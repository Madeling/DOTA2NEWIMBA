
CreateTalents("npc_dota_hero_huskar", "ting/hero_huskar")
------------------火矛-----------
--火矛现在是被动技能 会被破坏 但是不会被沉默
imba_huskar_burning_spear = class({})

LinkLuaModifier("modifier_imba_huskar_burning_spear_debuff", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_burning_spear_counter", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_burning_spear_passive", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_armlet", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_black", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_black_flag", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
function imba_huskar_burning_spear:GetBehavior()
	if self:GetCaster():TG_HasTalent("special_bonus_imba_huskar_4") and (self:GetCaster():HasItemInInventory("item_imba_armlet") or self:GetCaster():HasItemInInventory("item_imba_armlet_v2")) then 
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_IMMEDIATE+DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE  
	end
	
	if (self:GetCaster():HasItemInInventory("item_imba_armlet") or self:GetCaster():HasItemInInventory("item_imba_armlet_v2")) and not self:GetCaster():TG_HasTalent("special_bonus_imba_huskar_4") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_IMMEDIATE  
	end

	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function imba_huskar_burning_spear:GetIntrinsicModifierName() return "modifier_imba_huskar_burning_spear_passive" end

function imba_huskar_burning_spear:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_imba_huskar_armlet") then

	return "imba_huskar_burning_spear"  end
	return "huskar_burning_spear_a"  
	end
function imba_huskar_burning_spear:OnUpgrade()
	if IsServer() then
		local mod = self:GetCaster():FindModifierByName("modifier_imba_huskar_burning_spear_passive")
		if mod then
			mod.damage = self:GetSpecialValueFor("damage")
			mod.duration = self:GetSpecialValueFor("duration")
			mod.health_cost = self:GetSpecialValueFor("health_cost")
		end
	end
end
function imba_huskar_burning_spear:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Huskar.Life_Break")		
	caster:StartGesture(ACT_DOTA_TELEPORT_END)
	caster:Purge(false, true, false, true, true)
	
	if caster:HasModifier("modifier_imba_huskar_armlet") then 
		caster:RemoveModifierByName("modifier_imba_huskar_armlet")	
		caster:RemoveModifierByName("modifier_imba_huskar_burning_spear_hp")
	else 
		local mod = caster:AddNewModifier(caster,self,"modifier_imba_huskar_burning_spear_hp",{duration = 5}) 
		if mod~= nil then
			mod:SetStackCount(mod:GetStackCount()+ caster:GetHealth()*0.2)
		end
		caster:CalculateStatBonus(true)
		caster:SetHealth(caster:GetHealth()*0.8)
		caster:AddNewModifier(caster,self,"modifier_imba_huskar_armlet",{duration = -1})
	end
	
end

modifier_imba_huskar_armlet = class({})
LinkLuaModifier("modifier_imba_huskar_burning_spear_debuff", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_burning_spear_counter", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_huskar_armlet:IsDebuff()			return false end
function modifier_imba_huskar_armlet:IsHidden() 			return true end
function modifier_imba_huskar_armlet:IsPurgable() 			return false end
function modifier_imba_huskar_armlet:IsPurgeException() 	return false end
function modifier_imba_huskar_armlet:GetPriority() 		return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_imba_huskar_armlet:RemoveOnDeath() 		return false end
function modifier_imba_huskar_armlet:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS}
end
function modifier_imba_huskar_armlet:GetModifierAttackRangeBonus() return self.attrange end
function modifier_imba_huskar_armlet:OnCreated()
	self.attrange = 0
	if IsServer() then
		self.attack_cap = self:GetParent():GetAttackCapability()
		self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	end
	if self.attack_cap ~= DOTA_UNIT_CAP_MELEE_ATTACK then
		self.attrange = 200 - self:GetParent():Script_GetAttackRange()
	end
end

function modifier_imba_huskar_armlet:OnDestroy()
	if IsServer() then
		self:GetParent():SetAttackCapability(self.attack_cap)
	end
end


modifier_imba_huskar_burning_spear_passive = class({})
LinkLuaModifier("modifier_imba_huskar_burning_spear_debuff", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_burning_spear_counter", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_burning_spear_hp", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_huskar_burning_spear_passive:IsDebuff()			return false end
function modifier_imba_huskar_burning_spear_passive:IsHidden() 			return true end
function modifier_imba_huskar_burning_spear_passive:IsPurgable() 			return false end
function modifier_imba_huskar_burning_spear_passive:IsPurgeException() 	return false end
function modifier_imba_huskar_burning_spear_passive:GetPriority() 		return MODIFIER_PRIORITY_LOW end
function modifier_imba_huskar_burning_spear_passive:GetPriority() 		return MODIFIER_PRIORITY_LOW end
function modifier_imba_huskar_burning_spear_passive:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ATTACK, MODIFIER_PROPERTY_PROJECTILE_NAME,MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,MODIFIER_EVENT_ON_RESPAWN}
end


function modifier_imba_huskar_burning_spear_passive:GetModifierProjectileName()
return "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf" end
function modifier_imba_huskar_burning_spear_passive:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.health_cost = self.ability:GetSpecialValueFor("health_cost")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.damageTable = {
			attacker 		= self.parent,
			ability 		= self.ability
		}
		
end

function modifier_imba_huskar_burning_spear_passive:OnAttack(keys)
	if not IsServer() or self.parent:PassivesDisabled() or keys.attacker ~= self.parent then
		return
	end
	if  not keys.attacker:IsAlive() then
		return
	end
	if not keys.target:IsAlive() or  keys.target:GetTeamNumber() == keys.attacker:GetTeamNumber() then return end
		keys.attacker:EmitSound("Hero_Huskar.Burning_Spear.Cast")
		
		self.damageTable.damage = keys.attacker:GetHealth()*self.health_cost*0.01
		self.damageTable.damage_type =  DAMAGE_TYPE_PHYSICAL
		self.damageTable.victim = self.caster
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL

		ApplyDamage(self.damageTable)
		
		if self.parent:HasModifier("modifier_imba_huskar_armlet") then
		local mod = self.parent:AddNewModifier(self.parent,self:GetAbility(),"modifier_imba_huskar_burning_spear_hp",{duration = self.duration}) 
		if mod~= nil then
			mod:SetStackCount(math.min(mod:GetStackCount()+ keys.attacker:GetMaxHealth()*self.health_cost*0.01,12000))
		end
		self.parent:CalculateStatBonus(true)
		end
end

function modifier_imba_huskar_burning_spear_passive:OnAttackLanded(keys)
	if not IsServer() or self.parent:PassivesDisabled()then
		return
	end
	if keys.attacker:HasModifier("modifier_imba_huskar_armlet") then	
		return
	end
	if keys.target:IsBuilding() or keys.target:GetTeamNumber() == keys.attacker:GetTeamNumber() then return end
	if keys.attacker ~= self.parent or not keys.attacker:IsAlive() then
		return
	end

	keys.target:EmitSound("Hero_Huskar.Burning_Spear")
		self.damageTable.damage = keys.attacker:GetStrength()*(self.damage+keys.attacker:TG_GetTalentValue("special_bonus_imba_huskar_1"))*0.01
		self.damageTable.damage_type = keys.attacker:TG_HasTalent("special_bonus_imba_huskar_5") and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL
		self.damageTable.victim = keys.target
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NONE
		
		ApplyDamage(self.damageTable)
	
end


modifier_imba_huskar_burning_spear_hp = class({})
function modifier_imba_huskar_burning_spear_hp:IsDebuff()			return false end
function modifier_imba_huskar_burning_spear_hp:IsHidden()     return false end
function modifier_imba_huskar_burning_spear_hp:IsPurgable() 		return false end
function modifier_imba_huskar_burning_spear_hp:IsPurgeException() 		return false end
function modifier_imba_huskar_burning_spear_hp:DeclareFunctions()
	return {MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS}
end
function modifier_imba_huskar_burning_spear_hp:GetModifierExtraHealthBonus()
	return self:GetStackCount()
end
-----



-----------------心炎-----------------------------
--变为点地跳跃技能，过程中无敌，落地释放心炎，根据距离减少自己生命值并且造成额外伤害

imba_huskar_inner_fire = class({})
LinkLuaModifier("modifier_imba_huskar_black", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_inner_fire_disarm", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_huskar_inner_fire_yidong", "ting/hero_huskar", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_huskar_inner_fire_move_slow", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
function imba_huskar_inner_fire:IsStealable() return false end
function imba_huskar_inner_fire:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT --a杖改变技能释放效果 自己周围变为点地
end

function imba_huskar_inner_fire:CastFilterResultLocation(vLocation)  --缠绕不能释放
	if self:GetCaster():HasScepter() and self:GetCaster():IsRooted() then
		return UF_FAIL_CUSTOM
	end
end

function imba_huskar_inner_fire:GetCustomCastErrorLocation(vLocation)
	return "dota_hud_error_ability_disabled_by_root"
end

function imba_huskar_inner_fire:CastFilterResultTarget(target)
	if target ~= self:GetCaster() then
		return UF_FAIL_OBSTRUCTED
	end
end
function imba_huskar_inner_fire:GetCastRange(target)
	return self:GetSpecialValueFor("range")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_huskar_3")
end


function imba_huskar_inner_fire:OnSpellStart()
	if not IsServer() then return end
	self.caster = self:GetCaster()
	if self.caster ~= self:GetCursorTarget() then  
	local pos = self:GetCursorPosition()
	local direction = (pos - self.caster:GetAbsOrigin()):Normalized()
		direction.z = 0
	local max_distance = self:GetSpecialValueFor("range") + self.caster:TG_GetTalentValue("special_bonus_imba_huskar_3") + self.caster:GetCastRangeBonus()
	local distance = math.min(max_distance, (self.caster:GetAbsOrigin() - pos):Length2D())
	local tralve_duration = distance / self:GetSpecialValueFor("speed")
	self.caster:AddNewModifier(self.caster, self, "imba_huskar_inner_fire_yidong", {duration = tralve_duration, direction = direction})
	end
	if self:GetCursorTarget() == self.caster then
	self:InnerFire(0,false,true)
	return
	end
end
--心炎效果
function imba_huskar_inner_fire:InnerFire(damage_distance,ismagicimmune,isdisarm)
	local damage				= self:GetSpecialValueFor("damage")
	local radius				= self:GetSpecialValueFor("radius")
	local disarm_duration		= self:GetSpecialValueFor("disarm_duration")
	local knockback_dur	= self:GetSpecialValueFor("knockback_duration")
	local slow_flag = self.caster:TG_HasTalent("special_bonus_imba_huskar_2") and true or false
	local search_flag =  DOTA_UNIT_TARGET_FLAG_NONE
	local damageTable = {
			damage 			= damage,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self.caster,
			ability 		= self
		}
	local Knockback ={
          should_stun = 0.01, --打断
          knockback_duration = knockback_dur, --击退时间 减去不能动的时间就是太空步的时间
          duration = knockback_dur, --不能动的时间
          knockback_height = 0,	--击退高度
          center_x =  self.caster:GetAbsOrigin().x,	--施法者为中心
          center_y =  self.caster:GetAbsOrigin().y,
          center_z =  self.caster:GetAbsOrigin().z,
      }	
	self.caster:EmitSound("Hero_Huskar.Inner_Fire.Cast")	
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf", PATTACH_POINT, self.caster)
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))
	ParticleManager:SetParticleControl(particle, 3, self.caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	

	if ismagicimmune then 
		search_flag = DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
	
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, search_flag, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
	
		damageTable.victim = enemy
		knockback_distance = math.max(self:GetSpecialValueFor("knockback_distance") - (self.caster:GetAbsOrigin() - enemy:GetAbsOrigin()):Length2D(), 50), --击退距离
		enemy:AddNewModifier(self.caster, self, "modifier_knockback", Knockback)  --白牛的击退		
		
		
		if slow_flag then
		enemy:AddNewModifier(self.caster, self, "modifier_imba_huskar_inner_fire_move_slow", {duration = 4})  --减速
		end
		--缴械
		if isdisarm then
		enemy:AddNewModifier_RS(self.caster, self, "modifier_imba_huskar_inner_fire_disarm", {duration = disarm_duration}) --缴械
		end
		ApplyDamage(damageTable)
	end
		--免疫破坏
		self.caster:AddNewModifier(self.caster, self, "modifier_imba_huskar_black", {duration = self:GetSpecialValueFor("duration")}) 
	
	
end
--心炎的免疫破坏
modifier_imba_huskar_black = class({})
function modifier_imba_huskar_black:IsDebuff()			return false end
function modifier_imba_huskar_black:IsHidden() 			return false end
function modifier_imba_huskar_black:IsPurgable() 		return false end
function modifier_imba_huskar_black:IsPurgeException() 	return false end
function modifier_imba_huskar_black:GetStatusEffectName()	return "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_cast_flame.vpcf" end
function modifier_imba_huskar_black:CheckState()
	return	{[MODIFIER_STATE_PASSIVES_DISABLED] = false}
end
function modifier_imba_huskar_black:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA 
end

--心炎缴械
modifier_imba_huskar_inner_fire_disarm = class({})
function modifier_imba_huskar_inner_fire_disarm:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf"
end

function modifier_imba_huskar_inner_fire_disarm:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_imba_huskar_inner_fire_disarm:IsPurgable() return true end
function modifier_imba_huskar_inner_fire_disarm:IsPurgeException() return true end
function modifier_imba_huskar_inner_fire_disarm:CheckState()
	return {[MODIFIER_STATE_DISARMED] = true}
end

modifier_imba_huskar_inner_fire_move_slow = class({})
function modifier_imba_huskar_inner_fire_move_slow:IsHidden() return true end
function modifier_imba_huskar_inner_fire_move_slow:IsPurgable() return true end
function modifier_imba_huskar_inner_fire_move_slow:IsPurgeException() return true end
function modifier_imba_huskar_inner_fire_move_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_huskar_inner_fire_move_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.move
end
function modifier_imba_huskar_inner_fire_move_slow:OnCreated()
	self.move = -1*self:GetCaster():TG_GetTalentValue("special_bonus_imba_huskar_2")
end
function modifier_imba_huskar_inner_fire_move_slow:OnDestroy()
	self.move = nil
end


--心炎跳跃
imba_huskar_inner_fire_yidong = class({})
function imba_huskar_inner_fire_yidong:IsHidden()		return false end
function imba_huskar_inner_fire_yidong:IsPurgable()	return false end
function imba_huskar_inner_fire_yidong:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function imba_huskar_inner_fire_yidong:GetOverrideAnimation() return  ACT_DOTA_CAST_LIFE_BREAK_START end
function imba_huskar_inner_fire_yidong:GetStatusEffectName()	return "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_cast_flame.vpcf" end
function imba_huskar_inner_fire_yidong:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end
function imba_huskar_inner_fire_yidong:GetPriority() return {MODIFIER_PROPERTY_ULTRA} end
function imba_huskar_inner_fire_yidong:IsMotionController() return true end
function imba_huskar_inner_fire_yidong:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function imba_huskar_inner_fire_yidong:OnCreated(keys)
	if IsServer() then
		self.direction = StringToVector(keys.direction)
		self.speed = self:GetAbility():GetSpecialValueFor("speed")
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.pos = self.caster:GetAbsOrigin()
		self.new_pos = nil
		self:GetCaster():EmitSound("Hero_Huskar.Life_Break")
		self:StartIntervalThink(FrameTime())

	end
end

function imba_huskar_inner_fire_yidong:OnIntervalThink()
	self.new_pos = self.parent:GetAbsOrigin() + self.direction * (self.speed / (1.0 / FrameTime()))
	self.new_pos = GetGroundPosition(self.new_pos, nil)
	self.parent:SetOrigin(self.new_pos)
end

function imba_huskar_inner_fire_yidong:OnDestroy()
	if IsServer() then
	FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
	self:GetAbility():InnerFire(0,false,true)
	self.direction = nil
	self.speed = nil
	self.caster = nil
	self.pos = nil
	end
end
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


-------------------狂战士之血 ---------------------
--攻速 抗性 魔抗 回血
imba_huskar_berserkers_blood = class({})

LinkLuaModifier("modifier_imba_berserkers_blood_passive", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_berserkers_blood_passive_soulmax_flag", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)

function imba_huskar_berserkers_blood:GetIntrinsicModifierName() return "modifier_imba_berserkers_blood_passive" end
function imba_huskar_berserkers_blood:OnUpgrade()
	if not IsServer() then return end
	local mod = self:GetCaster():FindModifierByName("modifier_imba_berserkers_blood_passive")
	if mod then
		mod.reduce = self:GetSpecialValueFor("reduce")
		mod.soul = self:GetSpecialValueFor("soul") 
		mod.soulmax = self:GetSpecialValueFor("hp_threshold_max")			
		mod.range = self:GetSpecialValueFor("range_re")
		
	end
end

modifier_imba_berserkers_blood_passive = class({})
LinkLuaModifier("modifier_imba_berserkers_blood_passive_soulmax_flag", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_berserkers_blood_passive:IsDebuff()			return false end
function modifier_imba_berserkers_blood_passive:IsHidden() 			return false end
function modifier_imba_berserkers_blood_passive:IsPurgable() 		return false end
function modifier_imba_berserkers_blood_passive:IsPurgeException() 	return false end
function modifier_imba_berserkers_blood_passive:RemoveOnDeath()		return false end
function modifier_imba_berserkers_blood_passive:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,MODIFIER_PROPERTY_MODEL_SCALE,MODIFIER_EVENT_ON_DEATH,MODIFIER_EVENT_ON_RESPAWN,} end
function modifier_imba_berserkers_blood_passive:GetModifierAttackSpeedBonus_Constant() 
	return (self.parent:PassivesDisabled() and 0 or (self.ab:GetSpecialValueFor("maximum_attack_speed") * (self:GetStackCount() / 100))) 
end
function modifier_imba_berserkers_blood_passive:GetActivityTranslationModifiers() 
	return (self.parent:PassivesDisabled() and nil or (self:GetStackCount() > 50 and "berserkers_blood" or nil)) 
end
function modifier_imba_berserkers_blood_passive:GetModifierConstantHealthRegen() 
	return (self.parent:PassivesDisabled()) and 0 or (self.parent:GetStrength() * (self:GetStackCount()/ 100)*self.ab:GetSpecialValueFor("maximum_health_regen")*0.01)
end
function modifier_imba_berserkers_blood_passive:GetModifierMoveSpeedBonus_Constant() 
	return (self.parent:PassivesDisabled())  and 0 or ((self.ab:GetSpecialValueFor("move_speed")+self.parent:TG_GetTalentValue("special_bonus_imba_huskar_6"))* (self:GetStackCount() / 100))
end
function modifier_imba_berserkers_blood_passive:GetModifierMagicalResistanceBonus()
return (self.parent:PassivesDisabled() or  self.parent:HasModifier("modifier_imba_huskar_armlet")) and 0 or (self.parent:TG_GetTalentValue("special_bonus_imba_huskar_4")* (self:GetStackCount() / 100))
end
function modifier_imba_berserkers_blood_passive:OnCreated()	
			self.caster = self:GetCaster()
			self.parent = self:GetParent()
			self.ab = self:GetAbility()
			self.soul = self.ab:GetSpecialValueFor("soul") --死一个人多少数值
			self.soul_f = 0	--友军读秒计数
			self.soul_e = 0	-- 敌人
			self.soul_fe = self.soul_e + self.soul_f	--全部
			self.soulmax = self.ab:GetSpecialValueFor("hp_threshold_max")			
			self.range = self.ab:GetSpecialValueFor("range_re")
			self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_berserkers_blood_regen.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
			ParticleManager:SetParticleControlEnt(self.pfx, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
			self.cur =self.caster:Has_Aghanims_Shard() and self.soul_fe or 0
						
			self.reduce = self.ab:GetSpecialValueFor("reduce")
			if IsServer()then	
				self.current = (self.parent:GetHealth()-self.parent:GetMaxHealth()*self.cur*0.01) - ( self.soulmax/ 100) * self.parent:GetMaxHealth()
				self.max = self.parent:GetMaxHealth() - (self.soulmax/ 100) * self.parent:GetMaxHealth()
				self.pct = math.floor(((1 - max(self.current / self.max, 0)) * 100) + 0.5)
				self:StartIntervalThink(0.3)
			--self.parent:AddNewModifier(self.parent,self.ab,"modifier_imba_berserkers_blood_passive_soulmax_flag",{duration = -1})


	end
end

function modifier_imba_berserkers_blood_passive:OnIntervalThink()
	self.soul_fe = self.soul_e + self.soul_f	--全部
	self.soulmax = self.ab:GetSpecialValueFor("hp_threshold_max")
	self.cur =self.caster:Has_Aghanims_Shard() and self.soul_fe or self.soul_f
	self.current =(self.parent:GetHealth()-self.parent:GetMaxHealth()*self.cur*0.01) - ( self.soulmax/ 100) * self.parent:GetMaxHealth()
	self.max = self.parent:GetMaxHealth() - (self.soulmax/ 100) * self.parent:GetMaxHealth()
	self.pct = math.floor(((1 - max(self.current / self.max, 0)) * 100) + 0.5)
	ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.pct, 0, 0))
	self:SetStackCount(self.pct)
end


function modifier_imba_berserkers_blood_passive:GetModifierIncomingDamage_Percentage(keys)
	local range = self.parent:Script_GetAttackRange()
	if not IsServer() or keys.target ~= self.parent or self.parent:PassivesDisabled()  or self.parent:IsIllusion() then
		return
	end
	if self.parent:HasModifier("modifier_imba_huskar_black") then	
		range = 250
	end
	
	if self.parent:GetName()~="npc_dota_hero_huskar"  then
		range = 600
	end
	local range_att = (keys.attacker:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D()
	if range_att > range then
		return -1*self.reduce
	end
end
----------超越灵魂 每有一个队友死的时候，被动临界值减少3% ，队友复活的时候还原
function modifier_imba_berserkers_blood_passive:OnDeath(keys)
	if IsServer() and keys.unit~=self.parent and keys.unit:IsRealHero() then
		if keys.unit:GetTeamNumber() == self.parent:GetTeamNumber() then
			self.soul_f = self.soul_f + self.soul
		else
			self.soul_e = self.soul_e + self.soul
		end
	end
end

function modifier_imba_berserkers_blood_passive:OnRespawn(keys)
	if IsServer() then
	--[[	if keys.unit == self.parent then
			if not self.parent:HasModifier("modifier_imba_berserkers_blood_passive_soulmax_flag") then
				self.parent:AddNewModifier(self.parent,self.ab,"modifier_imba_berserkers_blood_passive_soulmax_flag",{duration = -1})
			end
		end]]
		if  keys.unit~=self.parent and keys.unit:IsRealHero() then
			if keys.unit:GetTeamNumber() == self.parent:GetTeamNumber() then
				self.soul_f = self.soul_f - self.soul
			else
				self.soul_e = self.soul_e - self.soul
			end
		end
	end
end

function modifier_imba_berserkers_blood_passive:OnDestroy()
	self.soulmax = nil
	self.current = nil
	self.max = nil
	self.pct = nil
	self.soul_f = nil
	self.soul_e = nil
	self.soul_fe = nil
	self.range_re = nil
	if IsServer() then
		if not self.parent:IsBoss() then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
			self.pfx = nil
		end
	end
end

--血量低的时候变红变大
function modifier_imba_berserkers_blood_passive:GetModifierModelScale()
	if not IsServer() then return end
	if self.parent:HasModifier("modifier_imba_huskar_armlet") then
		self.parent:SetRenderColor(255-255 * self.pct*0.01, 255-255 * self.pct*0.01, 255-255 * self.pct*0.01)
	else
		self.parent:SetRenderColor(255, 255-255 * self.pct*0.01, 255-255 * self.pct*0.01)	
	end
	return self.parent:PassivesDisabled() and 1.0 or (1.0 + self:GetStackCount()*1.5)
end
-----天赋的移动速度修饰器--------
modifier_imba_berserkers_blood_passive_soulmax_flag = class({})
function modifier_imba_berserkers_blood_passive_soulmax_flag:IsDebuff()			return false end
function modifier_imba_berserkers_blood_passive_soulmax_flag:IsHidden() 			return false end
function modifier_imba_berserkers_blood_passive_soulmax_flag:IsPurgable() 		return false end
function modifier_imba_berserkers_blood_passive_soulmax_flag:IsPurgeException() 	return false end
function modifier_imba_berserkers_blood_passive_soulmax_flag:RemoveOnDeath() 	return true end
function modifier_imba_berserkers_blood_passive_soulmax_flag:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_imba_berserkers_blood_passive_soulmax_flag:GetModifierMoveSpeedBonus_Constant() 
	return (self.parent:PassivesDisabled())  and 0 or (self.parent:TG_GetTalentValue("special_bonus_imba_huskar_6") * (self:GetStackCount() / 100))
end











------------------牺牲-----------------

imba_huskar_life_break = class({})

LinkLuaModifier("modifier_imba_huskar_life_break_yidong", "ting/hero_huskar", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_huskar_life_break_buff", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_life_break_buff2", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_black", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
function imba_huskar_life_break:IsStealable() return false end
function imba_huskar_life_break:GetCastRange() return self:GetCaster():HasScepter() and self:GetSpecialValueFor("range_scepter") or self:GetSpecialValueFor("range") end
function imba_huskar_life_break:CastFilterResultTarget(target)
	if IsServer() then
		--自己
		if target:IsBuilding() then return UF_FAIL_CUSTOM end
		if target:IsMagicImmune() and  self:GetCaster():HasScepter() then return UF_SUCCESS end
		if Is_Chinese_TG(target,self:GetCaster()) then return UF_FAIL_CUSTOM  end 
		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_huskar_life_break:OnSpellStart()
	if not IsServer() then return end

	self:GetCaster():EmitSound("Hero_Huskar.Life_Break")

	self:GetCaster():Purge(false, true, false, false, false)

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_life_break_yidong", {ent_index = self:GetCursorTarget():GetEntityIndex()})
end

--牺牲跳跃
modifier_imba_huskar_life_break_yidong = class({})
LinkLuaModifier("modifier_imba_huskar_life_break_buff", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_life_break_buff2", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_burning_spear_hp", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_huskar_inner_fire_disarm", "ting/hero_huskar", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_huskar_life_break_yidong:IsHidden()		return false end
function modifier_imba_huskar_life_break_yidong:IsPurgable()	return false end
function modifier_imba_huskar_life_break_yidong:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_imba_huskar_life_break_yidong:GetOverrideAnimation() return  ACT_DOTA_CAST_LIFE_BREAK_START end
function modifier_imba_huskar_life_break_yidong:GetPriority() return {MODIFIER_PROPERTY_ULTRA} end
function modifier_imba_huskar_life_break_yidong:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_ROOTED] = true} end
function modifier_imba_huskar_life_break_yidong:GetStatusEffectName()	return "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_cast_flame.vpcf" end
function modifier_imba_huskar_life_break_yidong:RemoveOnDeath()		return true end
function modifier_imba_huskar_life_break_yidong:OnCreated(params)
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.charge_speed			= self.ability:GetSpecialValueFor("charge_speed")
	if not IsServer() then return end

	self.target			= EntIndexToHScript(params.ent_index)

	self.break_range	= 2500

	if self:ApplyHorizontalMotionController() == false then
		self:Destroy()
		return
	end
end

function modifier_imba_huskar_life_break_yidong:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end

	me:FaceTowards(self.target:GetOrigin())
	local distance = (self.target:GetOrigin() - me:GetOrigin()):Normalized()
	me:SetOrigin( me:GetOrigin() + distance * self.charge_speed * dt )
	if (self.target:GetOrigin() - me:GetOrigin()):Length2D() <= 128 or (self.target:GetOrigin() - me:GetOrigin()):Length2D() > self.break_range or self.caster:IsHexed() or self.caster:IsNightmared()then
		self:Destroy()
	end
end

function modifier_imba_huskar_life_break_yidong:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_imba_huskar_life_break_yidong:OnDestroy()
	if not IsServer() then return end
	self.caster:RemoveHorizontalMotionController( self )
	local duration = self:GetAbility():GetSpecialValueFor("slow_durtion")
	if (self.target:GetOrigin() - self.caster:GetOrigin()):Length2D() <= 128 then
		if self.target:TriggerSpellAbsorb(self.ability) then
			return nil
		end

		self.caster:StartGesture(ACT_DOTA_CAST_LIFE_BREAK_END)

		self.target:EmitSound("Hero_Huskar.Life_Break.Impact")
		local particle = ParticleManager:CreateParticle("particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_life_break.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
		ParticleManager:SetParticleControl(particle, 1, self.target:GetOrigin())
		ParticleManager:SetParticleControl(particle, 2, self.target:GetOrigin())
		ParticleManager:SetParticleControl(particle, 3, self.target:GetOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
		
		local damage_e = self:GetAbility():GetSpecialValueFor("health_damage")*self.target:GetHealth()*0.01
		local damage_flags_e = DOTA_DAMAGE_FLAG_NONE

		local damageTable_enemy = {
			victim 			= self.target,
			attacker 		= self.caster,
			damage 			= damage_e,
			damage_type 	= DAMAGE_TYPE_MAGICAL,
			ability 		= self.ability,
			damage_flags	= damage_flags_e
		}
		ApplyDamage(damageTable_enemy)	
		local damageTable_self = {
			victim 			= self.caster,
			attacker 		= self.caster,
			damage 			= self:GetAbility():GetSpecialValueFor("health_cost_percent")*self.caster:GetHealth()*0.01,
			damage_type 	= DAMAGE_TYPE_MAGICAL,
			ability		 	= self.ability,
			damage_flags 	= DOTA_DAMAGE_FLAG_NON_LETHAL+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
			}
		ApplyDamage(damageTable_self)
		if self.caster:HasModifier("modifier_imba_huskar_armlet") then
		local mod = self.caster:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_imba_huskar_burning_spear_hp",{duration = self:GetAbility():GetSpecialValueFor("duration")}) 
		if mod~= nil then
		mod:SetStackCount(math.min(mod:GetStackCount()+self:GetAbility():GetSpecialValueFor("health_cost_percent")*self.caster:GetMaxHealth()*0.01,12000))
		end
		self.caster:CalculateStatBonus(true)
		end
		----敌人持续时间
		self.target:AddNewModifier_RS(self.caster, self.ability, "modifier_imba_huskar_life_break_buff", {duration = duration})
		if self.caster:HasScepter() then
			self.target:AddNewModifier_RS(self.caster, self.ability, "modifier_huskar_life_break_taunt", {duration = self:GetAbility():GetSpecialValueFor("taunt_dur")})
			self.target:AddNewModifier_RS(self.caster, self.ability, "modifier_imba_huskar_inner_fire_disarm", {duration = self:GetAbility():GetSpecialValueFor("taunt_dur")})
		end
		self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_huskar_life_break_buff2", {duration = duration})
	end
		self.caster:MoveToTargetToAttack( self.target )
		
		
	local ability = self.caster:FindAbilityByName("imba_huskar_inner_fire")
	if ability~=nil then
		if ability:GetLevel()>0 then
			ability:InnerFire(0,false,true)
		end
	end
	self.caster = nil
	self.ability = nil
	self.target = nil
	self.break_range = nil
		
end

modifier_imba_huskar_life_break_buff = class({})
function modifier_imba_huskar_life_break_buff:IsPurgable() return false end

function modifier_imba_huskar_life_break_buff:IsDebuff() return true end
function modifier_imba_huskar_life_break_buff:GetStatusEffectName()	return "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_cast_flame.vpcf" end
function modifier_imba_huskar_life_break_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_huskar_life_break_buff:RemoveOnDeath() return  false end
function modifier_imba_huskar_life_break_buff:GetModifierMoveSpeedBonus_Percentage() return	self.movespeed	end
function modifier_imba_huskar_life_break_buff:OnCreated()
	self.movespeed	= self:GetAbility():GetSpecialValueFor("movespeed")
end
function modifier_imba_huskar_life_break_buff:OnDestroy()
	self.movespeed = nil
end

modifier_imba_huskar_life_break_buff2 = class({})
function modifier_imba_huskar_life_break_buff2:IsPurgable() 	return false end
function modifier_imba_huskar_life_break_buff2:IsPurgeException() return false end
function modifier_imba_huskar_life_break_buff2:IsDebuff() return false end
function modifier_imba_huskar_life_break_buff2:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_MOVESPEED_LIMIT,MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT} end
function modifier_imba_huskar_life_break_buff2:GetModifierMoveSpeedBonus_Percentage() return	self.movespeed	end
function modifier_imba_huskar_life_break_buff2:GetEffectName()
	return "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf"
end
function modifier_imba_huskar_life_break_buff2:GetModifierMoveSpeed_Limit()
    return 9999
end
function modifier_imba_huskar_life_break_buff2:GetModifierIgnoreMovespeedLimit()
    return 1
end
function modifier_imba_huskar_life_break_buff2:OnCreated()
	self.movespeed = -1*self:GetAbility():GetSpecialValueFor("movespeed")
end
function modifier_imba_huskar_life_break_buff2:OnDestroy()
	self.movespeed = nil
end

