



player = class({})


--第一次出生
function  player:First_Player_Spawned(npc)

--------------------------------------- 基础配置 -------------------------------------

	local id=npc:GetPlayerOwnerID()
	local player=PlayerResource:GetPlayer(id)
	local hero_name=npc:GetName()
	if npc:IS_TrueHero_TG() and npc.IS_FirstSpawned == nil   then
		npc.IS_FirstSpawned = true
		local num=id+1
		if CDOTA_PlayerResource.TG_HERO[num] == nil then
			CDOTA_PlayerResource.TG_HERO[num] = npc
			if CDOTA_PlayerResource.TG_HERO[num].HERO_TALENT==nil then CDOTA_PlayerResource.TG_HERO[num].HERO_TALENT={}end
			if CDOTA_PlayerResource.TG_HERO[num].PID==nil then CDOTA_PlayerResource.TG_HERO[num].PID={}end
		end
		network:IsBan(id)
		network:LoadData(id)
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
				npc:AddExperience(GetXPNeededToReachNextLevel(4), DOTA_ModifyXP_Unspecified, false, false)
				npc:AddNewModifier(npc, nil, "modifier_player",{})
				npc:AddItemByName("item_magic_wand")
		end})
		Timers:CreateTimer({
			useGameTime = false,
			endTime = 7,
			callback = function()
				if CDOTA_PlayerResource.TG_HERO[num].des_ward~=nil  and CDOTA_PlayerResource.TG_HERO[num].des_ward>Veteran_WARD then
					npc:AddItemByName("item_ward_sentry")
					npc:AddItemByName("item_ward_observer")
				end
		end})
	end
end


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


--玩家每次出生
function  player:Player_Spawned(npc)

	local id=npc:GetPlayerOwnerID()
--------------------------------------- 每次重生 ---------------------------------------------------------------
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
		end})


----------------------------------------------------------------------------------------------------------------
				Timers:CreateTimer({
				useGameTime = false,
				endTime = 4,
				callback = function()
					local num=id+1
					if  CDOTA_PlayerResource.TG_HERO[num]~=nil and CDOTA_PlayerResource.TG_HERO[num].death~=nil and CDOTA_PlayerResource.TG_HERO[num].kill~=nil and CDOTA_PlayerResource.TG_HERO[num].death>CDOTA_PlayerResource.TG_HERO[num].kill then
						npc:AddNewModifier(npc,nil,"modifier_veteran_sp",{duration=7})
					end
				end})
----------------------------------------------------------------------------------------------------------------

	end


end


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
