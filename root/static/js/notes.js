<script type="text/javascript">
    //--indicates the mouse is currently over a div
    var onDiv = false;
    //--indicates the mouse is currently over a link
    var onLink = false;
    //--indicates that the bubble currently exists
    var bubbleExists = false;
    //--this is the ID of the timeout that will close the window if the user mouseouts the link
    var timeoutID;

    function addBubbleMouseovers(mouseoverClass) {
        $("."+mouseoverClass).mouseover(function(event) {
            if (onDiv || onLink) {
                return false;
            }

            onLink = true;

            showBubble.call(this, event);
        });

        $("." + mouseoverClass).mouseout(function() {
            onLink = false;
            timeoutID = setTimeout(hideBubble, 150);
        });
    }

    function hideBubble() {
        clearTimeout(timeoutID);
        //--if the mouse isn't on the div then hide the bubble
        if (bubbleExists && !onDiv) {
             $("#bubbleID").remove();

             bubbleExists = false;
        }
    }

    function showBubble(event) {
        if (bubbleExists) {
            hideBubble();
        }

        var tPosX = event.pageX + 15;
        var tPosY = event.pageY - 60;
        $('<div ID="bubbleID" style="top:' + tPosY + '; left:' + tPosX + '; position: absolute; display: inline; border: 2px; width: 200px; height: 150px; background-color: Red;">TESTING!!!!!!!!!!!!</div>').mouseover(keepBubbleOpen).mouseout(letBubbleClose).appendTo('body');

        bubbleExists = true;
    }

    function keepBubbleOpen() {
        onDiv = true;
    }

    function letBubbleClose() {
        onDiv = false;

        hideBubble();
    }


    //--TESTING!!!!!
    $("document").ready(function() {
        addBubbleMouseovers("temp1");
    });
</script>