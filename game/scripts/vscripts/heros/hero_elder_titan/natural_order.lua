natural_order=class({})
LinkLuaModifier("modifier_natural_order", "heros/hero_elder_titan/natural_order.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_natural_order_debuff", "heros/hero_elder_titan/natural_order.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_natural_order_tower", "heros/hero_elder_titan/natural_order.lua", LUA_MODIFIER_MOTION_NONE)

function natural_order:IsHiddenWhenStolen() 
    return false 
end

function natural_order:IsStealable() 
    return false 
end

function natural_order:IsRefreshable() 			
    return true 
end

function natural_order:GetIntrinsicModifierName() 
    return "modifier_natural_order" 
end


function natural_order:CastFilterResult()
    if not self:GetCaster():HasModifier("modifier_ancestral_spirit_echo_stomp") then  
        return UF_FAIL_CUSTOM
	end
end

function natural_order:GetCustomCastError() 
    return "场上没魂你按NMN" 
end

function natural_order:OnSpellStart()
    local caster = self:GetCaster()
    if caster.ancestral1~=nil then
        FindClearSpaceForUnit(caster, caster.ancestral1:GetAbsOrigin(), false)
        EmitSoundOn("Hero_ElderTitan.EchoStomp.ti7", caster)
        local particle= ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp.vpcf", PATTACH_ABSORIGIN,caster)
        ParticleManager:SetParticleControl(particle, 0,caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1,Vector(1,0,0))
        ParticleManager:SetParticleControl(particle, 2,Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
        ParticleManager:ReleaseParticleIndex( particle )
    end
end


modifier_natural_order=class({})

function modifier_natural_order:IsHidden() 			
    return false 
end

function modifier_natural_order:IsPurgable() 			
    return false 
end

function modifier_natural_order:IsPurgeException() 	
    return false 
end

function modifier_natural_order:AllowIllusionDuplicate() 
    return false 
end

function modifier_natural_order:IsAura() 
    return not self:GetParent():IsIllusion() 
end

function modifier_natural_order:GetModifierAura() 
        return "modifier_natural_order_debuff" 
end

function modifier_natural_order:GetAuraDuration() 
    return 0
end

function modifier_natural_order:GetAuraRadius() 
    return self:GetAbility():GetSpecialValueFor( "rd" )
end

function modifier_natural_order:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES 
end

function modifier_natural_order:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_natural_order:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
end



modifier_natural_order_debuff=class({})

function modifier_natural_order_debuff:IsDebuff()			
    return true 
end

function modifier_natural_order_debuff:IsHidden() 			
    return false 
end

function modifier_natural_order_debuff:IsPurgable() 			
    return false 
end

function modifier_natural_order_debuff:IsPurgeException() 	
    return false 
end

function modifier_natural_order_debuff:GetEffectName() 
    return "particles/heros/elder_titan/natural_order_pm.vpcf" 
end

function modifier_natural_order_debuff:GetEffectAttachType() 
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_natural_order_debuff:OnCreated() 	
    self.AR=self:GetAbility():GetSpecialValueFor("ar")
    self.MR=self:GetAbility():GetSpecialValueFor("mr")
    self.SR=self:GetAbility():GetSpecialValueFor("sr")
end

function modifier_natural_order_debuff:OnRefresh() 	
    self.AR=self:GetAbility():GetSpecialValueFor("ar")
    self.MR=self:GetAbility():GetSpecialValueFor("mr")
    self.SR=self:GetAbility():GetSpecialValueFor("sr")
end

function modifier_natural_order_debuff:OnDestroy() 	
    self.AR=nil
    self.MR=nil
    self.SR=nil
end


function modifier_natural_order_debuff:DeclareFunctions() 
    return 
    { 
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    } 
end

function modifier_natural_order_debuff:GetModifierPhysicalArmorBase_Percentage() 
        return self.AR
end

function modifier_natural_order_debuff:GetModifierMagicalResistanceBonus() 
    return  self.MR
end

function modifier_natural_order_debuff:GetModifierStatusResistanceStacking() 
    return self.SR
end