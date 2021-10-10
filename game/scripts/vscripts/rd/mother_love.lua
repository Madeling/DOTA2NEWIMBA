mother_love=class({})

LinkLuaModifier("modifier_mother_love", "rd/mother_love.lua", LUA_MODIFIER_MOTION_NONE)

function mother_love:GetIntrinsicModifierName() 
    return "modifier_mother_love" 
end

modifier_mother_love=class({})

function modifier_mother_love:IsPurgable() 			
    return false 
end

function modifier_mother_love:IsPurgeException() 	
    return false 
end

function modifier_mother_love:IsHidden()				
    return true 
end

function modifier_mother_love:AllowIllusionDuplicate()				
    return false 
end


function modifier_mother_love:DeclareFunctions()
	return 
    {
	    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end


function modifier_mother_love:GetModifierIncomingDamage_Percentage(tg)
    if tg.target==self:GetParent() and TableContainsKey(Female_HERO,tg.attacker:GetName()) then 
    	return self:GetAbility():GetSpecialValueFor("dmg")
    end
    return 0
end
