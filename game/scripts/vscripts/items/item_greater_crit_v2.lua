item_greater_crit_v2 = class({})

LinkLuaModifier("modifier_item_greater_crit_v2_pa", "items/item_greater_crit_v2.lua", LUA_MODIFIER_MOTION_NONE)
function item_greater_crit_v2:GetIntrinsicModifierName() 
    return "modifier_item_greater_crit_v2_pa" 
end


modifier_item_greater_crit_v2_pa = class({})

function modifier_item_greater_crit_v2_pa:GetTexture()
    return "item_greater_crit_v2" 
end

function modifier_item_greater_crit_v2_pa:IsHidden() 			
    return true 
end

function modifier_item_greater_crit_v2_pa:IsPurgable() 			
    return false 
end

function modifier_item_greater_crit_v2_pa:IsPurgeException() 	
    return false 
end

function modifier_item_greater_crit_v2_pa:AllowIllusionDuplicate() 	
    return false 
end

function modifier_item_greater_crit_v2_pa:GetAttributes() 	
    return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_item_greater_crit_v2_pa:DeclareFunctions() 
    return
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, 
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        
   } 
end


function modifier_item_greater_crit_v2_pa:OnCreated() 
    self.crit = {} 
    self.parent=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.crit_=self.ability:GetSpecialValueFor("crit")
    self.dam=self.ability:GetSpecialValueFor("dam") 
    self.crit_ch=self.ability:GetSpecialValueFor("crit_ch")
    self.crit_ch2=self.ability:GetSpecialValueFor("crit_ch2")
    self.crit_m=self.ability:GetSpecialValueFor("crit_m")
    self.crit_m2=self.ability:GetSpecialValueFor("crit_m2")
end


function modifier_item_greater_crit_v2_pa:GetModifierPreAttack_CriticalStrike(tg)
        if tg.attacker == self.parent and not tg.target:IsBuilding() and not self.parent:IsIllusion()  then
            self.crit[tg.record] = true
            if RollPseudoRandomPercentage( self.crit_ch,0,self.parent) then
                self.crit[tg.record] = false
                self.parent:EmitSound("DOTA_Item.Daedelus.Crit")
                if self.parent:HasItemInInventory("item_three_knives") then 
                    return self.crit_m+50
                else 
                    return self.crit_m
                end 
            elseif RollPseudoRandomPercentage(self.crit_ch2,0,self.parent) then
                self.parent:EmitSound("DOTA_Item.Daedelus.Crit")
                if self.parent:HasItemInInventory("item_three_knives") then 
                    return self.crit_m2+50
                else 
                    return self.crit_m2
                end 
            else
                return 0
            end
        end 
end

function modifier_item_greater_crit_v2_pa:GetModifierPreAttack_BonusDamage() 
        return self.dam 
end

