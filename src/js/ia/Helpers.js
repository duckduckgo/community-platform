(function(env) {
    // Handlebars helpers for IA Pages

    // Return the string correctly formatted with newlines
    Handlebars.registerHelper("newlines", function(string) {
        string = string.replace(/\n/g, "<br />");

        return new Handlebars.SafeString(string);
    });

    // Return elapsed time expressed as days from now (e.g. 5 days, 1 day, today)
    Handlebars.registerHelper("timeago", function(date, full) {
        var timestring = full? " days ago" : "d";
        if (date) {
            // expected date format: YYYY-MM-DDTHH:mm:ssZ e.g. 2011-04-22T13:33:48Z
            date = date.replace("/T.*Z/", " ");
            date = moment.utc(date, "YYYY-MM-DD");
            
            var elapsed = parseInt(moment().diff(date, "days", true));
            date = elapsed + timestring;

            return date;
        }
    });

    // Format the full date and convert time to local timezone time
    Handlebars.registerHelper("format_time", function(date) {
        if (date) {
            var offset = moment().local().utcOffset();

            // expected date format: YYYY-MM-DDTHH:mm:ssZ e.g. 2011-04-22T13:33:48Z
            date = date.replace("T", " ").replace("Z", " ");
            date = moment.utc(date, "YYYY-MM-DD HH:mm:ss");
            date = date.add(offset, "m");
            date = date.format('D MMM YYYY HH:mm');
            return date;
        }
     });

     // Return true if date1 is before date2
     Handlebars.registerHelper("is_before", function(date1, date2, options) {
        if (moment.utc(date1).isBefore(date2)) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
     });

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

    Handlebars.registerHelper("exists", function(obj, key, options) {
       if (obj && obj.hasOwnProperty(key)) {
           return options.fn(this);
       } else {
           return options.inverse(this);
       }
    });

    Handlebars.registerHelper("exists_subkey", function(obj, key, subkey, options) {
        if (obj && obj[key] && obj[key].hasOwnProperty(subkey)) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    Handlebars.registerHelper("n_exists", function(obj, key, options) {
        if (!obj || !obj.hasOwnProperty(key)) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    Handlebars.registerHelper("n_exists_subkey", function(obj, key, subkey, options) {
        if (!obj || !obj[key] || !obj[key].hasOwnProperty(subkey)) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
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

    // Check if val1 matches val2 using a regex
    Handlebars.registerHelper('match', function(val1, val2, options) {
       val2 = new RegExp(val2);
       if ((val1 && val2) && val1.match(val2)) {
           return options.fn(this);
       } else {
           return options.inverse(this);
       }
    });

    // Check if val1 matches val2 (not conditional)
    Handlebars.registerHelper('match', function(val1, val2) {
         var result = false;
         if (val1 && val2) {
             val2 = new RegExp(val2);
             if (val1.match(val2)) {
                  result = true;
             } 
         }

         return result;
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
        txt = txt? txt.toLowerCase().replace(/[^a-z0-9]/g, '') : '';
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

    // Returns true if any value in the array is false
    Handlebars.registerHelper('is_false_array', function(val1, val2, val3, val4, val5, val6, options) {
        if ((!val1) || (!val2) || (!val3) || (!val4) || (!val5) || (!(val6 && val6.length))) {
            return options.fn(this);
        } else {
            return options.inverse(this);
        }
    });

    // Returns true for values equal to 1, evaluating to true
    Handlebars.registerHelper('is_true', function(value, options) {
        value = parseInt(value);
        if (value) {
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
        if(url) {
            url = url.replace(/.*\/([^\/]*)$/,'$1');
        }
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

    // return the length of an array
    Handlebars.registerHelper('length', function(obj) {
        if(Array.isArray(obj)){
            return obj.length;
        }
    });

    // return sum of up to 4 values
    Handlebars.registerHelper('sum', function(v1, v2, v3, v4) {
        var values = [v1, v2, v3, v4];
        var total = 0;
        for(var i = 0; i < values.length; i++){
            if( typeof values[i] == 'number' ){
                total += values[i];
            }
        }
        return total;
    });

    // return total number of IAs since a given number of days
    // obj: array of IA objects
    // days: int
    // operator: 'less-than' 'greater-than'
    Handlebars.registerHelper('stats_from_day', function(obj, days, operator) {
        var calc = function(date, operator) {
            var days_from = function(tmpdate){
                var dateObj = moment.utc(tmpdate, "YYYY-MM-DD");
                var elapsed = parseInt(moment().diff(dateObj, "days", true));
                return elapsed;
            };

            if(operator == 'less-than'){
                if(days_from(date) < days){
                    return 1;
                }
            }
            if(operator == 'greater-than'){
                if(days_from(date) > days){
                    return 1;
                }
            }
            
        };

        var total = 0;
        if(obj){
            for(var i = 0; i < obj.length; i++){
                if( calc(obj[i].created_date, operator) ){
                        total++;
                }
            }
        }
        return total;
    });

})(DDH);
