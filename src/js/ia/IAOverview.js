(function(env) {

    DDH.IAOverview = function() {
        this.init();
    };

    DDH.IAOverview.prototype = {

        init: function() {
            console.log("IAOverview init()");
            var overview = this;
            var url = window.location.pathname.replace(/\/$/, '') + "/json";
            var username = $(".user-name").text();

            console.log(url);

            $.getJSON(url, function(data) { 
                console.log(data);

                var template = Handlebars.templates.overview(data);

                $("#ia-overview").html(template);
            });
        }
    };
})(DDH); 
