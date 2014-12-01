(function(env) {

    DDH.IAIndex = function() {
        this.init();
    };

    DDH.IAIndex.prototype = {

        sort_field: '',
        sort_asc: 1,    // sort ascending

        init: function() {
            console.log("IAIndex init()");
            var ind = this;
            var field = $("#ia_index").attr("field");
            var value = $("#ia_index").attr("value");
            var url = "/ia/json";
            
            if (field && value) {
               $(".breadcrumbs").append(field + ': <span class="idx_filter">' + value + '</span>');

               if (field !== "topic") {
                  url += "/" + field + "/" + value;
               }
            }

            $("#sort_name").on('click',   DDH.IAIndex.prototype.sort.bind(this, 'name'));
            $("#sort_descr").on('click',  DDH.IAIndex.prototype.sort.bind(this, 'description'));
            $("#sort_status").on('click', DDH.IAIndex.prototype.sort.bind(this, 'dev_milestone'));
            $("#sort_repo").on('click',   DDH.IAIndex.prototype.sort.bind(this, 'repo'));

            $.getJSON(url, function(x) {
                if (field == "topic") {
                    var topics;
                    var new_x = [];
                    for (var i = 0; i < x.length; i++) {
                        topics = x[i].topic;
                        if ($.inArray(value, topics) !== -1) {
                            new_x.push(x[i]);
                        }
                    }

                    x = new_x;
                }

                ind.ia_list = x;
                ind.sort('name');
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
