
modifier_oldtroll_rangeaxe_debuff = class({})

function modifier_oldtroll_rangeaxe_debuff:IsHidden() return false end
function modifier_oldtroll_rangeaxe_debuff:IsPurgable() return true end
function modifier_oldtroll_rangeaxe_debuff:IsPurgeException() return true end

function modifier_oldtroll_rangeaxe_debuff:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_oldtroll_rangeaxe_debuff:GetModifierMoveSpeedBonus_Percentage()

    return 0 - self:GetAbility():GetSpecialValueFor("rangeaxe_slow")

end
