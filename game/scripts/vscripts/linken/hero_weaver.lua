------2021.7.6--by--你收拾收拾准备出林肯吧
CreateTalents("npc_dota_hero_weaver", "linken/hero_weaver")
imba_weaver_the_swarm  = class({})
LinkLuaModifier("modifier_imba_the_swarm_debuff", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_the_swarm_aura", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_the_swarm_bug", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_the_swarm_agh", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE)

--function imba_weaver_the_swarm :IsHiddenWhenStolen() 		return true end
--function imba_weaver_the_swarm :IsStealable() 			return false end
function imba_weaver_the_swarm :OnSpellStart()	
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local speed = self:GetSpecialValueFor("speed")
	local distance = self:GetSpecialValueFor("distance")
	local radius = self:GetSpecialValueFor("radius") + caster:TG_GetTalentValue("special_bonus_imba_weaver_1")
	local direction = TG_Direction(pos, caster:GetAbsOrigin())
	
	local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 50.0}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	sound:AddNewModifier(self:GetCaster(), self, "modifier_imba_the_swarm_aura", {duration = 50.0})
	sound:EmitSound("Hero_Weaver.Swarm.Cast")
	EmitSoundOn("Hero_Weaver.Swarm.Projectile",self:GetCaster())		
		
	local info = {
		Ability = self,
		EffectName = "particles/units/heroes/hero_weaver/weaver_swarm_projectile.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = radius,
		fEndRadius = radius,
		fExpireTime = GameRules:GetGameTime() + 10,
		Source = caster,
		bDeleteOnHit = false,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		bProvidesVision = true,
		iVisionRadius = radius,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		vVelocity = direction * speed,
		ExtraData = {dummy_sound = sound:entindex()}
	}
	ProjectileManager:CreateLinearProjectile(info)
	    		
end
function imba_weaver_the_swarm:OnProjectileThink_ExtraData(pos, keys)
	if keys.dummy_sound and EntIndexToHScript(keys.dummy_sound) then
		EntIndexToHScript(keys.dummy_sound):SetOrigin(GetGroundPosition(pos, nil))
	end
end
function imba_weaver_the_swarm:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		if keys.dummy_sound then
			local sound=EntIndexToHScript(keys.dummy_sound)
			sound:ForceKill(false)
		end			
		return true
	end
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	target:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_the_swarm_debuff", {duration = duration})
end

modifier_imba_the_swarm_debuff = class({})

function modifier_imba_the_swarm_debuff:IsDebuff()				return IsEnemy(self.caster, self.parent) end
function modifier_imba_the_swarm_debuff:IsHidden() 				return false end
function modifier_imba_the_swarm_debuff:IsPurgable() 			return not self.caster:TG_HasTalent("special_bonus_imba_weaver_7")  end
function modifier_imba_the_swarm_debuff:IsPurgeException() 		return not self.caster:TG_HasTalent("special_bonus_imba_weaver_7")  end
--function modifier_imba_the_swarm_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_the_swarm_debuff:CheckState()
	if self:IsDebuff() then 
		return 
			{
			[MODIFIER_STATE_INVISIBLE] = false
			} 
	end		
end
function modifier_imba_the_swarm_debuff:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_the_swarm_debuff:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,  
		MODIFIER_EVENT_ON_DEATH, 
	} 
end
function modifier_imba_the_swarm_debuff:GetModifierPhysicalArmorBonus(keys)
	if IsEnemy(self.caster, self.parent) then 
		return 0-self:GetStackCount()
	end
	return self:GetStackCount()	
end
function modifier_imba_the_swarm_debuff:OnDeath(keys)
	if not IsServer() then return end
	if keys.unit ~= self.parent then return end
	if not keys.unit:IsHero() then return end
	if not IsEnemy(self.caster,self.parent) then return end
	local ability = self.caster:FindAbilityByName("imba_weaver_shukuchi")
	if ability and ability:IsTrained() then
		ability:SetCurrentAbilityCharges(ability:GetCurrentAbilityCharges()+1)
	end	
		
end
function modifier_imba_the_swarm_debuff:OnCreated(keys)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()	
	self.attack_rate = self.ability:GetSpecialValueFor("attack_rate") + self.caster:TG_GetTalentValue("special_bonus_imba_weaver_3")
	self.damage = self.ability:GetSpecialValueFor("damage")	
	if IsServer() then
		local duration = self.ability:GetSpecialValueFor("duration")
		self.time = 0
		self.bug = CreateUnitByName("npc_dota_weaver_swarm", self.parent:GetAbsOrigin(), true, self.caster, self.caster, self.caster:GetTeamNumber())
		self.bug:AddNewModifier(self.caster, self.ability, "modifier_imba_the_swarm_bug", {duration = duration, enemy = IsEnemy(self.caster, self.parent), target = self.parent:entindex()})
		self.bug:AddNewModifier(self.caster, self.ability, "modifier_kill", {duration = duration})
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())	
	end	
end
function modifier_imba_the_swarm_debuff:OnIntervalThink()
	if self.bug:IsAlive() then
		self.time = self.time + FrameTime()
		if self.time >= self.attack_rate then
			self:IncrementStackCount()
			self.time = 0
			if IsEnemy(self.caster, self.parent) then
				ApplyDamage(
					{
					attacker = self.caster, 
					victim = self.parent, 
					damage = self.damage, 
					damage_type = DAMAGE_TYPE_PHYSICAL, 
					ability = self.ability
					})
			else
				self.parent:Heal(self.damage, self.caster)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.parent, self.damage, nil)  
			end	
		end	
		local pos = self.parent:GetAbsOrigin()
		local direction = self.parent:GetForwardVector()
		local bug_pos = pos + direction * 64
		self.bug:SetOrigin(bug_pos)
		self.bug:SetForwardVector(0-direction)
	else
		self:Destroy()
	end
	if not self.ability then
		self:Destroy()
		self.bug:ForceKill(false)
	end			
end
function modifier_imba_the_swarm_debuff:OnDestroy()
	if IsServer() then
		if self.bug:IsAlive() then
			self.bug:ForceKill(false)
		end	
	end
end	
modifier_imba_the_swarm_bug = class({})

function modifier_imba_the_swarm_bug:IsDebuff()			return false end
function modifier_imba_the_swarm_bug:IsHidden() 		return true end
function modifier_imba_the_swarm_bug:IsPurgable() 		return false end
function modifier_imba_the_swarm_bug:IsPurgeException() return false end
function modifier_imba_the_swarm_bug:CheckState() 
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = self:GetAbility():GetAutoCastState(),
		--[MODIFIER_STATE_UNSELECTABLE] = self.caster:Has_Aghanims_Shard(),
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_INVISIBLE] = (self.target:IsInvisible() and not IsEnemy(self.caster, self.target)),
	} 
end
function modifier_imba_the_swarm_bug:DeclareFunctions() 
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED, 
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, 
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, 
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE, 
		MODIFIER_PROPERTY_DISABLE_HEALING, 
	} 
end
function modifier_imba_the_swarm_bug:GetAbsoluteNoDamageMagical() return 1 end
function modifier_imba_the_swarm_bug:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_imba_the_swarm_bug:GetAbsoluteNoDamagePure() return 1 end

function modifier_imba_the_swarm_bug:OnAttackLanded(keys)
	if not IsServer() or keys.target ~= self:GetParent() then
		return
	end
	local dmg = (keys.attacker:IsHero() or keys.attacker:IsTower()) and 2 or 1
	if self.enemy == 0 then
		dmg = self.parent:GetMaxHealth()
	end	
	if dmg > self.parent:GetHealth() then
		self.parent:Kill(self:GetAbility(), keys.attacker)
		return
	end
	self.parent:SetHealth(self.parent:GetHealth() - dmg)
end

function modifier_imba_the_swarm_bug:OnCreated(keys)
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()	
	self.destroy_attacks = self.ability:GetSpecialValueFor("destroy_attacks")
	if IsServer() then
		
		--[[Timers:CreateTimer(FrameTime()*2, function()
			self.parent:SetMaxHealth(self.destroy_attacks)	
			return nil
		end)
		Timers:CreateTimer(FrameTime()*4, function()
			self.parent:SetHealth(self.destroy_attacks)	
			return nil
		end)]]
		self.parent:Set_HP(self.destroy_attacks,true)				
		self.target = EntIndexToHScript(keys.target)
		self.enemy = keys.enemy
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_the_swarm_bug:OnIntervalThink()
	if not self.target:IsAlive() then
		self.parent:ForceKill(false)
	end	
	if not self.target then
		self.parent:ForceKill(false)
	end	
	if not self.target:HasModifier("modifier_imba_the_swarm_debuff") then
		self.parent:ForceKill(false)
	end
	if not self.ability then
		self.parent:ForceKill(false)
	end		
end
function modifier_imba_the_swarm_bug:OnDestroy()
	if IsServer() then
		self.parent = nil
		self.enemy = nil
	end
end
modifier_imba_the_swarm_aura = class({})

function modifier_imba_the_swarm_aura:IsDebuff()				return false end
function modifier_imba_the_swarm_aura:IsHidden() 				return true end
function modifier_imba_the_swarm_aura:IsPurgable() 			return false end
function modifier_imba_the_swarm_aura:IsPurgeException() 		return false end
function modifier_imba_the_swarm_aura:OnCreated(keys)
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_weaver_1")
		self.pfx = ParticleManager:CreateParticle("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.radius, 0, 0))
		ParticleManager:SetParticleControl(self.pfx, 2, Vector(10, 0, 0))
		ParticleManager:SetParticleControl(self.pfx, 3, Vector(100, 0, 0))
		ParticleManager:SetParticleControl(self.pfx, 15, Vector(255, 155, 55))
		self:AddParticle(self.pfx, true, false, 15, false, false)
		--self:StartIntervalThink(0.1)
		--self:OnIntervalThink()		
	end	
end
--[[function modifier_imba_the_swarm_aura:OnIntervalThink()
	if not self:GetParent():IsAlive() then
		self:Destroy()
	end	
end]]	
function modifier_imba_the_swarm_aura:OnRemoved()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end			
	end
end	
imba_weaver_shukuchi = class({})

LinkLuaModifier("modifier_imba_shukuchi_buff", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shukuchi_debuff", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE)
--function imba_weaver_shukuchi:IsHiddenWhenStolen() 		return true end
--function imba_weaver_shukuchi:IsStealable() 			return false end
function imba_weaver_shukuchi:GetManaCost(a) 
	if self:GetCaster():TG_HasTalent("special_bonus_imba_weaver_6") then  
		return 0	
	end
	return 70
end
function imba_weaver_shukuchi:OnSpellStart()
	self.caster = self:GetCaster()
	self.duration = self:GetSpecialValueFor("duration")
	self.caster:AddNewModifier(self.caster, self, "modifier_imba_shukuchi_buff", {duration = self.duration})
	EmitSoundOn("Hero_Weaver.Shukuchi",self:GetCaster())
	--[[self.pfx_st = ParticleManager:CreateParticle("particles/econ/items/weaver/weaver_immortal_ti6/weaver_immortal_ti6_shukuchi_portal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(self.pfx_st, 0, self.caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.pfx_st)]]			
end
modifier_imba_shukuchi_buff = class({})
function modifier_imba_shukuchi_buff:IsDebuff()				return false end
function modifier_imba_shukuchi_buff:IsHidden() 			return false end
function modifier_imba_shukuchi_buff:IsPurgable() 			return false end
function modifier_imba_shukuchi_buff:IsPurgeException() 	return false end
--function modifier_imba_shukuchi_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_shukuchi_buff:CheckState() 
	if self.bool == 1 then
		return 
		{
			[MODIFIER_STATE_INVISIBLE] = false,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_UNSLOWABLE]	= true,
			
		}
	end
		return 
		{
			[MODIFIER_STATE_INVISIBLE] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_UNSLOWABLE]	= true,
			
		} 
end
function modifier_imba_shukuchi_buff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK, 
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		}
end
function modifier_imba_shukuchi_buff:GetDisableAutoAttack() 
	return true  
end
function modifier_imba_shukuchi_buff:GetModifierInvisibilityLevel() 
	if self.bool ~= 1 then
		return 1
	end	
	
end
function modifier_imba_shukuchi_buff:OnCreated(keys) 	
	self.ability = self:GetAbility()
	self.speed = self.ability:GetSpecialValueFor("speed")
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.fade_time = self.ability:GetSpecialValueFor("fade_time")
	self.time = self.ability:GetSpecialValueFor("time")
	self.agh_radius = self.ability:GetSpecialValueFor("agh_radius")
	if IsServer() then
		self:SetStackCount(1)
		self.bool = keys.bool
		if self.bool == 1 then
			self.speed = 1000
		end	
		if self.caster:Has_Aghanims_Shard() then
			self.radius = self.radius + self.agh_radius
		end	
		self.interval = 0.25
		self.damage = self.ability:GetSpecialValueFor("damage") * self.interval
		self.caster:AddActivityModifier("shukuchi")
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_weaver/weaver_shukuchi.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.pfx, 0, self.parent:GetAbsOrigin())
		self:AddParticle(self.pfx, true, false, 15, false, false)
		self:StartIntervalThink(self.interval)	
	end 
end
function modifier_imba_shukuchi_buff:OnRefresh(keys) 
	if IsServer() then	
		self:SetStackCount(self:GetStackCount()+1)
	end	
end
function modifier_imba_shukuchi_buff:OnDestroy() 		
	if IsServer() then		
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end  
end	
function modifier_imba_shukuchi_buff:OnIntervalThink(keys)	
	local enemy = FindUnitsInRadius(
		self.caster:GetTeamNumber(), 
		self.parent:GetAbsOrigin(), 
		nil, 
		self.radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
	)			
	for i=1, #enemy do
		local damageTable = {
			victim = enemy[i],
			attacker = self.caster,
			damage = self.damage,
			damage_type = self.ability:GetAbilityDamageType(),
			ability = self.ability,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			}		
		ApplyDamage(damageTable)
		--[[self.pfx_da = ParticleManager:CreateParticle("particles/units/heroes/hero_weaver/weaver_loadout.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy[i])
		ParticleManager:SetParticleControl(self.pfx_da, 0, enemy[i]:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx_da, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx_da, 2, self.parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.pfx_da)]]		
	end			
end
function modifier_imba_shukuchi_buff:GetModifierMoveSpeedBonus_Constant() 	
	return self.speed * self:GetStackCount()
end
function modifier_imba_shukuchi_buff:GetModifierIgnoreMovespeedLimit() 	
	return 1
end
function modifier_imba_shukuchi_buff:OnAttack(keys)
	if not IsServer() then return end
	if keys.attacker ~= self.parent then
		return
	end
	local ability = self.caster:FindAbilityByName("imba_weaver_geminate_attack") 
	if ability and ability.shukuchi and not self.caster:FindModifierByName("modifier_imba_geminate_attack_reduce_damage")  then
		self:Destroy()
	elseif not ability then
		self:Destroy()	
	end	
			
end
function modifier_imba_shukuchi_buff:OnAbilityExecuted(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	if not keys.ability:IsItem() then
		return
	end
	self:Destroy()
end
function modifier_imba_shukuchi_buff:IsAura()
	return true
end
function modifier_imba_shukuchi_buff:GetAuraDuration() 
	return self.time 
end
function modifier_imba_shukuchi_buff:GetModifierAura() return "modifier_imba_shukuchi_debuff" end
function modifier_imba_shukuchi_buff:IsAuraActiveOnDeath() 		return false end
function modifier_imba_shukuchi_buff:GetAuraRadius() 	
	return self.radius 
end
function modifier_imba_shukuchi_buff:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_shukuchi_buff:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_shukuchi_buff:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_imba_shukuchi_buff:GetAuraEntityReject(hTarget)	
	return not self:GetAbility():IsTrained()
end
modifier_imba_shukuchi_debuff = class({})
function modifier_imba_shukuchi_debuff:IsDebuff()				return true end
function modifier_imba_shukuchi_debuff:IsHidden() 				return false end
function modifier_imba_shukuchi_debuff:IsPurgable() 			return true end
function modifier_imba_shukuchi_debuff:IsPurgeException() 		return true end
function modifier_imba_shukuchi_debuff:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, 
			MODIFIER_PROPERTY_MOVESPEED_LIMIT, 
			MODIFIER_PROPERTY_MOVESPEED_MAX, 
			MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
			MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		}
end
function modifier_imba_shukuchi_debuff:GetModifierMoveSpeed_Absolute() return 100 end
function modifier_imba_shukuchi_debuff:GetModifierMoveSpeed_Limit() return 100 end
function modifier_imba_shukuchi_debuff:GetModifierMoveSpeed_Max() return 100 end
function modifier_imba_shukuchi_debuff:GetModifierTurnRate_Percentage() return -100 end
function modifier_imba_shukuchi_debuff:GetModifierPercentageCasttime() return -80 end
function modifier_imba_shukuchi_debuff:GetModifierAttackSpeedBonus_Constant() return -300 end
function modifier_imba_shukuchi_debuff:MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS() return -400 end
function modifier_imba_shukuchi_debuff:OnCreated(keys) 	
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	if IsServer() then

		self.pfx = ParticleManager:CreateParticle("particles/econ/items/omniknight/omniknight_fall20_immortal/omniknight_fall20_immortal_degen_aura_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.pfx, 0, self.parent:GetAbsOrigin())
		self:AddParticle(self.pfx, true, false, 15, false, false)
	end 
end
function modifier_imba_shukuchi_debuff:OnDestroy() 		
	if IsServer() then		
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end  
end	


imba_weaver_geminate_attack = class({})
LinkLuaModifier("modifier_imba_geminate_attack_passive", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_geminate_attack_time", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_illusion_order", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_geminate_attack_reduce_damage", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE)
function imba_weaver_geminate_attack:GetIntrinsicModifierName() return "modifier_imba_geminate_attack_passive" end
function imba_weaver_geminate_attack:IsHiddenWhenStolen() 		return true end
function imba_weaver_geminate_attack:IsStealable() 			return false end
function imba_weaver_geminate_attack:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_weaver_2") then 
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_weaver_2"))
	end
	return cooldown
end
--[[function imba_weaver_geminate_attack:OnSpellStart()
	self.caster = self:GetCaster()
	self.shukuchi = false
	--self.duration = self:GetSpecialValueFor("duration")
	self.caster:AddNewModifier(self.caster, self, "modifier_imba_geminate_attack_time", {})
end]]
function imba_weaver_geminate_attack:OnProjectileHit_ExtraData(target, pos, keys)
	if target then
		self.shukuchi = false	
		self:GetCaster():PerformAttack(target, true, true, true, false, false, false, false)
		self.shukuchi = true
		if self:GetCaster():TG_HasTalent("special_bonus_imba_weaver_5") and target:IsUnit() then
			local ability = self:GetCaster():FindAbilityByName("imba_weaver_the_swarm")
			local modifier = target:FindModifierByName("modifier_imba_the_swarm_debuff")
			if ability and ability:IsTrained() and not modifier then
				target:AddNewModifier(self:GetCaster(), ability, "modifier_imba_the_swarm_debuff", {duration = ability:GetSpecialValueFor("duration")})
			end	
		end	
		return	
	end						
end
modifier_imba_geminate_attack_time = class({})
function modifier_imba_geminate_attack_time:IsDebuff()				return false end
function modifier_imba_geminate_attack_time:IsHidden() 				return true end
function modifier_imba_geminate_attack_time:IsPurgable() 			return false end
function modifier_imba_geminate_attack_time:IsPurgeException() 	return false end


modifier_imba_geminate_attack_passive = class({})
function modifier_imba_geminate_attack_passive:IsDebuff()				return false end
function modifier_imba_geminate_attack_passive:IsHidden() 			return true end
function modifier_imba_geminate_attack_passive:IsPurgable() 			return false end
function modifier_imba_geminate_attack_passive:IsPurgeException() 	return false end
function modifier_imba_geminate_attack_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK, 
		MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_EVENT_ON_DEATH,
		}
end
function modifier_imba_geminate_attack_passive:OnRespawn(keys)
	if not IsServer() or keys.unit ~= self:GetCaster() then
		return
	end
	self:OnCreated(keys)
end
function modifier_imba_geminate_attack_passive:OnDeath(keys)
	if not IsServer() or keys.unit ~= self:GetCaster() then
		return
	end
	if self.parent:IsIllusion() then return end
	self.caster = self:GetCaster()
	local illusions = FindUnitsInRadius(
		self.caster:GetTeamNumber(), 
		self.caster:GetAbsOrigin(), 
		nil, 
		40000, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 
		FIND_ANY_ORDER, 
		false
	)			
	for i=1, #illusions do
		if illusions[i]:HasModifier("modifier_imba_illusion_order") then
			illusions[i]:ForceKill(false)
		end	
	end
end
function modifier_imba_geminate_attack_passive:OnAttack(keys)
	if not IsServer() then return end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if keys.no_attack_cooldown then return end
	if not keys.process_procs then return end
	if not self.ability:IsCooldownReady() then return end
	if self.caster:PassivesDisabled() then return end
	Timers:CreateTimer(self.delay, function()
		
			self.shot = true	
			self.info = 
			{
				Target = keys.target,
				Source = self.parent,
				Ability = self.ability,	
				EffectName = self.parent:GetRangedProjectileName(),
				iMoveSpeed = self.caster:GetProjectileSpeed(),
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
			self.info.int = self.shot
			if self.caster:HasModifier("modifier_imba_time_lapse_new") then
				Timers:CreateTimer(self.delay, function()
					ProjectileManager:CreateTrackingProjectile(self.info)
					return nil
				end)	
			end	
			ProjectileManager:CreateTrackingProjectile(self.info)
			self.caster:EmitSound("Hero_Weaver.Attack")
			self.shot = false
			if self.ability:IsCooldownReady() then
				self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(-1)) * self:GetParent():GetCooldownReduction())
			end	
		
		return nil
	end)			
end
function modifier_imba_geminate_attack_passive:OnCreated(keys) 	
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.delay = self.ability:GetSpecialValueFor("delay")
	self.stun_d = self.ability:GetSpecialValueFor("stun_d")
	self.stun_a = self.ability:GetSpecialValueFor("stun_a")
	if IsServer() then
		self.bool = false
		if not self.parent:IsIllusion() and self.parent:GetName() == "npc_dota_hero_weaver" then
			local modifier_illusions =
			{
				outgoing_damage=-100,
				incoming_damage=-100,
				bounty_base=0,
				bounty_growth=0,
				outgoing_damage_structure=0,
				outgoing_damage_roshan=0,
			}
			caster.illusions = CreateIllusions(caster, caster, modifier_illusions, 2, 0, false, false)
			for i=1, #caster.illusions do
				caster.illusions[i]:AddNewModifier(caster, self.ability, "modifier_imba_illusion_order", {int = i})
				caster.illusions[i]:AddNewModifier(caster, self.ability, "modifier_phased", {})
			end
			self.time = 0	
			self:StartIntervalThink(FrameTime())
		end		
	end 
end

function modifier_imba_geminate_attack_passive:OnIntervalThink(keys)
	self.time = self.time + FrameTime()
	if self.caster:IsStunned() or self.caster:IsHexed() or self.caster:IsDisarmed() then
		self.time = self.time + FrameTime()
		if self.time >= self.stun_d then
			self.parent:RemoveModifierByName("modifier_imba_geminate_attack_time")
			self.time = 0
		end
	else
		if not self.parent:HasModifier("modifier_imba_geminate_attack_time") and self.time >= self.stun_a then
			self.parent:AddNewModifier(self.parent, self.ability, "modifier_imba_geminate_attack_time", {})
			self.time = 0
		end	
	end		
end
modifier_imba_illusion_order = class({})
function modifier_imba_illusion_order:IsDebuff()				return true end
function modifier_imba_illusion_order:IsHidden() 			return true end
function modifier_imba_illusion_order:IsPurgable() 			return false end
function modifier_imba_illusion_order:IsPurgeException() 	return false end
function modifier_imba_illusion_order:GetModifierModelScale() 
	return 0 - 20 
end
function modifier_imba_illusion_order:CheckState()
	if not self.caster:HasScepter() and self.int == 2 then
		return 
			{
			[MODIFIER_STATE_COMMAND_RESTRICTED]	= true,
			[MODIFIER_STATE_ROOTED]	= true,
			[MODIFIER_STATE_DISARMED]	= true,
			[MODIFIER_STATE_INVULNERABLE]	= true,
			[MODIFIER_STATE_UNSELECTABLE]	= true,
			[MODIFIER_STATE_NOT_ON_MINIMAP]	= true,
			[MODIFIER_STATE_NO_HEALTH_BAR]	= true,
			[MODIFIER_STATE_INVISIBLE] = true,
			[MODIFIER_STATE_STUNNED] = true,
		}
	end		
	
		return 
			{
			[MODIFIER_STATE_COMMAND_RESTRICTED]	= true,
			[MODIFIER_STATE_ROOTED]	= not self.bool,
			[MODIFIER_STATE_DISARMED]	= not self.bool,
			[MODIFIER_STATE_INVULNERABLE]	= true,
			[MODIFIER_STATE_UNSELECTABLE]	= true,
			[MODIFIER_STATE_NOT_ON_MINIMAP]	= true,
			[MODIFIER_STATE_NO_HEALTH_BAR]	= true,
			[MODIFIER_STATE_INVISIBLE] = self.caster:IsInvisible(),
			}
end
function modifier_imba_illusion_order:DeclareFunctions()
	return { 
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
		}
end
function modifier_imba_illusion_order:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_imba_illusion_order:GetDisableAutoAttack() 
	return true  
end
function modifier_imba_illusion_order:GetModifierMoveSpeed_Limit() 
	return self.caster:GetMoveSpeedModifier(self.caster:GetBaseMoveSpeed(), true)
end
function modifier_imba_illusion_order:GetModifierMoveSpeed_AbsoluteMin() 
	return self.caster:GetMoveSpeedModifier(self.caster:GetBaseMoveSpeed(), true)
end
function modifier_imba_illusion_order:GetModifierMoveSpeed_AbsoluteMax() 
	return self.caster:GetMoveSpeedModifier(self.caster:GetBaseMoveSpeed(), true)
end
function modifier_imba_illusion_order:GetModifierInvisibilityLevel() 
	return 1
end
function modifier_imba_illusion_order:GetModifierAttackSpeedBonus_Constant() 
	return self.caster:GetDisplayAttackSpeed()
end
function modifier_imba_illusion_order:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self.parent or not keys.target:IsAlive() then
		return
	end
	self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_geminate_attack_reduce_damage", {int = self.int})
	self.caster:PerformAttack(keys.target, true, false, true, false, false, false, false)
	self.caster:RemoveModifierByName("modifier_imba_geminate_attack_reduce_damage")
end
function modifier_imba_illusion_order:OnCreated(keys) 	
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.delay = self.ability:GetSpecialValueFor("delay")
	if IsServer() then	
		self.int = keys.int
		self.delay = self.ability:GetSpecialValueFor("delay") * self.int
		self.bool = true
		self.sce = true
		self:StartIntervalThink(self.delay)	
	end 	
end	
function modifier_imba_illusion_order:OnIntervalThink(keys)
	if self.int == 1 then
		if self.caster:HasModifier("modifier_imba_geminate_attack_time") and not self.bool then
			self.bool = true
			self.parent:RemoveNoDraw()
			self.parent:SetAbsOrigin(self.caster:GetAbsOrigin())
		elseif 	not self.caster:HasModifier("modifier_imba_geminate_attack_time") and  self.bool then
			self.bool = false
			self.parent:AddNoDraw()
			self.parent:SetAbsOrigin(self.caster:GetAbsOrigin())
		end		
	end
	if self.caster:HasScepter() and self.int == 2 and not self.sce then
		if self.caster:HasModifier("modifier_imba_geminate_attack_time") and not self.bool then
			self.bool = true
			self.parent:RemoveNoDraw()
			self.parent:SetAbsOrigin(self.caster:GetAbsOrigin())
		elseif 	not self.caster:HasModifier("modifier_imba_geminate_attack_time") and  self.bool then
			self.bool = false
			self.parent:AddNoDraw()
			self.parent:SetAbsOrigin(self.caster:GetAbsOrigin())
		end		
	elseif not self.caster:HasScepter() and self.int == 2 then
		self.sce = true
		self.parent:AddNoDraw()
	elseif self.caster:HasScepter() and self.int == 2 and self.sce then	
		self.parent:RemoveNoDraw()
		self.sce = false
	end	
	if TG_Distance(self.parent:GetAbsOrigin(),self.caster:GetAbsOrigin()) > 400 then 
		self.parent:SetAbsOrigin(self.caster:GetAbsOrigin())
	end	
	if not self.caster:IsAlive() then
		self.parent:ForceKill(false)
	end			
end
function modifier_imba_illusion_order:OnOrder(keys)
	if not IsServer() then return end
	local caster = self:GetCaster()
	if keys.unit ~= caster then
		return
	end
	--PrintTable(keys)
	if 	keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
		Timers:CreateTimer(self.delay, function()
			self:GetParent():MoveToTargetToAttack(keys.target)
			return nil
		end)
	end	
	if 	keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		Timers:CreateTimer(self.delay, function()
			self:GetParent():MoveToPosition(keys.new_pos)
			return nil
		end)
	end	
	if 	keys.order_type == DDOTA_UNIT_ORDER_MOVE_TO_TARGET then
		Timers:CreateTimer(self.delay, function()
			self:GetParent():MoveToNPC(keys.target)
			return nil
		end)
	end	
	if 	keys.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE then
		Timers:CreateTimer(self.delay, function()
			self:GetParent():MoveToPositionAggressive(keys.new_pos)
			return nil
		end)
	end	
	if 	keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION or keys.order_type == DOTA_UNIT_ORDER_STOP then
		Timers:CreateTimer(self.delay, function()
			self:GetParent():Stop()
			return nil
		end)
	end			
end
modifier_imba_geminate_attack_reduce_damage = class({})

function modifier_imba_geminate_attack_reduce_damage:IsDebuff()				return true end
function modifier_imba_geminate_attack_reduce_damage:IsHidden() 			return true end
function modifier_imba_geminate_attack_reduce_damage:IsPurgable() 			return false end
function modifier_imba_geminate_attack_reduce_damage:IsPurgeException() 	return false end
function modifier_imba_geminate_attack_reduce_damage:DeclareFunctions() 
	return {
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
			} 
end
function modifier_imba_geminate_attack_reduce_damage:OnCreated(keys) 	
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.reduce_damage = self.ability:GetSpecialValueFor("reduce_damage") + self.caster:TG_GetTalentValue("special_bonus_imba_weaver_8")
	if IsServer() then	
		self.int = keys.int
		self.reduce_damage = -100 + (self.reduce_damage / self.int)
	end 	
end	
function modifier_imba_geminate_attack_reduce_damage:GetModifierTotalDamageOutgoing_Percentage()
  return self.reduce_damage
end

imba_weaver_time_lapse = class({})
LinkLuaModifier("modifier_imba_time_lapse_passive", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_time_lapse_debuff", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE) 
--LinkLuaModifier("modifier_imba_time_lapse_kill", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_time_lapse_pfx", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_time_lapse_new", "linken/hero_weaver", LUA_MODIFIER_MOTION_NONE)

function imba_weaver_time_lapse:GetIntrinsicModifierName() return "modifier_imba_time_lapse_passive" end
function imba_weaver_time_lapse:IsHiddenWhenStolen() 		return true end
function imba_weaver_time_lapse:IsStealable() 			return false end
function imba_weaver_time_lapse:OnSpellStart()
   	local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local pos = self:GetCursorPosition()
    local ability = caster:FindAbilityByName("imba_weaver_shukuchi")
    local illusions_number = self:GetSpecialValueFor("illusions_number")
    local duration = self:GetSpecialValueFor("duration")
	local modifier_illusions =
	{
		outgoing_damage=-100,
		incoming_damage=-100,
		bounty_base=0,
		bounty_growth=0,
		outgoing_damage_structure=0,
		outgoing_damage_roshan=0,
	}
	caster.illusions = CreateIllusions(caster, caster, modifier_illusions, illusions_number, 0, false, false)
	for i=1, #caster.illusions do
		caster.illusions[i]:AddNewModifier(caster, self, "modifier_imba_time_lapse_new", {duration = duration})
		if ability and ability:IsTrained() then
			caster.illusions[i]:AddNewModifier(caster, ability, "modifier_imba_shukuchi_buff", {duration = duration, bool = true})
		end	
		caster.illusions[i]:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
		local next_pos = caster:GetAbsOrigin() + RandomVector(400):Normalized() * RandomInt(50, 400)
		FindClearSpaceForUnit(caster.illusions[i], next_pos, false)
	end
	caster:AddNewModifier(caster, self, "modifier_imba_time_lapse_new", {duration = duration})
	local enemy = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		caster:GetAbsOrigin(), 
		nil, 
		40000, 
		DOTA_UNIT_TARGET_TEAM_BOTH, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
		FIND_ANY_ORDER, 
		false
	)
	for i=1, #enemy do
		EmitSoundOnClient("Imba.Hero_weaver.time_lapse_dazhao", enemy[i]:GetPlayerOwner())
	end
	--[[local enemy = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		caster:GetAbsOrigin(), 
		nil, 
		40000, 
		DOTA_UNIT_TARGET_TEAM_BOTH, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
		FIND_ANY_ORDER, 
		false
	)			
	for i=1, #enemy do
		EmitSoundOnClient("Imba.Hero_weaver.time_lapse_dazhao", enemy[i]:GetPlayerOwner())
		local next_pos = enemy[i]:GetAbsOrigin() + RandomVector(200):Normalized() * RandomInt(50, 200)
		FindClearSpaceForUnit(enemy[i], next_pos, false)
		enemy[i]:AddNewModifier(caster, self, "modifier_imba_time_lapse_pfx", {duration = 0.5})		
	end
	local pause_att = self:GetSpecialValueFor("pause_att")
	for i=1, #pause_att do
	    self.info = 
	    {
	        Target = target,
	        Source = caster,
	        Ability = self,	
	        EffectName = caster:GetRangedProjectileName(),
	        iMoveSpeed = caster:GetProjectileSpeed(),
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
	    ProjectileManager:CreateTrackingProjectile(self.info)	
	end         
    target:AddNewModifier(caster, self, "modifier_imba_time_lapse_kill", {duration = 1.5})
   
    local next_pos = caster:GetAbsOrigin()
    local pos = caster:GetAbsOrigin()
    local direction_1 = TG_Direction(target:GetAbsOrigin(),caster:GetAbsOrigin())
    --caster:SetBuyBackDisabledByReapersScythe(true)
    local pause_time = self:GetSpecialValueFor("pause_time")
    local pause_att = self:GetSpecialValueFor("pause_att")
    self.time = 0	
    for i=0, pause_time,FrameTime() do
        Timers:CreateTimer({
            useGameTime = false,
            endTime = i,
            callback = function()
                local ang = 360 / pause_time * i
                self.time = self.time + FrameTime()
                
                local next_pos = RotatePosition(target:GetAbsOrigin(), QAngle(0, ang, 0), target:GetAbsOrigin()-direction_1 * 400)
                local direction = TG_Direction(target:GetAbsOrigin(),next_pos)

                caster:SetOrigin(next_pos)
                caster:SetForwardVector(direction) 
                if self.time > pause_time/pause_att then
	                self.info = 
	                {
	                    Target = target,
	                    Source = caster,
	                    Ability = self,	
	                    EffectName = caster:GetRangedProjectileName(),
	                    iMoveSpeed = caster:GetProjectileSpeed(),
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
	                ProjectileManager:CreateTrackingProjectile(self.info)
	                self.time = 0
	            end                  

        end})   							
    end
    PauseGame(true)
		      
    Timers:CreateTimer({
        useGameTime = false,
        endTime = pause_time+FrameTime(),
        callback = function()
        	FindClearSpaceForUnit(caster, pos, false)
				local enemy = FindUnitsInRadius(
					caster:GetTeamNumber(), 
					caster:GetAbsOrigin(), 
					nil, 
					40000, 
					DOTA_UNIT_TARGET_TEAM_BOTH, 
					DOTA_UNIT_TARGET_HERO, 
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
					FIND_ANY_ORDER, 
					false
				)			
				for i=1, #enemy do
					local next_pos = enemy[i]:GetAbsOrigin() + RandomVector(200):Normalized() * RandomInt(50, 200)
					FindClearSpaceForUnit(enemy[i], next_pos, false)
					enemy[i]:AddNewModifier(caster, self, "modifier_imba_time_lapse_pfx", {duration = 0.5})
				end        	
            PauseGame(false)
        end
      })]]
end
--[[function imba_weaver_time_lapse:OnProjectileHit_ExtraData(target, pos, keys)
	if target then
        self:GetCaster():PerformAttack(target, true, true, true, false, false, false, false)
		return	
	end						
end]]
modifier_imba_time_lapse_new = class({})
function modifier_imba_time_lapse_new:IsDebuff()				return false end
function modifier_imba_time_lapse_new:IsHidden() 			return false end
function modifier_imba_time_lapse_new:IsPurgable() 			return false end
function modifier_imba_time_lapse_new:IsPurgeException() 	return false end
function modifier_imba_time_lapse_new:GetStatusEffectName()
	if self.parent:IsIllusion() then
  		return "particles/units/heroes/hero_phantom_lancer/status_effect_phantom_illstrong.vpcf"
  	end	
end
function modifier_imba_time_lapse_new:StatusEffectPriority()
	if self.parent:IsIllusion() then
  		return 10001
  	end	
end
function modifier_imba_time_lapse_new:CheckState() 
	if self.parent:IsIllusion() then
		return 
		{
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_COMMAND_RESTRICTED]	= true,
			[MODIFIER_STATE_NO_HEALTH_BAR]	= true,
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			} 
	end	
end
function modifier_imba_time_lapse_new:OnCreated(keys) 	
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.range = self.ability:GetSpecialValueFor("range")
	if IsServer() then
		if not self.parent:IsIllusion() then
			return
		end	
		self.target = self.caster
		self.target_pos = self.caster:GetAbsOrigin()
		self.target_pos_next = self.target_pos + TG_Direction(self.target_pos,self.parent:GetAbsOrigin()) * 700
		self.move = false
		local enemy = FindUnitsInRadius(
			self.caster:GetTeamNumber(), 
			self.caster:GetAbsOrigin(), 
			nil, 
			self.range, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false
		)
		for i=1, #enemy do
			self.target = enemy[i]
			self.target_pos = enemy[i]:GetAbsOrigin()
			self.target_pos_next = self.target_pos + TG_Direction(self.target_pos,self.parent:GetAbsOrigin()) * 700
			break
		end	
		self:StartIntervalThink(0.1)	
	end 
end
function modifier_imba_time_lapse_new:OnIntervalThink(keys)
	if self.target and self.target_pos and not self.move and TG_Distance(self.parent:GetAbsOrigin(),self.target_pos_next) > 100 then
		self:GetParent():MoveToPosition(self.target_pos_next)
		self.move = true
	end
	if TG_Distance(self.parent:GetAbsOrigin(),self.target_pos_next) <= 100 then	
		self:OnCreated()
	end	
end
function modifier_imba_time_lapse_new:OnDestroy() 		
	if IsServer() then		

	end  
end	
modifier_imba_time_lapse_debuff = class({})
function modifier_imba_time_lapse_debuff:IsDebuff()				return false end
function modifier_imba_time_lapse_debuff:IsHidden() 			return true end
function modifier_imba_time_lapse_debuff:IsPurgable() 			return false end
function modifier_imba_time_lapse_debuff:IsPurgeException() 	return false end
function modifier_imba_time_lapse_debuff:OnCreated(keys) 	
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.distance_min = self.ability:GetSpecialValueFor("distance_min")
	self.stun_d = self.ability:GetSpecialValueFor("stun_d")
	if IsServer() then	
		self.ab = true
		self.distance = TG_Distance(self.parent:GetAbsOrigin(),self.caster:GetAbsOrigin())	
	end 	
end
function modifier_imba_time_lapse_debuff:OnDestroy()	
	self.ability = nil
	self.caster = nil
	self.parent = nil
	if IsServer() then	
		self.distance =nil
		self.ab = nil	
	end 	
end
function modifier_imba_time_lapse_debuff:DeclareFunctions() 
    return 
    {
        MODIFIER_EVENT_ON_ABILITY_START,
   	} 
end	
function modifier_imba_time_lapse_debuff:OnAbilityStart(keys)
	if not IsServer() then
		return 0
	end
	if self.distance < self.distance_min and self.ab then	
		local ability_caster = keys.ability:GetCaster()
		if keys.target == self.caster and IsEnemy(ability_caster,self.caster) and ability_caster == self.parent then
			ability_caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun_d})
			local cd = (keys.ability:GetCooldown(keys.ability:GetLevel() - 1)) * ability_caster:GetCooldownReduction()
			if cd == nil or cd == 0 then
				cd = 25
			end	
			keys.ability:StartCooldown(cd)
			ability_caster:Stop()
			ability_caster:AddNewModifier(self.caster, self.ability, "modifier_imba_time_lapse_pfx", {duration = 0.5})
			local caster_pos = self.caster:GetAbsOrigin()
			local target_pos = ability_caster:GetAbsOrigin()
			FindClearSpaceForUnit(ability_caster, caster_pos, false)
			FindClearSpaceForUnit(self.caster, target_pos, false)
			self.caster:SetForwardVector(TG_Direction(caster_pos,target_pos))
			self.caster:MoveToTargetToAttack(ability_caster)
			self.ab = false		
		end
	end		
end
modifier_imba_time_lapse_passive = class({})
function modifier_imba_time_lapse_passive:IsDebuff()			return false end
function modifier_imba_time_lapse_passive:IsHidden() 			return true end
function modifier_imba_time_lapse_passive:IsPurgable() 			return false end
function modifier_imba_time_lapse_passive:IsPurgeException() 	return false end
function modifier_imba_time_lapse_passive:IsAura()
	return true
end
function modifier_imba_time_lapse_passive:GetAuraDuration() return 0.1 end
function modifier_imba_time_lapse_passive:GetModifierAura() return "modifier_imba_time_lapse_debuff" end
function modifier_imba_time_lapse_passive:IsAuraActiveOnDeath() 		return false end
function modifier_imba_time_lapse_passive:GetAuraRadius() 	
	return self.distance_max 
end
function modifier_imba_time_lapse_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_time_lapse_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_time_lapse_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_imba_time_lapse_passive:GetAuraEntityReject(hTarget)	
	return not self:GetAbility():IsTrained()
end

function modifier_imba_time_lapse_passive:OnCreated(keys) 	
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.time_lapse = self.ability:GetSpecialValueFor("time_lapse")
	self.time_hp = self.ability:GetSpecialValueFor("time_hp")
	self.distance_max = self.ability:GetSpecialValueFor("distance_max")

	if IsServer() then	
		self.hp = self.caster:GetHealth()
		self.mp = self.caster:GetMana()
		self:StartIntervalThink(self.time_lapse)	
	end 	
end	
function modifier_imba_time_lapse_passive:OnIntervalThink(keys)
	local hp = self.caster:GetHealth()
	local mp = self.caster:GetMana()

	if self.hp > hp and self.parent:IsAlive() then
		local hp_heal = (self.hp - hp) * self.time_hp / 100
		self.caster:Heal(hp_heal, self.caster)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.caster, hp_heal, nil)
		EmitSoundOn("Hero_Weaver.TimeLapse",self:GetCaster())
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_weaver/weaver_timelapse.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.pfx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 2, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 60, Vector(math.random(1,255), math.random(1,255), math.random(1,255)))
		ParticleManager:SetParticleControl(self.pfx, 61, Vector(1, 0, 0))
		ParticleManager:ReleaseParticleIndex(self.pfx)
				
	end
	self.hp = self.caster:GetHealth()

	if self.mp > mp and self.caster:TG_HasTalent("special_bonus_imba_weaver_4") and self.parent:IsAlive() then
		local mp_heal = (self.mp - mp) * self.time_hp / 100
		self.caster:GiveMana(mp_heal)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self.caster, mp_heal, nil)
	end
	self.hp = self.caster:GetHealth()
	self.mp = self.caster:GetMana()		
end
--[[modifier_imba_time_lapse_kill = class({})
function modifier_imba_time_lapse_kill:IsDebuff()			return true end
function modifier_imba_time_lapse_kill:IsHidden() 			return true end
function modifier_imba_time_lapse_kill:IsPurgable() 		return false end
function modifier_imba_time_lapse_kill:IsPurgeException() 	return false end
--function modifier_imba_time_lapse_kill:RemoveOnDeath() 		return false end

function modifier_imba_time_lapse_kill:OnDestroy() 		
	if IsServer() then		
		if self:GetDuration() > self:GetElapsedTime() and self:GetCaster():TG_HasTalent("special_bonus_imba_weaver_1") then	
			self:GetParent():SetBuyBackDisabledByReapersScythe(true)
		end	
	end  
end]]
modifier_imba_time_lapse_pfx = class({})
function modifier_imba_time_lapse_pfx:IsDebuff()			return true end
function modifier_imba_time_lapse_pfx:IsHidden() 			return true end
function modifier_imba_time_lapse_pfx:IsPurgable() 		return false end
function modifier_imba_time_lapse_pfx:IsPurgeException() 	return false end
function modifier_imba_time_lapse_pfx:OnCreated(keys) 	
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	if IsServer() then		
		EmitSoundOnClient("Imba.Hero_weaver.time_lapse_shishan", self:GetParent():GetPlayerOwner())
		self.pfx = ParticleManager:CreateParticleForPlayer("particles/heros/weaver/time_lapse.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent(),self:GetParent():GetPlayerOwner())
		self:AddParticle(self.pfx, true, false, 15, false, false)    	
	end 	
end
function modifier_imba_time_lapse_pfx:OnDestroy() 		
	if IsServer() then		
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end  
end	