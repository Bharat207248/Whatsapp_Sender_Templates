document.addEventListener("DOMContentLoaded", function () {

    const templateSelect =
        document.getElementById("template");

    const templatesJson =
        document.getElementById(
            "approved-templates-data"
        );

    const parameterSection =
        document.getElementById(
            "template-parameter-section"
        );

    const parameterFields =
        document.getElementById(
            "template-parameter-fields"
        );


    if (
        !templateSelect ||
        !templatesJson ||
        !parameterSection ||
        !parameterFields
    ) {
        return;
    }


    let approvedTemplates = [];

    try {
        approvedTemplates = JSON.parse(
            templatesJson.textContent
        );
    } catch (error) {
        console.error(
            "Approved template JSON error:",
            error
        );
        return;
    }


    const templateMap = new Map();

    approvedTemplates.forEach(function (template) {

        const key =
            `${template.name}||${template.language}`;

        templateMap.set(key, template);

    });


    function getNumberedVariables(text) {

        const variables = [];
        const regex = /\{\{\s*(\d+)\s*\}\}/g;

        let match;

        while ((match = regex.exec(text || ""))) {

            if (!variables.includes(match[1])) {
                variables.push(match[1]);
            }

        }

        return variables;
    }


    function getNamedVariables(text) {

        const variables = [];

        const regex =
            /\{\{\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*\}\}/g;

        let match;

        while ((match = regex.exec(text || ""))) {

            if (!variables.includes(match[1])) {
                variables.push(match[1]);
            }

        }

        return variables;
    }


    function getNumberedExamples(
        component,
        prefix
    ) {

        const example =
            component.example || {};

        let values =
            example[`${prefix}_text`] || [];

        if (
            Array.isArray(values) &&
            values.length > 0 &&
            Array.isArray(values[0])
        ) {
            values = values[0];
        }

        return Array.isArray(values)
            ? values
            : [];
    }


    function getNamedExample(
        component,
        prefix,
        variableName
    ) {

        const example =
            component.example || {};

        const values =
            example[
                `${prefix}_text_named_params`
            ] || [];

        const found = values.find(
            function (item) {

                return (
                    item.param_name === variableName ||
                    item.parameter_name === variableName ||
                    item.name === variableName
                );

            }
        );

        if (!found) {
            return "";
        }

        return (
            found.example ||
            found.value ||
            ""
        );
    }


    function createGroup(title) {

        const group =
            document.createElement("div");

        group.className =
            "template-parameter-group";


        const heading =
            document.createElement("h4");

        heading.textContent = title;

        group.appendChild(heading);

        parameterFields.appendChild(group);

        return group;
    }


    function createInput(
        parent,
        labelText,
        inputName,
        inputValue = "",
        placeholder = ""
    ) {

        const wrapper =
            document.createElement("div");

        wrapper.className =
            "template-parameter-field";


        const label =
            document.createElement("label");

        label.setAttribute(
            "for",
            inputName
        );

        label.textContent = labelText;


        const input =
            document.createElement("input");

        input.type = "text";
        input.id = inputName;
        input.name = inputName;
        input.value = inputValue || "";
        input.placeholder = placeholder;
        input.required = true;


        wrapper.appendChild(label);
        wrapper.appendChild(input);

        parent.appendChild(wrapper);
    }
    function createFileInput(
    parent,
    labelText,
    inputName,
    acceptedFiles,
    helpMessage
) {
    const wrapper = document.createElement("div");

    wrapper.className =
        "template-parameter-field media-upload-field";


    const label = document.createElement("label");

    label.setAttribute("for", inputName);
    label.textContent = labelText;


    const input = document.createElement("input");

    input.type = "file";
    input.id = inputName;
    input.name = inputName;
    input.accept = acceptedFiles;
    input.required = true;


    const selectedFile = document.createElement("small");

    selectedFile.className = "selected-media-file";
    selectedFile.textContent = "No file selected";


    const helpText = document.createElement("small");

    helpText.className = "media-file-help";
    helpText.textContent = helpMessage;


    input.addEventListener("change", function () {
        const file = input.files[0];

        if (!file) {
            selectedFile.textContent =
                "No file selected";

            return;
        }

        const fileSizeInMB = (
            file.size / (1024 * 1024)
        ).toFixed(2);

        selectedFile.textContent =
            `${file.name} (${fileSizeInMB} MB)`;
    });


    wrapper.appendChild(label);
    wrapper.appendChild(input);
    wrapper.appendChild(selectedFile);
    wrapper.appendChild(helpText);

    parent.appendChild(wrapper);
}

    function renderTextVariables(
        component,
        prefix,
        examplePrefix,
        heading
    ) {

        const text =
            component.text || "";

        const numberedVariables =
            getNumberedVariables(text);

        const namedVariables =
            getNamedVariables(text);

        if (
            numberedVariables.length === 0 &&
            namedVariables.length === 0
        ) {
            return false;
        }

        const group = createGroup(heading);

        const numberedExamples =
            getNumberedExamples(
                component,
                examplePrefix
            );


        numberedVariables.forEach(
            function (variableNumber) {

                const exampleValue =
                    numberedExamples[
                        Number(variableNumber) - 1
                    ] || "";

                createInput(
                    group,
                    `Variable {{${variableNumber}}}`,
                    `${prefix}_var_${variableNumber}`,
                    exampleValue,
                    `Value for {{${variableNumber}}}`
                );

            }
        );


        namedVariables.forEach(
            function (variableName) {

                const exampleValue =
                    getNamedExample(
                        component,
                        examplePrefix,
                        variableName
                    );

                createInput(
                    group,
                    `Variable {{${variableName}}}`,
                    `${prefix}_named_${variableName}`,
                    exampleValue,
                    `Value for {{${variableName}}}`
                );

            }
        );

        return true;
    }


  function renderMediaHeader(
    component,
    prefix,
    heading
) {
    const format = (
        component.format || ""
    ).toUpperCase();


    const mediaSettings = {
        IMAGE: {
            label: "Choose Image",
            accept:
                "image/jpeg,image/png,image/webp,.jpg,.jpeg,.png,.webp",
            help:
                "Select a JPG, JPEG, PNG, or WebP image."
        },

        VIDEO: {
            label: "Choose Video",
            accept:
                "video/mp4,video/3gpp,.mp4,.3gp",
            help:
                "Select an MP4 or 3GP video. Maximum size: 16 MB."
        },

        DOCUMENT: {
            label: "Choose Document",
            accept: [
                "application/pdf",
                "text/plain",
                "application/msword",
                "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                "application/vnd.ms-excel",
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                "application/vnd.ms-powerpoint",
                "application/vnd.openxmlformats-officedocument.presentationml.presentation",
                ".pdf",
                ".txt",
                ".doc",
                ".docx",
                ".xls",
                ".xlsx",
                ".ppt",
                ".pptx"
            ].join(","),

            help:
                "PDF, TXT, Word, Excel ya PowerPoint document select karein. Maximum size 100 MB."
        }
    };


    const selectedMedia =
        mediaSettings[format];


    if (!selectedMedia) {
        return false;
    }


    const group = createGroup(heading);


    createFileInput(
        group,
        selectedMedia.label,
        `${prefix}_media_file`,
        selectedMedia.accept,
        selectedMedia.help
    );


    return true;
}
    function renderDynamicButtons(
        buttonsComponent,
        prefix,
        heading
    ) {

        const buttons =
            buttonsComponent.buttons || [];

        let group = null;
        let hasDynamicButton = false;


        buttons.forEach(
            function (button, buttonIndex) {

                const buttonType = (
                    button.type || ""
                ).toUpperCase();

                const buttonUrl =
                    button.url || "";

                const numberedVariables =
                    getNumberedVariables(
                        buttonUrl
                    );

                const namedVariables =
                    getNamedVariables(
                        buttonUrl
                    );


                if (
                    buttonType !== "URL" ||
                    (
                        numberedVariables.length === 0 &&
                        namedVariables.length === 0
                    )
                ) {
                    return;
                }


                if (!group) {
                    group = createGroup(heading);
                }

                hasDynamicButton = true;

                const buttonExamples =
                    Array.isArray(button.example)
                        ? button.example
                        : [];


                numberedVariables.forEach(
                    function (
                        variableNumber,
                        variableIndex
                    ) {

                        createInput(
                            group,
                            `${button.text || "URL Button"} {{${variableNumber}}}`,
                            `${prefix}_button_${buttonIndex}_var_${variableNumber}`,
                            buttonExamples[variableIndex] || "",
                            "Dynamic URL value"
                        );

                    }
                );


                namedVariables.forEach(
                    function (variableName) {

                        createInput(
                            group,
                            `${button.text || "URL Button"} {{${variableName}}}`,
                            `${prefix}_button_${buttonIndex}_named_${variableName}`,
                            "",
                            "Dynamic URL value"
                        );

                    }
                );

            }
        );

        return hasDynamicButton;
    }


    function renderNormalComponents(template) {

        const components =
            template.components || [];

        components.forEach(function (component) {

            const type = (
                component.type || ""
            ).toUpperCase();


            if (type === "HEADER") {

                const format = (
                    component.format || "TEXT"
                ).toUpperCase();

                if (format === "TEXT") {

                    renderTextVariables(
                        component,
                        "header",
                        "header",
                        "Header Values"
                    );

                } else {

                    renderMediaHeader(
                        component,
                        "header",
                        "Header Media"
                    );

                }

            }


            else if (type === "BODY") {

                renderTextVariables(
                    component,
                    "body",
                    "body",
                    "Body Values"
                );

            }


            else if (type === "BUTTONS") {

                renderDynamicButtons(
                    component,
                    "normal",
                    "Button Values"
                );

            }

        });

    }


    function renderCarousel(
        carouselComponent
    ) {

        const cards =
            carouselComponent.cards || [];


        cards.forEach(
            function (card, cardIndex) {

                const cardComponents =
                    card.components || [];


                cardComponents.forEach(
                    function (component) {

                        const type = (
                            component.type || ""
                        ).toUpperCase();


                        if (type === "HEADER") {

                            const format = (
                                component.format || ""
                            ).toUpperCase();

                            if (format === "TEXT") {

                                renderTextVariables(
                                    component,
                                    `carousel_${cardIndex}_header`,
                                    "header",
                                    `Carousel Card ${cardIndex + 1} Header`
                                );

                            } else {

                                renderMediaHeader(
                                    component,
                                    `carousel_${cardIndex}_header`,
                                    `Carousel Card ${cardIndex + 1} Media`
                                );

                            }

                        }


                        else if (type === "BODY") {

                            renderTextVariables(
                                component,
                                `carousel_${cardIndex}_body`,
                                "body",
                                `Carousel Card ${cardIndex + 1} Body`
                            );

                        }


                        else if (type === "BUTTONS") {

                            renderDynamicButtons(
                                component,
                                `carousel_${cardIndex}`,
                                `Carousel Card ${cardIndex + 1} Button`
                            );

                        }

                    }
                );

            }
        );

    }


    function renderParameterFields() {

        parameterFields.innerHTML = "";

        const selectedOption =
            templateSelect.options[
                templateSelect.selectedIndex
            ];

        const key =
            selectedOption.dataset.templateKey;

        if (!key) {

            parameterSection.hidden = true;
            return;

        }


        const selectedTemplate =
            templateMap.get(key);

        if (!selectedTemplate) {

            parameterSection.hidden = true;
            return;

        }


        renderNormalComponents(
            selectedTemplate
        );


        const carouselComponent = (
            selectedTemplate.components || []
        ).find(
            function (component) {

                return (
                    component.type || ""
                ).toUpperCase() === "CAROUSEL";

            }
        );


        if (carouselComponent) {

            renderCarousel(
                carouselComponent
            );

        }


        parameterSection.hidden =
            parameterFields.children.length === 0;

    }


    templateSelect.addEventListener(
        "change",
        renderParameterFields
    );

    renderParameterFields();

});
