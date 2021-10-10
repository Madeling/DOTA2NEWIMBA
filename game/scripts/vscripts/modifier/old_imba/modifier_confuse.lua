modifier_confuse = class({})

function modifier_confuse:IsDebuff()			return true end
function modifier_confuse:IsHidden() 			return false end
function modifier_confuse:IsPurgable() 			return true end
function modifier_confuse:IsPurgeException() 	return true end
function modifier_confuse:IsConfuse()			return true end
function modifier_confuse:GetEffectName() return "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_stunned.vpcf" end
function modifier_confuse:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_confuse:ShouldUseOverheadOffset() return true end

