item_imba_soul = class({})

LinkLuaModifier("modifier_imba_soul_ring_passive", "ting/items/item_soul_ring", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_soul_buff", "ting/items/item_soul_ring", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_snner_debug1", "ting/items/item_soul_ring", LUA_MODIFIER_MOTION_NONE)
function item_imba_soul:GetIntrinsicModifierName() return "modifier_imba_soul_ring_passive" end
function item_imba_soul:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_soul_buff") then
		return "item_soul_ring_png2"
	else
		return "item_soul_ring_png1"
	end
	return "item_soul_ring_png1"

end
function item_imba_soul:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	--and current_ability:GetCooldown(current_ability:GetLevel()-1) < 15 	
	local health = caster:GetHealth()
	caster:EmitSound("DOTA_Item.SoulRing.Activate")
	
	local pfx = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_transversant_soul/spectre_ti7_crimson_spectral_dagger_path_owner_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())		
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())	
	ParticleManager:SetParticleControl(pfx, 2, caster:GetAbsOrigin())	
	ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin())		
	ParticleManager:ReleaseParticleIndex(pfx)
	local healthc = self:GetSpecialValueFor("hp_cost")+ health*0.01*self:GetSpecialValueFor("extra_cost")
	caster:SetHealth(math.max(health-healthc,1))
	caster:GiveMana(healthc)	
	
		local modifier = caster:AddNewModifier(caster,self,"modifier_imba_soul_buff",{duration = self:GetSpecialValueFor("duration")})

end

modifier_imba_soul_buff = class({})
function modifier_imba_soul_buff:IsDebuff()			return false end
function modifier_imba_soul_buff:IsHidden() 			return false end
function modifier_imba_soul_buff:IsPurgable() 		return false end
function modifier_imba_soul_buff:IsPurgeException() 	return false end
function modifier_imba_soul_buff:GetEffectName()			return "particles/econ/items/spectre/spectre_transversant_soul/spectre_ti7_crimson_spectral_dagger_path_owner_energy.vpcf" end
function modifier_imba_soul_buff:GetTexture()			return "item_soul_ring_png2" end


modifier_imba_soul_ring_passive = class({})
LinkLuaModifier("modifier_imba_soul_ring_passive_cd", "ting/items/item_soul_ring", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_soul_ring_passive:IsDebuff()			return false end
function modifier_imba_soul_ring_passive:IsHidden() 			return true end
function modifier_imba_soul_ring_passive:IsPurgable() 		return false end
function modifier_imba_soul_ring_passive:IsPurgeException() 	return false end
function modifier_imba_soul_ring_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_HEAL_RECEIVED,MODIFIER_EVENT_ON_TAKEDAMAGE,MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,MODIFIER_PROPERTY_MANACOST_PERCENTAGE,MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
end
function modifier_imba_soul_ring_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_soul_ring_passive:OnCreated()
	self.ab = self:GetAbility()
	self.manacost = self.ab:GetSpecialValueFor("manacost")
	self.int = self.ab:GetSpecialValueFor("int")
	self.casttime = self.ab:GetSpecialValueFor("casttime")
	self.casttime_on = self.ab:GetSpecialValueFor("casttime_on")
	self.asp = self.ab:GetSpecialValueFor("asp")
	self.hp_re = self.ab:GetSpecialValueFor("hp_re")
	self.lifesteal = self.ab:GetSpecialValueFor("hero_lifesteal")
	self.lifesteal_on = self.ab:GetSpecialValueFor("hero_lifesteal_on")
	

end
function modifier_imba_soul_ring_passive:OnDestroy()
	self.manacost = nil
	self.int = nil
	self.casttime = nil
	self.casttime_on =  nil
	self.sap =nil
	self.hp_re = nil
	self.lifesteal = nil
	self.lifesteal_on = nil
	self.ab = nil
end
function modifier_imba_soul_ring_passive:GetModifierPercentageCasttime()
	local casttime = self.casttime
	if self:GetParent():HasModifier("modifier_imba_soul_buff") then 
	casttime = self.casttime_on
	end
	return casttime
end
function modifier_imba_soul_ring_passive:GetModifierBonusStats_Intellect()
	return self.int
end
function modifier_imba_soul_ring_passive:GetModifierPercentageManacost()
	return self.manacost
end

function modifier_imba_soul_ring_passive:GetModifierSpellAmplify_Percentage()
	return self.asp 
end
function modifier_imba_soul_ring_passive:GetModifierConstantHealthRegen()
	return self.hp_re
end


--[[function modifier_imba_soul_ring_passive:OnHealReceived(keys)
	if keys.unit ~= self:GetParent()  then return end
	if self:GetParent():GetMaxHealth() - self:GetParent():GetHealth() < keys.gain then
		if keys.gain~= self:GetParent():GetHealthRegen()/10 then 
		print(tostring(keys.gain))
		end
	end
end]]--

function modifier_imba_soul_ring_passive:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and keys.inflictor and IsEnemy(keys.attacker, keys.unit) and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
		local lifesteal = self.lifesteal 
		if self:GetParent():HasModifier("modifier_imba_soul_buff") then 
		 lifesteal = self.lifesteal_on
		end
		local dmg = keys.damage * (lifesteal / 100)
		if keys.unit:IsCreep() then
			dmg = dmg / 5
		end
		self:GetParent():Heal(dmg, self.ability)
		local pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_plasma.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(pfx)
		
	end
end

