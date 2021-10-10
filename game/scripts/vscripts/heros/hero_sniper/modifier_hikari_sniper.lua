modifier_hikari_sniper=class({})

function modifier_hikari_sniper:IsHidden() 			
	return false 
end

function modifier_hikari_sniper:IsPurgable() 		
	return false 
end

function modifier_hikari_sniper:IsPurgeException() 	
	return false 
end

function modifier_hikari_sniper:RemoveOnDeath() 	
	return false 
end

function modifier_hikari_sniper:IsPermanent() 	
	return true 
end

function modifier_hikari_sniper:GetTexture() 	
	return self:GetUnitName() 
end