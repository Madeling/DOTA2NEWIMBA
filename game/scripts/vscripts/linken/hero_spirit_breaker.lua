--2020.10.31 by 你收拾收拾准备出林肯吧
--暗影冲刺 可蓄力增加移速 非目标击退距离加倍
CreateTalents("npc_dota_hero_spirit_breaker","linken/hero_spirit_breaker.lua")
function IsInTable(value, hTable)
	for i=0, #hTable do
		if hTable[i] == value then
			return true
		end
	end
	return false
end
imba_spirit_breaker_charge_of_darkness = class({})
LinkLuaModifier("modifier_imba_spirit_breaker_charge_of_darkness_target","linken/hero_spirit_breaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spirit_breaker_charge_of_darkness_caster","linken/hero_spirit_breaker.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_darkness_target_stun","linken/hero_spirit_breaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_camera_stun","linken/hero_spirit_breaker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_spirit_breaker_charge_of_darkness:OnSpellStart(keys)
	local caster = self:GetCaster() 
	local target = self:GetCursorTarget()
	if not keys then
		if target:TG_TriggerSpellAbsorb(self) then return end
	end	
	caster:EmitSound("Hero_Spirit_Breaker.ChargeOfDarkness")
	target:AddNewModifier(caster, self, "modifier_imba_spirit_breaker_charge_of_darkness_target", {duration = 30})
	caster:AddNewModifier(caster, self, "modifier_imba_spirit_breaker_charge_of_darkness_caster", {duration = 30})		
end
function imba_spirit_breaker_charge_of_darkness:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:HasScepter() then 
		return (cooldown + self:GetSpecialValueFor("sce_cooldown"))
	end
	return cooldown
end
modifier_imba_spirit_breaker_charge_of_darkness_target = class({})
function modifier_imba_spirit_breaker_charge_of_darkness_target:IsDebuff()			return true end
function modifier_imba_spirit_breaker_charge_of_darkness_target:IsHidden() 			return true end
function modifier_imba_spirit_breaker_charge_of_darkness_target:IsPurgable() 		return false end
function modifier_imba_spirit_breaker_charge_of_darkness_target:IsPurgeException() 	return false end
function modifier_imba_spirit_breaker_charge_of_darkness_target:RemoveOnDeath() 		return true  end
function modifier_imba_spirit_breaker_charge_of_darkness_target:CheckState() return {[MODIFIER_STATE_INVISIBLE] = false} end
function modifier_imba_spirit_breaker_charge_of_darkness_target:DeclareFunctions() 
	return {
			MODIFIER_EVENT_ON_ORDER,
			MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
			MODIFIER_EVENT_ON_DEATH
			} 
end
function modifier_imba_spirit_breaker_charge_of_darkness_target:GetModifierProvidesFOWVision() return 1 end
function modifier_imba_spirit_breaker_charge_of_darkness_target:OnDeath(keys)
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local unit = keys.unit
	local spirit_breaker_fri = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		unit:GetAbsOrigin(), 
		nil, 
		4000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, 
		FIND_CLOSEST, 
		false
		)	
	local ability = caster:FindAbilityByName("imba_spirit_breaker_charge_of_darkness")
	if unit == self:GetParent() then
		self:Destroy()
		if caster:FindModifierByName("modifier_imba_spirit_breaker_charge_of_darkness_caster") then
			caster:FindModifierByName("modifier_imba_spirit_breaker_charge_of_darkness_caster"):Destroy()
		end	
		self:GetCaster():Stop()		
		for _, enemy in pairs(spirit_breaker_fri) do
			if ability then
				caster:SetCursorCastTarget(enemy)
				ability:OnSpellStart(true)
				break
			end
		end
	end			
end
function modifier_imba_spirit_breaker_charge_of_darkness_target:OnOrder(keys)
	local target = self:GetParent()	
	local caster = self:GetCaster()
	if keys.unit == self:GetCaster() then
		if keys.order_type ~= DOTA_UNIT_ORDER_CAST_NO_TARGET then
			self:Destroy()
		elseif	keys.ability and not bit.band(keys.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
			self:Destroy()
		end
	end
end
function modifier_imba_spirit_breaker_charge_of_darkness_target:OnCreated(keys)
		self.max_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.tree_radius = self:GetAbility():GetSpecialValueFor("tree_radius")	
	if IsServer() then
		local target = self:GetParent()	
		local caster = self:GetCaster()
		AddFOWViewer(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), 200, 0.2, true)
		self.hitted = {}
		self.pos = self:GetCaster():GetAbsOrigin()
		self:StartIntervalThink(FrameTime())
	   	self.pfx = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_target.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
	    ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	    ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	    self:AddParticle(self.pfx, false, false, -1, true, false)
	    caster:Stop()	
		--caster:MoveToTargetToAttack(target)
		--caster:SetAttacking(target) 
		caster:MoveToPosition(target:GetAbsOrigin())		
	end
end
function modifier_imba_spirit_breaker_charge_of_darkness_target:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetParent()
	if not self:GetCaster():HasModifier("modifier_imba_spirit_breaker_charge_of_darkness_caster") then
		self:Destroy()
	end	
	caster:MoveToPosition(target:GetAbsOrigin())	
	--caster:MoveToTargetToAttack(target)
	--caster:SetAttacking(target)
	--caster:SetForceAttackTarget(target)
	--Timers:CreateTimer(FrameTime(), function()
	--		caster:SetForceAttackTarget(nil)
	--	end
	--)
	local horn_pos = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack1"))
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= target then
			if not enemy:HasModifier("modifier_knockback") then
				if self:GetCaster():FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive") then
					self:GetCaster():FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive"):Bash(enemy, me, true)
				end
			end		
		end	
	end
	local spirit_breaker_fri = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		caster:GetAbsOrigin(), 
		nil, 
		self.radius, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
		)
	if self:GetAbility():GetAutoCastState() then
		for _, enemy in pairs(spirit_breaker_fri) do
			if not IsInTable(enemy, self.hitted) then
				if enemy ~= caster then
					if #self.hitted < 1 then
						enemy:AddNewModifier(caster, self:GetAbility(), "modifier_imba_darkness_target_stun", {duration = 30})
						enemy:AddNewModifier(caster, self:GetAbility(), "modifier_imba_camera_stun", {duration = 0.2})
						
						self.hitted[#self.hitted+1] = enemy
					end	
				end	
			end
		end			
		for i, enemy in pairs(self.hitted) do
			if enemy and enemy:IsAlive() then
				if enemy ~= caster then
					if #self.hitted <= 1 then
						if enemy:HasModifier("modifier_imba_darkness_target_stun") then
							enemy:SetOrigin(GetGroundPosition(horn_pos, nil))
						end
					end					
				end
			else
				self.hitted[i] = nil
			end
		end
	end	
	local spirit_breaker = FindUnitsInRadius(
		target:GetTeamNumber(), 
		target:GetAbsOrigin(), 
		nil, 
		self:GetCaster():Script_GetAttackRange()+150, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
		FIND_ANY_ORDER, 
		false
		)
	for _, enemy in pairs(spirit_breaker) do
		if enemy ==  caster then
			self:Destroy()	
			caster:EmitSound("Hero_Spirit_Breaker.Charge.Impact")
			if self:GetCaster():FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive") then
				self:GetCaster():FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive"):Bash(target, me, false)
			end	
			target:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", {duration = self.max_duration})
			if caster:FindModifierByName("modifier_imba_spirit_breaker_charge_of_darkness_caster") then
				caster:FindModifierByName("modifier_imba_spirit_breaker_charge_of_darkness_caster"):Destroy()
			end								
			break
		end
	end	
	GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), self.tree_radius, false)
	AddFOWViewer(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), 800, 0.1, true)
	if caster:IsStunned() or caster:IsHexed() then
		self:Destroy()
	end	
end
function modifier_imba_spirit_breaker_charge_of_darkness_target:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		if self.pfx then
			ParticleManager:DestroyParticle( self.pfx, false )
			ParticleManager:ReleaseParticleIndex( self.pfx )	
		end	
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		for _, enemy in pairs(self.hitted) do
			if enemy then
				if enemy:HasModifier("modifier_imba_darkness_target_stun") then
					local a = enemy:FindModifierByNameAndCaster("modifier_imba_darkness_target_stun", self:GetCaster()):Destroy()
				end	
				FindClearSpaceForUnit(enemy, enemy:GetAbsOrigin(), true)
				enemy:Stop()
				--enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_skewer_debuff", {duration = self:GetAbility():GetSpecialValueFor("slow_duration")})
			end
		end
		caster:MoveToTargetToAttack(target)
		caster:SetAttacking(target)		
		self.hitted = nil
		self.pos = nil
		self.speed = nil
	end
end
modifier_imba_spirit_breaker_charge_of_darkness_caster = class({})
function modifier_imba_spirit_breaker_charge_of_darkness_caster:IsDebuff()			return false end
function modifier_imba_spirit_breaker_charge_of_darkness_caster:IsHidden() 			return false end
function modifier_imba_spirit_breaker_charge_of_darkness_caster:IsPurgable() 		return false end
function modifier_imba_spirit_breaker_charge_of_darkness_caster:IsPurgeException() 	return false end
function modifier_imba_spirit_breaker_charge_of_darkness_caster:RemoveOnDeath() 		return true  end
function modifier_imba_spirit_breaker_charge_of_darkness_caster:CheckState() return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true} end
function modifier_imba_spirit_breaker_charge_of_darkness_caster:OnOrder(keys)
	if keys.unit == self:GetCaster() then
		if keys.order_type ~= DOTA_UNIT_ORDER_CAST_NO_TARGET then
			self:Destroy()
		elseif	keys.ability and not bit.band(keys.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
			self:Destroy()
		end	
	end
end
function modifier_imba_spirit_breaker_charge_of_darkness_caster:DeclareFunctions() 
	return {
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION, 
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
			MODIFIER_EVENT_ON_ORDER,
			} 
end
function modifier_imba_spirit_breaker_charge_of_darkness_caster:GetModifierMoveSpeedBonus_Constant() 
	local duration = self:GetElapsedTime()
	local caster = self:GetCaster()
	local per_speed = self:GetAbility():GetSpecialValueFor( "per_speed" ) + caster:TG_GetTalentValue("special_bonus_imba_spirit_breaker_1")
	local int = (duration * per_speed * 0.1) + 1
	local speed = self:GetAbility():GetSpecialValueFor( "speed" )
	if caster:HasScepter() then 
		speed =  speed + self:GetAbility():GetSpecialValueFor("sce_speed")
	end	
	return speed*int 
end
function modifier_imba_spirit_breaker_charge_of_darkness_caster:GetModifierIgnoreMovespeedLimit() return 1 end
function modifier_imba_spirit_breaker_charge_of_darkness_caster:GetOverrideAnimation()
	return ACT_DOTA_RUN_STATUE
end
function modifier_imba_spirit_breaker_charge_of_darkness_caster:GetStatusEffectName()
  return "particles/status_fx/status_effect_charge_of_darkness.vpcf"
end
function modifier_imba_spirit_breaker_charge_of_darkness_caster:OnCreated(keys)
	if IsServer() then	
		self:GetAbility():SetActivated(false)
		self:GetAbility():EndCooldown()
	   	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	    ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	    self:AddParticle(self.pfx, false, false, -1, true, false)
	    self:StartIntervalThink(FrameTime())		
	end
end
function modifier_imba_spirit_breaker_charge_of_darkness_caster:OnIntervalThink()
	if not IsServer() then return end

end	
function modifier_imba_spirit_breaker_charge_of_darkness_caster:OnDestroy()
	if IsServer() then
		self:GetAbility():SetActivated(true)
		self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(-1)) * self:GetParent():GetCooldownReduction())
		if self.pfx then
			ParticleManager:DestroyParticle( self.pfx, false )
			ParticleManager:ReleaseParticleIndex( self.pfx )	
		end
	end
end
modifier_imba_camera_stun = class({})

function modifier_imba_camera_stun:OnCreated(keys)
	if IsServer() then	
		PlayerResource:SetCameraTarget(self:GetParent():GetPlayerOwnerID(), self:GetParent())
	end
end
function modifier_imba_camera_stun:OnDestroy()
	if IsServer() then
		PlayerResource:SetCameraTarget(self:GetParent():GetPlayerOwnerID(), nil)
	end
end
modifier_imba_darkness_target_stun = class({})
function modifier_imba_darkness_target_stun:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_darkness_target_stun:IsDebuff()			return true end
function modifier_imba_darkness_target_stun:IsHidden() 			return false end
function modifier_imba_darkness_target_stun:IsPurgable() 			return false end
function modifier_imba_darkness_target_stun:IsPurgeException() 	return true end
function modifier_imba_darkness_target_stun:IsStunDebuff()		return true end
function modifier_imba_darkness_target_stun:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_imba_darkness_target_stun:GetOverrideAnimation() return ACT_DOTA_DISABLED end
function modifier_imba_darkness_target_stun:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_imba_darkness_target_stun:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_darkness_target_stun:ShouldUseOverheadOffset() return true end
function modifier_imba_darkness_target_stun:DeclareFunctions() 
	return {
			MODIFIER_EVENT_ON_ORDER,
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION
			} 
end
function modifier_imba_darkness_target_stun:OnOrder(keys)
	if self:GetCaster():GetTeamNumber()==self:GetParent():GetTeamNumber() and keys.unit == self:GetParent() then				
		if keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION or keys.order_type == DOTA_UNIT_ORDER_STOP then
			self:Destroy()
		end
	end
end
function modifier_imba_darkness_target_stun:OnCreated(keys)
	if IsServer() then	
		--PlayerResource:SetCameraTarget(self:GetParent():GetPlayerOwnerID(), self:GetParent())
		--Timers:CreateTimer(FrameTime(), function()
				--PlayerResource:SetCameraTarget(self:GetParent():GetPlayerOwnerID(), nil)
				--return nil
			--end
		--)		
	    if not self:GetParent():IsIllusion() then 
	        Notifications:Bottom(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), {text="下达停止或者固守原位指令来提前结束携程", duration=4, style={color="#E8E8E8", ["font-size"]="40px"}})
	    end			
	end
end
function modifier_imba_darkness_target_stun:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
end

--威吓




imba_spirit_breaker_bulldoze = class({})
LinkLuaModifier( "modifier_imba_spirit_breaker_bulldoze", "linken/hero_spirit_breaker.lua", LUA_MODIFIER_MOTION_NONE ) 
function imba_spirit_breaker_bulldoze:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_spirit_breaker_2") then 
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_spirit_breaker_2"))
	end
	return cooldown
end
function imba_spirit_breaker_bulldoze:OnSpellStart()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor( "radius" )
	local duration = self:GetSpecialValueFor( "duration" )

	caster:EmitSound("Hero_Spirit_Breaker.Bulldoze.Cast")
	caster:AddNewModifier(
		caster,
		self, 
		"modifier_imba_spirit_breaker_bulldoze", 
		{ duration = duration } 
	)
end
modifier_imba_spirit_breaker_bulldoze = class({})

function modifier_imba_spirit_breaker_bulldoze:IsDebuff()			return false end
function modifier_imba_spirit_breaker_bulldoze:IsHidden() 			return false end
function modifier_imba_spirit_breaker_bulldoze:IsPurgable() 		return false end
function modifier_imba_spirit_breaker_bulldoze:IsPurgeException() 	return false end
function modifier_imba_spirit_breaker_bulldoze:IsStunDebuff()		return true end
function modifier_imba_spirit_breaker_bulldoze:DeclareFunctions() 
	return {
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
			} 
end
function modifier_imba_spirit_breaker_bulldoze:GetModifierMoveSpeedBonus_Percentage()	return self:GetAbility():GetSpecialValueFor( "move_speed" ) end
function modifier_imba_spirit_breaker_bulldoze:GetModifierStatusResistanceStacking()	return self:GetAbility():GetSpecialValueFor( "resistance" ) end
function modifier_imba_spirit_breaker_bulldoze:GetModifierPreAttack_BonusDamage() 
	local caster = self:GetCaster()
	local move = caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true)
	local attack = (self:GetAbility():GetSpecialValueFor( "attack_bonus" ) + caster:TG_GetTalentValue("special_bonus_imba_spirit_breaker_3")) * 0.01 * move
	return attack
end
function modifier_imba_spirit_breaker_bulldoze:OnCreated(keys)
	if IsServer() then
		local caster = self:GetCaster()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if self:GetCaster():FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive") then
				caster:FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive"):Bash(enemy, me, false)
			end							
		end		
	   	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	    ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	    self:AddParticle(self.pfx, false, false, -1, true, false)		
	end
end
function modifier_imba_spirit_breaker_bulldoze:OnRefresh(keys) 
	self:OnCreated(keys)
end
function modifier_imba_spirit_breaker_bulldoze:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if self:GetCaster():FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive") then
				caster:FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive"):Bash(enemy, me, false)
			end						
		end		
		if self.pfx then
			ParticleManager:DestroyParticle( self.pfx, false )
			ParticleManager:ReleaseParticleIndex( self.pfx )	
		end
	end
end


imba_spirit_breaker_greater_bash = class({})
LinkLuaModifier("modifier_imba_spirit_breaker_greater_bash_passive", "linken/hero_spirit_breaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_darkness_target_stun","linken/hero_spirit_breaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spirit_breaker_greater_bash_move_speed","linken/hero_spirit_breaker.lua", LUA_MODIFIER_MOTION_NONE)



function imba_spirit_breaker_greater_bash:GetIntrinsicModifierName() return "modifier_imba_spirit_breaker_greater_bash_passive" end

modifier_imba_spirit_breaker_greater_bash_passive = class({})

function modifier_imba_spirit_breaker_greater_bash_passive:IsDebuff()				return false end
function modifier_imba_spirit_breaker_greater_bash_passive:IsHidden() 			return true end
function modifier_imba_spirit_breaker_greater_bash_passive:IsPurgable() 			return false end
function modifier_imba_spirit_breaker_greater_bash_passive:IsPurgeException() 	return false end
function modifier_imba_spirit_breaker_greater_bash_passive:AllowIllusionDuplicate() return false end
function modifier_imba_spirit_breaker_greater_bash_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_imba_spirit_breaker_greater_bash_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end 
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or keys.target:IsBuilding() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local chance_pct = ability:GetSpecialValueFor("chance_pct") + caster:TG_GetTalentValue("special_bonus_imba_spirit_breaker_5")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)			
	if PseudoRandom:RollPseudoRandom(ability, chance_pct) and self:GetAbility():IsCooldownReady() then
		if caster:HasModifier("modifier_imba_spirit_breaker_bulldoze") then
			for _, enemy in pairs(enemies) do
				caster:FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive"):Bash(enemy, me, false)	
			end
		else
			caster:FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive"):Bash(keys.target, me, false)	
		end
		self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(-1)) * self:GetParent():GetCooldownReduction())		
	end
end
function modifier_imba_spirit_breaker_greater_bash_passive:Bash(target, parent, bool, bool2)
	if not IsServer() then return end
	local caster = self:GetCaster()
	if not self:GetAbility():IsTrained() then return end
	self.boll = bool
	local move = math.min(caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true),3000)
	self.bash_range = self:GetAbility():GetSpecialValueFor("bash_range")
	self.bash_duration = self:GetAbility():GetSpecialValueFor("bash_duration")
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.damage = move * (self:GetAbility():GetSpecialValueFor("move_da") + caster:TG_GetTalentValue("special_bonus_imba_spirit_breaker_4")) * 0.01
	if self.boll then
		self.bash_range = self.bash_range * 3
	end
	if	bool2 then
		self.bash_range = 0
		self.bash_duration = 0
		self.stun_duration = 0
		self.damage = move * self:GetAbility():GetSpecialValueFor("move_da") * 0.01
	end	
	if target:GetName() == "npc_dota_roshan" or not target:IsAlive() then return end
	target:SetForwardVector(Vector(caster:GetForwardVector()[1], caster:GetForwardVector()[2], 0))					
   	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_CENTER_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(self.pfx, 0, target, PATTACH_CENTER_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetCaster(), PATTACH_CENTER_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    self:AddParticle(self.pfx, false, false, -1, true, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)			
	local parent_loc = self:GetCaster():GetAbsOrigin()
	target:EmitSound("Hero_Spirit_Breaker.GreaterBash") 
		knockback_properties = {
			 center_x 			= parent_loc.x,
			 center_y 			= parent_loc.y,
			 center_z 			= parent_loc.z,
			 duration 			= self.bash_duration,
			 knockback_duration = self.bash_duration,
			 knockback_distance = self.bash_range,
			 knockback_height 	= 50,
			}	
	local knockback_modifier = target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", knockback_properties)
	
	if knockback_modifier then
		knockback_modifier:SetDuration(self.stun_duration, true) 
	end	
	local damageTable = {
						victim 			= target,
						damage 			= self.damage,
						damage_type		= self:GetAbility():GetAbilityDamageType(),
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self:GetAbility()
						}
	if not target:IsMagicImmune() then									
		ApplyDamage(damageTable)
	end		
	caster:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_spirit_breaker_greater_bash_move_speed", {duration = self:GetAbility():GetSpecialValueFor("speed_duration")})		
end
modifier_imba_spirit_breaker_greater_bash_move_speed = class({})

function modifier_imba_spirit_breaker_greater_bash_move_speed:IsDebuff()				return false end
function modifier_imba_spirit_breaker_greater_bash_move_speed:IsHidden() 			return false end
function modifier_imba_spirit_breaker_greater_bash_move_speed:IsPurgable() 			return false end
function modifier_imba_spirit_breaker_greater_bash_move_speed:IsPurgeException() 	return false end
function modifier_imba_spirit_breaker_greater_bash_move_speed:AllowIllusionDuplicate() return false end
function modifier_imba_spirit_breaker_greater_bash_move_speed:DeclareFunctions() 
	return {
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
			} 
end
function modifier_imba_spirit_breaker_greater_bash_move_speed:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility():GetSpecialValueFor( "move_speed" ) end




imba_spirit_breaker_nether_strike = class({})
LinkLuaModifier("modifier_spirit_breaker_nether_strike_target","linken/hero_spirit_breaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spirit_breaker_nether_strike_caster","linken/hero_spirit_breaker.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_spirit_breaker_nether_strike_lift","linken/hero_spirit_breaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spirit_breaker_nether_strike_start_motion","linken/hero_spirit_breaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spirit_breaker_nether_strike_end_motion","linken/hero_spirit_breaker.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_spirit_breaker_nether_strike_debuff","linken/hero_spirit_breaker.lua", LUA_MODIFIER_MOTION_NONE)

function imba_spirit_breaker_nether_strike:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TG_TriggerSpellAbsorb(self) then return end
	caster:EmitSound("Hero_Spirit_Breaker.NetherStrike.Begin")
	target:AddNewModifier(caster, self, "modifier_spirit_breaker_nether_strike_target", {duration = 30})		
end
function imba_spirit_breaker_nether_strike:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_spirit_breaker_7") then 
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_spirit_breaker_7"))
	end
	return cooldown
end
modifier_spirit_breaker_nether_strike_target = class({})
function modifier_spirit_breaker_nether_strike_target:IsDebuff()			return true end
function modifier_spirit_breaker_nether_strike_target:IsHidden() 			return true end
function modifier_spirit_breaker_nether_strike_target:IsPurgable() 		return false end
function modifier_spirit_breaker_nether_strike_target:IsPurgeException() 	return false end
function modifier_spirit_breaker_nether_strike_target:RemoveOnDeath() 		return true  end
function modifier_spirit_breaker_nether_strike_target:DeclareFunctions() 
	return {
			MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
			MODIFIER_EVENT_ON_DEATH
			} 
end
function modifier_spirit_breaker_nether_strike_target:GetModifierProvidesFOWVision() return 1 end
function modifier_spirit_breaker_nether_strike_target:OnDeath(keys)
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local unit = keys.unit
	local spirit_breaker_fri = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		unit:GetAbsOrigin(), 
		nil, 
		4000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, 
		FIND_CLOSEST, 
		false
		)	
	local ability = caster:FindAbilityByName("imba_spirit_breaker_nether_strike")
	if unit == self:GetParent() then
		self:Destroy()
		if caster:FindModifierByName("modifier_spirit_breaker_nether_strike_caster") then
			caster:FindModifierByName("modifier_spirit_breaker_nether_strike_caster"):Destroy()
		end	
		self:GetCaster():Stop()		
		for _, enemy in pairs(spirit_breaker_fri) do
			if ability then
				caster:SetCursorCastTarget(enemy)
				ability:OnSpellStart()
				break
			end
		end
	end			
end

function modifier_spirit_breaker_nether_strike_target:OnCreated(keys)
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()	
		self.pos = self:GetCaster():GetAbsOrigin()
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_spirit_breaker_nether_strike_caster", {duration = 30})
		self.d = 0
		self:StartIntervalThink(FrameTime())
	   	self.pfx = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_target.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
	    ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	    ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	    self:AddParticle(self.pfx, false, false, -1, true, false)    		
	end
end
function modifier_spirit_breaker_nether_strike_target:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetParent()
	self.d = string.format("%.1f",self:GetElapsedTime()) % 0.5
	if not self:GetCaster():HasModifier("modifier_spirit_breaker_nether_strike_caster") then
		self:Destroy()
	end			
	caster:MoveToTargetToAttack(target)
	caster:SetAttacking(target)
	caster:SetForceAttackTarget(target)
	Timers:CreateTimer(FrameTime(), function()
			caster:SetForceAttackTarget(nil)
		end)
	caster:AddNoDraw()
	if self.d == 0 then
		caster:RemoveNoDraw()
	end		
			
	local spirit_breaker = FindUnitsInRadius(
		target:GetTeamNumber(), 
		target:GetAbsOrigin(), 
		nil, 
		self:GetCaster():Script_GetAttackRange()+50, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 
		FIND_ANY_ORDER, 
		false
		)
	for _, enemy in pairs(spirit_breaker) do
		if enemy ==  caster then	
			caster:EmitSound("Hero_Spirit_Breaker.NetherStrike.End")
			--self:GetCaster():FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive"):Bash(target, me, false)
			--target:AddNewModifier(caster, self:GetAbility(), "modifier_imba_darkness_target_stun", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
			self:Destroy()							
			break
		end
	end	
	GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("tree_radius"), false)
	AddFOWViewer(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), 800, 0.1, true)
end
function modifier_spirit_breaker_nether_strike_target:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		caster:RemoveNoDraw()
		if self.pfx then
			ParticleManager:DestroyParticle( self.pfx, false )
			ParticleManager:ReleaseParticleIndex( self.pfx )	
		end
		target:Purge(true, false, false, false, false)	
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		caster:AddNewModifier(caster, self, "modifier_phased", {duration = 0.2})
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
		target:AddNewModifier(target, self, "modifier_phased", {duration = 0.2})				
		target:AddNewModifier(
		self:GetCaster(), 
		self:GetAbility() , 
		"modifier_imba_spirit_breaker_nether_strike_lift", 
		{duration = 0.5})
		if caster:Has_Aghanims_Shard() then
			target:AddNewModifier(
			self:GetCaster(), 
			self:GetAbility() , 
			"modifier_spirit_breaker_nether_strike_debuff", 
			{duration = self:GetAbility():GetSpecialValueFor( "duration_debuff" )})
		end											
	end
end

modifier_spirit_breaker_nether_strike_caster = class({})
function modifier_spirit_breaker_nether_strike_caster:IsDebuff()			return false end
function modifier_spirit_breaker_nether_strike_caster:IsHidden() 			return true end
function modifier_spirit_breaker_nether_strike_caster:IsPurgable() 		return false end
function modifier_spirit_breaker_nether_strike_caster:IsPurgeException() 	return false end
function modifier_spirit_breaker_nether_strike_caster:RemoveOnDeath() 		return true  end
function modifier_spirit_breaker_nether_strike_caster:GetModifierIgnoreMovespeedLimit() return 1 end
function modifier_spirit_breaker_nether_strike_caster:CheckState() return 
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
function modifier_spirit_breaker_nether_strike_caster:DeclareFunctions() 
	return {
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
			} 
end
function modifier_spirit_breaker_nether_strike_caster:GetModifierMoveSpeedBonus_Constant() 
	return self:GetAbility():GetSpecialValueFor( "speed" ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_spirit_breaker_6")
end
function modifier_spirit_breaker_nether_strike_caster:GetOverrideAnimation()
	return ACT_DOTA_RUN_STATUE
end
function modifier_spirit_breaker_nether_strike_caster:GetStatusEffectName()
  return "particles/status_fx/status_effect_charge_of_darkness.vpcf"
end
function modifier_spirit_breaker_nether_strike_caster:OnCreated(keys)
	if IsServer() then	
	   	self.pfx = ParticleManager:CreateParticle("particles/econ/items/spirit_breaker/spirit_breaker_iron_surge/spirit_breaker_charge_iron.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	    ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	    self:AddParticle(self.pfx, false, false, -1, true, false)
		self:OnIntervalThink()	
		self:StartIntervalThink(0.5)	    		
	end
end
function modifier_spirit_breaker_nether_strike_caster:OnIntervalThink()
	local target = self:GetParent()
	local caster = self:GetCaster()
	local spirit_breaker = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		caster:GetAbsOrigin(), 
		nil, 
		30000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
		)
	for _, enemy in pairs(spirit_breaker) do
		if enemy:HasModifier("modifier_spirit_breaker_nether_strike_target") then
			en = enemy
			break
		end	
	end
	if not (en:HasModifier("modifier_imba_spirit_breaker_nether_strike_lift") or en:HasModifier("modifier_imba_spirit_breaker_nether_strike_start_motion") or en:HasModifier("modifier_imba_spirit_breaker_nether_strike_end_motion") or en:HasModifier("modifier_spirit_breaker_nether_strike_target")) then
		self:Destroy()
	end						
end	
function modifier_spirit_breaker_nether_strike_caster:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle( self.pfx, false )
			ParticleManager:ReleaseParticleIndex( self.pfx )	
		end
	end
end
modifier_imba_spirit_breaker_nether_strike_lift = class({})

function modifier_imba_spirit_breaker_nether_strike_lift:IsDebuff()			return false end
function modifier_imba_spirit_breaker_nether_strike_lift:IsHidden() 			return true end
function modifier_imba_spirit_breaker_nether_strike_lift:IsPurgable() 			return false end
function modifier_imba_spirit_breaker_nether_strike_lift:IsPurgeException() 	return false end
function modifier_imba_spirit_breaker_nether_strike_lift:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_imba_spirit_breaker_nether_strike_lift:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_imba_spirit_breaker_nether_strike_lift:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true} end

function modifier_imba_spirit_breaker_nether_strike_lift:OnCreated(keys)
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		self.life = false
		self:OnIntervalThink()	
		self:StartIntervalThink(FrameTime())
		target:SetForwardVector(Vector(-caster:GetForwardVector()[1], -caster:GetForwardVector()[2], 0))
		caster:AddNoDraw()		
		self.pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * self:GetAbility():GetSpecialValueFor("duration")
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_spirit_breaker_nether_strike_start_motion", {duration = 0.4})
	   	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_CENTER_FOLLOW, target)
	    ParticleManager:SetParticleControlEnt(self.pfx, 0, target, PATTACH_CENTER_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	    ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetCaster(), PATTACH_CENTER_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	    self:AddParticle(self.pfx, false, false, -1, true, false)
		local next_pos = target:GetAbsOrigin()
		local next_pos_a = next_pos + ((self:GetParent():GetForwardVector() * -1) * 100)			
		caster:SetForwardVector(Vector(-target:GetForwardVector()[1], -target:GetForwardVector()[2], 0))
		caster:RemoveNoDraw()	
		caster:SetAbsOrigin(next_pos_a)	
		target:EmitSound("Hero_Spirit_Breaker.GreaterBash")
		caster:EmitSound("Hero_Spirit_Breaker.NetherStrike.End")
		if self:GetCaster():FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive") then
			self:GetCaster():FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive"):Bash(target, me, false, true)	
		end		    	
	end
end
function modifier_imba_spirit_breaker_nether_strike_lift:OnIntervalThink()
	local target = self:GetParent()
	local caster = self:GetCaster()
	if not target:IsAlive() then
		if caster:FindModifierByName("modifier_spirit_breaker_nether_strike_caster") then
			caster:FindModifierByName("modifier_spirit_breaker_nether_strike_caster"):Destroy()
			self.life = true
		end
		self:Destroy()		
	end			
end	
function modifier_imba_spirit_breaker_nether_strike_lift:OnDestroy(keys)
	if IsServer() then
		local target = self:GetParent()
		local caster = self:GetCaster()
		caster:RemoveNoDraw()
		if not self.life then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_spirit_breaker_nether_strike_end_motion", {duration = 0.4, pos_x = self.pos.x, pos_y = self.pos.y, pos_z = self.pos.z})
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.4})
		end
		self.life = true	
		self.pos = nil
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		caster:AddNewModifier(caster, self, "modifier_phased", {duration = 0.2})
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
		target:AddNewModifier(target, self, "modifier_phased", {duration = 0.2})						
	end
end
modifier_imba_spirit_breaker_nether_strike_start_motion = class({})

function modifier_imba_spirit_breaker_nether_strike_start_motion:IsDebuff()			return false end
function modifier_imba_spirit_breaker_nether_strike_start_motion:IsHidden() 			return true end
function modifier_imba_spirit_breaker_nether_strike_start_motion:IsPurgable() 		return false end
function modifier_imba_spirit_breaker_nether_strike_start_motion:IsPurgeException() 	return false end
function modifier_imba_spirit_breaker_nether_strike_start_motion:DestroyOnExpire() return false end
function modifier_imba_spirit_breaker_nether_strike_start_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_imba_spirit_breaker_nether_strike_start_motion:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_imba_spirit_breaker_nether_strike_start_motion:IsMotionController() return true end
function modifier_imba_spirit_breaker_nether_strike_start_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_spirit_breaker_nether_strike_start_motion:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		caster:AddNoDraw()
		caster:SetForwardVector(Vector(-target:GetForwardVector()[1], -target:GetForwardVector()[2], 0))				
		self:StartIntervalThink(FrameTime())	
	end
end

function modifier_imba_spirit_breaker_nether_strike_start_motion:OnIntervalThink()
	local height = 256
	local caster = self:GetCaster()
	local target = self:GetParent()	
	if not target:IsAlive() then
		self:Destroy()
		if caster:FindModifierByName("modifier_spirit_breaker_nether_strike_caster") then
			caster:FindModifierByName("modifier_spirit_breaker_nether_strike_caster"):Destroy()
		end		
	end		
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0) / 2
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)
	AddFOWViewer(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), 200, 1, true)
end
function modifier_imba_spirit_breaker_nether_strike_start_motion:OnDestroy()
	if IsServer() then
	local caster = self:GetCaster()
	local target = self:GetParent()	
	caster:RemoveNoDraw()
	caster:SetForwardVector(Vector(-target:GetForwardVector()[1], -target:GetForwardVector()[2], 0))	
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
	caster:AddNewModifier(caster, self, "modifier_phased", {duration = 0.2})
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
	target:AddNewModifier(target, self, "modifier_phased", {duration = 0.2})	
	end	
end

modifier_imba_spirit_breaker_nether_strike_end_motion = class({})

function modifier_imba_spirit_breaker_nether_strike_end_motion:IsDebuff()			return false end
function modifier_imba_spirit_breaker_nether_strike_end_motion:IsHidden() 			return true end
function modifier_imba_spirit_breaker_nether_strike_end_motion:IsPurgable() 			return false end
function modifier_imba_spirit_breaker_nether_strike_end_motion:IsPurgeException() 	return false end
function modifier_imba_spirit_breaker_nether_strike_end_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_imba_spirit_breaker_nether_strike_end_motion:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_imba_spirit_breaker_nether_strike_end_motion:IsMotionController() return true end
function modifier_imba_spirit_breaker_nether_strike_end_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_spirit_breaker_nether_strike_end_motion:OnCreated(keys)
	if IsServer() then
		local target = self:GetParent()
		local caster = self:GetCaster()
		--caster:SetForwardVector(Vector(-target:GetForwardVector()[1], -target:GetForwardVector()[2], 0))	
		caster:AddNoDraw()
		Timers:CreateTimer(0.03, function()
			caster:SetOrigin(target:GetAbsOrigin())
			caster:RemoveNoDraw()	
		end)				
		self.startpos = self:GetParent():GetAbsOrigin()
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self:GetParent():RemoveModifierByName("modifier_imba_spirit_breaker_nether_strike_start_motion")
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())
		target:EmitSound("Hero_Spirit_Breaker.GreaterBash")
		caster:EmitSound("Hero_Spirit_Breaker.NetherStrike.End")	
	   	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_CENTER_FOLLOW, target)
	    ParticleManager:SetParticleControlEnt(self.pfx, 0, target, PATTACH_CENTER_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	    ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetCaster(), PATTACH_CENTER_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	    self:AddParticle(self.pfx, false, false, -1, true, false)
	    if self:GetCaster():FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive") then
	    	self:GetCaster():FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive"):Bash(target, me, false, true)	
	    end			
	end
end

function modifier_imba_spirit_breaker_nether_strike_end_motion:OnIntervalThink()
	local height = 256
	local caster = self:GetCaster()
	local target = self:GetParent()
	if not target:IsAlive() then
		self:Destroy()
		if caster:FindModifierByName("modifier_spirit_breaker_nether_strike_caster") then
			caster:FindModifierByName("modifier_spirit_breaker_nether_strike_caster"):Destroy()
		end		
	end	
	local distance = (self.startpos - self.pos):Length2D()
	local direction = (self.pos - self:GetParent():GetAbsOrigin()):Normalized()
	local speed = distance / self:GetDuration()
	local len = speed / (1.0 / FrameTime())
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0) / 2 + 0.5
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + direction * len, nil)
	local next_pos_a = next_pos + ((self:GetParent():GetForwardVector() * -1) * 100)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)
	caster:SetOrigin(next_pos_a)
	AddFOWViewer(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), 200, 1, true)	
end

function modifier_imba_spirit_breaker_nether_strike_end_motion:OnDestroy()
	if IsServer() then
	local caster = self:GetCaster()	
	local target = self:GetParent()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		caster:AddNewModifier(caster, self, "modifier_phased", {duration = 0.2})
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
		target:AddNewModifier(target, self, "modifier_phased", {duration = 0.2})	
		if caster:FindModifierByName("modifier_spirit_breaker_nether_strike_caster") then
			caster:FindModifierByName("modifier_spirit_breaker_nether_strike_caster"):Destroy()
		end
		--caster:SetForwardVector(Vector(-target:GetForwardVector()[1], -target:GetForwardVector()[2], 0))
		--caster:SetOrigin(target:GetAbsOrigin())
		caster:RemoveNoDraw()
		caster:EmitSound("Hero_Spirit_Breaker.NetherStrike.End")
		if self:GetCaster():FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive") then	
			self:GetCaster():FindModifierByName("modifier_imba_spirit_breaker_greater_bash_passive"):Bash(target, me, false)
		end
		if caster:Has_Aghanims_Shard() then
			target:AddNewModifier(
			self:GetCaster(), 
			self:GetAbility() , 
			"modifier_spirit_breaker_nether_strike_debuff", 
			{duration = self:GetAbility():GetSpecialValueFor( "duration_debuff" )})
		end					
	end
end

modifier_spirit_breaker_nether_strike_debuff = class({})

function modifier_spirit_breaker_nether_strike_debuff:IsDebuff()			return true end
function modifier_spirit_breaker_nether_strike_debuff:IsHidden() 			return false end
function modifier_spirit_breaker_nether_strike_debuff:IsPurgable() 			return false end
function modifier_spirit_breaker_nether_strike_debuff:IsPurgeException() 	return false end
function modifier_spirit_breaker_nether_strike_debuff:CheckState() return {[MODIFIER_STATE_PASSIVES_DISABLED] = true} end
function modifier_spirit_breaker_nether_strike_debuff:DeclareFunctions() 
	return {
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
			} 
end
function modifier_spirit_breaker_nether_strike_debuff:GetModifierTotalDamageOutgoing_Percentage() return 0-self:GetAbility():GetSpecialValueFor( "incoming" ) end