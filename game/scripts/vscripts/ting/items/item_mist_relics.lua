item_imba_mist_relics = class({})

LinkLuaModifier("item_imba_mist_relics_passive", "ting/items/item_mist_relics", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_imba_mist_relics_buff", "ting/items/item_mist_relics", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_imba_mist_relics_shield", "ting/items/item_mist_relics", LUA_MODIFIER_MOTION_NONE)
function item_imba_mist_relics:GetIntrinsicModifierName() return "item_imba_mist_relics_passive" end
function item_imba_mist_relics:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local health = caster:GetHealth()
	EmitSoundOn("DOTA_Item.Satanic.Activate", self:GetCaster())

	local modifier = caster:AddNewModifier(caster,self,"item_imba_mist_relics_buff",{duration = self:GetSpecialValueFor("duration_on")})

end

item_imba_mist_relics_buff = class({})
function item_imba_mist_relics_buff:IsDebuff()			return false end
function item_imba_mist_relics_buff:IsHidden() 			return false end
function item_imba_mist_relics_buff:IsPurgable() 		return false end
function item_imba_mist_relics_buff:IsPurgeException() 	return false end
function item_imba_mist_relics_buff:GetEffectName()			return "particles/items2_fx/satanic_buff.vpcf" end
function item_imba_mist_relics_buff:GetTexture()			return "item_mist_relics" end

item_imba_mist_relics_shield = class({})
function item_imba_mist_relics_shield:IsDebuff()			return false end
function item_imba_mist_relics_shield:IsHidden() 			return false end
function item_imba_mist_relics_shield:IsPurgable() 		return false end
function item_imba_mist_relics_shield:IsPurgeException() 	return false end
function item_imba_mist_relics_shield:DeclareFunctions() return {MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
function item_imba_mist_relics_shield:GetTexture()			return "item_mist_relics" end
function item_imba_mist_relics_shield:OnCreated()
	if self:GetAbility() == nil then
		return
	end
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	if not IsServer() then return end
	EmitSoundOn("Hero_Abaddon.AphoticShield.Loop", self:GetParent())
	EmitSoundOn("Hero_Abaddon.AphoticShield.Cast", self:GetParent())
end
function item_imba_mist_relics_shield:GetModifierTotal_ConstantBlock(keys)
	if keys.target~=self:GetParent() then
		return  0
	end
	local stack = self:GetStackCount()
	self:SetStackCount(math.max(0, stack - math.max(0,keys.damage)))
	return stack
end
function item_imba_mist_relics_shield:GetModifierPreAttack_BonusDamage()
	if self:GetParent()~=nil then
	if self:GetStackCount() == 0 then self:Destroy() return end
		return self.damage*self:GetStackCount()*0.01
	end
end


item_imba_mist_relics_passive = class({})
LinkLuaModifier("item_imba_mist_relics_passive_cd", "ting/items/item_mist_relics", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_imba_mist_relics_shield", "ting/items/item_mist_relics", LUA_MODIFIER_MOTION_NONE)
function item_imba_mist_relics_passive:IsDebuff()			return false end
function item_imba_mist_relics_passive:IsHidden() 			return true end
function item_imba_mist_relics_passive:IsPurgable() 		return false end
function item_imba_mist_relics_passive:IsPurgeException() 	return false end
function item_imba_mist_relics_passive:DeclareFunctions()
local tab1 = {
	MODIFIER_EVENT_ON_HEAL_RECEIVED,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATUS_RESISTANCE,
	MODIFIER_EVENT_ON_TAKEDAMAGE,}
local tab2 = {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATUS_RESISTANCE}

if self:GetParent():IsIllusion() then return tab2 end

return tab1
end

function item_imba_mist_relics_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function item_imba_mist_relics_passive:OnCreated()
    if self:GetAbility() == nil then
		return
	end
	self.ab = self:GetAbility()
	self.lifesteal = self.ab:GetSpecialValueFor("lifesteal")
	self.lifesteal_on = self.ab:GetSpecialValueFor("lifesteal_on")
	self.str = self.ab:GetSpecialValueFor("str")
	self.statu = self.ab:GetSpecialValueFor("statu")
	self.stack_max = self.ab:GetSpecialValueFor("stack_max")
	self.duration = self.ab:GetSpecialValueFor("duration")
	self.max_helthp = self.ab:GetSpecialValueFor("max_helthp")




end
function item_imba_mist_relics_passive:GetModifierBonusStats_Strength()
	return self.str or 0
end

function item_imba_mist_relics_passive:GetModifierStatusResistance()
	return self.statu or 0
end

function item_imba_mist_relics_passive:OnHealReceived(keys)
	if not IsServer() then return end
	if keys.unit ~= self:GetParent() then return end
	if keys.gain > self:GetParent():GetMaxHealth()*self.max_helthp*0.01 then
		if self:GetParent():GetHealth() + keys.gain > self:GetParent():GetMaxHealth() then
			--print(tostring(keys.gain+self:GetParent():GetHealth()-self:GetParent():GetMaxHealth()))
			local stack = 0
			if keys.unit:HasModifier("item_imba_mist_relics_shield") then
				stack = keys.unit:FindModifierByName("item_imba_mist_relics_shield"):GetStackCount()
			end
				local modifier = keys.unit:AddNewModifier(keys.unit,self:GetAbility(),"item_imba_mist_relics_shield",{duration = self.duration})
				modifier:SetStackCount(math.min(math.ceil(keys.gain+self:GetParent():GetHealth()-self:GetParent():GetMaxHealth())+stack,math.ceil(self:GetParent():GetMaxHealth()*self.stack_max*0.01)))
		end
	end
end


function item_imba_mist_relics_passive:OnTakeDamage( keys )
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
		local life = self.lifesteal
			if self:GetParent():HasModifier("item_imba_mist_relics_buff") then
				life = self.lifesteal_on
			end
		local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(pfx)
		keys.attacker:Heal(keys.damage * life * 0.01, keys.attacker)
		end
	end
end


------------------------------------------------------------------------------satanic
item_imba_satanic = class({})

LinkLuaModifier("item_imba_satanic_passive", "ting/items/item_mist_relics", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_imba_satanic_buff", "ting/items/item_mist_relics", LUA_MODIFIER_MOTION_NONE)
function item_imba_satanic:GetIntrinsicModifierName() return "item_imba_satanic_passive" end
function item_imba_satanic:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local health = caster:GetHealth()
	EmitSoundOn("DOTA_Item.Satanic.Activate", self:GetCaster())

	local modifier = caster:AddNewModifier(caster,self,"item_imba_satanic_buff",{duration = self:GetSpecialValueFor("duration_on")})
end

item_imba_satanic_buff = class({})
function item_imba_satanic_buff:IsDebuff()			return false end
function item_imba_satanic_buff:IsHidden() 			return false end
function item_imba_satanic_buff:IsPurgable() 		return false end
function item_imba_satanic_buff:IsPurgeException() 	return false end
function item_imba_satanic_buff:GetEffectName()			return "particles/items2_fx/satanic_buff.vpcf" end
function item_imba_satanic_buff:GetTexture()			return "item_imba_satanic" end

item_imba_satanic_passive = class({})
function item_imba_satanic_passive:IsDebuff()			return false end
function item_imba_satanic_passive:IsHidden() 			return true end
function item_imba_satanic_passive:IsPurgable() 		return false end
function item_imba_satanic_passive:IsPurgeException() 	return false end
function item_imba_satanic_passive:AllowIllusionDuplicate() 	return false end
function item_imba_satanic_passive:DeclareFunctions() return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATUS_RESISTANCE,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
}
end

function item_imba_satanic_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function item_imba_satanic_passive:OnCreated()
    if self:GetAbility() == nil then
		return
	end
	self.ab = self:GetAbility()
	self.lifesteal = self.ab:GetSpecialValueFor("lifesteal")
	self.lifesteal_on = self.ab:GetSpecialValueFor("lifesteal_on")
	self.str = self.ab:GetSpecialValueFor("str")
	self.statu = self.ab:GetSpecialValueFor("statu")
	self.damage = self.ab:GetSpecialValueFor("damage")
end

function item_imba_satanic_passive:GetModifierBonusStats_Strength()
	return self.str
end
function item_imba_satanic_passive:GetModifierStatusResistance()
	return self.statu
end
function item_imba_satanic_passive:GetModifierPreAttack_BonusDamage()
	return self.damage
end

function item_imba_satanic_passive:OnTakeDamage( keys )
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() and keys.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
		local life = self.lifesteal
			if self:GetParent():HasModifier("item_imba_satanic_buff") then
				life = self.lifesteal_on
			end
		local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(pfx)
		keys.attacker:Heal(keys.damage * life * 0.01, keys.attacker)
		end
	end
end

------------------------------------------------------------------------------blood
item_imba_thirst = class({})

LinkLuaModifier("item_imba_thirst_passive", "ting/items/item_mist_relics", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_imba_thirst_buff", "ting/items/item_mist_relics", LUA_MODIFIER_MOTION_NONE)
function item_imba_thirst:GetIntrinsicModifierName() return "item_imba_thirst_passive" end
function item_imba_thirst:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local health = caster:GetHealth()
	EmitSoundOn("DOTA_Item.Satanic.Activate", self:GetCaster())

	local modifier = caster:AddNewModifier(caster,self,"item_imba_thirst_buff",{duration = self:GetSpecialValueFor("duration_on")})
end

item_imba_thirst_buff = class({})
function item_imba_thirst_buff:IsDebuff()			return false end
function item_imba_thirst_buff:IsHidden() 			return false end
function item_imba_thirst_buff:IsPurgable() 		return false end
function item_imba_thirst_buff:IsPurgeException() 	return false end
function item_imba_thirst_buff:GetEffectName()			return "particles/items2_fx/satanic_buff.vpcf" end
function item_imba_thirst_buff:GetTexture()			return "item_thirst" end

item_imba_thirst_passive = class({})
function item_imba_thirst_passive:IsDebuff()			return false end
function item_imba_thirst_passive:IsHidden() 			return true end
function item_imba_thirst_passive:IsPurgable() 		return false end
function item_imba_thirst_passive:IsPurgeException() 	return false end
function item_imba_thirst_passive:DeclareFunctions() return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATUS_RESISTANCE,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
}
end

function item_imba_thirst_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function item_imba_thirst_passive:OnCreated()
	if self:GetAbility() == nil then
		return
	end
	self.ab = self:GetAbility()
	self.lifesteal = self.ab:GetSpecialValueFor("lifesteal")
	self.lifesteal_on = self.ab:GetSpecialValueFor("lifesteal_on")
	self.str = self.ab:GetSpecialValueFor("str")
	self.statu = self.ab:GetSpecialValueFor("statu")
	self.damage = self.ab:GetSpecialValueFor("damage")




end
function item_imba_thirst_passive:GetModifierBonusStats_Strength()
	return self.str
end
function item_imba_thirst_passive:GetModifierStatusResistance()
	return self.statu
end
function item_imba_thirst_passive:GetModifierPreAttack_BonusDamage()
	return self.damage
end

function item_imba_thirst_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end

	if keys.attacker == self:GetParent() and (keys.target:IsHero() or keys.target:IsCreep() or keys.target:IsBoss()) then
		local life = self.lifesteal
			if self:GetParent():HasModifier("item_imba_thirst_buff") then
				life = self.lifesteal_on
			end
		local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(pfx)
		keys.attacker:Heal(keys.damage * life * 0.01, keys.attacker)
	end
end
