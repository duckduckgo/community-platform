casper.test.begin("IA Index", function suite(test) {
    casper.start("http://maria.duckduckgo.com:5001/ia", function(response) {
        // we don't really support mobile yet
        casper.viewport(1336, 768).then(function() {
            this.reload(function() {

                // check basic elements exist
                test.assertExists(".developer-nav");
                test.assertExists("#ia_index");
                test.assertExists("#filters");

          });
       });
    });

    casper.run(function() {
        test.done()
    });
});




