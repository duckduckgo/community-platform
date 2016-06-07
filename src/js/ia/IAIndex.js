(function(env) {

    DDH.IAIndex = function() {
	$(".site-main > .content-wrap").first().removeClass("content-wrap").addClass("index-wrap");
	$(".site-main").addClass("index-main");
	
	$('#wrapper').css('min-width', '1200px');

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

        query: '',

        $list_item: '',

        init: function() {
            //console.log("IAIndex init()");
            var ind = this;
            var url = "/ia/json";
            var $clear_filters;
            //var right_pane_top;
            //var right_pane_left;
            var $right_pane;
            var window_top;
            var $dropdown_header;
            var $input_query;
            ind.ia_list = ia_init();

            ind.refresh();
            this.$list_item = $("#ia-list .ia-item");
            $clear_filters = $("#clear_filters");
            $right_pane = $("#filters");
            //right_pane_top = $right_pane.offset().top;
            //right_pane_left = $right_pane.offset().left;
            $dropdown_header = $right_pane.children(".dropdown").children(".dropdown_header");
            $input_query = $('#filters input[name="query"]');

            $(document).ready(function() {
                var parameters = window.location.search.replace("?", "");
                parameters = $.trim(parameters.replace(/\/$/, ''));
                if (parameters) {
                    parameters = parameters.split("&");

                    var param_count = 0;

                    $.each(parameters, function(idx) {
                        var temp = parameters[idx].split("=");
                        var field = temp[0];
                        var value = temp[1];
                        if (field && value && (ind.selected_filter.hasOwnProperty(field)) || field === "q" || field === "sort_asc" || field === "sort_desc") {
                            if (ind.selected_filter.hasOwnProperty(field)) {
                                var selector = "ia_" + field + "-" + value;
                                selector = (field === 'topic')? "." + selector : "#" + selector;
                                var $filter = $($(selector).parent().get(0));
                                $(selector).parent().trigger("click");
                                param_count++;
                            } else if ((field === "q") && value) {
                                $input_query.val(decodeURIComponent(value.replace(/\+/g, " ")));
                                $(".filters--search-button").trigger("click");
                                param_count++;
                            } else if ((field === "sort_asc" || field === "sort_desc") && value) {
                                ind.sort_asc = (field.replace("sort_", "") === "asc")? 1 : 0;
                                ind.sort(value);
                            }
                        }
                    });

                    if (param_count === 0) {
                        ind.filter();
                    }
                } else {
                    ind.filter();
                }
            });

            $(document).click(function(evt) {
                evt.stopPropagation();
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
                evt.stopPropagation(); 

                if (((evt.type === "keypress" && evt.which === 13) && $(this).hasClass("text"))
                    || (evt.type === "click" && $(this).hasClass("filters--search-button"))) {
                    var temp_query = $.trim($input_query.val());
                    if (temp_query !== ind.query) {
                        ind.query = temp_query;
                        ind.filter();
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
                ind.query = "";
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
                ind.filter();
            });

            $(".button-group .button, .button-group-vertical .row, .topic").click(function(evt) {
                evt.stopPropagation();
                console.log(this);

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

                    ind.query = $.trim($input_query.val());

                    ind.filter();
                }
            });
        },

        filter_regex: function($children, regex) {
            var shown = 0;

            $children.each(function(idx) {
                temp_name = $.trim($(this).find(".ia-item--header").text());
                temp_desc = $.trim($(this).find(".ia-item--details--bottom").text());

                if (regex.test(temp_name) || regex.test(temp_desc)) {
                    $(this).parent().show();
                    shown++;
                }
            });

            return shown;
        },

        filter: function() {
            var query = this.query;
            var repo = this.selected_filter.repo;
            var dev_milestone = this.selected_filter.dev_milestone;
            var topic = this.selected_filter.topic;
            var template = this.selected_filter.template;
            var regex;
            var url = "";
            var $obj = this.$list_item;

            if (query) {
                query = query.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
                regex = new RegExp(query, "i");
                url += "&q=" + encodeURIComponent(query.replace(/\x5c/g, "")).replace(/%20/g, "+");
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
                    var shown = this.filter_regex($children, regex);
                    var ind = this;
                    if (!shown) {
                        var split_query = query.split(/\s/);
                        var reg_array = [];
                        $.each(split_query, function(idx) {
                            var temp_regex = new RegExp(split_query[idx].replace("\\", ""), "gi");
                            if (temp_regex) {
                                ind.filter_regex($children, temp_regex);
                                reg_array.push(temp_regex);
                            }
                        });
                        
                        this.count_multiple($obj, reg_array, dev_milestone, topic, template, repo, true);
                    } else {
                        this.count_multiple($obj, regex, dev_milestone, topic, template, repo, false);
                    }
                } else {
                    $children.parent().show();
                    this.count_multiple($obj, regex, dev_milestone, topic, template, repo, false);
                }
            }

            if (this.sort_field.length) {
                var direction = this.sort_asc? "sort_asc" : "sort_desc";
                url += "&" + direction + "=" + this.sort_field;
            }

            url = url.length? "?" + url.replace("#", "").replace("&", ""): "/ia";
            
            // Allows changing URL without reloading, since it doesn't add the new URL to history;
            // Not supported on IE8 and IE9.
            history.pushState({}, "Index: Instant Answers", url);

        },

        count_multiple: function($list, regex, dev_milestone, topic, template, repo, is_array) {
            var $filter_repo = $("#filter_repo ul li a");
            var $filter_topic = $("#filter_topic ul li a");
            var $filter_template = $("#filter_template ul li a");

            var ind = this;
            if (is_array) {
                $.each(regex, function(idx) {
                    var tmp_r = regex[idx];
                    
                    ind.count($list, $filter_repo, tmp_r, dev_milestone + topic + template);
                    ind.count($list, $filter_topic, tmp_r, dev_milestone + repo + template);
                    ind.count($list, $filter_template, tmp_r, dev_milestone + repo + topic);
                });
            } else {
                this.count($list, $filter_repo, regex, dev_milestone + topic + template);
                this.count($list, $filter_topic, regex, dev_milestone + repo + template);
                this.count($list, $filter_template, regex, dev_milestone + repo + topic);
            }
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

        elapsed_time: function(date) {
            date = moment.utc(date.toString().replace("/T.*Z/", " "), "YYYY-MM-DD");
            return parseInt(moment().diff(date, "days", true));
        },

        sort: function(what) {
            this.sort_field = what;
            var ascending = this.sort_asc;
            var is_date = what.match(/\_date/)? 1 : 0;
            var ind = this;
            
            this.ia_list.sort(function(l,r) {
                // sort direction
                if (ascending) {
                    var a=l, b=r;
                }
                else {
                    var a=r; b=l;
                }

                if (is_date) {
                    a[what] = a[what]? ind.elapsed_time(a[what]) : 0;
                    b[what] = b[what]? ind.elapsed_time(b[what]) : 0;
                }
                
                if (a[what] > b[what]) {
                    return 1;
                }

                if (a[what] < b[what]) {
                    return -1;
                }

                return 0;
            });
            
            this.refresh(true);
        },

        refresh: function(just_sorted) {
            just_sorted = just_sorted? true : false;
            var iap = Handlebars.templates.index({ia: this.ia_list});
            $("#ia_index").html(iap);

            if (just_sorted) {
                this.$list_item = $("#ia-list .ia-item");
                this.filter();
            }
        }

    };

})(DDH);
