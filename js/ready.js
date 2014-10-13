console.log("ready.js");

$(document).ready(function() {

    if (DDH_iapage) {

        console.log("found DDH_iapage: '%s'", DDH_iapage);

        if (DDH[DDH_iapage]) {
            DDH.index = new DDH[DDH_iapage]();
        }
        // else .. error
    }

});





