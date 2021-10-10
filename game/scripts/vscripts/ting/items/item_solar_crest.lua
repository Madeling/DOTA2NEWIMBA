item_imba_solar_crest = class({})
LinkLuaModifier("modifier_imba_solar_passive", "ting/items/item_solar_crest", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sloar_buff", "ting/items/item_solar_crest", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sloar_debuff", "ting/items/item_solar_crest", LUA_MODIFIER_MOTION_NONE)
function item_imba_solar_crest:GetIntrinsicModifierName() return "modifier_imba_solar_passive" end


function item_imba_solar_crest:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    if Is_Chinese_TG(target,caster) then
		target:EmitSound("Item.StarEmblem.Friendly")
        target:AddNewModifier(caster, self, "modifier_imba_sloar_buff", {duration = self:GetSpecialValueFor("duration")})
    else
		target:EmitSound("Item.StarEmblem.Enemy")
        target:AddNewModifier(caster, self, "modifier_imba_sloar_debuff", {duration = self:GetSpecialValueFor("duration")*0.5})
    end
end

modifier_imba_solar_passive = class({})
function modifier_imba_solar_passive:IsDebuff()				return false end
function modifier_imba_solar_passive:IsHidden() 			return true end
function modifier_imba_solar_passive:IsPurgable() 			return false end
function modifier_imba_solar_passive:IsPurgeException() 			return false end
function modifier_imba_solar_passive:DeclareFunctions() return 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, 
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	} 
end

function modifier_imba_solar_passive:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.msp = self.ab:GetSpecialValueFor("move_speed_c") or 0
	self.armor = self.ab:GetSpecialValueFor("armor") or 0
	self.miss = self.ab:GetSpecialValueFor("miss") or 0
	self.mana_re = self.ab:GetSpecialValueFor("mana_re") or 0
	self.sta = self.ab:GetSpecialValueFor("sta") or 0
end

function modifier_imba_solar_passive:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_imba_solar_passive:GetModifierMoveSpeedBonus_Constant()
	return self.msp
end

function modifier_imba_solar_passive:GetModifierEvasion_Constant()
	return self.miss
end

function modifier_imba_solar_passive:GetModifierConstantManaRegen()
	return self.mana_re
end

function modifier_imba_solar_passive:GetModifierBonusStats_Strength() 	return self.sta end
function modifier_imba_solar_passive:GetModifierBonusStats_Agility() 	return self.sta end
function modifier_imba_solar_passive:GetModifierBonusStats_Intellect() 	return self.sta end

modifier_imba_sloar_buff = class({})
function modifier_imba_sloar_buff:IsDebuff()			return false end
function modifier_imba_sloar_buff:IsHidden() 			return false end
function modifier_imba_sloar_buff:IsPurgable() 			return false end
function modifier_imba_sloar_buff:GetEffectName() return "particles/items3_fx/star_emblem_friend_shield.vpcf" end
function modifier_imba_sloar_buff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_sloar_buff:GetTexture()		return "item_solar_crest_png" end	
function modifier_imba_sloar_buff:DeclareFunctions() return 
	{
		
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	} 
end

function modifier_imba_sloar_buff:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.asp = self.ab:GetSpecialValueFor("attack_speed") or 0
	self.msp = self.ab:GetSpecialValueFor("move_speed_max_f") or 0
	self.armor = self:GetParent() == self:GetCaster() and 0 or (self.ab:GetSpecialValueFor("armor") or 0) 
	self.miss =self:GetParent() == self:GetCaster() and 0 or (self.ab:GetSpecialValueFor("miss") or 0) 
	self.msp_min = self.ab:GetSpecialValueFor("move_speed_min") or 0
	if IsServer() then
		self:SetStackCount(self.msp)
		if self:GetParent() == self:GetCaster() then
			self.armor = 0
			self.miss = 0
		end
		self:StartIntervalThink(0.5)
	end
end
function modifier_imba_sloar_buff:OnRefresh()
		self:OnCreated()
end
function modifier_imba_sloar_buff:OnIntervalThink()
	if self.msp > self.msp_min then
		self.msp = self.msp - 5
		self:SetStackCount(self.msp)
	end
end
function modifier_imba_sloar_buff:GetModifierPhysicalArmorBonus()
	return self.armor
end
function modifier_imba_sloar_buff:GetModifierAttackSpeedBonus_Constant()
	return self.asp
end
function modifier_imba_sloar_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end
function modifier_imba_sloar_buff:GetModifierEvasion_Constant()
	return self.miss
end


modifier_imba_sloar_debuff = class({})
function modifier_imba_sloar_debuff:IsDebuff()			return true end
function modifier_imba_sloar_debuff:IsHidden() 			return false end
function modifier_imba_sloar_debuff:IsPurgable() 			return false end
function modifier_imba_sloar_debuff:GetEffectName() return "particles/items3_fx/star_emblem_brokenshield.vpcf" end
function modifier_imba_sloar_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_sloar_debuff:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_sloar_debuff:GetTexture()		return "item_solar_crest_png" end
function modifier_imba_sloar_debuff:DeclareFunctions() return 
	{
		
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	} 
end

function modifier_imba_sloar_debuff:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.asp = self.ab:GetSpecialValueFor("attack_speed")*-1 or 0
	self.msp = self.ab:GetSpecialValueFor("move_speed_max_e") or 0
	self.armor = self.ab:GetSpecialValueFor("armor")*-1 or 0
	self.msp_min = self.ab:GetSpecialValueFor("move_speed_min") or 0
	if IsServer() then
		self:SetStackCount(self.msp)
		self:StartIntervalThink(0.5)
	end
end
function modifier_imba_sloar_debuff:OnRefresh()
		self:OnCreated()
end
function modifier_imba_sloar_debuff:OnIntervalThink()
	if self.msp > self.msp_min then
		self.msp = self.msp - 20
		self:SetStackCount(self.msp)
	end
end

function modifier_imba_sloar_debuff:GetModifierPhysicalArmorBonus()
	return self.armor
end
function modifier_imba_sloar_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.asp
end
function modifier_imba_sloar_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()*-1
end

function modifier_imba_sloar_debuff:CheckState() return
	{	
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = false,
	} 
end

--[[modifier_item_imba_orb_passive = class({})
function modifier_item_imba_orb_passive:IsDebuff()			return false end
function modifier_item_imba_orb_passive:IsHidden() 			return true end
function modifier_item_imba_orb_passive:IsPurgable() 		return false end
function modifier_item_imba_orb_passive:IsPurgeException() 	return false end
function modifier_item_imba_orb_passive:DeclareFunctions() return 
	{
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,	
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	} 
end
function modifier_item_imba_orb_passive:CheckState()
		return {
			[MODIFIER_STATE_UNSLOWABLE]	= true
		}
end
function modifier_item_imba_orb_passive:OnCreated()
	if self:GetAbility()  then
	local ab = self:GetAbility() 
	self.hp = ab:GetSpecialValueFor("bonus_health")
	self.mp = ab:GetSpecialValueFor("bonus_mana")
	self.hp_re = ab:GetSpecialValueFor("hp_re")
	self.mp_re = ab:GetSpecialValueFor("mana_re")
	self.armor = ab:GetSpecialValueFor("bonus_armor")
	self.heal = ab:GetSpecialValueFor("heal_bonus")
end
end
function modifier_item_imba_orb_passive:GetModifierConstantManaRegen()
	return self.mp_re
end	
function modifier_item_imba_orb_passive:GetModifierHealthBonus()
	return self.hp
end
function modifier_item_imba_orb_passive:GetModifierManaBonus()
	return self.mp
end
function modifier_item_imba_orb_passive:GetModifierPhysicalArmorBonus()
	return self.armor
end
function modifier_item_imba_orb_passive:GetModifierConstantHealthRegen()
	return self.hp_re
end
function modifier_item_imba_orb_passive:GetModifierHPRegenAmplify_Percentage()
	return self.heal
end

function modifier_item_imba_orb_passive:GetModifierLifestealRegenAmplify_Percentage ()
	return self.heal
end]]