-- Author: MysticBug 02/13/2021
----------------------------------------------------------------------------------------------------------------
--rubick_fade_bolt  弱化能流
--拉比克制造一道强大的奥术能量流，在多个敌方单位之间流动，造成伤害并降低他们的攻击力。每次弹跳造成的伤害递减。

--imba 弱化奥术：降低敌方单位%10/15/20/25%技能增强。
----------------------------------------------------------------------------------------------------------------
imba_rubick_fade_bolt = class({})
LinkLuaModifier("modifier_imba_rubick_fade_bolt_debuff", "mb/hero_rubick/rubick_fade_bolt", LUA_MODIFIER_MOTION_NONE)

function imba_rubick_fade_bolt:IsHiddenWhenStolen() 	return false end
function imba_rubick_fade_bolt:IsRefreshable() 			return true end
function imba_rubick_fade_bolt:IsStealable() 			return false end
function imba_rubick_fade_bolt:IsNetherWardStealable()	return false end

function imba_rubick_fade_bolt:OnSpellStart()
	local caster = self:GetCaster()
	local cur_target = self:GetCursorTarget()
	local pre_target = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage")
	local jump_damage_reduction_pct = self:GetSpecialValueFor("jump_damage_reduction_pct")
	local hitted_table = {}
	--音效
	caster:EmitSound("Hero_Rubick.FadeBolt.Cast")
	--延时弹跳
	Timers:CreateTimer(function()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			cur_target:GetAbsOrigin(),
			nil,
			self:GetSpecialValueFor("radius"),
			self:GetAbilityTargetTeam(),
			self:GetAbilityTargetType(),
			self:GetAbilityTargetFlags(),
			FIND_CLOSEST,
			false
		)

		for _, enemy in pairs(enemies) do
			if enemy ~= pre_target and not IsInTable(enemy, hitted_table) then
				cur_target = enemy
				break
			end
		end

		if pre_target ~= nil then 
			--特效
			self.fade_bolt_pfx = "particles/units/heroes/hero_rubick/rubick_fade_bolt.vpcf"
			local pfx = ParticleManager:CreateParticle(self.fade_bolt_pfx, PATTACH_CUSTOMORIGIN, pre_target)
			ParticleManager:SetParticleControlEnt(pfx, 0, pre_target, PATTACH_POINT_FOLLOW, "attach_hitloc", pre_target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, cur_target, PATTACH_POINT_FOLLOW, "attach_hitloc", cur_target:GetAbsOrigin(), true)
			--如果不是第一个目标
			damage = damage - damage*jump_damage_reduction_pct/100
		end
	
		if not IsInTable(cur_target, hitted_table) then 
			-- hit 音效
			EmitSoundOn("Hero_Rubick.FadeBolt.Target", cur_target)
			-- 减攻击和技能增强
			cur_target:AddNewModifier_RS(caster, self, "modifier_imba_rubick_fade_bolt_debuff", {duration = self:GetSpecialValueFor("duration")})
			-- 造成伤害
			ApplyDamage({
				attacker = caster,
				victim = cur_target,
				ability = self,
				damage = damage,
				damage_type = self:GetAbilityDamageType()
			})
			--入列
			table.insert(hitted_table, cur_target)
		end
		-- 弹跳下个目标
		if pre_target ~= cur_target then
			--记录弹跳目标
			pre_target = cur_target
			return self:GetSpecialValueFor("jump_delay")
		else
			-- 如果没有，结束弹跳
			return nil
		end
	end)
end

--DEBUFF 减攻击和减技能增强
modifier_imba_rubick_fade_bolt_debuff = class({})

function modifier_imba_rubick_fade_bolt_debuff:IsHidden()			return false end
function modifier_imba_rubick_fade_bolt_debuff:IsDebuff()			return true end
function modifier_imba_rubick_fade_bolt_debuff:IsPurgable() 		return true end
function modifier_imba_rubick_fade_bolt_debuff:IsPurgeException() 	return true end
function modifier_imba_rubick_fade_bolt_debuff:GetEffectName() return "particles/units/heroes/hero_rubick/rubick_fade_bolt_debuff.vpcf" end
function modifier_imba_rubick_fade_bolt_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_rubick_fade_bolt_debuff:DeclareFunctions()  return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE} end
function modifier_imba_rubick_fade_bolt_debuff:GetModifierBaseDamageOutgoing_Percentage() 
	if self:GetParent():IsHero() or self:GetParent():IsBoss() then
		return (0 - (self:GetAbility():GetSpecialValueFor("hero_attack_damage_reduction") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_rubick_1","hero_attack_damage")))
	else
		return (0 - self:GetAbility():GetSpecialValueFor("creep_attack_damage_reduction"))
	end	
end
function modifier_imba_rubick_fade_bolt_debuff:GetModifierSpellAmplify_Percentage() 
	if self:GetParent():IsHero() or self:GetParent():IsBoss() then
		return (0 - (self:GetAbility():GetSpecialValueFor("hero_spell_reduction") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_rubick_1","hero_spell_amp")))
	end	
end