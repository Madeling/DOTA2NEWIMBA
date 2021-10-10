swift_slash2=class({})

function swift_slash2:IsHiddenWhenStolen()
    return false
end

function swift_slash2:IsStealable()
    return true
end


function swift_slash2:IsRefreshable()
    return true
end

function swift_slash2:GetCooldown(iLevel)
    return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_juggernaut_6")
end

function swift_slash2:GetCastPoint()
    if self:GetCaster():TG_HasTalent("special_bonus_juggernaut_8") then
        return 0
    else
        return 0.3
    end
end

function swift_slash2:OnSpellStart()
    local caster=self:GetCaster()
    local target=self:GetCursorTarget()
    local tpos=target:GetAbsOrigin()
    local cpos=caster:GetAbsOrigin()
    local att_num=self:GetSpecialValueFor("att")
    local num=0
    caster:EmitSound("TG.jugginv")
    Timers:CreateTimer(0, function()
        target:EmitSound("DOTA_Item.AbyssalBlade.Activate")
        local fx2 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt.vpcf", PATTACH_CUSTOMORIGIN,target)
        ParticleManager:SetParticleControl(fx2, 0,Vector(tpos.x+RandomInt(-700,700),tpos.y+RandomInt(-700,700),tpos.z+1000))
        ParticleManager:SetParticleControl(fx2, 1,tpos)
        ParticleManager:ReleaseParticleIndex(fx2)
        caster:PerformAttack(target, true, true, true, false, true, false, false)
        num=num+1
        if num>=att_num then
            return nil
        else
            return 0.1
        end
    end)
    FindClearSpaceForUnit( caster, tpos, true )
    caster:MoveToTargetToAttack(target)
end
