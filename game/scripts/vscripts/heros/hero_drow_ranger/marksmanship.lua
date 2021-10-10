marksmanship=class({})

LinkLuaModifier("modifier_marksmanship", "heros/hero_drow_ranger/marksmanship.lua", LUA_MODIFIER_MOTION_NONE)

function marksmanship:GetIntrinsicModifierName()
    return "modifier_marksmanship"
end

function marksmanship:OnSpellStart()
    local caster=self:GetCaster()
    local curpos=self:GetCursorPosition()
    local casterpos=caster:GetAbsOrigin()
    local dur=self:GetSpecialValueFor("dur")
    local time=TG_Distance(curpos,casterpos)/2000
    caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2,3)
    EmitSoundOn("Hero_DrowRanger.FrostArrows", caster)
    local fx = ParticleManager:CreateParticle("particles/tgp/drow/drow_m0.vpcf", PATTACH_CUSTOMORIGIN, nil)
                ParticleManager:SetParticleControl(fx, 0, casterpos)
                ParticleManager:SetParticleControl(fx, 1, curpos)
                ParticleManager:SetParticleControl(fx, 2, Vector(2000, 0, 0))
                Timers:CreateTimer(time, function()
                    ParticleManager:DestroyParticle(fx,true)
                    ParticleManager:ReleaseParticleIndex(fx)
                    AddFOWViewer(caster:GetTeamNumber(), curpos, self:GetSpecialValueFor("rd"), dur, false)
                    CreateModifierThinker(caster, self, "modifier_truesight_f", {duration=dur}, curpos, caster:GetTeamNumber(), false)
                    EmitSoundOn("Hero_Clinkz.SearingArrows.Impact", caster)
                    local fx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_drow/drow_shard_hypo_blast.vpcf", PATTACH_CUSTOMORIGIN, nil)
                                ParticleManager:SetParticleControl(fx1, 0, curpos)
                                ParticleManager:SetParticleControl(fx1, 1, curpos)
                                ParticleManager:SetParticleControl(fx1, 3, curpos)
                                ParticleManager:ReleaseParticleIndex(fx1)
                    local fx2 = ParticleManager:CreateParticle("particles/tgp/drow/drow_circle_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
                                ParticleManager:SetParticleControl(fx2, 0, curpos)
                                ParticleManager:SetParticleControl(fx2, 1, Vector(self:GetSpecialValueFor("rd"),0,0))
                                ParticleManager:SetParticleControl(fx2, 2, Vector(dur,0,0))
                                ParticleManager:ReleaseParticleIndex(fx2)
                                caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
                    return nil
                  end)
end

modifier_marksmanship=class({})

function modifier_marksmanship:IsPassive()
	return true
end

function modifier_marksmanship:IsDebuff()
	return false
end

function modifier_marksmanship:IsPurgable()
    return false
end

function modifier_marksmanship:IsPurgeException()
    return false
end

function modifier_marksmanship:IsHidden()
    return true
end

function modifier_marksmanship:DeclareFunctions()
    return
     {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_marksmanship:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("agility_multiplier")
end

function modifier_marksmanship:GetModifierAttackRangeBonus()
    return self:GetAbility():GetSpecialValueFor("attrg")
end

function modifier_marksmanship:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("sp")
end
