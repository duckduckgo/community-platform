(function(env) {


    // placeholder

    DDH.IAPageCommit = function(ops) {
        this.init(ops); 
    };

    // this could get the single IA json like the index.
    // but for now the page is being built with xslate
    DDH.IAPageCommit.prototype = {
        init: function(ops) {
            console.log("IAPageCommit.init()\n"); 

            if (DDH_iaid) {
                console.log("for ia id '%s'", DDH_iaid);

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
                    });

                    $("body").on('click', '#commit', function(evt) {
                        var values = [];
                        $('.updates_list .item_selected').each(function(idx) {
                            var temp_field = $(this).attr('name');

                            if (temp_field === "topic" || temp_field === "other_queries"
                                || temp_field === "code") {
                                var temp_value = [];
                                $('.updates_list .item_selected li').each(function(id) {
                                    temp_value.push($(this).text());
                                });
                            } else {
                                var temp_value = $(this).text().replace(/\"/g, "");
                            }
                            
                            values.push({'field':temp_field, 'value':temp_value});
                        });

                        DDH.IAPageCommit.prototype.save(values);
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
                id: DDH_iaid
            })
            .done(function(data) {
                if (data.result) {
                    window.location = '/ia/view/' + DDH_iaid;
                }
            });
        }
    };

})(DDH);
 
