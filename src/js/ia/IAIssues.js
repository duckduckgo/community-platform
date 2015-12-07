(function(env) {

    DDH.IAIssues = function() {
        this.init();
    };

    DDH.IAIssues.prototype = {

        sort_by_date: false,
        selected_tag: '',
	ia_issues: {},

	render: function() {
	    $('#issues').html(this.ia_issues);
	    
	    $('.filter-all').attr('data-count', $('.issues-list li[data-repo]').length);
	    $('.filter-lhf').attr('data-count', $('.issues-list .tag-lowhangingfruit').length);
	    $('.filter-bugs').attr('data-count', $('.issues-list .tag-bug').length);
	},

        init: function() {
            // console.log("IAIssues init()");
            var issues_p = this;
            var url = window.location.pathname.replace(/\/$/, '') + "/json";

	    // 100% width
            $(".site-main > .content-wrap").first().removeClass("content-wrap").addClass("issues-wrap");
	    $(".breadcrumb-nav").remove();
	    $(".site-main").addClass("developer-main");

	    $('#wrapper').css('min-width', '1200px');
	    
            $.getJSON(url, function(data) { 
		console.log(data);
                // console.log(window.location.pathname);
                var ia_issues;
                ia_issues = Handlebars.templates.issues(data);

		issues_p.ia_issues = ia_issues;
		issues_p.render();

		$('.filter-all').addClass('selected');

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
                        } else if ((field === "sort") && (value === "date")) {
                            $("#sort_date").trigger("click");
                        }
                    });
                }
            });

            $("body").on('click', "#sort_date", function(evt) {
                issues_p.sort_by_date = true;
                $("#pipeline-live__list .by_ia_item").addClass("hide");
                issues_p.filter();
            });

            $("body").on('click', "#sort_ia", function(evt) {
                issues_p.sort_by_date = false;
                $("#pipeline-live__list .by_date_item").addClass("hide");
                issues_p.filter();
            });

            $("body").on('click', ".filter-issues__item__checkbox", function(evt) {
                var url = "";

                if ($(this).hasClass("icon-check-empty")) {
                    $(".filter-issues__item__checkbox.icon-check").removeClass("icon-check").addClass("icon-check-empty");

                    $(this).removeClass("icon-check-empty");
                    $(this).addClass("icon-check");

                    issues_p.selected_tag = "." + $(this).attr("id");
                } else {
                    $(this).removeClass("icon-check");
                    $(this).addClass("icon-check-empty");
                    issues_p.selected_tag = '';
                }

                issues_p.filter();
            });

	    $('#issues').on('click', 'a[data-filter]', function(evt) {
		evt.preventDefault();
		issues_p.render();

		$('.issues-list .filter-' + $(this).data('type')).addClass('selected');
		if($(this).data('filter')) {
		    $('li[data-repo]').not($(this).data('filter')).hide();
		}
	    });
        },

        filter: function() {
            var selector = this.sort_by_date? "#pipeline-live__list .by_date_item" : "#pipeline-live__list .by_ia_item";
            var url = this.sort_by_date? "&sort=date" : "";

            if (this.selected_tag.length) {
                var value = this.selected_tag.replace(".issue-", "");
                url += "&tag=" + value;
                
                $(selector).addClass("hide");
                $(selector + " .list-container--right__issues li").addClass("hide");
                $(selector + this.selected_tag).removeClass("hide");
                $(selector + " .list-container--right__issues li" + this.selected_tag).removeClass("hide");
            } else {
                $(selector).removeClass("hide");
                $(selector + " .list-container--right__issues li").removeClass("hide");
            }

            url = url.length? "?" + url.replace("#", "").replace("&", "") : "issues";
            
            // Allows changing URL without reloading, since it doesn't add the new URL to history;
            // Not supported on IE8 and IE9.
            history.pushState({}, "IA Pages Issues", url);
        }
    };
})(DDH);
 
