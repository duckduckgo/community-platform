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

	    // 100% width
            $(".site-main > .content-wrap").first().removeClass("content-wrap").addClass("overview-wrap");
	    $(".breadcrumb-nav").remove();
	    $(".site-main").addClass("developer-main");

	    $('#wrapper').css('min-width', '1200px');

            $.getJSON(url, function(data) { 
		console.log(data);
                var template = Handlebars.templates.overview(data);

                $("#ia-overview").html(template);
            });

        }
    };
})(DDH); 
