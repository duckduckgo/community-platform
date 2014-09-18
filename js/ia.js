(function(env) {

    console.log("ia pages");

    env.DDH = {
        load_index: function(x) {
            DDH.ia = x;
            console.log("DDH loaded ia data");
        },

        current_sort: '',
        sort_asc: 1,

        sort_index: function(what) {
            console.log("sorting by %s, prev is %s", what, DDH.current_sort);

            // reverse
            if (DDH.current_sort == what) {
                DDH.sort_asc = 1 - DDH.sort_asc;
            }
            else {
                DDH.sort_asc = 1; // reset
            }

            DDH.ia.sort(function(l,r) {

                // sort direction
                if (DDH.sort_asc) {
                    var a=l, b=r;
                }
                else {
                    var a=r; b=l;
                }

                DDH.current_sort = what;
                
                if (a[what] > b[what]) {
                    return 1;
                }

                if (a[what] < b[what]) {
                    return -1;
                }

                return 0;
            });
            
            DDH.redraw_index();
        },

        redraw_index: function() {
            var iap = Handlebars.templates.index({ia: DDH.ia});
            $("#ia_index").html(iap);
        },


    };

    $(document).ready(function() {

        $.getJSON("/ia/json", function(x) {
            DDH.load_index(x);
            DDH.sort_index('name');

            $("#sort_name").on('click', DDH.sort_index.bind(DDH, 'name'));
            $("#sort_descr").on('click', DDH.sort_index.bind(DDH, 'description'));
            $("#sort_status").on('click', DDH.sort_index.bind(DDH, 'dev_milestone'));
            $("#sort_repo").on('click', DDH.sort_index.bind(DDH, 'repo'));
        });


    });

})(window);
