(function(env) {
    // Handlebars helpers for IA Pages

    // Check if two values are equal
    Handlebars.registerHelper('eq', function(value1, value2, options) {
        if (value1 === value2) {
            return options.fn(this);
        }
    });

})(DDH);
