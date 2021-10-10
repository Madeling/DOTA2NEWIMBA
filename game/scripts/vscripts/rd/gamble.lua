gamble=class({})

LinkLuaModifier("modifier_gamble_buff", "rd/gamble.lua", LUA_MODIFIER_MOTION_NONE)

function gamble:GetIntrinsicModifierName() 
    return "modifier_gamble" 
end


modifier_gamble=class({})

function modifier_gamble:IsPassive()
	return true
end

function modifier_gamble:IsPurgable() 			
    return false 
end

function modifier_gamble:IsPurgeException() 	
    return false 
end

function modifier_gamble:IsHidden()				
    return true 
end

function modifier_gamble:AllowIllusionDuplicate() 	
    return false 
end



