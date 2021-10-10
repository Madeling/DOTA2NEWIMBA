function ban(table) {
    var player = Players.GetLocalPlayer()
    var ban_panel = $.GetContextPanel().FindChildTraverse("BAN_ID");
    if (Players.IsValidPlayerID(player)) {
        Game.Disconnect()
    }
}

GameEvents.Subscribe("ban", ban);