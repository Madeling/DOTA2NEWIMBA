CreateTalents("npc_dota_hero_shredder", "linken/hero_shredder.lua")
------2020.1.2--by--你收拾收拾准备出林肯吧
imba_shredder_whirling_death = class({})	
LinkLuaModifier( "modifier_imba_shredder_whirling_death", "linken/hero_shredder.lua", LUA_MODIFIER_MOTION_NONE ) 

--------------------------------------------------------------------------------
-- Ability Start
function imba_shredder_whirling_death:GetCastRange()
	return self:GetSpecialValueFor( "whirling_radius" ) + self:GetCaster():TG_GetTalentValue("special_bonus_shredder_7") - self:GetCaster():GetCastRangeBonus() 
end
function imba_shredder_whirling_death:OnSpellStart()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor( "whirling_radius" ) + self:GetCaster():TG_GetTalentValue("special_bonus_shredder_7")
	local damage = self:GetSpecialValueFor( "whirling_damage" )
	local duration = self:GetSpecialValueFor( "duration" )
	local tree_damage = self:GetSpecialValueFor( "tree_damage_scale" )
	local trees = GridNav:GetAllTreesAroundPoint( caster:GetOrigin(), radius, false )
	GridNav:DestroyTreesAroundPoint( caster:GetOrigin(), radius, false )
	-- calculate and precache damage
	damage = damage + #trees * tree_damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local hashero = false
	for _,enemy in pairs(enemies) do
		-- debuff if hero
		if enemy:IsHero() then
			TG_AddNewModifier_RS(
				enemy,
				caster, -- player source
				self, -- ability source
				"modifier_imba_shredder_whirling_death", -- modifier name
				{ duration = duration } -- kv
			)

			hashero = true
		end

		-- damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )
	end

	-- Play effects
	self:PlayEffects( radius, hashero )
end

--------------------------------------------------------------------------------
function imba_shredder_whirling_death:PlayEffects( radius, hashero )
	if not IsServer() then return end
	local particle_cast = "particles/units/heroes/hero_shredder/shredder_whirling_death.vpcf"
	local sound_cast = "Hero_Shredder.WhirlingDeath.Cast"
	local sound_target = "Hero_Shredder.WhirlingDeath.Damage"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CENTER_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_CENTER_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	if hashero then
		EmitSoundOn( sound_target, self:GetCaster() )
	end
end

modifier_imba_shredder_whirling_death = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_shredder_whirling_death:IsHidden()
	return false
end

function modifier_imba_shredder_whirling_death:IsDebuff()
	return true
end

function modifier_imba_shredder_whirling_death:IsStunDebuff()
	return false
end

function modifier_imba_shredder_whirling_death:IsPurgable()
	return true
end

function modifier_imba_shredder_whirling_death:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_shredder_whirling_death:OnCreated( kv )
self.stat_loss_pct = self:GetAbility():GetSpecialValueFor( "stat_loss_pct" ) + self:GetCaster():TG_GetTalentValue("special_bonus_shredder_1")
	if not IsServer() then return end
	self.parent = self:GetParent()

	-- calculate stat loss
	self.stat_loss = -self.parent:GetPrimaryStatValue() * self.stat_loss_pct / 100
	self.stat_loss_stt = -self.parent:GetPrimaryStatValue() * self.stat_loss_pct / 100 * 2
	self.stat_loss_st = -self.parent:GetStrength() * self.stat_loss_pct / 100
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_shredder_whirling_death:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}

	return funcs
end

if IsServer() then
	function modifier_imba_shredder_whirling_death:GetModifierBonusStats_Agility()
		if self.parent:GetPrimaryAttribute()~=DOTA_ATTRIBUTE_AGILITY then return 0 end
		return self.stat_loss or 0
	end
	function modifier_imba_shredder_whirling_death:GetModifierBonusStats_Intellect()
		if self.parent:GetPrimaryAttribute()~=DOTA_ATTRIBUTE_INTELLECT then return 0 end
		return self.stat_loss or 0
	end
	function modifier_imba_shredder_whirling_death:GetModifierBonusStats_Strength()
		if self.parent:GetPrimaryAttribute()~=DOTA_ATTRIBUTE_STRENGTH then return self.stat_loss_st end
		return self.stat_loss_stt or 0
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_shredder_whirling_death:GetStatusEffectName()
	return "particles/status_fx/status_effect_shredder_whirl.vpcf"
end

function modifier_imba_shredder_whirling_death:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_imba_shredder_whirling_death:GetEffectName()
	return "particles/units/heroes/hero_shredder/shredder_whirling_death_debuff.vpcf"
end

function modifier_imba_shredder_whirling_death:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end




--------------------------------------------------------------------------------
imba_shredder_timber_chain = class({})
LinkLuaModifier( "modifier_imba_shredder_timber_chain", "linken/hero_shredder.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_imba_shredder_timber_chain_interval", "linken/hero_shredder.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_imba_shredder_timber_chain_pass", "linken/hero_shredder.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_imba_timber_chain_thinker", "linken/hero_shredder.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
imba_shredder_timber_chain_destroy = class({})
function imba_shredder_timber_chain_destroy:CastFilterResult()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_imba_shredder_timber_chain")
	if not modifier then
		return UF_FAIL_CUSTOM
	end
end

function imba_shredder_timber_chain_destroy:GetCustomCastError()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_imba_shredder_timber_chain")
	if not modifier then
		return "#dota_hud_error_ability_inactive"
	end
end
function imba_shredder_timber_chain_destroy:OnSpellStart()
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_imba_shredder_timber_chain")
	local ability = caster:FindAbilityByName("imba_shredder_timber_chain")
	local pos = ability.pos
	local ability2 = caster:FindAbilityByName("imba_shredder_whirling_death")
	if modifier then
		caster:RemoveHorizontalMotionController( modifier )
		modifier:Destroy()
	end
	if TG_Distance(pos,caster:GetAbsOrigin()) >= self:GetSpecialValueFor("direction") then
		ability2:OnSpellStart()
	end	
end

--------------------------------------------------------------------------------
-- Ability Start
function imba_shredder_timber_chain:GetCastRange()
	if not IsServer() then return end 			
	return self:GetSpecialValueFor("range") + self:GetCaster():TG_GetTalentValue("special_bonus_shredder_2")
end
function imba_shredder_timber_chain:OnUpgrade()
	local ability = self:GetCaster():FindAbilityByName("imba_shredder_timber_chain_destroy")
	if ability and self:GetLevel() <= 1 then
		ability:SetLevel(self:GetLevel())
	end
end
function imba_shredder_timber_chain:GetIntrinsicModifierName()
  return "modifier_imba_shredder_timber_chain_pass"
end
function imba_shredder_timber_chain:OnSpellStart(target, location, ExtraData,keys)
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	self.pos = caster:GetAbsOrigin()
	--if keys == self:GetSpecialValueFor( "repeat_counter" )	then
	--	return
	--end	

	-- load data
	local projectile_speed = self:GetSpecialValueFor( "speed" )		
	local projectile_distance = self:GetSpecialValueFor( "range" ) + self:GetCaster():TG_GetTalentValue("special_bonus_shredder_2")
	local projectile_radius = self:GetSpecialValueFor( "radius" )
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	local tree_radius = self:GetSpecialValueFor( "chain_radius" )
	local vision = 100

	-- create effect
	local effect = self:PlayEffects( caster:GetOrigin() + projectile_direction * projectile_distance, projectile_speed, projectile_distance/projectile_speed )

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    EffectName = "",
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius = projectile_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		
		bProvidesVision = true,
		iVisionRadius = vision,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}

	-- register projectile
	local projectile = ProjectileManager:CreateLinearProjectile(info)
	local ExtraData = {
		effect = effect,
		radius = tree_radius,
	}
	self.projectiles[ projectile ] = ExtraData
end
--------------------------------------------------------------------------------
-- Projectile
imba_shredder_timber_chain.projectiles = {}
function imba_shredder_timber_chain:OnProjectileThinkHandle( handle )
	-- get data
	local ExtraData = self.projectiles[ handle ]
	local location = ProjectileManager:GetLinearProjectileLocation( handle )
	--local projectile_distance = self:GetSpecialValueFor( "range" ) + self:GetCaster():TG_GetTalentValue("special_bonus_shredder_2")
	self.acc_range = self:GetSpecialValueFor( "acc_range" )
	--DebugDrawCircle(location, Vector(255,0,0), 100, 50, true, 0.1)
	-- search for tree
	trees_first = GridNav:GetAllTreesAroundPoint( location, ExtraData.radius, false )

	------------------------------盘子1
	local radius = self:GetCaster():FindAbilityByName("imba_shredder_chakram"):GetSpecialValueFor( "radius" )
	local pos = self:GetCaster():FindAbilityByName("imba_shredder_chakram").pos	or self:GetCaster():FindAbilityByName("imba_shredder_chakram_2").pos
	local pos_bool = self:GetCaster():FindAbilityByName("imba_shredder_chakram").pos_bool or self:GetCaster():FindAbilityByName("imba_shredder_chakram_2").pos_bool
	if pos_bool and pos and (pos - location):Length2D() <= radius and (pos - self:GetCaster():GetAbsOrigin()):Length2D() > radius then
		local caster = self:GetCaster()
		local distance = (pos - caster:GetAbsOrigin()):Normalized()
		local now_pos = pos + distance * self.acc_range
		self.sound = CreateModifierThinker(caster, self, "modifier_imba_timber_chain_thinker", {duration = 3.0}, now_pos, caster:GetTeamNumber(), false)
		local pos1 = self.sound:GetAbsOrigin()
		self:GetCaster():AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_imba_shredder_timber_chain", -- modifier name
			{
				point_x = pos.x,
				point_y = pos.y,
				point_Z = pos.z,
				effect = ExtraData.effect,
				point1_x = pos1.x,
				point1_y = pos1.y,
				point1_z = pos1.z,
			} -- kv
		)

		-- modify effects
		self:ModifyEffects2( ExtraData.effect, pos )

		-- destroy projectile
		ProjectileManager:DestroyLinearProjectile( handle )
		self.projectiles[ handle ] = nil

		-- add vision
		AddFOWViewer( self:GetCaster():GetTeamNumber(), pos, 400, 1, true )
	end
	------------------------------盘子2
	local pos2 = self:GetCaster():FindAbilityByName("imba_shredder_chakram_2").pos2
	--print(pos2)
	local pos_bool2 = self:GetCaster():FindAbilityByName("imba_shredder_chakram_2").pos_bool
	if pos_bool2 and pos2 and (pos2 - location):Length2D() <= radius and (pos2 - self:GetCaster():GetAbsOrigin()):Length2D() > radius then
		local caster = self:GetCaster()
		local distance = (pos2 - caster:GetAbsOrigin()):Normalized()
		local now_pos = pos2 + distance * self.acc_range
		self.sound = CreateModifierThinker(caster, self, "modifier_imba_timber_chain_thinker", {duration = 3.0}, now_pos, caster:GetTeamNumber(), false)
		local pos1 = self.sound:GetAbsOrigin()
		self:GetCaster():AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_imba_shredder_timber_chain", -- modifier name
			{
				point_x = pos2.x,
				point_y = pos2.y,
				point_Z = pos2.z,
				effect = ExtraData.effect,
				point1_x = pos1.x,
				point1_y = pos1.y,
				point1_z = pos1.z,
			} -- kv
		)

		-- modify effects
		self:ModifyEffects2( ExtraData.effect, pos2 )

		-- destroy projectile
		ProjectileManager:DestroyLinearProjectile( handle )
		self.projectiles[ handle ] = nil

		-- add vision
		AddFOWViewer( self:GetCaster():GetTeamNumber(), pos2, 400, 1, true )
	end	


	if #trees_first>0 then
		local caster = self:GetCaster()
		trees_point = trees_first[1]:GetOrigin()
		local distance = (trees_point - caster:GetAbsOrigin()):Normalized()
		local now_pos = trees_point + distance * self.acc_range
		self.sound = CreateModifierThinker(caster, self, "modifier_imba_timber_chain_thinker", {duration = 3.0}, now_pos, caster:GetTeamNumber(), false)
		local pos1 = self.sound:GetAbsOrigin()
		self:GetCaster():AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_imba_shredder_timber_chain", -- modifier name
			{
				point_x = trees_point.x,
				point_y = trees_point.y,
				point_Z = trees_point.z,
				effect = ExtraData.effect,
				point1_x = pos1.x,
				point1_y = pos1.y,
				point1_z = pos1.z,
			} -- kv
		)

		-- modify effects
		self:ModifyEffects2( ExtraData.effect, trees_point )

		-- destroy projectile
		ProjectileManager:DestroyLinearProjectile( handle )
		self.projectiles[ handle ] = nil

		-- add vision
		AddFOWViewer( self:GetCaster():GetTeamNumber(), trees_point, 400, 1, true )
	end
end

function imba_shredder_timber_chain:OnProjectileHitHandle( target, location, handle )
	local ExtraData = self.projectiles[ handle ]
	--DebugDrawCircle(location, Vector(255,0,0), 100, 50, true, 0.1)
	if not ExtraData then return end
	--DebugDrawCircle(location, Vector(255,0,0), 100, 50, true, 0.1)	

	-- add vision
	AddFOWViewer( self:GetCaster():GetTeamNumber(), location, 400, 0.1, true )

	-- play effect
	self:ModifyEffects1( ExtraData.effect )

	-- destroy reference
	self.projectiles[ handle ] = nil
end

--------------------------------------------------------------------------------
function imba_shredder_timber_chain:PlayEffects( point, speed, duration )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_shredder/shredder_timberchain.vpcf"
	local sound_cast = "Hero_Shredder.TimberChain.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 1, point )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( speed, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( duration*2 + 0.3, 0, 0 ) )

	EmitSoundOn( sound_cast, self:GetCaster() )

	return effect_cast
end
function imba_shredder_timber_chain:ModifyEffects1( effect )
	ParticleManager:SetParticleControlEnt(
		effect,
		1,
		self:GetCaster(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect )

	-- play sound
	local sound_cast = "Hero_Shredder.TimberChain.Retract"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function imba_shredder_timber_chain:ModifyEffects2( effect, point )
	ParticleManager:SetParticleControl( effect, 1, point )

	ParticleManager:SetParticleControl( effect, 3, Vector( 20, 0, 0 ) )

	-- play sound
	local sound_cast = "Hero_Shredder.TimberChain.Retract"
	local sound_target = "Hero_Shredder.TimberChain.Impact"
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOnLocationWithCaster( point, sound_target, self:GetCaster() )
end

modifier_imba_shredder_timber_chain = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_shredder_timber_chain:IsHidden()
	return true
end

function modifier_imba_shredder_timber_chain:IsDebuff()
	return false
end

function modifier_imba_shredder_timber_chain:IsStunDebuff()
	return false
end

function modifier_imba_shredder_timber_chain:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_shredder_timber_chain:OnCreated( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	if not IsServer() then return end

	-- references

	self.point = Vector( kv.point_x, kv.point_y, kv.point_z )
	self.effect = kv.effect
	self.pos = Vector( kv.point1_x, kv.point1_y, kv.point1_z )

	-- precache damage
	self.damageTable = {
	-- victim = target,
	attacker = self:GetCaster(),
	damage = damage,
	damage_type = self:GetAbility():GetAbilityDamageType(),
	ability = self:GetAbility(), --Optional.
	}

	self.proximity = 50
	self.caught_enemies = {}
	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
	end

end

function modifier_imba_shredder_timber_chain:OnRefresh( kv )
	if not IsServer() then return end
	local old_effect = self.effect

	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.point = Vector( kv.point_x, kv.point_y, kv.point_z )
	self.effect = kv.effect

	-- update damage

	self.damageTable.damage = damage
	
	-- init
	self.caught_enemies = {}

	-- destroy previous effect
	if old_effect then
		ParticleManager:DestroyParticle( old_effect, false )
		ParticleManager:ReleaseParticleIndex( old_effect )
	end	
end
function modifier_imba_shredder_timber_chain:OnRemoved()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )	
end
function modifier_imba_shredder_timber_chain:OnDestroy()
	if not IsServer() then return end

	-- remove effect
	if self.effect then
		ParticleManager:DestroyParticle( self.effect, false )
		ParticleManager:ReleaseParticleIndex( self.effect )
	end	

	-- play sound
	local sound_cast = "Hero_Shredder.TimberChain.Impact"
	EmitSoundOn( sound_cast, self:GetParent() )
	local ability = self:GetAbility()
	if ability.sound then
		ability.sound:Destroy()
	end	

	--[[local pos = self:GetAbility().pos
	local caster = self:GetCaster()
	local loc = (caster:GetAbsOrigin() - pos):Length2D()
	if loc >= self:GetAbility():GetSpecialValueFor( "shard_range" ) and not self:GetAbility().bool then
		self:GetCaster():SetCursorPosition(caster:GetAbsOrigin() + caster:GetForwardVector() * 500)
		self:GetAbility():OnSpellStart(nil,nil,nil,true)
	end]]		
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_imba_shredder_timber_chain:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_imba_shredder_timber_chain:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end
	local origin = me:GetOrigin()
	if self:GetAbility():GetAutoCastState() then
		self.point = self.pos
	end	
	local direction = (self.point-origin)
	direction.z = 0
	direction = direction:Normalized()

	-- set origin
	local target = origin + direction * self.speed * dt
	me:SetOrigin( target )

	-- find enemies
	local enemies = FindUnitsInRadius(
		me:GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	GridNav:DestroyTreesAroundPoint( origin, 50, true )		
	for _,enemy in pairs(enemies) do
		-- check if already hit
		if not self.caught_enemies[enemy] then
			self.caught_enemies[enemy] = true

			-- damage
			self.damageTable.victim = enemy
			if enemy:IsHero() then
				self.damageTable.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + (enemy:GetStrength() * self:GetAbility():GetSpecialValueFor( "strength_multiple" ))
			end	
			ApplyDamage( self.damageTable )
			-- play effects
			self:PlayEffects( enemy )
		end	
	end
	-- destroy if stunned
	--if me:IsStunned() or not me:IsAlive() then
	if not me:IsAlive() then	
		me:RemoveHorizontalMotionController( self )
		self:Destroy()
	end

	-- destroy if reached target
	if (self.point-origin):Length2D()<self.proximity then
		-- destroy tree

		local trees = GridNav:GetAllTreesAroundPoint( origin, 20, true )
		GridNav:DestroyTreesAroundPoint( origin, 20, true )
		self:GetParent():SetOrigin( self.point )

		-- destroy
		me:RemoveHorizontalMotionController( self )
		self:Destroy()
	end

end

function modifier_imba_shredder_timber_chain:OnHorizontalMotionInterrupted()
	if not IsServer() then return end
	-- destroy
	self:GetParent():RemoveHorizontalMotionController( self )
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_shredder_timber_chain:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_shredder/shredder_timber_dmg.vpcf"
	local sound_cast = "Hero_Shredder.TimberChain.Damage"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end
function modifier_imba_shredder_timber_chain:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
end
function modifier_imba_shredder_timber_chain:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_MIN_HEALTH, MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE}
end
function modifier_imba_shredder_timber_chain:GetModifierTurnRate_Percentage()	
	return 1000
end
function modifier_imba_shredder_timber_chain:GetMinHealth() return 2 end


modifier_imba_shredder_timber_chain_pass= class({})
function modifier_imba_shredder_timber_chain_pass:IsDebuff()      return false end
function modifier_imba_shredder_timber_chain_pass:IsHidden()      return true end
function modifier_imba_shredder_timber_chain_pass:IsPurgable()    return false end
function modifier_imba_shredder_timber_chain_pass:IsPurgeException()  return false end
function modifier_imba_shredder_timber_chain_pass:OnCreated(params)
  if IsServer() then
    self:StartIntervalThink(1)
  end
end
function modifier_imba_shredder_timber_chain_pass:OnIntervalThink()
  local ability = self:GetAbility()
  if self:GetParent():Has_Aghanims_Shard() then
	local ability = self:GetAbility()
	AbilityChargeController:AbilityChargeInitialize(ability, ability:GetCooldown(4 - 1), ability:GetSpecialValueFor( "repeat_counter" ), 1, true, true)
	self:StartIntervalThink(-1)
	self:Destroy()
	return
  end 
end
modifier_imba_timber_chain_thinker = class({})
function modifier_imba_timber_chain_thinker:IsDebuff()				return false end
function modifier_imba_timber_chain_thinker:IsHidden() 			return false end
function modifier_imba_timber_chain_thinker:IsPurgable() 			return false end
function modifier_imba_timber_chain_thinker:IsPurgeException() 	return false end
function modifier_imba_timber_chain_thinker:OnCreated(keys)
	if IsServer() then
		local caster = self:GetParent()
		self.ability = self:GetAbility()
		if self.ability:GetAutoCastState() then
			AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 300, 3, true)
			self.pfx = ParticleManager:CreateParticleForPlayer("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner())
			ParticleManager:SetParticleControl(self.pfx, 1, Vector(100, 0, 0))
			ParticleManager:SetParticleControl(self.pfx, 2, Vector(10, 0, 0))
			ParticleManager:SetParticleControl(self.pfx, 3, Vector(100, 0, 0))
			ParticleManager:SetParticleControl(self.pfx, 15, Vector(255, 0, 255))
			self:AddParticle(self.pfx, true, false, 15, false, false)
		end	
	end 
end
function modifier_imba_timber_chain_thinker:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.Pfx2, false)
			ParticleManager:ReleaseParticleIndex(self.Pfx2)
		end			
		self:GetParent():RemoveSelf()
	end
end

imba_shredder_reactive_armor = class({})
LinkLuaModifier( "modifier_imba_shredder_reactive_armor", "linken/hero_shredder.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_shredder_reactive_armor_stack", "linken/hero_shredder.lua", LUA_MODIFIER_MOTION_NONE ) 
LinkLuaModifier( "modifier_imba_shredder_reactive_armor_whirling_death", "linken/hero_shredder.lua", LUA_MODIFIER_MOTION_NONE ) 
LinkLuaModifier( "modifier_imba_shredder_reactive_armor_whirling_death_prevent", "linken/hero_shredder.lua", LUA_MODIFIER_MOTION_NONE ) 

--------------------------------------------------------------------------------
-- Passive Modifier

function imba_shredder_reactive_armor:GetIntrinsicModifierName()
	return "modifier_imba_shredder_reactive_armor"
end
function imba_shredder_reactive_armor:CastFilterResult()
	if not IsServer() then return end
	local duizhan = self:GetCaster():FindModifierByName("modifier_imba_shredder_reactive_armor")
	local stack_limit = self:GetSpecialValueFor( "stack_limit" )	
	if duizhan:GetStackCount()<stack_limit then
		return UF_FAIL_CUSTOM
	end
end

function imba_shredder_reactive_armor:GetCustomCastError()
	if not IsServer() then return end
	local duizhan = self:GetCaster():FindModifierByName("modifier_imba_shredder_reactive_armor")
	local stack_limit = self:GetSpecialValueFor( "stack_limit" )
	if duizhan:GetStackCount()<stack_limit then
		return "#dota_hud_error_ability_inactive"
	end
end
function imba_shredder_reactive_armor:GetCooldown(level)
	--if not IsServer() then return end
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_shredder_3") then 
		return (cooldown - caster:TG_GetTalentValue("special_bonus_shredder_3"))
	end
	return cooldown
end
function imba_shredder_reactive_armor:OnSpellStart()
	local modifier = self:GetCaster():FindModifierByName("modifier_imba_shredder_reactive_armor")
	local modifier1 = self:GetCaster():FindModifierByName("modifier_imba_shredder_reactive_armor_stack")
	local modifier2 = "modifier_imba_shredder_reactive_armor_stack"
	if not IsServer() then return end
	  local modifier_count = self:GetCaster():GetModifierCount()
	  for i = 0, modifier_count do
	      local modifier_name = self:GetCaster():GetModifierNameByIndex(i)
	      if modifier_name==modifier2 then 
	        self:GetCaster():RemoveModifierByName(modifier2)
	        modifier1:SetStackCount(modifier1:GetStackCount()-1) 
	      end
	  end	
	self:GetCaster():Purge(false, true, false, true, true)
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_shredder_reactive_armor_whirling_death", {duration = self:GetSpecialValueFor("buff_duration")}) 
end
modifier_imba_shredder_reactive_armor_whirling_death = class({})
function modifier_imba_shredder_reactive_armor_whirling_death:IsHidden()
	return false
end

function modifier_imba_shredder_reactive_armor_whirling_death:IsDebuff()
	return false
end

function modifier_imba_shredder_reactive_armor_whirling_death:IsStunDebuff()
	return false
end

function modifier_imba_shredder_reactive_armor_whirling_death:IsPurgable()
	return false
end
function modifier_imba_shredder_reactive_armor_whirling_death:IsPurgeException() 	
	return false 
end

function modifier_imba_shredder_reactive_armor_whirling_death:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end
function modifier_imba_shredder_reactive_armor_whirling_death:OnCreated( kv )
	if not IsServer() then return end
	self:StartIntervalThink(0.5)
end	
function modifier_imba_shredder_reactive_armor_whirling_death:OnDeath( keys ) 	
if not IsServer() then return end	
	if not IsServer() or self:GetParent():IsIllusion() then
		return
	end
end
function modifier_imba_shredder_reactive_armor_whirling_death:OnRespawn( keys )
	if not IsServer() then return end
	if not IsServer() or self:GetParent():IsIllusion() then
		return
	end
end
function modifier_imba_shredder_reactive_armor_whirling_death:DestroyOnExpire()
	return true
end
function modifier_imba_shredder_reactive_armor_whirling_death:RemoveOnDeath()
	return true 
end
function modifier_imba_shredder_reactive_armor_whirling_death:OnTakeDamage(keys) 	  
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return 
	end
	if keys.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() or self:GetParent():IsIllusion() or keys.attacker:IsBuilding() or self:GetCaster():HasModifier("modifier_imba_shredder_reactive_armor_whirling_death_prevent") then
		return
	end	
	if PseudoRandom:RollPseudoRandom(self:GetAbility(),(self:GetAbility():GetSpecialValueFor("chance")+self:GetCaster():TG_GetTalentValue("special_bonus_shredder_3"))) and self:GetCaster():FindAbilityByName("imba_shredder_whirling_death"):IsTrained() and not self:GetCaster():HasModifier("modifier_imba_shredder_reactive_armor_whirling_death_prevent") then
		self:GetCaster():FindAbilityByName("imba_shredder_whirling_death"):OnSpellStart()
		self:GetCaster():Purge(false, true, false, true, true)
		self:GetCaster():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_shredder_reactive_armor_whirling_death_prevent", {duration = self:GetAbility():GetSpecialValueFor("cooldown")})
	end	
end

function modifier_imba_shredder_reactive_armor_whirling_death:OnIntervalThink()
	if not IsServer() then return end
	self:PlayEffects( radius, hashero )
end
function modifier_imba_shredder_reactive_armor_whirling_death:PlayEffects( radius, hashero )
	if not IsServer() then return end
	local particle_cast = "particles/units/heroes/hero_shredder/shredder_whirling_death_spin.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CENTER_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_CENTER_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end






modifier_imba_shredder_reactive_armor_whirling_death_prevent = class({})

function modifier_imba_shredder_reactive_armor_whirling_death_prevent:IsDebuff()			return false end
function modifier_imba_shredder_reactive_armor_whirling_death_prevent:IsHidden() 			return true end
function modifier_imba_shredder_reactive_armor_whirling_death_prevent:IsPurgable() 			return false end
function modifier_imba_shredder_reactive_armor_whirling_death_prevent:IsPurgeException() 	return false end




--------------------------------------------------------------------------------------------------------


modifier_imba_shredder_reactive_armor = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_shredder_reactive_armor:IsHidden()
	return self:GetStackCount()==0
end

function modifier_imba_shredder_reactive_armor:IsDebuff()
	return false
end

function modifier_imba_shredder_reactive_armor:IsStunDebuff()
	return false
end

function modifier_imba_shredder_reactive_armor:IsPurgable()
	return false
end
function modifier_imba_shredder_reactive_armor:IsPurgeException() 	
	return false 
end

function modifier_imba_shredder_reactive_armor:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_shredder_reactive_armor:OnCreated( kv )
	self.stack_duration = self:GetAbility():GetSpecialValueFor( "stack_duration" )
	self.stack_regen = self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" ) --生命恢复
	self.stack_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) --护甲
	self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" ) --魔抗
	self.stack_limit = self:GetAbility():GetSpecialValueFor( "stack_limit" ) + self:GetCaster():TG_GetTalentValue("special_bonus_shredder_4")
	--self:GetParent():CalculateStatBonus(true)
end

function modifier_imba_shredder_reactive_armor:OnRefresh( kv )
	self.stack_duration = self:GetAbility():GetSpecialValueFor( "stack_duration" )
	self.stack_regen = self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" ) --生命恢复
	self.stack_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) --护甲
	self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" ) --魔抗
	self.stack_limit = self:GetAbility():GetSpecialValueFor( "stack_limit" ) + self:GetCaster():TG_GetTalentValue("special_bonus_shredder_4")
	--self:GetParent():CalculateStatBonus(true)
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_shredder_reactive_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_imba_shredder_reactive_armor:OnAttackLanded( params )
	if not IsServer() then return end
	if params.target ~= self:GetParent() then return end
	-- cancel if break
	if self:GetParent():PassivesDisabled() then return end
	if not self:GetParent():IsAlive() then return end
	if self:GetParent():HasModifier("modifier_imba_shredder_reactive_armor_whirling_death") then return end
	if #self:GetParent():FindAllModifiersByName("modifier_imba_shredder_reactive_armor_stack") >= 100 	then return end	
	-- add stack
		local modifier = self:GetParent():AddNewModifier(
				self:GetParent(), -- player source
				self:GetAbility(), -- ability source
				"modifier_imba_shredder_reactive_armor_stack", -- modifier name
				{ duration = self.stack_duration } -- kv
			)
		modifier.parent = self
		self:SetDuration( self.stack_duration, true )		
		self:SetStackCount(math.min(#self:GetParent():FindAllModifiersByName("modifier_imba_shredder_reactive_armor_stack"), self.stack_limit))
	--	print(self.stack_armor * self:GetStackCount())
end
function modifier_imba_shredder_reactive_armor:OnDeath( keys )
	if not IsServer() or self:GetParent():IsIllusion() then
		return
	end
end
function modifier_imba_shredder_reactive_armor:OnRespawn( keys )
	if not IsServer() or self:GetParent():IsIllusion() then
		return
	end
end		

function modifier_imba_shredder_reactive_armor:GetModifierPhysicalArmorBonus()
--	if not IsServer() then return end
	return  self.stack_armor * self:GetStackCount()
end
function modifier_imba_shredder_reactive_armor:GetModifierConstantHealthRegen()
	--if not IsServer() then return end
	return self.stack_regen * self:GetStackCount()
end
function modifier_imba_shredder_reactive_armor:GetModifierMagicalResistanceBonus()
--	if not IsServer() then return end
	return self.magic_resistance * self:GetStackCount()
end

function modifier_imba_shredder_reactive_armor:RemoveStack()
	self:SetStackCount(math.min(#self:GetParent():FindAllModifiersByName("modifier_imba_shredder_reactive_armor_stack"), self.stack_limit))
end

modifier_imba_shredder_reactive_armor_stack = class({})----------------------------------------------------------------------------
-- Classifications
function modifier_imba_shredder_reactive_armor_stack:IsHidden()
	return true
end

function modifier_imba_shredder_reactive_armor_stack:IsPurgable()
	return false
end

function modifier_imba_shredder_reactive_armor_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_shredder_reactive_armor_stack:OnDestroy()
	if not IsServer() then return end
	self.parent:RemoveStack()
end

LinkLuaModifier( "modifier_imba_shredder_chakram", "linken/hero_shredder.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_shredder_chakram_disarm", "linken/hero_shredder.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_shredder_chakram_thinker", "linken/hero_shredder.lua", LUA_MODIFIER_MOTION_NONE )



--------------------------------------------------------------------------------
-- Main ability
--------------------------------------------------------------------------------
imba_shredder_chakram = class({})

-- register here for easy copy on scepter ability
imba_shredder_chakram.sub_name = "imba_shredder_return_chakram"
imba_shredder_chakram.scepter = 0

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function imba_shredder_chakram:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function imba_shredder_chakram:GetCooldown(level)
	--if not IsClient() then return end
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_shredder_6") then 
		return (cooldown + caster:TG_GetTalentValue("special_bonus_shredder_6") )
	end
	return cooldown
end

--------------------------------------------------------------------------------
-- Ability Start
function imba_shredder_chakram:OnSpellStart(scepter)
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	if self:GetAbilityName() == "imba_shredder_chakram" then
		self.pos = self:GetCursorPosition()
	elseif 	self:GetAbilityName() == "imba_shredder_chakram_2" then
		self.pos2 = self:GetCursorPosition()
	end	
	self.pos_bool = false

	-- create thinker
	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_imba_shredder_chakram_thinker", -- modifier name
		{
			target_x = point.x,
			target_y = point.y,
			target_z = point.z,
			scepter = self.scepter,
		}, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
	local modifier = thinker:FindModifierByName( "modifier_imba_shredder_chakram_thinker" )

	-- add return ability and swap
	local sub = caster:AddAbility( self.sub_name )
	sub:SetLevel(1)
	caster:SwapAbilities(
		self:GetAbilityName(),
		self.sub_name,
		false,
		true
	)

	-- register each other
	self.modifier = modifier
	self.sub = sub
	sub.modifier = modifier
	modifier.sub = sub

	-- play effects
	local sound_cast = "Hero_Shredder.Chakram.Cast"
	EmitSoundOn( sound_cast, caster )
end

function imba_shredder_chakram:OnUnStolen()
	if self.modifier and not self.modifier:IsNull() then
		-- return the chakram
		self.modifier:ReturnChakram()

		-- reset position
		self:GetCaster():SwapAbilities(
			self:GetAbilityName(),
			self.sub:GetAbilityName(),
			true,
			false
		)
	end
end

--[[function imba_shredder_chakram:OnInventoryContentsChanged()
	if self:GetAbilityName() == "imba_shredder_chakram" then return end
	if self:GetCaster():HasScepter() or self:IsStolen() then
		if not self:IsTrained() then
			self:SetLevel(1)
		end
		
		if not self:GetCaster():FindAbilityByName("imba_shredder_return_chakram_2") or (self:GetCaster():FindAbilityByName("imba_shredder_return_chakram_2") and self:GetCaster():FindAbilityByName("imba_shredder_return_chakram_2"):IsHidden()) then
			self:SetHidden(false)
		end
	else
		if not self:GetCaster():FindAbilityByName("imba_shredder_return_chakram_2") or (self:GetCaster():FindAbilityByName("imba_shredder_return_chakram_2") and self:GetCaster():FindAbilityByName("imba_shredder_return_chakram_2"):IsHidden()) then
			self:SetHidden(true)
		end
	end
end]]

function imba_shredder_chakram:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end
function imba_shredder_chakram:OnInventoryContentsChanged( params )
	local caster = self:GetCaster()

	if self:GetAbilityName() == "imba_shredder_chakram_2" then return end
	local scepter = caster:HasScepter()
	local ability = caster:FindAbilityByName( "imba_shredder_chakram_2" )
	local ability2 = caster:FindAbilityByName( "imba_shredder_return_chakram_2" )	
	if not scepter and ability2 then	
		ability:SetActivated( false )
		ability:SetHidden( true )
		ability2:SetActivated( false )
		ability2:SetHidden( true )
	end	
	if not ability then return end
	if not ability2 then
		ability:SetActivated( scepter )
		ability:SetHidden( not scepter )
		

		if ability:GetLevel() < 1 then
			ability:SetLevel( 1 )
		end
	end
	if ability2 then
		--ability:SetActivated( not scepter )
		--ability:SetHidden(  scepter )
		ability2:SetActivated( scepter )
		ability2:SetHidden( not scepter )		
	end						
end

--------------------------------------------------------------------------------
-- Sub-ability
--------------------------------------------------------------------------------
imba_shredder_return_chakram = class({})

--------------------------------------------------------------------------------
-- Ability Start
function imba_shredder_return_chakram:OnSpellStart()
	if self.modifier and not self.modifier:IsNull() then
		self.modifier:ReturnChakram()
	end
end

--------------------------------------------------------------------------------
-- Scepter-ability
--------------------------------------------------------------------------------
imba_shredder_chakram_2 = class(imba_shredder_chakram)
imba_shredder_chakram_2.sub_name = "imba_shredder_return_chakram_2"
imba_shredder_chakram_2.scepter = 1
imba_shredder_chakram_2.OnInventoryContentsChanged = nil

imba_shredder_return_chakram_2 = class(imba_shredder_return_chakram)




modifier_imba_shredder_chakram_thinker = class({})
local MODE_LAUNCH = 0
local MODE_STAY = 1
local MODE_RETURN = 2

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_shredder_chakram_thinker:IsHidden()
	return true
end

function modifier_imba_shredder_chakram_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_shredder_chakram_thinker:OnCreated( kv )
	self.damage_pass = self:GetAbility():GetSpecialValueFor( "pass_damage" )
	self.damage_stay = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "pass_slow_duration" )
	self.manacost = self:GetAbility():GetSpecialValueFor( "mana_per_second" )
	self.max_range = self:GetAbility():GetSpecialValueFor( "break_distance" )
	self.interval = self:GetAbility():GetSpecialValueFor( "damage_interval" )
	if not IsServer() then return end
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.a = true
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" ) +self:GetCaster():TG_GetTalentValue("special_bonus_shredder_8")
	-- references


	-- kv references
	self.point = Vector( kv.target_x, kv.target_y, kv.target_z )
	self.scepter = kv.scepter==1

	-- init vars
	self.mode = MODE_LAUNCH
	self.move_interval = FrameTime()
	self.proximity = 50
	self.caught_enemies = {}
	self.damageTable = {
		-- victim = target,
		attacker = self.caster,
		-- damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- give vision to thinker
	self.parent:SetDayTimeVisionRange( 500 )
	self.parent:SetNightTimeVisionRange( 500 )

	-- add disarm to caster
	self.disarm = self.caster:AddNewModifier(
		self.caster, -- player source
		self:GetAbility(), -- ability source
		"modifier_imba_shredder_chakram_disarm", -- modifier name
		{} -- kv
	)

	-- Init mode
	self.damageTable.damage = self.damage_pass
	self:StartIntervalThink( self.move_interval )

	-- play effects
	self:PlayEffects1()
end

function modifier_imba_shredder_chakram_thinker:OnDestroy()
	if not IsServer() then return end

	-- remove disarm
	if not self.disarm:IsNull() then
		self.disarm:Destroy()
	end

	-- swap ability back, then remove sub
	local main = self:GetAbility()
	if main and (not main:IsNull()) and (not self.sub:IsNull()) then
		-- check if main is hidden (due to scepter or stolen)
		local active = main:IsActivated()

		self.caster:SwapAbilities(
			main:GetAbilityName(),
			self.sub:GetAbilityName(),
			active,
			false
		)
	end
	--self.sub:SetLevel(1)
	--self.sub:SetHidden(true)
	self.caster:RemoveAbilityByHandle( self.sub )

	-- stop effects
	self:StopEffects()

	-- remove
	--UTIL_Remove( self.parent )
	self.parent:RemoveSelf()	
	local ability = self:GetAbility()
	ability.pos = nil	
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_imba_shredder_chakram_thinker:OnIntervalThink()
	if not IsServer() then return end
	-- check mode
	if self.mode==MODE_LAUNCH then
		self:LaunchThink()
	elseif self.mode==MODE_STAY then
		self:StayThink()
	elseif self.mode==MODE_RETURN then
		self:ReturnThink()
	end
	local caster = self:GetCaster()
	local scepter = caster:HasScepter()
	local ability = self:GetAbility():GetAbilityName() ==  "imba_shredder_chakram_2" 
	local ability2 = self:GetAbility():GetAbilityName() ==  "imba_shredder_return_chakram_2"		
	if not caster:HasScepter() and (ability or ability2) then
		self:Destroy()
	end
end

function modifier_imba_shredder_chakram_thinker:LaunchThink()
	if not IsServer() then return end
	local origin = self.parent:GetOrigin()

	-- pass logic
	self:PassLogic( origin )

	-- move logic
	local close = self:MoveLogic( origin )

	-- if close, switch to stay mode
	if close then
		self.mode = MODE_STAY
		self.damageTable.damage = self.damage_stay*self.interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		-- play effects
		self:PlayEffects2()
	end
end

function modifier_imba_shredder_chakram_thinker:StayThink()
	if not IsServer() then return end
	local origin = self.parent:GetOrigin()

	-- check if died, too far or not enough manacost
	local mana = self.caster:GetMana()
	if (self.caster:GetOrigin()-origin):Length2D()>self.max_range or mana<self.manacost*self.interval or (not self.caster:IsAlive()) then
		self:ReturnChakram()
		return
	end

	-- spend mana
	self.caster:SpendMana( self.manacost*self.interval, self:GetAbility() )

	-- find enemies
	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

	end
	AddFOWViewer( self:GetCaster():GetTeamNumber(), origin, 400, 0.5, true )
	-- destroy trees
	local sound_tree = "Hero_Shredder.Chakram.Tree"
	local trees = GridNav:GetAllTreesAroundPoint( origin, self.radius, true )
	for _,tree in pairs(trees) do
		EmitSoundOnLocationWithCaster( tree:GetOrigin(), sound_tree, self.parent )
	end
	local ability = self:GetAbility()
	ability.pos_bool = true
	--if self.a then
	--	CreateTempTree(origin, 10)
	--	self.a = false
	--end	
	GridNav:DestroyTreesAroundPoint( origin, self.radius, true )
end

function modifier_imba_shredder_chakram_thinker:ReturnThink()
	if not IsServer() then return end
	local origin = self.parent:GetOrigin()

	-- pass logic
	self:PassLogic( origin )

	-- move logic
	self.point = self.caster:GetOrigin( )
	local close = self:MoveLogic( origin )

	-- if close, destroy
	local ability = self:GetAbility()
	ability.pos_bool = false
	--ability.pos = nil
	if close then
		self:Destroy()
	end
end

function modifier_imba_shredder_chakram_thinker:PassLogic( origin )
	if not IsServer() then return end
	-- find enemies
	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- check if already hit
		if not self.caught_enemies[enemy] then
			self.caught_enemies[enemy] = true

			-- damage
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )

			--enemy:AddNewModifier(self.caster, self:GetAbility(), "modifier_phased", {duration = 0.2})

			-- add debuff
			enemy:AddNewModifier(
				self.caster, -- player source
				self:GetAbility(), -- ability source
				"modifier_imba_shredder_chakram", -- modifier name
				{ duration = self.duration } -- kv
			)

			-- play effects
			local sound_target = "Hero_Shredder.Chakram.Target"
			EmitSoundOn( sound_target, enemy )
		end
	end
	--[[local all = FindUnitsInRadius(
		self.caster:GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)	
	for i=1, #all do
		FindClearSpaceForUnit(all[i], all[i]:GetAbsOrigin(), true)
		all[i]:AddNewModifier(caster, self, "modifier_phased", {duration = 0.2})  --添加相位修饰器？
	end	]]

	-- destroy trees
	local sound_tree = "Hero_Shredder.Chakram.Tree"
	local trees = GridNav:GetAllTreesAroundPoint( origin, self.radius, true )
	for _,tree in pairs(trees) do
		EmitSoundOnLocationWithCaster( tree:GetOrigin(), sound_tree, self.parent )
	end
	GridNav:DestroyTreesAroundPoint( origin, self.radius, true )
end

function modifier_imba_shredder_chakram_thinker:MoveLogic( origin )
	if not IsServer() then return end
	-- move position
	local direction = (self.point-origin):Normalized()
	local target = origin + direction * self.speed * self.move_interval
	-- target.z = GetGroundHeight( target, self.parent ) + 50
	self.parent:SetOrigin( target )

	-- return true if close to target
	return (target-self.point):Length2D()<self.proximity
end

function modifier_imba_shredder_chakram_thinker:ReturnChakram()
	if not IsServer() then return end
	-- if already returning, do nothing
	if self.mode == MODE_RETURN then return end

	-- switch mode
	self.mode = MODE_RETURN
	self.caught_enemies = {}
	self.damageTable.damage = self.damage_pass
	self:StartIntervalThink( self.move_interval )

	-- play effects
	self:PlayEffects3()
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_imba_shredder_chakram_thinker:IsAura()
	return self.mode==MODE_STAY
end

function modifier_imba_shredder_chakram_thinker:GetModifierAura()
	return "modifier_imba_shredder_chakram"
end

function modifier_imba_shredder_chakram_thinker:GetAuraRadius()
	return self.radius
end

function modifier_imba_shredder_chakram_thinker:GetAuraDuration()
	return 0.5
end

function modifier_imba_shredder_chakram_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_shredder_chakram_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_shredder_chakram_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_shredder_chakram_thinker:PlayEffects1()
	if not IsServer() then return end
	-- Get Resources

	particle_cast1 = "particles/units/heroes/hero_shredder/shredder_chakram.vpcf"		

	local sound_cast = "Hero_Shredder.Chakram"

	-- get data
	local direction = self.point-self.parent:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast1, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	--self.effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, direction * self.speed )
	ParticleManager:SetParticleControl( self.effect_cast, 16, Vector( 0, 0, 0 ) )

	if self.scepter then
		-- set color to blue
		ParticleManager:SetParticleControl( self.effect_cast, 15, Vector( 0, 0, 255 ) )
		ParticleManager:SetParticleControl( self.effect_cast, 16, Vector( 1, 0, 0 ) )
	end

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end

function modifier_imba_shredder_chakram_thinker:PlayEffects2()
	if not IsServer() then return end
	-- destroy previous particle
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Get Resources
	particle_cast2 = "particles/units/heroes/hero_shredder/shredder_chakram_stay.vpcf"	

	self.effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, nil )
	--self.effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 16, Vector( 0, 0, 0 ) )

	if self.scepter then
		-- set color to blue
		ParticleManager:SetParticleControl( self.effect_cast, 15, Vector( 0, 0, 255 ) )
		ParticleManager:SetParticleControl( self.effect_cast, 16, Vector( 1, 0, 0 ) )
	end
end

function modifier_imba_shredder_chakram_thinker:PlayEffects3()
	if not IsServer() then return end
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	particle_cast3 = "particles/units/heroes/hero_shredder/shredder_chakram_return.vpcf"	
	local sound_cast = "Hero_Shredder.Chakram.Return"
	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast3, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		1,
		self.caster,
		PATTACH_ABSORIGIN_FOLLOW,
		nil,
		self.caster:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self.speed, 0, 0 ) )
	ParticleManager:SetParticleControl( self.effect_cast, 16, Vector( 0, 0, 0 ) )

	if self.scepter then
		-- set color to blue
		ParticleManager:SetParticleControl( self.effect_cast, 15, Vector( 0, 0, 255 ) )
		ParticleManager:SetParticleControl( self.effect_cast, 16, Vector( 1, 0, 0 ) )
	end

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end

function modifier_imba_shredder_chakram_thinker:StopEffects()
	if not IsServer() then return end
	-- destroy previous particle
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- stop sound
	local sound_cast = "Hero_Shredder.Chakram"
	StopSoundOn( sound_cast, self.parent )
end

modifier_imba_shredder_chakram_disarm = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_shredder_chakram_disarm:IsHidden()
	return false
end

function modifier_imba_shredder_chakram_disarm:IsDebuff()
	return false
end

function modifier_imba_shredder_chakram_disarm:IsPurgable()
	return false
end

function modifier_imba_shredder_chakram_disarm:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_shredder_chakram_disarm:OnCreated( kv )
end

function modifier_imba_shredder_chakram_disarm:OnRefresh( kv )
end

function modifier_imba_shredder_chakram_disarm:OnRemoved()
end

function modifier_imba_shredder_chakram_disarm:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_imba_shredder_chakram_disarm:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

modifier_imba_shredder_chakram = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_shredder_chakram:IsHidden()
	return false
end

function modifier_imba_shredder_chakram:IsDebuff()
	return true
end
function modifier_imba_shredder_chakram:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_shredder_chakram:IsStunDebuff()
	return false
end

function modifier_imba_shredder_chakram:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_shredder_chakram:OnCreated( kv )
	if not IsServer() then return end
	self.parent = self:GetParent()
	-- references
	if self:GetAbility() and not self:GetAbility():IsNull() then
		self.slow = self:GetAbility():GetSpecialValueFor( "slow" )  
	else
		-- ability is deleted
		self.slow = 0
		self.stat_loss_z = 0
	end
	self.step = 5
	self.stat_loss = self:GetAbility():GetSpecialValueFor( "stat_loss_pct" ) + self:GetCaster():TG_GetTalentValue("special_bonus_shredder_5")
	self.slow_loss = -math.floor( (100-self:GetParent():GetHealthPercent())/self.step ) * self.slow
	self:StartIntervalThink( 0.1 )
end
function modifier_imba_shredder_chakram:OnIntervalThink()
	if not IsServer() then return end
	self.slow_loss = math.floor( (100-self:GetParent():GetHealthPercent())/self.step ) * self.slow
	self:SetStackCount(self.slow_loss)
	if self:GetParent():IsHero() then
		self:GetParent():CalculateStatBonus(true)
	end	
	--self:Destroy()
end
function modifier_imba_shredder_chakram:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_imba_shredder_chakram:OnRemoved()
	if not IsServer() then return end
end

function modifier_imba_shredder_chakram:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_shredder_chakram:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}

	return funcs
end

function modifier_imba_shredder_chakram:GetModifierMoveSpeedBonus_Percentage()
	--if not IsServer() then return end
	-- reduced to step of 5
	return 0-self:GetStackCount()
end

function modifier_imba_shredder_chakram:GetModifierBonusStats_Agility()
	--if not IsServer() then return end
	if self.parent:GetPrimaryAttribute()~=DOTA_ATTRIBUTE_AGILITY then return 0 end
	return -math.floor( (100-self:GetParent():GetHealthPercent())/self.step ) * self.stat_loss or 0
end
function modifier_imba_shredder_chakram:GetModifierBonusStats_Intellect()
	--if not IsServer() then return end
	if self.parent:GetPrimaryAttribute()~=DOTA_ATTRIBUTE_INTELLECT then return 0 end
	return -math.floor( (100-self:GetParent():GetHealthPercent())/self.step ) * self.stat_loss or 0
end
function modifier_imba_shredder_chakram:GetModifierBonusStats_Strength()
	--if not IsServer() then return end
	if self.parent:GetPrimaryAttribute()~=DOTA_ATTRIBUTE_STRENGTH then return 0 end
	return -math.floor( (100-self:GetParent():GetHealthPercent())/self.step ) * self.stat_loss or 0
end


--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_shredder_chakram:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

