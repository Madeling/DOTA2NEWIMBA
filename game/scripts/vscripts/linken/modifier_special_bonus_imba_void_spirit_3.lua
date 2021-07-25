modifier_special_bonus_imba_void_spirit_3=class({})
--LinkLuaModifier("modifier_special_bonus_imba_void_spirit_3", "heros/linken/modifier_hero_void_spirit.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_special_bonus_imba_void_spirit_3:IsHidden() 			
	return true 
end

function modifier_special_bonus_imba_void_spirit_3:IsPurgable() 		
	return false 
end

function modifier_special_bonus_imba_void_spirit_3:IsPurgeException() 	
	return false 
end

function modifier_special_bonus_imba_void_spirit_3:RemoveOnDeath() 	
	return false 
end

function modifier_special_bonus_imba_void_spirit_3:OnCreated()
	if not IsServer() then return end
	local ability = self:GetParent():FindAbilityByName("imba_void_spirit_astral_step")
	if ability then
		AbilityChargeController:AbilityChargeInitialize(ability, ability:GetCooldown(4 - 1), self:GetParent():TG_GetTalentValue("special_bonus_imba_void_spirit_3"), 1, true, true)
	end
end

function modifier_special_bonus_imba_void_spirit_3:OnRefresh()
	self:OnCreated()
end