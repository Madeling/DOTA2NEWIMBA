
modifier_rune_haste_tg = class({})

function modifier_rune_haste_tg:IsBuff()				
    return true 
end

function modifier_rune_haste_tg:IsPurgable() 			
    return false 
end

function modifier_rune_haste_tg:IsPurgeException() 	
    return true 
end

function modifier_rune_haste_tg:IsHidden()				
    return false 
end

function modifier_rune_haste_tg:GetTexture() 
    return "rune_haste" 
end

function modifier_rune_haste_tg:GetEffectName() 
    return "particles/generic_gameplay/rune_haste_owner.vpcf" 
end

function modifier_rune_haste_tg:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_rune_haste_tg:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT
    }
end

function modifier_rune_haste_tg:GetModifierMoveSpeedBonus_Percentage()
    return 100
end  

function modifier_rune_haste_tg:GetModifierMoveSpeed_Limit()
    return 99999
end

function modifier_rune_haste_tg:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_rune_haste_tg:CheckState()
    return
    {
           [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
   }
end