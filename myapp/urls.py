from django.urls import path
from django.contrib.auth import views as auth_views
from . import views
from .webhook_views import whatsapp_webhook


urlpatterns = [
        path(
        "login/",
        auth_views.LoginView.as_view(
            template_name="registration/login.html",
            redirect_authenticated_user=True,
        ),
        name="login",
    ),

    # path(
    #     "signup/",
    #     views.signup_view,
    #     name="signup",
    # ),

    path(
        "logout/",
        auth_views.LogoutView.as_view(),
        name="logout",
    ),
    path(
        "role-redirect/",
        views.role_redirect,
        name="role_redirect",
    ),

    path(
        "no-access/",
        views.no_access,
        name="no_access",
    ),
    path(
        "password-reset/",
        auth_views.PasswordResetView.as_view(
            template_name=(
                "registration/"
                "password_reset_form.html"
            ),
            email_template_name=(
                "registration/"
                "password_reset_email.html"
            ),
            subject_template_name=(
                "registration/"
                "password_reset_subject.txt"
            ),
        ),
        name="password_reset",
    ),

    path(
        "password-reset/done/",
        auth_views.PasswordResetDoneView.as_view(
            template_name=(
                "registration/"
                "password_reset_done.html"
            ),
        ),
        name="password_reset_done",
    ),

    path(
        "reset/<uidb64>/<token>/",
        auth_views.PasswordResetConfirmView.as_view(
            template_name=(
                "registration/"
                "password_reset_confirm.html"
            ),
        ),
        name="password_reset_confirm",
    ),

    path(
        "reset/complete/",
        auth_views.PasswordResetCompleteView.as_view(
            template_name=(
                "registration/"
                "password_reset_complete.html"
            ),
        ),
        name="password_reset_complete",
    ),
    path(
        "",
        views.home,
        name="home",
    ),

    path(
        "send-whatsapp/",
        views.send_whatsapp,
        name="send_whatsapp",
    ),

    path(
        "customer-report/",
        views.customer_report,
        name="customer_report",
    ),

    path(
        "webhook/whatsapp/",
        whatsapp_webhook,
        name="whatsapp_webhook",
    ),
    path(
    "message-inbox/",
    views.message_inbox,
    name="message_inbox",
),

    path(
        "customer-chat/<int:customer_id>/",
        views.customer_chat,
        name="customer_chat",
    ),

    path(
        "customer-chat/<int:customer_id>/send/",
        views.send_customer_reply,
        name="send_customer_reply",
    ),  
    path(
        "customers/import-excel/",
        views.import_customers_excel,
        name="import_customers_excel",
    ),         
]