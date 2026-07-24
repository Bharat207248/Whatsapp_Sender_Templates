// document.addEventListener(
//     "DOMContentLoaded",
//     function () {

//         // =====================================
//         // HTML ELEMENTS
//         // =====================================

//         const customerCheckboxes = Array.from(
//             document.querySelectorAll(
//                 'input[name="customers"]'
//             )
//         );

//         const selectedCountElement =
//             document.getElementById(
//                 "selected-customer-count"
//             );

//         const selectionOptions =
//             document.querySelectorAll(
//                 'input[name="contact-selection"]'
//             );

//         const selectContactMenu =
//             document.querySelector(
//                 ".select-contact-menu"
//             );

//         const searchInput =
//             document.getElementById(
//                 "customer-search-input"
//             );

//         const tableBody =
//             document.getElementById(
//                 "customer-table-body"
//             );

//         const noResultRow =
//             document.getElementById(
//                 "customer-no-result-row"
//             );


//         // =====================================
//         // CUSTOMER TABLE ROWS
//         // =====================================

//         const customerRows = tableBody
//             ? Array.from(
//                 tableBody.querySelectorAll(
//                     ".customer-search-row"
//                 )
//             )
//             : [];


//         // =====================================
//         // SELECTED COUNT
//         // =====================================

//         function updateSelectedCustomerCount() {

//             if (!selectedCountElement) {
//                 return;
//             }

//             const selectedCustomers =
//                 customerCheckboxes.filter(
//                     function (checkbox) {
//                         return checkbox.checked;
//                     }
//                 );

//             selectedCountElement.textContent =
//                 selectedCustomers.length;
//         }


//         // =====================================
//         // CHECKBOX CHANGE
//         // =====================================

//         customerCheckboxes.forEach(
//             function (checkbox) {

//                 checkbox.addEventListener(
//                     "change",
//                     updateSelectedCustomerCount
//                 );

//             }
//         );


//         // =====================================
//         // VISIBLE CUSTOMERS
//         // =====================================

//         function getVisibleCustomerRows() {

//             return customerRows.filter(
//                 function (row) {

//                     return (
//                         row.style.display !== "none"
//                     );

//                 }
//             );

//         }


//         function getCheckboxFromRow(row) {

//             return row.querySelector(
//                 'input[name="customers"]'
//             );

//         }


//         function setCheckboxValue(
//             checkbox,
//             checked
//         ) {

//             if (!checkbox) {
//                 return;
//             }

//             checkbox.checked = checked;
//         }


//         // =====================================
//         // ALL / TOP 10 / BOTTOM 10
//         // =====================================

//         selectionOptions.forEach(
//             function (option) {

//                 option.addEventListener(
//                     "change",
//                     function () {

//                         const selectedOption =
//                             this.value;

//                         const visibleRows =
//                             getVisibleCustomerRows();

//                         const visibleCheckboxes =
//                             visibleRows
//                                 .map(
//                                     getCheckboxFromRow
//                                 )
//                                 .filter(Boolean);


//                         // All visible customers select
//                         if (
//                             selectedOption === "all"
//                         ) {

//                             visibleCheckboxes.forEach(
//                                 function (checkbox) {

//                                     setCheckboxValue(
//                                         checkbox,
//                                         true
//                                     );

//                                 }
//                             );

//                         }


//                         // Visible list ke starting 10
//                         else if (
//                             selectedOption === "top-10"
//                         ) {

//                             visibleCheckboxes.forEach(
//                                 function (
//                                     checkbox,
//                                     index
//                                 ) {

//                                     setCheckboxValue(
//                                         checkbox,
//                                         index < 10
//                                     );

//                                 }
//                             );

//                         }


//                         // Visible list ke last 10
//                         else if (
//                             selectedOption
//                             === "bottom-10"
//                         ) {

//                             const startingIndex =
//                                 Math.max(
//                                     visibleCheckboxes.length
//                                     - 10,
//                                     0
//                                 );

//                             visibleCheckboxes.forEach(
//                                 function (
//                                     checkbox,
//                                     index
//                                 ) {

//                                     setCheckboxValue(
//                                         checkbox,
//                                         index
//                                         >= startingIndex
//                                     );

//                                 }
//                             );

//                         }


//                         updateSelectedCustomerCount();


//                         // Dropdown close
//                         if (selectContactMenu) {

//                             selectContactMenu
//                                 .removeAttribute(
//                                     "open"
//                                 );

//                         }


//                         // Same option dobara select
//                         // karne ke liye radio reset
//                         this.checked = false;

//                     }
//                 );

//             }
//         );


//         // =====================================
//         // SEARCH TEXT NORMALIZE
//         // =====================================

//         function normalizeText(value) {

//             return String(value || "")
//                 .toLowerCase()
//                 .replace(/\s+/g, " ")
//                 .trim();

//         }


//         // =====================================
//         // CUSTOMER LIVE SEARCH
//         // =====================================

//         function filterCustomerRows() {

//             if (
//                 !searchInput
//                 || !customerRows.length
//             ) {
//                 return;
//             }


//             const searchText =
//                 normalizeText(
//                     searchInput.value
//                 );


//             let visibleRowCount = 0;


//             customerRows.forEach(
//                 function (row) {

//                     const customerData =
//                         normalizeText(
//                             row.dataset
//                                 .customerSearch
//                             || row.textContent
//                         );


//                     const isMatching = (
//                         searchText === ""
//                         || customerData.includes(
//                             searchText
//                         )
//                     );


//                     row.style.display = (
//                         isMatching
//                         ? ""
//                         : "none"
//                     );


//                     if (isMatching) {
//                         visibleRowCount += 1;
//                     }

//                 }
//             );


//             // No result message
//             if (noResultRow) {

//                 noResultRow.style.display = (
//                     visibleRowCount === 0
//                     ? ""
//                     : "none"
//                 );

//             }

//         }


//         if (searchInput) {

//             // Type karte hi filter
//             searchInput.addEventListener(
//                 "input",
//                 filterCustomerRows
//             );


//             // Search clear button support
//             searchInput.addEventListener(
//                 "search",
//                 filterCustomerRows
//             );


//             // Enter press se main WhatsApp
//             // form submit nahi hoga
//             searchInput.addEventListener(
//                 "keydown",
//                 function (event) {

//                     if (
//                         event.key === "Enter"
//                     ) {

//                         event.preventDefault();

//                     }

//                 }
//             );

//         }


//         // =====================================
//         // INITIAL PAGE LOAD
//         // =====================================

//         updateSelectedCustomerCount();
//         filterCustomerRows();

//     }
// );


document.addEventListener(
    "DOMContentLoaded",
    function () {

        // =====================================
        // ELEMENTS
        // =====================================

        const whatsappForm =
            document.getElementById(
                "whatsapp-send-form"
            );

        const searchInput =
            document.getElementById(
                "customer-search-input"
            );

        const tableBody =
            document.getElementById(
                "customer-table-body"
            );

        const noResultRow =
            document.getElementById(
                "customer-no-result-row"
            );

        const selectedCountElement =
            document.getElementById(
                "selected-customer-count"
            );

        const selectionOptions =
            document.querySelectorAll(
                'input[name="contact-selection"]'
            );

        const selectContactMenu =
            document.querySelector(
                ".select-contact-menu"
            );


        if (!tableBody) {

            console.warn(
                "Customer table body not found."
            );

            return;

        }


        // Sirf actual customer rows
        const customerRows = Array.from(
            tableBody.querySelectorAll(
                ".customer-search-row"
            )
        );


        const customerCheckboxes = Array.from(
            tableBody.querySelectorAll(
                'input[name="customers"]'
            )
        );


        // =====================================
        // NORMALIZE SEARCH TEXT
        // =====================================

        function normalizeText(value) {

            return String(value || "")
                .toLowerCase()
                .replace(/\s+/g, " ")
                .trim();

        }


        // =====================================
        // CUSTOMER SEARCH
        // =====================================

        function filterCustomers() {

            if (!searchInput) {
                return;
            }


            const searchValue =
                normalizeText(
                    searchInput.value
                );


            let visibleCount = 0;


            customerRows.forEach(
                function (row) {

                    const searchableText =
                        normalizeText(
                            row.dataset
                                .customerSearch
                            || row.textContent
                        );


                    const matched = (
                        searchValue === ""
                        || searchableText.includes(
                            searchValue
                        )
                    );


                    row.style.display = (
                        matched
                        ? ""
                        : "none"
                    );


                    if (matched) {
                        visibleCount += 1;
                    }

                }
            );


            if (noResultRow) {

                noResultRow.style.display = (
                    visibleCount === 0
                    ? ""
                    : "none"
                );

            }

        }


        // Type karte hi search chalegi
        if (searchInput) {

            searchInput.addEventListener(
                "input",
                filterCustomers
            );


            searchInput.addEventListener(
                "search",
                filterCustomers
            );


            // Enter par form submit bilkul nahi hoga
            searchInput.addEventListener(
                "keydown",
                function (event) {

                    if (event.key === "Enter") {

                        event.preventDefault();
                        event.stopPropagation();

                        filterCustomers();

                    }

                }
            );

        }


        // Extra safety:
        // Search input se Enter aaye to form submit roko
        if (whatsappForm && searchInput) {

            whatsappForm.addEventListener(
                "keydown",
                function (event) {

                    if (
                        event.key === "Enter"
                        && event.target
                        === searchInput
                    ) {

                        event.preventDefault();
                        event.stopPropagation();

                        filterCustomers();

                    }

                },
                true
            );

        }


        // =====================================
        // SELECTED CUSTOMER COUNT
        // =====================================

        function updateSelectedCount() {

            if (!selectedCountElement) {
                return;
            }


            const selectedCount =
                customerCheckboxes.filter(
                    function (checkbox) {

                        return checkbox.checked;

                    }
                ).length;


            selectedCountElement.textContent =
                selectedCount;

        }


        customerCheckboxes.forEach(
            function (checkbox) {

                checkbox.addEventListener(
                    "change",
                    updateSelectedCount
                );

            }
        );


        // =====================================
        // VISIBLE CUSTOMER CHECKBOXES
        // =====================================

        function getVisibleCheckboxes() {

            return customerRows
                .filter(
                    function (row) {

                        return (
                            row.style.display
                            !== "none"
                        );

                    }
                )
                .map(
                    function (row) {

                        return row.querySelector(
                            'input[name="customers"]'
                        );

                    }
                )
                .filter(Boolean);

        }


        // =====================================
        // ALL / TOP 10 / BOTTOM 10
        // =====================================

        selectionOptions.forEach(
            function (option) {

                option.addEventListener(
                    "change",
                    function () {

                        const selectedOption =
                            this.value;

                        const visibleCheckboxes =
                            getVisibleCheckboxes();


                        if (
                            selectedOption === "all"
                        ) {

                            visibleCheckboxes.forEach(
                                function (checkbox) {

                                    checkbox.checked = true;

                                }
                            );

                        }


                        else if (
                            selectedOption === "top-10"
                        ) {

                            visibleCheckboxes.forEach(
                                function (
                                    checkbox,
                                    index
                                ) {

                                    checkbox.checked = (
                                        index < 10
                                    );

                                }
                            );

                        }


                        else if (
                            selectedOption
                            === "bottom-10"
                        ) {

                            const startingIndex =
                                Math.max(
                                    visibleCheckboxes.length
                                    - 10,
                                    0
                                );


                            visibleCheckboxes.forEach(
                                function (
                                    checkbox,
                                    index
                                ) {

                                    checkbox.checked = (
                                        index
                                        >= startingIndex
                                    );

                                }
                            );

                        }


                        updateSelectedCount();


                        if (selectContactMenu) {

                            selectContactMenu
                                .removeAttribute(
                                    "open"
                                );

                        }


                        // Same option dobara use
                        // karne ke liye radio reset
                        this.checked = false;

                    }
                );

            }
        );


        // =====================================
        // INITIAL LOAD
        // =====================================

        updateSelectedCount();
        filterCustomers();

    }
);