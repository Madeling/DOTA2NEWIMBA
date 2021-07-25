natural_order_spirit=class({})
LinkLuaModifier("modifier_natural_order_spirit", "heros/hero_elder_titan/natural_order_spirit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_natural_order_spirit_debuff", "heros/hero_elder_titan/natural_order_spirit.lua", LUA_MODIFIER_MOTION_NONE)

function natural_order_spirit:IsHiddenWhenStolen() 
    return false 
end

function natural_order_spirit:IsStealable() 
    return false 
end

function natural_order_spirit:GetIntrinsicModifierName() 
    return "modifier_natural_order_spirit" 
end


modifier_natural_order_spirit=class({})

function modifier_natural_order_spirit:IsBuff()			
    return true 
end

function modifier_natural_order_spirit:IsHidden() 			
    return false 
end

function modifier_natural_order_spirit:IsPurgable() 			
    return false 
end

function modifier_natural_order_spirit:IsPurgeException() 	
    return false 
end

function modifier_natural_order_spirit:IsAura() 
    return true 
end

function modifier_natural_order_spirit:GetAuraDuration() 
    return 0
end

function modifier_natural_order_spirit:GetModifierAura() 
    return "modifier_natural_order_spirit_debuff" 
end

function modifier_natural_order_spirit:GetAuraRadius() 
    return self:GetAbility():GetSpecialValueFor( "rd" )
end

function modifier_natural_order_spirit:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_natural_order_spirit:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_natural_order_spirit:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
end



modifier_natural_order_spirit_debuff=class({})

function modifier_natural_order_spirit_debuff:IsDebuff()			
    return true 
end

function modifier_natural_order_spirit_debuff:IsHidden() 			
    return false 
end

function modifier_natural_order_spirit_debuff:IsPurgable() 			
    return false 
end

function modifier_natural_order_spirit_debuff:IsPurgeException() 	
    return false 
end

function modifier_natural_order_spirit_debuff:GetEffectName() 
   return "particles/units/heroes/hero_elder_titan/elder_titan_natural_order_physical.vpcf" 
end

function modifier_natural_order_spirit_debuff:GetEffectAttachType() 
   return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_natural_order_spirit_debuff:OnCreated() 
    if not IsServer() then
        return 
    end
    self:SetStackCount(self:GetAbility():GetSpecialValueFor( "debuff" ))
end

function modifier_natural_order_spirit_debuff:OnRefresh() 
    if not IsServer() then
        return 
    end
    self:SetStackCount(self:GetAbility():GetSpecialValueFor( "debuff" ))
end

function modifier_natural_order_spirit_debuff:DeclareFunctions() 
    return 
    { 
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    } 
end

function modifier_natural_order_spirit_debuff:GetModifierPhysicalArmorBase_Percentage() 
    return self:GetStackCount()
end

function modifier_natural_order_spirit_debuff:GetModifierMagicalResistanceBonus() 
    return self:GetStackCount()
end

function modifier_natural_order_spirit_debuff:GetModifierStatusResistanceStacking() 
    return self:GetStackCount()
end