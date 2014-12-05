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
                var html = template.data(result).view();
                $(id).html(html);
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
                return Handlebars.templates.index({ia: this.result});
            },
            data: function(result) {
                this.result = ;
                return this;
            }
        },
        template: {
            view: function() {

            },
            data: function(result) {

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
