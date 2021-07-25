
item_imba_vladmir = class({})

LinkLuaModifier("modifier_vladmir_passive", "ting/items/item_vladmir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_vladmir_aura", "ting/items/item_vladmir", LUA_MODIFIER_MOTION_NONE)


function item_imba_vladmir:GetIntrinsicModifierName() return "modifier_vladmir_passive" end
-------------------------------------------------------------------------


modifier_vladmir_passive = class({})

function modifier_vladmir_passive:IsDebuff()			return false end
function modifier_vladmir_passive:IsHidden() 			return true end
function modifier_vladmir_passive:IsPurgable() 			return false end
function modifier_vladmir_passive:IsPurgeException() 	return false end
function modifier_vladmir_passive:OnCreated()
	self.stat = self:GetAbility():GetSpecialValueFor("stat_bonus")
	self.radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_vladmir_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_vladmir_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_vladmir_passive:DeclareFunctions() return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end
function modifier_vladmir_passive:GetModifierBonusStats_Intellect() return self.stat end
function modifier_vladmir_passive:GetModifierBonusStats_Agility() return self.stat end
function modifier_vladmir_passive:GetModifierBonusStats_Strength() return self.stat end


function modifier_vladmir_passive:IsAura() return true end
function modifier_vladmir_passive:GetAuraDuration() return 0.1 end
function modifier_vladmir_passive:GetModifierAura() return "modifier_item_imba_vladmir_aura" end
function modifier_vladmir_passive:GetAuraRadius() return self.radius end
function modifier_vladmir_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_vladmir_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_vladmir_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_item_imba_vladmir_aura = class({})

function modifier_item_imba_vladmir_aura:IsDebuff()			return false end
function modifier_item_imba_vladmir_aura:IsHidden() 			return false end
function modifier_item_imba_vladmir_aura:IsPurgable() 		return false end
function modifier_item_imba_vladmir_aura:IsPurgeException() 	return false end
function modifier_item_imba_vladmir_aura:GetTexture() return "item_imba_vladmir" end
function modifier_item_imba_vladmir_aura:OnCreated() 
	if self:GetAbility() then
	self.armor_aura = self:GetAbility():GetSpecialValueFor("armor_aura") 
	self.mana_regen_aura = self:GetAbility():GetSpecialValueFor("mana_regen_aura") 
	self.hp_regen_aura = self:GetAbility():GetSpecialValueFor("hp_regen_aura") 
	self.damage_aura = self:GetAbility():GetSpecialValueFor("damage_aura")
	self.hero_lifesteal = self:GetAbility():GetSpecialValueFor("hero_lifesteal") 
end
end

function modifier_item_imba_vladmir_aura:DeclareFunctions() 
	return 
	{
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, 
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, 
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, 
		MODIFIER_EVENT_ON_TAKEDAMAGE
	} 
end
function modifier_item_imba_vladmir_aura:GetModifierBaseDamageOutgoing_Percentage() 
	return self.damage_aura
end
function modifier_item_imba_vladmir_aura:GetModifierPhysicalArmorBonus() 
	return self.armor_aura end
function modifier_item_imba_vladmir_aura:GetModifierConstantManaRegen() 
	return self.mana_regen_aura end
function modifier_item_imba_vladmir_aura:GetModifierConstantHealthRegen() 
	return self.hp_regen_aura end

function modifier_item_imba_vladmir_aura:OnTakeDamage(keys)
	if not IsServer() then
		return
	end

	if keys.attacker == self:GetParent() and (keys.unit:IsHero() or keys.unit:IsCreep() or keys.unit:IsBoss()) and not Is_Chinese_TG(keys.attacker, keys.unit) and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then

		local lifesteal = keys.damage * (self.hero_lifesteal / 100)
		if keys.unit:IsCreep() and keys.inflictor then
			lifesteal = lifesteal / 5
		end
		self:GetParent():Heal(lifesteal,self:GetParent())
		SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(),lifesteal, nil)
	end
end