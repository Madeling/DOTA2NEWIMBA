untouchable=untouchable or class({})
LinkLuaModifier("modifier_untouchable", "heros/hero_enchantress/untouchable.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_untouchable_debuff", "heros/hero_enchantress/untouchable.lua", LUA_MODIFIER_MOTION_NONE)

function untouchable:GetIntrinsicModifierName()
    return "modifier_untouchable"
end

function untouchable:OnUpgrade()
    if self:GetLevel()==1 then
        local caster=self:GetCaster()
        if caster:HasAbility("enchant") then
            caster:FindAbilityByName("enchant"):SetLevel(1)
        end
    end
end


modifier_untouchable =  class({})

function modifier_untouchable:IsPassive()
	return true
end


function modifier_untouchable:IsPurgable()
    return false
end

function modifier_untouchable:IsPurgeException()
    return false
end

function modifier_untouchable:IsHidden()
    return true
end

function modifier_untouchable:OnCreated( tg )
    self.T=self:GetAbility():GetSpecialValueFor("t")
    self.chance=self:GetAbility():GetSpecialValueFor("chance")
    self.dis=self:GetAbility():GetSpecialValueFor("dis")
end

function modifier_untouchable:OnDestroy()
    self.T=nil
    self.chance=nil
    self.dis=nil
end

function modifier_untouchable:OnAttackStart(tg)
    if self:GetParent():PassivesDisabled() or tg.attacker:IsBuilding()  then
		return
    end
    if tg.target == self:GetParent() then
        if  tg.attacker~=self:GetParent() and not tg.attacker:IsMagicImmune() then
            tg.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_untouchable_debuff", {duration=5})
            if RollPseudoRandomPercentage(self.chance,0,self:GetParent()) then
                local Knockback ={
                should_stun =  self.T,
                knockback_duration =  self.T,
                duration =  self.T,
                knockback_distance = self.dis,
                knockback_height = 100,
                center_x =  tg.target:GetAbsOrigin().x,
                center_y =  tg.target:GetAbsOrigin().y,
                center_z =  tg.target:GetAbsOrigin().z
            }
            tg.attacker:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_knockback", Knockback)
            end
        end
    end
end



function modifier_untouchable:DeclareFunctions()
	return {
    MODIFIER_EVENT_ON_ATTACK_START,
    }
end


modifier_untouchable_debuff= class({})


function modifier_untouchable_debuff:IsDebuff()
    return true
end

function modifier_untouchable_debuff:IsPurgable()
    return false
end

function modifier_untouchable_debuff:IsPurgeException()
    return false
end

function modifier_untouchable_debuff:IsHidden()
    return false
end

function modifier_untouchable_debuff:OnCreated()
    self.attsp= self:GetAbility():GetSpecialValueFor("attsp")*self:GetParent():GetLevel()
end
function modifier_untouchable_debuff:OnDestroy()
    self.attsp=nil
end

function modifier_untouchable_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_untouchable_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attsp
end
