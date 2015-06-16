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
                var ia_deprecated;
                ia_deprecated = Handlebars.templates.dev_pipeline_deprecated(data.repos);
                $("#deprecated").html(ia_deprecated);
            });

            $("#pipeline_toggle-dev").click(function(evt) {
                if (!$(this).hasClass("disabled")) {
                    window.location = "/ia/dev/pipeline";
                }   
            });

            $("#pipeline_toggle-live").click(function(evt) {
                if (!$(this).hasClass("disabled")) {
                    window.location = "/ia/dev/issues";
                }
            });

            $("#pipeline_toggle-home").click(function(evt) {
                if (!$(this).hasClass("disabled")) {
                    window.location = "/ia/dev";
                }
            });
        }
    };
})(DDH);
 
