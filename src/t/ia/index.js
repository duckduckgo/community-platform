casper.test.begin("IA Index", function suite(test) {
    casper.start("http://maria.duckduckgo.com:5001/ia", function(response) {
        // we don't really support mobile yet
        casper.viewport(1336, 768).then(function() {
            this.reload(function() {

                test.comment("Check existence of basic elements in the page")
                test.assertExists(".developer-nav");
                test.assertExists("#ia_index");
                test.assertExists("#filters");


                test.comment("Test filtering by type - Goodies");
                this.click("#ia_repo-goodies");

                test.assertVisible(".ia-item > .ia_repo-goodies", "Goodies are visible after filtering");
                test.assertNotVisible(".ia-item > .ia_repo-spice", "Spices are hidden after filtering");

          });
       });
    });

    casper.run(function() {
        test.done()
    });
});




