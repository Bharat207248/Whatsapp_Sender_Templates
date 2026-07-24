from django.db import models


class Customer(models.Model):
    name = models.CharField(max_length=100)

    phone = models.CharField(max_length=15,unique=True)

    city = models.CharField(max_length=100)

    pin_code = models.CharField(max_length=10)

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.name} - {self.phone}"


class MessageLog(models.Model):

    STATUS_CHOICES = [
        ("pending", "Pending"),
        ("accepted", "Accepted"),
        ("sent", "Sent"),
        ("delivered", "Delivered"),
        ("read", "Read"),
        ("failed", "Failed"),
    ]

    customer = models.ForeignKey(
        Customer,
        on_delete=models.CASCADE,
        related_name="message_logs",
    )

    template_name = models.CharField(
        max_length=150
    )

    template_language = models.CharField(
        max_length=20
    )

    meta_message_id = models.CharField(
        max_length=255,
        blank=True,
        null=True,
        unique=True,
    )

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default="pending",
    )

    error_message = models.TextField(
        blank=True
    )

    created_at = models.DateTimeField(
        auto_now_add=True
    )

    updated_at = models.DateTimeField(
        auto_now=True
    )

    def __str__(self):
        return (
            f"{self.customer.phone} - "
            f"{self.template_name} - "
            f"{self.status}"
        )

    sent_at = models.DateTimeField(
        null=True,
        blank=True,
    )

    delivered_at = models.DateTimeField(
        null=True,
        blank=True,
    )

    read_at = models.DateTimeField(
        null=True,
        blank=True,
    )

    failed_at = models.DateTimeField(
        null=True,
        blank=True,
    )

class CustomerReply(models.Model):

    customer = models.ForeignKey(
        Customer,
        on_delete=models.CASCADE,
        related_name="replies",
    )

    message_log = models.ForeignKey(
        MessageLog,
        on_delete=models.SET_NULL,
        related_name="replies",
        null=True,
        blank=True,
    )

    whatsapp_message_id = models.CharField(
        max_length=255,
        unique=True,
    )

    reply_type = models.CharField(
        max_length=50,
        default="text",
    )

    reply_text = models.TextField(
        blank=True,
    )

    received_at = models.DateTimeField(
        null=True,
        blank=True,
    )

    created_at = models.DateTimeField(
        auto_now_add=True,
    )

    def __str__(self):
        return (
            f"{self.customer.phone} - "
            f"{self.reply_text[:40]}"
        )
class OutgoingReply(models.Model):
    """
    Web panel se customer ko bheje gaye
    WhatsApp replies ko save karta hai.
    """

    STATUS_CHOICES = [
        ("pending", "Pending"),
        ("accepted", "Accepted"),
        ("sent", "Sent"),
        ("delivered", "Delivered"),
        ("read", "Read"),
        ("failed", "Failed"),
    ]

    customer = models.ForeignKey(
        Customer,
        on_delete=models.CASCADE,
        related_name="outgoing_replies",
    )

    # Kis incoming customer message ka reply hai.
    reply_to = models.ForeignKey(
        CustomerReply,
        on_delete=models.SET_NULL,
        related_name="business_replies",
        null=True,
        blank=True,
    )

    reply_text = models.TextField()

    # Meta se return hone wala wamid.
    meta_message_id = models.CharField(
        max_length=255,
        blank=True,
        db_index=True,
    )

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default="pending",
        db_index=True,
    )

    error_message = models.TextField(
        blank=True,
    )

    created_at = models.DateTimeField(
        auto_now_add=True,
    )

    sent_at = models.DateTimeField(
        null=True,
        blank=True,
    )

    delivered_at = models.DateTimeField(
        null=True,
        blank=True,
    )

    read_at = models.DateTimeField(
        null=True,
        blank=True,
    )

    failed_at = models.DateTimeField(
        null=True,
        blank=True,
    )

    class Meta:
        ordering = [
            "created_at",
            "id",
        ]

    def __str__(self):
        return (
            f"{self.customer.phone} - "
            f"{self.reply_text[:40]}"
        )