modifier_rune_doubledamage_tg = class({})

function modifier_rune_doubledamage_tg:IsBuff()				
    return true 
end

function modifier_rune_doubledamage_tg:IsPurgable() 			
    return false 
end

function modifier_rune_doubledamage_tg:IsPurgeException() 	
    return true 
end

function modifier_rune_doubledamage_tg:IsHidden()				
    return false 
end

function modifier_rune_doubledamage_tg:GetTexture() 
    return "rune_doubledamage" 
end

function modifier_rune_doubledamage_tg:GetEffectName() 
    return "particles/generic_gameplay/rune_doubledamage_owner.vpcf" 
end

function modifier_rune_doubledamage_tg:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_rune_doubledamage_tg:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end

function modifier_rune_doubledamage_tg:GetModifierTotalDamageOutgoing_Percentage()
    return 70
end  