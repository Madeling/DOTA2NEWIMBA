crippling_fear = class({})
LinkLuaModifier("modifier_crippling_fear", "heros/hero_night_stalker/crippling_fear.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_crippling_fear_debuff", "heros/hero_night_stalker/crippling_fear.lua", LUA_MODIFIER_MOTION_NONE)
function crippling_fear:IsHiddenWhenStolen()
    return false
end

function crippling_fear:IsStealable()
    return true
end

function crippling_fear:IsRefreshable()
    return true
end

function crippling_fear:OnSpellStart()
    local caster=self:GetCaster()
    local dur_d=self:GetSpecialValueFor("dur_d")
    local dur_n=self:GetSpecialValueFor("dur_n")
    local rd=self:GetSpecialValueFor("rd")+caster:GetCastRangeBonus()
    local dur=0
    if caster:IsAlive() then
        caster:EmitSound("Hero_Nightstalker.Trickling_Fear")
        if not GameRules:IsDaytime() or GameRules:IsNightstalkerNight()  then
            dur=dur_n
        else
            dur=dur_d
        end
        caster:AddNewModifier(caster, self, "modifier_crippling_fear", {duration = dur+caster:TG_GetTalentValue("special_bonus_night_stalker_2"),rd=rd})
    end
end

modifier_crippling_fear=class({})


function modifier_crippling_fear:IsHidden()
	return false
end

function modifier_crippling_fear:IsPurgable()
	return false
end

function modifier_crippling_fear:IsPurgeException()
	return false
end

function modifier_crippling_fear:RemoveOnDeath()
    return true
end

function modifier_crippling_fear:IsAura()
    return true
end

function modifier_crippling_fear:GetModifierAura()
    return "modifier_crippling_fear_debuff"
end

function modifier_crippling_fear:GetAuraRadius()
    return self.rd
end
function modifier_crippling_fear:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_crippling_fear:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_crippling_fear:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_crippling_fear:OnCreated(tg)
    self.rd=tg.rd
    if not IsServer() then
		return
    end
  --  local fxname="particles/econ/items/nightstalker/nightstalker_ti10_silence/nightstalker_ti10.vpcf"
 --   if not GameRules:IsDaytime() or GameRules:IsNightstalkerNight()  then
 ---       fxname="particles/econ/items/nightstalker/nightstalker_ti10_silence/nightstalker_ti10_gold.vpcf"
  --  end
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle,2,Vector( self.rd,0,0))
    self:AddParticle(particle, false, false, 10, false, false)
end


modifier_crippling_fear_debuff=modifier_crippling_fear_debuff or class({})

function modifier_crippling_fear_debuff:IsDebuff()
	return true
end

function modifier_crippling_fear_debuff:IsHidden()
	return false
end

function modifier_crippling_fear_debuff:IsPurgable()
	return false
end

function modifier_crippling_fear_debuff:IsPurgeException()
	return false
end

function modifier_crippling_fear_debuff:GetEffectName()
    return "particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear.vpcf"
end
function modifier_crippling_fear_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_crippling_fear_debuff:ShouldUseOverheadOffset()
    return true
end

function modifier_crippling_fear_debuff:CheckState()
        return
        {
         [MODIFIER_STATE_SILENCED] = true,
        }
end

function modifier_crippling_fear_debuff:DeclareFunctions()
        return
        {
            MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        }

    end

function modifier_crippling_fear_debuff:GetModifierTurnRate_Percentage()
        return self:GetAbility():GetSpecialValueFor("tr")
    end