from pathlib import Path

from django import forms

# from django.contrib.auth.forms import UserCreationForm
# from django.contrib.auth.models import User



# class SignUpForm(UserCreationForm):
#     first_name = forms.CharField(
#         max_length=150,
#         required=True,
#         widget=forms.TextInput(
#             attrs={
#                 "placeholder": "Enter first name",
#                 "autocomplete": "given-name",
#             }
#         ),
#     )

#     last_name = forms.CharField(
#         max_length=150,
#         required=True,
#         widget=forms.TextInput(
#             attrs={
#                 "placeholder": "Enter last name",
#                 "autocomplete": "family-name",
#             }
#         ),
#     )

#     email = forms.EmailField(
#         required=True,
#         widget=forms.EmailInput(
#             attrs={
#                 "placeholder": "Enter email address",
#                 "autocomplete": "email",
#             }
#         ),
#     )

#     class Meta:
#         model = User

#         fields = (
#             "first_name",
#             "last_name",
#             "username",
#             "email",
#             "password1",
#             "password2",
#         )

#         widgets = {
#             "username": forms.TextInput(
#                 attrs={
#                     "placeholder": "Choose username",
#                     "autocomplete": "username",
#                 }
#             ),
#         }

#     def clean_email(self):
#         email = (
#             self.cleaned_data
#             .get("email", "")
#             .strip()
#             .lower()
#         )

#         if User.objects.filter(
#             email__iexact=email
#         ).exists():
#             raise forms.ValidationError(
#                 "An account with this email already exists."
#             )

#         return email


class CustomerExcelUploadForm(forms.Form):
    excel_file = forms.FileField(
        label="Customer Excel File",
        widget=forms.ClearableFileInput(
            attrs={
                "accept": ".xlsx",
                "class": "excel-file-input",
            }
        ),
    )

    def clean_excel_file(self):
        uploaded_file = self.cleaned_data["excel_file"]

        extension = Path(uploaded_file.name).suffix.lower()

        if extension != ".xlsx":
            raise forms.ValidationError(
                "Only .xls Excel files can be uploaded."
            )

        maximum_size = 5 * 1024 * 1024

        if uploaded_file.size > maximum_size:
            raise forms.ValidationError(
                "The Excel file should be a maximum of 5 MB."
            )

        return uploaded_file