

item_magic_shoes=class({})
LinkLuaModifier("modifier_item_magic_shoes_pa", "items/item_magic_shoes.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_magic_shoes_buff", "items/item_magic_shoes.lua", LUA_MODIFIER_MOTION_NONE)

function item_magic_shoes:GetIntrinsicModifierName() 
    return "modifier_item_magic_shoes_pa" 
end

function item_magic_shoes:IsRefreshable() 			
    return false 
end

modifier_item_magic_shoes_pa=  class({})

function modifier_item_magic_shoes_pa:IsPassive()			
    return true 
end


function modifier_item_magic_shoes_pa:IsHidden() 			
    return true 
end

function modifier_item_magic_shoes_pa:IsPurgable() 		
    return false
end

function modifier_item_magic_shoes_pa:IsPurgeException() 
    return false 
end

function modifier_item_magic_shoes_pa:AllowIllusionDuplicate() 
    return false 
end


function modifier_item_magic_shoes_pa:GetModifierAttackSpeedBonus_Constant() 
    return  self.attsp
end

function modifier_item_magic_shoes_pa:GetModifierConstantManaRegen() 
    return self.mana
end

function modifier_item_magic_shoes_pa:GetModifierMagicalResistanceBonus() 
    return self.bmr
end

function modifier_item_magic_shoes_pa:GetModifierMoveSpeedBonus_Special_Boots() 
    return self.sp
end

function modifier_item_magic_shoes_pa:DeclareFunctions() 
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
    } 
end

function modifier_item_magic_shoes_pa:OnCreated(tg) 
    self.CD=self:GetAbility():GetSpecialValueFor( "cd" )
    self.indur=self:GetAbility():GetSpecialValueFor( "indur" )
    self.attsp=self:GetAbility():GetSpecialValueFor( "attsp" )
    self.mana=self:GetAbility():GetSpecialValueFor( "mana" )
    self.bmr=self:GetAbility():GetSpecialValueFor( "bmr" )
    self.sp=self:GetAbility():GetSpecialValueFor( "sp" )
    if not IsServer() then
        return
    end
    self:OnIntervalThink()
    self:StartIntervalThink(1)
end


function modifier_item_magic_shoes_pa:OnIntervalThink()
    if  self:GetAbility():IsCooldownReady() and not self:GetParent():HasModifier("modifier_item_magic_shoes_buff") and self:GetParent():IsAlive() then
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_magic_shoes_buff", {})
    end
end

function modifier_item_magic_shoes_pa:OnRemoved()
    if IsServer() then
            if self:GetParent():HasModifier("modifier_item_magic_shoes_buff") then
                self:GetParent():RemoveModifierByName("modifier_item_magic_shoes_buff")
            end
    end
end

function modifier_item_magic_shoes_pa:OnTakeDamage(tg) 
    if not IsServer() then
        return
    end

    if tg.unit==self:GetParent() and tg.damage_type==2 and  self:GetAbility():IsCooldownReady() then
        if self:GetParent():HasModifier("modifier_item_magic_shoes_buff")then
            self:GetAbility():UseResources(false, false, true)
            self:GetParent():RemoveModifierByName("modifier_item_magic_shoes_buff")
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invisible", {duration=self.indur})
            --self:GetParent():Purge(false,true,false,false,false)
        end
    end
end

modifier_item_magic_shoes_buff=class({})


function modifier_item_magic_shoes_buff:IsHidden() 			
    return false 
end

function modifier_item_magic_shoes_buff:IsPurgable() 		
    return true
end

function modifier_item_magic_shoes_buff:IsPurgeException() 
    return true 
end


function modifier_item_magic_shoes_buff:RemoveOnDeath() 
    return true 
end

function modifier_item_magic_shoes_buff:GetTexture()			
    return "item_mgsh"
end

function modifier_item_magic_shoes_buff:OnCreated(tg) 
    self.mr=self:GetAbility():GetSpecialValueFor( "mr" )
end


function modifier_item_magic_shoes_buff:DeclareFunctions() 
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    } 
end

function modifier_item_magic_shoes_buff:GetModifierMagicalResistanceBonus() 
    return  self.mr
end