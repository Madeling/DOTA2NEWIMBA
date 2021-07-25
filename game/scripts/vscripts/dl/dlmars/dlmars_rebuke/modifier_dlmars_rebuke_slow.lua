
modifier_dlmars_rebuke_slow = class({})

function modifier_dlmars_rebuke_slow:IsDebuff()			return true end
function modifier_dlmars_rebuke_slow:IsHidden() 			return false end

function modifier_dlmars_rebuke_slow:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_dlmars_rebuke_slow:GetModifierTurnRate_Percentage()
	return	-200
end

function modifier_dlmars_rebuke_slow:GetModifierMoveSpeedBonus_Percentage()
	return	-50
end
