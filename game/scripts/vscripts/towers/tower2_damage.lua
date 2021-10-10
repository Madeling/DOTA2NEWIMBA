tower2_damage=class({})
LinkLuaModifier("modifier_tower2_damage", "towers/tower2_damage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower2_damage_arua", "towers/tower2_damage.lua", LUA_MODIFIER_MOTION_NONE)
function tower2_damage:IsHiddenWhenStolen() 
    return false 
end

function tower2_damage:IsStealable() 
    return false 
end

function tower2_damage:IsNetherWardStealable() 
    return false 
end


function tower2_damage:GetIntrinsicModifierName() 
    return "modifier_tower2_damage" 
end

modifier_tower2_damage = class({})

function modifier_tower2_damage:IsHidden() 			
    return false 
end

function modifier_tower2_damage:IsPurgable() 			
    return false 
end

function modifier_tower2_damage:IsPurgeException() 	
    return false 
end

function modifier_tower2_damage:GetTexture() 			
    return "tower2_damage" 
end


function modifier_tower2_damage:IsAura() 
    return true 
end

function modifier_tower2_damage:GetModifierAura() 
    return "modifier_tower2_damage_arua" 
end

function modifier_tower2_damage:GetAuraRadius() 
        return 1000
end

function modifier_tower2_damage:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_tower2_damage:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_tower2_damage:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO
end


modifier_tower2_damage_arua= class({})

function modifier_tower2_damage_arua:IsDeuff()			
    return true 
end


function modifier_tower2_damage_arua:IsHidden() 			
    return false 
end


function modifier_tower2_damage_arua:IsPurgable() 			
    return false 
end


function modifier_tower2_damage_arua:IsPurgeException() 	
    return false 
end

function modifier_tower2_damage_arua:GetTexture() 			
    return "tower2_damage" 
end

function modifier_tower2_damage_arua:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end


function modifier_tower2_damage_arua:GetModifierIncomingDamage_Percentage() 	
    return 30
end

