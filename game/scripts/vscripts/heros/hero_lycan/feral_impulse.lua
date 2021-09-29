feral_impulse=class({})

LinkLuaModifier("modifier_feral_impulse", "heros/hero_lycan/feral_impulse.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_feral_impulse_a", "heros/hero_lycan/feral_impulse.lua", LUA_MODIFIER_MOTION_NONE)
function feral_impulse:GetIntrinsicModifierName()
    return "modifier_feral_impulse_a"
end

modifier_feral_impulse_a= class({})

function modifier_feral_impulse_a:IsPassive()
	return true
end


function modifier_feral_impulse_a:IsHidden()
    return false
end

function modifier_feral_impulse_a:IsPurgable()
    return false
end

function modifier_feral_impulse_a:IsPurgeException()
    return false
end

function modifier_feral_impulse_a:IsAura()
    return true
end


function modifier_feral_impulse_a:GetModifierAura()
    return "modifier_feral_impulse"
end

function modifier_feral_impulse_a:GetAuraRadius()
    return 1000
end

function modifier_feral_impulse_a:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_feral_impulse_a:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_feral_impulse_a:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_feral_impulse_a:DeclareFunctions()
    return
    {

        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end

function modifier_feral_impulse_a:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
end

function modifier_feral_impulse_a:OnDeath(tg)
    if not IsServer() then
        return
    end
    if (tg.attacker== self.parent or tg.attacker:GetOwner()==self.parent) and (tg.unit:IsNeutralUnitType() or tg.unit:IsCreep()) then
        if self:GetStackCount()<180 then
            self:SetStackCount(self:GetStackCount()+3)
            self.parent:CalculateStatBonus(true)
        end
    end
end


function modifier_feral_impulse_a:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount()
end


modifier_feral_impulse=class({})

function modifier_feral_impulse:IsHidden()
	return false
end

function modifier_feral_impulse:IsPurgable()
	return false
end

function modifier_feral_impulse:IsPurgeException()
	return false
end

function modifier_feral_impulse:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    if not self.ability then
        return
    end
    self.bonus_damage=self.ability:GetSpecialValueFor("bonus_damage")+self.caster:TG_GetTalentValue("special_bonus_lycan_5")
    self.bonus_hp_regen=self.ability:GetSpecialValueFor("bonus_hp_regen")+self.caster:TG_GetTalentValue("special_bonus_lycan_6")
    if IsServer() then
        self.att=self.parent:GetBaseDamageMax()*self.bonus_damage*0.01
    end
end

function modifier_feral_impulse:OnRefresh()
    self:OnCreated()
end

function modifier_feral_impulse:DeclareFunctions()
    return
    {

        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
end

function modifier_feral_impulse:GetModifierBaseAttack_BonusDamage()
	return self.att
end

function modifier_feral_impulse:GetModifierConstantHealthRegen()
	return self.bonus_hp_regen
end