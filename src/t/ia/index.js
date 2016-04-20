var page = require('webpage').create();

page.open('https://maria.duckduckgo.com:5001/ia', function(status) {
    console.log(page.content);
    phantom.exit();
});



/*
casper.test.begin('IA Index', function suite(test) {
    casper.start("http://duck.co/ia", function() {
        casper.viewport(1336, 768).then(function() {
            this.reload(function() {
   
            casper.echo(this.fetchText('h2'));

            casper.echo(this.getPageContent());

            casper.echo(this.userAgent());

         });
         });
            
    });
        
    casper.on('page.resource.received', function(requestData, request) {
        casper.echo(JSON.stringify(requestData));
    });

    casper.then(function() {
        this.echo(this.getHTML());
    });
    
    casper.then(function() {
            test.pass('Test');
    });

    casper.run(function() {
        suite();
        test.done()
    });
});

i



*/
