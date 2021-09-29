item_desolator_v2=class({})

LinkLuaModifier("modifier_item_desolator_v2_pa", "items/item_desolator_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_desolator_v2_debuff", "items/item_desolator_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_desolator_v2_debuff2", "items/item_desolator_v2.lua", LUA_MODIFIER_MOTION_NONE)

function item_desolator_v2:GetIntrinsicModifierName()return "modifier_item_desolator_v2_pa"
end

modifier_item_desolator_v2_pa = class({})

function modifier_item_desolator_v2_pa:GetTexture()return "item_desolator_v2"
end
function modifier_item_desolator_v2_pa:IsHidden() return true
end
function modifier_item_desolator_v2_pa:IsPurgable()return false
end
function modifier_item_desolator_v2_pa:IsPurgeException()return false
end
function modifier_item_desolator_v2_pa:AllowIllusionDuplicate()return false
end


function modifier_item_desolator_v2_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PROJECTILE_NAME
   }
end


function modifier_item_desolator_v2_pa:OnCreated()
    self.ability,self.parent=self:GetAbility(),self:GetParent()
    if not  self.ability then
		return
    end
    self.bonus_damage=self.ability:GetSpecialValueFor("bonus_damage")
    self.dur=self.ability:GetSpecialValueFor("dur")
    self.armor=self.ability:GetSpecialValueFor("armor")
end


function modifier_item_desolator_v2_pa:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker == self.parent and  not self.parent:IsIllusion() then
        if self.parent:HasItemInInventory("item_laojie") then
            if self.parent:FindItemInInventory("item_laojie"):IsInBackpack() then
                TG_Modifier_Num_ADD2({
                    target=tg.target,
                    caster=self.parent,
                    ability= self.ability,
                    modifier="modifier_item_desolator_v2_debuff",
                    init= self.armor,
                    stack= self.armor,
                    duration=TG_StatusResistance_GET(tg.target,self.dur)
                })
            end
        else
            TG_Modifier_Num_ADD2({
                target=tg.target,
                caster=self.parent,
                ability= self.ability,
                modifier="modifier_item_desolator_v2_debuff",
                init= 5,
                stack= self.armor,
                duration=TG_StatusResistance_GET(tg.target,self.dur)
            })
        end
    end
end

function modifier_item_desolator_v2_pa:GetModifierPreAttack_BonusDamage()return  self.bonus_damage
end
function modifier_item_desolator_v2_pa:GetModifierProjectileName()return  "particles/items_fx/desolator_projectile.vpcf"
end

modifier_item_desolator_v2_debuff=class({})

function modifier_item_desolator_v2_debuff:GetTexture()return "item_desolator_v2"
end
function modifier_item_desolator_v2_debuff:IsDebuff()return true
end
function modifier_item_desolator_v2_debuff:IsHidden()return false
end
function modifier_item_desolator_v2_debuff:IsPurgable()return true
end
function modifier_item_desolator_v2_debuff:IsPurgeException()return true
end

function modifier_item_desolator_v2_debuff:OnCreated(tg)
    if not IsServer() then
        return
    end
    self:SetStackCount(tg.num)
end

function modifier_item_desolator_v2_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
   }
end

function modifier_item_desolator_v2_debuff:GetModifierPhysicalArmorBonus()
    return  (0-self:GetStackCount())
 end

 modifier_item_desolator_v2_debuff2=class({})

 function modifier_item_desolator_v2_debuff2:GetTexture()return "item_desolator_v2"
 end
 function modifier_item_desolator_v2_debuff2:IsDebuff()return true
 end
 function modifier_item_desolator_v2_debuff2:IsHidden()return false
 end
 function modifier_item_desolator_v2_debuff2:IsPurgable()return true
 end
 function modifier_item_desolator_v2_debuff2:IsPurgeException()return true
 end

 function modifier_item_desolator_v2_debuff2:OnCreated(tg)
    if not IsServer() then
        return
    end
    local FX=ParticleManager:CreateParticle("particles/econ/events/ti10/hot_potato/hot_potato_debuff.vpcf", PATTACH_ROOTBONE_FOLLOW, self:GetParent())
    self:AddParticle(FX, false, false, -1, false, false)
    local FX2=ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_meld_focal_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    self:AddParticle(FX2, false, false, -1, false, true)
    self:SetStackCount(tg.num)
end

function modifier_item_desolator_v2_debuff2:OnRefresh(tg)self:OnCreated(tg)
end

 function modifier_item_desolator_v2_debuff2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
   }
end

function modifier_item_desolator_v2_debuff2:GetModifierPhysicalArmorBonus()return  (0-self:GetStackCount())
end
