(function(env) {
    // Handlebars helpers for IA Pages

    // Check if two values are equal
    Handlebars.registerHelper('eq', function(value1, value2, options) {
        if (value1 === value2) {
            return options.fn(this);
        }
    });

    // True if the first value is equal to the second
    // or to the third
    Handlebars.registerHelper('eq_or', function(value1, value2, value3, options) {
        if (value1 === value2 || value1 === value3) {
            return options.fn(this);
        }
    });

    // Return the array value at the specified index
    Handlebars.registerHelper('index', function(array, idx) {
        if (array[idx]) {
            return array[idx];
        }
    });

    Handlebars.registerHelper('tab_url', function(tab) {
        if (tab && tab.length) {
            return '&ia=' + tab.toLowerCase().replace(/\s/g, "");
        }
    });

    // Strip non-alphanumeric chars from a string and transform it to lowercase
    Handlebars.registerHelper('slug', function(txt) {
        txt = txt.toLowerCase().replace(/[^a-z0-9]/g, '');
        return txt;
    });

    // Remove specified chars from a given string 
    // and replace it with specified char/string (optional)
    Handlebars.registerHelper('replace', function(txt, to_remove, replacement) {
        replacement = replacement? replacement : '';
        to_remove = new RegExp(to_remove, 'g');

        txt = txt.replace(to_remove, replacement);
        return txt;
    });

    // Returns true for values equal to zero, evaluating to false
    Handlebars.registerHelper('is_false', function(value, options) {
        value = parseInt(value);
        if (!value) {
            return options.fn(this);
        }
    });

    // Returns true if value is not null
    Handlebars.registerHelper('not_null', function(value, options) {
        if (value !== null) {
            return options.fn(this);
        }
    });

})(DDH);
