(function(env) {

    DDH.IADevPipeline = function() {
        this.init();
    };

    DDH.IADevPipeline.prototype = {

        init: function() {
            //console.log("IADevPipeline init()");
            var dev_p = this;
            var url = "/ia/pipeline/json";

            $.getJSON(url, function(data) { 
                console.log(data);
                var iadp = Handlebars.templates.dev_pipeline(data);
                $("#dev_pipeline").html(iadp);
            });
        }
    };
})(DDH);
 
