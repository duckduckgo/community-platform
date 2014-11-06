(function(env) {


    // placeholder

    DDH.IAPage = function(ops) {
        this.init(ops); 
    };

    // this could get the single IA json like the index.
    // but for now the page is being built with xslate
    DDH.IAPage.prototype = {
        init: function(ops) {
            console.log("IAPage.init()\n"); 

            if (DDH_iaid) {
                console.log("for ia id '%s'", DDH_iaid);

                $.getJSON("/ia/view/" + DDH_iaid + "/json", function(x) {
                    // Readonly mode templates
                    var name = Handlebars.templates.name(x);
                    var status = Handlebars.templates.status(x);
                    var desc = Handlebars.templates.description(x);
                    var team = Handlebars.templates.team(x);
                    var topic = Handlebars.templates.topic(x);
                    var screens = Handlebars.templates.screens(x);
                    var examples = Handlebars.templates.examples(x);
                    var related = Handlebars.templates.related(x);
                    var devinfo = Handlebars.templates.devinfo(x);
                    var issues = Handlebars.templates.issues(x);

                    // Pre-Edit mode templates
                    var pre_templates = {
                        name : Handlebars.templates.pre_edit_name(x),
                        status : Handlebars.templates.pre_edit_status(x),
                        description : Handlebars.templates.pre_edit_description(x),
                        team : Handlebars.templates.pre_edit_team(x),
                        topic : Handlebars.templates.pre_edit_topic(x),
                        examples : Handlebars.templates.pre_edit_examples(x),
                        example_query : this.examples,
                        other_queries : this.examples,
                        related : Handlebars.templates.pre_edit_related(x),
                        issues : Handlebars.templates.pre_edit_issues(x)
                    };

                    // Edit mode templates
                    var edit_templates = {
                        name : Handlebars.templates.edit_name(x),
                        status : Handlebars.templates.edit_status(x),
                        description : Handlebars.templates.edit_description(x),
                        team : Handlebars.templates.edit_team(x),
                        topic : Handlebars.templates.edit_topic(x),
                        example_query : Handlebars.templates.edit_examples(x),
                        other_queries : this.example_query,
                        related : Handlebars.templates.edit_related(x),
                    };

                    $(".ia-single").append(name);
                    $(".ia-single").append(status);
                    $(".ia-single").append(desc);
                    $(".ia-single").append(team);
                    $(".ia-single").append(topic);
                    $(".ia-single").append(screens);
                    $(".ia-single").append(examples);
                    $(".ia-single").append(related);
                    $(".ia-single").append(devinfo);
                    $(".ia-single").append(issues);

                    $("body").on('click', '.ia-single .dev-info', DDH.IAPage.prototype.expand.bind(this));

                    $("#edit_activate").on('click', function(evt) {

                        $(".ia-single").html(pre_templates.name);
                        $(".ia-single").append(pre_templates.status);
                        $(".ia-single").append(pre_templates.description);
                        $(".ia-single").append(pre_templates.team);
                        $(".ia-single").append(pre_templates.topic);
                        $(".ia-single").append(screens);
                        $(".ia-single").append(pre_templates.examples);
                        $(".ia-single").append(pre_templates.related);
                        $(".ia-single").append(devinfo);
                        $(".ia-single").append(pre_templates.issues);

                        if (!($("#examples a.other-examples").length)) {
                            $("#primary").parent().find(".button.delete").addClass("hide");
                        }

                        $("#edit_disable").removeClass("hide");
                        $(this).hide();
                    });

                    $("body").on('mouseenter mouseleave', '.pre_edit', function(evt) {
                        $(this).toggleClass("highlight");
                    });

                    $("body").on('click', '.pre_edit', function(evt) {
                        var name = $(this).attr('name');
                        var $obj;

                        if (name === "example_query" || name === "other_queries") {
                           $obj = $("#examples");
                        } else if (name === "topic") {
                            $obj = $("#topics");
                        } else if (name === "code") {
                            $obj = $(".dev-info-details");
                        }else {
                            $obj = $(this);
                        }

                        $obj.replaceWith(edit_templates[name]);
                    });

                    $("#edit_disable").on('click', function(evt) {
                        location.reload();
                    });

                    $("body").on('click', '#add_example', function(evt) {
                        $(this).addClass("hide");
                        $("#input_example").removeClass("hide");
                    });

                    $("body").on('focusout keypress', '.editable input', function(evt) {
                        if (evt.type === 'focusout' || (evt.type === 'keypress' && evt.which === 13)) {
                            var $obj = $(this).parent();
                            var field = $obj.attr('name');
                            var value = $(this).val();

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

                            if (field === "topic" || field === "other_queries" || field === "code") {
                                value = [];
                                var selector;
                                if (field === "topic") {
                                    selector = ".ia_topic a.editable input";
                                    $obj = $("#topics");
                                } else if (field === "other_queries") {
                                    selector = "#examples .other-examples input";
                                    $obj = $("#examples");
                                } else {                            
                                    selector = "li.code.editable input";
                                    $obj = $(".dev-info-details");
                                }

                                $(selector).each(function(index) {
                                    if ($(this).val()) {
                                        value.push($(this).val());
                                    }
                                });

                                value = JSON.stringify(value);
                            }

                            save(field, value, DDH_iaid, $obj);

                            if (evt.type === "keypress") {
                                return false;
                            }
                        }
                    });

                    $("body").on("click", ".button.delete", function(evt) {
                        var field = $(this).parent().find("a.editable").attr('name');
                        var value;
                        var $obj = $("#examples");

                        console.log("Field: " + field);
                        if (field === 'example_query') {
                            var $new_primary = $('a.other-examples input').first();
                            if ($new_primary.length) {
                                $new_primary.parent().removeClass('other-examples');
                                $new_primary.parent().attr('name', 'example_query');
                                $new_primary.parent().attr('id', 'primary');
                                console.log("$new_primary: " + $new_primary.val());
                                save(field, $new_primary.val(), DDH_iaid, $obj);
                            }

                            field = 'other_queries';
                        }

                        $(this).parent().remove();

                        if (!$("#examples a.other-examples").length && $("#primary").length) {
                            $("#primary").parent().find(".button.delete").addClass("hide");
                        }

                        value = [];
                        $("#examples a.other-examples input").each(function(index) {
                            if ($(this).val()) {
                                value.push($(this).val());
                            }
                        });

                        save(field, value, DDH_iaid, $obj);
                    });

                    function save(field, value, id, $obj) {
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
                                $.getJSON("/ia/view/" + DDH_iaid + "/json", function(new_x) {
                                    var name;
                                    if (field === "example_query" || field === "other_queries") {
                                        name = "examples"
                                    } else {
                                        name = field;
                                    }

                                    pre_templates[field] = Handlebars.templates['pre_edit_' + name](new_x);
                                    edit_templates[field] = Handlebars.templates['edit_' + name](new_x);
                                    $obj.replaceWith(pre_templates[field]);
                                });
                            }
                        });
                    }
                });
            }
        },

        expand: function() {
            $(".ia-single .dev-info").addClass("hide");
            $(".ia-single .dev-info-details").removeClass("hide");
        }        
    };

})(DDH);
