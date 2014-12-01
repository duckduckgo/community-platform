(function(env) {
    Handlebars.registerHelper('encode', function(s) {
        // decode first so we can support partially encoded
        // stuff without having to do anything extra.
        s = decodeURIComponent(s);
        return encodeURIComponent(s);
    });
}(this));
