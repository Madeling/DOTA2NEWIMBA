building = class({})

--设置建筑属性和技能
function building:Set_AB()
	local num=1
    local towers = FindUnitsInRadius(
		0,
		Vector(0,0,0),
		nil,
		25000,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_BUILDING,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
		FIND_ANY_ORDER,
		false)
	if #towers>0 then
		for _, tower in pairs(towers) do
			if string.find(tower:GetName(), "_fountain") then
				CDOTAGamerules.IMBA_FOUNTAIN[tower:GetTeamNumber()] = tower
			end
			if string.find(tower:GetName(), "_tower") then
				table.insert (CDOTAGamerules.TOWER, tower)
			end
		end
	end
	if GetMapName() =="6v6v6" then
			local dummy=CreateUnitByName("npc_dota_gold_box", Vector(0,0,0), true, nil, nil, DOTA_TEAM_NEUTRALS)
			dummy:AddNewModifier(dummy, nil, "modifier_invulnerable", {})
			dummy:AddNewModifier(dummy, nil, "modifier_no_healthbar", {})
			dummy:AddNewModifier(dummy, nil, "modifier_gold", {})
	else
			CreateModifierThinker(CDOTAGamerules.IMBA_FOUNTAIN[DOTA_TEAM_GOODGUYS], nil, "modifier_home", {}, GOOD_POS, DOTA_TEAM_GOODGUYS, false)
			CreateModifierThinker(CDOTAGamerules.IMBA_FOUNTAIN[DOTA_TEAM_BADGUYS], nil, "modifier_home", {}, BAD_POS, DOTA_TEAM_BADGUYS, false)
	end

		--[[Timers:CreateTimer(0, function()
			if num>#towers or towers[num]==nil then
				return nil
			end
			local tower= towers[num]
			local name= tower:GetUnitName()
			if string.find(name, "_tower1_") then
				tower:Set_HP(2000,true)
				tower:SetBaseMagicalResistanceValue( 10 )
				tower:SetPhysicalArmorBaseValue(20)
				tower:SetBaseDamageMax( 150 )
				tower:SetBaseDamageMin( 200 )
				TG_Tower_Up(TOWER_ABILITY_TABLE1,tower,1)

		elseif string.find(name, "_tower2_") then
				tower:Set_HP(2700,true)
				tower:SetBaseMagicalResistanceValue( 20 )
				tower:SetPhysicalArmorBaseValue(28)
				tower:SetBaseDamageMax( 200 )
				tower:SetBaseDamageMin( 250 )
				TG_Tower_Up(TOWER_ABILITY_TABLE2,tower,1)

		elseif string.find(name, "_tower3_") then
				tower:Set_HP(3000,true)
				tower:SetBaseMagicalResistanceValue( 25 )
				tower:SetPhysicalArmorBaseValue(30)
				tower:SetBaseDamageMax( 250 )
				tower:SetBaseDamageMin( 300 )
				TG_Tower_Up(TOWER_ABILITY_TABLE3,tower,1)

		elseif string.find(name, "_tower4") then
				tower:Set_HP(3200,true)
				tower:SetBaseMagicalResistanceValue( 50 )
				tower:SetPhysicalArmorBaseValue(40)
				tower:SetBaseDamageMax( 250 )
				tower:SetBaseDamageMin( 300 )
				TG_Tower_Up(TOWER_ABILITY_TABLE4,tower,1)

		elseif string.find(name, "_melee_rax_") then
				tower:Set_HP(3500,true)
				tower:SetBaseMagicalResistanceValue(20)
				tower:SetPhysicalArmorBaseValue(40)

		elseif string.find(name, "_range_rax_") then
				tower:Set_HP(3000,true)
				tower:SetBaseMagicalResistanceValue(10)
				tower:SetPhysicalArmorBaseValue(40)

		elseif string.find(name, "_fort") then
				tower:Set_HP(7000,true)
				tower:SetBaseMagicalResistanceValue(50)
				tower:SetPhysicalArmorBaseValue(50)

		elseif string.find(name, "_fountain") then
				tower:SetBaseDamageMin(10000)
				tower:SetBaseDamageMax(10000)
		end
		num=num+1
			return 1
		end)
	end ]]
end