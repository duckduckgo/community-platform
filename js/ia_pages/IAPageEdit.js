(function(env) {


    // placeholder

    DDH.IAPageEdit = function(ops) {
        this.init(ops); 
    };

    // this could get the single IA json like the index.
    // but for now the page is being built with xslate
    DDH.IAPageEdit.prototype = {
        init: function(ops) {
            console.log("IAPageEdit.init()\n"); 

            if (DDH_iaid) {
                console.log("for ia id '%s'", DDH_iaid);

                $.getJSON("/ia/view/" + DDH_iaid + "/json", function(x) {
                    var ia = Handlebars.templates.editpage(x);
                    $(".ia-single").html(ia);
                    $(".ia-single .dev-info").on('click', DDH.IAPageEdit.prototype.expand.bind(this));
                    $(".editable").on('click', function(evt) {
                        $(this).attr("contenteditable", "true");
                    }); 
                    $(".editable").on('focusout', function(evt) {
                        $(this).attr("contenteditable", "false");
                    });

                    $("#save").on('click', function(evt) {
                        var description =$("#desc").text();
                        console.log(description);
                        var jqxhr = $.post("/ia/save", {description : description, id : DDH_iaid.replace("#", "")})
                        .done(function(data) {
                            if (data) {
                                window.location = "/ia/view/" + DDH_iaid;
                            }
                        });
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
