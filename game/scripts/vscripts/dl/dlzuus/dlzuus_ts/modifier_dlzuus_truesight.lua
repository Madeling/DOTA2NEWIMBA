modifier_dlzuus_truesight = class({})

function modifier_dlzuus_truesight:IsHidden() return false end
function modifier_dlzuus_truesight:IsDebuff() return true end
function modifier_dlzuus_truesight:IsStunDebuff() return false end
function modifier_dlzuus_truesight:IsPurgable() return true end

function modifier_dlzuus_truesight:IsAura()
	return self.owner
end

function modifier_dlzuus_truesight:GetModifierAura()
	return "modifier_dlzuus_truesight"
end

function modifier_dlzuus_truesight:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("ts_vision")
end

function modifier_dlzuus_truesight:GetAuraDuration()	--光环粘滞
	return 0.3
end

function modifier_dlzuus_truesight:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_dlzuus_truesight:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_dlzuus_truesight:OnCreated( kv )
	if not IsServer() then return end

	-- check if it is thinker or aura targets
	self.owner = kv.isProvidedByAura~=1
	if not self.owner then return end
end

function modifier_dlzuus_truesight:OnDestroy()
	if not IsServer() then return end

	if self.owner then
		self.owner = nil
		UTIL_Remove( self:GetParent() )
	end
end

function modifier_dlzuus_truesight:CheckState()
	local state = {
		[MODIFIER_STATE_PROVIDES_VISION] = true,
        [MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end
