(function() {
    var availableTemplates = {
        index: {
            view: function(result) {

            },
            data: function(result) {

                return this;
            }
        },
        template: {
            view: function(result) {

            },
            data: function(result) {

                return this;
            }
        }
    };

    DDH.Index = {
        init: function(field, value) {
            this.field = field;
            this.value = value;

            if(this.field && this.value) {
                this.url += "/" + field + "/" + value;
                if(this.field in availableTemplates) {
                    this.template = availableTemplates[this.field];
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
        
        url: "/ia/json",
        template: availableTemplates.index
    };

    $(function() {
        var field = $("#ia_index").attr("field");
        var value = $("#ia_index").attr("value");

        DDH.Index.init(field, value).view();
    });
})();
