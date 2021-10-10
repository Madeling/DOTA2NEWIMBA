
modifier_oldtroll_meleeaxe_debuff = class({})

function modifier_oldtroll_meleeaxe_debuff:IsHidden() return false end
function modifier_oldtroll_meleeaxe_debuff:IsPurgable() return true end
function modifier_oldtroll_meleeaxe_debuff:IsPurgeException() return true end

function modifier_oldtroll_meleeaxe_debuff:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}

	return funcs
end

function modifier_oldtroll_meleeaxe_debuff:GetModifierMiss_Percentage() return self:GetAbility():GetSpecialValueFor("meleeaxe_miss") end
