var config = require("../config.json"),
    utils__ = require("/usr/lib/node_modules/casperjs/modules/clientutils.js"),
    hostname = casper.cli.get('hostname');

    IA_IDX_HEADER = "#ia_index_header h2",
    QUERY_FILTER = 'input[name="query"]';
    SEARCH_BTN = ".filters--search-button";
    IA_ITEM = ".ia-item";
    MAINTAINER = "#maintainer--readonly a";
    CLEAR_FILTERS = "#clear_filters";

// Start from the index
casper.test.begin("IA Page", function suite(test) {
    casper.start("http://" + hostname + "/ia", function(response) {
        test.assertEquals(200, response.status);
        // we don't really support mobile yet
        casper.viewport(1336, 768).then(function() {
            this.reload(function() {

                test.comment(hostname);
                this.click(CLEAR_FILTERS);
                test.comment("See if the IA is already in the DB")
                //document.querySelectorAll(QUERY_FILTER)[0].setAttribute('value', 'vim cheat');
                this.evaluate(function() {
                    __utils__.setFieldValue(QUERY_FILTER, 'vim cheat');
                });
            });
        });
     });
 });

    casper.then(function() {
        test.comment(this.fetchText(QUERY_FILTER));
        this.click(SEARCH_BTN);
    });

    casper.then(function() {
        if (test.assertEquals(this.fetchText(IA_IDX_HEADER), "Showing 1 Instant Answers")) {
            test.pass("IA exists");
        } else {
            test.skip(1, "IA Page not found - run script/ddgc_populate_ia_dev.pl to get the latest IA Pages data");
            test.done();
        }
    });

    casper.then(function() {
        casper.open("http://" + hostname + "/ia/view/vim_cheat_sheet", function(response) {
            casper.viewport(1336, 768).then(function() {
                this.reload(function() {
                    var maintainer_url = this.getElementAttribute(MAINTAINER, "href");
                    var reg = new RegExp(/duckduckhack/);

                    test.assertMatch(maintainer_url, reg, "Maintainer has a link to the DDH Profile");
                });
            });
        });
    });

    casper.run(function() {
        test.done()
    });
});




