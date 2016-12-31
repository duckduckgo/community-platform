(function(env) {


    // placeholder

    DDH.IAPageCommit = function(ops) {
        this.init(ops); 
    };

    // this could get the single IA json like the index.
    // but for now the page is being built with xslate
    DDH.IAPageCommit.prototype = {
        init: function(ops) {
            //console.log("IAPageCommit.init()\n"); 

            if (DDH_iaid) {
                //console.log("for ia id '%s'", DDH_iaid);

                $.getJSON("/ia/commit/" + DDH_iaid + "/json", function(x) {
                    if (x.redirect) {
                        window.location = "/ia/view/" + DDH_iaid;
                    } else {
                        var iapc = Handlebars.templates.commit_page(x);
                        $("#ia_commit").html(iapc);
                    }

                    $("body").on('click', '.updates_list td', function(evt) {
                        $(this).parent().find('td').removeClass("item_selected");
                        $(this).removeClass("item_focused");
                        $(this).addClass("item_selected");

                        // Enable commit button only if a version (either live or edited)
                        // has been selected for each field 
                        if ($("#commit").hasClass("disabled")) {
                            if ($("tr.updates_list").length === $("td.item_selected").length) {
                                $("#commit").removeClass("disabled");
                            }
                        }
                    });

                    $("body").on('click', '#commit', function(evt) {
                        if (!$(this).hasClass('disabled')) {
                            var values = [];
                            var is_json = false;
                            $('.updates_list .item_selected').each(function(idx) {
                                var temp_field = $(this).attr('name');
                                var temp_value;

                                if (temp_field === "topic" || temp_field === "other_queries" || temp_field === "developer"
                                    || temp_field === "triggers" || temp_field === "perl_dependencies") {
                                    temp_value = [];
                                    is_json = true;
                                    $('.updates_list .item_selected li').each(function(id) {
                                        if ($(this).parent().attr('name') === temp_field) {
                                            if (temp_field === "developer") {
                                                var temp_dev = {};
                                                temp_dev.name = $.trim($(this).text());
                                                temp_dev.type = $.trim($(this).attr("data-type"));
                                                temp_dev.url = $.trim($(this).attr("data-url"));

                                                temp_value.push(temp_dev);
                                            } else {
                                                temp_value.push($.trim($(this).text()));
                                            }
                                        }
                                    });
                                } else if (temp_field === "src_options") {
                                    temp_value = {};
                                    is_json = true;
                                    $('.item_selected .src_options-group li .section-group__item').each(function(id) {
                                        var subfield = $(this).attr("data-field");

                                        if ($(this).hasClass("icon-check")) {
                                            temp_value[subfield] = 1;
                                        } else if ($(this).hasClass("icon-check-empty")) {
                                            temp_value[subfield] = 0;
                                        } else {
                                            temp_value[subfield] = $.trim($(this).text().replace(/\"/g, ""));
                                        } 
                                    });
                                } else if (temp_field === "answerbar") {
                                    is_json = true;
                                    temp_value = {};
                                    temp_value.fallback_timeout = $.trim($(this).text().replace(/\"/g, ""));
                                } else {
                                    temp_value = $.trim($(this).text().replace(/\"/g, ""));

                                    if (temp_field === "src_id") {
                                        temp_value = parseInt(temp_value);
                                    } else if ((temp_field === "blockgroup" || temp_field === "deployment_state") && temp_value === "") {
                                        temp_value = null;
                                    }
                                }
                                
                                if (is_json && (temp_field !== "topic")) {
                                    temp_value = JSON.stringify(temp_value);
                                    is_json = false;
                                }

                                values.push({'field':temp_field, 'value':temp_value});
                            });

                            DDH.IAPageCommit.prototype.save(values);
                        }
                    });

                    $("body").on('mouseenter mouseleave', '.updates_list td', function(evt) {
                        if (!$(this).hasClass("item_selected")) {
                            $(this).toggleClass("item_focused");
                        }
                    });
                });
            }
        },

        save: function(values) { 
            var jqxhr = $.post("/ia/commit/" + DDH_iaid + "/save", {
                values: JSON.stringify(values),
                id: DDH_iaid,
                action_token: $.trim($('meta[name=action-token]').attr("content")) 
            })
            .done(function(data) {
                if (data.result && data.result.saved) {
                    window.location = '/ia/view/' + data.result.id;
                }
            });
        }
    };

})(DDH);
 
