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
                    $(".ia-readonly").html(ia);
                    $(".ia-edit").html(ia_edit);
                    $(".ia-single .dev-info").on('click', DDH.IAPage.prototype.expand.bind(this));
                    $(".editable").attr("contenteditable", "true");

                    $("#add_example").on('click', function(evt) {
                        $(this).addClass("hide");
                        $("#input_example").removeClass("hide");
                    });

                    $("#input_example").on('focusout keypress', function(evt) {
                        if (evt.type === 'focusout' || (evt.type === 'keypress' && evt.which === 13)) {
                            var new_example = $(this).text();
                            if (new_example !== '') {
                                $(this).before('<li class="editpage"><div class="button delete listbutton"><span>-</span></div>' +
                                               '<a class="editable other-examples newentry" title="Try this example on DuckDuckGo" href="https://duckduckgo.com/?q=' +
                                               new_example + '">' + new_example + '</a></li>');
                            }
                            $(this).text("");
                            $(this).addClass("hide");
                            $("#add_example").removeClass("hide");
                        }
                    });

                    $("body").on('click focusout keypress', '.editable, .button.delete', function(evt) {
                       if ((evt.type === 'click' && $(this).hasClass("delete")) ||
                          (evt.type === 'focusout' && $(this).hasClass("editable")) ||
                          (evt.type === 'keypress' && evt.which === 13 && $(this).hasClass("editable"))) {
                            var field = $(this).attr('name');
                            var value;
                            if (evt.type === 'click') {
                                $(this).parent().remove();
                            }

                            if (field !== "topic" && field !== "other_queries" && field !== "code") {
                                value = $(this).text();
                            } else {
                                value = [];
                                var selector;
                                if (field === "topic") {
                                    selector = ".ia_topic a.editable";
                                } else if (field === "other_queries") {
                                    selector = "#examples a.other-examples";
                                } else {                            
                                    selector = "li.code.editable";
                                }

                                $(selector).each(function(index) {
                                    value.push($(this).text());
                                });

                                value = JSON.stringify(value);
                            }

                            var jqxhr = $.post("/ia/save", {
                                            field : field, 
                                            value : value,
                                            id : DDH_iaid
                                        })
                            .done(function(data) {
                                if (data.result) {
                                    //location.reload();
                                } else {
                                    if ($("#error").hasClass("hide")) {
                                        $("#error").removeClass("hide");
                                    }
                                }
                            });

                            if (evt.type === "keypress") {
                                return false;
                            }
                        }
                    });
                });
            }
        },

        expand: function() {
            $(".ia-single .dev-info").addClass("hide");
            $(".ia-single .dev-info-details").removeClass("hide");
        }        
    };

})(DDH);
