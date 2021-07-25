CreateTalents("npc_dota_hero_visage", "mb/hero_visage.lua")
-- extra api
-- Sets a creature's max health to [health]
function SetCreatureHealth(unit, health, update_current_health)

	unit:SetBaseMaxHealth(health)
	unit:SetMaxHealth(health)

	if update_current_health then
		unit:SetHealth(health)
	end
end

--[[function IsEnemy(caster, target)
  if caster:GetTeamNumber()==target:GetTeamNumber() then   
    return false  
  else
    return true
  end 
end]]

--[[function TriggerStandardTargetSpell(BaseNPC,ability)
	if IsEnemy(BaseNPC, ability:GetCaster()) then
		BaseNPC:TriggerSpellReflect(ability)
		return BaseNPC:TriggerSpellAbsorb(ability)
	end
	return false
end]]

function IsHeroDamage(attacker, damage)
	if damage >= 0 then
		if attacker:IsBoss() or attacker:IsControllableByAnyPlayer() or attacker:GetName() == "npc_dota_shadowshaman_serpentward" then
			return true
		else
			return false
		end
	end
end

LinkLuaModifier("modifier_imba_gravekeepers_cloak_aura", "mb/hero_visage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gravekeepers_cloak", "mb/hero_visage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gravekeepers_cloak_recover_timer", "mb/hero_visage.lua", LUA_MODIFIER_MOTION_NONE)

imba_visage_gravekeepers_cloak = class({})

function imba_visage_gravekeepers_cloak:GetIntrinsicModifierName() return "modifier_imba_gravekeepers_cloak_aura" end
function imba_visage_gravekeepers_cloak:GetCastRange() return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end
--2020 12 25 by MysticBug-------
function imba_visage_gravekeepers_cloak:OnInventoryContentsChanged()
	--魔晶技能
	---------------------------------------------------------------
	if self:GetCaster():Has_Aghanims_Shard() then 
		local shard_abi = self:GetCaster():FindAbilityByName("imba_visage_stone_form_self_cast")
		if shard_abi then 
			shard_abi:SetHidden(false)
			shard_abi:SetLevel(self:GetLevel())
		end
	else
		local shard_abi = self:GetCaster():FindAbilityByName("imba_visage_stone_form_self_cast")
		if shard_abi then 
			shard_abi:SetHidden(true)
			shard_abi:SetLevel(0)
		end
	end
	---------------------------------------------------------------
end

modifier_imba_gravekeepers_cloak_aura = class({})

function modifier_imba_gravekeepers_cloak_aura:IsDebuff()			return false end
function modifier_imba_gravekeepers_cloak_aura:IsHidden() 			return true end
function modifier_imba_gravekeepers_cloak_aura:IsPurgable() 		return false end
function modifier_imba_gravekeepers_cloak_aura:IsPurgeException() 	return false end
function modifier_imba_gravekeepers_cloak_aura:AllowIllusionDuplicate() return false end

function modifier_imba_gravekeepers_cloak_aura:IsAura() return (not self:GetCaster():PassivesDisabled()) end
function modifier_imba_gravekeepers_cloak_aura:IsAuraActiveOnDeath() return true end
function modifier_imba_gravekeepers_cloak_aura:GetAuraDuration() return 0.1 end
function modifier_imba_gravekeepers_cloak_aura:GetModifierAura() return "modifier_imba_gravekeepers_cloak" end
function modifier_imba_gravekeepers_cloak_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_imba_gravekeepers_cloak_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_imba_gravekeepers_cloak_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_gravekeepers_cloak_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_gravekeepers_cloak_aura:GetAuraEntityReject(unit)
	if unit:IsCreep() and self:GetCaster():TG_HasTalent("special_bonus_imba_visage_1") then
		return false
	end
	return (unit:GetPlayerOwnerID() ~= self:GetCaster():GetPlayerOwnerID())
end

function modifier_imba_gravekeepers_cloak_aura:OnCreated()
	if IsServer() then
		self.units = {}
	end
end

function modifier_imba_gravekeepers_cloak_aura:OnDestroy()
	if IsServer() then
		self.units = nil
	end
end

function modifier_imba_gravekeepers_cloak_aura:DamageHealUnits(hUnit, fDamage)
	if IsServer() and self.units ~= nil then
		--for k, v in pairs(self.units) do
		for _, v in pairs(self.units) do
			--if v ~= hUnit and v ~= self:GetCaster() and v:IsControllableByAnyPlayer() then
			--print("wtf v--------",v:GetClassname())
			if v ~= hUnit and v ~= self:GetCaster() then 
				if string.find(v:GetClassname(),"npc_dota_visage_familiar") or v:IsControllableByAnyPlayer() then	
					v:Heal(fDamage, self:GetAbility())
					local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_grave_chill_cast_tgt.vpcf", PATTACH_CUSTOMORIGIN, v)
					ParticleManager:SetParticleControlEnt(pfx, 2, v, PATTACH_ABSORIGIN_FOLLOW, nil, v:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(pfx)
				end
			end
		end
	end
end

modifier_imba_gravekeepers_cloak = class({})

function modifier_imba_gravekeepers_cloak:IsDebuff()			return false end
function modifier_imba_gravekeepers_cloak:IsHidden() 			return false end
function modifier_imba_gravekeepers_cloak:IsPurgable() 			return false end
function modifier_imba_gravekeepers_cloak:IsPurgeException() 	return false end
function modifier_imba_gravekeepers_cloak:DeclareFunctions()	return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end

function modifier_imba_gravekeepers_cloak:OnCreated()
	local buff = self
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	if IsServer() then
		Timers:CreateTimer(0.1, function()
			if not buff:IsNull() then
				if caster == parent then
					buff:SetStackCount(ability:GetSpecialValueFor("max_layers"))
				else
					self:StartIntervalThink(0.1)
					buff:SetStackCount(caster:GetModifierStackCount("modifier_imba_gravekeepers_cloak", nil))
				end
			end
			return nil
		end
		)
		local buff = caster:FindModifierByName("modifier_imba_gravekeepers_cloak_aura")
		if buff then
			buff.units[parent:entindex()] = parent
		end
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_cloak_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end

function modifier_imba_gravekeepers_cloak:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(self:GetCaster():GetModifierStackCount("modifier_imba_gravekeepers_cloak", nil))
	end
end

function modifier_imba_gravekeepers_cloak:OnStackCountChanged(iStack)
	local stack = self:GetStackCount()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	if IsServer() and self.pfx then
		for i=2, stack + 2 - 1 do
			ParticleManager:SetParticleControl(self.pfx, i, Vector(1, 0, 0))
		end
		for i=stack + 2, 5 do
			ParticleManager:SetParticleControl(self.pfx, i, Vector(0, 0, 0))
		end
		if caster == parent and stack < self:GetAbility():GetSpecialValueFor("max_layers") then
			parent:AddNewModifierWhenPossible(parent, ability, "modifier_imba_gravekeepers_cloak_recover_timer", {duration = ability:GetSpecialValueFor("recovery_time")})
		end
	end
end

function modifier_imba_gravekeepers_cloak:GetModifierIncomingDamage_Percentage(keys)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local stack = self:GetStackCount()
	local damage = keys.original_damage
	local reduction = (0 - (self:GetStackCount() * ability:GetSpecialValueFor("damage_reduction")))
	if parent:IsCreep() and not parent:IsConsideredHero() then
		reduction = reduction / 2
	end
	if IsServer() then
		if keys.attacker:IsBuilding() then
			return 0
		end
		if self:GetStackCount() > 0 and IsHeroDamage(keys.attacker, damage) and damage >= ability:GetSpecialValueFor("minimum_damage") then
			local buff = caster:FindModifierByName("modifier_imba_gravekeepers_cloak_aura")
			--经常报错，可能会炸服，我也修不好，先禁用了
			--[[if buff then
				buff:DamageHealUnits(parent, damage)
			end]]
			if caster == parent then
				self:SetStackCount(self:GetStackCount() - 1)
			else
				self:SetStackCount(caster:GetModifierStackCount("modifier_imba_gravekeepers_cloak", nil))
			end
			return reduction
		end
		if damage >= ability:GetSpecialValueFor("minimum_damage") then
			return reduction
		end
	else
		return reduction
	end
end

function modifier_imba_gravekeepers_cloak:OnDestroy()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
		self.pfx = nil
		local buff = caster:FindModifierByName("modifier_imba_gravekeepers_cloak_aura")
		if buff then
			buff.units[parent:entindex()] = nil
		end
	end
end

modifier_imba_gravekeepers_cloak_recover_timer = class({})

function modifier_imba_gravekeepers_cloak_recover_timer:IsDebuff()			return false end
function modifier_imba_gravekeepers_cloak_recover_timer:IsHidden() 			return true end
function modifier_imba_gravekeepers_cloak_recover_timer:IsPurgable() 		return false end
function modifier_imba_gravekeepers_cloak_recover_timer:IsPurgeException() 	return false end

function modifier_imba_gravekeepers_cloak_recover_timer:OnDestroy()
	if IsServer() then
		local buff = self:GetParent():FindModifierByName("modifier_imba_gravekeepers_cloak")
		if buff then
			buff:SetStackCount(math.min(self:GetAbility():GetSpecialValueFor("max_layers"), buff:GetStackCount() + 1))
		end
	end
end


imba_visage_grave_chill=imba_visage_grave_chill or class({})
LinkLuaModifier("modifier_imba_visage_grave_chill_debuff", "mb/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_grave_chill_buff", "mb/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_grave_chill_aura_buff", "mb/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_grave_chill_change", "mb/hero_visage", LUA_MODIFIER_MOTION_NONE)

function imba_visage_grave_chill:IsHiddenWhenStolen() 
    return false 
end

function imba_visage_grave_chill:IsStealable() 
    return true 
end


function imba_visage_grave_chill:IsRefreshable() 			
    return true 
end

function imba_visage_grave_chill:ProcsMagicStick() 			
    return true 
end

function imba_visage_grave_chill:OnSpellStart()
	local target = self:GetCursorTarget()
    self:GetCaster():EmitSound("Hero_Visage.GraveChill.Cast")
	target:EmitSound("Hero_Visage.GraveChill.Target")
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_grave_chill_cast_beams.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_visage_grave_chill_buff", {duration = self:GetSpecialValueFor("chill_duration")})
	target:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_visage_grave_chill_change", {duration = self:GetSpecialValueFor("chill_duration")})
	target:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_visage_grave_chill_debuff", {duration = self:GetSpecialValueFor("chill_duration")}) 
end

modifier_imba_visage_grave_chill_debuff=modifier_imba_visage_grave_chill_debuff or class({})


function modifier_imba_visage_grave_chill_debuff:IsPurgable() 			
    return true
end
function modifier_imba_visage_grave_chill_debuff:IsPurgeException() 		
    return true 
end
function modifier_imba_visage_grave_chill_debuff:IsHidden()				
    return false 
end
function modifier_imba_visage_grave_chill_debuff:GetStatusEffectName()
	return "particles/units/heroes/hero_visage/status_effect_visage_chill_slow.vpcf"
end
function modifier_imba_visage_grave_chill_debuff:OnCreated()	
	if not IsServer() then return end	
	local pfx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_grave_chill_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(pfx3, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(pfx3, false, false, -1, false, false)
end
function modifier_imba_visage_grave_chill_debuff:DeclareFunctions()
	local buff = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	
	return buff
end
function modifier_imba_visage_grave_chill_debuff:GetModifierMoveSpeedBonus_Percentage()
	return (0-self:GetAbility():GetSpecialValueFor("move_speed"))
end
function modifier_imba_visage_grave_chill_debuff:GetModifierAttackSpeedBonus_Constant()
	return (0-self:GetAbility():GetSpecialValueFor("attack_speed"))
end

------------------------------------------------------------------------------

modifier_imba_visage_grave_chill_buff=modifier_imba_visage_grave_chill_buff or class({})


function modifier_imba_visage_grave_chill_buff:IsPurgable() 			
    return true
end
function modifier_imba_visage_grave_chill_buff:IsPurgeException() 		
    return true 
end
function modifier_imba_visage_grave_chill_buff:IsHidden()				
    return true 
end
function modifier_imba_visage_grave_chill_buff:IsAura() 				return true end
--function modifier_imba_visage_grave_chill_buff:IsAuraActiveOnDeath() 	return true end

function modifier_imba_visage_grave_chill_buff:GetAuraRadius()			return self:GetAbility():GetSpecialValueFor("casting_distance") end
function modifier_imba_visage_grave_chill_buff:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_imba_visage_grave_chill_buff:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_visage_grave_chill_buff:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO end
function modifier_imba_visage_grave_chill_buff:GetModifierAura()		return "modifier_imba_visage_grave_chill_aura_buff" end
--[[function modifier_imba_visage_grave_chill_buff:DeclareFunctions()
	local buff = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	
	return buff
end]]
--[[function modifier_imba_visage_grave_chill_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("move_speed")
end]]
--[[function modifier_imba_visage_grave_chill_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("attack_speed")
end]]
---------------------------------------------------------------------------------
modifier_imba_visage_grave_chill_aura_buff=modifier_imba_visage_grave_chill_aura_buff or class({})

function modifier_imba_visage_grave_chill_aura_buff:IsBuff()
    return true 
end
function modifier_imba_visage_grave_chill_aura_buff:IsPurgable() 			
    return false
end
function modifier_imba_visage_grave_chill_aura_buff:IsPurgeException() 		
    return false 
end
function modifier_imba_visage_grave_chill_aura_buff:IsHidden()				
    return false 
end
function modifier_imba_visage_grave_chill_aura_buff:DeclareFunctions()
	local buff = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	
	return buff
end
function modifier_imba_visage_grave_chill_aura_buff:GetModifierMoveSpeedBonus_Percentage() 	
	if self:GetParent():GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID() then
		return (self:GetAbility():GetSpecialValueFor("move_speed")*2)
	end
	return self:GetAbility():GetSpecialValueFor("move_speed")
end
function modifier_imba_visage_grave_chill_aura_buff:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID() then
		return (self:GetAbility():GetSpecialValueFor("attack_speed")*2)
	end
	return self:GetAbility():GetSpecialValueFor("attack_speed")
end

function modifier_imba_visage_grave_chill_aura_buff:OnCreated()
	local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_grave_chill_caster.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(pfx2, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
	
	if self:GetParent():GetName() == "npc_dota_hero_visage" then
		ParticleManager:SetParticleControlEnt(pfx2, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_tail_tip", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx2, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_wingtipL", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx2, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_wingtipR", self:GetParent():GetAbsOrigin(), true)
	else
		ParticleManager:SetParticleControlEnt(pfx2, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx2, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx2, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)	
	end
	
	self:AddParticle(pfx2, false, false, -1, false, false)
end	
-----------------------------------------------------------------------
modifier_imba_visage_grave_chill_change=modifier_imba_visage_grave_chill_change or class({})

function modifier_imba_visage_grave_chill_change:IsBuff()
    return false 
end
function modifier_imba_visage_grave_chill_change:IsPurgable() 			
    return true
end
function modifier_imba_visage_grave_chill_change:IsPurgeException() 		
    return true 
end
function modifier_imba_visage_grave_chill_change:IsHidden()				
    return false 
end
function modifier_imba_visage_grave_chill_change:DeclareFunctions()
	local buff = {
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	
	return buff
end
function modifier_imba_visage_grave_chill_change:OnHealReceived(keys)
	if keys.unit == self:GetParent() and keys.gain >= 100 then
		 self:GetCaster():Heal(keys.gain, self:GetAbility())
	end
end
function modifier_imba_visage_grave_chill_change:OnTakeDamage(keys)
	if keys.unit == self:GetParent() and keys.damage >= 100 then
		 self:GetCaster():Heal(keys.damage, self:GetAbility())
	end
end

--visage_soul_assumption 灵魂超度
--每次附近英雄（不论敌我）受到的伤害超过%damage_limit%点，
--维萨吉就能集聚灵魂精华的能量。将精华释放后，会对目标单位造成基础伤害，
--每一点集聚的能量还将造成额外伤害。

--note 能量点数只计算来自玩家或肉山的伤害，
--必须大于%damage_min%点小于%damage_max%点。自残型伤害和灵魂超度造成的伤害不计算在内。
--imba 镇魂：造成1秒昏迷 60/80/100/120 攻速减少

imba_visage_soul_assumption = class({})
LinkLuaModifier("modifier_imba_visage_soul_assumption_charge", "mb/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_soul_assumption_charge_bar", "mb/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_soul_assumption_charge_timer", "mb/hero_visage", LUA_MODIFIER_MOTION_NONE)

function imba_visage_soul_assumption:IsHiddenWhenStolen() 		return false end
function imba_visage_soul_assumption:IsRefreshable() 			return true end
function imba_visage_soul_assumption:IsStealable() 				return false end
function imba_visage_soul_assumption:IsNetherWardStealable()	return false end
--充能
function imba_visage_soul_assumption:GetIntrinsicModifierName() return "modifier_imba_visage_soul_assumption_charge" end
function imba_visage_soul_assumption:OnUpgrade()
	if not IsServer() then return end
	
	if self:GetLevel() >= 1 and self:GetCaster():FindModifierByNameAndCaster(self:GetIntrinsicModifierName(), self:GetCaster()) and not self:GetCaster():FindModifierByNameAndCaster(self:GetIntrinsicModifierName(), self:GetCaster()).pfx then
		self:GetCaster():FindModifierByNameAndCaster(self:GetIntrinsicModifierName(), self:GetCaster()).pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_soul_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
		self:GetCaster():FindModifierByNameAndCaster(self:GetIntrinsicModifierName(), self:GetCaster()):AddParticle(self:GetCaster():FindModifierByNameAndCaster(self:GetIntrinsicModifierName(), self:GetCaster()).pfx, false, false, -1, false, false)
	end
end
function imba_visage_soul_assumption:GetCastRange(location , target)
	return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():GetIntellect() + self:GetCaster():GetCastRangeBonus()
end

function imba_visage_soul_assumption:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	--------------------------------------------------------------------------------------------------
	local pfx_name = "particles/units/heroes/hero_visage/visage_soul_assumption_bolt.vpcf"
	--------------------------------------------------------------------------------------------------
	caster:EmitSound("Hero_Visage.SoulAssumption.Cast")
	-- 获取能量点数
	local charge_bars = 0
	local assumption_timer_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_visage_soul_assumption_charge_timer", self:GetCaster())
	if assumption_timer_modifier then	
		charge_bars = math.min(math.floor(assumption_timer_modifier:GetStackCount() / self:GetSpecialValueFor("damage_limit")), self:GetSpecialValueFor("stack_limit"))
		if charge_bars > 0 then
			pfx_name ="particles/units/heroes/hero_visage/visage_soul_assumption_bolt"..charge_bars..".vpcf"
		end
		-- 清空能量
		local assumption_bars_modifier = caster:FindAllModifiersByName("modifier_imba_visage_soul_assumption_charge_bar")
		for _, bar in pairs(assumption_bars_modifier) do
			bar:Destroy()
		end
		assumption_timer_modifier:Destroy()
	end
	-- 对目标
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = pfx_name,
		iMoveSpeed = self:GetSpecialValueFor("bolt_speed"),
		iSourceAttachment = caster:ScriptLookupAttachment("attach_attack1"),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
		ExtraData = {
			charges = charge_bars
		},
	}
	--释放抛射物
	ProjectileManager:CreateTrackingProjectile(info)

	--天赋 灵魂超度攻击多个目标
	if caster:TG_HasTalent("special_bonus_imba_visage_3") then 
		local strike_count = caster:TG_GetTalentValue("special_bonus_imba_visage_3")
		local radius = self:GetCastRange(caster:GetAbsOrigin(), caster) + caster:GetCastRangeBonus()		
		--优先英雄
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			caster:GetAbsOrigin(), 
			nil, 
			radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO, 
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, --只寻找在视野范围内的
			FIND_ANY_ORDER, 
			false)

		for _, enemy in pairs(enemies) do
			if enemy ~= target then
				info.Target = enemy
				--释放抛射物
				ProjectileManager:CreateTrackingProjectile(info)
				strike_count = strike_count - 1 
				if strike_count == 0 then 
					break
				end
			end
		end
		--然后普通单位
		local units = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		caster:GetAbsOrigin(), 
		nil, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, --只寻找在视野范围内的
		FIND_ANY_ORDER, 
		false)
		for _, unit in pairs(units) do
			if unit ~= target then
				info.Target = unit
				--释放抛射物
				ProjectileManager:CreateTrackingProjectile(info)
				strike_count = strike_count - 1 
				if strike_count == 0 then 
					break
				end
			end
		end	
	end
end

function imba_visage_soul_assumption:OnProjectileHit_ExtraData(target, pos, keys)
	--黄泉超度伤害 无法被躲避
	if not target or target:TriggerStandardTargetSpell(self) or target:IsMagicImmune() then
		return
	end
	local caster = self:GetCaster()	
	target:EmitSound("Hero_Visage.SoulAssumption.Target")
	-------------------------------------------------------------------------------------------------------------------------------------- 
	--击中特效
	--local pfx_name = "particles/units/heroes/hero_visage/visage_soul_assumption_beam_hit.vpcf"
	--------------------------------------------------------------------------------------------------
	--local pfx = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement(pfx_name, caster), PATTACH_CUSTOMORIGIN, target)
	--ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	--ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
	--ParticleManager:ReleaseParticleIndex(pfx)
	--------------------------------------------------------------------------------------------------
	local damage_final = self:GetSpecialValueFor("soul_base_damage") + (self:GetSpecialValueFor("soul_charge_damage") + caster:TG_GetTalentValue("special_bonus_imba_visage_2")) * keys.charges
	ApplyDamage(
		{
			attacker = caster, 
			victim = target, 
			damage = damage_final, 
			ability = self, 
			damage_type = self:GetAbilityDamageType()
		}
	)
	--麻痹
	target:AddNewModifier_RS(caster, self, "modifier_paralyzed", {duration = self:GetSpecialValueFor("stun_duration")})
	--所有佣兽攻击一次
	local primary_abi = caster:FindAbilityByName("imba_visage_summon_familiars")
	if primary_abi then 
		local familiars_table = primary_abi.familiars_table
		if familiars_table then
			for i = 1, #familiars_table do
				if familiars_table[i] and EntIndexToHScript(familiars_table[i]) and not EntIndexToHScript(familiars_table[i]):IsNull() and EntIndexToHScript(familiars_table[i]):IsAlive() then
					--攻击一次 附加灵魂超度基础伤害一半的额外伤害
					if not target:IsInvisible() and not target:IsInvulnerable() then
						ApplyDamage(
							{
								attacker = EntIndexToHScript(familiars_table[i]), 
								victim = target, 
								damage = self:GetSpecialValueFor("soul_base_damage") / 2 , 
								ability = self, 
								damage_type = self:GetAbilityDamageType()
							}
						)
						EntIndexToHScript(familiars_table[i]):PerformAttack(target, false, true, true, false, true, false, true)
					end
				end
			end
		end
	end
end

--充能监测
modifier_imba_visage_soul_assumption_charge = class({})

function modifier_imba_visage_soul_assumption_charge:IsBuff()			return false end
function modifier_imba_visage_soul_assumption_charge:IsDebuff()			return false end
function modifier_imba_visage_soul_assumption_charge:IsHidden() 		return true end
function modifier_imba_visage_soul_assumption_charge:IsPurgable() 		return false end
function modifier_imba_visage_soul_assumption_charge:IsPurgeException() 	return false end
function modifier_imba_visage_soul_assumption_charge:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_visage_soul_assumption_charge:OnCreated()
	if not IsServer() then return end
	
	if self:GetAbility() and self:GetAbility():GetLevel() >= 1 and not self.pfx then
		--空的能量条
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_soul_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(self.pfx, false, false, -1, false, false)
	end
end

function modifier_imba_visage_soul_assumption_charge:OnRefresh()
	self:OnCreated()
end

function modifier_imba_visage_soul_assumption_charge:OnDestroy()
	if IsServer() and self.pfx then
		ParticleManager:DestroyParticle(self.pfx, true)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

function modifier_imba_visage_soul_assumption_charge:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_imba_visage_soul_assumption_charge:OnTakeDamage(keys)
	--一定范围范围内的伤害
	--不会收集肉山和维萨吉控制的单位造成的伤害
	--不会收集灵魂超度技能本身伤害
	if (keys.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetAbility():GetSpecialValueFor("radius") and
	(keys.attacker:IsControllableByAnyPlayer() or keys.attacker:IsBoss()) and
	(keys.unit:IsRealHero() or not string.find(keys.attacker:GetClassname(), "npc_dota_visage_familiar")) and
	keys.unit ~= keys.attacker and
	keys.damage >= self:GetAbility():GetSpecialValueFor("damage_min") and
	keys.damage <= self:GetAbility():GetSpecialValueFor("damage_max") and
	
	keys.inflictor ~= self:GetAbility() then	

		--能量点数 特效
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_visage_soul_assumption_charge_timer", 
		{
			duration	= self:GetAbility():GetSpecialValueFor("stack_duration"),
			stacks		= keys.damage
		})
		
		local assumption_bars_modifier = self:GetParent():FindAllModifiersByName("modifier_imba_visage_soul_assumption_charge_bar")
		if #assumption_bars_modifier <= 10 then 
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_visage_soul_assumption_charge_bar", 
			{
				duration	= self:GetAbility():GetSpecialValueFor("stack_duration"),
				stacks		= keys.damage
			})
		end
	end
end

modifier_imba_visage_soul_assumption_charge_bar = class({})

function modifier_imba_visage_soul_assumption_charge_bar:IsBuff()			return false end
function modifier_imba_visage_soul_assumption_charge_bar:IsDebuff()			return false end
function modifier_imba_visage_soul_assumption_charge_bar:IsHidden() 		return true end
function modifier_imba_visage_soul_assumption_charge_bar:IsPurgable() 		return false end
function modifier_imba_visage_soul_assumption_charge_bar:IsPurgeException() 	return false end
function modifier_imba_visage_soul_assumption_charge_bar:GetAttributes()		return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_visage_soul_assumption_charge_bar:OnCreated(keys)
	if not IsServer() then return end
	self.damage_limit = self:GetAbility():GetSpecialValueFor("damage_limit")
	self.stack_limit = self:GetAbility():GetSpecialValueFor("stack_limit")
	local assumption_modifier = self:GetParent():FindModifierByNameAndCaster("modifier_imba_visage_soul_assumption_charge", self:GetCaster())
	local assumption_timer_modifier = self:GetParent():FindModifierByNameAndCaster("modifier_imba_visage_soul_assumption_charge_timer", self:GetCaster())
	self:SetStackCount(keys.stacks)
	if assumption_modifier and assumption_modifier.pfx and assumption_timer_modifier then
		assumption_timer_modifier:SetStackCount(assumption_timer_modifier:GetStackCount() + keys.stacks)
		--print("OnCreated pfx set ---charge  ---bar",assumption_timer_modifier:GetStackCount(),self:GetStackCount())
		for bar = 1, self.stack_limit do
			ParticleManager:SetParticleControl(assumption_modifier.pfx, bar, Vector(assumption_timer_modifier:GetStackCount() - (self.damage_limit * bar), 0, 0))
		end
	end
end

function modifier_imba_visage_soul_assumption_charge_bar:OnDestroy()
	if not IsServer() then return end
	local assumption_modifier = self:GetParent():FindModifierByNameAndCaster("modifier_imba_visage_soul_assumption_charge", self:GetCaster())
	local assumption_timer_modifier = self:GetParent():FindModifierByNameAndCaster("modifier_imba_visage_soul_assumption_charge_timer", self:GetCaster())
	if assumption_timer_modifier then
		assumption_timer_modifier:SetStackCount(assumption_timer_modifier:GetStackCount() - self:GetStackCount())
		if assumption_modifier and assumption_modifier.pfx then
			for bar = 1, self.stack_limit do
			--	print("Destroy pfx set ---charge  ---bar",assumption_modifier:GetStackCount(),self:GetStackCount())
				ParticleManager:SetParticleControl(assumption_modifier.pfx, bar, Vector(assumption_timer_modifier:GetStackCount() - (self.damage_limit * bar), 0, 0))
			end
		end
	end
end

modifier_imba_visage_soul_assumption_charge_timer = class({})

function modifier_imba_visage_soul_assumption_charge_timer:IsHidden()	return true end
function modifier_imba_visage_soul_assumption_charge_timer:IsPurgable()	return false end

--visage_summon_familiars 召唤佣兽
--召唤2只盲眼的佣兽为维萨吉作战，每提升一级额外多一只佣兽.
--佣兽无敌状态，无法选中，只会攻击visage攻击的目标. visage被缴械佣兽会受到相同结果.

--imba 侦查佣兽：每0.4秒 随机攻击一次范围内的敌人.这个技能只会有一只佣兽拥有.
--imba Level1: 获得寒霜攻击技能  降低目标移速和攻速
--imba Level2: 获得致命一击技能  20%几率暴击 200%伤害
--imba Level3: 获得灵魂攻击技能  17%几率剥离目标灵魂1.5s,使目标受到30%伤害加深.这个效果每4.5s触发一次.

--imba 神杖效果：
--召唤佣兽：
--Level4:获得100%溅射攻击技能

imba_visage_summon_familiars = class({})
imba_visage_summon_familiars.ability = {
	"venomancer_poison_sting",
	"chaos_knight_chaos_strike",
}

imba_visage_summon_familiars.attack_pfx = {
	"particles/econ/items/visage/immortal_familiar/visage_immortal_ti5/visage_familiar_base_attack_ti5.vpcf",
	"particles/econ/attack/attack_modifier_ti9.vpcf",
}

LinkLuaModifier("modifier_imba_visage_summon_familiars_caster","mb/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_summon_familiars_controller","mb/hero_visage", LUA_MODIFIER_MOTION_NONE)

function imba_visage_summon_familiars:IsHiddenWhenStolen() 			return false end
function imba_visage_summon_familiars:IsRefreshable() 				return true end
function imba_visage_summon_familiars:IsStealable() 				return false end
function imba_visage_summon_familiars:IsNetherWardStealable()		return false end
--function imba_visage_summon_familiars:GetAssociatedSecondaryAbilities() return "imba_visage_stone_form_self_cast" end
--2020 12 25 by MysticBug-------
function imba_visage_summon_familiars:OnInventoryContentsChanged()
	--神杖技能
	if self:GetCaster():HasScepter() then 
		local shard_abi = self:GetCaster():FindAbilityByName("imba_visage_silent_as_the_grave")
		if shard_abi then 
			shard_abi:SetHidden(false)
			shard_abi:SetLevel(self:GetLevel())
		end
	else
		local shard_abi = self:GetCaster():FindAbilityByName("imba_visage_silent_as_the_grave")
		if shard_abi then 
			shard_abi:SetHidden(true)
			shard_abi:SetLevel(0)
		end
	end
end
--[[function imba_visage_summon_familiars:OnUpgrade()
	local ability = self:GetCaster():FindAbilityByName("imba_visage_stone_form_self_cast")
	if ability then
		ability:SetLevel(self:GetLevel())
	end
end]]
function imba_visage_summon_familiars:OnSpellStart()
	local caster = self:GetCaster()
	local familiars_count = 1 + self:GetLevel() + caster:TG_GetTalentValue("special_bonus_imba_visage_4")
	--print("familiars_count",familiars_count)
	local familiars_ability = 1
	if self:GetLevel() > 1 and self:GetLevel() <= 3 then 
		familiars_ability = 2
	end
	local pos = caster:GetAbsOrigin() + (self:GetCaster():GetForwardVector() * RandomInt(150, 300))
	local caster_attackrange = caster:Script_GetAttackRange()
	--解除佣兽 召唤新佣兽
	if self.familiars_table then
		for i = 1, #self.familiars_table do
			if self.familiars_table[i] and EntIndexToHScript(self.familiars_table[i]) and not EntIndexToHScript(self.familiars_table[i]):IsNull() and EntIndexToHScript(self.familiars_table[i]):IsAlive() then
				EntIndexToHScript(self.familiars_table[i]):RemoveSelf()
			end
		end
	end
	--清空
	self.familiars_table = {}
	--召唤
	for i = 1, familiars_count do
		local unit = CreateUnitByName("npc_dota_visage_familiar"..math.min(self:GetLevel(), 3), pos, true, caster, caster, caster:GetTeamNumber())
		FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
		--设置属性
		SetCreatureHealth(unit, self:GetSpecialValueFor("familiar_hp"), true)
		unit:SetPhysicalArmorBaseValue(1 + self:GetSpecialValueFor("familiar_armor"))
		unit:SetBaseMoveSpeed(self:GetSpecialValueFor("familiar_speed"))
		unit:SetBaseDamageMin(self:GetSpecialValueFor("familiar_attack_damage"))
		unit:SetBaseDamageMax(self:GetSpecialValueFor("familiar_attack_damage"))

		unit:SetOwner(self:GetCaster())
		unit:SetTeam(self:GetCaster():GetTeam())
		--设置控制权
		unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
		--添加技能
		for j=1, familiars_ability do
			local ability = unit:AddAbility(self.ability[j])
			if ability then
				ability:SetLevel(self:GetLevel() + 1)
				ability:SetHidden(false)
			end
		end
		if caster:HasScepter() then 
			local ability = unit:AddAbility("imba_visage_soul_attack")
			if ability then
				ability:SetLevel(1)
				ability:SetHidden(false)
			end
		end
		--升级石化形态
		local stone_abi = unit:FindAbilityByName("visage_summon_familiars_stone_form")
		if stone_abi then
			stone_abi:SetLevel(self:GetLevel())
		end
		--佣兽状态 飞行 无敌 穿越单位 无法选中 没有血条
		unit:AddNewModifier(caster, self, "modifier_imba_visage_summon_familiars_caster", {familiars_patrol = i , attack_range = caster_attackrange , familiars_attack_pfx = self.attack_pfx[RandomInt(1,#self.attack_pfx)]})
		--跟随
		unit:MoveToNPC(caster)
		--入列
		table.insert(self.familiars_table,unit:entindex())
	end
	-------------------------------------------------------------------
	caster:EmitSound("Hero_Visage.SummonFamiliars.Cast")
	--被动控制佣兽
	if not caster:HasModifier("modifier_imba_visage_summon_familiars_controller") then 
		caster:AddNewModifier(caster, self, "modifier_imba_visage_summon_familiars_controller", {})
	end
end

--佣兽状态
modifier_imba_visage_summon_familiars_caster = class({})

function modifier_imba_visage_summon_familiars_caster:IsDebuff()			return false end
function modifier_imba_visage_summon_familiars_caster:IsHidden() 			return true end
function modifier_imba_visage_summon_familiars_caster:IsPurgable() 			return false end
function modifier_imba_visage_summon_familiars_caster:IsPurgeException() 	return false end
function modifier_imba_visage_summon_familiars_caster:RemoveOnDeath() 		return true end
function modifier_imba_visage_summon_familiars_caster:OnCreated(keys)
	if not IsServer() then return end
		self.patrol = keys.familiars_patrol
		self.attack_range = keys.attack_range
		self.attack_pfx = keys.familiars_attack_pfx
		self:StartIntervalThink(0.4)
end

function modifier_imba_visage_summon_familiars_caster:OnIntervalThink()
	if not IsServer() then return end
	-- 如果是侦查兵 
	if self.patrol == 1 and not self:GetParent():HasModifier("modifier_visage_silent_as_the_grave") then 
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(), 
			self:GetParent():GetAbsOrigin(), 
			nil, 
			self.attack_range, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, 
			FIND_FARTHEST, 
			false)
		for _, enemy in pairs(enemies) do
			--攻击一次
			if not enemy:IsInvisible() and not enemy:IsInvulnerable() then
				self:GetParent():PerformAttack(enemy, false, true, true, false, true, false, false) 
				break
			end
		end
	end
	-- 离维吉萨太远就传送
	if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() >= 600 then
		self:GetParent():SetAbsOrigin(GetGroundPosition(self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * RandomInt(150, 300)), self:GetParent()))
	end
end

--飞行 穿越单位 无法选中 移除生命血条 无敌
function modifier_imba_visage_summon_familiars_caster:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, --拥有飞机穿越地形的能力，但是算作地面单位  
		[MODIFIER_STATE_FLYING] = false,	-- 飞行
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true, --穿越单位
		[MODIFIER_STATE_INVULNERABLE] = true, --无敌
		[MODIFIER_STATE_NO_HEALTH_BAR] = true, --移除生命血条
		[MODIFIER_STATE_UNSELECTABLE] = true, --无法被选中
	}
	return state
end

function modifier_imba_visage_summon_familiars_caster:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,MODIFIER_PROPERTY_PROJECTILE_NAME,MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_visage_summon_familiars_caster:GetModifierAttackRangeBonus() 
	if not IsServer() then return end 
	return (self.attack_range <= self:GetParent():GetBaseAttackRange()) and 0 or (self.attack_range - self:GetParent():GetBaseAttackRange())
end
function modifier_imba_visage_summon_familiars_caster:GetModifierProjectileName() if not IsServer() then return end return self.attack_pfx end
function modifier_imba_visage_summon_familiars_caster:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	if self:GetCaster():TG_HasTalent("special_bonus_imba_visage_5") then 
			local talent_dmg = self:GetCaster():GetIntellect() * self:GetCaster():TG_GetTalentValue("special_bonus_imba_visage_5")/100/2
		ApplyDamage({
				victim = keys.target,
				attacker = self:GetParent(),
				damage = talent_dmg,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = self:GetAbility(), --Optional.
			}
		)
	end
end

modifier_imba_visage_summon_familiars_controller = class({})

function modifier_imba_visage_summon_familiars_controller:IsHidden() return true end
function modifier_imba_visage_summon_familiars_controller:IsDebuff() return false end
function modifier_imba_visage_summon_familiars_controller:IsPurgable() return false end
function modifier_imba_visage_summon_familiars_controller:RemoveOnDeath()	return true end
function modifier_imba_visage_summon_familiars_controller:OnCreated( keys )
	if not IsServer() then return end
		self:StartIntervalThink(0.3)
end
function modifier_imba_visage_summon_familiars_controller:OnIntervalThink()
	if not IsServer() then return end
	--如果不能攻击就停止佣兽
	if self:GetParent():IsStunned() or self:GetParent():HasModifier("modifier_imba_heavens_halberd_active") or self:GetParent():HasModifier("modifier_imba_sheepstick_debuff") or self:GetParent():HasModifier("modifier_imba_lion_hex") or self:GetParent():HasModifier("modifier_tg_ss_magica_ani") then
		local familiars_table = self:GetAbility().familiars_table
		for i = 1, #familiars_table do
			if familiars_table[i] and EntIndexToHScript(familiars_table[i]) and not EntIndexToHScript(familiars_table[i]):IsNull() and EntIndexToHScript(familiars_table[i]):IsAlive() then
				EntIndexToHScript(familiars_table[i]):Stop()
				EntIndexToHScript(familiars_table[i]):MoveToNPC(self:GetParent())
			end
		end
	end 
end

function modifier_imba_visage_summon_familiars_controller:DeclareFunctions() return {MODIFIER_EVENT_ON_ORDER,MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_imba_visage_summon_familiars_controller:OnOrder( params )
	if params.unit~=self:GetParent() then return end
	local familiars_table = self:GetAbility().familiars_table
	-- right click, force attack
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		--follow visage
		if familiars_table then
			for i = 1, #familiars_table do
				if familiars_table[i] and EntIndexToHScript(familiars_table[i]) and not EntIndexToHScript(familiars_table[i]):IsNull() and EntIndexToHScript(familiars_table[i]):IsAlive() then
					--EntIndexToHScript(familiars_table[i]):Stop()
					EntIndexToHScript(familiars_table[i]):MoveToNPC(self:GetParent())
				end
			end
		end
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET then 
			--attack target
			if familiars_table then
				--[[if self:GetParent():HasModifier("modifier_imba_heavens_halberd_active") or self:GetParent():HasModifier("modifier_imba_sheepstick_debuff") or self:GetParent():HasModifier("modifier_imba_lion_hex") or self:GetParent():HasModifier("modifier_tg_ss_magica_ani") then 
					for i = 1, #familiars_table do
						if familiars_table[i] and EntIndexToHScript(familiars_table[i]) and not EntIndexToHScript(familiars_table[i]):IsNull() and EntIndexToHScript(familiars_table[i]):IsAlive() then
							EntIndexToHScript(familiars_table[i]):Stop()
							EntIndexToHScript(familiars_table[i]):MoveToNPC(self:GetParent())
						end
					end
				else]]
					for i = 1, #familiars_table do
						if familiars_table[i] and EntIndexToHScript(familiars_table[i]) and not EntIndexToHScript(familiars_table[i]):IsNull() and EntIndexToHScript(familiars_table[i]):IsAlive() then
							--EntIndexToHScript(familiars_table[i]):SetAttacking(params.target)
							--EntIndexToHScript(familiars_table[i]):Stop()
							EntIndexToHScript(familiars_table[i]):MoveToTargetToAttack(params.target)
						end
					end
				--end
			end
	elseif
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION or 
		params.order_type==DOTA_UNIT_ORDER_STOP then
			--stop or hold 
			if familiars_table then
				for i = 1, #familiars_table do
					if familiars_table[i] and EntIndexToHScript(familiars_table[i]) and not EntIndexToHScript(familiars_table[i]):IsNull() and EntIndexToHScript(familiars_table[i]):IsAlive() then
						EntIndexToHScript(familiars_table[i]):Stop()
						EntIndexToHScript(familiars_table[i]):MoveToNPC(self:GetParent())
						--Hold() 不知道为啥 直接不动了
					end
				end
			end
	end
end

function modifier_imba_visage_summon_familiars_controller:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	if self:GetCaster():TG_HasTalent("special_bonus_imba_visage_5") then 
			local talent_dmg = self:GetCaster():GetIntellect() * self:GetCaster():TG_GetTalentValue("special_bonus_imba_visage_5")/100
		ApplyDamage({
				victim = keys.target,
				attacker = self:GetParent(),
				damage = talent_dmg,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = self:GetAbility(), --Optional.
			}
		)
	end
end

function modifier_imba_visage_summon_familiars_controller:OnRemoved()
	self:Destroy()
end
function modifier_imba_visage_summon_familiars_controller:OnDestroy()
	if not IsServer() then return end
	--when death 
	local familiars_table = self:GetAbility().familiars_table
	if familiars_table then
		for i = 1, #familiars_table do
			if familiars_table[i] and EntIndexToHScript(familiars_table[i]) and not EntIndexToHScript(familiars_table[i]):IsNull() and EntIndexToHScript(familiars_table[i]):IsAlive() then
				--EntIndexToHScript(familiars_table[i]):ForceKill(false)
				EntIndexToHScript(familiars_table[i]):RemoveSelf()
			end
		end
	end
end

--灵魂攻击
imba_visage_soul_attack = class({})
LinkLuaModifier("modifier_imba_visage_soul_attack_passive", "mb/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_soul_attack_debuff", "mb/hero_visage", LUA_MODIFIER_MOTION_NONE)

function imba_visage_soul_attack:GetIntrinsicModifierName() return "modifier_imba_visage_soul_attack_passive" end
modifier_imba_visage_soul_attack_passive = class({})

function modifier_imba_visage_soul_attack_passive:IsDebuff()			return false end
function modifier_imba_visage_soul_attack_passive:IsHidden() 			return true end
function modifier_imba_visage_soul_attack_passive:IsPurgable() 		return false end
function modifier_imba_visage_soul_attack_passive:IsPurgeException() 	return false end
function modifier_imba_visage_soul_attack_passive:DeclareFunctions()	return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_imba_visage_soul_attack_passive:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() or keys.target:IsMagicImmune() then
		return
	end
	if self:GetAbility():IsCooldownReady() and PseudoRandom:RollPseudoRandom(self:GetAbility(), self:GetAbility():GetSpecialValueFor("soul_chance")) then
		ApplyDamage({
				victim = keys.target,
				attacker = self:GetParent(),
				damage = self:GetAbility():GetSpecialValueFor("soul_damage"),
				damage_type = self:GetAbility():GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = self:GetAbility(), --Optional.
			}
		)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self:GetAbility():GetSpecialValueFor("soul_damage"), nil)
		--灵魂剥离
		keys.target:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_imba_visage_soul_attack_debuff", {duration = self:GetAbility():GetSpecialValueFor("soul_duration")})		
		self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(-1)) * self:GetParent():GetCooldownReduction())
	end
end

modifier_imba_visage_soul_attack_debuff = class({})

function modifier_imba_visage_soul_attack_debuff:IsDebuff()			return true end
function modifier_imba_visage_soul_attack_debuff:IsHidden() 			return false end
function modifier_imba_visage_soul_attack_debuff:IsPurgable() 			return false end
function modifier_imba_visage_soul_attack_debuff:CheckState() 			return {[MODIFIER_STATE_STUNNED] = true,[MODIFIER_STATE_ROOTED] = true,[MODIFIER_STATE_FROZEN] = true} end
function modifier_imba_visage_soul_attack_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end
function modifier_imba_visage_soul_attack_debuff:GetModifierIncomingDamage_Percentage() return self.incomingdamage_pct end
--function modifier_imba_visage_soul_attack_debuff:GetEffectName() return "particles/items3_fx/glimmer_cape_initial.vpcf" end
function modifier_imba_visage_soul_attack_debuff:GetEffectName()  return "particles/items_fx/ethereal_blade.vpcf" end
function modifier_imba_visage_soul_attack_debuff:GetEffectAttachType() return PATTACH_POINT_FOLLOW end
function modifier_imba_visage_soul_attack_debuff:OnCreated(keys)
	if IsServer() then
		self.incomingdamage_pct = self:GetAbility():GetSpecialValueFor("incomingdamage_pct")
		--击中特效
		--local pfx_name = "particles/items_fx/ethereal_blade.vpcf"
		----------------------------------------------------------------------------------------------
		--local pfx = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement(pfx_name, self:GetParent()), PATTACH_CUSTOMORIGIN, self:GetParent())
		--ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		--ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_CUSTOMORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
		--ParticleManager:ReleaseParticleIndex(pfx)
	end
end
function modifier_imba_visage_soul_attack_debuff:OnDestroy()
	if IsServer() then 
		self.incomingdamage_pct = nil
	end
end

--石像形态 魔晶技能
imba_visage_stone_form_self_cast = class({})
LinkLuaModifier("modifier_imba_visage_stone_form_self_cast", "mb/hero_visage", LUA_MODIFIER_MOTION_NONE)
function imba_visage_stone_form_self_cast:IsHiddenWhenStolen() 			return false end
function imba_visage_stone_form_self_cast:IsRefreshable() 				return true end
function imba_visage_stone_form_self_cast:IsStealable() 				return true end
function imba_visage_stone_form_self_cast:IsNetherWardStealable()		return false end
--function imba_visage_stone_form_self_cast:GetAssociatedPrimaryAbilities() return "imba_visage_summon_familiars" end
function imba_visage_stone_form_self_cast:OnSpellStart()
	local caster = self:GetCaster()
	local sound_cast = "Visage_Familar.StoneForm.Cast"
	-- 音效
	EmitSoundOn( sound_cast, self:GetCaster() )	
	-- 自身石化 无敌 回血
	caster:AddNewModifier(caster, self, "modifier_imba_visage_stone_form_self_cast", {duration = self:GetSpecialValueFor("stone_duration")})
	--visage_summon_familiars_stone_form
	local primary_abi = caster:FindAbilityByName("imba_visage_summon_familiars")
	if primary_abi then 
		local familiars_table = primary_abi.familiars_table
		if familiars_table then
			for i = 1, #familiars_table do
				if familiars_table[i] and EntIndexToHScript(familiars_table[i]) and not EntIndexToHScript(familiars_table[i]):IsNull() and EntIndexToHScript(familiars_table[i]):IsAlive() then
					local stone_abi = EntIndexToHScript(familiars_table[i]):FindAbilityByName("visage_summon_familiars_stone_form")
					if stone_abi then
						stone_abi:OnSpellStart()
					end
				end
			end
		end
	end
	-- 延时造成伤害和眩晕
	Timers:CreateTimer(self:GetSpecialValueFor("stun_delay"),function()
		-- 范围造成眩晕 伤害 
		local enemies = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				caster:GetAbsOrigin(), 
				nil, 
				self:GetSpecialValueFor("stun_radius"), 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				0, 
				FIND_ANY_ORDER, 
				false)
			for _, enemy in pairs(enemies) do
				--眩晕 
				enemy:AddNewModifier_RS(caster, self, "modifier_imba_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
				--伤害
				ApplyDamage({
						attacker = caster, 
						victim = enemy, 
						damage = self:GetSpecialValueFor("stun_damage"), 
						ability = self, 
						damage_type = self:GetAbilityDamageType()
					}
				)
				enemy:EmitSound("Visage_Familar.StoneForm.Stun")
			end
		return nil 
	end)
end

modifier_imba_visage_stone_form_self_cast = class({})

function modifier_imba_visage_stone_form_self_cast:IsDebuff()			return false end
function modifier_imba_visage_stone_form_self_cast:IsBuff()				return true end
function modifier_imba_visage_stone_form_self_cast:IsHidden() 			return false end
function modifier_imba_visage_stone_form_self_cast:IsPurgable() 		return false end
function modifier_imba_visage_stone_form_self_cast:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_UNSELECTABLE] = true, [MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FROZEN] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true} end
function modifier_imba_visage_stone_form_self_cast:GetStatusEffectName() return "particles/status_fx/status_effect_earth_spirit_petrify.vpcf" end
function modifier_imba_visage_stone_form_self_cast:StatusEffectPriority() return 20 end
-- 回血
function modifier_imba_visage_stone_form_self_cast:OnCreated()
	if IsServer() then 
		self.hp_regen = self:GetAbility():GetSpecialValueFor("hp_regen")
		self.stone_pfx_name = "particles/units/heroes/hero_visage/visage_stoneform_overhead_timer.vpcf"
		self:StartIntervalThink(1)
	end
end

function modifier_imba_visage_stone_form_self_cast:OnIntervalThink()
	if not IsServer() then return end
	self.stone_pfx = ParticleManager:CreateParticleForTeam(self.stone_pfx_name, PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetParent():GetTeamNumber())
	ParticleManager:SetParticleControl(self.stone_pfx, 1, Vector(0, math.ceil(self:GetRemainingTime()), 0))
	ParticleManager:SetParticleControl(self.stone_pfx, 2, Vector(1, 0, 0))
	ParticleManager:ReleaseParticleIndex(self.stone_pfx)
end

function modifier_imba_visage_stone_form_self_cast:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT} end
function modifier_imba_visage_stone_form_self_cast:GetModifierConstantHealthRegen() return self.hp_regen end
function modifier_imba_visage_stone_form_self_cast:OnDestroy()
	if IsServer() then 
		self.hp_regen = nil 
		self.stone_pfx_name = nil
		self.stone_pfx = nil
	end
end

--神杖技能
imba_visage_silent_as_the_grave = class({})

function imba_visage_silent_as_the_grave:IsHiddenWhenStolen() 			return false end
function imba_visage_silent_as_the_grave:IsRefreshable() 				return true end
function imba_visage_silent_as_the_grave:IsStealable() 				return true end
function imba_visage_silent_as_the_grave:IsNetherWardStealable()		return false end
function imba_visage_silent_as_the_grave:OnSpellStart()
	local caster = self:GetCaster()
	-- local sound_cast = "Visage_Familar.StoneForm.Cast"
	-- 音效
	-- EmitSoundOn( sound_cast, self:GetCaster() )	
	-- 维萨吉和佣兽变为隐形
	caster:AddNewModifier(caster, self, "modifier_visage_silent_as_the_grave", {duration = self:GetSpecialValueFor("invis_duration")})
	--visage_summon_familiars_stone_form
	local primary_abi = caster:FindAbilityByName("imba_visage_summon_familiars")
	if primary_abi then 
		local familiars_table = primary_abi.familiars_table
		if familiars_table then
			for i = 1, #familiars_table do
				if familiars_table[i] and EntIndexToHScript(familiars_table[i]) and not EntIndexToHScript(familiars_table[i]):IsNull() and EntIndexToHScript(familiars_table[i]):IsAlive() then
					EntIndexToHScript(familiars_table[i]):AddNewModifier(caster, self, "modifier_visage_silent_as_the_grave", {duration = self:GetSpecialValueFor("invis_duration")})
				end
			end
		end
	end
end