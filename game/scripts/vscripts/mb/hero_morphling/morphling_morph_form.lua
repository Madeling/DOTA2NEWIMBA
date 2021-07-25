-- Author: MysticBug 03/01/2021
----------------------------------------------------------------------------------------------------------------
--变体精灵
--imba_morphling_morph_form								
--形态变换
--变体精灵处于液体形态下,每次攻击敌方单位附加变体精灵全属性26%魔法伤害.

--imba
--1.拟态：记录过去5s内施法过的基础技能，记录成功时，该技能可以主动施法，获得记录技能相同效果.记录成功期间不会再记录其他技能.
--如果记录的是变体打击，那么主动使用只会对目标造成最小伤害和最小眩晕击退.
---------------------------------------------------------------------
----------------------- MORPHLING MORPH FORM ------------------------
---------------------------------------------------------------------
imba_morphling_morph_form = class({})
LinkLuaModifier("modifier_imba_morphling_morph_form_passive", "mb/hero_morphling/morphling_morph_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_morphling_morph_form_record", "mb/hero_morphling/morphling_morph_form", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_morphling_morph_form_record_target", "mb/hero_morphling/morphling_morph_form", LUA_MODIFIER_MOTION_NONE)

function imba_morphling_morph_form:IsStealable() 			return false end
function imba_morphling_morph_form:IsNetherWardStealable()	return false end
function imba_morphling_morph_form:GetIntrinsicModifierName() return "modifier_imba_morphling_morph_form_passive" end
function imba_morphling_morph_form:OnHeroLevelUp()
	local level = self:GetCaster():GetLevel()
	local ability = self
	local level_to_set = math.min((math.floor((level + 1) / 2) - 1), ability:GetMaxLevel())
	if ability:GetLevel() ~= level_to_set then
		ability:SetLevel(level_to_set)
	end
end
function imba_morphling_morph_form:GetBehavior()
	if self:GetCaster():HasModifier("modifier_imba_morphling_morph_form_record_target") then 
		return (DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE)
	elseif self:GetCaster():HasModifier("modifier_imba_morphling_morph_form_record") then 	
		return (DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE)
	else
		return (DOTA_ABILITY_BEHAVIOR_PASSIVE + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE)
	end
end


function imba_morphling_morph_form:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local record_ability_name
	if self:GetCaster():HasModifier("modifier_imba_morphling_morph_form_record_target") then 
		record_ability_name = self:GetCaster():FindModifierByName("modifier_imba_morphling_morph_form_record_target").record_ability_name
	elseif self:GetCaster():HasModifier("modifier_imba_morphling_morph_form_record") then 	
		record_ability_name = self:GetCaster():FindModifierByName("modifier_imba_morphling_morph_form_record").record_ability_name
	else
		return
	end
	local record_ability = self:GetCaster():FindAbilityByName(record_ability_name)
	local target = self:GetCursorTarget() or caster
	local target_point = self:GetCursorPosition()
	if record_ability and record_ability:GetLevel() > 0 and target_point then
		caster:SetCursorPosition(target_point)
		if record_ability_name == "imba_morphling_adaptive_strike" then
			record_ability:OnSpellStart(true)
		else
			record_ability:OnSpellStart()
		end
	elseif record_ability then
		record_ability:OnSpellStart()
	else
		return
	end
	--Remove
	self:GetCaster():RemoveModifierByName("modifier_imba_morphling_morph_form_record_target")
	self:GetCaster():RemoveModifierByName("modifier_imba_morphling_morph_form_record")
end
---------------------------------------------------------------------
-----          MODIFIER_IMBA_MORPHLING_MORPH_FORM_PASSIVE       -----
---------------------------------------------------------------------
modifier_imba_morphling_morph_form_passive = class({})

function modifier_imba_morphling_morph_form_passive:IsDebuff()			return false end
function modifier_imba_morphling_morph_form_passive:IsHidden() 			return true end
function modifier_imba_morphling_morph_form_passive:IsPurgable() 		return false end
function modifier_imba_morphling_morph_form_passive:IsPurgeException() 	return false end
function modifier_imba_morphling_morph_form_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_morphling_morph_form_passive:AllowIllusionDuplicate() return false end
function modifier_imba_morphling_morph_form_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_imba_morphling_morph_form_passive:OnCreated() 
	if not IsServer() then
		return
	end
	self.ability = self:GetAbility() 
	self.bonus_damage_muti = self.ability:GetSpecialValueFor("bonus_damage_muti")
	self.record_duration = self.ability:GetSpecialValueFor("record_duration")
end
function modifier_imba_morphling_morph_form_passive:OnDestroy() 
	if not IsServer() then
		return
	end
	self.ability = nil  
end
function modifier_imba_morphling_morph_form_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or not self:GetParent():IS_TrueHero_TG() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	local parent = self:GetParent()
	local pulverize_damage = (parent:GetStrength() + parent:GetAgility() + parent:GetIntellect())* self.ability:GetSpecialValueFor("bonus_damage_muti") / 100
	ApplyDamage({victim = keys.target, attacker = parent, damage = pulverize_damage, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})
	keys.target:EmitSound("Hero_Morphling.projectileImpact")
	--local pfx = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_morphling/morphling_adaptive_strike_str.vpcf", parent), PATTACH_CUSTOMORIGIN, keys.target)
	--	ParticleManager:SetParticleControlEnt(pfx, 0, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
	--	ParticleManager:SetParticleControlEnt(pfx, 1, keys.target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, keys.target:GetAbsOrigin(), true)
	--	ParticleManager:ReleaseParticleIndex(pfx)
end

banned_cast_abi = {
	["imba_morphling_morph_replicate"] = true,
	["imba_morphling_replicate"] = true,
	["imba_morphling_morph_form"] = true,	
}

function modifier_imba_morphling_morph_form_passive:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() or self:GetParent():PassivesDisabled() then 
		return 
	end
	--开关类技能 和 自动施法类技能不记录
	if banned_cast_abi[keys.ability:GetAbilityName()] or 
		(bit.band(keys.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_TOGGLE) == DOTA_ABILITY_BEHAVIOR_TOGGLE) or
		(bit.band(keys.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_AUTOCAST) == DOTA_ABILITY_BEHAVIOR_AUTOCAST) or
		(bit.band(keys.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_CHANNELLED) == DOTA_ABILITY_BEHAVIOR_CHANNELLED)	then 
		return
	end 
	local parent = self:GetParent()
	local cast_abi = self:GetParent():FindAbilityByName(keys.ability:GetAbilityName())
	--Record Ability
	if self.ability:IsCooldownReady() and 
		cast_abi and 
		not parent:HasModifier("modifier_imba_morphling_morph_form_record") and 
		not parent:HasModifier("modifier_imba_morphling_morph_form_record_target") then
		local buff
		if (bit.band(keys.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) then
			buff = parent:AddNewModifier(parent, self:GetAbility(), "modifier_imba_morphling_morph_form_record_target", {duration = self.record_duration})
		else
			buff = parent:AddNewModifier(parent, self:GetAbility(), "modifier_imba_morphling_morph_form_record", {duration = self.record_duration})
		end
		buff.record_ability_name = keys.ability:GetAbilityName()
		local buff_text = "#DOTA_Tooltip_ability_"..buff.record_ability_name
		Notifications:Bottom(self:GetCaster():GetPlayerOwnerID(),{text = "形态变换记录技能", duration = 3.0, style = {["font-size"] = "30px", color = "white"}})
		Notifications:Bottom(self:GetCaster():GetPlayerOwnerID(),{text = buff_text, duration = 3.0, style = {["font-size"] = "30px", color = "yellow"},continue = true})
	end
end

modifier_imba_morphling_morph_form_record = class({})

function modifier_imba_morphling_morph_form_record:IsDebuff()			return false end
function modifier_imba_morphling_morph_form_record:IsHidden() 			return false end
function modifier_imba_morphling_morph_form_record:IsPurgable() 		return false end
function modifier_imba_morphling_morph_form_record:IsPurgeException() 	return false end
function modifier_imba_morphling_morph_form_record:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_morphling_morph_form_record:AllowIllusionDuplicate() return false end

modifier_imba_morphling_morph_form_record_target = class({})

function modifier_imba_morphling_morph_form_record_target:IsDebuff()			return false end
function modifier_imba_morphling_morph_form_record_target:IsHidden() 			return false end
function modifier_imba_morphling_morph_form_record_target:IsPurgable() 		return false end
function modifier_imba_morphling_morph_form_record_target:IsPurgeException() 	return false end
function modifier_imba_morphling_morph_form_record_target:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_morphling_morph_form_record_target:AllowIllusionDuplicate() return false end