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

        query: '',

        data: {},

        init: function() {
	    $('#wrapper').css('min-width', '1200px');

            // console.log("IADevPipeline init()");
            var dev_p = this;
            var url = window.location.pathname.replace(/\/$/, '') + "/json";
            var username = $(".user-name").text();

            $.getJSON(url, function(data) { 
                // console.log(window.location.pathname);
                // Check user permissions and add to the data
                if ($("#create-new-ia").length) {
                    data.permissions = {};
                    data.permissions.admin = 1;
                }

                // Get username for the at mentions filter
                var username = $.trim($(".header-account-info .user-name").text());
                data.username = username;

                dev_p.data = data;
                
                var stats = Handlebars.templates.dev_pipeline_stats(data.dev_milestones);
                //var iadp = Handlebars.templates.dev_pipeline(data);
                sort_priority();

                $("#pipeline-stats").html(stats);
                //$("#dev_pipeline").html(iadp);

                if ($.trim($("#select-action option:selected").text()) === "type") {
                    $("#select-milestone").addClass("hide");
                    $("#select-type").removeClass("hide");
                }

                // 100% width
                $(".site-main > .content-wrap").first().removeClass("content-wrap").addClass("wrap-pipeline");
		        $(".breadcrumb-nav").remove();

                filterCounts();
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

            $("body").on("click", "#pipeline_toggle-dev", function(evt) {
                dev_p.query = "";

                $(".search-thing").val("");
                $(".active-filter").removeClass("active-filter");
                filter('', true);
            });

             $("body").on("click", "#create-new-ia", function(evt) {
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
                    dev_p.query = $(this).val();
                    $("#pipeline-clear-filters").removeClass("hide");
                    filter();
                }
            });

            $("body").on("click", "#beta_install", function(evt) {
                var prs = [];
                $(".dev_pipeline-column__list .selected").each(function(idx) {
                    var temp_pr = $.trim($(this).find(".item-activity a").attr("href"));
                    var temp_pr_id = temp_pr.replace(/.*\//, "");
                    var temp_repo = temp_pr.replace(/^.*\/duckduckgo\//, "").replace(/\/[a-zA-Z0-9]*\/[a-zA-Z0-9]*\/?/, "");

                    if (temp_pr_id && temp_repo) {
                        var temp_hash = 
                            {
                                "action" : "duckco",
                                "number" : temp_pr_id,
                                "repo" : temp_repo
                            };

                        prs.push(temp_hash);
                    }
                });

                if (prs.length) {
                    send_to_beta(JSON.stringify(prs));
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

            $("body").on("keypress change", ".edit-sidebar", function(evt) {
                if ((evt.type === "keypress" && evt.which === 13) || (evt.type === "change" && $(this).children("select").length)) {
                   var field = $(this).attr("id").replace("edit-sidebar-", "");
                   var value = (evt.type === "change")? $.trim($(this).find("option:selected").text()) : $.trim($(this).val());
                   var id = $("#page_sidebar").attr("ia_id");

                   autocommit(field, value, id);
                }
            });

            $("body").on("click", "#sidebar-close, .deselect-all", function(evt) {
                var $selected = $(".dev_pipeline-column__list .selected");
                $selected.removeClass("selected");

                // remove sidebar
                appendSidebar(0);
                
                if (dev_p.saved) {
                    var jqxhr = $.getJSON(url, function (data) {
                        dev_p.saved = false;
                        dev_p.data.dev_milestones = data.dev_milestones;

                        //var iadp = Handlebars.templates.dev_pipeline(data);
                        //$("#dev_pipeline").html(iadp);
                        sort_priority();
                        filterCounts();
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

            function send_to_beta(prs) {
                var jqxhr = $.post("/ia/send_to_beta", {
                    data : prs
                })
                .done(function(data) {
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
                } else if (multi && selected > 1) {
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
                       if (page_data.test_machine !== "beta") {
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
            function sort_priority() {
                $.each(dev_p.data.dev_milestones, function (key, val) {
                    $.each(dev_p.data.dev_milestones[key], function (temp_ia) {
                        var priority_val = 0;

                        var ia = dev_p.data.dev_milestones[key][temp_ia];

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
                                } else {
                                    priority_val += 20;
                                    priority_val += (2 * idle_comment);
                                }
                            } if (ia.last_commit) {
                                var idle_commit = elapsed_time(ia.last_commit.date);
                                if (ia.last_comment &&  moment.utc(ia.last_comment.date).isBefore(ia.last_commit.date)) {
                                    priority_val += idle_commit;
                                } else if ((!ia.last_comment) && (!ia.last_commit.admin)) {
                                    priority_val += (2 * idle_commit);
                                }
                            }

                            // Priority drops if the PR is on hold
                            if (ia.pr && ia.pr.issue_id) {
                                var tags = ia.pr.tags;

                                $.each(tags, function(idx) {
                                    var tag = tags[idx];
                                    if (tag.name.toLowerCase() === "on hold") {
                                        priority_val -= 100;
                                    } else if (tag.name.toLowerCase() === "priority: high") {
                                        priority_val += 20;
                                    }
                                });
                            }

                            // Priority is higher if the user has been mentioned in the last comment
                            if (ia.at_mentions && ia.at_mentions.indexOf(dev_p.data.username) !== -1) {
                                priority_val += 50;
                            }

                            // Has a PR, so it still has more priority than IAs which don't have one
                            if (priority_val <= 0) {
                                priority_val = 1;
                            }
                        }

                        dev_p.data.dev_milestones[key][temp_ia].priority = priority_val;
                        console.log(ia.name + ": " + dev_p.data.dev_milestones[key][temp_ia].priority);
                    });
                    
                    dev_p.data.dev_milestones[key].sort(function (l, r) {
                        var a = l;
                        var b = r;
                        console.log(a.priority + ", " + b.priority);

                        if (a.priority > b.priority) {
                            return -1;
                        } else if (b.priority > a.priority) {
                            return 1;
                        }
                            
                        return 0;
                    });
                });
            
                var iadp = Handlebars.templates.dev_pipeline(dev_p.data);
                $("#dev_pipeline").html(iadp);
            }

            // Add counts to filters
            function filterCounts() {
                $(".pipeline-filter").each(function(idx) {
                    var temp_filter = $(this).attr("id").replace("filter-", "");
                    var temp_count = $(".dev_pipeline-column__list li." + temp_filter).length;
                    $("#count-" + temp_filter).text(temp_count);
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
 
