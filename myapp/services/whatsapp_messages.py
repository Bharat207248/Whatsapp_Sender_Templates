from typing import Any
import mimetypes

from pathlib import Path
import requests
from django.conf import settings
from .meta_config import (
    get_meta_access_token,
    get_meta_graph_version,
    get_whatsapp_phone_number_id,
)

class WhatsAppMessageAPIError(Exception):
    """WhatsApp message request fail hone par use hoga."""
MEDIA_UPLOAD_RULES = {
    "IMAGE": {
        "extensions": {
            ".jpg",
            ".jpeg",
            ".png",
            ".webp",
        },
        "mime_types": {
            "image/jpeg",
            "image/png",
            "image/webp",
        },
        "max_size": 5 * 1024 * 1024,
        "display_name": "Image",
    },

    "VIDEO": {
        "extensions": {
            ".mp4",
            ".3gp",
        },
        "mime_types": {
            "video/mp4",
            "video/3gpp",
        },
        "max_size": 16 * 1024 * 1024,
        "display_name": "Video",
    },

    "DOCUMENT": {
        "extensions": {
            ".pdf",
            ".txt",
            ".doc",
            ".docx",
            ".xls",
            ".xlsx",
            ".ppt",
            ".pptx",
        },
        "mime_types": {
            "application/pdf",
            "text/plain",
            "application/msword",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            "application/vnd.ms-excel",
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            "application/vnd.ms-powerpoint",
            "application/vnd.openxmlformats-officedocument.presentationml.presentation",
        },
        "max_size": 100 * 1024 * 1024,
        "display_name": "Document",
    },
}
def upload_media_to_whatsapp(
    uploaded_file,
    expected_media_type: str,
) -> str:
    """
    Image, video ya document ko Meta WhatsApp
    media server par upload karta hai.

    Successful upload ke baad Media ID return karta hai.
    """

    access_token = settings.META_ACCESS_TOKEN

    phone_number_id = (
        settings.WHATSAPP_PHONE_NUMBER_ID
    )

    graph_version = (
        settings.META_GRAPH_VERSION
    )


    if not access_token:
        raise WhatsAppMessageAPIError(
            "Meta access token not found in settings."
        )


    if not phone_number_id:
        raise WhatsAppMessageAPIError(
            "WHATSAPP_PHONE_NUMBER_ID was not found in the settings."
        )


    content_type = validate_whatsapp_media_file(
        uploaded_file,
        expected_media_type,
    )


    url = (
        f"https://graph.facebook.com/"
        f"{graph_version}/"
        f"{phone_number_id}/media"
    )


    headers = {
        "Authorization": (
            f"Bearer {access_token}"
        ),
    }


    data = {
        "messaging_product": "whatsapp",
        "type": content_type,
    }


    try:
        uploaded_file.seek(0)

        files = {
            "file": (
                Path(uploaded_file.name).name,
                uploaded_file,
                content_type,
            )
        }


        response = requests.post(
            url,
            headers=headers,
            data=data,
            files=files,
            timeout=(10, 120),
        )


    except requests.Timeout as error:
        raise WhatsAppMessageAPIError(
            "Media upload timeout . "
            "Check the internet connection and file size ."
        ) from error


    except requests.ConnectionError as error:
        raise WhatsAppMessageAPIError(
            "Connection to the meta media server could not be established.. "
            "Check the internet connection."
        ) from error


    except requests.RequestException as error:
        raise WhatsAppMessageAPIError(
            f"Media upload request failed: {error}"
        ) from error


    try:
        response_data = response.json()

    except ValueError as error:
        raise WhatsAppMessageAPIError(
            "The Meta Media API did not provide a valid JSON response.."
        ) from error


    if not response.ok:
        meta_error = response_data.get(
            "error",
            {},
        )

        error_message = meta_error.get(
            "message",
            "Media upload failed.",
        )

        error_code = meta_error.get(
            "code"
        )

        error_details = (
            meta_error
            .get("error_data", {})
            .get("details")
        )


        complete_error = error_message

        if error_code:
            complete_error += (
                f" [Meta code: {error_code}]"
            )

        if error_details:
            complete_error += (
                f" — {error_details}"
            )


        raise WhatsAppMessageAPIError(
            complete_error
        )


    media_id = response_data.get("id")


    if not media_id:
        raise WhatsAppMessageAPIError(
            "No media response received from Meta.."
        )


    print(
        f"{expected_media_type.upper()} uploaded successfully. "
        f"Media ID received."
    )


    return media_id

def send_template_message(
    phone: str,
    template_name: str,
    language_code: str,
    components: list[dict[str, Any]] | None = None,
) -> dict[str, Any]:
    """
   It sends approved template messages via the WhatsApp Cloud API.
    """

    access_token = get_meta_access_token()

    phone_number_id = (
        get_whatsapp_phone_number_id()
    )

    graph_version = (
        get_meta_graph_version()
    )

    if not access_token:
        raise WhatsAppMessageAPIError(
            "META_ACCESS_TOKEN not found in the .env file ."
        )

    if not phone_number_id:
        raise WhatsAppMessageAPIError(
            "WHATSAPP_PHONE_NUMBER_ID not found in the .env file ."
        )

    # Phone number me sirf digits rehne denge.
    clean_phone = "".join(
        character
        for character in str(phone)
        if character.isdigit()
    )

    if not clean_phone:
        raise WhatsAppMessageAPIError(
            "invalid  customer phone number."
        )

    url = (
        f"https://graph.facebook.com/"
        f"{graph_version}/"
        f"{phone_number_id}/messages"
    )

    template_payload: dict[str, Any] = {
        "name": template_name,
        "language": {
            "code": language_code,
        },
    }

    if components:
        template_payload["components"] = components

    payload = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": clean_phone,
        "type": "template",
        "template": template_payload,
    }

    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json",
    }

    try:
        response = requests.post(
            url,
            headers=headers,
            json=payload,
            timeout=60,
        )

    except requests.Timeout as error:
        raise WhatsAppMessageAPIError(
            "WhatsApp API request timeout ."
        ) from error

    except requests.RequestException as error:
        raise WhatsAppMessageAPIError(
            f"WhatsApp API request failed: {error}"
        ) from error

    try:
        response_data = response.json()
    except ValueError as error:
        raise WhatsAppMessageAPIError(
            "The Meta API did not return a valid JSON response.."
        ) from error

    if not response.ok:

        meta_error = response_data.get(
            "error",
            {}
        )

        message = meta_error.get(
            "message",
            "WhatsApp message not send.",
        )

        error_details = (
            meta_error
            .get("error_data", {})
            .get("details")
        )

        if error_details:
            message = f"{message} — {error_details}"

        raise WhatsAppMessageAPIError(message)

    return response_data

def build_image_header_component() -> list[dict[str, Any]]:
    """
   A component is created for the image header template.
    The media ID will be referenced via the URL.
    """

    image_id = settings.WHATSAPP_HEADER_IMAGE_ID
    image_url = settings.WHATSAPP_HEADER_IMAGE_URL

    if image_id:

        return [
            {
                "type": "header",
                "parameters": [
                    {
                        "type": "image",
                        "image": {
                            "id": image_id,
                        },
                    }
                ],
            }
        ]

    if image_url:

        return [
            {
                "type": "header",
                "parameters": [
                    {
                        "type": "image",
                        "image": {
                            "link": image_url,
                        },
                    }
                ],
            }
        ]

    raise WhatsAppMessageAPIError(
       "The selected template has an image header, "
        "but WhatsApp_Header_Image_ID "
        "or WhatsApp_Header_Image_URL was not found in the .env file."
    )

def validate_whatsapp_media_file(
    uploaded_file,
    expected_media_type: str,
) -> str:
    """
    Validates the extension, MIME type, and size of the selected file.

    Returns the final MIME type if valid.
    """

    media_type = expected_media_type.upper()

    rules = MEDIA_UPLOAD_RULES.get(
        media_type
    )

    if not rules:
        raise WhatsAppMessageAPIError(
            f"Unsupported media type: {media_type}"
        )


    if not uploaded_file:
        raise WhatsAppMessageAPIError(
            f"{rules['display_name']} file select nahi ki gayi."
        )


    original_filename = Path(
        uploaded_file.name
    ).name

    extension = Path(
        original_filename
    ).suffix.lower()


    if extension not in rules["extensions"]:
        allowed_extensions = ", ".join(
            sorted(rules["extensions"])
        )

        raise WhatsAppMessageAPIError(
            f"{rules['display_name']} format not  supported. "
            f"Allowed formats: {allowed_extensions}"
        )


    file_size = uploaded_file.size or 0

    maximum_size = rules["max_size"]


    if file_size <= 0:
        raise WhatsAppMessageAPIError(
            "Selected file empty ."
        )


    if file_size > maximum_size:
        maximum_size_mb = round(
            maximum_size / (1024 * 1024)
        )

        actual_size_mb = round(
            file_size / (1024 * 1024),
            2,
        )

        raise WhatsAppMessageAPIError(
            f"{rules['display_name']} size "
            f"{actual_size_mb} MB hai. "
            f"Maximum allowed size "
            f"{maximum_size_mb} MB hai."
        )


    browser_content_type = (
        uploaded_file.content_type or ""
    ).lower()


    guessed_content_type = (
        mimetypes.guess_type(
            original_filename
        )[0]
        or ""
    ).lower()


    if browser_content_type in rules["mime_types"]:
        final_content_type = browser_content_type

    elif guessed_content_type in rules["mime_types"]:
        final_content_type = guessed_content_type

    else:
        raise WhatsAppMessageAPIError(
            f"{rules['display_name']}  name type "
            "not supported . "
            f"Received type: "
            f"{browser_content_type or 'unknown'}"
        )


    return final_content_type


def send_text_reply_to_whatsapp(
    phone: str,
    reply_text: str,
    reply_to_message_id: str | None = None,
) -> dict:
    """
    Sends a free-form WhatsApp text reply to the customer.

    If reply_to_message_id` is available,
    it replies to the customer's specific incoming message
    by including the quote or context.
    """

    access_token = get_meta_access_token()

    phone_number_id = (
    get_whatsapp_phone_number_id()
)

    graph_version = get_meta_graph_version()

    if not access_token:
        raise WhatsAppMessageAPIError(
            "META_ACCESS_TOKEN not found in the settings ."
        )


    if not phone_number_id:
        raise WhatsAppMessageAPIError(
            "WHATSAPP_PHONE_NUMBER_ID not found in the settings ."
        )


    clean_phone = "".join(
        character
        for character in str(phone)
        if character.isdigit()
    )


    if not clean_phone:
        raise WhatsAppMessageAPIError(
            "not valid customer phone number ."
        )


    clean_reply_text = str(
        reply_text
    ).strip()


    if not clean_reply_text:
        raise WhatsAppMessageAPIError(
            "can not be reply message ."
        )


    if len(clean_reply_text) > 4096:
        raise WhatsAppMessageAPIError(
            "Reply message is greater than 4096 characters."
        )


    url = (
        f"https://graph.facebook.com/"
        f"{graph_version}/"
        f"{phone_number_id}/messages"
    )


    headers = {
        "Authorization": (
            f"Bearer {access_token}"
        ),
        "Content-Type": "application/json",
    }


    payload = {
        "messaging_product": "whatsapp",
        "recipient_type": "individual",
        "to": clean_phone,
        "type": "text",
        "text": {
            "preview_url": False,
            "body": clean_reply_text,
        },
    }


    # Specific incoming message ko quote/reply karo.
    if reply_to_message_id:
        payload["context"] = {
            "message_id": reply_to_message_id,
        }


    try:
        response = requests.post(
            url,
            headers=headers,
            json=payload,
            timeout=(10, 30),
        )

    except requests.Timeout as error:
        raise WhatsAppMessageAPIError(
            "WhatsApp reply request failed."
        ) from error

    except requests.ConnectionError as error:
        raise WhatsAppMessageAPIError(
            "Connection to the Meta API failed. "
            "Check your internet connection ."
        ) from error

    except requests.RequestException as error:
        raise WhatsAppMessageAPIError(
            f"WhatsApp reply request failed: {error}"
        ) from error


    try:
        response_data = response.json()

    except ValueError as error:
        raise WhatsAppMessageAPIError(
            "The Meta API did not return a valid JSON response."
        ) from error


    if not response.ok:

        meta_error = response_data.get(
            "error",
            {},
        )

        error_message = meta_error.get(
            "message",
            "WhatsApp reply not sent.",
        )

        error_code = meta_error.get(
            "code"
        )

        error_details = (
            meta_error
            .get("error_data", {})
            .get("details")
        )


        if error_code:
            error_message += (
                f" [Meta code: {error_code}]"
            )

        if error_details:
            error_message += (
                f" — {error_details}"
            )


        raise WhatsAppMessageAPIError(
            error_message
        )


    messages_data = response_data.get(
        "messages",
        [],
    )


    if not messages_data:
        raise WhatsAppMessageAPIError(
            "WhatsApp message regarding Meta's response not received."
        )


    meta_message_id = messages_data[0].get(
        "id"
    )


    if not meta_message_id:
        raise WhatsAppMessageAPIError(
            "WhatsApp message ID not found in the Meta response."
        )


    return response_data