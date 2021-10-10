-- Author: MysticBug 02/13/2021
----------------------------------------------------------------------------------------------------------------
--rubick_arcane_supremacy 奥术至尊
--拉比克对奥术的熟稔让他可以造成更高的法术伤害，敌人所受的法术持续时间也更长。

--imba rubick_null_field 失效力场:降低%1200%敌人的%25%魔法抗性和提升队友%25%的魔法抗性。
----------------------------------------------------------------------------------------------------------------
imba_rubick_arcane_supremacy = class({})
LinkLuaModifier("modifier_imba_rubick_arcane_supremacy", "mb/hero_rubick/rubick_arcane_supremacy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rubick_arcane_supremacy_aura", "mb/hero_rubick/rubick_arcane_supremacy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rubick_arcane_supremacy_positive_aura", "mb/hero_rubick/rubick_arcane_supremacy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rubick_arcane_supremacy_negative_aura", "mb/hero_rubick/rubick_arcane_supremacy", LUA_MODIFIER_MOTION_NONE)
function imba_rubick_arcane_supremacy:GetIntrinsicModifierName() return "modifier_imba_rubick_arcane_supremacy" end

modifier_imba_rubick_arcane_supremacy = class({})

--被动加拉比克技能增强
function modifier_imba_rubick_arcane_supremacy:IsPassive()			return true end
function modifier_imba_rubick_arcane_supremacy:IsDebuff()			return false end
function modifier_imba_rubick_arcane_supremacy:IsHidden() 		    return true end
function modifier_imba_rubick_arcane_supremacy:IsPurgable() 		return false end
function modifier_imba_rubick_arcane_supremacy:IsPurgeException()   return false end
function modifier_imba_rubick_arcane_supremacy:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_rubick_arcane_supremacy:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_rubick_arcane_supremacy:DeclareFunctions() return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE} end
function modifier_imba_rubick_arcane_supremacy:GetModifierSpellAmplify_Percentage()	return self:GetAbility():GetSpecialValueFor("spell_amp") end

function modifier_imba_rubick_arcane_supremacy:OnCreated()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_rubick_arcane_supremacy_aura", {})
	end
end

function modifier_imba_rubick_arcane_supremacy:OnDestroy()
	if IsServer() and not self:GetParent():HasModifier("modifier_imba_rubick_arcane_supremacy_aura") then
		self:GetParent():RemoveModifierByName("modifier_imba_rubick_arcane_supremacy_aura")
	end
end 
function modifier_imba_rubick_arcane_supremacy:IsAura() return true end
function modifier_imba_rubick_arcane_supremacy:GetAuraDuration() return 0.1 end
function modifier_imba_rubick_arcane_supremacy:GetModifierAura() return "modifier_imba_rubick_arcane_supremacy_positive_aura" end
function modifier_imba_rubick_arcane_supremacy:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_imba_rubick_arcane_supremacy:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_rubick_arcane_supremacy:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_rubick_arcane_supremacy:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

--imba 失效立场光环 敌人
modifier_imba_rubick_arcane_supremacy_aura = class({})

function modifier_imba_rubick_arcane_supremacy_aura:IsDebuff()			return false end
function modifier_imba_rubick_arcane_supremacy_aura:IsHidden() 			return true end
function modifier_imba_rubick_arcane_supremacy_aura:IsPurgable() 			return false end
function modifier_imba_rubick_arcane_supremacy_aura:IsPurgeException() 	return false end
function modifier_imba_rubick_arcane_supremacy_aura:IsAura() 			return true end
function modifier_imba_rubick_arcane_supremacy_aura:GetAuraDuration() return 0.1 end
function modifier_imba_rubick_arcane_supremacy_aura:GetModifierAura() return "modifier_imba_rubick_arcane_supremacy_negative_aura" end
function modifier_imba_rubick_arcane_supremacy_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_imba_rubick_arcane_supremacy_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_rubick_arcane_supremacy_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_rubick_arcane_supremacy_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

--imba 失效立场光环 友军 加魔抗
modifier_imba_rubick_arcane_supremacy_positive_aura = class({})

function modifier_imba_rubick_arcane_supremacy_positive_aura:IsDebuff()			    return false end
function modifier_imba_rubick_arcane_supremacy_positive_aura:IsHidden() 			return false end
function modifier_imba_rubick_arcane_supremacy_positive_aura:IsPurgable() 		    return false end
function modifier_imba_rubick_arcane_supremacy_positive_aura:IsPurgeException() 	return false end
function modifier_imba_rubick_arcane_supremacy_positive_aura:GetTexture() 			return "rubick_null_field" end
function modifier_imba_rubick_arcane_supremacy_positive_aura:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_imba_rubick_arcane_supremacy_positive_aura:OnCreated() self.magic = self:GetAbility():GetSpecialValueFor("magic_resistance") end 
function modifier_imba_rubick_arcane_supremacy_positive_aura:OnDestroy() self.magic = nil end
function modifier_imba_rubick_arcane_supremacy_positive_aura:GetModifierMagicalResistanceBonus() return self.magic end

--imba 失效立场光环 敌军  减魔抗和抗性
modifier_imba_rubick_arcane_supremacy_negative_aura = class({})

function modifier_imba_rubick_arcane_supremacy_negative_aura:IsDebuff()				return true end
function modifier_imba_rubick_arcane_supremacy_negative_aura:IsHidden() 			return false end
function modifier_imba_rubick_arcane_supremacy_negative_aura:IsPurgable() 			return false end
function modifier_imba_rubick_arcane_supremacy_negative_aura:IsPurgeException() 	return false end
function modifier_imba_rubick_arcane_supremacy_negative_aura:GetTexture() 			return "rubick_null_field_offensive" end
function modifier_imba_rubick_arcane_supremacy_negative_aura:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING} end
function modifier_imba_rubick_arcane_supremacy_negative_aura:OnCreated() self.magic = self:GetAbility():GetSpecialValueFor("magic_resistance") self.status = self:GetAbility():GetSpecialValueFor("status_resistance") end 
function modifier_imba_rubick_arcane_supremacy_negative_aura:OnDestroy() self.magic = nil self.status = nil end
function modifier_imba_rubick_arcane_supremacy_negative_aura:GetModifierMagicalResistanceBonus() return (0 - self.magic) end 
function modifier_imba_rubick_arcane_supremacy_negative_aura:GetModifierStatusResistanceStacking() return (0 - self.status) end