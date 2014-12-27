(function(env) {
    // Handlebars helpers
    Handlebars.registerHelper('encodeURIComponent', encodeURIComponent);

    Handlebars.registerHelper('addPeriod', function(description) {
        if(!/\.$/.test(description)) {
            return description + ".";
        }

        return description;
    });

    Handlebars.registerHelper('listFiles', function(items, options) {
        var out = "";
        for(var i = 0; i < items.length; i++) {
            if(i < 3) {
                out +="<li>" + options.fn(items[i]) + "</li>";
            } else {
                out += "<li class='hide extra-item'>" + options.fn(items[i]) + "</li>";
            }
        }

        return out;
    });

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
                        name : Handlebars.templates.pre_edit_name(x),
                        status : Handlebars.templates.pre_edit_status(x),
                        description : Handlebars.templates.pre_edit_description(x),
                        topic : Handlebars.templates.pre_edit_topic(x),
                        screens : Handlebars.templates.screens(x),
                        template : Handlebars.templates.template(x),
                        examples : Handlebars.templates.pre_edit_examples(x),
                        devinfo : Handlebars.templates.devinfo(x),
                        github: Handlebars.templates.github(x)
                    };

                    DDH.IAPage.prototype.updateAll(readonly_templates);

                    $("body").on('click', '.ia-single .dev-info', DDH.IAPage.prototype.expand.bind(this));

                    $("#edit_activate").on('click', function(evt) {
                        DDH.IAPage.prototype.updateAll(pre_templates);

                        $("#edit_disable").removeClass("hide");
                        $(this).hide();
                    });

                    $("body").on('mouseenter mouseleave', '.pre_edit', function(evt) {
                        $(this).toggleClass("highlight");
                    });

                    $("body").on('click', '.button.arrow', function(evt) {
                        $(this).parent().find("img").toggleClass("hide");
                        if ($(this).find("span").text() == "▾") {
                            $(this).find("span").text("▴");
                        } else if ($(this).find("span").text() == "▴") {
                            $(this).find("span").text("▾");
                        }
                    });

                    $("body").on('click', '.pre_edit', function(evt) {
                        var name = $(this).attr('name');
                        var $obj;

                        if (name === "example_query" || name === "other_queries") {
                           $obj = $("#examples");
                           name = "examples";
                        } else if (name === "topic") {
                            $obj = $("#topics");
                        }else {
                            $obj = $(this);
                        }

                        $obj.replaceWith(Handlebars.templates['edit_' + name](x));

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

                    $("body").on('click', '.button.cancel', function(evt) {
                        var $obj = $(this).parent();
                        var name = $(this).attr('name');

                        $obj.replaceWith(Handlebars.templates['pre_edit_' + name](x));
                    });

                    $("body").on('keypress', '.editable input', function(evt) {
                        if (evt.type === 'keypress' && evt.which === 13) {
                            var $obj = $(this).parent().parent();
                            var field = $(this).parent().attr('name');
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

                            if (field !== "topic" && field !== "other_queries" && field !== "code" && field !== "example_query") {
                                save(field, value, DDH_iaid, $obj, true);
                            }

                            if (evt.type === "keypress") {
                                return false;
                            }
                        }
                    });

                    $("body").on("click", ".button.delete", function(evt) {
                        var field = $(this).parent().find(".editable").attr('name');
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

                    $("body").on("click", ".section_editable .button.end", function(evt) {
                        var $obj = $(this).parent();
                        var field = $obj.attr('id');
                        var value = [];
                        var selector;

                        if (field === "topic") {
                            selector = ".ia_topic .editable .available_topics option:selected";
                        } else if (field === "examples") {
                            save("example_query", $("#primary input").val(), DDH_iaid, $obj, false);
                            field = "other_queries";
                            selector = "#examples .other-examples input";
                        }

                        if (field !== "topic") {
                            $(selector).each(function(index) {
                                if ($(this).val()) {
                                    value.push($(this).val());
                                }
                            });
                        } else {
                            $(selector).each(function(index) {
                                if ($(this).text() && $.inArray($(this).text(), value) === -1) {
                                    value.push($(this).text());
                                }
                            });
                        }

                        value = JSON.stringify(value);
                        save(field, value, DDH_iaid, $obj, true);
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

                                if (field === "other_queries" || field === "topic" || field === "code") {
                                    x[field] = $.parseJSON(data.result[field]);
                                } else {
                                    x[field] = data.result[field];
                                }

                                pre_templates[field] = Handlebars.templates['pre_edit_' + name](x);

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
            'name',
            'description',
            'github',
            'examples',
            'devinfo',
        ],

        updateAll: function(templates) {
            $(".ia-single--left").empty();
            for (var i = 0; i < this.field_order.length; i++) {
                $(".ia-single--left").append(templates[this.field_order[i]]);
            }

            $(".ia-single--right").append(templates.screens);

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
        },       

        expand: function() {
            $(".ia-single .dev-info").addClass("hide");
            $(".ia-single .dev-info-details").removeClass("hide");
        }        
    };

})(DDH);
