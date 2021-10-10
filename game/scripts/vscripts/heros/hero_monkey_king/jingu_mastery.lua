jingu_mastery=class({})
LinkLuaModifier("modifier_jingu_mastery_pa", "heros/hero_monkey_king/jingu_mastery.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_jingu_mastery_buff", "heros/hero_monkey_king/jingu_mastery.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_jingu_mastery_debuff", "heros/hero_monkey_king/jingu_mastery.lua", LUA_MODIFIER_MOTION_BOTH)
function jingu_mastery:IsHiddenWhenStolen()
    return false
end

function jingu_mastery:IsStealable()
    return true
end

function jingu_mastery:IsRefreshable()
    return true
end

function jingu_mastery:GetIntrinsicModifierName ()
    return "modifier_jingu_mastery_pa"
end

modifier_jingu_mastery_pa=class({})
function modifier_jingu_mastery_pa:IsDebuff()
	return false
end

function modifier_jingu_mastery_pa:IsHidden()
	return true
end

function modifier_jingu_mastery_pa:IsPurgable()
	return false
end

function modifier_jingu_mastery_pa:IsPurgeException()
	return false
end

function modifier_jingu_mastery_pa:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_jingu_mastery_pa:OnCreated()
    self.required_hits=self:GetAbility():GetSpecialValueFor("required_hits")
    self.counter_duration=self:GetAbility():GetSpecialValueFor("counter_duration")

end
function modifier_jingu_mastery_pa:OnRefresh()
    self.required_hits=self:GetAbility():GetSpecialValueFor("required_hits")
    self.counter_duration=self:GetAbility():GetSpecialValueFor("counter_duration")
end

function modifier_jingu_mastery_pa:OnAttackLanded(tg)
    if not IsServer()  then
		return
    end
    if  tg.attacker==self:GetParent() and not self:GetParent():IsIllusion() and not self:GetParent():HasModifier("modifier_jingu_mastery_buff") and  not self:GetParent():PassivesDisabled() and not tg.target:IsBuilding() then
        local num=1
        if tg.target:HasModifier("modifier_jingu_mastery_debuff") then
            local modifier= tg.target:FindModifierByName( "modifier_jingu_mastery_debuff" )
            num=num+modifier:GetStackCount()
            if num >= self.required_hits then
                tg.target:RemoveModifierByName("modifier_jingu_mastery_debuff")
                self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_jingu_mastery_buff", {duration=40})
                return
            end
        end
        TG_Modifier_Num_ADD2({target=tg.target,caster=self:GetParent(),ability=self:GetAbility(),modifier="modifier_jingu_mastery_debuff",init=1,stack=1,duration=self.counter_duration})
    end
end


modifier_jingu_mastery_buff=class({})

function modifier_jingu_mastery_buff:IsDebuff()
	return false
end

function modifier_jingu_mastery_buff:IsHidden()
	return false
end

function modifier_jingu_mastery_buff:IsPurgable()
	return false
end

function modifier_jingu_mastery_buff:IsPurgeException()
	return false
end

function modifier_jingu_mastery_buff:GetEffectName()
    return "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_start.vpcf"
end

function modifier_jingu_mastery_buff:GetEffectAttachType()
     return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_jingu_mastery_buff:ShouldUseOverheadOffset()
    return true
end

function modifier_jingu_mastery_buff:OnCreated()
   self.bonus_damage= self:GetAbility():GetSpecialValueFor("bonus_damage")
   self.lifesteal= self:GetAbility():GetSpecialValueFor("lifesteal")
   self.charges=self:GetAbility():GetSpecialValueFor("charges")

    if not IsServer() then
		return
    end
    if  self:GetParent():HasItemInInventory("item_monkey_king_bar_v2") or self:GetParent():HasItemInInventory("item_monkey_king_bar") then
        self.lifesteal=77
        self.charges=7
    end
    self:SetStackCount(self.charges)
    self:GetParent():EmitSound("Hero_MonkeyKing.IronCudgel")
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    self:AddParticle(particle, false, false, 15, false, true)
    local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_tap_buff.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(particle2, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon_top", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle2, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon_bot", self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(particle2, false, false, -1, false, false)
end

function modifier_jingu_mastery_buff:OnRefresh()
   self:OnCreated()
end


function modifier_jingu_mastery_buff:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end

function modifier_jingu_mastery_buff:GetActivityTranslationModifiers(tg)
    return "iron_cudgel_charged_attack"
end

function modifier_jingu_mastery_buff:GetModifierPreAttack_BonusDamage(tg)
    if  self:GetParent():HasItemInInventory("item_monkey_king_bar_v2") or self:GetParent():HasItemInInventory("item_monkey_king_bar") then
        return   177
    else
        return  self.bonus_damage
    end
end

function modifier_jingu_mastery_buff:OnAttackLanded(tg)
    if not IsServer() then
		return
    end
    if tg.attacker==self:GetParent() then
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, tg.target)
        ParticleManager:SetParticleControlEnt( particle, 1, tg.target, PATTACH_POINT_FOLLOW, "attach_hitloc", tg.target:GetAbsOrigin(), true )
        ParticleManager:ReleaseParticleIndex(particle)
        if   not tg.target:IsBuilding() then
            local hp=tg.damage* self.lifesteal*0.01
            self:GetParent():Heal(hp, self:GetParent())
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(),hp, nil)
        end
        self:SetStackCount(self:GetStackCount()-1)
        if self:GetStackCount()==nil or self:GetStackCount()==0 then
            self:Destroy()
        end
    end
end


modifier_jingu_mastery_debuff=class({})

function modifier_jingu_mastery_debuff:IsDebuff()
	return true
end

function modifier_jingu_mastery_debuff:IsHidden()
	return false
end

function modifier_jingu_mastery_debuff:IsPurgable()
	return false
end

function modifier_jingu_mastery_debuff:IsPurgeException()
	return false
end

function modifier_jingu_mastery_debuff:ShouldUseOverheadOffset()
    return true
end

function modifier_jingu_mastery_debuff:OnCreated(tg)
    if not IsServer() then
		return
    end
    self:SetStackCount(tg.num)
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle, 1, Vector(self:GetRemainingTime(),self:GetStackCount(),1))
    self:AddParticle(particle, false, false, 15, false, true)
end
