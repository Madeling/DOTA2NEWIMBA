-- 04 8 2020 by MysticBug---
----------------------------
----------------------------
---------------------------------
-- Death Prophet Carrion Swarm --
---------------------------------
CreateTalents("npc_dota_hero_death_prophet", "mb/hero_death_prophet")
imba_death_prophet_carrion_swarm = class({})

function imba_death_prophet_carrion_swarm:IsHiddenWhenStolen() 		return false end
function imba_death_prophet_carrion_swarm:IsRefreshable() 			return true  end
function imba_death_prophet_carrion_swarm:IsStealable() 			return true  end
function imba_death_prophet_carrion_swarm:IsNetherWardStealable()	return true  end
function imba_death_prophet_carrion_swarm:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_death_prophet/death_prophet_carrion_swarm.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context )
end
function imba_death_prophet_carrion_swarm:GetCooldown(nLevel)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_unique_death_prophet_2") then 
		return self.BaseClass.GetCooldown( self, nLevel)
	else
		return self.BaseClass.GetCooldown( self, nLevel) - caster:TG_GetTalentValue("special_bonus_imba_death_prophet_2")
	end
end
function imba_death_prophet_carrion_swarm:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0
	local distance = self:GetSpecialValueFor("range") + caster:GetCastRangeBonus()
	--particles/units/heroes/hero_death_prophet/death_prophet_carrion_swarm.vpcf
	--particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm.vpcf  immoral
	local pfx_name = "particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm.vpcf"
	local sound_name = "Hero_DeathProphet.CarrionSwarm.Particle"
	local sound_name_cast = "Hero_DeathProphet.CarrionSwarm"
	local info = 
	{
		Ability = self,
		EffectName = pfx_name,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = self:GetSpecialValueFor("start_radius"),
		fEndRadius = self:GetSpecialValueFor("end_radius"),
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = false,
		vVelocity = direction * self:GetSpecialValueFor("speed"),
		bProvidesVision = false,
		ExtraData = { swarm_split = 1,direction_x = direction.x, direction_y = direction.y}
	}
	ProjectileManager:CreateLinearProjectile(info)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_name_cast, caster)
end

function imba_death_prophet_carrion_swarm:OnProjectileHit_ExtraData(target, location, keys)
	--分裂开
	--0 not split
	--1 split 
	--2 spirit_swarm pro 
	if keys.swarm_split == 1 and not target then 
		-- KV
		local caster = self:GetCaster()
		local distance = self:GetSpecialValueFor("range") + caster:GetCastRangeBonus()
		local swarm_count = self:GetSpecialValueFor("swarm_count")
		local direction = Vector(keys.direction_x, keys.direction_y, 0)
		--particles/units/heroes/hero_death_prophet/death_prophet_carrion_swarm.vpcf
		--particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm.vpcf  immoral
		local pfx_name = "particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm.vpcf"
		local sound_name = "Hero_DeathProphet.CarrionSwarm.Particle"
		local sound_name_cast = "Hero_DeathProphet.CarrionSwarm"
		for i = 1, swarm_count do
			local swarm_split_direction = (RotatePosition(location, QAngle(0, (-1) * 100 / 2 + (i - 1) * 100 / (swarm_count - 1) , 0), location + direction * distance) - location):Normalized()
			local info = 
			{
				Ability = self,
				EffectName = pfx_name,
				vSpawnOrigin = location,
				fDistance = distance,
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
				vVelocity = swarm_split_direction * self:GetSpecialValueFor("speed"),
				bProvidesVision = false,
				ExtraData = { swarm_split = 2,direction_x = direction.x, direction_y = direction.y}
			}
			ProjectileManager:CreateLinearProjectile(info)
			EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_name_cast, caster)
		end	
	end
	--击中
	if target and target:IsAlive() then
		local swam_damage = self:GetAbilityDamage()
		if keys.swarm_split == 2 then 
			swam_damage = self:GetAbilityDamage() / 2
		end
		local done_damage = ApplyDamage(
						{
							victim 			= target,
							damage 			= swam_damage,
							damage_type		= self:GetAbilityDamageType(),
							damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
							attacker 		= self:GetCaster(),
							ability 		= self
						}
					)
		local swarm_heal_pct = self:GetSpecialValueFor("swarm_heal_pct")
		if self:GetCaster():HasModifier("modifier_imba_death_prophet_witchcraft") then 
			local witchcraft_abi = self:GetCaster():FindAbilityByName("imba_death_prophet_witchcraft")
			if witchcraft_abi then 
				swarm_heal_pct = swarm_heal_pct + witchcraft_abi:GetSpecialValueFor("swarm_heal_pct") * self:GetCaster():GetLevel()
			end
		end
		--print("healing Prophet!!! inflictor Name   Swarm",swarm_heal_pct , self:GetAbilityDamage() * swarm_heal_pct / 100 )
		--造成伤害的5% 治疗死亡先知
		self:GetCaster():Heal(done_damage * swarm_heal_pct / 100, self)
		--Hero_DeathProphet.CarrionSwarm.Damage
		EmitSoundOn("Hero_DeathProphet.CarrionSwarm.Damage", target )
	end
end

---------------------------------
--    Death Prophet Silence    --
---------------------------------
--魔法治疗 时间内目标受到法术伤害的10%将治疗死亡先知

imba_death_prophet_silence = class({})
LinkLuaModifier("modifier_imba_death_prophet_silence", "mb/hero_death_prophet", LUA_MODIFIER_MOTION_NONE)

function imba_death_prophet_silence:IsHiddenWhenStolen() 	return false end
function imba_death_prophet_silence:IsRefreshable() 		return true  end
function imba_death_prophet_silence:IsStealable() 			return true  end
function imba_death_prophet_silence:IsNetherWardStealable()	return true  end
function imba_death_prophet_silence:GetAOERadius() return self:GetSpecialValueFor("radius") end
function imba_death_prophet_silence:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_death_prophet/death_prophet_silence.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_death_prophet/death_prophet_silence_impact.vpcf", context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_silenced.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context )
end
function imba_death_prophet_silence:OnSpellStart()
	--音效
	self:GetCaster():EmitSound("Hero_DeathProphet.Silence")
	--特效
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_silence.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, self:GetCursorPosition())
	ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetSpecialValueFor("radius"), 0, 1))
	ParticleManager:ReleaseParticleIndex(pfx)
	--范围沉默
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCursorPosition(),
		nil,
		self:GetSpecialValueFor("radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)
	local spirit_siphon_abi = self:GetCaster():FindAbilityByName("imba_death_prophet_spirit_siphon")

	for _, enemy in pairs(enemies) do
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_silence_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(pfx, 0, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)

		enemy:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_death_prophet_silence", {duration = self:GetDuration()}):SetDuration(self:GetDuration() * (1 - enemy:GetStatusResistance()), true)
		--IMBA Add imba_death_prophet_spirit_siphon
		if spirit_siphon_abi and spirit_siphon_abi:GetLevel() > 0 and enemy:IsHero() then 
			self:GetCaster():AddNewModifier_RS(self:GetCaster(), spirit_siphon_abi, "modifier_imba_death_prophet_spirit_siphon", {target = enemy:entindex(), duration = self:GetDuration() / 2})
		end
	end
end

modifier_imba_death_prophet_silence = class({})

function modifier_imba_death_prophet_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_imba_death_prophet_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_death_prophet_silence:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
	}
end

function modifier_imba_death_prophet_silence:OnCreated()
	if IsClient() then return end
end

function modifier_imba_death_prophet_silence:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_imba_death_prophet_silence:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then
		return 
	end
	if keys.inflictor then
		--受到法术伤害的5% 治疗死亡先知
		local silence_heal_pct = self:GetAbility():GetSpecialValueFor("silence_heal_pct")
		if self:GetCaster():HasModifier("modifier_imba_death_prophet_witchcraft") then 
			local witchcraft_abi = self:GetCaster():FindAbilityByName("imba_death_prophet_witchcraft")
			if witchcraft_abi then 
				silence_heal_pct = silence_heal_pct + witchcraft_abi:GetSpecialValueFor("silence_heal_pct") * self:GetCaster():GetLevel()
			end
		end
		--print("healing Prophet!!! inflictor Name +++ ",keys.inflictor:GetName(),silence_heal_pct , keys.damage * silence_heal_pct / 100 )
		self:GetCaster():Heal(keys.damage * silence_heal_pct / 100, self:GetAbility())
	end
end

---------------------------------
-- Death Prophet Spirit Siphon --
---------------------------------

imba_death_prophet_spirit_siphon = class({})

LinkLuaModifier("modifier_imba_death_prophet_spirit_siphon", "mb/hero_death_prophet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_prophet_spirit_siphon_buff", "mb/hero_death_prophet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_prophet_spirit_siphon_debuff", "mb/hero_death_prophet", LUA_MODIFIER_MOTION_NONE)

function imba_death_prophet_spirit_siphon:IsHiddenWhenStolen() 	return false end
function imba_death_prophet_spirit_siphon:IsRefreshable() 			return true end
function imba_death_prophet_spirit_siphon:IsStealable() 			return true end
function imba_death_prophet_spirit_siphon:IsNetherWardStealable()	return true end

function imba_death_prophet_spirit_siphon:CastFilterResultTarget(target)
	if target == self:GetCaster() or target:IsBuilding() or target:IsOther() or target:IsCourier() then
		return UF_FAIL_CUSTOM
	end
	if IsServer() then
		local buffs = self:GetCaster():FindAllModifiersByName("modifier_imba_death_prophet_spirit_siphon")
		for _, buff in pairs(buffs) do
			if target:entindex() == buff:GetStackCount() then
				return UF_FAIL_CUSTOM
			end
		end

		local nResult = UnitFilter(
			target,
			DOTA_UNIT_TARGET_TEAM_BOTH,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			self:GetCaster():GetTeamNumber()
		) 

		if nResult ~= UF_SUCCESS then
			return nResult
		end
		return UF_SUCCESS
	end
end

function imba_death_prophet_spirit_siphon:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	else
		return "#dota_hud_error_cant_cast_on_other"
	end
end

function imba_death_prophet_spirit_siphon:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_death_prophet/death_prophet_spiritsiphon.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context )
end

--[[function imba_death_prophet_spirit_siphon:OnUpgrade()
	--充能设置
	if not AbilityChargeController:IsChargeTypeAbility(self) then
		AbilityChargeController:AbilityChargeInitialize(self, self:GetSpecialValueFor("charge_restore_time"), self:GetSpecialValueFor("max_charges"), 1, true, true)
	else
		AbilityChargeController:ChangeChargeAbilityConfig(self, self:GetSpecialValueFor("charge_restore_time"), self:GetSpecialValueFor("max_charges"), 1, true, true)
	end
end]]

function imba_death_prophet_spirit_siphon:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():GetCastRangeBonus()
end

function imba_death_prophet_spirit_siphon:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerStandardTargetSpell(self) then
		return
	end
	local target_ent = target:entindex()
	if IsEnemy(caster, target) then
		caster:AddNewModifier(caster, self, "modifier_imba_death_prophet_spirit_siphon", {target = target_ent, duration = self:GetSpecialValueFor("haunt_duration")})
	else
		--可以对友军释放，持续时间内 治疗队友和提高队友移速
		target_ent = caster:entindex()
		caster:AddNewModifier(target, self, "modifier_imba_death_prophet_spirit_siphon", {target = target_ent, ally = 1, duration = self:GetSpecialValueFor("haunt_duration")})
	end
	caster:EmitSound("Hero_DeathProphet.SpiritSiphon.Cast")
	target:EmitSound("Hero_DeathProphet.SpiritSiphon.Target")
	--target:EmitSound("Hero_DeathProphet.SpiritSiphon.Loop")
	if not caster:HasModifier("modifier_imba_death_prophet_spirit_siphon") then
		caster:EmitSound("Hero_DeathProphet.SpiritSiphon.Loop")
	end
end

modifier_imba_death_prophet_spirit_siphon = class({})

function modifier_imba_death_prophet_spirit_siphon:IsDebuff()			return false end
function modifier_imba_death_prophet_spirit_siphon:IsHidden() 			return true end
function modifier_imba_death_prophet_spirit_siphon:IsPurgable() 		return false end
function modifier_imba_death_prophet_spirit_siphon:IsPurgeException() 	return false end
function modifier_imba_death_prophet_spirit_siphon:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_death_prophet_spirit_siphon:OnCreated(keys)
	if IsServer() then
		--计时器
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("tick_rate"))
		self.target = EntIndexToHScript(keys.target)
		self.ally = keys.ally
		--特效
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_neck", self:GetCaster():GetAbsOrigin(), true)
		if self.ally then
			ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		end
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.pfx, 11, Vector(0,0,0))
		local ent = keys.target
		if self:GetCaster() ~= self:GetAbility():GetCaster() then
			ent = self:GetCaster():entindex()
		end
		self:SetStackCount(ent)
	end
end

function modifier_imba_death_prophet_spirit_siphon:OnIntervalThink()
	--print("Start Siphon ~~~",self:GetAbility():GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster()) , (self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D())
	local caster = self:GetCaster()
	local target = self.target
	local spirit_siphon_distance = self:GetAbility():GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster()) + self:GetAbility():GetSpecialValueFor("siphon_buffer")
	if (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > (spirit_siphon_distance) or not target:IsAlive() or target:IsOutOfGame() then
		--print("Siphon Stop ~~~")
		self:Destroy()
		return
	end

	local ability = self:GetAbility()
	local dmg = (ability:GetSpecialValueFor("damage") + ((ability:GetSpecialValueFor("damage_pct") + caster:TG_GetTalentValue("special_bonus_imba_death_prophet_3")) / 100) * target:GetMaxHealth() or 0) / (1.0 / ability:GetSpecialValueFor("tick_rate"))
	if self.ally then
		dmg = dmg / 2
	end
	local damageTable = {
						victim = target,
						attacker = caster,
						damage = dmg,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self:GetAbility(), --Optional.
						}
	local dmg_done = ApplyDamage(damageTable)
	if self.ally then
		dmg_done = dmg_done * 2
	end
	if caster:GetHealth() ~= caster:GetMaxHealth() then
		ParticleManager:SetParticleControl(self.pfx, 11, Vector(0,0,0))
		caster:Heal(dmg_done, ability)
	else
		ParticleManager:SetParticleControl(self.pfx, 11, Vector(1,0,0))
		caster:SetMana(math.min(caster:GetMaxMana(), caster:GetMana() + dmg_done))
	end
	--窃取移速或者护甲
	if not self.ally then 
		target:AddNewModifier(caster, self:GetAbility(), "modifier_imba_death_prophet_spirit_siphon_debuff", {duration = self:GetAbility():GetSpecialValueFor("steal_duration")})
		target:SetModifierStackCount("modifier_imba_death_prophet_spirit_siphon_debuff", nil, target:GetModifierStackCount("modifier_imba_death_prophet_spirit_siphon_debuff", nil) + self:GetAbility():GetSpecialValueFor("steal_armor"))
		--魔晶恐惧
		if self:GetCaster():Has_Aghanims_Shard() and math.mod(target:GetModifierStackCount("modifier_imba_death_prophet_spirit_siphon_debuff", nil), self:GetAbility():GetSpecialValueFor("fear_tick")) == 0 then
			target:AddNewModifier(caster, self, "modifier_nevermore_requiem_fear", {duration = self:GetAbility():GetSpecialValueFor("fear_duration")})
		end
	end	
	caster:AddNewModifier(caster, self:GetAbility(), "modifier_imba_death_prophet_spirit_siphon_buff", {duration = self:GetAbility():GetSpecialValueFor("steal_duration")})
	caster:SetModifierStackCount("modifier_imba_death_prophet_spirit_siphon_buff", nil, caster:GetModifierStackCount("modifier_imba_death_prophet_spirit_siphon_buff", nil) + self:GetAbility():GetSpecialValueFor("steal_armor"))
end

function modifier_imba_death_prophet_spirit_siphon:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
		self.target:RemoveModifierByName("modifier_death_prophet_spirit_siphon_slow")
		self.target = nil
		self.pfx = nil
		self:GetCaster():StopSound("Hero_DeathProphet.SpiritSiphon.Cast")
		self:GetParent():StopSound("Hero_DeathProphet.SpiritSiphon.Target")
		--self:GetParent():StopSound("Hero_DeathProphet.SpiritSiphon.Loop")
		if not self:GetCaster():HasModifier("modifier_imba_death_prophet_spirit_siphon") then
			--self:GetCaster():StopSound("Hero_DeathProphet.SpiritSiphon.Loop")
		end
	end
end

--Value Shard Abi 
modifier_imba_death_prophet_spirit_siphon_buff = class({})

function modifier_imba_death_prophet_spirit_siphon_buff:IsDebuff()			return false end
function modifier_imba_death_prophet_spirit_siphon_buff:IsHidden() 			return false end
function modifier_imba_death_prophet_spirit_siphon_buff:IsPurgable() 		return false end
function modifier_imba_death_prophet_spirit_siphon_buff:IsPurgeException() 	return false end
--function modifier_imba_death_prophet_spirit_siphon_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_death_prophet_spirit_siphon_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_death_prophet_spirit_siphon_buff:GetModifierMoveSpeedBonus_Constant() return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("movement_steal") end
function modifier_imba_death_prophet_spirit_siphon_buff:GetModifierPhysicalArmorBonus()
	if self:GetCaster():Has_Aghanims_Shard() then 
		return self:GetStackCount() * 1
	end

	return 0 
end

modifier_imba_death_prophet_spirit_siphon_debuff = class({})

function modifier_imba_death_prophet_spirit_siphon_debuff:IsDebuff()			return true end
function modifier_imba_death_prophet_spirit_siphon_debuff:IsHidden() 			return false end
function modifier_imba_death_prophet_spirit_siphon_debuff:IsPurgable() 			return false end
function modifier_imba_death_prophet_spirit_siphon_debuff:IsPurgeException() 	return false end
--function modifier_imba_death_prophet_spirit_siphon_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_death_prophet_spirit_siphon_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_death_prophet_spirit_siphon_debuff:GetModifierMoveSpeedBonus_Constant() return 0 - self:GetStackCount()*self:GetAbility():GetSpecialValueFor("movement_steal") end
function modifier_imba_death_prophet_spirit_siphon_debuff:GetModifierPhysicalArmorBonus()
	if self:GetCaster():Has_Aghanims_Shard() then 
		return 0 - self:GetStackCount() * 1
	end
	return 0 
end

---------------------------------
-- 	Death Prophet Witchcraft   --
---------------------------------
--被动提升死亡先知移速
--被动提升其他技能IMBA效果

imba_death_prophet_witchcraft = class({})
LinkLuaModifier("modifier_imba_death_prophet_witchcraft", "mb/hero_death_prophet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_prophet_witchcraft_scepter", "mb/hero_death_prophet", LUA_MODIFIER_MOTION_NONE)

function imba_death_prophet_witchcraft:IsTalentAbility() return true end
function imba_death_prophet_witchcraft:OnHeroLevelUp()
	if self:GetLevel() <= 0 then 
		self:SetLevel(1)
	end
end
function imba_death_prophet_witchcraft:GetIntrinsicModifierName() return "modifier_imba_death_prophet_witchcraft" end

modifier_imba_death_prophet_witchcraft = class({})
function modifier_imba_death_prophet_witchcraft:IsPurgable() 				return false end
function modifier_imba_death_prophet_witchcraft:IsPurgeException() 			return false end
function modifier_imba_death_prophet_witchcraft:IsHidden()					return true end
function modifier_imba_death_prophet_witchcraft:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,MODIFIER_EVENT_ON_TAKEDAMAGE}
	return funcs
end
function modifier_imba_death_prophet_witchcraft:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_movement_speed") * self:GetCaster():GetLevel()
end

function modifier_imba_death_prophet_witchcraft:GetModifierPercentageManacostStacking()
	return self:GetAbility():GetSpecialValueFor("mana_cost_adjust") * self:GetCaster():GetLevel()
end

function modifier_imba_death_prophet_witchcraft:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.inflictor then
		--只有DP自身技能可以触发
		if (keys.inflictor:GetAbilityName() == "imba_death_prophet_carrion_swarm") or (keys.inflictor:GetAbilityName() == "imba_death_prophet_silence") or (keys.inflictor:GetAbilityName() == "imba_death_prophet_spirit_siphon") then 
			--print("abi inflictor ---",keys.inflictor:GetAbilityName(),keys.unit:GetName())
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_death_prophet_witchcraft_scepter", {}) 
			self:GetParent():PerformAttack(keys.unit, false, true, true, true, false, false, false)
			self:GetParent():RemoveModifierByName("modifier_imba_death_prophet_witchcraft_scepter")
		end
	end
end

modifier_imba_death_prophet_witchcraft_scepter = class({})
function modifier_imba_death_prophet_witchcraft_scepter:IsDebuff()      return false end
function modifier_imba_death_prophet_witchcraft_scepter:IsHidden()      return true end
function modifier_imba_death_prophet_witchcraft_scepter:IsPurgable()    return false end
function modifier_imba_death_prophet_witchcraft_scepter:IsPurgeException()  return false end
function modifier_imba_death_prophet_witchcraft_scepter:DeclareFunctions() return  {MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE} end
function modifier_imba_death_prophet_witchcraft_scepter:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = true} end
function modifier_imba_death_prophet_witchcraft_scepter:GetModifierOverrideAttackDamage() return self:GetParent():GetLevel() * 10 end