var panel = $.GetContextPanel()
var plid = Players.GetLocalPlayer()
var HERO_M_ID = panel.FindChildTraverse("HERO_M_ID")
var HERO_Text = panel.FindChildTraverse("HERO_Text")

function herostart() {
    if (Players.IsValidPlayerID(plid)) {
        GameEvents.SendCustomGameEventToServer("OnHero_Set", { id: plid });
    }
}

function select_skills(data) {
    HERO_M_ID.style.visibility = "visible";
    HERO_Text.style.visibility = "visible";
    for (var index = 1; index <= data[2]; index++) {
        var hsk = create_ab("Panel", panel, "HERO_SK", "HERO_SKC", HERO_M_ID);
        var t = create_ab("Label", hsk, "Author", "AuthorC", hsk);
        var t1 = create_ab("Label", hsk, "Author", "AuthorC", hsk);
        var aut = data[1][index]["Author"]
        var ss = data[1][index]["HasScepterAndShard"]
        var hero_name = Players.GetPlayerSelectedHero(plid);
        t.text = $.Localize("#Skills_Select");
        t1.text = $.Localize("#Skills_Desc");
        t1.html = true;
        t1.hittest = true;
        t.html = true;
        t.hittest = true;
        add_select_events(t, index, ss==1?true:false);
        if (aut != null)
        {
            var n1 = aut["name"];
            var p1 = aut["portrait"];
            var tip1 = n1 == "Valve" ? $.Localize("#Valve_Hero_Tip") : aut["tip"];
            add_author_events(t1, (n1 == null || n1 == "") ? $.Localize("#No_Skills_Select") : n1, (p1 == null || p1 == "") ? "file://{images}/heroes/" + hero_name + ".png" : p1, (tip1 == null || tip1 == "") ? $.Localize("#No_Skills_Desc") : tip1);
        }
        for (var index1 = 1; index1 < 10; index1++)
        {
            var name = data[1][index][index1]
            if (name == null || name == "generic_hidden")
            {
                continue;
            }
            var ab = create_ab("DOTAAbilityImage", hsk, "HERO_AB", "HERO_ABC", hsk);
            ab.abilityname = name;
            add_ab_events(ab, name);
        }
    }
    panel.BLoadLayout("file://{resources}/layout/custom_game/skills_select.xml", false, false);
}

function create_ab(p1, p2, id, pc, pid) {
    var pp = $.CreatePanel(p1, p2, id);
    pp.AddClass(pc);
    pp.SetParent(pid);
    return pp
}

function add_ab_events(panel, name) {
    if (panel === null)
        return;
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent("DOTAShowAbilityTooltip", panel, name);
    });
    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent("DOTAHideAbilityTooltip", panel);
    });

}

function add_select_events(panel, num, support) {
    if (panel === null)
        return;
    panel.SetPanelEvent('onmouseactivate', function() {
        GameEvents.SendCustomGameEventToServer("Get_Hero", { id: plid, num: num });
        HERO_M_ID.style.visibility = "collapse";
        HERO_Text.style.visibility = "collapse";
        if (support==false)
        {
            var aghs = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements");
            aghs.FindChildTraverse("AghsStatusContainer").style.visibility = "collapse";
        }
    });
}

function add_author_events(panel, title, hero_name, tip) {
    if (panel === null)
        return;
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent("DOTAShowTitleImageTextTooltip", title, hero_name, tip);
    });
    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent("DOTAHideTitleImageTextTooltip");
    });
}


GameEvents.Subscribe("select_skills", select_skills);