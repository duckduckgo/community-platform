// This hash lists implements the `view` and `data` methods of each template.
// - `data` is responsible for manipulating the data (filtering, mapping, etc.)
// - `view` is responsible for displaying the data on the page.
(function(env) {
    function sort(what, list) {
        return list.sort(function(a, b) {
            if(a[what] > b[what]) {
                return 1;
            } else if(a[what] < b[what]) {
                return -1;
            } else {
                return 0;
            }
        });
    }

    env.Views = {
        // Index View: This is the default view. It lists all the IAs in a table.
        index: {
            view: function() {
                var html = Handlebars.templates.index_view({ia: this.result});                
                $("#ia_index").html(html);
            },
            data: function(result) {
                this.result = sort('name', result);
                return this;
            }
        },
        
        // Template View: Used to show the screenshots of the IAs on the page.
        template: {
            view: function() {
                var html = Handlebars.templates.template_view({ia: this.result});
                $("#ia_index").html(html);
            },
            data: function(result) {
                this.result = result;
                return this;
            }
        }
    }
}(this));
