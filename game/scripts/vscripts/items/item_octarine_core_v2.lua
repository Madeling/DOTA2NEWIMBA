item_octarine_core_v2=class({})

LinkLuaModifier("modifier_item_octarine_core_v2_buff", "items/item_octarine_core_v2.lua", LUA_MODIFIER_MOTION_NONE)

function item_octarine_core_v2:GetIntrinsicModifierName()
    return "modifier_item_octarine_core_v2_buff"
end


modifier_item_octarine_core_v2_buff=class({})

function modifier_item_octarine_core_v2_buff:IsPassive()
    return true
end

function modifier_item_octarine_core_v2_buff:IsHidden()
    return true
end

function modifier_item_octarine_core_v2_buff:IsPurgable()
    return false
end

function modifier_item_octarine_core_v2_buff:IsPurgeException()
    return false
end

function modifier_item_octarine_core_v2_buff:AllowIllusionDuplicate()
    return false
end


function modifier_item_octarine_core_v2_buff:OnCreated()
    self.caster=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.bonus_cooldown= self.ability:GetSpecialValueFor("bonus_cooldown")
    self.cast_range_bonus= self.ability:GetSpecialValueFor("cast_range_bonus")
    self.bonus_health= self.ability:GetSpecialValueFor("bonus_health")
    self.bonus_mana= self.ability:GetSpecialValueFor("bonus_mana")
    self.bonus_mana_regen= self.ability:GetSpecialValueFor("bonus_mana_regen")
    self.blood= self.ability:GetSpecialValueFor("blood")
end

function modifier_item_octarine_core_v2_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_item_octarine_core_v2_buff:OnTakeDamage(tg)
    if IsServer() then
        if tg.attacker==self.caster and not self.caster:IsIllusion() and tg.inflictor~=nil and bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION and  bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
            local hp=tg.damage*(self.caster:GetLevel()*self.blood*0.01)
            self.caster:Heal(hp, self.ability)
            SendOverheadEventMessage(self.caster, OVERHEAD_ALERT_HEAL, self.caster,hp, nil)
        end
    end
end

function modifier_item_octarine_core_v2_buff:GetModifierPercentageCooldownStacking()
    return self.bonus_cooldown
end

function modifier_item_octarine_core_v2_buff:GetModifierCastRangeBonus()
  return self.cast_range_bonus
end

function modifier_item_octarine_core_v2_buff:GetModifierHealthBonus()
    return self.bonus_health
end

function modifier_item_octarine_core_v2_buff:GetModifierManaBonus()
    return self.bonus_mana
end

function modifier_item_octarine_core_v2_buff:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end
