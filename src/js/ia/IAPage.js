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

                    // Show latest edits for admins and users with edit permissions
                    var latest_edits_data = {};
                    if (ia_data.edited) {
                        latest_edits_data = page.updateData(ia_data, latest_edits_data, true);
                    } else {
                        latest_edits_data = ia_data.live;
                    }


                    if ($(".special-permissions").length) {
                        ia_data.permissions = {can_edit: 1};
                            
                        if ($("#view_commits").length) {
                            ia_data.permissions.admin = 1;
                        }
                    }

                    // Readonly mode templates
                    var readonly_templates = {
                        live: {
                            name : Handlebars.templates.name(ia_data),
                            status : Handlebars.templates.status(latest_edits_data),
                            description : Handlebars.templates.description(latest_edits_data),
                            topic : Handlebars.templates.topic(latest_edits_data),
                            template : Handlebars.templates.template(latest_edits_data),
                            examples : Handlebars.templates.examples(latest_edits_data),
                            devinfo : Handlebars.templates.devinfo(latest_edits_data),
                            github: Handlebars.templates.github(latest_edits_data)
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

                    page.updateAll(readonly_templates, ia_data.live.dev_milestone, false);

                    $("#view_json").click(function(evt) {
                        location.href = json_url;
                    });

                    $('body').on("change keypress focusout", ".available_types, .developer_username input", function(evt) {
                        if ((evt.type === "change" && $(this).hasClass("available_types")) || (evt.type === "keypress" && evt.which === 13)
                             || (evt.type === "focusout" && $(this).hasClass("focused"))) {
                            var $available_types;
                            var $dev_username;
                            var $parent;

                            if (evt.type !== "change") {
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

                            usercheck(type, username, $available_types, $dev_username);

                            if ($parent.hasClass("js-autocommit")) {
                                var field = "developer";
                                var value = getGroupVals(field);
                                var is_json = true;
                                var panel = $(this).attr("data-panel");

                                value = JSON.stringify(value);

                                if (field.length && value !== ia_data.live[field]) { 
                                    autocommit(field, value, DDH_iaid, is_json, panel);
                                }
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
                            page.updateAll(readonly_templates, ia_data.live.dev_milestone, false);

                            $(".button-nav-current").removeClass("disabled").removeClass("button-nav-current");
                            $(this).addClass("disabled").addClass("button-nav-current");
                        }
                    });

                    $("#toggle-devpage-editable").click(function(evt) {
                        if (!$(this).hasClass("disabled")) {
                            ia_data.permissions.can_edit = 1;
                            ia_data.permissions.admin = 1;

                            page.updateHandlebars(readonly_templates, ia_data, ia_data.live.dev_milestone);
                            page.updateAll(readonly_templates, ia_data.live.dev_milestone, false);

                            $(".button-nav-current").removeClass("disabled").removeClass("button-nav-current");
                            $(this).addClass("disabled").addClass("button-nav-current");
                        }
                    });

                    $("#edit_activate").on('click', function(evt) {
                        page.updateAll(pre_templates, ia_data.live.dev_milestone, true);
                        $("#edit_disable").removeClass("hide");
                        $(this).hide();
                        $(".special-permissions__toggle-view").hide();
                    });

                    page.hideScreenshot = (function(ia_data) {
                        return function() {
                            $(".ia-single--image-container img").error(function() {
                                // Show the dashed border if the image errored out and we have permissions.
                                if(ia_data.permissions && ia_data.permissions.can_edit) {
                                    $(".ia-single--screenshots").addClass("hide");
                                    $(".generate-screenshot").addClass("dashed-border");

                                    page.removeMaxHeight($(".milestone-panel"));
                                } else {
                                    // Display default image if we found the live image.
                                    if(ia_data.live && ia_data.live.dev_milestone === "live") {
                                        $(".ia-single--screenshots").removeClass("hide");
                                        $(".ia-single--image-container img").attr("src",  "https://images.duckduckgo.com/iu/?u=" + encodeURIComponent("http://ia-screenshots.s3.amazonaws.com/default_index.png"));
                                    } else {
                                        $(".ia-single--screenshots").addClass("hide");

                                        $(".generate-screenshot").hide();
                                    }                            
                                }

                                if (ia_data.live.dev_milestone !== "live" && ia_data.live.dev_milestone !== "deprecated"
                                    && (!ia_data.permissions.can_edit) && (!ia_data.permissions.admin)) {
                                    page.imgHide = true;
                                    $(".button.js-expand").hide();
                                }
                            });
                        };
                    }(ia_data));

                    page.hideScreenshot();

                    function setNotification(message) {
                        var $notif = $(".generate-screenshot--notif");
                        // Send notification.
                        $notif.text(message);
                        
                        // Revert button to its original state.
                        // Add a little delay.
                        setTimeout(function() {
                            $(".generate-screenshot--button").text("Generate Screenshot");
                            $notif.text("");
                        }, 1500);
                    }

                    // Saves the screenshot to S3.
                    $("body").on("click", ".save-screenshot--button", function(evt) {
                        $.post("https://ranger.duckduckgo.com/screenshot/save/" + DDH_iaid, function(data) {
                            // Check if the request was successful.
                            if(data && data.status === "ok" && data.screenshots && data.screenshots.index) {
                                // Hide the save button.
                                $(".save-screenshot--button").addClass("hide");
                                // Put in the image from S3.
                                $(".ia-single--image-container img").attr("src", "https://images.duckduckgo.com/iu/?u=" + encodeURIComponent(data.screenshots.index));
                            } else {
                                setNotification(data.status);
                            }
                        });
                    });
                    
                    // Check if the IA has a test machine or is live.
                    // If so, enable the screenshot button.
                    var test_machine = ia_data.live.test_machine;
                    var example_query = ia_data.live.example_query;
                    function enableScreenshotButton() {
                        var $generate_screenshot = $(".generate-screenshot--button");
                        if((test_machine && example_query) || ia_data.live.dev_milestone === "live") {
                            $generate_screenshot.removeClass("generate-screenshot--disabled");
                        } else {
                            $generate_screenshot.addClass("generate-screenshot--disabled");
                        }
                    }
                    enableScreenshotButton();

                    // Generate a screenshot when the button is clicked.
                    $("body").on("click", ".generate-screenshot--button", function(evt) {
                        // If it's disabled, do nothing.
                        if($(this).hasClass("generate-screenshot--disabled")) {
                            return;
                        }

                        var $button =  $(".generate-screenshot--button");
                        $button.text("Generating ...");

                        // Send a POST request with the ID of the IA.
                        $.post("https://ranger.duckduckgo.com/screenshot/create/" + DDH_iaid, function(data) {
                            // Check if the screenshot that we want is available.
                            // If it isn't there must be something wrong.
                            if(data && data.status === "ok" && data.screenshots && data.screenshots.index) {
                                $button.text("Generate Screenshot");
                                $(".save-screenshot--button").removeClass("hide");

                                // Show preview image.
                                $(".ia-single--image-container img").attr("src", data.screenshots.index);
                                $(".ia-single--screenshots").show();
                                $(".generate-screenshot").removeClass("dashed-border");
                            } else {
                                $button.text("Generate Screenshot");
                                setNotification(data.status);
                            }
                        }).error(function() {
                            setNotification("Screenshot service is down.");
                        });
                    });
                    
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
                               
                                field = parent_field.replace("-group", "");
                                value = JSON.stringify(section_vals);
                                is_json = true;
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
                            value = [];
                            var temp;
                            $("select.js-autocommit.topic-group").each(function(idx) {
                                $selected = $(this).find("option:selected");

                                if ($selected.attr("value").length) {
                                    temp = $.trim($selected.text());
                                } else {
                                    temp = '';
                                }

                                value.push(temp);
                            });

                           field = "topic";
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
                                
                                    field = parent_field.replace("-group", "");
                                    value = JSON.stringify(section_vals);
                                    is_json = true;
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

                    $(".special-permissions__toggle-view__button").on('click', function(evt) {
                        if (!$(this).hasClass("disabled")) {
                            $(".button-nav-current").removeClass("button-nav-current").removeClass("disabled");

                            $(this).addClass("button-nav-current").addClass("disabled");

                            if ($(this).attr("id") == "toggle-live") {
                                 latest_edits_data = page.updateData(ia_data, latest_edits_data, false);       
                            } else {
                                 latest_edits_data = page.updateData(ia_data, latest_edits_data, true);
                            }

                            page.updateHandlebars(readonly_templates, latest_edits_data, ia_data.live.dev_milestone);
                            page.updateAll(readonly_templates, ia_data.live.dev_milestone, false);
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
                        $new_input = $(this).parent().find('.new_input').first().clone();
                        $(this).before($new_input.removeClass("hide"));
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
                                $parent.find('.topic-group option[value="0"]').empty();
                                $parent.find('.topic-group').val('0');

                                $selector = $("select.js-autocommit.topic-group");
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
                                $type.removeClass("invalid");
                                $username.removeClass("invalid");
                            } else {
                                $type.addClass("invalid");
                                $username.addClass("invalid");
                            }
                        });
                    }

                    function getGroupVals(field, $obj) {
                        var $selector = $obj || (field === "topic")? $(".ia_topic .available_topics option:selected") : $("." + field + " input");
                        var temp_val;
                        var value = [];
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
                                    temp_val = $(this).attr("value").length? $.trim($(this).text()) : '';
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

                    function autocommit(field, value, id, is_json, panel) {
                        var jqxhr = $.post("/ia/save", {
                            field : field,
                            value : value,
                            id : id,
                            autocommit: 1
                        })
                        .done(function(data) {
                            if (data.result) {
                                if(data.result.example_query != null) {
                                    example_query = data.result.example_query;
                                    enableScreenshotButton();
                                }

                                if(data.result.test_machine != null) {
                                    test_machine = data.result.test_machine;
                                    enableScreenshotButton();
                                }

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
                                        readonly_templates.live.name = Handlebars.templates.name(ia_data);
                                        $(".ia-single--right").before(readonly_templates.live.name);
                                        $(".ia-single--right").before(readonly_templates.metafields);
                                        $("#metafields").html(readonly_templates.metafields_content);

                                        $(".ia-single--name ." + field).addClass(saved_class);
                                    } else {
                                        readonly_templates[panel + "_content"] = Handlebars.templates[panel + "_content"](ia_data);

                                        var $panel_body = $("#" + panel);
                                        $panel_body.html(readonly_templates[panel + "_content"]);
                                    
                                        page.appendTopics($(".topic-group"));
                                        page.hideAssignToMe();
                                   
                                        // Developer field is already highlighted in green
                                        // when the user check is successful
                                        if (field !== "developer") { 
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
            'topic',
            'description',
            'github',
            'examples',
            'devinfo'
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
            'contributors',
            'testing'
        ],

        removeMaxHeight: function($obj_set) {
            $obj_set.each(function(idx) {
                $(this).css("height", "");
            });
        },

        updateHandlebars: function(templates, ia_data, dev_milestone) {
            templates.live.name = Handlebars.templates.name(ia_data);
            
            if (dev_milestone === 'live') {
                for (var i = 0; i < this.field_order.length; i++) {
                    templates.live[this.field_order[i]] = Handlebars.templates[this.field_order[i]](ia_data);
                }
            } else {
                templates.metafields = Handlebars.templates.metafields(ia_data);
                templates.metafields_content = Handlebars.templates.metafields_content(ia_data);
                templates.base_info = Handlebars.templates.base_info(ia_data);
                templates.base_info_content = Handlebars.templates.base_info_content(ia_data);
                templates.advanced = Handlebars.templates.advanced(ia_data);
                templates.advanced_content = Handlebars.templates.advanced_content(ia_data);
                for (var i = 0; i < this.dev_milestones_order.length; i++) {
                    templates[this.dev_milestones_order[i]] = Handlebars.templates[this.dev_milestones_order[i]](ia_data);
                    templates[this.dev_milestones_order[i] + "_content"] = Handlebars.templates[this.dev_milestones_order[i] + "_content"](ia_data);
                }
            }
        },

        updateData: function(ia_data, x, edited) {
            var edited_fields = 0;
            $.each(ia_data.live, function(key, value) {
                if (edited && ia_data.edited[key]) {
                    x[key] = ia_data.edited[key];
                    edited_fields++;
                } else {
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

        updateAll: function(templates, dev_milestone, edit) {
            if (!edit) {
                $(".ia-single--name").remove();
                $("#metafields").remove();
                $(".ia-single--left, .ia-single--right").show().empty();

                if (dev_milestone === "live" || dev_milestone === "deprecated") {
                    for (var i = 0; i < this.field_order.length; i++) {
                        $(".ia-single--left").append(templates.live[this.field_order[i]]);
                    }
                } else {
                    var $temp_panel_body;
                    for (var i = 0; i < this.dev_milestones_order.length; i++) {
                        $(".ia-single--left").append(templates[this.dev_milestones_order[i]]);
                        $temp_panel_body = $("#" + this.dev_milestones_order[i]);
                        $temp_panel_body.html(templates[this.dev_milestones_order[i] + "_content"]);
                    }

                     $(".ia-single--right").append(templates.base_info);
                     $("#base_info").html(templates.base_info_content);
                }

                $(".ia-single--right").before(templates.live.name);
                $(".ia-single--right").append(templates.screens);
                if (dev_milestone !== "live" && dev_milestone !== "deprecated") {
                    $(".ia-single--right").before(templates.metafields);
                    $("#metafields").html(templates.metafields_content);
                    
                    $(".ia-single--right").append(templates.advanced);
                    $("#advanced").html(templates.advanced_content);

                    this.appendTopics($(".topic-group"));
                    this.hideAssignToMe();
                }

                if (this.hideScreenshot) {
                    this.hideScreenshot();
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
                $(".ia-single--left, .ia-single--right, .ia-single--name").hide();
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
