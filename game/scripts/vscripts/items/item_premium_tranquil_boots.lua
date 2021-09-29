item_premium_tranquil_boots=class({})

LinkLuaModifier("modifier_item_premium_tranquil_boots_pa", "items/item_premium_tranquil_boots.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_premium_tranquil_boots_buff", "items/item_premium_tranquil_boots.lua", LUA_MODIFIER_MOTION_NONE)

function item_premium_tranquil_boots:GetIntrinsicModifierName()
    return "modifier_item_premium_tranquil_boots_pa"
end

modifier_item_premium_tranquil_boots_pa=class({})

function modifier_item_premium_tranquil_boots_pa:IsHidden()
    return true
end

function modifier_item_premium_tranquil_boots_pa:IsPurgable()
    return false
end

function modifier_item_premium_tranquil_boots_pa:IsPurgeException()
    return false
end

function modifier_item_premium_tranquil_boots_pa:AllowIllusionDuplicate()
    return false
end

function modifier_item_premium_tranquil_boots_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_item_premium_tranquil_boots_pa:OnCreated()
    if self:GetAbility()==nil then
        return
    end
    self.sp=self:GetAbility():GetSpecialValueFor( "sp" )
    self.hr=self:GetAbility():GetSpecialValueFor( "hr" )
end


function modifier_item_premium_tranquil_boots_pa:GetModifierMoveSpeedBonus_Special_Boots()
    return self.sp
end

function modifier_item_premium_tranquil_boots_pa:GetModifierConstantHealthRegen()
    return self.hr
end

function modifier_item_premium_tranquil_boots_pa:OnTakeDamage(tg)
   if not IsServer() then
        return
   end

   if not self:GetAbility():IsCooldownReady() then
        return
    end

    if tg.unit==self:GetParent() and tg.damage>100 then
        self:GetParent():EmitSound( "DOTA_Item.TranquilBoots.Activate" )
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invisible", { duration=self:GetAbility():GetSpecialValueFor( "inv" ) })
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_premium_tranquil_boots_buff", { duration=self:GetAbility():GetSpecialValueFor( "inv" ) })
        self:GetAbility():UseResources(false, false, true)
    end

end


modifier_item_premium_tranquil_boots_buff=class({})

function modifier_item_premium_tranquil_boots_buff:IsBuff()
    return true
end

function modifier_item_premium_tranquil_boots_buff:IsHidden()
    return false
end

function modifier_item_premium_tranquil_boots_buff:IsPurgable()
    return false
end

function modifier_item_premium_tranquil_boots_buff:IsPurgeException()
    return false
end


function modifier_item_premium_tranquil_boots_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_premium_tranquil_boots_buff:GetEffectName()
    return "particles/items2_fx/tranquil_boots.vpcf"
end

function modifier_item_premium_tranquil_boots_buff:OnCreated()
    if self:GetAbility()==nil then
        return
    end
    self.hrp=self:GetAbility():GetSpecialValueFor( "hrp" )
end


function modifier_item_premium_tranquil_boots_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,

    }
end

function modifier_item_premium_tranquil_boots_buff:GetModifierHealthRegenPercentage()
    return self.hrp
end
