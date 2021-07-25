reduce=class({})

LinkLuaModifier("modifier_reduce_buff", "rd/reduce.lua", LUA_MODIFIER_MOTION_NONE)

function reduce:GetIntrinsicModifierName() 
    return "modifier_reduce_buff" 
end

modifier_reduce_buff=class({})

function modifier_reduce_buff:IsPurgable() 			
    return false 
end

function modifier_reduce_buff:IsPurgeException() 	
    return false 
end

function modifier_reduce_buff:IsHidden()				
    return true 
end

function modifier_reduce_buff:DeclareFunctions()
	return 
    {
	    MODIFIER_PROPERTY_MODEL_SCALE,
	}
end

function modifier_reduce_buff:GetModifierModelScale()
    if self:GetAbility() then 
    	return 0-self:GetAbility():GetSpecialValueFor("s")
    end
    return 0
end


function modifier_reduce_buff:CheckState() 
	return 
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true, 
	} 
end