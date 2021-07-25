-- Author: MysticBug 03/01/2021
----------------------------------------------------------------------------------------------------------------
--变体打击(力量)
--imba_morphling_adaptive_strike_str
--用猛烈的水波打击一个敌方单位,如果学习了变体打击将造成最大眩晕/击退和最小伤害,并附加一次普通攻击(触发攻击特效).
--混源
--1.混源打击(被动)：每次攻击敌方单位附加变体精灵全属性15%物理伤害(无视技能免疫).
-- 拥有魔晶以后，主动施法提升同等魔晶攻击敌方单位数目.

---------------------------------------------------------------------
----------------------- MORPHLING MORPH ------------------------
---------------------------------------------------------------------
imba_morphling_adaptive_strike_str = class({})
LinkLuaModifier("modifier_imba_morphling_adaptive_strike_str_passive", "mb/hero_morphling/morphling_adaptive_strike_str", LUA_MODIFIER_MOTION_NONE)

function imba_morphling_adaptive_strike_str:IsHiddenWhenStolen()		return false end
function imba_morphling_adaptive_strike_str:IsRefreshable()			return true end
function imba_morphling_adaptive_strike_str:IsStealable() 			return false end
function imba_morphling_adaptive_strike_str:IsNetherWardStealable()	return false end
function imba_morphling_adaptive_strike_str:GetIntrinsicModifierName() return "modifier_imba_morphling_adaptive_strike_str_passive" end
function imba_morphling_adaptive_strike_str:OnHeroLevelUp()
	local level = self:GetCaster():GetLevel()
	local ability = self
	local level_to_set = math.min((math.floor((level + 1) / 2) - 1), ability:GetMaxLevel())
	if ability:GetLevel() ~= level_to_set then
		ability:SetLevel(level_to_set)
	end
end

function imba_morphling_adaptive_strike_str:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if caster:HasAbility("imba_morphling_adaptive_strike") then
		caster:SetCursorCastTarget(target)
		local strike_ability = caster:FindAbilityByName("imba_morphling_adaptive_strike")
		if strike_ability and strike_ability:GetLevel() > 0 then
			strike_ability:OnSpellStart(true)
		end
	end
	--Attack 
	if not target:IsInvulnerable() and not target:IsOutOfGame() and caster:IsAlive() then
		caster:PerformAttack(target, false, true, true, false, true, false, false)
	end
	--shard strike
	if caster:Has_Aghanims_Shard() then 
		local strike_count = self:GetSpecialValueFor("shard_strike_count")
		--附加一次普通攻击
		local enemies = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				caster:GetAbsOrigin(), 
				nil, 
				self:GetCastRange(caster:GetAbsOrigin(), caster) + caster:GetCastRangeBonus(), 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO, 
				DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, --只寻找在视野范围内的
				FIND_ANY_ORDER, 
				false)

		for _, enemy in pairs(enemies) do
			if enemy ~= target then
				caster:PerformAttack(enemy, false, true, true, false, true, false, false)
				strike_count = strike_count - 1 
				if strike_count == 0 then 
					break
				end
			end
		end
	end
end
---------------------------------------------------------------------
-----    MODIFIER_IMBA_MORPHLING_ADAPTIVE_STRIKE_STR_PASSIVE    -----
---------------------------------------------------------------------
modifier_imba_morphling_adaptive_strike_str_passive = class({})

function modifier_imba_morphling_adaptive_strike_str_passive:IsDebuff()			return false end
function modifier_imba_morphling_adaptive_strike_str_passive:IsHidden() 			return true end
function modifier_imba_morphling_adaptive_strike_str_passive:IsPurgable() 		return false end
function modifier_imba_morphling_adaptive_strike_str_passive:IsPurgeException() 	return false end
function modifier_imba_morphling_adaptive_strike_str_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_morphling_adaptive_strike_str_passive:AllowIllusionDuplicate() return false end
function modifier_imba_morphling_adaptive_strike_str_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_imba_morphling_adaptive_strike_str_passive:OnCreated() 
	if not IsServer() then
		return
	end
	self.ability = self:GetAbility() 
	self.bonus_damage_muti = self.ability:GetSpecialValueFor("bonus_damage_muti")
end
function modifier_imba_morphling_adaptive_strike_str_passive:OnDestroy() 
	if not IsServer() then
		return
	end
	self.ability = nil  
end
function modifier_imba_morphling_adaptive_strike_str_passive:OnAttackLanded(keys)
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