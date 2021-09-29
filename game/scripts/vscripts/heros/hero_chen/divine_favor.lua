divine_favor=class({})

LinkLuaModifier("modifier_divine_favor", "heros/hero_chen/divine_favor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_divine_favor_buff", "heros/hero_chen/divine_favor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_divine_favor_debuff", "heros/hero_chen/divine_favor.lua", LUA_MODIFIER_MOTION_NONE)
function divine_favor:IsHiddenWhenStolen()
    return false
end

function divine_favor:IsStealable()
    return true
end


function divine_favor:IsRefreshable()
    return true
end

function divine_favor:GetIntrinsicModifierName()
    return "modifier_divine_favor"
end

function divine_favor:OnToggle()
end

modifier_divine_favor= class({})

function modifier_divine_favor:IsPassive()
	return true
end


function modifier_divine_favor:IsHidden()
    return true
end

function modifier_divine_favor:IsPurgable()
    return false
end

function modifier_divine_favor:IsPurgeException()
    return false
end

function modifier_divine_favor:IsAura()
    return true
end


function modifier_divine_favor:GetModifierAura()
    if IsServer() then
        if self:GetAbility():GetToggleState() then
            return "modifier_divine_favor_debuff"
        else
            return "modifier_divine_favor_buff"
        end
    end
end

function modifier_divine_favor:GetAuraRadius()
    return 2000
end

function modifier_divine_favor:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_divine_favor:GetAuraSearchTeam()
    if IsServer() then
        if self:GetAbility():GetToggleState() then
            return DOTA_UNIT_TARGET_TEAM_ENEMY
        else
            return DOTA_UNIT_TARGET_TEAM_FRIENDLY
        end
    end
end

function modifier_divine_favor:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end


modifier_divine_favor_buff=class({})

function modifier_divine_favor_buff:IsHidden()
    return false

end

function modifier_divine_favor_buff:IsPurgable()
    return false
end

function modifier_divine_favor_buff:IsPurgeException()
    return false
end

function modifier_divine_favor_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
    }
end
function modifier_divine_favor_buff:GetModifierHealAmplify_PercentageTarget()
    return  self.heal_amp
end

function modifier_divine_favor_buff:GetModifierHPRegenAmplify_Percentage()
    return self.heal_rate
end

function modifier_divine_favor_buff:GetModifierPercentageCooldown()
    if IsValidEntity(self:GetCaster()) and self:GetCaster():TG_HasTalent("special_bonus_chen_5") then
        return 5
    end
    return 0
end

function modifier_divine_favor_buff:OnCreated()
    if self:GetAbility()==nil then
        return
    end
    self.ability=self:GetAbility()
    self.heal_amp=self.ability:GetSpecialValueFor( "heal_amp")
    self.heal_rate=self.ability:GetSpecialValueFor( "heal_rate")
end

function modifier_divine_favor_buff:OnRefresh()
   self:OnCreated()
end

modifier_divine_favor_debuff=class({})

function modifier_divine_favor_debuff:IsHidden()
    return false

end

function modifier_divine_favor_debuff:IsPurgable()
    return false
end

function modifier_divine_favor_debuff:IsPurgeException()
    return false
end

function modifier_divine_favor_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end
function modifier_divine_favor_debuff:GetModifierHealAmplify_PercentageTarget()
    return  0-self.heal_amp
end

function modifier_divine_favor_debuff:GetModifierHPRegenAmplify_Percentage()
    return 0-self.heal_rate
end

function modifier_divine_favor_debuff:GetModifierMagicalResistanceBonus()
    if self:GetCaster():TG_HasTalent("special_bonus_chen_6") then
        return -15
    end
    return 0
end

function modifier_divine_favor_debuff:OnCreated()
    if self:GetAbility()==nil then
        return
    end
    self.ability=self:GetAbility()
    self.heal_amp=self:GetAbility():GetSpecialValueFor( "heal_amp")
    self.heal_rate=self:GetAbility():GetSpecialValueFor( "heal_rate")
end

function modifier_divine_favor_debuff:OnRefresh()
   self:OnCreated()
end