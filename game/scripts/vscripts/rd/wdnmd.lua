wdnmd=class({})

LinkLuaModifier("modifier_wdnmd", "rd/wdnmd.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wdnmd_buff", "rd/wdnmd.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wdnmd_debuff", "rd/wdnmd.lua", LUA_MODIFIER_MOTION_NONE)
function wdnmd:GetIntrinsicModifierName() 
    return "modifier_wdnmd" 
end


modifier_wdnmd=class({})

function modifier_wdnmd:IsPassive()
	return true
end

function modifier_wdnmd:IsPurgable() 			
    return false 
end

function modifier_wdnmd:IsPurgeException() 	
    return false 
end

function modifier_wdnmd:IsHidden()				
    return true 
end

function modifier_wdnmd:AllowIllusionDuplicate() 	
    return false 
end

function modifier_wdnmd:IsAura()
    return true
end

function modifier_wdnmd:GetAuraDuration() 
    return 0 
end

function modifier_wdnmd:GetModifierAura() 
    return "modifier_wdnmd_buff" 
end

function modifier_wdnmd:GetAuraRadius() 
    return 1000
end

function modifier_wdnmd:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_NONE
 end

function modifier_wdnmd:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function modifier_wdnmd:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC 
end


modifier_wdnmd_buff=class({})

function modifier_wdnmd_buff:IsPurgable() 			
    return false 
end

function modifier_wdnmd_buff:IsPurgeException() 	
    return false 
end

function modifier_wdnmd_buff:IsHidden()				
    return false 
end

function modifier_wdnmd_buff:DeclareFunctions()
	return 
    {
	    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
        MODIFIER_EVENT_ON_ATTACK_START 
	}
end

function modifier_wdnmd_buff:OnAttackStart(tg)
    if IsServer() then   
        if tg.attacker==self:GetParent() then   
            tg.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_wdnmd_debuff", {duration=2})
        end 
    end 
end

function modifier_wdnmd_buff:GetModifierStatusResistanceStacking()
    if self:GetAbility() then 
    	return self:GetAbility():GetSpecialValueFor("rs")
    end
end

function modifier_wdnmd_buff:GetModifierIgnoreCastAngle()
    return 1
end

function modifier_wdnmd_buff:GetModifierNoVisionOfAttacker()
    return 1
end


modifier_wdnmd_debuff=class({})

function modifier_wdnmd_debuff:IsHidden() 		
    return true 
end

function modifier_wdnmd_debuff:IsPurgable() 		
    return false 
end

function modifier_wdnmd_debuff:IsPurgeException() 
    return false 
end


function modifier_wdnmd_debuff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_DONT_GIVE_VISION_OF_ATTACKER,
    } 
end


function modifier_wdnmd_debuff:GetModifierNoVisionOfAttacker()
    return 1
end