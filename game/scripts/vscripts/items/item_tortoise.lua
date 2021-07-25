item_tortoise= class({})

LinkLuaModifier("modifier_item_tortoise_pa", "items/item_tortoise.lua", LUA_MODIFIER_MOTION_NONE)

function item_tortoise:GetIntrinsicModifierName() 
    return "modifier_item_tortoise_pa" 
end

modifier_item_tortoise_pa=modifier_item_tortoise_pa or class({})

function modifier_item_tortoise_pa:IsPassive()			
    return true 
end

function modifier_item_tortoise_pa:IsHidden() 			
    return true 
end

function modifier_item_tortoise_pa:IsPurgable() 		
    return false
end

function modifier_item_tortoise_pa:IsPurgeException() 
    return false 
end

function modifier_item_tortoise_pa:AllowIllusionDuplicate() 
    return false 
end


function modifier_item_tortoise_pa:OnAttackLanded(tg) 
    if not IsServer() then
        return
    end
        if tg.target==self:GetParent() and tg.attacker:IsRealHero() then
            if PseudoRandom:RollPseudoRandom(self:GetAbility(), self.disarmed_ch) then 
                    if not tg.attacker:IsMagicImmune() then
                        TG_AddNewModifier_RS(tg.attacker,tg.target,self:GetAbility(),"modifier_disarmed",{duration=self.disarmed_dur})
                    end
            end
        end
end


function modifier_item_tortoise_pa:OnCreated() 
    if self:GetAbility() == nil then
		return
	end
    local ab=self:GetAbility()
    self.armor=ab:GetSpecialValueFor("armor")
    self.attsp=ab:GetSpecialValueFor("attsp")
    self.dam=ab:GetSpecialValueFor("dam")
    self.disarmed_dur=ab:GetSpecialValueFor("disarmed_dur")
    self.disarmed_ch=ab:GetSpecialValueFor("disarmed_ch")
end


function modifier_item_tortoise_pa:DeclareFunctions() 
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
        MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
    } 
end


function modifier_item_tortoise_pa:GetModifierPhysicalArmorBonus() 
    return   self.armor
end

function modifier_item_tortoise_pa:GetModifierBaseAttackTimeConstant() 
    return   self.attsp
end

function modifier_item_tortoise_pa:GetModifierIncomingPhysicalDamage_Percentage(tg) 
    if tg.target~=self:GetParent() then    
		return  0
	end 
    if self:GetParent():PassivesDisabled() then
        return 0
    else
        local dam=0-(math.floor(self:GetParent():GetMaxHealth()/1000)*self.dam)
        if dam<-20 then 
            return -20
        else 
            return dam
        end  
    end
end

