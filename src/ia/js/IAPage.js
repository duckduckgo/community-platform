(function(env) {
    // Handlebars helpers
    Handlebars.registerHelper('encodeURIComponent', encodeURIComponent);

    // Choose a GitHub location before anything else.
    Handlebars.registerHelper('chooseService', function(services) {
        // Make sure to build the URL if we just find the handle.
        function buildURL(service) {
            var types = {
                github: 'https://github.com/',
                twitter: 'https://twitter.com/'
            };

            if(service.type in types && !/https?:\/\//.test(service.loc)) {
                return types[service.type] + service.loc; 
            }

            return service.loc;
        }

        for(var i = 0; i < services.length; i++) {
            if(services[i].type === "github") {
                return buildURL(services[i]);
            }
        }

        return buildURL(services[0]);
    });

    // placeholder

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

                    if (ia_data.live.dev_milestone !== "live") {
                        if ($(".special-permissions").length) {
                            ia_data.permissions = {can_edit: 1};
                            
                            if ($("#view_commits").length) {
                                ia_data.permissions.admin = 1;
                            }
                        }
                        ia_data.current = {};
                        ia_data.current[ia_data.live.dev_milestone] = 1;
                        var future = {};
                        var milestone_idx = $.inArray(ia_data.live.dev_milestone, page.dev_milestones_order);
                        if (milestone_idx !== -1) {
                            milestone_idx++;
                            for (var i = milestone_idx; i < page.dev_milestones_order.length; i++) {
                                future[page.dev_milestones_order[i]] = 1;
                            }
                        }

                        ia_data.future = future;
                    }

                    // Readonly mode templates
                    var readonly_templates = {
                        live: {
                            name : Handlebars.templates.name(latest_edits_data),
                            status : Handlebars.templates.status(latest_edits_data),
                            description : Handlebars.templates.description(latest_edits_data),
                            topic : Handlebars.templates.topic(latest_edits_data),
                            screens : Handlebars.templates.screens(latest_edits_data),
                            template : Handlebars.templates.template(latest_edits_data),
                            examples : Handlebars.templates.examples(latest_edits_data),
                            devinfo : Handlebars.templates.devinfo(latest_edits_data),
                            github: Handlebars.templates.github(latest_edits_data)
                        },
                        metafields : Handlebars.templates.metafields(ia_data),
                        planning : Handlebars.templates.planning(ia_data),
                        in_development : Handlebars.templates.in_development(ia_data),
                        qa : Handlebars.templates.qa(ia_data),
                        ready : Handlebars.templates.ready(ia_data)
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
                        unsafe : Handlebars.templates.pre_edit_unsafe(ia_data)
                    };

                    page.updateAll(readonly_templates, ia_data.live.dev_milestone, false);

                    $("#view_json").click(function(evt) {
                        location.href = json_url;
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

                    $(".ia-single--image-container img").error(function() {
                        if (ia_data.live.dev_milestone !== "live") {
                            $(".ia-single--screenshots").addClass("hide");
                            $(".ia-single--left").removeClass("ia-single--left").addClass("ia-single--left--wide");
                            $(".dev_milestone-container__body").removeClass("hide");

                            // Set the panels height to the tallest one's height
                            var max_height = 0;
                            $(".dev_milestone-container").each(function(idx) {
                                if ($(this).height() > max_height) {
                                    max_height = $(this).height();
                                }
                            });

                            $(".dev_milestone-container").height(max_height);

                            page.imgHide = true;
                        }
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

                        if ($(this).hasClass("icon-check-empty")) {
                            value = 1;
                        } else {
                            value = 0;
                        }

                        $(this).toggleClass("icon-check-empty");
                        $(this).toggleClass("icon-check");

                        if (field.length) {
                            if ($(this).hasClass("section-group__item")) {
                                var parent_field = $.trim($(this).parent().parent().attr("id"));
                                var section_vals = getSectionVals($(this), parent_field);

                                section_vals[field] = value;
                               
                                field = parent_field.replace("-group", "");
                                value = JSON.stringify(section_vals);
                                is_json = true;
                            }
                         
                            autocommit(field, value, DDH_iaid, is_json);
                        }
                    });

                    $("body").on("change", 'input[type="number"].js-autocommit', function(evt) {
                        if (!$(this).hasClass("js-autocommit-focused")) {
                            $(this).focus();
                        }
                    });

                    $("body").on("focusin", "textarea.js-autocommit, input.js-autocommit", function(evt) {
                        if (!$(this).hasClass("js-autocommit-focused")) {
                            $(this).addClass("js-autocommit-focused");
                        }
                    });

                    $("body").on('change', "select.js-autocommit", function(evt) {
                        var field;
                        var value;
                        var is_json = false;
                    
                        if ($(this).hasClass("topic-group")) {
                            value = [];
                            var temp;
                            $("select.js-autocommit.topic-group").each(function(idx) {
                                temp = $.trim($(this).find("option:selected").text());

                                if (temp.length) {
                                    value.push(temp);
                                }
                            });

                           field = "topic";
                           value = JSON.stringify(value);
                           is_json = true;
                        } else {
                           field = $.trim($(this).attr("id").replace("-select", ""));
                           value = $.trim($(this).find("option:selected").text());
                        }

                        if (field.length && value !== ia_data.live[field]) { 
                             autocommit(field, value, DDH_iaid, is_json);
                        }
                    });

                    $("body").on('keypress focusout', "textarea.js-autocommit-focused, input.js-autocommit-focused", function(evt) {
                        if ((evt.type === 'keypress' && evt.which === 13) || (evt.type === "focusout")) {
                            var field;
                            var value = $.trim($(this).val());
                            var id = $.trim($(this).attr("id"));
                            var is_json = false;

                            if (id.match(/.*-input/)) {
                                field = id.replace("-input", "");
                            } else {
                                field = id.replace("-textarea", "");
                            }

                            if ($(this).hasClass("comma-separated") && value.length) {
                                value = value.split(/\s*,\s*/);
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
                                
                                autocommit(field, value, DDH_iaid, is_json);
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
                        
                        $(this).hide();

                        if (field.length && value.length) {
                            autocommit(field, value, DDH_iaid, is_json);
                        }
                    });

                    $("body").on('click', ".js-complete.button", function(evt) {
                        var field = "dev_milestone";
                        var value;
                        var is_json = false;
                        
                        if (ia_data.live.dev_milestone === "ready") {
                            value = "live";
                        } else {
                            value = page.dev_milestones_order[$.inArray(ia_data.live.dev_milestone, page.dev_milestones_order) + 1];
                        }
                       
                        if (value.length) { 
                            autocommit(field, value, DDH_iaid, is_json);
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
                            $(".available_topics").append($("#allowed_topics").html());
                        }
                    });

                    $("#edit_disable").on('click', function(evt) {
                        location.reload();
                    });

                    $("body").on('click', '#add_example', function(evt) {
                        $(this).addClass("hide");
                        $("#input_example").removeClass("hide");
                    });

                    $("body").on('click', '#add_topic', function(evt) {
                        $(this).addClass("hide");
                        $("#add_topic_select").removeClass("hide");
                    });

                    $("body").on('click', '#view_commits', function(evt) {
                        window.location = "/ia/commit/" + DDH_iaid;
                    });

                    $("body").on("click", ".button.delete", function(evt) {
                        if (ia_data.live.dev_milestone === "live") {
                            $(this).parent().remove();
                            var field = $(this).parent().find(".js-editable").attr('name');
                            if (field === 'example_query') {
                                var $new_primary = $('a.other-examples input').first();
                                if ($new_primary.length) {
                                    $new_primary.parent().removeClass('other-examples');
                                    $new_primary.parent().attr('name', 'example_query');
                                    $new_primary.parent().attr('id', 'primary');
                                }
                            }

                            if (!$("#examples .other-examples").length && $("#primary").length) {
                                $("#primary").parent().find(".button.delete").addClass("hide");
                            }
                        } else {
                            // If dev milestone is not 'live' it means we are in the dev page
                            // and a topic has been deleted (it's the only field having a delete button in the dev page
                            // so far) - so we must save
                            if ($(this).hasClass("js-autocommit")) {
                                var field = "topic";
                                var value = [];
                                var is_json = true;
                                var temp;
                                var $parent = $(this).parent();
                                $parent.find('.topic-group option[value="0"]').empty();
                                $parent.find('.topic-group').val('0');
                                $("select.js-autocommit.topic-group").each(function(idx) {
                                    temp = $.trim($(this).find("option:selected").text());

                                    if (temp.length) {
                                        value.push(temp);
                                    }
                                });

                                value = JSON.stringify(value); 

                                if (field.length && value.length) {
                                    autocommit(field, value, DDH_iaid, is_json);
                                }
                            }
                        }
                   });

                    $("body").on('keypress click', '.js-input, .button.js-editable', function(evt) {
                        if ((evt.type === 'keypress' && (evt.which === 13 && $(this).hasClass("js-input")))
                            || (evt.type === 'click' && $(this).hasClass("js-editable"))) {
                            var field = $(this).attr('name');
                            var value;
                            var edited_value = ia_data.edited[field];
                            var live_value = ia_data.live[field];
                            var $obj = $("#row-diff-" + field);

                            if ($(this).hasClass("js-input")) {
                                value = $.trim($(this).val());
                            } else {
                                var input;
                                if (field === "dev_milestone") {
                                     $input = $obj.find(".available_dev_milestones option:selected");
                                     value = $.trim($input.text());
                                } else if (field === "repo") {
                                    $input = $obj.find(".available_repos option:selected");
                                    value = $.trim($input.text());
                                } else {
                                    $input = $obj.find("input.js-input,#description textarea");
                                    value = $.trim($input.val());
                                }
                            }
                            
                            if (evt.type === "click" && (field === "topic" || field === "other_queries")) {
                                value = [];
                                var txt;
                                if (field === "topic") {
                                    $(".ia_topic .available_topics option:selected").each(function(index) {
                                        txt = $.trim($(this).text());
                                        if (txt && $.inArray(txt, value) === -1) {
                                            value.push(txt);
                                        }
                                    });
                                } else if (field === "other_queries") {
                                    $(".other-examples input").each(function(index) {
                                        txt = $.trim($(this).val());
                                        if (txt && $.inArray(txt, value) === -1) {
                                            value.push(txt);
                                        }
                                    });
                                }

                                value = JSON.stringify(value);
                                edited_value = JSON.stringify(ia_data.edited[field]);
                                live_value = JSON.stringify(ia_data.live[field]);
                            }

                            if (value && (value !== edited_value && value !== live_value)) {
                                save(field, value, DDH_iaid, $obj);
                            } else {
                                $obj.replaceWith(pre_templates[field]);
                            }

                            if (evt.type === "keypress") {
                                return false;
                            }
                        }
                    });

                    function getSectionVals($obj, parent_field) {
                        var section_vals = {};
                        var temp_field;
                        var temp_value;

                        $("#" + parent_field + " .section-group__item").each(function(idx) {
                            if ($(this) !== $obj) {
                                if ($(this).hasClass("dev_milestone-container__body__input")) {
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

                    function autocommit(field, value, id, is_json) {
                        var jqxhr = $.post("/ia/save", {
                            field : field,
                            value : value,
                            id : id,
                            autocommit: 1
                        })
                        .done(function(data) {
                            if (data.result) {
                                if (field === "dev_milestone") {
                                    location.reload();
                                } else {
                                    ia_data.live[field] = (is_json && data.result[field])? $.parseJSON(data.result[field]) : data.result[field];

                                    if (field === "repo" || field === "producer"
                                        || field === "designer" || field === "developer") {

                                        if (field === "repo") {
                                            readonly_templates.planning =  Handlebars.templates.planning(ia_data);
                                        } else {
                                            readonly_templates.metafields =  Handlebars.templates.metafields(ia_data);
                                        }

                                        page.updateAll(readonly_templates, ia_data.live.dev_milestone, false);
                                    }
                                } 
                            }
                        });
                    }

                    function save(field, value, id, $obj) {
                        var jqxhr = $.post("/ia/save", {
                            field : field, 
                            value : value,
                            id : id,
                            autocommit: 0
                        })
                        .done(function(data) {
                            if (!data.result) {
                                if ($("#error").hasClass("hide")) {
                                    $("#error").removeClass("hide");
                                }
                            } else {
                                if (data.result.is_admin) {
                                    if ($("#view_commits").hasClass("hide")) {
                                        $("#view_commits").removeClass("hide");
                                    }
                                }

                                if (field === "other_queries" || field === "topic") {
                                    ia_data.edited[field] = $.parseJSON(data.result[field]);
                                } else {
                                    ia_data.edited[field] = data.result[field];
                                }

                                pre_templates[field] = Handlebars.templates['pre_edit_' + field](ia_data);

                                $obj.replaceWith(pre_templates[field]);
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
            'unsafe'
        ],

        dev_milestones_order: [
            'planning',
            'in_development',
            'qa',
            'ready'
        ],

        updateHandlebars: function(templates, ia_data, dev_milestone) {
            if (dev_milestone === 'live') {
                for (var i = 0; i < this.field_order.length; i++) {
                    templates.live.name = Handlebars.templates.name(ia_data);
                    templates.live[this.field_order[i]] = Handlebars.templates[this.field_order[i]](ia_data);
                }
            } else {
                templates.metafields = Handlebars.templates.metafields(ia_data);
                for (var i = 0; i < this.dev_milestones_order.length; i++) {
                    templates[this.dev_milestones_order[i]] = Handlebars.templates[this.dev_milestones_order[i]](ia_data);
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

        updateAll: function(templates, dev_milestone, edit) {
            if (!edit) {
                $(".ia-single--name").remove();
                $("#metafield_container").remove();
                $(".ia-single--left, .ia-single--right").show().empty();

                if (dev_milestone === "live") {
                    for (var i = 0; i < this.field_order.length; i++) {
                        $(".ia-single--left").append(templates.live[this.field_order[i]]);
                    }
                } else {
                    for (var i = 0; i < this.dev_milestones_order.length; i++) {
                        $(".ia-single--left").append(templates[this.dev_milestones_order[i]]);
                    }
                }

                $(".ia-single--right").before(templates.live.name);
                if (dev_milestone != "live") {
                    $(".ia-single--right").before(templates.metafields);

                    if ($(".topic-group").length) {
                        $(".topic-group").append($("#allowed_topics").html());
                    }

                    // If one or more team fields has the current user's name as value,
                    // hide the 'assign to me' button accordingly
                    var current_user = $.trim($(".header-account-info .user-name").text());
                    $(".team-input").each(function(idx) {
                        if ($(this).val() === current_user) {
                            $("#" + $.trim($(this).attr("id").replace("-input", "")) + "-button").hide();
                        }
                    });
                }

                if (!this.imgHide) {
                    $(".ia-single--right").append(templates.live.screens);
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
                }
            }
        }    
    };

})(DDH);
