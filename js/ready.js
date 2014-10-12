console.log("ready.js");

$(document).ready(function() {

    if (DDH_iapage) {

        console.log("found DDH_iapage: '%s'", DDH_iapage);

        if (DDH["ready_" + DDH_iapage]) {
            DDH["ready_" + DDH_iapage]();
        }
        else {
            console.log("can't find ready_" + DDH_iapage);
        }
    }

});





