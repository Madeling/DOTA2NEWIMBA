var plid = Players.GetLocalPlayer();
var TOOLS_ID = $.GetContextPanel().FindChildTraverse("TOOLS_ID");

var on_off = true;

function tools_sw() {
    Game.EmitSound("ui_team_select_shuffle");
    if (on_off) {
        TOOLS_ID.style.opacity = "0";
        on_off = false;
    } else {
        TOOLS_ID.style.opacity = "1";
        on_off = true;
    }
}

function toolsA(num) {
    Game.EmitSound("ui_team_select_shuffle");
    if (!Players.IsValidPlayerID(plid)) {
        return;
    }
    switch (num) {
        case 1:
            GameEvents.SendCustomGameEventToServer("Cheat", { id: plid, name: "xpall" });
            break;
        case 2:
            GameEvents.SendCustomGameEventToServer("Cheat", { id: plid, name: "xp" });
            break;
        case 3:
            GameEvents.SendCustomGameEventToServer("Cheat", { id: plid, name: "gold" });
            break;
        case 4:
            GameEvents.SendCustomGameEventToServer("Cheat", { id: plid, name: "eaxe" });
            break;
        case 5:
            GameEvents.SendCustomGameEventToServer("Cheat", { id: plid, name: "faxe" });
            break;
        case 6:
            GameEvents.SendCustomGameEventToServer("Cheat", { id: plid, name: "sandbag" });
            break;
        case 7:
            GameEvents.SendCustomGameEventToServer("Cheat", { id: plid, name: "heal" });
            break;
        case 8:
            Game.Disconnect();
            break;
        default:
            break;
    }

}