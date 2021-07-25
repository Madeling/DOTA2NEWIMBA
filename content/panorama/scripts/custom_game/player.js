var veteran_BG = $.GetContextPanel().FindChildTraverse('Veteran_BG');
var player_BG = $.GetContextPanel().FindChildTraverse('player_BG');
var veteran_data_ROOT = $.GetContextPanel().FindChildTraverse('veteran_data_ROOT');
var player_data_ROOT = $.GetContextPanel().FindChildTraverse('player_data_ROOT');
var player_LV = $.GetContextPanel().FindChildTraverse("player_LV");
var veteran9 = $.GetContextPanel().FindChildTraverse("veteran9");
var tip_data_ROOT = $.GetContextPanel().FindChildTraverse("tip_data_ROOT");
var tip_text = $.GetContextPanel().FindChildTraverse("tip_text");
var plid = Players.GetLocalPlayer()
var data = null;
var num = 1;
var max_t = 17;
GameEvents.Subscribe("User_Data", User_Data);

function Send_MSG() {
    if (Players.IsValidPlayerID(plid) && !Players.IsSpectator(plid)) {
        GameEvents.SendCustomGameEventToServer("Show_Data", { name: "Data", id: plid });
    }
}

function Get_Player_Data(b) {
    if (b) {
        player_data_ROOT.style.visibility = "visible";
        if (data != null) {
            var lv = Get_Rank_Kill(data[1]);
            player_LV.style.backgroundImage = "url(" + "'" + lv[0] + "'" + ")";
            veteran9.text = "Level < " + lv[1] + " > " + "每击杀500人提升1级，中途退出不计算数据";
            for (let i = 1; i <= 8; i++) {
                var num = i.toString()
                var name = "#veteran_data" + num
                var veteran = $.GetContextPanel().FindChildTraverse("veteran" + num);
                veteran.text = $.Localize(name) + data[i].toString();
            }
        }
    } else {
        player_data_ROOT.style.visibility = "collapse";
    }
}

function Get_Rank_Kill(k) {
    var image = "";
    var lv = "";
    if (k < 500) {
        image = 'file://{images}/rank_tier_icons/rank0_psd.vtex';
        lv = 0;
    } else if (k >= 500 && k < 1000) {
        lv = 1;
        image = 'file://{images}/rank_tier_icons/rank1_psd.vtex';
    } else if (k >= 1000 && k < 1500) {
        lv = 2;
        image = 'file://{images}/rank_tier_icons/rank2_psd.vtex';

    } else if (k >= 1500 && k < 2000) {
        lv = 3;
        image = 'file://{images}/rank_tier_icons/rank3_psd.vtex';
    } else if (k >= 2000 && k < 2500) {
        lv = 4;
        image = 'file://{images}/rank_tier_icons/rank4_psd.vtex';
    } else if (k >= 2500 && k < 3000) {
        lv = 5;
        image = 'file://{images}/rank_tier_icons/rank5_psd.vtex';
    } else if (k >= 3000 && k < 3500) {
        lv = 6;
        image = 'file://{images}/rank_tier_icons/rank6_psd.vtex';
    } else if (k >= 3500 && k < 4000) {
        lv = 7;
        image = 'file://{images}/rank_tier_icons/rank7_psd.vtex';
    } else if (k >= 4500) {
        lv = 8;
        image = 'file://{images}/rank_tier_icons/rank8_psd.vtex';
    }
    var IL = new Array();
    IL[0] = image;
    IL[1] = lv;
    return IL
}

function User_Data(tb) {
    data = tb[1]
}


function on_off_Veteran(b) {
    if (b) {
        veteran_data_ROOT.style.visibility = "visible";
    } else {
        veteran_data_ROOT.style.visibility = "collapse";
    }
}




function Get_TIP_Data(b) {
    if (b) {
        tip_data_ROOT.style.visibility = "visible";
    } else {
        tip_data_ROOT.style.visibility = "collapse";
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