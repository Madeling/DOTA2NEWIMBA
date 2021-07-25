modifier_data_cd=class({})

function modifier_data_cd:IsHidden() 			
    return false
end

function modifier_data_cd:IsPurgable() 			
    return false 
end

function modifier_data_cd:IsPurgeException() 	
    return false 
end

function modifier_data_cd:RemoveOnDeath() 	
    return false 
end

function modifier_data_cd:AllowIllusionDuplicate() 	
    return false 
end

function modifier_data_cd:GetTexture() 	
    return "red" 
end


