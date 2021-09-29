CreateTalents("npc_dota_hero_bristleback", "ting/hero_bristleback")
imba_bristleback_viscous_nasal_goo = class({})
LinkLuaModifier("modifier_goo_auto", "ting/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_goo_stack", "ting/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
function imba_bristleback_viscous_nasal_goo:GetIntrinsicModifierName() return "modifier_goo_auto" end
function imba_bristleback_viscous_nasal_goo:IsHiddenWhenStolen() 		return false end
function imba_bristleback_viscous_nasal_goo:IsRefreshable() 			return true  end
function imba_bristleback_viscous_nasal_goo:IsStealable() 			return true  end
function imba_bristleback_viscous_nasal_goo:IsNetherWardStealable()	return true end
function imba_bristleback_viscous_nasal_goo:GetBehavior()
	if self:GetCaster():HasScepter()  then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end
function imba_bristleback_viscous_nasal_goo:Init()
	self.pfx1 = "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf"
end
function imba_bristleback_viscous_nasal_goo:OnSpellStart(origin,caster_ball)
	self.caster = self:GetCaster()
	self.radius = self:GetSpecialValueFor("radius") + (self.caster:HasScepter() and self:GetSpecialValueFor("scept_exradius") or 0)
	self.speed = self:GetSpecialValueFor("goo_speed")
	self.fear_duration = self:GetSpecialValueFor("fear_duration")
	self.goo_duration = self:GetSpecialValueFor("goo_duration")
	if self.caster:HasScepter() or origin then 
	self.pos = self.caster:GetAbsOrigin()	--拥有a默认刚被自己附近
	if origin and caster_ball then 
		self.pos = origin	--如果是毛球放的就用毛球附近
		self.caster = EntIndexToHScript(caster_ball)
	end
	
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	for _,enemy in pairs(enemies) do
		self:start(enemy,self.caster)
	end
	
	else
		self:start(self:GetCursorTarget(),self.caster)
	end
end

function imba_bristleback_viscous_nasal_goo:start(target, caster )
		EmitSoundOn("Hero_Bristleback.ViscousGoo.Cast", self.caster)
		local info1 = 
			{
				Target = target,
				Source = caster,
				Ability = self,	
				EffectName = self.pfx1,
				iMoveSpeed = self.speed,
				vSourceLoc= caster:GetAbsOrigin(),
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				bProvidesVision = false,	
			}
		if target ~= nil then
			ProjectileManager:CreateTrackingProjectile(info1)
		end
		--判断角度 敌人是否看向刚被
		local cast_angle = VectorToAngles(target:GetForwardVector())
		local angle = VectorToAngles((caster:GetAbsOrigin() - target:GetAbsOrigin()):Normalized())
		local degree = math.abs(AngleDiff(cast_angle[2], angle[2]))
		
		local cast_angle2 = VectorToAngles(caster:GetForwardVector()*-1)
		local angle2 = VectorToAngles((caster:GetAbsOrigin() - target:GetAbsOrigin()):Normalized())
		local degree2 = math.abs(AngleDiff(cast_angle2[2], angle2[2]))
		
		local min_degree = 65			
			if degree <= min_degree and degree2 <= min_degree then
				target:SetForwardVector(Vector(caster:GetForwardVector()[1], caster:GetForwardVector()[2], 0))	
				if target then target:AddNewModifier_RS(self:GetCaster(), self, "modifier_terrorblade_fear", {duration = self.fear_duration}) end  
            end			
        
end


function imba_bristleback_viscous_nasal_goo:OnProjectileHit(target, pos)
	local caster = self:GetCaster()
	if not target then
		return
	end
	if target:TriggerStandardTargetSpell(self) then
		return
	end 
	target:AddNewModifier_RS(caster,self,"modifier_goo_stack",{duration = self.goo_duration})	
end


	
--[[
	AddFOWViewer(caster:GetTeamNumber(), pos, self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("duration"), false)
	local truesight = CreateUnitByName("npc_dummy_unit", pos, false, caster, caster, caster:GetTeamNumber())
	TG_AddNewModifier_RS(truesight, caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("truesight_duration")})
	TG_AddNewModifier_RS(truesight, caster, self, "modifier_item_gem_of_true_sight", {duration = self:GetSpecialValueFor("truesight_duration")})
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)]]


--鼻涕叠加
modifier_goo_stack=class({})
function modifier_goo_stack:IsHidden() return false end
function modifier_goo_stack:IsPurgable() return true end
function modifier_goo_stack:GetEffectName()
	return "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf"
end
function modifier_goo_stack:GetStatusEffectName()
	return "particles/status_fx/status_effect_goo.vpcf"
end
function modifier_goo_stack:DeclareFunctions() return {MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_SOURCE ,MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_goo_stack:GetModifierHealAmplify_PercentageSource()
	return self:GetStackCount()*self.heal_re
end
function modifier_goo_stack:GetModifierLifestealRegenAmplify_Percentage ()
	return self:GetStackCount()*self.heal_re
end
function modifier_goo_stack:GetModifierPhysicalArmorBonus() return self.base_armor + self:GetStackCount()*self.stack_armor end
function modifier_goo_stack:GetModifierMoveSpeedBonus_Percentage() return self.base_slow + self:GetStackCount()*self.stack_slow end
function modifier_goo_stack:OnCreated()
	self.ab = self:GetAbility()
	self.caster = self:GetCaster()
	self.base_armor = self.ab:GetSpecialValueFor("base_armor")*-1
	self.stack_armor = self.ab:GetSpecialValueFor("armor_per_stack")*-1 + self.caster:TG_GetTalentValue("special_bonus_imba_bristleback_2")*-1
	self.base_slow = self.ab:GetSpecialValueFor("base_move_slow")*-1
	self.stack_slow = self.ab:GetSpecialValueFor("move_slow_per_stack")*-1
	self.heal_re = self.ab:GetSpecialValueFor("heal_re")*-1
	if IsServer() then
		self.limit = self.ab:GetSpecialValueFor("stack_limit")+ self.caster:TG_GetTalentValue("special_bonus_imba_bristleback_4")
		self:SetStackCount(1)
	end
end
function modifier_goo_stack:OnRefresh()
	if IsServer() then
		self:SetStackCount( math.min( self:GetStackCount() + 1, self.limit)) 
	end
end

--自动鼻涕
modifier_goo_auto=class({})
function modifier_goo_auto:IsHidden() return true end
function modifier_goo_auto:IsPurgable() return false end
function modifier_goo_auto:IsPurgeException() return false end

function modifier_goo_auto:OnCreated()
    self.ab=self:GetAbility()
    if IsServer() then 
        self:StartIntervalThink(0.5)
   end
end

function modifier_goo_auto:OnIntervalThink()
    if self:GetCaster():IsAlive() and  self.ab and self.ab:GetAutoCastState() and self.ab:GetLevel()>0 and self.ab:IsOwnersManaEnough() and self.ab:IsCooldownReady()  then
        self.ab:OnSpellStart()
        self.ab:UseResources(true, false, true)
		if self.ab:IsHidden() then  
			self:GetCaster():RemoveModifierByName("modifier_goo_auto")
		end
		local ab = self:GetParent():FindAbilityByName("imba_bristleback_warpath")
		if ab ~= nil then
			self:GetCaster():AddNewModifier(self:GetCaster(),ab,"modifier_imba_warpath",{duration = ab:GetSpecialValueFor("duration_warpath")})
		end
    end
end

--刺
imba_bristleback_quill_spray = class({})
LinkLuaModifier("modifier_spray_stack", "ting/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spray_auto", "ting/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
function imba_bristleback_quill_spray:GetIntrinsicModifierName() return "modifier_spray_auto" end
function imba_bristleback_quill_spray:IsHiddenWhenStolen() 		return false end
function imba_bristleback_quill_spray:IsRefreshable() 			return true  end
function imba_bristleback_quill_spray:IsStealable() 			return true  end
function imba_bristleback_quill_spray:IsNetherWardStealable()	return true end
function imba_bristleback_quill_spray:OnUpgrade()
	if not IsServer() then return end
	local mod = self:GetCaster():FindModifierByName("modifier_spray_auto") 
	if mod then
		mod.cdr = self:GetSpecialValueFor("cooldown_reduction")
	end
end

function imba_bristleback_quill_spray:OnSpellStart()
	self.caster = self:GetCaster()
	self.target = nil

	EmitSoundOn("Hero_Bristleback.QuillSpray.Cast", self.caster)
	self:start(self.caster,true) --谁触发的 是不是刚被
end

function imba_bristleback_quill_spray:start(tar,bool)
	if bool then 
		self.target = tar
		self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
	else
		self.target = EntIndexToHScript(tar)
	end
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf", PATTACH_POINT, self.target)
	ParticleManager:SetParticleControl(pfx, 60, Vector(RandomInt(0, 255), RandomInt(0, 255), RandomInt(0, 255)))
	ParticleManager:SetParticleControl(pfx, 61, Vector(1, 0, 0))
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.target:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
				enemy:AddNewModifier_RS(self.caster,self,"modifier_spray_stack",{duration = 7})
	end
end


--自动刺
modifier_spray_auto=class({})
function modifier_spray_auto:IsHidden() return true end
function modifier_spray_auto:IsPurgable() return false end
function modifier_spray_auto:IsPurgeException() return false end
function modifier_spray_auto:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_spray_auto:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.target ~= self.parent then
		return
	end

	if self.ab and self.ab:GetLevel() > 0 then
		local cooldown_remaining = self.ab:GetCooldownTimeRemaining()
		self.ab:EndCooldown()
		if cooldown_remaining > self.cdr then
			self.ab:StartCooldown( cooldown_remaining - self.cdr )
		end
	end
	
end
function modifier_spray_auto:OnCreated()
    self.ab=self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.cdr = self.ab:GetSpecialValueFor("cooldown_reduction")
    if IsServer() then 
        self:StartIntervalThink(0.3)
   end
end

function modifier_spray_auto:OnIntervalThink()
    if self.parent:IsAlive() and  self.ab and self.ab:GetAutoCastState() and self.ab:GetLevel()>0 and self.ab:IsOwnersManaEnough() and self.ab:IsCooldownReady()  then
        self.ab:OnSpellStart()
        self.ab:UseResources(true, false, true)
		if self.ab:IsHidden() then  
			self:GetCaster():RemoveModifierByName("modifier_spray_auto")
		end
		local ab = self.parent:FindAbilityByName("imba_bristleback_warpath")
		if ab ~= nil then
			self:GetCaster():AddNewModifier(self:GetCaster(),ab,"modifier_imba_warpath",{duration = ab:GetSpecialValueFor("duration_warpath")})
		end
    end
end

--刺叠加
modifier_spray_stack=class({})
function modifier_spray_stack:IsHidden() return false end
function modifier_spray_stack:IsPurgable() return true end
function modifier_spray_stack:OnCreated()
	self.ab = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.base_damage = self.ab:GetSpecialValueFor("quill_base_damage")
	self.stack_damage = self.ab:GetSpecialValueFor("quill_stack_damage") + self.caster:TG_GetTalentValue("special_bonus_imba_bristleback_5")
	if IsServer() then
			self.damageTable = {
						victim = self.parent,
						attacker = self.caster,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self.ab, --Optional.
						}
						
		self:SetStackCount(0)
		self:OnRefresh()
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit_creep.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(pfx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, -1, false, false)

	end
end

function modifier_spray_stack:OnRefresh()
	if IsServer() then
		self.damageTable.damage = self.base_damage+self.stack_damage*self:GetStackCount()
			ApplyDamage(self.damageTable)
		if self:GetParent():IsAlive() then
			self:SetStackCount(self:GetStackCount() + 1) 
		end
	end
end
--后背
imba_bristleback_bristleback = class({})
LinkLuaModifier("modifier_imba_ass", "ting/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_bristleback_passive", "ting/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_bristleback_release", "ting/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
function imba_bristleback_bristleback:GetIntrinsicModifierName() return "modifier_imba_bristleback_passive" end
function imba_bristleback_bristleback:IsHiddenWhenStolen() 		return false end
function imba_bristleback_bristleback:IsRefreshable() 			return true  end
function imba_bristleback_bristleback:IsStealable() 			return false  end
function imba_bristleback_bristleback:IsNetherWardStealable()	return false end
function imba_bristleback_bristleback:OnToggle()
	if not IsServer() then return end
	local caster = self:GetCaster()
	if self:GetToggleState() then
		caster:AddNewModifier(caster, self, "modifier_imba_ass", {})
		
	else
        caster:RemoveModifierByName("modifier_imba_ass")
    end
end
function imba_bristleback_bristleback:OnUpgrade()
	if not IsServer() then return end
	local mod = self:GetCaster():FindModifierByName("modifier_imba_bristleback_passive")
	if mod then
	mod.min_degree = self:GetSpecialValueFor("side_angle")
	mod.back_angle  = self:GetSpecialValueFor("back_angle")
	mod.back_damage_reduction = self:GetSpecialValueFor("back_damage_reduction")
	mod.side_damage_reduction = self:GetSpecialValueFor("side_damage_reduction")
	mod.quill_release_threshold = self:GetSpecialValueFor("quill_release_threshold")
	end
end
modifier_imba_bristleback_release = class({})

function modifier_imba_bristleback_release:IsDebuff()			return false end
function modifier_imba_bristleback_release:IsHidden() 			return true end
function modifier_imba_bristleback_release:IsPurgable() 		return false end
function modifier_imba_bristleback_release:IsPurgeException() 	return false end
function modifier_imba_bristleback_release:RemoveOnDeath() 		return false end

function modifier_imba_bristleback_release:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_bristleback_release:OnIntervalThink()
	local ability = self:GetParent():FindAbilityByName("imba_bristleback_quill_spray")
	if ability and ability:GetLevel() > 0 then
		ability:OnSpellStart()
	end
	self:SetStackCount(self:GetStackCount() - 1)
	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end


modifier_imba_bristleback_passive = class({})
LinkLuaModifier("modifier_imba_bristleback_release", "ting/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_bristleback_passive:IsDebuff()			return false end
function modifier_imba_bristleback_passive:IsHidden() 			return true end
function modifier_imba_bristleback_passive:IsPurgable() 		return false end
function modifier_imba_bristleback_passive:IsPurgeException() 	return false end
function modifier_imba_bristleback_passive:DeclareFunctions() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end
function modifier_imba_bristleback_passive:OnCreated()
	self.parent = self:GetParent()
	self.ab = self:GetAbility()
	self.min_degree = self.ab:GetSpecialValueFor("side_angle")
	self.back_angle  = self.ab:GetSpecialValueFor("back_angle")
	self.back_damage_reduction = self.ab:GetSpecialValueFor("back_damage_reduction")
	self.side_damage_reduction = self.ab:GetSpecialValueFor("side_damage_reduction")
	self.quill_release_threshold = self.ab:GetSpecialValueFor("quill_release_threshold")
	
end
function modifier_imba_bristleback_passive:GetModifierIncomingDamage_Percentage(keys)

	if not IsServer() or self.parent:PassivesDisabled() or keys.attacker:IsBuilding() or self.parent:IsIllusion() then
		return
	end
	local cast_angle = VectorToAngles(self.parent:GetForwardVector() * -1)
	local angle = VectorToAngles((keys.attacker:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized())
	local degree = math.abs(AngleDiff(cast_angle[2], angle[2]))
	if self.parent:HasModifier("modifier_warpath_taunt") then
		degree = 1
	end
	if degree <= self.min_degree then
		local reduce = 0
		local ability = self.parent:FindAbilityByName("imba_bristleback_quill_spray")
		self.parent:EmitSound("Hero_Bristleback.Bristleback")
		if self:GetParent():HasModifier("modifier_warpath_taunt") then
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
			ParticleManager:SetParticleControlEnt(pfx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlForward(pfx, 3, (keys.attacker:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized())
			ParticleManager:ReleaseParticleIndex(pfx)
			self:SetStackCount(self:GetStackCount() + keys.damage * (self.back_damage_reduction / 100))
			reduce = self.back_damage_reduction*-1
		else
		
			if degree > self.back_angle then
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_side_dmg.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
				ParticleManager:SetParticleControlEnt(pfx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlForward(pfx, 3, (keys.attacker:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized())
				ParticleManager:ReleaseParticleIndex(pfx)
				self:SetStackCount(self:GetStackCount() + keys.damage * (self.side_damage_reduction / 100))
				reduce = self.side_damage_reduction*-1
			else 
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
				ParticleManager:SetParticleControlEnt(pfx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlForward(pfx, 3, (keys.attacker:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized())
				ParticleManager:ReleaseParticleIndex(pfx)
				self:SetStackCount(self:GetStackCount() + keys.damage * (self.back_damage_reduction / 100))
				reduce = self.back_damage_reduction*-1
			end
		end
		
		if self:GetStackCount() >= self.quill_release_threshold and ability and ability:GetLevel() > 0 then
			local max = math.floor(self:GetStackCount() / self.quill_release_threshold)
			self:SetStackCount(self:GetStackCount() - self.quill_release_threshold * max)
			if self.parent:HasModifier("modifier_imba_bristleback_release") then
				self.parent:SetModifierStackCount("modifier_imba_bristleback_release", nil, self.parent:GetModifierStackCount("modifier_imba_bristleback_release", nil) + max)
			else
				self.parent:AddNewModifier(self.parent, self.ab, "modifier_imba_bristleback_release", {})
				self.parent:SetModifierStackCount("modifier_imba_bristleback_release", nil, self.parent:GetModifierStackCount("modifier_imba_bristleback_release", nil) + max)
			end
		end
		return reduce
	end
end

modifier_imba_ass = class({})
function modifier_imba_ass:IsDebuff()			return false end
function modifier_imba_ass:IsHidden() 			return false end
function modifier_imba_ass:IsPurgable() 		return false end
function modifier_imba_ass:IsPurgeException() 	return false end
function modifier_imba_ass:RemoveOnDeath() 	return true end
function modifier_imba_ass:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_PROPERTY_MOVESPEED_LIMIT, MODIFIER_PROPERTY_MOVESPEED_MAX,MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_DISABLE_TURNING} end

--function modifier_imba_ass:GetModifierMoveSpeed_Absolute() return 350 end
function modifier_imba_ass:GetModifierMoveSpeed_Limit() return 300 end
--function modifier_imba_ass:GetModifierMoveSpeed_Max() return 350 end
function modifier_imba_ass:GetModifierMoveSpeedBonus_Percentage() return self.slow end
function modifier_imba_ass:GetModifierDisableTurning() 
    return 1
end
function modifier_imba_ass:GetModifierIgnoreCastAngle()
    return 1
end
function modifier_imba_ass:OnCreated() 
	self.slow = self:GetAbility():GetSpecialValueFor("ass_slow")*-1
    if not IsServer() then return end
	self.parent = self:GetParent()
	self.parent:SetForwardVector(Vector(self.parent:GetForwardVector()[1]*-1, self.parent:GetForwardVector()[2]*-1, 0))	
end
function modifier_imba_ass:OnDestroy()
	if IsServer() then 
	self.parent:SetAngles(0,0,0)
	self.slow = nil
	end
end

--战意
imba_bristleback_warpath = class({})
LinkLuaModifier("modifier_warpath_taunt", "ting/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bulldoze_buff1", "heros/hero_spirit_breaker/bulldoze.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_warpath_passive", "ting/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
function imba_bristleback_warpath:GetIntrinsicModifierName() return "modifier_imba_warpath_passive" end
function imba_bristleback_warpath:IsHiddenWhenStolen() 		return false end
function imba_bristleback_warpath:IsRefreshable() 			return true  end
function imba_bristleback_warpath:IsStealable() 			return true  end
function imba_bristleback_warpath:IsNetherWardStealable()	return true end
function imba_bristleback_warpath:OnUpgrade()
	if not IsServer() then return end
	local mod = self:GetCaster():FindModifierByName("modifier_imba_warpath_passive")
	if mod then
		mod.duration = self:GetSpecialValueFor("duration_warpath")
	end
end
function imba_bristleback_warpath:OnSpellStart()
	self.caster = self:GetCaster()
	EmitSoundOn("bristleback_bristle_laugh_02", self.caster)
	--self:start(caster,true) 
	self.caster:AddNewModifier(self.caster,self,"modifier_warpath_taunt",{duration = 2.1})
	self.damageTable = {
						attacker = self.caster,
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self, --Optional.
						}
	
end


function imba_bristleback_warpath:OnChannelFinish(bInterrupted)
	self.caster:EmitSound("Hero_Bristleback.QuillSpray.Cast")
	self.caster:EmitSound("Hero_Bristleback.QuillSpray.Cast")
	self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)

	local ab = self.caster:FindAbilityByName("imba_bristleback_quill_spray")	
	local count = 1
	local mod = self.caster:FindModifierByName("modifier_imba_warpath")
	if not bInterrupted then
	local pfx = ParticleManager:CreateParticle("particles/econ/items/bristleback/bristle_spikey_spray/bristle_spikey_quill_spray.vpcf", PATTACH_POINT, self.caster)
	ParticleManager:SetParticleControl(pfx, 60, Vector(RandomInt(0, 255), RandomInt(0, 255), RandomInt(0, 255)))
	ParticleManager:SetParticleControl(pfx, 61, Vector(1, 0, 0))
	ParticleManager:ReleaseParticleIndex(pfx)
	if ab and ab:GetLevel()>0 then
		ab:start(self.caster,true)
	end
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		if mod ~= nil then
			count = mod:GetStackCount()
		end
		self.damageTable.victim = enemy
		self.damageTable.damage = self.caster:GetBaseDamageMax()* count
			if enemy:IsAlive() then
				ApplyDamage(self.damageTable)
			end
	end
	end

end

modifier_imba_warpath= class({})
LinkLuaModifier("modifier_imba_bristleback_release", "ting/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_warpath:IsDebuff()			return false end
function modifier_imba_warpath:IsHidden() 			return false end
function modifier_imba_warpath:IsPurgable() 		return false end
function modifier_imba_warpath:IsPurgeException() 	return false end
function modifier_imba_warpath:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,MODIFIER_PROPERTY_MODEL_SCALE} end
function modifier_imba_warpath:GetModifierMoveSpeedBonus_Percentage() return self.ms*self:GetStackCount() end
function modifier_imba_warpath:GetModifierPhysicalArmorBonus() return self.armor*self:GetStackCount() end
function modifier_imba_warpath:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()*self.att
end
function modifier_imba_warpath:GetModifierModelScale() 
    return 5*self:GetStackCount()
end
function modifier_imba_warpath:OnCreated()
	self.ab = self:GetAbility()
	self.att = self.ab:GetSpecialValueFor("damage_per_stack") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_bristleback_6") --天赋 
	self.ms = self.ab:GetSpecialValueFor("move_speed_per_stack") 
	self.armor = self.ab:GetSpecialValueFor("armor_per_stack") 

	if IsServer() then
		self:SetStackCount(0)
		self:OnRefresh()
	end
end
function modifier_imba_warpath:OnRefresh()
	if IsServer() then
		self:SetStackCount( math.min( self:GetStackCount() + 1, self.ab:GetSpecialValueFor("max_stacks"))  ) 
	end
end

modifier_imba_warpath_passive = class({})
LinkLuaModifier("modifier_imba_warpath", "ting/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_warpath_passive:IsDebuff()			return false end
function modifier_imba_warpath_passive:IsHidden() 			return true end
function modifier_imba_warpath_passive:IsPurgable() 		return false end
function modifier_imba_warpath_passive:IsPurgeException() 	return false end
function modifier_imba_warpath_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end

function modifier_imba_warpath_passive:OnCreated()
	self.ab = self:GetAbility()
	self.parent = self:GetCaster()
	self.duration = self.ab:GetSpecialValueFor("duration_warpath")
end
function modifier_imba_warpath_passive:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self.parent  or self.parent:IsIllusion() then 
		return 
	end

	if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
		return 
	end

	self.parent:AddNewModifier(keys.unit,self.ab,"modifier_imba_warpath",{duration = self.duration})	

end



modifier_warpath_taunt=class({})
function modifier_warpath_taunt:IsHidden() return false end
function modifier_warpath_taunt:IsPurgable() return false end

function modifier_warpath_taunt:GetEffectName()
	return "particles/creatures/greevil/greevil_prison_bottom_ring.vpcf"
end


function modifier_warpath_taunt:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_MODEL_SCALE} end
function modifier_warpath_taunt:CheckState() 
	return 
	{
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_PASSIVES_DISABLED] = false,
    }	
end
function modifier_warpath_taunt:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA 
end
function modifier_warpath_taunt:OnCreated()
	self.ab = self:GetAbility()
	self.parent = self:GetParent()
	self.duration = self.ab:GetSpecialValueFor("taunt_dur")
end
function modifier_warpath_taunt:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.target ~= self.parent then
		return
	end

	keys.attacker:AddNewModifier(self.parent, self.ab , "modifier_huskar_life_break_taunt", {duration = self.duration})
end
function modifier_warpath_taunt:GetModifierModelScale() 
    return 50
end
--魔晶
imba_bristleback_hairball = class({})
LinkLuaModifier("modifier_hairball_root", "ting/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
--function imba_bristleback_hairball:GetIntrinsicModifierName() return "modifier_goo_auto" end
function imba_bristleback_hairball:IsHiddenWhenStolen() 		return false end
function imba_bristleback_hairball:IsRefreshable() 			return true  end
function imba_bristleback_hairball:IsStealable() 			return false  end
function imba_bristleback_hairball:IsNetherWardStealable()	return false end
function imba_bristleback_hairball:OnInventoryContentsChanged()
	if not IsServer() then return end
    if self:GetCaster():Has_Aghanims_Shard() then 
       self:SetHidden(false)
	   self:SetStolen(true)
       self:SetLevel(1)
    else
		self:SetHidden(true)
		self:SetLevel(0)
		self:SetStolen(true)
    end
end

function imba_bristleback_hairball:OnSpellStart()
	self.caster = self:GetCaster()
	self.team = self.caster:GetTeamNumber()
	self.stack1 = self:GetSpecialValueFor("quill_stack") 
	self.stack2 = self:GetSpecialValueFor("goo_stack") + self.caster:TG_GetTalentValue("special_bonus_imba_bristleback_3")
	self.root_radius = self:GetSpecialValueFor("root_radius")
	self.root = self:GetSpecialValueFor("root")
	EmitSoundOn("Hero_Bristleback.ViscousGoo.Cast", self.caster)
	self.pos = self:GetCursorPosition()
	local distance = (self.pos - self.caster:GetAbsOrigin()):Length2D()
	local direction = (self.pos - self.caster:GetAbsOrigin()):Normalized()
	direction.z = 0
	local pfxname ="particles/units/heroes/hero_bristleback/bristleback_hairball.vpcf" 
	local target = CreateModifierThinker(self.caster, self, "modifier_dummy_thinker", {duration = 5}, self.pos, self.caster:GetTeamNumber(), false)
	local info = 
	{
		Ability = self,
		EffectName = pfxname,
		vSpawnOrigin = self.caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = 0,
		fEndRadius = 0,
		Source = self.caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_NONE,
		bDeleteOnHit = true,
		vVelocity = direction * 1200,
		bProvidesVision = false,
		ExtraData = {tar = target:entindex()}
	}
	ProjectileManager:CreateLinearProjectile(info)
	self.caster:EmitSound("Hero_Meepo.Earthbind.Cast")
end


function imba_bristleback_hairball:OnProjectileThink_ExtraData(pos, keys)
	AddFOWViewer(self.team, pos, 300, FrameTime(), false)
end

function imba_bristleback_hairball:OnProjectileHit_ExtraData(target, pos, keys)
	local ability = self.caster:FindAbilityByName("imba_bristleback_quill_spray")
	local tar = keys.tar

	if ability and ability:GetLevel()>0 then	
	for i = 1 , self.stack1 do 
		ability:start(tar)
	EmitSoundOn("Hero_Bristleback.QuillSpray.Cast", self.caster)
	end
	end
	local ability2 = self.caster:FindAbilityByName("imba_bristleback_viscous_nasal_goo")
	if ability2 and ability2:GetLevel()>0 then	
	for j = 1 , self.stack2 do 
		ability2:OnSpellStart(pos,keys.tar)
	end
	
	end
	
	local enemies = FindUnitsInRadius(self.team, pos, nil, self.root_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
				enemy:AddNewModifier(self.caster,self,"modifier_hairball_root",{duration = self.root})
	end
end

modifier_hairball_root=class({})
function modifier_hairball_root:IsHidden() return false end
function modifier_hairball_root:IsPurgable() return true end

function modifier_hairball_root:GetEffectName()
	return "particles/econ/items/bristleback/ti7_head_nasal_goo/bristleback_ti7_nasal_goo_debuff.vpcf"
end
function modifier_hairball_root:CheckState() 			return {[MODIFIER_STATE_ROOTED] = true} end
