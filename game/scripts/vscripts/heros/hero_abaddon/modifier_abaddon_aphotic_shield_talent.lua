modifier_abaddon_aphotic_shield_talent=class({})

function modifier_abaddon_aphotic_shield_talent:IsPurgable() 			
    return false 
end

function modifier_abaddon_aphotic_shield_talent:IsPurgeException() 	
    return false 
end

function modifier_abaddon_aphotic_shield_talent:IsHidden()				
    return true 
end

function modifier_abaddon_aphotic_shield_talent:OnCreated(tg)
    if IsServer() then			
        local ab=self:GetParent():FindAbilityByName("aphotic_shield")	
        if ab and ab:GetLevel()>0 then 
            AbilityChargeController:ChangeChargeAbilityConfig(ab, ab:GetCooldown(ab:GetLevel()), 1+self:GetParent():TG_GetTalentValue("special_bonus_abaddon_6"), 1, true, true)
        end
    end
end