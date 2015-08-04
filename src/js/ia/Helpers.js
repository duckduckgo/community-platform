(function(env) {
    // Handlebars helpers for IA Pages

    /**
     * @function plural
     *
     * Returns the value of `context` (assuming `context` is a **number**)
     * and appends the singular or plural form of the specified word,
     * depending on the value of `context`
     *
     * @param {string} singular Indicates the singular form to use
     * @param {string} plural   Indicates the plural form to use
     * @param {string} delimiter **[optional]** Format the number with the `numFormat` helper
     *
     * Example:
     *
     * `{plural star_rating singular="star" plural="stars"}}`
     *
     * Will produce:
     * - `{{star_rating}} star`  if the value of `star_rating` is `1`, or
     * - `{{star_rating}} stars` if `star_rating` > `1`
     *
     */
    Handlebars.registerHelper("plural", function(num, options) {
        var singular = options.hash.singular || '',
            plural   = options.hash.plural || '',
            word = (num === 1) ? singular : plural;

        if (options.hash.delimiter){
            num = Handlebars.helpers.numFormat(num, options);
        }

        return word;
    });

    // True if v1 or v2 (or both) are true
    Handlebars.registerHelper('or', function(v1, v2, options) {
        if (v1 || v2) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });


    // True if the two vals are false
    Handlebars.registerHelper('unless_and', function(v1, v2, options) {
        if ((!v1) && (!v2)) {
            return options.fn(this);
        } else {
             return options.inverse(this);
        }
    });

    // Check if two values are equal
    Handlebars.registerHelper('eq', function(value1, value2, options) {
        if (value1 === value2) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    // Check if two values are different
    Handlebars.registerHelper('not_eq', function(value1, value2, options) {
        if (value1 !== value2) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    // True if first value is different both from the second and from the third
    Handlebars.registerHelper('ne_and', function(value1, value2, value3, options) {
        if (value1 !== value2 && value1 !== value3) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    // True if the first value is equal to the second
    // or to the third
    Handlebars.registerHelper('eq_or', function(value1, value2, value3, options) {
        if (value1 === value2 || value1 === value3) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    // True if the first value is greater than the second
    Handlebars.registerHelper('gt', function(value1, value2, options) {
        if (value1) {
            value1 = (typeof value1 == 'number')? value1 : value1.length;
            if (value1 > value2) {
                return options.fn(this);
            } else {
                return options.inverse(this);
            }
        } else {
            return options.inverse(this);
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

    // Urify string
    Handlebars.registerHelper('urify', function(txt) {
        txt = txt.toLowerCase().replace(/[^a-z]+/g, '-');
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

    // Check if object has key
    Handlebars.registerHelper('not_null', function(key, options) {
        if (key || key === '') {
            return options.fn(this);
        }
    });

    //Return final path of URL
    Handlebars.registerHelper('final_path', function(url) {
        url = url.replace(/.*\/([^\/]*)$/,'$1');
        return url;
    });

    // Loop n times
    Handlebars.registerHelper('loop_n', function(n, context, options) {
        var result = '';
        for(var i = 0; i < n; i++) {
            if (context[i]) {
                result += options.fn(context[i]);
            }
        }

        return result;
    });

    // Parse date
    Handlebars.registerHelper('parse_date', function(date) {
        date = date.replace(/T.*/, '').split('-');
        var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
        var year = date[0] || '';
        var month = date[1]? months[parseInt(date[1].replace('0', '')) - 1] : '';
        var day = date[2] || '';

        return month + ", " + day + " " + year;
    });

    // Returns true if value1 % value2 equals zero
    Handlebars.registerHelper('module_zero', function(value1, value2, options) {
        if ((value1 % value2 === 0) && (value1 > 1)) {
             return options.fn(this);
        }
    });
})(DDH);
