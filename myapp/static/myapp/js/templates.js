document.addEventListener("DOMContentLoaded", function () {

    const templateSelect =
        document.getElementById("template");

    const templatesDataElement =
        document.getElementById(
            "approved-templates-data"
        );

    const languageElement =
        document.getElementById(
            "template-language"
        );

    const categoryElement =
        document.getElementById(
            "template-category"
        );

    const emptyPreview =
        document.getElementById(
            "empty-template-preview"
        );

    const selectedPreview =
        document.getElementById(
            "selected-template-preview"
        );

    const previewTemplateName =
        document.getElementById(
            "preview-template-name"
        );

    const headerTextElement =
        document.getElementById(
            "template-header-text"
        );

    const bodyTextElement =
        document.getElementById(
            "template-body-text"
        );

    const footerTextElement =
        document.getElementById(
            "template-footer-text"
        );

    const mediaPlaceholder =
        document.getElementById(
            "template-media-placeholder"
        );

    const headerImage =
        document.getElementById(
            "template-header-image"
        );

    const buttonsContainer =
        document.getElementById(
            "template-buttons"
        );


    /*
        Required HTML elements check
    */

    if (!templateSelect) {
        console.error(
            "Template select element not found."
        );
        return;
    }

    if (!templatesDataElement) {
        console.error(
            "'Approved-templates-data' was not found.."
        );
        return;
    }


    /*
        Django JSON ko JavaScript array me convert
    */

    let approvedTemplates = [];

    try {
        approvedTemplates = JSON.parse(
            templatesDataElement.textContent
        );
    } catch (error) {
        console.error(
            "Template JSON parse error:",
            error
        );
        return;
    }


    /*
        Template name aur language ka map
    */

    const templateMap = new Map();

    approvedTemplates.forEach(function (template) {

        const key =
            `${template.name}||${template.language}`;

        templateMap.set(key, template);

    });


    /*
        Template ka particular component find karega
    */

    function getComponent(template, type) {

        const components =
            template.components || [];

        return components.find(
            function (component) {

                return (
                    component.type || ""
                ).toUpperCase() === type;

            }
        );

    }


    /*
        Variables ke sample values handle karna
    */

    function normalizeExamples(values) {

        if (!Array.isArray(values)) {
            return [];
        }

        if (
            values.length > 0 &&
            Array.isArray(values[0])
        ) {
            return values[0];
        }

        return values;
    }


    function replaceVariables(
        text,
        component,
        prefix
    ) {

        if (!text) {
            return "";
        }

        const example =
            component.example || {};

        const values =
            normalizeExamples(
                example[`${prefix}_text`] || []
            );

        return text.replace(
            /\{\{\s*(\d+)\s*\}\}/g,
            function (variable, number) {

                const index =
                    Number(number) - 1;

                if (values[index] !== undefined) {
                    return values[index];
                }

                return variable;
            }
        );

    }


    /*
        Preview reset
    */

    function resetPreview() {

        languageElement.textContent = "—";
        categoryElement.textContent = "—";

        emptyPreview.hidden = false;
        selectedPreview.hidden = true;

        headerTextElement.hidden = true;
        headerTextElement.textContent = "";

        bodyTextElement.textContent = "";

        footerTextElement.hidden = true;
        footerTextElement.textContent = "";

        mediaPlaceholder.hidden = true;

        headerImage.hidden = true;
        headerImage.removeAttribute("src");

        buttonsContainer.hidden = true;
        buttonsContainer.innerHTML = "";

    }


    /*
        Header show karna
    */

    function renderHeader(template) {

        const header =
            getComponent(template, "HEADER");

        headerTextElement.hidden = true;
        mediaPlaceholder.hidden = true;
        headerImage.hidden = true;

        if (!header) {
            return;
        }

        const format = (
            header.format || "TEXT"
        ).toUpperCase();


        if (format === "TEXT") {

            const text =
                replaceVariables(
                    header.text || "",
                    header,
                    "header"
                );

            headerTextElement.textContent =
                text;

            headerTextElement.hidden = false;

            return;
        }


        const example =
            header.example || {};

        const handles =
            example.header_handle || [];

        const mediaUrl =
            Array.isArray(handles)
                ? handles[0]
                : null;


        if (
            format === "IMAGE" &&
            typeof mediaUrl === "string" &&
            mediaUrl.startsWith("http")
        ) {

            headerImage.src = mediaUrl;
            headerImage.hidden = false;

            headerImage.onerror = function () {

                headerImage.hidden = true;

                mediaPlaceholder.textContent =
                    "IMAGE Header";

                mediaPlaceholder.hidden = false;
            };

        } else {

            mediaPlaceholder.textContent =
                `${format} Header`;

            mediaPlaceholder.hidden = false;
        }

    }


    /*
        Body show karna
    */

    function renderBody(template) {

        const body =
            getComponent(template, "BODY");

        if (!body) {

            bodyTextElement.textContent =
                "Body content available nahi hai.";

            return;
        }

        bodyTextElement.textContent =
            replaceVariables(
                body.text || "",
                body,
                "body"
            );

    }


    /*
        Footer show karna
    */

    function renderFooter(template) {

        const footer =
            getComponent(template, "FOOTER");

        footerTextElement.hidden = true;
        footerTextElement.textContent = "";

        if (!footer || !footer.text) {
            return;
        }

        footerTextElement.textContent =
            footer.text;

        footerTextElement.hidden = false;

    }


    /*
        Buttons show karna
    */

    function renderButtons(template) {

        const buttonsComponent =
            getComponent(template, "BUTTONS");

        buttonsContainer.innerHTML = "";
        buttonsContainer.hidden = true;

        if (
            !buttonsComponent ||
            !Array.isArray(
                buttonsComponent.buttons
            )
        ) {
            return;
        }

        buttonsComponent.buttons.forEach(
            function (button) {

                const buttonElement =
                    document.createElement("div");

                buttonElement.className =
                    "template-button";

                buttonElement.textContent =
                    button.text ||
                    button.type ||
                    "Button";

                buttonsContainer.appendChild(
                    buttonElement
                );

            }
        );

        if (
            buttonsComponent.buttons.length > 0
        ) {
            buttonsContainer.hidden = false;
        }

    }


    /*
        Selected template ka complete preview
    */

    function showSelectedTemplate() {

        const selectedOption =
            templateSelect.options[
                templateSelect.selectedIndex
            ];

        const templateKey =
            selectedOption.dataset.templateKey;


        if (!templateKey) {
            resetPreview();
            return;
        }


        const selectedTemplate =
            templateMap.get(templateKey);


        if (!selectedTemplate) {

            console.error(
                "Not found in the selected templates.:",
                templateKey
            );

            resetPreview();
            return;
        }


        languageElement.textContent =
            selectedTemplate.language || "—";

        categoryElement.textContent =
            selectedTemplate.category || "—";


        emptyPreview.hidden = true;
        selectedPreview.hidden = false;

        previewTemplateName.textContent =
            selectedTemplate.name || "Template";


        renderHeader(selectedTemplate);
        renderBody(selectedTemplate);
        renderFooter(selectedTemplate);
        renderButtons(selectedTemplate);

    }


    /*
        Dropdown change
    */

    templateSelect.addEventListener(
        "change",
        showSelectedTemplate
    );


    /*
        Page load par selected template ka
        preview turant show hoga.
    */

    showSelectedTemplate();

});