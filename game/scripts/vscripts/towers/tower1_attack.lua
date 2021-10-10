tower1_att=class({})
LinkLuaModifier("modifier_tower1_att", "towers/tower1_attack.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower1_att_arua", "towers/tower1_attack.lua", LUA_MODIFIER_MOTION_NONE)
function tower1_att:GetIntrinsicModifierName() 
    return "modifier_tower1_att" 
end


modifier_tower1_att = class({})


function modifier_tower1_att:IsHidden() 			
    return false 
end

function modifier_tower1_att:IsPurgable() 			
    return false 
end

function modifier_tower1_att:IsPurgeException() 	
    return false 
end

function modifier_tower1_att:GetTexture() 			
    return "tower1_att" 
end


function modifier_tower1_att:IsAura() 
    return true 
end


function modifier_tower1_att:GetModifierAura() 
    return "modifier_tower1_att_arua" 
end

function modifier_tower1_att:GetAuraRadius() 
    return 2000
end

function modifier_tower1_att:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_tower1_att:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function modifier_tower1_att:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO
end


modifier_tower1_att_arua= class({})

function modifier_tower1_att_arua:IsBuff()			
    return true 
end

function modifier_tower1_att_arua:IsHidden() 			
    return false 
end

function modifier_tower1_att_arua:IsPurgable() 			
    return false 
end

function modifier_tower1_att_arua:IsPurgeException() 	
    return false 
end

function modifier_tower1_att_arua:GetTexture() 			
    return "tower1_att" 
end


function modifier_tower1_att_arua:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_tower1_att_arua:GetModifierAttackSpeedBonus_Constant() 	
    return  35
end

function modifier_tower1_att_arua:GetModifierPreAttack_BonusDamage() 	
    return  30
end