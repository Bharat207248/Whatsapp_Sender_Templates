from functools import wraps

from django.contrib.auth.views import redirect_to_login
from django.shortcuts import redirect


WHATSAPP_SENDER_GROUP = "WhatsApp Templates Sender"
CUSTOMER_REPORT_GROUP = "Customer Report"


def group_required(*allowed_groups):
    """
    Access is allowed when:
    1. User is authenticated, and
    2. User is a superuser, or
    3. User belongs to one of the allowed groups.
    """

    def decorator(view_function):

        @wraps(view_function)
        def wrapped_view(request, *args, **kwargs):

            if not request.user.is_authenticated:
                return redirect_to_login(
                    request.get_full_path()
                )

            # Admin gets access to every protected page.
            if request.user.is_superuser:
                return view_function(
                    request,
                    *args,
                    **kwargs,
                )

            user_has_access = (
                request.user.groups
                .filter(name__in=allowed_groups)
                .exists()
            )

            if not user_has_access:
                return redirect("no_access")

            return view_function(
                request,
                *args,
                **kwargs,
            )

        return wrapped_view

    return decorator