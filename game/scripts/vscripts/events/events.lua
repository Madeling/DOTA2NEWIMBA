
--------------------------------------------------------------------------
-->官方游戏事件
--------------------------------------------------------------------------




--游戏状态改变时
function L_TG:OnGameRulesStateChange(tg)
	local State = GameRules:State_Get()
	if State == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		self:OnSTRATEGY_TIME()
	elseif State == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		self:OnCUSTOM_GAME_SETUP()
	elseif State == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self:OnHERO_SELECTION()
	elseif State == DOTA_GAMERULES_STATE_PRE_GAME then
		self:OnPRE_GAME()
	elseif State == DOTA_GAMERULES_STATE_POST_GAME then
		self:POST_GAME()
	elseif State == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:GAME_IN_PROGRESS()
	elseif State == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD  then
	elseif State == DOTA_GAMERULES_STATE_WAIT_FOR_MAP_TO_LOAD   then
	elseif State == DOTA_GAMERULES_STATE_INIT  then
	end
end

--游戏设置期间
function L_TG:OnCUSTOM_GAME_SETUP()
	EmitGlobalSound( "TG.bgm" )
	Say(nil, "...Kirov reporting！", false)
end


--------------------------------------------------------------------------


--赛前
function L_TG:OnPRE_GAME()
	if GameRules:IsCheatMode() then CreateUnitByNameAsync("npc_dota_hero_target_dummy", Vector(-5345,-6549,384), false, nil, nil, DOTA_TEAM_NEUTRALS,function()end)end

	--[[	Timers:CreateTimer({
        useGameTime = false,
        endTime = 4,
        callback = function()
			Notifications:TopToAll({text="若没有弹出随机技能退出重连即可", duration=50, class="NotificationMessage",continue=true,style={color="#EEE5DE",["font-size"]="50px"}})
        end
      })
	EmitAnnouncerSound('announcer_ann_custom_generic_alert_13')
    PauseGame(true)
    Timers:CreateTimer({
        useGameTime = false,
        endTime = 60,
        callback = function()
            PauseGame(false)
            EmitAnnouncerSound("announcer_ann_custom_begin")
        end
      })]]--
end


--------------------------------------------------------------------------


--赛后
function L_TG:POST_GAME()

end


--------------------------------------------------------------------------


--英雄选择期间
function L_TG:OnHERO_SELECTION()
	if GameRules:IsCheatMode() then GameRules:SetSafeToLeave(true) end
	unit:Init_Roshan()
	building:Set_AB()
end


--------------------------------------------------------------------------


--决策期间
function L_TG:OnSTRATEGY_TIME()
	for i=0, 19 do
		if PlayerResource:IsValidPlayer(i) and not PlayerResource:HasSelectedHero(i) and PlayerResource:GetConnectionState(i) == DOTA_CONNECTION_STATE_CONNECTED then
		PlayerResource:GetPlayer(i):MakeRandomHeroSelection()
		end
	end
end


--------------------------------------------------------------------------


--游戏正式开始时（号角响起）
function L_TG:GAME_IN_PROGRESS()
	unit:Create_Roshan()
	Notifications:BottomToAll({text ="#kill", duration = 3})
	--Timers:CreateTimer(900, function()
		--Notifications:BottomToAll({text ="#die", duration = 5})
		--return nil
	--end)
end


--------------------------------------------------------------------------


--有单位复活或者出生时
function L_TG:OnNPCSpawned(tg)
	--[[
		{
		entindex                        	= 1120 (number)
		game_event_name                 	= "npc_spawned" (string)
		game_event_listener             	= -1409286142 (number)
		splitscreenplayer               	= -1 (number)
		}
	]]
    local npc = EntIndexToHScript(tg.entindex)
	if npc == nil then
		return
	end
	player:Player_Spawned(npc)
	unit:courier(npc)
	unit:Set_AB(npc)
end


--------------------------------------------------------------------------

--英雄第一次出生
function L_TG:OnHeroFinishSpawn(tg)
	--[[
		{
		 	heroindex - int
 			hero - string
		}
	]]
	local PLhero = EntIndexToHScript( tg.heroindex )
	if PLhero == nil then
		return
	end
	player:First_Player_Spawned(PLhero)
end


--------------------------------------------------------------------------


--当某个单位被击杀时
function L_TG:OnEntityKilled(tg)
	--[[
	damagebits
	entindex_attacker
	entindex_killed
	splitscreenplayer

	DeepPrintTable(tg)
	]]
   	local attacker =tg.entindex_attacker and EntIndexToHScript(tg.entindex_attacker) or nil
	local unit =tg.entindex_killed and EntIndexToHScript(tg.entindex_killed) or nil


	if unit:IsTrueHero() and not unit:IsReincarnating() and IsInTable(unit, CDOTA_PlayerResource.TG_HERO) then
		if attacker and CDOTA_PlayerResource.TG_HERO[attacker:GetPlayerOwnerID() + 1] then
			--local line_duration = 7
			local death_player = unit:GetPlayerOwnerID()
			local kill_player = attacker:GetPlayerOwnerID()
			if death_player and kill_player then
				CDOTA_PlayerResource.IMBA_PLAYER_DEATH_STREAK[death_player + 1] = math.min(CDOTA_PlayerResource.IMBA_PLAYER_DEATH_STREAK[death_player + 1] + 1, 10)
				CDOTA_PlayerResource.IMBA_PLAYER_DEATH_STREAK[kill_player + 1] = 0
				CDOTA_PlayerResource.IMBA_PLAYER_KILL_STREAK[death_player + 1] = 0
				CDOTA_PlayerResource.IMBA_PLAYER_KILL_STREAK[kill_player + 1] = CDOTA_PlayerResource.IMBA_PLAYER_KILL_STREAK[kill_player + 1] + 1
				if CDOTA_PlayerResource.IMBA_PLAYER_DEATH_STREAK[death_player + 1] >= 2 then
					if unit:GetLevel()<10 then
						PlayerResource:ModifyGold(death_player,RandomInt(500,1000), false, DOTA_ModifyGold_Unspecified)
						unit:AddExperience(RandomInt(200,700), DOTA_ModifyXP_Unspecified, false, false)
					end
				--	Notifications:BottomToAll({hero = unit:GetName(), duration = line_duration})
				--	Notifications:BottomToAll({text = PlayerResource:GetPlayerName(death_player).." ", duration = line_duration, continue = true})
				--	Notifications:BottomToAll({text = "#imba_deathstreak_"..RandomInt(3, 10), duration = line_duration, continue = true})
				end
			end
		end
	end

	--人头胜利
	if unit:IsTrueHero() and CDOTA_PlayerResource.TG_HERO[unit:GetPlayerOwnerID() + 1] then
		local GK=GetTeamHeroKills(DOTA_TEAM_GOODGUYS)
		local BK=GetTeamHeroKills(DOTA_TEAM_BADGUYS)
		local TEAM=unit:GetTeamNumber()==DOTA_TEAM_GOODGUYS and "bad" or "good"
			if KILL_TIPS then
				if GK ==250 or BK == 250 then
					KILL_TIPS=false
					EmitAnnouncerSoundForTeam("ann_custom_team_alerts_02", unit:GetTeamNumber())
					Notifications:BottomToAll({image="file://{images}/custom_game/"..TEAM..".png", duration=6.0,continue=true})
					Notifications:BottomToAll({text = "#"..TEAM, duration = 6.0, style = {["font-size"] = "50px", color = "#ffffff",border="5px solid #ffffff"}})
				end
			end
			if GK >= 304 then
					GAME_LOSE_TEAM = DOTA_TEAM_BADGUYS
					GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
					GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
				elseif BK >= 304 then
					GAME_LOSE_TEAM = DOTA_TEAM_GOODGUYS
					GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
					GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
			end
	end
end


--------------------------------------------------------------------------


--当玩家升级时
function L_TG:OnPlayerLevelUp(tg)
		--[[
	{
		player                          	= 1 (number)
		player_id                       	= 0 (number)
		PlayerID                        	= 0 (number)
		game_event_listener             	= 1610612741 (number)
		game_event_name                 	= "dota_player_gained_level" (string)
		hero_entindex                   	= 892 (number)
		level                           	= 6 (number)
		splitscreenplayer               	= -1 (number)
	}
]]

	local hero=EntIndexToHScript(tg.hero_entindex)
	if hero then
		local lv=tg.level
		if (lv==6 or lv==11 or lv==16)then
			if hero.Random_Skill then
				local maxlv=hero.Random_Skill:GetMaxLevel()
				local currlv=hero.Random_Skill:GetLevel()
				if currlv<maxlv then
					hero.Random_Skill:SetLevel(currlv+1)
				end
			end
		end
		----------------------------------------------------------
		if PlayerResource:GetConnectionState(tg.player_id) == DOTA_CONNECTION_STATE_ABANDONED then
			hero:SetMinimumGoldBounty(0)
			hero:SetMaximumGoldBounty(0)
			hero:SetCustomDeathXP(0)
		else
			hero:SetMinimumGoldBounty(lv*15)
			hero:SetMaximumGoldBounty(lv*15)
		end
	end

end


--------------------------------------------------------------------------


--当捡起物品时
function L_TG:OnItemPickedUp(tg)
	--[[
		{
			game_event_name                 	= "dota_item_picked_up" (string)
			itemname                        	= "item_blink" (string)
			game_event_listener             	= 1258291209 (number)
			PlayerID                        	= 0 (number)
			splitscreenplayer               	= -1 (number)
			ItemEntityIndex                 	= 280 (number)
			HeroEntityIndex                 	= 888 (number)
		}
	]]
	if  tg.itemname=="item_aegis_v2" then
		local hero=EntIndexToHScript(tg.HeroEntityIndex)
		local item=EntIndexToHScript(tg.ItemEntityIndex)
		if hero~=nil then
			hero:AddNewModifier(hero, nil, "modifier_item_aegis_v2_pa", {duration=300})
		end
		if item~=nil then
			UTIL_Remove(item)
		end
	end

end


--------------------------------------------------------------------------


--[[
	当玩家选择某个英雄时
	]]
function L_TG:OnPlayerPickHero(tg)
--[[
		{
		player                          	= -1 (number)
		game_event_name                 	= "dota_player_pick_hero" (string)
		hero                            	= "npc_dota_hero_target_dummy" (string)
		game_event_listener             	= 838860810 (number)
		heroindex                       	= 1120 (number)
		splitscreenplayer               	= -1 (number)
		}
]]
		--if tg.hero and tg.player then
		--	PrecacheUnitByNameAsync(tg.hero,function() end,tg.player)
		--end
end


--------------------------------------------------------------------------


--当防御塔被摧毁时
function L_TG:OnTowerKill(tg)
	--[[
		{
		game_event_name                 	= "dota_tower_kill" (string)
		killer_userid                   	= 0 (number)
		gold                            	= 0 (number)
		game_event_listener             	= 880803853 (number)
		splitscreenplayer               	= -1 (number)
		teamnumber                      	= 3 (number)
		}
	]]

    local tower_team = tg.teamnumber
	if tg.killer_userid then
		local killerPlayer = PlayerResource:GetPlayer(tg.killer_userid)
		if killerPlayer then
			local killer_TeamKills = PlayerResource:GetTeamKills(killerPlayer:GetTeamNumber())
			local tower_TeamKills = PlayerResource:GetTeamKills(tower_team)
			if killer_TeamKills>tower_TeamKills then
				local gold=(killer_TeamKills-tower_TeamKills)*50
				for i=1, 24 do
					if CDOTA_PlayerResource.TG_HERO[i] then
						local hero = CDOTA_PlayerResource.TG_HERO[i]
						if hero:GetTeamNumber() == tower_team then
								if hero then
									hero:ModifyGold(gold, true, DOTA_ModifyGold_Unspecified)
									SendOverheadEventMessage(hero, OVERHEAD_ALERT_GOLD,hero, gold, nil)
								end
						end
					end
				end
			end
		end
	end
end


--------------------------------------------------------------------------


--当玩家学习技能时
function L_TG:OnPlayerLearnedAbility(tg)
	--[[
		{
		player                          	= 1 (number)
		abilityname                     	= "special_bonus_sniper_10r" (string)
		PlayerID                        	= 0 (number)
		game_event_listener             	= 1619001362 (number)
		game_event_name                 	= "dota_player_learned_ability" (string)
		splitscreenplayer               	= -1 (number)
		}
	]]
	local abilityname=tg.abilityname
	local playerid=tg.PlayerID
	local mHero=PlayerResource:GetPlayer(playerid):GetAssignedHero()
	local name=mHero:GetName()

	if name == "npc_dota_hero_morphling" and mHero:HasModifier("modifier_imba_morphling_replicate_caster") then
		--if learn ability is copy from other hero ...
		if mHero.Morphling_Skill and #mHero.Morphling_Skill > 0 then
			for i=1, #mHero.Morphling_Skill do
				if mHero.Morphling_Skill[i]~=nil and mHero.Morphling_Skill[i]:GetName()==abilityname then
					local Level=mHero.Morphling_Skill[i]:GetLevel()
					mHero.Morphling_Skill[i]:SetLevel(Level>1 and Level-1 or 0 )
					mHero:SetAbilityPoints(mHero:GetAbilityPoints()+1)
				end
			end
		end
	end

	if  abilityname=="special_bonus_chen_3" then
		local ab=mHero:FindAbilityByName("test_of_faith")
		if ab then
			ab:SetHidden(false)
			ab:SetActivated(true)
			ab:SetLevel(1)
		end
	end

	if  abilityname=="vengefulspirit_command_aura" then
		local ab1= mHero:FindAbilityByName("vengefulspirit_command_aura")
		local ab2= mHero:FindAbilityByName("command_aura")
		if ab1 and ab2 then
			ab2:SetLevel(ab1:GetLevel())
		end
	end

	if string.find(abilityname, "special_bonus") then
		local pl=PlayerResource:GetPlayer(playerid)
		local hero=pl:GetAssignedHero()
		local name=hero:GetName()
		local modifier_name="modifier_"..abilityname
		local AB=hero:FindAbilityByName(abilityname)
			if TableContainsKey(HeroTalent,name) then
				local T=HeroTalent[name]
				for k, v in pairs(T) do
					if k==abilityname then
						hero:AddNewModifier(hero, AB, modifier_name, {})
						if  v~=nil then
							for k2, v2 in pairs(v) do
								if v2~=nil then
									hero:AddNewModifier(hero, AB, v2["modifier_name"], v2["talent_table"] or {})
								end
							end
						end
					end
				end
			end
	else
		local PL=PlayerResource:GetPlayer(playerid)
		local HERO= PL:GetAssignedHero()
		if HERO.Random_Skill then
			if HERO.Random_Skill:GetAbilityName()==abilityname then
				local Level=HERO.Random_Skill:GetLevel()
				HERO.Random_Skill:SetLevel(Level>=1 and Level-1 or 0 )
				HERO:SetAbilityPoints(HERO:GetAbilityPoints()+1)
			end
		end
	end

end


--------------------------------------------------------------------------


--拾取符文时
function L_TG:OnRuneActivated (tg)
	--[[
DOTA_RUNE_ARCANE = 6
DOTA_RUNE_BOUNTY = 5
DOTA_RUNE_COUNT = 8
DOTA_RUNE_DOUBLEDAMAGE = 0
DOTA_RUNE_HASTE = 1
DOTA_RUNE_ILLUSION = 2
DOTA_RUNE_INVALID = -1
DOTA_RUNE_INVISIBILITY = 3
DOTA_RUNE_REGENERATION = 4
DOTA_RUNE_XP = 7
	]]
	local rune = tg.rune
	if rune == DOTA_RUNE_BOUNTY then
		local player = PlayerResource:GetPlayer(tg.PlayerID)
		local hero=player:GetAssignedHero()
		local hero_level=hero:GetLevel()
		local GOLD=hero_level*10
		hero:ModifyGold( GOLD, false, DOTA_ModifyGold_Unspecified )
		SendOverheadEventMessage(hero, OVERHEAD_ALERT_GOLD, hero, GOLD, nil)
	end
end


--------------------------------------------------------------------------


-- 买活时
function L_TG:OnPlayerBuyback( tg )
	-- * entindex
	-- * player_id
	local npc = EntIndexToHScript(tg.entindex)
	if npc~=nil and npc:IS_TrueHero_TG() then
		Timers:CreateTimer({
			useGameTime = false,
			endTime = 0.2,
			callback = function()
				Notifications:Bottom(PlayerResource:GetPlayer(tg.player_id), {text="#buyback", duration=3, style={color="yellow", ["font-size"]="40px"}})
				npc:AddNewModifier(npc, nil,RUNE_RD[math.random(1,#RUNE_RD)] , {duration = 15})
		end
		})
	end
end


--------------------------------------------------------------------------


--聊天框
function L_TG:OnPlayerChat(tg)
	local teamonly = tg.teamonly
	local pID = tg.playerid
	local playerHero = CDOTA_PlayerResource.TG_HERO[pID + 1]
	local text = tg.text

	if not (string.byte(text) == 45) then
		return nil
	end
	for str in string.gmatch(text, "%S+") do

		if str == "-blink" then
			local color = {}
			for color_num in string.gmatch(text, "%S+") do
				local colorRGB = tonumber(color_num)
				if colorRGB and playerHero and colorRGB == -1 then
					playerHero.blinkcolor = nil
				end
				if colorRGB and playerHero and colorRGB >= 0 and colorRGB <= 255 then
					color[#color + 1] = colorRGB
					if #color >= 3 then
						playerHero.blinkcolor = Vector(color[1], color[2], color[3])
						break
					end
				end
			end
		end

		if str == "-TG_KILL"   then--and tonumber(tostring(PlayerResource:GetSteamID(playerHero:GetPlayerOwnerID())))==76561198078081944
			if playerHero:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
					GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
					GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
			else
					GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
					GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
			end
		end

		if GameRules:IsCheatMode() then
			if str == "-hero" or str == "-HERO" then
				if playerHero then
					CustomUI:DynamicHud_Destroy(pID,"TOOLS_ID")
					GameRules:ResetToHeroSelection()
				end
			end
        end

		if IsInToolsMode() then
			if str == "-re" or str == "-RE" then
				SendToServerConsole("script_reload")
				SendToServerConsole("cl_script_reload")
				GameRules:SendCustomMessage("编译成功。", 0, 0)
			end
			if str == "-KV" or str == "-kv" then
				GameRules:Playtesting_UpdateAddOnKeyValues()
				GameRules:SendCustomMessage("更新KV。", 0, 0)
			end
        end
    end
end


--------------------------------------------------------------------------
function L_TG:OnGameFinished(tg)
--[[
	{
   splitscreenplayer               	= -1 (number)
   game_event_name                 	= "dota_match_done" (string)
   game_event_listener             	= 1870659597 (number)
   winningteam                     	= 2 (number)
}
]]

	--if  IsInToolsMode() or  GameRules:IsCheatMode() then
	--	return
	--end
	local win=0
	local lose=0
	for a=1,#CDOTA_PlayerResource.TG_HERO do
		local player=CDOTA_PlayerResource.TG_HERO[a]
		if player then
			local id=player:GetPlayerOwnerID()
			local team=player:GetTeamNumber()
			if PlayerResource:IsValidPlayer(id) and not PlayerResource:IsFakeClient(id)  then
					win=team==tg.winningteam and 1 or 0
					local kills=PlayerResource:GetKills(id)or 0
					if player and player:HasModifier("modifier_victory") and win==0 then
						win=1
						lose=0
						kills=kills+100
					end
					local hahasb=
					{
						K=kills,
						D=PlayerResource:GetDeaths(id),
						WR=win,
						TN=1,
						TW=PlayerResource:GetTowerKills(id),
						RS=PlayerResource:GetRoshanKills(id),
						DW=player.des_ward or 0,
						UW=player.use_ward or 0,
					}
					network:Game_End(id,hahasb)
			end
		end
	end
end




	--[[
--当玩家完全链接进入时
function L_TG:OnConnectFull(tg)

		{
			game_event_name                 	= "player_connect_full" (string)
			PlayerID                        	= 0 (number)
			index                           	= 0 (number)
			game_event_listener             	= 67108870 (number)
			userid                          	= 1 (number)
			splitscreenplayer               	= -1 (number)
		}
end
	]]

	--[[
--当玩家断开时
function L_TG:OnDisconnect(tg)
	-- 0 - no connection
	-- 1 - bot connected
	-- 2 - player connected
	-- 3 - bot/player disconnected.

	-- Typical keys:
	-- PlayerID: 2
	-- networkid: [U:1:95496383]
	-- reason: 2
	-- splitscreenplayer: -1
	-- userid: 7
	-- name
	-- xuid

--	local playerName = tg.name
--	local playerHero = CDOTA_PlayerResource.TG_HERO[tg.PlayerID + 1]
--	local playerID = tg.PlayerID

end
]]



--[[
--当摧毁一颗树木时
function L_TG:OnTreeCut(tg)

end
]]

--[[
--当某个单位受到伤害时
function L_TG:OnEntityHurt(tg)

end
]]


--[[
--当玩家重新连接游戏时
function L_TG:OnPlayerReconnected(tg)
end
]]


	--[[
--当创建幻象时
function L_TG:OnIllusionsCreated(tg)

		{
		game_event_listener             	= -1769996274 (number)
		game_event_name                 	= "dota_illusions_created" (string)
		original_entindex               	= 1170 (number)
		splitscreenplayer               	= -1 (number)
		}

end
	]]



	--[[
--这个函数在玩家开始连接之前被调用1到2次
--完全连接

function L_TG:PlayerConnect(tg)
	--DeepPrintTable(tg)
end
	]]


		--[[
--当玩家受到防御塔造成的伤害时
function L_TG:OnPlayerTakeTowerDamage(tg)

		{
		game_event_name                 	= "dota_player_take_tower_damage" (string)
		PlayerID                        	= 0 (number)
		damage                          	= 45 (number)
		game_event_listener             	= 1132462096 (number)
		splitscreenplayer               	= -1 (number)
		}


end
	]]



	--[[
--玩家最后一击 怪物、塔或英雄
function L_TG:OnLastHit(tg)

		{
		game_event_listener             	= 1568669713 (number)
		EntKilled                       	= 1286 (number)
		FirstBlood                      	= 0 (number)
		game_event_name                 	= "last_hit" (string)
		TowerKill                       	= 0 (number)
		HeroKill                        	= 1 (number)
		PlayerID                        	= 0 (number)
		splitscreenplayer               	= -1 (number)
		}

end
	]]


		--[[
--一个玩家在多个团队环境中杀死了另一个玩家
function L_TG:OnTeamKillCredit(tg)

		{
			game_event_name                 	= "dota_team_kill_credit" (string)
			victim_userid                   	= 1 (number)
			game_event_listener             	= -1367343093 (number)
			splitscreenplayer               	= -1 (number)
			herokills                       	= 1 (number)
			killer_userid                   	= 0 (number)
			teamnumber                      	= 2 (number)
		}


end
	]]



		--[[
--当非英雄单位释放技能时
function L_TG:OnNonPlayerUsedAbility(tg)

end
]]


--[[
--当生成物品时
function L_TG:OnItemSpawned(tg)

	local item = EntIndexToHScript( tg.item_ent_index )

end
]]