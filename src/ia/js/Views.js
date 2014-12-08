(function(env) {
    // This object implements the `view` and `data` methods of each view.
    // - `data` is responsible for manipulating the data (filtering, mapping, etc.)
    // - `view` is responsible for displaying the data on the page and adding DOM manip.
    env.Views = {
        // Index View: This is the default view. It lists all the IAs in a table.
        index: {
            view: function() {
                append_html("index_view", this.result);
                var that = this;
                $("#sort_name").click(function() {
                    that.sort_asc.name = !that.sort_asc.name;
                    sort('name', that.result, that.sort_asc.name);
                    that.view();
                });
                return this;
            },
            data: function(result) {
                this.result = sort("name", result, true);
                return this;
            },
            sort_asc: {
                name: true
            }
        },
        
        // Template View: Used to show the screenshots of the IAs on the page.
        template: {
            view: function() {
                append_html("template_view", this.result);
                return this;
            },
            data: function(result) {
                this.result = sort("name", result, true);
                return this;
            }
        }
    }

    function sort(what, result, asc) {
        return result.sort(function(m, n) {
            if(asc) {
                var a = m;
                var b = n;
            } else {
                var a = n;
                var b = m;
            }

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
}(this));
