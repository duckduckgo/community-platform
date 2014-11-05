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
                    var ia = Handlebars.templates.page(x);
                    var ia_edit = Handlebars.templates.editpage(x);
                    $(".ia-single").html(ia);
                    $(".ia-single .dev-info").on('click', DDH.IAPage.prototype.expand.bind(this));

                    $("#edit_activate").on('click', function(evt) {
                        $(".ia-single").html(ia_edit);

                        if (!($("#examples a.other-examples").length)) {
                            $("#primary").parent().find(".button.delete").addClass("hide");
                        }

                        $("#edit_disable").removeClass("hide");
                        $(this).hide();
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
                            if ($(this).parent().attr('id') === 'input_example') {
                                var new_example = $(this).val();
                                if (new_example !== '') {
                                    $(this).parent().parent().before('<li class="editpage"><div class="button delete listbutton"><span>-</span></div>' +
                                                   '<a class="editable other-examples newentry" name="other_queries" title="Try this example on DuckDuckGo" href="https://duckduckgo.com/?q=' +
                                                    new_example + '"><input type="text" value="' + new_example + '" /></a></li>');
                                }

                                $(this).val("");
                                $(this).parent().addClass("hide");
                                $("#add_example").removeClass("hide");

                                var $primary_button = $("#primary").parent().parent().find(".button.delete");
                                if ($primary_button.hasClass("hide")) {
                                    $primary_button.removeClass("hide");
                                }
                            }

                            var field = $(this).parent().attr('name');
                            var value;

                            if (field !== "topic" && field !== "other_queries" && field !== "code") {
                                value = $(this).val();
                            } else {
                                value = [];
                                var selector;
                                if (field === "topic") {
                                    selector = ".ia_topic a.editable input";
                                } else if (field === "other_queries") {
                                    selector = "#examples a.other-examples input";
                                } else {                            
                                    selector = "li.code.editable input";
                                }

                                $(selector).each(function(index) {
                                    if ($(this).val()) {
                                        value.push($(this).val());
                                    }
                                });

                                value = JSON.stringify(value);
                            }

                            save(field, value, DDH_iaid);

                            if (evt.type === "keypress") {
                                return false;
                            }
                        }
                    });

                    $("body").on("click", ".button.delete", function(evt) {
                        var field = $(this).parent().find("a.editable").attr('name');
                        var value;

                        console.log("Field: " + field);
                        if (field === 'example_query') {
                            var $new_primary = $('a.other-examples input').first();
                            if ($new_primary.length) {
                                $new_primary.parent().removeClass('other-examples');
                                $new_primary.parent().attr('name', 'example_query');
                                $new_primary.parent().attr('id', 'primary');
                                console.log("$new_primary: " + $new_primary.val());
                                save(field, $new_primary.val(), DDH_iaid);
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

                        save(field, value, DDH_iaid);
                    });

                    function save(field, value, id) {
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
