--2020 12 25 by MysticBug-------
--------------------------------
--------------------------------

--------------------------------------------------------------
--		   		 IMBA_SLARK_DARK_PACT                	    --
--------------------------------------------------------------
CreateTalents("npc_dota_hero_slark", "mb/hero_slark")
imba_slark_dark_pact = class({})

LinkLuaModifier( "modifier_imba_slark_dark_pact", "mb/hero_slark", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_slark_dark_pact_buff", "mb/hero_slark", LUA_MODIFIER_MOTION_NONE )

function imba_slark_dark_pact:IsHiddenWhenStolen() 		return false end
function imba_slark_dark_pact:IsRefreshable() 			return true end
function imba_slark_dark_pact:IsStealable() 				return true end
function imba_slark_dark_pact:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slark/slark_dark_pact_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/slark/slark_head_immortal/slark_head_immortal_start.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/slark/slark_head_immortal/slark_immortal_dark_pact_pulses.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context )
end
function imba_slark_dark_pact:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- Add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_slark_dark_pact", -- modifier name
		{} -- kv
	)
end

--------------------------------------------------------------
--		  MODIFIER_IMBA_SLARK_DARK_PACT                	    --
--------------------------------------------------------------

modifier_imba_slark_dark_pact = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_slark_dark_pact:IsHidden() return true end
function modifier_imba_slark_dark_pact:IsDebuff() return false end
function modifier_imba_slark_dark_pact:IsPurgable() return false end
function modifier_imba_slark_dark_pact:DestroyOnExpire() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_slark_dark_pact:OnCreated( kv )
	-- references
	self.delay_time = self:GetAbility():GetSpecialValueFor( "delay" )
	self.pulse_duration = self:GetAbility():GetSpecialValueFor( "pulse_duration" )
	self.total_pulses = self:GetAbility():GetSpecialValueFor( "total_pulses" )
	self.total_damage = self:GetAbility():GetSpecialValueFor( "total_damage" ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_slark_2")
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	-- generate data
	self.delay = true
	self.count = 0
	self.damage = self.total_damage/self.total_pulses

	-- Start interval
	if IsServer() then
		-- Precache damageTable	 
		self.damageTable = {
			-- victim = target,
			attacker = self:GetParent(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}

		-- begin delay
		self:StartIntervalThink( self.delay_time )

		-- play effects
		self:PlayEffects1()

		-- IMBA 1.damage 5% -> attack
		self:GetCaster():AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_imba_slark_dark_pact_buff", -- modifier name
			{ duration = self:GetAbility():GetSpecialValueFor("damage_shift_duration")} -- kv
		)
	end
end

function modifier_imba_slark_dark_pact:OnRefresh( kv )
	-- references
	self.delay_time = self:GetAbility():GetSpecialValueFor( "delay" )
	self.pulse_duration = self:GetAbility():GetSpecialValueFor( "pulse_duration" )
	self.total_pulses = self:GetAbility():GetSpecialValueFor( "total_pulses" )
	self.total_damage = self:GetAbility():GetSpecialValueFor( "total_damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	-- generate data
	self.delay = true
	self.count = 0
	self.damage = self.total_damage/self.total_pulses

	-- Start interval
	if IsServer() then
		-- Precache damageTable	 
		self.damageTable = {
			-- victim = target,
			attacker = self:GetParent(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}

		-- begin delay
		self:StartIntervalThink( self.delay_time )

		-- play effects
		self:PlayEffects1()

		-- IMBA 1.damage 5% -> attack
		self:GetCaster():AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_imba_slark_dark_pact_buff", -- modifier name
			{duration = self:GetAbility():GetSpecialValueFor("damage_shift_duration")} -- kv
		)
	end
end

function modifier_imba_slark_dark_pact:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_slark_dark_pact:OnIntervalThink()
	if self.delay then
		self.delay = false
		-- start pulse
		self:StartIntervalThink( self.pulse_duration/self.total_pulses )

		-- play effects
		self:PlayEffects2()
	else
		-- Find Units in Radius
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- aoe damage
		self.damageTable.damage = self.damage
		self.damageTable.damage_flags = 0
		for _,enemy in pairs(enemies) do
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
		end

		-- Purge   Strong Dispel
		self:GetParent():Purge( false, true, false, true, true )

		-- self damage
		self.damageTable.damage = self.damage/2
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
		self.damageTable.victim = self:GetParent()
		-- IMBA 2.only damage self in daytime 
		if GameRules:IsDaytime() then 
			ApplyDamage( self.damageTable )
		end

		-- Counter
		self.count = self.count + 1
		if self.count>=self.total_pulses then
			self:StartIntervalThink( -1 )
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_slark_dark_pact:PlayEffects1()
	--local particle_cast = "particles/units/heroes/hero_slark/slark_dark_pact_start.vpcf"
	--local sound_cast = "Hero_Slark.DarkPact.PreCast"
	local particle_cast = "particles/econ/items/slark/slark_head_immortal/slark_head_immortal_start.vpcf"
	local sound_cast = "Hero_Slark.DarkPact.PreCast.Immortal"

	-- play particle
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetTeamNumber() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitoc",
		self:GetParent():GetOrigin(),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), sound_cast, self:GetParent() )
end

function modifier_imba_slark_dark_pact:PlayEffects2()
	--local sound_cast = "Hero_Slark.DarkPact.Cast"
	--local particle_cast = "particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf"
	local sound_cast = "Hero_Slark.DarkPact.Cast.Immortal"
	local particle_cast = "particles/econ/items/slark/slark_head_immortal/slark_immortal_dark_pact_pulses.vpcf"

	-- play particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		self:GetParent():GetOrigin(),
		true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

----------------------------------------------------------------------------------------------
--------------------------------------------------------------
--		  MODIFIER_IMBA_SLARK_PACT_BUFF                	    --
--------------------------------------------------------------

modifier_imba_slark_dark_pact_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_slark_dark_pact_buff:IsHidden() return false end
function modifier_imba_slark_dark_pact_buff:IsDebuff() return false end
function modifier_imba_slark_dark_pact_buff:IsPurgable() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_slark_dark_pact_buff:OnCreated()
	-- references
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_slark_dark_pact_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_imba_slark_dark_pact_buff:GetModifierBaseAttack_BonusDamage()
	if not IsServer() then return end
	return self:GetStackCount()
end

function modifier_imba_slark_dark_pact_buff:OnTakeDamage(keys)
	if keys.unit == self:GetParent() and keys.damage >= 20 then
		self:SetStackCount(self:GetStackCount() + keys.damage * self:GetAbility():GetSpecialValueFor("damage_shift_pct") / 100)
	end
end
--------------------------------------------------------------------------------

--------------------------------------------------------------
--		 			IMBA_SLARK_POUNCE                	    --
--------------------------------------------------------------

imba_slark_pounce = class({})
LinkLuaModifier("modifier_imba_slark_pounce", "mb/hero_slark", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_imba_slark_pounce_debuff", "mb/hero_slark", LUA_MODIFIER_MOTION_NONE)

function imba_slark_pounce:IsHiddenWhenStolen() 		return false end
function imba_slark_pounce:IsRefreshable() 			return true end
function imba_slark_pounce:IsStealable() 				return true end
function imba_slark_pounce:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slark/slark_pounce_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slark/slark_pounce_trail.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slark/slark_pounce_ground.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slark/slark_pounce_leash.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_start_gold.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_trail_gold.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_gold_ground.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_leash_gold.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context )
end
function imba_slark_pounce:OnInventoryContentsChanged()
	if self:GetCaster():HasScepter() then
		--奇怪的BUG FUCK
		self:OnUpgrade()
	else
		self:OnUpgrade()
	end
end

function imba_slark_pounce:OnUpgrade()
	--充能设置
	if not AbilityChargeController:IsChargeTypeAbility(self) then
		AbilityChargeController:AbilityChargeInitialize(self, self:GetSpecialValueFor("charge_restore_time"), 1, 1, true, true)
	else
		if self:GetCaster():HasScepter() then 
			AbilityChargeController:ChangeChargeAbilityConfig(self, self:GetSpecialValueFor("charge_restore_time"), self:GetSpecialValueFor("max_charges"), 1, true, true)
		else
			AbilityChargeController:ChangeChargeAbilityConfig(self, self:GetSpecialValueFor("charge_restore_time"), 1, 1, true, true)
		end	
	end
end
function imba_slark_pounce:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	-- load data
	local pounce_distance = self:GetSpecialValueFor("pounce_distance")
	local pounce_speed = self:GetSpecialValueFor("pounce_speed")
	-- self.pounce_acceleration	= self:GetSpecialValueFor("pounce_acceleration") --不知道用在那个地方？
	local pounce_radius	= self:GetSpecialValueFor("pounce_radius")
	local leash_duration = self:GetSpecialValueFor("leash_duration") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_slark_1")
	local leash_radius = self:GetSpecialValueFor("leash_radius")
	if self:GetCaster():HasScepter() then 
		pounce_distance = self:GetSpecialValueFor("pounce_distance_scepter")
	end
	local jump_duration	= pounce_distance / pounce_speed
	local jump_height = 208
	local leash_count = self:GetSpecialValueFor("leash_count")

	-- Add modifier
	local pounce_handle = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_slark_pounce", -- modifier name
		{
			distance = pounce_distance,
			height = jump_height,
			duration = jump_duration,
			pounce_radius = pounce_radius,
			leash_duration = leash_duration,
			leash_radius = leash_radius,
			direction_x = caster:GetForwardVector().x,
			direction_y = caster:GetForwardVector().y,
			IsFreeControll = true,
		} -- kv
	)
	
	-- on landing
	local callback = function()
		if GameRules:IsDaytime() then 
			--nothing
		else
			-- find enemies
			local enemies = FindUnitsInRadius(
				self:GetCaster():GetTeamNumber(),	-- int, your team number
				self:GetCaster():GetOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				leash_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO,	-- int, type filter
				0,	-- int, flag filter
				0,	-- int, order filter
				false	-- bool, can grow cache
			)
			local enemy_count = 0 
			for _,enemy in pairs(enemies) do
				-- leash 
				enemy:AddNewModifier_RS(
					self:GetCaster(), -- player source
					self, -- ability source
					"modifier_imba_slark_pounce_debuff", -- modifier name
					{ 
						duration = leash_duration ,
						leash_radius = leash_radius ,
					} -- kv
				)
				enemy_count = enemy_count +1 
				if enemy_count >= leash_count then
					break
				end
			end
			-- play effects
			-- play sound
		end
	end
	--IMBA extra leash 2 targets
	pounce_handle:SetEndCallback( callback )
	-- play effects
	self:PlayEffects1()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function imba_slark_pounce:PlayEffects1()
	--local particle_cast = "particles/units/heroes/hero_slark/slark_pounce_start.vpcf"
	--local sound_cast = "Hero_Slark.Pounce.Cast"
	local particle_cast = "particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_start_gold.vpcf"
	local sound_cast = "Hero_Slark.Pounce.Cast.Immortal"

	-- play particle
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitoc",
		self:GetCaster():GetOrigin(),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- play sound
	EmitSoundOnLocationForAllies( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

--------------------------------------------------------------
--		  MODIFIER_IMBA_SLARK_POUNCE                	    --
--------------------------------------------------------------

modifier_imba_slark_pounce = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_slark_pounce:IsHidden() return true end
function modifier_imba_slark_pounce:IsDebuff() return false end
function modifier_imba_slark_pounce:IsPurgable() return false end
--function modifier_imba_slark_pounce:DestroyOnExpire() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_slark_pounce:OnCreated(kv)
	if IsServer() then 
	-- references
		self.distance = kv.distance or 0
		self.height = kv.height or -1
		self.duration = kv.duration or 0
		self.pounce_radius = kv.pounce_radius or 1
		self.leash_duration = kv.leash_duration or 0
		self.leash_radius = kv.leash_radius or 0
		if kv.direction_x and kv.direction_y then
			self.direction = Vector(kv.direction_x,kv.direction_y,0):Normalized()
		else
			self.direction = -(self:GetParent():GetForwardVector())
		end
		self.tree = 100 or self:GetParent():GetHullRadius()

		if kv.IsFreeControll then self.freecontroll = kv.IsFreeControll==1 else self.freecontroll = true end

		self.freecontroll_commands = {
			[DOTA_UNIT_ORDER_MOVE_TO_POSITION] 	= true,
			[DOTA_UNIT_ORDER_MOVE_TO_TARGET] 	= true,
			[DOTA_UNIT_ORDER_ATTACK_MOVE] 		= true,
			[DOTA_UNIT_ORDER_ATTACK_TARGET] 	= true,
			[DOTA_UNIT_ORDER_CAST_POSITION]		= true,
			[DOTA_UNIT_ORDER_CAST_TARGET]		= true,
			[DOTA_UNIT_ORDER_CAST_TARGET_TREE]	= true,
		}

		-- check duration
		if self.duration == 0 then
			self:Destroy()
			return
		end

		-- load data
		self.parent = self:GetParent()
		self.origin = self.parent:GetOrigin()

		-- horizontal init
		self.hVelocity = self.distance/self.duration

		-- vertical init
		local half_duration = self.duration/2
		self.gravity = 2*self.height/(half_duration*half_duration)
		self.vVelocity = self.gravity*half_duration

		-- apply motion controllers
		if self.distance>0 then
			if self:ApplyHorizontalMotionController() == false then 
				self:Destroy()
				return
			end
		end
		if self.height>=0 then
			if self:ApplyVerticalMotionController() == false then 
				self:Destroy()
				return
			end
		end
	end
end

function modifier_imba_slark_pounce:OnRefresh( kv ) if not IsServer() then return end end
function modifier_imba_slark_pounce:OnDestroy( kv )
	if not IsServer() then return end

	if not self.interrupted then
		-- destroy trees
		if self.tree>0 then
			GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.tree, true )
		end
	end

	if self.EndCallback then
		self.EndCallback( self.interrupted )
	end

	self:GetParent():InterruptMotionControllers( true )	
	--self:GetParent():RemoveHorizontalMotionController(self)
	--self:GetParent():RemoveVerticalMotionController(self)
	
	--Slark Gesture
	if self:GetCaster():GetName() == "npc_dota_hero_slark" then
		self:GetCaster():FadeGesture(ACT_DOTA_SLARK_POUNCE)
	end
end

--------------------------------------------------------------------------------
-- Setter
function modifier_imba_slark_pounce:SetEndCallback( func ) 
	self.EndCallback = func
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_slark_pounce:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_ORDER,
	}

	return funcs
end
function modifier_imba_slark_pounce:GetActivityTranslationModifiers() return "latch" end
function modifier_imba_slark_pounce:OnOrder(keys)
	if keys.unit == self:GetParent() and self.freecontroll == true then
		if self.freecontroll_commands[keys.order_type] then
			if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION and keys.new_pos then
				self.redirect_pos = keys.new_pos
			elseif keys.target then
				self.redirect_pos = keys.target:GetAbsOrigin()
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_imba_slark_pounce:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_imba_slark_pounce:UpdateHorizontalMotion( me, dt )
	local parent = self:GetParent()
	--Redirection FreeControll
	if self.redirect_pos then 
		self.direction = (self.redirect_pos - parent:GetAbsOrigin()):Normalized()
	end
	-- set position
	local target_pos = self.direction*self.distance*(dt/self.duration)

	-- leash something?
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(), 
		self:GetParent():GetAbsOrigin(), 
		nil, 
		self.pounce_radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, 
		false)

	for _, enemy in pairs(enemies) do
		if enemy:IsRealHero() or enemy:IsClone() or enemy:IsTempestDouble() then
			--enemy:EmitSound("Hero_Slark.Pounce.Impact")
			enemy:EmitSound("Hero_Slark.Pounce.Impact.Immortal")
			
			enemy:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_imba_slark_pounce_debuff", {
				duration 		= self.leash_duration,
				leash_radius	= self.leash_radius
			})
			
			self:GetParent():MoveToTargetToAttack(enemy)
			
			self:Destroy()
			break
		end
	end
	-- change position
	parent:SetOrigin( parent:GetOrigin() + target_pos )
end

function modifier_imba_slark_pounce:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.interrupted = true
		self:Destroy()
	end
end

function modifier_imba_slark_pounce:UpdateVerticalMotion( me, dt )
	-- set time
	local time = dt/self.duration

	-- change height
	self.parent:SetOrigin( self.parent:GetOrigin() + Vector( 0, 0, self.vVelocity*dt ) )

	-- calculate vertical velocity
	self.vVelocity = self.vVelocity - self.gravity*dt
end

function modifier_imba_slark_pounce:OnVerticalMotionInterrupted()
	if IsServer() then
		self.interrupted = true
		self:Destroy()
	end
end
--------------------------------------------------------------------------------
-- Graphics & Animations
--function modifier_imba_slark_pounce:GetEffectName() return "particles/units/heroes/hero_slark/slark_pounce_trail.vpcf" end
function modifier_imba_slark_pounce:GetEffectName() return "particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_trail_gold.vpcf" end

---------------------------------------------------------------------------------

--------------------------------------------------------------
--		  MODIFIER_IMBA_SLARK_POUNCE_DEBUFF                	--
--------------------------------------------------------------

modifier_imba_slark_pounce_debuff = class({})

function modifier_imba_slark_pounce_debuff:IsPurgable()	return false end
function modifier_imba_slark_pounce_debuff:OnCreated(keys)
	if not IsServer() then return end
	
	self.leash_radius = keys.leash_radius
	
	-- Okay there's like no wiki information on how the formula for movespeed limit actually works so I'm going to have to fudge something pretty badly
	self.begin_slow_radius = keys.leash_radius * 80 * 0.01
	
	self.leash_position	= self:GetParent():GetAbsOrigin()
	
	--self:GetParent():EmitSound("Hero_Slark.Pounce.Leash")
	self:GetParent():EmitSound("Hero_Slark.Pounce.Leash.Immortal")
	
	--束缚特效
	self.ground_particle = ParticleManager:CreateParticle("particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_gold_ground.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(self.ground_particle, 3, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.ground_particle, 4, Vector(self.leash_radius))
	self:AddParticle(self.ground_particle, false, false, -1, false, false)
	--被束缚特效
	self.leash_particle	= ParticleManager:CreateParticle("particles/econ/items/slark/slark_ti6_blade/slark_ti6_pounce_leash_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.leash_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.leash_particle, 3, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.leash_particle, false, false, -1, false, false)
	
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_slark_pounce_debuff:OnIntervalThink()
	self.limit = 0
	self.move_speed	= self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false)
	self.limit = ((self.leash_radius - (self:GetParent():GetAbsOrigin() - self.leash_position):Length2D()) / self.leash_radius) * self.move_speed
	--为0会无效
	if self.limit == 0 then
		self.limit = - 1
	end
end

function modifier_imba_slark_pounce_debuff:OnDestroy()
	if not IsServer() then return end
	--打断某些可能挣脱的位移方式和技能
	self:GetParent():InterruptMotionControllers(true)
	--音效
	self:GetParent():StopSound("Hero_Slark.Pounce.Leash.Immortal")
	self:GetParent():EmitSound("Hero_Slark.Pounce.End")
end

function modifier_imba_slark_pounce_debuff:CheckState() return {[MODIFIER_STATE_TETHERED] = true} end
function modifier_imba_slark_pounce_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_LIMIT,MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL} end
function modifier_imba_slark_pounce_debuff:GetModifierMoveSpeed_Limit()
	if not IsServer() then return end
	--根据距离限速
	if (self:GetParent():GetAbsOrigin() - self.leash_position):Length2D() >= self.begin_slow_radius and math.abs(AngleDiff(VectorToAngles(self:GetParent():GetAbsOrigin() - self.leash_position).y, VectorToAngles(self:GetParent():GetForwardVector() ).y)) <= 85 then
		return self.limit
	end
end
function modifier_imba_slark_pounce_debuff:GetModifierProcAttack_BonusDamage_Physical( keys )
	if keys.attacker ~= self:GetCaster() then return end
	local leash_heal = self:GetAbility():GetSpecialValueFor("leash_heal_pct") * keys.target:GetHealth() / 100 
	-- overhead event
	keys.attacker:Heal( leash_heal, self:GetCaster() )
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.attacker, leash_heal, nil)
	--Heal 特效
	local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
	ParticleManager:ReleaseParticleIndex(pfx)
	-- play effects
	-- local sound_cast = "Hero_DarkWillow.Shadow_Realm.Damage"
	-- EmitSoundOn( sound_cast, self:GetParent() )
	return leash_heal
end

--------------------------------------------------------------------------------
--------------------------------------------------------------
--		   		IMBA_SLARK_ESSENCE_SHIFT                	--
--------------------------------------------------------------
imba_slark_essence_shift = class({})
LinkLuaModifier( "modifier_imba_slark_essence_shift", "mb/hero_slark", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_slark_essence_shift_debuff", "mb/hero_slark", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_imba_slark_essence_shift_stack", "mb/hero_slark", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "stack_counter", "mb/generic/stack_counter", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Passive Modifier
function imba_slark_essence_shift:GetIntrinsicModifierName() return "modifier_imba_slark_essence_shift" end
--------------------------------------------------------------
--		   MODIFIER_IMBA_SLARK_ESSENCE_SHIFT                --
--------------------------------------------------------------
modifier_imba_slark_essence_shift = class({})
local tempStack = require("mb/generic/stack_counter")
--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_slark_essence_shift:IsHidden() return self:GetStackCount() <= 0 end
function modifier_imba_slark_essence_shift:IsDebuff() return false end
function modifier_imba_slark_essence_shift:IsPurgable() return false end
function modifier_imba_slark_essence_shift:DestroyOnExpire() return false end   --maybe bug in death?
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_slark_essence_shift:OnCreated()
	-- references
	self.stacks = 0
	if not IsServer() then return end
	
	self.stack_counter = {}
	
	self:StartIntervalThink(FrameTime())
end

--[[function modifier_imba_slark_essence_shift:OnRefresh()
	-- references
	self.stacks = self:GetStackCount() or 0
end]]

function modifier_imba_slark_essence_shift:OnIntervalThink()
	Stack_RetATValue(self.stack_counter, function(i, j)
		return self.stack_counter[i].current_game_time and self.stack_counter[i].duration and GameRules:GetDOTATime(true, true) - self.stack_counter[i].current_game_time <= self.stack_counter[i].duration
	end)
	
	if #self.stack_counter ~= self:GetStackCount() then
		self:SetStackCount(#self.stack_counter)
	end
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_slark_essence_shift:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end
function modifier_imba_slark_essence_shift:GetModifierProcAttack_Feedback( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then		
		-- filter enemy
		local target = params.target
		local duration = self:GetAbility():GetSpecialValueFor( "duration" )
		if (not target:IsHero()) or target:IsIllusion() then
			return
		end
		-- Apply debuff to enemy
		local debuff = params.target:AddNewModifier(
			self:GetParent(),
			self:GetAbility(),
			"modifier_imba_slark_essence_shift_debuff",
			{
				--stack_duration = self:GetAbility():GetSpecialValueFor( "duration" ),
				--stat_loss = self:GetAbility():GetSpecialValueFor( "stat_loss" ),
			}
		)
		-- record stack duration
		table.insert(self.stack_counter, {
			current_game_time	= GameRules:GetDOTATime(true, true),
			duration = duration
		})
		-- refresh buff duration and add stacks
		self:SetDuration(duration, true)
		self:IncrementStackCount()
		self.stacks = self.stacks + 1
		-- Play effects
		self:PlayEffects( params.target )
		--------------------------------------------------------------
		-- IMBA Destroy Enemy 5% mana and shift to slark health 
		local burning_mana = self:GetAbility():GetSpecialValueFor("burning_mana_pct") * target:GetMana() / 100 
		target:SetMana(math.max(0, target:GetMana() - burning_mana))
		-- Heal 
		self:GetParent():Heal(burning_mana, self:GetAbility())
		-- Heal Effects
		local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(pfx)
	end
end

function modifier_imba_slark_essence_shift:GetModifierBonusStats_Agility() return self:GetStackCount() * self:GetAbility():GetSpecialValueFor( "agi_gain" ) end
--------------------------------------------------------------------------------
-- Helper
function modifier_imba_slark_essence_shift:OnDeath(keys)
	if keys.unit == self:GetParent() then
		--IMBA hold 1/3 agi and max to 33 stacks
		if GameRules:IsDaytime() then 
			self.stack_counter = {}
			self:SetStackCount(0)
		else
			local duration = self:GetAbility():GetSpecialValueFor( "duration" )
			local agi_hold = self.stacks * self:GetAbility():GetSpecialValueFor("agi_hold_pct") / 100 or 1
			if agi_hold >= self:GetAbility():GetSpecialValueFor("agi_hold_max") then 
				agi_hold = self:GetAbility():GetSpecialValueFor("agi_hold_max")
			end
			--print("death stacks",self.stacks,agi_hold)
			--destroy
			self.stack_counter = {}
			--add
			for i=1,agi_hold do
				-- record stack duration
				table.insert(self.stack_counter, {
					current_game_time = GameRules:GetDOTATime(true, true),
					duration = duration
				})
			end
			self:SetDuration(duration, true)
			self:SetStackCount(math.ceil(agi_hold))
		end
	end
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_slark_essence_shift:PlayEffects( target )
	--local particle_cast = "particles/units/heroes/hero_slark/slark_essence_shift.vpcf"
	local particle_cast = "particles/econ/items/slark/slark_ti6_blade/slark_ti6_blade_essence_shift_gold.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() + Vector( 0, 0, 64 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

--------------------------------------------------------------
--		MODIFIER_IMBA_SLARK_ESSENCE_SHIFT_STACK             --
--------------------------------------------------------------
--modifier_imba_slark_essence_shift_stack = class({})
--local stack_counter = require("mb/generic/stack_counter")
----------------------------------------------------------------------------------
---- Classifications
--function modifier_imba_slark_essence_shift_stack:IsHidden() return true end
--function modifier_imba_slark_essence_shift_stack:IsPurgable() return false end
--function modifier_imba_slark_essence_shift_stack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--function modifier_imba_slark_essence_shift_stack:RemoveOnDeath() return self:GetParent():IsIllusion() or GameRules:IsDaytime() end
----------------------------------------------------------------------------------
---- Initializations
--function modifier_imba_slark_essence_shift_stack:OnCreated( kv )
--	if IsServer() then
--		self.modifier = stack_counter:RetATValue( kv.modifier )
--	end
--end

--function modifier_imba_slark_essence_shift_stack:OnRemoved()
--	if IsServer() then
--		self.modifier:RemoveStack()
--	end
--end
--------------------------------------------------------------
--		MODIFIER_IMBA_SLARK_ESSENCE_SHIFT_DEBUFF            --
--------------------------------------------------------------
modifier_imba_slark_essence_shift_debuff = class({})
local tempStack = require("mb/generic/stack_counter")
--------------------------------------------------------------------------------
-- Classifications
--function modifier_imba_slark_essence_shift_debuff:DestroyOnExpire()	return self:GetParent():GetHealthPercent() > 0 end
function modifier_imba_slark_essence_shift_debuff:IsHidden() return self:GetStackCount() <= 0 end
function modifier_imba_slark_essence_shift_debuff:IsDebuff() return true end
function modifier_imba_slark_essence_shift_debuff:IsPurgable() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_slark_essence_shift_debuff:OnCreated()
	-- references
	if not self.stat_loss then
		self.stat_loss	= self:GetAbility():GetSpecialValueFor("stat_loss")
	end

	if not IsServer() then return end
	
	if not self.stack_counter then
		self.stack_counter = {}
	end
	--stack duration record
	table.insert(self.stack_counter, {
		current_game_time = GameRules:GetDOTATime(true, true),
		duration = self:GetAbility():GetSpecialValueFor( "duration" )
	})

	self:IncrementStackCount()

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_slark_essence_shift_debuff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_slark_essence_shift_debuff:OnIntervalThink()
	Stack_RetATValue(self.stack_counter, function(i, j)
		return self.stack_counter[i].current_game_time and self.stack_counter[i].duration and GameRules:GetDOTATime(true, true) - self.stack_counter[i].current_game_time <= self.stack_counter[i].duration
	end)
	
	if #self.stack_counter ~= self:GetStackCount() then
		self:SetStackCount(#self.stack_counter)
	end
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_slark_essence_shift_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		--MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_imba_slark_essence_shift_debuff:GetModifierBonusStats_Strength() return self:GetStackCount() * -self.stat_loss end
function modifier_imba_slark_essence_shift_debuff:GetModifierBonusStats_Agility() return self:GetStackCount() * -self.stat_loss end
function modifier_imba_slark_essence_shift_debuff:GetModifierBonusStats_Intellect() return self:GetStackCount() * -self.stat_loss end
--function modifier_imba_slark_essence_shift_debuff:OnTooltip() return self:GetStackCount() * -self.stat_loss end
--------------------------------------------------------------------------------
-- Helper
function modifier_imba_slark_essence_shift_debuff:OnDeath(keys)
	if keys.unit == self:GetParent() and keys.unit:GetTeamNumber() ~= keys.attacker:GetTeamNumber() and (keys.unit:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= 300 then 
		--if is slark/ essence_shift owner  --> not morphling
		if keys.attacker == self:GetCaster() and keys.attacker:HasModifier("modifier_imba_slark_essence_shift") and not keys.attacker:HasModifier("modifier_morphling_replicate") then	
			--SNK 大 肉山盾效果 不计算 
			if self:GetParent().IsReincarnating and not self:GetParent():IsReincarnating() then
				--print("kill hero by ----> ",keys.attacker:GetName() , self:GetCaster():GetName())
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_slark_essence_shift_permanent_buff", {})
				self:GetCaster():SetModifierStackCount("modifier_slark_essence_shift_permanent_buff", nil, self:GetCaster():GetModifierStackCount("modifier_slark_essence_shift_permanent_buff", nil) + 1)
			else
				self:Destroy()
			end
		--owner player
		elseif self:GetCaster():HasModifier("modifier_imba_slark_essence_shift") and not self:GetCaster():HasModifier("modifier_morphling_replicate") then 
			if self:GetParent().IsReincarnating and not self:GetParent():IsReincarnating() then
				--print("kill hero by +++++> ",keys.attacker:GetName() , self:GetCaster():GetName())
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_slark_essence_shift_permanent_buff", {})
				self:GetCaster():SetModifierStackCount("modifier_slark_essence_shift_permanent_buff", nil, self:GetCaster():GetModifierStackCount("modifier_slark_essence_shift_permanent_buff", nil) + 1)
			else
				self:Destroy()
			end
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------
--					IMBA_SLARK_FISH_BAIT            		--
--------------------------------------------------------------

imba_slark_fish_bait = class({})
LinkLuaModifier("imba_slark_fish_bait", "mb/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slark_fish_bait_buff", "mb/hero_slark", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Custom KV
--[[function imba_slark_fish_bait:GetCastPoint()
	if IsServer() and self:GetCursorTarget()==self:GetCaster() then
		return self:GetSpecialValueFor( "self_cast_delay" )
	end
	return 0.2
end]]
--------------------------------------------------------------------------------
-- Ability Cast Filter
function imba_slark_fish_bait:CastFilterResultTarget( hTarget )
	if IsServer() and hTarget:IsChanneling() then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter(
		hTarget,
		--DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function imba_slark_fish_bait:GetCustomCastErrorTarget( hTarget )
	if IsServer() and hTarget:IsChanneling() then
		return "#dota_hud_error_is_channeling"
	end

	return ""
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function imba_slark_fish_bait:OnAbilityPhaseInterrupted()

end
function imba_slark_fish_bait:OnAbilityPhaseStart()
	if self:GetCursorTarget()==self:GetCaster() then
		--self:PlayEffects1()
	end

	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function imba_slark_fish_bait:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local projectile_name = "particles/units/heroes/hero_slark/slark_shard_fish_bait.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
	local fish_bait_count = self:GetSpecialValueFor( "fish_bait_count" )
	local slow_duration = self:GetSpecialValueFor( "slow_duration" )
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

	-- Play sound   fish_bait Hero_Snapfire.FishBait.Cast
	local sound_cast = "Hero_Slark.FishBait"
	EmitSoundOn( sound_cast, self:GetCaster() ) 

	-- NIGHT
	if not GameRules:IsDaytime() then 
		--print("is dark and fish !")
		-- find units
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self:GetCastRange(caster:GetOrigin(),target),	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		local enemy_count = 0 
		for _,unit in pairs(units) do
			-- fish !!!
			if IsEnemy(caster, unit) then
				if enemy_count <= fish_bait_count then 
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
function imba_slark_fish_bait:OnProjectileHit( target, location )
	if not target then return end

	if target:IsChanneling() or target:IsOutOfGame() then return end

	-- load data
	local slow_duration = self:GetSpecialValueFor( "slow_duration" )

	-- play effects2
	-- local effect_cast = self:PlayEffects2( target )
	-- brust buff
	target:AddNewModifier( self:GetCaster(), self, "modifier_imba_slark_fish_bait_buff", { duration = slow_duration } )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_imba_slark_fish_bait_buff", { duration = slow_duration } )
end

--------------------------------------------------------------------------------
function imba_slark_fish_bait:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_slark/slark_fish_bait_slow.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

--------------------------------------------------------------
--		   MODIFIER_IMBA_SLARK_FISH_BAIT_DEBUFF             --
--------------------------------------------------------------
--鱼饵BUFF
modifier_imba_slark_fish_bait_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_slark_fish_bait_buff:IsHidden() return false end
function modifier_imba_slark_fish_bait_buff:IsDebuff() return IsEnemy(self:GetCaster(), self:GetParent()) end
function modifier_imba_slark_fish_bait_buff:IsBuff() return not IsEnemy(self:GetCaster(), self:GetParent()) end
function modifier_imba_slark_fish_bait_buff:IsStunDebuff() return false end
function modifier_imba_slark_fish_bait_buff:IsPurgable() return true end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_slark_fish_bait_buff:OnCreated( kv )
	-- references
	if IsEnemy(self:GetCaster(), self:GetParent()) then
		self.movement_speed = -self:GetAbility():GetSpecialValueFor( "movement_speed" ) -- 移速
		self.attack_speed = -self:GetAbility():GetSpecialValueFor( "attack_speed" ) -- 攻速
	else
		self.movement_speed = self:GetAbility():GetSpecialValueFor( "movement_speed" ) -- 移速
		self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" ) -- 攻速
	end
end

function modifier_imba_slark_fish_bait_buff:OnRefresh( kv )
	-- references
	if IsEnemy(self:GetCaster(), self:GetParent()) then
		self.movement_speed = -self:GetAbility():GetSpecialValueFor( "movement_speed" ) -- 移速
		self.attack_speed = -self:GetAbility():GetSpecialValueFor( "attack_speed" ) -- 攻速
	else
		self.movement_speed = self:GetAbility():GetSpecialValueFor( "movement_speed" ) -- 移速
		self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" ) -- 攻速
	end
end

function modifier_imba_slark_fish_bait_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_imba_slark_fish_bait_buff:GetModifierMoveSpeedBonus_Percentage() return self.movement_speed end
function modifier_imba_slark_fish_bait_buff:GetModifierAttackSpeedBonus_Constant() return self.attack_speed end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_slark_fish_bait_buff:GetEffectName() return "particles/units/heroes/hero_slark/slark_fish_bait_slow.vpcf" end
function modifier_imba_slark_fish_bait_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
--------------------------------------------------------------------------------

imba_slark_shadow_dance = class({})

LinkLuaModifier("modifier_imba_shadow_dance_passive", "mb/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_dance_active", "mb/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_dance_effect", "mb/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_dance_dummy", "mb/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_dance_detect", "mb/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_dance_fade", "mb/hero_slark", LUA_MODIFIER_MOTION_NONE)

function imba_slark_shadow_dance:IsHiddenWhenStolen() 		return false end
function imba_slark_shadow_dance:IsRefreshable() 			return true end
function imba_slark_shadow_dance:IsStealable() 				return true end
function imba_slark_shadow_dance:GetIntrinsicModifierName() return "modifier_imba_shadow_dance_passive" end
function imba_slark_shadow_dance:GetCooldown(i) return (self:GetCaster():HasScepter() and self:GetSpecialValueFor("scepter_cooldown") or self.BaseClass.GetCooldown(self, i)) end
function imba_slark_shadow_dance:GetCastRange() return (self:GetCaster():HasScepter() and (self:GetSpecialValueFor("scepter_aoe") - self:GetCaster():GetCastRangeBonus()) or 0) end
function imba_slark_shadow_dance:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slark/slark_shadow_dance_dummy.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slark/slark_shadow_dance_dummy_sceptor.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/slark/slark_fall20_immortal/slark_fall20_shadow_dance.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context )
end
---------------------------------------------------------------
function imba_slark_shadow_dance:OnInventoryContentsChanged()
	--魔晶技能
	---------------------------------------------------------------
	if self:GetCaster():Has_Aghanims_Shard() then 
		local shard_abi = self:GetCaster():FindAbilityByName("imba_slark_fish_bait")
		if shard_abi then 
			shard_abi:SetHidden(false)
			shard_abi:SetLevel(self:GetLevel())
		end
	else
		local shard_abi = self:GetCaster():FindAbilityByName("imba_slark_fish_bait")
		if shard_abi then 
			shard_abi:SetHidden(true)
			shard_abi:SetLevel(0)
		end
	end
	---------------------------------------------------------------
end

function imba_slark_shadow_dance:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Slark.ShadowDance")
	caster:AddNewModifier(caster, self, "modifier_imba_shadow_dance_active", {duration = self:GetSpecialValueFor("duration")})
end

modifier_imba_shadow_dance_passive = class({})

function modifier_imba_shadow_dance_passive:IsDebuff()			return false end
function modifier_imba_shadow_dance_passive:IsHidden() 			return true end
function modifier_imba_shadow_dance_passive:IsPurgable() 		return false end
function modifier_imba_shadow_dance_passive:IsPurgeException() 	return false end
function modifier_imba_shadow_dance_passive:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, MODIFIER_PROPERTY_INVISIBILITY_LEVEL,MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_shadow_dance_passive:GetModifierInvisibilityLevel()
	if self:GetStackCount() == 2 or self:GetStackCount() == 1 then
		if not self:GetParent():HasModifier("modifier_imba_shadow_dance_fade") then 
			return 1
		end
	end
	return 0
end
function modifier_imba_shadow_dance_passive:GetModifierMoveSpeedBonus_Percentage()
	if self:GetStackCount() == 4 or self:GetStackCount() == 1 then
		return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
	end
end
function modifier_imba_shadow_dance_passive:GetModifierHealthRegenPercentage()
	if self:GetStackCount() == 4 or self:GetStackCount() == 1 then
		return self:GetAbility():GetSpecialValueFor("bonus_regen_pct")
	end
end
function modifier_imba_shadow_dance_passive:CheckState()
	if self:GetStackCount() == 1 or self:GetStackCount() == 2 then
		if not self:GetParent():HasModifier("modifier_imba_shadow_dance_fade") then 
			return {[MODIFIER_STATE_INVISIBLE] = true}
		end
	end
end

function modifier_imba_shadow_dance_passive:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() then
		if self:GetStackCount() == 1 or self:GetStackCount() == 2 then 
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_shadow_dance_fade", { duration = self:GetAbility():GetSpecialValueFor("fade_time")})
		end
	end
end

function modifier_imba_shadow_dance_passive:OnCreated()
	if IsServer() then
		local dummy = CreateUnitByName("npc_dota_slark_visual", Vector(30000,30000,0), false, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() == DOTA_TEAM_GOODGUYS and DOTA_TEAM_BADGUYS or DOTA_TEAM_GOODGUYS)
		dummy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_shadow_dance_detect", {})
		--self:StartIntervalThink(0.1)
	end
end

modifier_imba_shadow_dance_active = class({})

function modifier_imba_shadow_dance_active:IsDebuff()			return false end
function modifier_imba_shadow_dance_active:IsHidden() 			return false end
function modifier_imba_shadow_dance_active:IsPurgable() 		return false end
function modifier_imba_shadow_dance_active:IsPurgeException() 	return false end
function modifier_imba_shadow_dance_active:GetPriority() return MODIFIER_PRIORITY_ULTRA + 10 end
function modifier_imba_shadow_dance_active:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end

function modifier_imba_shadow_dance_active:OnDeath(keys)
	if IsServer() and keys.unit == self:GetParent() then
		self:Destroy()
	end
end

function modifier_imba_shadow_dance_active:OnCreated()
	if IsServer() then
		--0, 1 absorigin
		--3 attach_eyeR
		--4 attach_eyeL
		--特效
		local pfx_name = "particles/units/heroes/hero_slark/slark_shadow_dance.vpcf"
		local pfx_dummy_name = "particles/units/heroes/hero_slark/slark_shadow_dance_dummy.vpcf"
		local pfx_dummy_sceptor = "particles/units/heroes/hero_slark/slark_shadow_dance_dummy_sceptor.vpcf"
		--if HeroItems:UnitHasItem(self:GetCaster(), "slark_immortal_shoulder_fall20") then
			pfx_name = "particles/econ/items/slark/slark_fall20_immortal/slark_fall20_shadow_dance.vpcf"
			--pfx_dummy_name = "particles/econ/items/slark/slark_fall20_immortal/slark_fall20_shadow_dance.vpcf"
			pfx_dummy_sceptor = "particles/econ/items/slark/slark_fall20_immortal/slark_fall20_shadow_dance.vpcf"
		--end
		local pfx = ParticleManager:CreateParticleForTeam(pfx_name, PATTACH_CUSTOMORIGIN, nil, self:GetParent():GetTeamNumber())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eyeR", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eyeL", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
		if self:GetCaster():HasScepter() then
			local pfx2 = ParticleManager:CreateParticleForTeam(pfx_dummy_sceptor, PATTACH_CUSTOMORIGIN, nil, self:GetParent():GetTeamNumber())
			ParticleManager:SetParticleControlEnt(pfx2, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx2, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			self:AddParticle(pfx2, false, false, 15, false, false)
		end
		self.pfx_dummy = CreateModifierThinker(self:GetParent(), nil, "modifier_dummy_thinker", {duration = self:GetDuration() + 0.3}, self:GetParent():GetAbsOrigin(), self:GetParent():GetTeamNumber(), false)
		local pfx_dummy = ParticleManager:CreateParticle(pfx_dummy_name, PATTACH_CUSTOMORIGIN, self.pfx_dummy)
		ParticleManager:SetParticleControlEnt(pfx_dummy, 1, self.pfx_dummy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.pfx_dummy:GetAbsOrigin(), true)
		local buff = self.pfx_dummy:FindModifierByName("modifier_dummy_thinker")
		buff:AddParticle(pfx_dummy, false, false, 15, false, false)
		if self:GetCaster():HasScepter() then
			local pfx_dummy2 = ParticleManager:CreateParticle(pfx_dummy_sceptor, PATTACH_CUSTOMORIGIN, self.pfx_dummy)
			ParticleManager:SetParticleControlEnt(pfx_dummy2, 1, self.pfx_dummy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.pfx_dummy:GetAbsOrigin(), true)
			buff:AddParticle(pfx_dummy2, false, false, 15, false, false)
		end
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_shadow_dance_active:OnRefresh()
	if IsServer() and self.pfx_dummy then
		local buff = self.pfx_dummy:FindModifierByName("modifier_dummy_thinker")
		buff:SetDuration(self:GetDuration(), false)
	end
end

function modifier_imba_shadow_dance_active:OnIntervalThink()
	if self.pfx_dummy and not self.pfx_dummy:IsNull() then
		self.pfx_dummy:SetOrigin(self:GetParent():GetAbsOrigin())
	end
end

function modifier_imba_shadow_dance_active:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Slark.ShadowDance")
		if not self.pfx_dummy:IsNull() then
			self.pfx_dummy:RemoveModifierByName("modifier_dummy_thinker")
			self.pfx_dummy = nil
		end
	end
end

function modifier_imba_shadow_dance_active:IsAura() return true end
function modifier_imba_shadow_dance_active:GetAuraDuration() return 0.1 end
function modifier_imba_shadow_dance_active:GetModifierAura() return "modifier_imba_shadow_dance_effect" end
function modifier_imba_shadow_dance_active:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("scepter_aoe") end
function modifier_imba_shadow_dance_active:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_shadow_dance_active:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_shadow_dance_active:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_imba_shadow_dance_active:GetAuraEntityReject(unit)
	if self:GetCaster():HasScepter() then
		return false
	end
	if self:GetCaster() == unit then
		return false
	end
	return true 
end

modifier_imba_shadow_dance_effect = class({})

function modifier_imba_shadow_dance_effect:IsDebuff()			return false end
function modifier_imba_shadow_dance_effect:IsHidden() 			return false end
function modifier_imba_shadow_dance_effect:IsPurgable() 		return false end
function modifier_imba_shadow_dance_effect:IsPurgeException() 	return false end
function modifier_imba_shadow_dance_effect:CheckState() return {[MODIFIER_STATE_INVISIBLE] = true, [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true ,[MODIFIER_STATE_PROVIDES_VISION] = false} end
function modifier_imba_shadow_dance_effect:DeclareFunctions() return {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION} end
function modifier_imba_shadow_dance_effect:GetModifierProvidesFOWVision() return 0 end
function modifier_imba_shadow_dance_effect:GetStatusEffectName() return "particles/status_fx/status_effect_slark_shadow_dance.vpcf" end
function modifier_imba_shadow_dance_effect:StatusEffectPriority() return 15 end
function modifier_imba_shadow_dance_effect:GetPriority() return MODIFIER_PRIORITY_ULTRA + 10 end

modifier_imba_shadow_dance_dummy = class({})

function modifier_imba_shadow_dance_dummy:IsDebuff()			return false end
function modifier_imba_shadow_dance_dummy:IsHidden() 			return false end
function modifier_imba_shadow_dance_dummy:IsPurgable() 			return false end
function modifier_imba_shadow_dance_dummy:IsPurgeException() 	return false end

modifier_imba_shadow_dance_detect = class({})

function modifier_imba_shadow_dance_detect:IsDebuff()			return false end
function modifier_imba_shadow_dance_detect:IsHidden() 			return false end
function modifier_imba_shadow_dance_detect:IsPurgable() 		return false end
function modifier_imba_shadow_dance_detect:IsPurgeException() 	return false end
function modifier_imba_shadow_dance_detect:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_NOT_ON_MINIMAP] = true, [MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_OUT_OF_GAME] = true, [MODIFIER_STATE_UNSELECTABLE] = true} end

function modifier_imba_shadow_dance_detect:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_imba_shadow_dance_detect:OnIntervalThink()
	if not self:GetCaster() or self:GetCaster():IsNull() or not self:GetAbility() or self:GetAbility():IsNull() then
		self:GetParent():ForceKill(false)
		return
	end
	-- FOW + NIGHT = 1, NO FOW + NIGHT = 2, FOW + DAY = 4, NO FOW + DAY = 8
	local can_be_seen = self:GetParent():CanEntityBeSeenByMyTeam(self:GetCaster())
	local day = GameRules:IsDaytime()
	local buff = self:GetCaster():FindModifierByName("modifier_imba_shadow_dance_passive")

	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_shadow_dance_passive", {})
	buff = self:GetCaster():FindModifierByName("modifier_imba_shadow_dance_passive")

	if not buff then
		return
	end

	if day and can_be_seen  then
		buff:SetStackCount(8)
		buff:GetParent():RemoveModifierByName("modifier_imba_shadow_dance_dummy")
	elseif day and not can_be_seen then
		buff:SetStackCount(4)
		buff:GetParent():AddNewModifier(buff:GetParent(), buff:GetAbility(), "modifier_imba_shadow_dance_dummy", {})
	elseif not day and can_be_seen then
		buff:SetStackCount(2)
		buff:GetParent():RemoveModifierByName("modifier_imba_shadow_dance_dummy")
	elseif not day and not can_be_seen then
		buff:SetStackCount(1)
		buff:GetParent():AddNewModifier(buff:GetParent(), buff:GetAbility(), "modifier_imba_shadow_dance_dummy", {})
	end
end

modifier_imba_shadow_dance_fade = class({})

function modifier_imba_shadow_dance_fade:IsDebuff()			return false end
function modifier_imba_shadow_dance_fade:IsHidden() 			return true end
function modifier_imba_shadow_dance_fade:IsPurgable() 		return false end
function modifier_imba_shadow_dance_fade:IsPurgeException() 	return false end