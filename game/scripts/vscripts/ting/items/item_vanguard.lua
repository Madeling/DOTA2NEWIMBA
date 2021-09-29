


item_imba_vanguard = class({})

LinkLuaModifier("modifier_imba_vanguard_passive", "ting/items/item_vanguard", LUA_MODIFIER_MOTION_NONE)
function item_imba_vanguard:GetIntrinsicModifierName() return "modifier_imba_vanguard_passive" end

modifier_imba_vanguard_passive = class({})
LinkLuaModifier("modifier_snner_debug1", "ting/items/item_vanguard", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_vanguard_passive:IsDebuff()			return false end
function modifier_imba_vanguard_passive:IsHidden() 			return true end
function modifier_imba_vanguard_passive:IsPurgable() 		return false end
function modifier_imba_vanguard_passive:IsPurgeException() 	return false end
function modifier_imba_vanguard_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_vanguard_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK, MODIFIER_PROPERTY_HEALTH_BONUS, MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end
function modifier_imba_vanguard_passive:GetModifierPhysical_ConstantBlock()
	if self:GetParent():IS_TrueHero_TG() then
		return (self:GetParent():GetLevel() + self.base_damage_block)
	else
		return nil
	end
end

function modifier_imba_vanguard_passive:GetModifierHealthBonus() return self.health end

function modifier_imba_vanguard_passive:GetModifierConstantHealthRegen() return self.hp_re end

function modifier_imba_vanguard_passive:GetModifierIncomingDamage_Percentage()
	if not self:GetParent():HasModifier("modifier_imba_rapier_super_unique") and not self:GetParent():HasModifier("modifier_imba_burrow") and
	   not self:GetParent():HasModifier("modifier_imba_greatwyrm_plate_passive") and not self:GetParent():HasModifier("modifier_imba_crimson_guard_passive") then
		return (0 - self.dmg_re)
	else
		return 0
	end
end


function modifier_imba_vanguard_passive:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.base_damage_block = self:GetAbility():GetSpecialValueFor("base_damage_block")
	self.health = self:GetAbility():GetSpecialValueFor("health")
	self.hp_re = self:GetAbility():GetSpecialValueFor("health_regen")
	self.dmg_re = self:GetAbility():GetSpecialValueFor("damage_reduction")
end





item_imba_crimson_guard = class({})

LinkLuaModifier("modifier_imba_crimson_guard_passive", "ting/items/item_vanguard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_greatwyrm_plate_active", "ting/items/item_vanguard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_greatwyrm_plate_active_cd", "ting/items/item_vanguard", LUA_MODIFIER_MOTION_NONE)
function item_imba_crimson_guard:GetIntrinsicModifierName() return "modifier_imba_crimson_guard_passive" end

function item_imba_crimson_guard:GetCastRange()
	if not IsServer() then
		return (self:GetSpecialValueFor("active_radius") - self:GetCaster():GetCastRangeBonus())
	end
end

function item_imba_crimson_guard:OnSpellStart()
	local caster = self:GetCaster()
	local duration= self:GetSpecialValueFor("duration")
	caster:EmitSound("Item.CrimsonGuard.Cast")
	local pfx = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active_launch.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetSpecialValueFor("active_radius"),0,0))
	ParticleManager:ReleaseParticleIndex(pfx)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("active_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _, hero in pairs(heroes) do
		if hero:HasModifier("modifier_item_greatwyrm_plate_active_cd") then return end
		local modifier = hero:AddNewModifier(caster, self, "modifier_item_greatwyrm_plate_active", {duration =duration })
		modifier:SetStackCount(	math.ceil(hero:GetPhysicalArmorValue(true))/2)
		hero:AddNewModifier(self:GetCaster(),self,"modifier_item_greatwyrm_plate_active_cd",{duration = 12})
	end
end

modifier_imba_crimson_guard_passive = class({})
function modifier_imba_crimson_guard_passive:IsDebuff()			return false end
function modifier_imba_crimson_guard_passive:IsHidden() 		return true end
function modifier_imba_crimson_guard_passive:IsPurgable() 		return false end
function modifier_imba_crimson_guard_passive:IsPurgeException() return false end
function modifier_imba_crimson_guard_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_crimson_guard_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK, MODIFIER_PROPERTY_HEALTH_BONUS, MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_crimson_guard_passive:GetModifierPhysical_ConstantBlock()
	if self:GetParent():IS_TrueHero_TG() then
		return self.base_damage_block
	else
		return nil
	end
end
function modifier_imba_crimson_guard_passive:GetModifierHealthBonus()
	return self.health
end
function modifier_imba_crimson_guard_passive:GetModifierConstantHealthRegen()
	return self.health_regen
end
function modifier_imba_crimson_guard_passive:GetModifierIncomingDamage_Percentage()
	if not self:GetParent():HasModifier("modifier_imba_rapier_super_unique") and not self:GetParent():HasModifier("modifier_imba_burrow")
		and not self:GetParent():HasModifier("modifier_imba_greatwyrm_plate_passive")then
		return (0 -self.damage_reduction)
	else
		return 0
	end
end


function modifier_imba_crimson_guard_passive:GetModifierBonusStats_Intellect() return self.bonus_stats end
function modifier_imba_crimson_guard_passive:GetModifierBonusStats_Agility() return self.bonus_stats end
function modifier_imba_crimson_guard_passive:GetModifierBonusStats_Strength() return self.bonus_stats end
function modifier_imba_crimson_guard_passive:GetModifierPhysicalArmorBonus() return self.armor end

function modifier_imba_crimson_guard_passive:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	local ab= self:GetAbility()
	self.base_damage_block=ab:GetSpecialValueFor("base_damage_block")
	self.health=ab:GetSpecialValueFor("health")
	self.health_regen=ab:GetSpecialValueFor("health_regen")
	self.damage_reduction=ab:GetSpecialValueFor("damage_reduction")
	self.bonus_stats=ab:GetSpecialValueFor("bonus_stats")
	self.armor=ab:GetSpecialValueFor("armor")

end


item_imba_greatwyrm_plate = class({})
LinkLuaModifier("modifier_imba_greatwyrm_plate_passive", "ting/items/item_vanguard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_greatwyrm_plate_active", "ting/items/item_vanguard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_greatwyrm_plate_active_cd", "ting/items/item_vanguard", LUA_MODIFIER_MOTION_NONE)
function item_imba_greatwyrm_plate:GetIntrinsicModifierName() return "modifier_imba_greatwyrm_plate_passive" end

function item_imba_greatwyrm_plate:OnSpellStart()
	local caster = self:GetCaster()
	local duration= self:GetSpecialValueFor("duration")
	caster:EmitSound("Item.CrimsonGuard.Cast")
	local pfx = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active_launch.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetSpecialValueFor("active_radius"),0,0))
	ParticleManager:ReleaseParticleIndex(pfx)
	local ar = 0
	local mod = self:GetParent():FindModifierByName("modifier_imba_greatwyrm_plate_passive")
	if mod ~= nil then
		ar = mod:GetStackCount()*self:GetSpecialValueFor("armor_active_per")
	end
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("active_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	if #heroes>0 then
		for _, hero in pairs(heroes) do
			if hero:IsRealHero() then
				if hero:HasModifier("modifier_item_greatwyrm_plate_active_cd") then return end
				local modifier = hero:AddNewModifier(caster, self, "modifier_item_greatwyrm_plate_active", {duration =duration})
				modifier:SetStackCount(self:GetSpecialValueFor("armor_active") + ar)
				hero:AddNewModifier(self:GetCaster(),self,"modifier_item_greatwyrm_plate_active_cd",{duration = 12})
			end
		end
	end
end

--飞龙光环
modifier_imba_greatwyrm_plate_aura = class({})
function modifier_imba_greatwyrm_plate_aura:IsDebuff()			return false end
function modifier_imba_greatwyrm_plate_aura:IsHidden() 			return false end
function modifier_imba_greatwyrm_plate_aura:GetTexture() return "item_greatwyrm_plate_0" end
function modifier_imba_greatwyrm_plate_aura:IsPurgable() 		return false end
function modifier_imba_greatwyrm_plate_aura:IsPurgeException() 	return false end
function modifier_imba_greatwyrm_plate_aura:DeclareFunctions() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end
function modifier_imba_greatwyrm_plate_aura:GetModifierIncomingDamage_Percentage()
		return -1*self.re
end
function modifier_imba_greatwyrm_plate_aura:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.re = self:GetAbility():GetSpecialValueFor("dmg_reduce")
end

--飞龙被动
modifier_imba_greatwyrm_plate_passive = class({})
LinkLuaModifier("modifier_imba_greatwyrm_plate_passive_beidong", "ting/items/item_vanguard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_greatwyrm_plate_passive_beidong_cd", "ting/items/item_vanguard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_greatwyrm_plate_aura", "ting/items/item_vanguard", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_greatwyrm_plate_passive:IsDebuff()			return false end
function modifier_imba_greatwyrm_plate_passive:AllowIllusionDuplicate()			return false end
function modifier_imba_greatwyrm_plate_passive:IsHidden() 			return false end
function modifier_imba_greatwyrm_plate_passive:IsPurgable() 		return false end
function modifier_imba_greatwyrm_plate_passive:IsPurgeException() 	return false end
function modifier_imba_greatwyrm_plate_passive:GetTexture() return "item_greatwyrm_plate_0" end
function modifier_imba_greatwyrm_plate_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_greatwyrm_plate_passive:IsAura()
	if self:GetParent():IsIllusion() or self:GetStackCount()<self.lv then
		return false
	end
	return true
end
function modifier_imba_greatwyrm_plate_passive:GetAuraDuration() return 1 end
function modifier_imba_greatwyrm_plate_passive:GetModifierAura() return "modifier_imba_greatwyrm_plate_aura" end
function modifier_imba_greatwyrm_plate_passive:GetAuraRadius()
	return 1200
end

function modifier_imba_greatwyrm_plate_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_greatwyrm_plate_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_greatwyrm_plate_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_imba_greatwyrm_plate_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK, MODIFIER_PROPERTY_HEALTH_BONUS, MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_PROPERTY_MANA_BONUS, MODIFIER_PROPERTY_STATUS_RESISTANCE,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_greatwyrm_plate_passive:GetModifierPhysical_ConstantBlock(keys)
	if self:GetAbility()==nil or keys.target ~= self:GetParent() or self:GetParent():IsIllusion() then
		return
	end
	return keys.damage*(self.block+self:GetStackCount()*self.block_count)*0.01
end

function modifier_imba_greatwyrm_plate_passive:GetModifierHealthBonus() return self.hp end
function modifier_imba_greatwyrm_plate_passive:GetModifierConstantHealthRegen() return self.hp_re end
function modifier_imba_greatwyrm_plate_passive:GetModifierManaBonus() return self.mana end
function modifier_imba_greatwyrm_plate_passive:GetModifierStatusResistance() return self.statue_re + self:GetStackCount()*self.block_count end
function modifier_imba_greatwyrm_plate_passive:GetModifierPhysicalArmorBonus() return self.armor end

function modifier_imba_greatwyrm_plate_passive:OnCreated()
	self.count = 1
	if self:GetAbility()==nil then
		return
	end
	self.block = self:GetAbility():GetSpecialValueFor("base_damage_block")
	self.lv = self:GetAbility():GetSpecialValueFor("lv")
	self.hp = self:GetAbility():GetSpecialValueFor("health")
	self.hp_re = self:GetAbility():GetSpecialValueFor("health_regen")
	self.mana = self:GetAbility():GetSpecialValueFor("mana")
	self.statue_re = self:GetAbility():GetSpecialValueFor("statue_resis")
	self.armor = self:GetAbility():GetSpecialValueFor("armor")
	self.block_count = self:GetAbility():GetSpecialValueFor("block_count")
	self:StartIntervalThink(10)
end
function modifier_imba_greatwyrm_plate_passive:OnIntervalThink()
	if not IsServer() then return end
	local count = 1
	local tab_item = {
"item_imba_orb","item_imba_splendid","item_imba_aegis_heart","item_bkb","item_greaves_v2","item_heavens_halberd_v2","item_veil_of_evil","item_imba_blade_mail_2","item_imba_pipe","item_skadi_v2","item_blade_mail","item_imba_radiance","item_imba_vladmir","item_radiance_v2",}
	for i=0,5 do
		if self:GetParent():GetItemInSlot(i) ~= nil then
		local item_name = self:GetParent():GetItemInSlot(i):GetName()
			for k =1,#tab_item do
				if tab_item[k] == item_name then
					count = count+1
				end
			end
		end
	end
	self:SetStackCount(count)
end




--飞龙赤红主动
modifier_item_greatwyrm_plate_active = class({})

function modifier_item_greatwyrm_plate_active:IsDebuff()			return false end
function modifier_item_greatwyrm_plate_active:AllowIllusionDuplicate()			return false end
function modifier_item_greatwyrm_plate_active:IsHidden() 			return false end
function modifier_item_greatwyrm_plate_active:IsPurgable() 			return false end
function modifier_item_greatwyrm_plate_active:IsPurgeException() 	return false end
function modifier_item_greatwyrm_plate_active:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK} end
function modifier_item_greatwyrm_plate_active:GetTexture() return "item_imba_crimson_guard" end
function modifier_item_greatwyrm_plate_active:GetModifierPhysicalArmorBonus()
	return self:GetStackCount()
end

function modifier_item_greatwyrm_plate_active:OnCreated()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)

	end
end

modifier_item_greatwyrm_plate_active_cd = class({})
function modifier_item_greatwyrm_plate_active_cd:IsHidden() 			return false end
function modifier_item_greatwyrm_plate_active_cd:IsPurgable() 			return false end
function modifier_item_greatwyrm_plate_active_cd:IsPurgeException() 	return false end
function modifier_item_greatwyrm_plate_active_cd:RemoveOnDeath()		return false end
function modifier_item_greatwyrm_plate_active_cd:GetTexture() return "item_imba_crimson_guard" end
