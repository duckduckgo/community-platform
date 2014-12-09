(function(env) {
    "use strict";

    // This class is responsible for abstracting away:
    // - Choosing the right template depending on the URL.
    // - Getting the data needed by the template.
    // - Calling the right methods to manipulate and display the data.
    DDH.Index = {
        init: function(field, value) {
            this.field = field;
            this.value = value;
            this.template = Views.index;

            if(this.field && this.value) {
                this.url += "/" + field + "/" + value;
                if(this.field in Views) {
                    this.template = Views[this.field];
                }
            }

            return this;
        },

        view: function() {
            var template = this.template;
            $.getJSON(this.url, function(result) {
                template.data(result).view();
            });
        },
        
        url: "/ia/json"
    };

    // Initialize the class.
    $(function() {
        var field = $("#ia_index").attr("field");
        var value = $("#ia_index").attr("value");
        DDH.Index.init(field, value).view();
    });
})(this);
