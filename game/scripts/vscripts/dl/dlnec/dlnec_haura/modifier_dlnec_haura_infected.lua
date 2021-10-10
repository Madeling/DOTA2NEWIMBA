
modifier_dlnec_haura_infected = class({})

function modifier_dlnec_haura_infected:IsHidden() return false end
function modifier_dlnec_haura_infected:IsBuff() return false end
function modifier_dlnec_haura_infected:IsDebuff() return true end
function modifier_dlnec_haura_infected:IsStunDebuff() return false end
function modifier_dlnec_haura_infected:IsPurgable() return true end
function modifier_dlnec_haura_infected:IsPurgeException() return true end
function modifier_dlnec_haura_infected:GetEffectName() return "particles/units/heroes/hero_pudge/pudge_swallow_overhead_icon.vpcf" end
function modifier_dlnec_haura_infected:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_dlnec_haura_infected:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

function modifier_dlnec_haura_infected:GetModifierMoveSpeedBonus_Percentage()
    if not self or not self:GetAbility() then return end    --防止幻象报错，虽然最后直接幻象不继承了

    local speedloss_infected_percent = self:GetAbility():GetSpecialValueFor("haura_speedloss_infected_percent")
    local speedloss = -1*speedloss_infected_percent

    return speedloss
end

function modifier_dlnec_haura_infected:GetModifierMagicalResistanceBonus()
    if not self or not self:GetAbility() then return end    --防止幻象报错，虽然最后幻象不继承了

    local mrloss = self:GetAbility():GetSpecialValueFor("haura_mrloss_infected")*-1

    return mrloss
end
