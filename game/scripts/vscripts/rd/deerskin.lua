deerskin=class({})

LinkLuaModifier("modifier_deerskin", "rd/deerskin.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_deerskin_debuff", "rd/deerskin.lua", LUA_MODIFIER_MOTION_NONE)

function deerskin:GetIntrinsicModifierName() 
    return "modifier_deerskin" 
end


modifier_deerskin=class({})

function modifier_deerskin:IsPassive()
	return true
end

function modifier_deerskin:IsPurgable() 			
    return false 
end

function modifier_deerskin:IsPurgeException() 	
    return false 
end

function modifier_deerskin:IsHidden()				
    return true 
end

function modifier_deerskin:AllowIllusionDuplicate() 	
    return false 
end

function modifier_deerskin:DeclareFunctions()
	return 
    {
	    MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_deerskin:OnAttackLanded(tg)
    if IsServer() then 
        if tg.target==self:GetParent() and tg.attacker~=self:GetParent() and not tg.attacker:IsMagicImmune() then    
            tg.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_deerskin_debuff", {duration=self:GetAbility():GetSpecialValueFor("dur")})
        end  
    end
end


modifier_deerskin_debuff=class({})

function modifier_deerskin_debuff:IsDebuff() 			
    return true 
end

function modifier_deerskin_debuff:IsPurgable() 			
    return false 
end

function modifier_deerskin_debuff:IsPurgeException() 	
    return false 
end

function modifier_deerskin_debuff:IsHidden()				
    return false 
end

function modifier_deerskin_debuff:OnCreated()		
    local sp=self:GetAbility():GetSpecialValueFor("attsp")	
    local max=self:GetAbility():GetSpecialValueFor("max")		
    if IsServer() then   
        self:SetStackCount(sp>=max and max or self:GetStackCount()+sp)
    end 
end

function modifier_deerskin_debuff:OnRefresh()				
    self:OnCreated()
end

function modifier_deerskin_debuff:DeclareFunctions()
	return 
    {
	    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_deerskin_debuff:GetModifierAttackSpeedBonus_Constant()
    return 0-self:GetStackCount()
end


