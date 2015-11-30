(function(env) {

    DDH.IADevPipeline = function() {
        this.init();
    };

    DDH.IADevPipeline.prototype = {
        filters: [
            'missing',
            'important',
            'mentioned',
            'attention'
        ],

        current_filter: '',

        by_priority: false,

        query: '',

        data: {},

        init: function() {
	    $('#wrapper').css('min-width', '1200px');

            // console.log("IADevPipeline init()");
            var dev_p = this;
            var url = window.location.pathname.replace(/\/$/, '') + "/json";
            var username = $(".user-name").text();

	    // 100% width
            $(".site-main > .content-wrap").first().removeClass("content-wrap").addClass("wrap-pipeline");
	    $(".breadcrumb-nav").remove();
	    $(".site-main").addClass("developer-main");


            $.getJSON(url, function(data) { 
                // console.log(window.location.pathname);
                // Check user permissions and add to the data
                if ($("#create-new-ia").length) {
                    data.permissions = {};
                    data.permissions.admin = 1;
                    $("#sort_pipeline select option:selected").val(0);
                    dev_p.by_priority = true;
                }

                // Get username for the at mentions filter
                var username = $.trim($(".header-account-info .user-name").text());
                data.username = username;

                dev_p.data = data;
                
                var stats = Handlebars.templates.dev_pipeline_stats(data.dev_milestones);

                sort_pipeline();

                if ($.trim($("#select-action option:selected").text()) === "type") {
                    $("#select-milestone").addClass("hide");
                    $("#select-type").removeClass("hide");
                }

                var parameters = window.location.search.replace("?", "");
                parameters = $.trim(parameters.replace(/\/$/, ''));
                if (parameters) {
                    parameters = parameters.split("&");

                    var param_count = 0;

                    for (var idx = 0; idx < parameters.length; idx++) {
                        var temp = parameters[idx].split("=");
                        var field = temp[0];
                        var value = temp[1];

                        if (field && value && ((dev_p.filters.indexOf(value) !== -1) || field === "q")) {
                            if ((field === "q") && value) {
                                $(".search-thing").val(decodeURIComponent(value.replace(/\+/g, " ")));

                                //create return keypress event
                                var evt = $.Event("keypress");
                                evt.which = 13;
                                $(".search-thing").trigger(evt);
                                param_count++;
                            } else if (field === "filter") {
                                $("#filter-" + value).trigger("click");
                                param_count++;
                            }
                        }
                    }

                    if (param_count === 0) {
                        filter('', true);
                    }
                } else {
                    filter('', true);
                }
            });

            $("body").on("click", "#asana-create", function(evt) {
                if (!$(this).hasClass("disabled")) {
                    create_task($.trim($("#edit-sidebar-id").val()));
                    $(this).addClass("disabled");
                }
            });

            $("body").on("click", "#pipeline_toggle-dev", function(evt) {
                dev_p.query = "";

                $(".search-thing").val("");
                $(".active-filter").removeClass("active-filter");
                filter('', true);
            });

            $("body").on("change", "#sort_pipeline select", function(evt) {
                var option = parseInt($(this).find("option:selected").val());
                console.log("option: " + option);
                dev_p.by_priority = option? false : true;
                console.log("priority: " + dev_p.by_priority);
                sort_pipeline();
            });

            $("body").on("focusin", "#id-input.not_saved", function(evt) {
                $(this).removeClass("not_saved");
            });

            $("body").on("keypress", ".search-thing", function(evt) {
                if(evt.type === "keypress" && evt.which === 13) {
                    dev_p.query = $(this).val();
                    $("#pipeline-clear-filters").removeClass("hide");
                    filter();
                }
            });

            $("body").on("click", "#beta_install", function(evt) {
                if (!$(this).hasClass("disabled")) {
                    $(this).addClass("disabled");
                    var prs = [];
                    $(".dev_pipeline-column__list .selected").each(function(idx) {
                        var temp_pr = $.trim($(this).find(".item-activity a").attr("href"));
                        var temp_hash = pr_hash(temp_pr);

                        if (temp_hash) {
                            prs.push(temp_hash);
                        }
                    });

                    if (prs.length) {
                        send_to_beta(JSON.stringify(prs));
                    }
                }
            });

            $("body").on("click", "#beta-single", function(evt) {
                if (!$(this).hasClass("disabled")) {
                    $(this).addClass("disabled");
                    var prs = [];
                    var pr = $.trim($("#pr").attr("href"));
                    var tmp_hash = pr_hash(pr);

                    if (pr_hash) {
                        prs.push(tmp_hash);
                        send_to_beta(JSON.stringify(prs));
                    }
                }
            });

            $("body").on("click", ".dev_pipeline-column__list li", function(evt) {
                var $items = $(".dev_pipeline-column__list .selected");
                var was_selected = $(this).hasClass("selected");
                var multiselect = false;
                
                if (evt.shiftKey || was_selected || (!dev_p.data.hasOwnProperty("permissions"))) {
                    if ((!dev_p.data.hasOwnProperty("permissions"))) {
                        $(".selected").removeClass("selected");
                    }
                    
                    $(this).toggleClass("selected");
                    if (evt.shiftKey) {
                        evt.preventDefault();
                        multiselect = true;
                    }
                } else {
                    $items.toggleClass("selected"); 
                
                    if (!was_selected) {
                        $(this).toggleClass("selected");
                    }
                }
                
                // can't use caching here since the set of selected IAs changed
                // in the meantime
                var selected = $(".dev_pipeline-column__list .selected").length;
                
                if (selected > 1) {
                    $(".pipeline-actions").removeClass("hide");
                } else {
                    $(".pipeline-actions").addClass("hide");
                }

                appendSidebar(selected, multiselect);
            });

            $('body').on('focus', '.edit-sidebar', function(evt) {
            var focus_class = $(this).data('focus-class');
            if(focus_class) {
                $(this).addClass(focus_class);
            }
            });

            $('body').on('blur', '.edit-sidebar', function(evt) {
            $(this).removeClass('frm__input').removeClass('frm__text');
            });

            $("body").on("keypress change", ".edit-sidebar", function(evt) {
                if ((evt.type === "keypress" && evt.which === 13) || (evt.type === "change" && $(this).children("select").length)) {
                   var field = $(this).attr("id").replace("edit-sidebar-", "");
                   if ((field !== "description") || (field === "description" && evt.ctrlKey)) {
                       var value = (evt.type === "change")? $.trim($(this).find("option:selected").text()) : $.trim($(this).val());
                       var id = $("#page_sidebar").attr("ia_id");

                       autocommit(field, value, id);
                   }
                }
            });

            $("body").on("click", "#sidebar-close, .deselect-all", function(evt) {
                var $selected = $(".dev_pipeline-column__list .selected");
                $selected.removeClass("selected");

                // remove sidebar
                appendSidebar(0);
               
                console.log("Saved: " + dev_p.saved);
                if (dev_p.saved) {
                    var jqxhr = $.getJSON(url, function (data) {
                        dev_p.saved = false;
                        dev_p.data.dev_milestones = data.dev_milestones;

                        //var iadp = Handlebars.templates.dev_pipeline(data);
                        //$("#dev_pipeline").html(iadp);
                        sort_pipeline();
                        filter();
                    });
                }
            });

             $("body").on("click", ".pipeline-filter", function(evt) {
                if (!$(this).hasClass("active-filter")) {
                    $(".active-filter").removeClass("active-filter");
                    $(this).addClass("active-filter");
                    var which_filter = $(this).attr("id").replace("filter-", "");
                    
                    filter(which_filter);
                    console.log("filtering from triggered event");
                } else {
                    $(this).removeClass("active-filter");
                    filter('', true);
                }
            });

            $("body").on("keypress change", ".pipeline-actions__select, .pipeline-actions__input", function(evt)  {
                if ((evt.type === "keypress" && evt.which === 13 && $(this).hasClass("pipeline-actions__input")) 
                   || (evt.type === "change" && $(this).hasClass("pipeline-actions__select"))) {
                    var ias = [];
                    var field, value;
                    if (evt.type === "change") {
                        field = $.trim($(this).attr("id").replace("select-", ""));
                        value = $.trim($(this).find("option:selected").text().replace(/\s/g, "_"));
                    } else {
                        field = $.trim($(this).attr("id").replace("input-", ""));
                        value = $.trim($(this).val());
                    }

                    $(".dev_pipeline-column__list .selected").each(function(idx) {
                        var temp_id = $.trim($(this).attr("id").replace("pipeline-list__", ""));
                        
                        ias.push(temp_id);
                    });

                    ias = JSON.stringify(ias);
                    save_multiple(ias, field, value);
                }
            });

            $("body").on("click", ".toggle-details i", function(evt) {
                toggleCheck($(this));

                $(".activity-details").toggleClass("hide");
            });

            $("#select-teamrole").change(function(evt) {
                if ($("#filter-team_checkbox").hasClass("icon-check")) {
                    $(".dev_pipeline-column__list li").hide();

                    var teamrole = $(this).find("option:selected").text();
                    $(".dev_pipeline-column__list li." + teamrole + "-" + username).show();
                }
            });

            function pr_hash(href) {
                var temp_pr_id = href.replace(/.*\//, "");
                var temp_repo = href.replace(/^.*\/duckduckgo\//, "").replace(/\/[a-zA-Z0-9]*\/[a-zA-Z0-9]*\/?/, "");

                if (temp_pr_id && temp_repo) {
                    var temp_hash = 
                        {
                            "action" : "duckco",
                            "number" : temp_pr_id,
                            "repo" : temp_repo
                        };
                    return temp_hash;
                }

                return false;
            }

            function send_to_beta(prs) {
                var jqxhr = $.post("/ia/send_to_beta", {
                    data : prs
                })
                .done(function(data) {
                    dev_p.saved = true;
                });
            }

            function autocommit(field, value, id) {
               var jqxhr = $.post("/ia/save", {
                   field : field,
                   value : value,
                   id : id,
                   autocommit : 1
               })
               .done(function(data) {
                   if (data.result.saved) {
                       dev_p.saved = true;
                   }
               });
            }

            function toggleCheck($obj) {
                $obj.toggleClass("icon-check");
                $obj.toggleClass("icon-check-empty");
            }

            function appendSidebar(selected, multi) {
                $("#page_sidebar, #actions_sidebar").addClass("hide").empty();
                $("#page_sidebar").attr("ia_id", "");
                
                if ((!multi) && selected === 1) {
                    var $item = $(".dev_pipeline-column__list .selected");
                    var meta_id = $item.attr("id").replace("pipeline-list__", "");
                    var milestone = $item.parents(".dev_pipeline-column").attr("id").replace("pipeline-", "");
                    var page_data = getPageData(meta_id, milestone);
                    page_data.permissions = dev_p.data.permissions;
                    if (page_data) {
                        var sidebar = Handlebars.templates.dev_pipeline_detail(page_data);            
                    
                        $("#page_sidebar").html(sidebar).removeClass("hide");
                        $("#page_sidebar").attr("ia_id", page_data.id);
                    }
                } else if (selected > 1) {
                   var actions_data = {};
                   actions_data.permissions = dev_p.data.permissions;
                   actions_data.selected = selected;
                   actions_data.beta = 1;
                   actions_data.got_prs = 0;
                   var same_type = true;
                   var temp_type = '';

                   $(".dev_pipeline-column__list .selected").each(function(idx) {
                       var meta_id = $(this).attr("id").replace("pipeline-list__", "");
                       var milestone = $(this).parents(".dev_pipeline-column").attr("id").replace("pipeline-", "");
                       var page_data = getPageData(meta_id, milestone);
                        
                       // If at least one of the selected IAs isn't on beta we show the "install on beta" button
                       if ((page_data.beta_install && (!page_data.beta_install.match(/^success/))) || (!page_data.beta_install)) {
                           actions_data.beta = 0;
                       }

                       if (page_data.pr && page_data.pr.issue_id) {
                           actions_data.got_prs = 1;
                       }

                       if ((page_data.repo !== temp_type) && (temp_type !== '')) {
                           same_type = false;
                       } else if (temp_type === '') {
                           temp_type = page_data.repo;
                       }
                   });

                   if (!same_type) {
                       actions_data.got_prs = 0;
                   }

                   var actions_sidebar = Handlebars.templates.dev_pipeline_actions(actions_data);
                   $("#actions_sidebar").html(actions_sidebar).removeClass("hide");
                }
            }

            function getPageData(meta_id, milestone) {
                console.log(meta_id);
                console.log(milestone);
                for (var idx = 0; idx < dev_p.data.dev_milestones[milestone].length; idx++) {
                    var temp_ia = dev_p.data.dev_milestones[milestone][idx];

                    if (temp_ia.id === meta_id) {
                        return temp_ia;
                    }
                }
            }
            
            function elapsed_time(date) {
                date = moment.utc(date.replace("/T.*Z/", " "), "YYYY-MM-DD");
                return parseInt(moment().diff(date, "days", true));
            }

            // Sort each milestone array by priority
            function sort_pipeline() {
                $.each(dev_p.data.dev_milestones, function (key, val) {
                    $.each(dev_p.data.dev_milestones[key], function (temp_ia) {
                        var priority_val = 0;
                        var priority_msg = '';

                        var ia = dev_p.data.dev_milestones[key][temp_ia];

                        if (dev_p.by_priority) {
                            // Priority is higher when:
                            // - last activity (especially comment) is by a contributor (non-admin)
                            // - last activity happened long ago (the older the activity, the higher the priority)
                            if (ia.pr && ia.pr.issue_id) {
                                if (ia.last_comment) {
                                    priority_val += ia.last_comment.admin? -20 : 20;
                                    var idle_comment = elapsed_time(ia.last_comment.date);
                                    if (ia.last_comment.admin) {
                                        priority_val -= 20;
                                        priority_val += idle_comment;
                                        priority_msg += "- 20 (last comment by admin) \n+ elapsed time since last comment \n";
                                    } else {
                                        priority_val += 20;
                                        priority_val += (2 * idle_comment);
                                        priority_msg += "+ 20 (last comment by contributor) \n+ twice the elapsed time since last comment \n";
                                    }
                                } if (ia.last_commit) {
                                    var idle_commit = elapsed_time(ia.last_commit.date);
                                    if (ia.last_comment &&  moment.utc(ia.last_comment.date).isBefore(ia.last_commit.date)) {
                                        priority_val += (1.5 * idle_commit);
                                        priority_msg += "+ 1.5 times the elapsed time since last commit (made after last comment) \n";
                                    } else if ((!ia.last_comment) && (!ia.last_commit.admin)) {
                                        priority_val += (2 * idle_commit);
                                        priority_msg += "+ twice the elapsed time since last commit (there are no comments in the PR) \n";
                                    }
                                }

                                // Priority drops if the PR is on hold
                                if (ia.pr && ia.pr.issue_id) {
                                    var tags = ia.pr.tags;

                                    $.each(tags, function(idx) {
                                        var tag = tags[idx];
                                        if (tag.name.toLowerCase() === "on hold") {
                                            priority_val -= 100;
                                             priority_msg += "- 100: the PR is on hold \n";
                                        } else if (tag.name.toLowerCase() === "priority: high") {
                                            priority_val += 20;
                                             priority_msg += "+ 20: the PR is high priority \n";
                                        }
                                    });
                                }

                                // Priority is higher if the user has been mentioned in the last comment
                                if (ia.at_mentions && ia.at_mentions.indexOf(dev_p.data.username) !== -1) {
                                    priority_val += 50;
                                     priority_msg += "+ 50: you have been @ mentioned in the last comment \n";
                                }

                                // Has a PR, so it still has more priority than IAs which don't have one
                                if (priority_val <= 0) {
                                    priority_val = 1;
                                    priority_msg += "final value is 1: there's a PR, so it's higher priority than IAs without a PR \n";
                                }
                            }

                            dev_p.data.dev_milestones[key][temp_ia].priority = priority_val;
                            dev_p.data.dev_milestones[key][temp_ia].priority_msg = priority_msg;
                        }
                    });
                        
                    dev_p.data.dev_milestones[key].sort(function (l, r) {
                        var a, b;
                        if (dev_p.by_priority) {
                            a = l.priority;
                            b = r.priority;
                        } else {
                            a = l.last_update? - elapsed_time(l.last_update) : -100;
                            b = r.last_update? - elapsed_time(r.last_update) : -100;
                        }

                        if (a > b) {
                            return -1;
                        } else if (b > a) {
                            return 1;
                        }
                            
                        return 0;
                    });
                });

                dev_p.data.by_priority = dev_p.by_priority;
                var iadp = Handlebars.templates.dev_pipeline(dev_p.data);
                $("#dev_pipeline").html(iadp);
                filterCounts();
                if (dev_p.data.permissions && dev_p.data.permissions.admin) {
                    $(".mentioned, .attention").addClass("dog-ear");
                }
            }

            // Add counts to filters
            function filterCounts() {
                $(".pipeline-filter").each(function(idx) {
                    var temp_filter = $(this).attr("id").replace("filter-", "");
                    var temp_count = $(".dev_pipeline-column__list li." + temp_filter).length;
                    $("#count-" + temp_filter).text(temp_count);
                });
            }

            function create_task(id) {
                var jhxqr = $.post("/ia/asana", {
                    id : id
                })
                .done(function(data) {
                    console.log("Got so far");
                    dev_p.saved = true;
                });
                    
            }

            function filter(which_filter, reset) {
                var query = dev_p.query? dev_p.query.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&") : '';
                var url = "";
                var $obj = $(".dev_pipeline-column__list li");

                $obj.hide();
                if (which_filter) {
                    url += "&filter=" + which_filter;
                    which_filter = "." + which_filter;
                } else {
                    which_filter = reset? "" : dev_p.current_filter;
                }

                dev_p.current_filter = which_filter;
                $obj = $(".dev_pipeline-column__list li" + which_filter);
                var $children = $obj.children(".item-name");

                if (query) {
                    var regex = new RegExp(query, "gi");
                    url = "&q=" + encodeURIComponent(query.replace(/\x5c/g, "")).replace(/%20/g, "+") + url;
                    
                    $children.each(function(idx) {
                        if (regex.test($(this).text())) {
                            $(this).parent().show();
                        }
                    });
                } else {
                    $obj.show();
                }

                url = url.length? "?" + url.replace("#", "").replace("&", ""): "/ia/dev/pipeline";

                // Allows changing URL without reloading, since it doesn't add the new URL to history;
                // Not supported on IE8 and IE9.
                history.pushState({}, "Index: Instant Answers", url);
                updateCount();
            }

            function updateCount() {
                var all_visible = $("#dev_pipeline .item-name:visible").length;
                var planning_visible = $("#dev_pipeline #pipeline-planning__list .item-name:visible").length;
                var development_visible =  $("#dev_pipeline #pipeline-development__list .item-name:visible").length;
                var testing_visible = $("#dev_pipeline #pipeline-testing__list .item-name:visible").length;
                var complete_visible = $("#dev_pipeline #pipeline-complete__list .item-name:visible").length;
                
                //$("#pipeline-stats h1").text(all_visible + " Instant Answers in progress");
                $("#pipeline-planning .milestone-count").text(planning_visible);
                $("#pipeline-development .milestone-count").text(development_visible);
                $("#pipeline-testing .milestone-count").text(testing_visible);
                $("#pipeline-complete .milestone-count").text(complete_visible);
            }

            function save_multiple(ias, field, value) {
                var jqxhr = $.post("/ia/save_multiple", {
                    field : field,
                    value : value,
                    ias : ias
                })
                .done(function(data) {
                    dev_p.saved = true;
                });
            }
        }
    };
})(DDH);
 
