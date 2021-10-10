ambush_man = class({})


LinkLuaModifier("modifier_ambush_man_passive", "ting/ambush/ambush_man.lua", LUA_MODIFIER_MOTION_NONE)
function ambush_man:GetIntrinsicModifierName() return "modifier_ambush_man_passive" end
function ambush_man:Set_InitialUpgrade() return {LV=1} end
function ambush_man:OnUpgrade()
	if not IsServer() then return end
	local mod = self:GetCaster():FindModifierByName("modifier_ambush_man_passive")
	if mod then
		mod.range = self:GetSpecialValueFor("range")
		mod.cd = self:GetSpecialValueFor("cd")
		mod.b = false
		if IsServer() then
			mod:StartIntervalThink(0.3)
		end
	end
end
function ambush_man:RangedAttackerBreakInvisAttack(target)
	self:GetCaster():EmitSound("Ability.Assassinate")
	local info =
	{
		Target = target,
		Source = self:GetCaster(),
		Ability = self,
		EffectName = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf",
		iMoveSpeed = self:GetCaster():GetProjectileSpeed(),
		vSourceLoc = self:GetCaster():GetAbsOrigin(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = true,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function ambush_man:OnProjectileHit(target, location)
	if not target then
		return
	end
	local damage = self:GetSpecialValueFor("damage")+target:GetMaxHealth()*self:GetSpecialValueFor("damage_hp")*0.01
	ApplyDamage({victim = target, attacker = self:GetCaster(), ability = self, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
end


modifier_ambush_man_passive = class({})
function modifier_ambush_man_passive:IsPurgable()return false
end
function modifier_ambush_man_passive:IsPurgeException()return false
end
function modifier_ambush_man_passive:IsHidden()return true
end

function modifier_ambush_man_passive:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
			MODIFIER_EVENT_ON_ATTACK,
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			--MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_PROJECTILE_NAME,
			}

end
function modifier_ambush_man_passive:GetModifierAttackRangeBonus()
	return self.b and self.rb or 0
end
function modifier_ambush_man_passive:GetModifierProjectileName()
	return "particles/econ/items/sniper/sniper_witch_hunter/sniper_witch_hunter_base_attack.vpcf"
end
function modifier_ambush_man_passive:OnCreated()
	if self:GetAbility() == nil then return end
	self.ability = self:GetAbility()
	self.rb = 400
	self.cd = 2
	self.b = false
	self.parent = self:GetParent()
end

function modifier_ambush_man_passive:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self.parent or keys.target == self.parent then
			self.ability:StartCooldown(self.cd)
	end
	end
end

function modifier_ambush_man_passive:OnIntervalThink()
	if IsServer() then
		if self.ability:GetCooldownTimeRemaining() == 0 then
			self.b = true
		end
	end
end
function modifier_ambush_man_passive:OnAttack(keys)
	if IsServer() then
		if keys.attacker ~= self:GetParent() then
			return
		end

		if not keys.target:IsOther() and not keys.target:IsBuilding()  and self.b then
			self:GetAbility():RangedAttackerBreakInvisAttack(keys.target)
			self.b = false
			self.ability:StartCooldown(self.cd)
		end
	end
end
