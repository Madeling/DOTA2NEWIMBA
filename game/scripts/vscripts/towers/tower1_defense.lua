tower1_def=class({})
LinkLuaModifier("modifier_tower1_def", "towers/tower1_defense.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower1_def_arua", "towers/tower1_defense.lua", LUA_MODIFIER_MOTION_NONE)

function tower1_def:GetIntrinsicModifierName()
    return "modifier_tower1_def"
end

modifier_tower1_def = class({})


function modifier_tower1_def:IsHidden()
    return false
end

function modifier_tower1_def:IsPurgable()
    return false
end

function modifier_tower1_def:IsPurgeException()
    return false
end

function modifier_tower1_def:IsAura()
    return true
end
function modifier_tower1_def:GetTexture()
    return "tower1_def"
end

function modifier_tower1_def:GetModifierAura()
    return "modifier_tower1_def_arua"
end

function modifier_tower1_def:GetAuraRadius()
    return 2000
end

function modifier_tower1_def:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_tower1_def:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_tower1_def:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end


modifier_tower1_def_arua= class({})

function modifier_tower1_def_arua:IsHidden()
    return false
end


function modifier_tower1_def_arua:IsPurgable()
    return false
end


function modifier_tower1_def_arua:IsPurgeException()
    return false
end
function modifier_tower1_def_arua:GetTexture()
    return "tower1_def"
end

function modifier_tower1_def_arua:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end



function modifier_tower1_def_arua:GetModifierMagicalResistanceBonus()
    return 10
end


function modifier_tower1_def_arua:GetModifierPhysicalArmorBonus()
    return 10
end