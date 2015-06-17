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
        }
    };
})(DDH); 
