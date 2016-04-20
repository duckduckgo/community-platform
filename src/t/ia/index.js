var config = require("../config.json"),
    hostname = casper.cli.get('hostname');

    NAVBAR = ".developer-nav",
    IA_LIST = "#ia_index",
    FILTERS = "#filters",
    REPO_FILTER = "#ia_repo-",
    REPO_IA = ".ia-item > .ia_repo-";


casper.test.begin("IA Index", function suite(test) {
    casper.start("http://" + hostname + ".duckduckgo.com:5001/ia", function(response) {
        // we don't really support mobile yet
        casper.viewport(1336, 768).then(function() {
            this.reload(function() {

                test.comment("Check existence of basic elements in the page")
                test.assertExists(NAVBAR);
                test.assertExists(IA_LIST);
                test.assertExists(FILTERS);

                for (var i = 0; i < config.ia_types.length; i++) {
                    var current_type = config.ia_types[i];
                    test.comment("Test filtering by type - " + current_type);
                    this.click(REPO_FILTER + current_type);

                    test.assertVisible(REPO_IA + current_type, current_type + " type visible after filtering");

                    for (var j = 0; j < config.ia_types.length; j++) {
                        if (j !== i) {
                            var unselected_type = config.ia_types[j];
                            test.assertNotVisible(REPO_IA + unselected_type, unselected_type + " type hidden after filtering");
                        }
                    }
                }
          });
       });
    });

    casper.run(function() {
        test.done()
    });
});




