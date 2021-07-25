
modifier_gnm=class({})

function modifier_gnm:IsHidden() 			
    return false
end

function modifier_gnm:IsPurgable() 			
    return false 
end

function modifier_gnm:IsPurgeException() 	
    return false 
end

function modifier_gnm:RemoveOnDeath() 	
    return false 
end

function modifier_gnm:IsPermanent() 	
    return true 
end

function modifier_gnm:AllowIllusionDuplicate() 	
    return false 
end




