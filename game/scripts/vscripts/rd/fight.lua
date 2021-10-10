fight=class({})

LinkLuaModifier("modifier_fight", "rd/fight.lua", LUA_MODIFIER_MOTION_NONE)

function fight:GetIntrinsicModifierName() 
    return "modifier_fight" 
end


modifier_fight=class({})

function modifier_fight:IsPassive()
	return true
end

function modifier_fight:IsPurgable() 			
    return false 
end

function modifier_fight:IsPurgeException() 	
    return false 
end

function modifier_fight:IsHidden()				
    return true 
end

function modifier_fight:AllowIllusionDuplicate() 	
    return false 
end


function modifier_fight:DeclareFunctions()
	return 
    {
	    MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_fight:OnAttackLanded(tg)
    if IsServer() then 
        if tg.target~=self:GetParent() and tg.attacker==self:GetParent() and  tg.target:IsRealHero() then    
            local gold1 = self:GetAbility():GetSpecialValueFor("gold2")
            PlayerResource:ModifyGold(self:GetParent():GetPlayerOwnerID(),gold1,false,DOTA_ModifyGold_Unspecified)
            SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_GOLD, self:GetParent(), gold1, nil)
            ----
            local gold2 = self:GetAbility():GetSpecialValueFor("gold1")
            PlayerResource:ModifyGold(tg.target:GetPlayerOwnerID(), (0 - gold2), false, DOTA_ModifyGold_Unspecified)
            PopupNumbers(tg.target, "gold", Vector(255, 200, 33), 1.0,gold2, 1)
        end  
    end
end