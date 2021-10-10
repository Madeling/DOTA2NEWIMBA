item_imba_heart = class({})
LinkLuaModifier("modifier_imba_heart_passive", "ting/items/item_roshan_heart", LUA_MODIFIER_MOTION_NONE)

function item_imba_heart:GetIntrinsicModifierName() return "modifier_imba_heart_passive" end
modifier_imba_heart_passive = class({})
function modifier_imba_heart_passive:IsDebuff()			return false end
function modifier_imba_heart_passive:IsHidden() 			return true end
function modifier_imba_heart_passive:IsPurgable() 		return false end
function modifier_imba_heart_passive:IsPurgeException() 	return false end
function modifier_imba_heart_passive:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_BONUS,MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE} end
function modifier_imba_heart_passive:OnCreated()
	if self:GetAbility() == nil then
		return
	end
	self.ab = self:GetAbility()
	self.hp_re = self.ab:GetSpecialValueFor("hp_re")
	self.hp = self.ab:GetSpecialValueFor("hp")
end
function modifier_imba_heart_passive:GetModifierHealthRegenPercentage()
	return self.hp_re
end
function modifier_imba_heart_passive:GetModifierHealthBonus()
	return self.hp
end
item_imba_aegis_heart = class({})
LinkLuaModifier("modifier_imba_aegis_heart_passive", "ting/items/item_roshan_heart", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slow", "ting/items/item_roshan_heart", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hp_bonus", "ting/items/item_roshan_heart", LUA_MODIFIER_MOTION_NONE)
function item_imba_aegis_heart:GetIntrinsicModifierName() return "modifier_imba_aegis_heart_passive" end
function item_imba_aegis_heart:IsRefreshable() return false end

function item_imba_aegis_heart:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("RoshanDT.Death2")
	local particle = ParticleManager:CreateParticle("particles/neutral_fx/roshan_spawn.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	local pfx = ParticleManager:CreateParticle("particles/neutral_fx/roshan_slam.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 3, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)
	caster:StartGesture(ACT_DOTA_TELEPORT_END)
	local health_c = math.min(1.3 - caster:GetHealth()/caster:GetMaxHealth(),1)
	if health_c<1 then 
		caster:Purge(false, true, false, false, false)
	else 
		caster:Purge(false, true, false, true, true)
	end
	
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do 
	local Knockback ={
          should_stun = 0.01, --打断
          knockback_duration = 0.5, --击退时间 减去不能动的时间就是太空步的时间
          duration = 0.5, --不能动的时间
          knockback_distance = math.max(self:GetSpecialValueFor("max_Dis")*health_c - (caster:GetAbsOrigin() - enemy:GetAbsOrigin()):Length2D(), 250), --击退距离
          knockback_height = 400,	--击退高度
          center_x =  caster:GetAbsOrigin().x,	--施法者为中心
          center_y =  caster:GetAbsOrigin().y,
          center_z =  caster:GetAbsOrigin().z,
      }
		enemy:AddNewModifier(enemy, self, "modifier_knockback", Knockback)  --白牛的击退
		local modifier = enemy:AddNewModifier(enemy, self, "modifier_slow", {duration = 2})  --白牛的击退
		local stack = math.max(math.ceil(health_c*100),40)
		modifier:SetStackCount(stack)
	end
end

modifier_slow = class({})
function modifier_slow:IsDebuff()			return true end
function modifier_slow:IsHidden() 			return false end
function modifier_slow:IsPurgable() 		return false end
function modifier_slow:IsPurgeException() 	return false end
function modifier_slow:DeclareFunctions()	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_slow:GetModifierMoveSpeedBonus_Percentage() return -self:GetStackCount() end
function modifier_slow:GetTexture()			return "item_aegis_heart" end

modifier_imba_aegis_heart_passive = class({})
LinkLuaModifier("modifier_hp_bonus", "ting/items/item_roshan_heart", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_aegis_heart_passive:IsDebuff()			return false end
function modifier_imba_aegis_heart_passive:IsHidden() 			return true end
function modifier_imba_aegis_heart_passive:IsPurgable() 		return false end
function modifier_imba_aegis_heart_passive:IsPurgeException() 	return false end
function modifier_imba_aegis_heart_passive:DeclareFunctions() 
	return 
	{
		MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE,
		MODIFIER_PROPERTY_RESPAWNTIME_STACKING,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
	} 
end

function modifier_imba_aegis_heart_passive:OnCreated()
	if self:GetAbility() == nil then
		return
	end
	self.ab = self:GetAbility()
	self.str = self.ab:GetSpecialValueFor("str")
	self.hp_re = self.ab:GetSpecialValueFor("hp_re")
	self.re = self.ab:GetSpecialValueFor("re")
	self.radius = self.ab:GetSpecialValueFor("radius")
	self.hp2 = self.ab:GetSpecialValueFor("hp_b2")
end

function modifier_imba_aegis_heart_passive:GetModifierBonusStats_Strength()
	return self.str
end

function modifier_imba_aegis_heart_passive:GetModifierHealthRegenPercentage()
	return self.hp_re
end

function modifier_imba_aegis_heart_passive:GetModifierPercentageRespawnTime() 
	return self.re*0.01
end

function modifier_imba_aegis_heart_passive:GetModifierExtraHealthBonus()
	return self.hp2
end

function modifier_imba_aegis_heart_passive:OnRespawn(keys)
	if IsServer() and keys.unit==self:GetParent() and keys.unit:IsRealHero() then 
	self:GetAbility():EndCooldown() 
	end
end

function modifier_imba_aegis_heart_passive:IsAura() return true end
function modifier_imba_aegis_heart_passive:GetAuraDuration() return 0 end
function modifier_imba_aegis_heart_passive:GetModifierAura() return "modifier_hp_bonus" end
function modifier_imba_aegis_heart_passive:GetAuraRadius() return self.radius end
function modifier_imba_aegis_heart_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_aegis_heart_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_aegis_heart_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_hp_bonus = class({})
function modifier_hp_bonus:IsDebuff()			return false end
function modifier_hp_bonus:IsHidden() 			return false end
function modifier_hp_bonus:IsPurgable() 		return false end
function modifier_hp_bonus:IsPurgeException() 	return false end
function modifier_hp_bonus:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_BONUS,MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS} end
function modifier_hp_bonus:GetTexture()			return "item_aegis_heart" end
function modifier_hp_bonus:OnCreated()
	if self:GetAbility() == nil then
		return
	end
	self.ab = self:GetAbility()
	if not IsServer() then return end
	if self:GetParent():IsHero() then
	self.hp = self.ab:GetSpecialValueFor("hp_b")
	self.hp2 = 0
	else
	self.hp = 0
	self.hp2 = self.ab:GetSpecialValueFor("hp_b2")
	end
end
function modifier_hp_bonus:GetModifierExtraHealthBonus()
	return self.hp2
end
function modifier_hp_bonus:GetModifierHealthBonus()
	return self.hp
end


