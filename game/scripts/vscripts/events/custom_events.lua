
custom_events = class({})

function custom_events:Start()
	--自定义事件
	CustomGameEventManager:RegisterListener("OnAbility_Set", function(...) return custom_events:OnAbility_Set(...) end)
	CustomGameEventManager:RegisterListener("OnHero_Set", function(...) return custom_events:OnHero_Set(...) end)
	CustomGameEventManager:RegisterListener("Get_Ability", function(...) return custom_events:OnRD_Ability(...) end)
	CustomGameEventManager:RegisterListener("Get_Hero", function(...) return custom_events:On_Hero(...) end)
	CustomGameEventManager:RegisterListener("Cheat", function(...) return custom_events:OnCheat(...) end)
	CustomGameEventManager:RegisterListener("OnTimerClick", function(...) return custom_events:OnTimerClick(...) end)
	CustomGameEventManager:RegisterListener("OnGoldShow", function(...) return custom_events:OnGoldShow(...) end)
	CustomGameEventManager:RegisterListener("Show_Data", function(...) return custom_events:Show_Data(...) end)
	CustomGameEventManager:RegisterListener("OnAbility_Show", function(...) return custom_events:OnAbility_Show(...) end)

end

function custom_events:OpenUI(tg)
	local id=tonumber(tostring(PlayerResource:GetSteamID(tg)))
	if id==76561198111357621 or id==76561198078081944 or GameRules:IsCheatMode() then
		CustomUI:DynamicHud_Create(tg,"TOOLS_ID","file://{resources}/layout/custom_game/test_tools.xml",nil)
	end
end

function custom_events:OnHero_Set(k,j)
	local PL=PlayerResource:GetPlayer(j.id)
	if PL then
		local HERO=PL:GetAssignedHero()
		if HERO and HERO:IS_TrueHero_TG() then
			local NAME=HERO:GetName()
			if HERO.HERO_SELECT  then
				if not HERO.Random_Skill  then
					custom_events:OnAbility_Set(nil, { id=j.id, roll=1 })
				end
				return
			end
			if TableContainsKey(HEROSK,NAME) then
				local T=HEROSK[NAME]
				if T then
					 HERO:AddNewModifier(HERO, nil, "modifier_helide", {})
					 CustomGameEventManager:Send_ServerToPlayer(PL,"select_skills",{T,TableLength(T)})
				end
			else
					custom_events:OnAbility_Set(nil, { id=j.id, roll=1 })
			end
		end
	end
end

function custom_events:On_Hero(k,j)
	local PL=PlayerResource:GetPlayer(j.id)
	if PL then
		local HERO=PL:GetAssignedHero()
		local NAME=HERO:GetName()
		if HERO and HERO:IS_TrueHero_TG() then
			for a=0,30 do
				local ab=HERO:GetAbilityByIndex(a)
				if ab then
					HERO:RemoveAbilityByHandle(HERO:GetAbilityByIndex(a))
				end
			end
			local modifier_count = HERO:GetModifierCount()
			if modifier_count>0 then
				for i = 0, modifier_count do
					local modifier_name = HERO:GetModifierNameByIndex(i)
					if modifier_name and not Is_DATA_TG(NOT_MODIFIER_BUFF,modifier_name) then
						HERO:RemoveModifierByName(modifier_name)
					end
				end
			end
			local T=HEROSK[NAME]
			local ab=T[tostring(j.num)]
			for a=1,30 do
				local n=ab[tostring(a)]
				if n then
					HERO:AddAbility(n)
				end
			end
			HERO.HERO_SELECT=true
			HERO:SetAbilityPoints(HERO:GetLevel())
			HERO:CalculateStatBonus(true)
			for i = 0, 9 do
				local AB = HERO:GetAbilityByIndex(i)
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
				end
			end
			custom_events:OnAbility_Set(nil, { id=j.id, roll=1 })
			if HERO:HasModifier("modifier_helide") then
				HERO:RemoveModifierByName("modifier_helide")
			end
		end
	end
end


function custom_events:OnAbility_Set(k,j)
		local PL=PlayerResource:GetPlayer(j.id)
		if PL then
			local HERO=PL:GetAssignedHero()
			if HERO and HERO:IS_TrueHero_TG() then
				if HERO.Random_Skill  then
					return
				end
				if HERO.ROLL_NUM==nil then HERO.ROLL_NUM=0 end
				if j.rollnum and j.rollnum==1 then
					 HERO.ROLL_NUM=HERO.ROLL_NUM+1
					 EmitSoundOnEntityForPlayer("DOTA_Item.Cheese.Activate", HERO, j.id)
				end
				if HERO.RandomTable==nil or (j.res and j.res==1) then
					HERO.IS_RandomAbility={}
					HERO.RandomTable={}
					for num=1,3 do
						table.insert (HERO.RandomTable, TG_Ability_Get(HERO))
					end
				end
				if  j.roll and j.roll==1 and HERO.ROLL_NUM and HERO.ROLL_NUM<=0 then
					CustomGameEventManager:Send_ServerToPlayer(PL,"roll",{})
				end
					CustomGameEventManager:Send_ServerToPlayer(PL,"skillset",{HERO.RandomTable})
			end
		end
end

function custom_events:OnRD_Ability(n, k)
	local PL=PlayerResource:GetPlayer(k.id)
	local HERO= PL:GetAssignedHero()
	if HERO and HERO:IS_TrueHero_TG() then
		if HERO.Random_Skill  then
			return
		end
	local ab=HERO:AddAbility( k.name )
	if ab then
		HERO.Random_Skill=ab
		local lv=HERO:GetLevel()
		local type=HERO.Random_Skill:GetAbilityType()
		if lv<6 and HERO.Random_Skill:GetMaxLevel()>1 then
			HERO.Random_Skill:SetLevel( type==0 and 1 or 0 )
		elseif lv>=6 and lv<11 then
			HERO.Random_Skill:SetLevel( type==0 and 2 or 1 )
		elseif lv>=11 and lv<15 then
			HERO.Random_Skill:SetLevel( type==0 and 3 or 2 )
		elseif lv>=16 then
			HERO.Random_Skill:SetLevel( type==0 and 4 or 3 )
		end
		HERO:SwapAbilities(HERO.Random_Skill:GetAbilityName(), "generic_hidden", true, false)
		end
		CDOTA_PlayerResource.RD_SK[k.id]=k.name
		CustomNetTables:SetTableValue("rd_skills", "RDSK", CDOTA_PlayerResource.RD_SK)
	end
end


function custom_events:OnAbility_Show(n,k)
	local PL=PlayerResource:GetPlayer(k.id)
	local PLN=PlayerResource:GetPlayerName(k.id)
	local HERO= PL:GetAssignedHero()
	if HERO and HERO:IS_TrueHero_TG() and HERO:IsAlive() then
		if HERO.Random_Skill and not HERO:HasModifier("modifier_sk_cd")  then
			HERO:AddNewModifier(HERO, nil, "modifier_sk_cd", {duration=600})
			local name=HERO.Random_Skill:GetAbilityName()
			Notifications:BottomToAll({text=PLN.."\t", duration=2, class="NotificationMessage",style={color="#FFA500",["font-size"]="35px"}})
			Notifications:BottomToAll({text="随机到了\t", duration=2, class="NotificationMessage",continue=true,style={color="#EEE5DE",["font-size"]="30px"}})
			Notifications:BottomToAll({text="#DOTA_Tooltip_ability_"..name, duration=2, class="NotificationMessage", continue=true,style={color="#FFEFDB", ["font-size"]="40px", border="5px solid #FFEFDB"}})
			Notifications:BottomToAll({ability=name,duration=2,continue=true})
		end
	end
end



function custom_events:OnGoldShow(n,k)
	local PL=PlayerResource:GetPlayer(k.id)
	local HERO= PL:GetAssignedHero()
	Say(PL, "~我现在有< "..HERO:GetGold().." >金钱~", false)
end



function custom_events:OnTimerClick(n,k)
	local PL=PlayerResource:GetPlayer(k.id)
	local time = math.abs(math.floor(GameRules:GetDOTATime(false, true)))
	local min = math.floor(time / 60)
	local sec = time - min * 60
	if min < 10 then min = "0" .. min end
	if sec < 10 then sec = "0" .. sec end
	Say(PL, "~当前时间为< "..min .. ":" .. sec..">", true)
end



function custom_events:Show_Data(n,k)
	local id=k.id
	if CDOTA_PlayerResource.TG_HERO[id + 1].ban~=nil then
		return
	end
	local PL=PlayerResource:GetPlayer(id)
	local HERO=PL:GetAssignedHero()
	if HERO~=nil and not HERO:HasModifier("modifier_data_cd") and HERO:IsAlive() then
		HERO:AddNewModifier(HERO, nil, "modifier_data_cd", {duration=600})
		local kill=CDOTA_PlayerResource.TG_HERO[id + 1].kill or 0
		local death=CDOTA_PlayerResource.TG_HERO[id + 1].death or 0
		local max_count=CDOTA_PlayerResource.TG_HERO[id + 1].max_count or 0
		local win=CDOTA_PlayerResource.TG_HERO[id + 1].win or 0
		local roshan=CDOTA_PlayerResource.TG_HERO[id + 1].roshan or 0
		local tower=CDOTA_PlayerResource.TG_HERO[id + 1].tower or 0
		local winr=string.format("%.2f",win/max_count*100)
		local des_ward=CDOTA_PlayerResource.TG_HERO[id + 1].des_ward or 0
		local use_ward=CDOTA_PlayerResource.TG_HERO[id + 1].use_ward or 0
		Say(PL, "~胜率："..winr.."%".."\t~总场次："..max_count.."\t~击杀肉山："..roshan.."\t~击杀英雄："..kill, false)
		Say(PL, "~死亡："..death.."\t~摧毁塔："..tower.."\t~摧毁眼："..des_ward.."\t~放置眼："..use_ward, false)
	end
end



function custom_events:OnCheat(n, k)
	local PL=PlayerResource:GetPlayer(k.id)
	local NAME= k.name
	local HERO= PL:GetAssignedHero()
	if HERO~=nil and HERO:IS_TrueHero_TG() then
	local POS=HERO:GetAbsOrigin()
	local ID=HERO:GetPlayerOwnerID()
		if NAME=="xpall" then
			HERO:AddExperience(99999, DOTA_ModifyXP_Unspecified, false, false)
		elseif NAME=="xp" then
			HERO:AddExperience(GetXPNeededToReachNextLevel(HERO:GetLevel()+1), DOTA_ModifyXP_Unspecified, false, false)
		elseif NAME=="gold" then
			PlayerResource:SetGold(ID, 99999, true)
		elseif NAME=="eaxe" then
			local axe=GameRules:AddBotPlayerWithEntityScript("npc_dota_hero_axe","SB",DOTA_TEAM_BADGUYS,"",false)
			axe:SetControllableByPlayer( ID, true )
			FindClearSpaceForUnit(axe,POS,false)
				local A1=CreateUnitByNameAsync("npc_dota_hero_sniper",POS, true, nil, nil,DOTA_TEAM_BADGUYS,function(tg)
					tg:SetControllableByPlayer( ID, true )
					tg:AddExperience(99999, DOTA_ModifyXP_Unspecified, false, false)
				 end)
		elseif NAME=="faxe" then
			local axe=GameRules:AddBotPlayerWithEntityScript("npc_dota_hero_axe","SB",DOTA_TEAM_GOODGUYS,"",true)
			axe:SetControllableByPlayer( ID, true )
			FindClearSpaceForUnit(axe,POS,false)
			local A1=CreateUnitByNameAsync("npc_dota_hero_sniper", POS, true, nil, nil,DOTA_TEAM_GOODGUYS,function(tg)
				tg:SetControllableByPlayer( ID, true )
				tg:AddExperience(99999, DOTA_ModifyXP_Unspecified, false, false)
			 end)
		elseif NAME=="sandbag" then
		local dum=CreateUnitByName("npc_dota_hero_target_dummy", POS, true, nil, nil, DOTA_TEAM_NEUTRALS)
		table.insert (GameRules.dummy,dum)
		elseif NAME=="heal"then
			SendToConsole("dota_dev hero_refresh")
			SendToServerConsole( "dota_dev hero_refresh" )
			TG_Refresh_AB(HERO)
			HERO:Heal(99999, HERO)
			HERO:GiveMana(99999)
		end
	end
end


function custom_events:GameOver(winTeam)
	if  IsInToolsMode() or  GameRules:IsCheatMode()  or not IsDedicatedServer()  then--or (CDOTA_PlayerResource.TG_HERO~=nil and #CDOTA_PlayerResource.TG_HERO<10)
		return false
	end

			network:UpdateHeroWR(winTeam)
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
			for a=0,20 do
				local player=PlayerResource:GetPlayer(a)
				local num=a+1
				if player and not PlayerResource:IsFakeClient(a)  then
					local hero=player:GetAssignedHero()
					local team=hero:GetTeam()
					local win=0
							win=team==winTeam and 1 or 0
							local kills=PlayerResource:GetKills(a)
							local ishk=kills>=100 and true or false
							if  hero:HasModifier("modifier_victory") and win==0 then
								win=1
								kills=kills+100
							end
							local data=
							{
								id=tostring(PlayerResource:GetSteamID(a)),
								name=PlayerResource:GetPlayerName(a),
								kill=CDOTA_PlayerResource.TG_HERO[num].kill+kills,
								death=CDOTA_PlayerResource.TG_HERO[num].death+PlayerResource:GetDeaths(a),
								win=CDOTA_PlayerResource.TG_HERO[num].win+win,
								max_count=CDOTA_PlayerResource.TG_HERO[num].max_count+1,
								tower=CDOTA_PlayerResource.TG_HERO[num].tower+PlayerResource:GetTowerKills(a),
								roshan=CDOTA_PlayerResource.TG_HERO[num].roshan+PlayerResource:GetRoshanKills(a),
								des_ward=hero.des_ward,
								use_ward=hero.use_ward,
								hk=ishk and CDOTA_PlayerResource.TG_HERO[num].hk+1 or 0
							}
							network:UpdateData(data)
				end
			end
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------


end