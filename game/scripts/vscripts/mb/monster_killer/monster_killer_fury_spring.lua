-- Editors:
-- MysticBug, 20.09.2021
-- Extra API

function CheckBumped(hCaster,vLocation)
	--初始化kv
	local tree_radius = 120
	local wall_radius = 50
	local building_radius = 30
	local blocker_radius = 70
	--查看是否遇到墙 类似玛尔斯大招的墙
	local arena_walls = Entities:FindAllByClassnameWithin( "npc_dota_phantomassassin_gravestone", vLocation, wall_radius )
	for _,arena_wall in pairs(arena_walls) do
		if arena_wall:HasModifier( "modifier_mars_arena_of_blood_lua_blocker" ) then
			return true		
		end
	end
	--查看是否遇到地图边界墙
	local thinkers = Entities:FindAllByClassnameWithin( "npc_dota_thinker", vLocation, wall_radius )
	for _,thinker in pairs(thinkers) do
		if thinker:IsPhantomBlocker() then
			return true
		end
	end
	--查看是否遇到悬崖
	local base_loc = GetGroundPosition( vLocation, hCaster )
	local search_loc = GetGroundPosition( base_loc + hCaster:GetForwardVector() * wall_radius, hCaster )
	if search_loc.z-base_loc.z>10 and (not GridNav:IsTraversable( search_loc )) then
		return true
	end
	--查看是否遇到树
	if GridNav:IsNearbyTree( vLocation, tree_radius, false) then
		return true
	end
	--查看是否遇到建筑
	local buildings = FindUnitsInRadius(
		hCaster:GetTeamNumber(),	-- int, your team number
		vLocation,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		building_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	if #buildings>0 then
		return true
	end
	return false
end

----------------------------------------------------------
--		   	MONSTER_KILLER_FURY_SPRING               	--
----------------------------------------------------------
monster_killer_fury_spring = class({})

LinkLuaModifier("modifier_monster_killer_fury_spring", "mb/monster_killer/monster_killer_fury_spring.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monster_killer_fury_spring_motion", "mb/monster_killer/monster_killer_fury_spring.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monster_killer_fury_spring_debuff", "mb/monster_killer/monster_killer_fury_spring.lua", LUA_MODIFIER_MOTION_NONE)

function monster_killer_fury_spring:IsHiddenWhenStolen() 	return false end
function monster_killer_fury_spring:IsRefreshable() 		return true  end
function monster_killer_fury_spring:IsStealable() 			return true  end
function monster_killer_fury_spring:GetCastRange(location, target)
	if IsClient() then return self.BaseClass.GetCastRange(self, location, target) end 
end

function monster_killer_fury_spring:OnSpellStart()
	local caster      = self:GetCaster()
	local caster_pos  = caster:GetAbsOrigin()
	local target_pos  = self:GetCursorPosition()
	local direction   = (target_pos ~= caster_pos and (target_pos - caster_pos):Normalized()) or caster:GetForwardVector()
	      direction.z = 0.0
	local pos         = (target_pos - caster_pos):Length2D() <= self:GetSpecialValueFor("spring_range") and target_pos or caster_pos + direction * self:GetSpecialValueFor("spring_range")
	local duration    = self:GetSpecialValueFor("spring_duration");
	--muti cast bug 
	if caster:HasModifier("modifier_monster_killer_fury_spring_motion") then 
		caster:FindModifierByName("modifier_monster_killer_fury_spring_motion"):Destroy()
	end
	caster:AddNewModifier(caster, self, "modifier_monster_killer_fury_spring_motion", {duration = duration, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
	ProjectileManager:ProjectileDodge(caster)
	caster:Purge(false, true, false, false, false)
end

modifier_monster_killer_fury_spring_motion = class({})

function modifier_monster_killer_fury_spring_motion:IsDebuff()			return false end
function modifier_monster_killer_fury_spring_motion:IsHidden() 			return true end
function modifier_monster_killer_fury_spring_motion:IsPurgable() 		return false end
function modifier_monster_killer_fury_spring_motion:IsPurgeException() 	return false end
function modifier_monster_killer_fury_spring_motion:IsStunDebuff()		return true end
function modifier_monster_killer_fury_spring_motion:CheckState() 		return {[MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_MAGIC_IMMUNE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true} end
function modifier_monster_killer_fury_spring_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_DISABLE_TURNING,MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT} end
function modifier_monster_killer_fury_spring_motion:GetModifierDisableTurning() return 1 end
function modifier_monster_killer_fury_spring_motion:GetOverrideAnimation() return ACT_DOTA_TAUNT end
function modifier_monster_killer_fury_spring_motion:GetActivityTranslationModifiers() return "taunt_quickdraw_gesture" end
function modifier_monster_killer_fury_spring_motion:IsMotionController() return true end
function modifier_monster_killer_fury_spring_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function modifier_monster_killer_fury_spring_motion:GetStatusEffectName()  return "particles/units/heroes/hero_brewmaster/brewmaster_storm_ambient.vpcf" end
function modifier_monster_killer_fury_spring_motion:StatusEffectPriority() 	return MODIFIER_PRIORITY_HIGH end

function modifier_monster_killer_fury_spring_motion:OnCreated(keys)
	if IsServer() then
		self.caster          = self:GetCaster()
		self.parent          = self:GetParent()
		self.ability         = self:GetAbility()
		self.pos             = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.speed           = self.ability:GetSpecialValueFor("spring_range") / self.ability:GetSpecialValueFor("spring_duration");
		self.width           = self.ability:GetSpecialValueFor("spring_width")
		self.debuff_duration = self.ability:GetSpecialValueFor("debuff_duration")
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_monster_killer_fury_spring_motion:OnIntervalThink()
	local current_pos     = self.parent:GetAbsOrigin()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local distacne        = self.speed / (1.0 / FrameTime())
	local direction       = (self.pos - current_pos):Normalized()
	      direction.z     = 0
	local height          = self.ability:GetSpecialValueFor("spring_height")
	local next_pos        = GetGroundPosition((current_pos + direction * distacne), nil)
	      next_pos.z      = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self.parent:SetOrigin(next_pos)
	local horn_pos = self.parent:GetAttachmentOrigin(self.parent:ScriptLookupAttachment("attach_horn"))
	--Check
	if CheckBumped(self.parent,next_pos) then 
		self.parent:SetOrigin(GetGroundPosition(horn_pos, nil))
		self:Destroy()
	end 
end

function modifier_monster_killer_fury_spring_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
		self.pos = nil
		self.speed = nil
		self.parent:SetForwardVector(Vector(self.parent:GetForwardVector()[1], self.parent:GetForwardVector()[2], 0))
		local bShapeshift = false
		if self.parent:HasModifier("modifier_monster_killer_shapeshift_buff") then bShapeshift = true end 
		--Attack Once
		local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if enemy:IsAlive() then
				--attack once
				self.caster:PerformAttack(enemy, false, true, true, false, true, false, false)
				enemy:AddNewModifier(self.caster, self.ability,"modifier_monster_killer_fury_spring_debuff",{ duration = self.debuff_duration })
				if bShapeshift then 
					enemy:AddNewModifier(self.caster, self.ability,"modifier_nevermore_requiem_fear", {duration = self.debuff_duration})	
				end	
			end
		end
		--特效
		local smash_particle = "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf"
		local smash_sound = "Hero_Brewmaster.ThunderClap"
		--落地特效
		local smash = ParticleManager:CreateParticle(smash_particle, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(smash, 0, self:GetCaster():GetAbsOrigin())
		--猛击音效
		EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), smash_sound, self:GetCaster())
	end
end

-------------------------------------------------------------
--      MODIFIER_MONSTER_KILLER_FURY_SPRING_DEBUFF         --
-------------------------------------------------------------
modifier_monster_killer_fury_spring_debuff = class({})
--------------------------------------------------------------------------------
-- Classifications
function modifier_monster_killer_fury_spring_debuff:IsHidden() return false end
function modifier_monster_killer_fury_spring_debuff:IsDebuff() return true end
function modifier_monster_killer_fury_spring_debuff:IsPurgable() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_monster_killer_fury_spring_debuff:OnCreated( kv )
	-- references
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow" ) -- special value
	self.caster = self:GetAbility():GetCaster()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_monster_killer_fury_spring_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end
function modifier_monster_killer_fury_spring_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end