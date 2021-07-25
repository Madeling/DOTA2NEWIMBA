CreateTalents("npc_dota_hero_antimage", "linken/hero_antimage.lua")
modifier_imba_illusion_no_order = class({})
LinkLuaModifier("modifier_imba_illusion_no_order", "linken/hero_antimage.lua", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_illusion_no_order:IsDebuff()				return true end
function modifier_imba_illusion_no_order:IsHidden() 			return true end
function modifier_imba_illusion_no_order:IsPurgable() 			return false end
function modifier_imba_illusion_no_order:IsPurgeException() 	return false end
function modifier_imba_illusion_no_order:CheckState()
	return 
		{
		[MODIFIER_STATE_COMMAND_RESTRICTED]	= true,
		[MODIFIER_STATE_ROOTED]	= true,
		[MODIFIER_STATE_DISARMED]	= true,
		[MODIFIER_STATE_INVULNERABLE]	= true,
		[MODIFIER_STATE_UNSELECTABLE]	= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP]	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR]	= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]	= true,
		}
end

imba_antimage_mana_break = class({})

LinkLuaModifier("modifier_imba_antimage_mana_break", "linken/hero_antimage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_antimage_mana_break_1", "linken/hero_antimage.lua", LUA_MODIFIER_MOTION_NONE)

function imba_antimage_mana_break:GetIntrinsicModifierName() return "modifier_imba_antimage_mana_break" end
function imba_antimage_mana_break:OnSpellStart()
	local radius = self:GetSpecialValueFor("radius")
	local caster = self:GetCaster()
	local Immune = DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES	
	local number = self:GetSpecialValueFor("att_number") + caster:TG_GetTalentValue("special_bonus_imba_antimage_6")
	local enemy = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetAbsOrigin() ,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		Immune,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)	
	for i=1, #enemy do
		caster:AddNewModifier(caster, self, "modifier_imba_antimage_mana_break_1", {})
		caster:PerformAttack(enemy[i], true, true, true, false, true, false, true)
		caster:RemoveModifierByName("modifier_imba_antimage_mana_break_1")
		if i >= number then
			break
		end	
	end	

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_ring.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(3000, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle)
	self:GetCaster():EmitSound("Hero_Antimage.ManaVoid")
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 1)
end
modifier_imba_antimage_mana_break_1 =class({})

function modifier_imba_antimage_mana_break_1:IsDebuff() return false end
function modifier_imba_antimage_mana_break_1:IsHidden() return false end
function modifier_imba_antimage_mana_break_1:IsPurgable() return false end
function modifier_imba_antimage_mana_break_1:IsPurgeException() return true end
function modifier_imba_antimage_mana_break_1:IsStunDebuff() return false end
function modifier_imba_antimage_mana_break_1:RemoveOnDeath() return true end
function modifier_imba_antimage_mana_break_1:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE} end
function modifier_imba_antimage_mana_break_1:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and params.attacker == self:GetParent()  then 
		return self:GetAbility():GetSpecialValueFor("int")
	end
end


modifier_imba_antimage_mana_break = class({})

function modifier_imba_antimage_mana_break:IsDebuff()			return false end
function modifier_imba_antimage_mana_break:IsHidden() 			return true end
function modifier_imba_antimage_mana_break:IsPurgable() 		return false end
function modifier_imba_antimage_mana_break:IsPurgeException() 	return false end

function modifier_imba_antimage_mana_break:DeclareFunctions()
	local funcs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
	return funcs
end

function modifier_imba_antimage_mana_break:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetCaster() then
		return
	end	
	if keys.target:IsBuilding() or self:GetCaster():PassivesDisabled() or not keys.target:IsAlive() then
		return 
	end
	if keys.target:IsMagicImmune() then
		return
	end
	if not keys.target:IsUnit() then
		return
	end	
	local mana = keys.target:GetMaxMana()	
	if keys.target:GetMaxMana() <= 0 then
		mana = self:GetAbility():GetSpecialValueFor("nilmana_max")
	end		
	local mana_burn = self:GetAbility():GetSpecialValueFor("base_mana_burn") + mana * (self:GetAbility():GetSpecialValueFor("bonus_mana_burn") / 100)
	if keys.attacker:IsIllusion() then
		mana_burn = mana_burn * self:GetAbility():GetSpecialValueFor("illusion_factor")
	end
	keys.target:ReduceMana(math.max(0, mana_burn))
	local total_manaloss = mana - keys.target:GetMana()
	local dmg = total_manaloss * self:GetAbility():GetSpecialValueFor("damage_per_burn")
	if keys.attacker:IsIllusion() then
		dmg = dmg * self:GetAbility():GetSpecialValueFor("illusion_factor")
	end

	local damageTable = {
						victim = keys.target,
						attacker = keys.attacker,
						damage = dmg,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						ability = self:GetAbility(),
						}
	ApplyDamage(damageTable)
	local pfx_name = "particles/generic_gameplay/generic_manaburn.vpcf"
	local manaburn_pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN_FOLLOW, keys.target)
	ParticleManager:ReleaseParticleIndex(manaburn_pfx)				
	keys.target:EmitSound("Hero_Antimage.ManaBreak")
end

imba_antimage_blink = class({})

LinkLuaModifier("modifier_imba_antimage_passive_range", "linken/hero_antimage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_antimage_passive_range1", "linken/hero_antimage.lua", LUA_MODIFIER_MOTION_NONE)

function imba_antimage_blink:IsHiddenWhenStolen() 		return false end
function imba_antimage_blink:IsRefreshable() 			return true end
function imba_antimage_blink:IsStealable() 				return true end
function imba_antimage_blink:GetCastPoint()
	if	IsServer()  then 
		local caster = self:GetCaster()
		if caster:TG_HasTalent("special_bonus_imba_antimage_5") then 
			return caster:TG_GetTalentValue("special_bonus_imba_antimage_5")
		end
		return 0.4
	end		 
end
function imba_antimage_blink:GetCastRange() if IsClient() then return self:GetSpecialValueFor("blink_range") end end
function imba_antimage_blink:GetIntrinsicModifierName() return "modifier_imba_antimage_passive_range1" end
function imba_antimage_blink:OnSpellStart()
	local caster = self:GetCaster()
	ProjectileManager:ProjectileDodge(caster)
   local modifier=
    {
        outgoing_damage=self:GetSpecialValueFor("illusion_proc_chance_pct") - 100,
        incoming_damage=self:GetSpecialValueFor("tooltip_total_illusion_damage_in_pct")+100,
        bounty_base=0,
        bounty_growth=0,
        outgoing_damage_structure=0,
        outgoing_damage_roshan=0,
    }	
	caster.illusions = CreateIllusions(caster, caster, modifier, 1, 0, true, false)
    for i=1, #caster.illusions do 
        caster.illusions[i]:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("duration")})
        caster.illusions[i]:AddNewModifier(caster, self, "modifier_imba_illusion_no_order", {duration = self:GetSpecialValueFor("duration")})
    end	


	local pos = self:GetCursorPosition()
	local enemies = 
		FindUnitsInLine(self:GetCaster():GetTeamNumber(), 
		self:GetCaster():GetAbsOrigin(), 
		pos, 
		nil, 
		self:GetSpecialValueFor("range"), 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		)
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier_RS(caster, self, "modifier_imba_antimage_passive_range", {duration = self:GetSpecialValueFor("buff_duration")})
	end		
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0.0
	local max_dis = self:GetSpecialValueFor("blink_range")
	local sound_start = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	sound_start:EmitSound("Hero_Antimage.Blink_out")
	local pfx1_name = "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf"
	local pfx2_name = "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf"
	local pfx1 = ParticleManager:CreateParticle(pfx1_name, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(pfx1, 1, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlForward(pfx1, 0, direction)
	local distance = (pos - caster:GetAbsOrigin()):Length2D()
	if distance <= max_dis then
		FindClearSpaceForUnit(caster, pos, false)
	else
		pos = caster:GetAbsOrigin() + direction * max_dis
		FindClearSpaceForUnit(caster, pos, false)
	end
	ProjectileManager:ProjectileDodge(caster)
	local pfx2 = ParticleManager:CreateParticle(pfx2_name, PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx2, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	local sound_end = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	sound_end:EmitSound("Hero_Antimage.Blink_in")
	ParticleManager:ReleaseParticleIndex(pfx1)
	ParticleManager:ReleaseParticleIndex(pfx2)
end

modifier_imba_antimage_passive_range = class({})

function modifier_imba_antimage_passive_range:IsDebuff()			return true end
function modifier_imba_antimage_passive_range:IsHidden() 			return false end
function modifier_imba_antimage_passive_range:IsPurgable() 			return false end
function modifier_imba_antimage_passive_range:IsPurgeException() 	return false end
function modifier_imba_antimage_passive_range:DeclareFunctions()return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE} end
function modifier_imba_antimage_passive_range:GetStatusEffectName()
  return "particles/status_fx/status_effect_nightmare.vpcf"
end
function modifier_imba_antimage_passive_range:GetModifierSpellAmplify_Percentage()
	return 0-self:GetAbility():GetSpecialValueFor("amp")	
end
modifier_imba_antimage_passive_range1 = class({})

function modifier_imba_antimage_passive_range1:IsDebuff()			return false end
function modifier_imba_antimage_passive_range1:IsHidden() 			return true end
function modifier_imba_antimage_passive_range1:IsPurgable() 			return false end
function modifier_imba_antimage_passive_range1:IsPurgeException() 	return false end
function modifier_imba_antimage_passive_range1:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_imba_antimage_passive_range1:OnIntervalThink()
	if self:GetCaster():TG_HasTalent("special_bonus_imba_antimage_1") then
		local ability = self:GetAbility()
		AbilityChargeController:AbilityChargeInitialize(ability, ability:GetCooldown(4 - 1), self:GetCaster():TG_GetTalentValue("special_bonus_imba_antimage_1"), 1, true, true)
		self:StartIntervalThink(-1)
		self:Destroy()
	end	
end


imba_antimage_spell_shield = class({})

LinkLuaModifier("modifier_imba_antimage_spell_shield_passive", "linken/hero_antimage.lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_imba_antimage_spell_shield_active", "linken/hero_antimage.lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_imba_antimage_spell_shield_ability", "linken/hero_antimage.lua", LUA_MODIFIER_MOTION_NONE)

function imba_antimage_spell_shield:IsHiddenWhenStolen() 		return true end
function imba_antimage_spell_shield:IsRefreshable() 			return true end
function imba_antimage_spell_shield:IsStealable() 				return false end
function imba_antimage_spell_shield:GetBehavior() 
	return self:GetCaster():TG_HasTalent("special_bonus_imba_antimage_2") and DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL or DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
end

function imba_antimage_spell_shield:GetIntrinsicModifierName() return "modifier_imba_antimage_spell_shield_passive" end
function imba_antimage_spell_shield:OnUpgrade()
	local modifier = self:GetCaster():FindModifierByName( "modifier_antimage_counterspell" )
	local modifier2 = self:GetCaster():FindModifierByName( "modifier_imba_antimage_spell_shield_passive" )

	self:GetCaster():FindAbilityByName("antimage_counterspell"):SetLevel(self:GetLevel())
	if modifier then
		modifier:ForceRefresh()
	end
	if modifier2 then
		modifier2:ForceRefresh()
	end	
end
function imba_antimage_spell_shield:OnSpellStart()
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("antimage_counterspell")
	if caster:IsStunned() then
		self:EndCooldown()
		self:StartCooldown((self:GetCooldown(self:GetLevel() -1 ) * caster:GetCooldownReduction()) * caster:TG_GetTalentValue("special_bonus_imba_antimage_2"))
	end	
	ability:OnSpellStart()
	caster:Purge(false, true, false, true, true)	
end

modifier_imba_antimage_spell_shield_passive = class({})
function modifier_imba_antimage_spell_shield_passive:IsDebuff()					return false end
function modifier_imba_antimage_spell_shield_passive:IsHidden() 				return true end
function modifier_imba_antimage_spell_shield_passive:IsPurgable() 				return false end
function modifier_imba_antimage_spell_shield_passive:IsPurgeException() 		return false end
function modifier_imba_antimage_spell_shield_passive:OnCreated()
	if IsServer() then
	end
end
function modifier_imba_antimage_spell_shield_passive:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, MODIFIER_EVENT_ON_ABILITY_EXECUTED}
	return funcs
end

function modifier_imba_antimage_spell_shield_passive:GetModifierMagicalResistanceBonus()
	if self:GetCaster():HasModifier("modifier_antimage_counterspell") then
		return (self:GetAbility():GetSpecialValueFor("magic_resistance") * 2)
	end
end
function modifier_imba_antimage_spell_shield_passive:OnAbilityExecuted(keys)
	if not IsServer() then
		return
	end
	if keys.target ~= self:GetParent() then
		return
	end	
	if bit.band(keys.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
		return
	end	
	if not IsEnemy(keys.ability:GetCaster(), self:GetParent()) then
		return
	end
	local chance_pct = self:GetAbility():GetSpecialValueFor("chance_pct") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_antimage_4")
	if PseudoRandom:RollPseudoRandom(self:GetAbility(), chance_pct) then	
		if self:GetParent():FindAbilityByName("imba_antimage_mana_break") and self:GetParent():FindAbilityByName("imba_antimage_mana_break"):IsTrained() then    
			self:GetParent():FindAbilityByName("imba_antimage_mana_break"):OnSpellStart()
		end
	end	    	
end
function modifier_imba_antimage_spell_shield_passive:OnDestroy()
	if IsServer() then
	end
end
imba_antimage_mana_overload = class({})
LinkLuaModifier("modifier_imba_antimage_mana_overload_scepter", "linken/hero_antimage.lua", LUA_MODIFIER_MOTION_NONE)
function imba_antimage_mana_overload:IsHiddenWhenStolen() 		return false end
function imba_antimage_mana_overload:IsRefreshable() 			return true end
function imba_antimage_mana_overload:IsStealable() 				return true end
function imba_antimage_mana_overload:GetIntrinsicModifierName() return "modifier_imba_antimage_mana_overload_scepter" end
function imba_antimage_mana_overload:GetCastPoint()
	if	IsServer()  then 
		local caster = self:GetCaster()
		if caster:TG_HasTalent("special_bonus_imba_antimage_5") then 
			return caster:TG_GetTalentValue("special_bonus_imba_antimage_5")
		end
		return 0.4
	end		 
end
function imba_antimage_mana_overload:Set_InitialUpgrade(tg) 			
    return {LV=1} 
end
function imba_antimage_mana_overload:GetCastRange() if IsClient() then return self:GetSpecialValueFor("blink_range") end end
function imba_antimage_mana_overload:OnSpellStart()
	local caster = self:GetCaster() 
	ProjectileManager:ProjectileDodge(caster)
   local modifier=
    {
        outgoing_damage=self:GetSpecialValueFor("illusion_proc_chance_pct") - 100,
        incoming_damage=self:GetSpecialValueFor("tooltip_total_illusion_damage_in_pct")+100,
        bounty_base=0,
        bounty_growth=0,
        outgoing_damage_structure=0,
        outgoing_damage_roshan=0,
    }	
	
	local pos = self:GetCursorPosition()
	local ability = caster:FindAbilityByName("imba_antimage_blink")
	local enemies = 
		FindUnitsInLine(self:GetCaster():GetTeamNumber(), 
		self:GetCaster():GetAbsOrigin(), 
		pos, 
		nil, 
		ability:GetSpecialValueFor("range"), 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		)
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, ability, "modifier_imba_antimage_passive_range", {duration = ability:GetSpecialValueFor("buff_duration")})
	end	
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0.0
	local max_dis = self:GetSpecialValueFor("blink_range")
	local sound_start = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	sound_start:EmitSound("Hero_Antimage.Blink_out")
	local pfx1_name = "particles/units/heroes/hero_antimage/antimage_blink_start.vpcf"
	local pfx2_name = "particles/units/heroes/hero_antimage/antimage_blink_end.vpcf"
	local pfx1 = ParticleManager:CreateParticle(pfx1_name, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx1, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(pfx1, 1, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlForward(pfx1, 0, direction)
	local distance = (pos - caster:GetAbsOrigin()):Length2D()
	caster.illusions = CreateIllusions(caster, caster, modifier, 1, 0, false, false)
    for i=1, #caster.illusions do
        caster.illusions[i]:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("duration")})
		--caster.illusions[i]:AddNewModifier(caster, self, "modifier_imba_illusion_no_order", {duration = self:GetSpecialValueFor("duration")})
		if distance <= max_dis then
			FindClearSpaceForUnit(caster.illusions[i], pos, false)
		else
			pos = caster:GetAbsOrigin() + direction * max_dis
			FindClearSpaceForUnit(caster.illusions[i], pos, false)
		end 
		local pfx2 = ParticleManager:CreateParticle(pfx2_name, PATTACH_POINT_FOLLOW, caster.illusions[i])
		ParticleManager:SetParticleControlEnt(pfx2, 0, caster.illusions[i], PATTACH_POINT_FOLLOW, "attach_hitloc", caster.illusions[i]:GetAbsOrigin(), true)	
		ParticleManager:ReleaseParticleIndex(pfx2)	       
    end	
	ProjectileManager:ProjectileDodge(caster)
	local sound_end = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	sound_end:EmitSound("Hero_Antimage.Blink_in")
	ParticleManager:ReleaseParticleIndex(pfx1)
	
end
modifier_imba_antimage_mana_overload_scepter = class({})

function modifier_imba_antimage_mana_overload_scepter:IsDebuff()			return false end
function modifier_imba_antimage_mana_overload_scepter:IsHidden() 		return true end
function modifier_imba_antimage_mana_overload_scepter:IsPurgable() 		return false end
function modifier_imba_antimage_mana_overload_scepter:IsPurgeException() return false end
function modifier_imba_antimage_mana_overload_scepter:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_antimage_mana_overload_scepter:OnIntervalThink()
	self:GetAbility():SetHidden(not self:GetParent():Has_Aghanims_Shard())
	if self:GetParent():Has_Aghanims_Shard() then
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end	
end


imba_antimage_mana_void = class({})
LinkLuaModifier("modifier_imba_mana_void_passive", "linken/hero_antimage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mana_void_sce", "linken/hero_antimage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mana_void_debuff", "linken/hero_antimage.lua", LUA_MODIFIER_MOTION_NONE)

function imba_antimage_mana_void:IsHiddenWhenStolen() 		return false end
function imba_antimage_mana_void:IsRefreshable() 			return true end
function imba_antimage_mana_void:IsStealable() 				return true end

function imba_antimage_mana_void:GetAOERadius()	return self:GetSpecialValueFor("mana_void_aoe_radius") end
function imba_antimage_mana_void:GetCooldown(i) return self.BaseClass.GetCooldown(self, i) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_antimage_3") end
function imba_antimage_mana_void:GetIntrinsicModifierName() return "modifier_imba_mana_void_passive" end
function imba_antimage_mana_void:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Antimage.ManaVoidCast")
	return true
end

function imba_antimage_mana_void:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	self.target = self:GetCursorTarget()
	if target:TriggerStandardTargetSpell(self) then
		return
	end
	local amgint = self:GetSpecialValueFor("mana_void_damage_per_mana") + caster:TG_GetTalentValue("special_bonus_imba_antimage_8")
	local mana = target:GetMaxMana()
	if target:GetMaxMana() <= 0 then
		mana = self:GetSpecialValueFor("nilmana_max")
	end	
	local stun_duration = caster:HasScepter() and self:GetSpecialValueFor("mana_void_stun_scepter") or self:GetSpecialValueFor("mana_void_ministun")
	target:AddNewModifier_RS(caster, self, "modifier_imba_stunned", {duration = stun_duration})
	local dmg = 0
	target:ReduceMana(math.max(0, ((mana * (self:GetSpecialValueFor("mana_void_mana_burn_pct") / 100)))))
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									target:GetAbsOrigin(),
									nil,
									self:GetSpecialValueFor("mana_void_aoe_radius"),
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
									FIND_ANY_ORDER,
									false)
	if not caster:HasScepter() then
		dmg = (mana - target:GetMana()) * amgint
	else
		for _, enemy in pairs(enemies) do
			local mana1 = enemy:GetMaxMana()
			if enemy:GetMaxMana() <= 0 then
				mana1 = self:GetSpecialValueFor("nilmana_max")
			end
			dmg = dmg + (mana1 - enemy:GetMana()) * amgint
		end
	end
	for _, enemy in pairs(enemies) do
		local damageTable = {
							victim = enemy,
							attacker = caster,
							damage = dmg,
							damage_type = self:GetAbilityDamageType(),
							ability = self,
							}
		ApplyDamage(damageTable)
	end
	target:EmitSound("Hero_Antimage.ManaVoid")
	local pfx_name = "particles/units/heroes/hero_antimage/antimage_manavoid.vpcf"
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAttachmentOrigin(target:ScriptLookupAttachment("attach_hitloc")))
	ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetSpecialValueFor("mana_void_aoe_radius"), 0, 0))
	ParticleManager:ReleaseParticleIndex(pfx)
	self.target = nil
end
modifier_imba_mana_void_passive = class({})
function modifier_imba_mana_void_passive:IsDebuff()					return false end
function modifier_imba_mana_void_passive:IsHidden() 				return true end
function modifier_imba_mana_void_passive:IsPurgable() 				return false end
function modifier_imba_mana_void_passive:IsPurgeException() 		return false end

function modifier_imba_mana_void_passive:DeclareFunctions()
	local funcs = {MODIFIER_EVENT_ON_DEATH}
	return funcs
end
function modifier_imba_mana_void_passive:OnDeath(keys)
	if not IsServer() then
		return
	end
	local ability = self:GetAbility()
	local unit = keys.unit
	local attacker = keys.attacker
	if self:GetAbility().target ~= nil then
		if unit == self:GetAbility().target and self:GetAbility().target:IsRealHero() and attacker == self:GetCaster() and self:GetCaster():HasScepter() then
			CreateModifierThinker(self:GetAbility().target, ability, "modifier_imba_mana_void_sce", {},  Vector(30000,30000,5000), ability:GetCaster():GetTeamNumber(), false)
			self:GetAbility().target = nil
		end	
	end	
end
modifier_imba_mana_void_sce = class({})

function modifier_imba_mana_void_sce:DeclareFunctions() return {MODIFIER_EVENT_ON_RESPAWN} end

function modifier_imba_mana_void_sce:OnRespawn(keys)
	if not IsServer() or keys.unit ~= self:GetCaster() then
		return
	end
	local ability = self:GetAbility()
	local target = self:GetCaster()
	local max_cd = 0
	local max_ability = nil
	for i=0, 23 do
		local current_ability = target:GetAbilityByIndex(i)
		if current_ability and not current_ability:IsHidden() and current_ability:GetLevel() > 0 and max_cd <= current_ability:GetCooldown(current_ability:GetLevel()) then
			max_cd = current_ability:GetCooldown(-1)
			max_ability = current_ability
		end
	end
	if max_ability then
		--print(max_ability:GetName())
		local cd = max_ability:GetCooldownTimeRemaining() + ability:GetSpecialValueFor("cooldown_increase_scepter")
		local debuff = target:FindAllModifiersByName("modifier_imba_mana_void_debuff")
		local found = false
		for i=1, #debuff do
			if debuff[i]:GetAbility() == max_ability then
				found = debuff[i]
				break
			end
		end
		if found then
			found:SetDuration(cd, true)
		else
			target:AddNewModifier(target, max_ability, "modifier_imba_mana_void_debuff", {duration = cd})
		end
	end
	self:Destroy()
end

modifier_imba_mana_void_debuff = class({}) 

function modifier_imba_mana_void_debuff:IsDebuff()			return true end
function modifier_imba_mana_void_debuff:IsHidden() 			return false end
function modifier_imba_mana_void_debuff:IsPurgable() 		return false end
function modifier_imba_mana_void_debuff:IsPurgeException() 	return false end
function modifier_imba_mana_void_debuff:GetAttributes() 	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_mana_void_debuff:RemoveOnDeath() return self:GetParent():IsIllusion() end

function modifier_imba_mana_void_debuff:OnCreated()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_mana_void_debuff:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then
		self:Destroy()
		return
	end
	if not self:GetParent():IsAlive() then
		self:SetDuration(self:GetRemainingTime() + FrameTime(), true)
	end
	self:GetAbility():EndCooldown()
	self:GetAbility():StartCooldown(self:GetRemainingTime())
end