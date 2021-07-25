modifier_kill_illusion=class({})

function modifier_kill_illusion:IsHidden() 			
    return false 
end

function modifier_kill_illusion:IsPurgable() 			
    return false 
end

function modifier_kill_illusion:IsPurgeException() 	
    return false 
end

function modifier_kill_illusion:OnDestroy() 	
   if IsServer() then 
    self:GetParent():Kill(nil, self:GetParent())
   end
end