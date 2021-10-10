
--"imba_armlet_active"

item_imba_armlet = class({})

LinkLuaModifier("modifier_imba_armlet_passive", "ting/items/item_armlet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_armlet_active_unique", "ting/items/item_armlet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_armlet_stacks", "ting/items/item_armlet", LUA_MODIFIER_MOTION_NONE)

function item_imba_armlet:GetIntrinsicModifierName() return "modifier_imba_armlet_passive" end

function item_imba_armlet:GetAbilityTextureName() return (self:GetCaster():GetModifierStackCount("modifier_imba_armlet_active_unique", nil) > 0 and "imba_armlet_active" or "imba_armlet") end

function item_imba_armlet:OnSpellStart()
	local caster = self:GetCaster()
	local buff = caster:FindModifierByName("modifier_imba_armlet_active_unique")
	if not buff then
		return nil
	end
	if caster:GetModifierStackCount("modifier_imba_armlet_active_unique", nil) == 0 then
		caster:EmitSound("DOTA_Item.Armlet.Activate")
		buff:StartIntervalThink(0.4 / self:GetSpecialValueFor("unholy_bonus_strength"))
		caster:CalculateStatBonus(true)
		caster:AddNewModifier(caster, self, "modifier_item_imba_armlet_stacks", {})
	else		
		caster:EmitSound("DOTA_Item.Armlet.DeActivate")
		local count = caster:GetModifierStackCount("modifier_imba_armlet_active_unique", nil)
		buff:StartIntervalThink(-1)
		caster:ModifyHealth(math.max(caster:GetHealth()-count*20,1),self,false,DOTA_DAMAGE_FLAG_REFLECTION)
		buff:SetStackCount(0)
		caster:CalculateStatBonus(true)
		caster:RemoveModifierByName("modifier_item_imba_armlet_stacks")
		if buff.pfx then
			ParticleManager:DestroyParticle(buff.pfx, false)
			ParticleManager:ReleaseParticleIndex(buff.pfx)
			buff.pfx = nil
		end
	end
	self:OnHeroCalculateStatBonus()
end

modifier_imba_armlet_passive = class({})

function modifier_imba_armlet_passive:IsDebuff()		return false end
function modifier_imba_armlet_passive:IsHidden() 		return true end
function modifier_imba_armlet_passive:IsPurgable() 		return false end
function modifier_imba_armlet_passive:IsPurgeException() return false end
function modifier_imba_armlet_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_armlet_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT} end
function modifier_imba_armlet_passive:GetModifierPreAttack_BonusDamage() return self.att end
function modifier_imba_armlet_passive:GetModifierAttackSpeedBonus_Constant() return self.as end
function modifier_imba_armlet_passive:GetModifierPhysicalArmorBonus() return self.ar end
function modifier_imba_armlet_passive:GetModifierConstantHealthRegen() return self.hp_re end

function modifier_imba_armlet_passive:OnCreated()
	if not self:GetAbility() then   
		return 
	end 
	self.att = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.as = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.ar = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.hp_re = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_armlet_active_unique", {})
	end
end

function modifier_imba_armlet_passive:OnDestroy()
	if IsServer() and not self:GetParent():HasModifier("modifier_imba_armlet_passive") then
		self:GetParent():RemoveModifierByName("modifier_imba_armlet_active_unique")
		self:GetParent():RemoveModifierByName("modifier_item_imba_armlet_stacks")
	end
end

modifier_imba_armlet_active_unique = class({})

function modifier_imba_armlet_active_unique:IsDebuff()			return false end
function modifier_imba_armlet_active_unique:IsHidden() 			return true end
function modifier_imba_armlet_active_unique:IsPurgable() 		return false end
function modifier_imba_armlet_active_unique:IsPurgeException() 	return false end
function modifier_imba_armlet_active_unique:DeclareFunctions() return {MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
function modifier_imba_armlet_active_unique:GetModifierPhysicalArmorBonus() return (self:GetStackCount() > 0 and self.ar or 0) end
function modifier_imba_armlet_active_unique:GetModifierPreAttack_BonusDamage() return (self:GetStackCount() > 0 and self.ad or 0) end
function modifier_imba_armlet_active_unique:GetModifierExtraStrengthBonus()
	return self:GetStackCount()
end
function modifier_imba_armlet_active_unique:OnCreated()
	if not self:GetAbility() then   
		return 
	end 
	self.str = self:GetAbility():GetSpecialValueFor("unholy_bonus_strength")
	self.ar = self:GetAbility():GetSpecialValueFor("unholy_bonus_armor")
	self.ad = self:GetAbility():GetSpecialValueFor("unholy_bonus_damage")
end

function modifier_imba_armlet_active_unique:OnDestroy()
	if not IsServer() then return end
	self:SetStackCount(0)
	self:GetParent():CalculateStatBonus(true)
	if IsServer() and self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
		self.pfx = nil
	end
end

function modifier_imba_armlet_active_unique:OnIntervalThink()
	if not self.pfx then
		self.pfx = ParticleManager:CreateParticle("particles/items_fx/armlet.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
	self:SetStackCount(self:GetStackCount() + 1)
	self:GetParent():CalculateStatBonus(true)	
	self:GetParent():ModifyHealth(self:GetParent():GetHealth()+20,self:GetAbility(),false,DOTA_DAMAGE_FLAG_REFLECTION)
	if self:GetStackCount() >= self.str then
		self:SetStackCount(self.str)
		self:StartIntervalThink(-1)
	end
end

modifier_item_imba_armlet_stacks = class({})

function modifier_item_imba_armlet_stacks:IsDebuff()			return false end
function modifier_item_imba_armlet_stacks:IsHidden() 			return (self:GetParent():GetModifierStackCount("modifier_imba_armlet_active_unique", nil) == 0 and true or false) end
function modifier_item_imba_armlet_stacks:IsPurgable() 			return false end
function modifier_item_imba_armlet_stacks:IsPurgeException() 	return false end
function modifier_item_imba_armlet_stacks:GetTexture()			return "item_armlet_active" end
function modifier_item_imba_armlet_stacks:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_item_imba_armlet_stacks:GetModifierPreAttack_BonusDamage() return self.ad * self:GetStackCount() end
function modifier_item_imba_armlet_stacks:GetModifierAttackSpeedBonus_Constant() return self.as * self:GetStackCount() end
function modifier_item_imba_armlet_stacks:GetModifierPhysicalArmorBonus() return self.ar * self:GetStackCount() end

function modifier_item_imba_armlet_stacks:OnCreated()
	if not self:GetAbility() then   
		return 
	end 
	self.hp = self:GetAbility():GetSpecialValueFor("unholy_health_drain")
	self.health_per_stack = self:GetAbility():GetSpecialValueFor("health_per_stack")
	self.ad = self:GetAbility():GetSpecialValueFor("stack_damage")
	self.as = self:GetAbility():GetSpecialValueFor("stack_as")
	self.ar = self:GetAbility():GetSpecialValueFor("stack_armor")
	if IsServer() then
		self:SetStackCount(math.floor((self:GetParent():GetMaxHealth() - self:GetParent():GetHealth()) / self.health_per_stack))
		self:StartIntervalThink(0.3)
	end
end


function modifier_item_imba_armlet_stacks:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_item_imba_armlet_v2_stacks") then
		self:SetStackCount(0)
		else
		self:SetStackCount(math.floor((self:GetParent():GetMaxHealth() - self:GetParent():GetHealth()) / self.health_per_stack))
	end
	local hp_loss = self.hp / (1.0 / 0.3)
	self:GetParent():ModifyHealth(math.max(1, self:GetParent():GetHealth() - hp_loss),self:GetAbility(),false,DOTA_DAMAGE_FLAG_REFLECTION)
end


item_imba_armlet_v2 = class({})
LinkLuaModifier("modifier_imba_armlet_v2_passive", "ting/items/item_armlet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_armlet_v2_active_unique", "ting/items/item_armlet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_armlet_v2_stacks", "ting/items/item_armlet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_armlet_v2_exhp", "ting/items/item_armlet", LUA_MODIFIER_MOTION_NONE)
function item_imba_armlet_v2:GetIntrinsicModifierName() return "modifier_imba_armlet_v2_passive" end

function item_imba_armlet_v2:GetAbilityTextureName() return (self:GetCaster():GetModifierStackCount("modifier_imba_armlet_v2_active_unique", nil) > 0 and "armlet_active_v2" or "armlet_v2") end

function item_imba_armlet_v2:OnSpellStart()
	local caster = self:GetCaster()
	local buff = caster:FindModifierByName("modifier_imba_armlet_v2_active_unique")
	if not buff then
		return nil
	end
	if caster:GetModifierStackCount("modifier_imba_armlet_v2_active_unique", nil) == 0 then
		caster:EmitSound("DOTA_Item.Armlet.Activate")
		buff:StartIntervalThink(0.4 / self:GetSpecialValueFor("unholy_bonus_strength"))
		caster:CalculateStatBonus(true)
		caster:AddNewModifier(caster, self, "modifier_item_imba_armlet_v2_stacks", {})	
	else		
		caster:EmitSound("DOTA_Item.Armlet.DeActivate")
		local count = caster:GetModifierStackCount("modifier_imba_armlet_v2_active_unique", nil)
		buff:StartIntervalThink(-1)
		caster:ModifyHealth(math.max(caster:GetHealth()-count*20,1),self,false,DOTA_DAMAGE_FLAG_REFLECTION)
		buff:SetStackCount(0)
		caster:RemoveModifierByName("modifier_item_imba_armlet_v2_stacks")
		caster:CalculateStatBonus(true)
		if buff.pfx then
			ParticleManager:DestroyParticle(buff.pfx, false)
			ParticleManager:ReleaseParticleIndex(buff.pfx)
			buff.pfx = nil
		end
	end
	self:OnHeroCalculateStatBonus()
end

modifier_imba_armlet_v2_passive = class({})

function modifier_imba_armlet_v2_passive:IsDebuff()		return false end
function modifier_imba_armlet_v2_passive:IsHidden() 		return true end
function modifier_imba_armlet_v2_passive:IsPurgable() 		return false end
function modifier_imba_armlet_v2_passive:IsPurgeException() return false end
function modifier_imba_armlet_v2_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_armlet_v2_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT} end
function modifier_imba_armlet_v2_passive:GetModifierPreAttack_BonusDamage() return self.att end
function modifier_imba_armlet_v2_passive:GetModifierAttackSpeedBonus_Constant() return self.as end
function modifier_imba_armlet_v2_passive:GetModifierPhysicalArmorBonus() return self.ar end
function modifier_imba_armlet_v2_passive:GetModifierConstantHealthRegen() return self.hp_re end

function modifier_imba_armlet_v2_passive:OnCreated()
	if not self:GetAbility() then   
		return 
	end 
	self.att = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.as = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.ar = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.hp_re = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_armlet_v2_active_unique", {})
	end
end

function modifier_imba_armlet_v2_passive:OnDestroy()
	if IsServer() and not self:GetParent():HasModifier("modifier_imba_armlet_v2_passive") then
		self:GetParent():RemoveModifierByName("modifier_imba_armlet_v2_active_unique")
		self:GetParent():RemoveModifierByName("modifier_item_imba_armlet_v2_stacks")
	end
end

modifier_imba_armlet_v2_active_unique = class({})

function modifier_imba_armlet_v2_active_unique:IsDebuff()			return false end
function modifier_imba_armlet_v2_active_unique:IsHidden() 			return true end
function modifier_imba_armlet_v2_active_unique:IsPurgable() 		return false end
function modifier_imba_armlet_v2_active_unique:IsPurgeException() 	return false end
function modifier_imba_armlet_v2_active_unique:DeclareFunctions() return {MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
function modifier_imba_armlet_v2_active_unique:GetModifierPhysicalArmorBonus() return (self:GetStackCount() > 0 and self.ar or 0) end
function modifier_imba_armlet_v2_active_unique:GetModifierPreAttack_BonusDamage() return (self:GetStackCount() > 0 and self.ad or 0) end
function modifier_imba_armlet_v2_active_unique:GetModifierExtraStrengthBonus()
	return self:GetStackCount()
end
function modifier_imba_armlet_v2_active_unique:OnCreated()
	if not self:GetAbility() then   
		return 
	end 
	self.str = self:GetAbility():GetSpecialValueFor("unholy_bonus_strength")
	self.ar = self:GetAbility():GetSpecialValueFor("unholy_bonus_armor")
	self.ad = self:GetAbility():GetSpecialValueFor("unholy_bonus_damage")
end

function modifier_imba_armlet_v2_active_unique:OnDestroy()
	if not IsServer() then return end
	self:SetStackCount(0)
	self:GetParent():CalculateStatBonus(true)
	if IsServer() and self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
		self.pfx = nil
	end
	self:StartIntervalThink(-1)
end

function modifier_imba_armlet_v2_active_unique:OnIntervalThink()
	if not self.pfx then
		self.pfx = ParticleManager:CreateParticle("particles/items_fx/armlet.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
	self:SetStackCount(self:GetStackCount() + 1)
	self:GetParent():CalculateStatBonus(true)	
	self:GetParent():ModifyHealth(self:GetParent():GetHealth()+20,self:GetAbility(),false,DOTA_DAMAGE_FLAG_REFLECTION)
	if self:GetStackCount() >= self.str then
		self:SetStackCount(self.str)
		self:StartIntervalThink(-1)
	end
end

modifier_item_imba_armlet_v2_stacks = class({})
LinkLuaModifier("modifier_imba_armlet_v2_exhp", "ting/items/item_armlet", LUA_MODIFIER_MOTION_NONE)
function modifier_item_imba_armlet_v2_stacks:IsDebuff()			return false end
function modifier_item_imba_armlet_v2_stacks:IsHidden() 			return false end
function modifier_item_imba_armlet_v2_stacks:IsPurgable() 			return false end
function modifier_item_imba_armlet_v2_stacks:IsPurgeException() 	return false end
function modifier_item_imba_armlet_v2_stacks:GetTexture()			return "item_armlet_active_v2" end
function modifier_item_imba_armlet_v2_stacks:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_item_imba_armlet_v2_stacks:GetModifierAttackSpeedBonus_Constant() return self.as * self:GetStackCount() end
function modifier_item_imba_armlet_v2_stacks:GetModifierPhysicalArmorBonus() return self.ar * self:GetStackCount() end

function modifier_item_imba_armlet_v2_stacks:OnCreated()
	if not self:GetAbility() then   
		return 
	end 
	self.as = self:GetAbility():GetSpecialValueFor("stack_as")
	self.ar = self:GetAbility():GetSpecialValueFor("stack_armor")
	self.cri = self:GetAbility():GetSpecialValueFor("cri")
	self.hp_cost = self:GetAbility():GetSpecialValueFor("hp_cost")
	self.hp_ex = self:GetAbility():GetSpecialValueFor("hp_ex")*0.01
	self.stack_cri = self:GetAbility():GetSpecialValueFor("stack_cri")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	if IsServer() then
		self:SetStackCount((self:GetParent():GetMaxHealth() - self:GetParent():GetHealth())/self:GetParent():GetMaxHealth()*100)
		self:StartIntervalThink(0.3)
	end
end

function modifier_item_imba_armlet_v2_stacks:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() then
			if not keys.attacker:HasModifier("modifier_imba_armlet_v2_exhp") then
				local hp = keys.target:GetHealth()*self.hp_ex
				local dmg = keys.target:GetHealth()-hp
				if dmg>0 then
					keys.target:ModifyHealth(math.max(1,dmg),self:GetAbility(),false,DOTA_DAMAGE_FLAG_REFLECTION)
				end 
				keys.target:EmitSound("Hero_LifeStealer.Consume")
				local infest_particle = ParticleManager:CreateParticle("particles/items3_fx/iron_talon_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
				ParticleManager:SetParticleControl(infest_particle, 0, keys.target:GetOrigin())
				ParticleManager:SetParticleControl(infest_particle, 1, keys.target:GetOrigin())
				ParticleManager:ReleaseParticleIndex(infest_particle)
				
				local mod = keys.attacker:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_imba_armlet_v2_exhp",{duration = self.duration})
				if mod~=nil then
					mod:SetStackCount(hp)
					self:GetParent():CalculateStatBonus(true)
				end
				
			end	
			return self.cri + self:GetStackCount()*self.stack_cri
		else
			return 0
	end
end


function modifier_item_imba_armlet_v2_stacks:OnDestroy()
	if IsServer() then
	self:StartIntervalThink(-1)
	end
end

function modifier_item_imba_armlet_v2_stacks:OnIntervalThink()
		self:SetStackCount((self:GetParent():GetMaxHealth() - self:GetParent():GetHealth())/self:GetParent():GetMaxHealth()*100)
		local hp_loss = self:GetParent():GetHealth()*self.hp_cost*0.01
		self:GetParent():ModifyHealth(math.max(1, self:GetParent():GetHealth() - hp_loss),self:GetAbility(),false,DOTA_DAMAGE_FLAG_REFLECTION)
end

modifier_imba_armlet_v2_exhp = class({})

function modifier_imba_armlet_v2_exhp:IsDebuff()			return false end
function modifier_imba_armlet_v2_exhp:IsHidden() 			return false end
function modifier_imba_armlet_v2_exhp:IsPurgable() 		return false end
function modifier_imba_armlet_v2_exhp:IsPurgeException() 	return false end
function modifier_imba_armlet_v2_exhp:GetTexture()			return "item_armlet_active_v2" end
function modifier_imba_armlet_v2_exhp:DeclareFunctions() return {MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS} end

function modifier_imba_armlet_v2_exhp:GetModifierExtraHealthBonus()
	return self:GetStackCount()
end