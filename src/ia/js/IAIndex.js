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
            console.log("IAIndex init()");
            var ind = this;
            var url = "/ia/json";
            var $list_item;
            var $clear_filters;
            var $right_pane_div;
            var right_pane_top;
            var right_pane_top_start;
            var $right_pane;
            var window_top;
            var $dropdown_header;
            var $input_query;
            var query = "";
            
            $(".breadcrumb-nav").remove();

            $.getJSON(url, function(x) { 
                $("#ia_index_header h2").text(x.length + " Instant Answers");
                ind.ia_list = x;
                ind.sort('name');
                $list_item = $("#ia-list .ia-item");
                $clear_filters = $("#clear_filters");
                $right_pane = $("#filters");
                $right_pane_div = $("#filter_template");
                right_pane_top = $right_pane_div.offset().top;
                right_pane_top_start = right_pane_top;
                $dropdown_header = $right_pane.children(".dropdown").children(".dropdown_header");
                $input_query = $('#filters input[name="query"]');

                ind.filter($list_item, query);
            });

            $(document).click(function(evt) {
                if (!$(evt.target).closest(".dropdown").length) {
                    $right_pane.children(".dropdown").children("ul").addClass("hide");
                }
            });

            $("body").on("click keypress", "#search-ias, #filters .one-field input.text", function(evt) {
                if (((evt.type === "keypress" && evt.which === 13) && $(this).hasClass("text"))
                    || (evt.type === "click" && $(this).attr("id") === "search-ias")) {
                    var temp_query = $input_query.val().trim();
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

            $(window).scroll(function(evt) {
                var window_top = $(window).scrollTop();

                if (right_pane_top < window_top) {
                    if (!$right_pane_div.hasClass("is-fixed")) {
                        $right_pane_div.addClass("is-fixed");
                    }
               } else {
                    if ($right_pane_div.hasClass("is-fixed")) {
                        $right_pane_div.removeClass("is-fixed");
                    }
                }
            });

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
                    $(this).children("span").text(text.replace(/\([0-9]+\)/g, "").trim());
                });

                $(".is-selected").removeClass("is-selected");
                $("#ia_dev_milestone-all").addClass("is-selected");
                $("#ia_repo-all").parent().addClass("is-selected");
                $("#ia_topic-all, #ia_template-all").attr("selected", true);

                $(".button-group-vertical").find(".ia-repo").removeClass("fill");
                ind.filter($list_item);
            });

            $("body").on("click change", ".button-group .button, .button-group-vertical .row, #filter_topic, #filter_template, .topic", function(evt) {
                var id = $(this).attr("id");
                if (((id === "filter_topic" || id === "filter_template") && evt.type === "change")
                    || ((id !== "filter_topic" && id !== "filter_template") && evt.type === "click")) { 

                    console.log(this);

                    if (!$(this).hasClass("disabled")) { 
                        if($(this).hasClass("row")) {
                            $(this).parent().find(".ia-repo").removeClass("fill");
                            $(this).find(".ia-repo").addClass("fill");
                        }

                        if (!$(this).hasClass("is-selected") && evt.type !== "change") {
                            var $parent = $(this).parent();

                            $parent.find(".is-selected").removeClass("is-selected");
                            $(this).addClass("is-selected");
                        }

                        if ($clear_filters.hasClass("hide")) {
                            $clear_filters.removeClass("hide");
                        }

                        ind.selected_filter.dev_milestone = "." + $("#filter_dev_milestone .is-selected").attr("id");
                        ind.selected_filter.repo = "." + $("#filter_repo .is-selected a").attr("id");

                        if($(this).hasClass("topic")) {
                            ind.selected_filter.topic = "." + $(this).data("topic");
                        } else {                        
                            ind.selected_filter.topic = "." + $("#filter_topic option:selected").attr("id");
                        }

                        if ($parent.parent().hasClass("dropdown")) {
                            $parent.parent().children(".dropdown_header").children("span").text($(this).text().trim());
                            $parent.parent().children("ul").addClass("hide");
                        }

                        ind.selected_filter.template = "." + $("#filter_template option:selected").attr("id");

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
                        }

                        query = $input_query.val().trim();

                        ind.filter($list_item, query);
                    }
            }
            });
        },

        filter: function($obj, query) {
            var repo = this.selected_filter.repo;
            var dev_milestone = this.selected_filter.dev_milestone;
            var topic = this.selected_filter.topic;
            var template = this.selected_filter.template;

            var regex;

            if (query) {
                query = query.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&");
                regex = new RegExp(query, "gi");
            }

            if (!query && !repo.length && !topic.length && !dev_milestone.length && !template.length) {
                $obj.show();
            } else {
                $obj.hide();
                 
                var $children = $obj.children(dev_milestone + repo + topic + template);
               
                var temp_name;
                var temp_desc;
                if (regex) {
                    $children.each(function(idx) {
                        temp_name = $(this).find(".ia-item--header").text().trim();
                        temp_desc = $(this).find(".ia-item--details--bottom").text().trim();

                        if (regex.test(temp_name) || regex.test(temp_desc)) {
                            $(this).parent().show();
                        }
                    });
                } else {
                    $children.parent().show();
                }
            }
 
            this.count($obj, $("#filter_repo ul li a"), regex, dev_milestone + topic + template);
            this.count($obj, $("#filter_topic ul li a"), regex, dev_milestone + repo + template);
            this.count($obj, $("#filter_template ul li a"), regex, dev_milestone + repo + topic);
        },

        count: function($list, $obj, regex, classes) {
            var temp_text;
            var id;
            
            $obj.each(function(idx) {
                temp_text = $(this).text().replace(/\([0-9]+\)/g, "").trim();
                id = "." + $(this).attr("id");
                
                if (id === ".ia_repo-all" || id === ".ia_topic-all" || id === ".ia_template-all" || id === ".ia_dev_milestone-all") {
                    id = "";
                }
                
                var $children = $list.children(classes + id);  
                if (regex) {
                    var temp_name;
                    var temp_desc;
                    var children_count = 0;

                    $children.each(function(idx) {
                        temp_name = $(this).find(".ia-item--header").text().trim();
                        temp_desc = $(this).find(".ia-item--details--bottom").text().trim();

                        if (regex.test(temp_name) || regex.test(temp_desc)) {
                            children_count++;
                        }
                    });

                    temp_text += " (" + children_count + ")";
                } else {
                    temp_text += " (" + $children.length + ")";
                }
                    
                $(this).text(temp_text);
            });
        },

        sort: function(what) {
            console.log("sorting %s by %s", this.sort_asc ? "ascending" : "descending", what);

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
            $("#sort_name").on('click',   DDH.IAIndex.prototype.sort.bind(this, 'name'));
            $("#sort_descr").on('click',  DDH.IAIndex.prototype.sort.bind(this, 'description'));
            $("#sort_status").on('click', DDH.IAIndex.prototype.sort.bind(this, 'dev_milestone'));
            $("#sort_repo").on('click',   DDH.IAIndex.prototype.sort.bind(this, 'repo'));
        }

    };

})(DDH);
