--hero_grimstroke.lua
CreateTalents("npc_dota_hero_grimstroke", "linken/hero_grimstroke.lua")


imba_grimstroke_dark_artistry = class({})

LinkLuaModifier("modifier_imba_dark_artistry_debuff", "linken/hero_grimstroke.lua", LUA_MODIFIER_MOTION_NONE)

function imba_grimstroke_dark_artistry:IsHiddenWhenStolen() 	return true end
function imba_grimstroke_dark_artistry:IsStealable() 			return false end
function imba_grimstroke_dark_artistry:IsRefreshable() 			return true end
function imba_grimstroke_dark_artistry:GetCastRange() return self:GetSpecialValueFor("cast_range") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_grimstroke_1") + self:GetCaster():GetCastRangeBonus() end
function imba_grimstroke_dark_artistry:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Grimstroke.DarkArtistry.PreCastPoint")
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_cast2_ground.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(self.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	return true
end

function imba_grimstroke_dark_artistry:OnAbilityPhaseInterrupted()
	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, true)
		ParticleManager:ReleaseParticleIndex(self.pfx)
		self.pfx = nil
	end
	self:GetCaster():StopSound("Hero_Grimstroke.DarkArtistry.PreCastPoint")
end
function imba_grimstroke_dark_artistry:OnSpellStart(bNoSoulbind)
	local caster = self:GetCaster()
	self.auto = self:GetAutoCastState()
	caster:EmitSound("Hero_Grimstroke.DarkArtistry.Cast")
	local stack = caster:GetModifierStackCount("modifier_imba_soul_chain_stack", nil)
	local ability = caster:FindAbilityByName("imba_grimstroke_soul_chain")
	local add = 0
	if ability and ability:IsTrained()  then
		add = stack * ability:GetSpecialValueFor("art_bonus")
	end
	self.pos = caster:GetAbsOrigin()
	self.distance = self:GetSpecialValueFor("cast_range") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_grimstroke_1") + add + self:GetCaster():GetCastRangeBonus()
	if not self.auto or bNoSoulbind then
		self.hit_info = self.hit_info or {}
		self.soulbind_info = self.soulbind_info or {}
		self.hit_pfx_name = "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_dmg.vpcf"
		local pos = self:GetCursorPosition()
		local start_pos = GetGroundPosition((caster:GetAbsOrigin() + caster:GetRightVector() * -150), nil)
		local direction = GetDirection2D(pos, start_pos)
		local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 10.0}, start_pos, caster:GetTeamNumber(), false)
		sound:EmitSound("Hero_Grimstroke.DarkArtistry.Projectile")

		local info =
		{
			Ability = self,
			EffectName = "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_proj.vpcf",
			vSpawnOrigin = start_pos,
			fDistance = self.distance,
			fStartRadius = self:GetSpecialValueFor("start_radius"),
			fEndRadius = self:GetSpecialValueFor("end_radius"),
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = direction * (self:GetSpecialValueFor("projectile_speed") + caster:TG_GetTalentValue("special_bonus_imba_grimstroke_1")),
			bProvidesVision = false,
			ExtraData = {sound = sound:entindex()}
		}
		local i = ProjectileManager:CreateLinearProjectile(info)
		self.hit_info[i] = 0
		self.soulbind_info[i] = bNoSoulbind
	elseif self.auto then
		local pos = self:GetCursorPosition()
		local caster_pos = self:GetCaster():GetAbsOrigin()
		local start_pos = caster_pos + GetDirection2D(pos, caster_pos) * 1200
		local start_pos_1 = GetGroundPosition((start_pos + caster:GetRightVector() * -450), nil)
		local start_pos_2 = GetGroundPosition((start_pos + caster:GetRightVector() * 450), nil)
		local start_pos_3 = GetGroundPosition(((caster_pos + GetDirection2D(pos, caster_pos) * 700) + caster:GetRightVector() * -450), nil)
		local start_pos_4 = GetGroundPosition((caster_pos + GetDirection2D(pos, caster_pos) * 1000), nil)
		local start_pos_5 = GetGroundPosition(((caster_pos + GetDirection2D(pos, caster_pos) * 550) + caster:GetRightVector() * -150), nil)
		local start_pos_6 = GetGroundPosition(((caster_pos + GetDirection2D(pos, caster_pos) * 550) + caster:GetRightVector() * 150), nil)

		local end_pos_1 = GetGroundPosition(((caster_pos + GetDirection2D(pos, caster_pos) * 800) + caster:GetRightVector() * 450), nil)
		local end_pos_2 = GetGroundPosition(((caster_pos + GetDirection2D(pos, caster_pos) * 800) + caster:GetRightVector() * -450), nil)
		local end_pos_3 = GetGroundPosition(((caster_pos + GetDirection2D(pos, caster_pos) * 700) + caster:GetRightVector() * 450), nil)
		local end_pos_4 = GetGroundPosition((caster_pos + GetDirection2D(pos, caster_pos) * 50), nil)
		local end_pos_5 = GetGroundPosition(((caster_pos + GetDirection2D(pos, caster_pos) * 250) + caster:GetRightVector() * -550), nil)
		local end_pos_6 = GetGroundPosition(((caster_pos + GetDirection2D(pos, caster_pos) * 250) + caster:GetRightVector() * 550), nil)


		local int_1 = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 5.0}, start_pos_1, caster:GetTeamNumber(), false)
		local int_2 = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 5.0}, start_pos_2, caster:GetTeamNumber(), false)
		local int_3 = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 5.0}, start_pos_3, caster:GetTeamNumber(), false)
		local int_4 = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 5.0}, start_pos_4, caster:GetTeamNumber(), false)
		local int_5 = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 5.0}, start_pos_5, caster:GetTeamNumber(), false)
		local int_6 = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 5.0}, start_pos_6, caster:GetTeamNumber(), false)

		local int = (self:GetSpecialValueFor("projectile_speed") + caster:TG_GetTalentValue("special_bonus_imba_grimstroke_1"))
		local info =
		{
			Ability = self,
			EffectName = "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_proj.vpcf",
			vSpawnOrigin = start_pos,
			fDistance = self:GetCastRange(pos, caster) + caster:GetCastRangeBonus(),
			fStartRadius = self:GetSpecialValueFor("start_radius"),
			fEndRadius = self:GetSpecialValueFor("end_radius"),
			Source = int_1,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = 100,
			bProvidesVision = false,
			ExtraData = {}
		}
		info.vSpawnOrigin = start_pos_1
		info.fDistance	  =	TG_Distance(end_pos_1, start_pos_1)
		info.vVelocity 	  = GetDirection2D(end_pos_1, start_pos_1) * int
		ProjectileManager:CreateLinearProjectile(info)

		Timers:CreateTimer(0.2, function()
			info.vSpawnOrigin = start_pos_2
			info.fDistance	  =	TG_Distance(end_pos_2, start_pos_2)
			info.vVelocity 	  = GetDirection2D(end_pos_2, start_pos_2) * int
			ProjectileManager:CreateLinearProjectile(info)
			return nil
		end)

		Timers:CreateTimer(0.4, function()
			info.vSpawnOrigin = start_pos_3
			info.fDistance	  =	TG_Distance(end_pos_3, start_pos_3)
			info.vVelocity 	  = GetDirection2D(end_pos_3, start_pos_3) * int
			ProjectileManager:CreateLinearProjectile(info)
			return nil
		end)
		Timers:CreateTimer(0.6, function()
			info.vSpawnOrigin = start_pos_4
			info.fDistance	  =	TG_Distance(end_pos_4, start_pos_4)
			info.vVelocity 	  = GetDirection2D(end_pos_4, start_pos_4) * int
			ProjectileManager:CreateLinearProjectile(info)
			return nil
		end)
		Timers:CreateTimer(0.8, function()
			info.vSpawnOrigin = start_pos_5
			info.fDistance	  =	TG_Distance(end_pos_5, start_pos_5)
			info.vVelocity 	  = GetDirection2D(end_pos_5, start_pos_5) * int
			ProjectileManager:CreateLinearProjectile(info)
			return nil
		end)
		Timers:CreateTimer(1.0, function()
			info.vSpawnOrigin = start_pos_6
			info.fDistance	  =	TG_Distance(end_pos_6, start_pos_6)
			info.vVelocity 	  = GetDirection2D(end_pos_6, start_pos_6) * int
			ProjectileManager:CreateLinearProjectile(info)
			return nil
		end)
	end
end

function imba_grimstroke_dark_artistry:OnProjectileThink_ExtraData(pos, keys)
	if not self.auto then
		if keys.sound and not EntIndexToHScript(keys.sound):IsNull() then
			EntIndexToHScript(keys.sound):SetAbsOrigin(pos)
		end
		AddFOWViewer(self:GetCaster():GetTeamNumber(), pos, self:GetSpecialValueFor("end_radius"), self:GetSpecialValueFor("vision_duration"), false)
	end
end

function imba_grimstroke_dark_artistry:OnProjectileHitHandle(target, pos, i)
	if not self.auto then
		if target then
			local direction = TG_Distance(pos, self.pos)
			local dam_int = direction / self:GetSpecialValueFor("shard_range")
			local dmg = self:GetSpecialValueFor("damage") + self.hit_info[i] * self:GetSpecialValueFor("bonus_damage_per_target")
			if self:GetCaster():Has_Aghanims_Shard() and target:IsHero() then
				dmg = (self:GetSpecialValueFor("damage") + self.hit_info[i] * self:GetSpecialValueFor("bonus_damage_per_target")) + (dam_int * self:GetSpecialValueFor("damage"))
			end
			local duration = self:GetSpecialValueFor("slow_duration") + self.hit_info[i] * self:GetSpecialValueFor("bonus_duration_per_target")
			self.hit_info[i] = self.hit_info[i] + 1
			ApplyDamage({victim = target, attacker = self:GetCaster(), ability = self, damage = dmg, damage_type = self:GetAbilityDamageType()})
			target:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_dark_artistry_debuff", {duration = duration})
			if self:GetCaster():TG_HasTalent("special_bonus_imba_grimstroke_2") then
				target:AddNewModifier_RS(self:GetCaster(), self, "modifier_stunned", {duration = self:GetCaster():TG_GetTalentValue("special_bonus_imba_grimstroke_2")})
			end
			if target:IsHero() then
				target:EmitSound("Hero_Grimstroke.DarkArtistry.Damage")
			else
				target:EmitSound("Hero_Grimstroke.DarkArtistry.Damage.Creep")
			end
			local pfx = ParticleManager:CreateParticle(self.hit_pfx_name, PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:ReleaseParticleIndex(pfx)
			local buff = target:FindModifierByName("modifier_imba_soul_chain")
			if buff and not self.soulbind_info[i] and buff.latch then
				buff:GetAbsorbSpell({ability = self})
			end
			return false
		else
			self.hit_info[i] = nil
			return true
		end
	else
		if target then
			ApplyDamage({victim = target, attacker = self:GetCaster(), ability = self, damage = self:GetSpecialValueFor("damage"), damage_type = self:GetAbilityDamageType()})
			target:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_dark_artistry_debuff", {duration = self:GetSpecialValueFor("slow_duration")})
			if self:GetCaster():TG_HasTalent("special_bonus_imba_grimstroke_2") then
				target:AddNewModifier_RS(self:GetCaster(), self, "modifier_stunned", {duration = self:GetCaster():TG_GetTalentValue("special_bonus_imba_grimstroke_2")})
			end
			return false
		else
			return true
		end
	end
end

modifier_imba_dark_artistry_debuff = class({})

function modifier_imba_dark_artistry_debuff:IsDebuff()			return true end
function modifier_imba_dark_artistry_debuff:IsHidden() 			return false end
function modifier_imba_dark_artistry_debuff:IsPurgable() 		return true end
function modifier_imba_dark_artistry_debuff:IsPurgeException() 	return true end
function modifier_imba_dark_artistry_debuff:DeclareFunctions()  return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_dark_artistry_debuff:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("movement_slow_pct")) end
function modifier_imba_dark_artistry_debuff:GetEffectName() return "particles/units/heroes/hero_grimstroke/grimstroke_dark_artistry_debuff.vpcf" end
function modifier_imba_dark_artistry_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_dark_artistry_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_grimstroke_dark_artistry.vpcf" end
function modifier_imba_dark_artistry_debuff:StatusEffectPriority() return 15 end




imba_grimstroke_ink_creature = class({})

LinkLuaModifier("modifier_imba_ink_creature_movecontroller", "linken/hero_grimstroke.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ink_creature_debuff", "linken/hero_grimstroke.lua", LUA_MODIFIER_MOTION_NONE)

function imba_grimstroke_ink_creature:IsRefreshable() 			return true end
function imba_grimstroke_ink_creature:IsHiddenWhenStolen() 	return true end
function imba_grimstroke_ink_creature:IsStealable() 			return false end
function imba_grimstroke_ink_creature:OnAbilityPhaseStart()
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_cast_phantom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	return true
end

function imba_grimstroke_ink_creature:OnAbilityPhaseInterrupted()
	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, true)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

function imba_grimstroke_ink_creature:OnSpellStart()
	if self.pfx then
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerStandardTargetSpell(self) then
		return
	end
	caster:EmitSound("Hero_Grimstroke.InkCreature.Cast")
	local npc = CreateUnitByName("npc_dota_grimstroke_ink_creature", caster:GetAbsOrigin() + caster:GetForwardVector() * 130, false, caster, caster, caster:GetTeamNumber())
	npc:AddNewModifier(caster, self, "modifier_imba_ink_creature_movecontroller", {target = target:entindex()})
	npc:AddNewModifier(caster, self, "modifier_kill", {duration = 30})
	npc:EmitSound("Hero_Grimstroke.InkCreature.Spawn")
	SetCreatureHealth(npc, self:GetSpecialValueFor("destroy_attacks") * 2, true)
end

function imba_grimstroke_ink_creature:CreatureFinish(hSource)
	local info =
	{
		Target = self:GetCaster(),
		Source = hSource,
		Ability = self,
		EffectName = "particles/units/heroes/hero_grimstroke/grimstroke_phantom_return.vpcf",
		iMoveSpeed = self:GetSpecialValueFor("return_projectile_speed"),
		vSourceLoc = hSource:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 60,
		bProvidesVision = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function imba_grimstroke_ink_creature:OnProjectileHit(hTarget, vLocation)
	self:EndCooldown()
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("imba_grimstroke_soul_chain")
	if ability and ability:IsTrained()  then
		caster:AddNewModifier(caster, ability, "modifier_imba_soul_chain_stack", {duration = ability:GetSpecialValueFor("duration_bonus")})
		local cooldown_remaining = ability:GetCooldownTimeRemaining()
		local cd = ability:GetSpecialValueFor("cd")
		ability:EndCooldown()
		if cooldown_remaining > cd then
			ability:StartCooldown( cooldown_remaining - cd)
		end
	end

end

modifier_imba_ink_creature_movecontroller = class({})

function modifier_imba_ink_creature_movecontroller:IsDebuff()			return false end
function modifier_imba_ink_creature_movecontroller:IsHidden() 			return true end
function modifier_imba_ink_creature_movecontroller:IsPurgable() 		return false end
function modifier_imba_ink_creature_movecontroller:IsPurgeException() 	return false end
function modifier_imba_ink_creature_movecontroller:CheckState() return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true} end
function modifier_imba_ink_creature_movecontroller:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE, MODIFIER_PROPERTY_DISABLE_HEALING, MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN, MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX} end
function modifier_imba_ink_creature_movecontroller:GetAbsoluteNoDamageMagical() return 1 end
function modifier_imba_ink_creature_movecontroller:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_imba_ink_creature_movecontroller:GetAbsoluteNoDamagePure() return 1 end
function modifier_imba_ink_creature_movecontroller:GetModifierMoveSpeed_AbsoluteMin() return self:GetAbility():GetSpecialValueFor("speed") end
function modifier_imba_ink_creature_movecontroller:GetModifierMoveSpeed_AbsoluteMax() return self:GetAbility():GetSpecialValueFor("speed") end

function modifier_imba_ink_creature_movecontroller:OnAttackLanded(keys)
	if not IsServer() or keys.target ~= self:GetParent() or keys.attacker == self.target then
		return
	end
	local dmg = (keys.attacker:IsHero() or keys.attacker:IsTower()) and 2 or 1
	if dmg > self.parent:GetHealth() then
		self.parent:Kill(self:GetAbility(), keys.attacker)
		self.parent:EmitSound("Hero_Grimstroke.InkCreature.Death")
		return
	end
	self.parent:EmitSound("Hero_Grimstroke.InkCreature.Damage")
	self.parent:SetHealth(self.parent:GetHealth() - dmg)
end

function modifier_imba_ink_creature_movecontroller:OnCreated(keys)
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_phantom_ambient.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 6, Vector(1,0,0))
		self:AddParticle(pfx, false, false, 15, false, false)
		self.parent = self:GetParent()
		self.target = EntIndexToHScript(keys.target)
		self.distance = self:GetAbility():GetSpecialValueFor("latched_unit_offset")
		self.phase = "go"
		self:StartIntervalThink(0.1)
		self:OnIntervalThink()
	end
end

function modifier_imba_ink_creature_movecontroller:OnIntervalThink()
	AddFOWViewer(self.parent:GetTeamNumber(), self.target:GetAbsOrigin(), 200, 0.2, false)
	if not self.target:IsAlive() then
		if not self.target:IsAlive() then
			self:GetAbility():CreatureFinish(self.parent)
		end
		self.parent:ForceKill(false)
		self:Destroy()
		return
	end
	if self.phase == "go" then
		self.parent:MoveToNPC(self.target)
		if (self.parent:GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() <= 100 then
			self.parent:Stop()
			self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAPTURE, 2)
			self.phase = "attack"
			self.target:EmitSound("Hero_Grimstroke.InkCreature.Attach")
			self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_ink_creature_debuff", {npc = self.parent:entindex()})
		end
	elseif self.phase == "attack" then
		self.parent:Stop()
		self.parent:SetAbsOrigin(self.target:GetAbsOrigin() + self.target:GetForwardVector() * self.distance)
		if math.abs(VectorToAngles(self.target:GetForwardVector() * -1)[2] - VectorToAngles(self.parent:GetForwardVector())[2]) > 20 then
			self.parent:SetForwardVector(self.target:GetForwardVector() * -1)
		end
	end
end

function modifier_imba_ink_creature_movecontroller:OnDestroy()
	if IsServer() then
		self.parent = nil
		self.target = nil
		self.distance = nil
		self.phase = nil
	end
end

modifier_imba_ink_creature_debuff = class({})

function modifier_imba_ink_creature_debuff:IsDebuff()			return true end
function modifier_imba_ink_creature_debuff:IsHidden() 			return false end
function modifier_imba_ink_creature_debuff:IsPurgable() 		return true end
function modifier_imba_ink_creature_debuff:IsPurgeException() 	return true end
function modifier_imba_ink_creature_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_ink_creature_debuff:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end

function modifier_imba_ink_creature_debuff:OnCreated(keys)
	if IsServer() then
		self.npc = EntIndexToHScript(keys.npc)
		self:StartIntervalThink(0.5)
	end
end

function modifier_imba_ink_creature_debuff:OnIntervalThink()
	if not self.npc or self.npc:IsNull() then
		self:Destroy()
		return
	end
	ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("damage_per_sec") / (1.0 / 0.5), damage_type = self:GetAbility():GetAbilityDamageType()})
	self:GetParent():EmitSound("Hero_Grimstroke.InkCreature.Attack")
	if self:GetElapsedTime() >= self:GetAbility():GetSpecialValueFor("latch_duration") or (self.npc and not self.npc:IsNull() and not self.npc:IsAlive()) then
		self:Destroy()
	end
end

function modifier_imba_ink_creature_debuff:OnDestroy()
	if IsServer() then
		if self:GetElapsedTime() >= self:GetAbility():GetSpecialValueFor("latch_duration") or not self:GetParent():IsAlive() then
			self:GetParent():EmitSound("Hero_Grimstroke.InkCreature.Returned")
			self:GetAbility():CreatureFinish(self.npc)
			local enemy = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("bounce_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
			local found = false
			for i=1, #enemy do
				if enemy[i] ~= self:GetParent() then
					local buff = self.npc:FindModifierByName("modifier_imba_ink_creature_movecontroller")
					if buff then
						buff.phase = "go"
						buff.target = enemy[i]
						found = true
						break
					end
				end
			end
			if not found then
				self.npc:RemoveModifierByName("modifier_imba_ink_creature_movecontroller")
				UTIL_Remove(self.npc)
			end
			ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self:GetAbility():GetSpecialValueFor("pop_damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_grimstroke_8"), damage_type = self:GetAbility():GetAbilityDamageType()})
		else
			self.npc:RemoveModifierByName("modifier_imba_ink_creature_movecontroller")
			self.npc:EmitSound("Hero_Grimstroke.InkCreature.Death")
			self.npc:ForceKill(false)
		end
		self.npc = nil
	end
end

imba_grimstroke_spirit_walk = class({})

LinkLuaModifier("modifier_imba_spirit_walk_buff", "linken/hero_grimstroke.lua", LUA_MODIFIER_MOTION_NONE)
function imba_grimstroke_spirit_walk:IsHiddenWhenStolen() 	return true end
function imba_grimstroke_spirit_walk:IsStealable() 			return false end
function imba_grimstroke_spirit_walk:IsRefreshable() 			return true end
function imba_grimstroke_spirit_walk:GetAOERadius() return self.aoe end
function imba_grimstroke_spirit_walk:GetCastRange() return self:GetSpecialValueFor("cast_range") end

function imba_grimstroke_spirit_walk:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if caster ~= target then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_cast_ink_swell.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	end
	if IsEnemy(caster, target) and target:TriggerStandardTargetSpell(self) then
		return
	end

	local stack = caster:GetModifierStackCount("modifier_imba_soul_chain_stack", nil)
	local ability = caster:FindAbilityByName("imba_grimstroke_soul_chain")
	local add = 0
	if ability and ability:IsTrained()  then
		add = stack * ability:GetSpecialValueFor("walk_bonus")
	end
	self.aoe = self:GetSpecialValueFor("radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_grimstroke_3") + add

	target:AddNewModifier(caster, self, "modifier_imba_spirit_walk_buff", {duration = self:GetSpecialValueFor("buff_duration"), aoe = self.aoe})
	target:EmitSound("Hero_Grimstroke.InkSwell.Cast")
	caster:EmitSound("Hero_Grimstroke.InkSwell.Targe")
	if IsEnemy(caster, target) and caster:TG_HasTalent("special_bonus_imba_grimstroke_7") then
		target:Purge(true, false, false, false, false)
	elseif not IsEnemy(caster, target) and caster:TG_HasTalent("special_bonus_imba_grimstroke_6") then
		target:Purge(false, true, false, true, false)
	end
end

modifier_imba_spirit_walk_buff = class({})

function modifier_imba_spirit_walk_buff:IsDebuff()			return IsEnemy(self:GetCaster(), self:GetParent()) end
function modifier_imba_spirit_walk_buff:IsHidden() 			return false end
function modifier_imba_spirit_walk_buff:IsPurgable() 		return true end
function modifier_imba_spirit_walk_buff:IsPurgeException() 	return true end
function modifier_imba_spirit_walk_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_spirit_walk_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_spirit_walk_buff:GetModifierMoveSpeedBonus_Percentage()
	if self:IsDebuff() and self:GetCaster():TG_HasTalent("special_bonus_imba_grimstroke_5") then
		return 0 - self:GetAbility():GetSpecialValueFor("movespeed_bonus_pct")
	end
	return self:GetAbility():GetSpecialValueFor("movespeed_bonus_pct")
end
function modifier_imba_spirit_walk_buff:GetStatusEffectName() return "particles/status_fx/status_effect_grimstroke_ink_swell.vpcf" end
function modifier_imba_spirit_walk_buff:StatusEffectPriority() return 15 end

function modifier_imba_spirit_walk_buff:OnCreated(keys)
	if IsServer() then
		self.aoe = keys.aoe
		self.stun = false
		self.damage_duration = 0
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_buff.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 2, Vector(self.aoe, 0, 0))
		ParticleManager:SetParticleControlEnt(pfx, 3, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 6, Vector(self.aoe, 0, 0))
		self:AddParticle(pfx, false, false, 15, false, false)
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_rate"))
	end
end

function modifier_imba_spirit_walk_buff:OnIntervalThink()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()

	local unit = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local hero = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	self.damage_duration = #hero > 0 and self.damage_duration + ability:GetSpecialValueFor("tick_rate") or self.damage_duration
	for i=1, #unit do
		hero[#hero + 1] = unit[i]
	end
	for i=1, #hero do
		ApplyDamage({victim = hero[i], attacker = caster, damage = ability:GetSpecialValueFor("damage_per_sec") / (1.0 / ability:GetSpecialValueFor("tick_rate")), ability = ability, damage_type = ability:GetAbilityDamageType()})
	end
	if #hero > 0 then
		parent:EmitSound("Hero_Grimstroke.InkSwell.Damage")
	end
	if not IsEnemy(parent, caster) then
		parent:Heal(ability:GetSpecialValueFor("damage_per_sec") / (1.0 / ability:GetSpecialValueFor("tick_rate")), caster)
	end
	if not self.stun and parent:HasModifier("modifier_imba_dark_artistry_debuff") then
		self.stun = true
	end
end

function modifier_imba_spirit_walk_buff:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		parent:EmitSound("Hero_Grimstroke.InkSwell.Stun")
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 2, Vector(self.aoe, self.aoe, self.aoe))
		ParticleManager:SetParticleControl(pfx, 4, parent:GetAbsOrigin())

		local enemy = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local stun_duration = (self.damage_duration / self:GetElapsedTime()) * ability:GetSpecialValueFor("max_stun")
		local dmg = (self.damage_duration / self:GetElapsedTime()) * ability:GetSpecialValueFor("max_damage")
		for i=1, #enemy do
			if enemy[i] ~= parent then
				ApplyDamage({victim = enemy[i], attacker = caster, damage = dmg, ability = ability, damage_type = ability:GetAbilityDamageType()})
				enemy[i]:AddNewModifier_RS(caster, ability, "modifier_stunned", {duration = stun_duration})
				enemy[i]:EmitSound("Hero_Grimstroke.InkSwell.Stun")
			end
		end
		if (self.stun or parent:HasModifier("modifier_imba_dark_artistry_debuff")) and IsEnemy(parent, caster) then
			parent:AddNewModifier_RS(caster, ability, "modifier_stunned", {duration = stun_duration})
		end
		self.stun = false
		if not IsEnemy(parent, caster) then
			parent:Heal(dmg, caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, dmg, nil)
		end
	end
end



imba_grimstroke_soul_chain = class({})

--LinkLuaModifier("modifier_imba_soul_chain_scepter", "linken/hero_grimstroke.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_soul_chain", "linken/hero_grimstroke.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_soul_chain_cast", "linken/hero_grimstroke.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_soul_chain_slow", "linken/hero_grimstroke.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_soul_chain_stack", "linken/hero_grimstroke.lua", LUA_MODIFIER_MOTION_NONE)

function imba_grimstroke_soul_chain:IsStealable() 			return false end
function imba_grimstroke_soul_chain:IsHiddenWhenStolen() 	return true end
function imba_grimstroke_soul_chain:IsRefreshable() 		return true end
function imba_grimstroke_soul_chain:GetAOERadius() return self:GetSpecialValueFor("chain_latch_radius") end
function imba_grimstroke_soul_chain:GetCastRange() return self:GetSpecialValueFor("cast_range") end
---function imba_grimstroke_soul_chain:GetIntrinsicModifierName() return "modifier_imba_soul_chain_scepter" end

function imba_grimstroke_soul_chain:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerStandardTargetSpell(self) then
		return
	end
	local cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_cast_soulchain.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(cast_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(cast_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_pfx)
	caster:EmitSound("Hero_Grimstroke.SoulChain.Cast")
	target:EmitSound("Hero_Grimstroke.SoulChain.Target")
	if not target:HasModifier("modifier_imba_soul_chain") then
		target:AddNewModifier_RS(caster, self, "modifier_imba_soul_chain", {duration = self:GetSpecialValueFor("chain_duration") + caster:TG_GetTalentValue("special_bonus_imba_grimstroke_4"), is_primary = 1})
	else
		local buff = target:FindModifierByName("modifier_imba_soul_chain")
		buff:SetDuration(self:GetSpecialValueFor("chain_duration") + caster:TG_GetTalentValue("special_bonus_imba_grimstroke_4"), true)
		if buff.latch then
			buff.latch:FindModifierByName("modifier_imba_soul_chain"):SetDuration(self:GetSpecialValueFor("chain_duration") + caster:TG_GetTalentValue("special_bonus_imba_grimstroke_4"), true)
		end
	end
end

--[[modifier_imba_soul_chain_scepter = class({})

function modifier_imba_soul_chain_scepter:IsDebuff()			return false end
function modifier_imba_soul_chain_scepter:IsHidden() 			return true end
function modifier_imba_soul_chain_scepter:IsPurgable() 			return false end
function modifier_imba_soul_chain_scepter:IsPurgeException() 	return false end

function modifier_imba_soul_chain_scepter:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_imba_soul_chain_scepter:OnIntervalThink()
	self:GetAbility():SetHidden(not self:GetParent():HasScepter())
end]]

modifier_imba_soul_chain = class({})

function modifier_imba_soul_chain:IsDebuff()			return true end
function modifier_imba_soul_chain:IsHidden() 			return false end
function modifier_imba_soul_chain:IsPurgable() 			return false end
function modifier_imba_soul_chain:IsPurgeException() 	return false end
function modifier_imba_soul_chain:GetEffectName() return "particles/units/heroes/hero_grimstroke/grimstroke_soulchain_marker.vpcf" end
function modifier_imba_soul_chain:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_soul_chain:ShouldUseOverheadOffset() return true end
function modifier_imba_soul_chain:CheckState() return {[MODIFIER_STATE_TETHERED] = true, [MODIFIER_STATE_PROVIDES_VISION] = true} end

function modifier_imba_soul_chain:OnCreated(keys)
	if IsServer() then
		self.proc_ability = self.proc_ability or {}
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		self.latch_radius = self.ability:GetSpecialValueFor("chain_latch_radius")
		self.break_radiius = self.ability:GetSpecialValueFor("chain_break_distance")
		self.latch = nil
		if keys.is_primary == 1 then
			self.primary = true
			self:StartIntervalThink(FrameTime())
			self:OnIntervalThink()
			if self.main_pfx then
				ParticleManager:DestroyParticle(self.main_pfx, true)
				ParticleManager:ReleaseParticleIndex(self.main_pfx)
				self.main_pfx = nil
			end
			if self.sec_pfx then
				ParticleManager:DestroyParticle(self.sec_pfx, true)
				ParticleManager:ReleaseParticleIndex(self.sec_pfx)
				self.sec_pfx = nil
			end
			if not self.main_pfx then
				self.main_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
				ParticleManager:SetParticleControlEnt(self.main_pfx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.main_pfx, 2, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
			end
		elseif keys.is_primary == 0 then
			self.primary = false
			self.latch = EntIndexToHScript(keys.source)
			self:StartIntervalThink(FrameTime())
			self:OnIntervalThink()
			if self.main_pfx then
				ParticleManager:DestroyParticle(self.main_pfx, true)
				ParticleManager:ReleaseParticleIndex(self.main_pfx)
				self.main_pfx = nil
			end
			if self.sec_pfx then
				ParticleManager:DestroyParticle(self.sec_pfx, true)
				ParticleManager:ReleaseParticleIndex(self.sec_pfx)
				self.sec_pfx = nil
			end
			if not self.sec_pfx then
				self.sec_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
				ParticleManager:SetParticleControlEnt(self.sec_pfx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.sec_pfx, 2, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
			end
		end
	end
end

function modifier_imba_soul_chain:OnRefresh(keys) self:OnCreated(keys) end

function modifier_imba_soul_chain:OnIntervalThink()
	if self.primary then
		if not self.latch then
			local unit = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.latch_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			if #unit > 1 then
				for i=2, #unit do
					if not unit[i]:HasModifier("modifier_imba_soul_chain") or (unit[i]:FindModifierByName("modifier_imba_soul_chain") and unit[i]:FindModifierByName("modifier_imba_soul_chain").primary and not unit[i]:FindModifierByName("modifier_imba_soul_chain").latch) then
						self.latch = unit[i]
						self.latch:EmitSound("Hero_Grimstroke.SoulChain.Partner")
						self.parent:EmitSound("Hero_Grimstroke.SoulChain.Leash")
						if not self.latch:HasModifier("modifier_imba_soul_chain") then
							self.latch:EmitSound("Hero_Grimstroke.SoulChain.Leash")
						end
						if self.latch_pfx then
							ParticleManager:DestroyParticle(self.latch_pfx, false)
							ParticleManager:ReleaseParticleIndex(self.latch_pfx)
							self.latch_pfx = nil
						end
						self.latch:AddNewModifier(self.caster, self.ability, "modifier_imba_soul_chain", {duration = self:GetRemainingTime() - FrameTime(), is_primary = 0, source = self.parent:entindex()})
						self.latch_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControlEnt(self.latch_pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
						ParticleManager:SetParticleControlEnt(self.latch_pfx, 1, self.latch, PATTACH_POINT_FOLLOW, "attach_hitloc", self.latch:GetAbsOrigin(), true)
						break
					end
				end
			end
		else
			local distance = (self.parent:GetAbsOrigin() - self.latch:GetAbsOrigin()):Length2D()
			if distance > self.break_radiius or not self.latch:IsAlive() then
				local buff = self.latch:FindModifierByName("modifier_imba_soul_chain")
				if buff then
					self.latch:AddNewModifier(self.caster, self.ability, "modifier_imba_soul_chain", {duration = self:GetRemainingTime() - FrameTime(), is_primary = 1})
				end
				self:SetDuration(self:GetRemainingTime(), true)
				self.parent:StopSound("Hero_Grimstroke.SoulChain.Leash")
				self.latch:StopSound("Hero_Grimstroke.SoulChain.Leash")
				local latch = self.latch
				self.latch = nil
				local phantom = self.caster:FindAbilityByName("imba_grimstroke_ink_creature")
				if phantom and phantom:GetLevel() > 0 then
					self.caster:SetCursorCastTarget(self.parent)
					phantom:OnSpellStart()
					self.caster:SetCursorCastTarget(latch)
					phantom:OnSpellStart()
				end
				if self.latch_pfx then
					ParticleManager:DestroyParticle(self.latch_pfx, false)
					ParticleManager:ReleaseParticleIndex(self.latch_pfx)
					self.latch_pfx = nil
				end
			end
		end
	else
		if self.latch_pfx then
			ParticleManager:DestroyParticle(self.latch_pfx, false)
			ParticleManager:ReleaseParticleIndex(self.latch_pfx)
			self.latch_pfx = nil
		end
		if self.latch and not self.latch:IsAlive() then
			--local distance = (self.parent:GetAbsOrigin() - self.latch:GetAbsOrigin()):Length2D()
			--if distance > self.break_radiius or not self.latch:IsAlive() or not self.latch:HasModifier("modifier_imba_soul_chain") then
				--local buff = self.latch:FindModifierByName("modifier_imba_soul_chain")
				--if buff then
				--	buff:SetDuration(self:GetRemainingTime() - FrameTime(), true)
				--end
				self.parent:StopSound("Hero_Grimstroke.SoulChain.Leash")
				self.latch:StopSound("Hero_Grimstroke.SoulChain.Leash")
				self.latch = nil
				local phantom = self.caster:FindAbilityByName("imba_grimstroke_ink_creature")
				if phantom and phantom:GetLevel() > 0 then
					self.caster:SetCursorCastTarget(self.parent)
				end
				self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_soul_chain", {duration = self:GetRemainingTime() - FrameTime(), is_primary = 1})
			--end
		end
	end
	if not self.latch then
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_soul_chain_slow", {duration = 0.1})
	end
end

function modifier_imba_soul_chain:DeclareFunctions() return {MODIFIER_PROPERTY_ABSORB_SPELL} end

local no_soul_chain_abilities = {}
no_soul_chain_abilities["morphling_replicate"] = true
no_soul_chain_abilities["imba_morphling_replicate"] = true
no_soul_chain_abilities["grimstroke_soul_chain"] = true
no_soul_chain_abilities["imba_grimstroke_soul_chain"] = true
no_soul_chain_abilities["terrorblade_sunder"] = true
no_soul_chain_abilities["imba_terrorblade_sunder"] = true
no_soul_chain_abilities["vengefulspirit_nether_swap"] = true
no_soul_chain_abilities["imba_vengeful_nether_swap"] = true
no_soul_chain_abilities["imba_rubick_spell_steal"] = true
no_soul_chain_abilities["imba_juggernaut_swift_slash"] = true
no_soul_chain_abilities["tg_jugg_swift_slash"] = true
no_soul_chain_abilities["magic_missile"] = true 					--vs魔法箭
no_soul_chain_abilities["nether_swap"] = true 						--vs移形换位
no_soul_chain_abilities["guided_missile"] = true 					--飞机跟踪导弹
no_soul_chain_abilities["oldsky_abolt"] = true  					--天怒1
no_soul_chain_abilities["oldsky_aseal"] = true 						--天怒3
no_soul_chain_abilities["stifling_dagger"] = true 					--pa1
no_soul_chain_abilities["imba_bristleback_viscous_nasal_goo"] = true--刚被1
no_soul_chain_abilities["imba_lion_earth_spike"] = true  			--莱恩1
no_soul_chain_abilities["imba_bounty_hunter_shuriken_toss"] = true  --赏金1
no_soul_chain_abilities["imba_bristleback_hairball"] = true  		--刚被魔晶
no_soul_chain_abilities["imba_ogre_magi_fireblast_ignite"] = true  	--蓝胖1
no_soul_chain_abilities["penitence"] = true  	--陈1
no_soul_chain_abilities["dragon_tail"] = true
no_soul_chain_abilities["imba_riki_poison_dart"] = true

function modifier_imba_soul_chain:GetAbsorbSpell(keys)
	if not IsServer() then
		return 0
	end
	local ability_caster = keys.ability:GetCaster()
	local ability = keys.ability
	if no_soul_chain_abilities[ability:GetAbilityName()] or bit.band(ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_CHANNELLED) == DOTA_ABILITY_BEHAVIOR_CHANNELLED then
		return 0
	end
	if not IsEnemy(ability_caster, self.parent) or not self.latch or (self.proc_ability[ability_caster:entindex()] and self.proc_ability[ability_caster:entindex()][ability:GetAbilityName()] and self.proc_ability[ability_caster:entindex()][ability:GetAbilityName()] > 0) then
		if self.proc_ability[ability_caster:entindex()] and self.proc_ability[ability_caster:entindex()][ability:GetAbilityName()] and self.proc_ability[ability_caster:entindex()][ability:GetAbilityName()] > 0 then
			self.proc_ability[ability_caster:entindex()][ability:GetAbilityName()] = self.proc_ability[ability_caster:entindex()][ability:GetAbilityName()] - 1
		end
		return 0
	end
	local buff = self.latch:FindModifierByName("modifier_imba_soul_chain")
	if buff then
		if ability:GetAbilityName() ~= "imba_grimstroke_dark_artistry" then
			if buff.proc_ability[ability_caster:entindex()] and buff.proc_ability[ability_caster:entindex()][ability:GetAbilityName()] then
				buff.proc_ability[ability_caster:entindex()][ability:GetAbilityName()] = buff.proc_ability[ability_caster:entindex()][ability:GetAbilityName()] + 1
			else
				buff.proc_ability[ability_caster:entindex()] = {}
				buff.proc_ability[ability_caster:entindex()][ability:GetAbilityName()] = 1
			end
		end
		CreateModifierThinker(self.latch, ability, "modifier_imba_soul_chain_cast", {duration = 0}, ability_caster:GetAbsOrigin(), ability_caster:GetTeamNumber(), false)
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_proc.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, self.latch, PATTACH_POINT_FOLLOW, "attach_hitloc", self.latch:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
	return 0
end

function modifier_imba_soul_chain:OnDestroy()
	if IsServer() then
		if self.latch_pfx then
			ParticleManager:DestroyParticle(self.latch_pfx, false)
			ParticleManager:ReleaseParticleIndex(self.latch_pfx)
			self.latch_pfx = nil
		end
		self.parent:StopSound("Hero_Grimstroke.SoulChain.Leash")
		self.parent:StopSound("Hero_Grimstroke.SoulChain.Target")
		self.parent:StopSound("Hero_Grimstroke.SoulChain.Partner")
		if self.latch then
			self.latch:StopSound("Hero_Grimstroke.SoulChain.Leash")
			self.latch:StopSound("Hero_Grimstroke.SoulChain.Target")
			self.latch:StopSound("Hero_Grimstroke.SoulChain.Partner")
		end
		if self.sec_pfx then
			ParticleManager:DestroyParticle(self.sec_pfx, false)
			ParticleManager:ReleaseParticleIndex(self.sec_pfx)
			self.sec_pfx = nil
		end
		if self.main_pfx then
			ParticleManager:DestroyParticle(self.main_pfx, false)
			ParticleManager:ReleaseParticleIndex(self.main_pfx)
			self.main_pfx = nil
		end

		self.proc_ability = nil
		self.caster = nil
		self.parent = nil
		self.ability = nil
		self.latch_radius = nil
		self.break_radiius = nil
		self.latch = nil
		self.primary = nil
		self.main_pfx = nil
		self.sec_pfx = nil
		self.latch_pfx = nil
	end
end

modifier_imba_soul_chain_cast = class({})

function modifier_imba_soul_chain_cast:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster():SetCursorCastTarget(self:GetCaster())
		if self:GetAbility():GetAbilityName() == "imba_grimstroke_dark_artistry" then
			self:GetAbility():OnSpellStart(true)
		else
			self:GetAbility():OnSpellStart()
		end
	end
end

modifier_imba_soul_chain_slow = class({})

function modifier_imba_soul_chain_slow:IsDebuff()			return true end
function modifier_imba_soul_chain_slow:IsHidden() 			return false end
function modifier_imba_soul_chain_slow:IsPurgable() 		return false end
function modifier_imba_soul_chain_slow:IsPurgeException() 	return false end
function modifier_imba_soul_chain_slow:DeclareFunctions()   return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_soul_chain_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("no_sec_slow")) end

function modifier_imba_soul_chain_slow:OnCreated()
	if IsClient() then
		self:SetDuration(-1, true)
	end
end

function modifier_imba_soul_chain_slow:OnRefresh() self:OnCreated() end

modifier_imba_soul_chain_stack = class({})
function modifier_imba_soul_chain_stack:IsDebuff()			return false end
function modifier_imba_soul_chain_stack:IsHidden() 			return false end
function modifier_imba_soul_chain_stack:IsPurgable() 		return false end
function modifier_imba_soul_chain_stack:IsPurgeException() 	return false end
function modifier_imba_soul_chain_stack:DeclareFunctions() return {MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING} end
function modifier_imba_soul_chain_stack:GetModifierCastRangeBonusStacking() return (self:GetAbility():GetSpecialValueFor("cast_bonus")*self:GetStackCount()) end
function modifier_imba_soul_chain_stack:OnCreated()
	self.max_stack = self:GetAbility():GetSpecialValueFor("max_stack")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_imba_soul_chain_stack:OnRefresh()
	if IsServer() then
		if self:GetStackCount() >= self.max_stack then
			self:SetStackCount(self.max_stack)
		else
			self:IncrementStackCount()
		end
	end
end

imba_grimstroke_dark_portrait = class({})

LinkLuaModifier("modifier_imba_soul_chain_scepter", "linken/hero_grimstroke.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dark_portrait_mov", "linken/hero_grimstroke.lua", LUA_MODIFIER_MOTION_NONE)
function imba_grimstroke_dark_portrait:Set_InitialUpgrade(tg)
    return {LV=1}
end
function imba_grimstroke_dark_portrait:IsStealable() 			return false end
function imba_grimstroke_dark_portrait:IsHiddenWhenStolen() 	return true end
function imba_grimstroke_dark_portrait:GetIntrinsicModifierName() return "modifier_imba_soul_chain_scepter" end
function imba_grimstroke_dark_portrait:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerStandardTargetSpell(self) then
		return
	end
	local illusion_duration = self:GetSpecialValueFor("illusion_duration")
	local images_do_damage_percent = self:GetSpecialValueFor("images_do_damage_percent")
	local images_take_damage_percent = self:GetSpecialValueFor("images_take_damage_percent")

	local modifier_illusions =
	{
	    outgoing_damage=images_do_damage_percent - 100,
	    incoming_damage=images_take_damage_percent - 100,
	    bounty_base=0,
	    bounty_growth=0,
	    outgoing_damage_structure=0,
	    outgoing_damage_roshan=0,
	}
	caster.illusions = CreateIllusions(caster, target, modifier_illusions, 1, 0, false, false)
	for i=1, #caster.illusions do
		FindClearSpaceForUnit(caster.illusions[i], target:GetAbsOrigin(), false)
		caster.illusions[i]:SetForwardVector(TG_Direction(target:GetAbsOrigin(),caster.illusions[i]:GetAbsOrigin()))
		caster.illusions[i]:AddNewModifier(caster, self, "modifier_kill", {duration = illusion_duration})
		caster.illusions[i]:AddNewModifier(caster, self, "modifier_phased", {duration = illusion_duration})
		caster.illusions[i]:AddNewModifier(caster, self, "modifier_imba_dark_portrait_mov", {duration = illusion_duration})
	end
end
modifier_imba_dark_portrait_mov = class({})
function modifier_imba_dark_portrait_mov:IsDebuff()				return false end
function modifier_imba_dark_portrait_mov:IsHidden() 			return true end
function modifier_imba_dark_portrait_mov:IsPurgable() 			return false end
function modifier_imba_dark_portrait_mov:IsPurgeException() 	return false end
function modifier_imba_dark_portrait_mov:DeclareFunctions() 	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_dark_portrait_mov:GetStatusEffectName() return "particles/status_fx/status_effect_grimstroke_ink_swell.vpcf" end
function modifier_imba_dark_portrait_mov:StatusEffectPriority() return 100010 end
function modifier_imba_dark_portrait_mov:CheckState()
	return
		{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		}
end
function modifier_imba_dark_portrait_mov:GetModifierMoveSpeedBonus_Percentage() return self.images_movespeed_bonus end
function modifier_imba_dark_portrait_mov:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.images_movespeed_bonus = self.ability:GetSpecialValueFor("images_movespeed_bonus")
	self.time = self.ability:GetSpecialValueFor("time")
	self.range = self.ability:GetSpecialValueFor("range")
	self.ability_1 = self.caster:FindAbilityByName("imba_grimstroke_dark_artistry")
	self.ability_2 = self.caster:FindAbilityByName("imba_grimstroke_ink_creature")
	self.ability_3 = self.caster:FindAbilityByName("imba_grimstroke_spirit_walk")
	self.ability_4 = self.caster:FindAbilityByName("imba_grimstroke_soul_chain")
	if IsServer() then
		self.int = 0
		self.pos = nil
		self.target = nil
		self:StartIntervalThink(self.time)
	end
end
function modifier_imba_dark_portrait_mov:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),
		self.parent:GetAbsOrigin(),
		nil,
		self.range,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		FIND_CLOSEST,
		false
		)
	for _, enemy in pairs(enemies) do
		self.pos = enemy:GetAbsOrigin()
		self.target = enemy
		break
	end
	self.int = self.int + 1
	if #enemies > 0 and (self.pos or self.target) then
		if self.int == 1 and self.ability_1 and self.ability_1:IsTrained() then
			self.caster:SetCursorPosition(self.pos)
			self.ability_1:OnSpellStart(true)
		elseif	self.int == 2 and self.ability_2 and self.ability_2:IsTrained() then
				self.caster:SetCursorCastTarget(self.target)
				self.ability_2:OnSpellStart()
		elseif	self.int == 3 and self.ability_3 and self.ability_3:IsTrained() then
				self.caster:SetCursorCastTarget(self.target)
				self.ability_3:OnSpellStart()
		elseif	self.int == 4 and self.ability_4 and self.ability_4:IsTrained() then
				self.caster:SetCursorCastTarget(self.target)
				self.ability_4:OnSpellStart()
		end
	end
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/planeshift/void_spirit_planeshift_impact.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 2, Vector(self.range, self.range, self.range))
		ParticleManager:SetParticleControl(pfx, 4, self.parent:GetAbsOrigin())
		self:AddParticle(pfx, false, false, 15, false, false)
end

modifier_imba_soul_chain_scepter = class({})
function modifier_imba_soul_chain_scepter:IsDebuff()			return false end
function modifier_imba_soul_chain_scepter:IsHidden() 			return true end
function modifier_imba_soul_chain_scepter:IsPurgable() 			return false end
function modifier_imba_soul_chain_scepter:IsPurgeException() 	return false end
function modifier_imba_soul_chain_scepter:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_imba_soul_chain_scepter:OnIntervalThink()
	self:GetAbility():SetHidden(not self:GetParent():HasScepter())
end