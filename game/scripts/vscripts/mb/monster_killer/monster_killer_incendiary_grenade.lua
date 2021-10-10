-- Editors:
-- MysticBug, 25.09.2021
--Abilities
monster_killer_incendiary_grenade = class({})

LinkLuaModifier( "modifier_monster_killer_incendiary_grenade_thinker", "mb/monster_killer/monster_killer_incendiary_grenade.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_monster_killer_incendiary_grenade_debuff", "mb/monster_killer/monster_killer_incendiary_grenade.lua", LUA_MODIFIER_MOTION_NONE )

function monster_killer_incendiary_grenade:IsHiddenWhenStolen() 	return false end
function monster_killer_incendiary_grenade:IsRefreshable() 		return true  end
function monster_killer_incendiary_grenade:IsStealable() 		return true  end
function monster_killer_incendiary_grenade:Set_InitialUpgrade() 		return {LV=1,CD=true}  end
--------------------------------------------------------------------------------
-- Ability Start
function monster_killer_incendiary_grenade:OnSpellStart()
	local caster      = self:GetCaster()
	local pos         = self:GetCursorPosition()
	local distance    = (pos - caster:GetAbsOrigin()):Length2D()
	local direction   = (pos - caster:GetAbsOrigin()):Normalized()
	      direction.z = 0
	local projectile_name	= "particles/heroes/monster_killer/monster_killer_incendiary_grenade.vpcf"
	--thinker
	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_monster_killer_incendiary_grenade_thinker", -- modifier name
		{ travel_time = 0.3 }, -- kv
		pos,
		caster:GetTeamNumber(),
		false
	)

	-- precache projectile
	local info = {
		Target = thinker,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = (caster:IsRangedAttacker() and caster:GetProjectileSpeed() or 900),
		bDodgeable = false,                           -- Optional
	
		vSourceLoc = caster:GetOrigin(),                -- Optional (HOW)
		
		bDrawsOnMinimap = false,                          -- Optional
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = 100,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	}
	-- launch projectile
	ProjectileManager:CreateTrackingProjectile( info )
	
	--[[local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = distance,
	    fStartRadius = 250,
	    fEndRadius = 250,
		vVelocity = direction  * (caster:IsRangedAttacker() and caster:GetProjectileSpeed() or 900),
	
		bProvidesVision = true,
		iVisionRadius = 100,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}
	-- launch projectile
	ProjectileManager:CreateLinearProjectile(info)]]

	-- create FOW
	AddFOWViewer( caster:GetTeamNumber(), thinker:GetOrigin(), 100, 1, false )

	-- play sound
	local sound_cast = "Hero_Batrider.Flamebreak"
	EmitSoundOn( sound_cast, thinker )
end

function monster_killer_incendiary_grenade:OnProjectileHit( target, location )
	if not target then return end
		
	local damageTable = {
		--victim = enemy,
		attacker = self:GetCaster(),
		damage = self:GetSpecialValueFor("damage"),
		damage_type = self:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self, --Optional.
	} 
	local grenade_radius = self:GetSpecialValueFor("radius")
	--AOE Damage
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, grenade_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy:IsAlive() then 
			damageTable.victim = enemy
			ApplyDamage(damageTable)
		end
	end
	-- start aura on thinker
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_monster_killer_incendiary_grenade_thinker", -- modifier name
		{
			duration = self:GetSpecialValueFor("debuff_duration"),
			slow = 1
		} -- kv
	)
	-- play effects
	self:PlayEffects( target:GetOrigin() )
end

--------------------------------------------------------------------------------
function monster_killer_incendiary_grenade:PlayEffects( loc )
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
	local sound_location = "Hero_Batrider.Flamebreak.Impact"
	EmitSoundOnLocationWithCaster( loc, sound_location, self:GetCaster() )
end
--------------------------------------------------------------
--     MODIFIER_monster_killer_incendiary_grenade_DEBUFF    --
--------------------------------------------------------------
--------------------------------------------------------------------------------
modifier_monster_killer_incendiary_grenade_thinker = class({})
--------------------------------------------------------------------------------
-- Classifications
--------------------------------------------------------------------------------
-- Initializations
function modifier_monster_killer_incendiary_grenade_thinker:OnCreated( kv )
	-- references
	self.max_travel = 1.0
	self.radius     = self:GetAbility():GetSpecialValueFor( "radius" )
	self.linger     = self:GetDuration()

	if not IsServer() then return end

	-- dont start aura right off
	self.start = false

	-- create aoe finder particle
	self:PlayEffects( kv.travel_time )
end

function modifier_monster_killer_incendiary_grenade_thinker:OnRefresh( kv )
	-- references
	self.max_travel = 1.0
	self.radius     = self:GetAbility():GetSpecialValueFor( "radius" )
	self.linger     = self:GetDuration()

	if not IsServer() then return end

	-- start aura
	self.start = true

	-- stop aoe finder particle
	self:StopEffects()
end

function modifier_monster_killer_incendiary_grenade_thinker:OnRemoved()
end

function modifier_monster_killer_incendiary_grenade_thinker:OnDestroy()
	if not IsServer() then return end
	self:StopEffects()
	self:GetParent():RemoveSelf()
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_monster_killer_incendiary_grenade_thinker:IsAura() return self.start end
function modifier_monster_killer_incendiary_grenade_thinker:GetModifierAura()
	return "modifier_monster_killer_incendiary_grenade_debuff"
end

function modifier_monster_killer_incendiary_grenade_thinker:GetAuraRadius() return self.radius end
function modifier_monster_killer_incendiary_grenade_thinker:GetAuraDuration() return self.linger end
function modifier_monster_killer_incendiary_grenade_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_monster_killer_incendiary_grenade_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_monster_killer_incendiary_grenade_thinker:PlayEffects( time )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"
	--if not time or time == nil then  time = 0.3 end
	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius*(self.max_travel/time) ) )
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( time , 0, 0 ) )
end

function modifier_monster_killer_incendiary_grenade_thinker:StopEffects()
	ParticleManager:DestroyParticle( self.effect_cast, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end


--------------------------------------------------------------
--     MODIFIER_monster_killer_incendiary_grenade_DEBUFF    --
--------------------------------------------------------------
--DEBUFF
modifier_monster_killer_incendiary_grenade_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_monster_killer_incendiary_grenade_debuff:IsHidden() return false end
function modifier_monster_killer_incendiary_grenade_debuff:IsDebuff() return true end
function modifier_monster_killer_incendiary_grenade_debuff:IsPurgable() return true end
--------------------------------------------------------------------------------
-- Initializations
function modifier_monster_killer_incendiary_grenade_debuff:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "incendiary_damage" ) -- special value
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow" ) -- special value

	local interval = 1
	self.caster = self:GetAbility():GetCaster()

	if IsServer() then
		-- precache damage
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self.caster,
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}

		-- start interval
		self:StartIntervalThink( interval )
		self:OnIntervalThink()
	end
end

function modifier_monster_killer_incendiary_grenade_debuff:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_monster_killer_incendiary_grenade_debuff:GetEffectName() return "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_burn.vpcf" end
function modifier_monster_killer_incendiary_grenade_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_monster_killer_incendiary_grenade_debuff:ShouldUseOverheadOffset() return true end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_monster_killer_incendiary_grenade_debuff:OnIntervalThink()
	-- if self.caster:IsAlive() then
		ApplyDamage(self.damageTable)
	-- end
end
--------------------------------------------------------------------------------
-- Graphics & Animations
