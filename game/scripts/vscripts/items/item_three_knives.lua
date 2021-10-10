item_three_knives=class({})

LinkLuaModifier("modifier_item_three_knives_buff", "items/item_three_knives.lua", LUA_MODIFIER_MOTION_NONE)

function item_three_knives:GetIntrinsicModifierName()
    return "modifier_item_three_knives_buff"
end

modifier_item_three_knives_buff=class({})

function modifier_item_three_knives_buff:IsPassive()
    return true
end

function modifier_item_three_knives_buff:IsHidden()
    return true
end

function modifier_item_three_knives_buff:IsPurgable()
    return false
end

function modifier_item_three_knives_buff:IsPurgeException()
    return false
end

function modifier_item_three_knives_buff:AllowIllusionDuplicate()
    return false
end


function modifier_item_three_knives_buff:OnCreated()
    self.caster=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.all= self.ability:GetSpecialValueFor("all")
    self.all_rs= self.ability:GetSpecialValueFor("all_rs")
    self.all_heal= self.ability:GetSpecialValueFor("all_heal")
    self.all_sp= self.ability:GetSpecialValueFor("all_sp")
    self.all_attsp= self.ability:GetSpecialValueFor("all_attsp")
    self.all_spell= self.ability:GetSpecialValueFor("all_spell")
    self.all_mana= self.ability:GetSpecialValueFor("all_mana")
    self.ch1= self.ability:GetSpecialValueFor("ch1")
    self.ch2= self.ability:GetSpecialValueFor("ch2")
    self.mana= self.ability:GetSpecialValueFor("mana")
end

function modifier_item_three_knives_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }
end

function modifier_item_three_knives_buff:OnAttackLanded(tg)
    if IsServer() then
        if tg.attacker==self.caster and not self.caster:IsIllusion() and not tg.target:IsBuilding() then
            if RollPseudoRandomPercentage(self.ch1,0,self.caster) then
                self.caster:PerformAttack(tg.target, false, false, true, false, false, false, true)
            end
        end
    end
end

function modifier_item_three_knives_buff:OnAbilityExecuted(tg)
    if IsServer() then
        if tg.unit==self.caster and not self.caster:IsIllusion()  then
            if not tg.ability or tg.ability:IsItem() or tg.ability:IsToggle() or tg.ability:GetCooldown(tg.ability:GetLevel())<3 then
                return
            end
            if RollPseudoRandomPercentage(self.ch2,0,self.caster) then
                local mana=self.caster:GetLevel()*self.mana
                self.caster:GiveMana(mana)
                SendOverheadEventMessage(self.caster, OVERHEAD_ALERT_MANA_ADD, self.caster,mana, nil)
            end
        end
    end
end

function modifier_item_three_knives_buff:GetModifierBonusStats_Strength()
    return self.all
end

function modifier_item_three_knives_buff:GetModifierBonusStats_Intellect()
    return self.all
end

function modifier_item_three_knives_buff:GetModifierBonusStats_Agility()
    return self.all
end

function modifier_item_three_knives_buff:GetModifierStatusResistanceStacking()
    return  self.all_rs
end

function modifier_item_three_knives_buff:GetModifierHealAmplify_PercentageTarget()
    return self.all_heal
end

function modifier_item_three_knives_buff:GetModifierHPRegenAmplify_Percentage()
    return self.all_heal
end


function modifier_item_three_knives_buff:GetModifierAttackSpeedBonus_Constant()
    return self.all_attsp
end


function modifier_item_three_knives_buff:GetModifierMoveSpeedBonus_Percentage()
    return self.all_sp
end


function modifier_item_three_knives_buff:GetModifierSpellAmplify_Percentage()
    return self.all_spell
end


function modifier_item_three_knives_buff:GetModifierMPRegenAmplify_Percentage()
    return self.all_mana
end
