CreateTalents("npc_dota_hero_viper", "heros/hero_viper/poison_attack.lua")
poison_attack=class({})

LinkLuaModifier("modifier_poison_attack_att", "heros/hero_viper/poison_attack.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_poison_attack_debuff", "heros/hero_viper/poison_attack.lua", LUA_MODIFIER_MOTION_NONE)

function poison_attack:GetIntrinsicModifierName()
    return "modifier_poison_attack_att"
end

function poison_attack:GetCooldown(iLevel)
    if self:GetCaster():Has_Aghanims_Shard() then
        return 0
    end
    return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_undying_5")
end

modifier_poison_attack_att=class({})

function modifier_poison_attack_att:IsPassive()
	return true
end

function modifier_poison_attack_att:IsPurgable()
    return false
end

function modifier_poison_attack_att:IsPurgeException()
    return false
end

function modifier_poison_attack_att:IsHidden()
    return true
end

function modifier_poison_attack_att:GetModifierProjectileName()
    if self.parent:PassivesDisabled() or self.parent:IsIllusion() then
        return ""
    end
    return  "particles/econ/items/viper/viper_ti7_immortal/viper_poison_attack_ti7.vpcf"
end


function modifier_poison_attack_att:DeclareFunctions()
	return
        {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
	    }
end

function modifier_poison_attack_att:OnCreated()
    self.parent=self:GetParent()
    if not self:GetAbility() then
        return
    end
    self.ability=self:GetAbility()
    self.damage=self.ability:GetSpecialValueFor("damage")
    self.dur=self.ability:GetSpecialValueFor("dur")
    self.movement_speed=self.ability:GetSpecialValueFor("movement_speed")
    self.dam=self.ability:GetSpecialValueFor("dam")
end

function modifier_poison_attack_att:OnRefresh()
   self:OnCreated()
end


function modifier_poison_attack_att:OnAttackLanded(tg)
    if not IsServer() then
        return
	end

    if tg.attacker == self.parent then
        if self.parent:PassivesDisabled() or self.parent:IsIllusion()  or self.parent:IsMagicImmune() or tg.target:IsBuilding() or not self.ability:IsCooldownReady() then
            return
        end
        self.ability:UseResources(false, false, true)
        tg.target:AddNewModifier_RS(self.parent, self.ability, "modifier_poison_attack_debuff", {duration=self.dur+self:GetCaster():TG_GetTalentValue("special_bonus_viper_2"),num=self.movement_speed})
        local dam=tg.target:GetHealthDeficit()*self.dam*0.01
		local damage= {
            victim = tg.target,
            attacker = self.parent,
            damage = self.damage+dam+self:GetCaster():TG_GetTalentValue("special_bonus_viper_1"),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self.ability,
            }
        ApplyDamage(damage)

		EmitSoundOn("hero_viper.poisonAttack.Cast",self.parent)
	end
end


modifier_poison_attack_debuff=class({})

function modifier_poison_attack_debuff:IsDebuff()
    return true
end


function modifier_poison_attack_debuff:IsPurgable()
    return true
end

function modifier_poison_attack_debuff:IsPurgeException()
    return true
end

function modifier_poison_attack_debuff:IsHidden()
    return false
end


function modifier_poison_attack_debuff:OnCreated(tg)
    self.ability=self:GetAbility()
    self.movement_speed=self.ability:GetSpecialValueFor("movement_speed")
    self.max_stacks=self.ability:GetSpecialValueFor("max_stacks")
    if not IsServer() then
        return
    end
    if self:GetStackCount() < self.movement_speed* self.max_stacks then
        self:SetStackCount(self:GetStackCount()+tg.num)
    end
end

function modifier_poison_attack_debuff:OnRefresh(tg)
    self:OnCreated(tg)
end


function modifier_poison_attack_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end


function modifier_poison_attack_debuff:GetModifierMoveSpeedBonus_Percentage(tg)
    return 0-self:GetStackCount()
end

function modifier_poison_attack_debuff:GetModifierMagicalResistanceBonus(tg)
    return 0-self:GetStackCount()
end