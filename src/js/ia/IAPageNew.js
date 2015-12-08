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

            $("#new_ia_wizard_save").click(function(evt) {
                var data = {};
                $(".wizard_field").each(function(idx) {
                    var $temp_el = $(this).find(".wizard_field_insert");
                    var temp_id = $temp_el.attr("id");
                    var temp_field = temp_id.replace(/\-[^\-]+$/, "");
                    console.log(temp_field);
                    var temp_type = temp_id.replace(/^.+\-/, "");
                    var temp_val = (temp_type === "select")? $.trim($temp_el.find("option:selected").text()) : $.trim($temp_el.val());

                    if (temp_field) {
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
        }
    };
})(DDH); 
