function optionhide(b) {
    var TIP = $.GetContextPanel().FindChildTraverse("Option_BG2");
    if (b == true) {
        TIP.style.visibility = "visible";
    } else {
        TIP.style.visibility = "collapse";
    }
}