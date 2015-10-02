(function(env) {

    DDH.IADevPipeline = function() {
        this.init();
    };

    DDH.IADevPipeline.prototype = {
        filters: {
            producer: '',
            developer: '',
            missing: '',
        },

        query: '',

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

                var stats = Handlebars.templates.dev_pipeline_stats(data.dev_milestones);
                var iadp = Handlebars.templates.dev_pipeline(data);

                $("#pipeline-stats").html(stats);
                $("#dev_pipeline").html(iadp);

                if ($.trim($("#select-action option:selected").text()) === "type") {
                    $("#select-milestone").addClass("hide");
                    $("#select-type").removeClass("hide");
                }

                appendTeam(data.dev_milestones);

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
                            } else {
                                var $select = $("#select-" + field);
                                $select.val(value);
                                $select.trigger("change");
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

            $("body").on("click", ".dev_pipeline-column__list .icon-check, .dev_pipeline-column__list .icon-check-empty", function(evt) {
                toggleCheck($(this));

                var selected = $(".dev_pipeline-column__list .icon-check").length;
                
                if (selected) {
                    $(".pipeline-actions").removeClass("hide");
                } else {
                    $(".pipeline-actions").addClass("hide");
                }

                $(".count-txt").text(selected);
            });

            $(".deselect-all").click(function(evt) {
                $(".dev_pipeline-column__list .icon-check").removeClass("icon-check").addClass("icon-check-empty");
                $(".pipeline-actions").addClass("hide");
                $(".count-txt").text("0");
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

            $("body").on("change", "#select-producer, #select-developer", function(evt) {
                var value = $.trim($(this).find("option:selected").text().toLowerCase().replace(/[^a-z0-9]/g, ""));
                var field = $(this).attr("id").replace("select-", "");

                if (value === "all") {
                    dev_p.filters[field] = "";
                } else {
                    dev_p.filters[field] = value;
                }

                $("#pipeline-clear-filters").removeClass("hide");

                filter();
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

                $(".dev_pipeline-column__list .icon-check").each(function(idx) {
                    var temp_id = $.trim($(this).parent().attr("id").replace("pipeline-list__", ""));
                    
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

            function appendTeam(data) {
                var producers = [];
                var developers = [];
                $.each(data, function(idx, val) {
                    if (val !== "permissions") {
                        $.each(val, function(sub_id, sub_val) {
                            //var sub_val = data[idx][sub_id];
                            var temp_producer = sub_val.producer;
                            var devs = sub_val.developer;

                            if (($.inArray(temp_producer, producers) === -1) && temp_producer) {
                                producers.push(temp_producer);
                                var slug_producer = temp_producer.toLowerCase().replace(/[^a-z0-9]/g, "");

                                $("#select-producer").append('<option value="' + slug_producer + '">' + temp_producer + '</option>');
                            }

                            if (devs) {
                                $.each(devs, function(dev_id, temp_dev) {
                                    if (temp_dev && temp_dev.name && ($.inArray(temp_dev.name, developers)  === -1)) {
                                        developers.push(temp_dev.name);
                                        var slug_dev = temp_dev.name.toLowerCase().replace(/[^a-z0-9]/g, "");

                                        $("#select-developer").append('<option value="' + slug_dev + '">' + temp_dev.name + '</option>');
                                    }
                                });
                            }
                        });
                    }
                });

                var team = {producers : producers, developers : developers};
                return team;
            }

            function toggleCheck($obj) {
                $obj.toggleClass("icon-check");
                $obj.toggleClass("icon-check-empty");
                $obj.parent().toggleClass("selected");
            }
        }
    };
})(DDH);
 
