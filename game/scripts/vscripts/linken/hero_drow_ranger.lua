CreateTalents("npc_dota_hero_drow_ranger", "linken/hero_drow_ranger")
function StringToVector(sString)
	--Input: "123 123 123"
	local temp = {}
	for str in string.gmatch(sString, "%S+") do
		if tonumber(str) then
			temp[#temp + 1] = tonumber(str)
		else
			return nil
		end
	end
	return Vector(temp[1], temp[2], temp[3])
end
LinkLuaModifier("modifier_imba_drow_ranger_frost_arrows_passive", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_arrows_slow_stacks", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_arrows_frozen", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_arrows_shard", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
imba_drow_ranger_frost_arrows = class({})

function imba_drow_ranger_frost_arrows:GetIntrinsicModifierName() return "modifier_imba_drow_ranger_frost_arrows_passive" end
modifier_imba_drow_ranger_frost_arrows_passive = class({})

function modifier_imba_drow_ranger_frost_arrows_passive:IsDebuff()			return false end
function modifier_imba_drow_ranger_frost_arrows_passive:IsHidden() 			return true end
function modifier_imba_drow_ranger_frost_arrows_passive:IsPurgable() 			return false end
function modifier_imba_drow_ranger_frost_arrows_passive:IsPurgeException() 	return false end
function modifier_imba_drow_ranger_frost_arrows_passive:GetPriority() 		return MODIFIER_PRIORITY_LOW end
function modifier_imba_drow_ranger_frost_arrows_passive:StatusEffectPriority() return 15 end

function modifier_imba_drow_ranger_frost_arrows_passive:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ATTACK, MODIFIER_PROPERTY_PROJECTILE_NAME}
end

function modifier_imba_drow_ranger_frost_arrows_passive:GetModifierProjectileName() return "particles/econ/items/drow/drow_bow_monarch/drow_frost_arrow_monarch.vpcf" end
function modifier_imba_drow_ranger_frost_arrows_passive:OnCreated()
	self.duration = self:GetAbility():GetSpecialValueFor("frost_arrows_hero_duration")
	self.shard_st = self:GetAbility():GetSpecialValueFor("shard_st")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if not IsServer() then
		return
	end
end
function modifier_imba_drow_ranger_frost_arrows_passive:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() then
		return
	end
	EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_DrowRanger.FrostArrows", self:GetParent())
end

function modifier_imba_drow_ranger_frost_arrows_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsMagicImmune() or self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() or not keys.target:IsAlive() then
		return
	end
	if not self:GetAbility():IsCooldownReady() then
		return
	end
	local target = keys.target
	local damageTable = {
						victim = target,
						attacker = self:GetCaster(),
						damage = self.bonus_damage,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						ability = self:GetAbility(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE,
						}
	ApplyDamage(damageTable)				
	target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_frost_arrows_slow_stacks", {duration = self.duration})
	if keys.attacker:Has_Aghanims_Shard() and target:IsHero () then
		target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_frost_arrows_shard", {duration = self.shard_st})	
	end	
	self:GetAbility():UseResources(false, false, true)
end
modifier_imba_frost_arrows_slow_stacks = class({})

function modifier_imba_frost_arrows_slow_stacks:IsDebuff()				return true end
function modifier_imba_frost_arrows_slow_stacks:IsHidden() 				return false end
function modifier_imba_frost_arrows_slow_stacks:IsPurgable() 			return true end
function modifier_imba_frost_arrows_slow_stacks:IsPurgeException() 		return true end
function modifier_imba_frost_arrows_slow_stacks:GetEffectName() return "particles/generic_gameplay/generic_slowed_cold.vpcf" end
function modifier_imba_frost_arrows_slow_stacks:GetStatusEffectName() return "particles/status_fx/status_effect_frost.vpcf" end
function modifier_imba_frost_arrows_slow_stacks:StatusEffectPriority() return 15 end

function modifier_imba_frost_arrows_slow_stacks:OnCreated()
	self.stacks_to_freeze = self:GetAbility():GetSpecialValueFor("stacks_to_freeze") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_drow_ranger_3")	
	self.freeze_duration = self:GetAbility():GetSpecialValueFor("freeze_duration")
	if not IsServer() then
		return
	end	
	self:SetStackCount(1)
end

function modifier_imba_frost_arrows_slow_stacks:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_imba_frost_arrows_slow_stacks:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("frost_arrows_slow")) end
function modifier_imba_frost_arrows_slow_stacks:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("at_sp_slow")) end

function modifier_imba_frost_arrows_slow_stacks:OnRefresh()
	if not IsServer() then
		return
	end
	self:IncrementStackCount()
	if self:GetStackCount() >= self.stacks_to_freeze then
		self:SetStackCount(1)
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_frost_arrows_frozen", {duration = self.freeze_duration})
	end
end

modifier_imba_frost_arrows_frozen = class({})

function modifier_imba_frost_arrows_frozen:IsDebuff()				return true end
function modifier_imba_frost_arrows_frozen:IsHidden() 				return false end
function modifier_imba_frost_arrows_frozen:IsPurgable() 			return true end
function modifier_imba_frost_arrows_frozen:IsPurgeException() 		return true end
function modifier_imba_frost_arrows_frozen:GetEffectName() return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf" end
function modifier_imba_frost_arrows_frozen:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_frost_arrows_frozen:CheckState() return {[MODIFIER_STATE_ROOTED] = true} end


modifier_imba_frost_arrows_shard = class({})
function modifier_imba_frost_arrows_shard:IsDebuff()				return true end
function modifier_imba_frost_arrows_shard:IsHidden() 				return true end
function modifier_imba_frost_arrows_shard:IsPurgable() 				return true end
function modifier_imba_frost_arrows_shard:IsPurgeException() 		return true end
function modifier_imba_frost_arrows_shard:OnCreated()
	self.shard_st = self:GetAbility():GetSpecialValueFor("shard_st")
	self.range = self:GetAbility():GetSpecialValueFor("shard_range")
	self.duration = self:GetAbility():GetSpecialValueFor("frost_arrows_hero_duration")
	self.shard_damage = self:GetAbility():GetSpecialValueFor("shard_damage")	
	if not IsServer() then
		return
	end
	self:IncrementStackCount()	
	self.stack = self:GetStackCount()
	self.pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_drow/drow_hypothermia_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.pfx2, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.pfx2, 1, Vector(0,self:GetStackCount(),0))				
end
function modifier_imba_frost_arrows_shard:OnRefresh()
	if not IsServer() then
		return
	end
	if self:GetStackCount() >= self.shard_st then
		self:SetStackCount(self.shard_st)
	else
		self:IncrementStackCount()
		self.stack = self:GetStackCount()
	end			
end
function modifier_imba_frost_arrows_shard:OnStackCountChanged(iStack)
	if IsServer() and self.pfx2 then
		ParticleManager:SetParticleControl(self.pfx2, 1, Vector(0,self:GetStackCount(),0))	
	end	
end
function modifier_imba_frost_arrows_shard:DeclareFunctions()
	return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, MODIFIER_EVENT_ON_DEATH}
end
function modifier_imba_frost_arrows_shard:OnDeath(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end	
	local caster = self:GetCaster()
	local attacker = keys.attacker
	local unit = keys.unit

	local enemy = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		unit:GetAbsOrigin() ,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self:GetAbility():GetSpecialValueFor("shard_range"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)	
	for i=1, #enemy do
		local damageTable = {
						victim = enemy[i],
						attacker = caster,
						damage = self.stack * self:GetAbility():GetSpecialValueFor("shard_damage"),
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE,
						}			
		ApplyDamage(damageTable)
		enemy[i]:AddNewModifier(caster, self:GetAbility(), "modifier_imba_frost_arrows_slow_stacks", {duration = self:GetAbility():GetSpecialValueFor("frost_arrows_hero_duration")})
		enemy[i]:AddNewModifier(caster, self:GetAbility(), "modifier_imba_frost_arrows_shard", {duration = self:GetAbility():GetSpecialValueFor("shard_st")})
	end	
end

function modifier_imba_frost_arrows_shard:GetModifierHealthRegenPercentage() 
	return -self:GetStackCount() 
end
function modifier_imba_frost_arrows_shard:OnDestroy()
	if IsServer() then
		if self.pfx2 then
			ParticleManager:DestroyParticle(self.pfx2, false)
			ParticleManager:ReleaseParticleIndex(self.pfx2)	
		end
	end	
end

imba_drow_ranger_gust = class({})

LinkLuaModifier("modifier_imba_drow_ranger_gust_debuff", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_drow_ranger_gust_enemy_motion", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_drow_ranger_gust_cast", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

function imba_drow_ranger_gust:IsHiddenWhenStolen() 	return false end
function imba_drow_ranger_gust:IsRefreshable() 			return true  end
function imba_drow_ranger_gust:IsStealable() 			return true  end
function imba_drow_ranger_gust:IsNetherWardStealable() 	return true end

function imba_drow_ranger_gust:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("distance") end
function imba_drow_ranger_gust:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	self.int = 1
	self.max = self:GetSpecialValueFor("max") + caster:TG_GetTalentValue("special_bonus_imba_drow_ranger_6")
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0.0
	self.direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0.0	
	self.buff = CreateModifierThinker(caster, self, "modifier_imba_drow_ranger_gust_cast", {duration = 10.0, direction_x = direction.x, direction_y = direction.y}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	caster:EmitSound("Hero_DrowRanger.Silence")
	local info = {Ability = self,
					EffectName = "particles/units/heroes/hero_drow/drow_silence_wave.vpcf",
					vSpawnOrigin = caster:GetAbsOrigin(),
					fDistance = self:GetSpecialValueFor("distance") + caster:GetCastRangeBonus(),
					fStartRadius = self:GetSpecialValueFor("wave_width"),
					fEndRadius = self:GetSpecialValueFor("wave_width"),
					Source = caster,
					StartPosition = "attach_attack1",
					bHasFrontalCone = false,
					bReplaceExisting = false,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					fExpireTime = GameRules:GetGameTime() + 10.0,
					bDeleteOnHit = true,
					vVelocity = direction * self:GetSpecialValueFor("wave_speed"),
					bProvidesVision = false,
					ExtraData = {buffid = self.buff:entindex()},
				}
	ProjectileManager:CreateLinearProjectile(info)
end
function imba_drow_ranger_gust:OnProjectileThink_ExtraData(location, keys)
	if keys.buffid and EntIndexToHScript(keys.buffid) then
		EntIndexToHScript(keys.buffid):SetOrigin(GetGroundPosition(location, nil))
	end	
end
function imba_drow_ranger_gust:OnProjectileHit_ExtraData(target, pos, keys)
	if not target then
		return true
	end
	self.pos_int = pos
	if 	self.int < self.max then	
		local caster = self:GetCaster()
		local pos_1 = RotatePosition(pos, QAngle(0, math.random(0, 360), 0), pos + caster:GetForwardVector() * 10)
		local direction = (pos_1 - pos):Normalized()
		direction.z = 0.0
		self.direction = (pos_1 - pos):Normalized() 
		direction.z = 0.0		
		--local buff = CreateModifierThinker(caster, self, "modifier_imba_drow_ranger_gust_cast", {duration = 10.0, direction_x = direction.x, direction_y = direction.y}, pos, caster:GetTeamNumber(), false)
		local info = {Ability = self,
						EffectName = "particles/units/heroes/hero_drow/drow_silence_wave.vpcf",
						vSpawnOrigin = pos,
						fDistance = self:GetSpecialValueFor("distance") + caster:GetCastRangeBonus(),
						fStartRadius = self:GetSpecialValueFor("wave_width"),
						fEndRadius = self:GetSpecialValueFor("wave_width"),
						Source = caster,
						StartPosition = "attach_attack1",
						bHasFrontalCone = false,
						bReplaceExisting = false,
						iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
						iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						fExpireTime = GameRules:GetGameTime() + 10.0,
						bDeleteOnHit = true,
						vVelocity = direction * self:GetSpecialValueFor("wave_speed"),
						bProvidesVision = false,
						ExtraData = {buffid = self.buff:entindex()},
					}
		self.int = self.int + 1
		self.buff:EmitSound("Hero_DrowRanger.Silence")			
		ProjectileManager:CreateLinearProjectile(info)
	elseif self.int >= self.max and EntIndexToHScript(keys.buffid) and keys.buffid then
		EntIndexToHScript(keys.buffid):ForceKill(false)	
	end	
end

modifier_imba_drow_ranger_gust_cast = class({})

function modifier_imba_drow_ranger_gust_cast:OnCreated(keys)
self.wave_width = self:GetAbility():GetSpecialValueFor("wave_width")
	if IsServer() then
		self.hitted = false
		self.direction = Vector(keys.direction_x, keys.direction_y, 0)
		self.hitted = {}
		--self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_drow_ranger_gust_cast:OnIntervalThink()
	--DebugDrawLine(GetGroundPosition((self:GetParent():GetAbsOrigin() + self:GetParent():GetRightVector() * -125), nil), GetGroundPosition((self:GetParent():GetAbsOrigin() + self:GetParent():GetRightVector() * 125), nil), 250, 255, 255, true, 2.0)	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.wave_width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	--local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(), GetGroundPosition((self:GetParent():GetAbsOrigin() + self:GetParent():GetRightVector() * -125), nil), GetGroundPosition((self:GetParent():GetAbsOrigin() + self:GetParent():GetRightVector() * 125), nil), nil, -250 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	for _, enemy in pairs(enemies) do
		local hit = false
		for _, unit in pairs(self.hitted) do
			if enemy == unit then
				hit = true
				break
			end
		end
		if not hit then
			self.hitted[#self.hitted+1] = enemy
			local caster = self:GetCaster()
			local ability = caster:FindAbilityByName("imba_drow_ranger_gust")
			--print(ability.direction)			
			local direction = ((self:GetParent():GetAbsOrigin() + ability.direction * (self.wave_width)) - enemy:GetAbsOrigin()):Normalized()
			direction.z = 0.0
			local distance  = (enemy:GetAbsOrigin() - (self:GetParent():GetAbsOrigin() + ability.direction * (self.wave_width))):Length2D()		
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_drow_ranger_gust_debuff", {duration = self:GetAbility():GetSpecialValueFor("silence_duration")})
			enemy:RemoveModifierByName("modifier_imba_drow_ranger_gust_enemy_motion")
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_drow_ranger_gust_enemy_motion", {duration = self:GetAbility():GetSpecialValueFor("knockback_duration"), direction = direction, target_pos = enemy:GetAbsOrigin() ,distance = distance})
			ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = self:GetAbility() , damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = self:GetAbility():GetAbilityDamageType()})
		end
	end
end	
function modifier_imba_drow_ranger_gust_cast:OnDestroy()
	if IsServer() then
		self.hitted = nil
		self.direction = nil
		self:GetParent():RemoveSelf()
	end
end

modifier_imba_drow_ranger_gust_debuff = class({})

function modifier_imba_drow_ranger_gust_debuff:IsDebuff()				return true end
function modifier_imba_drow_ranger_gust_debuff:IsHidden() 				return false end
function modifier_imba_drow_ranger_gust_debuff:IsPurgable() 			return true end
function modifier_imba_drow_ranger_gust_debuff:IsPurgeException() 		return true end
function modifier_imba_drow_ranger_gust_debuff:DeclareFunctions()return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MISS_PERCENTAGE, MODIFIER_EVENT_ON_ATTACK_FAIL} end
function modifier_imba_drow_ranger_gust_debuff:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_imba_drow_ranger_gust_debuff:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("move_slow")) end
function modifier_imba_drow_ranger_gust_debuff:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("attack_slow")) end
function modifier_imba_drow_ranger_gust_debuff:GetModifierMiss_Percentage() 
	return  self:GetCaster():TG_GetTalentValue("special_bonus_imba_drow_ranger_4")
end 
function modifier_imba_drow_ranger_gust_debuff:OnAttackFail(keys) 
	if keys.attacker ~= self:GetParent() then
		return
	end
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_EVADE, keys.target, 0, nil)	
end

modifier_imba_drow_ranger_gust_enemy_motion = class({})

function modifier_imba_drow_ranger_gust_enemy_motion:IsDebuff()				return false end
function modifier_imba_drow_ranger_gust_enemy_motion:IsHidden() 			return true end
function modifier_imba_drow_ranger_gust_enemy_motion:IsPurgable() 			return true end
function modifier_imba_drow_ranger_gust_enemy_motion:IsPurgeException() 	return true end
function modifier_imba_drow_ranger_gust_enemy_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_PROPERTY_MOVESPEED_LIMIT} end
function modifier_imba_drow_ranger_gust_enemy_motion:GetModifierMoveSpeed_Absolute() if IsServer() then return 1 end end
function modifier_imba_drow_ranger_gust_enemy_motion:GetModifierMoveSpeed_Limit() if IsServer() then return 1 end end
function modifier_imba_drow_ranger_gust_enemy_motion:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_imba_drow_ranger_gust_enemy_motion:IsMotionController()	return true end
function modifier_imba_drow_ranger_gust_enemy_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end

function modifier_imba_drow_ranger_gust_enemy_motion:OnCreated(keys)
self.knockback_height = self:GetAbility():GetSpecialValueFor("knockback_height")
	if IsServer() then
		--if not self:CheckMotionControllers() then
		--	self:Destroy()
		--else
			self.target_pos = keys.target_pos
			self.direction = StringToVector(keys.direction)
			self.knockback_distance = keys.distance
			self:StartIntervalThink(FrameTime())
		--end
	end
end

function modifier_imba_drow_ranger_gust_enemy_motion:OnIntervalThink()
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)	
	local distance = self.knockback_distance / total_ticks
	local height = self.knockback_height
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + self.direction * distance, nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)
	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 100, false)
end

function modifier_imba_drow_ranger_gust_enemy_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		self.direction = nil
		self.knockback_distance = nil
		self.knockback_height = nil
	end
end
----------------------------------------------------------------------------------------------------------------------
imba_drow_ranger_multishot = class({})
LinkLuaModifier("modifier_imba_drow_ranger_multishot", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_multishot_passive", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_imba_life1", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
function imba_drow_ranger_multishot:IsRefreshable() 			return true  end
function imba_drow_ranger_multishot:IsStealable() 			return false  end
function imba_drow_ranger_multishot:GetIntrinsicModifierName() return "modifier_imba_multishot_passive" end
function imba_drow_ranger_multishot:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_drow_ranger_multishot") then  
		return  "imba_drow_ranger_multishot"	
	end
	return "drow_ranger_multishot"
end
function imba_drow_ranger_multishot:GetBehavior()
	if self:GetCaster():HasModifier("modifier_imba_drow_ranger_multishot") then  
		return  DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
	return DOTA_ABILITY_BEHAVIOR_POINT
end
function imba_drow_ranger_multishot:OnSpellStart()
	self.boll = self:GetSpecialValueFor("attack_interval")
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local length_pos = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Length2D()
	local direction = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized()
	self.pos = caster:GetAbsOrigin() + caster:GetForwardVector() * (length_pos)
	if not self:GetCaster():HasModifier("modifier_imba_drow_ranger_multishot") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_drow_ranger_multishot", {})

		self:GetCaster():SetForwardVector(direction)
	else
		self:GetCaster():RemoveModifierByName("modifier_imba_drow_ranger_multishot")
	end	
	self.int = self:GetCaster():HasModifier("modifier_imba_drow_ranger_multishot")
	self.now = 1.0

	self:GetCaster():SetContextThink( DoUniqueString( "multishot" ), function ( )
		local caster = self:GetCaster()
		local pos1 = caster:GetAbsOrigin() + caster:GetForwardVector() * 50
		local pos_start = RotatePosition(caster:GetAbsOrigin(), QAngle(0, 30, 0), pos1)
		local pos_end = RotatePosition(caster:GetAbsOrigin(), QAngle(0, 330, 0), pos1)
		local pos_now = (pos_start + pos_end) / 2
		local direction = (pos_start - pos_end):Normalized()
		local length = (pos_start - pos_end):Length2D()
		local length_now = (pos_start - pos_end):Length2D() * self.now
		self.length_now = math.random(-length_now, length_now)	
		self.pos = caster:GetAbsOrigin() + caster:GetForwardVector() * length_pos

		local ability = self:GetCaster():FindModifierByName("modifier_imba_multishot_passive")
		local direction2 = ((caster:GetAbsOrigin() + caster:GetForwardVector()) - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetCaster():GetProjectileSpeed() * 1.5
		direction2.z = 0.0
		local direction3 = (( self.pos - (pos_now + direction * self.length_now))):Normalized() * self:GetCaster():GetProjectileSpeed()
		direction3.z = 0.0	

		local info = 
		{
			Ability = self,
			EffectName = "particles/units/heroes/hero_drow/drow_multishot_proj_linear_proj.vpcf",
			vSpawnOrigin = pos_now + direction * self.length_now,
			fDistance = caster:Script_GetAttackRange() * self:GetSpecialValueFor("attack_range"),
			fStartRadius = caster:GetHullRadius()*2.5,
			fEndRadius = caster:GetHullRadius()*2.5,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = direction2,
			bProvidesVision = false,
		}
		if self.int then
			ProjectileManager:CreateLinearProjectile(info)
			ability:DecrementStackCount()
			self.now = self.now + 0.05
			EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Hero_DrowRanger.Multishot.FrostArrows", self:GetCaster())
		else
			self.boll = nil	
		end
		if not caster:IsAlive() then
			self.boll = nil
		end		
		return self.boll
	end, 0.0)		
end
function imba_drow_ranger_multishot:OnProjectileHit_ExtraData(target, location, keys)

	local ability = self:GetCaster():FindAbilityByName("imba_drow_ranger_frost_arrows")
	local duration = ability:GetSpecialValueFor("frost_arrows_hero_duration")
	local duration2 = ability:GetSpecialValueFor("shard_st")
	if not target then
		return true
	end
	--[[self:GetCaster():PerformAttack(
		target, -- hTarget
		true, -- bUseCastAttackOrb
		false, -- bProcessProcs
		true, -- bSkipCooldown
		false, -- bIgnoreInvis
		false, -- bUseProjectile
		false, -- bFakeAttack
		false -- bNeverMiss
	)]]
	local damageTable = {
						victim = target,
						attacker = self:GetCaster(),
						damage = self:GetCaster():GetAttackDamage() * (self:GetSpecialValueFor("bonus_at") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_drow_ranger_7")) * 0.01,
						damage_type = self:GetAbilityDamageType(),
						ability = self,
						damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE,
						}
	ApplyDamage(damageTable)
	if not target:IsMagicImmune() then	
		target:AddNewModifier(self:GetCaster(), ability, "modifier_imba_frost_arrows_slow_stacks", {duration = duration})
		if self:GetCaster():Has_Aghanims_Shard() and target:IsHero() then
			target:AddNewModifier(self:GetCaster(), ability, "modifier_imba_frost_arrows_shard", {duration = duration2})
		end
	end	
	target:EmitSound("Hero_DrowRanger.Marksmanship.Target")	
	if not self:GetCaster():TG_HasTalent("special_bonus_imba_drow_ranger_1") then
		return true
	end	
end	
modifier_imba_drow_ranger_multishot = class({})
function modifier_imba_drow_ranger_multishot:IsDebuff()				return false end
function modifier_imba_drow_ranger_multishot:IsHidden() 			return  true end 
function modifier_imba_drow_ranger_multishot:IsPurgable() 			return false end
function modifier_imba_drow_ranger_multishot:IsPurgeException() 	return false end
function modifier_imba_drow_ranger_multishot:DestroyOnExpire()	return false end
function modifier_imba_drow_ranger_multishot:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_DISABLE_TURNING,
			MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
			}
end
function modifier_imba_drow_ranger_multishot:CheckState()
	return {
		[MODIFIER_STATE_DISARMED]	= true
	}
end

function modifier_imba_drow_ranger_multishot:GetModifierDisableTurning() 
    return 1
end
function modifier_imba_drow_ranger_multishot:GetModifierIgnoreCastAngle() 
    return 1
end
function modifier_imba_drow_ranger_multishot:OnCreated(keys)
	if IsServer() then		
		self:OnIntervalThink()	
		self:StartIntervalThink(0.1)			
	end
end

function modifier_imba_drow_ranger_multishot:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetCaster():FindModifierByName("modifier_imba_multishot_passive")
	local stack = ability:GetStackCount()
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 3)
	if 	stack < 1 then
		self:GetCaster():SetCursorPosition(self:GetCaster():GetAbsOrigin())
		self:GetAbility():OnSpellStart()
	end	
end
modifier_imba_multishot_passive = class({})
function modifier_imba_multishot_passive:IsDebuff()				return false end
function modifier_imba_multishot_passive:IsHidden() 			return false end
function modifier_imba_multishot_passive:IsPurgable() 			return false end
function modifier_imba_multishot_passive:IsPurgeException() 	return false end
function modifier_imba_multishot_passive:DestroyOnExpire()	return false end
function modifier_imba_multishot_passive:OnCreated(keys)
	self.maxcharges = self:GetAbility():GetSpecialValueFor("maxcharges")
	self.duration = (self:GetAbility():GetSpecialValueFor("chargetime") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_drow_ranger_5"))
	if IsServer() then	
		self.duration = self.duration * self:GetCaster():GetCooldownReduction()	
		self.duration_int = 1
		self.duration_end = self.duration / self.duration_int

		self:SetStackCount(self.maxcharges)
		self:OnIntervalThink()
		self:StartIntervalThink(self.duration_end)			
	end
end
function modifier_imba_multishot_passive:DeclareFunctions()
	local funcs = {
	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}

	return funcs
end
function modifier_imba_multishot_passive:OnAbilityFullyCast( keys )
	if not IsServer() then
		return
	end
	if keys.unit == self:GetCaster() and string.find(keys.ability:GetAbilityName(), "refresh") then
		self:SetStackCount(self.maxcharges)
	end
end
function modifier_imba_multishot_passive:OnIntervalThink()
	self.duration_int = (self:GetStackCount())^2 * 0.01 + 1
	self.duration_end = self.duration / self.duration_int
	self:StartIntervalThink(self.duration_end)
	if not self:GetCaster():HasModifier("modifier_imba_drow_ranger_multishot") then
		if self:GetStackCount() < self.maxcharges then
			self:IncrementStackCount()
		end	
	end	
end

imba_drow_ranger_marksmanship = class({})

LinkLuaModifier("modifier_imba_marksmanship_effect", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_marksmanship_scepter_dmg_reduce", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_marksmanship_armor", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_trueshot_damage_stack", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_marksmanship_self", "linken/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

function imba_drow_ranger_marksmanship:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end

function imba_drow_ranger_marksmanship:GetIntrinsicModifierName() return "modifier_imba_marksmanship_effect" end

function imba_drow_ranger_marksmanship:OnUpgrade()
	self:GetCaster():CalculateStatBonus(true)
end

modifier_imba_marksmanship_effect = class({})

function modifier_imba_marksmanship_effect:IsDebuff()				return false end
function modifier_imba_marksmanship_effect:IsPurgable() 			return false end
function modifier_imba_marksmanship_effect:IsPurgeException() 		return false end
function modifier_imba_marksmanship_effect:GetPriority() 			return MODIFIER_PRIORITY_LOW end
function modifier_imba_marksmanship_effect:IsHidden()				return true  end
function modifier_imba_marksmanship_effect:IsAura()
	if self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() then
		return false
	end
	return true
end
function modifier_imba_marksmanship_effect:GetAuraDuration() return 0.5 end
function modifier_imba_marksmanship_effect:GetModifierAura() return "modifier_imba_trueshot_damage_stack" end
function modifier_imba_marksmanship_effect:IsAuraActiveOnDeath() 		return false end
function modifier_imba_marksmanship_effect:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_imba_marksmanship_effect:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_imba_marksmanship_effect:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_marksmanship_effect:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_imba_marksmanship_effect:GetAuraEntityReject(hTarget)	
	return not self:GetAbility():IsTrained() or self:GetParent():PassivesDisabled() 
end
function modifier_imba_marksmanship_effect:OnCreated()
self.count = self:GetAbility():GetSpecialValueFor("count")
	if IsServer() then
		self.pfx = nil
		self.split = true
		self.splitattack = true
		self.reduction = 0
		self.bonus_range = 200
		self.records = {}
		self.parent = self:GetParent()
		self:StartIntervalThink(0.1)	
	end
end

function modifier_imba_marksmanship_effect:OnIntervalThink()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	if (#enemies > 0 or self:GetParent():PassivesDisabled()) and not self:GetCaster():TG_HasTalent("special_bonus_imba_drow_ranger_2") then
		self:SetStackCount(1)
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
			self.pfx = nil
		end
	else
		self:SetStackCount(0)
	end

	if self:GetStackCount() == 0 and not self.pfx then
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_drow/drow_marksmanship.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 2, Vector(2,0,0))
		ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "bow_top", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 5, self:GetCaster(), PATTACH_POINT_FOLLOW, "bow_bot", self:GetCaster():GetAbsOrigin(), true)
	end
end

function modifier_imba_marksmanship_effect:OnDestroy()
	if IsServer() and self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
		self.pfx = nil
	end
end

function modifier_imba_marksmanship_effect:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS, 
			MODIFIER_PROPERTY_BONUS_NIGHT_VISION, 
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, 
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_EVENT_ON_ATTACK, 
			MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
			MODIFIER_PROPERTY_PROJECTILE_NAME
			}
end

function modifier_imba_marksmanship_effect:GetModifierBonusStats_Agility() return self:GetStackCount() ~= 0 and 0 or self:GetAbility():GetSpecialValueFor("agility_bonus") end
function modifier_imba_marksmanship_effect:GetBonusNightVision() return self:GetStackCount() ~= 0 and 0 or self:GetAbility():GetSpecialValueFor("night_vision_bonus") end
function modifier_imba_marksmanship_effect:GetModifierMoveSpeedBonus_Percentage() return self:GetStackCount() ~= 0 and 0 or self:GetAbility():GetSpecialValueFor("movement_speed_bonus") end
function modifier_imba_marksmanship_effect:GetModifierAttackRangeBonus() return self:GetStackCount() ~= 0 and 0 or self:GetAbility():GetSpecialValueFor("range_bonus") end
function modifier_imba_marksmanship_effect:GetModifierProjectileName() return "particles/units/heroes/hero_drow/drow_marksmanship_frost_arrow.vpcf" end
function modifier_imba_marksmanship_effect:GetPriority() 		return MODIFIER_PRIORITY_HIGH end
function modifier_imba_marksmanship_effect:StatusEffectPriority() return 20 end
function modifier_imba_marksmanship_effect:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local random = self:GetAbility():GetSpecialValueFor("pure_chance") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_drow_ranger_8")
	if keys.attacker == self:GetParent() and self.splitattack and keys.target:IsAlive() and (keys.target:IsHero() or keys.target:IsCreep() or keys.target:IsBoss()) then
		if PseudoRandom:RollPseudoRandom(self:GetAbility(), random) then
			keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_imba_marksmanship_self", {})
			keys.target:EmitSound("Hero_DrowRanger.Marksmanship.Target")
			local dmg = ApplyDamage({victim = keys.target, attacker = self:GetParent(), damage = self:GetAbility():GetSpecialValueFor("pure_pct"), damage_type = self:GetAbility():GetAbilityDamageType(), damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, keys.target, dmg, nil)
			if keys.target:GetPhysicalArmorValue(false) > 0 then
				keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_imba_marksmanship_armor", {})
			end			
		end
	end
end
function modifier_imba_marksmanship_effect:OnAttackRecordDestroy(keys)
	if not IsServer() then
		return
	end	
	if keys.attacker == self:GetParent() and keys.target:HasModifier("modifier_imba_marksmanship_armor") then
		keys.target:RemoveModifierByName("modifier_imba_marksmanship_armor")
	end	
	if keys.attacker == self:GetParent() and keys.attacker:HasModifier("modifier_imba_marksmanship_self") then
		keys.attacker:RemoveModifierByName("modifier_imba_marksmanship_self")
	end		
end
function modifier_imba_marksmanship_effect:OnAttack( params )
	if not IsServer() then
		return
	end	
	if params.attacker~=self:GetParent() then return end
	--if self:GetStackCount()<=0 then return end

	-- record attack
	self.records[params.record] = true

	-- play sound
	--local sound_cast = "Hero_Snapfire.ExplosiveShellsBuff.Attack"
	--EmitSoundOn( sound_cast, self:GetParent() )

	-- decrement stack
	if params.no_attack_cooldown then return end

	-- not proc for attacking allies
	if params.target:GetTeamNumber()==params.attacker:GetTeamNumber() then return end

	-- not proc if attack can't use attack modifiers
	if not params.process_procs then return end

	-- not proc on split shot attacks, even if it can use attack modifier, to avoid endless recursive call and crash
	if self.split_shot then return end

	if self:GetParent():HasScepter() then
		self:SplitShotModifier( params.target )
	end
end
function modifier_imba_marksmanship_effect:SplitShotModifier( target )
	-- get radius
	local radius = self.parent:Script_GetAttackRange()

	-- find other target units
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_COURIER,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- get targets
	local count = 0
	for _,enemy in pairs(enemies) do
		-- not target itself
		if enemy~=target then

			-- perform attack
			self.split_shot = true
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_marksmanship_scepter_dmg_reduce", {})
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
			self:GetCaster():RemoveModifierByName("modifier_imba_marksmanship_scepter_dmg_reduce")

			count = count + 1
			if count>=self.count then break end
		end
	end
end
modifier_imba_marksmanship_self = class({})

function modifier_imba_marksmanship_self:IsDebuff()				return false end
function modifier_imba_marksmanship_self:IsHidden() 			return true end
function modifier_imba_marksmanship_self:IsPurgable() 			return false end
function modifier_imba_marksmanship_self:IsPurgeException() 	return false end
function modifier_imba_marksmanship_self:CheckState()
	return {[MODIFIER_STATE_CANNOT_MISS] = true}
end

modifier_imba_marksmanship_armor = class({})

function modifier_imba_marksmanship_armor:IsDebuff()				return true end
function modifier_imba_marksmanship_armor:IsHidden() 			return false end
function modifier_imba_marksmanship_armor:IsPurgable() 			return false end
function modifier_imba_marksmanship_armor:IsPurgeException() 	return false end
function modifier_imba_marksmanship_armor:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_marksmanship_armor:GetModifierPhysicalArmorBonus(keys)
	return 0 - self:GetParent():GetPhysicalArmorBaseValue()
end
modifier_imba_trueshot_damage_stack = class({})
function modifier_imba_trueshot_damage_stack:IsDebuff()				return false end
function modifier_imba_trueshot_damage_stack:IsHidden() 			return false end
function modifier_imba_trueshot_damage_stack:IsPurgable() 			return false end
function modifier_imba_trueshot_damage_stack:IsPurgeException() 	return false end

function modifier_imba_trueshot_damage_stack:OnCreated()
	if IsServer() then	
		self:StartIntervalThink(0.1)
	end
end
function modifier_imba_trueshot_damage_stack:OnIntervalThink()
	if not IsServer() then
		return
	end	
	self:SetStackCount(self:GetCaster():GetAgility() * (self:GetAbility():GetSpecialValueFor("trueshot_ranged_damage") / 100))
end

function modifier_imba_trueshot_damage_stack:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, 
			}
end
function modifier_imba_trueshot_damage_stack:GetModifierPreAttack_BonusDamage() return self:GetStackCount() end

modifier_imba_marksmanship_scepter_dmg_reduce = class({})
function modifier_imba_marksmanship_scepter_dmg_reduce:IsDebuff()				return false end
function modifier_imba_marksmanship_scepter_dmg_reduce:IsHidden() 				return true end
function modifier_imba_marksmanship_scepter_dmg_reduce:IsPurgable() 			return false end
function modifier_imba_marksmanship_scepter_dmg_reduce:IsPurgeException() 		return false end
function modifier_imba_marksmanship_scepter_dmg_reduce:DeclareFunctions() return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE} end
function modifier_imba_marksmanship_scepter_dmg_reduce:GetModifierDamageOutgoing_Percentage() return ((0 - self:GetAbility():GetSpecialValueFor("damage_reduction_scepter")) or 0) end
