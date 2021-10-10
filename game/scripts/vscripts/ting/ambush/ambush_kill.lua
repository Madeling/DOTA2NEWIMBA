ambush_kill = class({})

LinkLuaModifier("modifier_ambush_kill_armor", "ting/ambush/ambush_kill.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_stunned", "ting/yinjianren/bait.lua", LUA_MODIFIER_MOTION_NONE)

function ambush_kill:IsHiddenWhenStolen() 		return false end
function ambush_kill:IsRefreshable() 			return true end
function ambush_kill:IsStealable() 				return true end
function ambush_kill:IsNetherWardStealable()	return true end
function ambush_kill:GetAOERadius()	return 600 end

function ambush_kill:OnSpellStart()
	if IsServer() then
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local rocket_dummy = CreateModifierThinker(self:GetCaster(), self, nil, {duration = 5},	pos, self:GetCaster():GetTeamNumber(), false)
	local rocket_particle = ParticleManager:CreateParticle("particles/tgp/sniper/rpg_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(rocket_particle, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1")))
	ParticleManager:SetParticleControl(rocket_particle, 1, pos)
	ParticleManager:SetParticleControl(rocket_particle, 2, Vector(1800, 0, 0))

	caster:EmitSound("Ability.Assassinate")
			local rocket =
						{
							Target 				= rocket_dummy,
							Source 				= self:GetCaster(),
							Ability 			= self,
							iMoveSpeed			= 1800,
							vSourceLoc 			= self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1")),
							bDrawsOnMinimap 	= true,
							bDodgeable 			= true,
							bIsAttack 			= false,
							bVisibleToEnemies 	= true,
							bReplaceExisting 	= false,
							flExpireTime 		= GameRules:GetGameTime() + 20,
							bProvidesVision 	= true,
							iVisionRadius 		= 400,
							iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),

							ExtraData = {rocket_particle = rocket_particle}
							}
		ProjectileManager:CreateTrackingProjectile(rocket)
		EmitSoundOn("Hero_Rattletrap.Rocket_Flare.Fire", self:GetCaster())
	end

end



function ambush_kill:OnProjectileHit_ExtraData(target, location, keys)
	--local thinker = EntIndexToHScript(keys.thinker)
	ParticleManager:DestroyParticle(keys.rocket_particle, false)
	ParticleManager:ReleaseParticleIndex(keys.rocket_particle)
	EmitSoundOnLocationWithCaster(location, "Hero_Rattletrap.Rocket_Flare.Explode", self:GetCaster())
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local stun = self:GetSpecialValueFor("stun_duration")
	local damageTable = {
						attacker = caster,
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self, --Optional.
								}
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(caster,self,"modifier_ambush_kill_armor",{duration = duration})
			enemy:AddNewModifier(caster,self,"modifier_imba_stunned",{duration = stun})

			damageTable.victim = enemy
			damageTable.damage = damage
			ApplyDamage(damageTable)
		end


end

modifier_ambush_kill_armor = class({})

function modifier_ambush_kill_armor:IsDebuff()			return true end
function modifier_ambush_kill_armor:IsHidden() 			return false end
function modifier_ambush_kill_armor:IsPurgable() 			return false end
function modifier_ambush_kill_armor:IsPurgeException() 	return false end
function modifier_ambush_kill_armor:ShouldUseOverheadOffset() return true end
function modifier_ambush_kill_armor:OnCreated()
	self.armor = self:GetAbility():GetSpecialValueFor("armor_re")
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_armor_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
		self:SetStackCount(0)
		self:OnRefresh()
	end
end
function modifier_ambush_kill_armor:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + 1)
	end
end
function modifier_ambush_kill_armor:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_ambush_kill_armor:GetModifierPhysicalArmorBonus()
	return 0 - self.armor*self:GetStackCount()
end
