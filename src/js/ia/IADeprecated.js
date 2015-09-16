(function(env) {

    DDH.IADeprecated = function() {
        this.init();
    };

    DDH.IADeprecated.prototype = {

        init: function() {
            // console.log("IADeprecated init()");
            var dev_p = this;
            var url = window.location.pathname.replace(/\/$/, '') + "/json";

            $.getJSON(url, function(data) { 
                // console.log(window.location.pathname);
                var ia_deprecated = Handlebars.templates.dev_pipeline_deprecated(data.deprecated);
                $("#deprecated").html(ia_deprecated);

                if (data.ghosted) {
                    var ia_ghosted = Handlebars.templates.dev_pipeline_deprecated(data.ghosted);
                    $("#ghosted").html(ia_ghosted);
                }
            });
        }
    };
})(DDH);
 
