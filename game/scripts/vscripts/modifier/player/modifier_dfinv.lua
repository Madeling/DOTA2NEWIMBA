modifier_dfinv=class({})

function modifier_dfinv:IsHidden()
    return true
end

function modifier_dfinv:IsPurgable()
    return false
end

function modifier_dfinv:IsPurgeException()
    return false
end

function modifier_dfinv:GetModifierIncomingDamage_Percentage(tg)
    if tg.target~=self:GetParent() then
		return  0
	end
     return  -100
end

function modifier_dfinv:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
