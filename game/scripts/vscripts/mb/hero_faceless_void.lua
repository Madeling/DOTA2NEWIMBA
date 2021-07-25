
-- Author: MouJiaoZi 01/08/2018
-- Arrangement: MysticBug 01/13/2021

--------------------------------------------------------------
--		   		 IMBA_FACELESS_VOID_TIME_WALK               --
--------------------------------------------------------------
CreateTalents("npc_dota_hero_faceless_void", "mb/hero_faceless_void")
imba_faceless_void_time_walk = class({})

LinkLuaModifier("modifier_imba_time_walk_slow", "mb/hero_faceless_void", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_time_walk_buff", "mb/hero_faceless_void", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_time_walk_motion", "mb/hero_faceless_void", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_time_walk_damage", "mb/hero_faceless_void", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_time_walk_damage_counter", "mb/hero_faceless_void", LUA_MODIFIER_MOTION_NONE)
--shard_abi
LinkLuaModifier("modifier_imba_time_walk_reverse_counter", "mb/hero_faceless_void", LUA_MODIFIER_MOTION_NONE)


function imba_faceless_void_time_walk:IsHiddenWhenStolen() 		return false end
function imba_faceless_void_time_walk:IsRefreshable() 			return true  end
function imba_faceless_void_time_walk:IsStealable() 			return true  end
function imba_faceless_void_time_walk:IsNetherWardStealable() 	return true end
function imba_faceless_void_time_walk:GetCastRange(location , target)
	if IsClient() then 
		if self:GetCaster():Has_Aghanims_Shard() then 
			return self:GetSpecialValueFor("range")	+ self:GetCaster():TG_GetTalentValue("special_bonus_imba_faceless_void_3") + self:GetSpecialValueFor("range_shard")
		else
			return self:GetSpecialValueFor("range")	+ self:GetCaster():TG_GetTalentValue("special_bonus_imba_faceless_void_3")
		end	
	end
end
--Shard Abi
function imba_faceless_void_time_walk:GetAssociatedSecondaryAbilities()  return "imba_faceless_void_time_walk_reverse" end
--Talent
function imba_faceless_void_time_walk:GetCooldown(i) return self.BaseClass.GetCooldown(self, i) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_faceless_void_4") end
function imba_faceless_void_time_walk:GetIntrinsicModifierName() return "modifier_imba_time_walk_damage" end
function imba_faceless_void_time_walk:GetAbilityTextureName()	return "faceless_void/jewelofaeons/faceless_void_time_walk_1" end
function imba_faceless_void_time_walk:OnSpellStart()
	local caster = self:GetCaster()
	local original_pos = caster:GetAbsOrigin()
	local pos = self:GetCursorPosition()
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0
	local max_distance = self:GetSpecialValueFor("range") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_faceless_void_3") + caster:GetCastRangeBonus()
	if self:GetCaster():Has_Aghanims_Shard() then 
		max_distance = max_distance + self:GetSpecialValueFor("range_shard")
	end
	local distance = math.min(max_distance, (caster:GetAbsOrigin() - pos):Length2D())
	local tralve_duration = distance / self:GetSpecialValueFor("speed")
	local sound_name = "Hero_FacelessVoid.TimeWalk"
	--if HeroItems:UnitHasItem(caster, "jewel_of_aeons") then
		sound_name = "Hero_FacelessVoid.TimeWalk.Aeons"
	--end
	caster:AddNewModifier(caster, self, "modifier_imba_time_walk_motion", {duration = tralve_duration, direction = direction})
	local buffs = caster:FindAllModifiersByName("modifier_imba_time_walk_damage_counter")
	local heal = 0 
	for _, buff in pairs(buffs) do
		heal = heal + buff:GetStackCount() / 10
	end
	caster:EmitSound(sound_name)
	caster:Heal(heal, caster)
	--Shard Abi 
	if caster:Has_Aghanims_Shard() then 
	    local shard_abi=caster:FindAbilityByName("imba_faceless_void_time_walk_reverse")
	    if shard_abi~=nil then 
	    	shard_abi:SetLevel(self:GetLevel()) 
	    	caster:SwapAbilities( "imba_faceless_void_time_walk", "imba_faceless_void_time_walk_reverse", false, true )
	    	--1.5s 
	    	caster:AddNewModifier(caster, self, "modifier_imba_time_walk_reverse_counter", {duration = 1.5 + tralve_duration, original_pos = original_pos})
	    end 
    end
end

modifier_imba_time_walk_motion = class({})

function modifier_imba_time_walk_motion:IsDebuff()			return false end
function modifier_imba_time_walk_motion:IsHidden() 			return true end
function modifier_imba_time_walk_motion:IsPurgable() 		return false end
function modifier_imba_time_walk_motion:IsPurgeException() 	return false end
function modifier_imba_time_walk_motion:GetEffectName() return "particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_jewel.vpcf" end
function modifier_imba_time_walk_motion:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_time_walk_motion:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_STUNNED] = true} end
function modifier_imba_time_walk_motion:IsMotionController() return true end
function modifier_imba_time_walk_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_time_walk_motion:OnCreated(keys)
	if IsServer() then
		self.direction = StringToVector(keys.direction)
		self.speed = self:GetAbility():GetSpecialValueFor("speed")
		self.effected_enemies = {}
		if not self:CheckMotionControllers() then
			self:Destroy()
		else
			self:StartIntervalThink(FrameTime())
		end
	end
end

function modifier_imba_time_walk_motion:OnIntervalThink()
	local me = self:GetParent()
	local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + self.direction * (self.speed / (1.0 / dt))
	new_pos = GetGroundPosition(new_pos, nil)
	me:SetOrigin(new_pos)
	CreateChronosphere(me, self:GetAbility(), me:GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("chrono_radius"), self:GetAbility():GetSpecialValueFor("chrono_linger"), 6)
	local enemy = FindUnitsInRadius(me:GetTeamNumber(), me:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("chrono_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i=1, #enemy do
		if not IsInTable(enemy[i], self.effected_enemies) then
			self.effected_enemies[#self.effected_enemies + 1] = enemy[i]
		end
	end
end

function modifier_imba_time_walk_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		self.direction = nil
		self.speed = nil
		if #self.effected_enemies > 0 then
			local modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_time_walk_buff", {duration = self:GetAbility():GetSpecialValueFor("duration")})
			modifier:SetStackCount(modifier:GetStackCount() + #self.effected_enemies)
		end 
		--05-09 Arrangement by MysteryBug
		if self:GetCaster():HasScepter() and self:GetAbility():GetName() == "imba_faceless_void_time_walk" then 
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			CreateChronosphere(self:GetParent(), self:GetAbility(), self:GetCaster():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius_scepter"), 1, 2)
			for _, enemy in pairs(enemies) do
				self:GetParent():PerformAttack(enemy, false, true, true, true, false, false, false)
			end
		end
	end
end

modifier_imba_time_walk_slow = class({})

function modifier_imba_time_walk_slow:IsDebuff()				return true end
function modifier_imba_time_walk_slow:IsHidden() 				return false end
function modifier_imba_time_walk_slow:IsPurgable() 				return true end
function modifier_imba_time_walk_slow:IsPurgeException() 		return true end
function modifier_imba_time_walk_slow:GetEffectName()	return "particles/units/heroes/hero_faceless_void/faceless_void_time_walk_debuff.vpcf" end
function modifier_imba_time_walk_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_time_walk_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_time_walk_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("slow")) end

modifier_imba_time_walk_buff = class({})

function modifier_imba_time_walk_buff:IsDebuff()				return false end
function modifier_imba_time_walk_buff:IsHidden() 				return false end
function modifier_imba_time_walk_buff:IsPurgable() 				return true end
function modifier_imba_time_walk_buff:IsPurgeException() 		return true end
function modifier_imba_time_walk_buff:GetEffectName()	return "particles/units/heroes/hero_faceless_void/faceless_void_time_walk.vpcf" end
function modifier_imba_time_walk_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_time_walk_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_time_walk_buff:GetModifierMoveSpeedBonus_Percentage() return (self:GetStackCount() * self.move_bonus) end
function modifier_imba_time_walk_buff:GetModifierAttackSpeedBonus_Constant() return (self:GetStackCount() * self.attack_speed_bonus) end
function modifier_imba_time_walk_buff:OnCreated() 
	self.move_bonus=self:GetAbility():GetSpecialValueFor("move_bonus")
	self.attack_speed_bonus=self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
end

function modifier_imba_time_walk_buff:OnDestroy() 
	self.move_bonus=nil
	self.attack_speed_bonus=nil
end

modifier_imba_time_walk_damage_counter = class({})

function modifier_imba_time_walk_damage_counter:IsDebuff()				return false end
function modifier_imba_time_walk_damage_counter:IsHidden() 				return true end
function modifier_imba_time_walk_damage_counter:IsPurgable() 			return false end
function modifier_imba_time_walk_damage_counter:IsPurgeException() 		return false end
function modifier_imba_time_walk_damage_counter:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_time_walk_damage_counter:RemoveOnDeath() return false end

modifier_imba_time_walk_damage = class({})

function modifier_imba_time_walk_damage:IsDebuff()				return false end
function modifier_imba_time_walk_damage:IsHidden() 				return true end
function modifier_imba_time_walk_damage:IsPurgable() 			return false end
function modifier_imba_time_walk_damage:IsPurgeException() 		return false end
function modifier_imba_time_walk_damage:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_imba_time_walk_damage:OnTakeDamage(keys)
	if not IsServer() then 
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
	end
	local buff = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_time_walk_damage_counter", {duration = self:GetAbility():GetSpecialValueFor("damage_time")})
	if buff ~= nil then 
		buff:SetStackCount(keys.damage * 10)
	end
end


modifier_imba_time_walk_reverse_counter = class({})

function modifier_imba_time_walk_reverse_counter:IsDebuff()				return false end
function modifier_imba_time_walk_reverse_counter:IsHidden() 			return true end
function modifier_imba_time_walk_reverse_counter:IsPurgable() 			return false end
function modifier_imba_time_walk_reverse_counter:IsPurgeException() 	return false end
function modifier_imba_time_walk_reverse_counter:OnCreated(keys) self.original_pos = keys.original_pos end
function modifier_imba_time_walk_reverse_counter:OnDestroy(keys)
	self.original_pos = nil
	if IsServer() then
         self:GetParent():SwapAbilities( "imba_faceless_void_time_walk", "imba_faceless_void_time_walk_reverse", true, false )
    end 	
end
--------------------------------------------------------------
--		  IMBA_FACELESS_VOID_TIME_WALK_REVERSE              --
--------------------------------------------------------------
imba_faceless_void_time_walk_reverse = class({})

function imba_faceless_void_time_walk_reverse:IsHiddenWhenStolen() 		return false end
function imba_faceless_void_time_walk_reverse:IsRefreshable() 			return true  end
function imba_faceless_void_time_walk_reverse:IsStealable() 			return false  end
function imba_faceless_void_time_walk_reverse:IsNetherWardStealable() 	return false end
function imba_faceless_void_time_walk_reverse:GetAssociatedPrimaryAbilities()  return "imba_faceless_void_time_walk" end
function imba_faceless_void_time_walk_reverse:OnSpellStart()
	local caster = self:GetCaster()
	local shard_handler = caster:FindModifierByName("modifier_imba_time_walk_reverse_counter")
	local pos = StringToVector(shard_handler.original_pos) or caster:GetAbsOrigin()
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0
	local distance = (caster:GetAbsOrigin() - pos):Length2D()
	local tralve_duration = distance / self:GetSpecialValueFor("speed")
	local sound_name = "Hero_FacelessVoid.TimeWalk.Aeons"
	caster:AddNewModifier(caster, self, "modifier_imba_time_walk_motion", {duration = tralve_duration, direction = direction})
	caster:EmitSound(sound_name)
end

--------------------------------------------------------------
--		   	 IMBA_FACELESS_VOID_TIME_DILATION               --
--------------------------------------------------------------
imba_faceless_void_time_dilation = class({})

LinkLuaModifier("modifier_imba_time_dilation_slow", "mb/hero_faceless_void", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_time_dilation_buff", "mb/hero_faceless_void", LUA_MODIFIER_MOTION_NONE)

function imba_faceless_void_time_dilation:IsHiddenWhenStolen() 		return false end
function imba_faceless_void_time_dilation:IsRefreshable() 			return true  end
function imba_faceless_void_time_dilation:IsStealable() 			return true  end
function imba_faceless_void_time_dilation:IsNetherWardStealable() 	return true end

function imba_faceless_void_time_dilation:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end
function imba_faceless_void_time_dilation:GetAbilityTextureName()	return "faceless_void/brancerofaeons/faceless_void_time_dilation_crimson" end
function imba_faceless_void_time_dilation:OnSpellStart()
	local caster = self:GetCaster()
	local pfx_name = "particles/units/heroes/hero_faceless_void/faceless_void_timedialate.vpcf"
	local pfx_debuff_name = "particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf.vpcf"
	local sound_name = "Hero_FacelessVoid.TimeDilation.Cast"
	--[[if HeroItems:UnitHasItem(caster, "bracers_of_aeons_of_witness") then
		pfx_name = "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_timedialate.vpcf"
		pfx_debuff_name = "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_dialatedebuf.vpcf"
		sound_name = "Hero_FacelessVoid.TimeDilation.Cast.ti7"
	--end]]
	--if HeroItems:UnitHasItem(caster, "bracers_of_aeons_of_the_crimson_witness") then
		pfx_name = "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_red_timedialate.vpcf"
		pfx_debuff_name = "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_dialatedebuf_red.vpcf"
		sound_name = "Hero_FacelessVoid.TimeDilation.Cast.ti7"
	--end
	caster:EmitSound(sound_name)
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius")))
	ParticleManager:ReleaseParticleIndex(pfx)
	local cooldown_ability = 0
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		local cooldown_ability_per = 0
		for i=0,23 do
			local ability = enemy:GetAbilityByIndex(i)
			if ability then
				if not ability:IsCooldownReady() and not ability:IsPassive() and ability:GetCooldownTime() ~= 0 then
					cooldown_ability_per = cooldown_ability_per + 1
					cooldown_ability = cooldown_ability + 1
					--print(ability:GetName(), ability:GetCooldownTimeRemaining())
					ability:StartCooldown(ability:GetCooldownTimeRemaining() + self:GetSpecialValueFor("cooldown_increase"))
				else
					ability:StartCooldown(self:GetSpecialValueFor("cooldown_start"))
				end
			end
		end
		if cooldown_ability_per ~= 0 then
			EmitSoundOnLocationWithCaster(enemy:GetAbsOrigin(), "Hero_FacelessVoid.TimeDilation.Target", enemy)
			local debuff = enemy:AddNewModifier_RS(caster, self, "modifier_imba_time_dilation_slow", {duration = self:GetSpecialValueFor("cooldown_increase")})
			debuff:SetStackCount(cooldown_ability_per)
			local pfx2 = ParticleManager:CreateParticle(pfx_debuff_name, PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(pfx2, 1, Vector(cooldown_ability_per, 0, 0))
			debuff:AddParticle(pfx2, false, false, 15, false, false)
		end
	end
	if cooldown_ability ~= 0 then
		local buff = caster:AddNewModifier(caster, self, "modifier_imba_time_dilation_buff", {duration = self:GetSpecialValueFor("cooldown_increase")})
		buff:SetStackCount(cooldown_ability)
	end
end

modifier_imba_time_dilation_slow = class({})

function modifier_imba_time_dilation_slow:IsDebuff()			return true end
function modifier_imba_time_dilation_slow:IsHidden() 			return false end
function modifier_imba_time_dilation_slow:IsPurgable() 			return true end
function modifier_imba_time_dilation_slow:IsPurgeException() 	return true end
function modifier_imba_time_dilation_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_time_dilation_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetStackCount() * self:GetAbility():GetSpecialValueFor("move_slow")) end
function modifier_imba_time_dilation_slow:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetStackCount() * self:GetAbility():GetSpecialValueFor("attack_slow")) end

modifier_imba_time_dilation_buff = class({})

function modifier_imba_time_dilation_buff:IsDebuff()			return false end
function modifier_imba_time_dilation_buff:IsHidden() 			return false end
function modifier_imba_time_dilation_buff:IsPurgable() 			return true end
function modifier_imba_time_dilation_buff:IsPurgeException() 	return true end
function modifier_imba_time_dilation_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_time_dilation_buff:GetEffectName() return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf" end
function modifier_imba_time_dilation_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_time_dilation_buff:GetModifierMoveSpeedBonus_Percentage() return (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("move_bonus")) end
function modifier_imba_time_dilation_buff:GetModifierAttackSpeedBonus_Constant() return (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("attack_bonus")) end

--------------------------------------------------------------
--		   	   IMBA_FACELESS_VOID_TIME_LOCK                 --
--------------------------------------------------------------
imba_faceless_void_time_lock = class({})

LinkLuaModifier("modifier_imba_faceless_void_time_lock_passive", "mb/hero_faceless_void", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_faceless_void_time_lock_reduce", "mb/hero_faceless_void", LUA_MODIFIER_MOTION_NONE)

function imba_faceless_void_time_lock:OnUpgrade()
	local ability = self:GetCaster():FindAbilityByName("faceless_void_backtrack")
	if ability then
		ability:SetLevel(self:GetLevel())
	end
end

function imba_faceless_void_time_lock:GetIntrinsicModifierName() return "modifier_imba_faceless_void_time_lock_passive" end

modifier_imba_faceless_void_time_lock_passive = class({})

function modifier_imba_faceless_void_time_lock_passive:IsDebuff()			return false end
function modifier_imba_faceless_void_time_lock_passive:IsHidden() 			return true end
function modifier_imba_faceless_void_time_lock_passive:IsPurgable() 		return false end
function modifier_imba_faceless_void_time_lock_passive:IsPurgeException() 	return false end

function modifier_imba_faceless_void_time_lock_passive:DeclareFunctions()	return {MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL} end

--function modifier_imba_faceless_void_time_lock_passive:OnAttackLanded(keys)
function modifier_imba_faceless_void_time_lock_passive:GetModifierProcAttack_BonusDamage_Magical(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return 
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	if PseudoRandom:RollPseudoRandom(self:GetAbility(), self:GetAbility():GetSpecialValueFor("bash_chance")) then
	--if RollPseudoRandomPercentage(self:GetAbility():GetSpecialValueFor("bash_chance"),0,self:GetParent()) then
		--resource
		local bash_damage = self:GetAbility():GetSpecialValueFor("bash_damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_faceless_void_2")
		local bash_duration = self:GetAbility():GetSpecialValueFor("bash_duration")
		local buff = self:GetParent():GetModifierStackCount("modifier_imba_faceless_void_time_lock_reduce", self:GetParent())
		local radius = math.max(self:GetAbility():GetSpecialValueFor("radius_min"), self:GetAbility():GetSpecialValueFor("bash_radius") - self:GetAbility():GetSpecialValueFor("radius_reduce") * buff)
		--if cooldown ready
		if self:GetAbility():IsCooldownReady() then
			local damageTable = {
					--victim = enemy,
					attacker = self:GetParent(),
					damage = bash_damage,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = self:GetAbility(), --Optional.
			}
			--IMBA Create a Chronosphere
			CreateChronosphere(self:GetParent(), self:GetAbility(), keys.target:GetAbsOrigin(), radius, bash_duration, 2)
			if not self:GetParent():TG_HasTalent("special_bonus_imba_faceless_void_5") then
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_faceless_void_time_lock_reduce", {duration = self:GetAbility():GetSpecialValueFor("reduce_duration")})
			end
			--AOE Damage
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), keys.target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				if enemy ~= keys.target then 
					damageTable.victim = enemy
					ApplyDamage(damageTable)
				end
			end
			--Start Cooldown
			self:GetAbility():UseResources(true, true, true)
		end
		--play sound 
		keys.target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
		--play effect 
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pfx, 0, keys.target:GetAbsOrigin() )
        ParticleManager:SetParticleControl(pfx, 1, keys.target:GetAbsOrigin() )
        ParticleManager:SetParticleControlEnt(pfx, 2, self:GetParent(), PATTACH_CUSTOMORIGIN, "attach_hitloc", keys.target:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(pfx)
		--IMBA Time Lord 
		for i = 0, 23 do
			local current_ability = keys.target:GetAbilityByIndex(i)
			if current_ability and not current_ability:IsCooldownReady() and current_ability:GetCooldownTime() ~= 0 then
				current_ability:StartCooldown( current_ability:GetCooldownTimeRemaining() + self:GetAbility():GetSpecialValueFor("cooldown_increase") )
			end
		end
		--Target effect
		--眩晕
		keys.target:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = bash_duration})
		--attack once 
		Timers:CreateTimer(0.33, function()
			--异步攻击，否则一起木大木大会BOOM
			if not self:GetAbility():IsNull() and keys.target:IsAlive() then
				self:GetParent():PerformAttack(keys.target, false, true, true, false, false, false, false)
			end
		end)
		--target damage
		return bash_damage
	end
end

modifier_imba_faceless_void_time_lock_reduce = class({})

function modifier_imba_faceless_void_time_lock_reduce:IsDebuff()			return true end
function modifier_imba_faceless_void_time_lock_reduce:IsHidden() 			return false end
function modifier_imba_faceless_void_time_lock_reduce:IsPurgable() 			return false end
function modifier_imba_faceless_void_time_lock_reduce:IsPurgeException() 	return false end

function modifier_imba_faceless_void_time_lock_reduce:OnRefresh() self:IncrementStackCount() end

--------------------------------------------------------------
--		   	   IMBA_FACELESS_VOID_CHRONOSPHERE              --
--------------------------------------------------------------
imba_faceless_void_chronosphere = class({})

LinkLuaModifier("modifier_imba_faceless_void_chronosphere_aoe", "mb/hero_faceless_void", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_faceless_void_chronosphere_thinker", "mb/hero_faceless_void", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_faceless_void_chronosphere_debuff", "mb/hero_faceless_void", LUA_MODIFIER_MOTION_NONE)

function imba_faceless_void_chronosphere:IsHiddenWhenStolen() 		return false end
function imba_faceless_void_chronosphere:IsRefreshable() 			return true  end
function imba_faceless_void_chronosphere:IsStealable() 				return true  end
function imba_faceless_void_chronosphere:IsNetherWardStealable() 	return true end
function imba_faceless_void_chronosphere:GetIntrinsicModifierName() return "modifier_imba_faceless_void_chronosphere_aoe" end

function imba_faceless_void_chronosphere:GetAOERadius() return self:GetSpecialValueFor("base_radius") + self:GetCaster():GetModifierStackCount("modifier_imba_faceless_void_chronosphere_aoe", self:GetCaster()) / 100 * self:GetSpecialValueFor("extra_radius") end
function imba_faceless_void_chronosphere:GetAbilityTextureName()	return "faceless_void/maceofaeons/faceless_void_chronosphere" end
function imba_faceless_void_chronosphere:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local radius = self:GetAOERadius()
	caster:SpendMana(caster:GetMana(), self)
	local time = self:GetSpecialValueFor("base_duration")
	if math.random(0,49) == math.random(0,49) then
		time = 1.9
		--EmitGlobalSound("Imba.FacelessZaWarudo")
		caster:EmitSound("Imba.FacelessZaWarudo")
		caster:SetContextThink(DoUniqueString("DIO"),
									function()
										CreateChronosphere(caster, self, pos, 3000, 9, 1)
										return nil
									end,1.8)
	end
	local thinker = CreateChronosphere(caster, self, pos, radius, time, 1)

	thinker:EmitSound("Hero_FacelessVoid.Chronosphere.MaceOfAeons")

	if caster:TG_HasTalent("special_bonus_imba_faceless_void_1") then
		caster:GiveMana(caster:TG_GetTalentValue("special_bonus_imba_faceless_void_1"))
	end
end

function CreateChronosphere(caster, ability, position, radius, duration, ally_behavior)
	-- Ally Behavior: 1 = Stun Allies, 2 = DO NOT EFFECT Allies, 4 = DO NOT EFFECT SPELL IMMUNE Enemies ////  add them up
	ially_behavior = ally_behavior or 1
	local thinker = CreateModifierThinker(caster, ability, "modifier_imba_faceless_void_chronosphere_thinker", {duration = duration, radius = radius, ally_behavior = ially_behavior}, position, caster:GetTeamNumber(), false)
	return thinker
end

modifier_imba_faceless_void_chronosphere_aoe = class({})

function modifier_imba_faceless_void_chronosphere_aoe:IsDebuff()			return false end
function modifier_imba_faceless_void_chronosphere_aoe:IsHidden() 			return true end
function modifier_imba_faceless_void_chronosphere_aoe:IsPurgable() 			return false end
function modifier_imba_faceless_void_chronosphere_aoe:IsPurgeException() 	return false end

function modifier_imba_faceless_void_chronosphere_aoe:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_faceless_void_chronosphere_aoe:OnIntervalThink()
	if self:GetAbility():IsCooldownReady() then
		local stacks = self:GetParent():GetMana() / self:GetAbility():GetManaCost(self:GetAbility():GetLevel()) * 100
		self:SetStackCount(stacks)
	end
end

modifier_imba_faceless_void_chronosphere_thinker = class({})

function modifier_imba_faceless_void_chronosphere_thinker:OnCreated(keys)
	if IsServer() then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), keys.radius, self:GetDuration(), false)
		self.radius = keys.radius
		self.ally_behavior = keys.ally_behavior
		local pfx_name = "particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf"
		if self.radius < 3000 then
			pfx_name = "particles/econ/items/faceless_void/faceless_void_mace_of_aeons/fv_chronosphere_aeons.vpcf"
		end
		local id=tonumber(tostring(PlayerResource:GetSteamID(self:GetCaster():GetPlayerOwnerID())))
		if (self:GetCaster():GetName()=="npc_dota_hero_rubick" or id == 76561198054050405 ) and self.radius < 3000 then 
			pfx_name = "particles/units/heroes/hero_rubick/rubick_faceless_void_chronosphere.vpcf"
		end
		if (id== 76561198361355161 or id ==76561198100269546 ) and self.radius < 3000 then 
			pfx_name = "particles/face/mace_of_aeons_ult/red/fv_chronosphere_aeons_red.vpcf" --laojiezhuanshu
		end
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(pfx, false, false, 16, false, false)
	end
end

function modifier_imba_faceless_void_chronosphere_thinker:IsAura() return true end
function modifier_imba_faceless_void_chronosphere_thinker:GetAuraDuration() return 0.1 end
function modifier_imba_faceless_void_chronosphere_thinker:GetModifierAura() return "modifier_imba_faceless_void_chronosphere_debuff" end
function modifier_imba_faceless_void_chronosphere_thinker:GetAuraRadius() return self.radius end
function modifier_imba_faceless_void_chronosphere_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_faceless_void_chronosphere_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_imba_faceless_void_chronosphere_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_faceless_void_chronosphere_thinker:GetAuraEntityReject(unit)
	if bit.band(self.ally_behavior, 4) == 4 and unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and unit:IsMagicImmune() then
		return true
	end
	if bit.band(self.ally_behavior, 2) == 2 and unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return true
	end
	if unit:IsInvulnerable() and unit:IsHero() then
		return true
	end
end

modifier_imba_faceless_void_chronosphere_debuff = class({})

--Chronosphere Parent Type
Chronosphere_Caster = 1
Chronosphere_Ally = 2
Chronosphere_Ally_Scepter = 3
Chronosphere_Enemy = 4
Chronosphere_Enemy_Ability = 5

function modifier_imba_faceless_void_chronosphere_debuff:OnCreated()
	self.buff_type = 0
	if self:GetParent():GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID()then
		self.buff_type = Chronosphere_Caster
	elseif self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and not self:GetCaster():HasScepter() then
		self.buff_type = Chronosphere_Ally
	elseif self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and self:GetCaster():HasScepter() then
		self.buff_type = Chronosphere_Ally_Scepter
	elseif self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and not self:GetParent():HasModifier("modifier_imba_faceless_void_chronosphere_aoe") then
		self.buff_type = Chronosphere_Enemy
	elseif self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetParent():HasModifier("modifier_imba_faceless_void_chronosphere_aoe") then
		self.buff_type = Chronosphere_Enemy_Ability
	else
		self.buff_type = Chronosphere_Enemy
	end
	self.ms = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false) * (1 - (self:GetAbility():GetSpecialValueFor("slow_scepter") / 100))
	if IsServer() and self:IsMotionController() then
		self:GetParent():InterruptMotionControllers(false)
		self.abs = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_faceless_void_chronosphere_debuff:OnIntervalThink()
	self:CheckMotionControllers()
	self:GetParent():InterruptMotionControllers(false)
	self:GetParent():SetOrigin(self.abs)
end

function modifier_imba_faceless_void_chronosphere_debuff:OnDestroy()
	if IsServer() and self:IsMotionController() then
		self.abs = nil
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
	self.buff_type = nil
end

function modifier_imba_faceless_void_chronosphere_debuff:IsHidden() 			return false end
function modifier_imba_faceless_void_chronosphere_debuff:IsPurgable() 			return false end
function modifier_imba_faceless_void_chronosphere_debuff:IsPurgeException() 	return false end
function modifier_imba_faceless_void_chronosphere_debuff:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_imba_faceless_void_chronosphere_debuff:IsDebuff() return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Enemy_Ability) end
function modifier_imba_faceless_void_chronosphere_debuff:IsStunDebuff()	return self:IsDebuff() end
function modifier_imba_faceless_void_chronosphere_debuff:IsMotionController() return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Ally_Scepter or self.buff_type == Chronosphere_Enemy_Ability) end
function modifier_imba_faceless_void_chronosphere_debuff:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_imba_faceless_void_chronosphere_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_imba_faceless_void_chronosphere_debuff:StatusEffectPriority() return 16 end
function modifier_imba_faceless_void_chronosphere_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_faceless_void_chronosphere_debuff:GetEffectName()
	if not self:IsMotionController() then
		return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"
	else
		return nil
	end
end

function modifier_imba_faceless_void_chronosphere_debuff:CheckState()
	if self:IsMotionController() then
		return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_FROZEN] = true}
	elseif self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Enemy_Ability then
		return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	else
		return nil
	end
end

function modifier_imba_faceless_void_chronosphere_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN, MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX, MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_imba_faceless_void_chronosphere_debuff:GetModifierMoveSpeed_AbsoluteMin()
	if self.buff_type == Chronosphere_Caster then
		return self:GetAbility():GetSpecialValueFor("chrono_ms")
	elseif self.buff_type == Chronosphere_Ally_Scepter then
		return self.ms
	else
		return nil
	end
end

function modifier_imba_faceless_void_chronosphere_debuff:GetModifierMoveSpeed_AbsoluteMax()
	if self.buff_type ==  Chronosphere_Caster then
		return self:GetAbility():GetSpecialValueFor("chrono_ms")
	elseif self.buff_type == Chronosphere_Ally_Scepter then
		return self.ms
	else
		return nil
	end
end

function modifier_imba_faceless_void_chronosphere_debuff:GetModifierTurnRate_Percentage()
	if self.buff_type == Chronosphere_Ally_Scepter then
		return (0 -self:GetAbility():GetSpecialValueFor("slow_scepter"))
	else
		return nil
	end
end

function modifier_imba_faceless_void_chronosphere_debuff:GetModifierAttackSpeedBonus_Constant()
	if self.buff_type == Chronosphere_Caster then
		return (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus_as"))
	else
		return nil
	end
end

function modifier_imba_faceless_void_chronosphere_debuff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetCaster() or self:GetAbility() ~= self:GetParent():FindAbilityByName("imba_faceless_void_chronosphere") then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() or not keys.target:HasModifier("modifier_imba_faceless_void_chronosphere_debuff") or not keys.target:IsAlive() then
		return
	end
	self:IncrementStackCount()
end