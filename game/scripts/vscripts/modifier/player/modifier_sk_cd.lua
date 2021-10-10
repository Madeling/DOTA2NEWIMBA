modifier_sk_cd=class({})

function modifier_sk_cd:IsHidden() 			
    return false
end

function modifier_sk_cd:IsPurgable() 			
    return false 
end

function modifier_sk_cd:IsPurgeException() 	
    return false 
end

function modifier_sk_cd:RemoveOnDeath() 	
    return false 
end

function modifier_sk_cd:AllowIllusionDuplicate() 	
    return false 
end

function modifier_sk_cd:GetTexture() 	
    return "ahlm" 
end


