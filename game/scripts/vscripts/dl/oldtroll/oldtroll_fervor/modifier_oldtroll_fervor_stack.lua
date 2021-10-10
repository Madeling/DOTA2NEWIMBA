
modifier_oldtroll_fervor_stack = class({})

function modifier_oldtroll_fervor_stack:IsHidden() return false end
function modifier_oldtroll_fervor_stack:IsBuff() return true end
function modifier_oldtroll_fervor_stack:IsDebuff() return false end
function modifier_oldtroll_fervor_stack:IsStunDebuff() return false end
function modifier_oldtroll_fervor_stack:IsPurgable() return false end
function modifier_oldtroll_fervor_stack:IsPurgeException() return false end

function modifier_oldtroll_fervor_stack:OnCreated()
    if not IsServer() then return end
    local caster = self:GetParent()

    self:SetStackCount(1)

end

function modifier_oldtroll_fervor_stack:OnRefresh()
    if not IsServer() then return end

    self:IncrementStackCount()

end


function modifier_oldtroll_fervor_stack:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}

	return funcs
end

function modifier_oldtroll_fervor_stack:GetModifierAttackSpeedBonus_Constant()
    local aspeed = self:GetAbility():GetSpecialValueFor("fervor_aspeed") + self:GetCaster():TG_GetTalentValue("special_bonus_dlnec_15l")
    return self:GetStackCount()*aspeed
end

function modifier_oldtroll_fervor_stack:GetModifierBaseAttackTimeConstant()
    local bat = self:GetAbility():GetSpecialValueFor("fervor_bat")
    local newbat = 1.6 - self:GetStackCount()*bat
    if newbat < 0.1 then newbat = 0.1 end
    return newbat
end
