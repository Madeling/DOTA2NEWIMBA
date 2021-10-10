untransform=class({})
function untransform:IsHiddenWhenStolen()
    return false
end

function untransform:IsStealable()
    return true
end

function untransform:IsRefreshable()
    return true
end

function untransform:Set_InitialUpgrade(tg)
    return {LV=1}
end

function untransform:GetAssociatedPrimaryAbilities()
    return "mischief"
end



function untransform:OnSpellStart()
    local caster=self:GetCaster()
    caster:EmitSound("Hero_MonkeyKing.Transform.Off")
    if caster:HasAbility("mischief") then
        if caster:HasModifier("modifier_mischief_buff") then
            caster:RemoveModifierByName("modifier_mischief_buff")
            return
        end
        caster:MK()
    end
end