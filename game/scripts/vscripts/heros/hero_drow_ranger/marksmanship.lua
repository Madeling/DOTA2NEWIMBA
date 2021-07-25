marksmanship=class({})

LinkLuaModifier("modifier_marksmanship", "heros/hero_drow_ranger/marksmanship.lua", LUA_MODIFIER_MOTION_NONE)

function marksmanship:GetIntrinsicModifierName() 
    return "modifier_marksmanship" 
end


modifier_marksmanship=class({})

function modifier_marksmanship:IsPassive()
	return true
end

function modifier_marksmanship:IsDebuff()
	return false
end

function modifier_marksmanship:IsPurgable() 			
    return false 
end

function modifier_marksmanship:IsPurgeException() 	
    return false 
end

function modifier_marksmanship:IsHidden()				
    return true 
end

function modifier_marksmanship:DeclareFunctions()
    return
     {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_marksmanship:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("agility_multiplier")
end

function modifier_marksmanship:GetModifierAttackRangeBonus()
    return self:GetAbility():GetSpecialValueFor("attrg")
end

function modifier_marksmanship:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("sp")
end
