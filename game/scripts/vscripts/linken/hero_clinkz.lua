--2021.06.01---by你收拾收拾准备出林肯吧
CreateTalents("npc_dota_hero_clinkz", "linken/hero_clinkz")
imba_clinkz_strafe_searing_arrows = class({})

LinkLuaModifier("modifier_imba_strafe_active", "linken/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_strafe_passive", "linken/hero_clinkz", LUA_MODIFIER_MOTION_NONE)

function imba_clinkz_strafe_searing_arrows:GetIntrinsicModifierName() return "modifier_imba_strafe_passive" end
function imba_clinkz_strafe_searing_arrows:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_clinkz_5") then
		return (cooldown - caster:TG_GetTalentValue("special_bonus_imba_clinkz_5"))
	end
	return cooldown
end

function imba_clinkz_strafe_searing_arrows:OnSpellStart()
	self.caster = self:GetCaster()
	self.caster:AddNewModifier(self.caster, self, "modifier_imba_strafe_active", {duration = self:GetSpecialValueFor("duration")})
	EmitSoundOnLocationWithCaster(self.caster:GetAbsOrigin(), "Hero_Clinkz.Strafe", self.caster)
end

modifier_imba_strafe_active = class({})

function modifier_imba_strafe_active:IsDebuff()				return false end
function modifier_imba_strafe_active:IsHidden() 			return false end
function modifier_imba_strafe_active:IsPurgable() 			return false end
function modifier_imba_strafe_active:IsPurgeException() 	return false end
function modifier_imba_strafe_active:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_strafe_active:GetEffectName() return "particles/units/heroes/hero_clinkz/clinkz_strafe.vpcf" end
function modifier_imba_strafe_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

modifier_imba_strafe_passive = class({})

function modifier_imba_strafe_passive:IsDebuff()			return false end
function modifier_imba_strafe_passive:IsHidden() 			return true end
function modifier_imba_strafe_passive:IsPurgable() 			return false end
function modifier_imba_strafe_passive:IsPurgeException() 	return false end
function modifier_imba_strafe_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		}
end
function modifier_imba_strafe_passive:OnCreated()
	self.ability = self:GetAbility()
	self.as_bonus = self.ability:GetSpecialValueFor("attack_speed_bonus_pct")
	self.miss = self.ability:GetSpecialValueFor("miss")
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.damage = self.ability:GetSpecialValueFor("damage_bonus") + self.caster:TG_GetTalentValue("special_bonus_imba_clinkz_6")
	if IsServer() then
		self.records = {}
		self.count = 1
		self.bonus_range = 200
	end
end
function modifier_imba_strafe_passive:OnRefresh()
	self:OnCreated()
end

function modifier_imba_strafe_passive:GetModifierAttackSpeedBonus_Constant()
	if self.caster:HasModifier("modifier_imba_strafe_active") then
		return self.as_bonus * 2
	end
	return self.as_bonus
end
function modifier_imba_strafe_passive:GetModifierEvasion_Constant(keys)
	if self.caster:HasModifier("modifier_imba_strafe_active") and keys.attacker:IsRangedAttacker() then
		return self.miss
	end
	return 0
end
function modifier_imba_strafe_passive:GetModifierProjectileName() return "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf" end
function modifier_imba_strafe_passive:OnAttackStart(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self.parent or self.parent:PassivesDisabled() or self.parent:IsIllusion() then
		return
	end
	EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Hero_Clinkz.SearingArrows", self.parent)
end

function modifier_imba_strafe_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self.parent or self.parent:PassivesDisabled() or self.parent:IsIllusion() or not keys.target:IsAlive() then
		return
	end
	local target = keys.target
	local damageTable = {
						victim = target,
						attacker = self.caster,
						damage = self.damage,
						damage_type = self.ability:GetAbilityDamageType(),
						ability = self.ability,
						damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE,
						}
	if self.caster:HasModifier("modifier_imba_strafe_active") then
		damageTable.damage = self.damage * 2
	end
	ApplyDamage(damageTable)
	target:EmitSound("Hero_Clinkz.SearingArrows.Impact")
end
function modifier_imba_strafe_passive:OnAttack( params )
	if not IsServer() then
		return
	end
	if params.attacker~=self:GetParent() then return end

	self.records[params.record] = true


	-- decrement stack
	if params.no_attack_cooldown then return end

	-- not proc for attacking allies
	if params.target:GetTeamNumber()==params.attacker:GetTeamNumber() then return end

	-- not proc if attack can't use attack modifiers
	if not params.process_procs then return end

	-- not proc on split shot attacks, even if it can use attack modifier, to avoid endless recursive call and crash
	if self.split_shot then return end

	if self.parent:TG_HasTalent("special_bonus_imba_clinkz_1") then
		self:SplitShotModifier( params.target )
	end
end
function modifier_imba_strafe_passive:SplitShotModifier( target )
	-- get radius
	local radius = self.parent:Script_GetAttackRange() + self.bonus_range

	-- find other target units
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	-- int, flag filter
		1,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- get targets
	local count = 0
	for _,enemy in pairs(enemies) do
		-- not target itself
		if enemy~=target then

			-- perform attack
			self.split_shot = true
			self.parent:PerformAttack(
				enemy, -- hTarget
				false, -- bUseCastAttackOrb
				true, -- bProcessProcs
				true, -- bSkipCooldown
				false, -- bIgnoreInvis
				true, -- bUseProjectile
				false, -- bFakeAttack
				false -- bNeverMiss
			)
			self.split_shot = false
			count = count + 1
			if count>=self.count then break end
		end
	end
end

imba_clinkz_burning_army = class({})

LinkLuaModifier("modifier_imba_burning_army", "linken/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_burning_army_reduce_damage", "linken/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
function imba_clinkz_burning_army:OnSpellStart(keys)
	self.caster = self:GetCaster()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    if not keys then
    	self.duration = self:GetSpecialValueFor("duration") + self.caster:TG_GetTalentValue("special_bonus_imba_clinkz_2")
    end
	self.illusion = CreateUnitByName("npc_dota_clinkz_skeleton_archer", caster_pos, true, caster, caster, caster:GetTeamNumber())
	self.illusion:AddNewModifier(caster, self, "modifier_imba_burning_army", {duration = self.duration, illusion = self.illusion:entindex()})
	self.illusion:AddNewModifier(caster, self, "modifier_kill", {duration = self.duration})
	self.illusion:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
end

modifier_imba_burning_army = class({})

function modifier_imba_burning_army:IsDebuff()			return false end
function modifier_imba_burning_army:IsHidden() 			return false end
function modifier_imba_burning_army:IsPurgable() 		return false end
function modifier_imba_burning_army:IsPurgeException() 	return false end
function modifier_imba_burning_army:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_HERO_KILLED,
		}
end
function modifier_imba_burning_army:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, --拥有飞机穿越地形的能力，但是算作地面单位
		[MODIFIER_STATE_DISARMED] = true,	-- 缴械
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true, --穿越单位
		[MODIFIER_STATE_INVULNERABLE] = true, --无敌
		[MODIFIER_STATE_NO_HEALTH_BAR] = true, --移除生命血条
		[MODIFIER_STATE_UNSELECTABLE] = true, --无法被选中
		[MODIFIER_STATE_INVISIBLE] = self.caster:IsInvisible(),
	}
	return state
end
function modifier_imba_burning_army:GetModifierInvisibilityLevel()
	if self.caster:IsInvisible() then
		return 1
	end
	return 0
end
function modifier_imba_burning_army:OnCreated(keys)
	self.ability = self:GetAbility()
	self.as_bonus = self.ability:GetSpecialValueFor("attack_speed_bonus_pct")
	self.damage = self.ability:GetSpecialValueFor("damage_bonus")
	self.scepter = self.ability:GetSpecialValueFor("scepter")
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.shot = true
	if IsServer() then
		self.illusion = EntIndexToHScript(keys.illusion)
		self.info =
		{
			Target = self.parent,
			Source = self.parent,
			Ability = self.ability,
			EffectName = "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf",
			iMoveSpeed = self.caster:GetProjectileSpeed()-150,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = true,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 10,
			bProvidesVision = false,
			ExtraData = {int = true},
		}
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_burning_army:OnIntervalThink()
	self.parent:SetAbsOrigin(self.caster:GetAbsOrigin()+Vector(0,0,185))
	self.parent:SetForwardVector(self.caster:GetForwardVector())
	if not self.caster:IsAlive() and self.ability.illusion then
		self.ability.illusion:Kill(self.ability, self.caster)
		self:Destroy()
	end
end
function modifier_imba_burning_army:OnAttack(keys)
	if IsServer() then
		if keys.no_attack_cooldown then return end
		if not keys.process_procs then return end
		if keys.attacker == self.caster then
			self.shot = true
			self.parent:StartGesture(ACT_DOTA_ATTACK)
			self.info.Target = keys.target
			self.info.int = self.shot
			ProjectileManager:CreateTrackingProjectile(self.info)
			if self.caster:TG_HasTalent("special_bonus_imba_clinkz_1") then
				local enemies = FindUnitsInRadius(
					self.parent:GetTeamNumber(),	-- int, your team number
					self.parent:GetOrigin(),	-- point, center point
					nil,	-- handle, cacheUnit. (not known)
					self.parent:Script_GetAttackRange()+200,	-- float, radius. or use FIND_UNITS_EVERYWHERE
					DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER,	-- int, type filter
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	-- int, flag filter
					1,	-- int, order filter
					false	-- bool, can grow cache
				)
				for _,enemy in pairs(enemies) do
					if enemy~=keys.target then
						self.info.Target = enemy
						ProjectileManager:CreateTrackingProjectile(self.info)
						break
					end
				end
			end

			self.shot = false
		end
	end
end
function modifier_imba_burning_army:OnHeroKilled(keys)
	if not IsServer() then
		return
    end
    if keys.attacker == self.caster or (keys.inflictor and keys.ability and keys.ability:GetCaster() == self.caster) and self.caster:HasScepter() then
        local time = self:GetRemainingTime() + self.scepter
        local modifier = self.illusion:FindModifierByName("modifier_kill")
        modifier:SetDuration(time, true)
        self:SetDuration(time, true)
    end
end
function imba_clinkz_burning_army:OnProjectileHit_ExtraData(target, pos, keys)
	if keys.shot then return end
	if target then
			self.caster:AddNewModifier(self.caster, self, "modifier_imba_burning_army_reduce_damage", {})
			self.caster:PerformAttack(target, true, true, true, false, false, false, false)
			self.caster:RemoveModifierByName("modifier_imba_burning_army_reduce_damage")
		return
	end
end
modifier_imba_burning_army_reduce_damage = class({})

function modifier_imba_burning_army_reduce_damage:IsDebuff()			return true end
function modifier_imba_burning_army_reduce_damage:IsHidden() 			return true end
function modifier_imba_burning_army_reduce_damage:IsPurgable() 			return false end
function modifier_imba_burning_army_reduce_damage:IsPurgeException() 	return false end
function modifier_imba_burning_army_reduce_damage:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
			}
end
function modifier_imba_burning_army_reduce_damage:GetModifierTotalDamageOutgoing_Percentage()
  return 0 - (100-self:GetAbility():GetSpecialValueFor("reduce_damage"))
end

imba_clinkz_wind_walk = class({})

LinkLuaModifier("modifier_imba_skeleton_walk", "linken/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skeleton_walk_extra", "linken/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
function imba_clinkz_wind_walk:GetIntrinsicModifierName() return "modifier_imba_skeleton_walk_extra" end
function imba_clinkz_wind_walk:OnSpellStart()
	local caster = self:GetCaster()
	local fade_time = self:GetSpecialValueFor("fade_time")
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_windwalk.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(pfx)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Clinkz.WindWalk", caster)
	Timers:CreateTimer(fade_time, function()
		caster:AddNewModifier(caster, self, "modifier_imba_skeleton_walk", {duration = self:GetSpecialValueFor("duration")})
		return nil
	end)
	--[[local modifier = caster:FindModifierByName("modifier_imba_skeleton_walk_extra")
	modifier:Destroy()
	caster:AddNewModifier(caster, self, "modifier_imba_skeleton_walk_extra", {})]]
end

modifier_imba_skeleton_walk = class({})

function modifier_imba_skeleton_walk:IsDebuff()				return false end
function modifier_imba_skeleton_walk:IsHidden() 			return false end
function modifier_imba_skeleton_walk:IsPurgable() 			return false end
function modifier_imba_skeleton_walk:IsPurgeException() 	return false end
function modifier_imba_skeleton_walk:GetEffectName() return "particles/generic_hero_status/status_invisibility_start.vpcf" end
function modifier_imba_skeleton_walk:GetEffectAttachType() return PATTACH_ABSORIGIN end
function modifier_imba_skeleton_walk:CheckState()
	if self:GetCaster():TG_HasTalent("special_bonus_imba_clinkz_7") then
		return {[MODIFIER_STATE_INVISIBLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_ALLOW_PATHING_THROUGH_CLIFFS] = true}
	end
	return {[MODIFIER_STATE_INVISIBLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
end
function modifier_imba_skeleton_walk:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_DISABLE_AUTOATTACK, MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ATTACK, MODIFIER_EVENT_ON_ABILITY_EXECUTED, MODIFIER_PROPERTY_INVISIBILITY_LEVEL}
end
function modifier_imba_skeleton_walk:GetModifierMoveSpeedBonus_Percentage() return self.as_bonus end
function modifier_imba_skeleton_walk:GetDisableAutoAttack() return true end
function modifier_imba_skeleton_walk:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.as_bonus = self.ability:GetSpecialValueFor("move_speed_bonus_pct") + self.caster:TG_GetTalentValue("special_bonus_imba_clinkz_4")
	self.shard = self.ability:GetSpecialValueFor("shard")

	if IsServer() then

	end
end
function modifier_imba_skeleton_walk:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self.parent and self.parent:IsRangedAttacker() then
		self:Destroy()
	end
end

function modifier_imba_skeleton_walk:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self.parent and not self.parent:IsRangedAttacker() then
		self:Destroy()
	end
end

function modifier_imba_skeleton_walk:OnAbilityExecuted(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self.parent then
		return
	end
	if not keys.ability:IsItem() then
		return
	end
	self:Destroy()
end
function modifier_imba_skeleton_walk:GetModifierInvisibilityLevel() return 1 end
function modifier_imba_skeleton_walk:OnDestroy()
	if IsServer() then
		local ability = self.caster:FindAbilityByName("imba_clinkz_burning_army")
		if ability and ability:IsTrained() and self.caster:Has_Aghanims_Shard() then
			ability.duration = self.shard
			ability:OnSpellStart(true)
			ability.duration = nil
		end
	end
end

modifier_imba_skeleton_walk_extra = class({})

function modifier_imba_skeleton_walk_extra:IsDebuff()			return false end
function modifier_imba_skeleton_walk_extra:IsHidden() 			return true end
function modifier_imba_skeleton_walk_extra:IsPurgable() 		return false end
function modifier_imba_skeleton_walk_extra:IsPurgeException() 	return false end
function modifier_imba_skeleton_walk_extra:RemoveOnDeath() 		return self:GetCaster():IsIllusion() end
function modifier_imba_skeleton_walk_extra:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
			MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
			MODIFIER_EVENT_ON_RESPAWN,
			MODIFIER_EVENT_ON_DEATH,
			}
end
function modifier_imba_skeleton_walk_extra:OnCreated(keys)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	if IsServer() then
		self.int = true
	end
end
function modifier_imba_skeleton_walk_extra:GetModifierIncomingDamage_Percentage(keys)
	if not keys.attacker:IsAlive() or (keys.inflictor and not keys.inflictor:GetCaster():IsAlive()) then
  		return -100
  	end
  	return 0
end
function modifier_imba_skeleton_walk_extra:GetModifierPreAttack_CriticalStrike(keys)
    if not IsServer() or self:GetParent():IsIllusion() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or not (keys.target:IsHero() or keys.target:IsCreep() or keys.target:IsBoss()) then
		return
	end
	if not self:GetParent():IsAlive() and self.int then
		self.int = false
  		return self.bonus_damage
  	end
end
function modifier_imba_skeleton_walk_extra:OnDeath(keys)
	if not IsServer() then
		return
    end
    if keys.unit == self.parent then
		self.info =
		{
			Target = keys.attacker or keys.ability:GetCaster(),
			Source = self.parent,
			Ability = self.ability,
			EffectName = "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf",
			iMoveSpeed = self.caster:GetProjectileSpeed(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = true,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 10,
			bProvidesVision = false,
			ExtraData = {},
		}
		ProjectileManager:CreateTrackingProjectile(self.info)
    end
end
function imba_clinkz_wind_walk:OnProjectileHit_ExtraData(target, pos, keys)
	if target then
		self:GetCaster():PerformAttack(target, true, true, true, false, false, false, true)
		return
	end
end
function modifier_imba_skeleton_walk_extra:OnRespawn( keys )
	if not IsServer() then return end
	if keys.unit == self:GetParent() then
		self.int = true
	end
end

imba_clinkz_death_pact = class({})

LinkLuaModifier("modifier_imba_death_pact_caster", "linken/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_passive", "linken/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_vision", "linken/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_str", "linken/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_agi", "linken/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_int", "linken/hero_clinkz", LUA_MODIFIER_MOTION_NONE)


function imba_clinkz_death_pact:GetIntrinsicModifierName() return "modifier_imba_death_pact_passive" end
function imba_clinkz_death_pact:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Clinkz.BurningArmy.SpellStart")
	return true
end
function imba_clinkz_death_pact:CastFilterResultTarget(target)
    if (not target:IsCreep() and not target:IsHero()) or target:IsAncient() then
        return UF_FAIL_CUSTOM
    else
        return UF_SUCCESS
    end
end

function imba_clinkz_death_pact:GetCustomCastErrorTarget(target)
    if (not target:IsCreep() and not target:IsHero()) or target:IsAncient() then
        return "dota_hud_error_cant_cast_on_other"
    end
end
function imba_clinkz_death_pact:OnSpellStart()
	self.caster = self:GetCaster()
	local caster = self.caster
	local target = self:GetCursorTarget()
	local hero_pct = self:GetSpecialValueFor("hero_pct")
	local max = self:GetSpecialValueFor("max")
	if target:TriggerStandardTargetSpell(self) then
		return
	end
	print(target:GetName() ~= "npc_dota_hero_clinkz")
	target:EmitSound("Hero_Clinkz.BurningArmy.Cast")
	local duration = self:GetSpecialValueFor("duration")
	if target:IsHero() and caster ~= target then
		local damageTable = {
							victim = target,
							attacker = caster,
							damage = (hero_pct / 100 * target:GetHealth()),
							damage_type = self:GetAbilityDamageType(),
							ability = self,
							}
		ApplyDamage(damageTable)
		caster:Heal((hero_pct / 100 * target:GetHealth()), caster)
		local int = #caster:FindAllModifiersByName("modifier_imba_death_pact_str") + #caster:FindAllModifiersByName("modifier_imba_death_pact_agi") + #caster:FindAllModifiersByName("modifier_imba_death_pact_int")
		if int < max then
			if target:GetPrimaryAttribute() == 0 then
		  		caster:AddNewModifier(target, self, "modifier_imba_death_pact_str", {})
		  	elseif 	target:GetPrimaryAttribute() == 1 then
		  		caster:AddNewModifier(target, self, "modifier_imba_death_pact_agi", {})
		  	elseif	target:GetPrimaryAttribute() == 2 then
		  		caster:AddNewModifier(target, self, "modifier_imba_death_pact_int", {})
		  	end
		end
		caster:AddNewModifier(target, self, "modifier_imba_death_pact_caster", {duration = duration})
	elseif caster == target then
		TG_Remove_AllModifier(caster,"modifier_imba_death_pact_str")
		TG_Remove_AllModifier(caster,"modifier_imba_death_pact_agi")
		TG_Remove_AllModifier(caster,"modifier_imba_death_pact_int")
		self:EndCooldown()
	elseif not target:IsHero() then
		caster:Heal(target:GetHealth(), caster)
		caster:AddNewModifier(target, self, "modifier_imba_death_pact_caster", {duration = duration})
		target:Kill(self, caster)
	end

	local death_pact_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_death_pact.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(death_pact_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(death_pact_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(death_pact_pfx)
	if caster:TG_HasTalent("special_bonus_imba_clinkz_3") and IsEnemy(caster,target) then
		local duration_vision = caster:TG_GetTalentValue("special_bonus_imba_clinkz_3")
		target:AddNewModifier(caster, self, "modifier_imba_death_pact_vision", {duration = duration_vision})
	end

end

modifier_imba_death_pact_vision = class({})

function modifier_imba_death_pact_vision:IsDebuff()			return true end
function modifier_imba_death_pact_vision:IsHidden() 			return false end
function modifier_imba_death_pact_vision:IsPurgable() 		return false end
function modifier_imba_death_pact_vision:IsPurgeException() 	return false end
function modifier_imba_death_pact_vision:CheckState()
	return {[MODIFIER_STATE_INVISIBLE] = false }
end
function modifier_imba_death_pact_vision:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_death_pact_vision:GetModifierProvidesFOWVision()
	return 1
end
function modifier_imba_death_pact_vision:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
   	}
end

modifier_imba_death_pact_caster = class({})
function modifier_imba_death_pact_caster:IsDebuff()				return false end
function modifier_imba_death_pact_caster:IsHidden() 			return false end
function modifier_imba_death_pact_caster:IsPurgable() 			return false end
function modifier_imba_death_pact_caster:IsPurgeException() 	return false end
function modifier_imba_death_pact_caster:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_HEALTH_BONUS,
			}
end
function modifier_imba_death_pact_caster:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.hp = self.ability:GetSpecialValueFor("health_gain_pct")
	self.att = self.ability:GetSpecialValueFor("damage_gain_pct")
	self.hero_pct = self.ability:GetSpecialValueFor("hero_pct")
	self.int_hp = 0
	self.int_att = 0

	if IsServer() then
		if self.caster:IsHero() then
			self.int_hp = self.hp / 100 * self.hero_pct / 100 * self.caster:GetHealth()
			self.int_att = self.att / 100 * self.hero_pct / 100 * self.caster:GetHealth()
			self:SetStackCount(self.int_att)
		else
			self.int_hp = self.hp / 100 * self.caster:GetHealth()
			self.int_att = self.att / 100 * self.caster:GetHealth()
			self:SetStackCount(self.int_att)
		end
		self.parent:CalculateStatBonus(true)
	end
end

function modifier_imba_death_pact_caster:OnRefresh()
	self:OnCreated()
end
function modifier_imba_death_pact_caster:GetModifierHealthBonus()
	return self:GetStackCount()*10
end
function modifier_imba_death_pact_caster:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end
modifier_imba_death_pact_passive = class({})

function modifier_imba_death_pact_passive:IsDebuff()			return false end
function modifier_imba_death_pact_passive:IsHidden() 			return true end
function modifier_imba_death_pact_passive:IsPurgable() 			return false end
function modifier_imba_death_pact_passive:IsPurgeException() 	return false end
function modifier_imba_death_pact_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		}
end
function modifier_imba_death_pact_passive:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.per_damage = self.ability:GetSpecialValueFor("per_damage")
end
function modifier_imba_death_pact_passive:GetModifierTotalDamageOutgoing_Percentage(keys)
	local modifier_strength = #self:GetParent():FindAllModifiersByName("modifier_imba_death_pact_str")
	local modifier_agility = #self:GetParent():FindAllModifiersByName("modifier_imba_death_pact_agi")
	local modifier_intelligence = #self:GetParent():FindAllModifiersByName("modifier_imba_death_pact_int")
	if keys.target:IsHero() then
		if keys.target:GetPrimaryAttribute() == 0 then
	  		return modifier_strength * self.per_damage
	  	elseif 	keys.target:GetPrimaryAttribute() == 1 then
	  		return modifier_agility * self.per_damage
	  	elseif	keys.target:GetPrimaryAttribute() == 2 then
	  		return modifier_intelligence * self.per_damage
	  	end
	end
  	return 0
end
modifier_imba_death_pact_str = class({})
modifier_imba_death_pact_agi = class({})
modifier_imba_death_pact_int = class({})

function modifier_imba_death_pact_str:IsDebuff()			return false end
function modifier_imba_death_pact_agi:IsDebuff()			return false end
function modifier_imba_death_pact_int:IsDebuff()			return false end

function modifier_imba_death_pact_str:IsHidden() 			return false end
function modifier_imba_death_pact_agi:IsHidden() 			return false end
function modifier_imba_death_pact_int:IsHidden() 			return false end

function modifier_imba_death_pact_str:IsPurgable() 			return false end
function modifier_imba_death_pact_agi:IsPurgable() 			return false end
function modifier_imba_death_pact_int:IsPurgable() 			return false end

function modifier_imba_death_pact_str:IsPurgeException() 	return false end
function modifier_imba_death_pact_agi:IsPurgeException() 	return false end
function modifier_imba_death_pact_int:IsPurgeException() 	return false end

function modifier_imba_death_pact_str:GetTexture() return self:GetCaster():GetName()	end
function modifier_imba_death_pact_agi:GetTexture() return self:GetCaster():GetName() 	end
function modifier_imba_death_pact_int:GetTexture() return self:GetCaster():GetName()	end

function modifier_imba_death_pact_str:RemoveOnDeath() return self:GetParent():GetName() ~= "npc_dota_hero_clinkz" 	end
function modifier_imba_death_pact_agi:RemoveOnDeath() return self:GetParent():GetName() ~= "npc_dota_hero_clinkz" 	end
function modifier_imba_death_pact_int:RemoveOnDeath() return self:GetParent():GetName() ~= "npc_dota_hero_clinkz"	end

function modifier_imba_death_pact_str:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_death_pact_agi:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_death_pact_int:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end