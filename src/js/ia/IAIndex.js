(function(env) {

    DDH.IAIndex = function() {
        this.init();
    };

    DDH.IAIndex.prototype = {

        sort_field: '',
        sort_asc: 1,    // sort ascending
        selected_filter: {
            dev_milestone: '',
            repo: '',
            topic: '',
            template: ''
        },

        init: function() {
            //console.log("IAIndex init()");
            var ind = this;
            var url = "/ia/json";
            var $list_item;
            var $clear_filters;
            //var right_pane_top;
            //var right_pane_left;
            var $right_pane;
            var window_top;
            var $dropdown_header;
            var $input_query;
            var query = ""; 

            $.getJSON(url, function(x) { 
                ind.ia_list = x;
                ind.sort('name');
                $list_item = $("#ia-list .ia-item");
                $clear_filters = $("#clear_filters");
                $right_pane = $("#filters");
                //right_pane_top = $right_pane.offset().top;
                //right_pane_left = $right_pane.offset().left;
                $dropdown_header = $right_pane.children(".dropdown").children(".dropdown_header");
                $input_query = $('#filters input[name="query"]');
                
                var parameters = window.location.search.replace("?", "");
                parameters = $.trim(parameters.replace(/\/$/, ''));
                if (parameters) {
                    parameters = parameters.split("&");

                    var param_count = 0;

                    $.each(parameters, function(idx) {
                        var temp = parameters[idx].split("=");
                        var field = temp[0];
                        var value = temp[1];
                        if (field && value && (ind.selected_filter.hasOwnProperty(field) || field === "q")) {
                            if (ind.selected_filter.hasOwnProperty(field)) {
                                var selector = "ia_" + field + "-" + value;
                                selector = (field === 'topic')? "." + selector : "#" + selector;
                                console.log(selector);
                                $(selector).parent().trigger("click");
                                param_count++;
                            } else if ((field === "q") && value) {
                                query = value;
                                ind.filter($list_item, query);
                                param_count++;
                            }
                        }
                    });

                    if (param_count === 0) {
                        ind.filter($list_item, query);
                    }
                } else {
                    ind.filter($list_item, query);
                }
           });

            $(document).click(function(evt) {
                if (!$(evt.target).closest(".dropdown").length) {
                    $right_pane.children(".dropdown").children("ul").addClass("hide");
                }
            });

            /*$(window).resize(function(evt) {
                if ($right_pane.hasClass("is-fixed")) {
                    $right_pane.removeClass("is-fixed");
                    right_pane_left = $right_pane.offset().left;
                    $right_pane.addClass("is-fixed");
                    $right_pane.css('left', right_pane_left + "px");
                } else {
                    right_pane_left = $right_pane.offset().left;
                    right_pane_top = $right_pane.offset().top;
                }
            });*/

            $(".filters--search-button").hover(function() {
                $(this).addClass("search-button--hover");
            }, function() {
                $(this).removeClass("search-button--hover");
            });
            
            $("body").on("click keypress", "#search-ias, #filters .one-field input.text, .filters--search-button", function(evt) {
                
                //console.log(evt.type, this);

                if (((evt.type === "keypress" && evt.which === 13) && $(this).hasClass("text"))
                    || (evt.type === "click" && $(this).hasClass("filters--search-button"))) {
                    var temp_query = $.trim($input_query.val());
                    if (temp_query !== query) {
                        query = temp_query;
                        ind.filter($list_item, query);
                        if ($clear_filters.hasClass("hide")) {
                            $clear_filters.removeClass("hide");
                        }
                    }
                }
            });

            $("body").on("click", "#ia-list .ia-item", function(evt) {
                if (!$(evt.target).closest(".ia-item--header").length
                    && !$(evt.target).closest(".topic").length) {
                    var $img = $(this).find(".ia-item--details--img");
                    if ($img.hasClass("hide")) {
                        $img.removeClass("hide");
                        var data_img = $img.children(".ia-item--img").attr("data-img");
                        $img.children(".ia-item--img").attr("src", data_img);
                    } else {
                        $img.addClass("hide");
                    }
                } 
            });

            $("body").on("click", "#filters .dropdown .dropdown_header", function(evt) {
                var $list = $(this).parent().children("ul");
                if ($list.hasClass("hide") && !$(this).parent().hasClass("disabled")) {
                    $right_pane.children(".dropdown").children("ul").addClass("hide");
                    $list.removeClass("hide");
                } else {
                    $list.addClass("hide");
                }
            });

            /*$(window).scroll(function(evt) {
                var window_top = $(window).scrollTop();

                if (right_pane_top < window_top) {
                    if (!$right_pane.hasClass("is-fixed")) {
                        $right_pane.addClass("is-fixed");
                        $right_pane.css('left', right_pane_left + "px");
                    }
               } else {
                    if ($right_pane.hasClass("is-fixed")) {
                        $right_pane.removeClass("is-fixed");
                    }
                }
            });*/

            $("#filters .ddgsi-close-grid").click(function() {
                $("#filters").addClass("hide-small");
            });

            $("#ia_index_header .ddgsi-menu").click(function() {
                $("#filters").removeClass("hide-small");
            });

            $(".breadcrumb-nav").hide();

            $("body").on("click", "#clear_filters", function(evt) {
                $(this).addClass("hide");
                query = "";
                ind.selected_filter.dev_milestone = "";
                ind.selected_filter.repo = "";
                ind.selected_filter.topic = "";
                ind.selected_filter.template = "";

                $input_query.val("");

                $dropdown_header.each(function(idx) {
                    var text = $(this).parent().children("ul").children("li:first-child").text();
                    $(this).children("span").text($.trim(text.replace(/\([0-9]+\)/g, "")));
                });

                $(".is-selected").removeClass("is-selected");
                $("#ia_dev_milestone-all").addClass("is-selected");
                $("#ia_repo-all, #ia_topic-all, #ia_template-all").parent().addClass("is-selected");

                $(".button-group-vertical").find(".ia-repo").removeClass("fill");
                ind.filter($list_item);
            });

            $("body").on("click", ".button-group .button, .button-group-vertical .row, .topic", function(evt) {

                //console.log(this);

                if (!$(this).hasClass("disabled") && !$(this).parent().parent().parent().hasClass("disabled")) { 
                    if($(this).hasClass("row")) {
                        $(this).parent().find(".ia-repo").removeClass("fill");
                        $(this).find(".ia-repo").addClass("fill");
                    }

                    if (!$(this).hasClass("is-selected")) {
                        var $parent = $(this).parent();

                        $parent.find(".is-selected").removeClass("is-selected");
                        $(this).addClass("is-selected");

                        if ($clear_filters.hasClass("hide")) {
                            $clear_filters.removeClass("hide");
                        }


                        if ($parent.parent().hasClass("dropdown")) {
                            $parent.parent().children(".dropdown_header").children("span").text($.trim($(this).text().replace(/\([0-9]+\)/g, "")));
                            $parent.parent().children("ul").addClass("hide");
                        }
                    }

                    ind.selected_filter.dev_milestone = "." + $("#filter_dev_milestone .is-selected").attr("id");
                    ind.selected_filter.repo = "." + $("#filter_repo .is-selected a").attr("id");

                    if($(this).hasClass("topic")) {
                        ind.selected_filter.topic = "." + $(this).data("topic");
                    } else {                        
                        ind.selected_filter.topic = "." + $("#filter_topic .is-selected a").attr("id");
                    }

                    ind.selected_filter.template = "." + $("#filter_template .is-selected a").attr("id");

                    if (ind.selected_filter.dev_milestone === ".ia_dev_milestone-all") {
                        ind.selected_filter.dev_milestone = "";
                    }

                    if (ind.selected_filter.repo === ".ia_repo-all") {
                        ind.selected_filter.repo = "";
                    }

                    if (ind.selected_filter.topic === ".ia_topic-all") {
                        ind.selected_filter.topic = "";
                    }

                    if (ind.selected_filter.template === ".ia_template-all") {
                        ind.selected_filter.template = "";
                    }

                    if($(this).hasClass("topic")) {
                        $("#filter_topic").find("li").removeClass("is-selected");
                        $("#" + $(this).data("topic")).parent().addClass("is-selected");
                        $("#filter_topic").find(".dropdown_header span").text($(this).text());
                    }

                    query = $.trim($input_query.val());

                    ind.filter($list_item, query);
                }
            });
        },

        filter: function($obj, query) {
            var repo = this.selected_filter.repo;
            var dev_milestone = this.selected_filter.dev_milestone;
            var topic = this.selected_filter.topic;
            var template = this.selected_filter.template;
            var regex;
            var url = "";

            if (query) {
                query = query.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
                regex = new RegExp(query, "gi");
                url += "&q=" + query;
            }

            if (!query && !repo.length && !topic.length && !dev_milestone.length && !template.length) {
                $obj.show();
            } else {
                $obj.hide();
                $.each(this.selected_filter, function(key, val) {
                    if (val) {
                        if (key === "topic") {
                            val = val.replace(".", "#");
                            val = $(val).attr("class").replace("ia_topic-", "");
                        } else {
                            val = val.replace(".ia_" + key + "-", "");
                        }
                        
                        url += "&" + key + "=" + val;
                    }
                });

                var $children = $obj.children(dev_milestone + repo + topic + template);
               
                var temp_name;
                var temp_desc;
                if (regex) {
                    $children.each(function(idx) {
                        temp_name = $.trim($(this).find(".ia-item--header").text());
                        temp_desc = $.trim($(this).find(".ia-item--details--bottom").text());

                        if (regex.test(temp_name) || regex.test(temp_desc)) {
                            $(this).parent().show();
                        }
                    });
                } else {
                    $children.parent().show();
                }
            }

            url = url.length? "?" + url.replace("#", "") : "/ia";
            
            // Allows changing URL without reloading, since it doesn't add the new URL to history;
            // Not supported on IE8 and IE9.
            history.pushState({}, "Index: Instant Answers", url);

            this.count($obj, $("#filter_repo ul li a"), regex, dev_milestone + topic + template);
            this.count($obj, $("#filter_topic ul li a"), regex, dev_milestone + repo + template);
            this.count($obj, $("#filter_template ul li a"), regex, dev_milestone + repo + topic);
        },

        count: function($list, $obj, regex, classes) {
            var temp_text;
            var id;
            var selector_all = "";
            var text_all;
            var tot_count = 0;

            $("#ia_index_header h2").text("Showing " + $(".ia-item:visible").length + " Instant Answers");
            
            $obj.each(function(idx) {
                temp_text = $.trim($(this).text().replace(/\([0-9]+\)/g, ""));
                id = "." + $(this).attr("id");
                
                // First row of each section will have the count equal to the sum of the other rows counts
                // in that section, except for topics, because an IA can have more than one topic
                if (id === ".ia_repo-all" || id === ".ia_template-all" || id === ".ia_dev_milestone-all") {
                    selector_all = id.replace(".", "#");
                    text_all = temp_text;
                    return;
                } else if (id === ".ia_topic-all") {
                    id = "";
                }
                
                var $children = $list.children(classes + id);  
                if (regex) {
                    var temp_name;
                    var temp_desc;
                    var children_count = 0;

                    $children.each(function(idx) {
                        temp_name = $.trim($(this).find(".ia-item--header").text());
                        temp_desc = $.trim($(this).find(".ia-item--details--bottom").text());

                        if (regex.test(temp_name) || regex.test(temp_desc)) {
                            children_count++;
                        }
                    });

                    temp_text += " (" + children_count + ")";
                    tot_count += children_count;
                } else {
                    temp_text += " (" + $children.length + ")";
                    tot_count += $children.length;
                }
                    
                $(this).text(temp_text);
            });
            
            if (selector_all !== "") {
                text_all += " (" + tot_count + ")";
                $(selector_all).text(text_all);

                if (selector_all !== "#ia_repo-all") {
                    if (tot_count === 0) {
                        $(selector_all).parent().parent().parent().addClass("disabled");
                    } else {
                        $(selector_all).parent().parent().parent().removeClass("disabled");
                    }
                }
            }
        },

        sort: function(what) {
            //console.log("sorting %s by %s", this.sort_asc ? "ascending" : "descending", what);

            // reverse
            if (this.sort_field == what) {
                this.sort_asc = 1 - this.sort_asc;
            }
            else {
                this.sort_asc = 1; // reset
            }

            this.sort_field = what;
            var ascending = this.sort_asc;

            this.ia_list.sort(function(l,r) {

                // sort direction
                if (ascending) {
                    var a=l, b=r;
                }
                else {
                    var a=r; b=l;
                }

                
                if (a[what] > b[what]) {
                    return 1;
                }

                if (a[what] < b[what]) {
                    return -1;
                }

                return 0;
            });
            
            this.refresh();
        },

        refresh: function() {
            var iap = Handlebars.templates.index({ia: this.ia_list});
            $("#ia_index").html(iap);
        }

    };

})(DDH);
