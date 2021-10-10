unit = class({})

--设置野怪小兵
function unit:Set_AB(npc)
	local unit_name = npc:GetUnitName()
	if string.find(unit_name, "upgraded_mega") then
		npc:Set_HP(SUPER_CREEP_HP,false)
		npc:SetPhysicalArmorBaseValue(50)
		npc:SetBaseMagicalResistanceValue(50)
		npc:SetBaseDamageMax(SUPER_CREEP_ATT)
		npc:SetBaseDamageMin(SUPER_CREEP_ATT)
		npc:SetBaseMoveSpeed(npc:GetBaseMoveSpeed()+SUPER_CREEP_SP)
		if CDOTAGamerules.IS_SUPER_CREEP==false then
			CDOTAGamerules.IS_SUPER_CREEP=true
			Timers:CreateTimer(0, function()
				SUPER_CREEP_ATT=SUPER_CREEP_ATT+1
				SUPER_CREEP_HP=((SUPER_CREEP_HP+5)>=10000 and 10000 or (SUPER_CREEP_HP+5) )
				return 1
			end)
		end
	end
end


----------------------------------------------------------------------------------------------------------------------------------


--野怪技能
function unit:upgrade_NeutralUnit(npc)
	if GameRules:GetDOTATime(false, false) >= 300 then
		if npc:IsNeutralUnitType() and string.find(npc:GetUnitName(), "npc_dota_neutral_black_dragon") then
				npc:AddNewModifier( npc, nil, "modifier_black_dragon", {} )
		end
	end
end


----------------------------------------------------------------------------------------------------------------------------------


--玩家信使
function unit:courier(npc)
    if npc.IS_FirstSpawned == nil and (npc:GetName()=="npc_dota_courier" or npc:GetName()=="npc_dota_flying_courier")  then
		npc.IS_FirstSpawned = true
		CDOTA_PlayerResource.TG_COURIER[npc:GetPlayerOwnerID()+1] = npc
		Timers:CreateTimer(5, function()
			npc:SetBaseMoveSpeed( 1000 )
			npc:FindAbilityByName("courier_burst"):SetLevel( 1 )
			npc:FindAbilityByName("courier_shield"):SetLevel( 1 )
			return nil
		end)
	end
end


----------------------------------------------------------------------------------------------------------------------------------


--初始化肉山
function unit:Init_Roshan()
	local roshan=Entities:FindByClassname(nil, "npc_dota_roshan_spawner")
	if roshan then
		ROSHAN_POS = roshan:GetAbsOrigin()
		Entities:FindByClassname(nil, "npc_dota_roshan_spawner"):RemoveSelf()
	end
end

----------------------------------------------------------------------------------------------------------------------------------


--创建肉山
function unit:Create_Roshan()
		CDOTA_PlayerResource.ROSHAN=CreateUnitByName("npc_dota_roshan_tg",  ROSHAN_POS, true, nil, nil, 0)
		if not CDOTA_PlayerResource.ROSHAN:HasModifier("modifier_roshan_up") then
			CDOTA_PlayerResource.ROSHAN:AddNewModifier( CDOTA_PlayerResource.ROSHAN, nil, "modifier_roshan_up", {} )
		end
end
