(function(env) {

    DDH.IAIssues = function() {
        this.init();
    };

    DDH.IAIssues.prototype = {

        init: function() {
            // console.log("IAIssues init()");
            var dev_p = this;
            var url = window.location.pathname.replace(/\/$/, '') + "/json";

            $.getJSON(url, function(data) { 
                // console.log(window.location.pathname);
                var ia_issues;
                ia_issues = Handlebars.templates.dev_pipeline_live(data);
                $("#issues").html(ia_issues);
            });

            $("body").on('click', ".filter-issues__item__checkbox", function(evt) {
                if ($(this).hasClass("icon-check-empty")) {
                    $(".icon-check").removeClass("icon-check").addClass("icon-check-empty");

                    $(this).removeClass("icon-check-empty");
                    $(this).addClass("icon-check");

                    var issue_tag = $(this).attr("id");

                    $("#pipeline-live__list .pipeline-live__list__item").hide();
                    $("#pipeline-live__list .pipeline-live__list__item .list-container--right__issues li").hide();
                    $("#pipeline-live__list .pipeline-live__list__item." + issue_tag).show();
                    $("#pipeline-live__list .pipeline-live__list__item .list-container--right__issues li").each(function(idx) {
                        if ($(this).find(".issues_col__tags." + issue_tag).length) {
                            $(this).show();
                        }
                    });
                } else {
                    $(this).removeClass("icon-check");
                    $(this).addClass("icon-check-empty");

                    $("#pipeline-live__list .pipeline-live__list__item").show();
                    $("#pipeline-live__list .pipeline-live__list__item .list-container--right__issues li").show();
                }
            });
        }
    };
})(DDH);
 
