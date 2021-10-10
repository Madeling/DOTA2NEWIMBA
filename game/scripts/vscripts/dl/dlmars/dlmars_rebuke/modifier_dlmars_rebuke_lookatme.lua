
modifier_dlmars_rebuke_lookatme = class({})

function modifier_dlmars_rebuke_lookatme:IsDebuff()			return true end
function modifier_dlmars_rebuke_lookatme:IsHidden() 			return false end
function modifier_dlmars_rebuke_lookatme:IsPurgable() 		return true end
function modifier_dlmars_rebuke_lookatme:IsPurgeException() 	return true end

function modifier_dlmars_rebuke_lookatme:OnCreated()
	if not IsServer() then return end
	if self:GetParent():IsMagicImmune() then return end

	self:GetParent():Stop()
	self:StartIntervalThink(FrameTime())
end

function modifier_dlmars_rebuke_lookatme:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():IsMagicImmune() then return end

	local fpoint = self:GetAbility():GetCaster():GetAbsOrigin()
	local ppoint = self:GetParent():GetAbsOrigin()
	local direction = (fpoint - ppoint):Normalized()

	self:GetParent():FaceTowards(fpoint)
	self:GetParent():SetForwardVector(direction)
end
