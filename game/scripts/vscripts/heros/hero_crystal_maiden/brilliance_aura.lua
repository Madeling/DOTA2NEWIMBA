brilliance_aura=class({})
LinkLuaModifier("modifier_brilliance_aura", "heros/hero_crystal_maiden/brilliance_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brilliance_aura_buff", "heros/hero_crystal_maiden/brilliance_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brilliance_aura_debuff", "heros/hero_crystal_maiden/brilliance_aura.lua", LUA_MODIFIER_MOTION_NONE)
function brilliance_aura:GetIntrinsicModifierName()
    return "modifier_brilliance_aura"
end

modifier_brilliance_aura=class({})

function modifier_brilliance_aura:IsPassive()
	return true
end

function modifier_brilliance_aura:IsPurgable()
    return false
end

function modifier_brilliance_aura:IsPurgeException()
    return false
end

function modifier_brilliance_aura:IsHidden()
    return true
end

function modifier_brilliance_aura:IsAura()
    return true
end

function modifier_brilliance_aura:GetModifierAura()
       return "modifier_brilliance_aura_buff"
end

function modifier_brilliance_aura:GetAuraRadius()
    return 25000
end

function modifier_brilliance_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_brilliance_aura:GetAuraSearchTeam()
               return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_brilliance_aura:GetAuraSearchType()
        return DOTA_UNIT_TARGET_HERO
end

function modifier_brilliance_aura:AllowIllusionDuplicate()
        return false
end

function modifier_brilliance_aura:OnCreated()
    self.mana_regen=self:GetAbility():GetSpecialValueFor("mana_regen")*self:GetAbility():GetSpecialValueFor("self_factor")
    self.spell=self:GetAbility():GetSpecialValueFor("spell")
end

function modifier_brilliance_aura:OnRefresh()
        self:OnCreated()
end

function modifier_brilliance_aura:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_brilliance_aura:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
        if tg.attacker==self:GetParent() and not tg.attacker:IsIllusion() and not tg.target:IsBuilding()  then
            if  tg.target:HasModifier("modifier_frostbite_debuff") or tg.target:HasModifier("modifier_brilliance_aura_debuff") or tg.target:HasModifier("modifier_crystal_nova_debuff") or
            tg.target:HasModifier("modifier_crystal_nova_debuff1") or tg.target:HasModifier("modifier_crystal_nova_debuff2") or tg.target:HasModifier("modifier_freezing_field_debuff")  then
                    local damage= {
                                        victim =  tg.target,
                                        attacker = self:GetParent(),
                                        damage = self:GetParent():GetIntellect()*1.5,
                                        damage_type = DAMAGE_TYPE_MAGICAL,
                                        ability = self:GetAbility(),
                                        }
                    ApplyDamage(damage)
                end
        end
end

function modifier_brilliance_aura:OnDeath(tg)
        if IsServer() then
                if tg.attacker~=self:GetParent() and tg.attacker:IsRealHero()  and not tg.attacker:IsIllusion() and tg.unit==self:GetParent()  then
                         tg.attacker:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_brilliance_aura_debuff",{duration=self:GetAbility():GetSpecialValueFor("dur")})
                end
        end
end

function modifier_brilliance_aura:GetModifierTotalPercentageManaRegen()
        return self.mana_regen
end

function modifier_brilliance_aura:GetModifierSpellAmplify_Percentage()
        if   self:GetCaster():TG_HasTalent("special_bonus_crystal_maiden_4") then
                return 21
        end
                return self.spell
end


modifier_brilliance_aura_buff=class({})


function modifier_brilliance_aura_buff:IsPurgable()
    return false
end

function modifier_brilliance_aura_buff:IsPurgeException()
    return false
end

function modifier_brilliance_aura_buff:IsHidden()
    return false
end

function modifier_brilliance_aura_buff:OnCreated()
        self.MANA=self:GetAbility():GetSpecialValueFor("mana_regen")
        self.SPELL=self:GetAbility():GetSpecialValueFor("spell")
end

function modifier_brilliance_aura_buff:AllowIllusionDuplicate()
    return false
end

function modifier_brilliance_aura_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_brilliance_aura_buff:GetModifierTotalPercentageManaRegen()
    return self.MANA or 0
end

function modifier_brilliance_aura_buff:GetModifierSpellAmplify_Percentage()
    return self.SPELL or 0
end


modifier_brilliance_aura_debuff=class({})
function modifier_brilliance_aura_debuff:IsDebuff()
    return true
end

function modifier_brilliance_aura_debuff:IsPurgable()
    return false
end

function modifier_brilliance_aura_debuff:IsPurgeException()
    return false
end

function modifier_brilliance_aura_debuff:IsHidden()
    return false
end

function modifier_brilliance_aura_debuff:RemoveOnDeath()
    return false
end

function modifier_brilliance_aura_debuff:IsPermanent()
    return true
end

function modifier_brilliance_aura_debuff:OnCreated()
        self.spell1=self:GetAbility():GetSpecialValueFor("spell1")
end

function modifier_brilliance_aura_debuff:AllowIllusionDuplicate()
    return false
end

function modifier_brilliance_aura_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
	}
end

function modifier_brilliance_aura_debuff:GetModifierSpellAmplify_Percentage()
    return  0-self.spell1
end

function modifier_brilliance_aura_debuff:GetModifierPercentageManacostStacking()
        if   self:GetCaster():TG_HasTalent("special_bonus_crystal_maiden_5") then
                return -40
        end
        return 0
end
