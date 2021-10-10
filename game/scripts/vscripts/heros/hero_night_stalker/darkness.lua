darkness=class({})
LinkLuaModifier("modifier_darkness_buff",  "heros/hero_night_stalker/darkness.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_darkness_debuff",  "heros/hero_night_stalker/darkness.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_darkness_v",  "heros/hero_night_stalker/darkness.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_darkness_sp",  "heros/hero_night_stalker/darkness.lua", LUA_MODIFIER_MOTION_NONE)
function darkness:IsHiddenWhenStolen()
    return false
end

function darkness:IsStealable()
    return true
end

function darkness:IsRefreshable()
    return true
end
function darkness:GetCooldown(iLevel)
    return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_night_stalker_8")
end

function darkness:OnSpellStart()
    local caster = self:GetCaster()
    local dur=self:GetSpecialValueFor("dur")+caster:TG_GetTalentValue("special_bonus_night_stalker_5")
    local v_dur=self:GetSpecialValueFor("v_dur")
    caster:EmitSound("Hero_Nightstalker.Darkness")
    GameRules:BeginNightstalkerNight(dur)
    caster:AddNewModifier(caster, self, "modifier_darkness_buff", {duration =dur })
    caster:AddNewModifier(caster, self, "modifier_darkness_sp", {sp =self:GetSpecialValueFor("sp")})
    if not GameRules:IsDaytime() or GameRules:IsNightstalkerNight()  and caster:IsAlive() then
        local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:ReleaseParticleIndex(pfx)
    end
	local heroes = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
    if #heroes>0 then
        for _, hero in pairs(heroes) do
            if  Is_Chinese_TG(caster, hero)  then
                    if caster:Has_Aghanims_Shard() then
                        hero:AddNewModifier(caster, self, "modifier_darkness_v", {duration =v_dur})
                    end
            else
                    hero:AddNewModifier_RS(caster, self, "modifier_darkness_debuff", {duration =v_dur})
            end

        end
    end
end


modifier_darkness_sp=class({})

function modifier_darkness_sp:IsPermanent()
    return true
end

function modifier_darkness_sp:RemoveOnDeath()
    return false
end

function modifier_darkness_sp:IsHidden()
    return false
end

function modifier_darkness_sp:IsPurgable()
    return false
end

function modifier_darkness_sp:IsPurgeException()
    return false
end

function modifier_darkness_sp:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
end

function modifier_darkness_sp:OnCreated(tg)
    if IsServer() then
        self:SetStackCount(self:GetStackCount()+tg.sp)
    end
end


function modifier_darkness_sp:OnRefresh(tg)
    self:OnCreated(tg)
end


function modifier_darkness_sp:GetModifierMoveSpeedBonus_Constant()
    return self:GetStackCount()
end

modifier_darkness_debuff = class({})

function modifier_darkness_debuff:IsDebuff()
    return true
end

function modifier_darkness_debuff:IsHidden()
    return false
end

function modifier_darkness_debuff:IsPurgable()
    return true
end

function modifier_darkness_debuff:IsPurgeException()
        return true
end

function modifier_darkness_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
        MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE
    }
end

function modifier_darkness_debuff:GetModifierProvidesFOWVision()
    return 1
end

function modifier_darkness_debuff:GetBonusVisionPercentage()
    return 0-self:GetAbility():GetSpecialValueFor("v1")
end



modifier_darkness_buff = modifier_darkness_buff or class({})


function modifier_darkness_buff:IsHidden()
    return false
end

function modifier_darkness_buff:IsPurgable()
    return false
end

function modifier_darkness_buff:IsPurgeException()
        return false
end

function modifier_darkness_buff:GetEffectName()
    return   "particles/units/heroes/hero_night_stalker/nightstalker_dark_buff.vpcf"

   end

function modifier_darkness_buff:GetEffectAttachType()
   return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_darkness_buff:OnCreated()

	if not IsServer() then
		return
    end

    local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_night_stalker/nightstalker_night_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle(pfx, false, false, 20, false, false)
    local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_bats.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
    ParticleManager:SetParticleControl(pfx2, 0,self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx2, 2,self:GetParent():GetAbsOrigin())
    self:AddParticle(pfx2, false, false, 20, false, false)
    self:StartIntervalThink(0.1)
end

function modifier_darkness_buff:OnIntervalThink()
    if not IsServer() then
		return
    end
        AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("v")+self:GetCaster():TG_GetTalentValue("special_bonus_night_stalker_6") , 0.2, false)
end

function modifier_darkness_buff:OnDestroy()
    if IsServer() then
        self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
    end
end

function modifier_darkness_buff:CheckState()
    return{[MODIFIER_STATE_FLYING] = true}
end

function modifier_darkness_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
    }
end

function modifier_darkness_buff:GetActivityTranslationModifiers()
    return "hunter_night"
end

function modifier_darkness_buff:GetOverrideAnimation()
    return ACT_DOTA_CAST_ABILITY_4
end

function modifier_darkness_buff:GetOverrideAnimationWeight()
    return 1
end


modifier_darkness_v= modifier_darkness_v or class({})


function modifier_darkness_v:IsHidden()
    return false
end

function modifier_darkness_v:IsPurgable()
    return false
end

function modifier_darkness_v:IsPurgeException()
    return false
end


function modifier_darkness_v:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
    }
end

function modifier_darkness_v:GetBonusNightVision()
    return 1000
end