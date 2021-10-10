mortal_strike=class({})
LinkLuaModifier("modifier_mortal_strike_pa", "heros/hero_skeleton_king/mortal_strike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mortal_strike_buff", "heros/hero_skeleton_king/mortal_strike.lua", LUA_MODIFIER_MOTION_NONE)
function mortal_strike:GetIntrinsicModifierName()
    return "modifier_mortal_strike_pa"
end

function mortal_strike:OnSpellStart()
        local caster=self:GetCaster()
        local pos=caster:GetAbsOrigin()
        EmitSoundOn("skeleton_king_wraith_spawn_01", caster)
        local dust = ParticleManager:CreateParticle("particles/units/heroes/hero_earthshaker/earthshaker_totem_leap_impact_dust.vpcf", PATTACH_CUSTOMORIGIN,nil)
        ParticleManager:SetParticleControl(dust, 0, pos)
        ParticleManager:ReleaseParticleIndex(dust)
        caster:AddActivityModifier("wraith_spin")
        caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT,1)
        Timers:CreateTimer(0.5, function()
            if caster:IsAlive() then
                                    EmitSoundOn("Hero_SkeletonKing.CriticalStrike.TI8", caster)
                                    local Projectile =
                                                {
                                                Ability = self,
                                                EffectName = "particles/tgp/king/ksword_m.vpcf",
                                                vSpawnOrigin = pos,
                                                fDistance = 1500,
                                                fStartRadius = 300,
                                                fEndRadius =300,
                                                Source =caster,
                                                bHasFrontalCone = false,
                                                bReplaceExisting = false,
                                                iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                                                iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                                                iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                                vVelocity = caster:GetForwardVector()*1500,
                                                bProvidesVision = false,
                                                }
                                                ProjectileManager:CreateLinearProjectile(Projectile)
                                                caster:ClearActivityModifiers()
            end
                        return nil
        end)
    if caster:TG_HasTalent("special_bonus_skeleton_king_5") then
        for a=1,6 do
            local epos=pos+RandomVector(250)
            local unit = CreateUnitByName("npc_wraith_king_skeleton_warrior",epos, true, caster, caster, caster:GetTeamNumber())
                    unit:AddNewModifier(caster, self, "modifier_phased", {duration=10})
                    unit:AddNewModifier(caster, self, "modifier_kill", {duration=10})
                    unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
                    unit:SetForwardVector(caster:GetForwardVector())
            end
    end

end

function mortal_strike:OnProjectileHit_ExtraData(target, location, kv)
            if target==nil then
                  return
            end
            self:GetCaster():PerformAttack(target, false, true, true, false, false, false, true)
            EmitSoundOn("Hero_SkeletonKing.Hellfire_BlastImpact", target)
end


modifier_mortal_strike_pa=class({})

function modifier_mortal_strike_pa:IsHidden()
    return true
end

function modifier_mortal_strike_pa:IsPurgable()
    return false
end

function modifier_mortal_strike_pa:IsPurgeException()
    return false
end

function modifier_mortal_strike_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_FAIL,
    }
end

function modifier_mortal_strike_pa:OnCreated()
    self.crit = {}
    if not self:GetAbility() then
        return
    end
    self.crit_mult=self:GetAbility():GetSpecialValueFor("crit_mult")
end

function modifier_mortal_strike_pa:OnRefresh()
    self:OnCreated()
end


function modifier_mortal_strike_pa:GetModifierPreAttack_CriticalStrike(tg)
    if not IsServer() or self:GetParent():IsIllusion()  then
		return
	end
    if tg.attacker == self:GetParent() and not tg.target:IsBuilding() and not self:GetParent():PassivesDisabled() then
        local ch=self:GetAbility():GetSpecialValueFor("ch")
        if self:GetParent():TG_HasTalent("special_bonus_skeleton_king_8") then
                ch=ch+10
        end
        if RollPseudoRandomPercentage(ch,0,self:GetParent()) then
			self:GetParent():EmitSound("Hero_SkeletonKing.CriticalStrike")
            self.crit[tg.record] = true
            if self:GetParent():HasModifier("modifier_hellfire_blast_buff") then
                    local AB=self:GetParent():FindAbilityByName("hellfire_blast")
                    if AB~=nil and  AB:GetLevel()>0 then
                        return  self.crit_mult+AB:GetSpecialValueFor("crit")
                    else
                        return  self.crit_mult
                    end
            else
                return self.crit_mult
            end
		else
			return 0
		end
	end
end


function modifier_mortal_strike_pa:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
	if tg.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled()  or tg.target:IsBuilding() or not tg.target:IsAlive() then
		return
    end
    if self.crit[tg.record] and tg.target:IsRealHero() then
        TG_Modifier_Num_ADD2({
            target=self:GetParent(),
            caster=self:GetParent(),
            ability=self:GetAbility(),
            modifier="modifier_mortal_strike_buff",
            init=15,
            stack=15,
            duration=self:GetAbility():GetSpecialValueFor("dur")
        })
    end
    self.crit[tg.record] = nil
    end

function modifier_mortal_strike_pa:OnAttackFail(tg)
        if not IsServer() then
            return
        end
        self.crit[tg.record] = nil
end

function modifier_mortal_strike_pa:OnDestroy()
        self.crit = nil
end

modifier_mortal_strike_buff=class({})

function modifier_mortal_strike_buff:IsHidden()
    return false
end

function modifier_mortal_strike_buff:IsPurgable()
    return false
end

function modifier_mortal_strike_buff:IsPurgeException()
    return false
end

function modifier_mortal_strike_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
end

function modifier_mortal_strike_buff:OnCreated(tg)
    if not IsServer() then
        return
    end
   self:SetStackCount(tg.num)
end

function modifier_mortal_strike_buff:GetModifierBonusStats_Strength()
    return self:GetStackCount()
end