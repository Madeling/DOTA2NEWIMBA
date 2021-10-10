item_eternal_armor = class({})
LinkLuaModifier("modifier_eternal_armor_passive", "ting/items/item_eternal_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_eternal_armor_buff", "ting/items/item_eternal_armor", LUA_MODIFIER_MOTION_NONE)
function item_eternal_armor:GetIntrinsicModifierName() return "modifier_eternal_armor_passive" end
function item_eternal_armor:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	if not caster:IsHero() then return end
	caster:EmitSound("DOTA_Item.Pipe.Activate")
	caster:AddNewModifier(caster,self,"modifier_eternal_armor_buff",{duration = self:GetSpecialValueFor("duration")})
end

modifier_eternal_armor_passive = class({})
LinkLuaModifier("modifier_eternal_armor_buff", "ting/items/item_eternal_armor", LUA_MODIFIER_MOTION_NONE)
function modifier_eternal_armor_passive:IsDebuff()			return false end
function modifier_eternal_armor_passive:IsHidden() 			return true end
function modifier_eternal_armor_passive:IsPurgable() 		return false end
function modifier_eternal_armor_passive:IsPurgeException() 	return false end
function modifier_eternal_armor_passive:DeclareFunctions() return {	
	MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_MANA_BONUS,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}end
function modifier_eternal_armor_passive:OnCreated() 
	self.block = self:GetAbility():GetSpecialValueFor("block_stack")
	self.magic_resistance = self:GetAbility():GetSpecialValueFor("magic_resistance")
	self.hp_per = self:GetAbility():GetSpecialValueFor("hp_per")*0.01
	self.mana_per = self:GetAbility():GetSpecialValueFor("mana_per")*0.01
	self.mana = self:GetAbility():GetSpecialValueFor("mana")
	self.lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal")
	self.hp_re = self:GetAbility():GetSpecialValueFor("health_regen")
end
function modifier_eternal_armor_passive:OnAttackLanded(keys) 
	if not IsServer() then
		return
	end
	
	if keys.target ~= self:GetParent() or not keys.target:IsAlive() or not self:GetParent():HasModifier("modifier_eternal_armor_buff") then
		return
	end
	local damage = self:GetParent():GetLevel()*self.block
	local damageTable = {
                         victim = keys.target,
                         attacker = keys.target,
                         damage = damage,
                         damage_type =DAMAGE_TYPE_MAGICAL,
                         damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, 
                         ability = self:GetAbility(),
                        }
                        ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, damage, nil)
end
function modifier_eternal_armor_passive:GetModifierMagicalResistanceBonus() 
	return self.magic_resistance
end
function modifier_eternal_armor_passive:GetModifierManaBonus() 
	return self.mana
end
function modifier_eternal_armor_passive: GetModifierConstantHealthRegen() 
	return self.hp_re
end
function modifier_eternal_armor_passive:GetModifierMagical_ConstantBlock(keys)
	if not IsServer() then return end
	local damage_block = self:GetParent():GetLevel()*self.block
	if keys.damage <= damage_block then
		damage_block = keys.damage
	end
	if keys.damage > self:GetParent():GetMaxHealth()*self.hp_per then 
		damage_block = math.max(keys.damage*keys.target:GetMaxMana()*self.mana_per*0.01,damage_block)
	end
	if self:GetParent():HasModifier("modifier_eternal_armor_buff") then
		self:GetParent():Heal(damage_block, self:GetParent())
		self:GetParent():GiveMana(damage_block)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetCaster(), damage_block, nil)
	end
	if damage_block > self:GetParent():GetLevel()*self.block then
		self:GetParent():SpendMana( damage_block*0.75,self:GetAbility()) 
	end
	
	return damage_block
end
function modifier_eternal_armor_passive:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and keys.inflictor and IsEnemy(keys.attacker, keys.unit) and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
		local lifesteal = self.lifesteal 

		local dmg = keys.damage * (lifesteal / 100)
		if keys.unit:IsCreep() then
			dmg = dmg / 5
		end
		self:GetParent():Heal(dmg, self:GetAbility())
		local pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_plasma.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(pfx)
		
	end
end

modifier_eternal_armor_buff = class({})
function modifier_eternal_armor_buff:IsDebuff()			return false end
function modifier_eternal_armor_buff:IsHidden() 			return false end
function modifier_eternal_armor_buff:IsPurgable() 			return false end
function modifier_eternal_armor_buff:RemoveOnDeath()		return false end
function modifier_eternal_armor_buff:IsPurgeException() 	return true end
function modifier_eternal_armor_buff:GetTexture()			return "item_eternal_armor" end
function modifier_eternal_armor_buff:OnCreated()
	self.parent = self:GetParent()
	if IsServer() then
		if not self.particle then
		self.particle = ParticleManager:CreateParticle("particles/items2_fx/eternal_shroud.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_origin", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle, 2, Vector(self.parent:GetModelRadius() * 1.1,0,0))
		end
	end
end


function modifier_eternal_armor_buff:OnDestroy()
	if self.particle and IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
	self.particle = nil
end
