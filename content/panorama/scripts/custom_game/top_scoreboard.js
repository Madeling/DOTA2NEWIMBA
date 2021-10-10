var PlayerPanels = {};
var TeamPanels = {};
var darknessEndTime = -Number.MAX_VALUE;
var TopBarScore = null;
var teamColors = {};
var map = Game.GetMapInfo().map_display_name == "6v6v6" ? true : false;
teamColors[DOTATeam_t.DOTA_TEAM_GOODGUYS] = "#008000";
teamColors[DOTATeam_t.DOTA_TEAM_BADGUYS] = "#FF0000";
teamColors[DOTATeam_t.DOTA_TEAM_CUSTOM_1] = "#FF0000";
function Snippet_TopBarPlayerSlot(playerId) {
    if (PlayerPanels[playerId] != null) return PlayerPanels[playerId];
    var team = Players.GetTeam(playerId)
        //if (team === DOTA_TEAM_SPECTATOR) return PlayerPanels[playerId];
    if (Players.IsSpectator(playerId)) return PlayerPanels[playerId];
    var teamPanel = Snippet_DotaTeamBar(team).FindChildTraverse('TopBarPlayersContainer');
    var panel = $.CreatePanel('Panel', teamPanel, '');
    panel.BLoadLayoutSnippet('TopBarPlayerSlot');
    panel.playerId = playerId;
    var hm = panel.FindChildTraverse('HeroImage')
    hm.SetPanelEvent('onactivate', function() {
        Players.PlayerPortraitClicked(playerId, GameUI.IsControlDown(), GameUI.IsAltDown());
    });
    hm.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent("DOTAShowTitleTextTooltip", "玩家名称 -  " + Players.GetPlayerName(panel.playerId), "SteamID -  <font color='#EE2C2C'>" + Game.GetPlayerInfo(panel.playerId).player_steamid) + "</font>";
    });
    //////////////////////////////////////////////////////
    hm.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTitleTextTooltip');
    });

    ///////////////////////////////////////////////////////////
    var TopBarUltIndicator = panel.FindChildTraverse('TopBarUltIndicator');

    TopBarUltIndicator.SetPanelEvent('onmouseover', function() {
        if (panel.ultimateCooldown != null && panel.ultimateCooldown > 0) {
            $.DispatchEvent('UIShowTextTooltip', TopBarUltIndicator, panel.ultimateCooldown);
        }
    });
    panel.FindChildTraverse('TopBarUltIndicator').SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('UIHideTextTooltip', panel);
    });
    panel.Resort = function() {
        SortPanelChildren(teamPanel, dynamicSort('-playerId'), function(child, child2) {
            return child.playerId > child2.playerId;
        });
    };
    panel.Resort();
    PlayerPanels[playerId] = panel;
    return panel;
}

function Snippet_TopBarPlayerSlot_Update(panel) {
    var playerId = panel.playerId;
    var playerInfo = Game.GetPlayerInfo(playerId);
    var connectionState = playerInfo.player_connection_state;
    //panel.visible = connectionState != DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED;
    //if (!panel.visible) return;
    var respawnSeconds = playerInfo.player_respawn_seconds;
    var heroEnt = playerInfo.player_selected_hero_entity_index;
    var isAlly = playerInfo.player_team_id === Players.GetTeam(Game.GetLocalPlayerID());
    panel.SetDialogVariableInt('respawn_seconds', respawnSeconds + 1);
    panel.SetHasClass('Dead', respawnSeconds >= 0);
    panel.SetHasClass('Disconnected', connectionState === DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED);
    const heroImage = panel.FindChildTraverse('HeroImage');
    heroImage.heroname = playerInfo.player_selected_hero;
    panel.FindChildTraverse('PlayerColor').style.backgroundColor = GetHEXPlayerColor(playerId);
    var ultStateOrTime = isAlly ? Game.GetPlayerUltimateStateOrTime(playerId) : PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_HIDDEN;
    panel.SetHasClass('UltLearned', ultStateOrTime !== PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NOT_LEVELED);
    panel.SetHasClass('UltReady', ultStateOrTime === PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_READY);
    panel.SetHasClass('UltReadyNoMana', ultStateOrTime === PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NO_MANA);
    panel.SetHasClass('UltOnCooldown', ultStateOrTime > 0);
    panel.FindChildTraverse('HealthBar').value = Entities.GetHealthPercent(heroEnt) / 100;
    panel.FindChildTraverse('ManaBar').value = Entities.GetMana(heroEnt) / Entities.GetMaxMana(heroEnt);
    panel.ultimateCooldown = ultStateOrTime;
    panel.SetHasClass("BuybackReady", Players.CanPlayerBuyback(playerId));
    var lastBuybackTime = Players.GetLastBuybackTime(playerId)
    panel.SetHasClass("BuybackUsed", lastBuybackTime != 0 && Game.GetGameTime() - lastBuybackTime < 10)
    if (!Players.IsSpectator(playerId) && playerInfo.player_team_id !== panel.GetParent().team && teamColors[playerInfo.player_team_id] != null) {
        panel.SetParent(Snippet_DotaTeamBar(playerInfo.player_team_id).FindChildTraverse('TopBarPlayersContainer'));
    }
}

function Snippet_DotaTeamBar(team) {

    if (TeamPanels[team] == null) {
        var num = map ? 1 : 2;
        var isRight = team % num !== 0;
        var rootPanel = $(isRight ? '#TopBarRightPlayers' : '#TopBarLeftPlayers');
        var panel = $.CreatePanel('Panel', rootPanel, '');
        panel.BLoadLayoutSnippet('DotaTeamBar');
        panel.team = team;
        TopBarScore = panel.FindChildTraverse('TopBarScore')
       // TopBarScore.style.textShadow = '0 0 10px ' + teamColors[team];
        if (map==true)
          {
            var context = $.GetContextPanel();
            var TopBarLeftTeams = context.FindChildTraverse("TopBarLeftTeams")
            TopBarLeftTeams.style.width = "1530px";
            var TimeOfDayBG = context.FindChildTraverse("TimeOfDayBG")
            TimeOfDayBG.style.marginLeft = "1350px";
            var TimeOfDay = context.FindChildTraverse("TimeOfDay")
            TimeOfDay.style.marginLeft = "1350px";
       }
        TeamPanels[team] = panel;
        SortPanelChildren(rootPanel, dynamicSort('team'), function(child, child2) {
            return child.team < child2.team;
        });
    }
    return TeamPanels[team];
}

function Snippet_DotaTeamBar_Update(panel) {
    var team = panel.team;
    panel.SetHasClass("EnemyTeam", team != Players.GetTeam(Game.GetLocalPlayerID()));
    var teamDetails = Game.GetTeamDetails(team);
    panel.SetDialogVariableInt("team_score", teamDetails.team_score);
}

function Update() {
    $.Schedule(0.2, Update);
    var rawTime = Game.GetDOTATime(false, true);
    var time = Math.abs(rawTime);
    var isNSNight = rawTime < darknessEndTime;
    var timeThisDayLasts = time - (Math.floor(time / 600) * 600);
    var isDayTime = !isNSNight && timeThisDayLasts <= 300;
    var context = $.GetContextPanel();
    context.SetHasClass('DayTime', isDayTime);
    context.SetHasClass('NightTime', !isDayTime);
    context.SetDialogVariable('time_of_day', secondsToMS(time, true));
    context.SetDialogVariable('time_until', secondsToMS((isDayTime ? 300 : 600) - timeThisDayLasts, true));
    context.SetDialogVariable('day_phase', $.Localize(isDayTime ? 'DOTA_HUD_Night' : 'DOTA_HUD_Day'));

    $("#DayTime").visible = isDayTime;
    $("#NightTime").visible = !isNSNight && !isDayTime;
    $("#NightstalkerNight").visible = isNSNight;
    $.Each(Game.GetAllPlayerIDs(), function(pid) {
        Snippet_TopBarPlayerSlot_Update(Snippet_TopBarPlayerSlot(pid));
    })

    Object.values(TeamPanels).forEach(Snippet_DotaTeamBar_Update);

    context.SetHasClass("AltPressed", GameUI.IsAltDown())
}

function TimerClick() {
    if (GameUI.IsAltDown()) {
        var playerId = Players.GetLocalPlayer()
        GameEvents.SendCustomGameEventToServer("OnTimerClick", { name: "test", id: playerId });
    }
}

(function() {
    FindDotaHudElement("topbar").visible = true;
    GameEvents.Subscribe("time_nightstalker_darkness", (function(data) {
        darknessEndTime = Game.GetDOTATime(false, false) + data.duration
    }))
    $("#TopBarLeftPlayers").RemoveAndDeleteChildren();
    $("#TopBarRightPlayers").RemoveAndDeleteChildren();
    Snippet_DotaTeamBar(DOTATeam_t.DOTA_TEAM_GOODGUYS);
    Snippet_DotaTeamBar(DOTATeam_t.DOTA_TEAM_BADGUYS);
    if (map) {
    Snippet_DotaTeamBar(DOTATeam_t.DOTA_TEAM_CUSTOM_1);
    }
    Update();
})()

var CombatLogButton = FindDotaHudElement("CombatLogButton");
var buttonBar = FindDotaHudElement("ButtonBar");
var beforebutton = FindDotaHudElement("ToggleScoreboardButton");
CombatLogButton.SetParent(buttonBar);
CombatLogButton.MoveChildAfter(buttonBar, beforebutton);