(function(env) {
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
                    if ($(".special-permissions").length) {
                        ia_data.permissions = {can_edit: 1};

                        // Preview switch must be on "edited" by default
                        ia_data.preview = 1;

                        ia_data.edit_count = ia_data.edited ? Object.keys(ia_data.edited).length : 0;

                        if ($("#view_commits").length) {
                            ia_data.permissions.admin = 1;
                        }
                    }

                    if(ia_data.live.test_machine && ia_data.live.example_query) {
                        ia_data.live.can_show = true;
                    }

                    // Allow blue band to get 100% page width
                    if (ia_data.live.dev_milestone === "live" || ia_data.live.dev_milestone === "deprecated") {
                        $(".site-main > .content-wrap").first().removeClass("content-wrap");
                        $(".breadcrumb-nav").remove();
                    }

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
                            breadcrumbs: Handlebars.templates.breadcrumbs(latest_edits_data)
                        },
                        screens : Handlebars.templates.screens(ia_data),
                        metafields : Handlebars.templates.metafields(ia_data),
                        metafields_content : Handlebars.templates.metafields_content(ia_data),
                        contributors : Handlebars.templates.contributors(ia_data),
                        contributors_content : Handlebars.templates.contributors_content(ia_data),
                        advanced : Handlebars.templates.advanced(ia_data),
                        advanced_content : Handlebars.templates.advanced_content(ia_data),
                        testing : Handlebars.templates.testing(ia_data),
                        testing_content : Handlebars.templates.testing_content(ia_data),
                        base_info : Handlebars.templates.base_info(ia_data),
                        base_info_content : Handlebars.templates.base_info_content(ia_data)
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
                        id : Handlebars.templates.pre_edit_id(ia_data)
                    };

                    page.updateAll(readonly_templates, ia_data, false);

                    $('body').on("click", "#show-all-issues", function(evt) {
                        $(this).hide();
                        $(".ia-issues ul li").show();
                    });

                    $("#view_json").click(function(evt) {
                        location.href = json_url;
                    });

                    $('body').on("change keypress focusout", ".available_types, .developer_username input", function(evt) {
                        if ((evt.type === "change" && $(this).hasClass("available_types")) || (evt.type === "keypress" && evt.which === 13)
                             || (evt.type === "focusout" && $(this).hasClass("focused"))) {
                            var $available_types;
                            var $dev_username;
                            var $parent;

                            if (evt.type !== "change" || (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated")) {
                                $parent = $(this).parent().parent();
                                $available_types = $parent.find(".available_types");
                                $dev_username = $parent.find(".developer_username input");
                            } else {
                                $parent =  $(this).parent();
                                $available_types = $parent.find(".available_types");
                                $dev_username = $parent.find(".developer_username input");
                            }

                            if ($(this).hasClass("focused")) {
                                $(this).removeClass("focused");
                            }

                            var type = $.trim($available_types.find("option:selected").text());
                            var username = $.trim($dev_username.val());

                            if (username && type) {
                                usercheck(type, username, $available_types, $dev_username);
                            }
                        }
                    });

                    $('body').on("focusin", ".developer_username input", function(evt) {
                        if (!$(this).hasClass("focused")) {
                            $(this).addClass("focused");
                        }
                    });

                    $("#toggle-devpage-static").click(function(evt) {
                        if (!$(this).hasClass("disabled")) {
                            ia_data.permissions.can_edit = 0;
                            ia_data.permissions.admin = 0;

                            page.updateHandlebars(readonly_templates, ia_data, ia_data.live.dev_milestone);
                            page.updateAll(readonly_templates, ia_data, false);

                            Screens.render();

                            $(".button-nav-current").removeClass("disabled").removeClass("button-nav-current");
                            $(this).addClass("disabled").addClass("button-nav-current");
                        }
                    });

                    $("#toggle-devpage-editable").click(function(evt) {
                        if (!$(this).hasClass("disabled")) {
                            ia_data.permissions.can_edit = 1;
                            ia_data.permissions.admin = $("#view_commits").length? 1 : 0;

                            page.updateHandlebars(readonly_templates, ia_data, ia_data.live.dev_milestone);
                            page.updateAll(readonly_templates, ia_data, false);

                            Screens.render();

                            $(".button-nav-current").removeClass("disabled").removeClass("button-nav-current");
                            $(this).addClass("disabled").addClass("button-nav-current");
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
                        return str.charAt(0).toUpperCase() + str.slice(1);
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
                                selector: '.screenshot-switcher .icon-extra-mobile',
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
                                selector: '.screenshot-switcher .icon-extra-desktop',
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
                                $('.screenshot-switcher .icon-extra-desktop').parent().addClass('remove-border');
                                $('.screenshot-switcher .icon-extra-mobile').parent().removeClass('remove-border');

                                $('.screenshot-switcher .icon-extra-mobile').removeClass('add-opacity');
                                $('.screenshot-switcher .icon-extra-desktop').addClass('add-opacity');
                            } else {
                                $('.screenshot-switcher .icon-extra-desktop').parent().removeClass('remove-border');
                                $('.screenshot-switcher .icon-extra-mobile').parent().addClass('remove-border');

                                $('.screenshot-switcher .icon-extra-mobile').addClass('add-opacity');
                                $('.screenshot-switcher .icon-extra-desktop').removeClass('add-opacity');
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
                            $('.generate-screenshot').show();
                            this.setEvent(this.events.refreshClick);

                            $('.screenshot-switcher--generate').hide();
                        },
                        setTakeScreenshotButton: function() {
                            $('.screenshot-switcher').hide();
                            $('.screenshot-switcher--generate').show();

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

                    $("body").on('click', ".dev_milestone-container__body__div__checkbox.js-autocommit", function(evt) {
                        var field = $.trim($(this).attr("id").replace("-check", ""));
                        var value;
                        var is_json = false;
                        var panel = $.trim($(this).attr("data-panel"));

                        resetSaved($(this));

                        if ($(this).hasClass("icon-check-empty")) {
                            value = 1;
                            $(this).removeClass("icon-check-empty").addClass("icon-check");
                        } else {
                            value = 0;
                            $(this).removeClass("icon-check").addClass("icon-check-empty");
                        }

                        if (field.length) {
                            if ($(this).hasClass("section-group__item")) {
                                var parent_field = $.trim($(this).parent().parent().attr("id"));
                                var section_vals = getSectionVals($(this), parent_field);

                                section_vals[field] = value;

                                parent_field = parent_field.replace("-group", "");
                                value = JSON.stringify(section_vals);
                                is_json = true;

                                autocommit(parent_field, value, DDH_iaid, is_json, panel, field);
                            }

                            autocommit(field, value, DDH_iaid, is_json, panel);
                        }
                    });

                    $("body").on("change", 'input[type="number"].js-autocommit', function(evt) {
                        if (!$(this).hasClass("js-autocommit-focused")) {
                            $(this).focus();
                        }

                        resetSaved($(this));
                    });

                    $("body").on("focusin", "textarea.js-autocommit, input.js-autocommit", function(evt) {
                        if (!$(this).hasClass("js-autocommit-focused")) {
                            $(this).addClass("js-autocommit-focused");
                        }

                        resetSaved($(this));
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

                    $("body").on('change', "select.js-autocommit", function(evt) {
                        var field;
                        var value;
                        var is_json = false;
                        var panel = $.trim($(this).attr("data-panel"));
                        var $selected = $(this).find("option:selected");

                        if ($(this).hasClass("topic-group")) {
                           var $selector = $("select.js-autocommit.topic-group option:selected");

                           value = [];
                           field = "topic";
                           value = getGroupVals(field, $selector);
                           value = JSON.stringify(value);
                           is_json = true;
                        } else {
                           field = $.trim($(this).attr("id").replace("-select", ""));
                           value = $selected.attr("value").length? $.trim($selected.text()) : '';
                        }

                        if (field.length && value !== ia_data.live[field]) {
                             autocommit(field, value, DDH_iaid, is_json, panel);
                        }
                    });

                    $("body").on('keypress focusout', "textarea.js-autocommit-focused, input.js-autocommit-focused", function(evt) {
                        if ((evt.type === 'keypress' && evt.which === 13) || (evt.type === "focusout")) {
                            var field;
                            var value = $.trim($(this).val());
                            var id = $.trim($(this).attr("id"));
                            var is_json = false;
                            var panel = $.trim($(this).attr("data-panel"));

                            if (id.match(/.*-input/)) {
                                field = id.replace("-input", "");
                            } else {
                                field = id.replace("-textarea", "");
                            }

                            if ($(this).hasClass("comma-separated") && value.length) {
                                value = value.split(/\s*,\s*/);

                                if (field === "developer") {
                                    var dev_array = [];

                                    $.each(value, function(idx, val) {
                                        var temp_dev = {};
                                        temp_dev.username = val.replace(/.*\/([^\/]*)$/,'$1');
                                        temp_dev.type = val.match(/github/)? 'github' : 'duck.co';

                                        if (temp_dev.type && temp_dev.username && $.inArray(temp_dev, dev_array) === -1) {
                                            dev_array.push(temp_dev);
                                        }
                                    });

                                    value = dev_array;
                                }

                                value = JSON.stringify(value);
                                is_json = true;
                            }

                            if (field.length && value !== ia_data.live[field]) {
                                if ($(this).hasClass("section-group__item")) {
                                    var parent_field = $.trim($(this).parent().parent().attr("id"));
                                    var section_vals = getSectionVals($(this), parent_field);
                                    section_vals[field] = value;

                                    parent_field = parent_field.replace("-group", "");
                                    value = JSON.stringify(section_vals);
                                    is_json = true;

                                    autocommit(parent_field, value, DDH_iaid, is_json, panel, field);
                                }

                                autocommit(field, value, DDH_iaid, is_json, panel);
                            }

                            if (evt.type === 'keypress') {
                                $(this).blur();
                            }

                            $(this).removeClass("js-autocommit-focused");
                        }
                    });

                    $("body").on('click', ".dev_milestone-container__body__button.js-autocommit", function(evt) {
                        var field = $.trim($(this).attr("id").replace("-button", ""));
                        var value = $.trim($(".header-account-info .user-name").text());
                        var is_json = false;
                        var panel = $.trim($(this).attr("data-panel"));

                        $(this).hide();

                        if (field.length && value.length) {
                            autocommit(field, value, DDH_iaid, is_json, panel);
                        }
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
                        }
                    });

                    $("#edit_disable").on('click', function(evt) {
                        location.reload();
                    });

                    $("body").on('click', '.add_input', function(evt) {
                        var $ul = $(this).closest('ul');
                        var $new_input = $ul.find('.new_input').first().clone();
                        var $last_li = $ul.children('li').last();
                        $last_li.before($new_input.removeClass("hide"));
                    });

                    $("body").on('click', '#add_topic', function(evt) {
                        $(this).addClass("hide");
                        $("#add_topic_select").removeClass("hide");
                    });

                    $("body").on('click', '#view_commits', function(evt) {
                        window.location = "/ia/commit/" + DDH_iaid;
                    });

                    $("body").on("click", ".button.delete", function(evt) {
                        var field = $(this).attr('name');

                        // If dev milestone is not 'live' it means we are in the dev page
                        // and a topic has been deleted (it's the only field having a delete button in the dev page
                        // so far) - so we must save
                        if ($(this).hasClass("js-autocommit") || $(this).parent().hasClass("js-autocommit")) {
                            var value = [];
                            var is_json = true;
                            var panel = $.trim($(this).attr("data-panel"));
                            var temp;
                            var $selector;
                            var $parent = $(this).parent();

                            if (field === "topic") {
                                var $select = $parent.find('.topic-group');
                                $select.find('option[value="0"]').empty();
                                $select.val('0');

                                $selector = $("select.js-autocommit.topic-group option:selected");
                            } else {
                                $(this).parent().remove();
                            }

                            value = getGroupVals(field, $selector);
                            value = JSON.stringify(value);

                            if (field.length && value.length) {
                                autocommit(field, value, DDH_iaid, is_json, panel);
                            }
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
                            } else {
                                var input;
                                if (field === "dev_milestone" || field === "repo") {
                                     $input = $obj.find(".available_" + field + "s option:selected");
                                     value = $.trim($input.text());
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

                    function usercheck(type, username, $type, $username) {
                        var jqxhr = $.post("/ia/usercheck", {
                            type: type,
                            username: username
                        })
                        .done(function(data) {
                            if (data.result) {
                                $type.parent().removeClass("invalid");
                                $username.parent().removeClass("invalid");
                                if (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated") {
                                    var field = "developer";
                                    var value = getGroupVals(field);
                                    var is_json = true;
                                    var panel = "contributors";

                                    value = JSON.stringify(value);

                                    if (field.length && value !== ia_data.live[field]) {
                                        autocommit(field, value, DDH_iaid, is_json, panel);
                                    }
                                }
                            } else {
                                $type.parent().addClass("invalid");
                                $username.parent().addClass("invalid");
                            }
                        });
                    }

                    function getGroupVals(field, $obj) {
                        var $selector;
                        var temp_val;
                        var value = [];

                        if ($obj) {
                            $selector = $obj;
                        } else {
                            $selector = (field === "topic")? $(".ia_topic .available_topics option:selected") : $("." + field + " input");
                        }

                        $selector.each(function(index) {
                            if (field === "developer") {
                                var $li_item = $(this).parent().parent();

                                temp_val = {};
                                temp_val.name = $.trim($(this).val());
                                temp_val.type = $.trim($li_item.find(".available_types").find("option:selected").text()) || "legacy";
                                temp_val.username = $.trim($li_item.find(".developer_username input").val());

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

                    function getSectionVals($obj, parent_field) {
                        var section_vals = {};
                        var temp_field;
                        var temp_value;

                        $("#" + parent_field + " .section-group__item").each(function(idx) {
                            if ($(this) !== $obj) {
                                if ($(this).hasClass("dev_milestone-container__body__input")
                                    || $(this).hasClass("selection-group__item-input")) {
                                    temp_field = $.trim($(this).attr("id").replace("-input", ""));
                                    temp_value = $.trim($(this).val());

                                    if ($(this).attr("type") === "number") {
                                        temp_value = parseInt(temp_value);
                                    }
                                } else {
                                    temp_field = $.trim($(this).attr("id").replace("-check", ""));
                                    if ($(this).hasClass("icon-check-empty")) {
                                        temp_value = 0;
                                    } else {
                                        temp_value = 1;
                                    }
                                }

                                section_vals[temp_field] = temp_value;
                            }
                        });

                        return section_vals;
                    }

                    function resetSaved($obj) {
                        if ($obj.hasClass("saved")) {
                            $obj.removeClass("saved");
                        } else if ($obj.hasClass("not_saved")) {
                            $obj.removeClass("not_saved");
                        }
                    }

                    function autocommit(field, value, id, is_json, panel, subfield) {
                        var jqxhr = $.post("/ia/save", {
                            field : field,
                            value : value,
                            id : id,
                            autocommit: 1
                        })
                        .done(function(data) {
                            if (data.result) {
                                if (data.result.saved && (field === "repo" ||
                                    (field === "dev_milestone" && data.result[field] === "live"))) {
                                    location.reload();
                                } else if (data.result.saved && field === "id") {
                                    location.href = "/ia/view/" + data.result.id;
                                } else {
                                    ia_data.live[field] = (is_json && data.result[field])? $.parseJSON(data.result[field]) : data.result[field];
                                    var saved_class = data.result.saved? "saved" : "not_saved";

                                    if (field === "name" || field === "dev_milestone") {
                                        $(".ia-single--name").remove();
                                        $("#metafields").remove();
                                        latest_edits_data = page.updateData(ia_data, latest_edits_data, false);
                                        readonly_templates.live.name = Handlebars.templates.name(latest_edits_data);
                                        $(".ia-single--wide").before(readonly_templates.live.name);
                                        $(".ia-single--wide").before(readonly_templates.metafields);
                                        $("#metafields").html(readonly_templates.metafields_content);

                                        $(".ia-single--name ." + field).addClass(saved_class);
                                    } else {
                                        Screens.render();

                                        readonly_templates[panel + "_content"] = Handlebars.templates[panel + "_content"](ia_data);

                                        var $panel_body = $("#" + panel);
                                        $panel_body.html(readonly_templates[panel + "_content"]);

                                        page.appendTopics($(".topic-group"));
                                        page.hideAssignToMe();

                                        // Developer field is already highlighted in green
                                        // when the user check is successful
                                        if (field !== "developer") {
                                            field = subfield? subfield : field;
                                            $panel_body.find("." + field).addClass(saved_class);
                                        }
                                    }
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
                            if (data.result && data.result[field]) {
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
            'github'
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

        dev_milestones_order: [
            'base_info',
            'contributors',
            'screens',
            'testing',
            'advanced'
        ],

        updateHandlebars: function(templates, ia_data, dev_milestone, staged) {
            var latest_edits_data = {};
            latest_edits_data = this.updateData(ia_data, latest_edits_data, staged);

            if (dev_milestone === 'live') {
                $.each(templates.live, function(key, val) {
                    templates.live[key] = Handlebars.templates[key](latest_edits_data);
                });
            } else {
                templates.live.name = Handlebars.templates.name(latest_edits_data);
                templates.metafields = Handlebars.templates.metafields(ia_data);
                templates.metafields_content = Handlebars.templates.metafields_content(ia_data);
                for (var i = 0; i < this.dev_milestones_order.length; i++) {
                    var template = this.dev_milestones_order[i];
                    templates[template] = Handlebars.templates[template](ia_data);

                    if (template !== "screens") {
                        templates[template + "_content"] = Handlebars.templates[template + "_content"](ia_data);
                    }
                }
            }
        },

        updateData: function(ia_data, x, edited) {
            var edited_fields = 0;
            $.each(ia_data.live, function(key, value) {
                if (edited && ia_data.edited && ia_data.edited[key] && (key !== "id")) {
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

            if (edited && edited_fields === 0) {
                $(".special-permissions__toggle-view").hide();
            }

            return x;
        },

        appendTopics: function($obj) {
            if ($obj.length) {
                $obj.append($("#allowed_topics").html());

                // Hide duplicated dropdown values
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
            }
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

                if (dev_milestone === "live" || dev_milestone === "deprecated") {
                    $("#ia-single-top-name").html(templates.live.name);
                    $('#ia-breadcrumbs').html(templates.live.breadcrumbs);
                    $("#ia-single-top-details").html(templates.live.top_details);
                    $('.edit-container').html(templates.live.edit_buttons);
                    $(".ia-single--left, .ia-single--right").show().empty();

                    for (var i = 0; i < this.field_order.length; i++) {
                        $(".ia-single--left").append(templates.live[this.field_order[i]]);
                    }

                    $(".ia-single--left .ia-issues").before(templates.screens);
                    $(".ia-single--right").append(templates.live.devinfo);
                    $(".ia-single--screenshots").removeClass("twothirds");
                } else {
                    $(".ia-single--wide").before(templates.live.name);

                    $("#metafields").remove();
                    $(".ia-single--wide").before(templates.metafields);
                    $("#metafields").html(templates.metafields_content);

                    $(".ia-single--wide").empty();

                    var $temp_panel_body;
                    for (var i = 0; i < this.dev_milestones_order.length; i++) {
                        var template = this.dev_milestones_order[i];
                        $(".ia-single--wide").append(templates[template]);

                        if (template !== 'screens') {
                            $temp_panel_body = $("#" + template);
                            $temp_panel_body.html(templates[template + "_content"]);
                        }
                    }

                    this.appendTopics($(".topic-group"));
                    this.hideAssignToMe();
                }

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
                }
            }
        }
    };

})(DDH);
