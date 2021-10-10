--额外降低50%克敌机先
item_imba_radiance = class({})

LinkLuaModifier("modifier_imba_radiance_passive", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_radiance_unique", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_radiance_debuff", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_splendid_debug", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_radiance_cd", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)
function item_imba_radiance:GetIntrinsicModifierName() return "modifier_imba_radiance_passive" end

function item_imba_radiance:GetCastRange()
	if not IsServer() then
		return (self:GetSpecialValueFor("aura_radius") - self:GetCaster():GetCastRangeBonus())
	end
end

function item_imba_radiance:GetAbilityTextureName()
	if self:GetCaster():GetModifierStackCount("modifier_imba_radiance_unique", nil) == 0 then
		return "radiance"
	else
		return "radiance_inactive"
	end
end

function item_imba_radiance:OnSpellStart()
	local buff = self:GetCaster():FindModifierByName("modifier_imba_radiance_unique")
	if buff~=nil then 
	if buff:GetStackCount() == 0 then
		buff:SetStackCount(1)
		buff:Inactive()
	else
		buff:SetStackCount(0)
		buff:Active()
	end
end
end


modifier_imba_radiance_passive = class({})
function modifier_imba_radiance_passive:IsDebuff()			return false end
function modifier_imba_radiance_passive:IsHidden() 			return true end
function modifier_imba_radiance_passive:IsPurgable() 		return false end
function modifier_imba_radiance_passive:IsPurgeException() 	return false end
LinkLuaModifier("modifier_imba_splendid_debug", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_radiance_passive:OnCreated()
	if not self:GetAbility() then   
        return 
    end 
		self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage") 
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_radiance_unique", {})
	end
end

function modifier_imba_radiance_passive:OnDestroy()
	if IsServer() then 
			self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_imba_splendid_debug",{duration = 1.0})
	end
end

function modifier_imba_radiance_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_radiance_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_radiance_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
function modifier_imba_radiance_passive:GetModifierPreAttack_BonusDamage() return self.bonus_damage end


modifier_imba_radiance_unique = class({})
LinkLuaModifier("modifier_imba_radiance_cd", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_radiance_unique:IsDebuff()			return false end
function modifier_imba_radiance_unique:IsHidden() 			return true end
function modifier_imba_radiance_unique:IsPurgable() 		return false end
function modifier_imba_radiance_unique:IsPurgeException() 	return false end

function modifier_imba_radiance_unique:OnCreated()
	if not self:GetAbility() then   
        return 
    end 
	self.think = self:GetAbility():GetSpecialValueFor("think_interval")
	self.base_damage = self:GetAbility():GetSpecialValueFor("base_damage")
	self.extra_damage = self:GetAbility():GetSpecialValueFor("extra_damage")
	self.aura = self:GetAbility():GetSpecialValueFor("aura_radius")
	if IsServer() then
		self:Active()
		self:StartIntervalThink(self.think)
	end
end
function modifier_imba_radiance_unique:OnIntervalThink()
	if not IsServer() or  not self:GetCaster():IsAlive() then return end
	local enemy_creeps = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
	self:GetCaster():GetAbsOrigin(), nil,self.aura , 
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER, false)

	if #enemy_creeps>0 then
		for _,enemy in pairs(enemy_creeps) do
		if enemy:HasModifier("modifier_imba_radiance_cd") and not self:GetCaster():IsIllusion() then
			return
		end
		
		local dmg=0
		if enemy:GetMaxHealth()>=6000 then
			dmg = self.base_damage + enemy:GetMaxHealth() * (self.extra_damage / 100)
			else
			dmg = self.base_damage + enemy:GetHealth() * (self.extra_damage / 100)
		end
		
		if self:GetCaster():IsIllusion() then
			dmg = self.base_damage
		end
		if  not enemy:IsBuilding() and not enemy:IsBoss() then
			if not self:GetCaster():IsIllusion() then
			enemy:AddNewModifier(self:GetCaster(),self,"modifier_imba_radiance_cd",{duration = 0.9})
			end
			ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = self:GetAbility(), damage = dmg, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
			end
		end
	end
end

function modifier_imba_radiance_unique:Active()
	self.pfx1 = ParticleManager:CreateParticle("particles/items2_fx/radiance_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end

function modifier_imba_radiance_unique:Inactive()
	ParticleManager:DestroyParticle(self.pfx1, false)
	ParticleManager:ReleaseParticleIndex(self.pfx1)
	self.pfx1 = nil
end

function modifier_imba_radiance_unique:OnDestroy()

	if IsServer() and self.pfx1 then
		ParticleManager:DestroyParticle(self.pfx1, false)
		ParticleManager:ReleaseParticleIndex(self.pfx1)
		self.pfx1 = nil
	end
end

function modifier_imba_radiance_unique:RemoveOnDeath() return self:GetParent():IsIllusion() end
function modifier_imba_radiance_unique:IsAura() return (self:GetStackCount() == 0 and true or false) end
function modifier_imba_radiance_unique:GetAuraDuration() return 0.1 end
function modifier_imba_radiance_unique:GetModifierAura() return "modifier_imba_radiance_debuff" end
function modifier_imba_radiance_unique:GetAuraRadius() 
	if not self:GetAbility() then   
        return 
    end 
	local ability = self:GetAbility()
	if ability~=nil then 
		return ability:GetSpecialValueFor("aura_radius") 
	else 
		return 0
	end
end

function modifier_imba_radiance_unique:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_radiance_unique:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_radiance_unique:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_imba_radiance_cd = class({})

function modifier_imba_radiance_cd:IsDebuff()			return true end
function modifier_imba_radiance_cd:IsHidden() 			return true end
function modifier_imba_radiance_cd:IsPurgable() 		return false end
function modifier_imba_radiance_cd:IsPurgeException() 	return false end


modifier_imba_radiance_debuff = class({})

function modifier_imba_radiance_debuff:IsDebuff()			return true end
function modifier_imba_radiance_debuff:IsHidden() 			return false end
function modifier_imba_radiance_debuff:IsPurgable() 		return false end
function modifier_imba_radiance_debuff:IsPurgeException() 	return false end

function modifier_imba_radiance_debuff:OnCreated()
	if not self:GetAbility() then   
		return  
	end 
	self.pierce_proc = false

	self.miss_chance = self:GetAbility():GetSpecialValueFor("miss_chance")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.parent = self:GetParent()
end

function modifier_imba_radiance_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MISS_PERCENTAGE,MODIFIER_EVENT_ON_ATTACK_RECORD} end
function modifier_imba_radiance_debuff:GetModifierMiss_Percentage() return self.miss_chance end
function modifier_imba_radiance_debuff:GetTexture()			return "item_imba_radiance" end
function modifier_imba_radiance_debuff:OnAttackRecord(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self.parent then
		if self.pierce_proc then
			self.pierce_proc = false
		end
		if PseudoRandom:RollPseudoRandom(self:GetAbility(), self.chance) then
			self.pierce_proc = true
		end
	end
end

function modifier_imba_radiance_debuff:CheckState()
	local state = {}	
	if self.pierce_proc then
		state = {[MODIFIER_STATE_CANNOT_MISS] = false}
	end
	return state
end

function modifier_imba_radiance_debuff:GetPriority() return MODIFIER_PRIORITY_HIGH end







------------------------------------------------------------
--------辉煌耀世-------------------------------------

item_imba_splendid = class({})
LinkLuaModifier("modifier_imba_splendid_light", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_splendid_miss", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_splendid_passive", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_radiance_unique", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_radiance_debuff", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_splendid_debug", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_radiance_cd", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)
function item_imba_splendid:GetIntrinsicModifierName() return "modifier_imba_splendid_passive" end
function item_imba_splendid:OnSpellStart() -- 耀世
--	if not IsServer then return end
	local caster = self:GetCaster()
	caster:EmitSound("Item.CrimsonGuard.Cast")
	caster:AddNewModifier(caster, self, "modifier_imba_splendid_light",{duration = self:GetSpecialValueFor("duration_self")})	--辉煌
		local pfx = ParticleManager:CreateParticle("particles/world_outpost/world_outpost_channel_finish.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())		
		ParticleManager:ReleaseParticleIndex(pfx)
end

modifier_imba_splendid_passive = class({})
function modifier_imba_splendid_passive:IsDebuff()			return false end
function modifier_imba_splendid_passive:IsHidden() 			return true end
function modifier_imba_splendid_passive:IsPurgable() 		return false end
function modifier_imba_splendid_passive:IsPurgeException() 	return false end
LinkLuaModifier("modifier_imba_splendid_debug", "ting/items/item_radiance", LUA_MODIFIER_MOTION_NONE)


function modifier_imba_splendid_passive:OnCreated()
	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.duration = self:GetAbility():GetSpecialValueFor("miss_duration") 
	if not IsServer() then return end
	--self.pfx1 = ParticleManager:CreateParticle("particles/items2_fx/radiance_owner.vpcf" , PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_radiance_unique", {}) 
end
function modifier_imba_splendid_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end
function modifier_imba_splendid_passive:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_imba_splendid_passive:GetModifierBonusStats_Intellect() return self.bonus_all_stats end
function modifier_imba_splendid_passive:GetModifierBonusStats_Agility() return self.bonus_all_stats end
function modifier_imba_splendid_passive:GetModifierBonusStats_Strength() return self.bonus_all_stats end


function modifier_imba_splendid_passive:OnAttack(keys)
	if not IsServer() then 
		return 
	end
	if keys.target == self:GetParent() then
		if keys.attacker:IsMagicImmune() and not self:GetParent():HasModifier("modifier_imba_splendid_light") then 
			return 
		end
		keys.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_radiance_debuff",{duration = self.duration})
		
		if self:GetParent():HasModifier("modifier_imba_splendid_light") then 
		keys.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_splendid_miss",{duration = self.duration})
		end
	end
end

function modifier_imba_splendid_passive:OnDestroy()
	if IsServer()  then
		self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_imba_splendid_debug",{duration = 1.0})
	end
end


modifier_imba_splendid_light = class({})
function modifier_imba_splendid_light:IsDebuff()			return false end
function modifier_imba_splendid_light:IsHidden() 			return false end
function modifier_imba_splendid_light:IsPurgable() 			return false end
function modifier_imba_splendid_light:IsPurgeException() 	return false end
function modifier_imba_splendid_light:GetEffectName() return "particles/econ/events/ti10/radiance_owner_ti10.vpcf" end
function modifier_imba_splendid_light:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_splendid_light:GetTexture() return "item_imba_splendid" end

modifier_imba_splendid_miss  = class({})
function modifier_imba_splendid_miss:IsDebuff()			return true end
function modifier_imba_splendid_miss:IsHidden() 			return false end
function modifier_imba_splendid_miss:IsPurgable() 			return false end
function modifier_imba_splendid_miss:IsPurgeException() 	return false end

function modifier_imba_splendid_miss:OnCreated()
	if not self:GetAbility() then   
        return 
    end 
	self.miss_chance = self:GetAbility():GetSpecialValueFor("miss_chance_2")
end
function modifier_imba_splendid_miss:DeclareFunctions() return {MODIFIER_PROPERTY_MISS_PERCENTAGE} end
function modifier_imba_splendid_miss:GetModifierMiss_Percentage()
	return self.miss_chance
end

modifier_imba_splendid_debug = class({})
function modifier_imba_splendid_debug:IsDebuff()			return false end
function modifier_imba_splendid_debug:IsHidden() 			return true end
function modifier_imba_splendid_debug:IsPurgable() 			return false end
function modifier_imba_splendid_debug:IsPurgeException() 	return false end
function modifier_imba_splendid_debug:RemoveOnDeath() 	return false end
function modifier_imba_splendid_debug:GetTexture() return "item_imba_splendid" end
function modifier_imba_splendid_debug:OnDestroy()
	if not IsServer() then return end
	if not self:GetParent():HasModifier("modifier_imba_splendid_passive") and not self:GetParent():HasModifier("modifier_imba_radiance_passive") then 
		self:GetParent():RemoveModifierByName("modifier_imba_radiance_unique")
	end
end













--------------------------------------------











