(function(env) {

    DDH.IAIssues = function() {
        this.init();
    };

    DDH.IAIssues.prototype = {

        init: function() {
            // console.log("IAIssues init()");
            var issues_p = this;
            var url = window.location.pathname.replace(/\/$/, '') + "/json";

            $.getJSON(url, function(data) { 
                // console.log(window.location.pathname);
                var ia_issues;
                ia_issues = Handlebars.templates.issues(data);
                $("#issues").html(ia_issues);

                var parameters = window.location.search.replace("?", "");
                parameters = $.trim(parameters.replace(/\/$/, ''));
                if (parameters) {
                    parameters = parameters.split("&");

                    $.each(parameters, function(idx) {
                        var temp = parameters[idx].split("=");
                        var field = temp[0];
                        var value = temp[1];
                        if ((field === "tag") && value) {
                            $("#issue-" + value).trigger("click");
                        }
                    });
                }
            });

            $("body").on('click', ".filter-issues__item__checkbox", function(evt) {
                var url = "";

                if ($(this).hasClass("icon-check-empty")) {
                    $(".icon-check").removeClass("icon-check").addClass("icon-check-empty");

                    $(this).removeClass("icon-check-empty");
                    $(this).addClass("icon-check");

                    var issue_tag = $(this).attr("id");
                    url += "&tag=" + issue_tag.replace("issue-", "");
                    
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

                url = url.length? "?" + url.replace("#", "") : "/issues";
                
                // Allows changing URL without reloading, since it doesn't add the new URL to history;
                // Not supported on IE8 and IE9.
                history.pushState({}, "IA Pages Issues", url);
            });
        }
    };
})(DDH);
 
