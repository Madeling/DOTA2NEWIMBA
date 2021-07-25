
CreateTalents("npc_dota_hero_broodmother", "linken/hero_broodmother.lua")

imba_broodmother_spider_strikes = class({})

LinkLuaModifier("modifier_imba_spider_strikes", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spider_strikes_caster", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spider_strikes_motion", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_spider_strikes_immune", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
function imba_broodmother_spider_strikes:IsHiddenWhenStolen() 		return false end
function imba_broodmother_spider_strikes:IsRefreshable() 			return true end
function imba_broodmother_spider_strikes:IsStealable() 				return true end
function imba_broodmother_spider_strikes:CastFilterResultTarget(target)
	if IsServer() then
		return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
	end
end
function imba_broodmother_spider_strikes:GetCastRange(pos, target)
	if not self.range_global then
		self.range_global = 0
	end
	if IsClient() then
		return self.BaseClass.GetCastRange(self, pos, target)
	else
		return self.BaseClass.GetCastRange(self, pos, target) + self.range_global
	end
end
function imba_broodmother_spider_strikes:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	self:SpecialEvent( caster, target )
	if target:IsCreep() and not target:IsBoss() then
		self:EndCooldown()
	end	
end
function imba_broodmother_spider_strikes:SpecialEvent( caster, target )
	if (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length() > self:GetSpecialValueFor("cast_range") + caster:GetCastRangeBonus() + 700 then
		local webs = Entities:FindAllByClassnameWithin("npc_dota_broodmother_web", target:GetAbsOrigin(), caster:FindAbilityByName("imba_broodmother_spin_web"):GetSpecialValueFor("radius"))
		for _, web in pairs(webs) do
			web:EmitSound("Imba.spiderstrikes")
			Timers:CreateTimer(self:GetSpecialValueFor("delay"), function()
				FindClearSpaceForUnit(self:GetCaster(), web:GetAbsOrigin(), true)
				caster:AddNewModifier(caster, self, "modifier_imba_spider_strikes_motion", {duration = self:GetSpecialValueFor("strike_duration"), target = target:entindex()})
				return nil						
			end)
			local pfx = ParticleManager:CreateParticle("particles/heros/broodmother/shovel_revealed_spiders.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, web:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, web:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)									
			break
		end
	else
		caster:AddNewModifier(caster, self, "modifier_imba_spider_strikes_motion", {duration = self:GetSpecialValueFor("strike_duration"), target = target:entindex()})	
	end		
end


modifier_imba_spider_strikes_motion = class({})

function modifier_imba_spider_strikes_motion:IsDebuff()			return false end
function modifier_imba_spider_strikes_motion:IsHidden() 		return true end
function modifier_imba_spider_strikes_motion:IsPurgable() 		return false end
function modifier_imba_spider_strikes_motion:IsPurgeException() return false end
function modifier_imba_spider_strikes_motion:CheckState() 
	if self:GetCaster():HasScepter() then
		return {
			[MODIFIER_STATE_MAGIC_IMMUNE] = true, 
			[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = self.caster:TG_HasTalent("special_bonus_imba_broodmother_2")
			}
	end	 
end
function modifier_imba_spider_strikes_motion:DeclareFunctions() return {MODIFIER_PROPERTY_MODEL_SCALE} end
function modifier_imba_spider_strikes_motion:GetModifierModelScale() return self.parent:HasScepter() and (0 - self.model_scale_scepter) or 0 end
function modifier_imba_spider_strikes_motion:IsMotionController() return true end
function modifier_imba_spider_strikes_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_spider_strikes_motion:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
	self.model_scale_scepter = self.ability:GetSpecialValueFor("model_scale_scepter")
	self.duration = self.ability:GetSpecialValueFor("duration") + self.caster:TG_GetTalentValue("special_bonus_imba_broodmother_7")
	self.web_duration_bonus = self.ability:GetSpecialValueFor("web_duration_bonus")
	if IsServer() then
		self.caster:EmitSound("Hero_Broodmother.SpawnSpiderlingsCast")
		if self:CheckMotionControllers() then
			self:GetAbility():SetActivated(false)
			self.target = EntIndexToHScript(keys.target)
			self:StartIntervalThink(FrameTime())
		end
	end
end

function modifier_imba_spider_strikes_motion:OnIntervalThink()
	if not self.target:IsAlive() or self.parent:IsStunned() or self.parent:IsHexed() or self:GetRemainingTime() < 0 then
 		self:StartIntervalThink(-1)
 		self:Destroy()
  		return
	end
	local dir = self.target:GetForwardVector()
	dir.z = 0
	local pos = self.target:GetAttachmentOrigin(self.target:ScriptLookupAttachment("attach_hitloc")) - dir * (100 * self.target:GetModelScale())
	local direction = (pos - self.parent:GetAbsOrigin()):Normalized()
	direction.z = 0
	local length = (self.parent:GetAbsOrigin() - pos):Length2D()
	if length > 0 and self:GetRemainingTime() > 0 then
		length = length / (self:GetRemainingTime() / FrameTime())
		local next_pos = GetGroundPosition(self.parent:GetAbsOrigin(), nil)
		next_pos = next_pos + direction * length
		local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
		local height = 300
		next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
		self.parent:SetAbsOrigin(next_pos)
		self.parent:SetForwardVector(direction)
	end
end

function modifier_imba_spider_strikes_motion:OnDestroy()
	if IsServer() then
		self:GetAbility():SetActivated(true)
		if self:GetElapsedTime() >= self:GetDuration() then
			local direction = self.target:GetForwardVector()
			direction.z = 0
			local pos = self.target:GetAttachmentOrigin(self.target:ScriptLookupAttachment("attach_hitloc")) - direction * (100 * self.target:GetModelScale())
			FindClearSpaceForUnit(self.parent, pos, true)
			if self.target:IsAlive() and not self.target:IsInvulnerable() then
				self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_imba_spider_strikes_caster", {duration = self.duration, target = self.target:entindex()})
				if self.parent:HasScepter() then
					self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_imba_spider_strikes_immune", {duration = self.duration})
				end				
				self.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_imba_spider_strikes", {duration = self.duration})
				if self.target:HasModifier("modifier_imba_spin_web_debuff") and self.target:GetModifierStackCount("modifier_imba_spin_web_debuff", nil) ~= -1 then
					local buff = self.target:FindModifierByName("modifier_imba_spin_web_debuff")
					buff:SetStackCount(buff:GetStackCount() + self.web_duration_bonus * 10)
				end

			end
		else
			FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
		end
	end
	self.target = nil
end
modifier_imba_spider_strikes_immune = class({})

function modifier_imba_spider_strikes_immune:IsDebuff()			return false end
function modifier_imba_spider_strikes_immune:IsHidden() 			return true end
function modifier_imba_spider_strikes_immune:IsPurgable() 		return false end
function modifier_imba_spider_strikes_immune:IsPurgeException() 	return false end
function modifier_imba_spider_strikes_immune:CheckState() 
	return {
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			--[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true, 
			} 
			end
function modifier_imba_spider_strikes_immune:GetModifierModelScale() return self:GetParent():HasScepter() and (0 - self:GetAbility():GetSpecialValueFor("model_scale_scepter")) or 0 end
function modifier_imba_spider_strikes_immune:DeclareFunctions() return {MODIFIER_PROPERTY_MODEL_SCALE} end
function modifier_imba_spider_strikes_immune:OnCreated()
	if IsServer() then
	   	self.pfx = ParticleManager:CreateParticle("particles/econ/items/lifestealer/lifestealer_immortal_backbone/lifestealer_immortal_backbone_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	    ParticleManager:SetParticleControlEnt(self.pfx, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	    ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	    self:AddParticle(self.pfx, false, false, -1, true, false)	
	end    
end
function modifier_imba_spider_strikes_immune:OnDestroy()
	if IsServer() then 
		if self.pfx then
	    	ParticleManager:DestroyParticle(self.pfx, false)
	    	ParticleManager:ReleaseParticleIndex(self.pfx)
	    end		    		
	end
end	



modifier_imba_spider_strikes_caster = class({})

function modifier_imba_spider_strikes_caster:IsDebuff()			return false end
function modifier_imba_spider_strikes_caster:IsHidden() 		return false end
function modifier_imba_spider_strikes_caster:IsPurgable() 		return false end
function modifier_imba_spider_strikes_caster:IsPurgeException() return false end
function modifier_imba_spider_strikes_caster:AllowIllusionDuplicate() return false end
function modifier_imba_spider_strikes_caster:CheckState() 
	return {
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true, 
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, 
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = self.caster:TG_HasTalent("special_bonus_imba_broodmother_2"),
		} 
end
function modifier_imba_spider_strikes_caster:DeclareFunctions() 
	return {
		MODIFIER_EVENT_ON_ORDER, 
		MODIFIER_EVENT_ON_ATTACK_LANDED, 
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
		MODIFIER_PROPERTY_MODEL_SCALE
		} 
end
function modifier_imba_spider_strikes_caster:GetModifierAttackSpeedBonus_Constant() 
	return self.as_bonus 
end
function modifier_imba_spider_strikes_caster:GetModifierModelScale() 
	return self.parent:HasScepter() and (0 - self.model_scale_scepter) or 0 
end

function modifier_imba_spider_strikes_caster:OnOrder(keys)
	if IsServer() and keys.unit == self.parent then
		if keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION or keys.order_type == DOTA_UNIT_ORDER_STOP then
			self.creep = false
			if self.target then
				TG_Remove_Modifier(self.target,"modifier_imba_spider_strikes",0)
			end	
			self:Destroy()
		end
	end
end

function modifier_imba_spider_strikes_caster:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self.parent or not keys.target:IsAlive() or keys.target:IsOther() or keys.target:IsBuilding() then
		return
	end
	keys.target:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = self.stun_duration})
end

function modifier_imba_spider_strikes_caster:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.immune_duration = self.ability:GetSpecialValueFor("immune_duration")
	self.strike_duration = self.ability:GetSpecialValueFor("strike_duration")
	self.cast_range = self.ability:GetSpecialValueFor("cast_range")
	self.model_scale_scepter = self.ability:GetSpecialValueFor("model_scale_scepter")
	self.stun_duration = self.ability:GetSpecialValueFor("stun_duration")
	self.as_bonus = self.ability:GetSpecialValueFor("as_bonus") + self.caster:TG_GetTalentValue("special_bonus_imba_broodmother_4")
	if IsServer() then		
		self.creep = true
		self.target = EntIndexToHScript(keys.target)		
		self.ability:SetActivated(false)	
	end
end

function modifier_imba_spider_strikes_caster:OnDestroy()
	if IsServer() then
		self.ability:SetActivated(true)
		if self.creep and not self.target:IsHero() then
			local creeps = FindUnitsInRadius(
				self.parent:GetTeamNumber(), 
				self.parent:GetAbsOrigin(), 
				nil, 
				self.cast_range, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_BASIC, 
				DOTA_UNIT_TARGET_FLAG_NONE, 
				FIND_ANY_ORDER, 
				false
				)
			if #creeps ~= 0 then
				for i=1, #creeps do
					if not creeps[i]:IsBoss() then
						self.parent:AddNewModifier(self.parent, self.ability, "modifier_imba_spider_strikes_motion", {duration = self.strike_duration, target = creeps[i]:entindex()})
						return
					end		
				end
			else
			self.creep = false	
			end
		end	 
		local immune_modifier = self.caster:FindModifierByName("modifier_imba_spider_strikes_immune")
		if immune_modifier then
			immune_modifier:SetDuration(self.immune_duration, true)
		end	
	end
end

modifier_imba_spider_strikes = class({})

function modifier_imba_spider_strikes:IsDebuff()			return true end
function modifier_imba_spider_strikes:IsHidden() 			return false end
function modifier_imba_spider_strikes:IsPurgable() 			return true end
function modifier_imba_spider_strikes:IsPurgeException() 	return true end

function modifier_imba_spider_strikes:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.duration = self.ability:GetSpecialValueFor("duration") + self.caster:TG_GetTalentValue("special_bonus_imba_broodmother_7")


	if IsServer() then
		self:StartIntervalThink(FrameTime())
		self.caster:PerformAttack(self.parent, false, true, true, false, true, false, false)
		--if self.caster:TG_HasTalent("special_bonus_imba_broodmother_2") then
			--self.parent:AddNewModifier(self.caster, self.ability, "modifier_confuse", {duration = self.duration})
		--end	
	end
end

function modifier_imba_spider_strikes:OnIntervalThink()
	self.caster:MoveToTargetToAttack(self.parent)
	self.caster:SetAttacking(self.parent)
	self.caster:SetForceAttackTarget(self.parent)
	Timers:CreateTimer(FrameTime(), function()
			self.caster:SetForceAttackTarget(nil)
			return nil
		end
	)
	if not self.parent:IsAlive() or not self.caster:IsAlive() or self.parent:IsInvulnerable() then
		self:Destroy()
		return
	end
	local pos = self.parent:GetAttachmentOrigin(self.parent:ScriptLookupAttachment("attach_hitloc")) - self.parent:GetForwardVector() * (100 * self.parent:GetModelScale())
	local direction = self.parent:GetForwardVector()
	direction.z = 0
	self.caster:SetOrigin(pos)
	self.caster:SetForwardVector(direction)
end

function modifier_imba_spider_strikes:OnDestroy()
	if IsServer() then
		local direction = self.parent:GetForwardVector():Normalized()
		direction.z = 0
		self.caster:SetForwardVector(direction)
		TG_Remove_Modifier(self.caster,"modifier_imba_spider_strikes_caster",0)
		--TG_Remove_Modifier(self.parent,"modifier_confuse",0)
	end
end

imba_broodmother_spin_web = class({})

LinkLuaModifier("modifier_imba_spin_web_caster_aura", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spin_web_buff", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spin_web_enemy_aura", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spin_web_debuff", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spin_web_scepter", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)  

function imba_broodmother_spin_web:IsHiddenWhenStolen() 	return false end
function imba_broodmother_spin_web:IsRefreshable() 			return true end
function imba_broodmother_spin_web:IsStealable() 			return true end
function imba_broodmother_spin_web:GetAOERadius() return self:GetSpecialValueFor("radius") end
function imba_broodmother_spin_web:GetCooldown(iLevel) return self:GetSpecialValueFor("charge_restore_time") end
function imba_broodmother_spin_web:OnUpgrade() 
	AbilityChargeController:AbilityChargeInitialize(self, self:GetSpecialValueFor("charge_restore_time"), self:GetSpecialValueFor("max_charges"), 1, true, true) 
end
function imba_broodmother_spin_web:GetIntrinsicModifierName() return "modifier_imba_spin_web_scepter" end

function imba_broodmother_spin_web:GetCastRange(pos, target)
	if not self.range then
		self.range = 0
	end
	if IsClient() then
		return self.BaseClass.GetCastRange(self, pos, target)
	else
		return self.BaseClass.GetCastRange(self, pos, target) + self.range
	end
end

function imba_broodmother_spin_web:OnSpellStart()
	if not self.webs then
		self.webs = {}
	end
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local found = false
	local web = CreateUnitByName("npc_dota_broodmother_web", pos, true, caster, caster, caster:GetTeamNumber())
	web:FindAbilityByName("broodmother_spin_web_destroy"):SetLevel(1)
	web:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	web:AddNewModifier(caster, nil, "modifier_invulnerable", {})
	web:AddNewModifier(caster, nil, "modifier_magic_immune", {})
	web:AddNewModifier(caster, self, "modifier_imba_spin_web_enemy_aura", {})
	web:EmitSound("Hero_Broodmother.SpinWebCast")
	for i=1, self:GetSpecialValueFor("count") do
		if not self.webs[i] then
			self.webs[i] = web
			web:AddNewModifier(caster, self, "modifier_imba_spin_web_caster_aura", {}):SetStackCount(i)
			found = true
			break
		end
	end
	if not found then
		local eldest = 0
		local time = 100000000
		for i=1, self:GetSpecialValueFor("count") do
			if self.webs[i] and self.webs[i]:GetCreationTime() < time then
				eldest = i
				time = self.webs[i]:GetCreationTime()
			end
		end
		self.webs[eldest]:FindAbilityByName("broodmother_spin_web_destroy"):OnSpellStart()
		self.webs[eldest] = web
		web:AddNewModifier(caster, self, "modifier_imba_spin_web_caster_aura", {}):SetStackCount(eldest)
	end
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_broodmother/broodmother_spin_web_cast.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, pos)
	ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetSpecialValueFor("radius"), 0, 0))
	ParticleManager:ReleaseParticleIndex(pfx)
end

modifier_imba_spin_web_scepter = class({})

function modifier_imba_spin_web_scepter:IsDebuff()			return false end
function modifier_imba_spin_web_scepter:IsHidden() 			return true end
function modifier_imba_spin_web_scepter:IsPurgable() 		return false end
function modifier_imba_spin_web_scepter:IsPurgeException() 	return false end

function modifier_imba_spin_web_scepter:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_spin_web_scepter:OnIntervalThink()
	if self:GetParent():HasScepter() then
		AbilityChargeController:ChangeChargeAbilityConfig(self:GetAbility(), nil, self:GetAbility():GetSpecialValueFor("max_charges_scepter"), nil, nil, nil)
	else
		AbilityChargeController:ChangeChargeAbilityConfig(self:GetAbility(), nil, self:GetAbility():GetSpecialValueFor("max_charges"), nil, nil, nil)
	end
end

modifier_imba_spin_web_caster_aura = class({})

function modifier_imba_spin_web_caster_aura:IsDebuff()			return false end
function modifier_imba_spin_web_caster_aura:IsHidden() 			return true end
function modifier_imba_spin_web_caster_aura:IsPurgable() 		return false end
function modifier_imba_spin_web_caster_aura:IsPurgeException() 	return false end

function modifier_imba_spin_web_caster_aura:OnDestroy()
	if IsServer() then
		self.ability.webs[self:GetStackCount()] = nil
	end
end

function modifier_imba_spin_web_caster_aura:IsAura() return true end
function modifier_imba_spin_web_caster_aura:GetAuraDuration() return 0.1 end
function modifier_imba_spin_web_caster_aura:GetModifierAura() return "modifier_imba_spin_web_buff" end
function modifier_imba_spin_web_caster_aura:GetAuraRadius() return self.radius end
function modifier_imba_spin_web_caster_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_spin_web_caster_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_spin_web_caster_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_imba_spin_web_caster_aura:GetAuraEntityReject(unit) return unit ~= self.caster end

function modifier_imba_spin_web_caster_aura:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_spin_web_caster_aura:OnIntervalThink()
	if self.caster:HasModifier("modifier_imba_insatiable_hunger") then
		local ability = self.caster:FindModifierByName("modifier_imba_insatiable_hunger"):GetAbility()
		if (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= (ability:GetSpecialValueFor("web_radius") + self.caster:TG_GetTalentValue("special_bonus_imba_broodmother_6")) then
			AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), self.radius, 0.2, false)
		end
	end
end

modifier_imba_spin_web_buff = class({})

function modifier_imba_spin_web_buff:IsDebuff()			return false end
function modifier_imba_spin_web_buff:IsHidden() 		return false end
function modifier_imba_spin_web_buff:IsPurgable() 		return false end
function modifier_imba_spin_web_buff:IsPurgeException() return false end
function modifier_imba_spin_web_buff:CheckState()
	if (0 - self:GetStackCount() / 10) >= self.fade_time then
		return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, [MODIFIER_STATE_INVISIBLE] = true}
	else
		return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
	end
end
function modifier_imba_spin_web_buff:DeclareFunctions() return {MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS, MODIFIER_PROPERTY_INVISIBILITY_LEVEL, MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_spin_web_buff:GetModifierInvisibilityLevel()
	if (0 - self:GetStackCount() / 10) >= self.fade_time then
		return 1
	else
		return 0
	end
end
function modifier_imba_spin_web_buff:GetModifierConstantHealthRegen() return self.heath_regen end
function modifier_imba_spin_web_buff:GetModifierMoveSpeedBonus_Percentage() return self.bonus_movespeed end
function modifier_imba_spin_web_buff:GetActivityTranslationModifiers() return "web" end

function modifier_imba_spin_web_buff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self.parent then
		self:SetStackCount(0)
	end
end

function modifier_imba_spin_web_buff:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.fade_time = self.ability:GetSpecialValueFor("fade_time")
	self.vision_radius = self.ability:GetSpecialValueFor("vision_radius")
	self.heath_regen = self.ability:GetSpecialValueFor("heath_regen")
	self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")	
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_spin_web_buff:OnIntervalThink()
	self:SetStackCount(math.max(self:GetStackCount() - 1, 0 - self.fade_time * 10))
	AddFOWViewer(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), self.vision_radius, 0.1, false)
end

function modifier_imba_spin_web_buff:OnDestroy()
	if IsServer() then
		GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), 200, false)
	end
end

modifier_imba_spin_web_enemy_aura = class({})

function modifier_imba_spin_web_enemy_aura:IsDebuff()			return false end
function modifier_imba_spin_web_enemy_aura:IsHidden() 			return true end
function modifier_imba_spin_web_enemy_aura:IsPurgable() 		return false end
function modifier_imba_spin_web_enemy_aura:IsPurgeException() 	return false end
function modifier_imba_spin_web_enemy_aura:IsAura() return true end
function modifier_imba_spin_web_enemy_aura:GetAuraDuration() return 0.1 end
function modifier_imba_spin_web_enemy_aura:GetModifierAura() return "modifier_imba_spin_web_debuff" end
function modifier_imba_spin_web_enemy_aura:GetAuraRadius() return self.radius end
function modifier_imba_spin_web_enemy_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_spin_web_enemy_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_spin_web_enemy_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_imba_spin_web_enemy_aura:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_spin_web_enemy_aura:OnIntervalThink()
	if not self:GetAbility() then
		local parent = self:GetParent()
		local ability = parent:FindAbilityByName("broodmother_spin_web_destroy")
		if ability then
			ability:OnSpellStart()
		end	
	end	
end

modifier_imba_spin_web_debuff = class({})

function modifier_imba_spin_web_debuff:IsDebuff()			return true end
function modifier_imba_spin_web_debuff:IsHidden() 			return false end
function modifier_imba_spin_web_debuff:IsPurgable() 		return false end
function modifier_imba_spin_web_debuff:IsPurgeException() 	return false end
function modifier_imba_spin_web_debuff:GetEffectName() return "particles/units/heroes/hero_broodmother/broodmother_incapacitatingbite_debuff.vpcf" end
function modifier_imba_spin_web_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_spin_web_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_spin_web_debuff:GetModifierMoveSpeedBonus_Percentage() return (0 - self.movespeed_slow) end
function modifier_imba_spin_web_debuff:CheckState()
	if self:GetStackCount() == -1 then
		return {[MODIFIER_STATE_ROOTED] = true}
	end
end

function modifier_imba_spin_web_debuff:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.root_delay = self.ability:GetSpecialValueFor("root_delay") + self.caster:TG_GetTalentValue("special_bonus_imba_broodmother_5")
	self.movespeed_slow = self.ability:GetSpecialValueFor("movespeed_slow")	+ self.caster:TG_GetTalentValue("special_bonus_imba_broodmother_3")
	self.root_duration = self.ability:GetSpecialValueFor("root_duration")
	self.radius = self.ability:GetSpecialValueFor("radius")
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_spin_web_debuff:OnIntervalThink()
	if self:GetStackCount() == -1 then
		self:Destroy()
		return
	end
	self:SetStackCount(self:GetStackCount() + 1)
	if self:GetStackCount() / 10 >= self.root_delay then
		self:SetStackCount(-1)
		self:StartIntervalThink(self.root_duration)
		if self:GetStackCount() == -1 then
			self:PlayEffects( radius, hashero )
		end	
		local webs = Entities:FindAllByClassnameWithin("npc_dota_broodmother_web", self.parent:GetAbsOrigin(), self.radius)
		for _, web in pairs(webs) do
			AddFOWViewer(self.caster:GetTeamNumber(), web:GetAbsOrigin(), self.radius, self.root_duration, false)
			return
		end
	end
end
function modifier_imba_spin_web_debuff:PlayEffects( radius, hashero )
	local pfx = ParticleManager:CreateParticle("particles/econ/items/broodmother/bm_lycosidaes/bm_lycosidaes_web_cast.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(pfx, 0, self.parent:GetAbsOrigin())
	self:AddParticle(pfx, false, false, 15, false, false)
end

broodmother_spin_web_destroy = class({})

function broodmother_spin_web_destroy:IsHiddenWhenStolen() 		return false end
function broodmother_spin_web_destroy:IsRefreshable() 			return false end
function broodmother_spin_web_destroy:IsStealable() 			return false end
function broodmother_spin_web_destroy:IsNetherWardStealable()	return false end
function broodmother_spin_web_destroy:OnSpellStart()
	local caster = self:GetCaster()
	for k, v in pairs(caster:FindAllModifiers()) do
		v:Destroy()
	end
	caster:ForceKill(false)
	Timers:CreateTimer(FrameTime(), function()
			if not caster:IsNull() then
				caster:RemoveSelf()
			end
			return nil
		end
	)
end

imba_broodmother_incapacitating_bite = class({})

LinkLuaModifier("modifier_imba_incapacitating_bite", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_incapacitating_bite_buff", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_incapacitating_bite_debuff", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)

function imba_broodmother_incapacitating_bite:GetIntrinsicModifierName() return "modifier_imba_incapacitating_bite" end

modifier_imba_incapacitating_bite = class({})

function modifier_imba_incapacitating_bite:IsDebuff()			return false end
function modifier_imba_incapacitating_bite:IsHidden() 			return true end
function modifier_imba_incapacitating_bite:IsPurgable() 		return false end
function modifier_imba_incapacitating_bite:IsPurgeException() 	return false end
function modifier_imba_incapacitating_bite:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_START, MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_imba_incapacitating_bite:OnAttackStart(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() or keys.target:IsOther() or keys.target:IsBuilding() or self:GetParent():IsIllusion() then
		return
	end
	local caster = self:GetCaster()
	local target = keys.target
	local ability = self:GetAbility()
	if target:IsRooted() then
		caster:AddNewModifier(caster, ability, "modifier_imba_incapacitating_bite_buff", {})
	else
		caster:RemoveModifierByName("modifier_imba_incapacitating_bite_buff")
	end
end

function modifier_imba_incapacitating_bite:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or not keys.target:IsAlive() or keys.target:IsOther() or keys.target:IsBuilding() or self:GetParent():IsIllusion() or keys.target:IsMagicImmune() or self:GetParent():PassivesDisabled() then
		return
	end
	local caster = self:GetCaster()
	local target = keys.target
	local ability = self:GetAbility()
	if target:HasModifier("modifier_imba_spin_web_debuff") and target:GetModifierStackCount("modifier_imba_spin_web_debuff", nil) ~= -1 then
		local buff = target:FindModifierByName("modifier_imba_spin_web_debuff")
		local duration = caster:HasModifier("modifier_imba_insatiable_hunger") and (self:GetAbility():GetSpecialValueFor("web_duration_bonus") + 1.0) * 10 or self:GetAbility():GetSpecialValueFor("web_duration_bonus") * 10
		buff:SetStackCount(buff:GetStackCount() + duration)
	end
	target:AddNewModifier(caster, ability, "modifier_imba_incapacitating_bite_debuff", {duration = ability:GetSpecialValueFor("duration")})
end

modifier_imba_incapacitating_bite_buff = class({})

function modifier_imba_incapacitating_bite_buff:IsDebuff()			return false end
function modifier_imba_incapacitating_bite_buff:IsHidden() 			return false end
function modifier_imba_incapacitating_bite_buff:IsPurgable() 		return false end
function modifier_imba_incapacitating_bite_buff:IsPurgeException() 	return false end
function modifier_imba_incapacitating_bite_buff:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_incapacitating_bite_buff:GetModifierAttackSpeedBonus_Constant() return self.rooted_as_bonus end
function modifier_imba_incapacitating_bite_buff:GetStatusEffectName() return "particles/status_fx/status_effect_life_stealer_rage.vpcf" end
function modifier_imba_incapacitating_bite_buff:StatusEffectPriority() return 15 end

function modifier_imba_incapacitating_bite_buff:OnCreated()
	self.rooted_as_bonus = self:GetAbility():GetSpecialValueFor("rooted_as_bonus") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_broodmother_8")
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_incapacitating_bite_buff:OnIntervalThink()
	if not self:GetParent():IsAttacking() then
		self:Destroy()
	end
end

modifier_imba_incapacitating_bite_debuff = class({})

function modifier_imba_incapacitating_bite_debuff:IsDebuff()			return true end
function modifier_imba_incapacitating_bite_debuff:IsHidden() 			return false end
function modifier_imba_incapacitating_bite_debuff:IsPurgable() 			return true end
function modifier_imba_incapacitating_bite_debuff:IsPurgeException() 	return true end
function modifier_imba_incapacitating_bite_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_MISS_PERCENTAGE} end
function modifier_imba_incapacitating_bite_debuff:GetModifierMoveSpeedBonus_Percentage() return (0 - self.movespeed_slow) end
function modifier_imba_incapacitating_bite_debuff:GetModifierMiss_Percentage() return self.miss_chance end

function modifier_imba_incapacitating_bite_debuff:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.movespeed_slow = self.ability:GetSpecialValueFor("movespeed_slow")
	self.damage_per_second = self.ability:GetSpecialValueFor("damage_per_second")
	self.miss_chance = self.ability:GetSpecialValueFor("miss_chance")
	if IsServer() then
		self.damage_type = self.ability:GetAbilityDamageType()
		local pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_broodmother/broodmother_spiderlings_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_broodmother/broodmother_poison_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		self:AddParticle(pfx1, false, false, 15, false, false)
		self:AddParticle(pfx2, false, false, 15, false, false)
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_incapacitating_bite_debuff:OnIntervalThink()
	local dmg = ApplyDamage(
		{
			victim = self.parent, 
			attacker = self.caster, 
			ability = self.ability, 
			damage = self.damage_per_second, 
			damage_type = self.damage_type
		}
		)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self.parent, dmg, nil)
end

imba_broodmother_insatiable_hunger = class({})

LinkLuaModifier("modifier_imba_insatiable_hunger", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_insatiable_hunger_truesight", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)

function imba_broodmother_insatiable_hunger:IsHiddenWhenStolen() 	return false end
function imba_broodmother_insatiable_hunger:IsRefreshable() 		return true end
function imba_broodmother_insatiable_hunger:IsStealable() 			return true end
function imba_broodmother_insatiable_hunger:IsNetherWardStealable()	return true end

function imba_broodmother_insatiable_hunger:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_imba_insatiable_hunger", {duration = self:GetSpecialValueFor("duration")})
end

modifier_imba_insatiable_hunger = class({})

function modifier_imba_insatiable_hunger:IsDebuff()			return false end
function modifier_imba_insatiable_hunger:IsHidden() 		return false end
function modifier_imba_insatiable_hunger:IsPurgable() 		return false end
function modifier_imba_insatiable_hunger:IsPurgeException() return false end
function modifier_imba_insatiable_hunger:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_EVENT_ON_HERO_KILLED} end
function modifier_imba_insatiable_hunger:GetModifierPreAttack_BonusDamage() return self.dmg end

function modifier_imba_insatiable_hunger:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()	
	self.dmg = self.ability:GetSpecialValueFor("bonus_damage") + self.caster:TG_GetTalentValue("special_bonus_imba_broodmother_1")
	self.lifesteal = self.ability:GetSpecialValueFor("lifesteal_pct") + self.caster:TG_GetTalentValue("special_bonus_imba_broodmother_1")
	self.strike_refresh_radius = self.ability:GetSpecialValueFor("strike_refresh_radius") + self.caster:TG_GetTalentValue("special_bonus_imba_broodmother_6")
	self.truesight_radius = self.ability:GetSpecialValueFor("truesight_radius") + self.caster:TG_GetTalentValue("special_bonus_imba_broodmother_6")
	if IsServer() then
		EmitSoundOn("Hero_Broodmother.InsatiableHunger", self.parent)
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_broodmother/broodmother_hunger_buff.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, self.parent, PATTACH_POINT_FOLLOW, (self.parent:IsHero() and "attach_thorax" or "attach_hitloc"), self.parent:GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end

function modifier_imba_insatiable_hunger:OnDestroy()
	StopSoundOn("Hero_Broodmother.InsatiableHunger", self.parent)
end

function modifier_imba_insatiable_hunger:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self.parent and (keys.target:IsHero() or keys.target:IsCreep() or keys.target:IsBoss()) then
		local lifesteal = self.lifesteal
		self.parent:Heal(lifesteal, self.ability)
	end
end

function modifier_imba_insatiable_hunger:OnHeroKilled(keys)
	if not IsServer() then
		return
	end
	if keys.target == self.parent then
		self:Destroy()
	end
	if keys.target:IsTrueHero() and (self.parent:GetAbsOrigin() - keys.target:GetAbsOrigin()):Length2D() <= self.strike_refresh_radius then
		if self.parent:HasAbility("imba_broodmother_spider_strikes") then
			self.parent:FindAbilityByName('imba_broodmother_spider_strikes'):EndCooldown()
		end
	end
end

function modifier_imba_insatiable_hunger:IsAura() return true end
function modifier_imba_insatiable_hunger:GetAuraDuration() return 0.1 end
function modifier_imba_insatiable_hunger:GetModifierAura() return "modifier_imba_insatiable_hunger_truesight" end
function modifier_imba_insatiable_hunger:GetAuraRadius() return self.truesight_radius end
function modifier_imba_insatiable_hunger:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_insatiable_hunger:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_insatiable_hunger:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end

modifier_imba_insatiable_hunger_truesight = class({})

function modifier_imba_insatiable_hunger_truesight:IsDebuff()			return true end
function modifier_imba_insatiable_hunger_truesight:IsHidden() 			return true end
function modifier_imba_insatiable_hunger_truesight:IsPurgable() 		return false end
function modifier_imba_insatiable_hunger_truesight:IsPurgeException() 	return false end
function modifier_imba_insatiable_hunger_truesight:CheckState() return {[MODIFIER_STATE_INVISIBLE] = false} end
function modifier_imba_insatiable_hunger_truesight:GetPriority() return MODIFIER_PRIORITY_HIGH end

imba_broodmother_silken_bola = class({})
LinkLuaModifier("modifier_imba_broodmother_silken_bola", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_silken_bola_shard", "linken/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)
function imba_broodmother_silken_bola:Set_InitialUpgrade(tg)       
    return {LV=1} 
end
function imba_broodmother_silken_bola:GetIntrinsicModifierName() return "modifier_imba_silken_bola_shard" end
function imba_broodmother_silken_bola:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local pfx_name = "particles/units/heroes/hero_broodmother/broodmother_silken_bola_projectile.vpcf"
	local speed = self:GetSpecialValueFor("projectile_speed")
	self.web_duration_bonus = self:GetSpecialValueFor("web_duration_bonus")
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = pfx_name,
		iMoveSpeed = speed,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
		ExtraData = {},
	}
	TG_CreateProjectile({id = 1, team = caster:GetTeamNumber() , owner = caster, p = info})				
end
function imba_broodmother_silken_bola:OnProjectileHit_ExtraData(target, pos, keys)
	if not target then 
		return
	end
	if target:TG_TriggerSpellAbsorb(self) then
		return
	end
	local caster = self:GetCaster()	
	if target:HasModifier("modifier_imba_spin_web_debuff") and target:GetModifierStackCount("modifier_imba_spin_web_debuff", nil) ~= -1 then
		local buff = target:FindModifierByName("modifier_imba_spin_web_debuff")
		buff:SetStackCount(buff:GetStackCount() + self.web_duration_bonus * 10)
	end	
	target:AddNewModifier(caster, self, "modifier_imba_broodmother_silken_bola", {duration = self:GetSpecialValueFor("duration")})
	target:AddNewModifier(caster, self, "modifier_confuse", {duration = self:GetSpecialValueFor("duration")})								
end
modifier_imba_broodmother_silken_bola = class({})

function modifier_imba_broodmother_silken_bola:IsDebuff()				return true end
function modifier_imba_broodmother_silken_bola:IsHidden() 				return false end
function modifier_imba_broodmother_silken_bola:IsPurgable() 			return true end
function modifier_imba_broodmother_silken_bola:IsPurgeException() 		return true end
function modifier_imba_broodmother_silken_bola:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_broodmother_silken_bola:GetModifierMoveSpeedBonus_Percentage() return (0 - self.movement_speed) end
function modifier_imba_broodmother_silken_bola:OnCreated()
	self.parent = self:GetParent()
	self.movement_speed = self:GetAbility():GetSpecialValueFor("movement_speed")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	if IsServer() then
	   	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_broodmother/broodmother_silken_bola_root.vpcf", PATTACH_ABSORIGIN, self.parent)
	    ParticleManager:SetParticleControl(self.pfx, 0, self.parent:GetAbsOrigin())
	    self:AddParticle(self.pfx, false, false, -1, true, false)	
	end    
end
function modifier_imba_broodmother_silken_bola:OnDestroy()
	if IsServer() then 
		if self.pfx then
	    	ParticleManager:DestroyParticle(self.pfx, false)
	    	ParticleManager:ReleaseParticleIndex(self.pfx)
	    end		    		
	end
end
modifier_imba_silken_bola_shard = class({})

function modifier_imba_silken_bola_shard:IsDebuff()			return false end
function modifier_imba_silken_bola_shard:IsHidden() 		return true end
function modifier_imba_silken_bola_shard:IsPurgable() 		return false end
function modifier_imba_silken_bola_shard:IsPurgeException() return false end
function modifier_imba_silken_bola_shard:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_silken_bola_shard:OnIntervalThink()
	self:GetAbility():SetHidden(not self:GetParent():Has_Aghanims_Shard())
	if self:GetParent():Has_Aghanims_Shard() then
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end	
end	