$(function() {
    // This class is responsible for abstracting away:
    // - Choosing the right template depending on the URL.
    // - Getting the data needed by the template.
    // - Calling the right methods to manipulate and display the data.
    DDH.Index = {
        init: function(field, value, availableTemplates) {
            this.field = field;
            this.value = value;
            this.template = availableTemplates.index;

            if(this.field && this.value) {
                this.url += "/" + field + "/" + value;
                if(this.field in availableTemplates) {
                    this.template = availableTemplates[this.field];
                }
            }

            return this;
        },

        view: function(id) {
            var template = this.template;
            $.getJSON(this.url, function(result) {
                template.data(result).view();
            });
        },
        
        url: "/ia/json"
    };

    // This hash lists implements the `view` and `data` methods of each template.
    // - `data` is responsible for manipulating the data (filtering, mapping, etc.)
    // - `view` is responsible for displaying the data on the page.
    var availableTemplates = {
        index: {
            view: function() {
                var html = Handlebars.templates.index({ia: this.result});                
                $("#ia_index").html(html);
            },
            data: function(result) {
                this.result = result;
                this.util.sort.call(this, 'name');
                return this;
            },
            util: {
                sort: function(what) {
                    this.result.sort(function(a, b) {
                        if(a[what] > b[what]) {
                            return 1;
                        } else if(a[what] < b[what]) {
                            return -1;
                        } else {
                            return 0;
                        }
                    });
                }
            }
        },
        template: {
            view: function() {
                var html = Handlebars.templates.template({ia: this.result});
                $("#ia_index").html(html);
            },
            data: function(result) {
                this.result = result;
                return this;
            }
        }
    };

    // Initialize the class.
    var id = "#ia_index";
    var field = $(id).attr("field");
    var value = $(id).attr("value");
    DDH.Index.init(field, value, availableTemplates).view(id);
});
