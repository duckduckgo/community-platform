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

            $("body").on('click', "#new-ia-form-save", function(evt) {
                var $id_input = $("#id-input");
                var name = $.trim($("#name-input").val());
                var id = $.trim($id_input.val());
                var description = $.trim($("#description-input").val());
                var dev_milestone = $.trim($("#dev_milestone-select .available_dev_milestones option:selected").text());

                var data = {
                    name : name,
                    id : id,
                    description : description,
                    dev_milestone : dev_milestone
                };
                
                if (name.length && id.length && dev_milestone.length && description.length) {
                    id = id.replace(/\s/g, '');

                    var jqxhr = $.post("/ia/create", {
                        data : JSON.stringify(data) 
                    })
                    .done(function(data) {
                        checkRedirect(data, $id_input);
                    });
                }
            });

            function checkRedirect(data, $input) {
                if (data.result && data.id) {
                    window.location = '/ia/view/' + data.id;
                } else {
                    $input.addClass("not_saved");
                }
            }
        }
    };
})(DDH); 
