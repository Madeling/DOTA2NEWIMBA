CreateTalents("npc_dota_hero_snapfire", "linken/modifier_generic_custom_indicator")
function IsEnemy(caster, target)
  if caster:GetTeamNumber()==target:GetTeamNumber() then
    return false
  else
    return true
  end
end
imba_snapfire_scatterblast = class({})

--锥形施法圈显示修饰器  by Elfansoer
LinkLuaModifier( "modifier_generic_custom_indicator", "linken/modifier_generic_custom_indicator", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_snapfire_scatterblast_debuff", "linken/hero_snapfire.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom Indicator
function imba_snapfire_scatterblast:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end

function imba_snapfire_scatterblast:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			-- register cursor position
			self.custom_indicator:Register( vLoc )
		end
	end

	return UF_SUCCESS
end

function imba_snapfire_scatterblast:CreateCustomIndicator()
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_range_finder_aoe.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end

function imba_snapfire_scatterblast:UpdateCustomIndicator( loc )
	-- get data
	local origin = self:GetCaster():GetAbsOrigin()
	local point_blank = self:GetSpecialValueFor( "point_blank_range" )

	-- get direction
	local direction = loc - origin
	direction.z = 0
	direction = direction:Normalized()

	ParticleManager:SetParticleControl( self.effect_cast, 0, origin )
	ParticleManager:SetParticleControl( self.effect_cast, 1, origin + direction*(self:GetCastRange( loc, nil )+200) )
	ParticleManager:SetParticleControl( self.effect_cast, 6, origin + direction*point_blank )
end

function imba_snapfire_scatterblast:DestroyCustomIndicator()
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function imba_snapfire_scatterblast:OnAbilityPhaseStart()
	-- play sound
	local sound_cast = "Hero_Snapfire.Shotgun.Load"
	EmitSoundOn( sound_cast, self:GetCaster() )

	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function imba_snapfire_scatterblast:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()

	-- load data
	local projectile_name = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun.vpcf"
	local projectile_distance = self:GetCastRange( point, nil )
	local projectile_start_radius = self:GetSpecialValueFor( "blast_width_initial" )/2
	local projectile_end_radius = self:GetSpecialValueFor( "blast_width_end" )/2
	local projectile_speed = self:GetSpecialValueFor( "blast_speed" )
	local projectile_direction = point-origin
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	local iUnitTargetFlags = self:GetAbilityTargetFlags()
	if caster:Has_Aghanims_Shard() then
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),

	    bDeleteOnHit = false,

	    iUnitTargetTeam = self:GetAbilityTargetTeam(),
	    iUnitTargetFlags = iUnitTargetFlags,
	    iUnitTargetType = self:GetAbilityTargetType(),

	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,

		bProvidesVision = false,
		ExtraData = {
			pos_x = origin.x,
			pos_y = origin.y,
		}
	}


	ProjectileManager:CreateLinearProjectile(info)

	-- play sound
	local sound_cast = "Hero_Snapfire.Shotgun.Fire"
	EmitSoundOn( sound_cast, caster )
	-- 添加霹雳铁手BUFF
	local lil_abi =  caster:FindAbilityByName("imba_snapfire_lil_shredder")
	if lil_abi and lil_abi:GetLevel() > 0 then
		if caster:HasModifier("modifier_imba_snapfire_lil_shredder_buff") then
			caster:SetModifierStackCount("modifier_imba_snapfire_lil_shredder_buff", nil, caster:GetModifierStackCount("modifier_imba_snapfire_lil_shredder_buff", nil) + 1)
		else
			-- addd buff
			local lil_modifier = caster:AddNewModifier(
								caster, -- player source
								lil_abi, -- ability source
								"modifier_imba_snapfire_lil_shredder_buff", -- modifier name
								{ duration = lil_abi:GetDuration() } -- kv
							)
			lil_modifier:SetStackCount(1)
		end
	end
end
--------------------------------------------------------------------------------
-- Projectile
function imba_snapfire_scatterblast:OnProjectileHit_ExtraData( target, location, extraData )
	if not target then return end

	-- load data
	local caster = self:GetCaster()
	local location = target:GetOrigin()
	local point_blank_range = self:GetSpecialValueFor( "point_blank_range" )
	local point_blank_mult = self:GetSpecialValueFor( "point_blank_dmg_bonus_pct" )/100
	local damage = self:GetSpecialValueFor( "damage" ) + caster:TG_GetTalentValue("special_bonus_imba_snapfire_7")
	local slow = self:GetSpecialValueFor( "debuff_duration" )
	-- check position
	local origin = Vector( extraData.pos_x, extraData.pos_y, 0 )
	local length = (location-origin):Length2D()

	-- manual check due to projectile's circle shape
	-- if length>self:GetCastRange( location, nil )+150 then return end

	local point_blank = (length<=point_blank_range)
	if point_blank then damage = damage + point_blank_mult*damage end

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- debuff 减速和缴械
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_snapfire_scatterblast_debuff", -- modifier name
		{ duration = slow } -- kv
	)

	-- 击退
	local caster_pos = caster:GetAbsOrigin()
	local knockback_table =
	{
		center_x = caster_pos.x ,
		center_y = caster_pos.y ,
		center_z = caster_pos.z ,
		duration = 0.2,
		knockback_duration = 0.2,
		knockback_distance = self:GetSpecialValueFor("knockback_distance"),
		knockback_height = 0
	}
	target:AddNewModifier( caster, self, "modifier_knockback", knockback_table )

	-- effect
	self:PlayEffects( target, point_blank )
end

--------------------------------------------------------------------------------
function imba_snapfire_scatterblast:PlayEffects( target, point_blank )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_impact.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_shells_impact.vpcf"
	local particle_cast3 = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_pointblank_impact_sparks.vpcf"
	local sound_target = "Hero_Snapfire.Shotgun.Target"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if point_blank then
		local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_POINT_FOLLOW, target )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			3,
			target,
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:ReleaseParticleIndex( effect_cast )

		local effect_cast = ParticleManager:CreateParticle( particle_cast3, PATTACH_POINT_FOLLOW, target )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			4,
			target,
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end

	-- Create Sound
	EmitSoundOn( sound_target, target )
end

--debuff
modifier_imba_snapfire_scatterblast_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_snapfire_scatterblast_debuff:IsHidden() return false end
function modifier_imba_snapfire_scatterblast_debuff:IsDebuff() return true end
function modifier_imba_snapfire_scatterblast_debuff:IsBuff() return false end
function modifier_imba_snapfire_scatterblast_debuff:IsStunDebuff() return false end
function modifier_imba_snapfire_scatterblast_debuff:IsPurgable() return true end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_snapfire_scatterblast_debuff:OnCreated( kv )
	-- references
	self.slow = -self:GetAbility():GetSpecialValueFor( "movement_slow_pct" )
end

function modifier_imba_snapfire_scatterblast_debuff:OnRefresh( kv )
	-- references
	self.slow = -self:GetAbility():GetSpecialValueFor( "movement_slow_pct" )
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_snapfire_scatterblast_debuff:CheckState()
	if self:GetCaster():TG_HasTalent("special_bonus_imba_snapfire_3") then
		local state = {
			[MODIFIER_STATE_DISARMED] = true,
		}
		return state
	end
end
function modifier_imba_snapfire_scatterblast_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end
function modifier_imba_snapfire_scatterblast_debuff:OnDestroy()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	if caster:Has_Aghanims_Shard() then
		parent:AddNewModifier(
			caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self:GetAbility():GetSpecialValueFor( "stun_duration" ) } -- kv
		)
	end
end

function modifier_imba_snapfire_scatterblast_debuff:GetModifierMoveSpeedBonus_Percentage() return self.slow end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_snapfire_scatterblast_debuff:GetEffectName()
	return "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf"
end
function modifier_imba_snapfire_scatterblast_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_snapfire_scatterblast_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_snapfire_slow.vpcf" end
function modifier_imba_snapfire_scatterblast_debuff:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL end



--------------------------------------------------------------------------------
------			       Snapfire Firesnap Cookie                           ------
--------------------------------------------------------------------------------

imba_snapfire_firesnap_cookie = class({})

LinkLuaModifier( "modifier_generic_knockback_lua", "linken/modifier_generic_knockback_lua.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_imba_snapfire_firesnap_cookie_buff", "linken/hero_snapfire.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
function imba_snapfire_firesnap_cookie:GetCastPoint()
	if IsServer() and self:GetCursorTarget()==self:GetCaster() then
		return self:GetSpecialValueFor( "self_cast_delay" )
	end
	return 0.2
end

--------------------------------------------------------------------------------
-- Ability Cast Filter
function imba_snapfire_firesnap_cookie:CastFilterResultTarget( hTarget )
	if IsServer() and hTarget:IsChanneling() then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter(
		hTarget,
		--DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		0,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function imba_snapfire_firesnap_cookie:GetCustomCastErrorTarget( hTarget )
	if IsServer() and hTarget:IsChanneling() then
		return "#dota_hud_error_is_channeling"
	end

	return ""
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function imba_snapfire_firesnap_cookie:OnAbilityPhaseInterrupted()

end
function imba_snapfire_firesnap_cookie:OnAbilityPhaseStart()
	if self:GetCursorTarget()==self:GetCaster() then
		self:PlayEffects1()
	end

	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function imba_snapfire_firesnap_cookie:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local projectile_name = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,

		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)

	-- Play sound
	local sound_cast = "Hero_Snapfire.FeedCookie.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )

	if RollPercentage(10) then
		EmitSoundOn("Imba.Snapfire.FeedCookie.Self", self:GetCaster() )
	end
end
--------------------------------------------------------------------------------
-- Projectile
function imba_snapfire_firesnap_cookie:OnProjectileHit( target, location )
	if not target then return end

	if target:IsChanneling() or target:IsOutOfGame() then return end

	-- load data
	local duration = self:GetSpecialValueFor( "jump_duration" )
	local height = self:GetSpecialValueFor( "jump_height" )
	local distance = self:GetSpecialValueFor( "jump_horizontal_distance" )
	if not IsEnemy(self:GetCaster(),target) then
		distance = distance * 2
	end
	local stun = self:GetSpecialValueFor( "impact_stun_duration" )
	local damage = self:GetSpecialValueFor( "impact_damage" )
	local radius = self:GetSpecialValueFor( "impact_radius" )
	-- IMBA
	local cookie_buff = self:GetSpecialValueFor( "cookie_buff_duration" )

	-- play effects2
	local effect_cast = self:PlayEffects2( target )

	-- knockback
	local knockback = target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_knockback_lua", -- modifier name
		{
			distance = distance,
			height = height,
			duration = duration,
			direction_x = target:GetForwardVector().x,
			direction_y = target:GetForwardVector().y,
			IsStun = IsEnemy(self:GetCaster(),target),--true,
			IsFreeControll = not IsEnemy(self:GetCaster(),target), --IsEnemy(self:GetCaster(),target),
		} -- kv
	)

	-- Talent
	if not IsEnemy(self:GetCaster(),target) and self:GetCaster():TG_HasTalent("special_bonus_imba_snapfire_5") then
		local heal_num = self:GetCaster():TG_GetTalentValue("special_bonus_imba_snapfire_5")
		target:Heal(heal_num, self:GetCaster())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal_num, nil)
	end

	-- on landing
	local callback = function()
		if not target:IsAlive() then return end
		-- precache damage
		local damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self, --Optional.
		}

		-- find enemies
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for _,enemy in pairs(enemies) do
			-- apply damage
			damageTable.victim = enemy
			ApplyDamage(damageTable)

			-- stun
			enemy:AddNewModifier(
				self:GetCaster(), -- player source
				self, -- ability source
				"modifier_stunned", -- modifier name
				{ duration = stun } -- kv
			)
		end

		-- destroy trees
		GridNav:DestroyTreesAroundPoint( target:GetOrigin(), radius, true )

		-- play effects
		ParticleManager:DestroyParticle( effect_cast, false )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		self:PlayEffects3( target, radius )

		-- brust buff
		target:AddNewModifier( self:GetCaster(), self, "modifier_imba_snapfire_firesnap_cookie_buff", { duration = cookie_buff } )
		-- play sound
		if not IsEnemy(self:GetCaster(),target) then
			if target:GetName() == "npc_dota_hero_juggernaut" then
				EmitSoundOn("Imba.Snapfire.FeedCookie.Jugg", target )
			elseif RollPercentage(10) then
				EmitSoundOn("Imba.Snapfire.FeedCookie.Ally", target )
			end
		end
	end
	knockback:SetEndCallback( callback )
end

--------------------------------------------------------------------------------
function imba_snapfire_firesnap_cookie:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_selfcast.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function imba_snapfire_firesnap_cookie:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_buff.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_receive.vpcf"
	local sound_target = "Hero_Snapfire.FeedCookie.Consume"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, target )

	-- Create Sound
	EmitSoundOn( sound_target, target )

	return effect_cast
end

function imba_snapfire_firesnap_cookie:PlayEffects3( target, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf"
	local sound_location = "Hero_Snapfire.FeedCookie.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_location, target )
end

--烈性能量
modifier_imba_snapfire_firesnap_cookie_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_snapfire_firesnap_cookie_buff:IsHidden() return false end
function modifier_imba_snapfire_firesnap_cookie_buff:IsDebuff() return IsEnemy(self:GetCaster(), self:GetParent()) end
function modifier_imba_snapfire_firesnap_cookie_buff:IsBuff() return not IsEnemy(self:GetCaster(), self:GetParent()) end
function modifier_imba_snapfire_firesnap_cookie_buff:IsStunDebuff() return false end
function modifier_imba_snapfire_firesnap_cookie_buff:IsPurgable() return true end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_snapfire_firesnap_cookie_buff:OnCreated( kv )
	-- references
	if IsEnemy(self:GetCaster(), self:GetParent()) then
		self.movement_pct = -self:GetAbility():GetSpecialValueFor( "movement_pct" ) -- 移速
		self.incoming_damage = self:GetAbility():GetSpecialValueFor( "incoming_damage" ) -- 受伤
		self.outgoing_damage = -self:GetAbility():GetSpecialValueFor( "outgoing_damage" ) -- 输出
	else
		self.movement_pct = self:GetAbility():GetSpecialValueFor( "movement_pct" ) -- 移速
		self.incoming_damage = -self:GetAbility():GetSpecialValueFor( "incoming_damage" ) -- 受伤
		self.outgoing_damage = self:GetAbility():GetSpecialValueFor( "outgoing_damage" ) -- 输出
	end
end

function modifier_imba_snapfire_firesnap_cookie_buff:OnRefresh( kv )
	-- references
	if IsEnemy(self:GetCaster(), self:GetParent()) then
		self.movement_pct = -self:GetAbility():GetSpecialValueFor( "movement_pct" ) -- 移速
		self.incoming_damage = self:GetAbility():GetSpecialValueFor( "incoming_damage" ) -- 受伤
		--self.outgoing_damage = -self:GetAbility():GetSpecialValueFor( "outgoing_damage" ) -- 输出
	else
		self.movement_pct = self:GetAbility():GetSpecialValueFor( "movement_pct" ) -- 移速
		self.incoming_damage = -self:GetAbility():GetSpecialValueFor( "incoming_damage" ) -- 受伤
		--self.outgoing_damage = self:GetAbility():GetSpecialValueFor( "outgoing_damage" ) -- 输出
	end
end

function modifier_imba_snapfire_firesnap_cookie_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		--MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end
function modifier_imba_snapfire_firesnap_cookie_buff:GetModifierMoveSpeedBonus_Percentage() return self.movement_pct end
function modifier_imba_snapfire_firesnap_cookie_buff:GetModifierIncomingDamage_Percentage() return self.incoming_damage end
--function modifier_imba_snapfire_firesnap_cookie_buff:GetModifierTotalDamageOutgoing_Percentage() return self.outgoing_damage end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_snapfire_firesnap_cookie_buff:GetEffectName() return "particles/generic_gameplay/rune_doubledamage_owner.vpcf" end
function modifier_imba_snapfire_firesnap_cookie_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


--------------------------------------------------------------------------------
------			       	Snapfire Lil Shredder                             ------
--------------------------------------------------------------------------------

imba_snapfire_lil_shredder = class({})

LinkLuaModifier( "modifier_imba_snapfire_lil_shredder_buff", "linken/hero_snapfire.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_snapfire_lil_shredder_debuff", "linken/hero_snapfire.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function imba_snapfire_lil_shredder:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetDuration()

	-- addd buff
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_snapfire_lil_shredder_buff", -- modifier name
		{ duration = duration } -- kv
	)
end
function imba_snapfire_lil_shredder:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:HasScepter() then
		return (cooldown - self:GetSpecialValueFor( "cd" ) )
	end
	return cooldown
end
--------------------------------------------------------------------------------
modifier_imba_snapfire_lil_shredder_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_snapfire_lil_shredder_buff:IsHidden() return false end
function modifier_imba_snapfire_lil_shredder_buff:IsDebuff() return false end
function modifier_imba_snapfire_lil_shredder_buff:IsBuff() return true end
function modifier_imba_snapfire_lil_shredder_buff:IsStunDebuff() return false end
function modifier_imba_snapfire_lil_shredder_buff:IsPurgable() return true end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_snapfire_lil_shredder_buff:OnCreated( kv )
	-- references
	self.attacks = self:GetAbility():GetSpecialValueFor( "buffed_attacks" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "attack_speed_bonus" )
	self.range_bonus = self:GetAbility():GetSpecialValueFor( "attack_range_bonus" )
	self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )

	self.slow = self:GetAbility():GetSpecialValueFor( "slow_duration" )

	if not IsServer() then return end
	self:SetStackCount( self.attacks )

	self.records = {}

	-- play Effects & Sound
	self:PlayEffects()
	local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
	EmitSoundOn( sound_cast, self:GetParent() )
-----------------------------
	self.reduction = 0
	self.count = self:GetParent():TG_GetTalentValue("special_bonus_imba_snapfire_8")
	self.bonus_range = 200

	self.parent = self:GetParent()

	-- will be changed dynamically for talents
	self.use_modifier = true

	if not IsServer() then return end
	self.projectile_name = self.parent:GetRangedProjectileName()
	self.projectile_speed = self.parent:GetProjectileSpeed()
end

function modifier_imba_snapfire_lil_shredder_buff:OnRefresh( kv )
	-- references
	self.attacks = self:GetAbility():GetSpecialValueFor( "buffed_attacks" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "attack_speed_bonus" )
	self.range_bonus = self:GetAbility():GetSpecialValueFor( "attack_range_bonus" )
	self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )

	self.slow = self:GetAbility():GetSpecialValueFor( "slow_duration" )

	if not IsServer() then return end
	self:SetStackCount( self.attacks )

	-- play sound
	local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
	EmitSoundOn( sound_cast, self:GetParent() )
	-----------------------------
	self.reduction = 0
	self.count = self:GetParent():TG_GetTalentValue("special_bonus_imba_snapfire_8")
	self.bonus_range = 200
end

function modifier_imba_snapfire_lil_shredder_buff:OnDestroy()
	if not IsServer() then return end

	-- stop sound
	local sound_cast = "Hero_Snapfire.ExplosiveShells.Cast"
	StopSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_snapfire_lil_shredder_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,

		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}

	return funcs
end

function modifier_imba_snapfire_lil_shredder_buff:OnAttack( params )
	if params.attacker~=self:GetParent() then return end
	if self:GetStackCount()<=0 then return end

	-- record attack
	self.records[params.record] = true

	-- play sound
	local sound_cast = "Hero_Snapfire.ExplosiveShellsBuff.Attack"
	EmitSoundOn( sound_cast, self:GetParent() )

	-- decrement stack
	if params.no_attack_cooldown then return end

	-- not proc for attacking allies
	if params.target:GetTeamNumber()==params.attacker:GetTeamNumber() then return end

	-- not proc if attack can't use attack modifiers
	if not params.process_procs then return end

	-- not proc on split shot attacks, even if it can use attack modifier, to avoid endless recursive call and crash
	if self.split_shot then return end

	-- split shot
--[[	if params.attacker:HasScepter() then
		params.target:AddNewModifier(
			params.attacker, -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self:GetAbility():GetSpecialValueFor( "stun_duration" ) } -- kv
		)
	end	]]
	if self:GetParent():TG_HasTalent("special_bonus_imba_snapfire_8") then
		self:SplitShotModifier( params.target )
	end
	if self:GetStackCount()>0 then
		self:DecrementStackCount()
	end

end
function modifier_imba_snapfire_lil_shredder_buff:SplitShotModifier( target )
	-- get radius
	local radius = self.parent:Script_GetAttackRange() + self.bonus_range

	-- find other target units
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		1,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- get targets
	local count = 0
	for _,enemy in pairs(enemies) do
		-- not target itself
		if enemy~=target then

			-- perform attack
			self.split_shot = true
			self.parent:PerformAttack(
				enemy, -- hTarget
				false, -- bUseCastAttackOrb
				true, -- bProcessProcs
				true, -- bSkipCooldown
				false, -- bIgnoreInvis
				true, -- bUseProjectile
				false, -- bFakeAttack
				false -- bNeverMiss
			)
			self.split_shot = false
			if self.parent:Has_Aghanims_Shard() then
				enemy:AddNewModifier(
					self.parent, -- player source
					self:GetAbility(), -- ability source
					"modifier_stunned", -- modifier name
					{ duration = self:GetAbility():GetSpecialValueFor( "stun_duration" ) } -- kv
				)
			end
			count = count + 1
			if count>=self.count then break end
		end
	end
end
function modifier_imba_snapfire_lil_shredder_buff:OnAttackLanded( params )
	if self.records[params.record] then
		-- add modifier
		params.target:AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_imba_snapfire_lil_shredder_debuff", -- modifier name
			{ duration = self.slow } -- kv
		)
	end

	-- play sound
	local sound_cast = "Hero_Snapfire.ExplosiveShellsBuff.Target"
	EmitSoundOn( sound_cast, params.target )
end

function modifier_imba_snapfire_lil_shredder_buff:OnAttackRecordDestroy( params )
	if self.records[params.record] then
		self.records[params.record] = nil

		-- if table is empty and no stack left, destroy
		if next(self.records)==nil and self:GetStackCount()<=0 then
			--IMBA 获得饼干BUFF
			local cookie_abi = self:GetCaster():FindAbilityByName("imba_snapfire_firesnap_cookie")
			if cookie_abi and cookie_abi:GetLevel() > 0 then
				self:GetParent():AddNewModifier(self:GetCaster(),cookie_abi,"modifier_imba_snapfire_firesnap_cookie_buff",{duration = self:GetAbility():GetDuration()/2})
			end
			self:Destroy()
		end
	end
end

function modifier_imba_snapfire_lil_shredder_buff:GetModifierProjectileName()
	if self:GetStackCount()<=0 then return end
	return "particles/units/heroes/hero_snapfire/hero_snapfire_shells_projectile.vpcf"
end

function modifier_imba_snapfire_lil_shredder_buff:GetModifierOverrideAttackDamage()
	if self:GetCaster():TG_HasTalent("special_bonus_imba_snapfire_6") or self:GetStackCount()<=0 then return end
	return self.damage
end

function modifier_imba_snapfire_lil_shredder_buff:GetModifierAttackRangeBonus()
	if self:GetStackCount()<=0 then return end
	return self.range_bonus
end

function modifier_imba_snapfire_lil_shredder_buff:GetModifierAttackSpeedBonus_Constant()
	if self:GetStackCount()<=0 then return end
	return self.as_bonus
end

function modifier_imba_snapfire_lil_shredder_buff:GetModifierBaseAttackTimeConstant()
	if self:GetStackCount()<=0 then return end
	return self.bat
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_snapfire_lil_shredder_buff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_shells_buff.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		4,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		5,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end

--------------------------------------------------------------------------------
modifier_imba_snapfire_lil_shredder_debuff = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_snapfire_lil_shredder_debuff:IsHidden() return false end
function modifier_imba_snapfire_lil_shredder_debuff:IsDebuff() return true end
function modifier_imba_snapfire_lil_shredder_debuff:IsBuff() return false end
function modifier_imba_snapfire_lil_shredder_debuff:IsStunDebuff() return false end
function modifier_imba_snapfire_lil_shredder_debuff:IsPurgable() return true end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_snapfire_lil_shredder_debuff:OnCreated( kv )
	-- references
	self.slow = 0 - self:GetAbility():GetSpecialValueFor( "attack_speed_slow_per_stack" )
	self.arr = 0 - self:GetCaster():TG_GetTalentValue("special_bonus_imba_snapfire_2")

	if not IsServer() then return end
	self:SetStackCount( 1 )
end

function modifier_imba_snapfire_lil_shredder_debuff:OnRefresh( kv )
	if not IsServer() then return end
	self:IncrementStackCount()
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_snapfire_lil_shredder_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_imba_snapfire_lil_shredder_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.slow * self:GetStackCount()
end
function modifier_imba_snapfire_lil_shredder_debuff:GetModifierPhysicalArmorBonus()

	return self.arr * self:GetStackCount()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_snapfire_lil_shredder_debuff:GetEffectName()
	-- return "particles/units/heroes/hero_snapfire/hero_snapfire_slow_debuff.vpcf"
	return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end
function modifier_imba_snapfire_lil_shredder_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

--------------------------------------------------------------------------------
------			       	Snapfire Mortimer Kisses                          ------
--------------------------------------------------------------------------------

imba_snapfire_mortimer_kisses = class({})

LinkLuaModifier( "modifier_imba_snapfire_mortimer_kisses", "linken/hero_snapfire.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_snapfire_mortimer_kisses_passive", "linken/hero_snapfire.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_snapfire_mortimer_kisses_thinker", "linken/hero_snapfire.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_snapfire_mortimer_kisses_aura", "linken/hero_snapfire.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_snapfire_mortimer_kisses_debuff", "linken/hero_snapfire.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_snapfire_mortimer_kisses_cd", "linken/hero_snapfire.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function imba_snapfire_mortimer_kisses:GetAOERadius() return self:GetSpecialValueFor( "impact_radius" ) end
function imba_snapfire_mortimer_kisses:GetIntrinsicModifierName() return "modifier_imba_snapfire_mortimer_kisses_passive" end
function imba_snapfire_mortimer_kisses:IsHiddenWhenStolen() 	return false end
function imba_snapfire_mortimer_kisses:IsRefreshable() 		return true end
function imba_snapfire_mortimer_kisses:IsStealable() 			return true end
function imba_snapfire_mortimer_kisses:IsNetherWardStealable()	return false end
--------------------------------------------------------------------------------
-- Ability Start
function imba_snapfire_mortimer_kisses:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetDuration()

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_snapfire_mortimer_kisses", -- modifier name
		{
			duration = duration,
			pos_x = point.x,
			pos_y = point.y,
		} -- kv
	)
end

--------------------------------------------------------------------------------
-- Projectile
function imba_snapfire_mortimer_kisses:OnProjectileHit( target, location )
	if not target then return end

	-- load data
	local damage = self:GetSpecialValueFor( "damage_per_impact" )
	if not self:GetCaster():HasModifier("modifier_imba_snapfire_mortimer_kisses") then
		damage = damage / 2
	end
	local duration = self:GetSpecialValueFor( "burn_ground_duration" )
	local impact_radius = self:GetSpecialValueFor( "impact_radius" )
	local vision = self:GetSpecialValueFor( "projectile_vision" )
	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		location,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		impact_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end

	-- start aura on thinker
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_imba_snapfire_mortimer_kisses_thinker", -- modifier name
		{
			duration = duration,
			slow = 1
		} -- kv
	)

	-- destroy trees
	GridNav:DestroyTreesAroundPoint( location, impact_radius, true )

	-- create Vision
	AddFOWViewer( self:GetCaster():GetTeamNumber(), location, vision, duration, false )

	-- play effects
	self:PlayEffects( target:GetOrigin() )
end

--------------------------------------------------------------------------------
function imba_snapfire_mortimer_kisses:PlayEffects( loc )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_impact.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_linger.vpcf"
	local sound_cast = "Hero_Snapfire.MortimerBlob.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 3, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, loc )
	ParticleManager:SetParticleControl( effect_cast, 1, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	local sound_location = "Hero_Snapfire.MortimerBlob.Impact"
	EmitSoundOnLocationWithCaster( loc, sound_location, self:GetCaster() )
end
--------------------------------------------------------------------------------
-- Projectile
function CastSingleMortimerKisses( caster, ability, target, location )
	if not target then return end

	-- load data
	local damage = ability:GetSpecialValueFor( "damage_per_impact" )
	local duration = ability:GetSpecialValueFor( "burn_ground_duration" )
	local impact_radius = ability:GetSpecialValueFor( "impact_radius" )
	local projectile_vision = ability:GetSpecialValueFor( "projectile_vision" )

	local projectile_speed = ability:GetSpecialValueFor( "projectile_speed" )
	local projectile_name = "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf"

	--thinker
	local thinker = CreateModifierThinker(
		caster, -- player source
		ability, -- ability source
		"modifier_imba_snapfire_mortimer_kisses_thinker", -- modifier name
		{ travel_time = 0.3 }, -- kv
		location,
		caster:GetTeamNumber(),
		false
	)

	-- precache projectile
	local info = {
		Target = thinker,
		Source = caster,
		Ability = ability,

		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional

		vSourceLoc = caster:GetOrigin(),                -- Optional (HOW)

		bDrawsOnMinimap = false,                          -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	}
	-- launch projectile
	ProjectileManager:CreateTrackingProjectile( info )

	-- create FOW
	AddFOWViewer( caster:GetTeamNumber(), thinker:GetOrigin(), 100, 1, false )

	-- play sound
	local sound_cast = "Hero_Snapfire.MortimerBlob.Launch"
	EmitSoundOn( sound_cast, thinker )
end

--IMBA
--------------------------------------------------------------------------------
modifier_imba_snapfire_mortimer_kisses_passive = class({})
--------------------------------------------------------------------------------
function modifier_imba_snapfire_mortimer_kisses_passive:IsPassive()			return true end
function modifier_imba_snapfire_mortimer_kisses_passive:IsDebuff()			return false end
function modifier_imba_snapfire_mortimer_kisses_passive:IsBuff()			return true end
function modifier_imba_snapfire_mortimer_kisses_passive:IsHidden() 			return true end
function modifier_imba_snapfire_mortimer_kisses_passive:IsPurgable() 		return false end
function modifier_imba_snapfire_mortimer_kisses_passive:IsPurgeException() 	return false end
function modifier_imba_snapfire_mortimer_kisses_passive:AllowIllusionDuplicate() return false end
function modifier_imba_snapfire_mortimer_kisses_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_imba_snapfire_mortimer_kisses_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	--触发
	if PseudoRandom:RollPseudoRandom(self:GetAbility(), self:GetAbility():GetSpecialValueFor("kisses_chance")) and not self:GetParent():HasModifier("modifier_imba_snapfire_mortimer_kisses_cd") then
		--施法火团
		CastSingleMortimerKisses(self:GetCaster(),self:GetAbility(),keys.target,keys.target:GetAbsOrigin())
		self:GetParent():AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_imba_snapfire_mortimer_kisses_cd", -- modifier name
			{
				duration = 0.3
			} -- kv
		)
	end
end
modifier_imba_snapfire_mortimer_kisses_cd = class({})
function modifier_imba_snapfire_mortimer_kisses_cd:IsDebuff()			return true end
function modifier_imba_snapfire_mortimer_kisses_cd:IsHidden() 			return false end
function modifier_imba_snapfire_mortimer_kisses_cd:IsPurgable() 		return false end
function modifier_imba_snapfire_mortimer_kisses_cd:IsPurgeException() 	return false end
banned_cast_abi = {
["imba_morphling_morph_replicate"] = true,
["imba_morphling_replicate"] = true,
["item_imba_blink"] = true,
["item_tpscroll"] = true,
["item_imba_black_king_bar"] = true,
["item_black_king_bar"] = true,
["item_imba_blink_boots"] = true,
["item_imba_ultimate_scepter_synth"] = true,
["item_imba_manta"] = true,
["item_imba_magic_stick"] = true,
["item_imba_magic_wand"] = true,
["item_soul_ring"] = true,
["item_imba_armlet"] = true,
["item_imba_armlet_active"] = true,
["item_imba_bloodstone"] = true,
["item_imba_cyclone"] = true,
["item_imba_radiance"] = true,
["item_imba_refresher"] = true,
["item_imba_cheese"] = true,
["item_imba_soul_ring"] = true,
["item_urn_of_shadows"] = true,
["item_smoke_of_deceit"] = true,
["item_imba_ring_of_aquila"] = true,
["item_imba_moon_shard"] = true,
["item_imba_silver_edge"] = true,
["item_imba_octarine_core"] = true,
["item_imba_octarine_core_off"] = true,
["item_bottle"] = true,
["item_dust"] = true,
["item_flask"] = true,
["item_imba_shadow_blade"] = true,
["item_ward_observer"] = true,
["item_ward_sentry"] = true,
["item_spirit_vessel"] = true,
["item_refresher_shard"] = true,
["item_ward_dispenser"] = true,
["item_travel_boots_2"] = true,
["item_travel_boots"] = true,
["item_power_treads"] = true,
["item_imba_power_treads_2"] = true,
["imba_antimage_blink"] = true,
["imba_queenofpain_blink"] = true,
["imba_riki_tricks_of_the_trade"] = true,
["imba_riki_tott_true"] = true,
["spirit_breaker_charge_of_darkness"] = true,
["tusk_snowball"] = true,
["tusk_launch_snowball"] = true,
["furion_teleportation"] = true,
["imba_faceless_void_time_walk"] = true,
["elder_titan_ancestral_spirit"] = true,
["brewmaster_primal_split"] = true,
["imba_jakiro_fire_breath"] = true,
["imba_jakiro_ice_breath"] = true,
["wisp_tether"] = true,
["wisp_tether_break"] = true,
["shredder_timber_chain"] = true,
["shredder_chakram"] = true,
["shredder_chakram_2"] = true,
["imba_chaos_knight_reality_rift"] = true,
["imba_puck_phase_shift"] = true,
["imba_puck_ethereal_jaunt"] = true,
["invoker_quas"] = true,
["invoker_exort"] = true,
["invoker_wex"] = true,
["invoker_invoke"] = true,
["imba_timbersaw_chakram"] = true,
["imba_timbersaw_chakram_2"] = true,
["item_necronomicon"] = true,
["item_necronomicon_2"] = true,
["item_necronomicon_3"] = true,
["item_demonicon"] = true,
["item_imba_necronomicon"] = true,
["item_imba_necronomicon_2"] = true,
["item_imba_necronomicon_3"] = true,
["item_imba_necronomicon_4"] = true,
["item_imba_necronomicon_5"] = true,
}

function modifier_imba_snapfire_mortimer_kisses_passive:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() or self:GetParent():PassivesDisabled() then
		return
	end
	--开关类技能不触发 自动施法类技能不能触发
	if banned_cast_abi[keys.ability:GetAbilityName()] then
		return
	end
	--10-31 Value Update Bug Fix
	--BitWiseAbilityBehavior(handle pzfability,int pzf abilityBehavior)
	if type(keys.ability:GetBehavior()) == "userdata" then
		if keys.ability:GetBehavior():BitwiseAnd(DOTA_ABILITY_BEHAVIOR_TOGGLE) or keys.ability:GetBehavior():BitwiseAnd(DOTA_ABILITY_BEHAVIOR_CHANNELLED) then
			return
		end
	elseif bit.band(keys.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_TOGGLE) == DOTA_ABILITY_BEHAVIOR_TOGGLE or bit.band(keys.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_CHANNELLED) == DOTA_ABILITY_BEHAVIOR_CHANNELLED then
		return
	end
	--[[for i = 0, self:GetCaster():GetModifierCount() -1 do
		print("pre modifier +++ ",self:GetCaster():GetModifierNameByIndex(i))
	end]]
	--施法必定触发火团
	local target = keys.ability:GetCursorTarget() or nil
	if target and target:IsAlive() and target ~= self:GetParent() then
		CastSingleMortimerKisses(self:GetCaster(),self:GetAbility(),target,target:GetAbsOrigin())
	end
end

--------------------------------------------------------------------------------
modifier_imba_snapfire_mortimer_kisses = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_snapfire_mortimer_kisses:IsHidden() return false end
function modifier_imba_snapfire_mortimer_kisses:IsDebuff() return false end
function modifier_imba_snapfire_mortimer_kisses:IsBuff() return true end
function modifier_imba_snapfire_mortimer_kisses:IsStunDebuff() return false end
function modifier_imba_snapfire_mortimer_kisses:IsPurgable() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_snapfire_mortimer_kisses:OnCreated( kv )
	-- references
	self.min_range = self:GetAbility():GetSpecialValueFor( "min_range" )
	self.max_range = self:GetAbility():GetCastRange( Vector(0,0,0), nil )
	self.range = self.max_range-self.min_range

	self.min_travel = self:GetAbility():GetSpecialValueFor( "min_lob_travel_time" )
	self.max_travel = self:GetAbility():GetSpecialValueFor( "max_lob_travel_time" )
	self.travel_range = self.max_travel-self.min_travel

	self.projectile_speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
	local projectile_vision = self:GetAbility():GetSpecialValueFor( "projectile_vision" )

	self.turn_rate = self:GetAbility():GetSpecialValueFor( "turn_rate" )

	if not IsServer() then return end
	-- load data
	local interval = self:GetAbility():GetDuration()/(self:GetAbility():GetSpecialValueFor( "projectile_count" ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_snapfire_1")) + 0.01 -- so it only have 8 projectiles instead of 9
	self:SetValidTarget( Vector( kv.pos_x, kv.pos_y, 0 ) )
	local projectile_name = "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf"
	local projectile_start_radius = 0
	local projectile_end_radius = 0

	-- precache projectile
	self.info = {
		-- Target = target,
		Source = self:GetCaster(),
		Ability = self:GetAbility(),

		EffectName = projectile_name,
		iMoveSpeed = self.projectile_speed,
		bDodgeable = false,                           -- Optional

		vSourceLoc = self:GetCaster():GetOrigin(),                -- Optional (HOW)

		bDrawsOnMinimap = false,                          -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = self:GetCaster():GetTeamNumber()        -- Optional
	}

	-- Start interval
	self:StartIntervalThink( interval )
	self:OnIntervalThink()
end

function modifier_imba_snapfire_mortimer_kisses:OnRefresh( kv )

end

function modifier_imba_snapfire_mortimer_kisses:OnRemoved()
end

function modifier_imba_snapfire_mortimer_kisses:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_snapfire_mortimer_kisses:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
	return funcs
end

function modifier_imba_snapfire_mortimer_kisses:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	-- right click, switch position
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self:SetValidTarget( params.new_pos )
	elseif
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetValidTarget( params.target:GetOrigin() )

	-- stop or hold
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:Destroy()
	end
end

function modifier_imba_snapfire_mortimer_kisses:GetModifierMoveSpeed_Limit() return 0.1 end
function modifier_imba_snapfire_mortimer_kisses:GetModifierTurnRate_Percentage() return -self.turn_rate end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_imba_snapfire_mortimer_kisses:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_snapfire_mortimer_kisses:OnIntervalThink()
	-- create target thinker
	local thinker = CreateModifierThinker(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_imba_snapfire_mortimer_kisses_thinker", -- modifier name
		{ travel_time = self.travel_time }, -- kv
		self.target_pos,
		self:GetParent():GetTeamNumber(),
		false
	)
	-- keep gesture
	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_4)
	-- set projectile
	self.info.iMoveSpeed = self.vector:Length2D()/self.travel_time
	self.info.Target = thinker

	-- launch projectile
	ProjectileManager:CreateTrackingProjectile( self.info )

	-- create FOW
	AddFOWViewer( self:GetParent():GetTeamNumber(), thinker:GetOrigin(), 100, 1, false )

	-- play sound
	local sound_cast = "Hero_Snapfire.MortimerBlob.Launch"
	EmitSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Helper
function modifier_imba_snapfire_mortimer_kisses:SetValidTarget( location )
	local origin = self:GetParent():GetOrigin()
	local vec = location-origin
	local direction = vec
	direction.z = 0
	direction = direction:Normalized()

	if vec:Length2D()<self.min_range then
		vec = direction * self.min_range
	elseif vec:Length2D()>self.max_range then
		vec = direction * self.max_range
	end

	self.target_pos = GetGroundPosition( origin + vec, nil )
	self.vector = vec
	self.travel_time = (vec:Length2D()-self.min_range)/self.range * self.travel_range + self.min_travel
end

--------------------------------------------------------------------------------
modifier_imba_snapfire_mortimer_kisses_debuff = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_snapfire_mortimer_kisses_debuff:IsHidden() return false end
function modifier_imba_snapfire_mortimer_kisses_debuff:IsDebuff() return true end
function modifier_imba_snapfire_mortimer_kisses_debuff:IsBuff()	return false end
function modifier_imba_snapfire_mortimer_kisses_debuff:IsStunDebuff() return false end
function modifier_imba_snapfire_mortimer_kisses_debuff:IsPurgable() return true end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_snapfire_mortimer_kisses_debuff:OnCreated( kv )
	-- references
	self.slow = - (self:GetAbility():GetSpecialValueFor( "move_slow_pct" ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_snapfire_4"))
	self.dps = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	local interval = self:GetAbility():GetSpecialValueFor( "burn_interval" )

	if not IsServer() then return end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.dps*interval,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	-- Start interval
	self:StartIntervalThink( interval )
	self:OnIntervalThink()
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_snapfire_mortimer_kisses_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_imba_snapfire_mortimer_kisses_debuff:GetModifierMoveSpeedBonus_Percentage() return self.slow end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_snapfire_mortimer_kisses_debuff:OnIntervalThink()
	-- apply damage
	ApplyDamage( self.damageTable )
	-- play overhead
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_snapfire_mortimer_kisses_debuff:GetEffectName() return "particles/units/heroes/hero_snapfire/hero_snapfire_burn_debuff.vpcf" end
function modifier_imba_snapfire_mortimer_kisses_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_snapfire_mortimer_kisses_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_snapfire_magma.vpcf" end
function modifier_imba_snapfire_mortimer_kisses_debuff:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL end

--------------------------------------------------------------------------------
modifier_imba_snapfire_mortimer_kisses_thinker = class({})
--------------------------------------------------------------------------------
-- Classifications
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_snapfire_mortimer_kisses_thinker:OnCreated( kv )
	-- references
	self.max_travel = self:GetAbility():GetSpecialValueFor( "max_lob_travel_time" )
	self.radius = self:GetAbility():GetSpecialValueFor( "impact_radius" )
	self.linger = self:GetAbility():GetSpecialValueFor( "burn_linger_duration" )

	if not IsServer() then return end

	-- dont start aura right off
	self.start = false

	-- create aoe finder particle
	self:PlayEffects( kv.travel_time )
end

function modifier_imba_snapfire_mortimer_kisses_thinker:OnRefresh( kv )
	-- references
	self.max_travel = self:GetAbility():GetSpecialValueFor( "max_lob_travel_time" )
	self.radius = self:GetAbility():GetSpecialValueFor( "impact_radius" )
	self.linger = self:GetAbility():GetSpecialValueFor( "burn_linger_duration" )

	if not IsServer() then return end

	-- start aura
	self.start = true

	-- stop aoe finder particle
	self:StopEffects()
end

function modifier_imba_snapfire_mortimer_kisses_thinker:OnRemoved()
end

function modifier_imba_snapfire_mortimer_kisses_thinker:OnDestroy()
	if not IsServer() then return end
	self:StopEffects()
	self:GetParent():RemoveSelf()
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_imba_snapfire_mortimer_kisses_thinker:IsAura() return self.start end
function modifier_imba_snapfire_mortimer_kisses_thinker:GetModifierAura()
	return "modifier_imba_snapfire_mortimer_kisses_debuff"
end

function modifier_imba_snapfire_mortimer_kisses_thinker:GetAuraRadius() return self.radius end
function modifier_imba_snapfire_mortimer_kisses_thinker:GetAuraDuration() return self.linger end
function modifier_imba_snapfire_mortimer_kisses_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_snapfire_mortimer_kisses_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_snapfire_mortimer_kisses_thinker:PlayEffects( time )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"
	--if not time or time == nil then  time = 0.3 end
	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius*(self.max_travel/time) ) )
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( time , 0, 0 ) )
end

function modifier_imba_snapfire_mortimer_kisses_thinker:StopEffects()
	ParticleManager:DestroyParticle( self.effect_cast, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end