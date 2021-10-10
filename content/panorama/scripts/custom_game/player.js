var panel = $.GetContextPanel()
var veteran_BG = panel.FindChildTraverse('Veteran_BG');
var player_BG = panel.FindChildTraverse('Player_BG');
var RDSK_BG = panel.FindChildTraverse('RDSK_BG');
var veteran_data_ROOT = panel.FindChildTraverse('veteran_data_ROOT');
var player_data_ROOT = panel.FindChildTraverse('player_data_ROOT');
var random_skills_ROOT = panel.FindChildTraverse('random_skills_ROOT');
var random_skills_BG = panel.FindChildTraverse('random_skills_BG');
var random_skills_1 = panel.FindChildTraverse('random_skills_1');
var random_skills_2 = panel.FindChildTraverse('random_skills_2');
var Slotted = panel.FindChildTraverse('Slotted');
var player_LV = panel.FindChildTraverse("player_LV");
var lv_text = panel.FindChildTraverse("data0");
var plid = Players.GetLocalPlayer()
var isCreate=false;
let LV_DATA=
{
    "0": 'file://{images}/custom_game/hud/lv0.png',
    "1": 'file://{images}/custom_game/hud/lv1.png',
    "2": 'file://{images}/custom_game/hud/lv2.png',
    "3": 'file://{images}/custom_game/hud/lv3.png',
    "4": 'file://{images}/custom_game/hud/lv4.png',
    "5": 'file://{images}/custom_game/hud/lv5.png',
    "6": 'file://{images}/custom_game/hud/lv6.png',
    "7": 'file://{images}/custom_game/hud/lv7.png',
    "8": 'file://{images}/custom_game/hud/lv8.png',
}
function SendMSG() {
    if (Players.IsValidPlayerID(plid) && !Players.IsSpectator(plid)) {
        GameEvents.SendCustomGameEventToServer("Show_Data", { name: "Data", id: plid });
    }
}

function GetPlayerData(b) {
    if (Players.IsSpectator(plid)) {return}
    if (b) {
        AnimatePanel(player_BG, { "opacity": "0.5;" });
        var steamid = Game.GetPlayerInfo(Players.GetLocalPlayer()).player_steamid.toString()
        var data = CustomNetTables.GetTableValue("player_data", steamid)
        if (data!=null)
        {
            var lv = GetRankKill(data[1]);
            player_data_ROOT.style.visibility = "visible";
            lv_text.text = $.Localize("VLV") + lv;
            player_LV.SetImage(LV_DATA[lv]);
            for (var i = 1; i <= 9; i++)
            {
                    var num = i.toString()
                    var name = "#veteran_data" + num
                    var veteran = panel.FindChildTraverse("data" + num);
                    veteran.text = $.Localize(name) + data[i].toString();
            }
        }
    } else {
        AnimatePanel(player_BG, { "opacity": "1;" });
       player_data_ROOT.style.visibility = "collapse";
    }
}

function GetRankKill(k) {
    var lv = 0;
    if (k < 500) {
        lv = 0;
    } else if (k >= 500 && k < 1000) {
        lv = 1;
    } else if (k >= 1000 && k < 1500) {
        lv = 2;
    } else if (k >= 1500 && k < 2000) {
        lv = 3;
    } else if (k >= 2000 && k < 2500) {
        lv = 4;
    } else if (k >= 2500 && k < 3000) {
        lv = 5;
    } else if (k >= 3000 && k < 3500) {
        lv = 6;
    } else if (k >= 3500 && k < 4000) {
        lv = 7;
    } else if (k >= 4500) {
        lv = 8;
    }
    return lv
}


///////////////////////////////////////////////////////////

function OnRDSK() {
    AnimatePanel(RDSK_BG, { "opacity": "0.5;" }, 0, "ease-in", 0.2);
    random_skills_ROOT.style.visibility = "visible";
    if (isCreate==false)
    {
        isCreate=true;
        for (var index = 0; index < RandomAbility.length; index++) {
            var pp = $.CreatePanel("DOTAAbilityImage", random_skills_1, "abilityID");
            pp.AddClass("ability");
            pp.abilityname = RandomAbility[index];
            PanelEvent(pp, pp.abilityname);
        }
        for (var index = 0; index < RandomAbility2.length; index++) {
            var pp = $.CreatePanel("DOTAAbilityImage", random_skills_2, "abilityID");
            pp.AddClass("ability");
            pp.abilityname = RandomAbility2[index];
            PanelEvent(pp, pp.abilityname);
        }
    }
}

function HideRDSK() {
    AnimatePanel(RDSK_BG, { "opacity": "1;" }, 0, "ease-in", 0.2);
    random_skills_ROOT.style.visibility = "collapse";
}

function PanelEvent(pp,name) {
    pp.SetPanelEvent('onmouseover', function () {
        $.DispatchEvent("DOTAShowAbilityTooltip", pp, name);
    });
    pp.SetPanelEvent('onmouseout', function () {
        $.DispatchEvent("DOTAHideAbilityTooltip", pp);
    });
}

///////////////////////////////////////////////////////////

var button_Veteran = [
    panel.FindChildTraverse("button_Veteran0"),
    panel.FindChildTraverse("button_Veteran1"),
    panel.FindChildTraverse("button_Veteran2"),
    panel.FindChildTraverse("button_Veteran3"),
]
var Veteran = [
    panel.FindChildTraverse("veteran0"),
    panel.FindChildTraverse("veteran1"),
    panel.FindChildTraverse("veteran2"),
    panel.FindChildTraverse("veteran3"),
]

function OnVeteran() {
    AnimatePanel(veteran_BG, { "opacity": "0.5;" }, 0, "ease-in", 0.2);
    veteran_data_ROOT.style.visibility = "visible";

}

function HideVeteran() {
    AnimatePanel(veteran_BG, { "opacity": "1;" }, 0, "ease-in", 0.2);
    veteran_data_ROOT.style.visibility = "collapse";
}

function ButtonVeteran(id) {
    for (let index = 0; index < button_Veteran.length; index++) {
        if (index == id)
        {
            button_Veteran[index].AddClass("button_Veteran_class1");
            Veteran[index].style.visibility = "visible";
        }else{
            button_Veteran[index].RemoveClass("button_Veteran_class1");
            Veteran[index].style.visibility = "collapse";
        }
    }
}


var RandomAbility =
[
    "multishot", "chilling_touch", "axe_sprint", "berserkers_call", "counter_helix", "double_edge", "surge", "dragon_blood", "dragon_tail", "searing_chains",
    "rocket_barrage", "blade_dance", "torrent", "howl", "mystic_snake", "crippling_fear", "essence_aura", "purification", "fortunes_end", "shackleshot",
    "powershot", "poison_nova", "storm_bolt", "slug", "hellfire_blast", "shock", "caustic_finale", "icarus_dive", "phantom_strike", "malefice", "stifling_dagger",
    "epicenter", "refraction", "wave_of_silence", "corrosive_skin", "nethertoxin", "plague_ward", "venomous_gale", "warcry", "sniper_roll", "burrowstrike",
    "imba_rattletrap_battery_assault", "guardian_angel", "sanity_eclipse", "boundless_strike", "shapeshift", "healing_ward", "sprout", "midnight_pulse", "seriously_punch",
    "ion_shell", "culling_blade", "ice_vortex", "ice_blast", "imba_storm_spirit_electric_vortex", "imba_storm_spirit_ball_lightning", "grenade", "echo_stomp",
    "guided_missile", "imba_bounty_hunter_shuriken_toss", "imba_chaos_knight_chaos_bolt", "imba_chaos_knight_chaos_strike", "imba_lina_dragon_slave", "imba_lina_light_strike_array",
    "imba_razor_plasma_field", "oldsky_aseal", "imba_leshrac_pulse_nova", "aghsfort_mars_spear", "imba_mirana_arrow", "imba_mirana_leap", "hoof_stomp", "breathe_fire",
    "sleight_of_fist", "song_of_the_siren", "voodoo", "decay", "windrun", "bulldoze", "charge_of_darkness", "greater_bash", "dual_breath", "ice_path", "macropyre",
    "toss_", "wdnmd", "shell_", "money", "mount", "dog", "gamble", "thunderstorm", "deerskin", "des_build", "fight", "kill_trees", "reduce", "laser_turret", "counterattack",
    "tower", "aphotic_shield", "death_coil", "frostmourne", "purification_new", "guardian_angel_new", "imba_queenofpain_blink", "imba_queenofpain_shadow_strike", "imba_queenofpain_scream_of_pain",
    "imba_queenofpain_sonic_wave", "imba_huskar_inner_fire", "imba_huskar_burning_spear", "imba_huskar_berserkers_blood", "polymerization", "forbid", "deception",
    "mother_love", "tp_tp", "assembly", "imba_witch_doctor_voodoo_switcheroo", "imba_witch_doctor_voodoo_restoration", "brain_sap", "enfeeble", "nightmare",
    "imba_tiny_grow", "imba_tiny_avalanche", "imba_treant_natures_grasp", "imba_light_radiant_bind", "imba_light_blinding_light", "imba_luna_lucent_beam",
    "imba_luna_lunar_blessing", "imba_spectre_desolate", "imba_phantom_lancer_spirit_lance", "prot", "flesh_heap", "dismember", "mountain", "shockwave",
    "imba_phantom_lancer_doppelwalk", "imba_phantom_lancer_phantom_edge", "imba_bristleback_viscous_nasal_goo", "imba_bristleback_quill_spray", "empower",
        "unstable_concoction_throw", "winters_curse", "cold_embrace", "splinter_blast",
    "pangolier_swashbuckle", "tidehunter_anchor_smash", "rattletrap_hookshot", "earthshaker_aftershock", "warlock_rain_of_chaos", "pudge_meat_hook", "queenofpain_blink",
    "shadow_shaman_voodoo", "faceless_void_time_walk", "dark_troll_warlord_ensnare", "polar_furbolg_ursa_warrior_thunder_clap", "centaur_khan_war_stomp", "roshan_spell_block",
    "roshan_slam", "hoodwink_scurry",  "filler_ability", "necronomicon_archer_aoe", "satyr_hellcaller_shockwave", "victory", "fiery_soul", "laguna_blade",

]


var RandomAbility2 =
[
    "filler_ability",
    "roshan_spell_block",
    "necronomicon_archer_aoe",
    "shredder_reactive_armor",
    "dragon_knight_dragon_blood",
    "omniknight_degen_aura",
    "huskar_burning_spear",
    "bounty_hunter_jinada",
    "ursa_fury_swipes",
    "ogre_magi_bloodlust",
    "troll_warlord_fervor",
    "centaur_return",
    "pangolier_heartpiercer",
    "life_stealer_feast",
    "pudge_flesh_heap",
    "earthshaker_aftershock",
    "sven_great_cleave",
    "drow_ranger_marksmanship",
    "razor_eye_of_the_storm",
    "crystal_maiden_brilliance_aura",
    "kunkka_tidebringer",
    "tiny_grow",
    "sniper_headshot",
    "beastmaster_inner_beast",
    "dragon_knight_elder_dragon_form",
    "huskar_berserkers_blood",

    "greater_bash",
    "tower1_watchtower",
    "blade_dance",
    "chilling_touch",
    "c_return",
    "untouchable",
    "rip_tide",
    "psi_blades",
    "counter_helix",
    "natural_order_spirit",
    "impetus",
    "feral_impulse",
    "corrosive_skin",
    "poison_sting",
    "blur",
    "divine_favor",
    "hunter_in_the_night",
    "poison_attack",
    "degen_aura",
    "imba_storm_spirit_overload",
    "dlzuus_al",
    "oldtroll_fervor",
    "wdnmd",
    "polymerization",
    "tower",
    "counterattack",
    "laser_turret",
    "reduce",
    "kill_trees",
    "victory",
    "fight",
    "des_build",
    "deerskin",
    "gamble",
    "dog",
    "money",
    "mount",
    "deception",
    "mother_love",
    "tp_tp",
    "assembly",
    "imba_tiny_grow",
    "imba_luna_lunar_blessing",
    "imba_spectre_desolate",
    "imba_phantom_lancer_phantom_edge",
    "imba_bristleback_warpath",
    "prot",
    "fiery_soul",
]