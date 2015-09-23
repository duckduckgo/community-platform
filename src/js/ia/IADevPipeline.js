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

                // Check user permissions and add to the data
                if ($("#create-new-ia").length) {
                    data.permissions = {};
                    data.permissions.admin = 1;
                }

                var iadp;
                iadp = Handlebars.templates.dev_pipeline(data);

                $("#dev_pipeline").html(iadp);

                appendTeam(data.dev_milestones);

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
                 toggleCheck($(this));

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

            $("body").on("click", ".dev_pipeline-column__list .icon-check, .dev_pipeline-column__list .icon-check-empty", function(evt) {
                toggleCheck($(this));

                if ($(".dev_pipeline-column__list .icon-check").length) {
                    $(".pipeline-actions").removeClass("hide");
                } else {
                    $(".pipeline-actions").addClass("hide");
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
                if (evt.type === "click" && $(evt.target).is("#filter-info i")) {
                    toggleCheck($(this));
                }

                if ($("#filter-info i").hasClass("icon-check")) {
                    $(".dev_pipeline-column__list li").hide();

                    var info = $.trim($("#select-info option:selected").text().toLowerCase().replace(/\s/g, "_"));
                    var selector_prefix = ".dev_pipeline-column__list li.missing-";
                    if (info === "all") {
                        $(selector_prefix + "perl_module").show();
                        $(selector_prefix + "type").show();
                        $(selector_prefix + "name").show();
                        $(selector_prefix + "example_query").show();
                    } else if (info === "none") {
                        $(".dev_pipeline-column__list li").show();

                        $(selector_prefix + "perl_module").hide();
                        $(selector_prefix + "type").hide();
                        $(selector_prefix + "name").hide();
                        $(selector_prefix + "example_query").hide();
                    } else {
                        $(selector_prefix + info).show();
                    }
                } else {
                    $(".dev_pipeline-column__list li").show();
                }
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

                                $("#select-producer").append("<option>" + temp_producer + "</option>");
                            }

                            if (devs) {
                                $.each(devs, function(dev_id, temp_dev) {
                                    if (temp_dev && temp_dev.name && ($.inArray(temp_dev.name, developers)  === -1)) {
                                        developers.push(temp_dev.name);

                                        $("#select-developer").append("<option>" + temp_dev.name + "</option>");
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
            }
        }
    };
})(DDH);
 
