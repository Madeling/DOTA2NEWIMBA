item_premium_phase_boots=class({})

LinkLuaModifier("modifier_item_premium_phase_boots_pa", "items/item_premium_phase_boots.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_premium_phase_boots_buff", "items/item_premium_phase_boots.lua", LUA_MODIFIER_MOTION_NONE)

function item_premium_phase_boots:OnSpellStart()
	local caster = self:GetCaster()
    local dur = self:GetSpecialValueFor("dur")
    caster:EmitSound( "DOTA_Item.PhaseBoots.Activate" ) 
    caster:AddNewModifier( caster, self, "modifier_item_premium_phase_boots_buff", {duration=dur} )
end

function item_premium_phase_boots:GetIntrinsicModifierName() 
    return "modifier_item_premium_phase_boots_pa" 
end


modifier_item_premium_phase_boots_pa=class({})


function modifier_item_premium_phase_boots_pa:IsHidden() 			
    return true 
end

function modifier_item_premium_phase_boots_pa:IsPurgable() 		
    return false
end

function modifier_item_premium_phase_boots_pa:IsPurgeException() 
    return false 
end

function modifier_item_premium_phase_boots_pa:DeclareFunctions() 
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE, 
      --  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,GetModifierMoveSpeedBonus_Constant
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, 
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
    } 
end

function modifier_item_premium_phase_boots_pa:OnCreated()
    if self:GetAbility() == nil then
		return
	end
    self.sp=self:GetAbility():GetSpecialValueFor("sp")
    self.att=self:GetAbility():GetSpecialValueFor("att")
    self.ar=self:GetAbility():GetSpecialValueFor("ar")
    self.rate=self:GetAbility():GetSpecialValueFor("rate")
end

function modifier_item_premium_phase_boots_pa:GetModifierMoveSpeedBonus_Special_Boots() 
    return  self.sp 
end

function modifier_item_premium_phase_boots_pa:GetModifierPreAttack_BonusDamage() 
    return self.att
end

function modifier_item_premium_phase_boots_pa:GetModifierPhysicalArmorBonus() 
    return  self.ar
end

function modifier_item_premium_phase_boots_pa:GetModifierTurnRate_Percentage() 
    return  self.rate 
end


modifier_item_premium_phase_boots_buff=class({})


function modifier_item_premium_phase_boots_buff:IsHidden() 			
    return false 
end

function modifier_item_premium_phase_boots_buff:IsPurgable() 		
    return true
end

function modifier_item_premium_phase_boots_buff:IsPurgeException() 
    return true 
end

function modifier_item_premium_phase_boots_buff:GetTexture()
    return "item_premium_phase_boots" 
end


function modifier_item_premium_phase_boots_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_item_premium_phase_boots_buff:GetEffectName()
    return "particles/econ/events/ti10/phase_boots_ti10.vpcf" 
end

function modifier_item_premium_phase_boots_buff:CheckState() 
    return 
    {
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_CLIFFS] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    } 
end


function modifier_item_premium_phase_boots_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT
    } 
end

function modifier_item_premium_phase_boots_buff:OnCreated()
    if self:GetAbility() == nil then
		return
	end
    self.active_sp=self:GetAbility():GetSpecialValueFor("active_sp")
end

function modifier_item_premium_phase_boots_buff:GetModifierMoveSpeedBonus_Percentage() 
        return self.active_sp
end

function modifier_item_premium_phase_boots_buff:GetModifierMoveSpeed_Limit()
    return 3000
end

function modifier_item_premium_phase_boots_buff:GetModifierIgnoreMovespeedLimit()
    return 1
end
