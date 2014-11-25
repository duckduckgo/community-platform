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
                    var iapc = Handlebars.templates.commit_page(x);
                    $("#ia_commit").html(iapc);

                    $("body").on('click', '.updates_list ul li', function(evt) {
                        $(this).parent().find('li').removeClass("item_selected");
                        $(this).removeClass("item_focused");
                        $(this).addClass("item_selected");
                    });

                    $("body").on('click', '#commit', function(evt) {
                        var values = [];
                        $('.updates_list ul li.item_selected').each(function(idx) {
                            var temp_value = $(this).text();
                            var temp_id = $(this).attr('id');
                            var temp_field = temp_id.substring(0, temp_id.lastIndexOf('_'));
                            
                            values.push({'field':temp_field, 'value':temp_value});
                        });

                        DDH.IAPageCommit.prototype.save(values);
                    });

                    $("body").on('mouseenter mouseleave', '.updates_list ul li', function(evt) {
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
                    window.location('/ia/view/' + DDH_iaid);
                }
            });
        }
    };

})(DDH);
 
