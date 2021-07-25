CreateTalents("npc_dota_hero_void_spirit", "linken/hero_void_spirit")

-- 02 03 by MysticBug-------
----------------------------
----------------------------

--持续时间内等待  监测到敌人 
--imba 牵引若干单位 造成一次牵引伤害
--void cut part one
--(天赋技能 施法双倍概率)虚无斩_一段  分身爆炸造成一次伤害 并且造成残废
--void sword volcano
--(神杖效果)虚无剑_火山 若干方向射出 碰到单位灼烧 减少护甲

---------------------------------------------------------------------
---------------- Void Spirirt Aether Remnant  -----------------------
---------------------------------------------------------------------

imba_void_spirit_aether_remnant = class({})
LinkLuaModifier("modifier_imba_aether_remnant_thinker", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_aether_remnant_state", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_aether_remnant_trigger", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_aether_remnant_target", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_aether_remnant_motion","linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_life","linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)

function imba_void_spirit_aether_remnant:IsHiddenWhenStolen() 	return false end
function imba_void_spirit_aether_remnant:IsRefreshable() 		return true end
function imba_void_spirit_aether_remnant:IsStealable() 			return true end
function imba_void_spirit_aether_remnant:GetAOERadius()
	return self:GetSpecialValueFor("remnant_watch_distance")
end
function imba_void_spirit_aether_remnant:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local distance = (caster:GetAbsOrigin() - pos):Length2D()
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0.0
	caster:EmitSound("Hero_VoidSpirit.AetherRemnant.Cast")
	local dummy = CreateUnitByName("npc_linken_unit", caster:GetAbsOrigin(), false, caster, caster, self:GetCaster():GetTeamNumber())
	dummy:AddNewModifier(self:GetCaster(), self, "modifier_imba_life", {duration = self:GetSpecialValueFor("duration")})
	dummy:AddNewModifier(caster, nil, "modifier_rooted", {duration = self:GetSpecialValueFor("duration")})
	--状态以及残影设置
	dummy:AddNewModifier(self:GetCaster(), self, "modifier_imba_aether_remnant_state", {duration = self:GetSpecialValueFor("duration")})
	--持续时间结束自动解除修饰器
	dummy:AddNewModifier(self:GetCaster(), nil, "modifier_kill", {duration = self:GetSpecialValueFor("duration")})

	local info = 
	{
		Ability = self,
		EffectName = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_run.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = 0,
		fEndRadius = 0,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_NONE,
		bDeleteOnHit = true,
		vVelocity = direction * (self:GetSpecialValueFor("projectile_speed") * 1),
		bProvidesVision = false,
		ExtraData = {dummy = dummy:entindex()}
	}
	--残影走动音效
	caster:EmitSound("Hero_VoidSpirit.AetherRemnant")
	--线性投射物管理器
	ProjectileManager:CreateLinearProjectile(info)
end

function imba_void_spirit_aether_remnant:OnProjectileThink_ExtraData(pos, keys)
	if keys.dummy and EntIndexToHScript(keys.dummy) then
		EntIndexToHScript(keys.dummy):SetOrigin(GetGroundPosition(pos, nil))
	end
end

function imba_void_spirit_aether_remnant:OnProjectileHit_ExtraData(hTarget, pos, keys)
	if keys.dummy and EntIndexToHScript(keys.dummy) then
		EntIndexToHScript(keys.dummy):SetOrigin(GetGroundPosition(pos, nil))
		local dummy = EntIndexToHScript(keys.dummy)
		if dummy:FindModifierByName("modifier_imba_aether_remnant_state") then
			--到达目的地后添加特效
			dummy:FindModifierByName("modifier_imba_aether_remnant_state"):CreatePfx()
			--600码真实视距
			dummy:AddNewModifier(self:GetCaster(), self, "modifier_item_gem_of_true_sight", {duration = self:GetSpecialValueFor("duration")})
			--添加监视器
			CreateModifierThinker(
				self:GetCaster(), -- player source
				self, -- ability source
				"modifier_imba_aether_remnant_thinker", -- modifier name
				{
					duration = self:GetSpecialValueFor("duration"),
					radius = self:GetSpecialValueFor("remnant_watch_distance"),
					delay = self:GetSpecialValueFor("activation_delay"),
					dummy = dummy:entindex()
				}, -- kv
				dummy:GetOrigin(),
				self:GetCaster():GetTeamNumber(),
				false
			)
		end
	end
end

--监视器
--------------------------------------------------------
modifier_imba_aether_remnant_thinker = class({})

function modifier_imba_aether_remnant_thinker:OnCreated(params)
	if IsServer() then
		self.radius = params.radius
		self.delay = params.delay
		self.dummy = EntIndexToHScript(params.dummy)
		if self.dummy:FindModifierByName("modifier_imba_aether_remnant_state") then
			--监测延迟
			self:StartIntervalThink(self.delay)
		end
	end
end

function modifier_imba_aether_remnant_thinker:OnIntervalThink(params)
	if not IsServer() then return end
	if not self.delay then
		self:StartIntervalThink(0.3)
	end
	--提供视野
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local pos = self.dummy:GetAbsOrigin()
	AddFOWViewer(caster:GetTeamNumber(), pos, ability:GetSpecialValueFor("remnant_watch_radius"), 0.3, false)

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self.dummy:GetOrigin(),	-- point, center point
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
	--发现敌人
	buff = self.dummy:FindModifierByName("modifier_imba_aether_remnant_state")
	if buff then 
		buff:Explode(true,self.dummy:GetOrigin())
	end
	self:Destroy()
end

function modifier_imba_aether_remnant_thinker:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveSelf()
	end
end

--dummy 残影状态
modifier_imba_aether_remnant_state = class({})

function modifier_imba_aether_remnant_state:CheckState() return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true} end
--watch 特效
function modifier_imba_aether_remnant_state:CreatePfx()
	if IsServer() then 
	-- Get Resources
	local particle_cast = "particles/heros/void_spirit/void_spirit_aether_remnant_watch_8.vpcf"
	local sound_cast = "Hero_VoidSpirit.AetherRemnant.Spawn_lp"
	-- Destroy previous effect
	--ParticleManager:DestroyParticle( self.effect_cast, false )
	--ParticleManager:ReleaseParticleIndex( self.effect_cast )
	local dummy = self:GetParent()
	local dummy_pos = dummy:GetAbsOrigin()
	--local dummy_direction = Vector( dummy_pos.direction.x, dummy_pos.direction.y, 0 )
	local dummy_direction = dummy_pos:Normalized()
	dummy_direction.z = 0
	local dummy_distance = self:GetAbility():GetSpecialValueFor( "remnant_watch_radius" )
	local dummy_target = GetGroundPosition( dummy_pos + dummy_direction * dummy_distance, nil )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, dummy )
	ParticleManager:SetParticleControl( effect_cast, 0, dummy_pos )
	ParticleManager:SetParticleControl( effect_cast, 1, dummy_target )
	ParticleManager:SetParticleControl( effect_cast, 3, dummy_pos )
	--[[ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		dummy,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		dummy_pos, -- unknown
		true -- unknown, true
	)]]
	ParticleManager:SetParticleControlForward( effect_cast, 0, dummy_direction )
	ParticleManager:SetParticleControlForward( effect_cast, 2, dummy_direction )

	-- store for later use
	self.effect_cast = effect_cast

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )

	end
end

function modifier_imba_aether_remnant_state:Explode(bActive,vLocation)
	local max_target = self:GetAbility():GetSpecialValueFor("extra_pull_targets") + 1 + self:GetCaster():TG_GetTalentValue("special_bonus_imba_void_spirit_8")
	if not IsServer() then
		return
	end
	--牵引
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local pos = vLocation
    --牵引最大英雄单位

	local target_enemies = {}
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil,ability:GetSpecialValueFor("remnant_watch_distance"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i=1, max_target do
		if enemies[i] and not IsInTable(enemies[i], target_enemies) then
			target_enemies[#target_enemies + 1] = enemies[i]
		end
	end
	--print("enemy number +++++++++++++",#target_enemies , #enemies , pos , ability:GetSpecialValueFor("remnant_watch_radius"))

	if target_enemies[1] then
		target_enemies[1]:EmitSound("Hero_VoidSpirit.AetherRemnant.Target")
	end
	for _, enemy in pairs(target_enemies) do
		--牵引 parent() ---> dummy
		enemy:AddNewModifier(self:GetParent(), ability, "modifier_imba_aether_remnant_motion", {duration = ability:GetSpecialValueFor("pull_duration")})
		--牵引伤害
		ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage_type = ability:GetAbilityDamageType(), damage = ability:GetSpecialValueFor("impact_damage")})
	end
	target_enemies = {}
end


function modifier_imba_aether_remnant_state:OnDestroy()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local pos = self:GetParent():GetAbsOrigin()
	self:GetParent():StopSound("Hero_VoidSpirit.AetherRemnant.Spawn_lp")
		-- Destroy previous effect
	if self.effect_cast then	
		ParticleManager:DestroyParticle( self.effect_cast, false )
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end	
	--void cut part one
	--(天赋技能)虚无斩_一段  落地触发一次 造成范围沉默
		local vs_cut_1 = caster:FindAbilityByName("imba_void_spirit_void_cut")
		if vs_cut_1 and vs_cut_1:GetLevel() > 0 then
	    	Timers:CreateTimer(0.2, function()
	    		--vs_cut_1:Spell_VoidCut(pos,(ability:GetSpecialValueFor("radius")),1)
	    		vs_cut_1:Spell_VoidCut(pos,(300),1)
	    		return nil
	    	end
	    	)
	    end
end
modifier_imba_life = class({})

function modifier_imba_life:IsDebuff()			return true end
function modifier_imba_life:IsHidden() 			return false end
function modifier_imba_life:IsPurgable() 		return false end
function modifier_imba_life:IsPurgeException() 	return false end
function modifier_imba_life:IsStunDebuff() return true end
function modifier_imba_life:CheckState() return 
	{
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, 
	[MODIFIER_STATE_NO_HEALTH_BAR] = true, 
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	[MODIFIER_STATE_INVULNERABLE] = true, 
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
	[MODIFIER_STATE_OUT_OF_GAME] = true, 
	[MODIFIER_STATE_UNSELECTABLE] = true, 
	[MODIFIER_STATE_DISARMED] = true, 
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true
} 
end
--牵引修饰器
-----------------------------------------------------------------------------------------
modifier_imba_aether_remnant_motion = class({})

function modifier_imba_aether_remnant_motion:IsDebuff()			return true end
function modifier_imba_aether_remnant_motion:IsHidden() 			return false end
function modifier_imba_aether_remnant_motion:IsPurgable() 			return false end
function modifier_imba_aether_remnant_motion:IsPurgeException() 	return true end
function modifier_imba_aether_remnant_motion:IsStunDebuff() return true end
function modifier_imba_aether_remnant_motion:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true} end
function modifier_imba_aether_remnant_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_imba_aether_remnant_motion:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_imba_aether_remnant_motion:IsMotionController() return true end
function modifier_imba_aether_remnant_motion:RemoveOnDeath() 		
	return false 
end
function modifier_imba_aether_remnant_motion:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_imba_aether_remnant_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_imba_aether_remnant_motion:OnCreated(kv)
	if IsServer() then
		--pull pfx 
		-- Get Resources
		local particle_cast = "particles/heros/void_spirit/void_spirit_aether_remnant_pull.vpcf"
		local sound_cast = "Hero_VoidSpirit.AetherRemnant.Triggered"
		local sound_target = "Hero_VoidSpirit.AetherRemnant.Target"

		-- get data caster --> dummy   parent --> enemy 
		self.pos = self:GetCaster():GetAbsOrigin()
		local direction = self:GetParent():GetOrigin()-self.pos
		direction.z = 0
		direction = -direction:Normalized()

		-- Create Particle
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( effect_cast, 0, self.pos )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			1,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			self:GetParent():GetAbsOrigin(), -- unknown
			true -- unknown, true
		)
		ParticleManager:SetParticleControlForward( effect_cast, 2, direction )
		ParticleManager:SetParticleControl( effect_cast, 3, self.pos )

		-- store for later use
		self.effect_cast = effect_cast

		-- Create Sound
		EmitSoundOn( sound_cast, self:GetCaster() )
		EmitSoundOn( sound_target, self:GetParent() )

		if self:CheckMotionControllers() then
			self:StartIntervalThink(FrameTime())
		else
			self:Destroy()
		end
	end
end

function modifier_imba_aether_remnant_motion:OnIntervalThink()
	--牵引距离和速度
	local distance = self:GetAbility():GetSpecialValueFor("pull_destination") / (1.0 / FrameTime())
	local direction = (self.pos - self:GetParent():GetAbsOrigin()):Normalized()
	local pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + direction * distance, nil)
	self:GetParent():SetOrigin(pos)
end

function modifier_imba_aether_remnant_motion:OnDestroy()
	if IsServer() then
		self:GetParent():EmitSound("Hero_VoidSpirit.AetherRemnant.Destroy")
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		self.pos = nil
		--移除dummy
		self:GetCaster():ForceKill(false)
		-- Destroy previous effect
	if self.effect_cast then	
		ParticleManager:DestroyParticle( self.effect_cast, false )
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end	
	end
end

-- 02 03 by MysticBug------
----------------------------
----------------------------

--产生若干圈  持续时间 使用二段技能落地 造成一次范围伤害
--imba 其他圈也爆炸，但是只造成1/2爆炸伤害
--void cut part two
--(天赋技能)虚无斩_二段  落地触发一次 造成范围沉默
--void sword tsunami
--(神杖效果)虚无剑_海啸 若干圈产生若干剑 造成 易伤BUFF

--(彩蛋)1% 5倍范围虚无斩*绝 不分敌我眩晕 敌方3倍虚无斩伤害

-----------------------------------------------------------------
---------------- Void Spirit Dissimilate  -----------------------
-----------------------------------------------------------------

imba_void_spirit_dissimilate = class({})

LinkLuaModifier("modifier_imba_dissimilate_thinker", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dissimilate_caster", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dissimilate_trigger", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dissimilate_target", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)


function imba_void_spirit_dissimilate:IsHiddenWhenStolen()    return false end
function imba_void_spirit_dissimilate:IsStealable() 		  return true end
function imba_void_spirit_dissimilate:GetCastRange() if IsClient() then return ((self:GetSpecialValueFor("radius")*3) -self:GetCaster():GetCastRangeBonus()) end end 
function imba_void_spirit_dissimilate:GetCastPoint()
	local cast_point = self.BaseClass.GetCastPoint(self)
	return cast_point
end

function imba_void_spirit_dissimilate:OnUpgrade()

end

function imba_void_spirit_dissimilate:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor( "phase_duration" )
	if self:GetAutoCastState() then
		duration = duration * 0.5
	end	
	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_imba_dissimilate_caster", -- modifier name
		{ duration = duration } -- kv
	)

	-- Play sound
	local sound_cast = "Hero_VoidSpirit.Dissimilate.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

--产生圈
modifier_imba_dissimilate_caster = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_imba_dissimilate_caster:IsHidden() return false end
function modifier_imba_dissimilate_caster:IsDebuff() return false end
function modifier_imba_dissimilate_caster:IsPurgable() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_dissimilate_caster:OnCreated( kv )
	-- references
	self.portals = self:GetAbility():GetSpecialValueFor( "portals_per_ring" )
	self.angle = self:GetAbility():GetSpecialValueFor( "angle_per_ring_portal" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.distance = self:GetAbility():GetSpecialValueFor( "first_ring_distance_offset" )
	self.target_radius = self:GetAbility():GetSpecialValueFor( "destination_fx_radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "ability_damage" )

	if not IsServer() then return end

	local origin = self:GetParent():GetOrigin()
	local direction = self:GetParent():GetForwardVector()
	local zero = Vector(0,0,0)
	self.selected = 1

	-- determine 6 points
	-- 原地圈
	self.points = {}
	self.effects = {}
	--imba 碰撞圈会爆炸
	--CreateModifierThinker(self:GetParent(), self.ability , "modifier_imba_dissimilate_thinker", {duration = self.duration }, self.origin, self:GetCaster():GetTeamNumber(), false)
	table.insert( self.points, origin )
	--原地圈特效设置
	table.insert( self.effects, self:PlayEffects1( origin, true ) )

    -- 周围圈
	for i=1,self.portals do
		local new_direction = RotatePosition( zero, QAngle( 0, self.angle*i, 0 ), direction )
		local point = GetGroundPosition( origin + new_direction * self.distance, nil )
		--imba 碰撞圈会爆炸
		--CreateModifierThinker(self:GetParent(), self.ability , "modifier_imba_dissimilate_thinker", {duration = self.duration }, point, self:GetCaster():GetTeamNumber(), false)

		table.insert( self.points, point )
		--圈特效设置
		table.insert( self.effects, self:PlayEffects1( point, false ) )
	end

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage/2,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}

	-- nodraw 气泡
	self:GetParent():AddNoDraw()
	-- 开始之前先造成一次伤害
	if not self:GetAbility():GetAutoCastState() then
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			origin,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			(self.radius * 3 - 100),	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		-- 造成眩晕
		--[[local dissimilate_stun = 0
		if self:GetCaster():TG_HasTalent("special_bonus_imba_void_spirit_7") then 
			dissimilate_stun = self:GetCaster():TG_GetTalentValue("special_bonus_imba_void_spirit_7")
		end]]
		for _,enemy in pairs(enemies) do
			-- apply damage
			if not enemy:IsMagicImmune() then 
				self.damageTable.victim = enemy
				ApplyDamage(self.damageTable)		
			end
			--[[if dissimilate_stun then 
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = dissimilate_stun })
			end]]
		end
	end	
end

function modifier_imba_dissimilate_caster:OnRefresh( kv )	end
function modifier_imba_dissimilate_caster:OnRemoved()	end
function modifier_imba_dissimilate_caster:OnDestroy()
	if not IsServer() then return end

	local point = self.points[self.selected]
	local caster = self:GetCaster()

	-- move parent
	FindClearSpaceForUnit( self:GetParent(), point, true )

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	-- 造成眩晕
	local dissimilate_stun = 0
	if self:GetCaster():TG_HasTalent("special_bonus_imba_void_spirit_7") then 
		dissimilate_stun = self:GetCaster():TG_GetTalentValue("special_bonus_imba_void_spirit_7")
	end
	for _,enemy in pairs(enemies) do
		-- apply damage
		if not enemy:IsMagicImmune() then 
			self.damageTable.victim = enemy
			self.damageTable.damage = self.damage * 1.5		
			ApplyDamage(self.damageTable)
		end
		if dissimilate_stun then 
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = dissimilate_stun })
		end		
	end

	-- nodraw 移除气泡
	self:GetParent():RemoveNoDraw()

	-- play effects 落地特效 音效
	self:PlayEffects2( point, #enemies )

	--void cut part two
	--(天赋技能)虚无斩_二段  落地触发一次 造成范围沉默 --改为缠绕
	local vs_cut_2 = caster:FindAbilityByName("imba_void_spirit_void_cut")
	if vs_cut_2 and vs_cut_2:GetLevel() > 0 then
    	Timers:CreateTimer(0.2, function()
    		vs_cut_2:Spell_VoidCut(caster:GetAbsOrigin(),300,4)
    		return nil
    	end
    	)
    end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_dissimilate_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,

		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_imba_dissimilate_caster:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	-- right click, switch position
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self:SetValidTarget( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetValidTarget( params.target:GetOrigin() )
	end
end

function modifier_imba_dissimilate_caster:GetModifierMoveSpeed_Limit()	return 0.1	end
--------------------------------------------------------------------------------
-- Status Effects 紫猫状态
function modifier_imba_dissimilate_caster:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true, --缴械
		[MODIFIER_STATE_SILENCED] = true, --沉默
		[MODIFIER_STATE_MUTED] = true,  --变形
		[MODIFIER_STATE_OUT_OF_GAME] = true,  --除外
		[MODIFIER_STATE_INVULNERABLE] = true, --无敌
	}

	return state
end

--------------------------------------------------------------------------------
-- Helper
function modifier_imba_dissimilate_caster:SetValidTarget( location )
	-- find max
	local max_dist = (location-self.points[1]):Length2D()
	local max_point = 1
	for i,point in ipairs(self.points) do
		local dist = (location-point):Length2D()
		if dist<max_dist then
			max_dist = dist
			max_point = i
		end
	end

	-- select 圈的编号
	local old_select = self.selected
	self.selected = max_point

	-- change effects  选中圈的特效
	self:ChangeEffects( old_select, self.selected )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_dissimilate_caster:PlayEffects1( point, main )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate.vpcf"
	local sound_cast = "Hero_VoidSpirit.Dissimilate.Portals"

	-- adjustments
	local radius = self.radius + 25

	-- Create Particle for this team
	local effect_cast = ParticleManager:CreateParticleForTeam(particle_cast, PATTACH_WORLDORIGIN, self:GetParent(), self:GetCaster():GetTeamNumber())
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 0, 1 ) )
	if main then
		ParticleManager:SetParticleControl( effect_cast, 2, Vector( 1, 0, 0 ) )
	end

	-- Create Particle for enemy team
	local effect_cast2 = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl( effect_cast2, 0, point )
	ParticleManager:SetParticleControl( effect_cast2, 1, Vector( radius, 0, 1 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
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

	-- Play Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )

	return effect_cast
end

function modifier_imba_dissimilate_caster:ChangeEffects( old, new )
	ParticleManager:SetParticleControl( self.effects[old], 2, Vector( 0, 0, 0 ) )
	ParticleManager:SetParticleControl( self.effects[new], 2, Vector( 1, 0, 0 ) )
end

function modifier_imba_dissimilate_caster:PlayEffects2( point, hit )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf"
	local sound_cast = "Hero_VoidSpirit.Dissimilate.TeleportIn"
	local sound_hit = "Hero_VoidSpirit.Dissimilate.Stun"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.target_radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
	if hit>0 then
		EmitSoundOn( sound_hit, self:GetParent() )
	end
end


-- 02 03 by MysticBug------
----------------------------
----------------------------

--大范围伤害 产生护盾 吸收物理伤害 
--imba根据敌人数量吸收临时智力加成
--void cut part tree 
--(天赋技能)虚空斩_三段 范围伤害 并且造成缴械
--void sword whirlwind
--(神杖效果)虚空剑_旋风 碰到敌人造成伤害 并且减少敌人20%输出

------------------------------------------------------------------
---------------- Void Spirit Resonant Pulse  ---------------------
------------------------------------------------------------------

imba_void_spirit_resonant_pulse = class({})

LinkLuaModifier("modifier_imba_resonant_pulse", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_resonant_pulse_buff", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_resonant_pulse_scepter", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_void_cut_debuff_silenced", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)

function imba_void_spirit_resonant_pulse:IsHiddenWhenStolen() 		return false end
function imba_void_spirit_resonant_pulse:IsRefreshable() 			return true end
function imba_void_spirit_resonant_pulse:IsStealable() 				return true end
function imba_void_spirit_resonant_pulse:GetIntrinsicModifierName() return "modifier_imba_resonant_pulse_scepter" end
function imba_void_spirit_resonant_pulse:GetCastRange() if IsClient() then return self:GetSpecialValueFor("radius") -self:GetCaster():GetCastRangeBonus() end end 
function imba_void_spirit_resonant_pulse:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_VoidSpirit.Pulse.Cast")
	----------------------------------------------
	--范围特效???
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(self:GetSpecialValueFor("radius")*3, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle)
	
    --特效结束后产生护盾
    caster:AddNewModifier(caster, self, "modifier_imba_resonant_pulse", {duration = self:GetSpecialValueFor("buff_duration")})
    --void cut part tree 
    --(天赋技能)虚空斩_三段 范围伤害 并且造成缴械
	local vs_cut_3 = caster:FindAbilityByName("imba_void_spirit_void_cut")
	if vs_cut_3 and vs_cut_3:GetLevel() > 0 then
    	Timers:CreateTimer(0.2, function()
    		--vs_cut_3:Spell_VoidCut(caster:GetAbsOrigin(),self:GetSpecialValueFor("radius"),3)
    		vs_cut_3:Spell_VoidCut(caster:GetAbsOrigin(),300,3)
    		return nil
    	end
    	)
    end
end
modifier_imba_resonant_pulse_scepter = class({})

function modifier_imba_resonant_pulse_scepter:IsDebuff()			return false end
function modifier_imba_resonant_pulse_scepter:IsHidden() 			return true end
function modifier_imba_resonant_pulse_scepter:IsPurgable() 		return false end
function modifier_imba_resonant_pulse_scepter:IsPurgeException() 	return false end

function modifier_imba_resonant_pulse_scepter:OnCreated()
	if not IsServer() then return end
	if not self:GetParent():IsIllusion() then
		AbilityChargeController:AbilityChargeInitialize(self:GetAbility(), self:GetAbility():GetCooldown(4 - 1), 1, 1, true, true)
		self:StartIntervalThink(0.5)
	end
end

function modifier_imba_resonant_pulse_scepter:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():HasScepter() then
		AbilityChargeController:ChangeChargeAbilityConfig(self:GetAbility(), self:GetAbility():GetCooldown(4 - 1), 2, 1, true, true)
	else
		AbilityChargeController:ChangeChargeAbilityConfig(self:GetAbility(), self:GetAbility():GetCooldown(4 - 1), 1, 1, true, true)
	end
end
modifier_imba_void_cut_debuff_silenced = class({})

function modifier_imba_void_cut_debuff_silenced:IsDebuff()			return true end
function modifier_imba_void_cut_debuff_silenced:IsHidden() 			return false end
function modifier_imba_void_cut_debuff_silenced:IsPurgable() 		return true end
function modifier_imba_void_cut_debuff_silenced:IsPurgeException() 	return true end
function modifier_imba_void_cut_debuff_silenced:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_imba_void_cut_debuff_silenced:GetEffectName() return "particles/units/heroes/hero_pangolier/pangolier_luckyshot_silence_debuff.vpcf" end
function modifier_imba_void_cut_debuff_silenced:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_void_cut_debuff_silenced:ShouldUseOverheadOffset() return true end
--护盾
modifier_imba_resonant_pulse = class({})

function modifier_imba_resonant_pulse:IsDebuff()			return false end
function modifier_imba_resonant_pulse:IsHidden() 			return false end
function modifier_imba_resonant_pulse:IsPurgable() 		return false end
function modifier_imba_resonant_pulse:IsPurgeException() 	return false end
function modifier_imba_resonant_pulse:DeclareFunctions() return {MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS} end
function modifier_imba_resonant_pulse:GetStatusEffectName()	return "particles/status_fx/status_effect_void_spirit_pulse_buff.vpcf" end
function modifier_imba_resonant_pulse:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL end
function modifier_imba_resonant_pulse:OnCreated()
	if IsServer() then
		self:GetParent():EmitSound("Hero_VoidSpirit.Pulse")
		local caster = self:GetCaster()
		--范围内地方英雄单位
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		local creeps = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		local enemy_amount = #enemies
		local damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_void_spirit_4") 	
		--英雄范围伤害
		if enemy_amount then 
			for _, enemy in pairs(enemies) do
				local damageTable = {
								victim = enemy,
								attacker = self:GetParent(),
								damage = damage,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self:GetAbility(), --Optional.
								}
								--DOTA_DAMAGE_FLAG_PROPERTY_FIRE
				if not enemy:IsMagicImmune() then
					if caster:HasScepter() then
						enemy:AddNewModifier(
						caster, -- player source
						self:GetAbility(), -- ability source
						"modifier_imba_void_cut_debuff_silenced", -- modifier name
						{ duration = self:GetAbility():GetSpecialValueFor("sce_duration") } -- kv
						)
					end				
					ApplyDamage(damageTable)
				end	
			end
		end
		--小兵范围伤害
		for _, creep in pairs(creeps) do
			local damageTable = {
							victim = creep,
							attacker = self:GetParent(),
							damage = damage,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self:GetAbility(), --Optional.
							}
							--DOTA_DAMAGE_FLAG_PROPERTY_FIRE			
			ApplyDamage(damageTable)	
		end		
		--吸收的物理伤害
		self.health = self:GetAbility():GetSpecialValueFor("base_absorb_amount") + enemy_amount * self:GetAbility():GetSpecialValueFor("absorb_per_hero_hit")
		self:SetStackCount(self:GetStackCount() + self.health)
		--吸收的智力
		self.extra_int = enemy_amount * self:GetAbility():GetSpecialValueFor("absorb_per_hero_int")

		--更新虚化
		if self:GetParent():HasModifier("modifier_imba_voidification") then 
			local int_ability = self:GetParent():FindAbilityByName("imba_void_spirit_void_cut")
			local int_bouns =  int_ability:GetSpecialValueFor("bouns_voidification") / 100
			local int_caster = self:GetParent():GetIntellect()
			self:GetParent():SetModifierStackCount("modifier_imba_voidification", nil, (int_caster + self.extra_int) * int_bouns)
		end

		--罩子特效
		-- Get Resources
		local particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield.vpcf"
		--local particle_cast2 = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_buff.vpcf"
		local sound_cast = "Hero_VoidSpirit.Pulse.Cast"

		-- Get Data
		local radius = 100

		-- Create Particle
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			0,
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

		EmitSoundOn( sound_cast, self:GetParent() )
	end
end

--刷新盾
function modifier_imba_resonant_pulse:OnRefresh()
	if IsServer() then
		self:GetParent():EmitSound("Hero_VoidSpirit.Pulse")
		local caster = self:GetCaster()
		--范围内地方单位
		local damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_void_spirit_4") 
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		local creeps = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)		
		local enemy_amount = #enemies
		--范围伤害
		if enemy_amount then 
			for _, enemy in pairs(enemies) do
				local damageTable = {
								victim = enemy,
								attacker = self:GetParent(),
								damage = damage,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self:GetAbility(), --Optional.
								}
								--DOTA_DAMAGE_FLAG_PROPERTY_FIRE
				if not enemy:IsMagicImmune() then
					if caster:HasScepter() then
						enemy:AddNewModifier(
						caster, -- player source
						self:GetAbility(), -- ability source
						"modifier_imba_void_cut_debuff_silenced", -- modifier name
						{ duration = self:GetAbility():GetSpecialValueFor("sce_duration") } -- kv
						)
					end										
					ApplyDamage(damageTable)
				end	
			end
		end
		--小兵范围伤害
		for _, creep in pairs(creeps) do
			local damageTable = {
							victim = creep,
							attacker = self:GetParent(),
							damage = damage,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self:GetAbility(), --Optional.
							}
							--DOTA_DAMAGE_FLAG_PROPERTY_FIRE			
			ApplyDamage(damageTable)	
		end				
		--吸收的物理伤害
		self.health = self:GetAbility():GetSpecialValueFor("base_absorb_amount") + enemy_amount * self:GetAbility():GetSpecialValueFor("absorb_per_hero_hit")
		self:SetStackCount(self:GetStackCount() + self.health)
		--吸收的智力
		self.extra_int = enemy_amount * self:GetAbility():GetSpecialValueFor("absorb_per_hero_int")
		--更新虚化
		if self:GetParent():HasModifier("modifier_imba_voidification") then 
			local int_ability = self:GetParent():FindAbilityByName("imba_void_spirit_void_cut")
			local int_bouns =  int_ability:GetSpecialValueFor("bouns_voidification") / 100
			local int_caster = self:GetParent():GetIntellect()
			self:GetParent():SetModifierStackCount("modifier_imba_voidification", nil, (int_caster + self.extra_int) * int_bouns)
		end
	end
end

function modifier_imba_resonant_pulse:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_VoidSpirit.Pulse")
		self:GetParent():EmitSound("Hero_VoidSpirit.Pulse.Destroy")
		self.health = nil
		self.extra_int = nil
	end
end

function modifier_imba_resonant_pulse:GetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		return
	end
	--吸收物理伤害
	if keys.damage_type ~= DAMAGE_TYPE_PHYSICAL then
		return
	end
	local stack = self.health
	--计算护盾值
	self.health = stack - math.max(0, keys.damage)
	if self.health <= 0 then
		self:SetStackCount(0)
		--self:Destroy()
	else
		self:SetStackCount(self.health)
	end
	return stack
end

function modifier_imba_resonant_pulse:GetModifierBonusStats_Intellect(keys)
	if IsServer() then 
		return self.extra_int
	end
end

-- 02 03 by MysticBug------
----------------------------
----------------------------
-- 300%太虚之径暴击  35% 施法时三重虚无斩
-- -7s 太虚之径充能  25% 技能增强		
-- +1s 虚无斩眩晕    +20% 虚无斩智力系数   (600码残阴真实视距)
-- 80攻击力          16 魔法恢复

--单体路径 攻击一条线上所有敌人并且施加标记 延迟爆炸
--imba 神杖效果
--void cut finish
--(天赋技能)虚空斩_终式 范围伤害 并且造成冻结
--(神杖效果)虚化 增加自身15% 智力/魔抗/物免
--(施法附加虚无剑,伤害较低，但是产生强力辅助效果)
--void sword heavry rains
--(神杖效果)虚无剑_暴雨 路径产生剑雨减少魔抗

----------------------------------------------------------------
---------------- Void Spirirt Astral Step  ---------------------
----------------------------------------------------------------
imba_void_spirit_astral_step = class({})

LinkLuaModifier("modifier_imba_astral_step_mark", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_astral_step_crit", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
function imba_void_spirit_astral_step:IsHiddenWhenStolen() 	return false end
function imba_void_spirit_astral_step:IsRefreshable() 		return true end
function imba_void_spirit_astral_step:IsStealable() 			return true end 
function imba_void_spirit_astral_step:GetCastRange() if IsClient() then return self:GetSpecialValueFor("max_travel_distance") end end
function imba_void_spirit_astral_step:OnUpgrade()
	local ability = self:GetCaster():FindAbilityByName("imba_void_spirit_void_cut")
	if ability then
		ability:SetLevel(self:GetLevel())
	end
	--充能设置
	if not self:GetCaster():TG_HasTalent("special_bonus_imba_void_spirit_3") then
		AbilityChargeController:AbilityChargeInitialize(self, self:GetSpecialValueFor("charge_restore_time"), self:GetSpecialValueFor("max_charges"), 1, true, true)
	end
end

function imba_void_spirit_astral_step:GetAssociatedSecondaryAbilities() return "imba_void_spirit_void_cut" end

function imba_void_spirit_astral_step:OnSpellStart()
	local caster = self:GetCaster()
	ProjectileManager:ProjectileDodge(caster)
	local pos = self:GetCursorPosition()
	--位移距离设定
	pos = (caster:GetAbsOrigin() - pos):Length2D() <= (self:GetSpecialValueFor("max_travel_distance")+self:GetCaster():GetCastRangeBonus()) and pos or (caster:GetAbsOrigin() + (pos - caster:GetAbsOrigin()):Normalized() * (self:GetSpecialValueFor("max_travel_distance")+self:GetCaster():GetCastRangeBonus()))
	local pos0 = caster:GetAbsOrigin()
	--位移
	FindClearSpaceForUnit( caster, pos, true )
	--开始音效
	EmitSoundOnLocationWithCaster(pos0, "Hero_VoidSpirit.AstralStep.Start", caster)
	-- Create Particle
	local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( pfx, 0, pos0 )
	ParticleManager:SetParticleControl( pfx, 1, pos )
	ParticleManager:ReleaseParticleIndex( pfx )
	--结束音效
	EmitSoundOnLocationWithCaster(pos, "Hero_VoidSpirit.AstralStep.End", caster)

	--路径监测 施加印记 施加减速
	--local max_pos = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector():Normalized() * self:GetSpecialValueFor("max_travel_distance")
	local enemies = FindUnitsInLine(
			self:GetCaster():GetTeamNumber(),
			pos0,
			pos,
			nil,
			self:GetSpecialValueFor( "radius" ),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		)

	if #enemies then 
	 for _, enemy in pairs(enemies) do
	 		--施加印记 & 减速
			enemy:AddNewModifier(caster, self, "modifier_imba_astral_step_mark", {duration = self:GetSpecialValueFor("pop_damage_delay")})
			--25天赋暴击
			if caster:TG_HasTalent("special_bonus_imba_void_spirit_6") then 
			caster:AddNewModifier(caster, self, "modifier_imba_astral_step_crit", {duration = self:GetSpecialValueFor("pop_damage_delay")})
			end
			--攻击一次 但是不造成分裂特效
			--self:GetCaster().splitattack = false
			self:GetCaster():PerformAttack(enemy, true, true, true, false, true, false, true)
			--self:GetCaster().splitattack = true
			if caster:TG_HasTalent("special_bonus_imba_void_spirit_6") then 
			caster:RemoveModifierByName("modifier_imba_astral_step_crit")
			end			
		end
    end
	----void cut finish
	--(天赋技能)虚空斩_终式 范围伤害 并且造成缠绕  --改为沉默
	local vs_cut_4 = caster:FindAbilityByName("imba_void_spirit_void_cut")
	if vs_cut_4 and vs_cut_4:GetLevel() > 0 then
    	Timers:CreateTimer(0.2, function()
    		vs_cut_4:Spell_VoidCut(caster:GetAbsOrigin(),600,10)
    		return nil
    	end
    	)
    end
end

--神杖效果 虚无剑 void sword 以紫猫为初点若干方向射出剑 碰到单位造成较少伤害，产生负面效果
--void sword volcano
--1.(神杖效果)虚无剑_火山 碰到敌方灼烧 减少20%护甲
--void sword tsunami
--2.(神杖效果)虚无剑_海啸 碰到敌方虚弱 	20%易伤
--void sword whirlwind
--3.(神杖效果)虚空剑_旋风 碰到敌方破攻 减少20%输出
--void sword heavry rains
--4.(神杖效果)虚无剑_暴雨 碰到敌方破魔 减少20%魔抗
--vEffect 1 2 3 4



--太虚印记 & 减速
modifier_imba_astral_step_mark = class({})

function modifier_imba_astral_step_mark:IsDebuff()			return true end
function modifier_imba_astral_step_mark:IsHidden() 			return false end
function modifier_imba_astral_step_mark:IsPurgable() 		return true end
function modifier_imba_astral_step_mark:IsPurgeException() 	return true end
function modifier_imba_astral_step_mark:GetAttributes()	    return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_astral_step_mark:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_astral_step_mark:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("movement_slow_pct")) end
function modifier_imba_astral_step_mark:GetEffectName() 	return "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf" end
function modifier_imba_astral_step_mark:GetEffectAttachType() 	return PATTACH_ABSORIGIN_FOLLOW end--
function modifier_imba_astral_step_mark:OnDestroy()
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local damageTable = {
								victim = self:GetParent(),
								attacker = caster,
								damage = ability:GetSpecialValueFor("damage_pop"),
								damage_type = DAMAGE_TYPE_MAGICAL,
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self:GetAbility(), --Optional.
						}
	ApplyDamage(damageTable)
	--爆炸伤害数字显示
	--SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, self:GetParent(), ability:GetSpecialValueFor("pop_damage"), nil)
	--爆炸特效
	--Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf"
	local sound_target = "Hero_VoidSpirit.AstralStep.MarkExplosion"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	-- 爆炸音效
	EmitSoundOn( sound_target, self:GetParent() )
end

--天赋暴击
modifier_imba_astral_step_crit =class({})

function modifier_imba_astral_step_crit:IsDebuff() return false end
function modifier_imba_astral_step_crit:IsHidden() return false end
function modifier_imba_astral_step_crit:IsPurgable() return false end
function modifier_imba_astral_step_crit:IsPurgeException() return true end
function modifier_imba_astral_step_crit:IsStunDebuff() return false end
function modifier_imba_astral_step_crit:RemoveOnDeath() return true end
function modifier_imba_astral_step_crit:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE} end
function modifier_imba_astral_step_crit:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and params.attacker == self:GetParent()  then 
		return self:GetCaster():TG_GetTalentValue("special_bonus_imba_void_spirit_6")
	end
end





-----------------------------------------------
---------------- Void Cut ---------------------
-----------------------------------------------
--[[天赋技能 被动 虚空斩 20% 
	1：造成智力40%/60%/80% 的额外纯粹伤害
	2：施放其他技能时必定触发并且带控制效果

	天赋 造成 0.5S 范围眩晕]]
imba_void_spirit_void_cut = class({})
LinkLuaModifier("modifier_imba_voidification", "linken/hero_void_spirit", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------------------------------------
--神杖效果 虚化 voidification  增加自身15% 智力/魔抗/物伤减免
modifier_imba_voidification = class({})

function modifier_imba_voidification:IsDebuff()				return false end
function modifier_imba_voidification:IsHidden() 			if self:GetCaster():HasScepter() then return false else return true end end
function modifier_imba_voidification:GetTexture() 			return "void_spirit_void_cut" end
function modifier_imba_voidification:RemoveOnDeath() 		return false end
function modifier_imba_voidification:IsPurgable() 			return false end
function modifier_imba_voidification:IsPurgeException() 	return false end
function modifier_imba_voidification:GetAttributes() 		return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_voidification:DeclareFunctions() 	return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK, MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_voidification:GetModifierMagicalResistanceBonus() if self:GetCaster():HasScepter() then return self:GetAbility():GetSpecialValueFor("bouns_voidification") end end
function modifier_imba_voidification:GetModifierPhysical_ConstantBlock()  if self:GetCaster():HasScepter() then return self:GetAbility():GetSpecialValueFor("bouns_voidification") end end
function modifier_imba_voidification:GetModifierBonusStats_Intellect() if self:GetCaster():HasScepter() then return self:GetStackCount() end end
function modifier_imba_voidification:OnCreated()
	if IsServer() then
		self:SetStackCount(self:GetParent():GetIntellect() * (self:GetAbility():GetSpecialValueFor("bouns_voidification") / 100))
	end
end
function modifier_imba_voidification:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() or not (keys.target:IsHero() or keys.target:IsCreep() or keys.target:IsBoss()) then
		return
	end
	local caster = self:GetCaster()
	local pos = keys.target:GetAbsOrigin()
	local chance = self:GetAbility():GetSpecialValueFor("cut_damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_void_spirit_2")
	local vs_cut_4 = caster:FindAbilityByName("imba_void_spirit_void_cut")	
	if PseudoRandom:RollPseudoRandom(self:GetAbility(), chance) then
		if vs_cut_4 and vs_cut_4:GetLevel() > 0 then
	    	Timers:CreateTimer(0.2, function()
	    		vs_cut_4:Spell_VoidCut(pos,300,10)
	    		return nil
	    	end
	    	)
	    end		
	end	
end
function imba_void_spirit_void_cut:GetIntrinsicModifierName() return "modifier_imba_voidification" end
function imba_void_spirit_void_cut:GetCastRange() if IsClient() then return self:GetSpecialValueFor("max_travel_distance") end end
function imba_void_spirit_void_cut:GetBehavior()
	if self:GetCaster():Has_Aghanims_Shard() then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE
	end

	return DOTA_ABILITY_BEHAVIOR_PASSIVE + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE
end
function imba_void_spirit_void_cut:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local pos0 = caster:GetAbsOrigin()
	local vs_cut_4 = caster:FindAbilityByName("imba_void_spirit_void_cut")
	local ability = caster:FindAbilityByName("imba_void_spirit_astral_step")
	local direction = (pos - pos0):Normalized()
	direction.z = 0	
	pos = (caster:GetAbsOrigin() - pos):Length2D() <= (ability:GetSpecialValueFor("max_travel_distance")+self:GetCaster():GetCastRangeBonus()) and pos or (caster:GetAbsOrigin() + (pos - caster:GetAbsOrigin()):Normalized() * (ability:GetSpecialValueFor("max_travel_distance")+self:GetCaster():GetCastRangeBonus()))
	dummy = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 5,}, pos, self:GetCaster():GetTeamNumber(), false)
	dummy:SetForwardVector(direction)
	EmitSoundOnLocationWithCaster(pos0, "Hero_VoidSpirit.AstralStep.Start", caster)
	local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( pfx, 0, pos0 )
	ParticleManager:SetParticleControl( pfx, 1, pos )
	ParticleManager:ReleaseParticleIndex( pfx )
	EmitSoundOnLocationWithCaster(pos, "Hero_VoidSpirit.AstralStep.End", caster)
	local enemies = FindUnitsInLine(
			self:GetCaster():GetTeamNumber(),
			pos0,
			pos,
			nil,
			ability:GetSpecialValueFor( "radius" ),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		)
	if #enemies then 
	 for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(caster, ability, "modifier_imba_astral_step_mark", {duration = ability:GetSpecialValueFor("pop_damage_delay")})
			if caster:TG_HasTalent("special_bonus_imba_void_spirit_6") then 
				caster:AddNewModifier(caster, ability, "modifier_imba_astral_step_crit", {duration = ability:GetSpecialValueFor("pop_damage_delay")})
			end
			self:GetCaster():PerformAttack(enemy, true, true, true, false, true, false, true)
			if caster:TG_HasTalent("special_bonus_imba_void_spirit_6") then 
				caster:RemoveModifierByName("modifier_imba_astral_step_crit")
			end			
		end
    end
	if vs_cut_4 and vs_cut_4:GetLevel() > 0 then
    	Timers:CreateTimer(0.2, function()
    		vs_cut_4:Spell_VoidCut(pos,600,10)
    		return nil
    	end
    	)
    end
	--[[local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/astral_step_portal_selected.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle2, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle2, 1, self:GetCaster():GetAbsOrigin() + Vector(0,0,250))
	ParticleManager:SetParticleControlOrientation(particle2, 1, dummy:GetForwardVector(), dummy:GetRightVector(), dummy:GetUpVector())
	ParticleManager:ReleaseParticleIndex(particle2)]]
end


function imba_void_spirit_void_cut:Spell_VoidCut(vLocation,vRadius,vEffect)
	if self:GetCaster():IsIllusion() or self:GetCaster():PassivesDisabled() then
		return
	end
	local multiple = 1
	if self:GetCaster():TG_HasTalent("special_bonus_imba_void_spirit_5") then
		if PseudoRandom:RollPseudoRandom(self, self:GetCaster():TG_GetTalentValue("special_bonus_imba_void_spirit_5")) then 
			multiple = 2
		end
	end 

	for i = 1 , multiple do 
		Timers:CreateTimer(i * 0.3, function()
			--斩切范围
			local radius = self:GetSpecialValueFor("radius")
			if vEffect == 10 then
				radius = radius * 2
			end	
			--范围特效 ( 以 vLocation 为原点的特效)
			--multiple > 1  为了酷炫可以坐标也稍微随机
			--------------------------------------------------------------------------------------------
			-- Get Resources
			local particle_cast = "particles/heros/void_spirit/void_spirit_dissimilate_dmg.vpcf"
			--斩切音效  ........
			local sound_cast = "Imba.void.cut.caster"
			-- Create Particle for this team
			local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl( effect_cast, 0, vLocation )
			ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 0, 1 ) )
			ParticleManager:ReleaseParticleIndex(effect_cast)
			-- Play Sound
			EmitSoundOnLocationWithCaster( vLocation, sound_cast, self:GetCaster() )
			--------------------------------------------------------------------------------------------
			--天赋眩晕1S
			local vc_cut_stun_duration = 0
			if self:GetCaster():TG_HasTalent("special_bonus_imba_void_spirit_1") then
				--眩晕音效
				EmitSoundOnLocationWithCaster(vLocation, "Hero_VoidSpirit.Dissimilate.Stun", self:GetCaster())
				--self:GetCaster():EmitSound("Hero_VoidSpirit.Dissimilate.Stun")
				vc_cut_stun_duration = self:GetCaster():TG_GetTalentValue("special_bonus_imba_void_spirit_1")
			end

			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			local pure_dmg = (self:GetCaster():GetIntellect() * (self:GetSpecialValueFor("cut_damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_void_spirit_2")))/100
			--print("pure_dmg +++++++++++ find enemies++++++++",pure_dmg,#enemies)
			for _, enemy in pairs(enemies) do
				if vc_cut_stun_duration then
					if not enemy:IsMagicImmune() then 
						enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = vc_cut_stun_duration })
					end	
				end
				local damageTable = {
									victim = enemy,
									attacker = self:GetCaster(),
									damage = pure_dmg,
									damage_type = self:GetAbilityDamageType(),
									damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
									ability = self, --Optional.
									}
				if not enemy:IsMagicImmune() then					
					ApplyDamage(damageTable)
				end
				if not enemy:IsMagicImmune() then
			    	enemy:AddNewModifier(self:GetCaster(), self, "modifier_paralyzed", {duration = self:GetSpecialValueFor("cut_duration")})
			    end	
			end
			return nil
		end
		)
	end
end