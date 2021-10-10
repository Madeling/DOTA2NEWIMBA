item_hensin=class({})
LinkLuaModifier("modifier_item_hensin_buff",  "items/item_hensin.lua", LUA_MODIFIER_MOTION_NONE)
function item_hensin:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_ABSORIGIN_FOLLOW , target)
    ParticleManager:ReleaseParticleIndex(particle)
    target:AddNewModifier(caster, self, "modifier_item_hensin_buff", {duration = 60})
    self:SpendCharge()
end


modifier_item_hensin_buff=class({})

function modifier_item_hensin_buff:IsDebuff()			
    return false 
end

function modifier_item_hensin_buff:IsHidden() 		
    return false 
end

function modifier_item_hensin_buff:IsPurgable() 		
    return false 
end

function modifier_item_hensin_buff:IsPurgeException()
    return false 
end

function modifier_item_hensin_buff:RemoveOnDeath()
    return false 
end

function modifier_item_hensin_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_item_hensin_buff:GetTexture()
    return "item_hensin" 
end

function modifier_item_hensin_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MODEL_CHANGE,
    } 
end

function modifier_item_hensin_buff:GetModifierAttackSpeedBonus_Constant() 
    return 70
end

function modifier_item_hensin_buff:GetModifierModelChange() 	
    return  "models/creeps/ice_biome/relict/relict.vmdl"
end