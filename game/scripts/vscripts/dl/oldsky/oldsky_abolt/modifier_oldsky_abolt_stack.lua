
modifier_oldsky_abolt_stack = class({})

function modifier_oldsky_abolt_stack:IsHidden() return false end
function modifier_oldsky_abolt_stack:IsBuff() return true end
function modifier_oldsky_abolt_stack:IsDebuff() return false end
function modifier_oldsky_abolt_stack:IsStunDebuff() return false end
function modifier_oldsky_abolt_stack:IsPurgable() return false end
function modifier_oldsky_abolt_stack:IsPurgeException() return false end

function modifier_oldsky_abolt_stack:OnCreated()
    if not IsServer() then return end
    local caster = self:GetParent()

    self:SetStackCount(1)

end

function modifier_oldsky_abolt_stack:OnRefresh()
    if not IsServer() then return end

    self:IncrementStackCount()

end

function modifier_oldsky_abolt_stack:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return funcs
end

function modifier_oldsky_abolt_stack:GetModifierBonusStats_Intellect()
    return (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("abolt_stackint"))
end
