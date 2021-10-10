wild_axes=class({})

function wild_axes:IsHiddenWhenStolen() 
    return false 
end

function wild_axes:IsStealable() 
    return true 
end


function wild_axes:IsRefreshable() 			
    return true 
end

function wild_axes:OnSpellStart()
	local cur_pos=self:GetCursorPosition()
    local caster=self:GetCaster() 
    local caster_pos=caster:GetAbsOrigin()
    local dir=TG_Direction(cur_pos,caster_pos)
    local radius=self:GetSpecialValueFor("radius")
    local spread=self:GetSpecialValueFor("spread")
    local range=self:GetSpecialValueFor("range")
    local axe_damage=self:GetSpecialValueFor("axe_damage")
    local duration=self:GetSpecialValueFor("duration")

end
