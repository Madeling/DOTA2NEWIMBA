
modifier_dlmars_rebuke_stun = class({})

--不做一个单独的眩晕modi的话，一个是需要无特效，一个是冲击结束需要移除的时候，不会误移除非目标modi

function modifier_dlmars_rebuke_stun:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_dlmars_rebuke_stun:IsDebuff()			return true end
function modifier_dlmars_rebuke_stun:IsHidden() 			return true end
function modifier_dlmars_rebuke_stun:IsPurgable() 			return false end
function modifier_dlmars_rebuke_stun:IsPurgeException() 	return true end     --不知道冲击过程中被强驱什么效果
function modifier_dlmars_rebuke_stun:IsStunDebuff()		return true end
function modifier_dlmars_rebuke_stun:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
