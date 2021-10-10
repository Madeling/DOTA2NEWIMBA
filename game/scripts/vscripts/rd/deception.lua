deception=class({})

LinkLuaModifier("modifier_deception", "rd/deception.lua", LUA_MODIFIER_MOTION_NONE)

function deception:GetIntrinsicModifierName() 
    return "modifier_deception" 
end

modifier_deception=class({})

function modifier_deception:IsPurgable() 			
    return false 
end

function modifier_deception:IsPurgeException() 	
    return false 
end

function modifier_deception:IsHidden()				
    return true 
end

function modifier_deception:AllowIllusionDuplicate()				
    return false 
end

function modifier_deception:DeclareFunctions()
	return 
    {
	    MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_deception:OnDeath(tg)
    if IsServer() then 
    	if tg.unit==self:GetParent() and not self:GetParent():IsIllusion() then   
            local id=self:GetParent():GetPlayerOwnerID()
            PlayerResource:IncrementKills(id,id)
            PlayerResource:IncrementAssists(id,id)
        end 
    end
end

