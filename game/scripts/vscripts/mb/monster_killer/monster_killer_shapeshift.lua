-- Editors:
-- MysticBug, 25.09.2021
------------------------------------------------------------
--		   		 MONSTER_KILLER_HOLY_WATER_BULLET         --
------------------------------------------------------------
monster_killer_shapeshift=class({})

LinkLuaModifier("modifier_monster_killer_shapeshift_pa", "mb/monster_killer/monster_killer_shapeshift.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monster_killer_shapeshift_buff", "mb/monster_killer/monster_killer_shapeshift.lua", LUA_MODIFIER_MOTION_NONE)

function monster_killer_shapeshift:IsHiddenWhenStolen() return false end
function monster_killer_shapeshift:IsStealable() return true end
function monster_killer_shapeshift:IsRefreshable() 	return true end
function monster_killer_shapeshift:GetIntrinsicModifierName() return "modifier_monster_killer_shapeshift_pa" end
function monster_killer_shapeshift:OnSpellStart()
    local caster   = self:GetCaster()
    local pos      = caster:GetAbsOrigin()
    local duration = self:GetSpecialValueFor("duration")
    EmitSoundOn("Hero_Lycan.Shapeshift.Cast", caster)
    local particle= ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW,caster)
    ParticleManager:SetParticleControl(particle, 0,pos)
    ParticleManager:ReleaseParticleIndex(particle)
    caster:AddNewModifier(caster, self, "modifier_monster_killer_shapeshift_buff", {duration = duration})
end

------------------------------------------------------------
modifier_monster_killer_shapeshift_pa = class({})

function modifier_monster_killer_shapeshift_pa:IsDebuff()			return false end
function modifier_monster_killer_shapeshift_pa:IsHidden() 			if self:GetAbility():GetLevel() > 0 then return false else return true end end
function modifier_monster_killer_shapeshift_pa:IsPurgable() 		return false end
function modifier_monster_killer_shapeshift_pa:IsPurgeException()	return false end
function modifier_monster_killer_shapeshift_pa:DeclareFunctions() 	return {MODIFIER_EVENT_ON_DEATH,MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_monster_killer_shapeshift_pa:OnDeath(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or self:GetParent():HasModifier("modifier_monster_killer_shapeshift_buff") then
		return
	end
	if keys.unit:IsBuilding() or keys.unit:IsOther() then
		return
	end
	local unit         = keys.unit
	local caster       = self:GetParent()
	local ability      = self:GetAbility()
	local boss_stack   = ability:GetSpecialValueFor("boss_stack")
	local masses_stack = ability:GetSpecialValueFor("masses_stack")
	local max_stack    = ability:GetSpecialValueFor("max_stack")
	--添加肾上腺激素
	if unit:IsRealHero() then--unit:IsElite() then
		if not GameRules:IsDaytime() then
			self:SetStackCount(self:GetStackCount() + boss_stack)
		else
			self:SetStackCount(self:GetStackCount() + boss_stack * 2)
		end
	else
		if not GameRules:IsDaytime() then
			self:SetStackCount(self:GetStackCount() + masses_stack * 1)
		else
			self:SetStackCount(self:GetStackCount() + masses_stack * 2)
		end
	end
	--Check Stack
	if self:GetStackCount() > max_stack then
		self:SetStackCount(max_stack)
	end
end

function modifier_monster_killer_shapeshift_pa:OnAbilityFullyCast( keys )
	if IsServer() then
		--Filter
		local max_stack    = self:GetAbility():GetSpecialValueFor("max_stack")
		if self:GetAbility():GetLevel() <= 0 or keys.unit ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetStackCount() < max_stack  or self:GetParent():HasModifier("modifier_monster_killer_shapeshift_buff") then
			return
		end
		if keys.ability and not string.find(keys.ability:GetAbilityName(), "item_") then
			--Cast Shapeshift
			self:GetAbility():OnSpellStart()
			self:SetStackCount(0)
		end
	end
end

------------------------------------------------------------
modifier_monster_killer_shapeshift_buff = class({})

function modifier_monster_killer_shapeshift_buff:IsHidden() 			return false end
function modifier_monster_killer_shapeshift_buff:IsPurgable() 			return false end
function modifier_monster_killer_shapeshift_buff:IsPurgeException() 	return false end
function modifier_monster_killer_shapeshift_buff:GetEffectName() return "particles/units/heroes/hero_lycan/lycan_monster_killer_shapeshift_buff.vpcf" end
function modifier_monster_killer_shapeshift_buff:RemoveOnDeath() 	return false end
function modifier_monster_killer_shapeshift_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_monster_killer_shapeshift_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE
    }
end

function modifier_monster_killer_shapeshift_buff:GetModifierModelChange()
    return "models/items/lycan/ultimate/blood_moon_hunter_shapeshift_form/blood_moon_hunter_shapeshift_form.vmdl"
end
function modifier_monster_killer_shapeshift_buff:GetAttackSound() return "Hero_Lycan.Attack" end
function modifier_monster_killer_shapeshift_buff:AllowIllusionDuplicate() return true end
function modifier_monster_killer_shapeshift_buff:OnCreated()
    self.crit               = {}
    self.parent             = self:GetParent()
    self.ability            = self:GetAbility()
    self.caster             = self:GetCaster()
    self.crit_multiplier    = self.ability:GetSpecialValueFor("crit_multiplier")
    self.crit_chance        = self.ability:GetSpecialValueFor("crit_chance")
    self.speed              = self.ability:GetSpecialValueFor("speed")
    self.night_vision       = self.ability:GetSpecialValueFor("bonus_night_vision")
    self.health_bonus       = self.ability:GetSpecialValueFor("health_bonus")
    self.attack_time        = self.ability:GetSpecialValueFor("attack_time")
    self.attack_range_limit = self.ability:GetSpecialValueFor("attack_range_limit")
end

function modifier_monster_killer_shapeshift_buff:OnRefresh() self:OnCreated() end
function modifier_monster_killer_shapeshift_buff:OnDestroy()
    self.crit = nil
    if not IsServer() then
        return
    end
    local particle= ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf", PATTACH_ABSORIGIN_FOLLOW,self.parent)
    ParticleManager:SetParticleControl(particle, 0,self.parent:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 3,self.parent:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
end


function modifier_monster_killer_shapeshift_buff:GetModifierPreAttack_CriticalStrike(keys)
    if not IsServer() then
		return
	end
    if keys.attacker == self.parent and not keys.target:IsBuilding() and not self.parent:IsIllusion() then
        if RollPseudoRandomPercentage(self.crit_chance,0,self.parent) then
            self.crit[keys.record] = true
            return  self.crit_multiplier
		else
			return 0
		end
	end
end


function modifier_monster_killer_shapeshift_buff:OnAttackFail(keys)
    if not IsServer() then
        return
    end
    self.crit[keys.record] = nil
end

function modifier_monster_killer_shapeshift_buff:GetModifierIgnoreMovespeedLimit() return 1 end
function modifier_monster_killer_shapeshift_buff:GetModifierMoveSpeedBonus_Constant() 	return  self.speed end
function modifier_monster_killer_shapeshift_buff:GetBonusNightVision() 	return  self.speed end
function modifier_monster_killer_shapeshift_buff:GetModifierHealthBonus() 	return  self.health_bonus end
function modifier_monster_killer_shapeshift_buff:GetModifierBaseAttackTimeConstant() 	return  self.attack_time end
function modifier_monster_killer_shapeshift_buff:GetModifierAttackRangeOverride() 	return  self.attack_range_limit end
function modifier_monster_killer_shapeshift_buff:CheckState()
    return
    {
        [MODIFIER_STATE_UNSLOWABLE] = true,
    }
end
