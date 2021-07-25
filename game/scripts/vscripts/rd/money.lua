money=class({})

LinkLuaModifier("modifier_money", "rd/money.lua", LUA_MODIFIER_MOTION_NONE)

function money:GetIntrinsicModifierName() 
    return "modifier_money" 
end


modifier_money=class({})

function modifier_money:IsPassive()
	return true
end

function modifier_money:IsPurgable() 			
    return false 
end

function modifier_money:IsPurgeException() 	
    return false 
end

function modifier_money:IsHidden()				
    return true 
end

function modifier_money:AllowIllusionDuplicate() 	
    return false 
end


function modifier_money:DeclareFunctions()
	return 
    {
	    MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_money:OnDeath(tg)
    if IsServer() then 
    	if tg.unit==self:GetParent() and not self:GetParent():IsIllusion() then   
            local gold = RandomInt(1, 399) 
            PlayerResource:ModifyGold(self:GetParent():GetPlayerOwnerID(),gold,false,DOTA_ModifyGold_Unspecified)
            SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_GOLD, self:GetParent(), gold, nil)
        end 
    end
end
