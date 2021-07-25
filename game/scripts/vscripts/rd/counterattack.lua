counterattack=class({})

LinkLuaModifier("modifier_counterattack", "rd/counterattack.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_counterattack_debuff", "rd/counterattack.lua", LUA_MODIFIER_MOTION_NONE)

function counterattack:GetIntrinsicModifierName() 
    return "modifier_counterattack" 
end


modifier_counterattack=class({})

function modifier_counterattack:IsPassive()
	return true
end

function modifier_counterattack:IsPurgable() 			
    return false 
end

function modifier_counterattack:IsPurgeException() 	
    return false 
end

function modifier_counterattack:IsHidden()				
    return true 
end

function modifier_counterattack:AllowIllusionDuplicate() 	
    return false 
end

function modifier_counterattack:DeclareFunctions()
	return 
    {
	    MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_counterattack:OnAttackLanded(tg)
    if IsServer() then 
        if tg.target==self:GetParent() and tg.attacker~=self:GetParent() and tg.attacker:IsRealHero() then    
            tg.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_counterattack_debuff", {duration=self:GetAbility():GetSpecialValueFor("dur")})
        end  
    end
end


modifier_counterattack_debuff=class({})

function modifier_counterattack_debuff:IsDebuff() 			
    return true 
end

function modifier_counterattack_debuff:IsPurgable() 			
    return false 
end

function modifier_counterattack_debuff:IsPurgeException() 	
    return false 
end

function modifier_counterattack_debuff:IsHidden()				
    return false 
end

function modifier_counterattack_debuff:OnCreated()		
    local att=self:GetAbility():GetSpecialValueFor("att")	
    local max=self:GetAbility():GetSpecialValueFor("max")		
    if IsServer() then   
        self:SetStackCount(att>=max and max or self:GetStackCount()+att)
    end 
end

function modifier_counterattack_debuff:OnRefresh()				
    self:OnCreated()
end

function modifier_counterattack_debuff:DeclareFunctions()
	return 
    {
	    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end

function modifier_counterattack_debuff:GetModifierPreAttack_BonusDamage()
    return self:GetStackCount()
end


