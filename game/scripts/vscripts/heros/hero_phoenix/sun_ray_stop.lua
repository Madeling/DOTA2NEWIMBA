sun_ray_stop=class({})

function sun_ray_stop:IsHiddenWhenStolen() 
    return false 
end

function sun_ray_stop:IsStealable() 
    return false 
end


function sun_ray_stop:IsRefreshable() 			
    return true 
end

function sun_ray_stop:GetAssociatedPrimaryAbilities() 
    return "sun_ray" 
end

function sun_ray_stop:OnSpellStart()
    local caster=self:GetCaster()
    TG_Remove_Modifier(caster,"modifier_sun_ray_buff",0)
end