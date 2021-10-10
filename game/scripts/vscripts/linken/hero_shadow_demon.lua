----------------------2021/5/10 by 你收拾收拾准备出林肯吧
CreateTalents("npc_dota_hero_shadow_demon", "linken/hero_shadow_demon")
imba_shadow_demon_disruption = class({})

LinkLuaModifier("modifier_imba_disruption","linken/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_disruption_damage","linken/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_disruption_talent","linken/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_disruption_muted", "linken/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)

function imba_shadow_demon_disruption:IsHiddenWhenStolen() 	return false end
function imba_shadow_demon_disruption:IsRefreshable() 		return true  end
function imba_shadow_demon_disruption:IsStealable()			return true end
function imba_shadow_demon_disruption:GetIntrinsicModifierName() return "modifier_imba_disruption_talent" end
function imba_shadow_demon_disruption:GetCastRange()
	return self:GetSpecialValueFor("range")
end
function imba_shadow_demon_disruption:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TG_TriggerSpellAbsorb(self) then
		return
	end
	self.caster = caster
	self.target = target
	local duration = self:GetSpecialValueFor("disruption_duration") + caster:TG_GetTalentValue("special_bonus_imba_shadow_demon_2")
	duration= Is_Chinese_TG(caster,target) and duration or TG_StatusResistance_GET(target,duration)
	target:AddNewModifier(caster, self, "modifier_imba_disruption", {duration = duration})
	local illusions_incoming = self:GetSpecialValueFor("illusions_incoming")
	local modifier_illusions =
	{
	    outgoing_damage=0,
	    incoming_damage=illusions_incoming - 100,
	    bounty_base=0,
	    bounty_growth=0,
	    outgoing_damage_structure=0,
	    outgoing_damage_roshan=0,
	}
	if not self:GetCaster():TG_HasTalent("special_bonus_imba_shadow_demon_4") then
		caster.illusions = CreateIllusions(target, target, modifier_illusions, 1, 0, false, false)
		for i=1, #caster.illusions do
			caster.illusions[i]:AddNewModifier(target, self, "modifier_kill", {duration =duration})
			caster.illusions[i]:AddNewModifier(target, self, "modifier_phased", {duration = duration})
		end
		caster.illusions[1]:AddNewModifier(target, self, "modifier_imba_disruption_damage", {duration = duration, int = 1})
		caster.illusions[1]:SetAbsOrigin(target:GetAbsOrigin() + caster:GetRightVector()*150)
	else
		caster.illusions = CreateIllusions(target, target, modifier_illusions, 2, 0, false, false)
		for i=1, #caster.illusions do
			caster.illusions[i]:AddNewModifier(target, self, "modifier_kill", {duration =duration})
			caster.illusions[i]:AddNewModifier(target, self, "modifier_phased", {duration = duration})
		end
		--两个不同的状态
		caster.illusions[1]:AddNewModifier(target, self, "modifier_imba_disruption_damage", {duration = duration, int = 1})
		caster.illusions[1]:SetAbsOrigin(target:GetAbsOrigin() + caster:GetRightVector()*150)

		caster.illusions[2]:AddNewModifier(target, self, "modifier_imba_disruption_damage", {duration = duration, int = 2})

		caster.illusions[2]:SetAbsOrigin(target:GetAbsOrigin() - caster:GetRightVector()*150)
		Timers:CreateTimer(FrameTime()*3, function()
			caster.illusions[1]:MoveToTargetToAttack(caster.illusions[2])
			caster.illusions[1]:SetAttacking(caster.illusions[2])
			caster.illusions[2]:MoveToTargetToAttack(caster.illusions[1])
			caster.illusions[2]:SetAttacking(caster.illusions[1])
		end)
	end
	EmitSoundOn("Hero_ShadowDemon.Disruption.Cast", self:GetCaster())
end
modifier_imba_disruption = class({})
function modifier_imba_disruption:IsDebuff()			return IsEnemy(self:GetCaster(),self:GetParent()) end
function modifier_imba_disruption:IsHidden() 			return false end
function modifier_imba_disruption:IsPurgable() 			return false end
function modifier_imba_disruption:IsPurgeException() 	return false end
function modifier_imba_disruption:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
	return state
end
function modifier_imba_disruption:OnCreated()
	if IsServer() then
		self.bool = false
		if self:GetParent():HasModifier("modifier_imba_demonic_purge_debuff") then
			self.bool = true
		end
		EmitSoundOn("Hero_ShadowDemon.Disruption", self:GetParent())
	   	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_shadow_demon/shadow_demon_disruption.vpcf", PATTACH_CUSTOMORIGIN, nil)
	    ParticleManager:SetParticleControl(self.pfx, 0, GetGroundPosition(self:GetParent():GetAbsOrigin(),self:GetParent())+Vector(0,0,150))
	    ParticleManager:SetParticleControl(self.pfx, 4, GetGroundPosition(self:GetParent():GetAbsOrigin(),self:GetParent())+Vector(0,0,150))
	    self:AddParticle(self.pfx, false, false, -1, false, false)
		self:GetParent():AddNoDraw()
	end
end

function modifier_imba_disruption:OnDestroy()
	if IsServer() then
		StopSoundOn("Hero_ShadowDemon.Disruption", self:GetParent())
		EmitSoundOn("Hero_ShadowDemon.Disruption.End", self:GetParent())
		self:GetParent():RemoveNoDraw()
		if self.pfx then
	    	ParticleManager:DestroyParticle(self.pfx, false)
	    	ParticleManager:ReleaseParticleIndex(self.pfx)
	    end
	    local duration = self:GetAbility():GetSpecialValueFor("muted_duration")
	    if self.bool and self:GetParent():IsAlive() and IsEnemy(self:GetParent(),self:GetCaster()) then
	    	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_disruption_muted", {duration = duration})
	    end
	end
end
modifier_imba_disruption_talent = class({})

function modifier_imba_disruption_talent:IsDebuff()			return false end
function modifier_imba_disruption_talent:IsHidden() 			return true end
function modifier_imba_disruption_talent:IsPurgable() 		return false end
function modifier_imba_disruption_talent:IsPurgeException() 	return false end
function modifier_imba_disruption_talent:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
			}
end
function modifier_imba_disruption_talent:GetModifierPercentageCasttime()
	if self:GetCaster():TG_HasTalent("special_bonus_imba_shadow_demon_6") then
		local cast_time = 0 - self:GetCaster():TG_GetTalentValue("special_bonus_imba_shadow_demon_6")
		return cast_time
	end
	return nil
end
function modifier_imba_disruption_talent:OnCreated()
	if not IsServer() then return end
	--检测天赋
	if not self:GetParent():IsIllusion() then
		AbilityChargeController:AbilityChargeInitialize(self:GetAbility(), self:GetAbility():GetCooldown(4 - 1), 1, 1, true, true)
		self:StartIntervalThink(0.5)
	end
end
function modifier_imba_disruption_talent:OnIntervalThink()
	if self:GetParent():TG_HasTalent("special_bonus_imba_shadow_demon_1") then
		AbilityChargeController:ChangeChargeAbilityConfig(self:GetAbility(), self:GetAbility():GetSpecialValueFor("charge_restore_time"), 2, 1, true, true)
	else
		AbilityChargeController:ChangeChargeAbilityConfig(self:GetAbility(), self:GetAbility():GetSpecialValueFor("charge_restore_time"), 1, 1, true, true)
	end
end

modifier_imba_disruption_damage = class({})
function modifier_imba_disruption_damage:IsDebuff()				return true end
function modifier_imba_disruption_damage:IsHidden() 			return true end
function modifier_imba_disruption_damage:IsPurgable() 			return false end
function modifier_imba_disruption_damage:IsPurgeException() 	return false end
function modifier_imba_disruption_damage:RemoveOnDeath() return not self:GetParent():IsIllusion() end
function modifier_imba_disruption_damage:GetStatusEffectName()
  return "particles/units/heroes/hero_phantom_lancer/status_effect_phantom_illstrong.vpcf"
end
function modifier_imba_disruption_damage:StatusEffectPriority()
  return 10001
end
function modifier_imba_disruption_damage:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = self.stun,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
		[MODIFIER_STATE_ATTACK_ALLIES] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
	return state
end
function modifier_imba_disruption_damage:DeclareFunctions()
	return {
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	MODIFIER_PROPERTY_MIN_HEALTH,
	}
end
function modifier_imba_disruption_damage:GetMinHealth() return self.hp end
function modifier_imba_disruption_damage:OnCreated(keys)
	if IsServer() then
		self.target = self:GetAbility().target
		self.caster = self:GetAbility().caster
		self.hp = self:GetParent():GetMaxHealth()
		self.int = keys.int
		self.attacker = self.caster
		self.stun = not self.caster:TG_HasTalent("special_bonus_imba_shadow_demon_4")
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_disruption_damage:OnIntervalThink()
	if not self.target:IsAlive() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_imba_disruption_damage:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	if keys.damage == self:GetParent():GetHealth() or keys.original_damage == self:GetParent():GetHealth() then
		return
	end
	if keys.attacker:IsHero() and not keys.attacker:IsIllusion() then
		self.attacker = keys.attacker
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then	return end
	--记录伤害
	if IsEnemy(self.caster,self.target) and self.target:IsAlive() then
		local damageTable = {
							victim = self.target,
							attacker = self.attacker,
							damage = keys.damage,
							damage_type = keys.damage_type,
							ability = self:GetAbility(),
							damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION,
							}
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self.target, keys.damage, nil)
	elseif not IsEnemy(self.caster,self.target) and self.target:IsAlive() then
		--是队友就治疗
		self.target:Heal(keys.damage, self:GetCaster())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.target, keys.damage, nil)
	end
end
function modifier_imba_disruption_damage:OnDestroy()
	if IsServer() then
		self.attacker = self.caster
		self.target = nil
		self.caster = nil
		--检测技能是否丢失 水人专属
		if self:GetAbility() then
			self:GetAbility().target = nil
			self:GetAbility().caster = nil
		end
	end
end
modifier_imba_disruption_muted = class({})
function modifier_imba_disruption_muted:IsDebuff()			return true end
function modifier_imba_disruption_muted:IsHidden() 			return false end
function modifier_imba_disruption_muted:IsPurgable() 		return true end
function modifier_imba_disruption_muted:IsPurgeException() 	return true end
function modifier_imba_disruption_muted:GetEffectName() return "particles/generic_gameplay/generic_muted.vpcf" end
function modifier_imba_disruption_muted:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_disruption_muted:ShouldUseOverheadOffset() return true end
function modifier_imba_disruption_muted:CheckState() return {[MODIFIER_STATE_MUTED] = true} end

imba_shadow_demon_soul_catcher = class({})

LinkLuaModifier("modifier_imba_soul_catcher","linken/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)

function imba_shadow_demon_soul_catcher:IsHiddenWhenStolen() 	return false end
function imba_shadow_demon_soul_catcher:IsRefreshable() 		return true  end
function imba_shadow_demon_soul_catcher:IsStealable()			return true end
function imba_shadow_demon_soul_catcher:GetAOERadius()
	local radius = self:GetSpecialValueFor("radius")
	return radius
end
function imba_shadow_demon_soul_catcher:GetCastRange()
	return self:GetSpecialValueFor("range")
end
function imba_shadow_demon_soul_catcher:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	self.attacker = caster
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		pos,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		--搜索无敌隐藏单位
		DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		FIND_ANY_ORDER,
		false
		)
	for _, enemy in pairs(enemies) do
		if enemy:IsInvulnerable() and not enemy:HasModifier("modifier_imba_disruption")	then
			return
		elseif enemy:HasModifier("modifier_imba_disruption") then
			--无敌单位只能自己给自己上修饰器
			enemy:AddNewModifier_RS(enemy, self, "modifier_imba_soul_catcher", {duration = duration, attacker_entindex = self:GetCaster():entindex()})
		elseif not enemy:IsInvulnerable() then
			enemy:AddNewModifier_RS(enemy, self, "modifier_imba_soul_catcher", {duration = duration, attacker_entindex = self:GetCaster():entindex()})
		end
		EmitSoundOn("Hero_ShadowDemon.Soul_Catcher", enemy)
	end
	local particle_ground = "particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher_v2_projected_ground.vpcf"
	local particle_ground_fx = ParticleManager:CreateParticle(particle_ground, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_ground_fx, 0, pos)
	ParticleManager:SetParticleControl(particle_ground_fx, 1, pos)
	ParticleManager:SetParticleControl(particle_ground_fx, 2, pos)
	ParticleManager:SetParticleControl(particle_ground_fx, 3, Vector(radius,0,0))

	Timers:CreateTimer(0.1, function()
		ParticleManager:DestroyParticle(particle_ground_fx, false)
		ParticleManager:ReleaseParticleIndex(particle_ground_fx)
	end)
	EmitSoundOn("Hero_ShadowDemon.Soul_Catcher.Cast", caster)
end
modifier_imba_soul_catcher = class({})
function modifier_imba_soul_catcher:IsDebuff()			return true end
function modifier_imba_soul_catcher:IsHidden() 			return false end
function modifier_imba_soul_catcher:IsPurgable() 		return false end
function modifier_imba_soul_catcher:IsPurgeException() 	return false end
function modifier_imba_soul_catcher:RemoveOnDeath() 	return true end
--MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 无效果（bug）
function modifier_imba_soul_catcher:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_soul_catcher:OnCreated(keys)
	self.health_lost = self:GetAbility():GetSpecialValueFor("health_lost")
	self.illusion = self:GetAbility():GetSpecialValueFor("illusion")
	if IsServer() then
		self.bool = true
		--自身给自身上修饰器  施法者丢失  这里想办法从别的地方获得
		if keys.attacker_entindex then
			self.attacker = EntIndexToHScript(keys.attacker_entindex)
		else
			self.attacker = self:GetCaster()
		end
		self.damage = self.health_lost * self:GetParent():GetHealth() * 0.01
			local damageTable = {
							victim = self:GetParent(),
							attacker = self.attacker,
							damage = self.damage,
							damage_type = DAMAGE_TYPE_PURE,
							ability = self:GetAbility(),
							--伤害穿透无敌
							damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
							}
		if self:GetParent():IsIllusion() then
			damageTable.damage = damageTable.damage * self.illusion * 0.01
		end
		ApplyDamage(damageTable)
	   	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	    ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
	    ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())
	    self:AddParticle(self.pfx, false, false, -1, false, false)

	   	self.pfx_1 = ParticleManager:CreateParticle("particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	    ParticleManager:SetParticleControl(self.pfx_1, 0, self:GetParent():GetAbsOrigin())
	    ParticleManager:SetParticleControl(self.pfx_1, 1, self:GetParent():GetAbsOrigin())
	    ParticleManager:SetParticleControl(self.pfx_1, 2, self:GetParent():GetAbsOrigin())
	    ParticleManager:SetParticleControl(self.pfx_1, 3, Vector(300,0,0))
	    ParticleManager:SetParticleControl(self.pfx_1, 4, self:GetParent():GetAbsOrigin())
	    self:AddParticle(self.pfx_1, false, false, -1, false, false)
	    self:OnIntervalThink()
	    self:StartIntervalThink(0.1)
	end
end
function modifier_imba_soul_catcher:OnIntervalThink()
	--imba效果 记录是否被大招影响过
	if (self:GetParent():HasModifier("modifier_imba_demonic_purge_debuff") or self:GetParent():HasModifier("modifier_imba_disruption")) and self.bool then
		self.bool = false
	end
	if self:GetParent():IsStunned() then
		for i = 0, 23 do
			local current_ability = self:GetParent():GetAbilityByIndex(i)
			if current_ability then
				local cooldown_remaining = current_ability:GetCooldownTimeRemaining()
				current_ability:EndCooldown()
				current_ability:StartCooldown( cooldown_remaining + 0.1*2)

			end
		end
	end
end
function modifier_imba_soul_catcher:OnDestroy(keys)
	if IsServer() then
		if self.bool and self:GetParent():IsAlive() then
			local hp = math.min(self:GetParent():GetHealth() + self.damage/2,self:GetParent():GetMaxHealth())
			if self:GetParent():IsIllusion() then
				hp = hp * self.illusion * 0.01
			end
	  		self:GetParent():SetHealth(hp)
	  	end
	  	self.bool = true
	  	--检测技能是否丢失
	  	if self:GetAbility() then
  			self:GetAbility().attacker = nil
  		end
 		if self.pfx then
	    	ParticleManager:DestroyParticle(self.pfx, false)
	    	ParticleManager:ReleaseParticleIndex(self.pfx)
	    end
 		if self.pfx_1 then
	    	ParticleManager:DestroyParticle(self.pfx_1, false)
	    	ParticleManager:ReleaseParticleIndex(self.pfx_1)
	    end
	end
end
imba_shadow_demon_shadow_poison = class({})
LinkLuaModifier("modifier_imba_shadow_poison", "linken/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_poison_thinker", "linken/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_poison_auto", "linken/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
function imba_shadow_demon_shadow_poison:GetIntrinsicModifierName() return "modifier_imba_shadow_poison_auto" end
function imba_shadow_demon_shadow_poison:OnSpellStart(keys)
	local caster = self:GetCaster()
	--灵魂球释放的技能 需要读取的数据
	if not keys then
		self.caster = caster
		self.pos = caster:GetAbsOrigin()
		self.target_pos = self:GetCursorPosition()
	end
	local direction = (self.target_pos - self.pos):Normalized()
	direction.z = 0
	self.speed = self:GetSpecialValueFor("speed") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_shadow_demon_5")
	self.cd = self:GetSpecialValueFor("cd")
	self.range = self:GetSpecialValueFor("radius")
	self.distance = self:GetSpecialValueFor("distance") + caster:GetCastRangeBonus()
	self.max = self:GetSpecialValueFor("number") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_shadow_demon_7")
	self.search_radius = self:GetSpecialValueFor("search_radius")
	self.int_number = 1
	if self:GetAutoCastState() and not keys then
		local ability = self:GetCaster():FindAbilityByName("imba_shadow_demon_shadow_energy")
		local pos = self:GetCursorPosition()
		if ability and ability:IsTrained() then
			local duration = ability:GetSpecialValueFor("duration")
			self.dummy_sound = CreateModifierThinker(
				self:GetCaster(), -- player source
				ability, -- ability source
				"modifier_imba_shadow_energy_thinker", -- modifier name
				{
					duration = duration,
				}, -- kv
				pos,
				self:GetCaster():GetTeamNumber(),
				false
			)
		end
		self:EndCooldown()
		self:StartCooldown((self:GetCooldown(self:GetLevel() -1 ) * self.cd * caster:GetCooldownReduction()))
	elseif not self:GetAutoCastState() or keys then
		EmitSoundOn("Hero_ShadowDemon.ShadowPoison.Cast", caster)
		self.dummy_sound = CreateModifierThinker(
			self:GetCaster(),
			self,
			"modifier_imba_shadow_poison_thinker",
			{
				duration = 60,
			},
			self.pos,
			self:GetCaster():GetTeamNumber(),
			false
		)
		self.dummy_sound:EmitSound("Hero_ShadowDemon.ShadowPoison")
	    local info = {
	        Ability = self,
	        EffectName = "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_projectile.vpcf",
	        vSpawnOrigin = self.pos,
	        fDistance = self.distance,
	        fStartRadius = self.range,
	        fEndRadius = self.range,
	        fExpireTime = GameRules:GetGameTime() + 10,
	        Source = self.caster,
	        bDeleteOnHit = false,
	        bHasFrontalCone = false,
	        bReplaceExisting = false,
	        bProvidesVision = true,
			iVisionRadius = 200,
			iVisionTeamNumber = caster:GetTeamNumber(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        vVelocity = direction * self.speed,
	        ExtraData = {dummy_sound = self.dummy_sound:entindex(),int = self.int_number}
	    }
	    ProjectileManager:CreateLinearProjectile(info)
	end
end
function imba_shadow_demon_shadow_poison:OnProjectileThink_ExtraData(pos, keys)
	if keys.dummy_sound and EntIndexToHScript(keys.dummy_sound) then
		EntIndexToHScript(keys.dummy_sound):SetOrigin(GetGroundPosition(pos, nil))
	end
end
function imba_shadow_demon_shadow_poison:OnProjectileHit_ExtraData(target, location, keys)
	if target then
		return false
	end
	--确保每次拐弯都上一次debuff
	EntIndexToHScript(keys.dummy_sound):ForceKill(false)
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		location,
		nil,
		self.search_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		FIND_CLOSEST,
		false
		)
	if #enemies > 0 and keys.int < self.max then
		for _, enemy in pairs(enemies) do
			self.pos_next = enemy:GetAbsOrigin()
			break
		end
		--确保每次拐弯都上一次debuff
		self.dummy_sound = CreateModifierThinker(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_imba_shadow_poison_thinker", -- modifier name
			{
				duration = 60,
			}, -- kv
			self.pos_next,
			self:GetCaster():GetTeamNumber(),
			false
		)
		local direction = (self.pos_next - location):Normalized()
		direction.z = 0
			--记录拐弯次数
			keys.int = keys.int + 1
		   	local info = {
		        Ability = self,
		        EffectName = "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_projectile.vpcf",
		        vSpawnOrigin = location,
		        fDistance = self.distance,
		        fStartRadius = self.range,
		        fEndRadius = self.range,
		        fExpireTime = GameRules:GetGameTime() + 10,
		        Source = caster,
		        bDeleteOnHit = false,
		        bHasFrontalCone = false,
		        bReplaceExisting = false,
		        bProvidesVision = true,
				iVisionRadius = 200,
				iVisionTeamNumber = caster:GetTeamNumber(),
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		        vVelocity = direction * self.speed,
		        ExtraData = {dummy_sound = self.dummy_sound:entindex(),int = keys.int}
		    }
		    ProjectileManager:CreateLinearProjectile(info)

	end
end
modifier_imba_shadow_poison_thinker = class({})
function modifier_imba_shadow_poison_thinker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_shadow_poison_thinker:OnCreated(keys)
self.im_damage		= 	self:GetAbility():GetSpecialValueFor("im_damage")
self.debuff_duration	= 	self:GetAbility():GetSpecialValueFor("duration")
self.range 				= 	self:GetAbility():GetSpecialValueFor("radius")
	if IsServer() then
		self.hitted = {}
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_shadow_poison_thinker:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		self.range,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		FIND_ANY_ORDER,
		false
		)
	--抄的猛犸拱 记录伤害过的敌人  确保不会一直添加
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
			if enemy:IsInvulnerable() and not enemy:HasModifier("modifier_imba_disruption")	then
				return
			elseif enemy:HasModifier("modifier_imba_disruption") then
				enemy:AddNewModifier_RS(enemy, self:GetAbility(), "modifier_imba_shadow_poison", {duration = self.debuff_duration, attacker_entindex = self:GetCaster():entindex()})
			elseif not enemy:IsInvulnerable() then
				enemy:AddNewModifier_RS(enemy, self:GetAbility(), "modifier_imba_shadow_poison", {duration = self.debuff_duration, attacker_entindex = self:GetCaster():entindex()})
			end
			local damageTable = {
								victim = enemy,
								attacker = self:GetCaster(),
								damage = self.im_damage,
								damage_type = DAMAGE_TYPE_MAGICAL,
								ability = self:GetAbility(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE,
								}
			ApplyDamage(damageTable)
		end
	end
end
function modifier_imba_shadow_poison_thinker:OnDestroy()
	if IsServer() then
		self.hitted = nil
		self:GetParent():RemoveSelf()
	end
end

modifier_imba_shadow_poison = class({})
function modifier_imba_shadow_poison:IsDebuff()				return true end
function modifier_imba_shadow_poison:IsHidden() 			return false end
function modifier_imba_shadow_poison:IsPurgable() 			return true end
function modifier_imba_shadow_poison:IsPurgeException() 	return true end
function modifier_imba_shadow_poison:RemoveOnDeath() 		return true end
function modifier_imba_shadow_poison:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_shadow_poison:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_TOOLTIP}

	return decFuncs
end

function modifier_imba_shadow_poison:OnTooltip()
	return self:ShadowPoisonDamage()
end
function modifier_imba_shadow_poison:ShadowPoisonDamage()
	--独立函数是为了buff栏显示正确伤害
	self.int = 2
	if self:GetStackCount() == 2 then
		self.int = 4
	elseif 	self:GetStackCount() == 3 then
		self.int = 8
	elseif 	self:GetStackCount() == 4 then
		self.int = 16
	elseif 	self:GetStackCount() == 5 then
		self.int = 32
	end
	local damage = self.int * self:GetParent():GetMaxHealth() * 0.01
	return damage
end
function modifier_imba_shadow_poison:OnCreated(keys)
	self.stack_damage = self:GetAbility():GetSpecialValueFor("stack_damage")
	self.max_stack = self:GetAbility():GetSpecialValueFor("max_multiply_stacks")
	if IsServer() then
		if keys.attacker_entindex then
			self.caster = EntIndexToHScript(keys.attacker_entindex)
		else
			self.caster = self:GetCaster()
		end

		self:IncrementStackCount()
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_stackui.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(math.floor(self:GetStackCount() / 10 % 10), self:GetStackCount() % 10, 0))
		self:AddParticle(self.pfx, false, false, -1, false, false)
	end
end
function modifier_imba_shadow_poison:OnRefresh()
	if IsServer() then
		if self:GetStackCount() >= self.max_stack then
			self:SetStackCount(self.max_stack)
		else
			self:IncrementStackCount()
		end
	end
end
function modifier_imba_shadow_poison:OnStackCountChanged(iStack)
	if IsServer() and self.pfx then
		--头上数字特效变更
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(math.floor(self:GetStackCount() / 10 % 10), self:GetStackCount() % 10, 0))
		if self:GetStackCount() == self.max_stack then
			self:Destroy()
		end
	end
end
function modifier_imba_shadow_poison:OnDestroy(keys)
	if IsServer() then
		local damage = self:ShadowPoisonDamage()
		local damageTable = {
							victim = self:GetParent(),
							attacker = self.caster,
							damage = damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
							ability = self:GetAbility(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE,
							}
		--对1技能的无敌单位有效
		if self:GetParent():IsInvulnerable() and self:GetParent():HasModifier("modifier_imba_disruption") then
			damageTable.damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY
		end
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), damage, nil)
		self.int = 1
		if self.pfx  then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
		EmitSoundOn("Hero_ShadowDemon.ShadowPoison.Impact", self:GetParent())
		self.particle_kill_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_kill.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.particle_kill_fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle_kill_fx, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle_kill_fx, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(1,0,0), true)
		ParticleManager:ReleaseParticleIndex(self.particle_kill_fx)

	end
end

modifier_imba_shadow_poison_auto = class({})
function modifier_imba_shadow_poison_auto:IsDebuff()			return false end
function modifier_imba_shadow_poison_auto:IsHidden() 			return true end
function modifier_imba_shadow_poison_auto:IsPurgable() 			return false end
function modifier_imba_shadow_poison_auto:IsPurgeException() 	return false end
function modifier_imba_shadow_poison_auto:DeclareFunctions() return {MODIFIER_EVENT_ON_ORDER} end
function modifier_imba_shadow_poison_auto:OnCreated()
	if IsServer() then

	end
end
function modifier_imba_shadow_poison_auto:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	--检测开关自动施法  不确定疯狂开关会不会卡顿
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		40000,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		FIND_ANY_ORDER,
		false
		)
	for _, enemy in pairs(enemies) do
		if enemy:HasModifier("modifier_imba_shadow_poison") then
			enemy:FindModifierByName("modifier_imba_shadow_poison"):Destroy()
		end
	end
end

imba_shadow_demon_shadow_energy = class({})
LinkLuaModifier("modifier_imba_shadow_energy", "linken/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_energy_thinker", "linken/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_thinker", "linken/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_energy_debuff", "linken/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
function imba_shadow_demon_shadow_energy:Set_InitialUpgrade(tg)
    return {LV=1}
end
function imba_shadow_demon_shadow_energy:GetManaCost(a)
	if self:GetCaster():Has_Aghanims_Shard() then
		return 50
	end
	return 0
end
function imba_shadow_demon_shadow_energy:GetCooldown(level)
	if self:GetCaster():Has_Aghanims_Shard() then
		return 10
	end
	return 0
end
function imba_shadow_demon_shadow_energy:GetBehavior()
	if self:GetCaster():Has_Aghanims_Shard() then
		return  DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end
function imba_shadow_demon_shadow_energy:GetIntrinsicModifierName() return "modifier_imba_shadow_energy" end
function imba_shadow_demon_shadow_energy:OnSpellStart()
	self.duration = self:GetSpecialValueFor("duration")
	self.dummy_sound = CreateModifierThinker(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_imba_shadow_energy_thinker", -- modifier name
		{
			duration = self.duration,
		}, -- kv
		self:GetCaster():GetAbsOrigin(),
		self:GetCaster():GetTeamNumber(),
		false
	)
end
modifier_imba_shadow_energy = class({})
function modifier_imba_shadow_energy:IsDebuff()				return false end
function modifier_imba_shadow_energy:IsHidden() 			return true end
function modifier_imba_shadow_energy:IsPurgable() 			return false end
function modifier_imba_shadow_energy:IsPurgeException() 	return false end
function modifier_imba_shadow_energy:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end
function modifier_imba_shadow_energy:OnCreated()
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.search_radius = self:GetAbility():GetSpecialValueFor("search_radius")
	self.delay = self:GetAbility():GetSpecialValueFor("delay")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	if IsServer() then
		self.parent = self:GetParent()
	end
end
function modifier_imba_shadow_energy:OnDeath(keys)
	if not IsServer() then return end
	if not keys.unit:IS_TrueHero_TG() then return end
	if not IsEnemy(self.parent,keys.unit) then return end
	local pos = keys.unit:GetAbsOrigin()
	local pos_self = self.parent:GetAbsOrigin()
	if TG_Distance(pos_self,pos) > self.search_radius then
		return
	end
	self.chance = self.chance + self.parent:TG_GetTalentValue("special_bonus_imba_shadow_demon_3")
	if PseudoRandom:RollPseudoRandom(self:GetAbility(), self.chance) then
		Timers:CreateTimer(self.delay, function()
			self.dummy_sound = CreateModifierThinker(
				self:GetCaster(), -- player source
				self:GetAbility(), -- ability source
				"modifier_imba_shadow_energy_thinker", -- modifier name
				{
					duration = self.duration,
				}, -- kv
				pos,
				self:GetCaster():GetTeamNumber(),
				false
			)
		end)
	end
end
modifier_imba_shadow_energy_thinker = class({})
function modifier_imba_shadow_energy_thinker:IsAura() return true end
function modifier_imba_shadow_energy_thinker:GetAuraDuration() return 0.1 end
function modifier_imba_shadow_energy_thinker:GetModifierAura() return "modifier_imba_shadow_energy_debuff" end
function modifier_imba_shadow_energy_thinker:GetAuraRadius() return self.radius end
function modifier_imba_shadow_energy_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_shadow_energy_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_shadow_energy_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_shadow_energy_thinker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_shadow_energy_thinker:OnCreated(keys)
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.search_radius = self:GetAbility():GetSpecialValueFor("search_radius")
	self.delay = self:GetAbility():GetSpecialValueFor("delay")
	if IsServer() then
		local caster = self:GetCaster()
		self.thinker = 0
		self.dummy = CreateUnitByName("npc_linken_unit", GetGroundPosition(self:GetCaster():GetAbsOrigin(),self:GetCaster()), false, caster, caster, self:GetCaster():GetTeamNumber())
		self.dummy:AddNewModifier(self:GetCaster(), self, "modifier_imba_life_thinker", {duration = self.duration})
		self.dummy:AddNewModifier(caster, nil, "modifier_rooted", {duration = self.duration})
		self.dummy:AddNewModifier(self:GetCaster(), nil, "modifier_kill", {duration = self.duration})
	   	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_shadow_demon/shadow_demon_disruption.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	    ParticleManager:SetParticleControl(self.pfx, 0, GetGroundPosition(self:GetParent():GetAbsOrigin(),self:GetParent())+Vector(0,0,150))
	    ParticleManager:SetParticleControl(self.pfx, 4, GetGroundPosition(self:GetParent():GetAbsOrigin(),self:GetParent())+Vector(0,0,150))
	    self:AddParticle(self.pfx, false, false, -1, false, false)
	    EmitSoundOn("Imba.Hero_shadow_demon.shadow_energy", self:GetParent())

		--[[self.pfx2 = ParticleManager:CreateParticle("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx2, 1, Vector(self.radius, 0, 0))
		ParticleManager:SetParticleControl(self.pfx2, 2, Vector(10, 0, 0))
		ParticleManager:SetParticleControl(self.pfx2, 3, Vector(100, 0, 0))
		ParticleManager:SetParticleControl(self.pfx2, 15, Vector(255, 155, 55))
		self:AddParticle(self.pfx2, true, false, 15, false, false)]]

		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_shadow_energy_thinker:OnIntervalThink(keys)
	--费劲的检测单位和位移
	self.dummy:SetAbsOrigin(self:GetParent():GetAbsOrigin())
	local flamebreak = Entities:FindAllInSphere(self:GetParent():GetAbsOrigin(), self.search_radius)
	for i=1, #flamebreak do
		if  string.find(flamebreak[i]:GetName(), "npc_") and flamebreak[i]:HasModifier("modifier_imba_life_thinker") and flamebreak[i]:GetAbsOrigin() ~= self:GetParent():GetAbsOrigin() and not IsEnemy(flamebreak[i], self:GetParent())  then
			self.pos = flamebreak[i]:GetAbsOrigin()
			break
		end
	end
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
	for _, enemy in pairs(enemies) do
		if (enemy:HasModifier("modifier_imba_disruption") or enemy:HasModifier("modifier_imba_soul_catcher") or enemy:HasModifier("modifier_imba_shadow_poison") or enemy:HasModifier("modifier_imba_demonic_purge_debuff")) and enemy ~= self:GetParent() then
			self.pos = enemy:GetAbsOrigin()
			break
		end
	end
	if self.pos ~= nil then
		local current_pos = self:GetParent():GetAbsOrigin()
		local distacne = 20 / (1.0 / FrameTime())
		local distance = (self:GetParent():GetAbsOrigin() - self.pos):Length2D()
		--旋转角度 越靠近角度越大
		local angle = 300 / distance
		--接近速度  越远速度越快
		local in_pull = (distance / 10)^2
		local new_pos = GetGroundPosition(RotatePosition(self.pos, QAngle(0,angle,0), current_pos), self:GetParent())
		local direction = (self.pos - new_pos):Normalized()
		direction.z = 0.0
		new_pos = new_pos + direction * in_pull / (1.0 / FrameTime())

		self:GetParent():SetOrigin(new_pos)
	    ParticleManager:SetParticleControl(self.pfx, 0, GetGroundPosition(self:GetParent():GetAbsOrigin(),self:GetParent())+Vector(0,0,150))
	    ParticleManager:SetParticleControl(self.pfx, 4, GetGroundPosition(self:GetParent():GetAbsOrigin(),self:GetParent())+Vector(0,0,150))
		if (self.pos - current_pos):Length2D() < self.radius then
			--释放3技能
			self.thinker = self.thinker + FrameTime()
		    self.ability = self:GetCaster():FindAbilityByName("imba_shadow_demon_shadow_poison")
			if self.ability and self.ability:IsTrained() and self.thinker >= self.delay then
				self:GetCaster():SetCursorPosition(self.pos)
				self.ability.pos = self:GetParent():GetAbsOrigin()
				self.ability.caster = self:GetParent()
				self.ability.target_pos = self.pos
				self.ability:OnSpellStart(true)
				self.thinker = 0
			end
		end
	end
	if self:GetCaster():Has_Aghanims_Shard() then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.radius, FrameTime(), false)
	end
	if not self:GetAbility() then
		self:Destroy()
	end
end
function modifier_imba_shadow_energy_thinker:OnDestroy()
	if IsServer() then
		if self.pfx then
	    	ParticleManager:DestroyParticle(self.pfx, false)
	    	ParticleManager:ReleaseParticleIndex(self.pfx)
	    end
		if self.pfx2 then
			ParticleManager:DestroyParticle(self.pfx2, false)
			ParticleManager:ReleaseParticleIndex(self.pfx2)
		end
	    if self.pos == nil then
	    	self.pos = self:GetCaster():GetAbsOrigin()
	    end
	    self.thinker = 0
	    self.dummy:ForceKill(false)
	    self:GetParent():RemoveSelf()
	    self.pos = nil
	    self.dummy = nil
	    StopSoundOn("Imba.Hero_shadow_demon.shadow_energy", self:GetParent())
	end
end
modifier_imba_shadow_energy_debuff = class({})

function modifier_imba_shadow_energy_debuff:IsDebuff()		return true end
function modifier_imba_shadow_energy_debuff:IsHidden() 		return false end
function modifier_imba_shadow_energy_debuff:IsPurgable() 		return true end
function modifier_imba_shadow_energy_debuff:IsPurgeException() return true end
function modifier_imba_shadow_energy_debuff:GetEffectName() return "particles/generic_gameplay/generic_silenced_old.vpcf" end
--function modifier_imba_shadow_energy_debuff:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_imba_shadow_energy_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_shadow_energy_debuff:ShouldUseOverheadOffset() return true end
function modifier_imba_shadow_energy_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE} end
function modifier_imba_shadow_energy_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_shadow_energy_debuff:OnCreated()
	self.vision = self:GetAbility():GetSpecialValueFor("vision")
	self.out_going = self:GetAbility():GetSpecialValueFor( "out_going" )
	if IsServer() then
	end
end
function modifier_imba_shadow_energy_debuff:GetBonusVisionPercentage()
	return 0 - self.vision
end
function modifier_imba_shadow_energy_debuff:GetModifierTotalDamageOutgoing_Percentage()
	if self:GetParent():HasModifier("modifier_imba_disruption_damage") then
		return nil
	end
	return 0 - self.out_going
end

modifier_imba_life_thinker = class({})

function modifier_imba_life_thinker:IsDebuff()			return true end
function modifier_imba_life_thinker:IsHidden() 			return false end
function modifier_imba_life_thinker:IsPurgable() 		return false end
function modifier_imba_life_thinker:IsPurgeException() 	return false end
function modifier_imba_life_thinker:IsStunDebuff() return true end
function modifier_imba_life_thinker:CheckState() return
	{
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true
}
end
function modifier_imba_life_thinker:OnCreated()
	if IsServer() then
	end
end

imba_shadow_demon_demonic_purge = class({})
LinkLuaModifier("modifier_imba_demonic_purge_debuff", "linken/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_demonic_purge_scepter", "linken/hero_shadow_demon.lua", LUA_MODIFIER_MOTION_NONE)
function imba_shadow_demon_demonic_purge:GetIntrinsicModifierName() return "modifier_imba_demonic_purge_scepter" end
function imba_shadow_demon_demonic_purge:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_shadow_demon_8") then
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_shadow_demon_8"))
	end
	return cooldown
end
function imba_shadow_demon_demonic_purge:OnSpellStart(x)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	if target:TG_TriggerSpellAbsorb(self) then
		return
	end
	EmitSoundOn("Hero_ShadowDemon.DemonicPurge.Cast", caster)
	if IsEnemy(caster, target) then
		target:AddNewModifier_RS(caster, self, "modifier_imba_demonic_purge_debuff", {duration = duration})
	else
	 	target:AddNewModifier(caster, self, "modifier_imba_demonic_purge_debuff", {duration = duration})
	end


end
modifier_imba_demonic_purge_debuff = class({})

function modifier_imba_demonic_purge_debuff:IsDebuff()			return IsEnemy(self:GetParent(), self:GetCaster()) end
function modifier_imba_demonic_purge_debuff:IsHidden() 			return false end
function modifier_imba_demonic_purge_debuff:IsPurgable() 		return false end
function modifier_imba_demonic_purge_debuff:IsPurgeException() 	return false end
function modifier_imba_demonic_purge_debuff:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  }
  return funcs
end
function modifier_imba_demonic_purge_debuff:CheckState()
	if self:GetCaster():HasScepter() and IsEnemy(self:GetParent(), self:GetCaster()) then
		return {[MODIFIER_STATE_PASSIVES_DISABLED] = true}
	end
end
function modifier_imba_demonic_purge_debuff:GetModifierMoveSpeedBonus_Percentage()
	local duration = self:GetRemainingTime()
	local int = math.min(duration / (self:GetDuration()) * 100, self.max_slow)
	if IsEnemy(self:GetParent(), self:GetCaster()) then
		return math.min(0-int, 0-self.min_slow)
	else
		return math.min(int, self.min_slow)
	end

end
function modifier_imba_demonic_purge_debuff:OnCreated()
	self.purge_damage = self:GetAbility():GetSpecialValueFor("purge_damage")
	self.max_slow = self:GetAbility():GetSpecialValueFor("max_slow")
	self.min_slow = self:GetAbility():GetSpecialValueFor("min_slow")
	if IsServer() then
		local direction = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_shadow_demon/shadow_demon_demonic_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 3, direction)
		ParticleManager:SetParticleControl(self.pfx, 4, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.pfx, false, false, -1, false, false)
		EmitSoundOn("Hero_ShadowDemon.DemonicPurge.Impact", self:GetParent())
		self:StartIntervalThink(FrameTime())
		local ability = self:GetCaster():FindAbilityByName("imba_shadow_demon_shadow_energy")
		local pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 150
		if ability and ability:IsTrained() then
			local duration = ability:GetSpecialValueFor("duration")
			self.dummy_sound = CreateModifierThinker(
				self:GetCaster(), -- player source
				ability, -- ability source
				"modifier_imba_shadow_energy_thinker", -- modifier name
				{
					duration = duration,
				}, -- kv
				pos,
				self:GetCaster():GetTeamNumber(),
				false
			)
		end
	end
end
function modifier_imba_demonic_purge_debuff:OnIntervalThink()
	if IsEnemy(self:GetParent(), self:GetCaster()) then
		self:GetParent():Purge(true, false, false, false, false)
	else
		self:GetParent():Purge(false, true, false, false, false)
	end
end
function modifier_imba_demonic_purge_debuff:OnRemoved()
	if not IsServer() then return end
	if self.pfx then
    	ParticleManager:DestroyParticle(self.pfx, false)
    	ParticleManager:ReleaseParticleIndex(self.pfx)
    end
    if IsEnemy(self:GetParent(), self:GetCaster()) then
		local damageTable = {victim = self:GetParent(),
							attacker = self:GetCaster(),
							damage = self.purge_damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
							damage_flags = DOTA_DAMAGE_FLAG_NONE,
							ability = self:GetAbility()}
		if self:GetParent():IsInvulnerable() and self:GetParent():HasModifier("modifier_imba_disruption") then
			damageTable.damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY
		end
		ApplyDamage(damageTable)
	else
		self:GetParent():Heal(self.purge_damage, self:GetCaster())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self.purge_damage, nil)
	end
	if self:GetParent():IsAlive() then
		EmitSoundOn("Hero_ShadowDemon.DemonicPurge.Damage", self:GetParent())
	end
	local ability = self:GetCaster():FindAbilityByName("imba_shadow_demon_shadow_energy")
	local pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 150
	if ability and ability:IsTrained() then
		local duration = ability:GetSpecialValueFor("duration")
		self.dummy_sound = CreateModifierThinker(
			self:GetCaster(), -- player source
			ability, -- ability source
			"modifier_imba_shadow_energy_thinker", -- modifier name
			{
				duration = duration,
			}, -- kv
			pos,
			self:GetCaster():GetTeamNumber(),
			false
		)
	end
end
--检测a杖给与充能
modifier_imba_demonic_purge_scepter = class({})

function modifier_imba_demonic_purge_scepter:IsDebuff()			return false end
function modifier_imba_demonic_purge_scepter:IsHidden() 			return true end
function modifier_imba_demonic_purge_scepter:IsPurgable() 		return false end
function modifier_imba_demonic_purge_scepter:IsPurgeException() 	return false end

function modifier_imba_demonic_purge_scepter:OnCreated()
	if not IsServer() then return end
	if not self:GetParent():IsIllusion() then
		AbilityChargeController:AbilityChargeInitialize(self:GetAbility(), self:GetAbility():GetCooldown(4 - 1), 1, 1, true, true)
		self:StartIntervalThink(0.5)
	end
end

function modifier_imba_demonic_purge_scepter:OnIntervalThink()
	if self:GetParent():HasScepter() then
		AbilityChargeController:ChangeChargeAbilityConfig(self:GetAbility(), self:GetAbility():GetCooldown(4 - 1), 3, 1, true, true)
	else
		AbilityChargeController:ChangeChargeAbilityConfig(self:GetAbility(), self:GetAbility():GetCooldown(4 - 1), 1, 1, true, true)
	end
end