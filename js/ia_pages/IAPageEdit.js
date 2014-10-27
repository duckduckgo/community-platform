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
            var edited = false; 

            if (DDH_iaid) {
                console.log("for ia id '%s'", DDH_iaid);

                $.getJSON("/ia/view/" + DDH_iaid + "/json", function(x) {
                    var ia = Handlebars.templates.editpage(x);
                    $(".ia-single").html(ia);
                    $(".ia-single .dev-info").on('click', DDH.IAPageEdit.prototype.expand.bind(this));
                    $(".editable").attr("contenteditable", "true");
                    $(".editable").on('keydown', function(evt) {
                        if ($("#save").hasClass("disabled")) {
                            $("#save").removeClass("disabled");
                        }

                        if (!edited) {
                            edited = true;
                        }
                    });

                    $("#save").on('click', function(evt) {
                       if (edited) {
                            var topics = [];
                            $(".ia_topic a.editable").each(function(index) {
                                topics.push($(this).text());
                            });

                            var examples = [];
                            $("#examples a.other-examples").each(function(index) {
                                examples.push($(this).text());
                            });
                        
                            var code = [];
                            $("li.code.editable").each(function(index) {
                                code.push($(this).text());
                            });

                            var jqxhr = $.post("/ia/save", {
                                            description : $("#desc").text(), 
                                            name : $("#name").text(),
                                            status : $(".status").text(),
                                            topic : JSON.stringify(topics),
                                            example : $("#examples a#primary").text(),
                                            other_examples : JSON.stringify(examples),
                                            code : JSON.stringify(code),
                                              id : DDH_iaid
                                        })
                            .done(function(data) {
                                if (data) {
                                    window.location = "/ia/view/" + DDH_iaid;
                                }
                            });
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
