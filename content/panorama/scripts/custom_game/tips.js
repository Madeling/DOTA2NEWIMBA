max_tip = 6
var num = 1;
var max_t = 17;
var panel = $.GetContextPanel()
var tip_text = panel.FindChildTraverse("tip_text");

function SET_DESC() {
    var DOTA2IMBA_DESC_INFO = $.GetContextPanel().FindChildInLayoutFile("DOTA2IMBA_DESC_INFO");
    for (let index = 1; index <= max_tip; index++) {
        DOTA2IMBA_DESC_INFO.text += $.Localize("#tip" + index) + "\n\n";
    }
}


function Set_TIP_Data(a) {
    switch (a) {
        case 0:
            if (num <= 1) {
                num = max_t;
            } else {
                num -= 1;
            }
            break;
        case 1:
            if (num >= max_t) {
                num = 1;
            } else {
                num += 1;
            }
            break;

        default:
            break;
    }
    tip_text.text = $.Localize("#tip_game" + num);
}