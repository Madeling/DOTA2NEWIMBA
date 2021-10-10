-- Author: MouJiaoZi 01/08/2018
-- Arrangement: MysticBug 02/13/2021
--------------------------------

imba_rubick_telekinesis_land = class({})

LinkLuaModifier("modifier_imba_telekinesis_pfx", "mb/hero_rubick/rubick_telekinesis_land", LUA_MODIFIER_MOTION_NONE)

function imba_rubick_telekinesis_land:IsHiddenWhenStolen() 		return false end
function imba_rubick_telekinesis_land:IsRefreshable() 			return true end
function imba_rubick_telekinesis_land:IsStealable() 			return false end
function imba_rubick_telekinesis_land:IsNetherWardStealable()	return false end
function imba_rubick_telekinesis_land:GetCastRange()
	if IsServer() then
		return 50000
	else
		return self:GetCaster():GetModifierStackCount("modifier_imba_telekinesis_range", nil) == 1 and self:GetSpecialValueFor("ally_land_distance") or self:GetSpecialValueFor("enemy_land_distance")
	end
end

function imba_rubick_telekinesis_land:GetAOERadius() return self:GetSpecialValueFor("landing_stun_radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_rubick_3") end
function imba_rubick_telekinesis_land:OnSpellStart()
	local buff = self:GetCaster():FindModifierByName("modifier_imba_telekinesis_range")
	local max_distance = buff:GetStackCount() == 1 and self:GetSpecialValueFor("ally_land_distance") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_rubick_3") or self:GetSpecialValueFor("enemy_land_distance") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_rubick_3")
	local talent = self:GetCaster():FindAbilityByName("special_bonus_unique_rubick")
	if talent then
		max_distance = max_distance + talent:GetSpecialValueFor("value")
	end
	local target_buff = self:GetCaster():FindAbilityByName("imba_rubick_telekinesis").buff
	if target_buff == nil or target_buff:IsNull() then 
		return
	end
	local pos
	if (self:GetCursorPosition() - target_buff:GetParent():GetAbsOrigin()):Length2D() > max_distance then
		pos = target_buff:GetParent():GetAbsOrigin() + (self:GetCursorPosition() - target_buff:GetParent():GetAbsOrigin()):Normalized() * max_distance
	else
		pos = self:GetCursorPosition()
	end
	target_buff.pos = GetGroundPosition(pos, nil)
	if not self.pfx then
		self.pfx = CreateModifierThinker(target_buff:GetParent(), self, "modifier_imba_telekinesis_pfx", {duration = target_buff:GetRemainingTime()}, pos, self:GetCaster():GetTeamNumber(), false)
	else
		self.pfx:FindModifierByName("modifier_imba_telekinesis_pfx"):SetStackCount(1)
		self.pfx:FindModifierByName("modifier_imba_telekinesis_pfx"):Destroy()
		self.pfx = CreateModifierThinker(target_buff:GetParent(), self, "modifier_imba_telekinesis_pfx", {duration = target_buff:GetRemainingTime()}, pos, self:GetCaster():GetTeamNumber(), false)
	end
end

modifier_imba_telekinesis_pfx = class({})

function modifier_imba_telekinesis_pfx:CheckState() return {[MODIFIER_STATE_INVISIBLE] = true} end

function modifier_imba_telekinesis_pfx:OnCreated()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_marker_force.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetRemainingTime() + 0.5, 0, 0))
		ParticleManager:SetParticleControl(pfx, 2, self:GetCaster():GetAbsOrigin())
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end

function modifier_imba_telekinesis_pfx:OnDestroy()
	if IsServer() then
		self:GetAbility().pfx = nil
	end
end





imba_rubick_spell_steal_buff = class({})

LinkLuaModifier("modifier_imba_spell_steal_buff", "mb/hero_rubick/rubick_telekinesis_land", LUA_MODIFIER_MOTION_NONE)

function imba_rubick_spell_steal_buff:IsTalentAbility() return true end
--function imba_rubick_spell_steal_buff:GetIntrinsicModifierName() return "modifier_imba_spell_steal_buff" end

modifier_imba_spell_steal_buff = class({})

function modifier_imba_spell_steal_buff:IsDebuff()			return false end
function modifier_imba_spell_steal_buff:IsHidden() 			return true end
function modifier_imba_spell_steal_buff:IsPurgable() 		return false end
function modifier_imba_spell_steal_buff:IsPurgeException() 	return false end
function modifier_imba_spell_steal_buff:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_imba_spell_steal_buff:OnAbilityFullyCast(keys)
	if not IsServer() or self:GetParent():IsIllusion() then
		return
	end
	if not self.talents then
		self.talents = {}
	end
	if keys.ability:GetAbilityName() == "rubick_spell_steal" then
		local target = keys.target
		local rubick = self:GetParent()
		for _, talent in pairs(self.talents) do
			rubick:RemoveAbility(talent:GetAbilityName())
		end
		self.talents = {}
		for i=0, 23 do
			local talent = target:GetAbilityByIndex(i)
			if talent and (string.find(talent:GetAbilityName(), "special_bonus_imba") or string.find(talent:GetAbilityName(), "special_bonus_unique_")) and talent:GetLevel() > 0 then
				local ability = rubick:AddAbility(talent:GetAbilityName())
				ability:SetLevel(1)
				table.insert(self.talents, ability)
			end
		end
	end
end