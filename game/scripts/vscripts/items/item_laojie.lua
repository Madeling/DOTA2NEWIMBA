item_laojie=class({})

LinkLuaModifier("modifier_item_laojie_pa", "items/item_laojie.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_laojie_debuff", "items/item_laojie.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_laojie_f", "items/item_laojie.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_laojie_e", "items/item_laojie.lua", LUA_MODIFIER_MOTION_NONE)

function item_laojie:GetIntrinsicModifierName()
    return "modifier_item_laojie_pa"
end

function item_laojie:OnSpellStart()
    local target=self:GetCursorTarget()
    local caster=self:GetCaster()
    local dur=self:GetSpecialValueFor("dur")
    local dur1=self:GetSpecialValueFor("dur1")
    EmitSoundOn("DOTA_Item.SpiderLegs.Cast", target)
    if Is_Chinese_TG(caster,target) then
        target:AddNewModifier(caster, self, "modifier_item_laojie_f", {duration=dur})
    else
        target:AddNewModifier_RS(caster, self, "modifier_item_laojie_e", {duration=dur1})
    end
end


modifier_item_laojie_pa = class({})


function modifier_item_laojie_pa:IsHidden()
    return true
end

function modifier_item_laojie_pa:IsPurgable()
    return false
end

function modifier_item_laojie_pa:IsPurgeException()
    return false
end


function modifier_item_laojie_pa:AllowIllusionDuplicate()
    return false
end


function modifier_item_laojie_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
   }
end


function modifier_item_laojie_pa:OnCreated()
    self.ability,self.parent=self:GetAbility(),self:GetParent()
    if not  self.ability then
		return
    end
    self.bonus_damage=self.ability:GetSpecialValueFor("bonus_damage")
    self.dur=self.ability:GetSpecialValueFor("dur")
    self.armor=self.ability:GetSpecialValueFor("armor")
    self.armor1=self.ability:GetSpecialValueFor("armor1")
    self.armor2=self.ability:GetSpecialValueFor("armor2")
    self.ab=self.ability:GetSpecialValueFor("ab")
end


function modifier_item_laojie_pa:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker ==self.parent and not self.parent:IsIllusion() then
        local ar=tg.target:IsBuilding() and self.armor1 or self.armor2
            TG_Modifier_Num_ADD2({
                target=tg.target,
                caster=self.parent,
                ability= self.ability,
                modifier="modifier_item_laojie_debuff",
                init= 7,
                stack= ar,
                duration=self.dur
            })
    end
end

function modifier_item_laojie_pa:GetModifierPreAttack_BonusDamage()
   return  self.bonus_damage
end

function modifier_item_laojie_pa:GetModifierPhysicalArmorBonus()
    return self.armor
 end

 function modifier_item_laojie_pa:GetModifierBonusStats_Agility()
    return self.ab
 end

 function modifier_item_laojie_pa:GetModifierBonusStats_Intellect()
    return self.ab
 end

 function modifier_item_laojie_pa:GetModifierBonusStats_Strength()
    return self.ab
 end

 function modifier_item_laojie_pa:GetModifierMoveSpeedBonus_Constant()
    return 30
 end

modifier_item_laojie_debuff=class({})


function modifier_item_laojie_debuff:IsDebuff()
    return true
end


function modifier_item_laojie_debuff:IsHidden()
    return false
end

function modifier_item_laojie_debuff:IsPurgable()
    return false
end

function modifier_item_laojie_debuff:IsPurgeException()
    return false
end

function modifier_item_laojie_debuff:OnCreated(tg)
    if not IsServer() then
        return
    end
    self:SetStackCount(tg.num)
end

function modifier_item_laojie_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
   }
end

function modifier_item_laojie_debuff:GetModifierPhysicalArmorBonus()
    return  (0-self:GetStackCount())
 end


 modifier_item_laojie_f=class({})

 function modifier_item_laojie_f:IsDebuff()
    return false
end

function modifier_item_laojie_f:IsHidden()
    return false
end

function modifier_item_laojie_f:IsPurgable()
    return false
end

function modifier_item_laojie_f:IsPurgeException()
    return false
end

function modifier_item_laojie_f:OnCreated(tg)
    if self:GetAbility() == nil then
		return
	end
    self.armor3=self:GetAbility():GetSpecialValueFor("armor3")
    self.sp1=self:GetAbility():GetSpecialValueFor("sp1")
end

function modifier_item_laojie_f:CheckState()
    return
    {
              [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end

function modifier_item_laojie_f:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
   }
end

function modifier_item_laojie_f:GetModifierPhysicalArmorBonus()
    return  self.armor3
 end

 function modifier_item_laojie_f:GetModifierMoveSpeedBonus_Percentage()
    return  self.sp1
 end

 function modifier_item_laojie_f:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
 end

 function modifier_item_laojie_f:GetEffectName()
    return "particles/tgp/items/laojie/laojie_buff.vpcf"
 end



 modifier_item_laojie_e=class({})

 function modifier_item_laojie_e:IsDebuff()
    return true
end

function modifier_item_laojie_e:IsHidden()
    return false
end

function modifier_item_laojie_e:IsPurgable()
    return false
end

function modifier_item_laojie_e:IsPurgeException()
    return false
end

function modifier_item_laojie_e:OnCreated(tg)
    if self:GetAbility() == nil then
		return
	end
    self.armor3=self:GetAbility():GetSpecialValueFor("armor3")
    self.sp1=self:GetAbility():GetSpecialValueFor("sp1")
    self.rs=self:GetAbility():GetSpecialValueFor("rs")
end

function modifier_item_laojie_e:CheckState()
    return
    {
        [MODIFIER_STATE_EVADE_DISABLED] = true,
    }
end

function modifier_item_laojie_e:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
   }
end

function modifier_item_laojie_e:GetModifierPhysicalArmorBonus()
    return  0-self.armor3
 end

 function modifier_item_laojie_e:GetModifierMoveSpeedBonus_Percentage()
    return  0-self.sp1
 end

  function modifier_item_laojie_e:GetModifierStatusResistanceStacking()
    return  0- self.rs
 end

 function modifier_item_laojie_e:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
 end

 function modifier_item_laojie_e:GetEffectName()
    return "particles/units/heroes/hero_pangolier/pangolier_heartpiercer_debuff.vpcf"
 end
