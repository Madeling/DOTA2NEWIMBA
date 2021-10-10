------2021.01.09--by--你收拾收拾准备出林肯吧
CreateTalents("npc_dota_hero_bloodseeker", "linken/hero_bloodseeker")
imba_bloodseeker_bloodrage = class({})
LinkLuaModifier("modifier_imba_bloodrage", "linken/hero_bloodseeker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_bloodseeker_bloodrage:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local target = self:GetCursorTarget()
	if target:TG_TriggerSpellAbsorb(self) then
		return
	end
	if IsEnemy(caster, target) then	
		target:AddNewModifier_RS(caster, self, "modifier_imba_bloodrage", {duration = duration})
	else
		target:AddNewModifier(caster, self, "modifier_imba_bloodrage", {duration = duration})
	end	

	--caster:RemoveModifierByName("modifier_imba_thirst")
	--local ability2 = caster:FindAbilityByName("imba_bloodseeker_thirst")
	--caster:AddNewModifier(caster, ability2, "modifier_imba_thirst", {})

	EmitSoundOn("hero_bloodseeker.bloodRage", target)			
end
modifier_imba_bloodrage = class({})

function modifier_imba_bloodrage:IsDebuff()				return IsEnemy(self:GetCaster(),self:GetParent()) end
function modifier_imba_bloodrage:IsHidden() 			return false end
function modifier_imba_bloodrage:IsPurgable() 			return IsEnemy(self:GetCaster(),self:GetParent()) end
function modifier_imba_bloodrage:IsPurgeException() 	return IsEnemy(self:GetCaster(),self:GetParent()) end
function modifier_imba_bloodrage:OnCreated()
	self.attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_bloodseeker_1")
	self.spell_amp = self:GetAbility():GetSpecialValueFor("spell_amp") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_bloodseeker_5")
	self.damage_pct = 0
	if IsEnemy(self:GetCaster(),self:GetParent()) then
		self.damage_pct = self:GetAbility():GetSpecialValueFor("damage_pct") * 0.01 / 2 * self:GetParent():GetMaxHealth() * 2
	end	
	if IsServer() then
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())			
		self:StartIntervalThink(0.5)
	end
end
function modifier_imba_bloodrage:OnRefresh()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle( self.pfx, true )
			ParticleManager:ReleaseParticleIndex( self.pfx )
		end			
		self:OnCreated()
	end
end
function modifier_imba_bloodrage:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle( self.pfx, true )
			ParticleManager:ReleaseParticleIndex( self.pfx )
		end	
	end	
end
function modifier_imba_bloodrage:OnIntervalThink()	
	local caster = self:GetCaster()
	local parent = self:GetParent()	
	local damageTable = {
		attacker = caster, 
		victim = parent, 
		damage = self.damage_pct, 
		ability = self:GetAbility(), 
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
		}	
	ApplyDamage(damageTable)
end
function modifier_imba_bloodrage:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,

   	} 
end
function modifier_imba_bloodrage:CheckState() return {[MODIFIER_STATE_SILENCED] = IsEnemy(self:GetCaster(),self:GetParent())} end
function modifier_imba_bloodrage:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end	
	if keys.target:IsBuilding() or not keys.target:IsAlive() or keys.target:IsBoss() then
		return 
	end
	if not self:GetCaster():Has_Aghanims_Shard() then
		return
	end
	if IsEnemy(keys.attacker, self:GetCaster())	then
		return
	end	
	if not keys.target:IsUnit() then
		return
	end
	local damage_shard = self:GetAbility():GetSpecialValueFor("damage_shard") * keys.target:GetMaxHealth() * 0.01
	local move_shard = self:GetAbility():GetSpecialValueFor("move_shard") * keys.target:GetMoveSpeedModifier(keys.target:GetBaseMoveSpeed(), true) * 0.01
	local damageTable = {
						victim = keys.target,
						attacker = keys.attacker,
						damage = damage_shard + move_shard,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						ability = self:GetAbility(),
						}
	ApplyDamage(damageTable)
	self:GetParent():Heal(damage_shard + move_shard, self:GetCaster())
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.attacker, damage_shard + move_shard, nil)    
    --local lifesteal_particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    --ParticleManager:ReleaseParticleIndex(lifesteal_particle)	
end
function modifier_imba_bloodrage:GetModifierSpellAmplify_Percentage()
	if IsEnemy(self:GetCaster(),self:GetParent())  then
  		return 0
  	else 
  		return self.spell_amp
  	end	
  	return 0
end
function modifier_imba_bloodrage:GetModifierAttackSpeedBonus_Constant()
	if IsEnemy(self:GetCaster(),self:GetParent()) then
  		return 0
  	else
  		return self.attack_speed
  	end
  	return 0	
end

imba_bloodseeker_blood_bath = class({})
LinkLuaModifier("modifier_imba_blood_bath", "linken/hero_bloodseeker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_blood_bath_thinker", "linken/hero_bloodseeker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_bloodseeker_blood_bath:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_bloodseeker_4") then 
		return (cooldown - caster:TG_GetTalentValue("special_bonus_imba_bloodseeker_4"))
	end
	return cooldown
end
function imba_bloodseeker_blood_bath:GetAOERadius()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius") --+  self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_6")	
	return radius		 
end
function imba_bloodseeker_blood_bath:OnSpellStart()
	local caster = 			self:GetCaster()
	local pos = 			self:GetCursorPosition()
	self.radius = 			self:GetSpecialValueFor("radius")
	self.silence_duration = self:GetSpecialValueFor("silence_duration")
	self.damage = 			self:GetSpecialValueFor("damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_bloodseeker_2")
	self.delay = 			self:GetSpecialValueFor("delay") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_bloodseeker_6")
	self.delay_int = 		self:GetSpecialValueFor("delay_int")
	local duration = self.delay * self.delay_int
	self.radius_int = 		self:GetSpecialValueFor("radius_int")
	self.dummy = CreateModifierThinker(
				caster, 
				self,
				"modifier_imba_blood_bath_thinker", 
				{
					duration = duration,
					silence_duration = self.silence_duration,
					radius = self.radius,
					damage = self.damage,
					delay = self.delay,
					delay_int = self.delay_int,
					radius_int = self.radius_int,
				}, 
				pos,
				self:GetCaster():GetTeamNumber(),
				false
				)
	EmitSoundOn("Hero_Bloodseeker.BloodRite.Cast", caster)					
end
modifier_imba_blood_bath_thinker  = class({})

function modifier_imba_blood_bath_thinker:OnCreated(keys)
	self.silence_duration = keys.silence_duration
	self.radius = keys.radius
	self.damage = keys.damage
	self.delay = keys.delay
	self.delay_int = keys.delay_int
	self.radius_int = keys.radius_int
	if IsServer() then
		self.delay_n = 0
		self.pos = self:GetParent():GetAbsOrigin()
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self.pos)	
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.radius,self.radius,self.radius))
		ParticleManager:SetParticleControl(self.pfx, 60, Vector(255,0,0))	
		ParticleManager:SetParticleControl(self.pfx, 61, Vector(0,0,0))
		EmitSoundOnLocationWithCaster( self.pos, "Hero_Bloodseeker.BloodRite", self:GetParent() )
		self:StartIntervalThink( self.delay_int )			
	end
end
function modifier_imba_blood_bath_thinker:OnIntervalThink()
	local caster = self:GetCaster()
	self.pos = self:GetParent():GetAbsOrigin()
	self.delay_n = self.delay_n + 1
	self.radius = self.radius + self.radius_int
	--DebugDrawCircle(self:GetParent():GetAbsOrigin(), Vector(255,0,0), 100, 50, true, 0.5)
	if self.pfx then
		ParticleManager:DestroyParticle( self.pfx, false )
		ParticleManager:ReleaseParticleIndex( self.pfx )
	end	
	local enemy = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		self:GetParent():GetAbsOrigin(), 
		nil, 
		self.radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
		)
	for i=1, #enemy do
		TG_AddNewModifier_RS(enemy[i], caster, self:GetAbility(), "modifier_imba_blood_bath", {duration = self.silence_duration})
		local move_shard = self:GetAbility():GetSpecialValueFor("move_shard") * enemy[i]:GetMoveSpeedModifier(enemy[i]:GetBaseMoveSpeed(), true) * 0.01
		local damageTable = {
			attacker = caster, 
			victim = enemy[i], 
			damage = self.damage+move_shard, 
			ability = self:GetAbility(), 
			damage_type = self:GetAbility():GetAbilityDamageType()
			}		
		ApplyDamage(damageTable)
		--EmitSoundOnLocationWithCaster( enemy[i]:GetAbsOrigin(), "hero_bloodseeker.bloodRite.silence", caster )
	end	
	if 	self.delay_n >= self.delay then
		self:StartIntervalThink( -1 )
		self:Destroy()
		return
	end
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.pfx, 0, self.pos)	
	ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.radius,self.radius,self.radius))
	ParticleManager:SetParticleControl(self.pfx, 60, Vector(255,0,0))	
	ParticleManager:SetParticleControl(self.pfx, 61, Vector(0,0,0))
	--EmitSoundOnLocationWithCaster( self.pos, "Hero_Bloodseeker.BloodRite", self:GetParent() )	

	--self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin())
end
function modifier_imba_blood_bath_thinker:OnDestroy()
	if not IsServer() then return end
	if self.pfx then
		ParticleManager:DestroyParticle( self.pfx, false )
		ParticleManager:ReleaseParticleIndex( self.pfx )
	end	
	--UTIL_Remove( self:GetParent() )
	self:GetParent():RemoveSelf()
end
modifier_imba_blood_bath = class({})

function modifier_imba_blood_bath:IsDebuff()			return true end
function modifier_imba_blood_bath:IsHidden() 			return false end
function modifier_imba_blood_bath:IsPurgable() 			return true end
function modifier_imba_blood_bath:IsPurgeException() 	return true end
function modifier_imba_blood_bath:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


imba_bloodseeker_thirst = class({})
LinkLuaModifier("modifier_imba_thirst", "linken/hero_bloodseeker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_thirst_invis", "linken/hero_bloodseeker.lua", LUA_MODIFIER_MOTION_NONE) 

function imba_bloodseeker_thirst:GetIntrinsicModifierName()
  return "modifier_imba_thirst"
end
function imba_bloodseeker_thirst:OnOwnerDied()
	self.toggle = self:GetToggleState()
end

function imba_bloodseeker_thirst:OnOwnerSpawned()
	if self.toggle == nil then
		self.toggle = false
	end
	if self.toggle ~= self:GetToggleState() then
		self:ToggleAbility()
	end
end

function imba_bloodseeker_thirst:OnToggle()
	self.toggle = self:GetToggleState()
end

modifier_imba_thirst = class({})
function modifier_imba_thirst:IsDebuff()			return false end
function modifier_imba_thirst:IsHidden() 			return false end
function modifier_imba_thirst:IsPurgable() 			return false end
function modifier_imba_thirst:IsPurgeException() 	return false end
function modifier_imba_thirst:OnCreated()
	self.move_damage = self:GetAbility():GetSpecialValueFor("move_damage")
	self.move = self:GetAbility():GetSpecialValueFor("move")
	self.half_bonus_aoe = self:GetAbility():GetSpecialValueFor("half_bonus_aoe")
	self.invis_threshold_pct = self:GetAbility():GetSpecialValueFor("invis_threshold_pct") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_bloodseeker_7")
	self.hero_kill_heal = self:GetAbility():GetSpecialValueFor("hero_kill_heal")
	if IsServer() then
		self.target = nil
		self.move_speed = 0		
		self.stack = 0
		if self:GetCaster():GetTeam() == DOTA_TEAM_GOODGUYS then
			self.team =  DOTA_TEAM_BADGUYS
		else
			self.team = DOTA_TEAM_GOODGUYS
		end
		self:StartIntervalThink(0.2)
	end
end
function modifier_imba_thirst:OnRefresh()
	self:OnCreated()
end
function modifier_imba_thirst:OnIntervalThink()	
	local caster = self:GetCaster()
	local enemy = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		self:GetParent():GetAbsOrigin(), 
		nil, 
		30000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
		FIND_ANY_ORDER, 
		false
		)
	for i=1, #enemy do
		if enemy[i]:GetHealth() / enemy[i]:GetMaxHealth() > 0.5 and enemy[i]:IS_TrueHero_TG() then
			self.stack = self.stack + 1
		end
	end
	self:SetStackCount(self.stack)
	self.stack = 0
	if self:GetParent():PassivesDisabled() then
		self:SetStackCount(0)
	end
end
function modifier_imba_thirst:GetModifierMoveSpeedBonus_Percentage()
	if self:GetAbility():GetToggleState() then
    	return self:GetStackCount() * self.move
    end	
    return math.max((10 - self:GetStackCount()),0) * self.move
end
function modifier_imba_thirst:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetAbility():GetToggleState() then
    	return math.max((10 - self:GetStackCount()),0) * self.move_damage
    end		
    return self:GetStackCount() * self.move_damage 
end
function modifier_imba_thirst:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
   	} 
end
function modifier_imba_thirst:OnDeath(keys)
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local unit = keys.unit
	if TG_Distance(unit:GetAbsOrigin(), caster:GetAbsOrigin()) > self.half_bonus_aoe then
		return
	end
	if self:GetParent():IsIllusion() then
		return
	end
	if unit:IsBoss() then
		return
	end	
	if unit:IsIllusion() then
		return
	end
	if not unit:IsUnit() then
		return
	end	
	if unit == caster then
		return
	end	
	self:GetParent():Heal(unit:GetMaxHealth() * self.hero_kill_heal * 0.01, self:GetParent())	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), unit:GetMaxHealth() * self.hero_kill_heal * 0.01, nil) 
end	
function modifier_imba_thirst:GetModifierIgnoreMovespeedLimit() return 1 end
function modifier_imba_thirst:IsAura()				return true end
function modifier_imba_thirst:GetAuraDuration() 	return 0.1 end
function modifier_imba_thirst:GetModifierAura() 	return "modifier_imba_thirst_invis" end
function modifier_imba_thirst:IsAuraActiveOnDeath() return false end
function modifier_imba_thirst:GetAuraRadius() 		return 30000 end
function modifier_imba_thirst:GetAuraSearchFlags() 	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_thirst:GetAuraSearchTeam() 	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_thirst:GetAuraSearchType() 	return DOTA_UNIT_TARGET_HERO end
function modifier_imba_thirst:GetAuraEntityReject(hTarget)	
	--if not self:GetAbility():IsTrained() or self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() or not hTarget:IS_TrueHero_TG() or not hTarget then
		if hTarget:GetHealth() / hTarget:GetMaxHealth() * 100 > self.invis_threshold_pct  then
			return true	
		else
			return false	
		end	
	--end	
end

modifier_imba_thirst_invis = class({})
function modifier_imba_thirst_invis:IsDebuff()			return true end
function modifier_imba_thirst_invis:IsHidden() 			return false end
function modifier_imba_thirst_invis:IsPurgable() 		return false end
function modifier_imba_thirst_invis:IsPurgeException() 	return false end
function modifier_imba_thirst_invis:CheckState()
	return {[MODIFIER_STATE_INVISIBLE] = false } 
end
function modifier_imba_thirst_invis:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_thirst_invis:GetModifierProvidesFOWVision() 
	return 1	 
end
function modifier_imba_thirst_invis:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
   	} 
end


imba_bloodseeker_rupture = class({})
LinkLuaModifier("modifier_imba_rupture", "linken/hero_bloodseeker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rupture_kill", "linken/hero_bloodseeker.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_rupture_scepter", "linken/hero_bloodseeker.lua", LUA_MODIFIER_MOTION_NONE) 
function imba_bloodseeker_rupture:GetIntrinsicModifierName() return "modifier_imba_rupture_scepter" end
function imba_bloodseeker_rupture:GetCastRange() return self:GetSpecialValueFor("cast_range_1") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_bloodseeker_3") end
function imba_bloodseeker_rupture:OnSpellStart(scepter)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TG_TriggerSpellAbsorb(self) then
		return
	end	
	local duration = self:GetSpecialValueFor("duration")
	target:AddNewModifier_RS(caster, self, "modifier_imba_rupture", {duration = duration})	
	--target:AddNewModifier(caster, self, "modifier_bloodseeker_rupture", {duration = duration})
				
end
modifier_imba_rupture = class({})
function modifier_imba_rupture:IsDebuff()			return true end
function modifier_imba_rupture:IsHidden() 			return false end
function modifier_imba_rupture:IsPurgable() 		return false end
function modifier_imba_rupture:IsPurgeException() 	return false end
function modifier_imba_rupture:GetStatusEffectName()
  return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end
function modifier_imba_rupture:DeclareFunctions() 
    return 
    {
        --MODIFIER_EVENT_ON_UNIT_MOVED,
        MODIFIER_PROPERTY_DISABLE_HEALING,
   	} 
end
--[[function modifier_imba_rupture:OnUnitMoved(keys)
	if not IsServer() then
		return
	end
	if keys.unit == self:GetParent() then
		self.a = self.a + 0.06
		self:SetStackCount(self.int-self.a)
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(math.floor(self:GetStackCount() / 10 % 10), self:GetStackCount() % 10, 0))
		if self:GetStackCount() <= 0 then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_rupture_kill", {duration = 1.5})
			self.a = 0
			self:SetStackCount(self.int)
			ParticleManager:SetParticleControl(self.pfx, 1, Vector(math.floor(self:GetStackCount() / 10 % 10), self:GetStackCount() % 10, 0))
		end	
	end
end]]

function modifier_imba_rupture:GetDisableHealing()
	if self:GetCaster():TG_HasTalent("special_bonus_imba_bloodseeker_8") and IsEnemy(self:GetCaster(),self:GetParent()) and self:GetElapsedTime()<=self:GetCaster():TG_GetTalentValue("special_bonus_imba_bloodseeker_8") then
    	return  1
    else
    	return 	0
    end		
end
function modifier_imba_rupture:OnCreated(keys)	
	self.movement_damage_pct = self:GetAbility():GetSpecialValueFor("movement_damage_pct") / 5
	self.int = self:GetAbility():GetSpecialValueFor("int")
	if IsServer() then
		self.a = 0
		self:SetStackCount(self.int)	
		self.pfx = ParticleManager:CreateParticle("particles/creatures/shadow_demon/creature_shadow_poison_stackui.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(math.floor(self:GetStackCount() / 10 % 10), self:GetStackCount() % 10, 0))
		self:AddParticle(self.pfx, false, false, -1, false, false)
		EmitSoundOn("hero_bloodseeker.rupture.cast", self:GetCaster())
		EmitSoundOn("hero_bloodseeker.rupture", self:GetParent())
		local damageTable = {
			attacker = self:GetCaster(), 
			victim = self:GetParent(), 
			damage = self:GetParent():GetHealth() * self:GetAbility():GetSpecialValueFor("hp_pct") * 0.01, 
			ability = self:GetAbility(), 
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS
			}		
		ApplyDamage(damageTable)
		self.pos = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(0.2)		
	end
end
function modifier_imba_rupture:OnIntervalThink()
	local new_pos = self:GetParent():GetAbsOrigin()
	if new_pos ~= self.pos then
		self.a = self.a + 0.5
		self:SetStackCount(self.int-self.a)
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(math.floor(self:GetStackCount() / 10 % 10), self:GetStackCount() % 10, 0))
		if self:GetStackCount() <= 0 then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_rupture_kill", {duration = 1.5})
			self.a = 0
			self:SetStackCount(self.int)
			ParticleManager:SetParticleControl(self.pfx, 1, Vector(math.floor(self:GetStackCount() / 10 % 10), self:GetStackCount() % 10, 0))
		end			
	end	
	self.pos = new_pos
	local damageTable = {
		attacker = self:GetCaster(), 
		victim = self:GetParent(), 
		damage = self.movement_damage_pct, 
		ability = self:GetAbility(), 
		damage_type = self:GetAbility():GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS
		}		
	ApplyDamage(damageTable)	
end

function modifier_imba_rupture:OnDestroy()
	if not IsServer() then return end
	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end		
	self.pos = nil
end
modifier_imba_rupture_kill = class({})
function modifier_imba_rupture_kill:IsDebuff()			return true end
function modifier_imba_rupture_kill:IsHidden() 			return true end
function modifier_imba_rupture_kill:IsPurgable() 		return false end
function modifier_imba_rupture_kill:IsPurgeException() 	return false end
function modifier_imba_rupture_kill:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_imba_rupture_kill:GetOverrideAnimation() return ACT_DOTA_DISABLED end
function modifier_imba_rupture_kill:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_imba_rupture_kill:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_rupture_kill:ShouldUseOverheadOffset() return true end
function modifier_imba_rupture_kill:OnCreated(keys)	
	if IsServer() then
	   	local fx = ParticleManager:CreateParticle("particles/heros/axe/axe_cb_ms.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
	    ParticleManager:SetParticleControlForward(fx, 0, self:GetParent():GetForwardVector())
	    ParticleManager:SetParticleControlEnt(fx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc",self:GetParent():GetAbsOrigin(), false)
	    ParticleManager:SetParticleControlEnt(fx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
	    ParticleManager:SetParticleControlEnt(fx, 4, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
	    ParticleManager:ReleaseParticleIndex(fx)

		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())	
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(300,300,300))
		ParticleManager:SetParticleControl(self.pfx, 60, Vector(255,0,0))	
		ParticleManager:SetParticleControl(self.pfx, 61, Vector(0,0,0))

		EmitSoundOn("hero_bloodseeker.rupture", self:GetParent())
	end
end

function modifier_imba_rupture_kill:OnDestroy()
	if not IsServer() then return end
	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end		
	local damageTable = {
		attacker = self:GetCaster(), 
		victim = self:GetParent(), 
		damage = self:GetParent():GetHealth() / 2, 
		ability = self:GetAbility(), 
		damage_type = self:GetAbility():GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
		}		
	ApplyDamage(damageTable)
end
modifier_imba_rupture_scepter = class({})

function modifier_imba_rupture_scepter:IsDebuff()			return false end
function modifier_imba_rupture_scepter:IsHidden() 			return true end
function modifier_imba_rupture_scepter:IsPurgable() 		return false end
function modifier_imba_rupture_scepter:IsPurgeException() 	return false end

function modifier_imba_rupture_scepter:OnCreated()
	if not IsServer() then return end
	if not self:GetParent():IsIllusion() then
		AbilityChargeController:AbilityChargeInitialize(self:GetAbility(), self:GetAbility():GetCooldown(4 - 1), 1, 1, true, true)
		self:StartIntervalThink(0.5)
	end
end

function modifier_imba_rupture_scepter:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():HasScepter() then
		AbilityChargeController:ChangeChargeAbilityConfig(self:GetAbility(), self:GetAbility():GetCooldown(4 - 1), 2, 1, true, true)
	else
		AbilityChargeController:ChangeChargeAbilityConfig(self:GetAbility(), self:GetAbility():GetCooldown(4 - 1), 1, 1, true, true)
	end
end
