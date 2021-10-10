tower3_fastatt=class({})
LinkLuaModifier("modifier_tower3_fastatt", "towers/tower3_fastatt.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower3_fastatt2", "towers/tower3_fastatt.lua", LUA_MODIFIER_MOTION_NONE)


function tower3_fastatt:GetIntrinsicModifierName() 
    return "modifier_tower3_fastatt" 
end

modifier_tower3_fastatt = class({})

function modifier_tower3_fastatt:IsHidden() 			
    return false 
end

function modifier_tower3_fastatt:IsPurgable() 			
    return false 
end

function modifier_tower3_fastatt:IsPurgeException() 	
    return false 
end
function modifier_tower3_fastatt:GetTexture() 			
    return "tower3_fastatt" 
end
function modifier_tower3_fastatt:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_tower3_fastatt:GetModifierAttackSpeedBonus_Constant() 	
    return 300
end