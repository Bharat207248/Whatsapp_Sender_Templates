import os
from pathlib import Path
from typing import Any

from django.conf import settings
from dotenv import dotenv_values


# .env ko har request par unnecessarily parse
# na karna pade, isliye modification time cache hoga.
_ENV_CACHE: dict[str, Any] = {
    "modified_time": None,
    "values": {},
}


def get_latest_env_values() -> dict[str, Any]:
    """
    .env file change hone par hi dobara read karta hai.

    Token update ke baad next API request par
    new value automatically mil jayegi.
    """

    env_path = Path(
        settings.BASE_DIR
    ) / ".env"


    if not env_path.exists():
        return {}


    try:
        modified_time = (
            env_path.stat().st_mtime_ns
        )

    except OSError:
        return {}


    if (
        _ENV_CACHE["modified_time"]
        != modified_time
    ):
        _ENV_CACHE["values"] = (
            dotenv_values(env_path)
        )

        _ENV_CACHE["modified_time"] = (
            modified_time
        )


    return _ENV_CACHE["values"]


def get_meta_access_token() -> str:
    """
    Latest META_ACCESS_TOKEN return karta hai.

    Priority:
    1. Current .env file
    2. System environment
    3. Existing Django settings
    """

    env_values = get_latest_env_values()


    token = (
        env_values.get(
            "META_ACCESS_TOKEN"
        )
        or os.getenv(
            "META_ACCESS_TOKEN"
        )
        or getattr(
            settings,
            "META_ACCESS_TOKEN",
            "",
        )
        or ""
    )


    return str(token).strip()


def get_whatsapp_waba_id() -> str:
    env_values = get_latest_env_values()

    value = (
        env_values.get(
            "WHATSAPP_WABA_ID"
        )
        or os.getenv(
            "WHATSAPP_WABA_ID"
        )
        or getattr(
            settings,
            "WHATSAPP_WABA_ID",
            "",
        )
        or ""
    )

    return str(value).strip()


def get_whatsapp_phone_number_id() -> str:
    env_values = get_latest_env_values()

    value = (
        env_values.get(
            "WHATSAPP_PHONE_NUMBER_ID"
        )
        or os.getenv(
            "WHATSAPP_PHONE_NUMBER_ID"
        )
        or getattr(
            settings,
            "WHATSAPP_PHONE_NUMBER_ID",
            "",
        )
        or ""
    )

    return str(value).strip()


def get_meta_graph_version() -> str:
    env_values = get_latest_env_values()

    value = (
        env_values.get(
            "META_GRAPH_VERSION"
        )
        or os.getenv(
            "META_GRAPH_VERSION"
        )
        or getattr(
            settings,
            "META_GRAPH_VERSION",
            "v25.0",
        )
        or "v25.0"
    )

    return str(value).strip()