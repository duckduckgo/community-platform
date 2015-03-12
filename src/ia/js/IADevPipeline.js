(function(env) {

    DDH.IADevPipeline = function() {
        this.init();
    };

    DDH.IADevPipeline.prototype = {

        init: function() {
            // console.log("IADevPipeline init()");
            var dev_p = this;
            var url = window.location.pathname.replace(/\/$/, '') + "/json";
            var username = $(".user-name").text();

            $.getJSON(url, function(data) { 
                // console.log(window.location.pathname);
                var iadp;

                if (data.hasOwnProperty("planning")) {
                    iadp = Handlebars.templates.dev_pipeline(data);
                } else {
                    iadp = Handlebars.templates.dev_pipeline_live(data);
                }

                $("#dev_pipeline").html(iadp);
            });

            $("#create-new-ia").click(function(evt) {
                $(this).hide();
                $("#create-new-ia-form").removeClass("hide");
            });

            $("body").on('click', "#new-ia-form-cancel", function(evt) {
                $("#create-new-ia-form").addClass("hide");
                $("#create-new-ia").show();
            });

            $("body").on('click', "#new-ia-form-save", function(evt) {
                var name = $.trim($("#name-input").val());
                var id = $.trim($("#id-input").val());
                var description = $.trim($("#description-input").val());
                var dev_milestone = $.trim($("#dev_milestone-select .available_dev_milestones option:selected").text());
                if (name.length && id.length && dev_milestone.length && description.length) {
                    var jqxhr = $.post("/ia/create", {
                        name : name,
                        id : id,
                        description : description,
                        dev_milestone : dev_milestone
                    })
                    .done(function(data) {
                        window.location = '/ia/view/' + id;
                    });
                }
            });

            $("body").on('click', ".filter-issues__item__checkbox", function(evt) {
                if ($(this).hasClass("icon-check-empty")) {
                    $(".icon-check").removeClass("icon-check").addClass("icon-check-empty");

                    $(this).removeClass("icon-check-empty");
                    $(this).addClass("icon-check");

                    var issue_tag = $(this).attr("id");

                    $("#pipeline-live__list .pipeline-live__list__item").hide();
                    $("#pipeline-live__list .pipeline-live__list__item." + issue_tag).show();
                } else {
                    $(this).removeClass("icon-check");
                    $(this).addClass("icon-check-empty");

                    $("#pipeline-live__list .pipeline-live__list__item").show();
                }
            });

            $("#filter-team_checkbox").click(function(evt) {
                $(this).toggleClass("icon-check");
                $(this).toggleClass("icon-check-empty");

                if ($(this).hasClass("icon-check-empty")) {
                    $(".dev_pipeline-column__list li").show();
                } else {
                    $(".dev_pipeline-column__list li").hide();

                    if ($("#select-teamrole").length) {
                        var teamrole = $("#select-teamrole option:selected").text();
                        $(".dev_pipeline-column__list li." + teamrole + "-" + username).show();
                    } else {
                        // If the select elements doesn't exist
                        // then the user isn't an admin
                        // and therefore the only role he can fulfill is the developer
                        $(".dev_pipeline-column__list li.designer-" + username).show();
                    }
                }
            });

            $("#select-teamrole").change(function(evt) {
                if ($("#filter-team_checkbox").hasClass("icon-check")) {
                    $(".dev_pipeline-column__list li").hide();

                    var teamrole = $(this).find("option:selected").text();
                    $(".dev_pipeline-column__list li." + teamrole + "-" + username).show();
                }
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
 
