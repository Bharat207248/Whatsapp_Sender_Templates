document.addEventListener(
    "DOMContentLoaded",
    function () {

        const chatMessages =
            document.getElementById(
                "chat-messages"
            );

        const replyForm =
            document.getElementById(
                "customer-reply-form"
            );

        const replyTextInput =
            document.getElementById(
                "reply-text-input"
            );

        const replyToIdInput =
            document.getElementById(
                "reply-to-id"
            );

        const replyingToPreview =
            document.getElementById(
                "replying-to-preview"
            );

        const replyingToText =
            document.getElementById(
                "replying-to-text"
            );

        const cancelReplyButton =
            document.getElementById(
                "cancel-reply-button"
            );

        const sendReplyButton =
            document.getElementById(
                "send-reply-button"
            );

        const sendButtonText =
            document.querySelector(
                ".send-button-text"
            );

        const sendButtonLoader =
            document.querySelector(
                ".send-button-loader"
            );

        const errorMessage =
            document.getElementById(
                "chat-error-message"
            );


        function scrollChatToBottom() {

            if (!chatMessages) {
                return;
            }

            chatMessages.scrollTop =
                chatMessages.scrollHeight;

        }


        function showError(message) {

            if (!errorMessage) {
                return;
            }

            errorMessage.textContent =
                message;

            errorMessage.hidden = false;

        }


        function hideError() {

            if (!errorMessage) {
                return;
            }

            errorMessage.textContent = "";
            errorMessage.hidden = true;

        }


        function clearReplySelection() {

            if (replyToIdInput) {
                replyToIdInput.value = "";
            }

            if (replyingToText) {
                replyingToText.textContent = "";
            }

            if (replyingToPreview) {
                replyingToPreview.hidden = true;
            }

        }


        function escapeHtml(value) {

            const div =
                document.createElement("div");

            div.textContent = value;

            return div.innerHTML;

        }


        function createOutgoingBubble(
            replyData
        ) {

            const row =
                document.createElement("div");

            row.className =
                "chat-message-row outgoing";


            const bubble =
                document.createElement("div");

            bubble.className =
                "chat-message-bubble outgoing";


            let quotedHtml = "";


            if (replyData.reply_to_text) {

                quotedHtml = `
                    <div class="quoted-message">
                        <span>Replying to</span>
                        <p>
                            ${escapeHtml(
                                replyData.reply_to_text
                            )}
                        </p>
                    </div>
                `;

            }


            bubble.innerHTML = `
                ${quotedHtml}

                <p class="message-text">
                    ${escapeHtml(replyData.text)}
                </p>

                <div class="message-footer">

                    <span>
                        ${escapeHtml(
                            replyData.created_at
                        )}
                    </span>

                    <span
                        class="
                            outgoing-status
                            status-${escapeHtml(
                                replyData.status
                            )}
                        "
                    >
                        ◷ Accepted
                    </span>

                </div>
            `;


            row.appendChild(bubble);

            chatMessages.appendChild(row);

            scrollChatToBottom();

        }


        const replyButtons =
            document.querySelectorAll(
                ".reply-to-message-button"
            );


        replyButtons.forEach(
            function (button) {

                button.addEventListener(
                    "click",
                    function () {

                        const messageRow =
                            button.closest(
                                ".chat-message-row"
                            );

                        const messageText =
                            messageRow
                            .querySelector(
                                ".message-text"
                            )
                            .innerText
                            .trim();


                        replyToIdInput.value =
                            button.dataset.replyId;

                        replyingToText.textContent =
                            messageText;

                        replyingToPreview.hidden =
                            false;

                        replyTextInput.focus();

                    }
                );

            }
        );


        if (cancelReplyButton) {

            cancelReplyButton.addEventListener(
                "click",
                clearReplySelection
            );

        }


        if (replyForm) {

            replyForm.addEventListener(
                "submit",
                async function (event) {

                    event.preventDefault();

                    hideError();


                    const messageText = (
                        replyTextInput.value
                    ).trim();


                    if (!messageText) {

                        showError(
                            "Reply message type here."
                        );

                        return;

                    }


                    sendReplyButton.disabled = true;

                    sendButtonText.hidden = true;
                    sendButtonLoader.hidden = false;


                    try {

                        const formData =
                            new FormData(
                                replyForm
                            );


                        const response =
                            await fetch(
                                replyForm.action,
                                {
                                    method: "POST",
                                    body: formData,
                                    headers: {
                                        "X-Requested-With":
                                            "XMLHttpRequest"
                                    }
                                }
                            );


                        const responseData =
                            await response.json();


                        if (
                            !response.ok
                            || !responseData.success
                        ) {

                            throw new Error(
                                responseData.error
                                || "Reply send nahi hua."
                            );

                        }


                        createOutgoingBubble(
                            responseData.outgoing_reply
                        );


                        replyTextInput.value = "";

                        clearReplySelection();


                    } catch (error) {

                        showError(
                            error.message
                            || "Unexpected error aayi."
                        );

                    } finally {

                        sendReplyButton.disabled =
                            false;

                        sendButtonText.hidden =
                            false;

                        sendButtonLoader.hidden =
                            true;

                    }

                }
            );

        }


        scrollChatToBottom();

    }
);