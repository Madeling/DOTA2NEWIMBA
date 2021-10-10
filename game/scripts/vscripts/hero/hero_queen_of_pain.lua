

CreateTalents("npc_dota_hero_queenofpain", "hero/hero_queen_of_pain")
imba_queenofpain_shadow_strike = class({})

LinkLuaModifier("modifier_imba_shadow_strike_passive", "hero/hero_queen_of_pain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_strike_base_slow", "hero/hero_queen_of_pain", LUA_MODIFIER_MOTION_NONE)

function imba_queenofpain_shadow_strike:IsHiddenWhenStolen() 		return false end
function imba_queenofpain_shadow_strike:IsRefreshable() 			return true end
function imba_queenofpain_shadow_strike:IsStealable() 				return true end
function imba_queenofpain_shadow_strike:GetIntrinsicModifierName() return "modifier_imba_shadow_strike_passive" end

function imba_queenofpain_shadow_strike:OnSpellStart(bAttack)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local speed = bAttack and 3000 or self:GetSpecialValueFor("projectile_speed")
	local info =
	{
		Target = target,
		Source = caster,
		Ability = self,
		EffectName = "particles/units/heroes/hero_queenofpain/queen_shadow_strike.vpcf",
		iMoveSpeed = speed,
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)
	caster:EmitSound("Hero_QueenOfPain.ShadowStrike")
	--Talent special_bonus_imba_queenofpain_2
	if not bAttack and caster:TG_HasTalent("special_bonus_imba_queenofpain_2") then
		local radius = caster:TG_GetTalentValue("special_bonus_imba_queenofpain_2")
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, --只寻找在视野范围内的
			FIND_ANY_ORDER,
			false)
		for _, enemy in pairs(enemies) do
			if enemy:IsAlive() then
				caster:PerformAttack(enemy, false, true, true, false, true, false, false)
			end
		end
	end
end

function imba_queenofpain_shadow_strike:OnProjectileHit(target, location)
	if not target or target:IsMagicImmune() then
		return
	end
	if target:TriggerStandardTargetSpell(self) then
		return true
	end
	target:EmitSound("Hero_QueenOfPain.ShadowStrike.Target")
	target:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_shadow_strike_base_slow", {duration = self:GetSpecialValueFor("duration_tooltip")})
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_shadow_strike_body.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(pfx)
end

modifier_imba_shadow_strike_base_slow = class({})

function modifier_imba_shadow_strike_base_slow:IsDebuff()			return true end
function modifier_imba_shadow_strike_base_slow:IsHidden() 			return false end
function modifier_imba_shadow_strike_base_slow:IsPurgable() 		return true end
function modifier_imba_shadow_strike_base_slow:IsPurgeException() 	return true end
function modifier_imba_shadow_strike_base_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_shadow_strike_base_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_shadow_strike_base_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("movement_slow")) end

function modifier_imba_shadow_strike_base_slow:OnCreated()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_shadow_strike_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
		local damageTable = {
							victim = self:GetParent(),
							attacker = self:GetCaster(),
							damage = self:GetAbility():GetSpecialValueFor("strike_damage"),
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self:GetAbility(), --Optional.
							}
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), self:GetAbility():GetSpecialValueFor("strike_damage"), nil)
		self:StartIntervalThink(1.5)
	end
end

function modifier_imba_shadow_strike_base_slow:OnIntervalThink()
	local damageTable = {
						victim = self:GetParent(),
						attacker = self:GetCaster(),
						damage = self:GetAbility():GetSpecialValueFor("duration_damage"),
						damage_type = self:GetAbility():GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self:GetAbility(), --Optional.
						}
	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), self:GetAbility():GetSpecialValueFor("duration_damage"), nil)
end

function modifier_imba_shadow_strike_base_slow:OnRefresh() self:OnCreated() end

modifier_imba_shadow_strike_passive = class({})

function modifier_imba_shadow_strike_passive:IsDebuff()			return false end
function modifier_imba_shadow_strike_passive:IsHidden() 		return true end
function modifier_imba_shadow_strike_passive:IsPurgable() 		return false end
function modifier_imba_shadow_strike_passive:IsPurgeException() return false end
function modifier_imba_shadow_strike_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_shadow_strike_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsMagicImmune() or not IsEnemy(keys.target, keys.attacker) or keys.target:IsBuilding() or keys.target:IsOther() or keys.target:IsCourier() or not keys.target:IsAlive() then
		return
	end
	if not keys.target:HasModifier("modifier_imba_shadow_strike_base_slow") then
		self:GetParent():SetCursorCastTarget(keys.target)
		self:GetAbility():OnSpellStart(true)
	end
end


imba_queenofpain_blink = class({})

function imba_queenofpain_blink:IsHiddenWhenStolen() 		return false end
function imba_queenofpain_blink:IsRefreshable() 			return true end
function imba_queenofpain_blink:IsStealable() 				return true end
function imba_queenofpain_blink:GetCastRange()	if IsClient() then return self:GetSpecialValueFor("blink_range") end end

function imba_queenofpain_blink:OnInventoryContentsChanged()
    local caster=self:GetCaster()
    if caster:Has_Aghanims_Shard()  then
		AbilityChargeController:AbilityChargeInitialize(self, self:GetCooldown(self:GetLevel()),2, 1, true, true)
    end
end


function imba_queenofpain_blink:OnSpellStart()
	local caster = self:GetCaster()
	ProjectileManager:ProjectileDodge(caster)
	local pos = self:GetCursorPosition()
	pos = (caster:GetAbsOrigin() - pos):Length2D() <= self:GetSpecialValueFor("blink_range") and pos or (caster:GetAbsOrigin() + (pos - caster:GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("blink_range"))
	local pos0 = caster:GetAbsOrigin()
	local sound_name1 = "Hero_QueenOfPain.Blink_out"
	local sound_name2 = "Hero_QueenOfPain.Blink_in"
	local pfx_start_name = "particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf"
	local pfx_end_name = "particles/units/heroes/hero_queenofpain/queen_blink_end.vpcf"
	--[[if HeroItems:UnitHasItem(caster, "queenofpain_ti10arcana") then
		pfx_start_name = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_blink_start.vpcf"
		pfx_end_name = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_blink_end.vpcf"
		sound_name1 = "Hero_QueenOfPain.Blink_out.Arcana"
		sound_name2 = "Hero_QueenOfPain.Blink_in.Arcana"
	end
	if HeroItems:UnitHasCustomFemaleItem(caster) then
		pfx_start_name = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_blink_v2_start.vpcf"
		pfx_end_name = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_blink_v2_end.vpcf"
		sound_name1 = "Hero_QueenOfPain.Blink_out.Arcana"
		sound_name2 = "Hero_QueenOfPain.Blink_in.Arcana"
	end]]
	--音效
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_name, caster)
	local pfx_start = ParticleManager:CreateParticle(pfx_start_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_start, 0, pos0)
	ParticleManager:SetParticleControl(pfx_start, 1, pos)
	ParticleManager:ReleaseParticleIndex(pfx_start)
	FindClearSpaceForUnit(caster, pos, true)
	local pfx_end = ParticleManager:CreateParticle(pfx_end_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_end, 0, pos)
	ParticleManager:SetParticleControlForward(pfx_end, 0, (pos - pos0):Normalized())
	ParticleManager:ReleaseParticleIndex(pfx_end)
	EmitSoundOnLocationWithCaster(pos, sound_name2, caster)

	local ability = caster:FindAbilityByName("imba_queenofpain_scream_of_pain")
	if ability and ability:GetLevel() > 0 then
		local damage = self:GetSpecialValueFor("scream_damage")
		local duration = self:GetSpecialValueFor("nausea_duration")
		local thinker1 = CreateModifierThinker(caster, self, "modifier_imba_shadow_strike_passive", {duration = 0.5}, pos0, caster:GetTeamNumber(), false)
		ability:OnSpellStart(thinker1, damage, duration)
		--thinker1:EmitSound("Hero_QueenOfPain.ScreamOfPain") --太吵啦
		local thinker2 = CreateModifierThinker(caster, self, "modifier_imba_shadow_strike_passive", {duration = 0.5}, pos, caster:GetTeamNumber(), false)
		ability:OnSpellStart(thinker2, damage, duration)
		--thinker2:EmitSound("Hero_QueenOfPain.ScreamOfPain") --太吵啦
	end
end


imba_queenofpain_scream_of_pain = class({})

LinkLuaModifier("modifier_imba_confusion", "hero/hero_queen_of_pain", LUA_MODIFIER_MOTION_NONE)

function imba_queenofpain_scream_of_pain:IsHiddenWhenStolen() 		return false end
function imba_queenofpain_scream_of_pain:IsRefreshable() 			return true end
function imba_queenofpain_scream_of_pain:IsStealable() 				return true end
function imba_queenofpain_scream_of_pain:GetCastRange() return self:GetSpecialValueFor("area_of_effect") - self:GetCaster():GetCastRangeBonus() end

function imba_queenofpain_scream_of_pain:OnSpellStart(maintarget, damage, duration, nohitsource)
	local caster = self:GetCaster()
	local pfx_main = maintarget or caster
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", PATTACH_POINT, pfx_main)
	ParticleManager:SetParticleControlEnt(pfx, 0, pfx_main, PATTACH_ABSORIGIN, "attach_hitloc", pfx_main:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	if maintarget == nil then
		pfx_main:EmitSound("Hero_QueenOfPain.ScreamOfPain")
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pfx_main:GetAbsOrigin(), nil, self:GetSpecialValueFor("area_of_effect"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if nohitsource and maintarget ~= enemy then
			local info =
			{
				Target = enemy,
				Source = pfx_main,
				Ability = self,
				EffectName = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf",
				iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
				vSourceLoc = pfx_main:GetAbsOrigin(),
				bDrawsOnMinimap = false,
				bDodgeable = false,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 10,
				bProvidesVision = false,
				ExtraData = {damage = damage, duration = duration}
			}
			ProjectileManager:CreateTrackingProjectile(info)
		elseif not nohitsource then
			local info =
			{
				Target = enemy,
				Source = pfx_main,
				Ability = self,
				EffectName = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf",
				iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
				vSourceLoc = pfx_main:GetAbsOrigin(),
				bDrawsOnMinimap = false,
				bDodgeable = false,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 10,
				bProvidesVision = false,
				ExtraData = {damage = damage, duration = duration}
			}
			ProjectileManager:CreateTrackingProjectile(info)
		end
	end
end

function imba_queenofpain_scream_of_pain:OnProjectileHit_ExtraData(target, location, keys)
	if not target or target:IsMagicImmune() then
		return
	end
	local caster = self:GetCaster()
	local damage = keys.damage or self:GetSpecialValueFor("damage")
	local duration = keys.duration or self:GetSpecialValueFor("nausea_duration")
	local damageTable = {
						victim = target,
						attacker = caster,
						damage = damage,
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self, --Optional.
						}
	ApplyDamage(damageTable)
	target:AddNewModifier(caster, self, "modifier_imba_confusion", {duration = duration})
end

modifier_imba_confusion = class({})

function modifier_imba_confusion:IsDebuff()			return true end
function modifier_imba_confusion:IsHidden() 		return false end
function modifier_imba_confusion:IsPurgable() 		return true end
function modifier_imba_confusion:IsPurgeException() return true end
function modifier_imba_confusion:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_START, MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end

function modifier_imba_confusion:OnAttackStart(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() then
		local dmg = self:GetAbility():GetSpecialValueFor("nausea_base_dmg") + self:GetParent():GetHealth() * (self:GetAbility():GetSpecialValueFor("nausea_bonus_dmg") / 100)
		local damageTable = {
							victim = self:GetParent(),
							attacker = self:GetCaster(),
							damage = dmg,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self:GetAbility(), --Optional.
							}
		ApplyDamage(damageTable)
	end
end

function modifier_imba_confusion:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit == self:GetParent() and not keys.ability:IsItem() then
		local dmg = self:GetAbility():GetSpecialValueFor("nausea_base_dmg") + self:GetParent():GetHealth() * (self:GetAbility():GetSpecialValueFor("nausea_bonus_dmg") / 100)
		local damageTable = {
							victim = self:GetParent(),
							attacker = self:GetCaster(),
							damage = dmg,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self:GetAbility(), --Optional.
							}
		ApplyDamage(damageTable)
	end
end


imba_queenofpain_delightful_torment = class({})

LinkLuaModifier("modifier_imba_delightful_torment", "hero/hero_queen_of_pain", LUA_MODIFIER_MOTION_NONE)

function imba_queenofpain_delightful_torment:Set_InitialUpgrade() return {LV=1} end
function imba_queenofpain_delightful_torment:GetIntrinsicModifierName() return "modifier_imba_delightful_torment" end

modifier_imba_delightful_torment = class({})

function modifier_imba_delightful_torment:IsDebuff()			return false end
function modifier_imba_delightful_torment:IsHidden() 			return true end
function modifier_imba_delightful_torment:IsPurgable() 			return false end
function modifier_imba_delightful_torment:IsPurgeException() 	return false end
function modifier_imba_delightful_torment:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_imba_delightful_torment:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and keys.unit:IsTrueHero() then
		local cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
		for i = 0, 23 do
			local current_ability = self:GetParent():GetAbilityByIndex(i)
			if current_ability then
				local cooldown_remaining = current_ability:GetCooldownTimeRemaining()
				current_ability:EndCooldown()
				if cooldown_remaining > cooldown_reduction then
					current_ability:StartCooldown( cooldown_remaining - cooldown_reduction )
				end
			end
		end
	end
	if keys.attacker == self:GetParent() and self:GetParent():TG_HasTalent("special_bonus_imba_queenofpain_1") and not keys.unit:IsMagicImmune() and not keys.unit:IsBuilding() and not keys.unit:IsCourier() and not keys.unit:IsOther() and not self:GetParent():IsIllusion() then
		keys.unit:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_confuse", {duration = self:GetParent():TG_GetTalentValue("special_bonus_imba_queenofpain_1")})
	end
end

--modifier_confuse

imba_queenofpain_sonic_wave = class({})

function imba_queenofpain_sonic_wave:IsHiddenWhenStolen() 		return false end
function imba_queenofpain_sonic_wave:IsRefreshable() 			return true end
function imba_queenofpain_sonic_wave:IsStealable() 				return true end

LinkLuaModifier("modifier_imba_sonic_wave_daze", "hero/hero_queen_of_pain", LUA_MODIFIER_MOTION_NONE)

function imba_queenofpain_sonic_wave:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0
	local sound = CreateModifierThinker(caster, self, "modifier_imba_delightful_torment", {duration = 5.0}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false):entindex()
	local sound_name = "Hero_QueenOfPain.SonicWave"
	local pfx_name = "particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf"
	--[[if HeroItems:UnitHasItem(caster, "queenofpain_ti10arcana") then
		pfx_name = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_sonic_wave.vpcf"
	end
	--v2
	if HeroItems:UnitHasCustomFemaleItem(caster) then
		pfx_name = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_sonic_wave_v2.vpcf"
	end]]
	--音效
	EntIndexToHScript(sound):EmitSound(sound_name)
	EntIndexToHScript(sound).hitted = {}
	local info =
	{
		Ability = self,
		EffectName = pfx_name,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = self:GetSpecialValueFor("distance"),
		fStartRadius = self:GetSpecialValueFor("starting_aoe"),
		fEndRadius = self:GetSpecialValueFor("final_aoe"),
		Source = caster,
		iSourceAttachment = "mouth",
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = direction * self:GetSpecialValueFor("speed"),
		bProvidesVision = false,
		ExtraData = {thinker = sound}
	}
	if math.random(0,49) == math.random(0,49) then
		--eggs
		local cast_pos = caster:GetAbsOrigin()
		local lines = 8
		local end_pos = cast_pos + cast_pos:Normalized() * self:GetSpecialValueFor("distance")
		for i=0, lines-1 do
			local pos = GetGroundPosition(RotatePosition(cast_pos, QAngle(0,i * (360 / lines),0), end_pos), nil)
			local direction = (pos - cast_pos):Normalized()
			direction.z = 0
			info.vVelocity = direction * self:GetSpecialValueFor("speed")
			ProjectileManager:CreateLinearProjectile(info)
		end
	else
		ProjectileManager:CreateLinearProjectile(info)
	end
end

function imba_queenofpain_sonic_wave:OnProjectileThink_ExtraData(location, keys)
	if EntIndexToHScript(keys.thinker) then
		EntIndexToHScript(keys.thinker):SetOrigin(location)
	end
end

function imba_queenofpain_sonic_wave:OnProjectileHit_ExtraData(target, location, keys)
	if target and not IsInTable(target, EntIndexToHScript(keys.thinker).hitted) then
		table.insert(EntIndexToHScript(keys.thinker).hitted, target)
		local caster = self:GetCaster()
		local dmg = caster:HasScepter() and self:GetSpecialValueFor("damage") or self:GetSpecialValueFor("damage_scepter")
		local ability = caster:FindAbilityByName("imba_queenofpain_scream_of_pain")
		if ability and ability:GetLevel() > 0 and caster:HasScepter() and target:IsTrueHero() then
			ability:OnSpellStart(target, nil, nil, true)
		end
		target:AddNewModifier_RS(caster, self, "modifier_confuse", {duration = self:GetSpecialValueFor("debuff_duration")})
		target:AddNewModifier_RS(caster, self, "modifier_imba_sonic_wave_daze", {duration = self:GetSpecialValueFor("debuff_duration")})
		local damageTable = {
							victim = target,
							attacker = caster,
							damage = dmg,
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}
		ApplyDamage(damageTable)
		--[[if HeroItems:UnitHasItem(self:GetCaster(), "queenofpain_ti10arcana") or HeroItems:UnitHasCustomFemaleItem(self:GetCaster()) then
			target:EmitSound("Hero_QueenOfPain.SonicWave.Arcana.Target")
		end]]
	end
	if not target then
		EntIndexToHScript(keys.thinker).hitted = nil
	end
end

modifier_imba_sonic_wave_daze = class({})

function modifier_imba_sonic_wave_daze:IsDebuff()			return true end
function modifier_imba_sonic_wave_daze:IsHidden() 			return false end
function modifier_imba_sonic_wave_daze:IsPurgable() 		return true end
function modifier_imba_sonic_wave_daze:IsPurgeException() 	return true end
function modifier_imba_sonic_wave_daze:DeclareFunctions() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end
function modifier_imba_sonic_wave_daze:GetModifierIncomingDamage_Percentage() return self:GetAbility():GetSpecialValueFor("damage_increase") end