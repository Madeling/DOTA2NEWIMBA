item_eyes=class({})
function item_eyes:OnSpellStart()
        self:GetCursorTarget():EmitSound("Item.DropGemWorld")
        local particle = ParticleManager:CreateParticle("particles/tgp/items/eye/item_eyes0.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCursorTarget())
        ParticleManager:ReleaseParticleIndex(particle)
        local heroes = FindUnitsInRadius(self:GetCursorTarget():GetTeam(), self:GetCursorTarget():GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _, hero in pairs(heroes) do
			AddFOWViewer(self:GetCaster():GetTeamNumber(), hero:GetAbsOrigin(), self:GetSpecialValueFor("v"), self:GetSpecialValueFor("dur"), false)
        end
        self:SpendCharge()
end