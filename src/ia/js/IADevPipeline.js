(function(env) {

    DDH.IADevPipeline = function() {
        this.init();
    };

    DDH.IADevPipeline.prototype = {

        init: function() {
            //console.log("IADevPipeline init()");
            var dev_p = this;
            var url = window.location.pathname + "/json";

            $.getJSON(url, function(data) { 
                console.log(window.location.pathname);
                var iadp;

                if (data.hasOwnProperty("planning")) {
                    iadp = Handlebars.templates.dev_pipeline(data);
                } else {
                    iadp = Handlebars.templates.dev_pipeline_live(data);
                }

                $("#dev_pipeline").html(iadp);
            });

            $("#pipeline_toggle-dev").click(function(evt) {
                if (!$(this).hasClass("disabled")) {
                    window.location = "/ia/pipeline/dev";
                }   
            });

            $("#pipeline_toggle-live").click(function(evt) {
                if (!$(this).hasClass("disabled")) {
                    window.location = "/ia/pipeline/live";
                }
            });
        }
    };
})(DDH);
 
