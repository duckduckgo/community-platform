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
                iadp = Handlebars.templates.dev_pipeline(data.dev_milestones);
                $("#dev_pipeline").html(iadp);

                // 100% width
                $(".site-main > .content-wrap").first().removeClass("content-wrap").addClass("wrap-pipeline");
            });

            $("#create-new-ia").click(function(evt) {
                $(this).hide();
                $("#create-new-ia-form").removeClass("hide");
            });

            $("body").on('click', "#new-ia-form-cancel", function(evt) {
                $("#create-new-ia-form").addClass("hide");
                $("#create-new-ia").show();
            });

            $("body").on("focusin", "#id-input.not_saved", function(evt) {
                $(this).removeClass("not_saved");
            });

            $("body").on('click', "#new-ia-form-save", function(evt) {
                var $id_input = $("#id-input");
                var name = $.trim($("#name-input").val());
                var id = $.trim($id_input.val());
                var description = $.trim($("#description-input").val());
                var dev_milestone = $.trim($("#dev_milestone-select .available_dev_milestones option:selected").text());
                
                if (name.length && id.length && dev_milestone.length && description.length) {
                    id = id.replace(/\s/g, '');

                    var jqxhr = $.post("/ia/create", {
                        name : name,
                        id : id,
                        description : description,
                        dev_milestone : dev_milestone
                    })
                    .done(function(data) {
                        if (data.result && data.id) {
                            window.location = '/ia/view/' + data.id;
                        } else {
                            $id_input.addClass("not_saved");
                        }
                    });
                }
            });

            $("body").on("keypress", ".search-thing", function(evt) {
                if(evt.type === "keypress" && evt.which === 13) {
                    var query = $(this).val();
                    var re = new RegExp(query, 'i');
                    var isBlank = query === "";

                    var showHideFunc = function(a, b) {
                        var $ia = $(b);
                        
                        if(!re.test($ia.text()) && !isBlank) {
                            $ia.parent().parent().hide();
                        } else {
                            $ia.parent().parent().show();
                        }
                    };

                    $("#pipeline-planning .item-name a").each(showHideFunc);
                    $("#pipeline-development .item-name a").each(showHideFunc);
	            $("#pipeline-testing .item-name a").each(showHideFunc);
                    $("#pipeline-complete .item-name a").each(showHideFunc);
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
        }
    };
})(DDH);
 
