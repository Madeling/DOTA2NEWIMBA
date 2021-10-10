item_imba_ether = class({})
LinkLuaModifier("modifier_imba_ether_passive", "ting/items/item_ether", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ether_buff", "ting/items/item_ether", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ether_debuff", "ting/items/item_ether", LUA_MODIFIER_MOTION_NONE)
function item_imba_ether:GetIntrinsicModifierName() return "modifier_imba_ether_passive" end

function item_imba_ether:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Invoker.GhostWalk")
	caster:AddNewModifier(caster,self,"modifier_imba_ether_buff",{duration = self:GetSpecialValueFor("duration")})
end

modifier_imba_ether_buff = class({})
LinkLuaModifier("modifier_imba_ether_debuff", "ting/items/item_ether", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_ether_buff:IsDebuff()			return  false  end
function modifier_imba_ether_buff:IsHidden() 			return false end
function modifier_imba_ether_buff:IsPurgable() 		return true end
function modifier_imba_ether_buff:IsPurgeException() 	return true end
function modifier_imba_ether_buff:GetTexture() return "item_ether" end
function modifier_imba_ether_buff:CheckState()
	return
		{
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		}
end
function modifier_imba_ether_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,}end
function modifier_imba_ether_buff:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.damage = self.ability:GetSpecialValueFor("damage")
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ghost_walk.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(pfx, 0, self.caster:GetAbsOrigin())		
		ParticleManager:ReleaseParticleIndex(pfx)
	end
	
end
function modifier_imba_ether_buff:OnDestroy()
	if not IsServer() then return end
	self.caster = nil 
	self.damage = nil
	self.ability = nil
end
function modifier_imba_ether_buff:GetModifierMagicalResistanceDecrepifyUnique( params )
	return self.damage 
end

function modifier_imba_ether_buff:GetAbsoluteNoDamagePhysical()
	if self:GetCaster() == self:GetParent() then return 1
	else return nil end
end

function modifier_imba_ether_buff:GetStatusEffectName() return "particles/status_fx/status_effect_wraithking_ghosts.vpcf" end

modifier_imba_ether_passive = class({})
function modifier_imba_ether_passive:IsDebuff()			return false end
function modifier_imba_ether_passive:IsHidden() 			return true end
function modifier_imba_ether_passive:IsPurgable() 		return false end
function modifier_imba_ether_passive:IsPurgeException() 	return false end
function modifier_imba_ether_passive:OnCreated()
	if not self:GetAbility() then    
		return  
	end 
	self.ability = self:GetAbility()
	self.stat = self.ability:GetSpecialValueFor("stat")

	self.mana = self.ability:GetSpecialValueFor("mana")
	self.cr = self.ability:GetSpecialValueFor("cr")
	self.mb = self.ability:GetSpecialValueFor("mb")
end
function modifier_imba_ether_passive:OnDestroy()
	self.ability = nil
	self.stat = nil
	self.mana = nil
	self.cr = nil
	self.mb = nil
end

function modifier_imba_ether_passive:DeclareFunctions() return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS,MODIFIER_PROPERTY_MANA_BONUS,MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,MODIFIER_PROPERTY_MANA_REGEN_CONSTANT} end

function modifier_imba_ether_passive:GetModifierCastRangeBonusStacking() return self.cr end
function modifier_imba_ether_passive:GetModifierBonusStats_Intellect() return self.stat end
function modifier_imba_ether_passive:GetModifierBonusStats_Agility() return self.stat end
function modifier_imba_ether_passive:GetModifierBonusStats_Strength() return self.stat end
function modifier_imba_ether_passive:GetModifierManaBonus() return self.mana end
function modifier_imba_ether_passive:GetModifierConstantManaRegen() return self.mb end



