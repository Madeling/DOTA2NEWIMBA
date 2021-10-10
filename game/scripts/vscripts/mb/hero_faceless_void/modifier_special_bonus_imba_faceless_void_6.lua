--------------------------------------------------------------
modifier_special_bonus_imba_faceless_void_6 = class({})

function modifier_special_bonus_imba_faceless_void_6:IsDebuff()			return false end
function modifier_special_bonus_imba_faceless_void_6:IsHidden() 		return true end
function modifier_special_bonus_imba_faceless_void_6:IsPurgable() 		return false end
function modifier_special_bonus_imba_faceless_void_6:IsPurgeException() 	return false end
function modifier_special_bonus_imba_faceless_void_6:OnCreated() end
function modifier_special_bonus_imba_faceless_void_6:DeclareFunctions()	return {MODIFIER_EVENT_ON_RESPAWN,MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT} end
--[[function modifier_special_bonus_imba_faceless_void_6:OnRespawn( keys )
	if IsServer() and keys.unit == self:GetParent() then
		IncreaseAttackSpeedCap(self:GetParent(), self:GetParent():TG_GetTalentValue("special_bonus_imba_faceless_void_6")) 
	end
end]]

function modifier_special_bonus_imba_faceless_void_6:GetModifierBaseAttackTimeConstant()
	return 1.5
end