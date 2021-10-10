-- Original Abilites created by Elfansoer: https://github.com/Elfansoer/dota-2-lua-abilities/blob/master/scripts/vscripts/lua_abilities
--------------------------------------------------------------------------------
--- 					Dark Willow Bramble Maze                             ---
--------------------------------------------------------------------------------
CreateTalents("npc_dota_hero_dark_willow", "mb/hero_dark_willow")
imba_dark_willow_bramble_maze = class({})
LinkLuaModifier( "modifier_generic_custom_indicator", "mb/generic/modifier_generic_custom_indicator", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_dark_willow_bramble_maze_thinker", "mb/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_dark_willow_bramble_maze_bramble", "mb/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_dark_willow_bramble_maze_debuff", "mb/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- init bramble locations
local locations = {}
local inner = Vector( 200, 0, 0 )
local outer = Vector( 500, 0, 0 )
outer = RotatePosition( Vector(0,0,0), QAngle( 0, 45, 0 ), outer )

-- real men use 0-based
for i=0,3 do
	locations[i] = RotatePosition( Vector(0,0,0), QAngle( 0, 90*i, 0 ), inner )
	locations[i+4] = RotatePosition( Vector(0,0,0), QAngle( 0, 90*i, 0 ), outer )
end
imba_dark_willow_bramble_maze.locations = locations

--------------------------------------------------------------------------------
-- Passive Modifier
function imba_dark_willow_bramble_maze:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end

--------------------------------------------------------------------------------
-- Ability Cast Filter (For custom indicator)
function imba_dark_willow_bramble_maze:CastFilterResultLocation( vLoc )
	-- Custom indicator block start
	if IsClient() then
		-- check custom indicator
		if self.custom_indicator then
			-- register cursor position
			self.custom_indicator:Register( vLoc )
		end
	end
	-- Custom indicator block end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Custom Indicator
function imba_dark_willow_bramble_maze:CreateCustomIndicator()
	-- references
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_bramble_range_finder_aoe.vpcf"

	-- get data
	local radius = self:GetSpecialValueFor( "placement_range" )

	-- create particle
	self.effect_indicator = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl( self.effect_indicator, 1, Vector( radius, radius, radius ) )
end

function imba_dark_willow_bramble_maze:UpdateCustomIndicator( loc )
	-- update particle position
	ParticleManager:SetParticleControl( self.effect_indicator, 0, loc )
	for i=0,7 do
		ParticleManager:SetParticleControl( self.effect_indicator, 2 + i, loc + self.locations[i] )
	end
end

function imba_dark_willow_bramble_maze:DestroyCustomIndicator()
	-- destroy particle
	ParticleManager:DestroyParticle( self.effect_indicator, false )
	ParticleManager:ReleaseParticleIndex( self.effect_indicator )
end

function imba_dark_willow_bramble_maze:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_bramble_precast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_bramble_wraith.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_bramble.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/dark_willow/dark_willow_chakram_immortal/dark_willow_bramble_precast.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/dark_willow/dark_willow_chakram_immortal/dark_willow_chakram_immortal_bramble_wraith.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/dark_willow/dark_willow_chakram_immortal/dark_willow_chakram_immortal_bramble.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_willow.vsndevts", context )
end
--------------------------------------------------------------------------------
-- Ability Start
function imba_dark_willow_bramble_maze:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_imba_dark_willow_bramble_maze_thinker", -- modifier name
		{}, -- kv
		point,
		self:GetCaster():GetTeamNumber(),
		false
	)
end

--------------------------------------------------------------------------------
modifier_imba_dark_willow_bramble_maze_thinker = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_dark_willow_bramble_maze_thinker:IsHidden() return false end
function modifier_imba_dark_willow_bramble_maze_thinker:IsDebuff() return false end
function modifier_imba_dark_willow_bramble_maze_thinker:IsStunDebuff() return false end
function modifier_imba_dark_willow_bramble_maze_thinker:IsPurgable() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_dark_willow_bramble_maze_thinker:OnCreated( kv )
	-- references
	local init_delay = self:GetAbility():GetSpecialValueFor( "initial_creation_delay" )
	self.interval = self:GetAbility():GetSpecialValueFor( "latch_creation_interval" )
	self.total_count = self:GetAbility():GetSpecialValueFor( "placement_count" )
	self.duration = self:GetAbility():GetSpecialValueFor( "placement_duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "placement_range" )

	self.latch_delay = self:GetAbility():GetSpecialValueFor( "latch_creation_delay" )
	self.latch_duration = self:GetAbility():GetSpecialValueFor( "latch_duration" )
	self.latch_radius = self:GetAbility():GetSpecialValueFor( "latch_range" )
	self.latch_damage = self:GetAbility():GetSpecialValueFor( "latch_damage" )

	if not IsServer() then return end
	-- init
	self.count = 0

	-- Start delay
	self:StartIntervalThink( init_delay )

	-- play effects
	self:PlayEffects1()
	self:PlayEffects2()
end

function modifier_imba_dark_willow_bramble_maze_thinker:OnRefresh( kv ) end
function modifier_imba_dark_willow_bramble_maze_thinker:OnRemoved() end
function modifier_imba_dark_willow_bramble_maze_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_dark_willow_bramble_maze_thinker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_dark_willow_bramble_maze_thinker:OnIntervalThink()
	if not self.delay then
		self.delay = true

		-- start creation interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()
		return
	end

	-- create bramble
	CreateModifierThinker(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_imba_dark_willow_bramble_maze_bramble", -- modifier name
		{
			duration = self.duration,
			root = self.latch_duration,
			radius = self.latch_radius,
			damage = self.latch_damage,
			delay = self.latch_delay,
		}, -- kv
		self:GetParent():GetOrigin() + self:GetAbility().locations[self.count],
		self:GetCaster():GetTeamNumber(),
		false
	)

	self.count = self.count+1
	if self.count>=self.total_count then
		self:StartIntervalThink( -1 )
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_dark_willow_bramble_maze_thinker:PlayEffects1()
	-- Get Resources
	--particles/econ/items/dark_willow/dark_willow_chakram_immortal/dark_willow_bramble_precast.vpcf
	--local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_bramble_precast.vpcf"
	local particle_cast = "particles/econ/items/dark_willow/dark_willow_chakram_immortal/dark_willow_bramble_precast.vpcf"

	for _,loc in pairs(self:GetAbility().locations) do
		local location = self:GetParent():GetOrigin() + loc

		-- Create Particle
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, location )
		ParticleManager:SetParticleControl( effect_cast, 3, location )
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end
end

function modifier_imba_dark_willow_bramble_maze_thinker:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_bramble_cast.vpcf"
	local sound_cast = "Hero_DarkWillow.Brambles.Cast"
	local sound_target = "Hero_DarkWillow.Brambles.CastTarget"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
modifier_imba_dark_willow_bramble_maze_bramble = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_dark_willow_bramble_maze_bramble:IsHidden() return false end
function modifier_imba_dark_willow_bramble_maze_bramble:IsDebuff() return false end
function modifier_imba_dark_willow_bramble_maze_bramble:IsStunDebuff() return false end
function modifier_imba_dark_willow_bramble_maze_bramble:IsPurgable() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_dark_willow_bramble_maze_bramble:OnCreated( kv )
	if not IsServer() then return end
	-- references
	self.radius = kv.radius
	self.root = kv.root
	self.damage = kv.damage
	local delay = kv.delay

	-- start delay
	self:StartIntervalThink( delay )

	-- play effects
	self:PlayEffects()
end

function modifier_imba_dark_willow_bramble_maze_bramble:OnRefresh( kv ) end
function modifier_imba_dark_willow_bramble_maze_bramble:OnRemoved() end
function modifier_imba_dark_willow_bramble_maze_bramble:OnDestroy()
	if not IsServer() then return end
	-- stop loop sound
	local sound_loop = "Hero_DarkWillow.BrambleLoop"
	StopSoundOn( sound_loop, self:GetParent() )

	-- play stopping sound
	local sound_stop = "Hero_DarkWillow.Bramble.Destroy"
	EmitSoundOn( sound_stop, self:GetParent() )

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_dark_willow_bramble_maze_bramble:OnIntervalThink()
	if not self.delay then
		self.delay = true

		-- start search interval
		local interval = 0.03
		self:StartIntervalThink( interval )
		return
	end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local target = nil
	for _,enemy in pairs(enemies) do
		-- find the first occurence
		target = enemy
		break
	end
	if not target then return end

	-- root target
	target:AddNewModifier_RS(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_imba_dark_willow_bramble_maze_debuff", -- modifier name
		{
			duration = self.root,
			damage = self.damage,
		} -- kv
	)

	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_dark_willow_bramble_maze_bramble:PlayEffects()
	-- Get Resources
	--local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_bramble_wraith.vpcf"
	local particle_cast = "particles/econ/items/dark_willow/dark_willow_chakram_immortal/dark_willow_chakram_immortal_bramble_wraith.vpcf"
	local sound_cast = "Hero_DarkWillow.Bramble.Spawn"
	local sound_loop = "Hero_DarkWillow.BrambleLoop"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
	EmitSoundOn( sound_loop, self:GetParent() )
end

--------------------------------------------------------------------------------
modifier_imba_dark_willow_bramble_maze_debuff = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_dark_willow_bramble_maze_debuff:IsHidden() return false end
function modifier_imba_dark_willow_bramble_maze_debuff:IsDebuff() return true end
function modifier_imba_dark_willow_bramble_maze_debuff:IsStunDebuff() return false end
function modifier_imba_dark_willow_bramble_maze_debuff:IsPurgable() return true end
function modifier_imba_dark_willow_bramble_maze_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_dark_willow_bramble_maze_debuff:OnCreated( kv )
	if not IsServer() then return end
	-- references
	local duration = kv.duration
	local damage = kv.damage
	local interval = 0.5

	-- set dps
	local instances = duration/interval
	local dps = damage/instances

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = dps,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
	
	-- Start interval
	self:StartIntervalThink( interval )

	-- play effects
	local sount_cast1 = "Hero_DarkWillow.Bramble.Target"
	local sount_cast2 = "Hero_DarkWillow.Bramble.Target.Layer"
	EmitSoundOn( sount_cast1, self:GetParent() )
	EmitSoundOn( sount_cast2, self:GetParent() )
end

function modifier_imba_dark_willow_bramble_maze_debuff:OnRefresh( kv ) end
function modifier_imba_dark_willow_bramble_maze_debuff:OnRemoved() end
function modifier_imba_dark_willow_bramble_maze_debuff:OnDestroy() 
	if not IsServer() then return end
	-- IMBA apply FOWViewer
	if self:GetParent():IsAlive() then 
		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("vision_radius"), self:GetAbility():GetSpecialValueFor("vision_duration"), false )
	end
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_imba_dark_willow_bramble_maze_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_dark_willow_bramble_maze_debuff:OnIntervalThink()
	-- apply damage
	ApplyDamage( self.damageTable )
	-- IMBA apply Bedlam Damage
	if IsServer() then 
		if self:GetCaster():HasModifier("modifier_imba_dark_willow_bedlam") then 
			--PerformWispAttackToBramble
			local wisp_hanlde = self:GetCaster():FindModifierByName("modifier_imba_dark_willow_bedlam") 
			local bedlam_abi = self:GetCaster():FindAbilityByName("imba_dark_willow_bedlam")
			if bedlam_abi and bedlam_abi:GetAutoCastState() then 
				wisp_hanlde.wisp:FindModifierByName("modifier_imba_dark_willow_bedlam_attack"):PerformWispAttackToBramble(self:GetParent())
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_dark_willow_bramble_maze_debuff:GetEffectName()
	--return "particles/units/heroes/hero_dark_willow/dark_willow_bramble.vpcf"
	return "particles/econ/items/dark_willow/dark_willow_chakram_immortal/dark_willow_chakram_immortal_bramble.vpcf"
end

function modifier_imba_dark_willow_bramble_maze_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


--------------------------------------------------------------------------------
--- 					Dark Willow Shadow Realm                             ---
--------------------------------------------------------------------------------
imba_dark_willow_shadow_realm = class({})
LinkLuaModifier( "modifier_imba_dark_willow_shadow_realm", "mb/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_dark_willow_shadow_realm_buff", "mb/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function imba_dark_willow_shadow_realm:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_dark_willow_shadow_realm", -- modifier name
		{ duration = duration }
	)
end

--------------------------------------------------------------------------------
-- Projectile
function imba_dark_willow_shadow_realm:OnProjectileHit_ExtraData( target, location, ExtraData )
	-- destroy effect projectile
	local effect_cast = ExtraData.effect
	ParticleManager:DestroyParticle( effect_cast, false )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if not target then return end

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = ExtraData.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
end

--------------------------------------------------------------------------------
modifier_imba_dark_willow_shadow_realm = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_dark_willow_shadow_realm:IsHidden() return false end
function modifier_imba_dark_willow_shadow_realm:IsDebuff() return false end
function modifier_imba_dark_willow_shadow_realm:IsPurgable() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_dark_willow_shadow_realm:OnCreated( kv )
	-- references
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "attack_range_bonus" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.bonus_max = self:GetAbility():GetSpecialValueFor( "max_damage_duration" )
	self.buff_duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.scepter = self:GetParent():HasScepter()
	self.movement_pct = self:GetAbility():GetSpecialValueFor( "movement_pct" ) -- 移速
	---------------------------------------------------------------------------------

	if not IsServer() then return end
	-- set creation time
	self.create_time = GameRules:GetGameTime()

	-- dodge projectiles
	ProjectileManager:ProjectileDodge( self:GetParent() )

	-- stop if currently attacking
	if self:GetParent():GetAggroTarget() and not self.scepter then

		-- unit:Stop() is not enough to stop
		local order = {
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP,
		}
		ExecuteOrderFromTable( order )
	end

	---------------------------------------------------------------------------------
	-- IMBA AUTO CAST 
	if self:GetAbility():GetAutoCastState() then 
		self.parent = self:GetParent()
		self.zero = Vector(0,0,0)

		-- references
		--self.revolution = self:GetAbility():GetSpecialValueFor( "roaming_seconds_per_rotation" )
		--self.rotate_radius = self:GetAbility():GetSpecialValueFor( "roaming_radius" )
		self.revolution = 1.8
		self.rotate_radius = 200
		-- init data
		self.interval = 0.03
		self.base_facing = Vector(0,1,0)
		self.relative_pos = Vector( -self.rotate_radius, 0, 100 )
		self.rotate_delta = 360/self.revolution * self.interval

		-- set init location
		self.position = self.parent:GetOrigin() + self.relative_pos
		self.rotation = 0
		self.facing = self.base_facing

		-- create wisp
		self.wisp = CreateUnitByName(
			"npc_dota_dark_willow_creature",
			self.position,
			true,
			self.parent,
			self.parent:GetOwner(),
			self.parent:GetTeamNumber()
		)
		self.wisp:SetForwardVector( self.facing )
		self.wisp:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_wisp_ambient", -- modifier name
			{} -- kv
		)

		-- add attack modifier
		self.wisp:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_imba_dark_willow_bedlam_attack", -- modifier name
			{ duration = kv.duration } -- kv
		)

		self:StartIntervalThink(self.interval)
	end
	---------------------------------------------------------------------------------
	self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_dark_willow_shadow_realm:OnIntervalThink()
	-- update position
	self.rotation = self.rotation + self.rotate_delta
	-- IMBA If has jex
	--[[if self:GetAbility():GetAutoCastState() and self.scepter then 
	 	self.rotate_radius = self.rotate_radius + 5
	 	self.relative_pos = Vector( -self.rotate_radius, 0, 100 )
	end]]

	local origin = self.parent:GetOrigin()
	self.position = RotatePosition( origin, QAngle( 0, -self.rotation, 0 ), origin + self.relative_pos )
	self.facing = RotatePosition( self.zero, QAngle( 0, -self.rotation, 0 ), self.base_facing )

	-- update wisp
	self.wisp:SetOrigin( self.position )
	self.wisp:SetForwardVector( self.facing )
end

function modifier_imba_dark_willow_shadow_realm:OnRefresh( kv )
	-- references
	self.bonus_range = self:GetAbility():GetSpecialValueFor( "attack_range_bonus" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.bonus_max = self:GetAbility():GetSpecialValueFor( "max_damage_duration" )
	self.buff_duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.movement_pct = self:GetAbility():GetSpecialValueFor( "movement_pct" ) -- 移速

	if not IsServer() then return end
	--IMBA AUTOCAST
	-----------------------------------------------------------------
		if self:GetAbility():GetAutoCastState() then 
			self.relative_pos = Vector( -self.rotate_radius, 0, 100 )
			self.rotate_delta = 360/self.revolution * self.interval

			-- refresh attack modifier
			self.wisp:AddNewModifier(
				self:GetCaster(), -- player source
				self:GetAbility(), -- ability source
				"modifier_imba_dark_willow_bedlam_attack", -- modifier name
				{ duration = kv.duration } -- kv
			)
		end
	-----------------------------------------------------------------
	-- dodge projectiles
	ProjectileManager:ProjectileDodge( self:GetParent() )
end

function modifier_imba_dark_willow_shadow_realm:OnRemoved() end
function modifier_imba_dark_willow_shadow_realm:OnDestroy()
	-- stop sound
	local sound_cast = "Hero_DarkWillow.Shadow_Realm"
	StopSoundOn( sound_cast, self:GetParent() )
	--IMBA AUTOCAST
	----------------------------------------------------------------- 
	if not IsServer() then return end
		if self:GetAbility():GetAutoCastState() then 
		-- kill the wisp
			UTIL_Remove( self.wisp )
		end
	--IMBA AUTOCAST
	-----------------------------------------------------------------
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_dark_willow_shadow_realm:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}
	return funcs
end

function modifier_imba_dark_willow_shadow_realm:GetModifierAttackRangeBonus() return self.bonus_range end
--particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack.vpcf
--particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack_dummy.vpcf
function modifier_imba_dark_willow_shadow_realm:GetModifierProjectileName()
	return "particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack.vpcf"
end
function modifier_imba_dark_willow_shadow_realm:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if 	params.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO then
		--print("AUTOCAST Spell",params.ability:GetAbilityName(),self:GetAbility():GetAbilityName())
		if params.ability == self:GetAbility() then 
			self:GetAbility():ToggleAutoCast() --不允许施法期间关闭/开启 自动施法，否则出现奇怪BUG
		end
	end
end

function modifier_imba_dark_willow_shadow_realm:GetModifierMoveSpeedBonus_Percentage() 
	if IsServer() then 
		if self:GetAbility():GetAutoCastState() then 
			return self.movement_pct 
		end
	end
end
function modifier_imba_dark_willow_shadow_realm:GetModifierIgnoreMovespeedLimit() return 1 end
function modifier_imba_dark_willow_shadow_realm:OnAttack( params )
	-- IMBA AUTOCAST 
	if self:GetAbility():GetAutoCastState() then return end
	if not IsServer() then return end
	if params.attacker~=self:GetParent() then return end
	-- 对建筑无效
	if params.target:IsBuilding() or params.target:IsOther() then
		return
	end
	-- calculate time
	local time = GameRules:GetGameTime() - self.create_time
	time = math.min( time/self.bonus_max, 1 )

	-- create modifier
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_imba_dark_willow_shadow_realm_buff", -- modifier name
		{
			duration = self.buff_duration,
			record = params.record,
			damage = self.bonus_damage,
			time = time,
			target = params.target:entindex(),
		} -- kv
	)

	-- play sound
	local sound_cast = "Hero_DarkWillow.Shadow_Realm.Attack"
	EmitSoundOn( sound_cast, self:GetParent() )

	-- destroy if doesn't have scepter
	if not self.scepter then
		self:Destroy()
	end
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_imba_dark_willow_shadow_realm:CheckState()
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		-- [MODIFIER_STATE_UNSELECTABLE] = true,
	}
	if self:GetAbility():GetAutoCastState() then 
		state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		-- [MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true
		}
	end

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_dark_willow_shadow_realm:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end

function modifier_imba_dark_willow_shadow_realm:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf"
	local sound_cast = "Hero_DarkWillow.Shadow_Realm"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
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

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
modifier_imba_dark_willow_shadow_realm_buff = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_dark_willow_shadow_realm_buff:IsHidden() return true end
function modifier_imba_dark_willow_shadow_realm_buff:IsDebuff() return false end
function modifier_imba_dark_willow_shadow_realm_buff:IsPurgable() return false end
function modifier_imba_dark_willow_shadow_realm_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_dark_willow_shadow_realm_buff:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.damage = kv.damage
	self.record = kv.record
	self.time = kv.time
	self.target = EntIndexToHScript( kv.target )

	self.target_pos = self.target:GetOrigin()
	self.target_prev = self.target_pos

	-- create custom projectile
	-- self:PlayEffects()
end

function modifier_imba_dark_willow_shadow_realm_buff:OnRefresh( kv ) end
function modifier_imba_dark_willow_shadow_realm_buff:OnRemoved() end
function modifier_imba_dark_willow_shadow_realm_buff:OnDestroy() end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_dark_willow_shadow_realm_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,

		MODIFIER_EVENT_ON_PROJECTILE_DODGE,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, -- this does nothing but tracking target's movement, for projectile dodge purposes
	}

	return funcs
end

function modifier_imba_dark_willow_shadow_realm_buff:OnAttackRecordDestroy( params )
	if not IsServer() then return end
	if params.record~=self.record then return end

	-- destroy buff if attack finished (proc/miss/whatever)
	-- self:StopEffects( false )
	self:Destroy()
end
function modifier_imba_dark_willow_shadow_realm_buff:GetModifierProcAttack_BonusDamage_Magical( params )
	if params.record~=self.record then return end
	-- overhead event
	SendOverheadEventMessage(
		nil, --DOTAPlayer sendToPlayer,
		OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
		params.target,
		self.damage * self.time,
		self:GetParent():GetPlayerOwner() -- DOTAPlayer sourcePlayer
	)

	-- play effects
	local sound_cast = "Hero_DarkWillow.Shadow_Realm.Damage"
	EmitSoundOn( sound_cast, self:GetParent() )

	return self.damage * self.time
end

function modifier_imba_dark_willow_shadow_realm_buff:OnProjectileDodge( params )
	if not IsServer() then return end
	if params.target~=self.target then return end

	-- set target CP to last known location
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		1,
		self.target,
		PATTACH_CUSTOMORIGIN,
		"attach_hitloc",
		self.target_prev, -- unknown
		true -- unknown, true
	)
end
function modifier_imba_dark_willow_shadow_realm_buff:GetModifierBaseAttack_BonusDamage()
	if not IsServer() then return end

	-- track target's position each frame
	self.target_prev = self.target_pos
	self.target_pos = self.target:GetOrigin()

	-- the property actually does nothing
	return 0
end

--it cannt destroy during Client sometimes ...fXXK
--------------------------------------------------------------------------------
-- Graphics and Animations
--[[function modifier_imba_dark_willow_shadow_realm_buff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack.vpcf"

	-- Get data
	local speed = self:GetParent():GetProjectileSpeed()

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		1,
		self.target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( speed, 0, 0 ) )
	ParticleManager:SetParticleControl( self.effect_cast, 5, Vector( self.time, 0, 0 ) )
end]]

--[[function modifier_imba_dark_willow_shadow_realm_buff:StopEffects( dodge )
	-- destroy effects
	ParticleManager:DestroyParticle( self.effect_cast, dodge )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end]]


--------------------------------------------------------------------------------
--- 					Dark Willow Cursed Crown                             ---
--------------------------------------------------------------------------------

imba_dark_willow_cursed_crown = class({})
LinkLuaModifier( "modifier_imba_dark_willow_cursed_crown", "mb/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )
-------------------------------------------------------------------------------
function imba_dark_willow_cursed_crown:GetCooldown( iLevel )
	if self:GetCaster():Has_Aghanims_Shard() then 
		return self.BaseClass.GetCooldown( self, iLevel ) + self:GetSpecialValueFor("shard_cooldown")
	end
	return self.BaseClass.GetCooldown( self, iLevel )
end

function imba_dark_willow_cursed_crown:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_ley_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_leyconduit_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_leyconduit_marker.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_leyconduit_marker_helper.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_ti8_immortal_cursed_crown_cast.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_ti8_immortal_cursed_crown_start.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_ti8_immortal_cursed_crown_marker.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_ti8_immortal_cursed_crown_helper.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_willow.vsndevts", context )
end
--------------------------------------------------------------------------------
-- Ability Start
function imba_dark_willow_cursed_crown:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local duration = self:GetSpecialValueFor( "delay" )
	local cursed_count = self:GetSpecialValueFor("cursed_count")

	-- add debuff
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_dark_willow_cursed_crown", -- modifier name
		{ duration = duration , cursed_infect = true , cursed_count = cursed_count } -- kv
	)
end

--imba 诅咒传染：诅咒王冠结束后会自动向周围随机一名敌方传递，可以传递%cursed_count%次.
--------------------------------------------------------------------------------
modifier_imba_dark_willow_cursed_crown = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_dark_willow_cursed_crown:IsHidden() return false end
function modifier_imba_dark_willow_cursed_crown:IsDebuff() return true end
function modifier_imba_dark_willow_cursed_crown:IsStunDebuff() return false end
function modifier_imba_dark_willow_cursed_crown:IsPurgable() return true end
--function modifier_imba_dark_willow_cursed_crown:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_dark_willow_cursed_crown:OnCreated( kv )
	-- references
	self.stun = self:GetAbility():GetSpecialValueFor( "stun_duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "stun_radius" )
	self.delay = self:GetAbility():GetSpecialValueFor( "delay" )
	self.cursed_infect = kv.cursed_infect
	self.cursed_count = kv.cursed_count
	-- Value Shard Abi 
	self.root = self:GetAbility():GetSpecialValueFor( "latch_duration" )
	self.damage = self:GetAbility():GetSpecialValueFor( "latch_damage" )

	if not IsServer() then return end
	local interval = 1
	self.count = 0

	-- Start interval
	self:StartIntervalThink( interval )

	-- Play effects
	self:PlayEffects1()
	self:PlayEffects2()
end

function modifier_imba_dark_willow_cursed_crown:OnRefresh( kv ) end
function modifier_imba_dark_willow_cursed_crown:OnRemoved() end
function modifier_imba_dark_willow_cursed_crown:OnDestroy()
	if self.cursed_infect and self.cursed_infect ~= nil and self.cursed_count > 0 then  
		--IMBA cursed crown for other enemies 
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self:GetAbility():GetSpecialValueFor("infect_radius"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter only for hero
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		local cursed_count = self:GetAbility():GetSpecialValueFor("cursed_count")
		local cursed_enemy = 0
		for _,enemy in pairs(enemies) do
			-- add cursed crown
			if enemy ~= self:GetParent() and enemy:IsAlive() and self:GetCaster():IsAlive() then 
				enemy:AddNewModifier(
					self:GetCaster(), -- player source
					self:GetAbility(), -- ability source
					"modifier_imba_dark_willow_cursed_crown", -- modifier name
					{ duration = self.delay , cursed_infect = true , cursed_count = self.cursed_count - 1 } -- kv
				)
				break
			end
		end
		--Value Shard Abi 
		if self:GetCaster():Has_Aghanims_Shard() then 
			for _,enemy in pairs(enemies) do
				if enemy ~= self:GetParent() and enemy:IsAlive() then 
				-- root target
				enemy:AddNewModifier_RS(
					self:GetCaster(), -- player source
					self:GetAbility(), -- ability source
					"modifier_imba_dark_willow_bramble_maze_debuff", -- modifier name
					{
						duration = self.root,
						damage = self.damage,
					} -- kv
				)
				end
			end	
		end
	end

	--clear kv 
	self.stun = nil 
	self.radius = nil
	self.delay = nil 
	self.cursed_infect = nil
	self.cursed_count = nil

	if IsServer() then
		self.count = nil
	end
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_dark_willow_cursed_crown:OnIntervalThink()
	self.count = self.count + 1
	if self.count < self.delay then
		-- Play effects
		self:PlayEffects4()
		-- IMBA apply Bedlam Damage
		if IsServer() then 
			if self:GetCaster():HasModifier("modifier_imba_dark_willow_bedlam") then 
				--PerformWispAttackToCursed
				local wisp_hanlde = self:GetCaster():FindModifierByName("modifier_imba_dark_willow_bedlam")
				local bedlam_abi = self:GetCaster():FindAbilityByName("imba_dark_willow_bedlam") 
				if bedlam_abi and bedlam_abi:GetAutoCastState() then 
					wisp_hanlde.wisp:FindModifierByName("modifier_imba_dark_willow_bedlam_attack"):PerformWispAttackToCursed(self:GetParent(),self.radius)
				end
			end
		end
		return
	end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- stun
		enemy:AddNewModifier_RS(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.stun } -- kv
		)
	end
	-- play effects
	self:PlayEffects3()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_dark_willow_cursed_crown:PlayEffects1()
	-- Get Resources
	--local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_ley_cast.vpcf"
	local particle_cast = "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_ti8_immortal_cursed_crown_cast.vpcf"
	local sound_cast = "Hero_DarkWillow.Ley.Cast"
	local sound_target = "Hero_DarkWillow.Ley.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector( 0, 0, 0 ), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector( 0, 0, 0 ), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_target, self:GetParent() )
end

function modifier_imba_dark_willow_cursed_crown:PlayEffects2()
	-- Get Resources
	--local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_leyconduit_start.vpcf"
	local particle_cast = "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_ti8_immortal_cursed_crown_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )

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

function modifier_imba_dark_willow_cursed_crown:PlayEffects3()
	-- Get Resources
	--local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_leyconduit_marker.vpcf"
	local particle_cast = "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_ti8_immortal_cursed_crown_marker.vpcf"
	local sound_cast = "Hero_DarkWillow.Ley.Stun"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

function modifier_imba_dark_willow_cursed_crown:PlayEffects4()
	-- Get Resources
	--local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_leyconduit_marker_helper.vpcf"
	local particle_cast = "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_ti8_immortal_cursed_crown_helper.vpcf"
	local sound_cast = "Hero_DarkWillow.Ley.Count"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
--- 					 Dark Willow Bedlam                             	 ---
--------------------------------------------------------------------------------

imba_dark_willow_bedlam = class({})
LinkLuaModifier( "modifier_wisp_ambient", "mb/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_dark_willow_bedlam", "mb/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_dark_willow_bedlam_attack", "mb/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function imba_dark_willow_bedlam:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor( "roaming_duration" )

	-- add buff
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_dark_willow_bedlam", -- modifier name
		{ duration = duration } -- kv
	)

end
--------------------------------------------------------------------------------
-- Projectile
function imba_dark_willow_bedlam:OnProjectileHit_ExtraData( target, location, ExtraData )
	-- destroy effect projectile
	local effect_cast = ExtraData.effect
	ParticleManager:DestroyParticle( effect_cast, false )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	if not target then return end

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = ExtraData.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
end


--------------------------------------------------------------------------------
modifier_imba_dark_willow_bedlam = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_dark_willow_bedlam:IsHidden() return false end
function modifier_imba_dark_willow_bedlam:IsDebuff() return false end
function modifier_imba_dark_willow_bedlam:IsPurgable() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_dark_willow_bedlam:OnCreated( kv )
	self.parent = self:GetParent()
	self.zero = Vector(0,0,0)

	-- references
	self.revolution = self:GetAbility():GetSpecialValueFor( "roaming_seconds_per_rotation" )
	self.rotate_radius = self:GetAbility():GetSpecialValueFor( "roaming_radius" )

	if not IsServer() then return end

	-- init data
	self.interval = 0.03
	self.base_facing = Vector(0,1,0)
	self.relative_pos = Vector( -self.rotate_radius, 0, 100 )
	self.rotate_delta = 360/self.revolution * self.interval

	-- set init location
	self.position = self.parent:GetOrigin() + self.relative_pos
	self.rotation = 0
	self.facing = self.base_facing

	-- create wisp
	self.wisp = CreateUnitByName(
		"npc_dota_dark_willow_creature",
		self.position,
		true,
		self.parent,
		self.parent:GetOwner(),
		self.parent:GetTeamNumber()
	)
	self.wisp:SetForwardVector( self.facing )
	self.wisp:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_wisp_ambient", -- modifier name
		{} -- kv
	)

	-- add attack modifier
	self.wisp:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_imba_dark_willow_bedlam_attack", -- modifier name
		{ duration = kv.duration } -- kv
	)

	-- Start interval
	self:StartIntervalThink( self.interval )

	-- deactivate ability
	local ability = self:GetCaster():FindAbilityByName( "imba_dark_willow_terrorize" )
	if ability then ability:SetActivated( false ) end

	-- play effects
	self:PlayEffects()
end

function modifier_imba_dark_willow_bedlam:OnRefresh( kv )
	-- refresh references
	self.revolution = self:GetAbility():GetSpecialValueFor( "roaming_seconds_per_rotation" )
	self.rotate_radius = self:GetAbility():GetSpecialValueFor( "roaming_radius" )

	if not IsServer() then return end

	self.relative_pos = Vector( -self.rotate_radius, 0, 100 )
	self.rotate_delta = 360/self.revolution * self.interval

	-- refresh attack modifier
	self.wisp:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_imba_dark_willow_bedlam_attack", -- modifier name
		{ duration = kv.duration } -- kv
	)
end

function modifier_imba_dark_willow_bedlam:OnRemoved() end
function modifier_imba_dark_willow_bedlam:OnDestroy()
	if not IsServer() then return end

	-- kill the wisp
	UTIL_Remove( self.wisp )
	-- self.wisp:ForceKill( false )

	-- reactivate ability
	local ability = self:GetCaster():FindAbilityByName( "imba_dark_willow_terrorize" )
	if ability then ability:SetActivated( true ) end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_dark_willow_bedlam:OnIntervalThink()
	-- update position
	self.rotation = self.rotation + self.rotate_delta
	-- IMBA If has jex
	if self:GetCaster():HasModifier("modifier_imba_dark_willow_shadow_realm") and self:GetAbility():GetAutoCastState() then 
	 	self.rotate_radius = self.rotate_radius + 5
	 	self.relative_pos = Vector( -self.rotate_radius, 0, 100 )
	end

	local origin = self.parent:GetOrigin()
	self.position = RotatePosition( origin, QAngle( 0, -self.rotation, 0 ), origin + self.relative_pos )
	self.facing = RotatePosition( self.zero, QAngle( 0, -self.rotation, 0 ), self.base_facing )

	-- update wisp
	self.wisp:SetOrigin( self.position )
	self.wisp:SetForwardVector( self.facing )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_dark_willow_bedlam:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_wisp_aoe_cast.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( self.rotate_radius, self.rotate_radius, self.rotate_radius ) )
	-- if is rubick_arcana
	ParticleManager:SetParticleControl( effect_cast, 60, Vector( 0, 0, 255) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 1, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

--------------------------------------------------------------------------------
modifier_imba_dark_willow_bedlam_attack = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_dark_willow_bedlam_attack:IsHidden() return false end
function modifier_imba_dark_willow_bedlam_attack:IsDebuff() return false end
function modifier_imba_dark_willow_bedlam_attack:IsStunDebuff() return false end
function modifier_imba_dark_willow_bedlam_attack:IsPurgable() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_dark_willow_bedlam_attack:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "attack_damage" ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_dark_willow_4")
	self.interval = self:GetAbility():GetSpecialValueFor( "attack_interval" )
	self.radius = self:GetAbility():GetSpecialValueFor( "attack_radius" )

	if not IsServer() then return end
	-- precache projectile
	-- local projectile_name = "particles/units/heroes/hero_dark_willow/dark_willow_willowisp_base_attack.vpcf"
	local projectile_name = ""
	local projectile_speed = 1400

	self.info = {
		-- Target = target,
		Source = self:GetParent(),
		Ability = self:GetAbility(),	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
		-- bIsAttack = false,                                -- Optional

		ExtraData = {
			damage = damage,
		}
	}

	-- Start interval
	self:StartIntervalThink( self.interval )

	-- play effects
	self:PlayEffects()
end

function modifier_imba_dark_willow_bedlam_attack:OnRefresh( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "attack_damage" ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_dark_willow_4")
	self.interval = self:GetAbility():GetSpecialValueFor( "attack_interval" )
	self.radius = self:GetAbility():GetSpecialValueFor( "attack_radius" )

	if not IsServer() then return end
	-- update projectile
	self.info.ExtraData.damage = damage

	-- play effects
	local sound_cast = "Hero_DarkWillow.WispStrike.Cast"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_imba_dark_willow_bedlam_attack:OnRemoved() end
function modifier_imba_dark_willow_bedlam_attack:OnDestroy() end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_dark_willow_bedlam_attack:OnIntervalThink()
	-- IMBA 
	self.radius = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() +  self:GetAbility():GetSpecialValueFor( "attack_radius" )

	local attack_targets = self:GetAbility():GetSpecialValueFor("attack_targets")
	local attack_count = 0
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- create projectile effect
		local effect = self:PlayEffects1( enemy, self.info.iMoveSpeed )

		-- launch attack
		self.info.Target = enemy
		self.info.ExtraData.effect = effect

		ProjectileManager:CreateTrackingProjectile( self.info )

		-- play effects
		local sound_cast = "Hero_DarkWillow.WillOWisp.Damage"
		EmitSoundOn( sound_cast, self:GetParent() )

		-- only on first unit
		attack_count = attack_count + 1
		if attack_count >= attack_targets then 
			break
		end
	end
end

-- Attack Bramble Maze enemy once
function modifier_imba_dark_willow_bedlam_attack:PerformWispAttackToBramble(hTarget)
	-- create projectile effect
	local effect = self:PlayEffects1( hTarget, self.info.iMoveSpeed )

	-- launch attack
	self.info.Target = hTarget
	self.info.ExtraData.effect = effect

	ProjectileManager:CreateTrackingProjectile( self.info )

	-- play effects
	local sound_cast = "Hero_DarkWillow.WillOWisp.Damage"
	EmitSoundOn( sound_cast, self:GetParent() )
end

-- Attack Enemy Radius other enemies once
function modifier_imba_dark_willow_bedlam_attack:PerformWispAttackToCursed(hTarget,vRadius)
	local attack_targets = self:GetAbility():GetSpecialValueFor("attack_targets")
	local attack_count = 0
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		hTarget:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		vRadius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		self:PerformWispAttackToBramble(enemy)
		-- only on first unit
		attack_count = attack_count + 1
		if attack_count >= attack_targets then 
			break
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_dark_willow_bedlam_attack:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_wisp_aoe.vpcf"
	local sound_cast = "Hero_DarkWillow.WispStrike.Cast"
	--local imba_spell_steal = self:GetCaster():FindAbilityByName("imba_rubick_spell_steal")
	--local spell_steal = self:GetCaster():FindAbilityByName("rubick_spell_steal")
	-- set color based on level
	--local color = Vector(0,0,0)
	--local level = spell_steal:GetLevel()
	--[[	if (level==1) then color.x = 255 
	elseif (level==2) then color.y = 255
	elseif (level==3) then color.z = 255
	end]]
	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )

	-- if is rubick_arcana
	ParticleManager:SetParticleControl( effect_cast, 60, Vector( 0, 0, 255) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 1, 0, 0 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_imba_dark_willow_bedlam_attack:PlayEffects1( target, speed )
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_willowisp_base_attack.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )

	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	) 
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( speed, 0, 0 ) )
	-- if is rubick_arcana
	ParticleManager:SetParticleControl( effect_cast, 60, Vector( 0, 0, 255) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 1, 0, 0 ) )
	return effect_cast
end

--------------------------------------------------------------------------------
modifier_wisp_ambient = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_wisp_ambient:IsHidden() return false end
function modifier_wisp_ambient:IsPurgable() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_wisp_ambient:OnCreated( kv )
	if not IsServer() then return end
	self:GetParent():SetModel( "models/heroes/dark_willow/dark_willow_wisp.vmdl" )
	self:PlayEffects()

	-- check if stolen
	local spell_steal = self:GetCaster():FindAbilityByName("imba_rubick_spell_steal")
	local stolen = (self:GetAbility():IsStolen() and spell_steal)
	if stolen then
		self:GetParent():SetModelScale( 0.01 )
	end

end

function modifier_wisp_ambient:OnRefresh( kv ) end
function modifier_wisp_ambient:OnRemoved() end
function modifier_wisp_ambient:OnDestroy() end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_wisp_ambient:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}

	return funcs
end

function modifier_wisp_ambient:GetModifierBaseAttack_BonusDamage()
	if not IsServer() then return end

	-- update cp
	local target = self:GetParent():GetOrigin() + self:GetParent():GetForwardVector()
	local forward = self:GetParent():GetForwardVector()
	ParticleManager:SetParticleControl( self.effect_cast, 2, target )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_wisp_ambient:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_wisp_ambient:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_willowisp_ambient.vpcf"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		1,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	-- if is rubick_arcana
	ParticleManager:SetParticleControl( self.effect_cast, 60, Vector( 0, 0, 255) )
	ParticleManager:SetParticleControl( self.effect_cast, 61, Vector( 1, 0, 0 ) )

	-- buff particle
	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end

--------------------------------------------------------------------------------
--- 					 Dark Willow Terrorize                            	 ---
--------------------------------------------------------------------------------
imba_dark_willow_terrorize = class({})
LinkLuaModifier( "modifier_wisp_ambient", "mb/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_dark_willow_terrorize", "mb/hero_dark_willow", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function imba_dark_willow_terrorize:GetAOERadius()
	return self:GetSpecialValueFor( "destination_radius" )
end

function imba_dark_willow_terrorize:OnUpgrade()
	local caster = self:GetCaster()
	local bedlam_abi = caster:FindAbilityByName("imba_dark_willow_bedlam")
	--local morph_hybrid = caster:FindAbilityByName("imba_morphling_hybrid")
	if bedlam_abi then 
		bedlam_abi:SetLevel(self:GetLevel())
	end
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function imba_dark_willow_terrorize:OnAbilityPhaseStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local vector = point-caster:GetOrigin()
	vector.z = 0

	-- get data
	local radius = self:GetSpecialValueFor( "destination_radius" )
	local height = self:GetSpecialValueFor( "starting_height" )

	-- create wisp
	self.wisp = CreateUnitByName(
		"npc_dota_dark_willow_creature",
		caster:GetOrigin(),
		true,
		caster,
		caster:GetOwner(),
		caster:GetTeamNumber()
	)
	self.wisp:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_wisp_ambient", -- modifier name
		{} -- kv
	)
	self.wisp:SetForwardVector( vector:Normalized() )
	self.wisp:SetOrigin( self.wisp:GetOrigin() + Vector( 0,0,height ) )

	-- create effects
	self:PlayEffects1( point, radius )
	self:PlayEffects2()

	return true -- if success
end
function imba_dark_willow_terrorize:OnAbilityPhaseInterrupted()
	UTIL_Remove( self.wisp )

	self:StopEffects1()
	self:StopEffects2()
end

--------------------------------------------------------------------------------
-- Ability Start
function imba_dark_willow_terrorize:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local vector = point-caster:GetOrigin()
	vector.z = 0
	local origin = caster:GetOrigin()

	-- load data
	local height = self:GetSpecialValueFor( "starting_height" )

	--local projectile_name = ""
	local projectile_speed = self:GetSpecialValueFor( "destination_travel_speed" )
	local projectile_distance = vector:Length2D()
	local projectile_direction = vector:Normalized()
	local projectile_height = self:GetSpecialValueFor( "300" )

	-- projectiles don't change height, so better pre-set it to have nice effect
	local spawn_origin = caster:GetOrigin()
	spawn_origin.z = GetGroundHeight( point, caster )
	height = origin.z + height - spawn_origin.z

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = spawn_origin,
		--vSourceLoc = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack1")),
		
	    bDeleteOnHit = true,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_NONE,
	    
	    EffectName = nil,
	    fDistance = projectile_distance,
	    bHasFrontalCone = false,
		bReplaceExisting = false,
		vVelocity = projectile_direction * projectile_speed,

		ExtraData = {
			origin_x = origin.x,
			origin_y = origin.y,
			origin_z = origin.z,
			distance = projectile_distance,
			height = height,
			returning = 0,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- deactivate ability
	self:SetActivated( false )
	local ability = caster:FindAbilityByName( "imba_dark_willow_bedlam" )
	if ability then ability:SetActivated( false ) end
end
--------------------------------------------------------------------------------
-- Projectile
function imba_dark_willow_terrorize:OnProjectileHit_ExtraData( target, location, ExtraData )
	local returning = ExtraData.returning==1

	if returning then
		-- kill the wisp
		UTIL_Remove( self.wisp )

		-- deactivate ability
		self:SetActivated( true )
		local ability = self:GetCaster():FindAbilityByName( "imba_dark_willow_bedlam" )
		if ability then ability:SetActivated( true ) end
		return
	end

	-- get data
	local radius = self:GetSpecialValueFor( "destination_radius" )
	local duration = self:GetSpecialValueFor( "destination_status_duration" ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_dark_willow_2")

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		location,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- add fear
		enemy:AddNewModifier_RS(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_imba_dark_willow_terrorize", -- modifier name
			{ duration = duration } -- kv
		)
	end

	-- create return projectile
	local projectile_speed = self:GetSpecialValueFor( "return_travel_speed" )
	local info = {
		Target = self:GetCaster(),
		Source = self.wisp,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional

		ExtraData = {
			returning = 1,
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)

	-- set wisp activity
	self.wisp:StartGesture( ACT_DOTA_CAST_ABILITY_5 )

	-- play effects
	self:PlayEffects3( location, radius, #enemies )
end

function imba_dark_willow_terrorize:OnProjectileThink_ExtraData( location, ExtraData )
	local returning = ExtraData.returning==1
	if returning then
		-- get facing direction
		local direction = self:GetCaster():GetOrigin()-location
		direction.z = 0
		direction = direction:Normalized()

		-- set position
		self.wisp:SetOrigin( location )
		self.wisp:SetForwardVector( direction )
		return
	end

	-- get data
	local origin = Vector( ExtraData.origin_x, ExtraData.origin_y, ExtraData.origin_z )
	local distance = ExtraData.distance
	local height = ExtraData.height

	-- interpolate height
	local current_dist = (location-origin):Length2D()

	local current_height = height - (current_dist/distance)*height

	self.wisp:SetOrigin( location + Vector( 0,0,current_height ) )
end

--------------------------------------------------------------------------------
function imba_dark_willow_terrorize:PlayEffects1( point, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_marker.vpcf"

	-- Create Particle
	self.effect_cast1 = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast1, 0, point )
	ParticleManager:SetParticleControl( self.effect_cast1, 1, Vector( radius, 0, 0 ) )
	-- if is rubick arcana
	ParticleManager:SetParticleControl( self.effect_cast1, 60, Vector( 0, 0, 255) )
	ParticleManager:SetParticleControl( self.effect_cast1, 61, Vector( 1, 0, 0 ) )

	-- play sound
	local sound_cast1 = "Hero_DarkWillow.Fear.Cast"
	local sound_cast2 = "Hero_DarkWillow.Fear.Wisp"
	local sound_cast3 = "Hero_DarkWillow.Fear.Location"
	EmitSoundOn( sound_cast1, self:GetCaster() )
	EmitSoundOn( sound_cast2, self:GetCaster() )
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast3, self:GetCaster() )
end
function imba_dark_willow_terrorize:StopEffects1()
	-- destroy particle
	ParticleManager:DestroyParticle( self.effect_cast1, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast1 )

	-- stop sound
	local sound_cast1 = "Hero_DarkWillow.Fear.Cast"
	local sound_cast2 = "Hero_DarkWillow.Fear.Wisp"
	local sound_cast3 = "Hero_DarkWillow.Fear.Location"
	StopSoundOn( sound_cast1, self:GetCaster() )
	StopSoundOn( sound_cast2, self:GetCaster() )
	StopSoundOn( sound_cast3, self:GetCaster() )
end

function imba_dark_willow_terrorize:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_channel.vpcf"

	-- Create Particle
	self.effect_cast2 = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.wisp )
	-- if is rubick arcana
	ParticleManager:SetParticleControl( self.effect_cast2, 60, Vector( 0, 0, 255) )
	ParticleManager:SetParticleControl( self.effect_cast2, 61, Vector( 1, 0, 0 ) )
end
function imba_dark_willow_terrorize:StopEffects2()
	-- destroy particle
	ParticleManager:DestroyParticle( self.effect_cast2, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast2 )
end

function imba_dark_willow_terrorize:PlayEffects3( point, radius, number )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell.vpcf"
	local sound_cast = "Hero_DarkWillow.Fear.FP"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 0, radius*2 ) )

	-- if is rubick arcana
	ParticleManager:SetParticleControl( self.effect_cast1, 60, Vector( 0, 0, 255) )
	ParticleManager:SetParticleControl( self.effect_cast1, 61, Vector( 1, 0, 0 ) )

	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	if number>0 then
		EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
modifier_imba_dark_willow_terrorize = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_dark_willow_terrorize:IsHidden() return false end
function modifier_imba_dark_willow_terrorize:IsDebuff() return true end
function modifier_imba_dark_willow_terrorize:IsStunDebuff() return false end
function modifier_imba_dark_willow_terrorize:IsPurgable() return true end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_dark_willow_terrorize:OnCreated( kv )
	if not IsServer() then return end
	-- play effects
	self:PlayEffects()

	-- if neutral, set disarm to run back towards camp
	if self:GetParent():IsNeutralUnitType() then
		self.neutral = true
	end

	-- find enemy fountain
	local buildings = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		Vector(0,0,0),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local fountain = nil
	for _,building in pairs(buildings) do
		if building:GetClassname()=="ent_dota_fountain" then
			fountain = building
			break
		end
	end

	-- if no fountain, just don't do anything
	if not fountain then return end

	-- for lane creep, MoveToPosition won't work, so use this
	if self:GetParent():IsCreep() then
		self:GetParent():SetForceAttackTargetAlly( fountain ) -- for creeps
	end

	-- for others, order to run to fountain
	self:GetParent():MoveToPosition( fountain:GetOrigin() )
end

function modifier_imba_dark_willow_terrorize:OnRefresh( kv ) end
function modifier_imba_dark_willow_terrorize:OnRemoved() end
function modifier_imba_dark_willow_terrorize:OnDestroy()
	if not IsServer() then return end

	-- stop running
	self:GetParent():Stop()
	if self:GetParent():IsCreep() then
		self:GetParent():SetForceAttackTargetAlly( nil ) -- for creeps
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_dark_willow_terrorize:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_imba_dark_willow_terrorize:GetModifierProvidesFOWVision()
	return 1
end

function modifier_imba_dark_willow_terrorize:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.target ~= self:GetParent() or not keys.attacker:IsHero() or not keys.target:IsAlive() then
		return
	end
	-- precache damage
	local damageTable = {
		victim = keys.target,
		attacker = keys.attacker,
		damage = self:GetAbility():GetSpecialValueFor("terrorize_damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	local damage_calculate = ApplyDamage(damageTable)
	-- overhead event
	SendOverheadEventMessage(
		nil, --DOTAPlayer sendToPlayer,
		OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
		keys.target,
		damage_calculate,
		keys.attacker:GetPlayerOwner() -- DOTAPlayer sourcePlayer
	)
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_imba_dark_willow_terrorize:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = self.neutral,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_dark_willow_terrorize:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_wisp_fear.vpcf"
end

function modifier_imba_dark_willow_terrorize:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_debuff.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_fear_debuff.vpcf"

	-- Create Particle
    local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    -- if is rubick arcana
	ParticleManager:SetParticleControl( effect_cast1, 60, Vector( 0, 0, 255) )
	ParticleManager:SetParticleControl( effect_cast1, 61, Vector( 1, 0, 0 ) )

	local effect_cast2 = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	-- if is rubick arcana
	ParticleManager:SetParticleControl( effect_cast2, 60, Vector( 0, 0, 255) )
	ParticleManager:SetParticleControl( effect_cast2, 61, Vector( 1, 0, 0 ) )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end