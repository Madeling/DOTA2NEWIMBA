tp_tp=class({})
LinkLuaModifier("modifier_tp_tp", "rd/tp_tp.lua", LUA_MODIFIER_MOTION_NONE)

function tp_tp:GetIntrinsicModifierName() 
    return "modifier_tp_tp" 
end

modifier_tp_tp=class({})

function modifier_tp_tp:IsDebuff() 			
    return false 
end

function modifier_tp_tp:IsPurgable() 			
    return false 
end

function modifier_tp_tp:IsPurgeException() 	
    return false 
end

function modifier_tp_tp:IsHidden()				
    return true 
end

function modifier_tp_tp:OnCreated() 	
    self.parent=self:GetParent()
    if IsServer() then  

    end 
end

function modifier_tp_tp:DeclareFunctions()
	return 
    {
        MODIFIER_EVENT_ON_TELEPORTED
	}
end

function modifier_tp_tp:OnTeleported(tg) 	
    if IsServer() then  
        if tg.unit==self.parent then 
            self.parent:AddItemByName("item_tpscroll")
            local tp = self.parent:GetItemInSlot(DOTA_ITEM_TP_SCROLL)
			if tp then
				tp:EndCooldown()
			end	
        end 
    end 
 end