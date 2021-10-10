
modifier_oldsky_cshot_slow = class({})

function modifier_oldsky_cshot_slow:IsDebuff()			return true end
function modifier_oldsky_cshot_slow:IsHidden() 			return false end
function modifier_oldsky_cshot_slow:IsPurgable() 		return true end
function modifier_oldsky_cshot_slow:IsPurgeException() 	return true end
function modifier_oldsky_cshot_slow:GetEffectName() return "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot_slow_debuff.vpcf" end
function modifier_oldsky_cshot_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_oldsky_cshot_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_oldsky_cshot_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("cshot_slowpercent")) end
