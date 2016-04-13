(function(env) {

    //console.log("DDH.js");


    env.DDH = {

    };

    env.Utils = {
        // Called on userpages links click
        sendReq: function($obj) {
            var username = $.trim($obj.text());
            var id = $obj.attr("id");
            var url_suffix = "?" + Math.ceil(Math.random() * 1e7);
            var img = new Image();

            id = (id && id.match(/maintainer/))? "maintainer" : "contributor";
            username = username? "_" + username.replace(/[^0-9a-zA-Z]/g, "") : "";

            img.src = "https://duckduckgo.com/t/iaptu_" + id + username + url_suffix;
        }

    };

})(window);
