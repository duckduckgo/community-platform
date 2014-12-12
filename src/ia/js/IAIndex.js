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
            var $right_pane;
            var window_top;
            var $dropdown_header;
            
            $.getJSON(url, function(x) { 
                ind.ia_list = x;
                ind.sort('name');
                $list_item = $("#ia-list .ia-item");
                $clear_filters = $("#clear_filters");
                $right_pane = $("#filters");
                $right_pane_div = $("#filter_template");
                right_pane_top = $right_pane_div.offset().top;
                $dropdown_header = $right_pane.children(".dropdown .dropdown_header");
            });

            $("body").on("click", "#filters .dropdown .dropdown_header", function(evt) {
                var $list = $(this).parent().children("ul");
                if ($list.hasClass("hide")) {
                    $right_pane.children(".dropdown").children("ul").addClass("hide");
                    $list.removeClass("hide");
                } else {
                    $list.addClass("hide");
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
                ind.selected_filter.dev_milestone = "";
                ind.selected_filter.repo = "";
                ind.selected_filter.topic = "";
                ind.selected_filter.template = "";

                $(".is-selected").removeClass("is-selected");
                $("#ia_dev_milestone-all, #ia_repo-all, #ia_topic-all, #ia_template-all").parent().addClass("is-selected");

                $(".button-group-vertical").find(".ia-repo").removeClass("fill");
                ind.filter($list_item);
            });

            $("body").on("click", ".button-group .button, .button-group-vertical .row", function(evt) {
                if (!$(this).hasClass("disabled")) { 
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
                    }

                    ind.selected_filter.dev_milestone = "." + $("#filter_dev_milestone .is-selected").attr("id");
                    ind.selected_filter.repo = "." + $("#filter_repo .is-selected a").attr("id");
                    ind.selected_filter.topic = "." + $("#filter_topic .is-selected a").attr("id");
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

                    ind.filter($list_item);
                }
            });
        },

        filter: function($obj) {
            var repo = this.selected_filter.repo;
            var dev_milestone = this.selected_filter.dev_milestone;
            var topic = this.selected_filter.topic;
            var template = this.selected_filter.template;

            if (!repo.length && !topic.length && !dev_milestone.length && !template.length) {
                $obj.show();
            } else {
                $obj.hide();                
                $obj.children(dev_milestone + repo + topic + template).parent().show();
            }
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
