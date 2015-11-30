(function(env) {

    DDH.IADeprecated = function() {
        this.init();
    };

    DDH.IADeprecated.prototype = {

        init: function() {
            // console.log("IADeprecated init()");
            var dev_p = this;
            var url = window.location.pathname.replace(/\/$/, '') + "/json";

	    // 100% width
            $(".site-main > .content-wrap").first().removeClass("content-wrap").addClass("deprecated-wrap");
	    $(".breadcrumb-nav").remove();
	    $(".site-main").addClass("developer-main");

            $.getJSON(url, function(data) { 
                // console.log(window.location.pathname);
                var ia_deprecated = Handlebars.templates.dev_pipeline_deprecated(data.deprecated);
                $("#deprecated").html(ia_deprecated);

                if (data.ghosted) {
                    var ia_ghosted = Handlebars.templates.dev_pipeline_deprecated(data.ghosted);
                    $("#ghosted").html(ia_ghosted);
                }
            });

            $(".toggle-ghosted").click(function() {
                $(this).children("i").toggleClass("icon-check-empty");
                $(this).children("i").toggleClass("icon-check");
                $("#ghosted").toggleClass("hide");
            });
        }
    };
})(DDH);
 
