degen_aura = class({})

LinkLuaModifier("modifier_degen_aura_pa", "heros/hero_omniknight/degen_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_degen_aura_buff", "heros/hero_omniknight/degen_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_degen_aura_debuff", "heros/hero_omniknight/degen_aura.lua", LUA_MODIFIER_MOTION_NONE)
function degen_aura:GetCastRange()
     return self:GetSpecialValueFor("radius")
end

function degen_aura:GetIntrinsicModifierName()
     return "modifier_degen_aura_pa"
end

modifier_degen_aura_pa = class({})

function modifier_degen_aura_pa:IsDebuff()
    return false
end

function modifier_degen_aura_pa:IsHidden()
    return true
end

function modifier_degen_aura_pa:IsPurgable()
    return false
end

function modifier_degen_aura_pa:IsPurgeException()
    return false
end

function modifier_degen_aura_pa:AllowIllusionDuplicate()
    return false
end

function modifier_degen_aura_pa:IsAura()
	if self:GetParent():PassivesDisabled() then
		return false
	else
		return true
	end
end

function modifier_degen_aura_pa:GetAuraDuration()
    return 0
end

function modifier_degen_aura_pa:GetModifierAura()
    return "modifier_degen_aura_buff"
end

function modifier_degen_aura_pa:GetAuraRadius()
    return 375
end

function modifier_degen_aura_pa:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
 end

function modifier_degen_aura_pa:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_degen_aura_pa:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_degen_aura_pa:OnCreated()
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_degen_aura_pa:OnRefresh()
        self:OnCreated()
end

function modifier_degen_aura_pa:OnIntervalThink()
    if self:GetParent():IsAlive() then
        local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 375, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        if  #enemies>0 then
            for _,target in pairs(enemies) do
                if target:IsRealHero() then
                TG_Modifier_Num_ADD2({
                    target=target,
                    caster=self:GetParent(),
                    ability=self:GetAbility(),
                    modifier="modifier_degen_aura_debuff",
                    init=5,
                    stack=5,
                    duration=1.1
                })
                end
            end
        end
    end
end

modifier_degen_aura_buff = class({})

function modifier_degen_aura_buff:IsDebuff()
    return true
end

function modifier_degen_aura_buff:IsHidden()
    return false
end

function modifier_degen_aura_buff:IsPurgable()
    return false
end

function modifier_degen_aura_buff:IsPurgeException()
    return false
end

function modifier_degen_aura_buff:GetEffectName()
    return "particles/units/heroes/hero_omniknight/omniknight_degen_aura_debuff.vpcf"
end

function modifier_degen_aura_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_degen_aura_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end


function modifier_degen_aura_buff:GetModifierMoveSpeedBonus_Percentage()
    return (0 - (self:GetAbility():GetSpecialValueFor("speed_bonus")+self:GetCaster():TG_GetTalentValue("special_bonus_omniknight_5")))
 end



 modifier_degen_aura_debuff=class({})

function modifier_degen_aura_debuff:IsPurgable()
    return false
end

function modifier_degen_aura_debuff:IsPurgeException()
    return false
end

function modifier_degen_aura_debuff:IsHidden()
    return false
end

function modifier_degen_aura_debuff:IsDebuff()
    return true
end

function modifier_degen_aura_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
end

function modifier_degen_aura_debuff:OnCreated(tg)
    if not IsServer() then
        return
    end
   self:SetStackCount(tg.num)
end

function modifier_degen_aura_debuff:GetModifierBonusStats_Strength()
    return (0-self:GetStackCount())
end

function modifier_degen_aura_debuff:GetModifierBonusStats_Agility()
    return (0-self:GetStackCount())
end

function modifier_degen_aura_debuff:GetModifierBonusStats_Intellect()
    return (0-self:GetStackCount())
end