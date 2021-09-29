-- 02 27 by MysticBug-------
----------------------------
----------------------------

--  +175%暴伤 300攻               4  17      16   3(醉拳击杀延长持续时间)
--  200攻速   +4000 元素生命         15      14   2(激活大招获得4000血护盾)
--  40魔抗    +3s ThunderClap       13      12   1
--  600       60					11		10   

--brewmaster_thunder_clap  雷霆一击
--猛击地面，造成伤害并降低附近敌方单位的移动速度和攻击速度。
--imba 曼吉克斯向前跳跃一段距离，然后再猛击地面
-------------------------------------------------------------------------------------------------
--extra api
CreateTalents("npc_dota_hero_brewmaster","mb/hero_brewmaster.lua")
function StringToVector(sString)
	local temp = {}
	for str in string.gmatch(sString, "%S+") do
		if tonumber(str) then
			temp[#temp + 1] = tonumber(str)
		else
			return nil
		end
	end
	return Vector(temp[1], temp[2], temp[3])
end	

-- Custom function, checks if the unit is far enough away from the inner radius
function CalculateDistance(ent1, ent2)
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local distance = (pos1 - pos2):Length2D()
	return distance
end

-- Finds units only on the outer layer of a ring
function FindUnitsInRing(teamNumber, position, cacheUnit, ring_radius, ring_width, teamFilter, typeFilter, flagFilter, order, canGrowCache)
	-- First checks all of the units in a radius
	local all_units	= FindUnitsInRadius(teamNumber, position, cacheUnit, ring_radius, teamFilter, typeFilter, flagFilter, order, canGrowCache)
	
	-- Then builds a table composed of the units that are in the outer ring, but not in the inner one.
	local outer_ring_units	=	{}

	for _,unit in pairs(all_units) do
		-- Custom function, checks if the unit is far enough away from the inner radius
		if CalculateDistance(unit:GetAbsOrigin(), position) >= ring_radius - ring_width then
			table.insert(outer_ring_units, unit)
		end
	end

	return outer_ring_units
end

--[[function IsEnemy(caster, target)
  if caster:GetTeamNumber()==target:GetTeamNumber() then   
    return false  
  else
    return true
  end 
end]]

--[[function TriggerStandardTargetSpell(BaseNPC,ability)
	if IsEnemy(BaseNPC, ability:GetCaster()) then
		BaseNPC:TriggerSpellReflect(ability)
		return BaseNPC:TriggerSpellAbsorb(ability)
	end
	return false
end]]

function IsTrueHero(BaseNPC)
	return (not BaseNPC:IsTempestDouble() and BaseNPC:IsRealHero() and not BaseNPC:HasModifier("modifier_imba_meepo_clone_controller"))
end

function IsUnit(BaseNPC)
	return BaseNPC:IsHero() or BaseNPC:IsCreep() or BaseNPC:IsBoss()
end
-------------------------------------------------------------------------------------------

imba_brewmaster_thunder_clap = class({})

LinkLuaModifier("modifier_imba_brewmaster_thunder_clap_motion","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_thunder_clap_debuff","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_thunder_clap_buff","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)

function imba_brewmaster_thunder_clap:IsHiddenWhenStolen()  return false end
function imba_brewmaster_thunder_clap:IsRefreshable()		return true end
function imba_brewmaster_thunder_clap:IsStealable() 	return true end
function imba_brewmaster_thunder_clap:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_brewmaster_1")
end
--imba 曼吉克斯向前跳跃一段距离，然后再猛击地面 
function imba_brewmaster_thunder_clap:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	local ability = self
	local motion_movement = "modifier_imba_brewmaster_thunder_clap_motion"
	local jump_particle = "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf"

	--跳跃高度设置
	local jump_speed = ability:GetSpecialValueFor("jump_speed")
	local jump_horizontal_distance = ability:GetSpecialValueFor("jump_horizontal_distance") + caster:TG_GetTalentValue("special_bonus_imba_brewmaster_1")

	--传递Kv
    if target_point then
		local dis = (target_point - caster:GetAbsOrigin()):Length2D()
		local dir = (target_point - caster:GetAbsOrigin()):Normalized()
		if dis > jump_horizontal_distance then
		    dis = jump_horizontal_distance
		end
		local dur = dis/ jump_speed
		--载入跳跃
		caster:AddNewModifier(caster, self, motion_movement, {duration = dur,direction = dir})
	end
end

--跳跃
modifier_imba_brewmaster_thunder_clap_motion = class({})

function modifier_imba_brewmaster_thunder_clap_motion:IsBuff() return true end
function modifier_imba_brewmaster_thunder_clap_motion:IsHidden() return true end
function modifier_imba_brewmaster_thunder_clap_motion:IsPurgable() return false end
function modifier_imba_brewmaster_thunder_clap_motion:IsPurgeException() return false end
function modifier_imba_brewmaster_thunder_clap_motion:IsMotionController() return true end
function modifier_imba_brewmaster_thunder_clap_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_imba_brewmaster_thunder_clap_motion:OnCreated(keys)
	--特效
	self.smash_particle = "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf"
	self.smash_sound = "Hero_Brewmaster.ThunderClap"
	--KV
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.debuff_modifier = "modifier_imba_brewmaster_thunder_clap_debuff"
	self.debuff_duration = self:GetAbility():GetSpecialValueFor("duration")
	self.debuff_duration_creeps = self:GetAbility():GetSpecialValueFor("duration_creeps")
	self.buff_modifier = "modifier_imba_brewmaster_thunder_clap_buff"
	self.radius = self:GetAbility():GetSpecialValueFor("radius")

	if IsServer() then
		self.direction = StringToVector(keys.direction)
		self.speed = self:GetAbility():GetSpecialValueFor("jump_speed")
		if not self:CheckMotionControllers() then
			self:Destroy()
		else
			self:StartIntervalThink(FrameTime())
		end
	end
end

function modifier_imba_brewmaster_thunder_clap_motion:OnIntervalThink()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = self:GetAbility():GetSpecialValueFor("jump_height")
	local pos = self:GetParent():GetAbsOrigin() + self.direction * (self.speed / (1.0 / FrameTime()))
	pos = GetGroundPosition(pos, nil)
	pos.z = pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(pos)
end

function modifier_imba_brewmaster_thunder_clap_motion:OnDestroy()
	if IsServer() then
		--落地
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		--跳跃过程是否可以打断
		self:GetParent():InterruptMotionControllers(true)
		
		--落地特效
		local smash = ParticleManager:CreateParticle(self.smash_particle, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(smash, 0, self:GetCaster():GetAbsOrigin())

		--猛击音效
		EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), self.smash_sound, self:GetCaster())

		--猛击伤害
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),
			self:GetCaster():GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		local enemy_duration = self.debuff_duration
		local enemy_count = 0
		for _,enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
				damage_table = ({
					victim = enemy,
					attacker = self:GetCaster(),
					ability = self:GetAbility(),
					damage = self.damage,
					damage_type = self:GetAbility():GetAbilityDamageType()
				})
				--造成伤害
				ApplyDamage(damage_table)
				--DEBUFF
				if enemy:IsCreep() then
					enemy_duration = self.debuff_duration_creeps
				end
				--减攻速和减移速
				enemy:AddNewModifier_RS(self:GetCaster(), 
					self:GetAbility(), 
					self.debuff_modifier, 
					{duration = enemy_duration})
				enemy:EmitSound("Hero_Brewmaster.ThunderClap.Target")
				enemy_count = enemy_count + 1
			end
		end
		--自己添加BUFF
		self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self:GetAbility(),
			self.buff_modifier,
			{duration = self.debuff_duration_creeps , enemy_count = enemy_count}
			)

		--释放特效
		ParticleManager:ReleaseParticleIndex(smash)

		self.direction = nil
		self.speed = nil
	end
end

-- 允许使用位移技能和位移道具(跳刀)打断平移
function modifier_imba_brewmaster_thunder_clap_motion:OnHorizontalMotionInterrupted() self:Destroy() end
-- 允许使用位移技能和位移道具(跳刀)打断Z轴轨迹
function modifier_imba_brewmaster_thunder_clap_motion:OnVerticalMotionInterrupted() self:Destroy() end
-- 跳跃状态
function modifier_imba_brewmaster_thunder_clap_motion:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY]	= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]					= true,
	}
end


--DEBUFF 减少移速和攻速
modifier_imba_brewmaster_thunder_clap_debuff = class({})

function modifier_imba_brewmaster_thunder_clap_debuff:IsDebuff()		return true end
function modifier_imba_brewmaster_thunder_clap_debuff:IsHidden() 		return false end
function modifier_imba_brewmaster_thunder_clap_debuff:IsPurgable() 		return true end
function modifier_imba_brewmaster_thunder_clap_debuff:IsPurgeException() 	return true end
function modifier_imba_brewmaster_thunder_clap_debuff:GetEffectName() return "particles/basic_ambient/generic_paralyzed.vpcf" end
function modifier_imba_brewmaster_thunder_clap_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_brewmaster_thunder_clap_debuff:ShouldUseOverheadOffset() return true end
function modifier_imba_brewmaster_thunder_clap_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_brewmaster_thunder_clap_debuff:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("attack_speed_slow")) end
function modifier_imba_brewmaster_thunder_clap_debuff:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("movement_slow")) end

--Buff 增加自身攻速和移速
modifier_imba_brewmaster_thunder_clap_buff = class({})

function modifier_imba_brewmaster_thunder_clap_buff:IsDebuff()			return false end
function modifier_imba_brewmaster_thunder_clap_buff:IsHidden() 			return false end
function modifier_imba_brewmaster_thunder_clap_buff:IsPurgable() 		return true end
function modifier_imba_brewmaster_thunder_clap_buff:IsPurgeException() 	return true end
function modifier_imba_brewmaster_thunder_clap_buff:GetEffectName() return "particles/basic_ambient/generic_paralyzed.vpcf" end
function modifier_imba_brewmaster_thunder_clap_buff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_brewmaster_thunder_clap_buff:ShouldUseOverheadOffset() return true end
function modifier_imba_brewmaster_thunder_clap_buff:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_brewmaster_thunder_clap_buff:OnCreated(keys)
	if IsServer() then
		local caster = self:GetCaster()
		self.enemy_count = keys.enemy_count
		self.attack_count = self:GetAbility():GetSpecialValueFor("attack_count")
		self:SetStackCount(self.attack_count)
	end
end
function modifier_imba_brewmaster_thunder_clap_buff:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local enemy_self = self:GetParent()

	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	self:DecrementStackCount()
	if self:GetStackCount() == 0 then
		self:Destroy()
	end
end
function modifier_imba_brewmaster_thunder_clap_buff:GetModifierAttackSpeedBonus_Constant() return (self:GetAbility():GetSpecialValueFor("attack_speed_slow") * self:GetAbility():GetSpecialValueFor("attack_count")) end
function modifier_imba_brewmaster_thunder_clap_buff:GetModifierMoveSpeedBonus_Percentage() return (self:GetAbility():GetSpecialValueFor("movement_slow")) end
function modifier_imba_brewmaster_thunder_clap_buff:OnDestroy()
	if IsServer() then 
		self.enemy_count = nil 
		self.attack_count = nil
	end
end
-- 02 27 by MysticBug-------
----------------------------
----------------------------

--brewmaster_cinder_brew   余烬佳酿 (新代替醉酒云雾技能)
--将烈酒洒向一片区域，使敌方单位移动变慢，受到技能伤害后还将燃烧。点燃时持续时间增加%extra_duration%秒。
--imba 自残：受影响的敌人几率攻击自己

imba_brewmaster_cinder_brew = class({})

LinkLuaModifier("modifier_imba_cinder_brew_thinker","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_cinder_brew_debuff","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_cinder_brew_burned","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)

function imba_brewmaster_cinder_brew:IsHiddenWhenStolen()	return false end
function imba_brewmaster_cinder_brew:IsRefreshable()		return true end
function imba_brewmaster_cinder_brew:IsStealable()			return true end
function imba_brewmaster_cinder_brew:IsNetherWardStealable() return false end

function imba_brewmaster_cinder_brew:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	--弹道音效 sounds/weapons/hero/brewmaster/drunken_haze_cast.vsnd
	--目标音效 sounds/weapons/hero/brewmaster/drunken_haze_target.vsnd
	local brew_particle = "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_cast_projectile.vpcf"

	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local brew_sound = "Hero_Brewmaster.CinderBrew.Cast"
	--Hero_Brewmaster.Brawler.Crit  Hero_Brewmaster.PrimalSplit.Spawn
	--Hero_Brewmaster.Drunken_Haze.Cast

	EmitSoundOnLocationWithCaster(target_point, brew_sound, caster)
	
	local thinker = CreateModifierThinker(
		caster, 
		self, 
		"modifier_imba_cinder_brew_thinker", 
		{
			duration = duration,
			target_x = target_point.x,
			target_y = target_point.y,
			target_z = target_point.z
		}, 
			target_point, 
			caster:GetTeamNumber(), 
			false
		)

	--弹道特效
	local pfx_tgt = ParticleManager:CreateParticle(brew_particle, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_tgt, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx_tgt, 1, target_point)
	ParticleManager:ReleaseParticleIndex(pfx_tgt)
end

--AOE 监测
modifier_imba_cinder_brew_thinker = class({})

function modifier_imba_cinder_brew_thinker:OnCreated(kv)
	if IsServer() then
		self.target_x       = kv.target_x
		self.target_y       = kv.target_y
		self.target_z       = kv.target_z

		local ability       = self:GetAbility()
		local caster        = self:GetCaster()
		local pos           = Vector(self.target_x,self.target_y,self.target_z)
		local brew_particle = "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_cast.vpcf"

		--BOOM特效
		local pfx = ParticleManager:CreateParticle(brew_particle, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:SetParticleControl(pfx, 1, pos)
		ParticleManager:ReleaseParticleIndex(pfx)
		-- Find enemies
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			pos,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			ability:GetSpecialValueFor("radius"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for _, enemy in pairs(enemies) do
			--减速和自残判断
			if not enemy:IsMagicImmune() then 
				enemy:AddNewModifier_RS(
					enemy, 
					ability, 
					"modifier_imba_cinder_brew_debuff", 
					{duration = ability:GetSpecialValueFor("duration")}
				)
				enemy:EmitSound("Hero_Brewmaster.CinderBrew.Target")
			end
		end
	end
end

function modifier_imba_cinder_brew_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
end

--减速、自残、点燃判断
modifier_imba_cinder_brew_debuff = class({})

function modifier_imba_cinder_brew_debuff:IsDebuff()			return true end
function modifier_imba_cinder_brew_debuff:IsHidden() 			return false end
function modifier_imba_cinder_brew_debuff:IsPurgable() 			return true end
function modifier_imba_cinder_brew_debuff:IsPurgeException() 	return true end
function modifier_imba_cinder_brew_debuff:GetEffectName() return "particles/status_fx/status_effect_brewmaster_cinder_brew.vpcf" end
function modifier_imba_cinder_brew_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_cinder_brew_debuff:ShouldUseOverheadOffset() return true end
function modifier_imba_cinder_brew_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_imba_cinder_brew_debuff:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("movement_slow")) end

--自残几率  目标被缴械可以避免
function modifier_imba_cinder_brew_debuff:OnAttackLanded( keys )
	if not IsServer() then
		return 
	end
	local ability    = self:GetAbility()
	local caster     = self:GetCaster()
	local enemy_self = self:GetParent()

	if keys.attacker ~= enemy_self or keys.target:IsIllusion() or not keys.target:IsAlive() then
		return
	end

	if PseudoRandom:RollPseudoRandom(ability, ability:GetSpecialValueFor("self_mutilating_chance")) then
		if not enemy_self:IsInvisible() and not enemy_self:IsInvulnerable() and not enemy_self:IsOutOfGame() then
			enemy_self:PerformAttack(enemy_self, false, true, true, true, false, false, true)
			--自残特效
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_self_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy_self)
			ParticleManager:SetParticleControl(pfx, 0, enemy_self:GetOrigin())
			ParticleManager:SetParticleControl(pfx, 1, enemy_self:GetOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)
			--自残音效
			enemy_self:EmitSound("Hero_Brewmaster.CinderBrew.SelfAttack")
		end
	end
end

--受伤害点燃持续时间延长
function modifier_imba_cinder_brew_debuff:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then
		return 
	end
	local ability        = self:GetAbility()
	local caster         = self:GetCaster()
	local enemy_self     = self:GetParent()
	local extra_duration = ability:GetSpecialValueFor("extra_duration")
	if caster:TG_HasTalent("special_bonus_imba_brewmaster_3") then 
		extra_duration = math.floor(ability:GetSpecialValueFor("extra_duration") * caster:TG_GetTalentValue("special_bonus_imba_brewmaster_3")/100)
	end

	if IsServer() then
		--受伤害点燃持续时间延长
		if not enemy_self:HasModifier("modifier_imba_cinder_brew_burned") then		 
			enemy_self:AddNewModifier(
				caster, 
				ability, 
				"modifier_imba_cinder_brew_burned", 
				{duration = self:GetDuration() + extra_duration }
			)
			--延长修饰器持续时间
			self:SetDuration(self:GetDuration() + extra_duration,true)
		end
	end
end

--持续燃烧魔法伤害
modifier_imba_cinder_brew_burned = class({})

function modifier_imba_cinder_brew_burned:IsDebuff()			return true end
function modifier_imba_cinder_brew_burned:IsHidden() 			return false end
function modifier_imba_cinder_brew_burned:IsPurgable() 			return true end
function modifier_imba_cinder_brew_burned:IsPurgeException() 	return true end
function modifier_imba_cinder_brew_burned:GetEffectName() 		return "particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_debuff.vpcf" end
function modifier_imba_cinder_brew_burned:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_cinder_brew_burned:OnCreated(kv)
	if IsServer() then
	local total_damage = self:GetAbility():GetSpecialValueFor("total_damage")
	if self:GetCaster():TG_HasTalent("special_bonus_imba_brewmaster_3") then 
		total_damage = math.floor(self:GetAbility():GetSpecialValueFor("total_damage") * self:GetCaster():TG_GetTalentValue("special_bonus_imba_brewmaster_3")/100)
	end
	self.dps = total_damage / self:GetDuration()
	-----------------------------------------------
    -- 灼烧音效
    self:GetParent():EmitSound("Hero_Brewmaster.CinderBrew.Creep")
    -----------------------------------------------
	self:StartIntervalThink(1)
	end
end

function modifier_imba_cinder_brew_burned:OnIntervalThink(kv)
	--if not IsServer() then return end
	local ability    = self:GetAbility()
	local caster     = self:GetCaster()
	local enemy_self = self:GetParent()
	local damageTable = {
					victim = enemy_self,
					attacker = caster,
					damage = self.dps,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE, --Optional. 火焰伤害
					ability = self:GetAbility(), --Optional.
					}
	ApplyDamage(damageTable)
end

--brewmaster_drunken_brawler  醉拳
--酒仙被动获得一定几率闪避物理攻击并能造成致命一击。
--主动施放后进入醉拳状态，闪避攻击和致命一击的几率得到提升。
--酒仙的自身移动速度将持续变化，从-%min_movement%%%到%max_movement%%%。持续%duration%秒。
--imba 1.醉荡步: 主动施放后持续时间内闪避一切物理攻击.
--     2.踢连环: 主动施放期间每击杀一英雄单位,醉拳效果延长1s.

imba_brewmaster_drunken_brawler = class({})

LinkLuaModifier("modifier_imba_brewmaster_drunken_brawler_passive","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_drunken_brawler_active","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)

function imba_brewmaster_drunken_brawler:IsHiddenWhenStolen() 	return false end
function imba_brewmaster_drunken_brawler:IsRefreshable() 		return true end
function imba_brewmaster_drunken_brawler:IsStealable() 			return true end
function imba_brewmaster_drunken_brawler:GetIntrinsicModifierName() return "modifier_imba_brewmaster_drunken_brawler_passive" end

function imba_brewmaster_drunken_brawler:OnSpellStart()
	local caster        = self:GetCaster()
	local ability       = self
	local duration      = self:GetSpecialValueFor("duration")
	local brawler_sound = "Hero_Brewmaster.Brawler.Cast"
	local pos           = self:GetCaster():GetAbsOrigin()
	--开始音效
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), brawler_sound, caster)
	--暴击和闪避修饰器 移速限制修改器
	caster:AddNewModifier(
				caster, 
				ability, 
				"modifier_imba_brewmaster_drunken_brawler_active", 
				{duration = duration}
			)
end

--醉拳主动
modifier_imba_brewmaster_drunken_brawler_active = class({})

function modifier_imba_brewmaster_drunken_brawler_active:IsDebuff()			return false end
function modifier_imba_brewmaster_drunken_brawler_active:IsHidden() 		return false end
function modifier_imba_brewmaster_drunken_brawler_active:IsPurgable() 		return true end
--醉拳特效
function modifier_imba_brewmaster_drunken_brawler_active:GetEffectName() return "particles/units/heroes/hero_brewmaster/brewmaster_drunkenbrawler_crit.vpcf" end
function modifier_imba_brewmaster_drunken_brawler_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_brewmaster_drunken_brawler_active:DeclareFunctions()	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_EVENT_ON_HERO_KILLED,MODIFIER_PROPERTY_AVOID_DAMAGE} end
--移速
function modifier_imba_brewmaster_drunken_brawler_active:GetModifierMoveSpeedBonus_Percentage() return	self:GetAbility():GetSpecialValueFor("max_movement") end
--IMBA
function modifier_imba_brewmaster_drunken_brawler_active:OnHeroKilled(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() and keys.target:IsHero() then 
		self:SetDuration(self:GetRemainingTime() + self:GetAbility():GetSpecialValueFor("active_extend"),true)
	end
end
--避免物理伤害
function modifier_imba_brewmaster_drunken_brawler_active:GetModifierAvoidDamage(tg) 
	if self:GetAbility() ~= nil and tg.target==self:GetParent() and (tg.damage_type == DAMAGE_TYPE_PHYSICAL) then return 1 end
	return 0 
end

--暴击和闪避修饰器 移速限制修改器
modifier_imba_brewmaster_drunken_brawler_passive = class({})

function modifier_imba_brewmaster_drunken_brawler_passive:IsDebuff()			return false end
function modifier_imba_brewmaster_drunken_brawler_passive:IsHidden() 			return true end
function modifier_imba_brewmaster_drunken_brawler_passive:IsPurgable() 		return false end
function modifier_imba_brewmaster_drunken_brawler_passive:IsPurgeException() 	return false end
function modifier_imba_brewmaster_drunken_brawler_passive:DeclareFunctions()	return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_ATTACK_FAIL,MODIFIER_PROPERTY_EVASION_CONSTANT} end
function modifier_imba_brewmaster_drunken_brawler_passive:OnCreated() self.crit = {} end
function modifier_imba_brewmaster_drunken_brawler_passive:OnDestroy() self.crit = nil end
--暴击
function modifier_imba_brewmaster_drunken_brawler_passive:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() and keys.attacker == self:GetParent() and IsUnit(keys.target) and not self:GetParent():PassivesDisabled() then
		local brewmaster = self:GetParent()
		local ability = self:GetAbility()
		local crit_chance = ability:GetSpecialValueFor("crit_chance") 
		if brewmaster:HasModifier("modifier_imba_brewmaster_drunken_brawler_active") then 
			crit_chance = crit_chance * ability:GetSpecialValueFor("active_multiplier")
		end
		if PseudoRandom:RollPseudoRandom(ability, crit_chance) or brewmaster:HasModifier("modifier_imba_brewmaster_fire_buff") then
			self.crit[keys.record] = true
			if brewmaster:TG_HasTalent("special_bonus_imba_brewmaster_4") then
				return (ability:GetSpecialValueFor("crit_multiplier") + brewmaster:TG_GetTalentValue("special_bonus_imba_brewmaster_4"))
			else
				return (ability:GetSpecialValueFor("crit_multiplier"))
			end
		end
		return 0 
	end
end

function modifier_imba_brewmaster_drunken_brawler_passive:OnAttackFail(keys) self.crit[keys.record] = nil end
function modifier_imba_brewmaster_drunken_brawler_passive:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	if self.crit[keys.record] then
		--暴击音效
		self:GetParent():EmitSound("Hero_Brewmaster.Brawler.Crit")
		--暴击特效
		--local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		--ParticleManager:ReleaseParticleIndex(pfx)
	end
	self.crit[keys.record] = nil
end
--闪避
function modifier_imba_brewmaster_drunken_brawler_passive:GetModifierEvasion_Constant() 
	if self:GetParent():HasModifier("modifier_imba_brewmaster_drunken_brawler_active") and self:GetAbility() ~= nil then 
		return	self:GetAbility():GetSpecialValueFor("dodge_chance") * self:GetAbility():GetSpecialValueFor("active_multiplier")
	end
	return	self:GetAbility():GetSpecialValueFor("dodge_chance") 
end
-- 02 27 by MysticBug-------
----------------------------
----------------------------


---------------------------------------------------------------------
----------------     BREWMASTER PRIMAL SPLIT     --------------------
---------------------------------------------------------------------
--(神杖)虚无战士 虚无 太虚斩
--imba_brewmaster_void_astral_pulse

--imba_brewmaster_primal_split ?
--imba_brewmaster_primal_split_switch  切换元素分离效果

--<font color='#EE2C2C'>酒仙分裂成元素，变身成为各有所长的战士之一，不同战士将会导致元素分离冷却时间不同。</font>
--\n<h1><font color='#EE2C2C'>1.大地●粉碎击</font></h1> 猛击地面产生多道巨石残岩，巨石残岩造成伤害和眩晕,持续时间内酒仙对建筑额外造成100/120/150%伤害.
--\n<h1><font color='#EE2C2C'>2.狂风●龙卷风</font></h1> 向前方施放三道龙卷风，对敌方造成伤害,击飞,弱驱散效果,对队友造成治疗和强驱散效果.持续时间内酒仙获得350/400/450攻击距离提升.
--\n<h1><font color='#EE2C2C'>3.烈火●烈火拳</font></h1> 对前方800码范围内敌方造成当前等级醉拳致命一击,持续时间酒仙内获得永久献祭光环，对敌方每秒造成100 + 酒仙4%当前生命灼烧伤害.
--\n<h1><font color='#EE2C2C'>4.虚无●太虚斩</font></h1> 对前方800码范围内敌方造成2s静止和魔法伤害,持续时间内每隔2s酒仙进入一次虚化状态,躲避一切伤害,虚化期间可以施法,但是一旦攻击将会脱离虚化效果.

imba_brewmaster_primal_split = class({})

ENUM_EARTH = 1
ENUM_STORM = 2
ENUM_FIRE  = 3
ENUM_VOID  = 4

SPLIT_TYPE = {
	{ENUM_EARTH,"modifier_imba_brewmaster_earth"},
	{ENUM_STORM,"modifier_imba_brewmaster_storm"},
	{ENUM_FIRE,"modifier_imba_brewmaster_fire"},
	{ENUM_VOID,"modifier_imba_brewmaster_void"}
}

TEXTURE_TYPE = {
	{ENUM_EARTH,"brewmaster_earth_pulverize"},
	{ENUM_STORM,"brewmaster_storm_cyclone"},
	{ENUM_FIRE,"ember_spirit_sleight_of_fist"},
	{ENUM_VOID,"void_spirit_resonant_pulse"}
}

SHARD_TYPE = {
	{ENUM_EARTH,"modifier_imba_brewmaster_earth_spell_immunity"},
	{ENUM_STORM,"modifier_brewmaster_storm_wind_walk"},
	{ENUM_FIRE,"modifier_imba_brewmaster_fire_dash_fist"},
	{ENUM_VOID,"modifier_imba_brewmaster_void_astral_pulse"}
}

SHARD_TEXTURE_TYPE = {
	{ENUM_EARTH,"brewmaster_earth_spell_immunity"},
	{ENUM_STORM,"brewmaster_storm_wind_walk"},
	{ENUM_FIRE,"brewmaster_fire_permanent_immolation"},
	{ENUM_VOID,"brewmaster_void_astral_pulse"}
}

LinkLuaModifier("modifier_imba_brewmaster_primal_split_switch","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_earth","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_storm","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_fire","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_void","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_fire_buff","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_void_buff","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)


function imba_brewmaster_primal_split:IsHiddenWhenStolen() 		return false end
function imba_brewmaster_primal_split:IsRefreshable() 			return true end
function imba_brewmaster_primal_split:IsStealable() 			return false end
function imba_brewmaster_primal_split:GetCooldown( iLevel )
	if self:GetCaster():TG_HasTalent("special_bonus_imba_brewmaster_2") then 
		return self.BaseClass.GetCooldown( self, iLevel ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_brewmaster_2")
	else
		return self.BaseClass.GetCooldown( self, iLevel )
	end
end
function imba_brewmaster_primal_split:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_brewmaster_primal_split_switch") then  
		local split_type = self:GetCaster():GetModifierStackCount("modifier_imba_brewmaster_primal_split_switch", nil)
		--返回对应技能图标
		for k,v in pairs(TEXTURE_TYPE) do
		    if v[1] == split_type then
		        return TEXTURE_TYPE[k][2]
		    end
		end
	end
	return "brewmaster_primal_split"
end
--魔晶
--brewmaster_void_astral_pulse --2020 12 25 by MysticBug-------
--[[function imba_brewmaster_primal_split:OnInventoryContentsChanged()
	if self:GetCaster():Has_Aghanims_Shard() then 
		local shard_abi = self:GetCaster():FindAbilityByName("brewmaster_void_astral_pulse")
		if shard_abi then 
			shard_abi:SetHidden(false)
			shard_abi:SetLevel(self:GetLevel())
		end
	else
		local shard_abi = self:GetCaster():FindAbilityByName("brewmaster_void_astral_pulse")
		if shard_abi then 
			shard_abi:SetHidden(true)
			shard_abi:SetLevel(0)
		end
	end
end]]

function imba_brewmaster_primal_split:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	--音效
	caster:EmitSound("Hero_Brewmaster.PrimalSplit.Cast")
	return true
end

function imba_brewmaster_primal_split:OnUpgrade()
	if not self:GetCaster():HasModifier("modifier_imba_brewmaster_primal_split_switch") then
		self:GetCaster():AddNewModifierWhenPossible(self:GetCaster(), self, "modifier_imba_brewmaster_primal_split_switch", {})
	end
	local caster = self:GetCaster()
	local primal_split_switch = caster:FindAbilityByName("imba_brewmaster_primal_split_switch")
	if primal_split_switch then 
		primal_split_switch:SetLevel(self:GetLevel())
	end
end

function imba_brewmaster_primal_split:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	--音效
	caster:EmitSound("Hero_Brewmaster.PrimalSplit.Spawn")
	--check type 
	if caster:HasModifier("modifier_imba_brewmaster_primal_split_switch") then  
		local split_type = math.max(caster:GetModifierStackCount("modifier_imba_brewmaster_primal_split_switch", nil),1)
		--添加对应技能mod
		for k,v in pairs(SPLIT_TYPE) do
		    if v[1] == split_type then
		    	caster:AddNewModifier(
		    			caster, -- player source
		    			self, -- ability source
		    			SPLIT_TYPE[k][2], -- modifier name
		    			{ duration = (split_type == ENUM_VOID and duration/2 or duration) } -- kv
		    		)
		    end
		end
	end
end

-----------------------
--	Tornado On Hit   --
-----------------------
function imba_brewmaster_primal_split:OnProjectileHit(target, location)
	if IsServer() then
		--伤害
		local damage          = self:GetSpecialValueFor("damage")
		local heal_num        = damage * self:GetSpecialValueFor("storm_count")
		local debuff_duration = self:GetSpecialValueFor("debuff_duration")
		if target ~= nil then 
			if IsEnemy(self:GetCaster(),target) then
				ApplyDamage(
					{
						attacker = self:GetCaster(), 
						victim = target, 
						damage = damage, 
						ability = self, 
						damage_type = DAMAGE_TYPE_MAGICAL
					}
				)
				--吹飞    
				local caster_pos = self:GetCaster():GetAbsOrigin()
				local knockback_table =
				{
					center_x = caster_pos.x ,
					center_y = caster_pos.y ,
					center_z = caster_pos.z ,
					duration = debuff_duration,
					knockback_duration = debuff_duration,
					knockback_distance = 10,
					knockback_height = 0
				}
				target:Purge(true, false, false, false, false)
				target:AddNewModifier_RS( self:GetCaster(), self, "modifier_knockback", knockback_table )
			else
				--ally
				target:Purge(false, true, false, true, true)
				target:Heal(heal_num, self:GetCaster())
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal_num, nil)
			end
		end
	end
end

---------------------------------------------------------------------
----------------     MODIFIER_IMBA_BREWMASTER_EARTH     -------------
---------------------------------------------------------------------
modifier_imba_brewmaster_earth = class({})

function modifier_imba_brewmaster_earth:IsDebuff()			return false end
function modifier_imba_brewmaster_earth:IsHidden() 			return false end
function modifier_imba_brewmaster_earth:IsPurgable() 		return false end
function modifier_imba_brewmaster_earth:IsPurgeException() 	return false end
function modifier_imba_brewmaster_earth:GetTexture() return TEXTURE_TYPE[ENUM_EARTH][2] end
--分裂成大地战士
function modifier_imba_brewmaster_earth:DeclareFunctions() return {MODIFIER_PROPERTY_MODEL_CHANGE,MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL} end
function modifier_imba_brewmaster_earth:GetModifierModelChange() return "models/heroes/brewmaster/brewmaster_earthspirit.vmdl" end
function modifier_imba_brewmaster_earth:GetStatusEffectName()	return "particles/units/heroes/hero_brewmaster/brewmaster_earth_ambient.vpcf" end
function modifier_imba_brewmaster_earth:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA end
--建筑被动伤害
function modifier_imba_brewmaster_earth:GetModifierProcAttack_BonusDamage_Physical(keys)
	local parent = self:GetParent()
	local passive = self:GetAbility()
	if not IsServer() or keys.attacker ~= parent or parent:PassivesDisabled() or parent:IsIllusion() or not keys.target:IsBuilding() then	
		return
	end
	if not parent:IsAlive() then
		return
	end
	return keys.damage * self:GetAbility():GetSpecialValueFor("buildings_damage") / 100
end
function modifier_imba_brewmaster_earth:OnCreated()
	if IsServer() then
		local caster               = self:GetCaster()
		local pos                  = caster:GetAbsOrigin()
		--音效和特效
		local boulder_sound        = "Brewmaster_Earth.Boulder.Cast"
		local boulder_target_sound = "Brewmaster_Earth.Boulder.Target"
		---------------------------------------------------------------
		local boulder_pfx          = "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf"
		---------------------------------------------------------------
		local debuff_duration      = self:GetAbility():GetSpecialValueFor("debuff_duration")
		local knock_table          = {}
		--环参数
		local radius               = self:GetAbility():GetSpecialValueFor("radius")
		local ring_count           = self:GetAbility():GetSpecialValueFor("ring_count")
		local ring_radius          = radius / ring_count
		local ring                 = 1
		local damageTable = {
						--victim = enemy,
						damage = self:GetAbility():GetSpecialValueFor("damage"),
						damage_type = DAMAGE_TYPE_PURE,
						attacker = caster,
						ability = self:GetAbility()
					}

		-- 音效
		caster:EmitSound("Brewmaster_Earth.Boulder.Cast")
		for i=1,ring_count do
			Timers:CreateTimer(0.2*i,function()
				self.pfx = ParticleManager:CreateParticle(boulder_pfx, PATTACH_WORLDORIGIN, caster)
				ParticleManager:SetParticleControl(self.pfx, 0, pos)
				ParticleManager:SetParticleControl(self.pfx, 1, Vector(ring_radius * i, 0 , 0))
				return nil 
			end)
		end
		-- 以环状圈范围搜寻敌人
		Timers:CreateTimer(function()
			local enemies =	FindUnitsInRing(caster:GetTeamNumber(),
				pos,
				nil,
				ring * ring_radius ,
				ring_radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_DAMAGE_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)
			for _,enemy in pairs(enemies) do
				if not IsInTable(knock_table, enemy) then
					-- Emit hit sound
					enemy:EmitSound(boulder_target_sound)
					--特效
					local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_impale_hit_spikes.vpcf", PATTACH_CUSTOMORIGIN, nil)
					for i=0, 2 do
						ParticleManager:SetParticleControl(pfx, i, GetGroundPosition(enemy:GetAbsOrigin(), nil))
					end
					-- 落地造成伤害
					damageTable.victim = enemy
					ApplyDamage(damageTable)
					--特效移除
					ParticleManager:ReleaseParticleIndex(pfx)
					--眩晕
					if not enemy:IsMagicImmune() then 
						enemy:AddNewModifier_RS(caster, self:GetAbility(), "modifier_stunned", {duration = debuff_duration})
					end
					-- 记录已经被击飞的单位
					table.insert(knock_table, enemy)
				end
			end
				-- 下一个圈
				if ring < ring_count then
					ring = ring + 1
					return 0.25
				end
		end)
		if self.pfx~=nil then 
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end
end

function modifier_imba_brewmaster_earth:OnRefresh()
	self:OnCreated()
end

function modifier_imba_brewmaster_earth:OnDestroy()
	--结束音效
	if IsServer() then
		self:GetParent():EmitSound("Hero_Brewmaster.PrimalSplit.Return") 
	end
end

---------------------------------------------------------------------
----------------     MODIFIER_IMBA_BREWMASTER_STORM     -------------
---------------------------------------------------------------------

modifier_imba_brewmaster_storm = class({})

function modifier_imba_brewmaster_storm:IsDebuff()			return false end
function modifier_imba_brewmaster_storm:IsHidden() 			return false end
function modifier_imba_brewmaster_storm:IsPurgable() 		return false end
function modifier_imba_brewmaster_storm:IsPurgeException() 	return false end
function modifier_imba_brewmaster_storm:GetTexture() return TEXTURE_TYPE[ENUM_STORM][2] end
--分裂成狂风战士
function modifier_imba_brewmaster_storm:DeclareFunctions() return {MODIFIER_PROPERTY_MODEL_CHANGE,MODIFIER_PROPERTY_ATTACK_RANGE_BONUS} end
function modifier_imba_brewmaster_storm:GetModifierModelChange() return "models/heroes/brewmaster/brewmaster_windspirit.vmdl" end
function modifier_imba_brewmaster_storm:GetModifierAttackRangeBonus() 
	if IsServer() then 
		return self.attack_bouns
	end
end
function modifier_imba_brewmaster_storm:GetStatusEffectName()	return "particles/units/heroes/hero_brewmaster/brewmaster_storm_ambient.vpcf" end
function modifier_imba_brewmaster_storm:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA end
function modifier_imba_brewmaster_storm:OnCreated() 
	if IsServer() then
		self.ability          = self:GetAbility()
		self.caster           = self.ability:GetCaster()
		self.parent           = self:GetParent()
		self.attack_bouns     = self.ability:GetSpecialValueFor("storm_attackrange")
		
		local distance        = self.ability:GetSpecialValueFor("radius")
		local storm_width     = self.ability:GetSpecialValueFor("storm_width")
		local speed           = self.ability:GetSpecialValueFor("speed")
		local storm_count     = self.ability:GetSpecialValueFor("storm_count")
		local direction       = self.caster:GetForwardVector()
		direction.z           = 0.0
		direction             = direction:Normalized()
		local location        = self.caster:GetAbsOrigin()
		local pfx_name        = "particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6.vpcf"
		local sound_name_cast = "Brewmaster_Storm.DispelMagic"

		for i = 1, storm_count do
			local storm_count_direction = (RotatePosition(location, QAngle(0, (-1) * 30 + (i - 1) * 60 / (storm_count - 1) , 0), location + direction * distance) - location):Normalized()
			local info = 
			{
				Ability = self.ability,
				EffectName = pfx_name,
				vSpawnOrigin = self.caster:GetAbsOrigin(),
				fDistance = distance * 2,
				fStartRadius = storm_width,
				fEndRadius = storm_width,
				Source = self.caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 10.0,
				bDeleteOnHit = false,
				vVelocity = storm_count_direction * speed,
				bProvidesVision = true,
			}
			ProjectileManager:CreateLinearProjectile(info)
			EmitSoundOnLocationWithCaster(self.caster:GetAbsOrigin(), sound_name_cast, self.caster)
		end	

		--施法结束 冷却减半
		local ult_ability = self.caster:FindAbilityByName("imba_brewmaster_primal_split")
		local ult_cooldown_pct = self.ability:GetSpecialValueFor("cooldown_pct") / 100
		if ult_ability then 
			local ult_ability_cd = ult_ability:GetCooldownTimeRemaining() 
			ult_ability:EndCooldown()
			ult_ability:StartCooldown(ult_ability_cd * (1 - ult_cooldown_pct))
		end
	end
end
function modifier_imba_brewmaster_storm:OnRefresh()
	self:OnCreated()
end

function modifier_imba_brewmaster_storm:OnDestroy()
	--结束音效
	if IsServer() then
		self:GetParent():EmitSound("Hero_Brewmaster.PrimalSplit.Return") 
	end
end

---------------------------------------------------------------------
----------------     MODIFIER_IMBA_BREWMASTER_FIRE     --------------
---------------------------------------------------------------------

modifier_imba_brewmaster_fire = class({})

function modifier_imba_brewmaster_fire:IsDebuff()			return false end
function modifier_imba_brewmaster_fire:IsHidden() 			return false end
function modifier_imba_brewmaster_fire:IsPurgable() 		return false end
function modifier_imba_brewmaster_fire:IsPurgeException() 	return false end
function modifier_imba_brewmaster_fire:GetTexture() return TEXTURE_TYPE[ENUM_FIRE][2] end
--分裂成烈火战士
function modifier_imba_brewmaster_fire:DeclareFunctions() return {MODIFIER_PROPERTY_MODEL_CHANGE,MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL} end
function modifier_imba_brewmaster_fire:GetModifierModelChange() return "models/heroes/brewmaster/brewmaster_firespirit.vmdl" end
function modifier_imba_brewmaster_fire:GetStatusEffectName()	return "particles/units/heroes/hero_brewmaster/brewmaster_fire_ambient.vpcf" end
function modifier_imba_brewmaster_fire:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA end
function modifier_imba_brewmaster_fire:OnCreated() 
	if IsServer() then
		self.ability              = self:GetAbility()
		self.caster               = self.ability:GetCaster()
		self.parent               = self:GetParent()
		self.fire_interval        = self.ability:GetSpecialValueFor("fire_interval")
		self.fire_attack_interval = self.ability:GetSpecialValueFor("fire_attack_interval")
		self.fire_radius          = self.ability:GetSpecialValueFor("fire_radius")
		self.fire_damage          = self.ability:GetSpecialValueFor("fire_damage")
		self.dam=
		{
		    attacker = self.parent,
		    ability = self.ability,
		    damage = self.fire_damage,
		    damage_type = DAMAGE_TYPE_MAGICAL,
		}
		self.pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlForward(self.pf, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(self.pf, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pf, 2, Vector(325, 0, 0))
		ParticleManager:SetParticleControl(self.pf, 3, Vector(5.0, 0, 0))
		self:AddParticle(self.pf, false, false, 15, false, false)
		self:SpellFireOfFist()     
        self:StartIntervalThink(self.fire_interval)
        --施法结束 冷却减半
		local ult_ability = self.caster:FindAbilityByName("imba_brewmaster_primal_split")
		local ult_cooldown_pct = self.ability:GetSpecialValueFor("cooldown_pct") / 100
		if ult_ability then 
			local ult_ability_cd = ult_ability:GetCooldownTimeRemaining() 
			ult_ability:EndCooldown()
			ult_ability:StartCooldown(ult_ability_cd * (1 - ult_cooldown_pct))
		end
	end
end
function modifier_imba_brewmaster_fire:OnRefresh()
	self:OnCreated()
end

function modifier_imba_brewmaster_fire:OnDestroy()
	--结束音效
	if IsServer() then
		ParticleManager:DestroyParticle(self.pf, false)
        ParticleManager:ReleaseParticleIndex(self.pf)
		self:GetParent():EmitSound("Hero_Brewmaster.PrimalSplit.Return") 
	end
end

function modifier_imba_brewmaster_fire:OnIntervalThink()	
    if not self.parent:IsAlive() then
        return 
    end 
    local heroes = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.fire_radius , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    if #heroes>0 then 
        for _,tar in pairs(heroes) do
            if not tar:IsMagicImmune() then 
                self.dam.victim = tar
                self.dam.damage = self.fire_damage + self.caster:GetHealth() * self.ability:GetSpecialValueFor("fire_damage_pct") / 100 
                ApplyDamage(self.dam)
            end 
        end
    end
end

function modifier_imba_brewmaster_fire:SpellFireOfFist()
	if not IsServer() then return end
	--kv 
	local pos     = self.caster:GetAbsOrigin()
	local team    = self.caster:GetTeamNumber()
	local cur_pos = pos+self.caster:GetForwardVector() * self.fire_radius
	local stack   = 1
	local heroes  = {}
	local op      = {}
    EmitSoundOn("Hero_EmberSpirit.SleightOfFist.Cast", self.caster)  
    local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pf, 0, cur_pos)
    ParticleManager:SetParticleControl(pf, 1, Vector(self.fire_radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(pf)
    heroes = FindUnitsInRadius(team, cur_pos, nil, self.fire_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

    if #heroes>0 then 
    	self.ability:SetActivated(false) 
        local pf1 = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pf1, 0, pos)
        ParticleManager:SetParticleControlForward(pf1, 1, self.caster:GetForwardVector())
        ParticleManager:SetParticleControl(pf1, 62, Vector(10, 0, 0))
        for a=1,#heroes do
            op[a] = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf", PATTACH_OVERHEAD_FOLLOW, heroes[a])
            ParticleManager:SetParticleControl( op[a], 0, heroes[a]:GetAbsOrigin())
        end
        self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_brewmaster_fire_buff", {})
        Timers:CreateTimer(0, function()
            if  heroes~=nil and stack<=#heroes then 
                if heroes[stack]~=nil and heroes[stack]:IsAlive() then 
                    local tpos=heroes[stack]:GetAbsOrigin()
                    local trail = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
                    ParticleManager:SetParticleControl(trail, 0,self.caster:GetAbsOrigin())
                    ParticleManager:SetParticleControl(trail, 1,tpos)
                    ParticleManager:ReleaseParticleIndex(trail)   
                    if  not self.caster:HasModifier("modifier_activate_fire_remnant") then 
                        self.caster:SetAbsOrigin(tpos)
                    end
                    self.caster:PerformAttack(heroes[stack], false, true, true, false, false, false, false)
                    local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, heroes[stack])
                    ParticleManager:SetParticleControl(pf, 0,tpos)
                    ParticleManager:ReleaseParticleIndex(pf)       
                        if op[stack]~=nil then 
                            ParticleManager:DestroyParticle(op[stack], false)
                            ParticleManager:ReleaseParticleIndex(op[stack])
                        end
                end
                stack=stack+1
            else 
                self:EndFireOfFist(op,pf1) 
                FindClearSpaceForUnit(self.caster, pos, true)
                return nil 
            end 
                return self.caster:HasModifier("modifier_activate_fire_remnant") and 0 or self.fire_attack_interval
        end
        )
    end 
end

function modifier_imba_brewmaster_fire:EndFireOfFist(op,pf1) 			
    if op~=nil then 
        for a=1,#op do
            ParticleManager:DestroyParticle(op[a], false)
            ParticleManager:ReleaseParticleIndex(op[a])
        end
    end
    if self.caster:HasModifier("modifier_imba_brewmaster_fire_buff") then 
        self.caster:RemoveModifierByName("modifier_imba_brewmaster_fire_buff")
    end 
    if  pf1~=nil then 
        ParticleManager:DestroyParticle(pf1, false)
        ParticleManager:ReleaseParticleIndex(pf1)
    end 
end
------------------------------------------------------------------------------
modifier_imba_brewmaster_fire_buff=class({})

function modifier_imba_brewmaster_fire_buff:IsHidden() 			return true end
function modifier_imba_brewmaster_fire_buff:IsPurgable() 			return false end
function modifier_imba_brewmaster_fire_buff:IsPurgeException() 	return false end
function modifier_imba_brewmaster_fire_buff:CheckState() 
    return 
    {
		[MODIFIER_STATE_INVULNERABLE]                    = true, 
		[MODIFIER_STATE_NO_UNIT_COLLISION]               = true, 
		[MODIFIER_STATE_CANNOT_MISS]                     = true, 
		[MODIFIER_STATE_NO_HEALTH_BAR]                   = true, 
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true
    } 
end

function modifier_imba_brewmaster_fire_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
    } 
end

function modifier_imba_brewmaster_fire_buff:OnCreated()	
    self.ability=self:GetAbility()	
    self.parent=self:GetParent()
end

function modifier_imba_brewmaster_fire_buff:OnDestroy()	
    if IsServer() then    
        self.ability:SetActivated(true)
    end 
end

function modifier_imba_brewmaster_fire_buff:GetModifierIgnoreCastAngle() return 1 end

---------------------------------------------------------------------
----------------     MODIFIER_IMBA_BREWMASTER_VOID     --------------
---------------------------------------------------------------------
-- 2     4    6     8    10
-- void       void       void 
--
modifier_imba_brewmaster_void = class({})

function modifier_imba_brewmaster_void:IsDebuff()			return false end
function modifier_imba_brewmaster_void:IsHidden() 			return false end
function modifier_imba_brewmaster_void:IsPurgable() 		return false end
function modifier_imba_brewmaster_void:IsPurgeException() 	return false end
function modifier_imba_brewmaster_void:GetTexture() return TEXTURE_TYPE[ENUM_VOID][2] end
--分裂成虚无战士
function modifier_imba_brewmaster_void:DeclareFunctions() return {MODIFIER_PROPERTY_MODEL_CHANGE} end
function modifier_imba_brewmaster_void:GetModifierModelChange() return "models/heroes/brewmaster/brewmaster_voidspirit.vmdl" end
function modifier_imba_brewmaster_void:GetStatusEffectName()	return "particles/units/heroes/hero_brewmaster/brewmaster_void_ambient.vpcf" end
function modifier_imba_brewmaster_void:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA end
function modifier_imba_brewmaster_void:OnCreated() 
	if IsServer() then
		self.ability       = self:GetAbility()
		self.caster        = self.ability:GetCaster()
		self.parent        = self:GetParent()
		self.void_interval = self.ability:GetSpecialValueFor("void_interval")
		self.damage        = self.ability:GetSpecialValueFor("damage") 
		self.void_radius   = self.ability:GetSpecialValueFor("void_radius")
		self.dam=
		{
		    attacker = self.parent,
		    ability = self.ability,
		    damage = self.damage,
		    damage_type = DAMAGE_TYPE_MAGICAL,
		    damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		}
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_brewmaster_void_buff", { duration = self.void_interval / 2 })
		self:SpellVoidOfCut()     
        self:StartIntervalThink(self.void_interval)
	end
end

function modifier_imba_brewmaster_void:OnIntervalThink()	
    if not self.parent:IsAlive() then
        return 
    end 
   	if self.parent:HasModifier("modifier_imba_brewmaster_void_buff") then 
   		self.parent:RemoveModifierByName("modifier_imba_brewmaster_void_buff")
   	else
   		self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_brewmaster_void_buff", {})
   	end
end

function modifier_imba_brewmaster_void:OnRefresh()
	self:OnCreated()
end

function modifier_imba_brewmaster_void:OnDestroy()
	--结束音效
	if IsServer() then
		self.parent:EmitSound("Hero_Brewmaster.PrimalSplit.Return") 
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_brewmaster_void_buff", { duration = self.void_interval })
   	else
	end
end

function modifier_imba_brewmaster_void:SpellVoidOfCut()
	--斩切范围
	local pos = self.caster:GetAbsOrigin()
    local cur_pos = pos+self.caster:GetForwardVector()*self.void_radius
	local multiple = 1
	for i = 1 , multiple do 
		Timers:CreateTimer(i * 0.3, function()
			--multiple > 1  为了酷炫可以坐标也稍微随机
			--------------------------------------------------------------------------------------------
			-- Get Resources
			local particle_cast = "particles/heros/void_spirit/void_spirit_dissimilate_dmg.vpcf"
			--斩切音效  ........
			local sound_cast = "Imba.void.cut.caster"
			-- Create Particle for this team
			local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl( effect_cast, 0, cur_pos )
			ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.void_radius, 0, 1 ) )
			ParticleManager:ReleaseParticleIndex(effect_cast)
			-- Play Sound
			EmitSoundOnLocationWithCaster(cur_pos, sound_cast, self.caster )
			--------------------------------------------------------------------------------------------
			--静止
			local vc_cut_stun_duration = self.ability:GetSpecialValueFor("debuff_duration")
			--眩晕音效
			EmitSoundOnLocationWithCaster(cur_pos, "Hero_VoidSpirit.Dissimilate.Stun", self.caster)

			local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), cur_pos, nil, self.void_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				self.dam.victim = enemy
				if not enemy:IsMagicImmune() then
					enemy:AddNewModifier_RS(self.caster, self.ability, "modifier_stunned", {duration = vc_cut_stun_duration })
					ApplyDamage(self.dam)
			    end	
			end
			return nil
		end
		)
	end
end

-------------------------------------------------------------------------------
modifier_imba_brewmaster_void_buff=class({})

function modifier_imba_brewmaster_void_buff:IsHidden() 			return true end
function modifier_imba_brewmaster_void_buff:IsPurgable() 			return false end
function modifier_imba_brewmaster_void_buff:IsPurgeException() 	return false end
function modifier_imba_brewmaster_void_buff:GetStatusEffectName()	return "particles/status_fx/status_effect_void_spirit_pulse_buff.vpcf" end
function modifier_imba_brewmaster_void_buff:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA end
function modifier_imba_brewmaster_void_buff:CheckState() 
    return 
    {
		[MODIFIER_STATE_INVULNERABLE]                     = true, 
		[MODIFIER_STATE_NO_UNIT_COLLISION]                = true, 
		[MODIFIER_STATE_NO_HEALTH_BAR]                    = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE]                    = true
    } 
end


---------------------------------------------------------------------
-------      MODIFIER_IMBA_BREWMASTER_PRIMAL_SPLIT_SWITCH     -------
---------------------------------------------------------------------
--分裂选择
modifier_imba_brewmaster_primal_split_switch = class({})

function modifier_imba_brewmaster_primal_split_switch:IsDebuff()			return false end
function modifier_imba_brewmaster_primal_split_switch:IsHidden() 			return false end
function modifier_imba_brewmaster_primal_split_switch:IsPurgable() 			return false end
function modifier_imba_brewmaster_primal_split_switch:IsPurgeException() 	return false end
function modifier_imba_brewmaster_primal_split_switch:RemoveOnDeath() 		return false end
function modifier_imba_brewmaster_primal_split_switch:DeclareFunctions() return {MODIFIER_PROPERTY_MODEL_CHANGE} end
function modifier_imba_brewmaster_primal_split_switch:GetModifierModelChange() return self.model_name end
function modifier_imba_brewmaster_primal_split_switch:GetStatusEffectName()	return self.model_effect end
function modifier_imba_brewmaster_primal_split_switch:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_brewmaster_primal_split_switch:OnCreated() 
	self.effect_table = {
		{"models/heroes/brewmaster/brewmaster_earthspirit.vmdl","particles/units/heroes/hero_brewmaster/brewmaster_earth_ambient.vpcf"}, --earth
		{"models/heroes/brewmaster/brewmaster_windspirit.vmdl","particles/units/heroes/hero_brewmaster/brewmaster_storm_ambient.vpcf"}, --wind 
		{"models/heroes/brewmaster/brewmaster_firespirit.vmdl","particles/units/heroes/hero_brewmaster/brewmaster_fire_ambient.vpcf"}, --fire 
		{"models/heroes/brewmaster/brewmaster_voidspirit.vmdl","particles/units/heroes/hero_brewmaster/brewmaster_storm_ambient.vpcf"} --void  		
	}
	self.model_name = self.effect_table[math.max(self:GetStackCount(),1)][1]
	self.model_effect = self.effect_table[math.max(self:GetStackCount(),1)][2]
	self:SetStackCount(1)
end

function modifier_imba_brewmaster_primal_split_switch:OnRefresh() 
	self.model_name = self.effect_table[math.max(self:GetStackCount(),1)][1]
	self.model_effect = self.effect_table[math.max(self:GetStackCount(),1)][2]
end

---------------------------------------------------------------------
----------------     BREWMASTER PRIMAL SPLIT SWITCH   ---------------
---------------------------------------------------------------------
imba_brewmaster_primal_split_switch = class({})

function imba_brewmaster_primal_split_switch:IsHiddenWhenStolen() 	return false end
function imba_brewmaster_primal_split_switch:IsRefreshable() 		return false end
function imba_brewmaster_primal_split_switch:IsStealable() 			return false end
function imba_brewmaster_primal_split_switch:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	--SwitchAbility
	if caster:HasModifier("modifier_imba_brewmaster_primal_split_switch") then
		local split_type = self:GetCaster():GetModifierStackCount("modifier_imba_brewmaster_primal_split_switch", nil) 	
		split_type = split_type + 1
		if split_type > ( caster:HasScepter() and ENUM_VOID or ENUM_FIRE) then 
			split_type = ENUM_EARTH
		end
		caster:SetModifierStackCount("modifier_imba_brewmaster_primal_split_switch", nil, split_type)
		caster:FindModifierByName("modifier_imba_brewmaster_primal_split_switch"):OnRefresh()
	else
		caster:AddNewModifierWhenPossible(caster, self, "modifier_imba_brewmaster_primal_split_switch", {})
		caster:SetModifierStackCount("modifier_imba_brewmaster_primal_split_switch", nil, 1)
	end
end

---------------------------------------------------------------------
----------------     BREWMASTER PRIMAL RESONANT   -------------------
---------------------------------------------------------------------
imba_brewmaster_primal_resonant = class({})

LinkLuaModifier("modifier_imba_brewmaster_earth_spell_immunity","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_fire_dash_fist","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_fire_dash_fist_buff","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brewmaster_void_astral_pulse","mb/hero_brewmaster.lua", LUA_MODIFIER_MOTION_NONE)

function imba_brewmaster_primal_resonant:IsHiddenWhenStolen() 		return false end
function imba_brewmaster_primal_resonant:IsRefreshable() 			return true end
function imba_brewmaster_primal_resonant:IsStealable() 			return false end
function imba_brewmaster_primal_resonant:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_brewmaster_primal_split_switch") then  
		local split_type = self:GetCaster():GetModifierStackCount("modifier_imba_brewmaster_primal_split_switch", nil)
		--返回对应技能图标
		for k,v in pairs(SHARD_TEXTURE_TYPE) do
		    if v[1] == split_type then
		        return SHARD_TEXTURE_TYPE[k][2]
		    end
		end
	end
	return "brewmaster_earth_spell_immunity"
end
--魔晶
--brewmaster_void_astral_pulse --2021 8 22 by MysticBug-------
function imba_brewmaster_primal_resonant:OnInventoryContentsChanged()
	--魔晶技能
	---------------------------------------------------------------
	local caster=self:GetCaster()
	if self:GetCaster():Has_Aghanims_Shard() then 
        TG_Set_Scepter(caster,false,math.max(math.floor(math.min(caster:GetLevel(),18)/6),1),"imba_brewmaster_primal_resonant")
    else
        TG_Set_Scepter(caster,true,math.max(math.floor(math.min(caster:GetLevel(),18)/6),1),"imba_brewmaster_primal_resonant")
    end
	---------------------------------------------------------------
end

function imba_brewmaster_primal_resonant:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	--Sound
	caster:EmitSound("Brewmaster_Void.Pulse")
	return true
end

function imba_brewmaster_primal_resonant:OnUpgrade()
	if not self:GetCaster():HasModifier("modifier_imba_brewmaster_primal_split_switch") then
		self:GetCaster():AddNewModifierWhenPossible(self:GetCaster(), self, "modifier_imba_brewmaster_primal_split_switch", {})
	end
	local caster = self:GetCaster()
	local primal_split_switch = caster:FindAbilityByName("imba_brewmaster_primal_split_switch")
	if primal_split_switch then 
		primal_split_switch:SetLevel(self:GetLevel())
	end
end

function imba_brewmaster_primal_resonant:OnSpellStart()
	local caster             = self:GetCaster()
	local duration           = self:GetSpecialValueFor("duration")
	local wind_walk_duration = self:GetSpecialValueFor("wind_walk_duration")
	--check type 
	if caster:HasModifier("modifier_imba_brewmaster_primal_split_switch") then  
		local shard_type = math.max(caster:GetModifierStackCount("modifier_imba_brewmaster_primal_split_switch", nil),1)
		--添加对应技能mod
		for k,v in pairs(SHARD_TYPE) do
		    if v[1] == shard_type then
		    	caster:AddNewModifier(
		    			caster, -- player source
		    			self, -- ability source
		    			SHARD_TYPE[k][2], -- modifier name
		    			{ duration = (shard_type == ENUM_STORM and wind_walk_duration or duration) } -- kv
		    		)
		    end
		end
	end
end

---------------------------------------------------------------------
-------      MODIFIER_IMBA_BREWMASTER_EARTH_SPELL_IMMUNITY    -------
---------------------------------------------------------------------

modifier_imba_brewmaster_earth_spell_immunity = class({})

function modifier_imba_brewmaster_earth_spell_immunity:IsHidden() 		return false end
function modifier_imba_brewmaster_earth_spell_immunity:IsPurgable() 	return false end
function modifier_imba_brewmaster_earth_spell_immunity:IsPurgeException() return false end
function modifier_imba_brewmaster_earth_spell_immunity:OnCreated()  
	if IsServer() then  self:GetCaster():EmitSound("Brewmaster_Earth.Attack") end
end
function modifier_imba_brewmaster_earth_spell_immunity:GetTexture() return SHARD_TEXTURE_TYPE[ENUM_EARTH][2] end
function modifier_imba_brewmaster_earth_spell_immunity:GetEffectName() return "particles/units/heroes/hero_brewmaster/brewmaster_earth_ambient.vpcf" end
function modifier_imba_brewmaster_earth_spell_immunity:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_brewmaster_earth_spell_immunity:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true,} end


---------------------------------------------------------------
-------      MODIFIER_IMBA_BREWMASTER_FIRE_DASH_FIST    -------
---------------------------------------------------------------

modifier_imba_brewmaster_fire_dash_fist = class({})

function modifier_imba_brewmaster_fire_dash_fist:IsDebuff()			return false end
function modifier_imba_brewmaster_fire_dash_fist:IsHidden() 		return true end
function modifier_imba_brewmaster_fire_dash_fist:IsPurgable() 		return false end
function modifier_imba_brewmaster_fire_dash_fist:IsPurgeException() 	return false end
function modifier_imba_brewmaster_fire_dash_fist:GetTexture() return SHARD_TEXTURE_TYPE[ENUM_FIRE][2] end
function modifier_imba_brewmaster_fire_dash_fist:OnCreated() 
	if IsServer() then
		self.ability              = self:GetAbility()
		self.caster               = self.ability:GetCaster()
		self.parent               = self:GetParent()
		self.fire_attack_interval = self.ability:GetSpecialValueFor("fire_attack_interval")
		self.fire_radius          = self.ability:GetSpecialValueFor("radius")
		self:SpellFireOfFist()
	end
end
function modifier_imba_brewmaster_fire_dash_fist:OnRefresh()
	self:OnCreated()
end

function modifier_imba_brewmaster_fire_dash_fist:SpellFireOfFist()
	if not IsServer() then return end
	--kv 
	local pos     = self.caster:GetAbsOrigin()
	local team    = self.caster:GetTeamNumber()
	local cur_pos = pos + self.caster:GetForwardVector() * self.fire_radius
	local fpos    = pos + TG_Direction(cur_pos,pos) * self.fire_radius
	local stack   = 1
	local heroes  = {}
    local op = {}
    --Brewmaster_Fire.Attack
    EmitSoundOn("Hero_EmberSpirit.SleightOfFist.Cast", self.caster)  
    local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pf, 0,cur_pos)
    ParticleManager:SetParticleControl(pf, 1,fpos)
    ParticleManager:ReleaseParticleIndex(pf)   
    --line 
    heroes = FindUnitsInLine(team,pos,fpos,self.caster,250,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NO_INVIS+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

    if #heroes>0 then 
    	self.ability:SetActivated(false) 
        local pf1 = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pf1, 0, pos)
        ParticleManager:SetParticleControlForward(pf1, 1, self.caster:GetForwardVector())
        ParticleManager:SetParticleControl(pf1, 62, Vector(10, 0, 0))
        for a=1,#heroes do
            op[a] = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf", PATTACH_OVERHEAD_FOLLOW, heroes[a])
            ParticleManager:SetParticleControl( op[a], 0, heroes[a]:GetAbsOrigin())
        end
        self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_brewmaster_fire_dash_fist_buff", {})
        Timers:CreateTimer(0, function()
            if  heroes~=nil and stack<=#heroes then 
                if heroes[stack]~=nil and heroes[stack]:IsAlive() then 
					local tpos  = heroes[stack]:GetAbsOrigin()
					local trail = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
                    ParticleManager:SetParticleControl(trail, 0,self.caster:GetAbsOrigin())
                    ParticleManager:SetParticleControl(trail, 1,tpos)
                    ParticleManager:ReleaseParticleIndex(trail)   
                    if  not self.caster:HasModifier("modifier_activate_fire_remnant") then 
                        self.caster:SetAbsOrigin(tpos)
                    end
                    self.caster:PerformAttack(heroes[stack], false, true, true, false, false, false, false)
                    local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, heroes[stack])
                    ParticleManager:SetParticleControl(pf, 0,tpos)
                    ParticleManager:ReleaseParticleIndex(pf)       
                        if op[stack]~=nil then 
                            ParticleManager:DestroyParticle(op[stack], false)
                            ParticleManager:ReleaseParticleIndex(op[stack])
                        end
                end
                stack=stack+1
            else 
                self:EndFireOfFist(op,pf1) 
                FindClearSpaceForUnit(self.caster, pos, true)
                return nil 
            end 
                return self.caster:HasModifier("modifier_activate_fire_remnant") and 0 or self.fire_attack_interval
        end
        )
    end 
end

function modifier_imba_brewmaster_fire_dash_fist:EndFireOfFist(op,pf1) 			
    if op~=nil then 
        for a=1,#op do
            ParticleManager:DestroyParticle(op[a], false)
            ParticleManager:ReleaseParticleIndex(op[a])
        end
    end
    if self.caster:HasModifier("modifier_imba_brewmaster_fire_dash_fist_buff") then 
        self.caster:RemoveModifierByName("modifier_imba_brewmaster_fire_dash_fist_buff")
    end 
    if  pf1~=nil then 
        ParticleManager:DestroyParticle(pf1, false)
        ParticleManager:ReleaseParticleIndex(pf1)
    end 
end

------------------------------------------------------------------
modifier_imba_brewmaster_fire_dash_fist_buff=class({})

function modifier_imba_brewmaster_fire_dash_fist_buff:IsHidden() 			return true end
function modifier_imba_brewmaster_fire_dash_fist_buff:IsPurgable() 			return false end
function modifier_imba_brewmaster_fire_dash_fist_buff:IsPurgeException() 	return false end
function modifier_imba_brewmaster_fire_dash_fist_buff:CheckState() 
    return 
    {
		[MODIFIER_STATE_INVULNERABLE]                    = true, 
		[MODIFIER_STATE_NO_UNIT_COLLISION]               = true, 
		[MODIFIER_STATE_CANNOT_MISS]                     = true, 
		[MODIFIER_STATE_NO_HEALTH_BAR]                   = true, 
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true
    } 
end

function modifier_imba_brewmaster_fire_dash_fist_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
    } 
end

function modifier_imba_brewmaster_fire_dash_fist_buff:OnCreated()	
    self.ability=self:GetAbility()	
    self.parent=self:GetParent()
end

function modifier_imba_brewmaster_fire_dash_fist_buff:OnDestroy()	
    if IsServer() then    
        self.ability:SetActivated(true)
    end 
end

function modifier_imba_brewmaster_fire_dash_fist_buff:GetModifierIgnoreCastAngle() return 1 end

------------------------------------------------------------------
-------      modifier_imba_brewmaster_void_astral_pulse    -------
------------------------------------------------------------------

modifier_imba_brewmaster_void_astral_pulse = class({})

function modifier_imba_brewmaster_void_astral_pulse:IsDebuff()			return false end
function modifier_imba_brewmaster_void_astral_pulse:IsHidden() 			return false end
function modifier_imba_brewmaster_void_astral_pulse:IsPurgable() 		return false end
function modifier_imba_brewmaster_void_astral_pulse:IsPurgeException() 	return false end
function modifier_imba_brewmaster_void_astral_pulse:GetTexture() return SHARD_TEXTURE_TYPE[ENUM_VOID][2] end
function modifier_imba_brewmaster_void_astral_pulse:OnCreated() 
	if IsServer() then
		self.ability              = self:GetAbility()
		self.caster               = self.ability:GetCaster()
		self.parent               = self:GetParent()
		self.void_slow 			  = self.ability:GetSpecialValueFor("slow")
		self.void_radius          = self.ability:GetSpecialValueFor("radius")
		self.void_duration        = self.ability:GetSpecialValueFor("duration")
		--PFX
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse.vpcf", PATTACH_POINT_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(particle, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, Vector(self.void_radius*3, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle) 
		--AOE 
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.void_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
				enemy:AddNewModifier_RS(self.caster, self.ability, "modifier_brewmaster_void_astral_pulse", {duration = self.void_duration })
				self.caster:PerformAttack(enemy, false, false, true, false, false, false, false)
		    end	
		end
	end
end
function modifier_imba_brewmaster_void_astral_pulse:OnRefresh()
	self:OnCreated()
end