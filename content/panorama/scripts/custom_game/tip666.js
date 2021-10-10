
(function () {
      if (Game.GetMapInfo().map_display_name == "6v6v6")
      {
            var panel = $.GetContextPanel()
            var TIP = panel.FindChildTraverse('TIP');
            TIP.style.visibility = "visible";
      }
})()