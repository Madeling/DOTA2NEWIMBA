var WIN = 50;
var KILL = 1000;
var TOWER = 50;
var DESW = 100;
var panel = $.GetContextPanel()
var plid = Players.GetLocalPlayer()
var SKILLS_BG = panel.FindChildTraverse("SKILLS_BG");
var SKILLS_ID = panel.FindChildTraverse("SKILLS_ID");
var AG_ID = panel.FindChildTraverse("AG_ID");
var AG = panel.FindChildTraverse("AG");
var SKILL_P = [3];
var SKILL_NUM = [3];

function skillstart() {
    for (var index = 1; index <= 3; index++) {
        SKILL_P[index] = panel.FindChildTraverse("SKILLS" + index.toString());
        SKILL_NUM[index] = panel.FindChildTraverse(index.toString());
    }
    /*
    var hero = Players.GetPlayerSelectedHero(plid)
    var result = false;
    for (var i=0; i < HEROLIST.length; i++) {
        if (HEROLIST[i] === hero) {
            result = true;
            break;
        }
    }
    if (result==false) {
        GameEvents.SendCustomGameEventToServer("OnAbility_Set", { id: Players.GetLocalPlayer(), roll: 1 });
    }
    */
}

function skillset(data) {
    panel.FindChildTraverse("SKILLS_ID").style.visibility = "visible";
    if (Players.IsValidPlayerID(plid)) {
        for (a = 1; a < 4; a++) {
            SKILL_NUM[a].abilityname = data[1][a];
        }
        AG.SetPanelEvent('onmouseactivate', function() {
            GameEvents.SendCustomGameEventToServer("OnAbility_Set", { id: plid, roll: 0, res: 1, rollnum: 1 });
            AG_ID.style.visibility = "collapse";
        });
    }
}

function roll(data) {
    AG_ID.style.visibility = "visible";
}

function skill(num) {
    var skill = SKILL_NUM[num]
    if (skill.abilityname == "gamble") {
        GameEvents.SendCustomGameEventToServer("OnAbility_Set", { id: plid, res: 1 });
        return
    }
    AG_ID.style.visibility = "collapse";
    SKILLS_ID.style.visibility = "collapse";
    if (Players.IsValidPlayerID(plid)) {
        GameEvents.SendCustomGameEventToServer("Get_Ability", { name: skill.abilityname, id: plid });
    }
}

function skillshow(A, B) {
    var sk = panel.FindChildTraverse(B.toString());
    if (A) {
        $.DispatchEvent("DOTAShowAbilityTooltip", sk, sk.abilityname);
    } else {
        $.DispatchEvent("DOTAHideAbilityTooltip", sk);
    }
}


GameEvents.Subscribe("roll", roll);
GameEvents.Subscribe("skillset", skillset);


var HEROLIST=
[
    "npc_dota_hero_sniper",
    "npc_dota_hero_lina",
]