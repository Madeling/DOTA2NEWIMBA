modifier_special_bonus_imba_antimage_1=class({})
function modifier_special_bonus_imba_antimage_1:IsHidden() 			
	return true 
end

function modifier_special_bonus_imba_antimage_1:IsPurgable() 		
	return false 
end

function modifier_special_bonus_imba_antimage_1:IsPurgeException() 	
	return false 
end

function modifier_special_bonus_imba_antimage_1:RemoveOnDeath() 	
	return false 
end
function modifier_special_bonus_imba_antimage_1:OnCreated()
	if IsServer() then
		local ability = self:GetParent():FindAbilityByName("imba_antimage_blink")
		if ability then
			AbilityChargeController:AbilityChargeInitialize(ability, ability:GetCooldown(4), self:GetParent():TG_GetTalentValue("special_bonus_imba_antimage_1"), 1, true, true)
		end
	end
end

function modifier_special_bonus_imba_antimage_1:OnRefresh()
	self:OnCreated()
end