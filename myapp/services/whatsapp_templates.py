from typing import Any

import requests

from django.conf import settings
from django.core.cache import cache

from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

import hashlib

from .meta_config import (
    get_meta_access_token,
    get_meta_graph_version,
    get_whatsapp_waba_id,
)

class WhatsAppTemplateAPIError(Exception):
    """It will occur if the meta-template API request fails.."""


def get_approved_templates() -> list[dict[str, Any]]:
    """
   WhatsApp Business Account se approved templates
    fetches.

    Performance improvements:
    1. Templates will remain in cache for 5 minutes.
    2. In case of network failure, the last successful cache will be used.
    3. There will be automatic retry on temporary meta errors.
    4. Session connection will be reused.
    """

    # =====================================
    # META SETTINGS
    # =====================================

    access_token = get_meta_access_token()

    waba_id = get_whatsapp_waba_id()

    graph_version = get_meta_graph_version()


    if not access_token:
        raise WhatsAppTemplateAPIError(
            "META_ACCESS_TOKEN not found in the .env file ."
        )


    if not waba_id:
        raise WhatsAppTemplateAPIError(
            "WHATSAPP_WABA_ID not found in the .env file."
        )


    # =====================================
    # CACHE KEYS
    # =====================================
    token_fingerprint = hashlib.sha256(
        access_token.encode("utf-8")
    ).hexdigest()[:12]
    
    cache_key = (
    f"approved_whatsapp_templates:"
    f"{graph_version}:"
    f"{waba_id}:"
    f"{token_fingerprint}"
)

    stale_cache_key = (
        f"{cache_key}:stale"
    )


    # =====================================
    # FRESH CACHE CHECK
    # =====================================
    #
    # Agar templates pichhle 5 minutes me
    # fetch hui hain, to Meta API call nahi hogi.
    # =====================================

    cached_templates = cache.get(
        cache_key
    )


    if cached_templates is not None:
        return cached_templates


    # =====================================
    # META API URL
    # =====================================

    url = (
        f"https://graph.facebook.com/"
        f"{graph_version}/"
        f"{waba_id}/message_templates"
    )

    headers = {
        "Authorization": (
            f"Bearer {access_token}"
        ),
    }

    params = {
        "fields": (
            "id,name,status,language,"
            "category,components"
        ),
        "limit": 100,
    }


    approved_templates: list[
        dict[str, Any]
    ] = []


    # =====================================
    # AUTOMATIC RETRY SETTINGS
    # =====================================
    #
    # Sirf GET request retry hogi.
    #
    # Retry cases:
    # 429 = rate limit
    # 500 = server error
    # 502 = bad gateway
    # 503 = unavailable
    # 504 = gateway timeout
    # =====================================

    retry_strategy = Retry(
        total=2,
        connect=2,
        read=2,
        status=2,
        backoff_factor=0.5,
        status_forcelist=(
            429,
            500,
            502,
            503,
            504,
        ),
        allowed_methods=frozenset(
            {"GET"}
        ),
        respect_retry_after_header=True,
        raise_on_status=False,
    )


    adapter = HTTPAdapter(
        max_retries=retry_strategy,
        pool_connections=5,
        pool_maxsize=5,
    )


    # =====================================
    # META REQUEST SESSION
    # =====================================

    with requests.Session() as session:

        session.mount(
            "https://",
            adapter,
        )

        session.headers.update(
            headers
        )


        # Meta response paginated ho sakta hai.
        while url:

            try:

                response = session.get(
                    url,
                    params=params,

                    # 5 seconds connection ke liye
                    # 30 seconds response ke liye
                    timeout=(5, 30),
                )


                response.raise_for_status()


            # =================================
            # NETWORK / TIMEOUT FALLBACK
            # =================================

            except (
                requests.Timeout,
                requests.ConnectionError,
            ) as error:

                stale_templates = cache.get(
                    stale_cache_key
                )


                # Last successful templates available
                # hain to wahi return kar denge.
                if stale_templates is not None:
                    return stale_templates


                raise WhatsAppTemplateAPIError(
                   "Could not connect to the Meta API."
                    "Check your internet connection."
                ) from error


            # =================================
            # META API ERROR
            # =================================

            except requests.RequestException as error:

                response_status = None

                if error.response is not None:
                    response_status = (
                        error.response.status_code
                    )


                # Meta ka temporary server error ho
                # to old cached templates use karo.
                if (
                    response_status is not None
                    and response_status >= 500
                ):

                    stale_templates = cache.get(
                        stale_cache_key
                    )

                    if stale_templates is not None:
                        return stale_templates


                error_message = (
                    "Failed to fetch templates from Meta API."
                )


                if error.response is not None:

                    try:

                        meta_payload = (
                            error.response.json()
                        )

                        meta_error = (
                            meta_payload.get(
                                "error",
                                {},
                            )
                        )

                        error_message = (
                            meta_error.get(
                                "message",
                                error_message,
                            )
                        )


                        meta_error_code = (
                            meta_error.get("code")
                        )


                        if meta_error_code:

                            error_message = (
                                f"{error_message} "
                                f"[Meta code: "
                                f"{meta_error_code}]"
                            )


                    except ValueError:
                        pass


                raise WhatsAppTemplateAPIError(
                    error_message
                ) from error


            # =================================
            # RESPONSE JSON
            # =================================

            try:

                payload = response.json()

            except ValueError as error:

                stale_templates = cache.get(
                    stale_cache_key
                )


                if stale_templates is not None:
                    return stale_templates


                raise WhatsAppTemplateAPIError(
                    "Meta API ne valid JSON "
                    "response nahi diya."
                ) from error


            templates = payload.get(
                "data",
                [],
            )


            # =================================
            # APPROVED TEMPLATES FILTER
            # =================================

            for template in templates:

                if (
                    template.get("status")
                    != "APPROVED"
                ):
                    continue


                approved_templates.append(
                    {
                        "id": template.get(
                            "id"
                        ),

                        "name": template.get(
                            "name"
                        ),

                        "language": template.get(
                            "language"
                        ),

                        "category": template.get(
                            "category"
                        ),

                        "status": template.get(
                            "status"
                        ),

                        "components": template.get(
                            "components",
                            [],
                        ),
                    }
                )


            # =================================
            # NEXT PAGE
            # =================================

            url = (
                payload
                .get("paging", {})
                .get("next")
            )


            # Paging next URL me query parameters
            # already included hote hain.
            params = None


    # =====================================
    # SORT TEMPLATES
    # =====================================

    approved_templates.sort(
        key=lambda item: (
            item.get("name", ""),
            item.get("language", ""),
        )
    )


    # =====================================
    # CACHE SAVE
    # =====================================

    # Fresh cache:
    # 5 minutes tak Meta API call nahi hogi.

    cache.set(
        cache_key,
        approved_templates,
        timeout=300,
    )


    # Backup/stale cache:
    # Network fail hone par 1 hour tak
    # last successful templates use hongi.

    cache.set(
        stale_cache_key,
        approved_templates,
        timeout=3600,
    )


    return approved_templates