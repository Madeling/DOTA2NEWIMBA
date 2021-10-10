--------------------------------------------------------------
--					IMBA_RIKI_POISON_DART            		--
--------------------------------------------------------------

imba_riki_poison_dart = class({})
LinkLuaModifier("modifier_imba_riki_poison_dart_sleeping", "mb/hero_riki/riki_poison_dart", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_riki_poison_dart_debuff", "mb/hero_riki/riki_poison_dart", LUA_MODIFIER_MOTION_NONE)

-- Ability Cast Filter
function imba_riki_poison_dart:CastFilterResultTarget( hTarget )
	if IsServer() and hTarget:IsChanneling() then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function imba_riki_poison_dart:GetCustomCastErrorTarget( hTarget )
	if IsServer() and hTarget:IsChanneling() then
		return "#dota_hud_error_is_channeling"
	end

	return ""
end

function imba_riki_poison_dart:OnInventoryContentsChanged()
	--魔晶技能
	---------------------------------------------------------------
	local caster=self:GetCaster()
	if self:GetCaster():Has_Aghanims_Shard() then 
        TG_Set_Scepter(caster,false,1,"imba_riki_poison_dart")
    else
        TG_Set_Scepter(caster,true,1,"imba_riki_poison_dart")
    end
	---------------------------------------------------------------
end
function imba_riki_poison_dart:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_riki/riki_shard_sleeping_dart.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_riki/riki_shard_sleeping_dart_cast.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_riki.vsndevts", context )
end
function imba_riki_poison_dart:GetAbilityTextureName()	
	if self:GetCaster():HasModifier("modifier_imba_riki_mode_switch") then  
		local mode_type = self:GetCaster():GetModifierStackCount("modifier_imba_riki_mode_switch", nil) or 1
		--返回对应技能图标
		return "riki/riki_poison_dart"..mode_type
	else
		return "riki/riki_poison_dart1"
	end 
end

--------------------------------------------------------------------------------
-- Ability Start
function imba_riki_poison_dart:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local projectile_name = "particles/units/heroes/hero_riki/riki_shard_sleeping_dart.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
	local poison_dart_count = self:GetSpecialValueFor( "poison_dart_count" )
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
	local sound_cast = "Hero_Riki.SleepDart.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() ) 
	-- Play Effect
	self:PlayEffects1()
	-- NIGHT
	local modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_riki_mode_switch", caster)	
	if modifier == nil or modifier:GetStackCount() == 1 then 
		aoe = self:GetSpecialValueFor("radius") + self:GetSpecialValueFor("bouns_radius")
		-- find units
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self:GetCastRange(caster:GetOrigin(),target),	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		local enemy_count = 0 
		for _,unit in pairs(units) do
			-- dart!!!
			if IsEnemy(caster, unit) then
				if enemy_count <= poison_dart_count then 
					enemy_count = enemy_count + 1 
					info.Target = unit
					ProjectileManager:CreateTrackingProjectile(info)
				end
			else
				info.Target = unit
				ProjectileManager:CreateTrackingProjectile(info)
			end
		end
	end
end
--------------------------------------------------------------------------------
-- Projectile
function imba_riki_poison_dart:OnProjectileHit( target, location )
	if not target or target:TG_TriggerSpellAbsorb(self) or target:IsMagicImmune() then return end

	if target:IsChanneling() or target:IsOutOfGame() then return end

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
	-- Play sound
	local sound_cast = "Hero_Riki.SleepDart.Target"
	EmitSoundOn( sound_cast, target )
	-- Sleeping
	target:AddNewModifier_RS( self:GetCaster(), self, "modifier_imba_riki_poison_dart_sleeping", { duration = duration } )
end

--------------------------------------------------------------------------------
function imba_riki_poison_dart:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_riki/riki_shard_sleeping_dart_cast.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 60, Vector( 0, 255, 0) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 1, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

--------------------------------------------------------------
--		   MODIFIER_IMBA_RIKI_POISON_DART_SLEEPING          --
--------------------------------------------------------------
--Sleeping
modifier_imba_riki_poison_dart_sleeping = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_riki_poison_dart_sleeping:IsHidden() return false end
function modifier_imba_riki_poison_dart_sleeping:IsDebuff() return true end
function modifier_imba_riki_poison_dart_sleeping:IsPurgable() return false end
function modifier_imba_riki_poison_dart_sleeping:IsPurgeException() return true  end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_riki_poison_dart_sleeping:OnDestroy()
	--Wake Up 
	if IsServer() then 
		self:GetParent():AddNewModifier_RS( self:GetCaster(), self:GetAbility(), "modifier_imba_riki_poison_dart_debuff", { duration = self:GetAbility():GetSpecialValueFor( "debuff_duration" ) } )
	end
end

function modifier_imba_riki_poison_dart_sleeping:CheckState()
    return
     {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_NIGHTMARED] = true, 
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_STUNNED] = true, 
    } 
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_riki_poison_dart_sleeping:GetEffectAttachType()	return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_riki_poison_dart_sleeping:GetEffectName() return "particles/generic_gameplay/generic_sleep.vpcf" end

--------------------------------------------------------------
--		   MODIFIER_IMBA_RIKI_POISON_DART_DEBUFF            --
--------------------------------------------------------------
--DEBUFF
modifier_imba_riki_poison_dart_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_riki_poison_dart_debuff:IsHidden() return false end
function modifier_imba_riki_poison_dart_debuff:IsDebuff() return true end
function modifier_imba_riki_poison_dart_debuff:IsPurgable() return true end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_riki_poison_dart_debuff:OnCreated( kv )
	-- references  
	self.movement_slow = -self:GetAbility():GetSpecialValueFor( "movement_slow" ) -- 移速
	if IsServer() then	
		self.ability = self:GetAbility()
		self.caster = self.ability:GetCaster()
		self.parent = self:GetParent()
		if self:GetCaster():HasModifier("modifier_imba_riki_mode_switch") then 
			if self:GetCaster():GetModifierStackCount("modifier_imba_riki_mode_switch", self:GetCaster()) == 3 then 
				-- begin delay
				self:StartIntervalThink( 1.0 )
			end
		end
	end
end

function modifier_imba_riki_poison_dart_debuff:OnRefresh( kv )
	-- references
	self.movement_slow = -self:GetAbility():GetSpecialValueFor( "movement_slow" ) -- 移速
end

function modifier_imba_riki_poison_dart_debuff:OnIntervalThink()
	if self.caster:HasModifier("modifier_imba_riki_backstab_passive") then 
		self.caster:FindModifierByNameAndCaster("modifier_imba_riki_backstab_passive",self.caster):Poisoned_BonusDamage(self.parent:entindex())
	end
end
function modifier_imba_riki_poison_dart_debuff:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_riki_poison_dart_debuff:CheckState()
	if self:GetCaster():HasModifier("modifier_imba_riki_mode_switch") then 
		if self:GetCaster():GetModifierStackCount("modifier_imba_riki_mode_switch", self:GetCaster()) == 2 then
			local state = {[MODIFIER_STATE_PROVIDES_VISION] = true}
			if self:GetParent():HasModifier("modifier_slark_shadow_dance") then
				return state
			end
			--显影
			state = {[MODIFIER_STATE_PROVIDES_VISION] = true,
				[MODIFIER_STATE_INVISIBLE] = false}
			return state
		end
	end
end
function modifier_imba_riki_poison_dart_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
	return funcs
end
function modifier_imba_riki_poison_dart_debuff:GetModifierMoveSpeedBonus_Percentage() return self.movement_slow end
function modifier_imba_riki_poison_dart_debuff:GetModifierPercentageCasttime() return self.movement_slow end
function modifier_imba_riki_poison_dart_debuff:GetModifierProvidesFOWVision() 
	if self:GetCaster():HasModifier("modifier_imba_riki_mode_switch") then 
		if self:GetCaster():GetModifierStackCount("modifier_imba_riki_mode_switch", self:GetCaster()) == 2 then  
			local state = {[MODIFIER_STATE_PROVIDES_VISION] = true}
			if not self:GetParent():HasModifier("modifier_slark_shadow_dance") then
				return 1 
			else
				return 0
			end
		end
	end
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_riki_poison_dart_debuff:OnDestroy()
	self.movement_slow = nil
	self:PlayEffects1()
end
function modifier_imba_riki_poison_dart_debuff:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_riki/riki_shard_sleeping_dart_cast.vpcf"
	-- Play sound
	local sound_cast = "Hero_Riki.SleepDart.Damage"
	EmitSoundOn( sound_cast, self:GetParent() )
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(effect_cast, false, false, 15, false, false)
	--ParticleManager:ReleaseParticleIndex( effect_cast )
end