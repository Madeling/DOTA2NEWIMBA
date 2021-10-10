-- Editors:
-- MysticBug, 25.09.2021
------------------------------------------------------------
--		   		 MONSTER_KILLER_HOLY_WATER_BULLET         --
------------------------------------------------------------
monster_killer_holy_water_bullet = class({})

LinkLuaModifier( "modifier_monster_killer_holy_water_bullet", "mb/monster_killer/monster_killer_holy_water_bullet", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Phase Start
function monster_killer_holy_water_bullet:OnAbilityPhaseStart()
	local caster = self:GetCaster()

	-- play effects
	local sound_cast = "Ability.AssassinateLoad"
	EmitSoundOnClient( sound_cast, caster:GetPlayerOwner() )

	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function monster_killer_holy_water_bullet:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local projectile_name = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf"
	local projectile_speed = self:GetSpecialValueFor("projectile_speed")

	local info = {
		Target = target,
		Source = caster,
		Ability = self,

		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
		ExtraData = { }
	}
	ProjectileManager:CreateTrackingProjectile(info)

	-- effects
	local sound_cast = "Hero_Sniper.MKG_attack"
	EmitSoundOn( sound_cast, caster )
	local sound_target = "Hero_Sniper.AssassinateProjectile"
	EmitSoundOn( sound_cast, target )
end
--------------------------------------------------------------------------------
-- Projectile
function monster_killer_holy_water_bullet:OnProjectileHit_ExtraData( target, location, extradata )
	-- cancel if gone
	if (not target) or target:IsInvulnerable() or target:IsOutOfGame() or target:TriggerSpellAbsorb( self ) then
		return
	end
	local caster = self:GetCaster()
	-- apply damage
	local damage = self:GetAbilityDamage()
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self, --Optional.
	}
	local damage_calculate = ApplyDamage(damageTable)
	-- overhead event
	SendOverheadEventMessage(
		nil, --DOTAPlayer sendToPlayer,
		OVERHEAD_ALERT_CRITICAL,
		target,
		damage_calculate,
		caster:GetPlayerOwner() -- DOTAPlayer sourcePlayer
	)
	-- Attack Once
	caster:PerformAttack(target, false, true, true, false, false, false, false)
	-- short stun
	target:Interrupt()

	if target:IsRealHero() then
		local debuff_duration = self:GetSpecialValueFor("debuff_duration")

		local modifier = target:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_monster_killer_holy_water_bullet", -- modifier name
			{ duration = debuff_duration } -- kv
		)
	end
	-- AOE
	if caster:HasModifier("modifier_monster_killer_shapeshift_buff") then
		local aoe_radius = self:GetSpecialValueFor("radius")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, aoe_radius , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if enemy:IsAlive() and enemy ~= target then
				--attack once
				caster:PerformAttack(enemy, false, true, true, false, false, false, false)
				damageTable.victim = enemy
				damageTable.damage_type =  DAMAGE_TYPE_PHYSICAL
				ApplyDamage(damageTable)
			end
		end
		-- effects2 血箭特效
		self:PlayEffects(target)
		-- effects1
		local sound_cast = "Hero_LifeStealer.Consume"
		EmitSoundOn( sound_cast, target )
	else
		-- effects1
		local sound_cast = "Hero_Sniper.AssassinateDamage"
		EmitSoundOn( sound_cast, target )
	end
end

function monster_killer_holy_water_bullet:PlayEffects(hTarget)
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, hTarget)
    ParticleManager:ReleaseParticleIndex(effect_cast)
end
----------------------------------------------------------
--	    MODIFIER_MONSTER_KILLER_HOLY_WATER_BULLET       --
----------------------------------------------------------

modifier_monster_killer_holy_water_bullet = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_monster_killer_holy_water_bullet:IsHidden() return false end
function modifier_monster_killer_holy_water_bullet:IsDebuff() return true end
function modifier_monster_killer_holy_water_bullet:IsPurgable() return false end
--function modifier_monster_killer_holy_water_bullet:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--------------------------------------------------------------------------------
-- Initializations
function modifier_monster_killer_holy_water_bullet:OnCreated( kv )
	--refer
	self.incoming_damage = self:GetAbility():GetSpecialValueFor("incoming_damage")
	if IsServer() then
		self:PlayEffects()
	end
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_monster_killer_holy_water_bullet:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end
function modifier_monster_killer_holy_water_bullet:GetModifierProvidesFOWVision() return true end
function modifier_monster_killer_holy_water_bullet:GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then return end
	return self.incoming_damage
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_monster_killer_holy_water_bullet:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}
	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_monster_killer_holy_water_bullet:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_sniper/sniper_crosshair.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber() )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		true
	)
end