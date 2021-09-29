CreateTalents("npc_dota_hero_puck", "heros/hero_puck/hero_puck.lua")
imba_puck_illusory_orb = class({})

function imba_puck_illusory_orb:IsHiddenWhenStolen() 	return false end
function imba_puck_illusory_orb:IsRefreshable() 		return true end
function imba_puck_illusory_orb:IsStealable() 			return true end
function imba_puck_illusory_orb:GetAssociatedSecondaryAbilities() return "imba_puck_ethereal_jaunt" end
function imba_puck_illusory_orb:GetCastRange()
	if IsClient() then
		local distance = self:GetSpecialValueFor("max_distance")
		if self:GetCaster():TG_HasTalent("special_bonus_imba_puck_1") then
			distance = self:GetCaster():TG_GetTalentValue("special_bonus_imba_puck_1") * distance
		end
		return distance
	else
		return 50000
	end
end

LinkLuaModifier("modifier_imba_illusory_orb_thinker", "heros/hero_puck/hero_puck.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_illusory_orb_silenced", "heros/hero_puck/hero_puck.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_illusory_orb_controller", "heros/hero_puck/hero_puck.lua", LUA_MODIFIER_MOTION_NONE)
function imba_puck_illusory_orb:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()+caster:GetForwardVector()*10
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0
	local sound = CreateModifierThinker(caster, self, "modifier_imba_illusory_orb_thinker", {duration = 30.0}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	EmitSoundOn("Imba.Hero_Puck.Illusory_Orb", sound)
	local distance = self:GetSpecialValueFor("max_distance")
	local speed = self:GetSpecialValueFor("orb_speed")
	if caster:TG_HasTalent("special_bonus_imba_puck_1") then
		distance = caster:TG_GetTalentValue("special_bonus_imba_puck_1") * distance
		speed = caster:TG_GetTalentValue("special_bonus_imba_puck_1") * speed
	end
	local ability_1 = caster:FindAbilityByName("imba_puck_phase_shift")
	if caster:TG_HasTalent("special_bonus_imba_puck_8") and ability_1 and ability_1:IsTrained() then
		caster:AddNewModifier(caster, ability_1, "modifier_imba_phase_shift", {duration = caster:TG_GetTalentValue("special_bonus_imba_puck_8"), int = 1})
	end
	local pfx_name = "particles/units/heroes/hero_puck/puck_illusory_orb.vpcf"
--	if HeroItems:UnitHasItem(self:GetCaster(), "blossom_of_the_merry_wanderer") then
--		pfx_name = "particles/econ/items/puck/puck_merry_wanderer/puck_illusory_orb_merry_wanderer.vpcf"
--	end
	local info =
	{
		Ability = self,
		EffectName = pfx_name,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = self:GetSpecialValueFor("radius"),
		fEndRadius = self:GetSpecialValueFor("radius"),
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity = direction * speed,
		bProvidesVision = false,
		ExtraData = {sound = sound:entindex()},
	}
	self.projectile = ProjectileManager:CreateLinearProjectile(info)
	local time = (self:GetSpecialValueFor("max_distance") / self:GetSpecialValueFor("orb_speed") - 0.1)
	caster:AddNewModifier(caster, self, "modifier_imba_illusory_orb_controller", {duration = time}):SetStackCount(0)

	if	self:GetCaster():TG_HasTalent("special_bonus_imba_puck_3") then
		local ability = caster:FindAbilityByName("imba_puck_dream_coil")
		if ability and ability:IsTrained() and not ability:GetAutoCastState() then
			local enemy = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster:Script_GetAttackRange()+200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
			for i=1, #enemy do
				if not caster:IsDisarmed() or caster:HasModifier("modifier_imba_phase_shift") then
					caster:PerformAttack(enemy[i], false, true, true, false, true, false, true)
				end
				if i >= 3 then
					break
				end
			end
		end
	end
end

function imba_puck_illusory_orb:OnProjectileThink_ExtraData(pos, keys)
	AddFOWViewer(self:GetCaster():GetTeamNumber(), pos, self:GetSpecialValueFor("orb_vision"), self:GetSpecialValueFor("vision_duration"), false)
	if keys.sound then
		EntIndexToHScript(keys.sound):SetOrigin(pos)
	end
end

function imba_puck_illusory_orb:OnProjectileHit_ExtraData(target, pos, keys)
	if not target and keys.sound then
		local sound=EntIndexToHScript(keys.sound)
		sound:StopSound("Hero_Puck.Illusory_Orb")
		sound:ForceKill(false)
	end
	if target then
		target:EmitSound("Hero_Puck.IIllusory_Orb_Damage")
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_orb_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:ReleaseParticleIndex(pfx)
		ApplyDamage({victim = target, attacker = self:GetCaster(), ability = self, damage = self:GetSpecialValueFor("damage"), damage_type = self:GetAbilityDamageType()})
	end
end

modifier_imba_illusory_orb_thinker = class({})

function modifier_imba_illusory_orb_thinker:IsAura() return true end
function modifier_imba_illusory_orb_thinker:GetAuraDuration() return 0.1 end
function modifier_imba_illusory_orb_thinker:GetModifierAura() return "modifier_imba_illusory_orb_silenced" end
function modifier_imba_illusory_orb_thinker:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_imba_illusory_orb_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_illusory_orb_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_illusory_orb_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_imba_illusory_orb_silenced = class({})

function modifier_imba_illusory_orb_silenced:IsDebuff()			return true end
function modifier_imba_illusory_orb_silenced:IsHidden() 		return false end
function modifier_imba_illusory_orb_silenced:IsPurgable() 		return true end
function modifier_imba_illusory_orb_silenced:IsPurgeException() return true end
function modifier_imba_illusory_orb_silenced:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_imba_illusory_orb_silenced:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_imba_illusory_orb_silenced:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_illusory_orb_silenced:ShouldUseOverheadOffset() return true end

modifier_imba_illusory_orb_controller = class({})

function modifier_imba_illusory_orb_controller:IsDebuff()			return false end
function modifier_imba_illusory_orb_controller:IsHidden() 			return false end
function modifier_imba_illusory_orb_controller:IsPurgable() 		return false end
function modifier_imba_illusory_orb_controller:IsPurgeException() 	return false end
function modifier_imba_illusory_orb_controller:RemoveOnDeath() return self:GetParent():IsIllusion() end

function modifier_imba_illusory_orb_controller:OnCreated()
	if IsServer() then
		local ability = self:GetParent():FindAbilityByName("imba_puck_ethereal_jaunt")
		if ability then
			ability:SetActivated(true)
		end
	end
end

function modifier_imba_illusory_orb_controller:OnDestroy()
	if IsServer() then
		local ability = self:GetParent():FindAbilityByName("imba_puck_ethereal_jaunt")
		if ability then
			ability:SetActivated(false)
		end
		self:GetAbility().projectile = nil
	end
end

imba_puck_ethereal_jaunt = class({})

function imba_puck_ethereal_jaunt:IsHiddenWhenStolen() 		return false end
function imba_puck_ethereal_jaunt:IsRefreshable() 			return true end
function imba_puck_ethereal_jaunt:IsStealable() 			return false end
function imba_puck_ethereal_jaunt:GetAssociatedPrimaryAbilities() return "imba_puck_illusory_orb" end
function imba_puck_ethereal_jaunt:Set_InitialUpgrade() return {kv=1} end
function imba_puck_ethereal_jaunt:ProcsMagicStick() return false end
function imba_puck_ethereal_jaunt:OnUpgrade()
	if IsServer() then
		self:SetActivated(false)
	end
end

function imba_puck_ethereal_jaunt:OnSpellStart()
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("imba_puck_illusory_orb")
	if not ability or (ability and not ability.projectile) then
		self:EndCooldown()
		return
	end
	if caster:GetUnitName() == "npc_dota_hero_puck" and RollPercentage(35) then
		caster:EmitSound("puck_puck_ability_orb_0"..RandomInt(1, 8))
	end
	caster:EmitSound("Hero_Puck.EtherealJaunt")
	caster:SetOrigin(GetGroundPosition(ProjectileManager:GetLinearProjectileLocation(ability.projectile), nil))
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	local pfx = ParticleManager:CreateParticle("particles/hero/puck/puck_ethereal_jaunt.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)
	if caster:GetModifierStackCount("modifier_imba_illusory_orb_controller", nil) == 0 then
		local rift = caster:FindAbilityByName("imba_puck_waning_rift")
		if rift and rift:GetLevel() > 0 then
			self:GetCaster():SetCursorPosition(GetGroundPosition(ProjectileManager:GetLinearProjectileLocation(ability.projectile), nil))
			rift:OnSpellStart(true)
		end
	end
	caster:SetModifierStackCount("modifier_imba_illusory_orb_controller", nil, 1)
	caster:RemoveModifierByName("modifier_imba_phase_shift")
end

imba_puck_waning_rift = class({})

function imba_puck_waning_rift:IsHiddenWhenStolen() 	return false end
function imba_puck_waning_rift:IsRefreshable() 			return true end
function imba_puck_waning_rift:IsStealable() 			return true end
function imba_puck_waning_rift:GetCastRange() if IsClient() then return self:GetSpecialValueFor("radius") end end
function imba_puck_waning_rift:GetCooldown(i) return (self.BaseClass.GetCooldown(self, -1) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_puck_2")) end
function imba_puck_waning_rift:GetAOERadius()	return self:GetSpecialValueFor("radius") end
LinkLuaModifier("modifier_imba_waning_rift_silenced", "heros/hero_puck/hero_puck.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_waning_rift_agh", "heros/hero_puck/hero_puck.lua", LUA_MODIFIER_MOTION_NONE)

function imba_puck_waning_rift:OnSpellStart(bHalf)
	local caster = self:GetCaster()
	--local pos = caster:GetAbsOrigin()
	local range = self:GetSpecialValueFor("radius")
	local pos_next = self:GetCursorPosition()
	local max_dis = self:GetSpecialValueFor("distance") --+ self:GetCaster():GetCastRangeBonus()
	local distance = (pos_next - caster:GetAbsOrigin()):Length2D()
	local direction = (pos_next - caster:GetAbsOrigin()):Normalized()
	direction.z = 0.0
	if self:GetAutoCastState() or caster:IsRooted() then
		pos_next = caster:GetAbsOrigin()
	elseif not self:GetAutoCastState() then
		if distance <= max_dis then
			FindClearSpaceForUnit(caster, pos_next, false)
		else
			pos_next = caster:GetAbsOrigin() + direction * max_dis
			FindClearSpaceForUnit(caster, pos_next, false)
		end
	end
	if caster:Has_Aghanims_Shard() then
		local enemy1 = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_OTHER, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for i=1, #enemy1 do
			enemy1[i]:AddNewModifier(caster, self, "modifier_item_dustofappearance", {duration = 5})
			if not enemy1[i]:IsMagicImmune() then
				enemy1[i]:AddNewModifier(caster, self, "modifier_imba_waning_rift_agh", {duration = 0.4})
			end
		end
	end


	if caster:GetUnitName() == "npc_dota_hero_puck" then
		caster:EmitSound("puck_puck_ability_rift_0"..RandomInt(1, 3))
	end
	caster:EmitSound("Hero_Puck.Waning_Rift")
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_waning_rift.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, pos_next)
	ParticleManager:SetParticleControl(pfx, 1, Vector(range,range,range))
	ParticleManager:ReleaseParticleIndex(pfx)
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), pos_next, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, FIND_ANY_ORDER, false)
	for i=1, #enemy do
		local dmg = bHalf and (self:GetSpecialValueFor("damage") / 2) or self:GetSpecialValueFor("damage")
		ApplyDamage({victim = enemy[i], attacker = caster, ability = self, damage = dmg, damage_type = self:GetAbilityDamageType()})
		enemy[i]:AddNewModifier(caster, self, "modifier_imba_waning_rift_silenced", {duration = self:GetSpecialValueFor("silence_duration")})
		if enemy[i]:HasModifier("modifier_imba_dream_coil_enemy") then
			enemy[i]:AddNewModifier(caster, self, "modifier_confuse", {duration = self:GetSpecialValueFor("silence_duration")})
		end
	end
	Timers:CreateTimer(FrameTime(), function()
		if	self:GetCaster():TG_HasTalent("special_bonus_imba_puck_4") then
			local ability = caster:FindAbilityByName("imba_puck_dream_coil")
			if ability and ability:IsTrained() and not ability:GetAutoCastState() then
				local enemy = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster:Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
				for i=1, #enemy do
					if not caster:IsDisarmed() or caster:HasModifier("modifier_imba_phase_shift") then
						caster:PerformAttack(enemy[i], false, true, true, false, true, false, true)
					end
					if i >= 3 then
						break
					end
				end
			end
		end
		return nil
	end)
end

modifier_imba_waning_rift_silenced = class({})

function modifier_imba_waning_rift_silenced:IsDebuff()			return true end
function modifier_imba_waning_rift_silenced:IsHidden() 			return false end
function modifier_imba_waning_rift_silenced:IsPurgable() 		return true end
function modifier_imba_waning_rift_silenced:IsPurgeException() 	return true end
function modifier_imba_waning_rift_silenced:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_imba_waning_rift_silenced:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_imba_waning_rift_silenced:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_waning_rift_silenced:ShouldUseOverheadOffset() return true end

function modifier_imba_waning_rift_silenced:OnCreated()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_waning_rift_silenced:OnIntervalThink()
	if self:GetParent():HasModifier("modifier_imba_dream_coil_enemy") or self:GetParent():IsStunned() then
		self:SetDuration(self:GetRemainingTime() + FrameTime(), true)
	end
end
modifier_imba_waning_rift_agh = class({})
function modifier_imba_waning_rift_agh:IsDebuff()			return false end
function modifier_imba_waning_rift_agh:IsHidden() 			return false end
function modifier_imba_waning_rift_agh:IsPurgable() 		return false end
function modifier_imba_waning_rift_agh:IsPurgeException() 	return false end
function modifier_imba_waning_rift_agh:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_imba_waning_rift_agh:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
			MODIFIER_PROPERTY_MOVESPEED_LIMIT
			}
end
function modifier_imba_waning_rift_agh:GetModifierMoveSpeed_Absolute() if IsServer() then return 1 end end
function modifier_imba_waning_rift_agh:GetModifierMoveSpeed_Limit() if IsServer() then return 1 end end
function modifier_imba_waning_rift_agh:OnCreated(keys)
	if IsServer() then
		self.target_pos = keys.target_pos
		self.direction = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
		self.knockback_distance = 100
		self.knockback_height = 1
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_waning_rift_agh:OnIntervalThink()
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local distance = self.knockback_distance / total_ticks
	local height = self.knockback_height
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + self.direction * distance, nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)
	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 100, false)
end
function modifier_imba_waning_rift_agh:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
end
imba_puck_phase_shift = class({})

LinkLuaModifier("modifier_imba_phase_shift", "heros/hero_puck/hero_puck.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phase_shift_talent_passive", "heros/hero_puck/hero_puck.lua", LUA_MODIFIER_MOTION_NONE)
function imba_puck_phase_shift:GetIntrinsicModifierName() return "modifier_imba_phase_shift_talent_passive" end
function imba_puck_phase_shift:IsHiddenWhenStolen() 	return false end
function imba_puck_phase_shift:IsRefreshable() 			return true end
function imba_puck_phase_shift:IsStealable() 			return true end
function imba_puck_phase_shift:ProcsMagicStick() return (not self:GetCaster():HasModifier("modifier_imba_phase_shift")) end

function imba_puck_phase_shift:OnSpellStart()
	local caster = self:GetCaster()
	if not caster:HasModifier("modifier_imba_phase_shift") then
		if caster:GetUnitName() == "npc_dota_hero_puck" then
			caster:EmitSound("puck_puck_ability_phase_0"..RandomInt(1, 7))
		end
		caster:AddNewModifier(caster, self, "modifier_imba_phase_shift", {duration = self:GetSpecialValueFor("duration"), int = 0})
		self:EndCooldown()
		self:StartCooldown(0.3)
		ProjectileManager:ProjectileDodge(caster)
	else
		caster:RemoveModifierByName("modifier_imba_phase_shift")
	end
	if self:GetCaster():TG_HasTalent("special_bonus_imba_puck_6") then
		caster:Purge(false,true,false,false,false)
	end
	if self:GetCaster():TG_HasTalent("special_bonus_imba_puck_5") then
		local ability = caster:FindAbilityByName("imba_puck_dream_coil")
		if ability and ability:IsTrained() and not ability:GetAutoCastState() then
			local enemy = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster:Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
			for i=1, #enemy do
				if not caster:IsDisarmed() or caster:HasModifier("modifier_imba_phase_shift") then
					caster:PerformAttack(enemy[i], false, true, true, false, true, false, true)
				end
				if i >= 3 then
					break
				end
			end
		end
	end
end

modifier_imba_phase_shift = class({})

function modifier_imba_phase_shift:IsDebuff()			return false end
function modifier_imba_phase_shift:IsHidden() 			return false end
function modifier_imba_phase_shift:IsPurgable() 		return false end
function modifier_imba_phase_shift:IsPurgeException() 	return false end
function modifier_imba_phase_shift:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_OUT_OF_GAME] = true, [MODIFIER_STATE_UNSELECTABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_FLYING] = true} end
function modifier_imba_phase_shift:DeclareFunctions() return {MODIFIER_PROPERTY_MODEL_CHANGE, MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_PROPERTY_MOVESPEED_LIMIT, MODIFIER_PROPERTY_MOVESPEED_MAX} end
function modifier_imba_phase_shift:GetModifierModelChange() return "models/development/invisiblebox.vmdl" end
function modifier_imba_phase_shift:GetModifierMoveSpeed_Absolute() return 50 end
function modifier_imba_phase_shift:GetModifierMoveSpeed_Limit() return 50 end
function modifier_imba_phase_shift:GetModifierMoveSpeed_Max() return 50 end
function modifier_imba_phase_shift:GetEffectName() return "particles/units/heroes/hero_puck/puck_phase_shift.vpcf" end
function modifier_imba_phase_shift:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_phase_shift:OnCreated(keys)
	if IsServer() then
		self.int = keys.int
		self:GetParent():EmitSound("Hero_Puck.Phase_Shift")
	end
end

function modifier_imba_phase_shift:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Puck.Phase_Shift")
		--GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 180, false)
		if self.int == 0 then
			self:GetAbility():EndCooldown()
			self:GetAbility():StartCooldown(math.max(FrameTime(), (self:GetAbility():GetCooldown(-1) * self:GetCaster():GetCooldownReduction()) - self:GetElapsedTime()))
		end
	end
end
modifier_imba_phase_shift_talent_passive = class({})
function modifier_imba_phase_shift_talent_passive:IsDebuff()			return false end
function modifier_imba_phase_shift_talent_passive:IsHidden() 			return true  end
function modifier_imba_phase_shift_talent_passive:IsPurgable() 		return false end
function modifier_imba_phase_shift_talent_passive:IsPurgeException() 	return false end
function modifier_imba_phase_shift_talent_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_phase_shift_talent_passive:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsCourier() or not keys.target:IsAlive() then
		return
	end
	if not self:GetParent():TG_HasTalent("special_bonus_imba_puck_7") then
		return
	end
	local caster = self:GetParent()
	local ability = self:GetAbility()
	local spe = math.abs(keys.target:GetSpellAmplification(false)) * 100
	local damage_int = self:GetParent():TG_GetTalentValue("special_bonus_imba_puck_7")
	local damage = spe * damage_int

	ApplyDamage(
		{
			victim = keys.target,
			attacker = caster,
			ability = ability,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL
		})

end
imba_puck_dream_coil = class({})

LinkLuaModifier("modifier_imba_dream_coil_thinker", "heros/hero_puck/hero_puck.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dream_coil_range", "heros/hero_puck/hero_puck.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dream_coil_enemy", "heros/hero_puck/hero_puck.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dream_coil_caster", "heros/hero_puck/hero_puck.lua", LUA_MODIFIER_MOTION_NONE)

function imba_puck_dream_coil:IsHiddenWhenStolen() 		return false end
function imba_puck_dream_coil:IsRefreshable() 			return true end
function imba_puck_dream_coil:IsStealable() 			return true end
function imba_puck_dream_coil:GetAOERadius()			return self:GetSpecialValueFor("radius") end

function imba_puck_dream_coil:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local duration = caster:HasScepter() and self:GetSpecialValueFor("coil_duration_scepter") or self:GetSpecialValueFor("coil_duration")
	local thinker = CreateModifierThinker(caster, self, "modifier_imba_dream_coil_thinker", {duration = duration}, pos, caster:GetTeamNumber(), false)
	FindClearSpaceForUnit(thinker, pos, true)
	caster:AddNewModifier(thinker, self, "modifier_imba_dream_coil_caster", {duration = duration})
	if caster:GetUnitName() == "npc_dota_hero_puck" then
		caster:EmitSound("puck_puck_ability_dreamcoil_0"..RandomInt(1, 5))
	end
end

modifier_imba_dream_coil_thinker = class({})

function modifier_imba_dream_coil_thinker:OnCreated()
	self.parent=self:GetParent()
	self.ability=self:GetAbility()
	self.radius=self.ability:GetSpecialValueFor("radius")
	self.stun_duration=self.ability:GetSpecialValueFor("stun_duration")
	self.pos=self.parent:GetAbsOrigin()
	if IsServer() then
		self.parent:EmitSound("Hero_Puck.Dream_Coil")
		local pfx_name = "particles/units/heroes/hero_puck/puck_dreamcoil.vpcf"
	--	if HeroItems:UnitHasItem(self:GetCaster(), "blossom_of_the_merry_wanderer") then
	--		pfx_name = "particles/econ/items/puck/puck_ti10_immortal/puck_ti10_ult.vpcf"
	--	end
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self.parent:GetAbsOrigin())
		self:AddParticle(pfx, false, false, 15, false, false)
		local direction = self.parent:GetForwardVector()
		direction.z = 0
		local pos = self.parent:GetAbsOrigin() + direction * self.radius
		self.range = {}
		for i=1, 4 do
			self.range[i] = ParticleManager:CreateParticle("particles/hero/puck/puck_dreamcoil_range.vpcf", PATTACH_WORLDORIGIN, nil)
			--[[local range_pos = RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, 90 * i, 0), pos)
			self.range[i] = CreateModifierThinker(nil, self:GetAbility(), "modifier_imba_dream_coil_range", {}, range_pos, self:GetCaster():GetTeamNumber(), false)
			self.range[i]:GiveVisionForBothTeam()]]
		end
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_dream_coil_thinker:OnIntervalThink()
	local direction = self.parent:GetForwardVector()
	direction.z = 0
	local pos = self.parent:GetAbsOrigin() + direction * self.radius
	local new_pos = RotatePosition(self.parent:GetAbsOrigin(), QAngle(0, 5, 0), pos)
	local new_direction = (new_pos - self.parent:GetAbsOrigin()):Normalized()
	new_direction.z = 0
	for i=1, 4 do
		local range_pos = RotatePosition(self.parent:GetAbsOrigin(), QAngle(0, 90 * i, 0), new_pos)
		range_pos = GetGroundPosition(range_pos, nil)
		range_pos.z = range_pos.z + 128
		--[[self.range[i]:SetOrigin(range_pos)]]
		ParticleManager:SetParticleControl(self.range[i], 0, range_pos)
	end
	self.parent:SetForwardVector(new_direction)
	local caster = self.ability:GetCaster()
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #enemy>0 then
	for i=1, #enemy do
		if not enemy[i]:FindModifierByNameAndCaster("modifier_imba_dream_coil_enemy", self.parent) and self.parent:IsAlive() then
			enemy[i]:AddNewModifier(caster, self.ability, "modifier_imba_stunned", {duration = self.stun_duration})
			enemy[i]:AddNewModifier(self.parent, self.ability, "modifier_imba_dream_coil_enemy", {duration = self:GetRemainingTime()})
		end
	end
end
end

function modifier_imba_dream_coil_thinker:OnDestroy()
	if IsServer() then
		self.parent:StopSound("Hero_Puck.Dream_Coil")
		for i=1, 4 do
			--self.range[i]:ForceKill(false)
			ParticleManager:DestroyParticle(self.range[i], false)
		end
	end
end

modifier_imba_dream_coil_range = class({})

function modifier_imba_dream_coil_range:OnCreated()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
		local pfx = ParticleManager:CreateParticle("particles/hero/puck/puck_dreamcoil_range.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end

function modifier_imba_dream_coil_range:OnIntervalThink()
	DebugDrawCircle(self:GetParent():GetAbsOrigin(), Vector(255, 0, 0), 100, 50, true, FrameTime())
end

modifier_imba_dream_coil_enemy = class({})

function modifier_imba_dream_coil_enemy:IsDebuff()			return false end
function modifier_imba_dream_coil_enemy:IsHidden() 			return true end
function modifier_imba_dream_coil_enemy:IsPurgable() 		return false end
function modifier_imba_dream_coil_enemy:IsPurgeException() 	return false end
function modifier_imba_dream_coil_enemy:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_dream_coil_enemy:CheckState() return {[MODIFIER_STATE_TETHERED] = true} end

function modifier_imba_dream_coil_enemy:OnCreated()
	if IsServer() then
		local pfx_name = "particles/units/heroes/hero_puck/puck_dreamcoil_tether.vpcf"
	--	if HeroItems:UnitHasItem(self:GetCaster(), "blossom_of_the_merry_wanderer") then
	--		pfx_name = "particles/econ/items/puck/puck_ti10_immortal/puck_ti10_tether.vpcf"
	--	end
		self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(self.pfx, false, false, 15, false, false)
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_dream_coil_enemy:OnIntervalThink()
	if not self:GetCaster() then
		return
	end
	local ability = self:GetAbility()
	local caster = ability:GetCaster()
	local distance = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()
	if distance > ability:GetSpecialValueFor("radius") + self:GetParent():GetHullRadius() + 75 and not (self:GetParent():IsMagicImmune() and not caster:HasScepter()) then
		self:SetStackCount(1)
		self:Destroy()
	end
end

function modifier_imba_dream_coil_enemy:OnDestroy()
	if IsServer() then
		self:GetParent():EmitSound("Hero_Puck.Dream_Coil_Snap")
		if self:GetStackCount() == 1 then
			self:SetStackCount(0)
			local ability = self:GetAbility()
			local caster = ability:GetCaster()
			local target = self:GetParent()
			ApplyDamage({attacker = caster, victim = target, damage = (caster:HasScepter() and ability:GetSpecialValueFor("coil_break_damage_scepter") or ability:GetSpecialValueFor("coil_break_damage")), ability = ability, damage_type = ability:GetAbilityDamageType()})
			target:AddNewModifier(caster, ability, "modifier_imba_stunned", {duration = (caster:HasScepter() and ability:GetSpecialValueFor("coil_stun_duration_scepter") or ability:GetSpecialValueFor("coil_stun_duration"))})
		end
	end
end

modifier_imba_dream_coil_caster = class({})

function modifier_imba_dream_coil_caster:IsDebuff()			return false end
function modifier_imba_dream_coil_caster:IsHidden() 		return true end
function modifier_imba_dream_coil_caster:IsPurgable() 		return false end
function modifier_imba_dream_coil_caster:IsPurgeException() return false end
function modifier_imba_dream_coil_caster:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_dream_coil_caster:RemoveOnDeath() return false end
function modifier_imba_dream_coil_caster:AllowIllusionDuplicate() return false end

function modifier_imba_dream_coil_caster:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("attack_interval"))
	end
end

function modifier_imba_dream_coil_caster:OnIntervalThink()
	local thinker = self:GetCaster()
	local caster = self:GetParent()
	local ability = self:GetAbility()
	if not ability:GetAutoCastState() then
		local enemy = FindUnitsInRadius(caster:GetTeamNumber(), thinker:GetAbsOrigin(), nil, ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for i=1, #enemy do
			if enemy[i]:FindModifierByNameAndCaster("modifier_imba_dream_coil_enemy", thinker) and (not caster:IsDisarmed() or caster:HasModifier("modifier_imba_phase_shift")) then
				caster:PerformAttack(enemy[i], false, true, true, false, true, false, true)
			end
		end
	end
end