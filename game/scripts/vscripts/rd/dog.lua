dog=class({})

LinkLuaModifier("modifier_dog", "rd/dog.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dog_buff", "rd/dog.lua", LUA_MODIFIER_MOTION_NONE)

function dog:GetIntrinsicModifierName() 
    return "modifier_dog" 
end


modifier_dog=class({})

function modifier_dog:IsPassive()
	return true
end

function modifier_dog:IsPurgable() 			
    return false 
end

function modifier_dog:IsPurgeException() 	
    return false 
end

function modifier_dog:IsHidden()				
    return true 
end

function modifier_dog:AllowIllusionDuplicate() 	
    return false 
end

function modifier_dog:IsAura()
    return true
end

function modifier_dog:GetAuraDuration() 
    return 0 
end

function modifier_dog:GetModifierAura() 
    return "modifier_dog_buff" 
end

function modifier_dog:GetAuraRadius() 
    return 1000
end

function modifier_dog:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_NONE
 end

function modifier_dog:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function modifier_dog:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO 
end


modifier_dog_buff=class({})

function modifier_dog_buff:IsPurgable() 			
    return false 
end

function modifier_dog_buff:IsPurgeException() 	
    return false 
end

function modifier_dog_buff:IsHidden()				
    return false 
end

function modifier_dog_buff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS
    }
end
function modifier_dog_buff:GetModifierHealAmplify_PercentageTarget()
    return  self.heal
end

function modifier_dog_buff:GetModifierHPRegenAmplify_Percentage()
    return self.heal
end

function modifier_dog_buff:GetModifierHealthBonus() 	
    return self.hp
end

function modifier_dog_buff:OnCreated()
    if self:GetAbility()==nil then 
        return 
    end 
    self.heal=self:GetAbility():GetSpecialValueFor( "heal")
    self.hp=self:GetAbility():GetSpecialValueFor( "hp")
end

function modifier_dog_buff:OnRefresh()
   self:OnCreated()
end