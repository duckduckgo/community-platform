(function(env) {

    DDH.IAOverview = function() {
        this.init();
    };

    DDH.IAOverview.prototype = {

        init: function() {
            // console.log("IAOverview init()");
            var overview = this;
            var url = window.location.pathname.replace(/\/$/, '') + "/json";
            var username = $(".user-name").text();

            $.getJSON(url, function(data) { 
                var template = Handlebars.templates.overview(data);

                $("#ia-overview").html(template);
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

            $("#pipeline_toggle-deprecated").click(function(evt) {
                if (!$(this).hasClass("disabled")) {
                    window.location = "/ia/dev/deprecated";
                }
            });
 
        }
    };
})(DDH); 
