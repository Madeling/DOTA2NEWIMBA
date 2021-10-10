item_amulet=item_amulet or class({})

LinkLuaModifier("modifier_item_amulet_pa", "items/item_amulet.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_amulet_debuff", "items/item_amulet.lua", LUA_MODIFIER_MOTION_NONE)

function item_amulet:GetIntrinsicModifierName() 
    return "modifier_item_amulet_pa" 
end

modifier_item_amulet_pa=modifier_item_amulet_pa or class({})

function modifier_item_amulet_pa:IsPassive()			
    return true 
end

function modifier_item_amulet_pa:IsHidden() 			
    return true 
end

function modifier_item_amulet_pa:IsPurgable() 		
    return false
end

function modifier_item_amulet_pa:IsPurgeException() 
    return false 
end



function modifier_item_amulet_pa:OnCreated() 
    local ab=self:GetAbility()
    self.hp=ab:GetSpecialValueFor("hp")
    self.hpp=ab:GetSpecialValueFor("hpp")
    self.addhp=ab:GetSpecialValueFor("addhp")
    self.dur=ab:GetSpecialValueFor("dur")
end


function modifier_item_amulet_pa:DeclareFunctions() 
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    } 
end
function modifier_item_amulet_pa:GetModifierHealthBonus()
    return self.hp
end

function modifier_item_amulet_pa:GetModifierBonusStats_Strength() 
    return  self.hpp
end

modifier_item_amulet_debuff=modifier_item_amulet_debuff or class({})

function modifier_item_amulet_debuff:IsBuff()			
    return true 
end

function modifier_item_amulet_debuff:IsHidden() 			
    return false 
end

function modifier_item_amulet_debuff:IsPurgable() 		
    return false
end

function modifier_item_amulet_debuff:IsPurgeException() 
    return false 
end

function modifier_item_amulet_debuff:IsPurgeException() 
    return false 
end

function modifier_item_amulet_debuff:GetTexture()			
    return "item_amulet"
end


function modifier_item_amulet_debuff:OnCreated(tg) 
    if IsServer() then
    self:SetStackCount(math.ceil(tg.health))
end
end

function modifier_item_amulet_debuff:OnDestroy() 
    if IsServer() then
    self:SetStackCount(0)
end
end


function modifier_item_amulet_debuff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    } 
end
function modifier_item_amulet_debuff:GetModifierExtraHealthBonus()
    return  self:GetStackCount()
end