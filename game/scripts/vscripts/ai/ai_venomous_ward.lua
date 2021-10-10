function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.sandking_burrowstrike = thisEntity:FindAbilityByName( "sandking_burrowstrike" )
      thisEntity.sandking_burrowstrike:SetLevel(1)
      thisEntity.Owner=thisEntity:GetOwner()
	thisEntity:SetContextThink( "burrowstrike", burrowstrike, 1 )
end

--------------------------------------------------------------------------------

function burrowstrike()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

	if #hEnemies <= 0 then
		return 1
      else
            local ability=thisEntity.Owner:FindAbilityByName("plague_ward")
            if ability then
                  if thisEntity.sandking_burrowstrike ~= nil and thisEntity.sandking_burrowstrike:IsFullyCastable() and ability:GetAutoCastState() then
                              thisEntity:EmitSound("Hero_Lion.Impale")
                              return CastHex( hEnemies[ RandomInt( 1, #hEnemies ) ] )
                  end
            end
	end
	return 0.5
end

--------------------------------------------------------------------------------

function CastHex( hEnemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.sandking_burrowstrike:entindex(),
		Position = hEnemy:GetOrigin(),
		Queue = false,
	})
	return 1
end