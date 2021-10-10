modifier_veteran_sp=class({})
function modifier_veteran_sp:IsHidden()
    return false
end
function modifier_veteran_sp:IsPurgable()
    return false
end
function modifier_veteran_sp:IsPurgeException()
    return false
end
function modifier_veteran_sp:AllowIllusionDuplicate()
    return false
end
function modifier_veteran_sp:GetTexture()
    return "reborn"
end
function modifier_veteran_sp:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end
function modifier_veteran_sp:GetModifierMoveSpeedBonus_Percentage()
        return 15
end