item_pool_blink=item_pool_blink or class({})

function item_pool_blink:OnSpellStart() 
    target_point = self:GetCaster():GetAbsOrigin() + (self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()* (self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()
    self:GetCaster():EmitSound("DOTA_Item.BlinkDagger.Activate")
    ProjectileManager:ProjectileDodge(self:GetCaster())  
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, self:GetCaster())

	self:GetCaster():SetAbsOrigin(target_point)
	FindClearSpaceForUnit(self:GetCaster(), target_point, false)
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
    
    self:GetCaster():PerformAttack(self:GetCursorTarget(), false, true, true, false, false, false, true)

    self:SpendCharge()
    end