ghillie_suit = class({})

LinkLuaModifier("modifier_ghillie_suit", "ting/yinjianren/ghillie_suit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ghillie_suit_pa", "ting/yinjianren/ghillie_suit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ghillie_suit_pa_inv", "ting/yinjianren/ghillie_suit.lua", LUA_MODIFIER_MOTION_NONE)
function ghillie_suit:GetIntrinsicModifierName() return "ghillie_suit_pa" end
function ghillie_suit:IsHiddenWhenStolen() 	return false end
function ghillie_suit:IsRefreshable() 			return true  end
function ghillie_suit:IsStealable() 			return true  end
function ghillie_suit:OnUpgrade()
	if self:GetLevel() <= 4 then
		local caster = self:GetCaster()
		local name = "yinjianren"
		local ability = caster:FindAbilityByName(name)
		ability:SetLevel(1)
	end
end

function ghillie_suit:OnSpellStart()
	self.caster = self:GetCaster()
	self.duration = self:GetSpecialValueFor("duration")

	local target = self:GetCursorTarget()


	target:AddNewModifier(self.caster,self,"modifier_ghillie_suit",{duration = self.duration})

end


modifier_ghillie_suit = class({})
function modifier_ghillie_suit:IsDebuff()			return false end
function modifier_ghillie_suit:IsHidden() 			return false end
function modifier_ghillie_suit:IsPurgable() 			return false end
function modifier_ghillie_suit:GetEffectName() return "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf" end
function modifier_ghillie_suit:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
			}

end
function modifier_ghillie_suit:DeclareFunctions() return
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
end

function modifier_ghillie_suit:GetDisableAutoAttack() return true end
function modifier_ghillie_suit:GetModifierInvisibilityLevel()
	return 1
end
function modifier_ghillie_suit:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_bonus
end
function modifier_ghillie_suit:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() then
		self:Destroy()
	end
end
function modifier_ghillie_suit:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit == self.parent then
		local name = params.ability:GetAbilityName()
		if params.ability == self.ab or name == "assassinate" then return end
			self:Destroy()
		end
	end
end
function modifier_ghillie_suit:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.movement_bonus = self.ab:GetSpecialValueFor("move_s")
	self.parent = self:GetParent()
	if IsServer() then
		self.mod = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/spring2021_ambush_sniper_cape/spring2021_ambush_sniper_cape.vmdl"})
		self.mod:SetParent(self:GetParent(), nil)
        self.mod:FollowEntity(self:GetParent(), true)
		self.parent:EmitSound("Hero_Treant.NaturesGuise.On")

	end

end
function modifier_ghillie_suit:OnDestroy()
	if IsServer() and self.mod then
		self.mod:RemoveSelf()
		self.parent:EmitSound("Hero_Treant.NaturesGuise.Off")
	end
end


ghillie_suit_pa = class({})
LinkLuaModifier("ghillie_suit_pa_inv", "ting/yinjianren/ghillie_suit.lua", LUA_MODIFIER_MOTION_NONE)
function ghillie_suit_pa:IsHidden() 			return true end
function ghillie_suit_pa:IsPurgable() 			return false end
function ghillie_suit_pa:IsPurgeException() 			return false end
function ghillie_suit_pa:RemoveOnDeath() 			return false end
function ghillie_suit_pa:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function ghillie_suit_pa:OnCreated()
	if self:GetAbility() ~= nil then
		self.ability  = self:GetAbility()
		self.parent = self:GetParent()
	end
	if not IsServer() then return end
	self:StartIntervalThink(0.5)
end

function ghillie_suit_pa:OnIntervalThink()
	if not IsServer() then return end

	if self.ability:GetLevel() > 0 and self.parent:IsAlive() then
	local inv_time = self.ability:GetSpecialValueFor("inv_time")*2
--[[	if GridNav:IsNearbyTree(self:GetParent():GetAbsOrigin(),self:GetAbility():GetSpecialValueFor("radius"), true) and self:GetAbility():GetLevel() >0 then
			self:SetStackCount(math.min(self:GetStackCount()+1,2))
			else
			self:SetStackCount(0)

	end]]

	self:SetStackCount(math.min(self:GetStackCount()+1,inv_time))
	if self:GetStackCount() == inv_time then
		self.parent:AddNewModifier(self.parent,self.ability,"ghillie_suit_pa_inv",{duration = -1})
		self:SetStackCount(0)
		self:StartIntervalThink(-1)
	end
	end
end
function ghillie_suit_pa:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() then
		keys.attacker:RemoveModifierByName("ghillie_suit_pa_inv")
		self:SetStackCount(0)
		self:StartIntervalThink(0.5)
	end
	if keys.target == self:GetParent() then
		self:SetStackCount(0)
		self:StartIntervalThink(0.5)
	end	

end
function ghillie_suit_pa:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit~=self.parent then return end	
		local name = params.ability:GetAbilityName()
		if params.ability == self.ability or name == "assassinate" then return end
--			self:SetStackCount(0)
--			self:StartIntervalThink(0.5)

		self.parent:RemoveModifierByName("ghillie_suit_pa_inv")
	end
end


ghillie_suit_pa_inv = class({})
function ghillie_suit_pa_inv:IsHidden() 			return false end
function ghillie_suit_pa_inv:IsPurgable() 			return false end
function ghillie_suit_pa_inv:IsPurgeException() 			return false end

function ghillie_suit_pa_inv:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			}

end

function ghillie_suit_pa_inv:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,}
end
function ghillie_suit_pa_inv:GetDisableAutoAttack() return true end
function ghillie_suit_pa_inv:GetModifierInvisibilityLevel()
	return 1
end
function ghillie_suit_pa_inv:GetModifierMoveSpeedBonus_Percentage()
	return 0 --self.movement_bonus 0
end


function ghillie_suit_pa_inv:OnCreated()
	--self.regen_amp = self:GetAbility():GetSpecialValueFor("regen_amp")
	if not IsServer() then  return end
	self.mod = self:GetParent():FindModifierByName("ghillie_suit_pa")
	self.caster = self:GetCaster()
	self.caster:EmitSound("Hero_Treant.NaturesGuise.On")
	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_naturesguise_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControlEnt(cast_particle, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(cast_particle, 2, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)
end



function ghillie_suit_pa_inv:OnDestroy()
	if not IsServer() then return end
		if self.mod then
			self.mod:StartIntervalThink(0.5)
		end
		if  self.caster~=nil and IsValidEntity(self.caster) then
			self.caster:EmitSound("Hero_Treant.NaturesGuise.Off")
		end
end