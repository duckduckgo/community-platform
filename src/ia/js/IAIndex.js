(function() {
    DDH.Index = {
        init: function(field, value) {
            // This lists all of the available templates that we could use.
            var availableTemplates = {
                index: {
                    view: function(data) {

                    }
                },
                template: {
                    view: function(data) {

                    }
                },
            };
            
            // Initialize the properties.
            this.field = field;
            this.value = value;
            this.url = "/ia/json";

            // Check if we need to use a new template.
            // If there aren't any, stick with the default (called "index").
            this.use = availableTemplates.index;
            if(this.field && this.value) {
                this.url += "/" + field + "/" + value;
                if(this.field in availableTemplates) {
                    this.use = availableTemplates[this.field];
                }
            }
        },

        view: function() {
            var that = this;
            // Get the data that we need.
            $.getJSON(this.url, function(data) {
                that.use.view(data);
            });
        }
    };

    DDH.Index.init();
    DDH.Index.view();
})();
