var Hikari_ABID = $.GetContextPanel().FindChildTraverse("Hikari_ABID");
var Hikari_SK = $.GetContextPanel().FindChildTraverse("Hikari_SK");
var plid = Players.GetLocalPlayer()

function Load_Hikari() {
    Hikari_SK.abilityname = "purification_new";
}


function Show_Hikari(b) {
    if (b) {
        //  $.DispatchEvent("DOTAShowTitleTextTooltip", "ok", "qs");

    } else {
        //   $.DispatchEvent("DOTAHideTitleTextTooltip");
    }
}