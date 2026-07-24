import json
from datetime import datetime
from datetime import timezone as datetime_timezone
from django.contrib.auth.decorators import login_not_required
from django.conf import settings
from django.http import (
    HttpResponse,
    HttpResponseBadRequest,
    HttpResponseForbidden,
    JsonResponse,
)
from django.db import transaction
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt

from .models import (
    Customer,
    CustomerReply,
    MessageLog,
    OutgoingReply,
)


STATUS_PRIORITY = {
    "pending": 0,
    "accepted": 1,
    "sent": 2,
    "delivered": 3,
    "read": 4,
}


def convert_whatsapp_timestamp(
    timestamp_value,
):
    """
    Meta Unix timestamp ko Django-aware datetime
    me convert karta hai.
    """

    if not timestamp_value:
        return None

    try:
        return datetime.fromtimestamp(
            int(timestamp_value),
            tz=datetime_timezone.utc,
        )

    except (TypeError, ValueError, OverflowError):
        return None


def get_status_error(
    status_data: dict,
) -> str:
    """
    Failed webhook ke error details read karta hai.
    """

    errors = status_data.get(
        "errors",
        [],
    )

    if not errors:
        return ""

    first_error = errors[0]

    error_message = first_error.get(
        "message",
        "",
    )

    error_details = (
        first_error
        .get("error_data", {})
        .get("details", "")
    )

    if error_message and error_details:
        return f"{error_message} — {error_details}"

    return error_details or error_message


def _update_status_record(
    model_class,
    message_id,
    status_value,
    event_time,
    error_message,
    default_failure_message,
):
    """
    MessageLog ya OutgoingReply ko safely update karta hai.

    select_for_update() concurrent webhook requests ko serialize
    karta hai, aur priority check read status ko delivered/sent
    se overwrite hone se bachata hai.
    """

    with transaction.atomic():
        record = (
            model_class.objects
            .select_for_update()
            .filter(meta_message_id=message_id)
            .first()
        )

        if not record:
            print(
                f"STATUS RECORD NOT FOUND: "
                f"{model_class.__name__} | {message_id}"
            )
            return

        current_status = (
            getattr(record, "status", "")
            or "pending"
        ).lower().strip()

        current_priority = STATUS_PRIORITY.get(
            current_status,
            -1,
        )

        new_priority = STATUS_PRIORITY.get(
            status_value,
            -1,
        )

        update_fields = []

        # Timestamp field ko save karo, lekin existing timestamp ko
        # delayed duplicate webhook se overwrite mat karo.
        timestamp_field = {
            "sent": "sent_at",
            "delivered": "delivered_at",
            "read": "read_at",
            "failed": "failed_at",
        }.get(status_value)

        if (
            timestamp_field
            and hasattr(record, timestamp_field)
            and getattr(record, timestamp_field, None) is None
        ):
            setattr(
                record,
                timestamp_field,
                event_time,
            )
            update_fields.append(timestamp_field)

        should_update_status = False

        if status_value == "failed":
            # Delivered/read message ko delayed failed event se
            # overwrite nahi karna chahiye.
            should_update_status = current_status not in {
                "delivered",
                "read",
            }

            if should_update_status:
                record.error_message = (
                    error_message
                    or default_failure_message
                )
                update_fields.append("error_message")

        elif current_status != "failed":
            # sent -> delivered -> read progression only.
            should_update_status = (
                new_priority > current_priority
            )

        if should_update_status:
            record.status = status_value
            update_fields.append("status")

        # Duplicate field names hata do.
        update_fields = list(dict.fromkeys(update_fields))

        if update_fields:
            record.save(update_fields=update_fields)

        print(
            "STATUS RESULT:",
            model_class.__name__,
            message_id,
            f"{current_status} -> {status_value}",
            "saved fields:",
            update_fields or "none",
        )


def update_message_status(
    status_data,
):
    """
    Template MessageLog aur webpage OutgoingReply
    dono ka webhook status safely update karta hai.
    """

    message_id = status_data.get("id")

    status_value = (
        status_data.get("status", "")
        .lower()
        .strip()
    )

    timestamp_value = status_data.get("timestamp")

    print(
        "STATUS WEBHOOK:",
        message_id,
        status_value,
        timestamp_value,
    )

    if not message_id:
        print("STATUS SKIPPED: message id missing")
        return

    valid_statuses = {
        "sent",
        "delivered",
        "read",
        "failed",
    }

    if status_value not in valid_statuses:
        print(
            "STATUS SKIPPED: unsupported status",
            status_value,
        )
        return

    event_time = convert_whatsapp_timestamp(
        timestamp_value
    )

    if event_time is None:
        event_time = timezone.now()

    error_message = get_status_error(
        status_data
    )

    _update_status_record(
        model_class=MessageLog,
        message_id=message_id,
        status_value=status_value,
        event_time=event_time,
        error_message=error_message,
        default_failure_message=(
            "WhatsApp delivery failed."
        ),
    )

    _update_status_record(
        model_class=OutgoingReply,
        message_id=message_id,
        status_value=status_value,
        event_time=event_time,
        error_message=error_message,
        default_failure_message=(
            "WhatsApp reply delivery failed."
        ),
    )

def extract_reply_text(
    incoming_message: dict,
) -> tuple[str, str]:
    """
    Text, quick reply button aur interactive
    reply se readable text nikalta hai.
    """

    message_type = incoming_message.get(
        "type",
        "unknown",
    )

    if message_type == "text":

        text = (
            incoming_message
            .get("text", {})
            .get("body", "")
        )

        return message_type, text


    if message_type == "button":

        button = incoming_message.get(
            "button",
            {},
        )

        text = (
            button.get("text")
            or button.get("payload")
            or "Button reply"
        )

        return message_type, text


    if message_type == "interactive":

        interactive = incoming_message.get(
            "interactive",
            {},
        )

        interactive_type = interactive.get(
            "type",
            "",
        )

        if interactive_type == "button_reply":

            button_reply = interactive.get(
                "button_reply",
                {},
            )

            text = (
                button_reply.get("title")
                or button_reply.get("id")
                or "Button reply"
            )

            return "button_reply", text


        if interactive_type == "list_reply":

            list_reply = interactive.get(
                "list_reply",
                {},
            )

            text = (
                list_reply.get("title")
                or list_reply.get("id")
                or "List reply"
            )

            return "list_reply", text


    if message_type == "image":

        caption = (
            incoming_message
            .get("image", {})
            .get("caption", "")
        )

        return "image", caption or "[Image received]"


    if message_type == "video":

        caption = (
            incoming_message
            .get("video", {})
            .get("caption", "")
        )

        return "video", caption or "[Video received]"


    if message_type == "document":

        document = incoming_message.get(
            "document",
            {},
        )

        filename = document.get(
            "filename",
            "",
        )

        return (
            "document",
            filename or "[Document received]",
        )


    if message_type == "audio":

        return "audio", "[Audio received]"


    if message_type == "location":

        return "location", "[Location received]"


    return message_type, f"[{message_type} received]"


def save_customer_reply(
    incoming_message: dict,
    contacts: list,
):
    """
    Customer ke incoming WhatsApp reply ko
    MySQL me save karta hai.
    """

    from_number = incoming_message.get(
        "from",
        "",
    )

    clean_phone = "".join(
        character
        for character in str(from_number)
        if character.isdigit()
    )

    if not clean_phone:
        return

    contact_name = ""

    if contacts:

        contact_name = (
            contacts[0]
            .get("profile", {})
            .get("name", "")
        )

    customer, created = Customer.objects.get_or_create(
        phone=clean_phone,
        defaults={
            "name": contact_name or clean_phone,
            "city": "",
            "pin_code": "",
        },
    )

    # Existing unknown name ko update kar sakte hain.
    if (
        contact_name
        and customer.name in {
            "",
            customer.phone,
        }
    ):
        customer.name = contact_name
        customer.save(update_fields=["name"])

    context_message_id = (
        incoming_message
        .get("context", {})
        .get("id")
    )

    related_message_log = None

    if context_message_id:

        related_message_log = (
            MessageLog.objects.filter(
                meta_message_id=context_message_id
            ).first()
        )

    # Context ID na mile to is customer ka latest message log.
    if not related_message_log:

        related_message_log = (
            MessageLog.objects.filter(
                customer=customer
            )
            .order_by("-created_at")
            .first()
        )

    reply_type, reply_text = extract_reply_text(
        incoming_message
    )

    inbound_message_id = incoming_message.get(
        "id"
    )

    if not inbound_message_id:
        return

    CustomerReply.objects.update_or_create(
        whatsapp_message_id=inbound_message_id,
        defaults={
            "customer": customer,
            "message_log": related_message_log,
            "reply_type": reply_type,
            "reply_text": reply_text,
            "received_at": convert_whatsapp_timestamp(
                incoming_message.get("timestamp")
            ),
        },
    )

@login_not_required
@csrf_exempt
def whatsapp_webhook(request):
    """
    GET request:
    Meta webhook verification.

    POST request:
    Message statuses aur customer replies.
    """

    # =====================================
    # META WEBHOOK VERIFICATION
    # =====================================

    if request.method == "GET":

        mode = request.GET.get("hub.mode")

        verify_token = request.GET.get(
            "hub.verify_token"
        )

        challenge = request.GET.get(
            "hub.challenge"
        )

        print("Webhook verification request:")
        print("Mode:", mode)
        print("Token matched:", (
            verify_token
            == settings.WHATSAPP_VERIFY_TOKEN
        ))
        print("Challenge:", challenge)

        if (
            mode == "subscribe"
            and verify_token
            == settings.WHATSAPP_VERIFY_TOKEN
            and challenge
        ):
            return HttpResponse(
                challenge,
                status=200,
                content_type="text/plain",
            )

        return HttpResponseForbidden(
            "Webhook verify token invalid ."
        )


    # =====================================
    # WEBHOOK EVENTS
    # =====================================

    if request.method == "POST":

        try:
            payload = json.loads(
                request.body.decode("utf-8")
            )

        except (
            json.JSONDecodeError,
            UnicodeDecodeError,
        ):
            return HttpResponseBadRequest(
                "Invalid JSON payload."
            )

        print(
            "WHATSAPP WEBHOOK:",
            json.dumps(
                payload,
                indent=2,
                ensure_ascii=False,
            ),
        )

        for entry in payload.get("entry", []):

            for change in entry.get(
                "changes",
                [],
            ):

                if change.get("field") != "messages":
                    continue

                value = change.get(
                    "value",
                    {},
                )

                # Sent, delivered, read, failed
                for status_data in value.get(
                    "statuses",
                    [],
                ):
                    print(
                        "STATUS WEBHOOK LOOP:",
                        status_data.get("id"),
                        status_data.get("status"),
                        status_data.get("timestamp"),
                    )

                    update_message_status(
                        status_data
                    )

                # Customer replies
                contacts = value.get(
                    "contacts",
                    [],
                )

                for incoming_message in value.get(
                    "messages",
                    [],
                ):
                    save_customer_reply(
                        incoming_message,
                        contacts,
                    )

        return JsonResponse(
            {
                "status": "received",
            },
            status=200,
        )


    return HttpResponse(
        "Method not allowed",
        status=405,
    )