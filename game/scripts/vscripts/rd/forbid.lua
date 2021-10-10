forbid=class({})
LinkLuaModifier("modifier_forbid", "rd/forbid.lua", LUA_MODIFIER_MOTION_NONE)
function forbid:IsHiddenWhenStolen() 
    return false 
end

function forbid:IsStealable() 
    return true 
end


function forbid:IsRefreshable() 			
    return true 
end

function forbid:OnSpellStart()
    local cur_tar=self:GetCursorTarget()
    local caster=self:GetCaster() 
    cur_tar:AddNewModifier(caster,self, "modifier_forbid", {duration=self:GetSpecialValueFor("dur")})
end

modifier_forbid=class({})

function modifier_forbid:IsPurgable() 			
    return false 
end

function modifier_forbid:IsPurgeException() 	
    return false 
end

function modifier_forbid:IsHidden()				
    return false 
end

function modifier_forbid:RemoveOnDeath()				
    return false 
end

function modifier_forbid:AllowIllusionDuplicate()				
    return false 
end

function modifier_forbid:DeclareFunctions()
	return 	
    {
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
	}
end


function modifier_forbid:GetModifierPercentageExpRateBoost()
	return -100
end
