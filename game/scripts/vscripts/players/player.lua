



player = class({})


--第一次出生
function  player:First_Player_Spawned(npc)

--------------------------------------- 基础配置 -------------------------------------
	local id=npc:GetPlayerOwnerID()
	if npc:IS_TrueHero_TG() and npc.IS_FirstSpawned == nil and PlayerResource:IsValidPlayer(id)   then
		npc.IS_FirstSpawned = true
		local id=npc:GetPlayerOwnerID()
		local num=id+1
		if CDOTA_PlayerResource.TG_HERO[num] == nil then
			CDOTA_PlayerResource.TG_HERO[num] = npc
			if CDOTA_PlayerResource.TG_HERO[num].HERO_TALENT==nil then CDOTA_PlayerResource.TG_HERO[num].HERO_TALENT={}end
			if CDOTA_PlayerResource.TG_HERO[num].PID==nil then CDOTA_PlayerResource.TG_HERO[num].PID={}end
			CDOTA_PlayerResource.IMBA_PLAYER_DEATH_STREAK[num] = 0
			CDOTA_PlayerResource.IMBA_PLAYER_KILL_STREAK[num] = 0
		end
		custom_events:OpenUI(id)
		if GameRules:IsCheatMode() then
			GameRules:GetGameModeEntity():SetFixedRespawnTime(10)
			PlayerResource:SetCustomBuybackCost(id,1)
			PlayerResource:SetCustomBuybackCooldown(id, 1)
		end
		Timers:CreateTimer({
			useGameTime = false,
			endTime = SPAWN_TIME,
			callback = function()
			local hero_name=npc:GetName()
			if not PlayerResource:IsFakeClient(id)  then
					network:Create_Login(id)
			end
			if hero_name=="npc_dota_hero_invoker" then
				npc:AddNewModifier(npc, nil, "modifier_invoker_up",{} )
			end
			if PlayerResource:HasRandomed(id) then
				PlayerResource:ModifyGold(id,600,true,DOTA_ModifyGold_Unspecified)
			end
			local tp = npc:GetItemInSlot(DOTA_ITEM_TP_SCROLL)
			if tp then
				tp:EndCooldown()
			end
			npc:AddItemByName("item_magic_wand")
			npc:AddExperience(GetXPNeededToReachNextLevel(4), DOTA_ModifyXP_Unspecified, false, false)
			--npc:AddNewModifier(npc, nil, "modifier_gold", {})
			npc:AddNewModifier(npc, nil, "modifier_player",{})
			--[[Timers:CreateTimer({
				useGameTime = false,
				endTime = 10,
				callback = function()
				local dw=CDOTA_PlayerResource.TG_HERO[num].des_ward
				local uw=CDOTA_PlayerResource.TG_HERO[num].use_ward
				if dw and uw and (uw+dw)>=WARD then
					npc:AddItemByName("item_ward_sentry")
					npc:AddItemByName("item_ward_observer")
				end
			end})]]
		end})
	end
end


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


--玩家每次出生
function  player:Player_Spawned(npc)

--------------------------------------- 每次重生 ---------------------------------------------------------------
local id=npc:GetPlayerOwnerID()
if npc:IS_TrueHero_TG()  and PlayerResource:IsValidPlayer(id)   then
		Timers:CreateTimer({
			useGameTime = false,
			endTime = 1,
			callback = function()
				for i = 0, 24 do
					local AB = npc:GetAbilityByIndex(i)
					if AB~=nil then
						local AB_NAME = AB:GetAbilityName()
						local AB_LV = AB:GetLevel()
						if AB_LV == 0 then
							local TABLE=AB.Set_InitialUpgrade()
							if TABLE~=nil then
								AB:SetLevel(TABLE.LV or 1)
								AB:UseResources(TABLE.MANA or false,TABLE.GOLD or false,TABLE.CD or false)
							end
						end
---------------------------------------------------------------------------------------------------------------
						if string.find(AB_NAME, "special_bonus") and AB_LV>0 then
							local modifier_name="modifier_"..AB_NAME
							local name=npc:GetName()
							if TableContainsKey(HeroTalent,name) then
								local T=HeroTalent[name]
								if T~=nil then
									for k, v in pairs(T) do
										if k==AB_NAME then
												npc:AddNewModifier(npc, AB, modifier_name, {})
											if  v~=nil then
												for k2, v2 in pairs(v) do
													if v2~=nil then
															npc:AddNewModifier(npc, AB, v2["modifier_name"],v2["talent_table"] or {})
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
	end
	})
end
end


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
