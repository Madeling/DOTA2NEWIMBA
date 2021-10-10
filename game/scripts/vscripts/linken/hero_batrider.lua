------2020.11.20--by--你收拾收拾准备出林肯吧
CreateTalents("npc_dota_hero_batrider", "linken/hero_batrider")
function CalculateDistance(ent1, ent2)
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local distance = (pos1 - pos2):Length2D()
	return distance
end
imba_batrider_sticky_napalm = class({})
LinkLuaModifier("modifier_imba_sticky_napalm_thinker", "linken/hero_batrider", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sticky_napalm_debuff", "linken/hero_batrider", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sticky_napalm_debuff_cd", "linken/hero_batrider", LUA_MODIFIER_MOTION_NONE) 


function imba_batrider_sticky_napalm:IsHiddenWhenStolen() 		return false end
function imba_batrider_sticky_napalm:IsRefreshable() 			return true end
function imba_batrider_sticky_napalm:IsStealable() 			return true end
--function imba_batrider_sticky_napalm:GetCastRange() return self:GetSpecialValueFor("cast_distance") +  self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_6") + self:GetCaster():GetCastRangeBonus() end
function imba_batrider_sticky_napalm:GetAOERadius()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")	
	return radius		 
end

function imba_batrider_sticky_napalm:OnSpellStart(scepter)
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	caster:EmitSound("Hero_Batrider.StickyNapalm.Cast")
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(self.pfx, 0, pos)
	ParticleManager:SetParticleControl(self.pfx, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(self.pfx, 2, caster:GetAbsOrigin())
	--self:AddParticle(self.pfx, false, false, -1, false, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)	

	AddFOWViewer(caster:GetTeamNumber(), pos, radius, 2, true)
	local dummy_pfx = CreateModifierThinker(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_imba_sticky_napalm_thinker", -- modifier name
		{
			duration = duration,
			radius = radius,
			pos = pos,
		}, -- kv
		GetGroundPosition(pos,caster),
		self:GetCaster():GetTeamNumber(),
		false
	)
	EmitSoundOn("Hero_Batrider.StickyNapalm.Impact", dummy_pfx)
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		pos,	
		nil,	
		radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		0,	
		0,	
		false
	)
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier_RS(caster, self, "modifier_imba_sticky_napalm_debuff", {duration = duration})	
	end			
end

modifier_imba_sticky_napalm_thinker = class({})
function modifier_imba_sticky_napalm_thinker:OnCreated(params)
self.damage = self:GetAbility():GetSpecialValueFor("napalm_damage")
self.duration = self:GetAbility():GetSpecialValueFor("duration")
	if IsServer() then
		self.radius = params.radius
		self.pos = params.pos
		self.int = false
		self.angle = 0
		self.damage_type = DAMAGE_TYPE_MAGICAL		
		local caster = self:GetCaster()
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_POINT, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), 0, 0))
		ParticleManager:SetParticleControl(self.pfx, 15, Vector(70, 70, 70))
		ParticleManager:SetParticleControl(self.pfx, 16, Vector(1, 0, 0))	
		self:AddParticle(self.pfx, false, false, -1, false, false)	
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_sticky_napalm_thinker:OnRefresh()
self.damage = self:GetAbility():GetSpecialValueFor("napalm_damage")
	if IsServer() then
		self.angle = 0
		local caster = self:GetCaster()
		self.damage_type = DAMAGE_TYPE_MAGICAL
		if self.pfx  then			
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)	
		end			
		--self.pfx = ParticleManager:CreateParticle("particles/heros/batrider/imba_batrider_sticky_napalm.vpcf", PATTACH_POINT, self:GetParent())
		--[[self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_shard_fireball.vpcf", PATTACH_POINT, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 2, Vector(self.duration, 0, 0))
		ParticleManager:SetParticleControl(self.pfx, 3, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.pfx, false, false, 1, false, false)]]
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_flame_thrower.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 3, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.pfx, false, false, -1, false, false)				
	end	

end
function modifier_imba_sticky_napalm_thinker:OnIntervalThink(params)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	if not self:GetAbility() then
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end	
	local flamebreak = Entities:FindAllInSphere(self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"))
	for i=1, #flamebreak do
		if not self.int and (((string.find(flamebreak[i]:GetName(), "npc_")) and flamebreak[i]:HasModifier("modifier_imba_life_teshu")) or ((string.find(flamebreak[i]:GetName(), "npc_")) and flamebreak[i]:HasModifier("modifier_imba_batrider_firefly"))) then
			self.int = true
			EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Jakiro.LiquidFire", self:GetParent())
			--self:StartIntervalThink(1)
			self:OnRefresh()
			break
		end
	end
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),	
		nil,	
		self.radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		0,	
		0,	
		false
	)
	if self.int then
		if self.angle >= 1 then
			for _, enemy in pairs(enemies) do
				self.damage_table = {
					victim 			= enemy,
					damage 			= self.damage,
					damage_type		= self.damage_type,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
					ability 		= self:GetAbility()
				}			
				ApplyDamage(self.damage_table)
			end
			self.angle = 0 
		end				
	end
	self.angle = self.angle + FrameTime()
	local pos_forward = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 150
	local pos = RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0,30,0), pos_forward)
	local direction = TG_Direction(pos,self:GetParent():GetAbsOrigin())
	self:GetParent():SetForwardVector(direction)		
end

function modifier_imba_sticky_napalm_thinker:OnDestroy(params)
	if IsServer() then
		self.angle = 0
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end	
		self.int = false
		self:GetParent():RemoveSelf()
	end
end
modifier_imba_sticky_napalm_debuff = class({})

function modifier_imba_sticky_napalm_debuff:IsDebuff()			return true end
function modifier_imba_sticky_napalm_debuff:IsHidden() 		return false end
function modifier_imba_sticky_napalm_debuff:IsPurgable() 		return false end
function modifier_imba_sticky_napalm_debuff:IsPurgeException() return false end

function modifier_imba_sticky_napalm_debuff:OnCreated()
	self.damage = (self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_batrider_5"))
	self.max_stack = self:GetAbility():GetSpecialValueFor("max_stack") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_batrider_1")
	self.int = self:GetAbility():GetSpecialValueFor("napalm_duration")
	self.slow_stack  = self:GetAbility():GetSpecialValueFor("slow_stack")
	self.turn_rate_slow = self:GetAbility():GetSpecialValueFor("turn_rate_slow")
	if IsServer() then
		self:IncrementStackCount()	
		self.non_trigger_inflictors = {
			["imba_batrider_sticky_napalm"] = true,
		}				
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_stickynapalm_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(math.floor(self:GetStackCount() / 10 % 10), self:GetStackCount() % 10, 0))
		self:AddParticle(self.pfx, false, false, -1, false, false)										
	end
end
function modifier_imba_sticky_napalm_debuff:OnRefresh()
	if IsServer() then
		if self:GetStackCount() >= self.max_stack then 
			self:SetStackCount(self.max_stack)
		else
			self:IncrementStackCount()
		end
	end
end
function modifier_imba_sticky_napalm_debuff:OnStackCountChanged(iStack)
	if IsServer() and self.pfx then
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(math.floor(self:GetStackCount() / 10 % 10), self:GetStackCount() % 10, 0))	
	end	
end
function modifier_imba_sticky_napalm_debuff:OnDestroy() 
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end											
	end	
end


function modifier_imba_sticky_napalm_debuff:DeclareFunctions() 
	return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	} 
end
function modifier_imba_sticky_napalm_debuff:GetModifierMoveSpeedBonus_Percentage() 
	return (0 - self:GetStackCount() * self.slow_stack) 
end
function modifier_imba_sticky_napalm_debuff:GetModifierTurnRate_Percentage() 
	return (0 - self.turn_rate_slow) 
end
function modifier_imba_sticky_napalm_debuff:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker:HasModifier("modifier_imba_sticky_napalm_debuff_cd") then return end
	if keys.unit == self:GetParent() and (not keys.inflictor or not self.non_trigger_inflictors[keys.inflictor:GetName()]) and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
		ApplyDamage(
		{
		victim = keys.unit, 
		attacker = self:GetCaster(), 
		ability = self:GetAbility(), 
		damage_type = DAMAGE_TYPE_MAGICAL, 
		damage = self:GetStackCount() * self.damage,
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
		})
		if keys.attacker ~= self:GetCaster() then
			keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_sticky_napalm_debuff_cd", {duration = self.int})
		end		
	end		
end

modifier_imba_sticky_napalm_debuff_cd = class({}) 
function modifier_imba_sticky_napalm_debuff_cd:IsDebuff()			return true end
function modifier_imba_sticky_napalm_debuff_cd:IsHidden() 			return true end
function modifier_imba_sticky_napalm_debuff_cd:IsPurgable() 		return false end
function modifier_imba_sticky_napalm_debuff_cd:IsPurgeException() 	return false end

imba_batrider_flamebreak = class({})

LinkLuaModifier("modifier_imba_batrider_flamebreak_damage", "linken/hero_batrider", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_life_teshu", "linken/hero_batrider", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_life1", "linken/hero_batrider", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_batrider_flamebreak_ta", "linken/hero_batrider", LUA_MODIFIER_MOTION_NONE)

function imba_batrider_flamebreak:IsHiddenWhenStolen() 	return false end
function imba_batrider_flamebreak:IsRefreshable() 		return true end
function imba_batrider_flamebreak:IsStealable() 			return true end
function imba_batrider_flamebreak:GetIntrinsicModifierName() return "modifier_imba_batrider_flamebreak_ta" end
function imba_batrider_flamebreak:GetAOERadius()
	return self:GetSpecialValueFor("explosion_radius")
end
function imba_batrider_flamebreak:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	self.pos = self:GetCursorPosition()
	self.x = 0
	self.duration = self:GetSpecialValueFor("duration") + caster:TG_GetTalentValue("special_bonus_imba_batrider_3")
	local distance = (caster:GetAbsOrigin() - pos):Length2D()
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	--local ability = caster:FindAbilityByName("imba_batrider_firefly")
	direction.z = 0.0
	if (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Length2D() < 150 then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector()*150)
	end
	local dummy = CreateUnitByName("npc_linken_unit", GetGroundPosition(self:GetCaster():GetAbsOrigin(),self:GetCaster()), false, caster, caster, self:GetCaster():GetTeamNumber())
	dummy:EmitSound("Hero_Batrider.Flamebreak")
	dummy:AddNewModifier(self:GetCaster(), self, "modifier_imba_life_teshu", {duration = self.duration})
	dummy:AddNewModifier(caster, nil, "modifier_rooted", {duration = self.duration})
	dummy:AddNewModifier(self:GetCaster(), nil, "modifier_kill", {duration = self.duration})
	--if ability then
		--dummy:AddNewModifier(self:GetCaster(), ability, "modifier_imba_batrider_firefly", {duration = self.duration})
		--dummy:AddNewModifier(self:GetCaster(), ability, "modifier_batrider_firefly", {duration = self.duration})
	--end	

	local flamebreak_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(flamebreak_particle, 0, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 128)) 
	ParticleManager:SetParticleControl(flamebreak_particle, 1, Vector(1200,0,0))
	ParticleManager:SetParticleControl(flamebreak_particle, 5, self:GetCursorPosition())

	if not self.projectile_table then
		self.projectile_table = {
			Ability				= self,
			EffectName			= nil,
			vSpawnOrigin		= nil,
			fDistance			= nil,
			fStartRadius		= 0,
			fEndRadius			= 0,
			Source				= self:GetCaster(),
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_NONE,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_NONE,
			fExpireTime 		= nil,
			bDeleteOnHit		= false,
			vVelocity			= nil,
			bProvidesVision		= true,
			iVisionRadius 		= 175,
			iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),
			
			ExtraData			= nil
		}
	end
	
	self.projectile_table.vSpawnOrigin	= self:GetCaster():GetAbsOrigin()
	self.projectile_table.fDistance		= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Length2D()
	self.projectile_table.fExpireTime 	= GameRules:GetGameTime() + 10.0
	self.projectile_table.vVelocity		= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * 1200 * Vector(1, 1, 0)
	self.projectile_table.ExtraData		= 
	{
		dummy	= dummy:entindex(),
		flamebreak_particle			= flamebreak_particle
	}
	
	ProjectileManager:CreateLinearProjectile(self.projectile_table)
end

function imba_batrider_flamebreak:OnProjectileThink_ExtraData(pos, keys)
	if keys.dummy and EntIndexToHScript(keys.dummy) then
		EntIndexToHScript(keys.dummy):SetOrigin(GetGroundPosition(pos, nil))
		if not self then
			if keys.flamebreak_particle then
				ParticleManager:DestroyParticle(keys.flamebreak_particle, false)
				ParticleManager:ReleaseParticleIndex(keys.flamebreak_particle)
			end			
			EntIndexToHScript(keys.dummy):RemoveSelf()
			return
		end		
		--local ability = self:GetCaster():FindAbilityByName("imba_batrider_firefly")
		--self.x = self.x + 1
		--if 	self.x % 4 == 0 and ability:IsTrained() and (GetGroundPosition(pos, nil) - self.pos):Length2D() > self:GetSpecialValueFor("explosion_radius") then	
		--if 	self.x % 4 == 0 and ability:IsTrained() then	
		--	CreateModifierThinker(self:GetCaster(), self, "modifier_imba_life1", {duration = self.duration}, EntIndexToHScript(keys.dummy):GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)		
			--DebugDrawCircle(self:GetParent():GetAbsOrigin(), Vector(255,0,0), 100, 50, true, 2.0)	
		--end		
	end
end

function imba_batrider_flamebreak:OnProjectileHit_ExtraData(hTarget, pos, keys)
	if not self then
		if keys.flamebreak_particle then
			ParticleManager:DestroyParticle(keys.flamebreak_particle, false)
			ParticleManager:ReleaseParticleIndex(keys.flamebreak_particle)
		end		
		EntIndexToHScript(keys.dummy):RemoveSelf()
		return
	end		
	EmitSoundOnLocationWithCaster(pos, "Hero_Batrider.Flamebreak.Impact", self:GetCaster())
	local ability = self:GetCaster():FindAbilityByName("imba_batrider_sticky_napalm")
	if ability and ability:IsTrained()  then
		self:GetCaster():SetCursorPosition(GetGroundPosition(pos,EntIndexToHScript(keys.dummy)))
		ability:OnSpellStart()
	end	
	Timers:CreateTimer(0.1, function ()
		if keys.dummy then
			EntIndexToHScript(keys.dummy):StopSound("Hero_Batrider.Flamebreak")
			--EntIndexToHScript(keys.dummy):FindModifierByName("modifier_imba_batrider_firefly"):Destroy()
			--EntIndexToHScript(keys.dummy):RemoveSelf()
		end
	end)

	
	if keys.flamebreak_particle then
		ParticleManager:DestroyParticle(keys.flamebreak_particle, false)
		ParticleManager:ReleaseParticleIndex(keys.flamebreak_particle)
	end	
	if keys.dummy and EntIndexToHScript(keys.dummy) then
		EntIndexToHScript(keys.dummy):SetOrigin(GetGroundPosition(pos, nil))
		local dummy = EntIndexToHScript(keys.dummy)
		local parent_loc = dummy:GetAbsOrigin()
		local knockback_max_distance = self:GetSpecialValueFor("knockback_max_distance")
		local knockback_duration = self:GetSpecialValueFor("knockback_duration")
		local knockback_height = self:GetSpecialValueFor("knockback_height")
		self.damage = self:GetSpecialValueFor("damage")
		self.damage_type = DAMAGE_TYPE_MAGICAL				
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), pos, nil, self:GetSpecialValueFor("explosion_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)		
		for _, enemy in pairs(enemies) do
			self.damage_table = {
				victim 			= enemy,
				damage 			= self.damage,
				damage_type		= self.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self
			}			
			ApplyDamage(self.damage_table)
			knockback_properties = {
				 center_x 			= parent_loc.x,
				 center_y 			= parent_loc.y,
				 center_z 			= parent_loc.z,
				 duration 			= knockback_duration,
				 knockback_duration = knockback_duration,
				 knockback_distance = knockback_max_distance,
				 knockback_height 	= knockback_height,
				}
			if self:GetAutoCastState() then
				knockback_properties.knockback_distance = 0
			end		
			local knockback_modifier = enemy:AddNewModifier(self:GetCaster(), self, "modifier_knockback", knockback_properties)
			if knockback_modifier then
				knockback_modifier:SetDuration(0.35, true) 
			end				
			local damage_modifier = enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_batrider_flamebreak_damage",
			{
				duration			= self.duration,
				damage_per_second	= self:GetSpecialValueFor("debuff_damage"),
				damage_type			= self:GetAbilityDamageType()
			})
		end		
	end
end

modifier_imba_batrider_flamebreak_damage = class({})
function modifier_imba_batrider_flamebreak_damage:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_batrider_flamebreak_damage:OnCreated(params)
	if not IsServer() then return end
	
	self.damage_per_second	= params.damage_per_second
	self.damage_type		= params.damage_type
	
	self.damage_table = {
		victim 			= self:GetParent(),
		damage 			= self.damage_per_second,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	}
	
	self:StartIntervalThink(1)
end

function modifier_imba_batrider_flamebreak_damage:OnIntervalThink()
	ApplyDamage(self.damage_table)
	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage_per_second, nil)
		
	if self:GetParent():IsRealHero() and not self:GetParent():IsAlive() and self:GetCaster():GetName() == "npc_dota_hero_batrider" and RollPercentage(50) then		
		self:GetCaster():EmitSound("batrider_bat_ability_firefly_0"..RandomInt(1, 6))
	end
end
modifier_imba_life_teshu = class({})

function modifier_imba_life_teshu:IsDebuff()			return true end
function modifier_imba_life_teshu:IsHidden() 			return false end
function modifier_imba_life_teshu:IsPurgable() 		return false end
function modifier_imba_life_teshu:IsPurgeException() 	return false end
function modifier_imba_life_teshu:IsStunDebuff() return true end
function modifier_imba_life_teshu:CheckState() return 
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
modifier_imba_batrider_flamebreak_ta = class({})

function modifier_imba_batrider_flamebreak_ta:IsDebuff()			return false end
function modifier_imba_batrider_flamebreak_ta:IsHidden() 			return true end
function modifier_imba_batrider_flamebreak_ta:IsPurgable() 			return false end
function modifier_imba_batrider_flamebreak_ta:IsPurgeException() 	return false end
function modifier_imba_batrider_flamebreak_ta:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_imba_batrider_flamebreak_ta:OnIntervalThink()
	if self:GetCaster():TG_HasTalent("special_bonus_imba_batrider_6") then
		local ability = self:GetAbility()
		AbilityChargeController:AbilityChargeInitialize(ability, ability:GetCooldown(4 - 1), self:GetCaster():TG_GetTalentValue("special_bonus_imba_batrider_6"), 1, true, true)
		self:StartIntervalThink(-1)
		return
		self:Destroy()
	end	
end
imba_batrider_firefly = class({})
LinkLuaModifier("modifier_imba_batrider_firefly", "linken/hero_batrider", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_firefly_mov", "linken/hero_batrider", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_firefly_mov_thinker", "linken/hero_batrider", LUA_MODIFIER_MOTION_NONE)
function imba_batrider_firefly:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_batrider_2") then 
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_batrider_2"))
	end
	return cooldown
end
function imba_batrider_firefly:GetAbilityTextureName()  
	if self:GetCaster():HasModifier("modifier_imba_batrider_firefly") then 	
		return "phoenix_sun_ray" 
	else
		return	"batrider_firefly"
	end	
end
function imba_batrider_firefly:GetManaCost(a) 
	if self:GetCaster():HasModifier("modifier_imba_batrider_firefly") then  
		return 50	
	end
	return 125 
end
function imba_batrider_firefly:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Batrider.Firefly.Cast")
	self.duration = self:GetSpecialValueFor("duration") + caster:TG_GetTalentValue("special_bonus_imba_batrider_8")
	local pos = caster:GetAbsOrigin() + caster:GetForwardVector()*self:GetSpecialValueFor("distance")
	local duration = (caster:GetAbsOrigin() - pos):Length2D() / (self:GetSpecialValueFor("speed"))
	local modifier = caster:HasModifier("modifier_imba_batrider_firefly")
	if modifier then
		local modifier_int = caster:FindModifierByName("modifier_imba_batrider_firefly")
		local stack = modifier_int:GetStackCount()
		if modifier_int:GetStackCount() >= 1 then
			modifier_int:DecrementStackCount()
			caster:AddNewModifier(caster, self, "modifier_imba_firefly_mov", {duration = duration, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
			self:EndCooldown()
			self:StartCooldown(self:GetSpecialValueFor("cd"))
			if modifier_int:GetStackCount() == 0 then
				self:SetActivated(false)
			end	
		end	
	else	
		caster:AddNewModifier(caster, self, "modifier_imba_batrider_firefly", {duration = self.duration})
		self.dummy_pfx = CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_imba_firefly_mov_thinker", -- modifier name
			{
				duration = self.duration,
			}, -- kv
			caster:GetAbsOrigin(),
			self:GetCaster():GetTeamNumber(),
			false
		)		
		self:EndCooldown()
	end
end

modifier_imba_batrider_firefly = class({})
function modifier_imba_batrider_firefly:IsDebuff()			return false end
function modifier_imba_batrider_firefly:IsHidden() 			return false end
function modifier_imba_batrider_firefly:IsPurgable() 		return false end
function modifier_imba_batrider_firefly:IsPurgeException() 	return false end
function modifier_imba_batrider_firefly:GetTexture() return "batrider_firefly" end
function modifier_imba_batrider_firefly:OnCreated()
	self.add_vision	= self:GetAbility():GetSpecialValueFor("add_vision")
	self.sp_radius	= self:GetAbility():GetSpecialValueFor("sp_radius")	
	self.damage 	= self:GetAbility():GetSpecialValueFor("damage_per_second")
	self.movement_speed 	= self:GetAbility():GetSpecialValueFor("movement_speed")	
	self.stack 	= self:GetAbility():GetSpecialValueFor("stack") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_batrider_4")
	if not IsServer() then return end
		self.pfx = ParticleManager:CreateParticle("particles/heros/batrider/imba_batrider_sticky_napalm.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 5, Vector(self.sp_radius, 0, 0))
		self:AddParticle(self.pfx, false, false, -1, false, false)
		self:SetStackCount(self.stack)	
	self:StartIntervalThink(1)
end
function modifier_imba_batrider_firefly:OnIntervalThink()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.sp_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		self.damage_table = {
			victim 			= enemy,
			damage 			= self.damage,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		}			
		ApplyDamage(self.damage_table)
	end
end	
function modifier_imba_batrider_firefly:OnDestroy()
	if not IsServer() then return end
	if self.pfx  then			
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)	
	end		
	self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(self:GetAbility():GetLevel() -1 ) * self:GetCaster():GetCooldownReduction()) - self:GetElapsedTime())
	self:GetAbility():SetActivated(true)
end

function modifier_imba_batrider_firefly:CheckState()
	return {[MODIFIER_STATE_FLYING]	= true}
end

function modifier_imba_batrider_firefly:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
			MODIFIER_PROPERTY_BONUS_DAY_VISION,
			MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
			}
end

function modifier_imba_batrider_firefly:GetBonusDayVision()
	return self.add_vision	
end
function modifier_imba_batrider_firefly:GetBonusNightVision()
	return self.add_vision
end
function modifier_imba_batrider_firefly:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed
end
modifier_imba_firefly_mov_thinker = class({})
function modifier_imba_firefly_mov_thinker:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(FrameTime())
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_flame_thrower.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin()+Vector(0,0,200))
		ParticleManager:SetParticleControl(self.pfx, 3, self:GetParent():GetAbsOrigin()+Vector(0,0,200))
		self:AddParticle(self.pfx, false, false, -1, false, false)			
	end
end
function modifier_imba_firefly_mov_thinker:OnIntervalThink()
	self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin()+Vector(0,0,200))
	self:GetParent():SetForwardVector(Vector(-self:GetCaster():GetForwardVector()[1], -self:GetCaster():GetForwardVector()[2], 0))
end	
function modifier_imba_firefly_mov_thinker:OnDestroy()
	if IsServer() then
		if self.pfx then
	    	ParticleManager:DestroyParticle(self.pfx, false)
	    	ParticleManager:ReleaseParticleIndex(self.pfx)
	    end		
		self:GetParent():RemoveSelf()
	end
end
modifier_imba_firefly_mov = class({})
function modifier_imba_firefly_mov:IsDebuff()			return false end
function modifier_imba_firefly_mov:IsHidden() 			return true end
function modifier_imba_firefly_mov:IsPurgable() 		return false end
function modifier_imba_firefly_mov:IsPurgeException() 	return false end
function modifier_imba_firefly_mov:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_MAGIC_IMMUNE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true} end
function modifier_imba_firefly_mov:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_DISABLE_TURNING} end
function modifier_imba_firefly_mov:GetModifierDisableTurning() return 1 end
function modifier_imba_firefly_mov:IsMotionController() return true end
function modifier_imba_firefly_mov:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function modifier_imba_firefly_mov:OnCreated(keys)
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
	if IsServer() then
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)		
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())	
	end
end
function modifier_imba_firefly_mov:OnIntervalThink()
	if not IsServer() then return end 
	local current_pos = self:GetParent():GetAbsOrigin()
	local distacne = self.speed / (1.0 / FrameTime())
	local direction = (self.pos - current_pos):Normalized()
	direction.z = 0
	local next_pos = GetGroundPosition((current_pos + direction * distacne), nil)
	self:GetParent():SetOrigin(next_pos)
	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 200, false)
end
function modifier_imba_firefly_mov:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		self.pos = nil
		self.speed = nil
		self:GetParent():SetForwardVector(Vector(self:GetParent():GetForwardVector()[1], self:GetParent():GetForwardVector()[2], 0))
	end
end
imba_batrider_flaming_lasso = class({})
LinkLuaModifier("modifier_imba_batrider_flaming_lasso", "linken/hero_batrider", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_batrider_flaming_lasso_self", "linken/hero_batrider", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_lasso_illusions", "linken/hero_batrider", LUA_MODIFIER_MOTION_NONE)
function imba_batrider_flaming_lasso:GetCastRange()
	if IsServer() then
		if self:GetAutoCastState() then
			return self:GetSpecialValueFor("auto_range")
		end	
	end	
	return self:GetSpecialValueFor("range") 	
end
function imba_batrider_flaming_lasso:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "dota_hud_error_cant_cast_on_self"
	elseif not IsEnemy(self:GetCaster(), target) and not self:GetCaster():Has_Aghanims_Shard() then
		return "未使用阿哈利姆魔晶"
	elseif not target:IsUnit() then
		return "无法使用"
	end		
end
function imba_batrider_flaming_lasso:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		if target == caster then
			return UF_FAIL_CUSTOM
		elseif not IsEnemy(self:GetCaster(), target) and not self:GetCaster():Has_Aghanims_Shard() then
			return UF_FAIL_CUSTOM
		--elseif not target:IsUnit() then
		--	return UF_FAIL_CUSTOM
		end
		if target:IsCourier() then
			return UF_FAIL_COURIER
		end		
		local nResult = UnitFilter(target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), caster:GetTeamNumber())
		return nResult		
	end
end
function imba_batrider_flaming_lasso:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_batrider_7") then 
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_batrider_7"))
	end
	return cooldown
end
function imba_batrider_flaming_lasso:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	local ability = target:FindModifierByName("modifier_imba_sticky_napalm_debuff")
	if not IsEnemy(target, caster) then
		self:EndCooldown()
		self:StartCooldown((20) * caster:GetCooldownReduction())
	end		

	self.duration = self:GetSpecialValueFor("duration")
	if ability then
		local stack = ability:GetStackCount() * self:GetSpecialValueFor("int_time")
		self.duration = self:GetSpecialValueFor("duration") + stack
	end	
	
	if target:TG_TriggerSpellAbsorb(self) then return end
	
	self:GetCaster():EmitSound("Hero_Batrider.FlamingLasso.Cast")

	if not self:GetAutoCastState() then
		local lasso_modifier = target:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_batrider_flaming_lasso", {
			duration			= self.duration,
			attacker_entindex	= self:GetCaster():entindex()
		})

		if self:GetCaster():HasScepter() and IsEnemy(caster,target) then
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("grab_radius_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
			
			for _, enemy in pairs(enemies) do
				if enemy ~= target and enemy:IsConsideredHero() then
					local secondary_lasso_modifier = enemy:AddNewModifier(target, self, "modifier_imba_batrider_flaming_lasso", {
						duration			= self.duration,
						attacker_entindex	= self:GetCaster():entindex()
					})				
					break
				end
			end
		end
		local self_lasso_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_batrider_flaming_lasso_self", {duration = self.duration})
	   	
	else	
	   	local modifier=
	    {
	        outgoing_damage=0,
	        incoming_damage=0,
	        bounty_base=0,
	        bounty_growth=0,
	        outgoing_damage_structure=0,
	        outgoing_damage_roshan=0,
	    }
	  	local illusions=CreateIllusions(caster, caster, modifier, 1,0, false, true)
	    for _, illusion in pairs(illusions) do
	        illusion:AddNewModifier(caster, self, "modifier_kill", {duration=30})
	        illusion:AddNewModifier(caster, self, "modifier_imba_lasso_illusions", {target=target:entindex()})
	    end
		self:EndCooldown()
		self:StartCooldown(self:GetSpecialValueFor("cd"))	    
	end
end
modifier_imba_lasso_illusions=class({})

function modifier_imba_lasso_illusions:IsHidden() 			return false end
function modifier_imba_lasso_illusions:IsPurgable() 			return false end
function modifier_imba_lasso_illusions:IsPurgeException() 	return false end
function modifier_imba_lasso_illusions:RemoveOnDeath() 		return true end
function modifier_imba_lasso_illusions:GetStatusEffectName() 	return "particles/status_fx/status_effect_charge_of_darkness.vpcf" end
function modifier_imba_lasso_illusions:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_lasso_illusions:GetMotionPriority() 	return DOTA_MOTION_CONTROLLER_PRIORITY_LOW   end
function modifier_imba_lasso_illusions:OnCreated(keys)
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.range = self.ability:GetSpecialValueFor("range")  
    self.break_distance = self.ability:GetSpecialValueFor("break_distance")
    if not IsServer() then
        return
    end
    self.speed = self.caster:GetMoveSpeedModifier(self.caster:GetBaseMoveSpeed(), true)
    self.target=EntIndexToHScript(keys.target)
	local modifier = self.target:FindModifierByName("modifier_imba_sticky_napalm_debuff")	
	if modifier then
		local stack = modifier:GetStackCount() * self.ability:GetSpecialValueFor("int_time")
		self.duration = self.ability:GetSpecialValueFor("duration") + stack
	end        
    self.bool = false
    local target_pos = self.target:GetAbsOrigin()
    self.parent:MoveToPosition(target_pos)
    self:StartIntervalThink(FrameTime())
end
function modifier_imba_lasso_illusions:OnIntervalThink()
	local caste_pos = self.caster:GetAbsOrigin()
	local target_pos = self.target:GetAbsOrigin()
	local parent_pos = self.parent:GetAbsOrigin()
	local direction = TG_Direction(target_pos,parent_pos)
	local distance =	TG_Distance(target_pos,parent_pos)
	local next_pos = parent_pos+direction*(self.speed / (1.0 / FrameTime()))
	if distance > self.range and not self.bool then
		self.parent:SetForwardVector(direction)
		self.parent:SetAbsOrigin(next_pos)
	elseif distance <= self.range and not self.bool then
		local lasso_modifier = self.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_imba_batrider_flaming_lasso", {
			duration			= self.duration,
			attacker_entindex	= self.target:entindex()
		})
		self.bool = true
		if self.caster:HasScepter() and IsEnemy(self.caster,self.target) then
			local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.target:GetAbsOrigin(), nil, self.ability:GetSpecialValueFor("grab_radius_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				if enemy ~= self.target and enemy:IsConsideredHero() then
					local secondary_lasso_modifier = enemy:AddNewModifier_RS(self.target, self.ability, "modifier_imba_batrider_flaming_lasso", {
						duration			= self.duration,
						attacker_entindex	= self.caster:entindex()
					})				
					break
				end
			end
		end		
	elseif self.bool and TG_Distance(caste_pos,parent_pos)	>= 50 then
		direction = TG_Direction(caste_pos,parent_pos)
		next_pos = parent_pos+direction*(self.speed / (1.0 / FrameTime()))
		self.parent:SetForwardVector(direction)
		self.parent:SetAbsOrigin(next_pos)
	elseif	self.bool and TG_Distance(caste_pos,parent_pos)	< 50 then
		local modifier = self.target:FindModifierByName("modifier_imba_batrider_flaming_lasso")
		if modifier then
			self.duration = modifier:GetRemainingTime()
			local lasso_modifier = self.target:AddNewModifier(self.caster, self:GetAbility(), "modifier_imba_batrider_flaming_lasso", {
				duration			= self.duration,
				attacker_entindex	= self.caster:entindex()
			})	
		end		
        self:Destroy()
        self.parent:ForceKill(false)
        return       
	end
    if	self.bool and not self.target:HasModifier("modifier_imba_batrider_flaming_lasso") then
        self:Destroy()
        self.parent:ForceKill(false)
        return
    end
    if	self.bool and TG_Distance(caste_pos,parent_pos)	> self.break_distance then
        self:Destroy()
        self.parent:ForceKill(false)
        return
    end         	
end


function modifier_imba_lasso_illusions:OnDestroy()
    if not IsServer() then
        return
    end
    self.bool = false
end

function modifier_imba_lasso_illusions:CheckState()
    return
    {
          [MODIFIER_STATE_DISARMED] = true,
          [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,   
          [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,   
          [MODIFIER_STATE_INVULNERABLE] = true, 
          [MODIFIER_STATE_UNSELECTABLE] = true,    
          [MODIFIER_STATE_UNTARGETABLE] = true,    
          [MODIFIER_STATE_NO_HEALTH_BAR] = true,   
      } 
end

modifier_imba_batrider_flaming_lasso = class({})
function modifier_imba_batrider_flaming_lasso:IsDebuff()	return true end

function modifier_imba_batrider_flaming_lasso:GetEffectName()
	return "particles/units/heroes/hero_batrider/batrider_flaming_lasso_generic_smoke.vpcf"
end

function modifier_imba_batrider_flaming_lasso:OnCreated(params)
	if not IsServer() then return end
	
	if params.attacker_entindex then
		self.attacker = EntIndexToHScript(params.attacker_entindex)
	else
		self.attacker = self:GetCaster()
	end
	
	self.drag_distance			= self:GetAbility():GetSpecialValueFor("drag_distance")
	self.break_distance			= self:GetAbility():GetSpecialValueFor("break_distance")
	self.max_time			= self:GetAbility():GetSpecialValueFor("max_time")	
	
	if self:GetCaster():HasScepter() then
		self.damage				= self:GetAbility():GetSpecialValueFor("scepter_damage")
	else
		self.damage				= self:GetAbility():GetSpecialValueFor("damage")
	end
	
	self.counter			= 0
	self.damage_instances	= 1 - self:GetParent():GetStatusResistance()
	self.interval			= FrameTime()
	
	self.chariot_max_length	= self:GetAbility():GetCastRange(self:GetParent():GetAbsOrigin(), self:GetParent())
	self.vector				= self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
	self.current_position	= self:GetCaster():GetAbsOrigin()	
	
	self.damage_table = {
		victim 			= self:GetParent(),
		damage 			= self.damage,
		damage_type		= self:GetAbility():GetAbilityDamageType(),
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self.attacker,
		ability 		= self:GetAbility()
	}
	
	self:GetParent():EmitSound("Hero_Batrider.FlamingLasso.Loop")
	if self.lasso_particle then
    	ParticleManager:DestroyParticle(self.lasso_particle, false)
    	ParticleManager:ReleaseParticleIndex(self.lasso_particle)
	end	
	self.lasso_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flaming_lasso.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	
	if self:GetCaster():GetName() == "npc_dota_hero_batrider" then
		ParticleManager:SetParticleControlEnt(self.lasso_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "lasso_attack", self:GetCaster():GetAbsOrigin(), true)
	else
		ParticleManager:SetParticleControlEnt(self.lasso_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	end
	
	ParticleManager:SetParticleControlEnt(self.lasso_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

	self:AddParticle(self.lasso_particle, false, false, -1, false, false)
	
	self:StartIntervalThink(self.interval)
end

function modifier_imba_batrider_flaming_lasso:OnRefresh(params)
	self:OnCreated(params)
end

function modifier_imba_batrider_flaming_lasso:OnIntervalThink()

	if (self:GetCaster():GetAbsOrigin() - self.current_position):Length2D() > self.break_distance or not self:GetCaster():IsAlive() then
		self:Destroy()
	else
		self.vector				= self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
		self.current_position	= self:GetCaster():GetAbsOrigin()
		
		if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() > self.drag_distance then
			self:GetParent():SetAbsOrigin(GetGroundPosition(self:GetCaster():GetAbsOrigin() + self.vector:Normalized() * self.drag_distance, nil))
		end
	end
	self.counter = self.counter + self.interval
	
	if self.counter >= self.damage_instances then
		ApplyDamage(self.damage_table)
		self.counter = 0
	end

	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 200, 1, true)			
end

function modifier_imba_batrider_flaming_lasso:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_Batrider.FlamingLasso.Loop")
	self:GetParent():EmitSound("Hero_Batrider.FlamingLasso.End")

	local self_lasso_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_batrider_flaming_lasso_self", self:GetCaster())

	if self_lasso_modifier then
		self_lasso_modifier:Destroy()
	end
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)	
end

function modifier_imba_batrider_flaming_lasso:CheckState()
	return {
		[MODIFIER_STATE_STUNNED]							= true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY]	= true
	}
end

function modifier_imba_batrider_flaming_lasso:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end
function modifier_imba_batrider_flaming_lasso:GetModifierIncomingDamage_Percentage()
	if not IsEnemy(self:GetCaster(), self:GetParent()) then
		return 0-80
	end	
	return 0
end

function modifier_imba_batrider_flaming_lasso:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

modifier_imba_batrider_flaming_lasso_self = class({})
function modifier_imba_batrider_flaming_lasso_self:IsDebuff()	return true end
function modifier_imba_batrider_flaming_lasso_self:IsPurgable()	return false end
function modifier_imba_batrider_flaming_lasso_self:IsHidden() 			return true end
function modifier_imba_batrider_flaming_lasso_self:CheckState()
	return {
		[MODIFIER_STATE_DISARMED]	= true
	}
end

function modifier_imba_batrider_flaming_lasso_self:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, 
			
			}
end

function modifier_imba_batrider_flaming_lasso_self:GetOverrideAnimation()
	return ACT_DOTA_LASSO_LOOP
end