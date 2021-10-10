plague_ward=class({})

LinkLuaModifier("modifier_plague_ward", "heros/hero_venomancer/plague_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_plague_ward_debuff", "heros/hero_venomancer/plague_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_plague_ward_buff", "heros/hero_venomancer/plague_ward.lua", LUA_MODIFIER_MOTION_NONE)

function plague_ward:IsHiddenWhenStolen()
    return false
end

function plague_ward:IsStealable()
    return true
end

function plague_ward:IsRefreshable()
    return true
end

function plague_ward:OnSpellStart()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    local pos = self:GetCursorPosition()
    local duration = self:GetSpecialValueFor("duration")
    caster:EmitSound("Hero_Venomancer.Plague_Ward")
    for i=1,self:GetSpecialValueFor("num") do
       local ward=CreateUnitByName("npc_plague_ward", pos, true, caster, caster, caster:GetTeamNumber())
       ward:AddNewModifier(caster, self, "modifier_plague_ward", {duration=duration})
       ward:AddNewModifier(caster, self, "modifier_kill", {duration=duration})
       ward:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
    end
end

modifier_plague_ward=class({})


function modifier_plague_ward:IsHidden()
	return true
end

function modifier_plague_ward:IsPurgable()
	return false
end

function modifier_plague_ward:IsPurgeException()
	return false
end


function modifier_plague_ward:CheckState()
    return
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end

function modifier_plague_ward:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_PROPERTY_DISABLE_HEALING,
	}
end

function modifier_plague_ward:GetDisableHealing()
    return 1
end

function modifier_plague_ward:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_plague_ward:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_plague_ward:GetAbsoluteNoDamagePure()
    return 1
end


function modifier_plague_ward:OnCreated()
    self.dur=self:GetAbility():GetSpecialValueFor("dur")
    self.less=self:GetAbility():GetSpecialValueFor("less")+self:GetCaster():TG_GetTalentValue("special_bonus_venomancer_5")
    local DAM=self:GetAbility():GetSpecialValueFor("att")+self:GetCaster():TG_GetTalentValue("special_bonus_venomancer_4")
    if not IsServer() then
        return
    end
    self:GetParent():Set_HP(self:GetAbility():GetSpecialValueFor("hp"),true)
    self:GetParent():SetBaseDamageMax(DAM)
    self:GetParent():SetBaseDamageMin(DAM)
end

function modifier_plague_ward:OnRefresh()
   self:OnCreated()
end


function modifier_plague_ward:OnAttackLanded(tg)
    if not IsServer() then
        return
	end
    if  tg.target == self:GetParent() then
        if self:GetParent():GetHealth()>0 then
        self:GetParent():SetHealth(self:GetParent():GetHealth() - 1)
        elseif self:GetParent():GetHealth()<=0 then
        self:GetParent():Kill(self:GetAbility(), tg.attacker)
        end
    end

    if tg.attacker == self:GetParent() then
        if self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() or tg.target:IsBuilding() then
            return
        end
        if tg.target:HasModifier("modifier_venomous_gale_debuff") then
            self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_plague_ward_buff", {})
        end
         TG_Modifier_Num_ADD2({
            target= tg.target,
            caster=self:GetParent(),
            ability=self:GetAbility(),
            modifier="modifier_plague_ward_debuff",
            init= self.less,
            stack= self.less,
            duration=  TG_StatusResistance_GET(tg.target,self.dur)
        })
        if self:GetCaster():TG_HasTalent("special_bonus_venomancer_6") then
            local damage= {
                victim = tg.target,
                attacker = self:GetParent(),
                damage = 40,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self:GetAbility(),
                }
        end
	end
end

modifier_plague_ward_debuff=class({})

function modifier_plague_ward_debuff:IsDebuff()
	return true
end

function modifier_plague_ward_debuff:IsPurgable()
    return false
end

function modifier_plague_ward_debuff:IsPurgeException()
    return false
end

function modifier_plague_ward_debuff:IsHidden()
    return false
end


function modifier_plague_ward_debuff:OnCreated(tg)
    if not IsServer() then
        return
    end
    self:SetStackCount(tg.num)
end


function modifier_plague_ward_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_plague_ward_debuff:GetModifierMagicalResistanceBonus(tg)
    return 0-self:GetStackCount()
end

function modifier_plague_ward_debuff:GetModifierMoveSpeedBonus_Percentage(tg)
    return 0-self:GetStackCount()
end


modifier_plague_ward_buff=class({})

function modifier_plague_ward_buff:IsDebuff()
	return false
end

function modifier_plague_ward_buff:IsPurgable()
    return false
end

function modifier_plague_ward_buff:IsPurgeException()
    return false
end

function modifier_plague_ward_buff:IsHidden()
    return false
end

function modifier_plague_ward_debuff:RemoveOnDeath()
    return true
end

function modifier_plague_ward_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_plague_ward_buff:GetModifierAttackSpeedBonus_Constant(tg)
    return self:GetAbility():GetSpecialValueFor("attsp")
end