reincarnation=class({})
LinkLuaModifier("modifier_reincarnation", "heros/hero_skeleton_king/reincarnation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reincarnation_sp", "heros/hero_skeleton_king/reincarnation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reincarnation_buff", "heros/hero_skeleton_king/reincarnation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reincarnation_attsp", "heros/hero_skeleton_king/reincarnation.lua", LUA_MODIFIER_MOTION_NONE)

function reincarnation:CastFilterResultTarget(target)
    local caster=self:GetCaster()
	if target==caster or not target:IsRealHero() or not Is_Chinese_TG(caster,target)  then
		return UF_FAIL_CUSTOM
	end
end

function reincarnation:GetCustomCastErrorTarget(target)
        return "无法对其使用"
end

function reincarnation:GetCastRange()
    if self:GetCaster():TG_HasTalent("special_bonus_skeleton_king_6") then
        return 800
    else
        return 0
    end
end

function reincarnation:GetManaCost(iLevel)
    if self:GetCaster():HasScepter() then
        return 0
    else
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end

function reincarnation:GetBehavior()
    if self:GetCaster():TG_HasTalent("special_bonus_skeleton_king_6") then
        return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
    else
        return DOTA_ABILITY_BEHAVIOR_PASSIVE
    end
end

function reincarnation:GetIntrinsicModifierName()
    return "modifier_reincarnation"
end

function reincarnation:OnSpellStart()
    local caster=self:GetCaster()
    local target=self:GetCursorTarget()
    caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 2)
    caster:EmitSound("Hero_SkeletonKing.Hellfire_Blast")
    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW ,target)
    ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
    if target~=caster then
        target:AddNewModifier(caster, self, "modifier_reincarnation", {duration=30})
    end
end


modifier_reincarnation = class({})

function modifier_reincarnation:IsHidden()
    if self:GetParent()== self:GetCaster() then
        return true
    else
        return false
    end
end

function modifier_reincarnation:IsPurgable()
    return false
end

function modifier_reincarnation:IsPurgeException()
     return false
end

function modifier_reincarnation:AllowIllusionDuplicate()
    return false
end

function modifier_reincarnation:DeclareFunctions()
    return
     {
         MODIFIER_PROPERTY_REINCARNATION,
         MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_reincarnation:ReincarnateTime()
    if not IsServer() then
        return
    end
	if (self:GetAbility():IsCooldownReady() and  self:GetAbility():IsOwnersManaEnough()) or self:GetParent()~=self:GetCaster() then
        self:GetParent():EmitSound("Hero_SkeletonKing.Reincarnate")
        self:GetAbility():UseResources(true, false, true)
        if self:GetCaster():HasAbility("vampiric_aura") then
            local AB=self:GetCaster():FindAbilityByName("vampiric_aura")
            if AB~=nil and AB:GetLevel()>0 then
                AB:EndCooldown()
            end
        end
        if self:GetParent()==self:GetCaster() then
            Timers:CreateTimer(4.1, function()
                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_reincarnation_attsp", {duration=self:GetAbility():GetSpecialValueFor("dur2")})
                return nil
            end)
        end
        return self:GetAbility():GetSpecialValueFor("reincarnate_time")
	else
		return nil
	end
end

function modifier_reincarnation:OnDeath(tg)
	if IsServer() then
        if tg.unit == self:GetParent() and not self:GetParent():IsIllusion() then
            local heros = FindUnitsInRadius(
                self:GetParent():GetTeamNumber(),
                self:GetParent():GetAbsOrigin(),
                nil,
                self:GetAbility():GetSpecialValueFor("slow_radius"),
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO,
                DOTA_UNIT_TARGET_FLAG_NONE,
                FIND_ANY_ORDER,
                false)
                if #heros>0 then
                    for _, hero in pairs(heros) do
                        if hero:IsAlive() and hero:IsRealHero() then
                            hero:AddNewModifier_RS(self:GetCaster(), self:GetAbility(), "modifier_reincarnation_sp", {duration=self:GetAbility():GetSpecialValueFor("slow_duration")})
                        end
                    end
                end

        end
    end
end

modifier_reincarnation_sp = class({})

function modifier_reincarnation_sp:IsDebuff()
    return true
end

function modifier_reincarnation_sp:IsHidden()
    return false
end

function modifier_reincarnation_sp:IsPurgable()
    return true
end

function modifier_reincarnation_sp:IsPurgeException()
    return true
end

function modifier_reincarnation_sp:GetEffectName()
    return "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_slow_debuff.vpcf"
end

function modifier_reincarnation_sp:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_reincarnation_sp:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_reincarnation_sp:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_reincarnation_sp:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("attackslow")
end


modifier_reincarnation_buff=class({})

function modifier_reincarnation_buff:IsDebuff()
    return false
end

function modifier_reincarnation_buff:IsHidden()
    return true
end

function modifier_reincarnation_buff:IsPurgable()
    return false
end

function modifier_reincarnation_buff:IsPurgeException()
    return false
end

modifier_reincarnation_attsp=class({})

function modifier_reincarnation_attsp:IsDebuff()
    return false
end

function modifier_reincarnation_attsp:IsHidden()
    return false
end

function modifier_reincarnation_attsp:IsPurgable()
    return false
end

function modifier_reincarnation_attsp:IsPurgeException()
    return false
end

function modifier_reincarnation_attsp:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end


function modifier_reincarnation_attsp:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("attsp")
end