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
					var ia = Handlebars.templates.page({
					    name: x.name,
						topic: x.topic,
						id: x.id,
						example_query: x.example_query,
						other_queries: x.other_queries,
						repo: x.repo
				    });
                    $(".ia-single").html(ia);
					console.log(x.name);
                });
            }
        }
    };

})(DDH);
