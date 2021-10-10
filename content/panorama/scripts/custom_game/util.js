var DOTA_TEAM_SPECTATOR = 1;

function GetHEXPlayerColor(playerId) {
    var playerColor = Players.GetPlayerColor(playerId).toString(16);
    return playerColor == null ? '#000000' : ('#' + playerColor.substring(6, 8) + playerColor.substring(4, 6) + playerColor.substring(2, 4) + playerColor.substring(0, 2));
}

function secondsToMS(seconds, bTwoChars) {
    var sec_num = parseInt(seconds, 10);
    var minutes = Math.floor(sec_num / 60);
    var seconds = Math.floor(sec_num - minutes * 60);

    if (bTwoChars && minutes < 10)
        minutes = '0' + minutes;
    if (seconds < 10)
        seconds = '0' + seconds;
    return minutes + ':' + seconds;
}

function dynamicSort(property) {
    var sortOrder = 1;
    if (property[0] === "-") {
        sortOrder = -1;
        property = property.substr(1);
    }
    return function(a, b) {
        var result = (a[property] < b[property]) ? -1 : (a[property] > b[property]) ? 1 : 0;
        return result * sortOrder;
    }
}

function SortPanelChildren(panel, sortFunc, compareFunc) {
    var tlc = panel.Children().sort(sortFunc)
    $.Each(tlc, function(child) {
        for (var k in tlc) {
            var child2 = tlc[k]
            if (child != child2 && compareFunc(child, child2)) {
                panel.MoveChildBefore(child, child2)
                break;
            }
        }
    });
}

/**
 * Simple Panel Animation
 * 
 * Simple panel animations for Panorama UI
 */

var DEFAULT_DURATION = "300.0ms";
var DEFAULT_EASE = "linear";

/* AnimatePanel
 * Animates a panel
 * 
 * Params:
 * 		panel 		- Panel to animate
 *		values 		- Dictionary containing the properties and values to animate.
 *					  Example: { "transform": "translateX(100);", "opacity": "0.5" }
 *		duration 	- The animation duration in seconds
 *		ease 		- Easing function to use. Example: "linear" or "ease-in"
 *		delay		- Time to wait before starting the animation in seconds
		AnimatePanel(panel, { "transform": "translateX(100px) translateY(50px) scaleX(1.5) scaleY(1.5);" }, 0.3);

		AnimatePanel(panel, { "transform": "translateY(10px) scaleY(2);", "opacity": "1;" }, 2, "ease-in", 1);

		AnimatePanel(panel, { "transform": "scaleX(0.5) scaleY(0.5);", "opacity": "0.3;" });
 */
function AnimatePanel(panel, values, duration, ease, delay) {
    // generate transition string
    var durationString = (duration != null ? parseInt(duration * 1000) + ".0ms" : DEFAULT_DURATION);
    var easeString = (ease != null ? ease : DEFAULT_EASE);
    var delayString = (delay != null ? parseInt(delay * 1000) + ".0ms" : "0.0ms");
    var transitionString = durationString + " " + easeString + " " + delayString;

    var i = 0;
    var finalTransition = ""
    for (var property in values) {
        // add property to transition
        finalTransition = finalTransition + (i > 0 ? ", " : "") + property + " " + transitionString;
        i++;
    }

    // apply transition
    panel.style.transition = finalTransition + ";";

    // apply values
    for (var property in values)
        panel.style[property] = values[property];
}