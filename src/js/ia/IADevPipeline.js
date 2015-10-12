(function(env) {

    DDH.IADevPipeline = function() {
        this.init();
    };

    DDH.IADevPipeline.prototype = {
        filters: {
            missing: '',
        },

        query: '',

        data: {},

        init: function() {
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

                dev_p.data = data;
                
                var stats = Handlebars.templates.dev_pipeline_stats(data.dev_milestones);
                var iadp = Handlebars.templates.dev_pipeline(data);

                $("#pipeline-stats").html(stats);
                $("#dev_pipeline").html(iadp);

                if ($.trim($("#select-action option:selected").text()) === "type") {
                    $("#select-milestone").addClass("hide");
                    $("#select-type").removeClass("hide");
                }

                // 100% width
                $(".site-main > .content-wrap").first().removeClass("content-wrap").addClass("wrap-pipeline");

                var parameters = window.location.search.replace("?", "");
                parameters = $.trim(parameters.replace(/\/$/, ''));
                if (parameters) {
                    parameters = parameters.split("&");

                    var param_count = 0;

                    $.each(parameters, function(idx) {
                        var temp = parameters[idx].split("=");
                        var field = temp[0];
                        var value = temp[1];

                        if (field && value && (dev_p.filters.hasOwnProperty(field) || field === "q")) {
                            if ((field === "q") && value) {
                                $(".search-thing").val(decodeURIComponent(value.replace(/\+/g, " ")));

                                //create return keypress event
                                var evt = $.Event("keypress");
                                evt.which = 13;
                                $(".search-thing").trigger(evt);
                                param_count++;
                            } else if (field === "missing") {
                                $("#select-info").val(value);
                                $("#filter-info i").trigger("click");
                            }
                        }
                    });

                    if (param_count === 0) {
                        filter();
                    }
                } else {
                    filter();
                }
            });

            $("#pipeline-clear-filters").click(function(evt) {
                $(this).addClass("hide");

                dev_p.query = "";
                $.each(dev_p.filters, function(key, val) {
                    dev_p.filters[key] = "";
                });

                $(".filter-team select").val("all");
                $(".search-thing").val("");

                $("#filter-info i").removeClass("icon-check").addClass("icon-check-empty");

                filter();
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
                    dev_p.query = $(this).val();
                    $("#pipeline-clear-filters").removeClass("hide");
                    filter();
                }
            });

            $("body").on("click", ".dev_pipeline-column__list li", function(evt) {
                var $items = $(".dev_pipeline-column__list .selected");
                var was_selected = $(this).hasClass("selected");
                
                if (evt.shiftKey || was_selected || (!dev_p.data.hasOwnProperty("permissions"))) {
                    if ((!dev_p.data.hasOwnProperty("permissions"))) {
                        $(".selected").removeClass("selected");
                    }
                    
                    $(this).toggleClass("selected");
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

                appendSidebar(selected);
                $(".count-txt").text(selected);
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
                $(".pipeline-actions").addClass("hide");
                $(".count-txt").text("0");

                // remove sidebar
                appendSidebar(0);
                
                if (dev_p.saved) {
                    var jqxhr = $.getJSON(url, function (data) {
                        dev_p.saved = false;
                        dev_p.data.dev_milestones = data.dev_milestones;
                    
                        $(".pipeline-actions").addClass("hide");
                        $(".count-txt").text("0");

                        var iadp = Handlebars.templates.dev_pipeline(data);
                        $("#dev_pipeline").html(iadp);
                    });
                }
            });

            $("body").on("change", "#select-action", function(evt) {
                if ($.trim($(this).find("option:selected").text()) === "type") {
                    $("#select-type").removeClass("hide");
                    $("#select-milestone").addClass("hide");
                } else {
                    $("#select-milestone").removeClass("hide");
                    $("#select-type").addClass("hide");
                }
            });

            $("body").on("click change", "#filter-info i, #select-info", function(evt) {
                if (evt.type === "click" && $(this).is("#filter-info i")) {
                    toggleCheck($(this));
                }

                if ($("#filter-info i").hasClass("icon-check")) {
                    var value = $.trim($("#select-info option:selected").text().toLowerCase().replace(/\s/g, "_"));
                    dev_p.filters.missing = value;
                    $("#pipeline-clear-filters").removeClass("hide");
                } else {
                    dev_p.filters.missing = "";
                }

                filter();
            });

            $("body").on("click", "#pipeline-action-submit", function(evt)  {
                var ias = [];
                var field = $.trim($("#select-action").find("option:selected").text().replace(/\s/g, "_"));
                var $select_value;
                
                if (field === "type") {
                    field = "repo";
                    $select_value = $("#select-type");
                } else {
                    $select_value = $("#select-milestone");
                }
                
                var value = $.trim($select_value.find("option:selected").text());

                $(".dev_pipeline-column__list .selected").each(function(idx) {
                    var temp_id = $.trim($(this).attr("id").replace("pipeline-list__", ""));
                    
                    ias.push(temp_id);
                });

                ias = JSON.stringify(ias);
                save_multiple(ias, field, value);
            });

            $(".toggle-details i").click(function(evt) {
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

            function appendSidebar(selected) {
                $("#page_sidebar, #actions_sidebar").addClass("hide").empty();
                $("#page_sidebar").attr("ia_id", "");
                
                if (selected === 1) {
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

            function filter() {
                var query = dev_p.query? dev_p.query.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&") : '';
                var url = "";
                var $obj = $(".dev_pipeline-column__list li");
                var class_sel = "";

                $obj.hide();
                $.each(dev_p.filters, function(key, val) {
                    if (val) {
                        class_sel += "." + key + "-";
                        class_sel += (val === "none")? "" : val;
                        url += "&" + key + "=" + val;
                    }
                });

                $obj = $(".dev_pipeline-column__list li" + class_sel);
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
                
                $("#pipeline-stats h1").text(all_visible + " Instant Answers in progress");
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
                    if (data.result) {
                        location.reload();
                    }
                });
            }
        }
    };
})(DDH);
 
