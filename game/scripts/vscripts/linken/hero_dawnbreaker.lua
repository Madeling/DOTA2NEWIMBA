--2021.04.10 by你收拾收拾准备出林肯吧
CreateTalents("npc_dota_hero_dawnbreaker", "linken/hero_dawnbreaker")
imba_dawnbreaker_fire_wreath = class({})
--技能期间可移动，并且攻击速度可加成技能攻击速度
function imba_dawnbreaker_fire_wreath:IsHiddenWhenStolen() 	return false end
function imba_dawnbreaker_fire_wreath:IsRefreshable() 		return true end
function imba_dawnbreaker_fire_wreath:IsStealable() 			return true end

LinkLuaModifier("modifier_imba_dawnbreaker_fire_wreath", "linken/hero_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fire_wreath_talent", "linken/hero_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_dawnbreaker_fire_wreath:GetIntrinsicModifierName() return "modifier_imba_fire_wreath_talent" end
function imba_dawnbreaker_fire_wreath:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	if self:GetCaster():Has_Aghanims_Shard() then 
		return (cooldown + self:GetSpecialValueFor("agh_cd"))
	end
	return cooldown
end
function imba_dawnbreaker_fire_wreath:GetCustomCastErrorLocation()
	if self:GetCaster():HasModifier("modifier_imba_dawnbreaker_fire_wreath") then
		return "技能持续期间无法继续释放"
	end
end
function imba_dawnbreaker_fire_wreath:CastFilterResultLocation(vLoc)
	if self:GetCaster():HasModifier("modifier_imba_dawnbreaker_fire_wreath") then
		return UF_FAIL_CUSTOM
	end
end
function imba_dawnbreaker_fire_wreath:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local int = math.min(math.max(caster:GetAttacksPerSecond()*0.5,1), 2)
	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, int)
	return true		
end
function imba_dawnbreaker_fire_wreath:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local time = self:GetSpecialValueFor("duration")
	caster:MoveToPosition(pos)
	caster:AddNewModifier(caster, self, "modifier_imba_dawnbreaker_fire_wreath", {duration = time})

end
modifier_imba_dawnbreaker_fire_wreath = class({})

function modifier_imba_dawnbreaker_fire_wreath:IsDebuff()			return false end
function modifier_imba_dawnbreaker_fire_wreath:IsHidden() 			return true end
function modifier_imba_dawnbreaker_fire_wreath:IsPurgable() 			return false end
function modifier_imba_dawnbreaker_fire_wreath:IsPurgeException() 	return false end
function modifier_imba_dawnbreaker_fire_wreath:CheckState() return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_MAGIC_IMMUNE] = true, [MODIFIER_STATE_DISARMED] = true} end
function modifier_imba_dawnbreaker_fire_wreath:GetStatusEffectName()
  	return "particles/status_fx/status_effect_dawnbreaker_fire_wreath_magic_immunity.vpcf"
end
function modifier_imba_dawnbreaker_fire_wreath:StatusEffectPriority() return 10001 end
function modifier_imba_dawnbreaker_fire_wreath:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end
function modifier_imba_dawnbreaker_fire_wreath:GetModifierPreAttack_BonusDamage(keys)

	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() or self:GetParent():IsIllusion() or not (keys.target:IsHero() or keys.target:IsCreep() or keys.target:IsBoss()) then
		return
	end
	if self.cishu ~= 3 then
    	return self:GetAbility():GetSpecialValueFor("swipe_damage") + self:GetParent():TG_GetTalentValue("special_bonus_imba_dawnbreaker_2")
    else
    	return self:GetAbility():GetSpecialValueFor("smash_damage") + self:GetParent():TG_GetTalentValue("special_bonus_imba_dawnbreaker_2")
    end
    	
end
function modifier_imba_dawnbreaker_fire_wreath:GetModifierIncomingDamage_Percentage(keys)
	if keys.target == self:GetParent() or not keys.target:IsAlive() or not self:GetParent():IsIllusion() then 
  		return -100
  	end	 
end
function modifier_imba_dawnbreaker_fire_wreath:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA 
end
function modifier_imba_dawnbreaker_fire_wreath:OnCreated()
	self.swipe_radius = self:GetAbility():GetSpecialValueFor("swipe_radius")
	self.smash_radius = self:GetAbility():GetSpecialValueFor("smash_radius")
	self.time = self:GetAbility():GetSpecialValueFor("duration")
	self.total_attacks = self:GetAbility():GetSpecialValueFor("total_attacks") - 1
	self.interval = self.time / self.total_attacks
	self.smash_stun_duration = self:GetAbility():GetSpecialValueFor("smash_stun_duration")
	if IsServer() then
		local caster = self:GetCaster()
		self.cishu = 1
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_sweep_cast.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_sweep.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx2, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx2)



		--caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
		local int = math.min(math.max(caster:GetAttacksPerSecond()*0.5,1), 2)
		self.interval = self.interval / int
		caster:StartGestureWithPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_1, int)
		local enemy = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			caster:GetAbsOrigin(), 
			nil, 
			self.swipe_radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			FIND_ANY_ORDER, 
			false
			)		
		for i=1, #enemy do
			caster:PerformAttack(enemy[i], false, true, true, false, true, false, true)
			--local pfx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_impact.vpcf", PATTACH_CUSTOMORIGIN, enemy[i])
			--ParticleManager:SetParticleControl(pfx3, 0, enemy[i]:GetAbsOrigin())
			--ParticleManager:ReleaseParticleIndex(pfx3)			
		end	
		caster:EmitSound("Hero_Dawnbreaker.Fire_Wreath.Sweep")	
		caster:EmitSound("Hero_Dawnbreaker.Fire_Wreath.Cast")				
		self:StartIntervalThink(self.interval)
	end
end
function modifier_imba_dawnbreaker_fire_wreath:OnIntervalThink()
	local caster = self:GetCaster()
	if 	self.cishu == self.total_attacks then
		self.cishu = self.cishu + 1
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_sweep_overhead.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControlOrientation(pfx, 0, caster:GetForwardVector(), caster:GetRightVector(), caster:GetUpVector())
		ParticleManager:ReleaseParticleIndex(pfx)

		local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_smash.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin() + caster:GetForwardVector() * 185)
		ParticleManager:ReleaseParticleIndex(pfx2)

		local enemy = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			caster:GetAbsOrigin() + caster:GetForwardVector() * 185, 
			nil, 
			self.smash_radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			FIND_ANY_ORDER, 
			false
			)		
		for i=1, #enemy do
			caster:PerformAttack(enemy[i], false, true, true, false, true, false, true)
			--local pfx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_impact.vpcf", PATTACH_CUSTOMORIGIN, enemy[i])
			--ParticleManager:SetParticleControl(pfx3, 0, enemy[i]:GetAbsOrigin())
			--ParticleManager:ReleaseParticleIndex(pfx3)				
			local parent_loc = self:GetCaster():GetAbsOrigin()
				knockback_properties = {
					 center_x 			= parent_loc.x,
					 center_y 			= parent_loc.y,
					 center_z 			= parent_loc.z,
					 duration 			= 0.3,
					 knockback_duration = 0.3,
					 knockback_distance = 0,
					 knockback_height 	= 200,
					}	
			local knockback_modifier = enemy[i]:AddNewModifier_RS(self:GetCaster(), self:GetAbility(), "modifier_knockback", knockback_properties)
			
			if knockback_modifier then
				local smash_stun_duration = self:GetAbility():GetSpecialValueFor( "smash_stun_duration" )
				if self:GetCaster():Has_Aghanims_Shard() then
					smash_stun_duration = self:GetAbility():GetSpecialValueFor( "smash_stun_duration" ) + self:GetAbility():GetSpecialValueFor( "agh_duration" )
				end	
				knockback_modifier:SetDuration(smash_stun_duration, true) 
			end				
		end				
		self.cishu = 1
		caster:EmitSound("Hero_Dawnbreaker.Solar_Guardian.Stun")
		caster:EmitSound("Hero_Dawnbreaker.Fire_Wreath.Smash")
		self:StartIntervalThink(-1)
		return
		self:Destroy()
	end			
		self.cishu = self.cishu + 1
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_sweep_cast.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
		local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_sweep.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx2, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx2)							
		local enemy = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		caster:GetAbsOrigin(), 
		nil, 
		self.swipe_radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
		FIND_ANY_ORDER, 
		false
		)		
	for i=1, #enemy do
		caster:PerformAttack(enemy[i], false, true, true, false, true, false, true)
		local pfx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_impact.vpcf", PATTACH_CUSTOMORIGIN, enemy[i])
		ParticleManager:SetParticleControl(pfx3, 0, enemy[i]:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx3)			
	end
	caster:EmitSound("Hero_Dawnbreaker.Fire_Wreath.Sweep")
	caster:EmitSound("Hero_Dawnbreaker.Fire_Wreath.Layer")
end
function modifier_imba_dawnbreaker_fire_wreath:OnRemoved()
	if IsServer() then

	end
end

modifier_imba_fire_wreath_talent = class({})
function modifier_imba_fire_wreath_talent:IsDebuff()			return false end
function modifier_imba_fire_wreath_talent:IsHidden() 			return true end
function modifier_imba_fire_wreath_talent:IsPurgable() 		return false end
function modifier_imba_fire_wreath_talent:IsPurgeException() 	return false end

function modifier_imba_fire_wreath_talent:OnCreated()
	if not IsServer() then return end
	if not self:GetParent():IsIllusion() then
		AbilityChargeController:AbilityChargeInitialize(self:GetAbility(), self:GetAbility():GetCooldown(4 - 1), 1, 1, true, true)
		self:StartIntervalThink(0.5)
	end
end

function modifier_imba_fire_wreath_talent:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():TG_HasTalent("special_bonus_imba_dawnbreaker_1") then
		AbilityChargeController:ChangeChargeAbilityConfig(self:GetAbility(), self:GetAbility():GetCooldown(4 - 1), 2, 1, true, true)
	else
		AbilityChargeController:ChangeChargeAbilityConfig(self:GetAbility(), self:GetAbility():GetCooldown(4 - 1), 1, 1, true, true)
	end
end

imba_dawnbreaker_celestial_hammer = class({})

function imba_dawnbreaker_celestial_hammer:IsHiddenWhenStolen() 	return false end
function imba_dawnbreaker_celestial_hammer:IsRefreshable() 		return true end
function imba_dawnbreaker_celestial_hammer:IsStealable() 			return true end
function imba_dawnbreaker_celestial_hammer:GetCastRange()if IsClient() then return self:GetSpecialValueFor("range") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_dawnbreaker_3") end end
LinkLuaModifier("modifier_imba_dawnbreaker_hammer", "linken/hero_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dawnbreaker_hammer_thinker", "linken/hero_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dawnbreaker_hammer_slow", "linken/hero_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_dawnbreaker_celestial_hammer:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	if not caster:HasModifier("modifier_imba_dawnbreaker_hammer") then
		caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 1)
	else
		caster:StartGestureWithPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_1, 1.7)
	end	
	return true		
end
function imba_dawnbreaker_celestial_hammer:GetCastPoint()
	if	IsServer()  then 
		local caster = self:GetCaster()
		if not caster:HasModifier("modifier_imba_dawnbreaker_hammer") then
			return 0.15
		else
			return 0.35
		end
	end		 
end
function imba_dawnbreaker_celestial_hammer:GetAOERadius()
	local radius = self:GetSpecialValueFor("hammer_aoe_radius")
	return radius		 
end
function imba_dawnbreaker_celestial_hammer:GetBehavior()
	if self:GetCaster():HasModifier("modifier_imba_dawnbreaker_hammer") then  
		return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT
	end
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end
function imba_dawnbreaker_celestial_hammer:GetManaCost(a) 
	if self:GetCaster():HasModifier("modifier_imba_dawnbreaker_hammer") then  
		return 0	
	end
	return 110 
end
function imba_dawnbreaker_celestial_hammer:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_dawnbreaker_hammer") then  
		return  "dawnbreaker_converge"	
	end
	return "dawnbreaker_celestial_hammer"
end
function imba_dawnbreaker_celestial_hammer:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local range = self:GetSpecialValueFor("range") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_dawnbreaker_3")
	local radius = self:GetSpecialValueFor("hammer_aoe_radius")
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0.0	
	if caster:HasModifier("modifier_imba_dawnbreaker_hammer") then
		if self.pos then
			FindClearSpaceForUnit(caster, self.pos, false)
		end	
		caster:RemoveModifierByName("modifier_imba_dawnbreaker_hammer")
		caster:EmitSound("Hero_Dawnbreaker.Celestial_Hammer.Return") 
		caster:EmitSound("Hero_Dawnbreaker.Solar_Guardian.BlastOff")
	else
		caster:EmitSound("Hero_Dawnbreaker.Celestial_Hammer.Impact")
		caster:AddNewModifier(caster, self, "modifier_imba_dawnbreaker_hammer", {duration = duration})
		local distance = (pos - caster:GetAbsOrigin()):Length2D()
		if distance > range then
			pos = caster:GetAbsOrigin() + direction * range
		end
		pos = GetGroundPosition(pos,caster)
		local sound = CreateModifierThinker(caster, self, "modifier_imba_dawnbreaker_hammer_thinker", {duration = duration+1}, pos, caster:GetTeamNumber(), false)
		sound:EmitSound("Hero_Dawnbreaker.Celestial_Hammer.Projectile")
		sound:EmitSound("Hero_Dawnbreaker.Solar_Guardian.Target.Layer")
		local pfx_fly = ParticleManager:CreateParticle("particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", PATTACH_CUSTOMORIGIN, sound)
		ParticleManager:SetParticleControl(pfx_fly, 0, pos)
		ParticleManager:SetParticleControl(pfx_fly, 2, pos)
		ParticleManager:ReleaseParticleIndex(pfx_fly)

		local pfx_fly2 = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_celestial_hammer_grounded.vpcf", PATTACH_CUSTOMORIGIN, sound)
		ParticleManager:SetParticleControl(pfx_fly2, 0, pos)
		ParticleManager:ReleaseParticleIndex(pfx_fly2)
		self:EndCooldown()
		self:StartCooldown(0.1)			
	end		
end

modifier_imba_dawnbreaker_hammer = class({})
function modifier_imba_dawnbreaker_hammer:IsDebuff()		return false end
function modifier_imba_dawnbreaker_hammer:IsHidden() 		return false end
function modifier_imba_dawnbreaker_hammer:IsPurgable() 		return false end
function modifier_imba_dawnbreaker_hammer:IsPurgeException() return false end

modifier_imba_dawnbreaker_hammer_thinker = class({})
function modifier_imba_dawnbreaker_hammer_thinker:IsAura() return true end
function modifier_imba_dawnbreaker_hammer_thinker:GetAuraDuration() return 0.1 end
function modifier_imba_dawnbreaker_hammer_thinker:GetModifierAura() return "modifier_imba_dawnbreaker_hammer_slow" end
function modifier_imba_dawnbreaker_hammer_thinker:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("hammer_aoe_radius") end
function modifier_imba_dawnbreaker_hammer_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_dawnbreaker_hammer_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_dawnbreaker_hammer_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_dawnbreaker_hammer_thinker:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("hammer_aoe_radius")
	self.damage = self:GetAbility():GetSpecialValueFor("hammer_damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_dawnbreaker_4")
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local enemy = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			self:GetParent():GetAbsOrigin(), 
			nil, 
			self:GetAbility():GetSpecialValueFor("hammer_aoe_radius"), 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			FIND_ANY_ORDER, 
			false
			)		
		for i=1, #enemy do		
			local damageTable = {
				victim 			= enemy[i],
				damage 			= self.damage,
				damage_type		= self:GetAbility():GetAbilityDamageType(),
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= caster,
				ability 		= self:GetAbility()
			}
			ApplyDamage(damageTable)
		end	

		self:GetAbility().pos = self:GetParent():GetAbsOrigin()

		
		self.pfx = ParticleManager:CreateParticle("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(self:GetAbility():GetSpecialValueFor("hammer_aoe_radius"), 0, 0))
		ParticleManager:SetParticleControl(self.pfx, 2, Vector(10, 0, 0))
		ParticleManager:SetParticleControl(self.pfx, 3, Vector(100, 0, 0))
		ParticleManager:SetParticleControl(self.pfx, 15, Vector(255, 155, 55))
		self:AddParticle(self.pfx, true, false, 15, false, false)

		self:StartIntervalThink(0.1)
	end
end
function modifier_imba_dawnbreaker_hammer_thinker:OnIntervalThink()
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.radius, 0.1, false)
	if not self:GetCaster():HasModifier("modifier_imba_dawnbreaker_hammer") then
		--Timers:CreateTimer(0.2, function()
			local pfx_fly3 = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_landing.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx_fly3, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx_fly3, 1, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx_fly3, 2, Vector(self.radius,0,0))
			ParticleManager:ReleaseParticleIndex(pfx_fly3)		
			self:StartIntervalThink(-1)
			self:Destroy()
	 	--end)
	end	
end
function modifier_imba_dawnbreaker_hammer_thinker:OnDestroy()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local enemy = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		self:GetParent():GetAbsOrigin(), 
		nil, 
		self:GetAbility():GetSpecialValueFor("hammer_aoe_radius"), 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
		FIND_ANY_ORDER, 
		false
		)		
	for i=1, #enemy do		
		local damageTable = {
			victim 			= enemy[i],
			damage 			= self.damage,
			damage_type		= self:GetAbility():GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= caster,
			ability 		= self:GetAbility()
		}
		ApplyDamage(damageTable)
		--enemy[i]:AddNewModifier(caster, self:GetAbility(), "modifier_imba_dawnbreaker_hammer_slow", {duration = self:GetAbility():GetSpecialValueFor("slow_time")})
		TG_AddNewModifier_RS(enemy[i], caster, self:GetAbility(), "modifier_imba_dawnbreaker_hammer_slow", {duration = self:GetAbility():GetSpecialValueFor("slow_time")})
	end
	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end				
	self:GetAbility().pos = nil
	self:GetAbility():EndCooldown()
	self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(self:GetAbility():GetLevel() -1 ) * caster:GetCooldownReduction()) - self:GetElapsedTime())	
	self:GetParent():RemoveSelf()
end
modifier_imba_dawnbreaker_hammer_slow = class({})

function modifier_imba_dawnbreaker_hammer_slow:IsDebuff()			return true end
function modifier_imba_dawnbreaker_hammer_slow:IsHidden() 		return false end
function modifier_imba_dawnbreaker_hammer_slow:IsPurgable() 		return true end
function modifier_imba_dawnbreaker_hammer_slow:IsPurgeException() return true end
function modifier_imba_dawnbreaker_hammer_slow:GetModifierMoveSpeedBonus_Percentage() 
	return (0 - self:GetAbility():GetSpecialValueFor("slow"))
end
function modifier_imba_dawnbreaker_hammer_slow:DeclareFunctions()	
	return 
	{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	} 
end
imba_dawnbreaker_luminosity = class({})

LinkLuaModifier("modifier_imba_dawnbreaker_luminosity", "linken/hero_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dawnbreaker_luminosity_miss", "linken/hero_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_luminosity_effect", "linken/hero_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_dawnbreaker_luminosity:GetIntrinsicModifierName() return "modifier_imba_dawnbreaker_luminosity" end
function imba_dawnbreaker_luminosity:GetCastRange()
	return self:GetSpecialValueFor("heal_radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_dawnbreaker_5") - self:GetCaster():GetCastRangeBonus() 
end
function imba_dawnbreaker_luminosity:GetBehavior()
	if self:GetCaster():HasScepter() then  
		return  DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_TOGGLE
end
function imba_dawnbreaker_luminosity:OnOwnerDied()
	self.toggle = self:GetToggleState()
end

function imba_dawnbreaker_luminosity:OnOwnerSpawned()
	if self.toggle == nil then
		self.toggle = false
	end
	if self.toggle ~= self:GetToggleState() then
		self:ToggleAbility()
	end
end

function imba_dawnbreaker_luminosity:OnToggle()
	self:EndCooldown()
	self.toggle = self:GetToggleState()
end
modifier_imba_dawnbreaker_luminosity = class({})
function modifier_imba_dawnbreaker_luminosity:IsDebuff()			return false end
function modifier_imba_dawnbreaker_luminosity:IsHidden() 			return self:GetStackCount() == 0 end
function modifier_imba_dawnbreaker_luminosity:IsPurgable() 		return false end
function modifier_imba_dawnbreaker_luminosity:IsPurgeException() 	return false end
function modifier_imba_dawnbreaker_luminosity:CheckState() return 
	{
	[MODIFIER_STATE_CANNOT_MISS] = self:GetParent():HasModifier("modifier_imba_dawnbreaker_luminosity_miss")
	} 
end
function modifier_imba_dawnbreaker_luminosity:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_FAIL,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_AVOID_DAMAGE,
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_imba_dawnbreaker_luminosity:GetModifierPreAttack_CriticalStrike(keys)
    if not IsServer() or self:GetParent():IsIllusion() then
		return
	end 
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() or self:GetParent():IsIllusion() or not (keys.target:IsHero() or keys.target:IsCreep() or keys.target:IsBoss()) then
		return
	end
    if self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("attack_count") then
		return self:GetAbility():GetSpecialValueFor("bonus_damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_dawnbreaker_5")
	elseif keys.attacker:HasModifier("modifier_imba_dawnbreaker_luminosity_miss") then
		return self:GetAbility():GetSpecialValueFor("miss") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_dawnbreaker_5")
	else	
		return 0
	end
end

function modifier_imba_dawnbreaker_luminosity:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() or self:GetParent():IsIllusion() or not (keys.target:IsHero() or keys.target:IsCreep() or keys.target:IsBoss()) then
		return
	end
	if self:GetStackCount() == self:GetAbility():GetSpecialValueFor("attack_count") - 1 then
		keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_imba_luminosity_effect", {})
	end
	if self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("attack_count") then
		local enemy = FindUnitsInRadius(
			keys.attacker:GetTeamNumber(), 
			keys.attacker:GetAbsOrigin(), 
			nil, 
			self:GetAbility():GetSpecialValueFor("heal_radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_dawnbreaker_6"), 
			DOTA_UNIT_TARGET_TEAM_BOTH, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			FIND_ANY_ORDER, 
			false
			)		
		for i=1, #enemy do
			if (not self:GetAbility():GetToggleState() and not IsEnemy(keys.attacker, enemy[i])) or (keys.attacker:HasScepter() and not IsEnemy(keys.attacker, enemy[i])) then
				enemy[i]:Heal(keys.damage * self:GetAbility():GetSpecialValueFor("heal_pct") * 0.01, keys.attacker)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, enemy[i], keys.damage * self:GetAbility():GetSpecialValueFor("heal_pct") * 0.01, nil) 
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_luminosity.vpcf", PATTACH_CUSTOMORIGIN, keys.attacker)
				ParticleManager:SetParticleControl(pfx, 0, enemy[i]:GetAbsOrigin())
				ParticleManager:SetParticleControl(pfx, 1, keys.attacker:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(pfx)				
			elseif (self:GetAbility():GetToggleState() and IsEnemy(keys.attacker, enemy[i]) and not enemy[i]:IsMagicImmune()) or (keys.attacker:HasScepter() and IsEnemy(keys.attacker, enemy[i]) and not enemy[i]:IsMagicImmune())  then
				local damageTable = {
					victim 			= enemy[i],
					damage 			= keys.damage * self:GetAbility():GetSpecialValueFor("heal_pct") * 0.01,
					damage_type		= self:GetAbility():GetAbilityDamageType(),
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= keys.attacker,
					ability 		= self:GetAbility()
				}
				ApplyDamage(damageTable)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy[i], keys.damage * self:GetAbility():GetSpecialValueFor("heal_pct") * 0.01, nil)
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_luminosity.vpcf", PATTACH_CUSTOMORIGIN, keys.attacker)
				ParticleManager:SetParticleControl(pfx, 0, keys.attacker:GetAbsOrigin())
				ParticleManager:SetParticleControl(pfx, 1, enemy[i]:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(pfx)							 
			end								
		end
		keys.attacker:EmitSound("Hero_Dawnbreaker.Fire_Wreath.Smash")
		self:SetStackCount(0)
	else
		self:IncrementStackCount()
	end
	if keys.attacker:HasModifier("modifier_imba_dawnbreaker_luminosity_miss") then
		keys.attacker:RemoveModifierByName("modifier_imba_dawnbreaker_luminosity_miss")
	end	
end
function modifier_imba_dawnbreaker_luminosity:OnAttackStart(keys)
local caster = self:GetCaster()
	if IsServer() then
		if keys.attacker == caster and caster:HasModifier("modifier_imba_luminosity_effect") then
			local int = keys.attacker:GetAttacksPerSecond() + 1
			keys.attacker:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_STATUE, int)
		end
	end
end	
function modifier_imba_dawnbreaker_luminosity:OnAttackFail(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() or self:GetParent():IsIllusion() or not (keys.target:IsHero() or keys.target:IsCreep() or keys.target:IsBoss()) then
		return
	end
	keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_imba_dawnbreaker_luminosity_miss", {})
end

function modifier_imba_dawnbreaker_luminosity:GetModifierIncomingDamage_Percentage(keys)
	if keys.damage_type == 4 and not self:GetParent():IsIllusion() then 
  		return -100
  	end
  	return 0	 
end
function modifier_imba_dawnbreaker_luminosity:GetModifierAvoidDamage(keys)
	if keys.damage_type == 4 then
		return 1
	end
end
function modifier_imba_dawnbreaker_luminosity:GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.damage_type == 4 and not self:GetParent():IsIllusion() then 
  		return -1000
  	end
  	return 0	 
end
function modifier_imba_dawnbreaker_luminosity:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

modifier_imba_dawnbreaker_luminosity_miss = class({})
function modifier_imba_dawnbreaker_luminosity_miss:IsDebuff()			return false end
function modifier_imba_dawnbreaker_luminosity_miss:IsHidden() 			return false end
function modifier_imba_dawnbreaker_luminosity_miss:IsPurgable() 		return false end
function modifier_imba_dawnbreaker_luminosity_miss:IsPurgeException() 	return false end

modifier_imba_luminosity_effect = class({})

function modifier_imba_luminosity_effect:IsDebuff()			return false end
function modifier_imba_luminosity_effect:IsHidden() 			return false end
function modifier_imba_luminosity_effect:IsPurgable() 		return false end
function modifier_imba_luminosity_effect:IsPurgeException() 	return false end
--function modifier_imba_luminosity_effect:DeclareFunctions() return {MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS} end
--function modifier_imba_luminosity_effect:GetActivityTranslationModifiers() return "overload" end
function modifier_imba_luminosity_effect:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end
function modifier_imba_luminosity_effect:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() or self:GetParent():IsIllusion() or not (keys.target:IsHero() or keys.target:IsCreep() or keys.target:IsBoss()) then
		return
	end
	keys.attacker:EmitSound("Hero_Dawnbreaker.Fire_Wreath.Smash")
	keys.attacker:RemoveModifierByName("modifier_imba_luminosity_effect")
end
function modifier_imba_luminosity_effect:OnCreated()
	if IsServer() then
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_luminosity_attack_buff.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon_core_fx", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon_core_fx", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon_core_fx", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon_core_fx", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon_core_fx", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(self.pfx, false, false, 15, false, false)
	end
end
function modifier_imba_luminosity_effect:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle( self.pfx, true )
			ParticleManager:ReleaseParticleIndex( self.pfx )
		end	
	end	
end

imba_dawnbreaker_solar_guardian = class({})

LinkLuaModifier("modifier_imba_dawnbreaker_solar_guardian_point", "linken/hero_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_dawnbreaker_solar_guardian", "linken/hero_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE)  
LinkLuaModifier("modifier_imba_solar_guardian_thinker", "linken/hero_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_solar_guardian_hp", "linken/hero_dawnbreaker.lua", LUA_MODIFIER_MOTION_NONE) 

function imba_dawnbreaker_solar_guardian:IsRefreshable() 			return true end
function imba_dawnbreaker_solar_guardian:IsStealable() 			return false end
function imba_dawnbreaker_solar_guardian:IsHiddenWhenStolen() 	return true end
function imba_dawnbreaker_solar_guardian:GetIntrinsicModifierName() return "modifier_imba_dawnbreaker_solar_guardian_point" end
function imba_dawnbreaker_solar_guardian:GetCastPoint() return math.min(self:GetCaster():GetModifierStackCount("modifier_imba_dawnbreaker_solar_guardian_point", nil)/100, 1.7) end
function imba_dawnbreaker_solar_guardian:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_dawnbreaker_8") then 
		return (cooldown - caster:TG_GetTalentValue("special_bonus_imba_dawnbreaker_8"))
	end
	return cooldown
end
function imba_dawnbreaker_solar_guardian:GetAOERadius()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_dawnbreaker_7")
	return radius		 
end
function imba_dawnbreaker_solar_guardian:OnAbilityPhaseStart()
	self.radius = self:GetSpecialValueFor("radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_dawnbreaker_7")
	local buff = self:GetCaster():FindModifierByName("modifier_imba_dawnbreaker_solar_guardian_point")
	local caster = self:GetCaster()
	buff:SetStackCount(self.BaseClass.GetCastPoint(self) * ((self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Length2D() / self:GetSpecialValueFor("min_distance")) * 100)	
	local pos = GetGroundPosition(self:GetCursorPosition(),caster)
	if not caster:HasModifier("modifier_imba_dawnbreaker_solar_guardian") then
		caster:AddNewModifier(caster, self, "modifier_imba_dawnbreaker_solar_guardian", {duration = self:GetSpecialValueFor("airtime_duration")+math.min(self:GetCaster():GetModifierStackCount("modifier_imba_dawnbreaker_solar_guardian_point", nil)/100, 1.7), pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
	end	
	self.dummy = CreateModifierThinker(caster, self, "modifier_imba_solar_guardian_thinker", {duration = 5, int = 1}, pos, caster:GetTeamNumber(), false)
	self.dummy:EmitSound("Hero_Dawnbreaker.Solar_Guardian.Channel")		
	--return true
	return false
end
function imba_dawnbreaker_solar_guardian:OnSpellStart()

end
modifier_imba_dawnbreaker_solar_guardian = class({})

function modifier_imba_dawnbreaker_solar_guardian:IsDebuff()			return false end
function modifier_imba_dawnbreaker_solar_guardian:IsHidden() 			return true end
function modifier_imba_dawnbreaker_solar_guardian:IsPurgable() 			return false end
function modifier_imba_dawnbreaker_solar_guardian:IsPurgeException() 	return false end
function modifier_imba_dawnbreaker_solar_guardian:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_NOT_ON_MINIMAP] = true, [MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_OUT_OF_GAME] = true, [MODIFIER_STATE_UNSELECTABLE] = true, [MODIFIER_STATE_COMMAND_RESTRICTED] = true} end
function modifier_imba_dawnbreaker_solar_guardian:OnCreated(keys)
	self.radius = self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_dawnbreaker_7")
	if IsServer() then
		local caster = self:GetCaster()
		caster:StartGesture(ACT_DOTA_CAST_ABILITY_4_END)
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self:StartIntervalThink(0.15)
	end
end
function modifier_imba_dawnbreaker_solar_guardian:OnIntervalThink()
	local caster = self:GetCaster()
	local dummy = CreateModifierThinker(caster, self:GetAbility(), "modifier_imba_solar_guardian_thinker", {duration = 5, int = 2}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)	
	dummy:EmitSound("Hero_Dawnbreaker.Solar_Guardian.BlastOff")	
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf", PATTACH_CUSTOMORIGIN, dummy)
	ParticleManager:SetParticleControl(pfx, 0, dummy:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, dummy:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)					
	caster:AddNoDraw()
	caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_4_END)
	--caster:StartGestureWithPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_1, 5)
	self:StartIntervalThink(-1)
	return
	--self:Destroy()
end
function modifier_imba_dawnbreaker_solar_guardian:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()		
		caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
		caster:RemoveNoDraw()
		FindClearSpaceForUnit(caster, self.pos, false)
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius,self.radius,self.radius))
		ParticleManager:ReleaseParticleIndex(pfx)
		local pfx_fly3 = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_landing.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx_fly3, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx_fly3, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx_fly3, 2, Vector(self.radius,0,0))
		ParticleManager:ReleaseParticleIndex(pfx_fly3)
		--self:GetAbility().dummy:Destroy()					
	end
end

modifier_imba_dawnbreaker_solar_guardian_point = class({})

function modifier_imba_dawnbreaker_solar_guardian_point:IsDebuff()			return false end
function modifier_imba_dawnbreaker_solar_guardian_point:IsHidden() 			return true end
function modifier_imba_dawnbreaker_solar_guardian_point:IsPurgable() 			return false end
function modifier_imba_dawnbreaker_solar_guardian_point:IsPurgeException() 	return false end

modifier_imba_solar_guardian_hp = class({})

function modifier_imba_solar_guardian_hp:IsDebuff()			return false end
function modifier_imba_solar_guardian_hp:IsHidden() 			return true end
function modifier_imba_solar_guardian_hp:IsPurgable() 			return false end
function modifier_imba_solar_guardian_hp:IsPurgeException() 	return false end
function modifier_imba_solar_guardian_hp:DeclareFunctions() return {MODIFIER_PROPERTY_DISABLE_HEALING} end
function modifier_imba_solar_guardian_hp:GetDisableHealing()
	return 1
end

modifier_imba_solar_guardian_thinker = class({})

function modifier_imba_solar_guardian_thinker:IsDebuff()			return false end
function modifier_imba_solar_guardian_thinker:IsHidden() 			return true end
function modifier_imba_solar_guardian_thinker:IsPurgable() 		return false end
function modifier_imba_solar_guardian_thinker:IsPurgeException() 	return false end
--function modifier_imba_solar_guardian_thinker:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end


function modifier_imba_solar_guardian_thinker:OnCreated(keys)
	self.radius = self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_dawnbreaker_7")
	if IsServer() then		
		if keys.int == 1 then
			self.dummy = self:GetParent()
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_aoe.vpcf", PATTACH_CUSTOMORIGIN, self.dummy)
			ParticleManager:SetParticleControl(pfx, 0, self.dummy:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, self.dummy:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 2, Vector(self.radius,0,0))
			ParticleManager:ReleaseParticleIndex(pfx)			
			self:OnIntervalThink()
			self:StartIntervalThink(0.1)
		end	
	end
end

function modifier_imba_solar_guardian_thinker:OnIntervalThink()
	local caster = self:GetCaster()	
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), 0.1, false)
	local enemy = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		self:GetParent():GetAbsOrigin(), 
		nil, 
		self.radius, 
		DOTA_UNIT_TARGET_TEAM_BOTH, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
		FIND_ANY_ORDER, 
		false
		)		
	for i=1, #enemy do
		local hp = enemy[i]:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("base") * 0.001
		if enemy[i]:GetTeamNumber() == caster:GetTeamNumber() then
			enemy[i]:Heal(hp, caster)
			--SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, enemy[i], hp, nil)
		else			
			local damageTable = {
				victim 			= enemy[i],
				damage 			= hp,
				damage_type		= self:GetAbility():GetAbilityDamageType(),
				attacker 		= caster,
				damage_flags 	= DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR,
				ability 		= self:GetAbility()
			}
			ApplyDamage(damageTable)
			enemy[i]:AddNewModifier(caster, self:GetAbility(), "modifier_imba_solar_guardian_hp", {duration = 0.2})
			--SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy[i], hp, nil)
		end	
	end
	if not caster:HasModifier("modifier_imba_dawnbreaker_solar_guardian") then
		local caster = self:GetCaster()	
		local enemy = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			self:GetParent():GetAbsOrigin(), 
			nil, 
			self.radius, 
			DOTA_UNIT_TARGET_TEAM_BOTH, 
			DOTA_UNIT_TARGET_HERO, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			FIND_ANY_ORDER, 
			false
			)		
		for i=1, #enemy do
			local hp = enemy[i]:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("base_damage_heal") * 0.01
			if enemy[i]:GetTeamNumber() == caster:GetTeamNumber() then
				enemy[i]:Heal(hp, caster)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, enemy[i], hp, nil)
			else			
				local damageTable = {
					victim 			= enemy[i],
					damage 			= hp,
					damage_type		= self:GetAbility():GetAbilityDamageType(),
					attacker 		= caster,
					damage_flags 	= DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR,
					ability 		= self:GetAbility()
				}
				ApplyDamage(damageTable)
				--enemy[i]:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("land_stun_duration")})
				TG_AddNewModifier_RS(enemy[i], caster, self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("land_stun_duration")})
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy[i], hp, nil)
			end	
		end
		local enemy1 = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			self:GetParent():GetAbsOrigin(), 
			nil, 
			self.radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false
			)				
		self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(-1) * caster:GetCooldownReduction()) - (#enemy1 * self:GetAbility():GetSpecialValueFor("cd")))			
		self:StartIntervalThink(-1)
		self:GetParent():StopSound("Hero_Dawnbreaker.Solar_Guardian.Channel")	
		self:GetParent():EmitSound("Hero_Dawnbreaker.Luminosity.Strike")	
		self:GetParent():EmitSound("Hero_Dawnbreaker.Solar_Guardian.BlastOff")			
		self:Destroy()
		return
	end						
end

function modifier_imba_solar_guardian_thinker:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveSelf()
	end
end