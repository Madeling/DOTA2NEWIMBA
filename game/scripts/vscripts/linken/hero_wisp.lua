CreateTalents("npc_dota_hero_wisp", "linken/hero_wisp.lua")
function IsFriendly(caster, target)
	if 	caster:GetTeamNumber()~=target:GetTeamNumber() then		
		return false	
	else
		return true
	end	
end
function StringToVector(sString)
	--Input: "123 123 123"
	local temp = {}
	for str in string.gmatch(sString, "%S+") do
		if tonumber(str) then
			temp[#temp + 1] = tonumber(str)
		else
			return nil
		end
	end
	return Vector(temp[1], temp[2], temp[3])
end
imba_wisp_tether = class({})
LinkLuaModifier("modifier_imba_wisp_tether_target", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_wisp_tether_latch", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_wisp_tether_slow", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_imba_wisp_tether_pass", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
function imba_wisp_tether:IsHiddenWhenStolen() 		return false end
function imba_wisp_tether:IsRefreshable() 			return true end
function imba_wisp_tether:IsStealable() 			return true end
--function imba_wisp_tether:GetIntrinsicModifierName() return "modifier_imba_wisp_tether_pass" end
function imba_wisp_tether:GetCastRange() return 1000 end
function imba_wisp_tether:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_wisp_1") then 
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_wisp_1"))
	end
	return cooldown
end
function imba_wisp_tether:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "dota_hud_error_cant_cast_on_self"
	elseif self:GetCaster():HasModifier("modifier_imba_wisp_tether_target") or target:HasModifier("modifier_imba_wisp_tether") or target:HasModifier("modifier_imba_wisp_tether_target") or self:GetCaster():HasModifier("modifier_imba_wisp_tether") then
		return "无法连接"
	end
end
function imba_wisp_tether:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		local casterID = caster:GetPlayerOwnerID()
		local targetID = target:GetPlayerOwnerID()

		if target == caster then
			return UF_FAIL_CUSTOM
		end

		if target:IsCourier() then
			return UF_FAIL_COURIER
		end

		if self:GetCaster():HasModifier("modifier_imba_wisp_tether_target") or target:HasModifier("modifier_imba_wisp_tether") or target:HasModifier("modifier_imba_wisp_tether_target") or self:GetCaster():HasModifier("modifier_imba_wisp_tether") then
			return UF_FAIL_CUSTOM
		end
		
		local nResult = UnitFilter(target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), caster:GetTeamNumber())
		return nResult
	end
end
function imba_wisp_tether:OnSpellStart()
	self.caster = self:GetCaster()
	self.target = self:GetCursorTarget()
	--if target:TG_TriggerSpellAbsorb(self) and not IsFriendly(self.target, self.caster) then return end
	local ability 				= self:GetCaster():FindAbilityByName("imba_wisp_tether")
	local latch_distance 		= self:GetSpecialValueFor("latch_distance")
	local destroy_tree_radius 	= ability:GetSpecialValueFor("destroy_tree_radius")
	--self.target更换施法者
	self.caster:AddNewModifier(self.target, self, "modifier_imba_wisp_tether_target", {})
	self.target:AddNewModifier(self.caster, self, "modifier_imba_wisp_tether", {})
	self.caster:SwapAbilities("imba_wisp_tether", "imba_wisp_tether_break", false, true)
	self.caster:FindAbilityByName("imba_wisp_tether_break"):SetLevel(1)
	self.caster:FindAbilityByName("imba_wisp_tether_break"):StartCooldown(0.25)	
	local distToAlly = (self:GetCursorTarget():GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()
	if distToAlly >= latch_distance then
		self.caster:AddNewModifier(self.caster, self, "modifier_imba_wisp_tether_latch", { destroy_tree_radius =  destroy_tree_radius})
	end	
end

modifier_imba_wisp_tether_target = class({})

function modifier_imba_wisp_tether_target:IsHidden() return false end
function modifier_imba_wisp_tether_target:IsPurgable() return false end 
function modifier_imba_wisp_tether_target:IsDebuff () return 
	false
end
function modifier_imba_wisp_tether_target:RemoveOnDeath() 		return true end
function modifier_imba_wisp_tether_target:OnCreated()
	if IsServer() then
		self.target = self:GetCaster()
		self.caster = self:GetParent()
		self.hitted = {}
		self.original_speed		= self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false)
		self.target_speed		= self.target:GetMoveSpeedModifier(self.target:GetBaseMoveSpeed(), true)
		self.difference			= self.target_speed - self.original_speed
		self.radius 			= self:GetAbility():GetSpecialValueFor("radius") + self.caster:TG_GetTalentValue("special_bonus_imba_wisp_8")
		self.tether_heal_amp 	= self:GetAbility():GetSpecialValueFor("tether_heal_amp")
		if not IsFriendly(self.target, self.caster) then
			Notifications:Bottom(PlayerResource:GetPlayer(self.target:GetPlayerOwnerID()), {text="累计眩晕艾欧3秒后自动解除连接", duration=3.5, style={color="#FF0000", ["font-size"]="40px"}})
			self.tether_heal_amp 	= self:GetAbility():GetSpecialValueFor("tether_heal_damage") + self.caster:TG_GetTalentValue("special_bonus_imba_wisp_7")
			--print(self.tether_heal_amp)
		end	
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self.total_gained_mana 		= 0
		self.total_gained_health 	= 0
		self.update_timer 			= 0
		self.stun_timer 			= 0
		self.time_to_send 			= 1

		EmitSoundOn("Hero_Wisp.Tether.Target", self.target)
		EmitSoundOn("Hero_Wisp.Tether", self:GetParent())

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_wisp_tether_target:OnIntervalThink()
	if not self:GetCaster():IsAlive() or not self:GetParent():IsAlive() then
		self:Destroy()
	end
	if not self.caster:HasModifier("modifier_imba_wisp_overcharge") then
		self.target:RemoveModifierByName("modifier_imba_wisp_overcharge")
	end	
	local ability = self.caster:FindAbilityByName("imba_wisp_overcharge")
	if not self.target:HasModifier("modifier_imba_wisp_overcharge") and self.caster:HasModifier("modifier_imba_wisp_overcharge") then
		self.target:AddNewModifier(self.caster, ability, "modifier_imba_wisp_overcharge", {})
	end			
	self.difference			= 0
	self.radius 			= self:GetAbility():GetSpecialValueFor("radius") + self.caster:TG_GetTalentValue("special_bonus_imba_wisp_8")

	self.original_speed		= self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false)
	self.target_speed		= self.target:GetMoveSpeedModifier(self.target:GetBaseMoveSpeed(), true)
	self.difference			= self.target_speed - self.original_speed		
	if IsServer() then
		self.update_timer = self.update_timer + FrameTime()
		if self:GetParent():IsStunned() and not IsFriendly(self:GetParent(),self:GetCaster()) then
			self.stun_timer = self.stun_timer + FrameTime()
		end
		if self.stun_timer >= 3 then
			self.stun_timer 			= 0
			self:Destroy()
		end	
		if self.update_timer > self.time_to_send then
			if IsFriendly(self:GetParent(),self:GetCaster()) then 
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.target, self.total_gained_health * self.tether_heal_amp, nil)	
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self.target, self.total_gained_mana * self.tether_heal_amp, nil)
			else	
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self.target, self.total_gained_health * self.tether_heal_amp, nil)	
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, self.target, self.total_gained_mana * self.tether_heal_amp, nil)
			end	
			self.total_gained_mana 		= 0
			self.total_gained_health 	= 0
			self.update_timer 			= 0
		end

			if (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() >= self.radius and not self:GetParent():HasModifier("modifier_imba_wisp_tether_latch") then
				--Timers:CreateTimer(0.15, function()
					self:Destroy()
				--end)	
			end			
		--end				
		local enemies = 
			FindUnitsInLine(self:GetParent():GetTeamNumber(), 
			self:GetCaster():GetAbsOrigin(), 
			self:GetParent():GetAbsOrigin(), 
			nil, 
			100, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
			)
		for _, enemy in pairs(enemies) do
			if enemy ~= self:GetCaster() then
				local hit = false
				for _, unit in pairs(self.hitted) do
					if enemy == unit then
						hit = true
						break
					end
				end
				if not hit then
					self.hitted[#self.hitted+1] = enemy
					EmitSoundOn("Hero_Wisp.Tether.Stun", enemy)
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self:GetAbility():GetSpecialValueFor("stun_duration") })
				end
				--if not enemy:HasModifier("modifier_imba_wisp_tether_slow") then 			
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_wisp_tether_slow", { duration = self:GetAbility():GetSpecialValueFor("stun_duration") })
				--end
			end	
		end					
	end
end
function modifier_imba_wisp_tether_target:OnRemoved() 
	if IsServer() then
		self.target:StopSound("Hero_Wisp.Tether.Target")
		if self.pfx then		
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex( self.pfx )
		end
		self:GetCaster():EmitSound("Hero_Wisp.Tether.Stop")
		self:GetParent():StopSound("Hero_Wisp.Tether")
		self:GetParent():FindAbilityByName("imba_wisp_tether").target = nil	
		if self.caster:HasModifier("modifier_imba_wisp_overcharge") then
			self.target:RemoveModifierByName("modifier_imba_wisp_overcharge")
		end
		self.target:RemoveModifierByName("modifier_imba_wisp_tether")
		if self.target:HasModifier("modifier_imba_wisp_element_territory_tethered") then
			self.target:RemoveModifierByName("modifier_imba_wisp_element_territory_tethered")
		end				
		--self:GetParent():SwapAbilities("imba_wisp_tether_break", "imba_wisp_tether", true, false)
		self:GetParent():SwapAbilities("imba_wisp_tether_break", "imba_wisp_tether", false, true)
	end
end

function modifier_imba_wisp_tether_target:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_EVENT_ON_MANA_GAINED,
		--MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT	
	}

	return decFuncs
end

function modifier_imba_wisp_tether_target:OnAttack(keys)
	if IsServer() then
		if keys.attacker == self:GetCaster() and self:GetParent():TG_HasTalent("special_bonus_imba_wisp_6") and IsFriendly(self:GetCaster(), self:GetParent()) then
			self:GetParent():PerformAttack(keys.target, true, true, true, false, true, false, false)
		end
	end
end
function modifier_imba_wisp_tether_target:OnHealReceived(keys)	
	if keys.unit == self:GetParent() then
		if IsFriendly(self:GetParent(),self:GetCaster()) then
			self.target:Heal(keys.gain * self.tether_heal_amp, self:GetAbility())
			--print(keys.gain)
			--if keys.gain > 100 then
			--	PrintTable(keys)
			--end
		else
			self.damage_table = {
				victim 			= self.target,
				damage 			= keys.gain * self.tether_heal_amp,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
				attacker 		= self:GetParent(),
				ability 		= self:GetAbility()
			}
			ApplyDamage(self.damage_table)
		end	
		self.total_gained_health = self.total_gained_health + keys.gain
		--self.a = self.a + (keys.gain * self.tether_heal_amp * 2)
		--self.b = self.a - (self.b + (keys.gain))
	end
end

function modifier_imba_wisp_tether_target:OnManaGained(keys)
	if keys.unit == self:GetParent() then
		if IsFriendly(self:GetParent(),self:GetCaster()) then
			self.target:GiveMana(keys.gain * self.tether_heal_amp)
		else
			self.target:ReduceMana(keys.gain * self.tether_heal_amp)
		end	
		self.total_gained_mana = self.total_gained_mana + keys.gain
	end
end
function modifier_imba_wisp_tether_target:GetModifierMoveSpeedOverride()
	if self.target and self.target.GetBaseMoveSpeed then
		--return self.target:GetBaseMoveSpeed()
	end
end
--[[function modifier_imba_wisp_tether_target:GetModifierMoveSpeed_Absolute()
	--if self.target and self.target.GetBaseMoveSpeed then
		return self.target:GetMoveSpeedModifier(self:GetCaster():GetBaseMoveSpeed(), true)
	--end
end]]

function modifier_imba_wisp_tether_target:GetModifierMoveSpeedBonus_Constant()
	if self.original_speed and self.target:GetMoveSpeedModifier(self.target:GetBaseMoveSpeed(), true) >= self.original_speed and self.difference and IsFriendly(self:GetParent(),self:GetCaster()) then
		return self.difference
	end
end

function modifier_imba_wisp_tether_target:GetModifierMoveSpeed_Limit()
	if IsFriendly(self:GetParent(),self:GetCaster()) then
		return self.target_speed
	end	
end

function modifier_imba_wisp_tether_target:GetModifierIgnoreMovespeedLimit()
	if IsFriendly(self:GetParent(),self:GetCaster()) then
		return 1
	end	
end	

modifier_imba_wisp_tether = class({})

function modifier_imba_wisp_tether:IsHidden() return false end
function modifier_imba_wisp_tether:IsPurgable() return false end
function modifier_imba_wisp_tether:IsDebuff () return not IsFriendly(self:GetParent(),self:GetCaster()) end
function modifier_imba_wisp_tether:RemoveOnDeath() 		return true end
function modifier_imba_wisp_tether:DeclareFunctions()
	local decFuncs = {		
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
	}

	return decFuncs
end
function modifier_imba_wisp_tether:OnCreated()
	self.att_add = self:GetAbility():GetSpecialValueFor("att_add")
	if IsServer() then	
		if IsFriendly(self:GetParent(),self:GetCaster()) and self:GetCaster():HasScepter() then
			self:GetParent():SetStolenScepter(true)
		end		
		self.original_speed		= self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), true)
		self.target_speed		= self:GetCaster():GetMoveSpeedModifier(self:GetCaster():GetBaseMoveSpeed(), true)
		self.difference			= self.target_speed - self.original_speed
		self:StartIntervalThink(0.1)
	end
end
function modifier_imba_wisp_tether:GetModifierCastRangeBonus(keys)
	if self:GetParent():HasScepter() then 
		return self.att_add
	end
	return 0	
end
function modifier_imba_wisp_tether:GetModifierAttackRangeBonus(keys)
	if self:GetParent():HasScepter() then 
		return self.att_add
	end
	return 0	
end
function modifier_imba_wisp_tether:OnIntervalThink()
		self.original_speed		= self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), true)
		self.target_speed		= self:GetCaster():GetMoveSpeedModifier(self:GetCaster():GetBaseMoveSpeed(), true)
		self.difference			= self.target_speed - self.original_speed
		--print(self.target_speed)
end
function modifier_imba_wisp_tether:GetModifierMoveSpeedOverride()
	if not IsFriendly(self:GetParent(),self:GetCaster()) then
		return self:GetCaster():GetBaseMoveSpeed()
	end	
end	
function modifier_imba_wisp_tether:GetModifierMoveSpeedBonus_Percentage()
	if IsFriendly(self:GetParent(),self:GetCaster()) then
		return self:GetAbility():GetSpecialValueFor("movespeed")
	else
		return 0-self:GetAbility():GetSpecialValueFor("movespeed")	
	end
end
function modifier_imba_wisp_tether:OnDestroy()
	if not IsServer() then return end
	self.boll = false
	if IsFriendly(self:GetParent(),self:GetCaster()) then
		self:GetParent():SetStolenScepter(false)
	end		
end
modifier_imba_wisp_tether_latch = class({})

function modifier_imba_wisp_tether_latch:IsHidden()	return true end
function modifier_imba_wisp_tether_latch:IsPurgable()	return false end
function modifier_imba_wisp_tether_latch:RemoveOnDeath() 		return true end
function modifier_imba_wisp_tether_latch:OnCreated(params)
	if IsServer() then
		self.target 				= self:GetAbility().target
		self.destroy_tree_radius 	= params.destroy_tree_radius
		-- "Pulls Io at a speed of 1000, until coming within 300 range of the target."
		self.final_latch_distance	= 300
		
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_wisp_tether_latch:OnIntervalThink()
	if IsServer() then
		--"The pull gets interrupted when Io gets stunned, hexed, hidden, feared, hypnotize, or rooted during the pull."
		-- self:GetParent():IsFeared() and self:GetParent():IsHypnotized() don't actually exist as Valve functions but they'll be placeholders for if it gets implemented one way or another
		if self:GetParent():IsStunned() or self:GetParent():IsHexed() or self:GetParent():IsOutOfGame() or (self:GetParent().IsFeared and self:GetParent():IsFeared()) or (self:GetParent().IsHypnotized and self:GetParent():IsHypnotized()) or self:GetParent():IsRooted() then
			self:StartIntervalThink(-1)
			self:Destroy()
			return
		end
		-- Calculate the distance
		local casterDir = self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin()
		local distToAlly = casterDir:Length2D()
		casterDir = casterDir:Normalized()
		
		if distToAlly > self.final_latch_distance then
			-- Leap to the target
			distToAlly = distToAlly - self:GetAbility():GetSpecialValueFor("latch_speed") * FrameTime()
			distToAlly = math.max( distToAlly, self.final_latch_distance )	-- Clamp this value

			local pos = self.target:GetAbsOrigin() + casterDir * distToAlly
			pos = GetGroundPosition(pos, self:GetCaster())

			self:GetCaster():SetAbsOrigin(pos)
		end

		
		if distToAlly <= self.final_latch_distance then
			-- We've reached, so finish latching
			GridNav:DestroyTreesAroundPoint(self:GetCaster():GetAbsOrigin(), self.destroy_tree_radius, false)
			ResolveNPCPositions(self:GetCaster():GetAbsOrigin(), 128)
			self:GetCaster():RemoveModifierByName("modifier_imba_wisp_tether_latch")
		end
		local target = self:GetCaster():FindAbilityByName("imba_wisp_tether").target
		if not target:HasModifier("modifier_imba_wisp_tether") or (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() >= 2000 then
			self:StartIntervalThink(-1)
			self:Destroy()
			return
		end	
	end
end

function modifier_imba_wisp_tether_latch:OnDestroy()
	if not IsServer() then return end
	
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
end
modifier_imba_wisp_tether_slow = class({})

function modifier_imba_wisp_tether_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}	
	return funcs
end

function modifier_imba_wisp_tether_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end
imba_wisp_tether_break = class({})
function imba_wisp_tether_break:IsStealable() return false end

function imba_wisp_tether_break:OnSpellStart()

	--self:GetCaster():SwapAbilities("imba_wisp_tether_break", "imba_wisp_tether", false, true)
	--self:GetCaster():SwapAbilities("imba_wisp_tether_break", "imba_wisp_tether", true, false)
	local target = self:GetCaster():FindAbilityByName("imba_wisp_tether").target
	if target ~= nil and self:GetCaster():HasModifier("modifier_imba_wisp_tether_target") then
		self:GetCaster():RemoveModifierByName("modifier_imba_wisp_tether_target")
		target:RemoveModifierByName("modifier_imba_wisp_tether")
	end
	if self:GetCaster():HasModifier("modifier_imba_wisp_tether_latch") then
		self:GetCaster():RemoveModifierByName("modifier_imba_wisp_tether")
	end	
end

imba_wisp_spirits = class({})
LinkLuaModifier("modifier_imba_spirits", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spirits_thinker", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_spirits_thinker_debuff", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
function imba_wisp_spirits:OnSpellStart()
	self.duration = self:GetSpecialValueFor("duration")
	self.caster = self:GetCaster()
	self.int = false
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_spirits", {duration = self.duration})
end
modifier_imba_spirits = class({})
function modifier_imba_spirits:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_spirits:IsPurgable()	return false end
function modifier_imba_spirits:IsPurgeException() 		return false end
function modifier_imba_spirits:OnCreated(params)
	if IsServer() then
		self.caster = self:GetCaster()
		self.duration = self:GetAbility():GetSpecialValueFor("duration")
		for i=1, 6 do
			Timers:CreateTimer(0.05, function()
				CreateModifierThinker(
				self:GetCaster(), -- player source
				self:GetAbility(), -- ability source
				"modifier_imba_spirits_thinker", -- modifier name
				{
				duration = self:GetAbility():GetSpecialValueFor("duration"),
				i = i
				}, 
				self.caster:GetAbsOrigin()+Vector(0,300,0), 
				self:GetCaster():GetTeamNumber(), 
				false) -- kv
			end)	
		end	
	end
end		
modifier_imba_spirits_thinker = class({})

function modifier_imba_spirits_thinker:OnCreated(params)
	self.spirits_radius = self:GetAbility():GetSpecialValueFor("spirits_radius")
	self.dis_duration = self:GetAbility():GetSpecialValueFor("dis_duration")
	self.major_axis = self:GetAbility():GetSpecialValueFor("major_axis") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_wisp_2")
	self.minor_axis = self:GetAbility():GetSpecialValueFor("minor_axis")	
	if IsServer() then
		EmitSoundOn("Hero_Wisp.Spirits.Loop", self:GetParent())

		
		self.pos = Vector(0,0,0)
		self.i = params.i
		
		self.xxx = self.pos.x
		self.yyy = self.pos.y
		self.planet	=  false --true	

		if 	self.planet then
			self.major_axis = self:GetAbility():GetSpecialValueFor("major_axis") / 3
			self.minor_axis = self:GetAbility():GetSpecialValueFor("minor_axis")
		end		
		self.pos_now = Vector(0,0,0)		
		self.asd = false
		self.int = self:GetCaster():FindAbilityByName("imba_wisp_spirits").int
		self.target = self:GetCaster():FindAbilityByName("imba_wisp_tether").target
		self.direction = (self.pos - self:GetCaster():GetAbsOrigin()):Normalized()
		self.length = (self.pos - self:GetCaster():GetAbsOrigin()):Length2D()
		self.sp = self:GetCaster():TG_HasTalent("special_bonus_imba_wisp_2") and 60 or 30

		--if self.target and not IsFriendly(self.target, self:GetCaster())  then
			--self.direction = (self.pos - self.target:GetAbsOrigin()):Normalized()
			--self.length = (self.pos - self.target:GetAbsOrigin()):Length2D()
		--end	
		--DebugDrawCircle(self:GetParent():GetAbsOrigin(), Vector(255,0,0), 100, 50, true, 2.0)
		self.ember_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.ember_particle, 1, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.ember_particle, false, false, -1, false, false)		
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_spirits_thinker:OnIntervalThink(params)
	--if not IsServer() then return end	
	local x = self.xxx ^ 2
	local a = self.major_axis ^ 2
	local b = self.minor_axis ^ 2 
	if 	self.i % 2 == 0 or self.planet then
		if 	self.planet then
			self.xxx = self.xxx - 2 * self.i 
		else
			self.xxx = self.xxx - self.sp	
		end	
		self.yyy = math.sqrt(math.abs((1- x / a) * b ))	
		if self.xxx <= self.pos.x - self.major_axis or self.asd then
			
			if 	self.planet then
				self.xxx = self.xxx + 4 * self.i 
			else
				self.xxx = self.xxx + (self.sp * 2)	
			end
			self.asd = true
			self.yyy = self.yyy
		elseif 	self.xxx <= self.pos.x + self.major_axis  then
			self.yyy = 0-self.yyy
		end
		if self.xxx >= self.pos.x + self.major_axis then
			self.asd = false
		end		
	elseif self.i % 2 ~= 0 and not self.planet 	then
		self.xxx = self.xxx + self.sp
		self.yyy = math.sqrt(math.abs((1- x / a) * b ))	
		if self.xxx >= self.pos.x + self.major_axis or self.asd then
			self.xxx = self.xxx - (self.sp * 2)
			self.asd = true
			self.yyy = 0-self.yyy
		elseif 	self.xxx <= self.pos.x + self.major_axis and self.xxx >= self.pos.x then
			self.yyy = self.yyy
		end
		if self.xxx <= self.pos.x - self.major_axis then
			self.asd = false
		end
	end	      
	


	self.direction = (Vector(self.xxx,self.yyy,0) - self.pos):Normalized()
	self.length = (Vector(self.xxx,self.yyy,0) - self.pos):Length2D()
	if  self.planet then
		self.length = self.length * self.i
	end		
	self.pos_now = self:GetCaster():GetAbsOrigin() + self.direction * self.length
	if not self.planet then
		if self.target and not IsFriendly(self.target, self:GetCaster()) and self.int then
			self.pos_now = self.target:GetAbsOrigin() + self.direction * self.length
		end			
		if self.i==1 or self.i==2 then
			if self.target and not IsFriendly(self.target, self:GetCaster()) and self.int  then
				self.pos_now = RotatePosition(self.target:GetAbsOrigin(), QAngle(0, 0, 0), self.pos_now)
			elseif 	self.target  then
				self.pos_now = RotatePosition(self:GetCaster():GetAbsOrigin(), QAngle(0, 0, 0), self.pos_now)
			elseif 	not self.target  then
				self.pos_now = RotatePosition(self:GetCaster():GetAbsOrigin(), QAngle(0, 0, 0), self.pos_now)	
			end	
		end
		if self.i==3 or self.i==4 then
			if self.target and not IsFriendly(self.target, self:GetCaster()) and self.int   then
				self.pos_now = RotatePosition(self.target:GetAbsOrigin(), QAngle(0, 120, 0), self.pos_now)
			elseif 	self.target  then
				self.pos_now = RotatePosition(self:GetCaster():GetAbsOrigin(), QAngle(0, 120, 0), self.pos_now)
			elseif 	not self.target  then
				self.pos_now = RotatePosition(self:GetCaster():GetAbsOrigin(), QAngle(0, 120, 0), self.pos_now)		
			end		
		end
		if self.i==5 or self.i==6 then
			if self.target and not IsFriendly(self.target, self:GetCaster())  and self.int  then
				self.pos_now = RotatePosition(self.target:GetAbsOrigin(), QAngle(0, 240, 0), self.pos_now)
			elseif 	self.target  then
				self.pos_now = RotatePosition(self:GetCaster():GetAbsOrigin(), QAngle(0, 240, 0), self.pos_now)
			elseif 	not self.target  then
				self.pos_now = RotatePosition(self:GetCaster():GetAbsOrigin(), QAngle(0, 240, 0), self.pos_now)				
			end		
		end
	end						
	self:GetParent():SetAbsOrigin(self.pos_now)
	ParticleManager:SetParticleControl(self.ember_particle, 1, self.pos_now) 
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),	
		nil,	
		self.spirits_radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		0,	
		0,	
		false
	)
	for _, enemy in pairs(enemies) do
		if not enemy:HasModifier("modifier_imba_spirits_thinker_debuff") then
			enemy:AddNewModifier_RS(self:GetCaster(), self:GetAbility(), "modifier_imba_spirits_thinker_debuff", {duration = self.dis_duration})
		end	
	end
	if not self:GetCaster():IsAlive() then
		self:Destroy()
	end	
end
function modifier_imba_spirits_thinker:OnRemoved()
	if IsServer() then
		self:GetParent():StopSound("Hero_Wisp.Spirits.Loop")
	end
end
function modifier_imba_spirits_thinker:OnDestroy(params)
	if IsServer() then
		if self.ember_particle then
			ParticleManager:DestroyParticle(self.ember_particle, false)
			ParticleManager:ReleaseParticleIndex(self.ember_particle)
		end
		self:GetParent():RemoveSelf()	
	end
end
modifier_imba_spirits_thinker_debuff = class({})
function modifier_imba_spirits_thinker_debuff:IsDebuff()				return true end
function modifier_imba_spirits_thinker_debuff:IsHidden() 				return false end
function modifier_imba_spirits_thinker_debuff:IsPurgable() 			return true end
function modifier_imba_spirits_thinker_debuff:IsPurgeException() 		return true end
function modifier_imba_spirits_thinker_debuff:OnCreated() 		
	if IsServer() then
		self.damage_table = {
			victim 			= self:GetParent(),
			damage 			= self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_wisp_3") ,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		}	
		EmitSoundOn("Hero_Wisp.Spirits.Target", self:GetParent())	
		ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
		ApplyDamage(self.damage_table)
	end
end	
--function modifier_imba_spirits_thinker_debuff:DeclareFunctions()return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_spirits_thinker_debuff:CheckState() return {[MODIFIER_STATE_DISARMED] = true} end
--function modifier_imba_spirits_thinker_debuff:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("move_slow")) end
--function modifier_imba_spirits_thinker_debuff:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("attack_slow")) end	


imba_wisp_overcharge = class({})
LinkLuaModifier("modifier_imba_wisp_overcharge", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
function imba_wisp_overcharge:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_imba_wisp_overcharge", {duration = self:GetSpecialValueFor("duration")})
end
modifier_imba_wisp_overcharge = class({})
function modifier_imba_wisp_overcharge:IsDebuff() return not IsFriendly(self:GetParent(),self:GetCaster()) end
function modifier_imba_wisp_overcharge:IsHidden() return false end
function modifier_imba_wisp_overcharge:IsPurgable() return false end
function modifier_imba_wisp_overcharge:IsStunDebuff() return false end
function modifier_imba_wisp_overcharge:IsPurgeException() return false end
--[[function modifier_imba_wisp_overcharge:GetEffectName()
	return "particles/units/heroes/hero_wisp/wisp_overcharge.vpcf"
end
function modifier_imba_wisp_overcharge:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end]]
function modifier_imba_wisp_overcharge:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()


		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_overcharge.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		--ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self.drain_interval = 0.2
		self.heal = self:GetAbility():GetSpecialValueFor("heal") * 0.01 * self.drain_interval 
		self.mana = self:GetAbility():GetSpecialValueFor("mana") * 0.01 * self.drain_interval
		self:StartIntervalThink(self.drain_interval)
	end
end
function modifier_imba_wisp_overcharge:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
    MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
    MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
  }

  return funcs
end
function modifier_imba_wisp_overcharge:GetModifierPercentageCasttime()
	if IsFriendly(self:GetParent(),self:GetCaster()) and self:GetCaster():Has_Aghanims_Shard() then
  		return (self:GetAbility():GetSpecialValueFor("shard_sp"))
  	elseif not IsFriendly(self:GetParent(),self:GetCaster()) and self:GetCaster():Has_Aghanims_Shard() then
  		return (0-self:GetAbility():GetSpecialValueFor("shard_sp"))
  	end	
  	return 0
end
function modifier_imba_wisp_overcharge:GetModifierTurnRate_Percentage()
	if IsFriendly(self:GetParent(),self:GetCaster()) and self:GetCaster():Has_Aghanims_Shard() then
  		return (self:GetAbility():GetSpecialValueFor("shard_sp"))
  	elseif not IsFriendly(self:GetParent(),self:GetCaster()) and self:GetCaster():Has_Aghanims_Shard() then
  		return (0-self:GetAbility():GetSpecialValueFor("shard_sp"))
  	end	
  	return 0
end
function modifier_imba_wisp_overcharge:GetModifierProjectileSpeedBonus()
	if IsFriendly(self:GetParent(),self:GetCaster()) and self:GetCaster():Has_Aghanims_Shard() then
  		return (self:GetAbility():GetSpecialValueFor("shard_add"))
  	elseif not IsFriendly(self:GetParent(),self:GetCaster()) and self:GetCaster():Has_Aghanims_Shard() then
  		return (0-self:GetAbility():GetSpecialValueFor("shard_add"))
  	end	
  	return 0
end
function modifier_imba_wisp_overcharge:GetModifierSpellAmplify_Percentage()
	if IsFriendly(self:GetParent(),self:GetCaster())  then
  		return (self:GetAbility():GetSpecialValueFor("reduce_damage"))
  	elseif not IsFriendly(self:GetParent(),self:GetCaster()) then
  		return (0-self:GetAbility():GetSpecialValueFor("reduce_damage"))
  	end	
  	return 0
end
function modifier_imba_wisp_overcharge:GetModifierAttackSpeedBonus_Constant()
	if not IsFriendly(self:GetParent(),self:GetCaster()) then
  		return (0-self:GetAbility():GetSpecialValueFor("att_sp"))
  	else
  		return (self:GetAbility():GetSpecialValueFor("att_sp"))
  	end
  	return 0	
end
function modifier_imba_wisp_overcharge:OnIntervalThink()
	local hp = self:GetParent():GetMaxHealth() * self.heal
	local mp = self:GetParent():GetMaxMana() * self.mana
	if IsFriendly(self:GetParent(),self:GetCaster()) then
		self:GetParent():Heal(hp, self:GetAbility())
	 	self:GetParent():GiveMana(mp)
	else 	
		self.damage_table = {
			victim 			= self:GetParent(),
			damage 			= hp,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		}		
		ApplyDamage(self.damage_table)
	 	self:GetParent():ReduceMana(mp)
	end
	self.target = self:GetCaster():FindAbilityByName("imba_wisp_tether").target	
	if self.target == nil and self:GetCaster() ~= self:GetParent() then
		self:StartIntervalThink(-1)
		self:Destroy()
	end	
end
function modifier_imba_wisp_overcharge:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		if self.pfx then		
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex( self.pfx )
		end			
	end
end
-----------------------------------------------------------------------------------------------------------------------
imba_wisp_element_territory = class({})
LinkLuaModifier("modifier_imba_wisp_element_territory_thinker", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_imba_wisp_element_territory_thinker_2", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_wisp_element_territory_cd", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_element_territory_tethered", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
function imba_wisp_element_territory:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function imba_wisp_element_territory:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_wisp_5") then 
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_wisp_5"))
	end
	return cooldown
end
function imba_wisp_element_territory:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local thinker = CreateModifierThinker(caster, self, "modifier_imba_wisp_element_territory_thinker", {duration = duration}, pos, caster:GetTeamNumber(), false)
end
--[[modifier_imba_wisp_element_territory_thinker_2 = class({})
function modifier_imba_wisp_element_territory_thinker_2:OnCreated(keys)
	if IsServer() then
		EmitSoundOn("wisp_fastres", self:GetParent())
		self.ember_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.ember_particle, 1, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.ember_particle, false, false, -1, false, false)
		self.int = 0
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())
		
	end
end	
function modifier_imba_wisp_element_territory_thinker_2:OnIntervalThink()
	self.int = self.int + FrameTime()
	if self.int >= 5.8 then
		EmitSoundOn("wisp_fastres", self:GetParent())
		self.int = 0
	end	
	local pos = self:GetParent():GetAbsOrigin()
	local new_pos = RotatePosition(self:GetCaster():GetAbsOrigin(), QAngle(0, 5, 0), pos)
	self:GetParent():SetAbsOrigin(new_pos)
	ParticleManager:SetParticleControl(self.ember_particle, 1, self:GetParent():GetAbsOrigin()) 
end
function modifier_imba_wisp_element_territory_thinker_2:OnDestroy()
	if IsServer() then
	
	end
end]]	
modifier_imba_wisp_element_territory_thinker = class({})

function modifier_imba_wisp_element_territory_thinker:OnCreated()
	if IsServer() then
		--[[local direction = self:GetParent():GetForwardVector()
		direction.z = 0
		local pos = self:GetParent():GetAbsOrigin() + direction * self:GetAbility():GetSpecialValueFor("radius")
		self.range = {}
		local duration = self:GetAbility():GetSpecialValueFor("duration")
		for i=1, 4 do
			pos = RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, 90 * (i-1), 0), pos)
			dummy = CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_imba_wisp_element_territory_thinker_2", {duration = duration, i = i}, pos, self:GetCaster():GetTeamNumber(), false)
		end]]
		self.int = 0
		EmitSoundOn("wisp_fastres", self:GetParent())
		self.cd = self:GetAbility():GetSpecialValueFor("cd")
		local pos = self:GetParent():GetAbsOrigin()
	   	self.fx = ParticleManager:CreateParticle("particles/heros/centaur/centaur_hoof_stomp_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
	    ParticleManager:SetParticleControl(self.fx, 0,  pos)
	    ParticleManager:SetParticleControl(self.fx, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"),1,1))
	    ParticleManager:SetParticleControl(self.fx, 2, Vector(self:GetRemainingTime(),1,1))
	    self:AddParticle(self.fx, false, false, -1, false, false)		
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_wisp_element_territory_thinker:DeclareFunctions()
	return {
			MODIFIER_EVENT_ON_ORDER
			}
end

function modifier_imba_wisp_element_territory_thinker:OnIntervalThink()
	self.int = self.int + FrameTime()
	if self.int >= 5.8 then
		EmitSoundOn("wisp_fastres", self:GetParent())
		self.int = 0
	end		
	local target = self:GetCaster():FindAbilityByName("imba_wisp_tether").target
	if target and (self:GetParent():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= self:GetAbility():GetSpecialValueFor("radius") and not IsFriendly(target,self:GetCaster()) and not target:HasModifier("modifier_imba_wisp_element_territory_tethered") then
		target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_wisp_element_territory_tethered", {})
	elseif	target and (self:GetParent():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > (self:GetAbility():GetSpecialValueFor("radius") - target:GetHullRadius()) and not IsFriendly(target,self:GetCaster()) and target:HasModifier("modifier_imba_wisp_element_territory_tethered") then
		local direction = (target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
		direction.z = 0
		FindClearSpaceForUnit(target, self:GetParent():GetAbsOrigin() + direction * (self:GetAbility():GetSpecialValueFor("radius") - target:GetHullRadius()), true)
	end
end
function modifier_imba_wisp_element_territory_thinker:OnOrder(keys)
	local target = self:GetCaster():FindAbilityByName("imba_wisp_tether").target
	if not IsServer() or (keys.order_type ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET and keys.order_type ~= DOTA_UNIT_ORDER_MOVE_TO_POSITION) then return end

	if keys.unit == self:GetCaster() or (target and keys.unit == target) then
		local pos = keys.new_pos
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
			pos = keys.target:GetAbsOrigin()
		end	
		--DebugDrawCircle(pos, Vector(255,0,0), 100, 50, true, 2.0)
		if keys.unit == self:GetCaster() and not keys.unit:HasModifier("modifier_imba_wisp_element_territory_cd") and not (keys.unit:IsStunned() or keys.unit:IsHexed()) then
			if (self:GetParent():GetAbsOrigin() - keys.new_pos):Length2D() <= self:GetAbility():GetSpecialValueFor("radius") and (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetAbility():GetSpecialValueFor("radius") then
				
				local swap_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
				ParticleManager:SetParticleControlEnt(swap_pfx, 0, self:GetCaster(), PATTACH_POINT, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(swap_pfx, 1, nil, PATTACH_POINT, "attach_hitloc", pos, true)	
				self:GetCaster():EmitSound("Hero_Wisp.TeleportOut.Arc")
				--keys.unit:MoveToPositionAggressive(pos)
				FindClearSpaceForUnit(self:GetCaster(), pos, false)
				ProjectileManager:ProjectileDodge(self:GetCaster())
				keys.unit:AddNewModifier(keys.unit, self:GetAbility(), "modifier_imba_wisp_element_territory_cd", {duration = self.cd})	
			end
		elseif keys.unit == target and not keys.unit:HasModifier("modifier_imba_wisp_element_territory_cd") and IsFriendly(target,self:GetCaster()) and not (keys.unit:IsStunned() or keys.unit:IsHexed()) then
			if (self:GetParent():GetAbsOrigin() - keys.new_pos):Length2D() <= self:GetAbility():GetSpecialValueFor("radius") and (target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetAbility():GetSpecialValueFor("radius") then
				
				local swap_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_CUSTOMORIGIN, target)
				ParticleManager:SetParticleControlEnt(swap_pfx, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(swap_pfx, 1, nil, PATTACH_POINT, "attach_hitloc", pos, true)	
				target:EmitSound("Hero_Wisp.TeleportOut.Arc")
				--keys.unit:MoveToPositionAggressive(pos)	
				FindClearSpaceForUnit(target, pos, false)
				ProjectileManager:ProjectileDodge(target)
				keys.unit:AddNewModifier(keys.unit, self:GetAbility(), "modifier_imba_wisp_element_territory_cd", {duration = self.cd})
			end
		end		
	end		
	
end
function modifier_imba_wisp_element_territory_thinker:OnDestroy()
	if IsServer() then
		local target = self:GetCaster():FindAbilityByName("imba_wisp_tether").target
		if target and target:HasModifier("modifier_imba_wisp_element_territory_tethered") then
			target:RemoveModifierByName("modifier_imba_wisp_element_territory_tethered")
		end
		if self.fx then		
			ParticleManager:DestroyParticle(self.fx, false)
			ParticleManager:ReleaseParticleIndex( self.fx )
		end		
		self:GetParent():RemoveSelf()
	end
end
modifier_imba_wisp_element_territory_tethered = class({})
function modifier_imba_wisp_element_territory_tethered:IsDebuff()				return true end
function modifier_imba_wisp_element_territory_tethered:IsHidden() 			return  false end 
function modifier_imba_wisp_element_territory_tethered:IsPurgable() 			return false end
function modifier_imba_wisp_element_territory_tethered:IsPurgeException() 	return false end
function modifier_imba_wisp_element_territory_tethered:CheckState() return {[MODIFIER_STATE_TETHERED] = true} end	
modifier_imba_wisp_element_territory_cd = class({})
function modifier_imba_wisp_element_territory_cd:IsDebuff()				return false end
function modifier_imba_wisp_element_territory_cd:IsHidden() 			return  true end 
function modifier_imba_wisp_element_territory_cd:IsPurgable() 			return false end
function modifier_imba_wisp_element_territory_cd:IsPurgeException() 	return false end
function modifier_imba_wisp_element_territory_cd:GetEffectName()
	return "particles/generic_gameplay/generic_silenced_old.vpcf"
end

function modifier_imba_wisp_element_territory_cd:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_imba_wisp_element_territory_cd:OnCreated()
	if IsServer() then
	end
end		

--[[function modifier_imba_wisp_element_territory_cd:GetStatusEffectName()
	return "particles/status_fx/status_effect_chemical_rage.vpcf"
end

function modifier_imba_wisp_element_territory_cd:StatusEffectPriority()
	return 10
end
function modifier_imba_wisp_element_territory_cd:GetHeroEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf"
end

function modifier_imba_wisp_element_territory_cd:HeroEffectPriority()
	return 10
end]]
imba_wisp_relocate = class({})
LinkLuaModifier("modifier_imba_wisp_relocate", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_wisp_relocate_thinker", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_relocate_thinker_cd", "linken/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
--function imba_wisp_relocate:GetCooldown(level)
	--return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_wisp_9")
--end
function imba_wisp_relocate:OnUpgrade()
	local ability = self:GetCaster():FindAbilityByName("imba_wisp_element_territory")
	if ability then
		ability:SetLevel(self:GetLevel())
	end
end
function imba_wisp_relocate:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_wisp_4") then 
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_wisp_4"))
	end
	return cooldown
end	
function imba_wisp_relocate:OnSpellStart()
	self.pos = self:GetCursorPosition()
	local caster 		= self:GetCaster()
	self.pos_2 = self:GetCaster():GetAbsOrigin()
	self.return_time = self:GetSpecialValueFor("return_time")
	self.duration = self:GetSpecialValueFor("duration")
	if self:GetCursorTarget() == self:GetCaster() then
		if self:GetCaster():GetTeam() == DOTA_TEAM_GOODGUYS then
			self.pos = Vector(-6870, -6450, 520)
		else
			self.pos = Vector(6740, 6160, 520)
		end
	end
	if caster:HasModifier("modifier_fountain_aura_buff") then
		caster:RemoveModifierByName("modifier_fountain_aura_buff")
	end	
	CreateModifierThinker(
	self:GetCaster(), -- player source
	self , -- ability source
	"modifier_imba_wisp_relocate_thinker", -- modifier name
	{
	duration = self.duration,
	i = 1
	}, 
	self.pos, 
	caster:GetTeamNumber(), 
	false) -- kv
	CreateModifierThinker(
	self:GetCaster(), -- player source
	self , -- ability source
	"modifier_imba_wisp_relocate_thinker", -- modifier name
	{
	duration = self.duration,
	i = 2
	}, 
	self.pos_2, 
	caster:GetTeamNumber(), 
	false) -- kv	

	EmitSoundOn("Hero_Wisp.Relocate", self:GetCaster())
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_imba_wisp_relocate", { duration = self.return_time, pos_now = self.pos, pos_old = self.pos_2 })		
end
modifier_imba_wisp_relocate = class({})
function modifier_imba_wisp_relocate:IsDebuff() return false end
function modifier_imba_wisp_relocate:IsHidden() return false end
function modifier_imba_wisp_relocate:IsPurgable() return false end
function modifier_imba_wisp_relocate:IsStunDebuff() return false end
function modifier_imba_wisp_relocate:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_wisp_relocate:IsPurgeException() return false end
function modifier_imba_wisp_relocate:OnCreated(keys)
	if IsServer() then
		local caster 		= self:GetCaster()
		local ability 		= self:GetAbility()
		self.pos = StringToVector(keys.pos_now)
		self.pos_2 = StringToVector(keys.pos_old)
		self.target = self:GetCaster():FindAbilityByName("imba_wisp_tether").target
		self.return_time = self:GetAbility():GetSpecialValueFor("return_time")

		if self.target and IsFriendly(self.target,self:GetCaster()) and self.target:IsHero() then
			FindClearSpaceForUnit(self.target, self.pos, true)
			ProjectileManager:ProjectileDodge(self.target)
			PlayerResource:SetCameraTarget(self.target:GetPlayerOwnerID(), self.target)
			Timers:CreateTimer(0.1, function()
				PlayerResource:SetCameraTarget(self.target:GetPlayerOwnerID(), nil)
			end)	
		elseif self.target and not IsFriendly(self.target,self:GetCaster()) then
			self.target:AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("imba_wisp_spirits"), "modifier_imba_spirits", {duration = self:GetCaster():FindAbilityByName("imba_wisp_spirits"):GetSpecialValueFor("duration")})
			self:GetCaster():FindAbilityByName("imba_wisp_spirits").int = true
		end	
		FindClearSpaceForUnit(caster, self.pos, true)
		ProjectileManager:ProjectileDodge(caster)
		PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), caster)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), nil)
		end)			
		GridNav:DestroyTreesAroundPoint(self.pos, 300, false)
		GridNav:DestroyTreesAroundPoint(self.pos_2, 300, false)
		--self.Pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		--local time_x = self.return_time >= 10 and 1 or 0
		--local time_y = self.return_time % 10
		--ParticleManager:SetParticleControl(self.Pfx, 1, Vector( time_x, time_y, 0 ) )
		self.Pfx_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(self.Pfx_2, 0, self.pos_2)
		--self.Pfx_3 = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_marker.vpcf", PATTACH_WORLDORIGIN, caster)
		--ParticleManager:SetParticleControl(self.Pfx_3, 0, self.pos_2)
		--传送门特效
		--self.Pfx_4 = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_marker_ti7.vpcf", PATTACH_WORLDORIGIN, caster)
		--ParticleManager:SetParticleControl(self.Pfx_4, 0, self.pos_2)
		--self.Pfx_5 = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_marker_ti7.vpcf", PATTACH_WORLDORIGIN, caster)
		--ParticleManager:SetParticleControl(self.Pfx_5, 0, self.pos)				
		EmitSoundOn("Hero_Wisp.Return", self:GetCaster())
		EmitSoundOn("Hero_Wisp.ReturnCounter", self:GetCaster())								
		--self:StartIntervalThink(1.0)
	end
end
function modifier_imba_wisp_relocate:OnIntervalThink()
	--self.return_time = self.return_time - 1
	--local time_x = self.return_time >= 10 and 1 or 0
	--local time_y = self.return_time % 10
	--ParticleManager:SetParticleControl(self.Pfx, 1, Vector( time_x, time_y, 0 ) )
end
function modifier_imba_wisp_relocate:OnRemoved()
	if IsServer() then
		local caster 		= self:GetCaster()
		local ability 		= self:GetAbility()
		if caster:IsAlive() then		
			FindClearSpaceForUnit(caster, self.pos_2, true)
		end
		GridNav:DestroyTreesAroundPoint(self.pos, 300, false)
		GridNav:DestroyTreesAroundPoint(self.pos_2, 300, false)
		self.target = self:GetCaster():FindAbilityByName("imba_wisp_tether").target
		if self.target and IsFriendly(self.target,self:GetCaster()) then
			if caster:IsAlive() then
				FindClearSpaceForUnit(self.target, self.pos_2, true)
				PlayerResource:SetCameraTarget(self.target:GetPlayerOwnerID(), self.target)
				Timers:CreateTimer(0.1, function()
					PlayerResource:SetCameraTarget(self.target:GetPlayerOwnerID(), nil)
				end)
			end	
		elseif self.target and not IsFriendly(self.target,self:GetCaster()) then
			self.target:AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("imba_wisp_spirits"), "modifier_imba_spirits", {duration = self:GetCaster():FindAbilityByName("imba_wisp_spirits"):GetSpecialValueFor("duration")})
			self:GetCaster():FindAbilityByName("imba_wisp_spirits").int = true		
		end
		if caster:IsAlive() then		
			PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), caster)
			Timers:CreateTimer(0.1, function()
				PlayerResource:SetCameraTarget(caster:GetPlayerOwnerID(), nil)
			end)
		end			
		EmitSoundOn("Hero_Wisp.TeleportOut", self:GetCaster())
		StopSoundOn("Hero_Wisp.ReturnCounter", self:GetCaster())
		--if self.Pfx then		
		--	ParticleManager:DestroyParticle(self.Pfx, false)
		--	ParticleManager:ReleaseParticleIndex( self.Pfx )
		--end					
		if self.Pfx_2 then		
			ParticleManager:DestroyParticle(self.Pfx_2, false)
			ParticleManager:ReleaseParticleIndex( self.Pfx_2 )
		end	
		--if self.Pfx_4 then		
		--	ParticleManager:DestroyParticle(self.Pfx_4, false)
		--	ParticleManager:ReleaseParticleIndex( self.Pfx_4 )
		--end
		--if self.Pfx_5 then		
		--	ParticleManager:DestroyParticle(self.Pfx_5, false)
		--	ParticleManager:ReleaseParticleIndex( self.Pfx_5 )
		--end
		if caster:HasModifier("modifier_fountain_aura_buff") then
			caster:RemoveModifierByName("modifier_fountain_aura_buff")
		end				
	end
end
modifier_imba_wisp_relocate_thinker = class({})
function modifier_imba_wisp_relocate_thinker:OnCreated(keys)
	if IsServer() then
		self.hitted = false
		self.trigger_duration = self:GetAbility():GetSpecialValueFor("trigger_duration")
		self.hitted = {}		
		if keys.i == 1 then
			self.pos = self:GetCaster():FindAbilityByName("imba_wisp_relocate").pos_2
		end		
		
		if keys.i == 2 then
			self.pos = self:GetCaster():FindAbilityByName("imba_wisp_relocate").pos
		end	
		self.time = 0
		self.Pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		local time_x = self:GetStackCount() >= 10 and 1 or 0
		local time_y = self:GetStackCount() % 10
		ParticleManager:SetParticleControl(self.Pfx, 0, (self:GetParent():GetAbsOrigin()) )
		ParticleManager:SetParticleControl(self.Pfx, 1, Vector( time_x, time_y, 0 ) )

		self.Pfx_4 = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_marker_ti7.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.Pfx_4, 0, self:GetParent():GetAbsOrigin())				
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_wisp_relocate_thinker:OnIntervalThink(params)
	if not IsServer() then return end	
	local time_x = self:GetStackCount() >= 10 and 1 or 0
	local time_y = self:GetStackCount() % 10
	ParticleManager:SetParticleControl(self.Pfx, 0, (self:GetParent():GetAbsOrigin()) )
	ParticleManager:SetParticleControl(self.Pfx, 1, Vector( time_x, time_y, 0 ) )	
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),	
		nil,	
		120,	
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO,	
		0,	
		0,	
		false
	)
	self.target = self:GetCaster():FindAbilityByName("imba_wisp_tether").target
	--print(enemies)
	if #enemies == 0 then
		self:SetStackCount(0)
	end	
	for _, enemy in pairs(enemies) do
		local hit = false
		for _, unit in pairs(self.hitted) do
			if enemy == unit then
				hit = true
				break
			end
		end
		if not hit then
			if  enemy ~= self:GetCaster() and enemy ~= self.target and not enemy:HasModifier("modifier_imba_wisp_relocate_thinker_cd") then
					--print(self:GetStackCount())
					self.time = self.time + FrameTime()
					if self.time > 1 then
						self:IncrementStackCount()
						--EmitSoundOn("Hero_Wisp.ReturnCounter", enemy)
						self.time = 0
					end
				if self:GetStackCount() >= self.trigger_duration  then					
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_wisp_relocate_thinker_cd", {duration = self:GetRemainingTime()})
					self.hitted[#self.hitted+1] = enemy
					FindClearSpaceForUnit(enemy, self.pos, true)
					PlayerResource:SetCameraTarget(enemy:GetPlayerOwnerID(), enemy)
					Timers:CreateTimer(0.1, function()
						PlayerResource:SetCameraTarget(enemy:GetPlayerOwnerID(), nil)
					end)	
					EmitSoundOn("Hero_Wisp.TeleportOut", enemy)
					self:SetStackCount(0)
					--StopSoundOn("Hero_Wisp.ReturnCounter", enemy)
				end	
			end	
		end
	end	
end
function modifier_imba_wisp_relocate_thinker:OnRemoved()
	if IsServer() then
		self.hitted = {}
		if self.Pfx then		
			ParticleManager:DestroyParticle(self.Pfx, false)
			ParticleManager:ReleaseParticleIndex( self.Pfx )
		end
		if self.Pfx_4 then		
			ParticleManager:DestroyParticle(self.Pfx_4, false)
			ParticleManager:ReleaseParticleIndex( self.Pfx_4 )
		end					
	end
end
function modifier_imba_wisp_relocate_thinker:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveSelf()
	end
end
modifier_imba_wisp_relocate_thinker_cd = class({})
function modifier_imba_wisp_relocate_thinker_cd:IsDebuff()				return false end
function modifier_imba_wisp_relocate_thinker_cd:IsHidden() 			return  true end 
function modifier_imba_wisp_relocate_thinker_cd:IsPurgable() 			return false end
function modifier_imba_wisp_relocate_thinker_cd:IsPurgeException() 	return false end