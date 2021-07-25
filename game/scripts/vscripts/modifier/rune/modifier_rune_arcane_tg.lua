
modifier_rune_arcane_tg = class({})

function modifier_rune_arcane_tg:IsBuff()				
    return true 
end

function modifier_rune_arcane_tg:IsPurgable() 			
    return false 
end

function modifier_rune_arcane_tg:IsPurgeException() 	
    return true 
end

function modifier_rune_arcane_tg:IsHidden()				
    return false 
end

function modifier_rune_arcane_tg:GetTexture() 
    return "rune_arcane" 
end

function modifier_rune_arcane_tg:GetEffectName() 
    return "particles/generic_gameplay/rune_arcane_owner.vpcf" 
end

function modifier_rune_arcane_tg:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_rune_arcane_tg:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MAGICDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT
    }
end

function modifier_rune_arcane_tg:GetModifierMagicDamageOutgoing_Percentage()
    return 40
end  

function modifier_rune_arcane_tg:GetModifierCooldownReduction_Constant()
    return 15
end 