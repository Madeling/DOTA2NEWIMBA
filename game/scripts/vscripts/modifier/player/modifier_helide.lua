modifier_helide=class({})

function modifier_helide:IsHidden() 			
    return true
end

function modifier_helide:IsPurgable() 			
    return false 
end

function modifier_helide:IsPurgeException() 	
    return false 
end

function modifier_helide:AllowIllusionDuplicate() 	
    return false 
end
