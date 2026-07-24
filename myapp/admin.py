from django.contrib import admin

from .models import Customer,MessageLog,CustomerReply,OutgoingReply


@admin.register(Customer)
class CustomerAdmin(admin.ModelAdmin):
    list_display = (
        "id",
        "phone",
        "name",
        "city",
        "pin_code",
        "created_at",
    )

    search_fields = (
        "phone",
        "name",
        "city",
        "pin_code",
    )

@admin.register(MessageLog)
class MessageLogAdmin(admin.ModelAdmin):

    list_display = (
        "id",
        "customer",
        "template_name",
        "template_language",
        "status",
        "meta_message_id",
        "created_at",
    )

    list_filter = (
        "status",
        "template_name",
        "template_language",
    )

    search_fields = (
        "customer__name",
        "customer__phone",
        "meta_message_id",
        "template_name",
    )

@admin.register(CustomerReply)
class CustomerReplyAdmin(admin.ModelAdmin):

    list_display = (
        "id",
        "customer",
        "message_log",
        "reply_type",
        "reply_text",
        "received_at",
    )

    search_fields = (
        "customer__name",
        "customer__phone",
        "reply_text",
        "whatsapp_message_id",
    )

    list_filter = (
        "reply_type",
        "received_at",
    )

@admin.register(OutgoingReply)
class OutgoingReplyAdmin(admin.ModelAdmin):

    list_display = (
        "id",
        "customer",
        "reply_text",
        "status",
        "meta_message_id",
        "created_at",
    )

    list_filter = (
        "status",
        "created_at",
    )

    search_fields = (
        "customer__name",
        "customer__phone",
        "reply_text",
        "meta_message_id",
    )

    readonly_fields = (
        "created_at",
        "sent_at",
        "delivered_at",
        "read_at",
        "failed_at",
    )