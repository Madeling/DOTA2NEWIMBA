CreateTalents("npc_dota_hero_storm_spirit", "hero/hero_storm_spirit")

imba_storm_spirit_static_remnant = class({})

LinkLuaModifier("modifier_imba_static_remnant_thinker", "hero/hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_static_remnant_trigger", "hero/hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_static_remnant_target", "hero/hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_static_remnant_cd", "hero/hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)

function imba_storm_spirit_static_remnant:IsHiddenWhenStolen() 		return false end
function imba_storm_spirit_static_remnant:IsRefreshable() 			return true end
function imba_storm_spirit_static_remnant:IsStealable() 			return true end
function imba_storm_spirit_static_remnant:GetCastRange() return self:GetSpecialValueFor("static_remnant_radius") - self:GetCaster():GetCastRangeBonus() end

function imba_storm_spirit_static_remnant:OnSpellStart(location)
	local caster = self:GetCaster()
	local pos = location or caster:GetAbsOrigin()
	caster:EmitSound("Hero_StormSpirit.StaticRemnantPlant")
	CreateModifierThinker(caster, self, "modifier_imba_static_remnant_thinker", {duration = self:GetSpecialValueFor("duration")}, pos, caster:GetTeamNumber(), false)
end

modifier_imba_static_remnant_thinker = class({})

function modifier_imba_static_remnant_thinker:OnCreated()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlForward(pfx, 0, self:GetCaster():GetForwardVector())
		ParticleManager:SetParticleControlEnt(pfx, 1, self:GetCaster(), PATTACH_CUSTOMORIGIN, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		local gesture = math.random(84, 96)
		local steal_gesture = {53, 59, 65, 66, 70, 77, 88, 101, 114, 121}
		if self:GetAbility():IsStolen() then
			gesture = RandomFromTable(steal_gesture)
		end
		ParticleManager:SetParticleControl(pfx, 2, Vector(gesture, self:GetCaster():GetModelScale(), 0))
		self:AddParticle(pfx, false, false, 15, false, false)
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("static_remnant_delay"))
	end
end

function modifier_imba_static_remnant_thinker:OnIntervalThink()
	if self:GetStackCount() == 0 then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("sec"))
		self:SetStackCount(1)
		CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_imba_static_remnant_trigger", {duration = self:GetDuration()}, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local pos = self:GetParent():GetAbsOrigin()
	AddFOWViewer(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), ability:GetSpecialValueFor("static_remnant_radius"), 1, false)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, caster:Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, enemy in pairs(enemies) do
		if not enemy:HasModifier("modifier_imba_static_remnant_cd") then
			enemy:AddNewModifier(caster, ability, "modifier_imba_static_remnant_cd", {duration = self:GetAbility():GetSpecialValueFor("sec")-0.05})
			ApplyDamage(
				{
				victim = enemy,
				attacker = caster,
				ability = ability,
				damage_type = ability:GetAbilityDamageType(),
				damage = ability:GetSpecialValueFor("sec_damage") + caster:TG_GetTalentValue("special_bonus_imba_storm_spirit_7")
				})

			local pfx = ParticleManager:CreateParticle("particles/econ/events/ti10/maelstrom_ti10.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
			--ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			--ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin() + Vector(0,0,75))
			ParticleManager:SetParticleControl(pfx, 2, Vector(1,1,1))
			ParticleManager:ReleaseParticleIndex(pfx)

			enemy:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
			break
		end
	end
end

function modifier_imba_static_remnant_thinker:OnDestroy()
	if not IsServer() then
		return
	end
	self:GetParent():EmitSound("Hero_StormSpirit.StaticRemnantExplode")
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local pos = self:GetParent():GetAbsOrigin()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, ability:GetSpecialValueFor("static_remnant_damage_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier_RS(caster, ability, "modifier_paralyzed", {duration = ability:GetSpecialValueFor("slow_duration") + caster:TG_GetTalentValue("special_bonus_imba_storm_spirit_1")})
		ApplyDamage(
			{
			victim = enemy,
			attacker = caster,
			ability = ability,
			damage_type = ability:GetAbilityDamageType(),
			damage = ability:GetSpecialValueFor("static_remnant_damage") + caster:TG_GetTalentValue("special_bonus_imba_storm_spirit_7")
			})
	end
	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

modifier_imba_static_remnant_trigger = class({})

function modifier_imba_static_remnant_trigger:IsAura() return true end
function modifier_imba_static_remnant_trigger:GetAuraDuration() return 0.1 end
function modifier_imba_static_remnant_trigger:GetModifierAura() return "modifier_imba_static_remnant_target" end
function modifier_imba_static_remnant_trigger:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("static_remnant_radius") end
function modifier_imba_static_remnant_trigger:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_static_remnant_trigger:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_static_remnant_trigger:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_imba_static_remnant_cd = class({})
function modifier_imba_static_remnant_cd:IsDebuff()			return false end
function modifier_imba_static_remnant_cd:IsHidden() 			return true end
function modifier_imba_static_remnant_cd:IsPurgable() 		return false end
function modifier_imba_static_remnant_cd:IsPurgeException() 	return false end

modifier_imba_static_remnant_target = class({})

function modifier_imba_static_remnant_target:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_static_remnant_target:IsHidden() return true end
function modifier_imba_static_remnant_target:OnCreated()
	if IsServer() then
		if self:GetCaster()~=nil then
		self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_kill", {duration = 0.1})
	end
	end
end

imba_storm_spirit_electric_vortex = class({})

LinkLuaModifier("modifier_imba_electric_vortex_motion", "hero/hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)

function imba_storm_spirit_electric_vortex:IsHiddenWhenStolen() 	return false end
function imba_storm_spirit_electric_vortex:IsRefreshable() 			return true end
function imba_storm_spirit_electric_vortex:IsStealable() 			return true end
function imba_storm_spirit_electric_vortex:GetBehavior()
	--if not self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	--else
		--return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	--end
end

function imba_storm_spirit_electric_vortex:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if not caster:HasScepter() then
		if target and target:TriggerStandardTargetSpell(self)  then
			return
		end
	end
	local max_target = caster:HasScepter() and 9999 or self:GetSpecialValueFor("extra_target")
	local target_enemies = {}
	if target then
		--target_enemies[#target_enemies + 1] = target
		table.insert (target_enemies, target)
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i=1, max_target+1 do
		if enemies[i] and not IsInTable(enemies[i], target_enemies) then
			table.insert (target_enemies, enemies[i])
			--target_enemies[#target_enemies + 1] = enemies[i]
		end
	end
	if target_enemies[1] then
		target_enemies[1]:EmitSound("Hero_StormSpirit.ElectricVortex")
	end
	for _, enemy in pairs(target_enemies) do
		enemy:AddNewModifier_RS(caster, self, "modifier_imba_electric_vortex_motion", {duration = self:GetSpecialValueFor("duration") + caster:TG_GetTalentValue("special_bonus_imba_storm_spirit_2")})
	end
	caster:EmitSound("Hero_StormSpirit.ElectricVortexCast")

	local ability = caster:FindAbilityByName("imba_storm_spirit_static_remnant")
	if ability and ability:GetLevel() > 0 then
		local pos = caster:GetAbsOrigin() + caster:GetForwardVector():Normalized() * self:GetSpecialValueFor("radius")
		local remnants = self:GetSpecialValueFor("remnant_counts")
		for i=1, remnants do
			local pos0 = RotatePosition(caster:GetAbsOrigin(), QAngle(0, i*(360/remnants), 0), pos)
			pos0 = GetGroundPosition(pos0, caster)
			ability:OnSpellStart(pos0)
		end
	end
end

modifier_imba_electric_vortex_motion = class({})

function modifier_imba_electric_vortex_motion:IsDebuff()			return true end
function modifier_imba_electric_vortex_motion:IsHidden() 			return false end
function modifier_imba_electric_vortex_motion:IsPurgable() 			return false end
function modifier_imba_electric_vortex_motion:IsPurgeException() 	return true end
function modifier_imba_electric_vortex_motion:IsStunDebuff() return true end
function modifier_imba_electric_vortex_motion:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true} end
function modifier_imba_electric_vortex_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_imba_electric_vortex_motion:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_imba_electric_vortex_motion:IsMotionController() return true end
function modifier_imba_electric_vortex_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_imba_electric_vortex_motion:OnCreated()
	if IsServer() then
		self.pos = self:GetCaster():GetAbsOrigin()
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
		if self:CheckMotionControllers() then
			self:StartIntervalThink(FrameTime())
		else
			self:Destroy()
		end
	end
end

function modifier_imba_electric_vortex_motion:OnIntervalThink()
	local distance = self:GetAbility():GetSpecialValueFor("electric_vortex_pull_units_per_second") / (1.0 / FrameTime())
	local direction = (self.pos - self:GetParent():GetAbsOrigin()):Normalized()
	local pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + direction * distance, nil)
	self:GetParent():SetOrigin(pos)
end

function modifier_imba_electric_vortex_motion:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_StormSpirit.ElectricVortex")
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		self.pos = nil
	end
end

imba_storm_spirit_overload = class({}) --overload

LinkLuaModifier("modifier_imba_overload_passive", "hero/hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_overload_effect", "hero/hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_overload_slow", "hero/hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_overload_int", "hero/hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_overload_chance", "hero/hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)
function imba_storm_spirit_overload:GetBehavior()
	if not self:GetCaster():TG_HasTalent("special_bonus_imba_storm_spirit_6") then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
end
function imba_storm_spirit_overload:GetIntrinsicModifierName() return "modifier_imba_overload_passive" end
function imba_storm_spirit_overload:OnSpellStart(location)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_imba_overload_chance", {duration = 5})
end
modifier_imba_overload_passive = class({})

function modifier_imba_overload_passive:IsDebuff()			return false end
function modifier_imba_overload_passive:IsHidden()
	return self:GetParent()==self:GetCaster() and true or  false
end
function modifier_imba_overload_passive:IsPurgable() 		return false end
function modifier_imba_overload_passive:IsPurgeException() 	return false end
function modifier_imba_overload_passive:RemoveOnDeath() return self:GetParent():IsIllusion() end
function modifier_imba_overload_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_EXECUTED, MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_imba_overload_passive:OnAbilityExecuted(keys)
	if not IsServer() or keys.ability:IsItem() or keys.unit ~= self:GetParent() then
		return
	end
	self:GetParent():AddModifierStacks(self:GetParent(), self:GetAbility(), "modifier_imba_overload_effect", {}, 1, false, true)
end

function modifier_imba_overload_passive:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsCourier() or not keys.target:IsAlive() then
		return
	end
	local caster = self:GetParent()
	local ability = self:GetAbility()
	if caster:HasModifier("modifier_imba_overload_int") then
		return
	end
	local chance = ability:GetSpecialValueFor("passive_chance")
	if caster:HasModifier("modifier_imba_overload_chance") then
		chance = 60
	end
	if caster:HasModifier("modifier_imba_overload_effect") or PseudoRandom:RollPseudoRandom(self:GetAbility(), chance) then
		local stacks = caster:GetModifierStackCount("modifier_imba_overload_effect", nil)
		if stacks == 0 then
			stacks = 1
		end
		local mag = DOTA_UNIT_TARGET_FLAG_NONE
		--if caster:TG_HasTalent("special_bonus_imba_storm_spirit_6") then
		--	mag = DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		--end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, ability:GetSpecialValueFor("overload_aoe"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, mag, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			local arm = math.abs(enemy:GetPhysicalArmorValue(false)) * caster:TG_GetTalentValue("special_bonus_imba_storm_spirit_8") * 0.01
			ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage = ability:GetSpecialValueFor("damage") + arm, damage_type = ability:GetAbilityDamageType()})
			if not self:GetParent():TG_HasTalent("special_bonus_imba_storm_spirit_5") then
				enemy:AddNewModifier(caster, ability, "modifier_imba_overload_slow", {duration = ability:GetSpecialValueFor("duration") * stacks})
			else
				enemy:AddNewModifier(caster, ability, "modifier_paralyzed", {duration = ability:GetSpecialValueFor("duration") * stacks})
			end
		end
		caster:RemoveModifierByName("modifier_imba_overload_effect")
		local pfx_name = "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, keys.target)
		ParticleManager:ReleaseParticleIndex(pfx)
		keys.target:EmitSound("Hero_StormSpirit.Overload")
		local dmg = 0
		if caster:TG_HasTalent("special_bonus_imba_storm_spirit_4") then
			self:GetAbility():GlaiveAttck(keys.target, dmg, 0)
		end
	end
end
function modifier_imba_overload_passive:OnDestroy()
	if not IsServer() then
		return
	end
	if self:GetParent():HasModifier("modifier_imba_overload_effect") then
		self:GetParent():RemoveModifierByName("modifier_imba_overload_effect")
	end
end
function imba_storm_spirit_overload:GlaiveAttck(source, damage, bounce)
	local target = nil
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), source:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= source then
			target = enemy
			break
		end
	end
	if target == nil then
		return
	end
	local info =
	{
		Target = target,
		Source = source,
		Ability = self,
		EffectName = self:GetCaster():GetRangedProjectileName(),
		iMoveSpeed = (self:GetCaster():IsRangedAttacker() and self:GetCaster():GetProjectileSpeed() or 900),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
		ExtraData = {bounces = bounce, dmg = damage}
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function imba_storm_spirit_overload:OnProjectileHit_ExtraData(target, location, keys)
	local damage = 0
	local caster = self:GetCaster()
	if target then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_overload_int", {})
		self:GetCaster():PerformAttack(target, false, true, true, false, false, false, true)
		self:GetCaster():RemoveModifierByName("modifier_imba_overload_int")

		local pfx_name = "particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, target)
		ParticleManager:ReleaseParticleIndex(pfx)
		target:EmitSound("Hero_StormSpirit.Overload")
		if not target:IsBlind() then
			local mag = DOTA_UNIT_TARGET_FLAG_NONE
			--if caster:TG_HasTalent("special_bonus_imba_storm_spirit_6") then
			--	mag = DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
			--end
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("overload_aoe"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, mag, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				local arm = math.abs(enemy:GetPhysicalArmorValue(false)) * caster:TG_GetTalentValue("special_bonus_imba_storm_spirit_8") * 0.01
				ApplyDamage({victim = enemy, attacker = caster, ability = self, damage = self:GetSpecialValueFor("damage") + arm, damage_type = self:GetAbilityDamageType()})
				if not caster:TG_HasTalent("special_bonus_imba_storm_spirit_5") then
					enemy:AddNewModifier_RS(caster, self, "modifier_imba_overload_slow", {duration = self:GetSpecialValueFor("duration")})
				else
					enemy:AddNewModifier_RS(caster, self, "modifier_paralyzed", {duration = self:GetSpecialValueFor("duration")})
				end
			end
		end
		local bounce = keys.bounces + 1
		if bounce >= caster:TG_GetTalentValue("special_bonus_imba_storm_spirit_4") then
			return
		end
		local next_target = target
		self:GlaiveAttck(next_target, damage, bounce)
	end
end

modifier_imba_overload_effect = class({})

function modifier_imba_overload_effect:IsDebuff()			return false end
function modifier_imba_overload_effect:IsHidden() 			return false end
function modifier_imba_overload_effect:IsPurgable() 		return false end
function modifier_imba_overload_effect:IsPurgeException() 	return false end
function modifier_imba_overload_effect:DeclareFunctions() return {MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS} end
function modifier_imba_overload_effect:GetActivityTranslationModifiers() return "overload" end

function modifier_imba_overload_effect:OnCreated()
	if IsServer() then
		local pfx_name = "particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf"
	--	if HeroItems:UnitHasItem(self:GetCaster(), "storm_spirit_overload_ti8") then
	--		pfx_name = "particles/econ/items/storm_spirit/strom_spirit_ti8/storm_spirit_ti8_overload_gold_ambient.vpcf"
	--	end
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end

modifier_imba_overload_slow = class({})

function modifier_imba_overload_slow:IsDebuff()			return true end
function modifier_imba_overload_slow:IsHidden() 		return false end
function modifier_imba_overload_slow:IsPurgable() 		return true end
function modifier_imba_overload_slow:IsPurgeException() return true end
function modifier_imba_overload_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_overload_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("overload_move_slow")) end
function modifier_imba_overload_slow:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("overload_attack_slow")) end

modifier_imba_overload_int = class({})

function modifier_imba_overload_int:IsDebuff()			return false end
function modifier_imba_overload_int:IsHidden() 		return true end
function modifier_imba_overload_int:IsPurgable() 		return false end
function modifier_imba_overload_int:IsPurgeException() return false end
modifier_imba_overload_chance = class({})

function modifier_imba_overload_chance:IsDebuff()			return false end
function modifier_imba_overload_chance:IsHidden() 		return false end
function modifier_imba_overload_chance:IsPurgable() 		return false end
function modifier_imba_overload_chance:IsPurgeException() return false end


imba_storm_spirit_ball_lightning = class({})

LinkLuaModifier("modifier_imba_ball_lightning_travel", "hero/hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ball_lightning_mana_penalty", "hero/hero_storm_spirit", LUA_MODIFIER_MOTION_NONE)

function imba_storm_spirit_ball_lightning:IsHiddenWhenStolen() 		return false end
function imba_storm_spirit_ball_lightning:IsRefreshable() 			return true end
function imba_storm_spirit_ball_lightning:IsStealable() 			return true end
function imba_storm_spirit_ball_lightning:GetManaCost() return (self:GetSpecialValueFor("ball_lightning_initial_mana_base") + self:GetCaster():GetMaxMana() * (self:GetSpecialValueFor("ball_lightning_initial_mana_percentage") / 100)) * (1 + self:GetCaster():GetModifierStackCount("modifier_imba_ball_lightning_mana_penalty", nil) * (self:GetSpecialValueFor("mana_penalty_pct") / 100)) end

function imba_storm_spirit_ball_lightning:GetCastRange() return (IsServer() and 99999 or self:GetSpecialValueFor("ball_lightning_aoe") - self:GetCaster():GetCastRangeBonus()) end

function imba_storm_spirit_ball_lightning:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	caster:AddNewModifier(caster, self, "modifier_invulnerable", {duration = self:GetSpecialValueFor("cast_invul_duration")})
	caster:AddNewModifier(caster, self, "modifier_imba_ball_lightning_travel", {pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
	ProjectileManager:ProjectileDodge(caster)
	if (caster:GetAbsOrigin() - pos):Length2D() >= self:GetSpecialValueFor("mana_penalty_distance") then
		caster:AddModifierStacks(caster, self, "modifier_imba_ball_lightning_mana_penalty", {}, 1, false, true):SetDuration(-1, true)
	end
end

modifier_imba_ball_lightning_travel = class({})

function modifier_imba_ball_lightning_travel:IsDebuff()			return false end
function modifier_imba_ball_lightning_travel:IsHidden() 		return false end
function modifier_imba_ball_lightning_travel:IsPurgable() 		return false end
function modifier_imba_ball_lightning_travel:IsPurgeException() return false end
function modifier_imba_ball_lightning_travel:CheckState() return {[MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true} end
function modifier_imba_ball_lightning_travel:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION,MODIFIER_EVENT_ON_ORDER} end
function modifier_imba_ball_lightning_travel:GetOverrideAnimation() return ACT_DOTA_OVERRIDE_ABILITY_4 end
function modifier_imba_ball_lightning_travel:IsMotionController() return true end
function modifier_imba_ball_lightning_travel:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_imba_ball_lightning_travel:OnCreated(keys)
	if IsServer() then
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.start_pos = self:GetParent():GetAbsOrigin()
		self.current_pos = self:GetParent():GetAbsOrigin()
		self.ability = self:GetAbility()
		self.talent_travel = 0
		local sound_name = "Hero_StormSpirit.BallLightning"
		local pfx_name = "particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf"
	--	if HeroItems:UnitHasItem(self:GetCaster(), "storm_spirit_ball_lightning_ti8") then
	--		sound_name = "Hero_StormSpirit.Orchid_BallLightning"
	--		pfx_name = "particles/econ/items/storm_spirit/storm_spirit_orchid_hat_retro/stormspirit_orchid_retro_ball_lightning.vpcf"
	--	end
		self:GetParent():EmitSound(sound_name)
		self:GetParent():EmitSound("Hero_StormSpirit.BallLightning.Loop")
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_pos, true)
		ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_pos, true)
		self:AddParticle(pfx, false, false, 15, false, false)
		if self:GetParent():HasAbility("imba_storm_spirit_electric_vortex") and self:GetParent():HasScepter() then
			local ability = self:GetParent():FindAbilityByName("imba_storm_spirit_electric_vortex")
			local pfx_range = ParticleManager:CreateParticleForPlayer("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner())
			ParticleManager:SetParticleControl(pfx_range, 1, Vector(ability:GetSpecialValueFor("radius"), 0, 0))
			ParticleManager:SetParticleControl(pfx_range, 2, Vector(10, 0, 0))
			ParticleManager:SetParticleControl(pfx_range, 3, Vector(100, 0, 0))
			ParticleManager:SetParticleControl(pfx_range, 15, Vector(0, 0, 255))
			self:AddParticle(pfx_range, true, false, 15, false, false)
		end
		if self:CheckMotionControllers() then
			self:StartIntervalThink(FrameTime())
		else
			self:Destroy()
		end
	end
end

function modifier_imba_ball_lightning_travel:OnIntervalThink()
	self.current_pos = self:GetParent():GetAbsOrigin()
	if (self.current_pos - self.pos):Length2D() <= 50 or self:GetParent():IsStunned() or self:GetParent():IsSilenced() or self:GetParent():IsHexed() then
		self:Destroy()
		return
	end
	AddFOWViewer(self:GetParent():GetTeamNumber(), self.current_pos, self.ability:GetSpecialValueFor("ball_lightning_vision_radius"), 0.1, false)
	self:SetStackCount((self.current_pos - self.start_pos):Length2D())
	local direction = (self.pos - self:GetParent():GetAbsOrigin()):Normalized()
	local distance = (self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false) * ((self.ability:GetSpecialValueFor("ball_lightning_move_speed") + self:GetParent():TG_GetTalentValue("special_bonus_imba_storm_spirit_3")) / 100)) / (1.0 / FrameTime())
	if distance > (self.current_pos - self.pos):Length2D() then
		distance = (self.current_pos - self.pos):Length2D()
	end
	local next_pos = GetGroundPosition(self.current_pos + direction * distance, nil)
	--[[if self:GetParent():TG_HasTalent("special_bonus_imba_storm_spirit_4") and self:GetParent():HasAbility("imba_storm_spirit_static_remnant") then
		self.talent_travel = self.talent_travel + (next_pos - self.current_pos):Length2D()
		if self.talent_travel >= self:GetParent():TG_GetTalentValue("special_bonus_imba_storm_spirit_4") then
			self.talent_travel = self.talent_travel - self:GetParent():TG_GetTalentValue("special_bonus_imba_storm_spirit_4")
			local ability = self:GetParent():FindAbilityByName("imba_storm_spirit_static_remnant")
			if ability:GetLevel() > 0 then
				ability:OnSpellStart()
			end
		end
	end]]
	self:GetParent():SetOrigin(next_pos)
	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 180, true)
end

-- Stop BallLightning
function modifier_imba_ball_lightning_travel:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION or
		params.order_type==DOTA_UNIT_ORDER_STOP then
			if self:GetStackCount() > self:GetAbility():GetSpecialValueFor("min_stop_distance") then
				self:Destroy()
			end
	end
end

function modifier_imba_ball_lightning_travel:OnDestroy()
	if IsServer() then
		local damage = self:GetStackCount() / 100 * self.ability:GetSpecialValueFor("travel_damage")
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), damage, nil)
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.ability:GetSpecialValueFor("ball_lightning_aoe"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = damage, ability = self.ability, damage_type = self.ability:GetAbilityDamageType()})
		end
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		self:GetParent():RemoveModifierByName("modifier_invulnerable")
		self:GetParent():StopSound("Hero_StormSpirit.BallLightning.Loop")
	end
end

modifier_imba_ball_lightning_mana_penalty = class({})

function modifier_imba_ball_lightning_mana_penalty:IsDebuff()			return false end
function modifier_imba_ball_lightning_mana_penalty:IsHidden() 			return false end
function modifier_imba_ball_lightning_mana_penalty:IsPurgable() 		return false end
function modifier_imba_ball_lightning_mana_penalty:IsPurgeException() 	return false end
function modifier_imba_ball_lightning_mana_penalty:RemoveOnDeath() return self:GetParent():IsIllusion() end
function modifier_imba_ball_lightning_mana_penalty:AllowIllusionDuplicate() return false end
function modifier_imba_ball_lightning_mana_penalty:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_TOOLTIP} end

function modifier_imba_ball_lightning_mana_penalty:OnTooltip() return self:GetAbility():GetSpecialValueFor("mana_penalty_pct") * self:GetStackCount() end

function modifier_imba_ball_lightning_mana_penalty:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and IsEnemy(keys.unit, keys.attacker) and keys.unit:IsHero() then
		if self:GetDuration() <= 0 then
			self:SetDuration(self:GetAbility():GetSpecialValueFor("mana_penalty_remove_delay"), true)
		end
	end
end


--2021/1/27/ 新
electric_rave=class({})

function electric_rave:IsHiddenWhenStolen() 		return false end
function electric_rave:IsRefreshable() 			return true end
function electric_rave:IsStealable() 			return true end

function electric_rave:OnInventoryContentsChanged()
    local caster=self:GetCaster()
    if caster:Has_Aghanims_Shard() then
		self:SetLevel(1)
		self:SetHidden(false)
    end
end


function electric_rave:OnSpellStart()
	local caster = self:GetCaster()
	local pos=caster:GetAbsOrigin()
	local charges=self:GetSpecialValueFor("charges")
	local duration=self:GetSpecialValueFor("duration")
	local ab=caster:FindAbilityByName("imba_storm_spirit_overload")
	if ab  and ab:GetLevel()>0 then
		EmitSoundOn("TG.pr", caster)
		EmitSoundOn("Hero_StormSpirit.StaticRemnantPlant", caster)
		local pf = ParticleManager:CreateParticle("particles/econ/events/ti10/hot_potato/disco_ball_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(pf, 0,pos)
		local pf1 = ParticleManager:CreateParticle("particles/econ/items/storm_spirit/strom_spirit_ti8/storm_spirit_ti8_overload_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(pf1, 0,pos)
		ParticleManager:SetParticleControl(pf1, 2,pos)
		ParticleManager:SetParticleControl(pf1, 5,pos)
		ParticleManager:ReleaseParticleIndex(pf1)
		local pf2 = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_disco_tnt.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(pf2, 0,pos)
		Timers:CreateTimer({
			useGameTime = false,
			endTime =5,
			callback = function()
			if pf then
				ParticleManager:DestroyParticle(pf, false)
				ParticleManager:ReleaseParticleIndex(pf)
			end
			if pf2 then
				ParticleManager:DestroyParticle(pf2, false)
				ParticleManager:ReleaseParticleIndex(pf2)
			end
		end
		})
		local heros = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if #heros>0 then
			for _, target in pairs(heros) do
				if target~=caster then
					local p2 = ParticleManager:CreateParticle("particles/econ/events/ti6/maelstorm_ti6.vpcf", PATTACH_POINT_FOLLOW, target)
					ParticleManager:SetParticleControlEnt(p2, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(p2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:SetParticleControl(p2, 2, Vector(1,1,1))
					ParticleManager:ReleaseParticleIndex(p2)
					target:AddNewModifier(caster, ab, "modifier_imba_overload_passive", {duration=duration})
				end
			end
		end
	end
end
