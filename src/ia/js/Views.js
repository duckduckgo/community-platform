(function(env) {
    function sort(what, result) {
        return result.sort(function(a, b) {
            if(a[what] > b[what]) {
                return 1;
            } else if(a[what] < b[what]) {
                return -1;
            } else {
                return 0;
            }
        });
    }

    function append_html(template, result) {
        var html = Handlebars.templates[template]({ia: result});                
        $("#ia_index").html(html);
    }

    // This object implements the `view` and `data` methods of each view.
    // - `data` is responsible for manipulating the data (filtering, mapping, etc.)
    // - `view` is responsible for displaying the data on the page and adding DOM manip.
    env.Views = {
        // Index View: This is the default view. It lists all the IAs in a table.
        index: {
            view: function() {
                append_html("index_view", this.result);
            },
            data: function(result) {
                this.result = sort("name", result);
                return this;
            }
        },
        
        // Template View: Used to show the screenshots of the IAs on the page.
        template: {
            view: function() {
                append_html("template_view", this.result);
            },
            data: function(result) {
                this.result = sort("name", result);
                return this;
            }
        }
    }
}(this));
