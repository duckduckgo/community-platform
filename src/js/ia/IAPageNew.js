(function(env) {

    DDH.IAPageNew = function() {
        this.init();
    };

    DDH.IAPageNew.prototype = {

        init: function() {
            // console.log("IAPageNew init()");
            var page_new = this;
                
            // 100% width
            $(".site-main > .content-wrap").first().removeClass("content-wrap").addClass("wrap-pipeline");
            $(".breadcrumb-nav").remove();

             $("body").on("click", "#create-ia-from-pr", function(evt) {
                $("#create-ia-from-pr").addClass("hide");
                $("#create-ia-from-pr-form, #create-ia-from-pr-bg").removeClass("hide");
            });

            $("body").on('click', "#create-ia-from-pr-cancel", function(evt) {
                var $modal = $("#create-ia-from-pr-form");
                $modal.addClass("hide");
                $("#create-ia-from-pr-bg").addClass("hide");
                $modal.find("input, textarea").val("").removeClass("not_saved");
                $("#create-ia-from-pr").removeClass("hide");
            });

            $("body").on("click", "#create-ia-from-pr-save", function(evt) {
                var $pr_input = $("#pr-input");
                var pr = $.trim($pr_input.val());
                if (pr.length) {
                    var jqxhr = $.post("/ia/create_from_pr", {
                        pr : pr
                    })
                    .done(function(data) {
                        console.log(data);
                        checkRedirect(data, $pr_input);
                    });
                }
            });
            
            $("#new_ia_wizard_save").click(function(evt) {
                var data = {};
                $(".wizard_field").each(function(idx) {
                    var $temp_el = $(this).find(".wizard_field_insert");
                    var temp_id = $temp_el.attr("id");
                    var temp_field = temp_id.replace(/\-[^\-]+$/, "");
                    console.log(temp_field);
                    var temp_type = temp_id.replace(/^.+\-/, "");
                    var temp_val = (temp_type === "radio")? $.trim($temp_el.find('input[type="radio"]:checked').val()) : $.trim($temp_el.val());

                    if (temp_field) {
                        temp_field = temp_field.replace(/^.+\-/, "");
                        data[temp_field] = temp_val;
                    }
                });

                data.id = data.name;

                if (data.id) {
                    var jqxhr = $.post("/ia/create", {
                        data : JSON.stringify(data)
                    })
                    .done(function(data) {
                        console.log(data);
                        if (data.result && data.id) {
                            window.location = '/ia/view/' + data.id;
                        }
                    });
                }
            });
            
            function checkRedirect(data, $input) {
                if (data.result && data.id) {
                    window.location = '/ia/view/' + data.id;
                } else {
                    $input.addClass("not_saved");
                }
            }
        }
    };
})(DDH); 
