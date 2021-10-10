tower1_watchtower=class({})
LinkLuaModifier("modifier_tower1_watchtower", "towers/tower1_watchtower.lua", LUA_MODIFIER_MOTION_NONE)

function tower1_watchtower:IsHiddenWhenStolen() 
    return false 
end

function tower1_watchtower:IsStealable() 
    return false 
end

function tower1_watchtower:IsNetherWardStealable() 
    return false 
end


function tower1_watchtower:GetIntrinsicModifierName() 
    return "modifier_tower1_watchtower" 
end



modifier_tower1_watchtower = class({})

function modifier_tower1_watchtower:IsBuff()			
    return true 
end

function modifier_tower1_watchtower:IsHidden() 			
    return false 
end

function modifier_tower1_watchtower:IsPurgable() 			
    return false 
end

function modifier_tower1_watchtower:IsPurgeException() 	
    return false 
end

function modifier_tower1_watchtower:GetTexture() 			
    return "tower1_watchtower" 
end

function modifier_tower1_watchtower:OnCreated()
    if 	self:GetAbility()==nil then 
        return 
    end
    self.rd  = self:GetAbility():GetSpecialValueFor("rd")
    self.dur = self:GetAbility():GetSpecialValueFor("dur")
    if not IsServer() then
        return
    end
			self:StartIntervalThink(1)
	
end

function modifier_tower1_watchtower:OnIntervalThink()
    if not  self:GetAbility():IsCooldownReady()  then
		return
    end
    AddFOWViewer(self:GetParent():GetTeamNumber() , self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("rd"), self:GetAbility():GetSpecialValueFor("dur") , false )
    self:GetAbility():UseResources(true, true, true)
end