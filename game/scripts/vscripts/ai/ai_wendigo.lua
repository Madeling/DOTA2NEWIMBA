function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.tusk_walrus_punch = thisEntity:FindAbilityByName( "tusk_walrus_punch" )
	thisEntity:SetContextThink( "snowball", snowball, 0.5 )
end

--------------------------------------------------------------------------------

function snowball()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

	if #hEnemies >0 then
                  if thisEntity.tusk_walrus_punch ~= nil and thisEntity.tusk_walrus_punch:IsFullyCastable()  then
                              return CastBall( hEnemies[ RandomInt( 1, #hEnemies ) ] )
                  end
	end
	return 0.5
end

--------------------------------------------------------------------------------

function CastBall( hEnemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = thisEntity.tusk_walrus_punch:entindex(),
		TargetIndex = hEnemy:entindex(),
		Queue = false,
	})
	return 1
end