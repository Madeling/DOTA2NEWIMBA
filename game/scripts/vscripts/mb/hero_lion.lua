-- Author: MouJiaoZi 01/08/2018
-- Arrangement: MysticBug 01/13/2021

--------------------------------------------------------------
--		   		   IMBA_LION_EARTH_SPIKE     	            --
--------------------------------------------------------------
CreateTalents("npc_dota_hero_lion", "mb/hero_lion")
imba_lion_earth_spike = class({})

LinkLuaModifier("modifier_earth_spike_motion", "mb/hero_lion", LUA_MODIFIER_MOTION_NONE)

function imba_lion_earth_spike:IsHiddenWhenStolen() 	return false end
function imba_lion_earth_spike:IsRefreshable() 			return true end
function imba_lion_earth_spike:IsStealable() 			return true end
function imba_lion_earth_spike:IsNetherWardStealable()	return true end
function imba_lion_earth_spike:GetAbilityTextureName()	return "lion/ti9_immortal_head/lion_impale_immortal" end
function imba_lion_earth_spike:GetCooldown( iLevel )
	return self.BaseClass.GetCooldown( self, iLevel ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_lion_2")
end
function imba_lion_earth_spike:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local pos = target and target:GetAbsOrigin() or self:GetCursorPosition()
	local start_pos = caster:GetAbsOrigin()
	local direction = (pos - start_pos):Normalized()
	direction.z = 0.0
	local end_pos = start_pos + direction * (self:GetCastRange(pos, caster) + caster:GetCastRangeBonus() + caster:TG_GetTalentValue("special_bonus_imba_lion_1"))
	local marker = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 20.0}, start_pos, caster:GetTeamNumber(), false):entindex()
	local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 20.0}, start_pos, caster:GetTeamNumber(), false):entindex()
	EntIndexToHScript(sound):EmitSound("Hero_Lion.Impale")
	local project_effect = "particles/units/heroes/hero_lion/lion_spell_impale.vpcf"
	project_effect = "particles/econ/items/lion/lion_ti9/lion_spell_impale_ti9.vpcf"
	local info = 
	{
		Ability = self,
		EffectName = project_effect,
		vSpawnOrigin = start_pos,
		fDistance = (start_pos - end_pos):Length2D(),
		fStartRadius = self:GetSpecialValueFor("spikes_radius"),
		fEndRadius = self:GetSpecialValueFor("spikes_radius"),
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = true,
		vVelocity = direction * self:GetSpecialValueFor("spike_speed"),
		bProvidesVision = false,
		ExtraData = {marker = marker, sound = sound}
	}
	ProjectileManager:CreateLinearProjectile(info)
end

function imba_lion_earth_spike:OnProjectileThink_ExtraData(location, keys) EntIndexToHScript(keys.sound):SetOrigin(location) end

function imba_lion_earth_spike:OnProjectileHit_ExtraData(target, location, keys)
	local caster = self:GetCaster()
	local marker = EntIndexToHScript(keys.marker)
	local marker_ent = marker:entindex()
	if not marker.hitted then
		marker.hitted = {}
	end

	if target then
		for _, hit in pairs(marker.hitted) do
			if hit == target then
				return false
			end
		end
		if target:HasModifier("modifier_imba_soul_chain") and keys.extra == 1 then
			--
		elseif target:TriggerStandardTargetSpell(self) then
			return
		end
		target:EmitSound("Hero_Lion.ImpaleHitTarget")
		target:AddNewModifier(caster, self, "modifier_earth_spike_motion", {duration = self:GetSpecialValueFor("knock_up_time")})
		marker.hitted[#marker.hitted+1] = target
		target:AddNewModifier_RS(caster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
		local pfx = ParticleManager:CreateParticle("particles/econ/items/lion/lion_ti9/lion_spell_impale_hit_ti9_spikes.vpcf", PATTACH_CUSTOMORIGIN, nil)
		for i=0, 2 do
			ParticleManager:SetParticleControl(pfx, i, GetGroundPosition(target:GetAbsOrigin(), nil))
		end
		local spike_damage = self:GetSpecialValueFor("damage") + caster:TG_GetTalentValue("special_bonus_imba_lion_3")
		local damageTable = {
							victim = target,
							attacker = caster,
							damage = spike_damage,
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}
		ApplyDamage(damageTable)
		ParticleManager:ReleaseParticleIndex(pfx)
		local delay = self:GetSpecialValueFor("wait_interval")
		Timers:CreateTimer(delay, function()
			local spike = true
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, self:GetSpecialValueFor("extra_spike_AOE") + caster:TG_GetTalentValue("special_bonus_imba_lion_1"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			for _, enemy in pairs(enemies) do
				local hitted = false
				for _, hit in pairs(marker.hitted) do
					if hit == enemy then
						hitted = true
					end
				end
				if not hitted and spike then
					spike = false
					local start_pos = target:GetAbsOrigin()
					local direction = (enemy:GetAbsOrigin() - start_pos):Normalized()
					direction.z = 0.0
					local end_pos = start_pos + direction * (self:GetCastRange(location, caster) + caster:GetCastRangeBonus() + caster:TG_GetTalentValue("special_bonus_imba_lion_1"))
					local info = 
					{
						Ability = self,
						EffectName = "particles/econ/items/lion/lion_ti9/lion_spell_impale_ti9.vpcf",
						vSpawnOrigin = target:GetAbsOrigin(),
						fDistance = (start_pos - end_pos):Length2D(),
						fStartRadius = self:GetSpecialValueFor("spikes_radius"),
						fEndRadius = self:GetSpecialValueFor("spikes_radius"),
						Source = caster,
						bHasFrontalCone = false,
						bReplaceExisting = false,
						iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
						iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						fExpireTime = GameRules:GetGameTime() + 10.0,
						bDeleteOnHit = true,
						vVelocity = (end_pos - start_pos):Normalized() * self:GetSpecialValueFor("spike_speed"),
						bProvidesVision = false,
						ExtraData = {marker = marker_ent, sound = keys.sound, extra = 1}
					}
					ProjectileManager:CreateLinearProjectile(info)
				end
			end
		return nil
		end
		)
	end
end

modifier_earth_spike_motion = class({})

function modifier_earth_spike_motion:IsDebuff()				return true end
function modifier_earth_spike_motion:IsHidden() 			return true end
function modifier_earth_spike_motion:IsPurgable() 			return false end
function modifier_earth_spike_motion:IsPurgeException() 	return true end
function modifier_earth_spike_motion:IsStunDebuff() 		return true end
function modifier_earth_spike_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_earth_spike_motion:GetModifierMoveSpeed_Absolute() return 1 end
function modifier_earth_spike_motion:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_earth_spike_motion:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true} end
function modifier_earth_spike_motion:IsMotionController() return true end
function modifier_earth_spike_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_earth_spike_motion:OnCreated()
	if IsServer() then
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			if self:GetParent():GetName() ~= "npc_dota_thinker" then
				self:Destroy()
			end
		end
	end
end

function modifier_earth_spike_motion:OnIntervalThink()
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local height = self:GetAbility():GetSpecialValueFor("knock_up_height")
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)
end

function modifier_earth_spike_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		if self:GetParent():GetName() ~= "npc_dota_thinker" then
			self:GetParent():EmitSound("Hero_Lion.ImpaleTargetLand")
		end
		if self.hitted then
			self.hitted = nil
		end
	end
end
--------------------------------------------------------------
--		   	   			IMBA_LION_HEX       	            --
--------------------------------------------------------------
imba_lion_hex = class({})

LinkLuaModifier("modifier_imba_lion_hex", "mb/hero_lion", LUA_MODIFIER_MOTION_NONE)

function imba_lion_hex:IsHiddenWhenStolen() 	return false end
function imba_lion_hex:IsRefreshable() 			return true end
function imba_lion_hex:IsStealable() 			return true end
function imba_lion_hex:IsNetherWardStealable()	return true end
function imba_lion_hex:GetAbilityTextureName()	return "lion_voodoo_fish" end
function imba_lion_hex:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/lion/fish_stick/fish_stick_splash.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context )
end
function imba_lion_hex:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerStandardTargetSpell(self) then
		return
	end
	if target:IsIllusion() then
		target:Kill(self, caster)
		return
	end
	--EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Lion.Voodoo", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Lion.Hex.Fishstick", caster)
	target:AddNewModifier_RS(caster, self, "modifier_imba_lion_hex", {duration = self:GetSpecialValueFor("duration")})
end

modifier_imba_lion_hex = class({})

function modifier_imba_lion_hex:IsDebuff()			return true end
function modifier_imba_lion_hex:IsHidden() 			return false end
function modifier_imba_lion_hex:IsPurgable() 		return false end
function modifier_imba_lion_hex:IsPurgeException() 	return false end
function modifier_imba_lion_hex:CheckState() return {[MODIFIER_STATE_SILENCED] = true, [MODIFIER_STATE_MUTED] = true, [MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_HEXED] = true} end
function modifier_imba_lion_hex:DeclareFunctions() return {MODIFIER_PROPERTY_MODEL_CHANGE, MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_PROPERTY_MOVESPEED_LIMIT, MODIFIER_PROPERTY_MOVESPEED_MAX} end
--function modifier_imba_lion_hex:GetModifierModelChange() return "models/props_gameplay/frog.vmdl" end
function modifier_imba_lion_hex:GetModifierModelChange() return "models/items/hex/fish_hex/fish_hex.vmdl" end
function modifier_imba_lion_hex:GetModifierMoveSpeed_Absolute() return 100 end
function modifier_imba_lion_hex:GetModifierMoveSpeed_Limit() return 100 end
function modifier_imba_lion_hex:GetModifierMoveSpeed_Max() return 100 end

function modifier_imba_lion_hex:OnCreated()
	if IsServer() then
		--particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf
		local pfx = ParticleManager:CreateParticle("particles/econ/items/lion/fish_stick/fish_stick_spell_fish.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(pfx)
		--self:GetParent():EmitSound("Hero_Lion.Hex.Target")
		self:GetParent():EmitSound("Hero_Lion.Fishstick.Target")
		local interval = self:GetAbility():GetSpecialValueFor("bounce_duration")
		self:StartIntervalThink(interval)
	end
end

function modifier_imba_lion_hex:OnIntervalThink()
	self:StartIntervalThink(-1)
	local target_num = self:GetCaster():HasScepter() and self:GetAbility():GetSpecialValueFor("target_scepter") or 1
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("hex_bounce_radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_lion_6"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local tars = 0
	for _, enemy in pairs(enemies) do
		if enemy ~= self:GetParent() and not enemy:IsHexed() then
			enemy:AddNewModifier_RS(self:GetCaster(), self:GetAbility(), "modifier_imba_lion_hex", {duration = self:GetAbility():GetSpecialValueFor("duration")})
			tars = tars + 1
			if tars == target_num then
				break
			end
		end
	end
end

--------------------------------------------------------------
--		   	        IMBA_LION_MANA_DRAIN                    --
--------------------------------------------------------------
imba_lion_mana_drain = class({})

LinkLuaModifier("modifier_imba_mana_drain_aura_effect", "mb/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mana_drain_hero_effect", "mb/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mana_drain_thinker", "mb/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mana_drain_immune", "mb/hero_lion", LUA_MODIFIER_MOTION_NONE)

function imba_lion_mana_drain:IsHiddenWhenStolen() 		return false end
function imba_lion_mana_drain:IsRefreshable() 			return true end
function imba_lion_mana_drain:IsStealable() 			return true end
function imba_lion_mana_drain:IsNetherWardStealable()	return true end
function imba_lion_mana_drain:GetChannelTime() 			return self:GetSpecialValueFor("max_channel_time") end
function imba_lion_mana_drain:GetIntrinsicModifierName() return "modifier_imba_mana_drain_aura_effect" end
function imba_lion_mana_drain:GetAbilityTextureName()	return "lion/demon_drain/lion_mana_drain" end
function imba_lion_mana_drain:CastFilterResultTarget(target)
	if target:IsInvulnerable() then
		return UF_FAIL_INVULNERABLE
	end
	if target == self:GetCaster() or 
		not target:IsHero() or 
		target:IsOther() or 
		target:IsCourier() then 
		return UF_FAIL_CUSTOM
	end
	--scepter can caster for allies
	local nResult = UnitFilter(
			target,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
			self:GetCaster():GetTeamNumber()
		)

		if self:GetCaster():TG_HasTalent("special_bonus_imba_lion_5") then
			nResult = UnitFilter(
					target,
					DOTA_UNIT_TARGET_TEAM_BOTH,
					DOTA_UNIT_TARGET_HERO,
					DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
					self:GetCaster():GetTeamNumber()
					) 
		end

		if nResult ~= UF_SUCCESS then
			return nResult
		end
		return UF_SUCCESS
end

function imba_lion_mana_drain:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	else
		return "#dota_hud_error_cant_cast_on_other"
	end
end
function imba_lion_mana_drain:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerStandardTargetSpell(self) then
		return
	end
	if target:IsIllusion() then
		target:Kill(self, caster)
		return
	end
	self.drain_table = {}
	--mana_to_drain
	target:AddNewModifier(caster, self, "modifier_imba_mana_drain_thinker", {target = target:entindex(), duration = self:GetSpecialValueFor("max_channel_time")})
	table.insert(self.drain_table,target:entindex())
	--Talent 
	if caster:Has_Aghanims_Shard() then 
		local multi_target = self:GetSpecialValueFor("shard_count")
		local enemies = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				caster:GetAbsOrigin(), 
				nil, 
				self:GetCastRange(caster:GetAbsOrigin(),target) + caster:GetCastRangeBonus(), 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO, 
				DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, --只寻找在视野范围内的
				FIND_ANY_ORDER, 
				false)
		if #enemies then 
			for i=1, #enemies do
				if enemies[i] ~= target then
					enemies[i]:AddNewModifier(caster, self, "modifier_imba_mana_drain_thinker", {target = target:entindex(), duration = self:GetSpecialValueFor("max_channel_time")})
					table.insert(self.drain_table,enemies[i]:entindex())
					if i == multi_target then
						break 
					end
				end
			end
		end
		--自己获得技能免疫效果
		caster:AddNewModifier(caster, self, "modifier_imba_mana_drain_immune", {duration = self:GetSpecialValueFor("max_channel_time")})
	end
end

function imba_lion_mana_drain:OnChannelFinish(bInterrupted)
	for _, unit in pairs(self.drain_table) do
		if EntIndexToHScript(unit):HasModifier("modifier_imba_mana_drain_thinker") then
			EntIndexToHScript(unit):FindModifierByNameAndCaster("modifier_imba_mana_drain_thinker",self:GetCaster()):Destroy()
		end
	end
	if self:GetCaster():HasModifier("modifier_imba_mana_drain_immune") then 
		self:GetCaster():RemoveModifierByName("modifier_imba_mana_drain_immune")
	end
end

modifier_imba_mana_drain_thinker = class({})

function modifier_imba_mana_drain_thinker:IsDebuff()			return true end
function modifier_imba_mana_drain_thinker:IsHidden() 			return true end
function modifier_imba_mana_drain_thinker:IsPurgable() 		return false end
function modifier_imba_mana_drain_thinker:IsPurgeException() 	return false end
function modifier_imba_mana_drain_thinker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_mana_drain_thinker:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_mana_drain_thinker:DeclareFunctions() 
	local funs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funs
end
function modifier_imba_mana_drain_thinker:GetModifierMoveSpeedBonus_Percentage() return IsEnemy(self:GetCaster(), self:GetParent()) and (0 - self.movement_slow) or 0 end
--function modifier_imba_mana_drain_thinker:GetModifierAttackSpeedBonus_Constant() return (0 - self.shard_sp) end
function modifier_imba_mana_drain_thinker:OnCreated(keys)
	self.movement_slow = 0 + self:GetCaster():TG_GetTalentValue("special_bonus_imba_lion_1")
	self.shard_sp = self:GetAbility():GetSpecialValueFor("shard_sp")
	if IsServer() then 
		self.target = EntIndexToHScript(keys.target)
		--Effect
		self.pfx = ParticleManager:CreateParticle("particles/econ/items/lion/lion_demon_drain/lion_spell_mana_drain_demon.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_mouth", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.pfx, 2, self:GetCaster():GetForwardVector())
		self.tick = 0
		self:GetParent():EmitSound("Hero_Lion.ManaDrain")
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
	end
end

function modifier_imba_mana_drain_thinker:OnIntervalThink()
	local distance = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()
	if distance > self:GetAbility():GetSpecialValueFor("break_distance") or self:GetParent():IsInvulnerable() or self:GetParent():IsMagicImmune() or not self:GetCaster():CanEntityBeSeenByMyTeam(self:GetParent()) then
		self:Destroy()
		return
	end
	-- 主目标没有被吸蓝也结束
	if self.target ~=nil and not self.target:HasModifier("modifier_imba_mana_drain_thinker") then 
		self:GetCaster():Interrupt()
		self:Destroy()
		return
	end
	local tick = self:GetAbility():GetSpecialValueFor("interval")
	self.tick = self.tick + 0.1
	if tick >= self.tick and tick <= self.tick + 0.1 then
		self.tick = 0
		local mana_drain_sec = self:GetAbility():GetSpecialValueFor("mana_drain_sec") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_lion_7")
		local mana_to_drain = mana_drain_sec / (1.0 / self:GetAbility():GetSpecialValueFor("interval"))
		local mana = self:GetParent():GetMana()
		mana_to_drain = mana < mana_to_drain and mana or mana_to_drain
		if mana_to_drain > 0 then
			local dmg = mana_to_drain * (self:GetAbility():GetSpecialValueFor("mana_pct_as_damage") / 100)
			local damageTable = {
								victim = self:GetParent(),
								attacker = self:GetCaster(),
								damage = dmg,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self:GetAbility(), --Optional.
								}
			local caster_mana = self:GetCaster():GetMana()
			--敌人吸蓝
			if IsEnemy(self:GetCaster(), self:GetParent()) then 
				--造成同等蓝伤害
				ApplyDamage(damageTable)
				if caster_mana < self:GetCaster():GetMaxMana() then
					self:GetParent():SetMana(self:GetParent():GetMana() - mana_to_drain)
					self:GetCaster():SetMana(caster_mana + mana_to_drain)
				else
					self:GetCaster():Heal(mana_to_drain, self)
				end
			--给队友回蓝
			else
				if caster_mana > 0 then --自己蓝大于0才能给队友回蓝
					self:GetParent():SetMana(self:GetParent():GetMana() + mana_to_drain)
					--self:GetParent():GiveMana(mana_to_drain)
					self:GetCaster():SetMana(caster_mana - mana_to_drain)
				elseif self:GetParent():GetMana() == self:GetParent():GetMaxMana() then 
					self:Destroy()
				else
					self:Destroy()
				end
			end
		elseif not self:GetParent():IsHero() then
			self:Destroy()
		end
	end
end

function modifier_imba_mana_drain_thinker:OnDestroy()
	self.movement_slow = nil
	self.shard_sp = nil
	if IsServer() then 
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
		self:GetParent():StopSound("Hero_Lion.ManaDrain")
		self.movement_slow = nil
		self.target = nil
	end
end

modifier_imba_mana_drain_aura_effect = class({})

function modifier_imba_mana_drain_aura_effect:IsDebuff()			return false end
function modifier_imba_mana_drain_aura_effect:IsHidden() 			return false end
function modifier_imba_mana_drain_aura_effect:IsPurgable() 			return false end
function modifier_imba_mana_drain_aura_effect:IsPurgeException() 	return false end
function modifier_imba_mana_drain_aura_effect:IsAura() return true end
function modifier_imba_mana_drain_aura_effect:GetAuraDuration() return 0.1 end
function modifier_imba_mana_drain_aura_effect:GetModifierAura() return "modifier_imba_mana_drain_hero_effect" end
function modifier_imba_mana_drain_aura_effect:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_imba_mana_drain_aura_effect:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_mana_drain_aura_effect:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_mana_drain_aura_effect:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_imba_mana_drain_hero_effect = class({})

function modifier_imba_mana_drain_hero_effect:IsDebuff()			return true end
function modifier_imba_mana_drain_hero_effect:IsHidden() 			return false end
function modifier_imba_mana_drain_hero_effect:IsPurgable() 			return false end
function modifier_imba_mana_drain_hero_effect:IsPurgeException() 	return false end

function modifier_imba_mana_drain_hero_effect:OnCreated()
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
	end
end

function modifier_imba_mana_drain_hero_effect:OnIntervalThink()
	local mana_to_drain = self:GetParent():GetMaxMana() * (self:GetAbility():GetSpecialValueFor("aura_max_mana_drain") / 100) / (1.0 / self:GetAbility():GetSpecialValueFor("interval"))
	mana_to_drain = mana_to_drain < self:GetParent():GetMana() and mana_to_drain or self:GetParent():GetMana()
	if mana_to_drain > 0 then
		self:GetParent():SetMana(self:GetParent():GetMana() - mana_to_drain)
		local caster_mana = self:GetCaster():GetMana()
		if caster_mana < self:GetCaster():GetMaxMana() then
			self:GetCaster():SetMana(caster_mana + mana_to_drain)
		else
			self:GetCaster():Heal(mana_to_drain, self)
		end
	end
end


modifier_imba_mana_drain_immune = class({})

function modifier_imba_mana_drain_immune:IsHidden() 	return true end
function modifier_imba_mana_drain_immune:IsPurgable() 		return false end
function modifier_imba_mana_drain_immune:IsPurgeException() return false end
function modifier_imba_mana_drain_immune:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_imba_mana_drain_immune:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_mana_drain_immune:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true,} end
--------------------------------------------------------------
--		   	      IMBA_LION_FINGER_OF_DEATH                 --
--------------------------------------------------------------

imba_lion_finger_of_death = class({})

LinkLuaModifier("modifier_imba_finger_of_death_kill", "mb/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_finger_of_death", "mb/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_finger_of_death_ti8", "mb/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_finger_of_death_grace_period", "mb/hero_lion", LUA_MODIFIER_MOTION_NONE)

function imba_lion_finger_of_death:IsHiddenWhenStolen() 	return false end
function imba_lion_finger_of_death:IsRefreshable() 			return true end
function imba_lion_finger_of_death:IsStealable() 			return true end
function imba_lion_finger_of_death:IsNetherWardStealable()	return true end
function imba_lion_finger_of_death:GetManaCost(i) return (1 + (self:GetSpecialValueFor("mana_increase_pct") / 100) * self:GetCaster():GetModifierStackCount("modifier_imba_finger_of_death_kill", self:GetCaster())) * self:GetSpecialValueFor("base_mana_cost") end
function imba_lion_finger_of_death:GetCooldown(i) return self:GetCaster():HasScepter() and self:GetSpecialValueFor("cooldown_scepter") or self:GetSpecialValueFor("cd") end
function imba_lion_finger_of_death:GetAOERadius() return self:GetCaster():HasScepter() and self:GetSpecialValueFor("radius_scepter") or 0 end
function imba_lion_finger_of_death:GetAbilityTextureName()	return "lion/finger_of_death/lion_finger_of_death_immortal" end
function imba_lion_finger_of_death:OnUpgrade()
	if IsServer() and not self:GetCaster():HasModifier("modifier_imba_finger_of_death") then
		self:GetCaster():AddNewModifierWhenPossible(self:GetCaster(), self, "modifier_imba_finger_of_death", {})
	end
end

function imba_lion_finger_of_death:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	--if HeroItems:UnitHasItem(caster, "lion_ti8") then
		local pfx = ParticleManager:CreateParticle("particles/econ/items/lion/lion_ti8/lion_spell_finger_of_death_charge_ti8.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
	--end
	return true
end

function imba_lion_finger_of_death:OnSpellStart()
	self.wait = false  --damage_stack
	local caster = self:GetCaster()
	local ability = self 
	caster:EmitSound("Hero_Lion.FingerOfDeath")
	local target = self:GetCursorTarget()
	if target:TriggerStandardTargetSpell(ability) then
		return
	end
	--Load Kv 
	local enemies = {}
	table.insert(enemies, target)
	local stack_damage = ability:GetSpecialValueFor("stack_damage")
	local damage_delay = ability:GetSpecialValueFor("damage_delay")
	local grace_period = ability:GetSpecialValueFor("grace_period")
	if not caster:HasModifier("modifier_imba_finger_of_death") then
		caster:AddNewModifier(caster, ability, "modifier_imba_finger_of_death", {})
	end
	local dmg = self:GetSpecialValueFor("damage") + caster:GetModifierStackCount("modifier_imba_finger_of_death", nil) * stack_damage
	if caster:HasScepter() then
		dmg = self:GetSpecialValueFor("damage_scepter") + caster:GetModifierStackCount("modifier_imba_finger_of_death", nil) * stack_damage
		local enemies2 = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_NIGHTMARED, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies2) do
			if (enemy:IsStunned() or enemy:IsHexed()) and enemy ~= target then
				enemies[#enemies+1] = enemy
			end
		end
	end
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = dmg,
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = ability, --Optional.
	}
	local damage_done = 0
	for _, enemy in pairs(enemies) do
		local direction = (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
		local pfx_name = "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf"
		--if HeroItems:UnitHasItem(caster, "lion_ti8") then
			pfx_name = "particles/econ/items/lion/lion_ti8/lion_spell_finger_ti8_lvl2.vpcf"
		--end
		--if HeroItems:UnitHasItem(self:GetCaster(), "rubick_arcana") then
		if self:GetCaster():GetName() == "npc_dota_hero_rubick" then 
			pfx_name = "particles/units/heroes/hero_rubick/rubick_finger_of_death.vpcf"
		end
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 2, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 4, enemy:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(pfx, 3, direction)
		--if HeroItems:UnitHasItem(caster, "lion_ti8") then
			local center = caster:GetAbsOrigin() + direction * ((enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() / 2)
			ParticleManager:SetParticleControl(pfx, 6, GetRandomPosition2D(center, ((enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() / 2)))
			ParticleManager:SetParticleControl(pfx, 10, GetRandomPosition2D(center, ((enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() / 2)))
			enemy:EmitSound("Hero_Lion.FingerOfDeath.TI8")
		--else
		--	enemy:EmitSound("Hero_Lion.FingerOfDeathImpact")
		--end
		ParticleManager:ReleaseParticleIndex(pfx)
		--debug 使用Timers 会导致ability table 丢失 神奇的BUG
		enemy:AddNewModifier(caster, ability, "modifier_imba_finger_of_death_grace_period", {duration = grace_period + damage_delay})
		--delay damage
		Timers:CreateTimer(damage_delay, function()
			damageTable.victim = enemy
			damage_done = ApplyDamage(damageTable) --for pfx 
			--if HeroItems:UnitHasItem(caster, "lion_ti8") then
				local pfx_head = ParticleManager:CreateParticle("particles/econ/items/lion/lion_ti8/lion_spell_finger_of_death_overhead_ti8.vpcf", PATTACH_ABSORIGIN, enemy)
				local hp_pct = 1 - (enemy:GetHealthPercent() / 100)
				ParticleManager:SetParticleControl(pfx_head, 1, Vector(hp_pct, 0, 0))
				ParticleManager:ReleaseParticleIndex(pfx_head)
			--end
			return nil
		end
		)
	end
end

function imba_lion_finger_of_death:KillCredit(target)
	if not self.wait and target:IsHero() then
		local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_finger_of_death_kill", {duration = self:GetSpecialValueFor("mana_add_duration")})
		if buff then
			buff:SetStackCount(buff:GetStackCount() + 1)
		end
		if self:GetCaster():GetName() ~= "npc_dota_hero_lion" then
			local damage_stack = self:GetCaster():GetModifierStackCount("modifier_imba_finger_of_death", nil)
			self:GetCaster():RemoveModifierByName("modifier_imba_finger_of_death")
			self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_imba_finger_of_death",{})
			self:GetCaster():SetModifierStackCount("modifier_imba_finger_of_death", nil, damage_stack + 1)
		else
			self:GetCaster():SetModifierStackCount("modifier_imba_finger_of_death", nil, self:GetCaster():GetModifierStackCount("modifier_imba_finger_of_death", nil) + 1)
		end	
		self:GetCaster():CalculateStatBonus(true)
		self.wait = true
		self:EndCooldown()
	end
end
--mana cost stack 
modifier_imba_finger_of_death_kill = class({})

function modifier_imba_finger_of_death_kill:IsDebuff()			return false end
function modifier_imba_finger_of_death_kill:IsHidden() 			return false end
function modifier_imba_finger_of_death_kill:IsPurgable() 		return false end
function modifier_imba_finger_of_death_kill:IsPurgeException() 	return false end
function modifier_imba_finger_of_death_kill:OnDestroy()
	if IsServer() and self:GetAbility() ~= nil then 
		self:GetAbility():UseResources(true, true, true)
	end
end

--grace_period
modifier_imba_finger_of_death_grace_period = class({})

function modifier_imba_finger_of_death_grace_period:IsDebuff()				return true end
function modifier_imba_finger_of_death_grace_period:IsHidden() 			return false end
function modifier_imba_finger_of_death_grace_period:IsPurgable() 			return false end
function modifier_imba_finger_of_death_grace_period:IsPurgeException() 	return false end
function modifier_imba_finger_of_death_grace_period:DeclareFunctions()
	local funcs = {MODIFIER_EVENT_ON_DEATH}
	return funcs
end
function modifier_imba_finger_of_death_grace_period:OnDeath(keys)
	if not IsServer() then
		return
	end
	if keys.unit == self:GetParent() and self:GetParent():IsRealHero() then
		--print("debug info ",self:GetAbility(),self:GetAbility():GetName(),keys.unit:GetName())
		self:GetAbility():KillCredit(keys.unit)
		local pfx_target = ParticleManager:CreateParticle("particles/econ/items/lion/lion_ti8/lion_spell_finger_death_arcana.vpcf", PATTACH_ABSORIGIN, keys.unit)
		ParticleManager:SetParticleControlEnt(pfx_target, 0, keys.unit, PATTACH_ABSORIGIN, nil, keys.unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx_target, 1, keys.unit, PATTACH_ABSORIGIN, nil, keys.unit:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx_target)
		--particles/econ/items/lion/lion_ti8/lion_spell_finger_of_death_overhead_ti8_counter.vpcf
		local kills = PlayerResource:GetKills(self:GetCaster():GetPlayerOwnerID())
		local pfx_counter = ParticleManager:CreateParticle("particles/econ/items/lion/lion_ti8/lion_spell_finger_of_death_overhead_ti8_counter.vpcf", PATTACH_ABSORIGIN, keys.unit)
		ParticleManager:SetParticleControlEnt(pfx_counter, 0, keys.unit, PATTACH_ABSORIGIN, nil, keys.unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl( pfx_counter, 11, Vector( 0, tostring(kills) or 1, 0) )
		ParticleManager:ReleaseParticleIndex(pfx_counter)
	end	
end

--damage stack 
modifier_imba_finger_of_death = class({})

function modifier_imba_finger_of_death:IsDebuff()			return false end
function modifier_imba_finger_of_death:IsHidden() 			return false end
function modifier_imba_finger_of_death:IsPurgable() 		return false end
function modifier_imba_finger_of_death:IsPurgeException() 	return false end
function modifier_imba_finger_of_death:RemoveOnDeath() return self:GetParent():IsIllusion() end
function modifier_imba_finger_of_death:DeclareFunctions() return {MODIFIER_PROPERTY_TOOLTIP,MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS} end
function modifier_imba_finger_of_death:OnTooltip() return self:GetStackCount() * self.damage_stack end
function modifier_imba_finger_of_death:GetModifierExtraHealthBonus() return self:GetParent():TG_HasTalent("special_bonus_imba_lion_4") and self:GetStackCount() * self.damage_stack or 0 end
function modifier_imba_finger_of_death:OnCreated()
	self.damage_stack = self:GetAbility() ~= nil and self:GetAbility():GetSpecialValueFor("stack_damage") or 20
	if not IsServer() then return end
	--and HeroItems:UnitHasItem(self:GetCaster(), "lion_ti8")
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_finger_of_death_ti8", {})
end

modifier_imba_finger_of_death_ti8 = class({})

function modifier_imba_finger_of_death_ti8:IsDebuff()			return false end
function modifier_imba_finger_of_death_ti8:IsHidden() 			return true end
function modifier_imba_finger_of_death_ti8:RemoveOnDeath() 		return self:GetParent():IsIllusion() end
function modifier_imba_finger_of_death_ti8:IsPurgable() 		return false end
function modifier_imba_finger_of_death_ti8:IsPurgeException() 	return false end
function modifier_imba_finger_of_death_ti8:DeclareFunctions() return {MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS} end
function modifier_imba_finger_of_death_ti8:GetActivityTranslationModifiers() return "ti8_immortal" end
