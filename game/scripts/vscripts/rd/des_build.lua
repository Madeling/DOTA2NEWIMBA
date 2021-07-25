des_build=class({})

LinkLuaModifier("modifier_des_build", "rd/des_build.lua", LUA_MODIFIER_MOTION_NONE)

function des_build:GetIntrinsicModifierName() 
    return "modifier_des_build" 
end


modifier_des_build=class({})

function modifier_des_build:IsPassive()
	return true
end

function modifier_des_build:IsPurgable() 			
    return false 
end

function modifier_des_build:IsPurgeException() 	
    return false 
end

function modifier_des_build:IsHidden()				
    return true 
end

function modifier_des_build:AllowIllusionDuplicate() 	
    return false 
end


function modifier_des_build:DeclareFunctions()
	return 
    {
	    MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_des_build:OnDeath(tg)
    if IsServer() then 
    	if tg.attacker==self:GetParent() and tg.unit:IsBuilding() then   
            local gold = self:GetParent():GetLevel()*self:GetAbility():GetSpecialValueFor("gold")	
            PlayerResource:ModifyGold(self:GetParent():GetPlayerOwnerID(),gold,false,DOTA_ModifyGold_Building)
            SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_GOLD, self:GetParent(), gold, nil)
            GameRules:SpawnAndReleaseCreeps()
        end 
    end
end