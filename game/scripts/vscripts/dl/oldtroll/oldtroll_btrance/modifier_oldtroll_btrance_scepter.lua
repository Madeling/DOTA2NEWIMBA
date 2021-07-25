
modifier_oldtroll_btrance_scepter = class({})

function modifier_oldtroll_btrance_scepter:IsHidden() return false end
function modifier_oldtroll_btrance_scepter:IsBuff() return true end
function modifier_oldtroll_btrance_scepter:IsDebuff() return false end
function modifier_oldtroll_btrance_scepter:IsStunDebuff() return false end
function modifier_oldtroll_btrance_scepter:IsPurgable() return true end

function modifier_oldtroll_btrance_scepter:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}

	return funcs
end

function modifier_oldtroll_btrance_scepter:GetModifierBaseAttackTimeConstant()
    local bat = self:GetAbility():GetSpecialValueFor("btrance_bat")
    local newbat = 1.7 - bat
    if newbat < 0.04 then newbat = 0.04 end
    return newbat
end
