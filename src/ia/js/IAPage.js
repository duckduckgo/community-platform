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

            if (DDH_iaid) {
                //console.log("for ia id '%s'", DDH_iaid);

                $.getJSON("/ia/view/" + DDH_iaid + "/json", function(ia_data) {

                    // Show latest edits for admins and users with edit permissions
                    var x = {};
                    if (ia_data.edited) {
                       $.each(ia_data.live, function(key, value) {
                            if (!ia_data.edited[key]) {
                                x[key] = value;
                            } else {
                                x[key] = ia_data.edited[key];
                            }
                        });
                    } else {
                        x = ia_data.live;
                    }

                    // Readonly mode templates
                    var readonly_templates = {
                        name : Handlebars.templates.name(x),
                        status : Handlebars.templates.status(x),
                        description : Handlebars.templates.description(x),
                        topic : Handlebars.templates.topic(x),
                        screens : Handlebars.templates.screens(x),
                        template : Handlebars.templates.template(x),
                        examples : Handlebars.templates.examples(x),
                        devinfo : Handlebars.templates.devinfo(x),
                        github: Handlebars.templates.github(x)
                    };

                    // Pre-Edit mode templates
                    var pre_templates = {
                        name : Handlebars.templates.pre_edit_name(ia_data),
                        status : Handlebars.templates.pre_edit_status(ia_data),
                        description : Handlebars.templates.pre_edit_description(ia_data),
                        topic : Handlebars.templates.pre_edit_topic(ia_data),
                        examples : Handlebars.templates.pre_edit_examples(ia_data)
                    };

                    DDH.IAPage.prototype.updateAll(readonly_templates, false);

                    $("#edit_activate").on('click', function(evt) {
                        DDH.IAPage.prototype.updateAll(pre_templates, true);

                        $("#edit_disable").removeClass("hide");
                        $(this).hide();
                    });

                    $("body").on('click', '.js-pre-editable.button', function(evt) {
                        var name = $(this).attr('name');
                        var $row = $(this).parent();
                        var $obj = $("#column-edits-" + name);

                        $obj.replaceWith(Handlebars.templates['edit_' + name](ia_data));
                        $row.addClass("row-diff-edit");
                        $(this).hide();
                        $row.children(".js-editable").removeClass("hide");

                        if (name === "examples") {
                            if (!($("#examples .other-examples").length)) {
                                $("#primary").parent().find(".button.delete").addClass("hide");
                            }
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
                        $("#new_topic").parent().parent().removeClass("hide");
                    });

                    $("body").on('click', '#view_commits', function(evt) {
                        window.location = "/ia/commit/" + DDH_iaid;
                    });

                    $("body").on("click", ".button.delete", function(evt) {
                        var field = $(this).parent().find(".js-editable").attr('name');
                        if (field === 'example_query') {
                            var $new_primary = $('a.other-examples input').first();
                            if ($new_primary.length) {
                                $new_primary.parent().removeClass('other-examples');
                                $new_primary.parent().attr('name', 'example_query');
                                $new_primary.parent().attr('id', 'primary');
                            }
                        }

                        $(this).parent().remove();

                        if (!$("#examples .other-examples").length && $("#primary").length) {
                            $("#primary").parent().find(".button.delete").addClass("hide");
                        }
                    });

                    $("body").on('keypress click', '.js-input, .button.js-editable', function(evt) {
                        if ((evt.type === 'keypress' && (evt.which === 13 && $(this).hasClass("js-input")))
                            || (evt.type === 'click' && $(this).hasClass("js-editable"))) {
                            var field = $(this).attr('name');
                            var value = "";
                            var $obj = $("#row-diff-" + field);

                            if ($(this).hasClass("js-input")) {
                                value = $(this).val();
                            } else {
                                var $input = $obj.find("input.js-input");
                                value = $input.val();
                            }

                            if ($obj.attr('id') === 'input_example') {
                                if (value !== '') {
                                    $obj.parent().before('<li class="editpage"><div class="button delete listbutton"><span>-</span></div>' +
                                                   '<span class="editable other-examples newentry" name="other_queries" title="Try this example on DuckDuckGo">' +
                                                   '<input type="text" value="' + value + '" /></span></li>');
                                }

                                $(this).val("");
                                $obj.addClass("hide");
                                $("#add_example").removeClass("hide");

                                var $primary_button = $("#primary").parent().parent().find(".button.delete");
                                if ($primary_button.hasClass("hide")) {
                                    $primary_button.removeClass("hide");
                                }
                            }

                            if (evt.type === "click" && (field === "topic" || field === "examples")) {
                                if (field === "topic") {
                                    $(".ia_topic .js-editable .available_topics option:selected").each(function(index) {
                                        if ($(this).text() && $.inArray($(this).text(), value) === -1) {
                                            value.push($(this).text());
                                        }
                                    });
                                } else if (field === "examples") {
                                    save("example_query", $("#primary input").val(), DDH_iaid, $obj, false);
                                    field = "other_queries";
                                    $("#examples .other-examples input").each(function(index) {
                                        if ($(this).val()) {
                                            value.push($(this).val());
                                        }
                                    });
                                }

                                value = JSON.stringify(value);
                            }
                            
                            if (value !== ia_data.live[field] && value !== ia_data.edited[field]) {
                                save(field, value, DDH_iaid, $obj, true);    
                            }

                            if (evt.type === "keypress") {
                                return false;
                            }
                        }
                    });

                    function save(field, value, id, $obj, replace) {
                        var jqxhr = $.post("/ia/save", {
                            field : field, 
                            value : value,
                            id : id
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

                                var name;
                                if (field === "example_query" || field === "other_queries") {
                                    name = "examples";
                                } else {
                                    name = field;
                                }

                                if (field === "other_queries" || field === "topic") {
                                    ia_data.edited[field] = $.parseJSON(data.result[field]);
                                } else {
                                    ia_data.edited[field] = data.result[field];
                                }

                                pre_templates[field] = Handlebars.templates['pre_edit_' + name](ia_data);

                                if (replace) {
                                    $obj.replaceWith(pre_templates[field]);
                                }
                            }
                        });
                    }
                });
            }
        },

        field_order: [
            'description',
            'github',
            'examples',
            'devinfo'
        ],

        edit_field_order: [
            'name',
            'status',
            'description',
            'topic',
            'examples'
        ],

        updateAll: function(templates, edit) {
            if (!edit) {
                $(".ia-single--left").show().empty();
                for (var i = 0; i < this.field_order.length; i++) {
                    $(".ia-single--left").append(templates[this.field_order[i]]);
                }

                $(".ia-single--right").show().append(templates.screens);

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
                $(".ia-single--left, .ia-single--right").hide();
                for (var i = 0; i < this.edit_field_order.length; i++) {
                    $(".ia-single").append(templates[this.edit_field_order[i]]);
                }
            }
        }    
    };

})(DDH);
