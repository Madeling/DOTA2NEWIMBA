CreateTalents("npc_dota_hero_pangolier", "linken/hero_pangolier")
--1/11 2020
--Swashbuckle------
-------------------
imba_pangolier_swashbuckle = class({})

LinkLuaModifier("modifier_imba_swashbuckle_dash","linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_swashbuckle_chargedtime","linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_swashbuckle_chargedattack","linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_swashbuckle_chargedattack_int","linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)

function imba_pangolier_swashbuckle:IsHiddenWhenStolen() 	return false end
function imba_pangolier_swashbuckle:IsRefreshable() 		return true  end
function imba_pangolier_swashbuckle:IsStealable()			return true end
function imba_pangolier_swashbuckle:GetBehavior()
	if self:GetCaster():TG_HasTalent("special_bonus_imba_pangolier_5") and not self:GetCaster():HasModifier("modifier_imba_swashbuckle_chargedattack") then  
		return  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end 
function imba_pangolier_swashbuckle:GetAbilityTextureName()  
	if self:GetCaster():HasModifier("modifier_imba_swashbuckle_chargedtime") then 	
		return "pangolier_heartpiercer" 
	else
		return	"pangolier_swashbuckle"
	end	
end
function imba_pangolier_swashbuckle:GetManaCost(a) 
	if self:GetCaster():HasModifier("modifier_imba_swashbuckle_chargedtime") then  
		return 0	
	end
	return 90 
end
function imba_pangolier_swashbuckle:GetCastRange() if IsClient() then return self:GetSpecialValueFor("range") end end
function imba_pangolier_swashbuckle:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
		if caster:TG_HasTalent("special_bonus_imba_pangolier_2") then 
			return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_pangolier_2"))
		end
	return cooldown
end

function imba_pangolier_swashbuckle:OnSpellStart() 
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("imba_pangolier_shield_crash")
	if ability and ability:IsTrained() then
		ability.pos = caster:GetAbsOrigin()
	end
	local direction = (self:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
	direction.z = 0.0
	local pos = (self:GetCursorPosition() - caster:GetAbsOrigin()):Length2D() <= (self:GetSpecialValueFor("range")) and self:GetCursorPosition() or caster:GetAbsOrigin() + direction * (self:GetSpecialValueFor("range"))
	local duration = (caster:GetAbsOrigin() - pos):Length2D() / (self:GetSpecialValueFor("dash_speed"))
	if not caster:HasModifier("modifier_imba_swashbuckle_chargedtime") then
		caster:AddNewModifier(caster, self, "modifier_imba_swashbuckle_dash", {duration = duration, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
		caster:EmitSound("Hero_Pangolier.Swashbuckle.Cast")
		ProjectileManager:ProjectileDodge(caster)

		local charged_time = self:GetSpecialValueFor("charged_time")
		caster:AddNewModifier(caster, self, "modifier_imba_swashbuckle_chargedtime", {duration = charged_time})
		self:EndCooldown()
	else
		self:GetCaster():SetForwardVector(direction)
		self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_swashbuckle_chargedattack", {})
		self:EmitSound("Hero_Pangolier.swashbuckle.cast")
		self:EndCooldown()
		self:GetCaster():RemoveModifierByName("modifier_imba_swashbuckle_chargedtime") 				
	end
	TG_Remove_Modifier(caster,"modifier_imba_gyroshell_roll",0)
end
modifier_imba_swashbuckle_chargedtime = class({})

function modifier_imba_swashbuckle_chargedtime:IsDebuff()			return false end
function modifier_imba_swashbuckle_chargedtime:IsHidden() 			return false end
function modifier_imba_swashbuckle_chargedtime:IsPurgable() 		return false end
function modifier_imba_swashbuckle_chargedtime:IsPurgeException() 	return false end
function modifier_imba_swashbuckle_chargedtime:RemoveOnDeath() 		return true  end
function modifier_imba_swashbuckle_chargedtime:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true} end 
function modifier_imba_swashbuckle_chargedtime:OnCreated()
	if IsServer() then
	   	self.pfx = ParticleManager:CreateParticle("particles/econ/items/lifestealer/lifestealer_immortal_backbone/lifestealer_immortal_backbone_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	    ParticleManager:SetParticleControlEnt(self.pfx, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	    ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	    self:AddParticle(self.pfx, false, false, -1, true, false)		
	end
end
function modifier_imba_swashbuckle_chargedtime:OnDestroy()
	if IsServer() then 
		if self.pfx then
	    	ParticleManager:DestroyParticle(self.pfx, false)
	    	ParticleManager:ReleaseParticleIndex(self.pfx)
	    end	
		self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(self:GetAbility():GetLevel() -1 ) * self:GetCaster():GetCooldownReduction()) - self:GetElapsedTime())
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_imba_gyroshell_boost_morale") then
			local buff = caster:FindAbilityByName("imba_pangolier_gyroshell")
			local buff_namber = caster:GetModifierStackCount("modifier_imba_gyroshell_boost_morale", caster)
			local boost_morale_counter = buff:GetSpecialValueFor("boost_morale_counter") + caster:TG_GetTalentValue("special_bonus_imba_pangolier_6")
			if buff_namber >= boost_morale_counter then 
				caster:SetModifierStackCount("modifier_imba_gyroshell_boost_morale", nil, buff_namber - boost_morale_counter)
				self:GetAbility():EndCooldown()
			end
		end			    		
	end
end
modifier_imba_swashbuckle_dash = class({})

function modifier_imba_swashbuckle_dash:IsDebuff()			return false end
function modifier_imba_swashbuckle_dash:IsHidden() 			return true end
function modifier_imba_swashbuckle_dash:IsPurgable() 		return false end
function modifier_imba_swashbuckle_dash:IsPurgeException() 	return false end
function modifier_imba_swashbuckle_dash:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_MAGIC_IMMUNE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true} end
function modifier_imba_swashbuckle_dash:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_DISABLE_TURNING} end
function modifier_imba_swashbuckle_dash:GetModifierDisableTurning() return 1 end
function modifier_imba_swashbuckle_dash:GetOverrideAnimation() return ACT_DOTA_CAST_ABILITY_1 end
function modifier_imba_swashbuckle_dash:IsMotionController() return true end
function modifier_imba_swashbuckle_dash:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function modifier_imba_swashbuckle_dash:OnCreated(keys)
		self.speed = self:GetAbility():GetSpecialValueFor("dash_speed")
		self.start_radius = self:GetAbility():GetSpecialValueFor("start_radius")
	if IsServer() then
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())	
	end
end
function modifier_imba_swashbuckle_dash:OnIntervalThink()
	if not IsServer() then return end 
	local current_pos = self:GetParent():GetAbsOrigin()
	local distacne = self.speed / (1.0 / FrameTime())
	local direction = (self.pos - current_pos):Normalized()
	direction.z = 0
	local next_pos = GetGroundPosition((current_pos + direction * distacne), nil)
	self:GetParent():SetOrigin(next_pos)
	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self.start_radius, false)
end
function modifier_imba_swashbuckle_dash:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		self.pos = nil
		self.speed = nil
		self:GetParent():SetForwardVector(Vector(self:GetParent():GetForwardVector()[1], self:GetParent():GetForwardVector()[2], 0))
	end
end

modifier_imba_swashbuckle_chargedattack = class({})
function modifier_imba_swashbuckle_chargedattack:IsDebuff()				return false end
function modifier_imba_swashbuckle_chargedattack:IsHidden() 			return false end
function modifier_imba_swashbuckle_chargedattack:IsPurgable() 			return false end
function modifier_imba_swashbuckle_chargedattack:IsPurgeException() 	return false end
function modifier_imba_swashbuckle_chargedattack:RemoveOnDeath() 		return true  end 
function modifier_imba_swashbuckle_chargedattack:OnCreated(keys)
	self.ability = self:GetAbility()
	self.range = self.ability:GetSpecialValueFor("range")
	self.start_radius = self.ability:GetSpecialValueFor("start_radius")
	self.strikes = self.ability:GetSpecialValueFor("strikes")
	self.attack_interval = self.ability:GetSpecialValueFor("attack_interval")
	self.charged_crit = self.ability:GetSpecialValueFor("charged_crit")
	self.charged_time = self.ability:GetSpecialValueFor("charged_time")
	self.charged_int = self.ability:GetSpecialValueFor("charged_int") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_pangolier_7")		
	if not IsServer() then return end
	if self:GetCaster():TG_HasTalent("special_bonus_imba_pangolier_5") and self:GetAbility():GetAutoCastState() then
		self.strikes = 1
	end	
	self.particle = "particles/units/heroes/hero_pangolier/pangolier_swashbuckler.vpcf"
	self.charged_sound = "Hero_Pangolier.Swashbuckle" 
	self.hit_sound= "Hero_Pangolier.Swashbuckle.Damage"
	self.charged_particle = {}
	self.executed_strikes = 0
	Timers:CreateTimer(FrameTime(), function()
		self.direction = self:GetCaster():GetForwardVector():Normalized()
		self.fixed_target = self:GetCaster():GetAbsOrigin() + self.direction * self.range
		self:StartIntervalThink(self.attack_interval)
	end)	

end

--function modifier_imba_swashbuckle_chargedattack:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_imba_swashbuckle_chargedattack:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_MAGIC_IMMUNE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true} end
function modifier_imba_swashbuckle_chargedattack:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_imba_swashbuckle_chargedattack:GetOverrideAnimation()	return ACT_DOTA_CAST_ABILITY_1_END	end
function modifier_imba_swashbuckle_chargedattack:OnIntervalThink()
	if PseudoRandom:RollPseudoRandom(self:GetAbility(), self.charged_int) then
		self.strikes = self.strikes + 1
	end	
	if self.executed_strikes >= self.strikes then 	
		self:StartIntervalThink(-1)
		return
		self:Destroy()
	end
	self.charged_particle[self.executed_strikes] = ParticleManager:CreateParticle(self.particle, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.charged_particle[self.executed_strikes], 0, self:GetCaster():GetAbsOrigin()) 
	ParticleManager:SetParticleControl(self.charged_particle[self.executed_strikes], 1, self.direction * self.range)

	EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), self.charged_sound, self:GetCaster())

	local enemies = FindUnitsInLine(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(),
		self.fixed_target,
		nil,
		self.start_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
	)

	for _,enemy in pairs(enemies) do
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_swashbuckle_chargedattack_int", {int = 1}) 
		self:GetCaster():PerformAttack(enemy, false, true, true, false, true, false, false)
		self:GetParent():RemoveModifierByName("modifier_imba_swashbuckle_chargedattack_int")
	end

	self.executed_strikes = self.executed_strikes + 1
end

function modifier_imba_swashbuckle_chargedattack:OnRemoved()
	if IsServer() then
		for k,v in pairs(self.charged_particle) do
			ParticleManager:DestroyParticle(v, false)
			ParticleManager:ReleaseParticleIndex(v)
		end
	end
end
function modifier_imba_swashbuckle_chargedattack:OnDestroy()
	if IsServer() then
		self:GetParent():MoveToPositionAggressive(self:GetParent():GetAbsOrigin())
	end
end
modifier_imba_swashbuckle_chargedattack_int = class({})
function modifier_imba_swashbuckle_chargedattack_int:IsDebuff()      return false end
function modifier_imba_swashbuckle_chargedattack_int:IsHidden()      return true end
function modifier_imba_swashbuckle_chargedattack_int:IsPurgable()    return false end
function modifier_imba_swashbuckle_chargedattack_int:IsPurgeException()  return false end
function modifier_imba_swashbuckle_chargedattack_int:DeclareFunctions() return  {MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE, MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE} end
function modifier_imba_swashbuckle_chargedattack_int:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = true} end
function modifier_imba_swashbuckle_chargedattack_int:OnCreated(keys)
	if not IsServer() then return end
	self.int = keys.int
end	
function modifier_imba_swashbuckle_chargedattack_int:GetModifierOverrideAttackDamage()
	if self:GetCaster():TG_HasTalent("special_bonus_imba_pangolier_5") and self:GetAbility():GetAutoCastState() and self.int == 1 then
		return nil
	end
	return self:GetAbility():GetSpecialValueFor("damage")
end
function modifier_imba_swashbuckle_chargedattack_int:GetModifierPreAttack_CriticalStrike(keys)
	if self:GetCaster():TG_HasTalent("special_bonus_imba_pangolier_5") and self:GetAbility():GetAutoCastState() and self.int == 1 then
		return self:GetCaster():TG_GetTalentValue("special_bonus_imba_pangolier_5")
	end
	return nil	
end

--Shield Crash
--------------
imba_pangolier_shield_crash = imba_pangolier_shield_crash or class({})
LinkLuaModifier("modifier_imba_shield_crash_buff", "linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_shield_crash_jump", "linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_BOTH) 
LinkLuaModifier("modifier_imba_shield_crash_miss_vision","linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)


function imba_pangolier_shield_crash:GetAbilityTextureName()	return "pangolier_shield_crash"	end
function imba_pangolier_shield_crash:IsHiddenWhenStolen()  return false end
function imba_pangolier_shield_crash:IsStealable() 	return true end
function imba_pangolier_shield_crash:GetCastRange() return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end

function imba_pangolier_shield_crash:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local cooldown2 = self.BaseClass.GetCooldown(self, level) * 0.2
	local cooldown3 = self.BaseClass.GetCooldown(self, level) * 0.5
	local caster = self:GetCaster()
	local roll_cooldown = caster:TG_GetTalentValue("special_bonus_imba_pangolier_4")
	local yanfan = self:GetCaster():HasModifier("modifier_imba_swashbuckle_chargedtime") 
	local Scepter = self:GetCaster():HasModifier("modifier_imba_swashbuckle_chargedtime") and caster:HasScepter()
	if caster:TG_HasTalent("special_bonus_imba_pangolier_4") then 
		if caster:HasModifier("modifier_imba_gyroshell_roll") then
			return roll_cooldown
		end
	end
	if Scepter then
		return cooldown2
	end
	if yanfan then
		return cooldown3
	end		
	return cooldown
end

function imba_pangolier_shield_crash:GetCastPoint()
	if not IsServer() then return end 
	local cast_point = self.BaseClass.GetCastPoint(self)

	return cast_point
end


function imba_pangolier_shield_crash:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local sound_cast= "Hero_Pangolier.TailThump.Cast"
	local gyroshell_ability = caster:FindAbilityByName("imba_pangolier_gyroshell")
	local modifier_movement = "modifier_imba_shield_crash_jump"
	local vision_duration = ability:GetSpecialValueFor("vision_duration")

	local jump_duration = ability:GetSpecialValueFor("jump_duration")
	local jump_duration_gyroshell = ability:GetSpecialValueFor("jump_duration_gyroshell")
	local jump_height = ability:GetSpecialValueFor("jump_height")
	local jump_height_gyroshell = ability:GetSpecialValueFor("jump_height_gyroshell")
	local jump_horizontal_distance = ability:GetSpecialValueFor("jump_horizontal_distance")
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_cast, caster)
	Timers:CreateTimer(FrameTime(), function ()
		local modifier_movement_handler = caster:AddNewModifier(caster, ability, modifier_movement, {})
		return nil
	end)	

	if self:GetCaster():HasScepter() and self:GetCaster():FindAbilityByName("imba_pangolier_swashbuckle") and self:GetCaster():FindAbilityByName("imba_pangolier_swashbuckle"):IsTrained() then
		local swashbuckle_ability	= self:GetCaster():FindAbilityByName("imba_pangolier_swashbuckle")
		local swashbuckle_radius	= swashbuckle_ability:GetSpecialValueFor("end_radius") or swashbuckle_ability:GetSpecialValueFor("start_radius")
		local swashbuckle_range		= swashbuckle_ability:GetSpecialValueFor("range")
		local swashbuckle_damage	= swashbuckle_ability:GetSpecialValueFor("damage")
		if not self.slash_particles then self.slash_particles = {} end
		
		for _, particle in pairs(self.slash_particles) do
			ParticleManager:DestroyParticle(particle, false)
			ParticleManager:ReleaseParticleIndex(particle)
		end
		
		self.slash_particles = {}
		
		for pulses = 0, 1 do
			Timers:CreateTimer(0.1 * pulses, function()
				local hit_enemies = {}			
				for slash = 1, 4 do
					local direction = RotatePosition(Vector(0, 0, 0), QAngle(0, 90 * slash, 0), self:GetCaster():GetForwardVector())				
					local slash_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_swashbuckler.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
					ParticleManager:SetParticleControl(slash_particle, 1, direction)					
					table.insert(self.slash_particles, slash_particle)					
					EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Hero_Pangolier.Swashbuckle", self:GetCaster())
					local enemies = FindUnitsInLine(
						self:GetCaster():GetTeamNumber(),
						self:GetCaster():GetAbsOrigin(),
						self:GetCaster():GetAbsOrigin() + (direction * swashbuckle_range),
						nil,
						swashbuckle_radius,
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
						DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
					)

					for _, enemy in pairs(enemies) do
						if not hit_enemies[enemy] then
							EmitSoundOn("Hero_Pangolier.Swashbuckle.Damage", enemy)
							self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("imba_pangolier_swashbuckle"), "modifier_imba_swashbuckle_chargedattack_int", {int = 2}) 
							self:GetCaster():PerformAttack(enemy, false, true, true, false, true, false, false)							
							hit_enemies[enemy] = true
							self:GetCaster():RemoveModifierByName("modifier_imba_swashbuckle_chargedattack_int")
						end
					end
					
					Timers:CreateTimer(0.5, function ()						
						for _, particle in pairs(self.slash_particles) do
							ParticleManager:DestroyParticle(particle, false)
							ParticleManager:ReleaseParticleIndex(particle)
						end				
						self.slash_particles = {}
					end)
				end
			end)
		end
	end
	Timers:CreateTimer(FrameTime(), function ()
		if self:GetCaster():HasModifier("modifier_imba_swashbuckle_chargedtime") then
			local caster = self:GetCaster()
			local pos = caster:GetAbsOrigin()
			local direction = pos:Normalized()
			direction.z = 0.0
			local damage = self:GetSpecialValueFor("damage")
			local buff_duration = self:GetSpecialValueFor("duration")
			local radius = self:GetSpecialValueFor("radius")
			self.sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 5.0}, pos, caster:GetTeamNumber(), false)
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf", PATTACH_ABSORIGIN, self.sound)
			ParticleManager:SetParticleControl(pfx, 0, self.sound:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius,0,0))
			ParticleManager:ReleaseParticleIndex(pfx)
			self.sound:EmitSound("Hero_Pangolier.Gyroshell.Stun")					
			local enemies = FindUnitsInRadius(
				self:GetCaster():GetTeamNumber(),
				self:GetCaster():GetAbsOrigin(),
				nil,
				radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
				FIND_ANY_ORDER,
				false
			)
			for _,enemy in pairs(enemies) do
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_shield_crash_miss_vision", {duration = vision_duration})					
			end		
		end
	return nil
	end)		
end
modifier_imba_shield_crash_miss_vision = class({})
function modifier_imba_shield_crash_miss_vision:IsDebuff() return true end
function modifier_imba_shield_crash_miss_vision:IsHidden() return false end
function modifier_imba_shield_crash_miss_vision:IsPurgable() return true end
function modifier_imba_shield_crash_miss_vision:DeclareFunctions() return {MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_shield_crash_miss_vision:GetBonusVisionPercentage()
	local duration = string.format("%.1f",self:GetElapsedTime())
	local int = duration / (self:GetDuration()-1.5) * 100
	self.int_int = string.format("%.1f",int)
	return (0 - self.int_int) 
end
function modifier_imba_shield_crash_miss_vision:GetModifierMoveSpeedBonus_Percentage()
	local duration = string.format("%.1f",self:GetElapsedTime())
	local int = duration / (self:GetDuration()-1.5) * 100
	self.int_int = string.format("%.1f",int)	
	return (0 - self.int_int) 
end
function modifier_imba_shield_crash_miss_vision:OnCreated(kv)
	if IsServer() then
		self.int_int = 0
	end
end


modifier_imba_shield_crash_buff = class ({})
function modifier_imba_shield_crash_buff:OnCreated(kv)
	if IsServer() then
		local caster = self:GetCaster()
		self.stacks = kv.stacks
		self.sound = "Hero_Pangolier.TailThump.Shield"
		self.damage_reduction_pct = self:GetAbility():GetSpecialValueFor("hero_stacks")	+ caster:TG_GetTalentValue("special_bonus_imba_pangolier_8")
		
		self:SetStackCount(self.damage_reduction_pct * self.stacks)
		EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), self.sound, self:GetCaster())
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())	
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, GetGroundPosition(caster:GetAbsOrigin(),caster), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(self.damage_reduction_pct * self.stacks,0,0), true)
		self:AddParticle(self.pfx, false, false, -1, false, false)			
	end
end
function modifier_imba_shield_crash_buff:OnDestroy()
	if IsServer() then
		if self.pfx then		
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex( self.pfx )
		end
	end	
end	

function modifier_imba_shield_crash_buff:DestroyOnExpire()	return true end
function modifier_imba_shield_crash_buff:DeclareFunctions()	return  {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_shield_crash_buff:GetModifierIncomingDamage_Percentage()
	return self.damage_reduction_pct * self.stacks * (-1)
end

function modifier_imba_shield_crash_buff:GetModifierPreAttack_BonusDamage()
	--if not IsServer() then return end 
	if self:GetStackCount() then 
		return self:GetStackCount()
	else
		return 0
	end
end

function modifier_imba_shield_crash_buff:GetModifierAttackSpeedBonus_Constant()
	--if not IsServer() then return end 
	if self:GetStackCount() then 
		return self:GetStackCount()
	else
		return 0
	end
end

function modifier_imba_shield_crash_buff:IsPermanent() return false end
function modifier_imba_shield_crash_buff:IsHidden() return false end
function modifier_imba_shield_crash_buff:IsPurgable() return true end
function modifier_imba_shield_crash_buff:IsDebuff() return false end
function modifier_imba_shield_crash_buff:AllowIllusionDuplicate() return true end
function modifier_imba_shield_crash_buff:IsStealable() return true end
modifier_imba_shield_crash_jump = class({})

function modifier_imba_shield_crash_jump:IsHidden() return true end
function modifier_imba_shield_crash_jump:IsPurgable() return false end

function modifier_imba_shield_crash_jump:OnCreated()
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.buff_duration = self:GetAbility():GetSpecialValueFor("duration")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.hero_stacks = self:GetAbility():GetSpecialValueFor("hero_stacks") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_pangolier_8")
	self.distance	= self:GetAbility():GetSpecialValueFor("jump_horizontal_distance")
	if not IsServer() then return end
	local caster = self:GetCaster()
	self.buff_modifier = "modifier_imba_shield_crash_buff"
	self.smash_sound = "Hero_Pangolier.TailThump"
	self.gyroshell = "modifier_imba_gyroshell_roll"

	self.direction	= self:GetCaster():GetForwardVector()
	if self:GetCaster():HasModifier("modifier_imba_swashbuckle_chargedtime") then
		self.direction	= (self:GetAbility().pos - self:GetParent():GetAbsOrigin()):Normalized()
		self.distance	= (self:GetAbility().pos - self:GetParent():GetAbsOrigin()):Length() * 0.8
		self.height		= self:GetAbility():GetSpecialValueFor("jump_height") * 5
	end	
	self.duration	= self:GetAbility():GetSpecialValueFor("jump_duration") / 2
	self.height		= self:GetAbility():GetSpecialValueFor("jump_height") / 2
	self.velocity		= self.direction * self.distance / self.duration

	self.vertical_velocity		= 4 * self.height / self.duration
	self.vertical_acceleration	= -(8 * self.height) / (self.duration * self.duration)		
	self:GetParent():RemoveHorizontalMotionController(self)		
	if self:ApplyVerticalMotionController() == false then 
		self:Destroy()
	end		
	if not self:GetParent():HasModifier("modifier_imba_gyroshell_roll") and self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
	end
end

function modifier_imba_shield_crash_jump:OnDestroy()
	if not IsServer() then return end

	--self:GetAbility().pos = nil
	self:GetParent():InterruptMotionControllers(true)
	EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), self.smash_sound, self:GetCaster())
	local flag = DOTA_UNIT_TARGET_FLAG_NONE
	if self:GetCaster():Has_Aghanims_Shard() then
		flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end	
	local enemy_heroes = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		flag,
		FIND_ANY_ORDER,
		false
	)

	local damaged_heroes = #enemy_heroes
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		flag,
		FIND_ANY_ORDER,
		false
	)
	for _,enemy in pairs(enemies) do
		damage_table = ({
			victim = enemy,
			attacker = self:GetCaster(),
			ability = self:GetAbility(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL
		})

		ApplyDamage(damage_table)
	end
	
	local dust_particle111 = "particles/units/heroes/hero_pangolier/pangolier_tailthump.vpcf"
	if damaged_heroes > 0 then
	dust_particle111 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_hero.vpcf"
		if self:GetCaster():HasModifier(self.buff_modifier) then
			local old_stacks = self:GetCaster():GetModifierStackCount(self.buff_modifier, self:GetCaster())
			local buff = self:GetCaster():FindModifierByName("modifier_imba_shield_crash_buff")
			self:GetCaster():RemoveModifierByName(self.buff_modifier)

			if damaged_heroes > old_stacks / self.hero_stacks then
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.buff_modifier, {duration = self.buff_duration, stacks = damaged_heroes})
			else
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.buff_modifier, {duration = self.buff_duration, stacks = old_stacks / self.hero_stacks})
			end
		else
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.buff_modifier, {duration = self.buff_duration, stacks = damaged_heroes})
		end			
	end
	local dust = ParticleManager:CreateParticle(dust_particle111, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(dust, 0, GetGroundPosition(self:GetCaster():GetAbsOrigin(),self:GetCaster())) 
end

function modifier_imba_shield_crash_jump:UpdateHorizontalMotion(me, dt)
	if not IsServer() then return end 
	me:SetOrigin( me:GetOrigin() + self.velocity * dt )
end
function modifier_imba_shield_crash_jump:OnHorizontalMotionInterrupted()
	if not IsServer() then return end 
	self:Destroy()
end

function modifier_imba_shield_crash_jump:UpdateVerticalMotion(me, dt)
	if not IsServer() then return end 
	me:SetOrigin( me:GetOrigin() + Vector(0, 0, self.vertical_velocity) * dt )
	
	if GetGroundHeight(self:GetParent():GetAbsOrigin(), nil) > self:GetParent():GetAbsOrigin().z then
		self:Destroy()
	else
		self.vertical_velocity = self.vertical_velocity + (self.vertical_acceleration * dt)
	end
end
function modifier_imba_shield_crash_jump:OnVerticalMotionInterrupted()
	if not IsServer() then return end 
	self:Destroy()
end

function modifier_imba_shield_crash_jump:CheckState()
	if not IsServer() then return end 
	if self:GetCaster():HasModifier(self.gyroshell) then
		return {
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY]	= true,
			[MODIFIER_STATE_NO_UNIT_COLLISION]					= true
		}
	else
		return {
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY]	= true,
			[MODIFIER_STATE_NO_UNIT_COLLISION]					= true,
			[MODIFIER_STATE_STUNNED]							= true,
		}
	end
end

--Lucky Shot--
--------------
LinkLuaModifier("modifier_lucky_shot_passive", "linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lucky_shot_debuff_str", "linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lucky_shot_debuff_agi", "linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lucky_shot_debuff_int", "linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)

imba_pangolier_lucky_shot = class({})

function imba_pangolier_lucky_shot:GetIntrinsicModifierName() return "modifier_lucky_shot_passive" end

modifier_lucky_shot_passive = class({})

function modifier_lucky_shot_passive:IsDebuff()				return false end
function modifier_lucky_shot_passive:IsHidden() 			return true end
function modifier_lucky_shot_passive:IsPurgable() 			return false end
function modifier_lucky_shot_passive:IsPurgeException() 	return false end
function modifier_lucky_shot_passive:AllowIllusionDuplicate() return false end
function modifier_lucky_shot_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_lucky_shot_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end 
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or keys.target:IsBuilding() or keys.target:IsOther() or keys.target:IsMagicImmune() then
		return
	end
	local ability = self:GetAbility()
	self.chance_pct = ability:GetSpecialValueFor("chance_pct")
	if self:GetCaster():TG_HasTalent("special_bonus_imba_pangolier_3") then
		self.chance_pct = self.chance_pct + self:GetCaster():TG_GetTalentValue("special_bonus_imba_pangolier_3")
	end
	if keys.target:IsMagicImmune() then
		self.chance_pct = self.chance_pct / 2 
	end	
	local ability_1 = self:GetParent():FindAbilityByName("imba_pangolier_swashbuckle")
	local modifier = self:GetParent():FindModifierByName("modifier_imba_swashbuckle_chargedattack_int")
	if modifier then
		if self:GetCaster():TG_HasTalent("special_bonus_imba_pangolier_5") and ability_1:GetAutoCastState() and modifier.int == 1 then
			self.chance_pct = 100
		end
	end		
	self.duration = ability:GetSpecialValueFor("duration")	
	if PseudoRandom:RollPseudoRandom(ability, self.chance_pct) then
		if keys.target:HasModifier("modifier_lucky_shot_debuff_agi") or keys.target:HasModifier("modifier_lucky_shot_debuff_int") then
			keys.target:EmitSound("Hero_Pangolier.HeartPiercer")
			local buff = keys.target:AddNewModifier_RS(self:GetParent(), ability, "modifier_lucky_shot_debuff_str", {duration = self.duration})
			buff:ForceRefresh()
		end
		keys.target:EmitSound("Hero_Pangolier.LuckyShot.Proc")
		local buff_name = {"modifier_lucky_shot_debuff_agi",
							"modifier_lucky_shot_debuff_int",}
		keys.target:AddNewModifier_RS(self:GetParent(), ability, buff_name[RandomInt(1, 2)], {duration = self.duration})
	end
end

modifier_lucky_shot_debuff_str = class({}) 

function modifier_lucky_shot_debuff_str:IsDebuff()			return true end
function modifier_lucky_shot_debuff_str:IsHidden() 			return false end
function modifier_lucky_shot_debuff_str:IsPurgable() 		return true end
function modifier_lucky_shot_debuff_str:IsPurgeException() 	return true end
function modifier_lucky_shot_debuff_str:DeclareFunctions() return {MODIFIER_PROPERTY_DISABLE_HEALING, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_lucky_shot_debuff_str:GetEffectName() return "particles/units/heroes/hero_pangolier/pangolier_heartpiercer_delay.vpcf" end
function modifier_lucky_shot_debuff_str:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_lucky_shot_debuff_str:ShouldUseOverheadOffset() return true end
function modifier_lucky_shot_debuff_str:GetModifierPhysicalArmorBonus() return (0 - self:GetAbility():GetSpecialValueFor("armor")) end
function modifier_lucky_shot_debuff_str:GetDisableHealing()
	return 1
end

modifier_lucky_shot_debuff_agi = class({})

function modifier_lucky_shot_debuff_agi:IsDebuff()			return true end
function modifier_lucky_shot_debuff_agi:IsHidden() 			return false end
function modifier_lucky_shot_debuff_agi:IsPurgable() 		return true end
function modifier_lucky_shot_debuff_agi:IsPurgeException() 	return true end
function modifier_lucky_shot_debuff_agi:CheckState() return {[MODIFIER_STATE_DISARMED] = true} end
function modifier_lucky_shot_debuff_agi:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_lucky_shot_debuff_agi:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("slow")) end
function modifier_lucky_shot_debuff_agi:GetEffectName() return "particles/units/heroes/hero_pangolier/pangolier_luckyshot_disarm_debuff.vpcf" end
function modifier_lucky_shot_debuff_agi:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_lucky_shot_debuff_agi:ShouldUseOverheadOffset() return true end
function modifier_lucky_shot_debuff_agi:GetModifierPhysicalArmorBonus() return (0 - self:GetAbility():GetSpecialValueFor("armor")) end

modifier_lucky_shot_debuff_int = class({})

function modifier_lucky_shot_debuff_int:IsDebuff()			return true end
function modifier_lucky_shot_debuff_int:IsHidden() 			return false end
function modifier_lucky_shot_debuff_int:IsPurgable() 		return true end
function modifier_lucky_shot_debuff_int:IsPurgeException() 	return true end
function modifier_lucky_shot_debuff_int:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_lucky_shot_debuff_int:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_lucky_shot_debuff_int:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("slow")) end
function modifier_lucky_shot_debuff_int:GetEffectName() return "particles/units/heroes/hero_pangolier/pangolier_luckyshot_silence_debuff.vpcf" end
function modifier_lucky_shot_debuff_int:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_lucky_shot_debuff_int:ShouldUseOverheadOffset() return true end
function modifier_lucky_shot_debuff_int:GetModifierPhysicalArmorBonus() return (0 - self:GetAbility():GetSpecialValueFor("armor")) end

-- Gyroshell --
---------------

imba_pangolier_gyroshell = class({})

LinkLuaModifier("modifier_imba_gyroshell_impact_check", "linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_gyroshell_boost_morale", "linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_gyroshell_roll", "linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_gyroshell_roll_cd", "linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) 

function imba_pangolier_gyroshell:GetAbilityTextureName() return "pangolier_gyroshell" end
function imba_pangolier_gyroshell:IsHiddenWhenStolen() return false end
function imba_pangolier_gyroshell:IsStealable() return true end
function imba_pangolier_gyroshell:GetAssociatedSecondaryAbilities()	return "imba_pangolier_gyroshell_stop" end
function imba_pangolier_gyroshell:GetCooldown(level)
	--if not IsServer() then return end 
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_pangolier_1") then 
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_pangolier_1"))
	end
	return cooldown
end

function imba_pangolier_gyroshell:OnUpgrade()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local main_ability = self
	local main_abilityName = self:GetAbilityName()
	local main_abilityLevel = self:GetLevel()
	local sub_ability = "imba_pangolier_gyroshell_stop"
	local sub_ability_handle = caster:FindAbilityByName(sub_ability)
	local sub_ability_level = sub_ability_handle:GetLevel()
	if sub_ability_level ~= main_abilityLevel then
		sub_ability_handle:SetLevel(main_abilityLevel)
	end
end

function imba_pangolier_gyroshell:OnAbilityPhaseStart()
	if not IsServer() then return end 
	local sound_cast = "Hero_Pangolier.Gyroshell.Cast"
	local cast_particle = "particles/units/heroes/hero_pangolier/pangolier_gyroshell_cast.vpcf"
	local caster = self:GetCaster()
	self.cast_effect = ParticleManager:CreateParticle(cast_particle, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.cast_effect, 0, caster:GetAbsOrigin()) -- 0: Spotlight position,
	ParticleManager:SetParticleControl(self.cast_effect, 3, caster:GetAbsOrigin()) --3: shell and sprint effect position,
	ParticleManager:SetParticleControl(self.cast_effect, 60, caster:GetAbsOrigin()) --5: roses landing point

	return true
end

function imba_pangolier_gyroshell:OnAbilityPhaseInterrupted()
	if not IsServer() then return end 
	if self.cast_effect then
		ParticleManager:DestroyParticle(self.cast_effect, false)
		ParticleManager:ReleaseParticleIndex(self.cast_effect)
	end	
end

function imba_pangolier_gyroshell:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local loop_sound = "Hero_Pangolier.Gyroshell.Loop" 
	local roll_modifier = "modifier_imba_gyroshell_roll"
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local ability_duration = ability:GetSpecialValueFor("duration")
	if caster:TG_HasTalent("special_bonus_imba_pangolier_7") then 
		stun_duration = ability:GetSpecialValueFor("stun_duration") + caster:TG_GetTalentValue("special_bonus_imba_pangolier_7")
	end

	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	if self.cast_effect then
		ParticleManager:DestroyParticle(self.cast_effect, false)
		ParticleManager:ReleaseParticleIndex(self.cast_effect)
	end	

	caster:Purge(false, true, false, false, false)

	caster:AddNewModifier(caster, ability, roll_modifier, {duration = ability_duration ,stun_duration = stun_duration })
	caster:AddNewModifier(caster, ability, "modifier_imba_gyroshell_impact_check", {duration = ability_duration})
	if caster:TG_HasTalent("special_bonus_imba_pangolier_4") then
		self:GetCaster():FindAbilityByName("imba_pangolier_shield_crash"):EndCooldown()
	end		
	EmitSoundOn(loop_sound, caster)	

	caster:SwapAbilities("imba_pangolier_gyroshell", "imba_pangolier_gyroshell_stop", false, true)
end
function imba_pangolier_gyroshell:Bash(target, parent, bUltimate)
	if not IsServer() then return end
	local caster = self:GetCaster()
	local parent_loc	= self:GetCaster():GetAbsOrigin()
	target:EmitSound("Hero_Pangolier.Gyroshell.Stun") 
		knockback_properties = {
			 center_x 			= parent_loc.x,
			 center_y 			= parent_loc.y,
			 center_z 			= parent_loc.z,
			 duration 			= 0.4,
			 knockback_duration = 0.4,
			 knockback_distance = 200,
			 knockback_height 	= 150,
		}	
	local knockback_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_knockback", knockback_properties)
	
	if knockback_modifier then
		knockback_modifier:SetDuration(self:GetSpecialValueFor("stun_duration"), true) 
	end	
	local damage = self:GetSpecialValueFor("damage")
	local stacks = caster:GetModifierStackCount("modifier_imba_gyroshell_roll", nil)
	local damageTable = {
						victim 			= target,
						damage 			= damage + stacks * damage * 0.5,
						damage_type		= self:GetAbilityDamageType(),
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self
						}
	ApplyDamage(damageTable)
	target:AddNewModifier(self:GetCaster(), self, "modifier_imba_gyroshell_roll_cd", {duration = self:GetSpecialValueFor("stun_duration")})
end

modifier_imba_gyroshell_impact_check = class({})

function modifier_imba_gyroshell_impact_check:IsHidden() return true end
function modifier_imba_gyroshell_impact_check:IsPurgable() return false end
function modifier_imba_gyroshell_impact_check:IsPermanent() return false end
function modifier_imba_gyroshell_impact_check:IsDebuff() return false end

function modifier_imba_gyroshell_impact_check:OnCreated()
		self.duration_extend = self:GetAbility():GetSpecialValueFor("duration_extend")
		self.buff = self:GetAbility():GetSpecialValueFor("boost_morale_counter_max")
	if IsServer() then
		self.gyroshell = self:GetCaster():FindModifierByName("modifier_imba_gyroshell_roll")
		self.targets = self.targets or {}
		self:StartIntervalThink(0.05)
	end
end

function modifier_imba_gyroshell_impact_check:OnIntervalThink()
	if IsServer() then
		if not self:GetCaster():HasModifier("modifier_imba_gyroshell_roll") then
			self:Destroy()
		end
		local stacks = self:GetCaster():GetModifierStackCount("modifier_imba_gyroshell_roll", nil)
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
			self:GetCaster():GetAbsOrigin(),
			nil,
			180 + stacks * 60 ,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,
			FIND_ANY_ORDER,
			false)
		for _,enemy in pairs(enemies) do
				if not enemy:HasModifier("modifier_imba_gyroshell_roll_cd") then   				
					self:GetCaster():FindAbilityByName("imba_pangolier_gyroshell"):Bash(enemy, me)

					--Boost Morale layer talent to reduce Swashbuckle cooldown
					local buff_namber = self:GetParent():AddNewModifier(self:GetParent(), self:GetCaster():FindAbilityByName("imba_pangolier_gyroshell"), "modifier_imba_gyroshell_boost_morale", {})
					if enemy:IsRealHero() then
						if buff_namber:GetStackCount() < self.buff then
							buff_namber:SetStackCount(buff_namber:GetStackCount() + 1)
						end	
					end	
				end
		end
	end
end

function modifier_imba_gyroshell_impact_check:OnRemoved()
	if IsServer() then
		self:GetCaster():SwapAbilities("imba_pangolier_gyroshell", "imba_pangolier_gyroshell_stop", true, false)
	end
end
modifier_imba_gyroshell_roll_cd = class({})

function modifier_imba_gyroshell_roll_cd:IsDebuff()			return false end
function modifier_imba_gyroshell_roll_cd:IsHidden() 		return true end
function modifier_imba_gyroshell_roll_cd:IsPurgable() 		return false end
function modifier_imba_gyroshell_roll_cd:IsPurgeException() return false end

modifier_imba_gyroshell_boost_morale = class ({})
function modifier_imba_gyroshell_boost_morale:IsDebuff()			return false end
function modifier_imba_gyroshell_boost_morale:IsHidden() 
	if not IsServer() then return end 
	if self:GetStackCount() > 0 then
		return false
	end
	return true
end			
function modifier_imba_gyroshell_boost_morale:IsPurgable() 			return false end
function modifier_imba_gyroshell_boost_morale:IsPurgeException() 	return false end



modifier_imba_gyroshell_roll = class({})

function modifier_imba_gyroshell_roll:IsDebuff()			return false end
function modifier_imba_gyroshell_roll:IsHidden() 			return false end
function modifier_imba_gyroshell_roll:IsPurgable() 			return false end
function modifier_imba_gyroshell_roll:IsPurgeException() 	return false end  
function modifier_imba_gyroshell_roll:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MOVESPEED_LIMIT,
					MODIFIER_PROPERTY_MOVESPEED_MAX,
					MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
					MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE, 
				}
	return funcs
end

function modifier_imba_gyroshell_roll:CheckState()
	return{ [MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true
		}
end

function modifier_imba_gyroshell_roll:GetModifierMoveSpeed_Limit() 
	return 1
end

function modifier_imba_gyroshell_roll:GetModifierMoveSpeed_Max() 	
	return 1
end
function modifier_imba_gyroshell_roll:GetModifierTurnRate_Percentage()
	if not IsServer() then return end 
	local turn_slow = 0 - 150	
	return turn_slow
end	
function modifier_imba_gyroshell_roll:OnCreated()
	self:GetCaster().roll_is_moving = true
	if not IsServer() then
		return
	end
	self.sprinting_effect = "particles/units/heroes/hero_pangolier/pangolier_gyroshell.vpcf"
	self.sprint = ParticleManager:CreateParticle(self.sprinting_effect, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(self.sprint, 0, self:GetCaster():GetAbsOrigin()) --origin

	self:AddParticle(self.sprint, false, false, -1, true, false)
	self.model = self:GetCaster():GetModelName()
	self:GetCaster():SetOriginalModel("models/heroes/pangolier/pangolier_gyroshell2.vmdl")
	self.forwardMoveSpeed				= self:GetAbility():GetSpecialValueFor("forward_move_speed")
	
    self:OnIntervalThink()
    self:StartIntervalThink(FrameTime())
end	
function modifier_imba_gyroshell_roll:OnIntervalThink()
	local caster = self:GetCaster()
	local direction = self:GetParent():GetForwardVector()
	local pos = self:GetParent():GetAbsOrigin()
	local int = self:GetStackCount()
	local speed = self.forwardMoveSpeed + (int * self.forwardMoveSpeed * 0.5)
	
	local next_pos = GetGroundPosition(pos + direction * speed * FrameTime(), nil)
	if caster.roll_is_moving and not caster:IsStunned() then
		self:GetParent():SetAbsOrigin(next_pos)
	end	
end		
function modifier_imba_gyroshell_roll:OnRemoved()
	if IsServer() then
		self:GetCaster():SetOriginalModel(self.model)
		self:GetCaster():EmitSound("Hero_Pangolier.Gyroshell.Stop")
		self:GetCaster():StopSound("Hero_Pangolier.Gyroshell.Loop")
		self:GetCaster():StopSound("Hero_Pangolier.Gyroshell.Layer")
	end
	self:GetCaster().roll_is_moving = true
end


imba_pangolier_gyroshell_stop = class ({})

LinkLuaModifier("modifier_imba_gyroshell_stop_buff", "linken/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)

function imba_pangolier_gyroshell_stop:IsInnateAbility()				return true end
function imba_pangolier_gyroshell_stop:IsStealable()					return false end
function imba_pangolier_gyroshell_stop:GetAssociatedPrimaryAbilities()	return "imba_pangolier_gyroshell" end

function imba_pangolier_gyroshell_stop:OnOwnerSpawned()
	if not IsServer() then return end 
	local gyroshell_ability = self:GetCaster():FindAbilityByName("imba_pangolier_gyroshell")
	
	if gyroshell_ability and gyroshell_ability:IsHidden() then
		self:GetCaster():SwapAbilities("imba_pangolier_gyroshell", "imba_pangolier_gyroshell_stop", true, false)
	end
end

function imba_pangolier_gyroshell_stop:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_imba_gyroshell_roll")

	local ability = self:GetCaster():FindAbilityByName("imba_pangolier_gyroshell")
	if ability:GetAutoCastState() and modifier:GetStackCount() < 5 then
		modifier:IncrementStackCount()
		modifier:SetDuration(modifier:GetRemainingTime()-1, true)
		EmitSoundOn("Imba.Hero_pangolier.gyroshell_stop", caster)
		self:EndCooldown()
		self:StartCooldown(0.4)
	elseif not ability:GetAutoCastState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_gyroshell_stop_buff", { duration = 0.4})
		caster.roll_is_moving = false
		Timers:CreateTimer(0.4, function ()
		caster.roll_is_moving = true
		end)
	end	

end

modifier_imba_gyroshell_stop_buff = class({})

function modifier_imba_gyroshell_stop_buff:IsPurgable() return false end
function modifier_imba_gyroshell_stop_buff:IsHidden() return false end
function modifier_imba_gyroshell_stop_buff:IsDebuff() return false end
function modifier_imba_gyroshell_stop_buff:DeclareFunctions() return {MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE} end
function modifier_imba_gyroshell_stop_buff:GetModifierTurnRate_Percentage()
	if not IsServer() then return end 
	local ability = self:GetCaster():FindAbilityByName("imba_pangolier_gyroshell_stop"):GetSpecialValueFor("stop_turn_rate")
	return ability
end