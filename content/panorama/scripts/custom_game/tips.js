max_tip = 6

function SHOW_TIP() {
    var panel = $.GetContextPanel().FindPanelInLayoutFile("DOTA2IMBA_OP6");
    panel.style.opacity = 1;
}

function SET_TIP() {
    var tip = $.GetContextPanel().FindChildInLayoutFile("DOTA2IMBA_TIP_TEXT");
    for (let index = 1; index <= max_tip; index++) {
        tip.text += $.Localize("#tip" + index) + "\n\n";
    }
}

function HERO_TIP() {
    var tip = $.GetContextPanel().FindChildTraverse("DOTA2IMBA_HERO_Recommend");
    tip.style.backgroundImage = "url('file://{images}/custom_game/CN/cn.png')";
    //"url('file://{images}/custom_game/hero/" + Math.floor(Math.random() * 22).toString() + ".jpg')";
}