import re

from django.contrib import messages
from django.contrib.auth import login
from django.contrib.auth.decorators import (
    login_not_required,
    login_required,
)
from .decorators import (
    CUSTOMER_REPORT_GROUP,
    WHATSAPP_SENDER_GROUP,
    group_required,
)
# from django.contrib.auth.decorators import login_required
from django.db import transaction
# from django.shortcuts import redirect
from django.views.decorators.http import require_POST

from openpyxl import load_workbook
from openpyxl.utils.exceptions import InvalidFileException

# from .forms import (
#     CustomerExcelUploadForm,
#     SignUpForm,
# )

from .forms import CustomerExcelUploadForm
from .models import Customer
from typing import Any
from pathlib import Path
from django.conf import settings
from datetime import timedelta
from django.http import JsonResponse
from django.db.models import Prefetch,Q



from django.contrib import messages
from django.core.cache import cache
from django.shortcuts import redirect, render
from django.shortcuts import (
    get_object_or_404,
    redirect,
    render,)
from django.utils import timezone
from django.views.decorators.http import require_POST
from .models import Customer, MessageLog,CustomerReply,OutgoingReply
from .services.whatsapp_messages import (
    WhatsAppMessageAPIError,
    send_template_message,
    send_text_reply_to_whatsapp,
    upload_media_to_whatsapp,
)
from .services.whatsapp_templates import (
    WhatsAppTemplateAPIError,
    get_approved_templates,
)

def get_customer_reply_window(
    customer,
):
    """
    Calculates the 24-hour reply window based on the customer's latest incoming message.
    """

    latest_incoming = (
        CustomerReply.objects
        .filter(customer=customer)
        .order_by(
            "-received_at",
            "-created_at",
            "-id",
        )
        .first()
    )


    if not latest_incoming:
        return {
            "is_open": False,
            "latest_incoming": None,
            "expires_at": None,
            "remaining_seconds": 0,
            "remaining_text": (
                "The customer's incoming message was not received."
            ),
        }


    incoming_time = (
        latest_incoming.received_at
        or latest_incoming.created_at
    )


    expires_at = (
        incoming_time
        + timedelta(hours=24)
    )


    current_time = timezone.now()

    is_open = current_time < expires_at


    if is_open:

        remaining_seconds = int(
            (
                expires_at
                - current_time
            ).total_seconds()
        )

        remaining_hours = (
            remaining_seconds // 3600
        )

        remaining_minutes = (
            remaining_seconds % 3600
        ) // 60

        remaining_text = (
            f"{remaining_hours}h "
            f"{remaining_minutes}m remaining"
        )

    else:

        remaining_seconds = 0

        remaining_text = (
            "24-hour reply window closed"
        )


    return {
        "is_open": is_open,
        "latest_incoming": latest_incoming,
        "expires_at": expires_at,
        "remaining_seconds": remaining_seconds,
        "remaining_text": remaining_text,
    }






def get_template_component(
    template: dict,
    component_type: str,
) -> dict | None:
    """
    The required component among the template components provides the funding.
    """

    for component in template.get("components", []):

        if (
            component.get("type", "").upper()
            == component_type.upper()
        ):
            return component

    return None


def get_home_context() -> dict:
    """
    Returns the customers and approved templates for the home page.
    """

    customers = Customer.objects.all().order_by("id")

    template_error = None

    approved_templates = cache.get(
        "approved_whatsapp_templates"
    )

    if approved_templates is None:

        try:
            approved_templates = get_approved_templates()

            cache.set(
                "approved_whatsapp_templates",
                approved_templates,
                300,
            )

        except WhatsAppTemplateAPIError as error:
            approved_templates = []
            template_error = str(error)

    return {
        "customers": customers,
        "approved_templates": approved_templates,
        "template_error": template_error,
    }


# @login_not_required
# def signup_view(request):
#     """
#     Creates a new Sea News Network user account.
#     """

#     if request.user.is_authenticated:
#         return redirect("home")

#     if request.method == "POST":
#         form = SignUpForm(
#             request.POST
#         )

#         if form.is_valid():
#             user = form.save()

#             login(
#                 request,
#                 user,
#             )

#             messages.success(
#                 request,
#                 "Your Sea News Network account was created successfully.",
#             )

#             return redirect("home")

#     else:
#         form = SignUpForm()

#     return render(
#         request,
#         "registration/signup.html",
#         {
#             "form": form,
#         },
#     )

@login_required
def role_redirect(request):
    """
    Login ke baad user ko uske assigned page par bhejta hai.
    """

    if request.user.is_superuser:
        return redirect("home")

    group_names = set(
        request.user.groups.values_list(
            "name",
            flat=True,
        )
    )

    if WHATSAPP_SENDER_GROUP in group_names:
        return redirect("home")

    if CUSTOMER_REPORT_GROUP in group_names:
        return redirect("customer_report")

    return redirect("no_access")

@login_required
def no_access(request):
    return render(
        request,
        "registration/no_access.html",
        status=403,
    )


@group_required(WHATSAPP_SENDER_GROUP)   
def home(request):
    return render(
        request,
        "messaging/index.html",
        get_home_context(),
    )


NUMBERED_VARIABLE_PATTERN = re.compile(
    r"\{\{\s*(\d+)\s*\}\}"
)

NAMED_VARIABLE_PATTERN = re.compile(
    r"\{\{\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*\}\}"
)


def get_variable_tokens(
    text: str,
) -> list[tuple[str, str]]:
    """
    Returns numbered and named variables from the text in order of occurrence.
    """

    matches: list[tuple[int, str, str]] = []

    for match in NUMBERED_VARIABLE_PATTERN.finditer(
        text or ""
    ):
        matches.append(
            (
                match.start(),
                "numbered",
                match.group(1),
            )
        )

    for match in NAMED_VARIABLE_PATTERN.finditer(
        text or ""
    ):
        matches.append(
            (
                match.start(),
                "named",
                match.group(1),
            )
        )

    matches.sort(key=lambda item: item[0])

    result: list[tuple[str, str]] = []
    seen: set[tuple[str, str]] = set()

    for _, variable_type, variable_name in matches:

        token = (
            variable_type,
            variable_name,
        )

        if token not in seen:
            result.append(token)
            seen.add(token)

    return result


def build_text_parameters(
    text: str,
    prefix: str,
    post_data,
) -> list[dict[str, Any]]:
    """
    Meta-parameters are created by taking the values ​​of the template's {{1}}, {{2}}, or named variables from the HTML form.
    """

    parameters: list[dict[str, Any]] = []

    # {{1}}, {{2}}, {{3}} jaise numbered variables
    numbered_variables = re.findall(
        r"\{\{\s*(\d+)\s*\}\}",
        text or "",
    )

    # Duplicate variables remove, order preserve
    numbered_variables = list(
        dict.fromkeys(numbered_variables)
    )

    for variable_number in numbered_variables:

        field_name = (
            f"{prefix}_var_{variable_number}"
        )

        value = post_data.get(
            field_name,
            "",
        ).strip()

        if not value:
            raise WhatsAppMessageAPIError(
                f"Variable {{{{{variable_number}}}}} "
                "fill the value ."
            )

        parameters.append(
            {
                "type": "text",
                "text": value,
            }
        )


    # {{customer_name}} jaise named variables
    named_variables = re.findall(
        r"\{\{\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*\}\}",
        text or "",
    )

    named_variables = list(
        dict.fromkeys(named_variables)
    )

    for variable_name in named_variables:

        field_name = (
            f"{prefix}_named_{variable_name}"
        )

        value = post_data.get(
            field_name,
            "",
        ).strip()

        if not value:
            raise WhatsAppMessageAPIError(
                f"Variable {{{{{variable_name}}}}} "
                "fill the value."
            )

        parameters.append(
            {
                "type": "text",
                "text": value,
                "parameter_name": variable_name,
            }
        )

    return parameters


def build_header_component(
    header,
    prefix,
    post_data,
    file_data,
):
    """
    Text, image, video, and document templates
    The WhatsApp API payload for the header is generated.
    """

    header_format = (
        header.get(
            "format",
            "TEXT",
        )
        .upper()
    )


    # =====================================
    # TEXT HEADER
    # =====================================

    if header_format == "TEXT":
        parameters = build_text_parameters(
            header.get("text", ""),
            prefix,
            post_data,
        )

        if not parameters:
            return None

        return {
            "type": "header",
            "parameters": parameters,
        }


    # =====================================
    # MEDIA HEADER
    # =====================================

    if header_format in {
        "IMAGE",
        "VIDEO",
        "DOCUMENT",
    }:
        # Carousel me document header supported nahi
        if (
            prefix.startswith("carousel_")
            and header_format == "DOCUMENT"
        ):
            raise WhatsAppMessageAPIError(
               "Document headers in carousel cards are not supported. Use an image or video."
            )


        file_field_name = (
            f"{prefix}_media_file"
        )

        uploaded_file = file_data.get(
            file_field_name
        )


        # User ne system se file select ki
        if uploaded_file:
            media_id = upload_media_to_whatsapp(
                uploaded_file,
                header_format,
            )

        # Existing Media ID ka optional fallback
        else:
            media_id = (
                post_data.get(
                    f"{prefix}_media_id",
                    "",
                )
                .strip()
            )


        # Existing default image Media ID fallback
        if (
            not media_id
            and header_format == "IMAGE"
        ):
            media_id = getattr(
                settings,
                "WHATSAPP_HEADER_IMAGE_ID",
                "",
            )


        if not media_id:
            raise WhatsAppMessageAPIError(
                f"{header_format} header ke liye "
                "Select the file."
            )


        media_parameter_type = (
            header_format.lower()
        )


        media_object = {
            "id": media_id,
        }


        # Document me original filename show hoga
        if (
            header_format == "DOCUMENT"
            and uploaded_file
        ):
            media_object["filename"] = (
                Path(uploaded_file.name).name
            )


        return {
            "type": "header",
            "parameters": [
                {
                    "type": media_parameter_type,
                    media_parameter_type:
                        media_object,
                }
            ],
        }


    raise WhatsAppMessageAPIError(
        f"{header_format} template header "
        "not supported ."
    )

def build_button_components(
    buttons_component: dict[str, Any],
    prefix: str,
    post_data,
) -> list[dict[str, Any]]:
    """
   Parameters are generated for dynamic URL buttons.
    There is no need to pass a component for static buttons.
    """

    result: list[dict[str, Any]] = []

    buttons = buttons_component.get(
        "buttons",
        [],
    )

    for button_index, button in enumerate(
        buttons
    ):

        button_type = button.get(
            "type",
            "",
        ).upper()

        if button_type != "URL":
            continue

        parameters = build_text_parameters(
            button.get("url", ""),
            f"{prefix}_button_{button_index}",
            post_data,
        )

        if not parameters:
            continue

        result.append(
            {
                "type": "button",
                "sub_type": "url",
                "index": str(button_index),
                "parameters": parameters,
            }
        )

    return result


def build_carousel_component(
    carousel: dict[str, Any],
    post_data,
    file_data,
) -> dict[str, Any]:
    """
   The payload for each card in the approved carousel is generated based on the card index/order.
    """

    cards_payload: list[dict[str, Any]] = []

    cards = carousel.get(
        "cards",
        [],
    )

    if not cards:

        raise WhatsAppMessageAPIError(
            "Cards not found in the carousel template.."
        )


    for card_index, card in enumerate(cards):

        card_components_payload: list[
            dict[str, Any]
        ] = []

        for component in card.get(
            "components",
            [],
        ):

            component_type = component.get(
                "type",
                "",
            ).upper()


            if component_type == "HEADER":

                header_payload = (
                    build_header_component(
                        component,
                        (
                            f"carousel_"
                            f"{card_index}_header"
                        ),
                        post_data,
                        file_data,
                    )
                )

                if header_payload:
                    card_components_payload.append(
                        header_payload
                    )


            elif component_type == "BODY":

                body_parameters = (
                    build_text_parameters(
                        component.get(
                            "text",
                            "",
                        ),
                        (
                            f"carousel_"
                            f"{card_index}_body"
                        ),
                        post_data,
                    )
                )

                if body_parameters:

                    card_components_payload.append(
                        {
                            "type": "body",
                            "parameters": (
                                body_parameters
                            ),
                        }
                    )


            elif component_type == "BUTTONS":

                button_components = (
                    build_button_components(
                        component,
                        f"carousel_{card_index}",
                        post_data,
                    )
                )

                card_components_payload.extend(
                    button_components
                )


        cards_payload.append(
            {
                "card_index": card_index,
                "components": (
                    card_components_payload
                ),
            }
        )


    return {
        "type": "carousel",
        "cards": cards_payload,
    }


def build_template_components(
    template: dict[str, Any],
    post_data,
    file_data,
) -> list[dict[str, Any]]:
    """
    By inspecting the selected and approved template, the correct meta-send payload components are generated.
    """

    payload_components: list[
        dict[str, Any]
    ] = []


    for component in template.get(
        "components",
        [],
    ):

        component_type = component.get(
            "type",
            "",
        ).upper()


        if component_type == "HEADER":

            header_payload = (
                build_header_component(
                    component,
                    "header",
                    post_data,
                    file_data,
                )
            )

            if header_payload:
                payload_components.append(
                    header_payload
                )


        elif component_type == "BODY":

            body_parameters = (
                build_text_parameters(
                    component.get(
                        "text",
                        "",
                    ),
                    "body",
                    post_data,
                )
            )

            if body_parameters:

                payload_components.append(
                    {
                        "type": "body",
                        "parameters": body_parameters,
                    }
                )


        elif component_type == "BUTTONS":

            payload_components.extend(
                build_button_components(
                    component,
                    "normal",
                    post_data,
                )
            )


        elif component_type == "CAROUSEL":

            payload_components.append(
                build_carousel_component(
                    component,
                    post_data,
                    file_data,
                )
            )


    return payload_components

@group_required(WHATSAPP_SENDER_GROUP)
def send_whatsapp(request):

    # Sirf POST request allow hogi
    if request.method != "POST":
        return redirect("home")


    # =====================================
    # FORM DATA
    # =====================================

    selected_customer_ids = request.POST.getlist(
        "customers"
    )

    selected_template_value = request.POST.get(
        "template",
        "",
    ).strip()


    # =====================================
    # CUSTOMER VALIDATION
    # =====================================

    if not selected_customer_ids:

        messages.error(
            request,
            "Select at least one customer..",
        )

        return redirect("home")


    # =====================================
    # TEMPLATE VALIDATION
    # =====================================

    if not selected_template_value:

        messages.error(
            request,
            "Select an approved WhatsApp template..",
        )

        return redirect("home")


    # Template dropdown value:
    # template_name|language_code

    try:

        template_name, language_code = (
            selected_template_value.split(
                "|",
                1,
            )
        )

        template_name = template_name.strip()
        language_code = language_code.strip()

    except ValueError:

        messages.error(
            request,
            "The format of the selected template is invalid..",
        )

        return redirect("home")


    # =====================================
    # FETCH APPROVED META TEMPLATES
    # =====================================

    try:

        approved_templates = (
            get_approved_templates()
        )

    except WhatsAppTemplateAPIError as error:

        messages.error(
            request,
            (
                "Template details not fetched: "
                f"{error}"
            ),
        )

        return redirect("home")


    # =====================================
    # FIND SELECTED TEMPLATE
    # =====================================

    selected_template = next(
        (
            template
            for template in approved_templates
            if (
                template.get("name")
                == template_name
                and template.get("language")
                == language_code
            )
        ),
        None,
    )


    if not selected_template:

        messages.error(
            request,
            (
               "Selected approved template"
                "not found in Meta API."
            ),
        )

        return redirect("home")


    # =====================================
    # BUILD TEMPLATE COMPONENTS
    # =====================================
    #
    # Yahin par:
    #
    # Text variables process honge
    # Image upload hogi
    # Video upload hogi
    # Document upload hoga
    # Carousel components banenge
    #
    # Ye customer loop se pehle hai,
    # isliye media sirf ek baar upload hogi.
    # =====================================

    try:

        message_components = (
            build_template_components(
                selected_template,
                request.POST,
                request.FILES,
            )
        )

    except WhatsAppMessageAPIError as error:

        messages.error(
            request,
            str(error),
        )

        return redirect("home")


    # =====================================
    # FETCH SELECTED CUSTOMERS
    # =====================================

    customers = Customer.objects.filter(
        id__in=selected_customer_ids
    ).order_by("id")


    if not customers.exists():

        messages.error(
            request,
            (
               "Selected customer records"
                "were not found in the database."
            ),
        )

        return redirect("home")


    # =====================================
    # COUNTERS
    # =====================================

    success_count = 0
    failed_count = 0
    failed_details = []


    # =====================================
    # SEND MESSAGE TO CUSTOMERS
    # =====================================

    for customer in customers:

        message_log = MessageLog.objects.create(
            customer=customer,
            template_name=template_name,
            template_language=language_code,
            status="pending",
        )


        try:

            response_data = send_template_message(
                phone=customer.phone,
                template_name=template_name,
                language_code=language_code,
                components=message_components,
            )


            # Meta message response
            response_messages = response_data.get(
                "messages",
                [],
            )


            meta_message_id = None


            if response_messages:

                meta_message_id = (
                    response_messages[0].get(
                        "id"
                    )
                )


            message_log.meta_message_id = (
                meta_message_id
            )


            # Meta API ne message request
            # accept kar li hai.
            #
            # sent, delivered, read aur failed
            # webhook ke through update honge.

            message_log.status = "accepted"

            message_log.save(
                update_fields=[
                    "meta_message_id",
                    "status",
                ]
            )


            success_count += 1


        except WhatsAppMessageAPIError as error:

            error_text = str(error)

            message_log.status = "failed"
            message_log.error_message = error_text

            message_log.save(
                update_fields=[
                    "status",
                    "error_message",
                ]
            )


            failed_count += 1

            failed_details.append(
                f"{customer.phone}: {error_text}"
            )


        except Exception as error:

            # Unexpected Python/Django error ko
            # bhi report table me save karega.

            error_text = (
                "Unexpected sending error: "
                f"{error}"
            )

            message_log.status = "failed"
            message_log.error_message = error_text

            message_log.save(
                update_fields=[
                    "status",
                    "error_message",
                ]
            )


            failed_count += 1

            failed_details.append(
                f"{customer.phone}: {error_text}"
            )


    # =====================================
    # SUCCESS MESSAGE
    # =====================================

    if success_count:

        messages.success(
            request,
            (
                f"{success_count} customer(s) accepted "
                "WhatsApp message Meta API ."
            
            ),
        )


    # =====================================
    # FAILED MESSAGE
    # =====================================

    if failed_count:

        short_error = " | ".join(
            failed_details[:3]
        )

        messages.warning(
            request,
            (
                f"{failed_count} message(s) failed. "
                f"{short_error}"
            ),
        )


    return redirect("home")
@group_required(CUSTOMER_REPORT_GROUP)
def customer_report(request):

    # =====================================
    # STATUS FILTER
    # =====================================

    active_filter = (
        request.GET
        .get("status", "all")
        .strip()
        .lower()
    )

    valid_filters = {
        "all",
        "accepted",
        "sent",
        "delivered",
        "read",
        "failed",
        "reply",
    }

    if active_filter not in valid_filters:
        active_filter = "all"


    # =====================================
    # CUSTOMER SEARCH
    # =====================================

    search_query = (
        request.GET
        .get("q", "")
        .strip()
    )


    # =====================================
    # LATEST CUSTOMER REPLIES
    # =====================================

    latest_replies = (
        CustomerReply.objects
        .order_by(
            "-received_at",
            "-id",
        )
    )


    # =====================================
    # BASE MESSAGE LOG QUERY
    # =====================================

    base_logs = (
        MessageLog.objects
        .select_related("customer")
        .prefetch_related(
            Prefetch(
                "replies",
                queryset=latest_replies,
                to_attr="reply_items",
            )
        )
        .order_by("-created_at")
    )


    # =====================================
    # SUMMARY CARD COUNTS
    # =====================================

    total_count = MessageLog.objects.count()

    accepted_count = (
        MessageLog.objects
        .filter(status="accepted")
        .count()
    )

    sent_count = (
        MessageLog.objects
        .filter(status="sent")
        .count()
    )

    delivered_count = (
        MessageLog.objects
        .filter(status="delivered")
        .count()
    )

    read_count = (
        MessageLog.objects
        .filter(status="read")
        .count()
    )

    failed_count = (
        MessageLog.objects
        .filter(status="failed")
        .count()
    )

    reply_count = (
        MessageLog.objects
        .filter(replies__isnull=False)
        .distinct()
        .count()
    )


    # =====================================
    # STATUS-WISE TABLE FILTER
    # =====================================

    message_logs = base_logs

    if active_filter in {
        "accepted",
        "sent",
        "delivered",
        "read",
        "failed",
    }:

        message_logs = message_logs.filter(
            status=active_filter
        )

    elif active_filter == "reply":

        message_logs = (
            message_logs
            .filter(replies__isnull=False)
            .distinct()
        )


    # =====================================
    # NAME OR PHONE SEARCH
    # =====================================

    if search_query:

        message_logs = message_logs.filter(
            Q(
                customer__name__icontains=search_query
            )
            |
            Q(
                customer__phone__icontains=search_query
            )
        )


    # Search ke baad kitne records mile
    filtered_count = message_logs.count()


    # =====================================
    # TEMPLATE CONTEXT
    # =====================================

    context = {
        "message_logs": message_logs,
        "active_filter": active_filter,
        "search_query": search_query,
        "filtered_count": filtered_count,

        "total_count": total_count,
        "accepted_count": accepted_count,
        "sent_count": sent_count,
        "delivered_count": delivered_count,
        "read_count": read_count,
        "failed_count": failed_count,
        "reply_count": reply_count,
    }

    return render(
        request,
        "messaging/customer_report.html",
        context,
    )

@group_required(CUSTOMER_REPORT_GROUP)
def message_inbox(request):
    """
   It displays the list of customers
 ​​   who have replied on WhatsApp.
    """

    customers = (
        Customer.objects
        .filter(replies__isnull=False)
        .distinct()
        .order_by("name", "phone")
    )


    inbox_items = []


    for customer in customers:

        latest_reply = (
            CustomerReply.objects
            .filter(customer=customer)
            .order_by(
                "-received_at",
                "-created_at",
                "-id",
            )
            .first()
        )


        latest_outgoing = (
            OutgoingReply.objects
            .filter(customer=customer)
            .order_by(
                "-created_at",
                "-id",
            )
            .first()
        )


        latest_message_time = None
        latest_message_text = ""
        latest_direction = "incoming"


        if latest_reply:

            latest_message_time = (
                latest_reply.received_at
                or latest_reply.created_at
            )

            latest_message_text = (
                latest_reply.reply_text
            )


        if latest_outgoing:

            outgoing_time = (
                latest_outgoing.created_at
            )

            if (
                latest_message_time is None
                or outgoing_time
                > latest_message_time
            ):
                latest_message_time = outgoing_time
                latest_message_text = (
                    latest_outgoing.reply_text
                )
                latest_direction = "outgoing"


        window_data = get_customer_reply_window(
            customer
        )


        inbox_items.append(
            {
                "customer": customer,
                "latest_message_text":
                    latest_message_text,
                "latest_message_time":
                    latest_message_time,
                "latest_direction":
                    latest_direction,
                "reply_window_open":
                    window_data["is_open"],
            }
        )


    inbox_items.sort(
        key=lambda item: (
            item["latest_message_time"]
            or timezone.now()
            - timedelta(days=36500)
        ),
        reverse=True,
    )


    return render(
        request,
        "messaging/message_inbox.html",
        {
            "inbox_items": inbox_items,
        },
    )
@group_required(CUSTOMER_REPORT_GROUP)
def customer_chat(
    request,
    customer_id,
):
    """
    It displays the complete incoming and outgoing conversation of a customer.
    """

    customer = get_object_or_404(
        Customer,
        id=customer_id,
    )


    incoming_messages = (
        CustomerReply.objects
        .filter(customer=customer)
        .order_by(
            "received_at",
            "created_at",
            "id",
        )
    )


    outgoing_messages = (
        OutgoingReply.objects
        .filter(customer=customer)
        .select_related("reply_to")
        .order_by(
            "created_at",
            "id",
        )
    )


    conversation = []


    for incoming in incoming_messages:

        message_time = (
            incoming.received_at
            or incoming.created_at
        )


        conversation.append(
            {
                "direction": "incoming",
                "db_id": incoming.id,
                "text": incoming.reply_text,
                "message_type":
                    incoming.reply_type,
                "meta_message_id":
                    incoming.whatsapp_message_id,
                "created_at": message_time,
                "status": "received",
                "reply_to_text": None,
            }
        )


    for outgoing in outgoing_messages:

        reply_to_text = None

        if outgoing.reply_to:
            reply_to_text = (
                outgoing.reply_to.reply_text
            )


        conversation.append(
            {
                "direction": "outgoing",
                "db_id": outgoing.id,
                "text": outgoing.reply_text,
                "message_type": "text",
                "meta_message_id":
                    outgoing.meta_message_id,
                "created_at":
                    outgoing.created_at,
                "status": outgoing.status,
                "reply_to_text":
                    reply_to_text,
                "error_message":
                    outgoing.error_message,
            }
        )


    conversation.sort(
        key=lambda item: (
            item["created_at"],
            item["db_id"],
        )
    )


    window_data = get_customer_reply_window(
        customer
    )


    return render(
        request,
        "messaging/customer_chat.html",
        {
            "customer": customer,
            "conversation": conversation,
            "reply_window_open":
                window_data["is_open"],
            "reply_window_text":
                window_data["remaining_text"],
            "reply_window_expires_at":
                window_data["expires_at"],
        },
    )

@group_required(CUSTOMER_REPORT_GROUP)
@require_POST
def send_customer_reply(
    request,
    customer_id,
):
    """
    It sends a WhatsApp text reply to the customer from the webpage.
    """

    customer = get_object_or_404(
        Customer,
        id=customer_id,
    )


    reply_text = request.POST.get(
        "reply_text",
        "",
    ).strip()


    reply_to_id = request.POST.get(
        "reply_to_id",
        "",
    ).strip()


    if not reply_text:

        return JsonResponse(
            {
                "success": False,
                "error": (
                    "The reply message cannot be empty.."
                ),
            },
            status=400,
        )


    if len(reply_text) > 4096:

        return JsonResponse(
            {
                "success": False,
                "error": (
                    "Reply maximum 4096 characters "
                    
                ),
            },
            status=400,
        )


    # =====================================
    # REPLY WINDOW CHECK
    # =====================================

    window_data = get_customer_reply_window(
        customer
    )


    if not window_data["is_open"]:

        return JsonResponse(
            {
                "success": False,
                "window_closed": True,
                "error": (
                   "The 24-hour customer reply window"
                    "has closed."
                    "Now, send an approved template."
                ),
            },
            status=400,
        )


    # =====================================
    # SELECTED INCOMING MESSAGE
    # =====================================

    selected_incoming_reply = None


    if reply_to_id:

        try:

            selected_incoming_reply = (
                CustomerReply.objects.get(
                    id=reply_to_id,
                    customer=customer,
                )
            )

        except (
            CustomerReply.DoesNotExist,
            ValueError,
        ):

            return JsonResponse(
                {
                    "success": False,
                    "error": (
                        "Not valide Selected customer message "
                        
                    ),
                },
                status=400,
            )


    # Specific reply select nahi kiya to latest
    # incoming message ko context me use karenge.

    if selected_incoming_reply is None:

        selected_incoming_reply = (
            window_data["latest_incoming"]
        )


    context_message_id = None


    if selected_incoming_reply:

        context_message_id = (
            selected_incoming_reply
            .whatsapp_message_id
        )


    # =====================================
    # PENDING DATABASE RECORD
    # =====================================

    outgoing_reply = (
        OutgoingReply.objects.create(
            customer=customer,
            reply_to=selected_incoming_reply,
            reply_text=reply_text,
            status="pending",
        )
    )


    try:

        response_data = (
            send_text_reply_to_whatsapp(
                phone=customer.phone,
                reply_text=reply_text,
                reply_to_message_id=(
                    context_message_id
                ),
            )
        )


        response_messages = (
            response_data.get(
                "messages",
                [],
            )
        )


        meta_message_id = None


        if response_messages:

            meta_message_id = (
                response_messages[0].get(
                    "id"
                )
            )


        outgoing_reply.meta_message_id = (
            meta_message_id or ""
        )

        outgoing_reply.status = "accepted"

        outgoing_reply.error_message = ""

        outgoing_reply.save(
            update_fields=[
                "meta_message_id",
                "status",
                "error_message",
            ]
        )


    except WhatsAppMessageAPIError as error:

        error_text = str(error)

        outgoing_reply.status = "failed"
        outgoing_reply.error_message = (
            error_text
        )

        outgoing_reply.failed_at = (
            timezone.now()
        )

        outgoing_reply.save(
            update_fields=[
                "status",
                "error_message",
                "failed_at",
            ]
        )


        return JsonResponse(
            {
                "success": False,
                "error": error_text,
            },
            status=400,
        )


    current_local_time = timezone.localtime(
        outgoing_reply.created_at
    )


    return JsonResponse(
        {
            "success": True,
            "message": (
                "Meta API accpect reply."
            ),
            "outgoing_reply": {
                "id": outgoing_reply.id,
                "text":
                    outgoing_reply.reply_text,
                "status":
                    outgoing_reply.status,
                "meta_message_id":
                    outgoing_reply.meta_message_id,
                "created_at":
                    current_local_time.strftime(
                        "%d %b %Y, %I:%M %p"
                    ),
                "reply_to_text": (
                    selected_incoming_reply.reply_text
                    if selected_incoming_reply
                    else ""
                ),
            },
        },
        status=200,
    )


HEADER_ALIASES = {
    "name": {
        "name",
        "customer name",
        "customer",
        "full name",
    },
    "phone": {
        "phone",
        "phone number",
        "mobile",
        "mobile number",
        "whatsapp number",
        "contact number",
    },
    "city": {
        "city",
        "customer city",
    },
    "pin_code": {
        "pin",
        "pin code",
        "pincode",
        "postal code",
        "zip code",
    },
}


def normalize_excel_header(value):
    """
    Example:
    'Mobile Number' -> 'mobile number'
    'PIN_Code'      -> 'pin code'
    """
    if value is None:
        return ""

    value = str(value).lower().strip()
    value = re.sub(r"[^a-z0-9]+", " ", value)

    return re.sub(r"\s+", " ", value).strip()


def clean_excel_text(value):
    """
    Excel numeric values such as 207001.0 ko
    clean string '207001' me convert karta hai.
    """
    if value is None:
        return ""

    if isinstance(value, float) and value.is_integer():
        return str(int(value))

    return str(value).strip()


def normalize_customer_phone(value):
    """
    Phone number se spaces, + aur hyphen remove karta hai.
    10 digit Indian number me 91 add karta hai.
    """
    phone = clean_excel_text(value)

    digits = re.sub(r"\D", "", phone)

    if not digits:
        raise ValueError("Phone number is empty .")

    # Example: 09759998032
    if len(digits) == 11 and digits.startswith("0"):
        digits = digits[1:]

    # Example: 9759998032 -> 919759998032
    if len(digits) == 10:
        digits = f"91{digits}"

    if len(digits) < 11 or len(digits) > 15:
        raise ValueError(
            "The phone number must be between 11 and 15 digits long.."
        )

    return digits

@group_required(WHATSAPP_SENDER_GROUP)
@login_required
@require_POST
def import_customers_excel(request):
    form = CustomerExcelUploadForm(
        request.POST,
        request.FILES,
    )

    if not form.is_valid():
        error_message = " ".join(
            error
            for errors in form.errors.values()
            for error in errors
        )

        messages.error(request, error_message)
        return redirect("home")

    excel_file = form.cleaned_data["excel_file"]
    workbook = None

    try:
        excel_file.seek(0)

        workbook = load_workbook(
            excel_file,
            read_only=True,
            data_only=True,
        )

        # Customers sheet mile to wahi read hogi.
        # Nahi mili to active sheet read hogi.
        if "Customers" in workbook.sheetnames:
            worksheet = workbook["Customers"]
        else:
            worksheet = workbook.active

        # max_row use nahi kar rahe, kyunki woh None aa sakta hai.
        rows_iterator = worksheet.iter_rows(values_only=True)

        try:
            header_row = next(rows_iterator)
        except StopIteration:
            messages.error(
                request,
                "Excel file completely empty.",
            )
            return redirect("home")

        normalized_headers = [
            normalize_excel_header(header)
            for header in header_row
        ]

        column_map = {}

        for field_name, possible_headers in HEADER_ALIASES.items():
            for column_index, header in enumerate(
                normalized_headers
            ):
                if header in possible_headers:
                    column_map[field_name] = column_index
                    break

        if "phone" not in column_map:
            messages.error(
                request,
                (
                    "Phone, mobile, or mobile number column not found in the Excel file."
                ),
            )
            return redirect("home")

        # Pehle saari non-empty rows collect karenge.
        data_rows = []

        for row_number, row in enumerate(
            rows_iterator,
            start=2,
        ):
            is_empty_row = not any(
                value is not None and str(value).strip()
                for value in row
            )

            if is_empty_row:
                continue

            data_rows.append(
                (row_number, row)
            )

            if len(data_rows) > 10000:
                messages.error(
                    request,
                    (
                       "Upload a maximum of 10,000 customer records in an Excel file."
                    ),
                )
                return redirect("home")

        if not data_rows:
            messages.error(
                request,
                "There are no customer records in the Excel file.",
            )
            return redirect("home")

        created_count = 0
        updated_count = 0
        skipped_count = 0
        row_errors = []

        def get_column_value(row, field_name):
            column_index = column_map.get(field_name)

            if column_index is None:
                return None

            if column_index >= len(row):
                return None

            return row[column_index]

        for row_number, row in data_rows:
            try:
                phone = normalize_customer_phone(
                    get_column_value(row, "phone")
                )

                name = clean_excel_text(
                    get_column_value(row, "name")
                )

                city = clean_excel_text(
                    get_column_value(row, "city")
                )

                pin_code = clean_excel_text(
                    get_column_value(row, "pin_code")
                )

                # Name blank hua to phone ko name bana denge.
                if not name:
                    name = phone

                # Har customer row alag transaction me save hogi.
                with transaction.atomic():
                    existing_customer = (
                        Customer.objects
                        .filter(phone=phone)
                        .first()
                    )

                    if existing_customer:
                        existing_customer.name = name
                        existing_customer.city = city
                        existing_customer.pin_code = pin_code

                        existing_customer.save(
                            update_fields=[
                                "name",
                                "city",
                                "pin_code",
                            ]
                        )

                        updated_count += 1

                    else:
                        Customer.objects.create(
                            name=name,
                            phone=phone,
                            city=city,
                            pin_code=pin_code,
                        )

                        created_count += 1

            except Exception as row_error:
                skipped_count += 1

                # Sirf first 10 errors screen par show karenge.
                if len(row_errors) < 10:
                    row_errors.append(
                        f"Row {row_number}: {row_error}"
                    )

        messages.success(
            request,
            (
                f"Excel import complete: "
                f"{created_count} new customers created, "
                f"{updated_count} existing customers updated, "
                f"{skipped_count} records skipped."
            ),
        )

        if row_errors:
            messages.warning(
                request,
                " | ".join(row_errors),
            )

    except InvalidFileException:
        messages.error(
            request,
            (
               "The Excel file is not valid."
                "Please upload a proper .xlsx file."
            ),
        )

    except Exception as error:
        messages.error(
            request,
            f"Excel import failed.: {error}",
        )

    finally:
        if workbook is not None:
            workbook.close()

    return redirect("home")