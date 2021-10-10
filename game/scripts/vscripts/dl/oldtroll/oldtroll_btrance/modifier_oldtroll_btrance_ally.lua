
modifier_oldtroll_btrance_ally = class({})

function modifier_oldtroll_btrance_ally:IsHidden() return false end
function modifier_oldtroll_btrance_ally:IsBuff() return true end
function modifier_oldtroll_btrance_ally:IsDebuff() return false end
function modifier_oldtroll_btrance_ally:IsStunDebuff() return false end
function modifier_oldtroll_btrance_ally:IsPurgable() return true end

function modifier_oldtroll_btrance_ally:GetEffectName() return "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf" end
function modifier_oldtroll_btrance_ally:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_oldtroll_btrance_ally:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_oldtroll_btrance_ally:GetModifierAttackSpeedBonus_Constant()
    if self:GetAbility() then 
        return self:GetAbility():GetSpecialValueFor("btrance_aspeed")
    end 
    return 0
end
