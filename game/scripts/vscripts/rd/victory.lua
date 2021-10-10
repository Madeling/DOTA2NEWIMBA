victory=class({})

LinkLuaModifier("modifier_victory", "rd/victory.lua", LUA_MODIFIER_MOTION_NONE)

function victory:GetIntrinsicModifierName() 
    return "modifier_victory" 
end


modifier_victory=class({})

function modifier_victory:IsPassive()
	return true
end

function modifier_victory:IsPurgable() 			
    return false 
end

function modifier_victory:IsPurgeException() 	
    return false 
end

function modifier_victory:IsHidden()				
    return true 
end

function modifier_victory:AllowIllusionDuplicate() 	
    return false 
end