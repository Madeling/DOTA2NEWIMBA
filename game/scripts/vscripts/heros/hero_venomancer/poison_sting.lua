poison_sting=class({})
LinkLuaModifier("modifier_poison_sting", "heros/hero_venomancer/poison_sting.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_poison_sting_debuff", "heros/hero_venomancer/poison_sting.lua", LUA_MODIFIER_MOTION_NONE)
function poison_sting:GetIntrinsicModifierName()
    return "modifier_poison_sting"
end

modifier_poison_sting=class({})

function modifier_poison_sting:IsPassive()
	return true
end

function modifier_poison_sting:IsPurgable()
    return false
end

function modifier_poison_sting:IsPurgeException()
    return false
end

function modifier_poison_sting:IsHidden()
    return true
end

function modifier_poison_sting:AllowIllusionDuplicate()
    return false
end

function modifier_poison_sting:DeclareFunctions()
    return
    {
    	MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_poison_sting:OnCreated()
    self.duration=self:GetAbility():GetSpecialValueFor("duration")
    self.movement_speed=self:GetAbility():GetSpecialValueFor("movement_speed")
    self.mr=self:GetAbility():GetSpecialValueFor("mr")
end

function modifier_poison_sting:OnRefresh()
   self:OnCreated()
end



function modifier_poison_sting:OnAttackLanded(tg)
    if not IsServer() then
        return
	end

    if tg.attacker == self:GetParent() then
        if self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() or tg.target:IsBuilding() then
            return
        end
        TG_Modifier_Num_ADD2({
            target= tg.target,
            caster=self:GetParent(),
            ability=self:GetAbility(),
            modifier="modifier_poison_sting_debuff",
            init= self.movement_speed,
            stack= self.movement_speed,
            duration= TG_StatusResistance_GET(tg.target,self.duration)
        })
		local damage= {
            victim = tg.target,
            attacker = self:GetParent(),
            damage = self:GetAbility():GetSpecialValueFor("damage")+self:GetCaster():TG_GetTalentValue("special_bonus_venomancer_3"),
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flag=DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            ability = self:GetAbility(),
            }
        ApplyDamage(damage)
	end
end

modifier_poison_sting_debuff=class({})

function modifier_poison_sting_debuff:IsDebuff()
	return true
end

function modifier_poison_sting_debuff:IsPurgable()
    return false
end

function modifier_poison_sting_debuff:IsPurgeException()
    return false
end

function modifier_poison_sting_debuff:IsHidden()
    return false
end

function modifier_poison_sting_debuff:OnCreated(tg)
    if not IsServer() then
        return
    end
    self:SetStackCount(tg.num)
end


function modifier_poison_sting_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end


function modifier_poison_sting_debuff:GetModifierMoveSpeedBonus_Percentage(tg)
    return 0-self:GetStackCount()
end

function modifier_poison_sting_debuff:GetModifierMagicalResistanceBonus(tg)
    return 0-self:GetStackCount()
end
