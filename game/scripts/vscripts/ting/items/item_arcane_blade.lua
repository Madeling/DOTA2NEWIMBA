item_imba_arcane = class({})
LinkLuaModifier("modifier_imba_arcane_passive", "ting/items/item_arcane_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_arcane_on", "ting/items/item_arcane_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_arcane_debug", "ting/items/item_arcane_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_arcane_debuff", "ting/items/item_arcane_blade", LUA_MODIFIER_MOTION_NONE)
function item_imba_arcane:GetIntrinsicModifierName() return "modifier_imba_arcane_passive" end
function item_imba_arcane:GetAbilityTextureName() return 
					(self:GetCaster():HasModifier("modifier_imba_arcane_on") 
					and "tome_of_knowledge2" or "tome_of_knowledge1") end

function item_imba_arcane:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	if not caster:IsHero() then return end
	local speed = self:GetCaster():GetProjectileSpeed()
	if caster:HasModifier("modifier_imba_arcane_on") then 
	caster:RemoveModifierByName("modifier_imba_arcane_on")
	else
	caster:AddNewModifier(caster,self,"modifier_imba_arcane_on",{duration = -1})
	self:StartCooldown(5) 
	end
	
end

modifier_imba_arcane_passive = class({})
LinkLuaModifier("modifier_item_imba_arcane_debug", "ting/items/item_arcane_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_arcane_debuff", "ting/items/item_arcane_blade", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_arcane_passive:IsDebuff()			return false end
function modifier_imba_arcane_passive:IsHidden() 			return true end
function modifier_imba_arcane_passive:IsPurgable() 		return false end
function modifier_imba_arcane_passive:IsPurgeException() 	return false end
function modifier_imba_arcane_passive:OnCreated() 
	self.ab = self:GetAbility()
	self.asp = self.ab:GetSpecialValueFor("asp")
	self.int = self.ab:GetSpecialValueFor("int")
	self.arrmor = self.ab:GetSpecialValueFor("arrmor")
	self.sp = self.ab:GetSpecialValueFor("sp")
	self.int_damage = self.ab:GetSpecialValueFor("int_damage")
	self.speed = self.ab:GetSpecialValueFor("project_speed_bonus")
	self.duration = self.ab:GetSpecialValueFor("duration")
	
	
end
function modifier_imba_arcane_passive:DeclareFunctions() return {	
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}end

function modifier_imba_arcane_passive:GetModifierProcAttack_BonusDamage_Magical(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and not keys.target:IsBuilding() then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self:GetParent():GetBaseIntellect(), nil)
	    return  self:GetParent():GetBaseIntellect()*self.int_damage
		end
	end
end 

function modifier_imba_arcane_passive:OnAttackLanded(keys)	

	if keys.attacker == self:GetParent() and IsServer() and not keys.target:IsBuilding() and not keys.target:IsOther()then
		keys.target:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_item_imba_arcane_debuff",{duration = self.duration})
	end
	
end
function modifier_imba_arcane_passive:GetModifierProjectileSpeedBonus()
    return  self.speed
end
function modifier_imba_arcane_passive:GetModifierAttackSpeedBonus_Constant() return self.asp end
function modifier_imba_arcane_passive:GetModifierBonusStats_Intellect() return self.int end
function modifier_imba_arcane_passive:GetModifierPhysicalArmorBonus() return self.arrmor end
function modifier_imba_arcane_passive:OnDestroy()
	if IsServer() 	then	
		self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_item_imba_arcane_debug",{duration = 0.3})
	end
	self.asp = nil
	self.int = nil
	self.arrmor = nil
	self.sp = nil
	self.speed = nil
	self.int_damage = nil
	self.duration = nil
	self.ab = nil
end

modifier_imba_arcane_on = class({})
function modifier_imba_arcane_on:IsDebuff()			return false end
function modifier_imba_arcane_on:IsHidden() 			return false end
function modifier_imba_arcane_on:IsPurgable() 		return false end
function modifier_imba_arcane_on:IsPurgeException() 	return false end
function modifier_imba_arcane_on:GetTexture()			return "item_tome_of_knowledge2" end
function modifier_imba_arcane_on:DeclareFunctions() return {	
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_PROJECTILE_NAME,
	MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
} end

function modifier_imba_arcane_on:OnCreated()
	self.ab = self:GetAbility()
	self.mana_cost = self.ab:GetSpecialValueFor("mana_cost_per")/2	--每秒掉蓝
	self.attack_magic = self.ab:GetSpecialValueFor("attack_magic")*0.01	--攻击额外魔法伤害
	self.manacost_stack = self.ab:GetSpecialValueFor("attack_mana")/2	--攻击增加消耗的蓝
	self.sp = self.ab:GetSpecialValueFor("sp")	--法强
	self.nerf = self.ab:GetSpecialValueFor("damage_nerf")	--自身全伤害削弱
	if IsServer() then
	self.caster = self:GetCaster()
	local speed = self:GetParent():GetProjectileSpeed() or 1000		
	self.speed = math.max(self.ab:GetSpecialValueFor("project_speed_on")-speed,0)	--增加的弹道速度
	end 
	self:StartIntervalThink(0.5)
end

function modifier_imba_arcane_on:GetModifierProjectileSpeedBonus()
    return  self.speed
end 
function modifier_imba_arcane_on:GetModifierTotalDamageOutgoing_Percentage()
    return  self.nerf*-1
end 

function modifier_imba_arcane_on:OnDestroy()
	self:StartIntervalThink(-1)

	self.attack_magic = nil 
	self.mana_cost = nil
	self.manacost_stack  = nil
	self.sp = nil
	self.asp_e = nil
	self.sp_e = nil
	self.stack = nil
	self.ab = nil
end
function modifier_imba_arcane_on:OnIntervalThink()

	if IsServer() then
	if self.caster:GetMana() > self.mana_cost then 
	self.caster:ReduceMana(self.mana_cost)
	else
	self:Destroy()
	end
	end
end
function modifier_imba_arcane_on:GetModifierProjectileName() 
	return "particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_base_attack.vpcf" 
end

function modifier_imba_arcane_on:GetModifierSpellAmplify_Percentage()
	return self.sp
end
function modifier_imba_arcane_on:OnAttackLanded(keys)
	
	if keys.attacker == self:GetParent() and IsServer() and not keys.target:IsBuilding() and not keys.target:IsOther()then
	local damage = math.ceil(keys.original_damage*self.attack_magic)
	ApplyDamage(  
		{
		victim = keys.target,
		attacker = self:GetParent(),
		damage = damage,	
		ability = self:GetAbility(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		}
		)
	self.mana_cost = self.mana_cost+self.manacost_stack 
	--self.caster:ReduceMana(self.caster:GetMaxMana()*0.01*self.attack_mana)
	end
end



modifier_item_imba_arcane_debug = class({})
function modifier_item_imba_arcane_debug:IsDebuff()			return false end
function modifier_item_imba_arcane_debug:IsHidden() 			return true end
function modifier_item_imba_arcane_debug:IsPurgable() 		return false end
function modifier_item_imba_arcane_debug:IsPurgeException() 	return false end
function modifier_item_imba_arcane_debug:OnDestroy()
		if IsServer() then 
			if self:GetParent():HasModifier("modifier_imba_arcane_passive") then 
			self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_arcane_on",{duration = -1})
			else
			self:GetParent():RemoveModifierByName("modifier_imba_arcane_on")
			end
		end
end
modifier_item_imba_arcane_debuff = class({})
function modifier_item_imba_arcane_debuff:IsDebuff()			return true end
function modifier_item_imba_arcane_debuff:IsHidden() 			return false end
function modifier_item_imba_arcane_debuff:IsPurgable() 			return false end
function modifier_item_imba_arcane_debuff:IsPurgeException() 	return false end
function modifier_item_imba_arcane_debuff:GetTexture()			return "item_tome_of_knowledge2" end
function modifier_item_imba_arcane_debuff:DeclareFunctions() return {	
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}end
function modifier_item_imba_arcane_debuff:OnRefresh()
	if IsServer() then
		if self:GetStackCount() > self.max_stack -1  then
			self:SetStackCount(self.max_stack)
		else
		self:IncrementStackCount()
		end
	end
end
function modifier_item_imba_arcane_debuff:OnCreated()
		self.magic_armor_nerf = self:GetAbility():GetSpecialValueFor("magic_armor_nerf")
		self.max_stack = self:GetAbility():GetSpecialValueFor("max_stack")
		self.move_slow = self:GetAbility():GetSpecialValueFor("slow")
		self:SetStackCount(1)
end

function modifier_item_imba_arcane_debuff:OnDestroy()
	self.magic_armor_nerf = nil
	self.max_stack = nil
end
function modifier_item_imba_arcane_debuff:GetModifierMagicalResistanceBonus()
	return -1*self.magic_armor_nerf*self:GetStackCount()
end
function modifier_item_imba_arcane_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -1*self.move_slow*self:GetStackCount()
end
