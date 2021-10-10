bait = class({})
LinkLuaModifier("bait_buff", "ting/yinjianren/bait.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_stunned", "ting/yinjianren/bait.lua", LUA_MODIFIER_MOTION_NONE)
--function imba_bristleback_hairball:GetIntrinsicModifierName() return "modifier_goo_auto" end
function bait:IsHiddenWhenStolen() 		return false end
function bait:IsRefreshable() 			return true  end
function bait:IsStealable() 			return false  end


function bait:OnSpellStart()
	self.caster = self:GetCaster()
	self.team = self.caster:GetTeamNumber()

--	self.root_radius = self:GetSpecialValueFor("root_radius")
--	self.root = self:GetSpecialValueFor("root")

	EmitSoundOn("Hero_Sniper.attack", self.caster)
	self.pos = self:GetCursorPosition()
	local speed = 2000
	local distance = (self.pos - self.caster:GetAbsOrigin()):Length2D()
	local direction = (self.pos - self.caster:GetAbsOrigin()):Normalized()
	direction.z = 0
		local pfxname ="particles/units/heroes/hero_sniper/sniper_shard_concussive_grenade_model.vpcf"
		local flamebreak_particle = ParticleManager:CreateParticle(pfxname, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(flamebreak_particle, 0, self:GetCaster():GetAbsOrigin() + Vector(0, -50, 128))
	ParticleManager:SetParticleControl(flamebreak_particle, 1, Vector(speed,0,0))
	ParticleManager:SetParticleControl(flamebreak_particle, 5, self:GetCursorPosition())
	--self.caster:AddNewModifier(self.caster, self, "bait_debug", {duration = 5})
	--[[
	                Timers:CreateTimer(time_bait, function()
				local bait = CreateUnitByName("npc_sniper_bait", self.pos, true, self.caster, self.caster, self.caster:GetTeamNumber())
					bait:SetOwner(self.caster)
					bait:SetBaseMaxHealth(hp)
					bait:SetMaxHealth(hp)
					bait:SetHealth(hp)
					bait:AddNewModifier(self.caster, self, "bait_buff", {duration = duration,pfx = flamebreak_particle})
                end)
					Timers:CreateTimer(10, function()
					if 	flamebreak_particle	then
						ParticleManager:DestroyParticle(flamebreak_particle, false)
						ParticleManager:ReleaseParticleIndex(flamebreak_particle)
					end
                end)]]
	local info =
	{
		Ability = self,
		EffectName = "",
		vSpawnOrigin = self.caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = 0,
		fEndRadius = 0,
		Source = self.caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_NONE,
		bDeleteOnHit = true,
		vVelocity = direction * speed,
		bProvidesVision = false,
		ExtraData = {pfx = flamebreak_particle}
	}
	ProjectileManager:CreateLinearProjectile(info)
end


function bait:OnProjectileHit_ExtraData(target, pos, keys)
					local hp = self:GetSpecialValueFor("hp")
					local duration = self:GetSpecialValueFor("duration")
					local bait = CreateUnitByName("npc_sniper_bait", pos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
					bait:SetOwner(self:GetCaster())
					bait:SetBaseMaxHealth(hp)
					bait:SetMaxHealth(hp)
					bait:SetHealth(hp)
					bait:AddNewModifier(self:GetCaster(), self, "bait_buff", {duration = duration})
	if keys.pfx then
		ParticleManager:DestroyParticle(keys.pfx, false)
		ParticleManager:ReleaseParticleIndex(keys.pfx)

	end

end
bait_buff = class({})
LinkLuaModifier("modifier_imba_stunned", "ting/yinjianren/bait.lua", LUA_MODIFIER_MOTION_NONE)
function bait_buff:OnCreated(keys)

	if self:GetAbility() == nil then return end

	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.radius =self.ability:GetSpecialValueFor("radius")
	self.taunt_time = self.ability:GetSpecialValueFor("taunt")
	self.stun_time = self.ability:GetSpecialValueFor("stun")
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.pfx = keys.pfx


	if IsServer() then
		self.parent:EmitSound("Hero_Axe.Battle_Hunger")
		self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)
		local pfx = ParticleManager:CreateParticle("particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf", PATTACH_ABSORIGIN,self.parent)
		ParticleManager:SetParticleControl(pfx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, self.parent:GetAttachmentOrigin(self.parent:ScriptLookupAttachment("attach_mouth")))
		ParticleManager:SetParticleControl(pfx, 2, Vector(self.radius, self.radius, self.radius))
		self.damageTable =  {
							attacker = self.parent,
							damage = self.damage,
							damage_type = self.ability:GetAbilityDamageType(),
							ability = self.ability, --Optional.
							}
		self:GetParent():SetModelScale(3.0)
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier_RS(self.parent, self.ability, "modifier_huskar_life_break_taunt", {duration = self.taunt_time})
		end

	end
end


function bait_buff:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end

function bait_buff:IsHidden()
	return false
end
function bait_buff:IsPurgable()
	return false
end
function bait_buff:IsPurgeException()
	return false
end


function bait_buff:OnDestroy()
	if IsServer() then
		local pfxname ="particles/units/heroes/hero_sniper/sniper_shard_concussive_grenade_model.vpcf"
		local flamebreak_particle = ParticleManager:CreateParticle(pfxname, PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(flamebreak_particle, 0, self.parent:GetAbsOrigin())
			ParticleManager:SetParticleControl(flamebreak_particle, 1, Vector(1,0,0))
			ParticleManager:SetParticleControl(flamebreak_particle, 5, self.parent:GetAbsOrigin())
			ParticleManager:DestroyParticle(flamebreak_particle, false)
			ParticleManager:ReleaseParticleIndex(flamebreak_particle)
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier_RS(self.parent, self.ability, "modifier_imba_stunned", {duration = self.stun_time})
		--	if self.pfx then
		--			ParticleManager:DestroyParticle(self.pfx, false)
		--			ParticleManager:ReleaseParticleIndex(self.pfx)
		--	end
			self.damageTable.victim = enemy
			ApplyDamage(self.damageTable)
		end

		--self.caster:RemoveModifierByName("bait_debug")
		self.parent:EmitSound("Hero_Rattletrap.Rocket_Flare.Explode")
		--UTIL_Remove(self.parent)
		self.parent:ForceKill(false)
		--CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_imba_tiny_avalanche_thinker", { duration = self:GetChannelTime() }, self:GetCaster():GetOrigin(), self:GetCaster():GetTeamNumber(), false )
	end
end

modifier_imba_stunned = class({})

function modifier_imba_stunned:IsDebuff()			return true end
function modifier_imba_stunned:IsHidden() 			return false end
function modifier_imba_stunned:IsPurgable() 		return false end
function modifier_imba_stunned:IsPurgeException() 	return true end
function modifier_imba_stunned:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_imba_stunned:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_imba_stunned:GetOverrideAnimation() return ACT_DOTA_DISABLED end
function modifier_imba_stunned:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_imba_stunned:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_stunned:ShouldUseOverheadOffset() return true end
