kill_trees=class({})

LinkLuaModifier("modifier_kill_trees_buff", "rd/kill_trees.lua", LUA_MODIFIER_MOTION_NONE)

function kill_trees:GetIntrinsicModifierName() 
    return "modifier_kill_trees_buff" 
end

function kill_trees:OnToggle()
end

modifier_kill_trees_buff=class({})

function modifier_kill_trees_buff:IsPurgable() 			
    return false 
end

function modifier_kill_trees_buff:IsPurgeException() 	
    return false 
end

function modifier_kill_trees_buff:IsHidden()				
    return true 
end

function modifier_kill_trees_buff:DeclareFunctions()
	return 
    {
	    MODIFIER_EVENT_ON_UNIT_MOVED,
	}
end

function modifier_kill_trees_buff:OnUnitMoved(tg)
    if IsServer() then    
        if tg.unit==self:GetParent() and self:GetAbility():GetToggleState() then    
            GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(),300,false)
        end 
    end  
end