-- Author: MysticBug 08/30/2021

--------------------------------------------------------------
--		   		 IMBA_FACELESS_VOID_TIME_WALK               --
--------------------------------------------------------------
CreateTalents("npc_dota_hero_faceless_void", "mb/hero_faceless_void/faceless_void_time_walk")
imba_faceless_void_time_walk = class({})

LinkLuaModifier("modifier_imba_time_walk_slow", "mb/hero_faceless_void/faceless_void_time_walk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_time_walk_buff", "mb/hero_faceless_void/faceless_void_time_walk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_faceless_void_time_walk_motion", "mb/hero_faceless_void/faceless_void_time_walk", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_time_walk_damage", "mb/hero_faceless_void/faceless_void_time_walk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_time_walk_damage_counter", "mb/hero_faceless_void/faceless_void_time_walk", LUA_MODIFIER_MOTION_NONE)
--scepter
require("mb/hero_faceless_void/faceless_void_chronosphere")
--shard_abi
LinkLuaModifier("modifier_imba_time_walk_reverse_counter", "mb/hero_faceless_void/faceless_void_time_walk", LUA_MODIFIER_MOTION_NONE)

function imba_faceless_void_time_walk:IsHiddenWhenStolen() 		return false end
function imba_faceless_void_time_walk:IsRefreshable() 			return true  end
function imba_faceless_void_time_walk:IsStealable() 			return true  end
function imba_faceless_void_time_walk:IsNetherWardStealable() 	return true end
function imba_faceless_void_time_walk:GetCastPoint()
	if IsServer() then 
		if self:GetCaster():HasModifier("modifier_imba_time_walk_reverse_counter") then   
			return 0
		end
		return self.BaseClass.GetCastPoint(self)
	end
end
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
function imba_faceless_void_time_walk:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_time_walk_reverse_counter") then  
		return  "faceless_void_time_walk_reverse"	
	end	
	return "faceless_void/jewelofaeons/faceless_void_time_walk_1" 
end
function imba_faceless_void_time_walk:OnSpellStart()
	if not IsServer() then return end
	local caster       = self:GetCaster()
	local original_pos = caster:GetAbsOrigin()
	local pos          = self:GetCursorPosition()
	--local direction  = (pos - caster:GetAbsOrigin()):Normalized()  pfx maybe casuse bug 
	local direction    = (pos ~= original_pos and (pos - original_pos):Normalized()) or caster:GetForwardVector()
	direction.z = 0
	local max_distance = self:GetSpecialValueFor("range") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_faceless_void_3") + caster:GetCastRangeBonus()
	if self:GetCaster():Has_Aghanims_Shard() then 
		max_distance = max_distance + self:GetSpecialValueFor("range_shard")
	end
	local distance        = math.min(max_distance, (caster:GetAbsOrigin() - pos):Length2D())
	local tralve_duration = distance / self:GetSpecialValueFor("speed")
	local sound_name      = "Hero_FacelessVoid.TimeWalk.Aeons"
	--if HeroItems:UnitHasItem(caster, "jewel_of_aeons") then
	--sound_name = "Hero_FacelessVoid.TimeWalk.Aeons"
	--end
	--Shard Abi Cast 
	if caster:HasModifier("modifier_imba_time_walk_reverse_counter") then
		local shard_handler   = caster:FindModifierByName("modifier_imba_time_walk_reverse_counter")
		local shard_pos       = StringToVector(shard_handler.original_pos) or caster:GetAbsOrigin() --original_pos
		local shard_distance  = math.min(max_distance, (caster:GetAbsOrigin() - shard_pos):Length2D())
		local shard_direction = (caster:GetAbsOrigin() ~= shard_pos and (shard_pos - caster:GetAbsOrigin()):Normalized()) or (-1) * caster:GetForwardVector()
		local shard_tralve_duration = shard_distance / self:GetSpecialValueFor("speed")
		shard_direction.z     = 0
		caster:AddNewModifier(caster, self, "modifier_imba_faceless_void_time_walk_motion", {duration = shard_tralve_duration, direction = shard_direction , distance = shard_distance , bShard = true})
		caster:EmitSound(sound_name)
		--Start True CD
		caster:RemoveModifierByName("modifier_imba_time_walk_reverse_counter")
	else
		caster:AddNewModifier(caster, self, "modifier_imba_faceless_void_time_walk_motion", {duration = tralve_duration, direction = direction , distance = distance})
		local buffs = caster:FindAllModifiersByName("modifier_imba_time_walk_damage_counter")
		local heal  = 0 
		for _, buff in pairs(buffs) do
			heal = heal + buff:GetStackCount() / 10
		end
		caster:EmitSound(sound_name)
		caster:Heal(heal, caster)
		--Shard Abi 
		if caster:Has_Aghanims_Shard() then 
			caster:AddNewModifier(caster, self, "modifier_imba_time_walk_reverse_counter", {duration = 1.5, original_pos = original_pos})
		    --local shard_abi=caster:FindAbilityByName("imba_faceless_void_time_walk_reverse")
		    --[[if shard_abi~=nil then 
		    	shard_abi:SetLevel(self:GetLevel()) 
		    	caster:SwapAbilities( "imba_faceless_void_time_walk", "imba_faceless_void_time_walk_reverse", false, true )
		    	--1.5s 
		    	caster:AddNewModifier(caster, self, "modifier_imba_time_walk_reverse_counter", {duration = 1.5 + tralve_duration, original_pos = original_pos})
		    	--
		    	self:EndCooldown()
				self:StartCooldown(0.1)
		    end]] 
		    self:EndCooldown()
			self:StartCooldown(0.2)
	    end
	 end
end

--------------------------------------------------------------
--		  MODIFIER_IMBA_FACELESS_VOID_TIME_WALK_MOTION      --
--------------------------------------------------------------
modifier_imba_faceless_void_time_walk_motion = class({})
function modifier_imba_faceless_void_time_walk_motion:IsDebuff()			return false end
function modifier_imba_faceless_void_time_walk_motion:IsHidden() 			return true end
function modifier_imba_faceless_void_time_walk_motion:IsPurgable() 			return false end
function modifier_imba_faceless_void_time_walk_motion:IsPurgeException() 	return false end
function modifier_imba_faceless_void_time_walk_motion:GetEffectName() return "particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_jewel.vpcf" end
function modifier_imba_faceless_void_time_walk_motion:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_faceless_void_time_walk_motion:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_STUNNED] = true} end
function modifier_imba_faceless_void_time_walk_motion:IsMotionController() return true end
function modifier_imba_faceless_void_time_walk_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_imba_faceless_void_time_walk_motion:OnCreated(keys)
	if not IsServer() then return end
	self.ability          = self:GetAbility()
	self.caster           = self.ability:GetCaster()
	self.parent           = self:GetParent()
	--kv
	self.direction        = StringToVector(keys.direction)
	self.speed            = self.ability:GetSpecialValueFor("speed")
	self.walk_pos         = self.caster:GetAbsOrigin() + self.direction * keys.distance
	self.debuff_duration  = self.ability:GetSpecialValueFor("duration")
	self.bShard           = keys.bShard
	self.effected_enemies = {}
	--speed
	--self.walk_pos	= GetGroundPosition(Vector(self.direction.x, self.direction.y, 0), nil)
	
	--start Horizontal motion controller
	if self:ApplyHorizontalMotionController() == false then
		self:Destroy()
	end
end

function modifier_imba_faceless_void_time_walk_motion:OnRefresh()
	self:OnCreated(keys)
end

function modifier_imba_faceless_void_time_walk_motion:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end
	--Horizontal
	me:SetOrigin( me:GetAbsOrigin() + self.direction * self.speed * dt )
	--record effected enemies
	local enemy = FindUnitsInRadius(me:GetTeamNumber(), me:GetAbsOrigin(), nil, self.ability:GetSpecialValueFor("chrono_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i=1, #enemy do
		if not IsInTable(enemy[i], self.effected_enemies) then
			self.effected_enemies[#self.effected_enemies + 1] = enemy[i]
			enemy[i]:AddNewModifier(self.caster, self.ability, "modifier_imba_time_walk_slow", {duration = self.debuff_duration})
			enemy[i]:AddNewModifier_RS(self.caster, self.ability, "modifier_stunned", {duration = 0.1})
		end
	end
end

function modifier_imba_faceless_void_time_walk_motion:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_imba_faceless_void_time_walk_motion:OnDestroy()
	if not IsServer() then return end
	--over motion
	self.parent:RemoveHorizontalMotionController( self )
	--position reset
	self.parent:SetAbsOrigin(self.walk_pos)
	--ResolveNPCPositions(self.walk_pos, 128) --maybe cause bug
	FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
	--buff
	local radius_scepter = self.ability:GetSpecialValueFor("radius_scepter")
	self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_time_walk_buff", {duration = self.debuff_duration + TableLength(self.effected_enemies)})
	--05-09 Scepter by MysteryBug
	if self.caster:HasScepter() and self.ability:GetName() == "imba_faceless_void_time_walk" and not self.bShard then 
		local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, radius_scepter, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		CreateChronosphere(self.parent, self.ability, self.caster:GetAbsOrigin(), radius_scepter, 1, 2)
		for _, enemy in pairs(enemies) do
			self.parent:PerformAttack(enemy, false, true, true, true, false, false, false)
		end
	end
	--Shard Abi
	if self.bShard then 
		self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_time_walk_reverse_counter", {duration = 1.5, original_pos = self.parent:GetAbsOrigin(),bShard = true})
	end
end

--------------------------------------------------------------
modifier_imba_time_walk_slow = class({})

function modifier_imba_time_walk_slow:IsDebuff()				return true end
function modifier_imba_time_walk_slow:IsHidden() 				return false end
function modifier_imba_time_walk_slow:IsPurgable() 				return true end
function modifier_imba_time_walk_slow:IsPurgeException() 		return true end
function modifier_imba_time_walk_slow:GetEffectName()	return "particles/units/heroes/hero_faceless_void/faceless_void_time_walk_debuff.vpcf" end
function modifier_imba_time_walk_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_time_walk_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_time_walk_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self.move_bonus) end
function modifier_imba_time_walk_slow:GetModifierAttackSpeedBonus_Constant() return (0 - self.attack_speed_bonus) end
function modifier_imba_time_walk_slow:OnCreated() 
	self.move_bonus=self:GetAbility():GetSpecialValueFor("slow")
	self.attack_speed_bonus=self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
end

function modifier_imba_time_walk_slow:OnDestroy() 
	self.move_bonus=nil
	self.attack_speed_bonus=nil
end
--------------------------------------------------------------
modifier_imba_time_walk_buff = class({})

function modifier_imba_time_walk_buff:IsDebuff()				return false end
function modifier_imba_time_walk_buff:IsHidden() 				return false end
function modifier_imba_time_walk_buff:IsPurgable() 				return true end
function modifier_imba_time_walk_buff:IsPurgeException() 		return true end
function modifier_imba_time_walk_buff:GetEffectName()	return "particles/units/heroes/hero_faceless_void/faceless_void_time_walk.vpcf" end
function modifier_imba_time_walk_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_time_walk_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_time_walk_buff:GetModifierMoveSpeedBonus_Percentage() return self.move_bonus end
function modifier_imba_time_walk_buff:GetModifierAttackSpeedBonus_Constant() return self.attack_speed_bonus end
function modifier_imba_time_walk_buff:OnCreated() 
	self.move_bonus=self:GetAbility():GetSpecialValueFor("slow")
	self.attack_speed_bonus=self:GetAbility():GetSpecialValueFor("attack_speed_bonus")
end

function modifier_imba_time_walk_buff:OnDestroy() 
	self.move_bonus=nil
	self.attack_speed_bonus=nil
end

--------------------------------------------------------------
modifier_imba_time_walk_damage_counter = class({})

function modifier_imba_time_walk_damage_counter:IsDebuff()				return false end
function modifier_imba_time_walk_damage_counter:IsHidden() 				return true end
function modifier_imba_time_walk_damage_counter:IsPurgable() 			return false end
function modifier_imba_time_walk_damage_counter:IsPurgeException() 		return false end
function modifier_imba_time_walk_damage_counter:GetAttributes()			return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_time_walk_damage_counter:RemoveOnDeath() return false end

--------------------------------------------------------------
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
	local damage_time = self:GetAbility():GetSpecialValueFor("damage_time") + self:GetParent():TG_GetTalentValue("special_bonus_imba_faceless_void_7")
	local buff = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_time_walk_damage_counter", {duration = damage_time})
	if buff ~= nil then 
		buff:SetStackCount(keys.damage * 10)
	end
end

--------------------------------------------------------------
modifier_imba_time_walk_reverse_counter = class({})

function modifier_imba_time_walk_reverse_counter:IsDebuff()				return false end
function modifier_imba_time_walk_reverse_counter:IsHidden() 			return true end
function modifier_imba_time_walk_reverse_counter:IsPurgable() 			return false end
function modifier_imba_time_walk_reverse_counter:IsPurgeException() 	return false end
function modifier_imba_time_walk_reverse_counter:OnCreated(keys) 
	self.original_pos = keys.original_pos 
	self.bShard       = keys.bShard
end
function modifier_imba_time_walk_reverse_counter:OnDestroy(keys)
	self.original_pos = nil
	if IsServer() and not self.bShard then 
		self:GetAbility():EndCooldown()
		self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(-1) * self:GetCaster():GetCooldownReduction() - FrameTime())
	end
	--[[if IsServer() then
         self:GetParent():SwapAbilities( "imba_faceless_void_time_walk", "imba_faceless_void_time_walk_reverse", true, false )
    end]] 	
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
	local caster          = self:GetCaster()
	local shard_handler   = caster:FindModifierByName("modifier_imba_time_walk_reverse_counter")
	local pos             = StringToVector(shard_handler.original_pos) or caster:GetAbsOrigin() --original_pos
	local distance        = (caster:GetAbsOrigin() - pos):Length2D()
	local direction       = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z           = 0
	local tralve_duration = distance / self:GetSpecialValueFor("speed")
	local sound_name      = "Hero_FacelessVoid.TimeWalk.Aeons"
	caster:AddNewModifier(caster, self, "modifier_imba_faceless_void_time_walk_motion", {duration = tralve_duration, direction = direction , distance = distance})
	caster:EmitSound(sound_name)
end
