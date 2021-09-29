item_enchanted_edge=class({})
LinkLuaModifier("modifier_enchanted_edge_pa", "items/item_enchanted_edge.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enchanted_edge_buff", "items/item_enchanted_edge.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enchanted_edge_debuff", "items/item_enchanted_edge.lua", LUA_MODIFIER_MOTION_NONE)

function item_enchanted_edge:IsRefreshable()
    return true
end

function item_enchanted_edge:GetIntrinsicModifierName()
    if self:GetCaster():IsRangedAttacker() then
        return ""
    else
        return "modifier_enchanted_edge_pa"
    end
end

modifier_enchanted_edge_pa = class({})


function modifier_enchanted_edge_pa:IsHidden()
    return true
end

function modifier_enchanted_edge_pa:IsPurgable()
    return false
end

function modifier_enchanted_edge_pa:IsPurgeException()
    return false
end

function modifier_enchanted_edge_pa:AllowIllusionDuplicate()
    return false
end


function modifier_enchanted_edge_pa:OnCreated()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.stats=self.ability:GetSpecialValueFor("stats") or 0
    self.AttackSpeed=self.ability:GetSpecialValueFor("AttackSpeed") or 0
    self.mana=self.ability:GetSpecialValueFor("mana") or 0
    self.att_dis=self.ability:GetSpecialValueFor( "att_dis" ) or 0
    self.att=self.ability:GetSpecialValueFor("att") or 0
    self.attr=self.ability:GetSpecialValueFor("attr") or 0
end


function modifier_enchanted_edge_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_EVENT_ON_DEATH
    }
end

function modifier_enchanted_edge_pa:OnAttack(tg)
    if not IsServer() or tg.attacker:IsIllusion() then
        return
    end
    if tg.attacker == self:GetParent() and self.ability:IsCooldownReady() and not self:GetParent():IsRangedAttacker() then
        self:GetParent():AddNewModifier(self:GetParent(), self.ability, "modifier_enchanted_edge_buff", {duration=0.6})
        self.ability:UseResources(false, false, true)
    end
end

function modifier_enchanted_edge_pa:OnDeath(tg)
    if not IsServer() or tg.attacker:IsIllusion() then
        return
    end
    if tg.attacker == self:GetParent() and tg.unit:IsHero() then
        self:GetAbility():EndCooldown()
    end
end

function modifier_enchanted_edge_pa:GetModifierAttackRangeBonus()
    return self.attr
end

function modifier_enchanted_edge_pa:GetModifierBonusStats_Intellect()
    return  self.stats
end

function modifier_enchanted_edge_pa:GetModifierBonusStats_Agility()
    return  self.stats
end

function modifier_enchanted_edge_pa:GetModifierBonusStats_Strength()
    return  self.stats
end

function modifier_enchanted_edge_pa:GetModifierAttackSpeedBonus_Constant()
    return self.AttackSpeed
end

function modifier_enchanted_edge_pa:GetModifierPreAttack_BonusDamage()
    return self.att
end

function modifier_enchanted_edge_pa:GetModifierConstantManaRegen()
    return self.mana
end


modifier_enchanted_edge_buff= class({})


function modifier_enchanted_edge_buff:IsHidden()
    return false
end

function modifier_enchanted_edge_buff:IsPurgable()
    return false
end

function modifier_enchanted_edge_buff:IsPurgeException()
    return false
end

function modifier_enchanted_edge_buff:AllowIllusionDuplicate()
    return false
end

function modifier_enchanted_edge_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_enchanted_edge_buff:OnCreated()
    self.parent=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.attsp= self.ability:GetSpecialValueFor("attsp")
    self.dam=self.ability:GetSpecialValueFor("dam")
    self.damageTable1 = {
        attacker = self.parent,
        damage = self.dam,
        damage_type =DAMAGE_TYPE_MAGICAL,
        ability =  self.ability,
        }
end


function modifier_enchanted_edge_buff:OnAttackLanded(tg)
    if not IsServer() or tg.attacker:IsIllusion() then
        return
    end
    if tg.attacker == self.parent and not tg.target:IsBuilding() then
        self.damageTable1.victim = tg.target
        ApplyDamage(self.damageTable1)
        tg.target:AddNewModifier_RS(self.parent,  self.ability, "modifier_enchanted_edge_debuff", {duration=1})
    end
end

function modifier_enchanted_edge_buff:GetModifierAttackSpeedBonus_Constant()
    return self.attsp
end

modifier_enchanted_edge_debuff= class({})


function modifier_enchanted_edge_debuff:IsHidden()
    return false
end

function modifier_enchanted_edge_debuff:IsPurgable()
    return false
end

function modifier_enchanted_edge_debuff:IsPurgeException()
    return false
end


function modifier_enchanted_edge_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_enchanted_edge_debuff:GetModifierMoveSpeedBonus_Percentage()
   return  0-self:GetAbility():GetSpecialValueFor("sp")
end