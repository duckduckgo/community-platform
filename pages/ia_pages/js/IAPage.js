(function(env) {


    // placeholder

    DDH.IAPage = function(ops) {
        this.init(ops); 
    };

    // this could get the single IA json like the index.
    // but for now the page is being built with xslate
    DDH.IAPage.prototype = {
        init: function(ops) {
            console.log("IAPage.init()\n"); 

            if (DDH_iaid) {
                console.log("for ia id '%s'", DDH_iaid);

                $.getJSON("/ia/view/" + DDH_iaid + "/json", function(x) {
				    var ia = Handlebars.templates.page(x);
				    $(".ia-single").html(ia);
                    $(".ia-single .dev-info").on('click', DDH.IAPage.prototype.expand.bind(this));
                });
            }
	    },

	    expand: function() {
		    $(".ia-single .dev-info").addClass("hide");
		    $(".ia-single .dev-info-details").removeClass("hide");
		}        
    };

})(DDH);
