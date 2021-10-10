
modifier_dlmars_rebuke_mars = class({})

function modifier_dlmars_rebuke_mars:IsHidden() return true end
function modifier_dlmars_rebuke_mars:IsBuff() return true end
function modifier_dlmars_rebuke_mars:IsDebuff() return false end
function modifier_dlmars_rebuke_mars:IsStunDebuff() return false end
function modifier_dlmars_rebuke_mars:IsPurgable() return false end
function modifier_dlmars_rebuke_mars:IsPurgeException() return false end

function modifier_dlmars_rebuke_mars:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}

	return funcs
end

function modifier_dlmars_rebuke_mars:OnCreated( kv )
	-- references
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "rebuke_damage" )
	self.bonus_crit = self:GetAbility():GetSpecialValueFor( "rebuke_crit" )
end

function modifier_dlmars_rebuke_mars:GetModifierPreAttack_BonusDamagePostCrit( params )
	if not IsServer() then return end
	return self.bonus_damage
end
function modifier_dlmars_rebuke_mars:GetModifierPreAttack_CriticalStrike( params )
	return self.bonus_crit
end
