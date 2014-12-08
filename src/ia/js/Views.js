(function(env) {
    // This object implements the `view` and `data` methods of each view.
    // - `data` is responsible for manipulating the data (filtering, mapping, etc.)
    // - `view` is responsible for displaying the data on the page and adding DOM manip.
    env.Views = {
        // Index View: This is the default view. It lists all the IAs in a table.
        index: {
            view: function() {
                append_html("index_view", this.result);

                // Add click events specific to the page.
                $("#sort_name").click(this.util.click.bind(this, "name"));
                $("#sort_repo").click(this.util.click.bind(this, "repo"));
                $("#sort_status").click(this.util.click.bind(this, "status"));                

                return this;
            },
            data: function(result) {
                this.result = sort("name", result, true);
                return this;
            },
            util: {
                sort_asc: {
                    name: true,
                    repo: true,
                    status: true
                },
                click: function(col) {
                    this.util.sort_asc[col] = !this.util.sort_asc[col];
                    sort(col, this.result, this.util.sort_asc[col]);
                    this.view();
                }
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
                var a = m[what] || "";
                var b = n[what] || "";
            } else {
                var a = n[what] || "";
                var b = m[what] || "";
            }

            if(a > b) {
                return 1;
            } else if(a < b) {
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
