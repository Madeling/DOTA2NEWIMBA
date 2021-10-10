modifier_special_bonus_imba_spirit_breaker_8=class({})
--LinkLuaModifier("modifier_special_bonus_imba_spirit_breaker_8", "heros/linken/modifier_hero_void_spirit.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_special_bonus_imba_spirit_breaker_8:IsHidden() 			
	return true 
end

function modifier_special_bonus_imba_spirit_breaker_8:IsPurgable() 		
	return false 
end

function modifier_special_bonus_imba_spirit_breaker_8:IsPurgeException() 	
	return false 
end

function modifier_special_bonus_imba_spirit_breaker_8:RemoveOnDeath() 	
	return false 
end
function modifier_special_bonus_imba_spirit_breaker_8:OnCreated()
	if not IsServer() then return end
end
function modifier_special_bonus_imba_spirit_breaker_8:DeclareFunctions()
	return 
		{
			MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		}
end

function modifier_special_bonus_imba_spirit_breaker_8:GetModifierBaseAttackTimeConstant()
	return self:GetParent():TG_GetTalentValue("special_bonus_imba_spirit_breaker_8")
end