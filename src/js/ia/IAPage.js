(function(env) {
    function dropdownLength(value, add) {
        if(value.length <= 5 && value.length > 0) {
            return (value.length + (add || 0)) * 8;
        }

        return (value.length + (add || 0)) * 8 || 150;
    }

    // Handlebars helpers
    Handlebars.registerHelper('encodeURIComponent', encodeURIComponent);

    DDH.IAPage = function(ops) {
        this.init(ops);
    };

    // this could get the single IA json like the index.
    // but for now the page is being built with xslate
    DDH.IAPage.prototype = {
        init: function(ops) {
            //console.log("IAPage.init()\n");

            var page = this;
            var json_url = "/ia/view/" + DDH_iaid + "/json";

            if (DDH_iaid) {
                //console.log("for ia id '%s'", DDH_iaid);

                $.getJSON(json_url, function(ia_data) {
                    //Get user permissions
                    ia_data.permissions = {};
                    if ($(".special-permissions").length) {
                        ia_data.permissions = {can_edit: 1};

                        // Preview switch must be on "edited" by default
                        ia_data.preview = 1;

                        ia_data.edit_count = ia_data.edited ? Object.keys(ia_data.edited).length : 0;

                        if ($("#view_commits").length) {
                            ia_data.permissions.admin = 1;
                        }

                        if(ia_data.live.test_machine && ia_data.live.example_query) {
                            ia_data.live.can_show = true;
                        }
                    
                        ia_data.edited_dev_milestone = ia_data.edited.dev_milestone;
                    }

                    // Allow blue band to get 100% page width
                    $(".site-main > .content-wrap").first().removeClass("content-wrap");
                    $(".breadcrumb-nav").remove();

                    // Separate back-end files from front-end ones
                    ia_data.live.back_end = [];
                    ia_data.live.front_end = [];
                    if (ia_data.live.code) {
                        front_end = ["handlebars", "js", "css", "json"];
                        back_end = ["pm", "t"];
                        $.each(ia_data.live.code, function(idx) {
                            var file = ia_data.live.code[idx];
                            var type = file.replace(/.*\.([^\.]*)$/,'$1');

                            if ($.inArray(type, front_end) !== -1) {
                                ia_data.live.front_end.push(file);
                            } else if ($.inArray(type, back_end) !== -1) {
                                ia_data.live.back_end.push(file);
                            }
                        });
                    }

                    // Show latest edits for admins and users with edit permissions
                    var latest_edits_data = {};
                    if (ia_data.edited || (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated")) {
                        latest_edits_data = page.updateData(ia_data, latest_edits_data, true);
                    } else {
                        latest_edits_data = ia_data.live;
                    }

                    console.log(latest_edits_data);

                    // Readonly mode templates
                    var readonly_templates = {
                        live: {
                            name : Handlebars.templates.name(latest_edits_data),
                            top_details : Handlebars.templates.top_details(latest_edits_data),
                            description : Handlebars.templates.description(latest_edits_data),
                            examples : Handlebars.templates.examples(latest_edits_data),
                            devinfo : Handlebars.templates.devinfo(latest_edits_data),
                            github: Handlebars.templates.github(latest_edits_data),
                            edit_buttons: Handlebars.templates.edit_buttons(latest_edits_data),
                            breadcrumbs: Handlebars.templates.breadcrumbs(latest_edits_data),
                            triggers: Handlebars.templates.triggers(latest_edits_data),
                            test: Handlebars.templates.test(latest_edits_data),
                            advanced:  Handlebars.templates.advanced(latest_edits_data)
                        },
                        screens : Handlebars.templates.screens(ia_data),
                    };

                    // Pre-Edit mode templates
                    var pre_templates = {
                        name : Handlebars.templates.pre_edit_name(ia_data),
                        status : Handlebars.templates.pre_edit_status(ia_data),
                        description : Handlebars.templates.pre_edit_description(ia_data),
                        topic : Handlebars.templates.pre_edit_topic(ia_data),
                        example_query : Handlebars.templates.pre_edit_example_query(ia_data),
                        other_queries : Handlebars.templates.pre_edit_other_queries(ia_data),
                        dev_milestone : Handlebars.templates.pre_edit_dev_milestone(ia_data),
                        template : Handlebars.templates.pre_edit_template(ia_data),
                        perl_module : Handlebars.templates.pre_edit_perl_module(ia_data),
                        producer : Handlebars.templates.pre_edit_producer(ia_data),
                        designer : Handlebars.templates.pre_edit_designer(ia_data),
                        developer : Handlebars.templates.pre_edit_developer(ia_data),
                        tab : Handlebars.templates.pre_edit_tab(ia_data),
                        repo : Handlebars.templates.pre_edit_repo(ia_data),
                        src_api_documentation : Handlebars.templates.pre_edit_src_api_documentation(ia_data),
                        api_status_page : Handlebars.templates.pre_edit_api_status_page(ia_data),
                        unsafe : Handlebars.templates.pre_edit_unsafe(ia_data),
                        answerbar : Handlebars.templates.pre_edit_answerbar(ia_data),
                        triggers :  Handlebars.templates.pre_edit_triggers(ia_data),
                        perl_dependencies :  Handlebars.templates.pre_edit_perl_dependencies(ia_data),
                        src_options : Handlebars.templates.pre_edit_src_options(ia_data),
                        src_id : Handlebars.templates.pre_edit_src_id(ia_data),
                        src_name : Handlebars.templates.pre_edit_src_name(ia_data),
                        src_domain : Handlebars.templates.pre_edit_src_domain(ia_data),
                        is_stackexchange : Handlebars.templates.pre_edit_is_stackexchange(ia_data),
                        id : Handlebars.templates.pre_edit_id(ia_data),
                        blockgroup: Handlebars.templates.pre_edit_blockgroup(ia_data),
                        deployment_state: Handlebars.templates.pre_edit_deployment_state(ia_data)
                    };

                    page.updateAll(readonly_templates, ia_data, false);

                    $('body').on("click", "#show-all-issues", function(evt) {
                        $(this).hide();
                        $(".ia-issues ul li").show();
                    });

                    $("#view_json").click(function(evt) {
                        location.href = json_url;
                    });

                    function tagLength(value) {
                        if(value.length <= 10 && value.length > 0) {
                            return (value.length + 5) * 8;
                        }
                        return value.length * 8 || 100;
                    }

                    $("body").on("click", "#beta-install", function(evt) {
                        if (!$(this).hasClass("disabled")) {
                            $(this).addClass("disabled");
                            var temp_hash = {
                                "action" : "duckco",
                                "number" : ia_data.live.pr.id,
                                "repo" : "zeroclickinfo-" + ia_data.live.repo
                            };
                            beta_install(temp_hash);
                        }
                    });

                    $("body").on("change", "select.top-details.js-autocommit", function(evt) {
                        if($(this).hasClass("topic")) {
                            $(this).parent().css("width", dropdownLength($.trim($(this).children("option:selected").text()), 1) + "px");
                        } else {
                            $(this).parent().css("width", dropdownLength($.trim($(this).children("option:selected").text())) + "px");
                        }
                    });

                    $("body").on("keydown", ".ia-examples input[type='text'], .ia-triggers input[type='text']", function(evt) {
                        if(tagLength(this.value) > 100) {
                            $(this).css("width", tagLength(this.value) + "px");
                        }
                    });

                    $("body").on("click", ".devpage-edit", function(evt) {
                        evt.preventDefault();

                        $(".ia-examples input[type='text'], .ia-triggers input[type='text']").each(function() {
                            $(this).css("width", tagLength(this.value) + "px");
                        });

                        var $parent = $(this).parent().parent();

                        $(this).addClass("hide");
                        $(this).siblings(".devpage-commit, .devpage-cancel").removeClass("hide");

                        // Show editable field and hide readonly field
                        $parent.children(".hidden-toshow").removeClass("hide");
                        $parent.children(".readonly--info").addClass("hide");
                    });

                    // This shows the contributor's popup.
                    $("body").on("click", ".devpage-edit-popup", function(evt) {
                        evt.preventDefault();

                        var field = $(this).attr("id").replace("dev-edit-", "");
                        var $popup = $("#" + field + "-popup");

                        $popup.removeClass("hide");

                        // It should also show a blue background.
                        $("#edit-modal").removeClass("hide");
                        $popup.find(".save-button-popup").removeClass("is-disabled");
                    });

                    $("body").on("click", "#edit-modal", function(evt) {
                        $(this).addClass("hide");
                        $("#contributors-popup").addClass("hide");
                    });

                    $("body").on("click", "#asana_button", function(evt) {
                        if(!$(this).hasClass("is-disabled")) {
                            create_task(DDH_iaid);
                            $(this).addClass("is-disabled");
                        }
                    });

                    $("body").on("click", ".devpage-cancel", function(evt) {
                        evt.preventDefault();

                        var field = $(this).attr("id").replace(/dev\-cancel\-/, "");

                        if (ia_data.staged && ia_data.staged[field]) {
                            // Remove any unsaved edits and then refresh Handlebars
                            if (field === "example_query" || field === "other_queries") {
                                delete ia_data.staged.example_query;
                                delete ia_data.staged.other_queries;
                            } else {
                                delete ia_data.staged[field];
                            }
                        }

                        keepUnsavedEdits(field);
                    });

                    $("body").on("click", "#js-top-details-cancel", function(evt) {
                        if (!$(this).hasClass("is-disabled")) {
                            // Remove any unsaved edits
                            if (ia_data.staged && ia_data.staged.top_details) {
                                delete ia_data.staged.top_details;
                            }

                            keepUnsavedEdits("top_details");

                            // Make sure to update the widths of the topics.
                            $("select.top-details.js-autocommit").each(function() {
                                if($(this).hasClass("topic")) {
                                    $(this).parent().css("width", dropdownLength($.trim($(this).children("option:selected").text()), 1) + "px");
                                } else {
                                    $(this).parent().css("width", dropdownLength($.trim($(this).children("option:selected").text())) + "px");
                                }
                            });
                        }
                    });

                    $('body').on("change keypress focusout", ".available_types, .developer_username input", function(evt) {
                        if ((evt.type === "change" && $(this).hasClass("available_types")) || (evt.type === "keypress" && evt.which === 13)
                             || (evt.type === "focusout" && $(this).hasClass("focused"))) {
                            var $available_types;
                            var $dev_username;
                            var $parent;

                            if (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated") {
                                $parent = $(this).parent().parent().parent();
                            } else {
                                $parent =  $(this).parent();
                            }

                            $dev_username = $parent.find(".developer_username input");
                            $available_types = $parent.find(".available_types");

                            if ($(this).hasClass("focused")) {
                                $(this).removeClass("focused");
                            }

                            var type = $.trim($available_types.find("option:selected").text());
                            var username = $.trim($dev_username.val());

                            if (username && type && (type !== "ddg")) {
                                usercheck(type, username, $available_types, $dev_username);
                            } else if (type && (type === "ddg")) {
                                $dev_username.val("http://www.duckduckhack.com");
                                $parent.find(".developer input").val("DDG Team");
                                $dev_username.parent().removeClass("invalid");
                                $available_types.parent().removeClass("invalid");
                            }
                        }
                    });

                    $("body").on("focusout keypress", "#producer-input", function(evt) {
                        if ((evt.type === "keypress" && evt.which === 13) || (evt.type === "focusout" && $(this).hasClass("focused"))) {
                            var username = $(this).val();

                            if (username) {
                                usercheck("duck.co", username, null, $(this));
                            }
                        }
                    });

                    $('body').on("focusin", ".developer_username input, #producer-input", function(evt) {
                        if (!$(this).hasClass("focused")) {
                            $(this).addClass("focused");
                            var $parent = $(this).hasClass("group-vals")? $(this).parent().parent() : $(this).parent();
                            var $error = $parent.find(".ddgsi-warning").parent();
                            var $valid = $parent.find(".ddgsi-check-sign").parent();

                            $error.addClass("hide");
                            $valid.addClass("hide");

                            $("#contributors-popup .save-button-popup").removeClass("is-disabled");
                        }
                    });

                    $("body").on('click', "#edit_activate", function(evt) {
                        page.updateAll(pre_templates, ia_data, true);
                        $("#edit_disable").removeClass("hide");
                        $(this).hide();

                        if (ia_data.permissions.admin && ia_data.edit_count) {
                            $("#view_commits").removeClass("hide");
                        }
                    });

                    $('body').on('click', '.switch.js-switch', function(evt) {
                        var $preview =  $(this).parent();
                        if (!$preview.hasClass("is-on")) {
                            $preview.addClass("is-on");
                            ia_data.preview = 0;
                            page.updateHandlebars(readonly_templates, ia_data, ia_data.live.dev_milestone, false);
                        } else {
                            $preview.removeClass("is-on");
                            ia_data.preview = 1;
                            page.updateHandlebars(readonly_templates, ia_data, ia_data.live.dev_milestone, true);
                        }

                        page.updateAll(readonly_templates, ia_data, false);
                        Screens.render();
                    });

                    // Generate a screenshot
                    //
                    // UI States:
                    // - If we're logged in
                    //     - There is no screenshot at all
                    //         - Show top generate button part
                    //         - Hide the desktop/mobile switcher buttons
                    //         - Show there-is-no-screenshot message
                    //         - When the generate button is clicked:
                    //             - The screenshot loads.
                    //                 - While the screenshot loads, disable the "Generate Screenshot" button.
                    //                 - The screenshot succeeds
                    //                     - Show desktop view as a default
                    //                 - The screenshot fails
                    //                     - When the screenshot fails, show an error message
                    //     - There is a screenshot and we want to take another
                    //         - Show refresh screenshot button over the image.
                    //         - Show the desktop/mobile switcher buttons
                    //         - When the refresh button is clicked:
                    //             - The screenshot loads
                    //                 - While the screenshot loads, disable the refresh button and the switcher buttons
                    //                 - The screenshot succeeds
                    //                     - When the new screenshot loads, make sure we stay on the current view, i.e., stay on desktop
                    //                       if we're on desktop view and stay on mobile if we're on the mobile view
                    //                 - The screenshot fails
                    //                     - When the screenshot fails, show an error message
                    //                     - Show a message that the user can click on to revert back to the old screenshot
                    //                         - When the user clicks on the revert button, make sure to return to the old view (desktop/mobile)
                    // - If we're not logged in
                    //     - If there is a screenshot
                    //         - Show the screenshots
                    //         - Show the switcher buttons
                    //         - Don't show the refresh button
                    //         - Don't show the generate screenshot button
                    //     - If there is no screenshot
                    //         - Show the screenshot
                    //         - Don't show the switcher buttons
                    //         - Don't show the generate screenshot button
                    //         - Don't show the refresh button

                    var capitalize = function(str) {
                        if(str) {
                            return str.charAt(0).toUpperCase() + str.slice(1);
                        }
                        return "";
                    };

                    window.Screens = {
                        render: function() {
                            Screens.resetState();
                            Screens.hasScreenshot(function() {
                                Screens.setScreenshotImage();
                                Screens.setRefreshButton();
                                Screens.setSwitcherButtons();
                            }, function() {
                                Screens.setMessage("There are no screenshots for the query '" + capitalize(ia_data.live.example_query) + "'.");
                                Screens.setTakeScreenshotButton();
                            });
                        },
                        resetState: function() {
                            Screens.state.refreshClicked = false;
                            Screens.state.generateClicked = false;
                            Screens.state.isError = false;
                            Screens.state.isLoading = false;
                            Screens.state.isMobile = false;
                            Screens.disableLoadingAnimation();
                            Screens.enableRefreshButton();
                            Screens.enableTakeScreenshotButton();
                            Screens.disableScreenshotImage();
                        },
                        data: {
                            url: function() {
                                var image = Screens.state.isMobile ? 'mobile' : 'index';
                                return 'https://images.duckduckgo.com/iu/?u=' +
                                       encodeURIComponent('https://ia-screenshots.s3.amazonaws.com/' + DDH_iaid + '_' + image + '.png?nocache=' + Math.floor(Math.random() * 10000)) +
                                       '&f=1';
                            },
                            createImageEndpoint: 'https://jag.duckduckgo.com/screenshot/create/' + DDH_iaid,
                            saveImageEndpoint: 'https://jag.duckduckgo.com/screenshot/save/' + DDH_iaid
                        },
                        events: {
                            refreshClick: {
                                evt: 'click',
                                selector: '.generate-screenshot',
                                fn: function() {
                                    if(!Screens.state.refreshClicked) {
                                        Screens.toggleState("refreshClicked");

                                        Screens.disableRefreshButton();
                                        Screens.disableScreenshotImage();
                                        Screens.setLoadingAnimation();
                                        Screens.state.isLoading = true;
                                        Screens.generateImage(function() {
                                            Screens.toggleState("refreshClicked");
                                            Screens.render();
                                            Screens.state.isLoading = false;
                                        });
                                    }
                                }
                            },
                            generateClick: {
                                evt: 'click',
                                selector: '.screenshot-switcher--generate .btn',
                                fn: function() {
                                    if(!Screens.state.generateClicked) {
                                        Screens.toggleState("generateClicked");

                                        Screens.disableTakeScreenshotButton();
                                        Screens.disableMessage();
                                        Screens.setLoadingAnimation();
                                        Screens.state.isLoading = true;
                                        Screens.generateImage(function() {
                                            Screens.toggleState("generateClicked");
                                            Screens.render();
                                            Screens.state.isLoading = false;
                                        }, true);
                                    }
                                }
                            },
                            revertClick: {
                                evt: 'click',
                                selector: '.revert',
                                fn: function(event) {
                                    event.preventDefault();
                                    $('.revert').hide();
                                    $('.default-message').hide();
                                    Screens.render();
                                }
                            },
                            mobileClick: {
                                evt: 'click',
                                selector: '.screenshot-switcher .platform-mobile',
                                fn: function(event) {
                                    if(!Screens.state.isError && !Screens.state.isLoading) {
                                        Screens.state.isMobile = true;
                                        $('.mobile-faux__container').show();
                                        $('.screenshot-desktop').hide();
                                        Screens.setScreenshotImage();
                                        Screens.setOpacity();
                                    }
                                }
                            },
                            desktopClick: {
                                evt: 'click',
                                selector: '.screenshot-switcher .platform-desktop',
                                fn: function(event) {
                                    if(!Screens.state.isError && !Screens.state.isLoading) {
                                        Screens.state.isMobile = false;
                                        $('.mobile-faux__container').hide();
                                        $('.screenshot-desktop').show();
                                        Screens.setScreenshotImage();
                                        Screens.setOpacity();
                                    }
                                }
                            }
                        },
                        state: {
                            refreshClicked: false,
                            generateClicked: false,
                            isMobile: false,
                            isError: false,
                            isLoading: false
                        },
                        toggleState: function(state) {
                            Screens.state[state] = !Screens.state[state];
                        },
                        setOpacity: function() {
                            if(Screens.state.isMobile) {
                                $('.screenshot-switcher .platform-desktop').parent().addClass('remove-border');
                                $('.screenshot-switcher .platform-mobile').parent().removeClass('remove-border');

                                $('.screenshot-switcher .platform-mobile').removeClass('add-opacity');
                                $('.screenshot-switcher .platform-desktop').addClass('add-opacity');
                            } else {
                                $('.screenshot-switcher .platform-desktop').parent().removeClass('remove-border');
                                $('.screenshot-switcher .platform-mobile').parent().addClass('remove-border');

                                $('.screenshot-switcher .platform-mobile').addClass('add-opacity');
                                $('.screenshot-switcher .platform-desktop').removeClass('add-opacity');
                            }
                        },
                        generateImage: function(callback, isFirst) {
                            function failedMessage() {
                                Screens.disableScreenshotImage();
                                Screens.disableLoadingAnimation();
                                Screens.setMessage("Screenshot Failed", true, isFirst);

                                Screens.state.isError = true;
                            }

                            var nocache = Math.floor(Math.random() * 10000);
                            $.post(Screens.data.createImageEndpoint + "?nocache=" + nocache, function(data) {
                                if(data && data.status === "ok" && data.screenshots && data.screenshots.index) {
                                    $.post(Screens.data.saveImageEndpoint + "?nocache=" + nocache, function() {
                                        Screens.state.isError = false;
                                        callback();
                                    });
                                } else {
                                    failedMessage();
                                }
                            }).fail(failedMessage);
                        },
                        enableRefreshButton: function() {
                            $('.generate-screenshot')
                                .removeClass('btn--alternative')
                                .addClass('btn--primary');
                        },
                        enableTakeScreenshotButton: function() {
                            $('.screenshot-switcher--generate .btn')
                                .removeClass('btn--wire')
                                .addClass('btn--primary');
                        },
                        setMessage: function(message, enableRevert, isFirst) {
                            $('.screenshot--status').show();
                            $('.screenshot--status .default-message').show().text(message);

                            if(enableRevert) {
                                this.setEvent(this.events.revertClick);
                                if(isFirst) {
                                    Screens.toggleState("generateClicked");
                                    Screens.enableTakeScreenshotButton();
                                } else {
                                    $('.revert').show();
                                }
                            }
                        },
                        setLoadingAnimation: function() {
                            $('.screenshot--status').show();
                            $('.screenshot--status .loader').show();
                        },
                        setRefreshButton: function() {
                            $('.generate-screenshot').removeClass("hide");
                            this.setEvent(this.events.refreshClick);

                            $('.screenshot-switcher--generate').addClass("hide");
                        },
                        setTakeScreenshotButton: function() {
                            $('.screenshot-switcher').hide();
                            $('.screenshot-switcher--generate').removeClass("hide");

                            this.setEvent(this.events.generateClick);
                        },
                        setSwitcherButtons: function() {
                            $('.screenshot-switcher').show();
                            Screens.setEvent(Screens.events.mobileClick);
                            Screens.setEvent(Screens.events.desktopClick);
                        },
                        setScreenshotImage: function() {
                            var image = Screens.state.isMobile ? 'mobile' : 'desktop';

                            var screenshotImage = $('.ia-single--screenshots img.screenshot-' + image);
                            screenshotImage.attr('src', this.data.url());
                            screenshotImage.show();
                        },
                        disableScreenshotImage: function() {
                            $('.ia-single--screenshots img.screenshot-desktop').hide();
                            $('.mobile-faux__container').hide();
                        },
                        setEvent: function(eventData) {
                            $(eventData.selector).on(eventData.evt, eventData.fn);
                        },
                        disableLoadingAnimation: function() {
                            $('.screenshot--status').hide();
                            $('.screenshot--status .loader').hide();
                        },
                        disableRefreshButton: function() {
                            $('.generate-screenshot')
                                .removeClass('btn--primary')
                                .addClass('btn--alternative');
                        },
                        disableTakeScreenshotButton: function() {
                            $('.screenshot-switcher--generate .btn')
                                .removeClass('btn--primary')
                                .addClass('btn--wire');
                        },
                        disableMessage: function() {
                            $('.screenshot--status').hide();
                            $('.screenshot--status .default-message').hide();
                        },
                        hasScreenshot: function(succeed, failed) {
                            $("<img src='" + this.data.url() + "'>")
                                .on("load", function() {
                                    succeed();
                                })
                                .error(function() {
                                    failed();
                                });
                        }
                    };

                    Screens.render();

                    $("body").on('click', ".js-expand.button", function(evt) {
                        var milestone = $(this).parent().parent().attr("id");
                        $(".container-" + milestone + "__body").toggleClass("hide");
                        $(this).children("i").toggleClass("icon-caret-up");
                        $(this).children("i").toggleClass("icon-caret-down");
                    });

                    $("body").on("change", '.ia-single--details input[type="number"].js-autocommit', function(evt) {
                        resetSaved($(this));

                        $("#devpage-commit-details, #devpage-cancel-details").removeClass("hide");
                    });

                    $("body").on("focusin", "textarea.js-autocommit, input.js-autocommit", function(evt) {
                        resetSaved($(this));
                    });

                    $("body").on("keydown", ".ia-single--details .js-autocommit", function(evt) {
                        $("#devpage-commit-details, #devpage-cancel-details").removeClass("hide");
                    });

                    $("body").on("click", "select.js-autocommit", function(evt) {
                        var $obj;

                        if ($(this).hasClass("topic-group")) {
                            $obj = $(".js-autocommit.topic");
                        } else {
                            $obj = $(this);
                        }

                        resetSaved($obj);
                    });

                    // Dev Page: commit test machine on change
                    $("body").on("change", ".test_machine.js-autocommit", function(evt) {
                        commitEdit($(this));
                    });

                    $("body").on("focusin", ".topic-group.js-autocommit", function(evt) {
                        $(".top__repo, .top__milestone").hide();
                        $("#topic-cancel").removeClass("hide");
                    });

                    $("body").on("blur", ".topic-group.js-autocommit", function(evt) {
                        $(".top__repo, .top__milestone").show();
                        $("#topic-cancel").addClass("hide");
                        if ($(".topic-group.js-autocommit").length < 2) {
                            $("#add_topic").removeClass("hide");
                        }
                    });

                    $("body").on("change", "select.top-details.js-autocommit", function(evt) {
                        $("#js-top-details-submit, #js-top-details-cancel").removeClass("is-disabled");

                        // Display topics as tags
                        if ($(this).hasClass("topic-group")) {
                            $(".topic-group.js-autocommit").trigger("blur");
                        }
                    });

                    $("body").on("keydown", "#name-input", function(evt) {
                        $("#js-top-details-submit, #js-top-details-cancel").removeClass("is-disabled");
                    });

                    // Cancel an editing attempt on topics and remove any new empty topics
                    $("body").on("click", "#topic-cancel", function(evt) {
                        $(".topic-group.js-autocommit").each(function(idx) {
                            if ((!$(this).val()) && (!$(this).hasClass("new_empty_topic"))) {
                                $(this).parent().parent().addClass("hide").removeClass("js-autocommit");
                            }
                        });

                        $(".topic-group.js-autocommit").trigger("blur");
                    });

                    $("body").on('click', "#contributors-popup .cancel-button-popup", function(evt) {
                        $("#contributors-popup").addClass("hide");
                        $("#edit-modal").hide();
                    });

                    $("body").on("keypress", ".other_queries.js-autocommit, #example_query-input", function(evt) {
                        if (evt.keyCode === 13) {
                            $(".other_queries.js-autocommit, #example_query-input").trigger("blur");
                        }
                    });

                    //Dev Page: commit fields in the details section
                    $("body").on("click", "#devpage-commit-details", function(evt) {
                        evt.preventDefault();

                        var $details = $("#ia-single--details .js-autocommit");
                        
                        // There's only one section group for fatheads and one for spices,
                        // so we check if it's been saved already in order to avoid useless 
                        // multiple POST requests
                        var section_done = false;
                        var to_commit = [];

                        $details.each(function(idx) {
                            if ((!section_done) || (!$(this).hasClass("section-group__item"))) {
                                if ($(this).hasClass("section-group__item")) {
                                    section_done = true;
                                }
                                
                                to_commit.push(getUnsavedValue($(this)));
                            }
                        });

                        commitMultiple(to_commit);

                        $("#devpage-commit-details, #devpage-cancel-details").addClass("hide");
                    });

                    // Dev Page: cancel edits in the details section
                    $("body").on("click", "#devpage-cancel-details", function(evt) {
                        evt.preventDefault();

                        if (ia_data.staged && ia_data.staged.details) {
                            delete ia_data.staged.details;
                        }
                        
                        keepUnsavedEdits("details");
                    });

                    $("body").on("click", "#ia-single--details .frm__label__chk.js-autocommit", function(evt) {
                        $("#devpage-commit-details, #devpage-cancel-details").removeClass("hide");
                        if (!$(this).attr("checked")) {
                            $(this).attr("checked", ":checked");
                        } else {
                            $(this).removeAttr("checked");
                        }
                    });

                    // Dev Page: commit checkboxes in the testing section
                    $("body").on("click", ".testing-section .js-autocommit", function(evt) {
                        evt.preventDefault();
                        commitEdit($(this));
                    });

                    // Dev Page: commit fields in the blue band
                    $("body").on('click', "#js-top-details-submit", function(evt) {
                        if (!$(this).hasClass("is-disabled")) {
                            var $editable = $(".top-details.js-autocommit");
                            var field;
                            var is_json = false;
                            var topic_done = false;

                            console.log($editable.length);
                            $editable.each(function(idx) {
                                field = $(this).hasClass("topic-group")? "topic" : "";
                                is_json = field === "topic"? true : false;

                                // Make sure we try to commit topics just once
                                if ((field !== "topic") || (!topic_done)) {
                                    commitEdit($(this), field, is_json);
                                    topic_done = field === "topic"? true : topic_done;
                                }
                            });

                            $("#js-top-details-submit, #js-top-details-cancel").addClass("is-disabled");
                        }
                    });

                    // Dev Page: commit fields inside a popup
                    $("body").on('click', "#contributors-popup .save-button-popup", function(evt) {
                        // We only have a popup for the contributors fields, so far:
                        // try committing developer and then commitEdit() and autocommit() will take care of whether
                        // to commit producer as well (if user has permissions etc).
                        if (!$(this).hasClass("is-disabled")) {
                            var $editable = $(".developer_username input");
                            $(this).addClass("is-disabled");
                            commitEdit($editable, "developer", true);
                        }
                    });

                    // Dev Page: commit any field inside .ia-single--left and .ia-single--right (except popup fields)
                    $("body").on('click', ".devpage-commit", function(evt) {
                        evt.preventDefault();

                        var $parent = $(this).parent().parent();
                        var $editable = $parent.find(".js-autocommit").first();
                        var to_commit = [];

                        if ($parent.hasClass("ia-examples")) {
                            // We pass the fields names as well in case all of them are removed
                            // so we'll be able to commit the empty value for these fields anyway
                            to_commit.push(getUnsavedValue($(".other_queries input"), "other_queries", true));
                            to_commit.push(getUnsavedValue($("#example_query-input"), "example_query"));

                            commitMultiple(to_commit, true);
                        } else {
                            console.log($editable.attr("class"));
                            commitEdit($editable);
                        }
                    });

                    $("body").on('click', ".assign-button.js-autocommit", function(evt) {
                        var $input = $(".team-input");
                        var username = $.trim($(".header-account-info .user-name").text());
                        $input.val(username);
                        $("#producer-input").removeClass("focused");
                         $("#contributors-popup .save-button-popup").removeClass("is-disabled");
                        usercheck("duck.co", username, null, $("#producer-input"));
                    });

                    $("body").on('click', '.js-pre-editable.button', function(evt) {
                        var field = $(this).attr('name');
                        var $row = $(this).parent();
                        var $obj = $("#column-edits-" + field);
                        var value = {};

                        value[field] = ia_data.edited[field]? ia_data.edited[field] : ia_data.live[field];

                        $obj.replaceWith(Handlebars.templates['edit_' + field](value));
                        $row.addClass("row-diff-edit");
                        $(this).hide();
                        $row.children(".js-editable").removeClass("hide");

                        if (field === "topic") {
                            page.appendTopics($(".available_topics"));
                        } else if (field === "blockgroup") {
                            page.appendBlockgroup($(".available_blockgroups"));
                        }
                    });

                    $("#edit_disable").on('click', function(evt) {
                        location.reload();
                    });

                    $("body").on('click', '.add_input', function(evt) {
                        evt.preventDefault();

                        var $ul = $(this).closest('ul');
                        var $new_input = $ul.find('.new_input').first().clone();
                        var $last_li = $ul.children('li').last();
                        $last_li.before($new_input.removeClass("hide"));
                        $new_input.removeClass("new_input");

                        if (($(this).attr("id") === "add_example") && ($("#example_query-input").length === 0)
                            && (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated")) {
                            var $input = $new_input.find("input");
                            $input.attr("id", "example_query-input");
                            $input.removeClass("group-vals").removeClass("other_queries").addClass("example_query");
                            $new_input.find(".other_queries").removeClass("other_queries").addClass("example_query");
                        }
                    });

                    $("body").on('click', '#add_topic', function(evt) {
                        var topics;
                        topics = $(".topic-separator").length;
                        var $empty_topic = $(".new_empty_topic").clone();
                        $(this).before($empty_topic.removeClass("hide").removeClass("new_empty_topic"));

                        if (topics > 1) {
                            $(this).addClass("hide");
                        }
                    });

                    $("body").on('click', '#view_commits', function(evt) {
                        window.location = "/ia/commit/" + DDH_iaid;
                    });

                    $("body").on("click", ".delete", function(evt) {
                        var field = $(this).attr('name');

                        // If dev milestone is not 'live' it means we are in the dev page
                        if (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated") {
                            if ($(this).parent().parent().hasClass("topic-separator")) {
                                $("#js-top-details-submit, #js-top-details-cancel").removeClass("is-disabled");
                                $("#add_topic").removeClass("hide");
                            } else if ($(this).parent().hasClass("example_query")) {
                                console.log("delete button has example_query class");
                                var $first_query = $(".other_queries input.js-autocommit.group-vals").first();
                                console.log($first_query.attr("class"));
                                if ($first_query.length && (!$first_query.parent().parent().hasClass("new_input"))) {
                                    $first_query.removeClass("group-vals").addClass("example_query");
                                    $first_query.parent().removeClass("other_queries").addClass("example_query");
                                    $first_query.attr("id", "example_query-input");
                                }
                            }

                            $(this).parent().parent().remove();
                        } else {
                            if (field !== "topic") {
                                $(this).parent().remove();
                            } else {
                                var $select = $(this).parent().find('.available_topics');
                                $select.find('option[value="0"]').empty();
                                $select.val('0');
                            }
                        }
                   });

                    $("body").on("click", ".column-right-edits i.icon-check.js-editable", function(evt) {
                        $(this).removeClass("icon-check").addClass("icon-check-empty");
                    });

                    $("body").on("click", ".column-right-edits i.icon-check-empty.js-editable", function(evt) {
                        $(this).removeClass("icon-check-empty").addClass("icon-check");
                    });

                    $("body").on('keypress click', '.js-input, .button.js-editable', function(evt) {
                        if ((evt.type === 'keypress' && (evt.which === 13 && $(this).hasClass("js-input")))
                            || (evt.type === 'click' && $(this).hasClass("js-editable"))) {
                            var field = $(this).attr('name');
                            var value;
                            var is_json = false;
                            var edited_value = ia_data.edited[field];
                            var live_value = ia_data.live[field];
                            var $obj = $("#row-diff-" + field);

                            if ($(this).hasClass("js-input")) {
                                value = $.trim($(this).val());
                            } else if ($(this).hasClass("js-check")) {
                                value = $("#" + field + "-check").hasClass("icon-check")? 1 : 0;
                                console.log("#" + field + "-check");
                                console.log(value);
                            } else {
                                var input;
                                if (field === "dev_milestone" || field === "repo" || field === "blockgroup" || field === "deployment_state") {
                                     $input = $obj.find(".available_" + field + "s option:selected");
                                     value = $.trim($input.text());
                                     value = (value === "---")? null : value;
                                     console.log(value);
                                } else {
                                    $input = $obj.find("input.js-input,#description textarea");
                                    value = $.trim($input.val());
                                }
                            }

                            if ((evt.type === "click"
                                && (field === "topic" || field === "other_queries" || field === "triggers" || field === "perl_dependencies" || field === "src_options"))
                                || (field === "answerbar") || (field === "developer")) {
                                if (field !== "answerbar" && field !== "src_options") {
                                    value = getGroupVals(field);
                                } else if (field === "src_options") {
                                    value = {};
                                    value = getSectionVals(null, "src_options-group");
                                } else if (field === "answerbar") {
                                    value = {};
                                    value.fallback_timeout = $("#answerbar input").val();
                                }

                                value = JSON.stringify(value);
                                edited_value = JSON.stringify(ia_data.edited[field]);
                                live_value = JSON.stringify(ia_data.live[field]);
                                is_json = true;
                            }

                            if (value !== edited_value && value !== live_value) {
                                save(field, value, DDH_iaid, $obj, is_json);
                            } else {
                                $obj.replaceWith(pre_templates[field]);
                            }

                            if (evt.type === "keypress") {
                                return false;
                            }
                        }
                    });

                    // Check if username exists for the given account type (either github or duck.co)
                    function usercheck(type, username, $type, $username) {
                        var jqxhr = $.post("/ia/usercheck", {
                            type: type,
                            username: username
                        })
                        .done(function(data) {
                            var $parent =  $username.hasClass("group-vals")? $username.parent().parent() : $username.parent();
                            var $error = $parent.find(".ddgsi-warning").parent();
                            var $valid = $parent.find(".ddgsi-check-sign").parent();

                            if (data.result) {
                                $error.addClass("hide");
                                $valid.removeClass("hide");
                            } else {
                                $error.removeClass("hide");
                                $valid.addClass("hide");
                            }
                        });
                    }

                    // Autocommit multiple fields
                    // to_commit is an array of hashes,
                    // each containing field, value, is_json and parent_field (for section group fields)
                    function commitMultiple(to_commit, refresh) {
                        var field;
                        var parent_field;
                        var value;
                        var is_json;
                        refresh = refresh? true : false;

                        $.each(to_commit, function(idx, val) {
                            field = val.field;
                            value = val.value;
                            is_json = val.is_json;
                            parent_field = val.parent_field;
                            var temp_refresh = (idx === (to_commit.length - 1))? refresh : false;
                           
                            var live_data = (ia_data.live[field] && is_json)? JSON.stringify(ia_data.live[field]) : ia_data.live[field];
     
                            console.log("Inside commitMultiple... " + field + " " + value);
                            console.log("Live data: " + live_data);
                            console.log("Live data without JSON " + ia_data.live[field]);                           
                            if (field && (live_data != value)) {
                                if (parent_field) {
                                    autocommit(parent_field, value, DDH_iaid, is_json, field);
                                } else {
                                    // Ensure name has always a value
                                    if (value || (field !== "name")) {
                                        autocommit(field, value, DDH_iaid, is_json);
                                    }
                                }
                            } else if (temp_refresh && ia_data.examples_saved) {
                                // For now we're using this only for example queries
                                // so it's ok to avoid checking for the field here
                                keepUnsavedEdits("example_query");
                            } else if (!ia_data.examples_saved && (field === "example_query" || field === "other_queries")) {
                                ia_data.examples_saved = 1;
                            }
                        });
                    }

                    // Gather data needed for committing an edit and call autocommit
                    function commitEdit($editable, field, is_json) {
                        var field = field? field : "";
                        var parent_field;
                        var value;
                        var is_json = is_json? is_json : false;

                        var result = getUnsavedValue($editable, field, is_json);

                        field = result.field;
                        value = result.value;
                        is_json = result.is_json;
                        parent_field = result.parent_field;

                        var live_data = (ia_data.live[field] && is_json)? JSON.stringify(ia_data.live[field]) : ia_data.live[field];

                        console.log("After getUnsaved... " + field + " " + value);
                        console.log("Live data: " + live_data);
                        console.log("Live data without JSON " + ia_data.live[field]);
                        if (field && (live_data != value)) {
                            if (parent_field) {
                                autocommit(parent_field, value, DDH_iaid, is_json, field);
                            } else {
                                // Ensure name has always a value
                                if (value || (field !== "name")) {
                                    autocommit(field, value, DDH_iaid, is_json);
                                }
                            }
                        } else {
                            if (field === "developer" && ia_data.permissions && ia_data.permissions.admin) {
                                commitEdit($("#producer-input"));
                            } else if (!$("#ia-single--details ." + field).length) {
                                keepUnsavedEdits(field);
                            }
                        }
                    }

                    // Get a value for an editable field in the dev page
                    // This is used both for getting a value to commit
                    // and also inside keepUnsavedEdits(), for collecting each unsaved value after commit
                    // before refreshing the Handlebars templates.
                    function getUnsavedValue($editable, field, is_json) {
                        field = field? field : "";
                        var parent_field;
                        var result = {};
                        var value = is_json? JSON.stringify([]) : "";
                        is_json = is_json? is_json : false;

                        if ($editable.length) {
                            if ($editable.hasClass("group-vals")) {
                                is_json = true;
                                field = $editable.parents(".parent-group").attr("id").replace(/\-.+/, "");
                                var $obj = field === "topic"? $(".topic-group.js-autocommit option:selected") : "";
                                value = getGroupVals(field, $obj);
                                value = JSON.stringify(value);
                            } else {
                                field = $editable.attr("id").replace(/\-.+/, "");
                                var editable_type = $editable.attr("id").replace(/.+\-/, "");
                                if (editable_type === "check") {
                                    value = $editable.is(":checked")? 1 : 0;
                                } else if (editable_type === "select") {
                                    var $selected = $editable.find("option:selected");
                                    value = $selected.attr("value").length? $.trim($selected.text()) : '';
                                } else if (editable_type === "input" || editable_type === "textarea") {
                                    value = ($editable.attr("type") === "number")? parseInt($editable.val()) : $.trim($editable.val());

                                    if ($editable.hasClass("comma-separated")) {
                                        value = value.length? JSON.stringify(value.split(/\s*,\s*/)) : "[]";
                                        is_json = true;
                                    }
                                }
                            }

                            if ($editable.hasClass("section-group__item")) {
                                value = "";
                                parent_field = $.trim($editable.parents(".section-group").attr("id"));
                                var section_vals = getSectionVals($editable, parent_field);
                                console.log(parent_field + " " + field);

                                parent_field = parent_field.replace("-group", "");
                                value = section_vals? JSON.stringify(section_vals) : value;
                                is_json = true;
                            }
                        }

                        result.value = value;
                        result.is_json = is_json;
                        result.field = field;
                        result.parent_field = parent_field;

                        return result;
                    }

                    // Gets values for fields such as topic, developer, other queries
                    // which have an array of values instead of just a single value
                    function getGroupVals(field, $obj) {
                        var $selector;
                        var temp_val;
                        var value = [];

                        if ($obj && $obj.length) {
                            $selector = $obj;
                        } else {
                            if (field === "topic") {
                                $selector = $(".ia_topic .available_topics option:selected");
                            } else if ((ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated") && (field === "developer")) {
                                $selector = $(".developer_username input[type='text']");
                            } else {
                                $selector = $("." + field).children("input");
                            }
                        }

                        $selector.each(function(index) {
                            if (field === "developer") {
                                var $li_item = (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated")? $(this).parent().parent().parent() : $(this).parent().parent();

                                temp_val = {};
                                temp_val.name = $.trim($(this).val());
                                temp_val.type = $.trim($li_item.find(".available_types").find("option:selected").text()) || "legacy";
                                temp_val.username = $.trim($li_item.find(".developer_username input[type='text']").val());
                                
                                if (!temp_val.username) {
                                    return;
                                }
                            } else {
                                if (field === "topic") {
                                    temp_val = $(this).attr("value").length? $.trim($(this).text()) : "";
                                } else {
                                    temp_val = $.trim($(this).val());
                                }
                            }

                            if (temp_val && $.inArray(temp_val, value) === -1) {
                                value.push(temp_val);
                            }
                        });

                        return value;
                    }

                    // Gets values for section fields, which can contain mixed types of values,
                    // such as src_options, which has both input fields and checkboxes
                    function getSectionVals($obj, parent_field) {
                        var section_vals = {};
                        var temp_field;
                        var temp_value;

                        $("#" + parent_field + " .section-group__item").each(function(idx) {
                            if ($(this) !== $obj) {
                                if ($(this).hasClass("frm__input")
                                    || $(this).hasClass("selection-group__item-input")) {
                                    temp_field = $.trim($(this).attr("id").replace("-input", ""));
                                    temp_value = ($(this).attr("type") === "number")? parseInt($(this).val()) : $.trim($(this).val());
                                } else {
                                    temp_field = $.trim($(this).attr("id").replace("-check", ""));
                                    if ($(this).attr("checked") || $(this).hasClass("icon-check")) {
                                        temp_value = 1;
                                    } else {
                                        temp_value = 0;
                                    }
                                }

                                section_vals[temp_field] = temp_value;
                            }
                        });

                        return section_vals;
                    }

                    function resetSaved($obj) {
                        if ($obj.hasClass("not_saved")) {
                            $obj.removeClass("not_saved");
                            $obj.siblings(".error-notification").addClass("hide");
                        }
                    }

                    // After saving a field inside .ia-single--left or .ia-single--right,
                    // we need to refresh the Handlebars templates: this means that we'd lose any unsaved
                    // edits if other fields were open for editing at the same time.
                    // So before refreshing we collect all the unsaved data and we pass it to the Handlebars
                    // templates, so they will retain the unsaved data and will display those fields as editable
                    // like we left them.
                    function keepUnsavedEdits(field) {
                        var $commit_open = $(".devpage-edit.hide").parent().parent();
                        var secondary_field = "";
                        ia_data.staged = {};
                        var error_save = [];
                        var examples_done = false;
                        field = field? field : "";

                        if ((field === "example_query") || (field === "other_queries")) {
                            secondary_field = (field === "example_query")? "other_queries" : "example_query";
                        }

                        if (ia_data.examples_saved) {
                            delete ia_data.examples_saved;
                        }

                        if ($("#beta-install").hasClass("disabled")) {
                            ia_data.staged.beta = 1;
                        }

                        $commit_open.each(function(idx) {
                            var $unsaved_edits = $(this).find(".js-autocommit").first();
                            console.log($unsaved_edits.attr("class"));
                            var temp_result = getUnsavedValue($unsaved_edits);
                            var temp_field = temp_result.field;

                            if ((temp_field !== field) && (temp_field !== secondary_field)) {
                                var temp_value = temp_result.value;

                                if (temp_result.is_json && temp_value) {
                                    temp_value = $.parseJSON(temp_value);
                                } else if (!temp_value && (temp_field === "example_query") || (temp_field === "triggers")) {
                                    temp_value = "n---d";
                                }
                                
                                if (!examples_done || (temp_field !== "example_query" && temp_field !== "other_examples")) {
                                    ia_data.staged[temp_field] = temp_value;

                                    if (temp_field === "example_query") {
                                        temp_result = getUnsavedValue($(".other_queries input"), "other_queries", true);
                                        temp_value = temp_result.value? $.parseJSON(temp_result.value) : temp_result.value;

                                        ia_data.staged.other_queries = temp_value;
                                        examples_done = true;
                                    } else if (temp_field === "other_queries") {
                                        temp_result = getUnsavedValue($("#example_query-input"), "example_query");
                                        ia_data.staged.example_query = temp_result.value;

                                        examples_done = true;
                                    }
                                }

                                if ($unsaved_edits.hasClass("not_saved") && ($.inArray(temp_field, error_save) === -1)) {
                                    var temp_error = {};
                                    temp_error.field = temp_field;
                                    var $notif = $("." + temp_field).siblings(".error-notification");
                                    temp_error.msg = $notif.text()? $notif.text() : "";
                                    error_save.push(temp_error);
                                }
                            }
                        });

                        // If the submit button is visible it means at least one field
                        // in the top blue band was edited.
                        // Those fields are saved all at once when clicking on submit,
                        // and are always editable for people with permissions,
                        // so we don't know which fields have been modified and which haven't:
                        // let's just take all the current values as unsaved
                        if (!$("#js-top-details-submit").hasClass("is-disabled") && (field !== "top_details")) {
                            ia_data.staged.top_fields = {};
                            $(".top-details.js-autocommit").each(function(idx) {
                                var temp_field;
                                var temp_editable;
                                if (!$(this).hasClass("topic")) {
                                    temp_field = $(this).attr("id").replace(/\-.+/, "");
                                    temp_editable = $(this).attr("id").replace(/.+\-/, "");
                                } else {
                                    temp_field = "topic";
                                    temp_editable = "select";
                                }

                                if (!ia_data.staged.top_fields[temp_field] && (temp_field !== field)) {
                                    temp_result = getUnsavedValue($(this), field, temp_editable);
                                    temp_value = temp_field === "topic"? $.parseJSON(temp_result.value) : temp_result.value;

                                    ia_data.staged.top_fields[temp_field] = temp_value;
                                }
                            });
                        }

                        // If the details commit button is visible it means at least one field
                        // in the details section was edited.
                        // These fields have the same behaviour as the blue band fields, too,
                        // so we perform the same actions for them as well
                        if (!$("#devpage-commit-details").hasClass("hide") && (field !== "details")) {
                            ia_data.staged.details = {};
                            var section_done = false;
                            var $details = $("#ia-single--details .js-autocommit");

                            $details.each(function(idx) {
                                if ((!section_done) || (!$(this).hasClass("section-group__item"))) {
                                    if ($(this).hasClass("section-group__item")) {
                                        section_done = true;
                                    }
                                    
                                    var temp_result = getUnsavedValue($(this));
                                    var temp_field = temp_result.field;
                                    var temp_parent = temp_result.parent_field;

                                    if ((temp_field !== field) && (temp_field !== secondary_field)) {
                                        var temp_value = temp_result.value;

                                        if (temp_result.is_json && temp_value) {
                                            temp_value = $.parseJSON(temp_value);
                                        }

                                        ia_data.staged.details[temp_field] = temp_parent? temp_value[temp_field] : temp_value;
                                    }

                                }
                            });

                        }

                        if (ia_data.live.test_machine && ia_data.live.example_query && ia_data.permissions.can_edit) {
                            ia_data.can_show = 1;
                        } else {
                             ia_data.can_show = 0;
                        }

                        page.updateHandlebars(readonly_templates, ia_data, ia_data.live.dev_milestone, false);
                        page.updateAll(readonly_templates, ia_data, false);

                        Screens.render();

                        $commit_open.find(".devpage-edit").trigger("click");

                        $.each(error_save, function(idx, val) {
                            $("." + val.field).addClass("not_saved");
                            var $error_msg = $("." + val.field).siblings(".error-notification");
                            $error_msg.removeClass("hide").text(val.msg);
                        });
                    }

                    //Install pr on beta
                    function beta_install(pr) {
                        var prs = [pr];
                        var jqxhr = $.post("/ia/send_to_beta", {
                            data : JSON.stringify(prs)
                        })
                        .done(function (data) {
                            if (!ia_data.staged) {
                                ia_data.staged = {};
                            }
                                
                            ia_data.staged.beta = 1;
                        });
                    }
                    function create_task(id) {
                        var jqxhr = $.post("/ia/asana", {
                            id : id
                        })
                        .done(function(data) {
                        });
                    }

                    // Saves values for editable fields on the dev page
                    function autocommit(field, value, id, is_json, subfield) {
                        var jqxhr = $.post("/ia/save", {
                            field : field,
                            value : value,
                            id : id,
                            autocommit: 1
                        })
                        .done(function(data) {
                            subfield = subfield? subfield : "";
                            if (data.result) {
                                if (data.result.saved) {
                                    if (field === "dev_milestone" && data.result[field] === "live") {
                                        location.reload();
                                    } else if (field === "id" || data.result.id) {
                                        location.href = "/ia/view/" + data.result.id;
                                    } else {
                                        ia_data.live[field] = (is_json && data.result[field])? $.parseJSON(data.result[field]) : data.result[field];
                                        if ((field === "developer" && ia_data.permissions && ia_data.permissions.admin)
                                            || ($("#ia-single--details ." + field).length || (subfield && $("#ia-single--details ." + subfield).length))
                                            || ((field === "example_query" || field === "other_queries") && (!ia_data.examples_saved))) {
                                             if (field === "example_query" || field === "other_queries") {
                                                 ia_data.examples_saved = 1;
                                             }
                                             
                                             page.updateHandlebars(readonly_templates, ia_data, ia_data.live.dev_milestone, false);
                                        } else {
                                            console.log("CALLING keepUnsavedEdits " + field + " " + ia_data.live[field]);
                                            keepUnsavedEdits(field);
                                        }
                                    }
                                } else {
                                    $("." + field).addClass("not_saved");
                                    var $error_msg = $("." + field).siblings(".error-notification");
                                    $error_msg.removeClass("hide");
                                    $error_msg.text(data.result.msg);
                                }

                                if (field === "developer" && ia_data.permissions && ia_data.permissions.admin) {
                                    commitEdit($("#producer-input"));
                                }
                            }
                        });
                    }

                    function save(field, value, id, $obj, is_json) {
                        var jqxhr = $.post("/ia/save", {
                            field : field,
                            value : value,
                            id : id,
                            autocommit: 0
                        })
                        .done(function(data) {
                            console.log(data);
                            if (data.result && data.result.staged) {
                                console.log(data.result);
                                if (data.result.is_admin) {
                                    if ($("#view_commits").hasClass("hide")) {
                                        $("#view_commits").removeClass("hide");
                                    }
                                }

                                if (is_json) {
                                    ia_data.edited[field] = $.parseJSON(data.result[field]);
                                } else {
                                    ia_data.edited[field] = data.result[field];
                                }

                                pre_templates[field] = Handlebars.templates['pre_edit_' + field](ia_data);

                                $obj.replaceWith(pre_templates[field]);
                            } else {
                                if ($("#error").hasClass("hide")) {
                                    $("#error").removeClass("hide");
                                }
                            }
                        });
                    }
                });
            }
        },

        imgHide: false,

        field_order: [
            'description',
            'examples',
            'screens',
            'github',
            'triggers',
            'advanced',
            'test'
        ],

        edit_field_order: [
            'name',
            'status',
            'description',
            'repo',
            'topic',
            'example_query',
            'other_queries',
            'perl_module',
            'template',
            'src_api_documentation',
            'api_status_page',
            'src_id',
            'src_name',
            'src_domain',
            'is_stackexchange',
            'src_options',
            'unsafe',
            'answerbar',
            'triggers',
            'perl_dependencies'
        ],

        updateHandlebars: function(templates, ia_data, dev_milestone, staged) {
            var latest_edits_data = {};
            latest_edits_data = this.updateData(ia_data, latest_edits_data, staged);

            $.each(templates.live, function(key, val) {
                templates.live[key] = Handlebars.templates[key](latest_edits_data);
            });

            templates.screens = Handlebars.templates.screens(ia_data);
        },

        updateData: function(ia_data, x, edited) {
            var edited_fields = 0;
            $.each(ia_data.live, function(key, value) {
                if (edited && ia_data.edited && ia_data.edited[key] && (key !== "id") && (key !== "dev_milestone")) {
                    x[key] = ia_data.edited[key];
                    edited_fields++;
                } else {
                    x[key] = value;
                }
            });

            $.each(ia_data, function(key, value) {
                if (key !== "live" && key !== "edited") {
                    x[key] = value;
                }
            });

            if (edited && edited_fields === 0 &&
                (ia_data.live.dev_milestone === "live" || ia_data.live.dev_milestone === "deprecated")) {
                $(".special-permissions__toggle-view").hide();
            }

            console.log(x);

            return x;
        },

        appendTopics: function($obj) {
            if ($obj.length) {
                $obj.append($("#allowed_topics").html());

                this.hideDupes($obj);
            }
        },

        appendBlockgroup: function($obj) {
            if ($obj.length) {
                $obj.append($("#allowed_blockgroups").html());

                this.hideDupes($obj);
            }
        },

        // Hide duplicated dropdown values
        hideDupes: function($obj) {
                $obj.each(function(idx) {
                    $first_opt = $(this).find('option[value="0"]');
                    var opt_0 = $.trim($first_opt.text()) || '';
                    $(this).find("option").each(function(id) {
                        if ($(this) !== $first_opt && $.trim($(this).text()) === opt_0) {
                            $(this).hide();
                        }
                    });

                    if (!opt_0)  {
                        $first_opt.hide();
                    } else {
                        $first_opt.show();
                    }
                });
        },

        hideAssignToMe: function() {
            // If one or more team fields has the current user's name as value,
            // hide the 'assign to me' button accordingly
            var current_user = $.trim($(".header-account-info .user-name").text());
            $(".team-input").each(function(idx) {
                if ($(this).val() === current_user) {
                    $("#" + $.trim($(this).attr("id").replace("-input", "")) + "-button").hide();
                    $(this).css({width: "100%"});
                }
            });
        },

        updateAll: function(templates, ia_data, edit) {
            var dev_milestone = ia_data.live.dev_milestone;

            if (!edit) {
                $(".ia-single--name").remove();

                $("#ia-single-top-name").html(templates.live.name);
                $('#ia-breadcrumbs').html(templates.live.breadcrumbs);
                $("#ia-single-top-details").html(templates.live.top_details);
                $('.edit-container').html(templates.live.edit_buttons);
                $(".ia-single--left, .ia-single--right").show().empty();

                for (var i = 0; i < this.field_order.length; i++) {
                    $(".ia-single--left").append(templates.live[this.field_order[i]]);

                    if (this.field_order[i] === "examples") {
                        $(".ia-single--left").append(templates.screens);
                    }
                }

                $(".ia-single--right").append(templates.live.devinfo);

                $(".show-more").click(function(e) {
                    e.preventDefault();

                    if($(".ia-single--info li").hasClass("hide")) {
                        $(".ia-single--info li").removeClass("hide");
                        $("#show-more--link").text("Show Less");
                        $(".ia-single--info").find(".ddgsi").removeClass("ddgsi-chev-down").addClass("ddgsi-chev-up");
                    } else {
                        $(".ia-single--info li.extra-item").addClass("hide");
                        $("#show-more--link").text("Show More");
                        $(".ia-single--info").find(".ddgsi").removeClass("ddgsi-chev-up").addClass("ddgsi-chev-down");
                    }
                });

                if (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated") {
                    this.appendTopics($(".topic-group.js-autocommit"));
                }
            } else {
                $("#ia-single-top").attr("id", "ia-single-top--edit");
                $("#ia-single-top-name, #ia-single-top-details, .ia-single--left, .ia-single--right, .edit-container, #ia-breadcrumbs").hide();
                $(".special-permissions .btn--wire--hero").removeClass("btn--wire--hero").addClass("button");
                $(".ia-single--edits").removeClass("hide");
                for (var i = 0; i < this.edit_field_order.length; i++) {
                    $(".ia-single--edits").append(templates[this.edit_field_order[i]]);
                }

                // Only admins can edit these fields
                if ($("#view_commits").length) {
                    $(".ia-single--edits").append(templates.dev_milestone);
                    $(".ia-single--edits").append(templates.producer);
                    $(".ia-single--edits").append(templates.designer);
                    $(".ia-single--edits").append(templates.developer);
                    $(".ia-single--edits").append(templates.tab);
                    $(".ia-single--edits").append(templates.id);
                    $(".ia-single--edits").append(templates.blockgroup);
                    $(".ia-single--edits").append(templates.deployment_state);
                }
            }

            // Make sure to update the widths of the topics.
            $("select.top-details.js-autocommit").each(function() {
                if($(this).hasClass("topic")) {
                    $(this).parent().css("width", dropdownLength($.trim($(this).children("option:selected").text()), 1) + "px");
                } else {
                    $(this).parent().css("width", dropdownLength($.trim($(this).children("option:selected").text())) + "px");
                }
            });
        }
    };

})(DDH);
