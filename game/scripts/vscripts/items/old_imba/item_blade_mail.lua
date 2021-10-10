item_imba_blade_mail_2 = class({})

LinkLuaModifier("modifier_imba_balde_mail_2", "items/old_imba/item_blade_mail", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_balde_mail_2_active", "items/old_imba/item_blade_mail", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_balde_mail_2_debuff", "items/old_imba/item_blade_mail", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_balde_mail_2_cd", "items/old_imba/item_blade_mail", LUA_MODIFIER_MOTION_NONE)
function item_imba_blade_mail_2:GetIntrinsicModifierName() return "modifier_imba_balde_mail_2" end

function item_imba_blade_mail_2:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("DOTA_Item.BladeMail.Activate")
	caster:AddNewModifier(caster, self, "modifier_imba_balde_mail_2_active", {duration = self:GetSpecialValueFor("duration")})
end

modifier_imba_balde_mail_2 = class({})

function modifier_imba_balde_mail_2:IsDebuff()			return false end
function modifier_imba_balde_mail_2:IsHidden() 			return true end
function modifier_imba_balde_mail_2:IsPermanent() 		return true end
function modifier_imba_balde_mail_2:IsPurgable() 		return false end
function modifier_imba_balde_mail_2:IsPurgeException() 	return false end
function modifier_imba_balde_mail_2:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_balde_mail_2:OnCreated()
    if not self:GetAbility() then   
        return  
    end 
    self.ability=self:GetAbility()
    self.bonus_damage=self.ability:GetSpecialValueFor("bonus_damage")
    self.bonus_armor=self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_intellect=self.ability:GetSpecialValueFor("bonus_intellect")
	self.bonus_agility=self.ability:GetSpecialValueFor("bonus_agility")
	self.bonus_strength=self.ability:GetSpecialValueFor("bonus_strength")
	self.dmg=0-self.ability:GetSpecialValueFor("dmg")
end

function modifier_imba_balde_mail_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_balde_mail_2:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end
function modifier_imba_balde_mail_2:GetModifierPreAttack_BonusDamage() 
	return self.bonus_damage end
function modifier_imba_balde_mail_2:GetModifierPhysicalArmorBonus() 
	return self.bonus_armor end
function modifier_imba_balde_mail_2:GetModifierBonusStats_Intellect() 
	return self.bonus_intellect end
function modifier_imba_balde_mail_2:GetModifierBonusStats_Agility() 
	return self.bonus_agility end
function modifier_imba_balde_mail_2:GetModifierBonusStats_Strength() 
	return self.bonus_strength end
function modifier_imba_balde_mail_2:GetModifierIncomingDamage_Percentage() 
return self.dmg end

modifier_imba_balde_mail_2_active = class({})

function modifier_imba_balde_mail_2_active:IsDebuff()			return false end
function modifier_imba_balde_mail_2_active:IsHidden() 			return false end
function modifier_imba_balde_mail_2_active:IsPurgable() 		return false end
function modifier_imba_balde_mail_2_active:IsPurgeException() 	return false end
function modifier_imba_balde_mail_2_active:GetEffectName() return "particles/items_fx/blademail.vpcf" end
function modifier_imba_balde_mail_2_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_balde_mail_2_active:GetStatusEffectName() return "particles/items_fx/blademail.vpcf" end
function modifier_imba_balde_mail_2_active:StatusEffectPriority() return 20 end
function modifier_imba_balde_mail_2_active:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_imba_balde_mail_2_active:GetTexture() return "imba_blade_mail_2" end
function modifier_imba_balde_mail_2_active:OnCreated()
	if IsClient() then
		local pfx = ParticleManager:CreateParticle("particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast_debuff_fire.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end

function modifier_imba_balde_mail_2_active:OnDestroy()
	EmitSoundOn("DOTA_Item.BladeMail.Deactivate", self:GetParent())
end

function modifier_imba_balde_mail_2_active:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() or not keys.attacker:IsUnit() or not self:GetParent():IsAlive() or keys.attacker:IsBoss() or self:GetParent():HasModifier("modifier_imba_balde_mail_2_cd") then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
	end
	local caster = self:GetCaster()
	local attacker = keys.attacker
	local ability = self:GetAbility()
	local damage_origin = keys.original_damage * (ability:GetSpecialValueFor("origin_pct") / 100)
	local damage_taken = keys.damage
	local bIsAttack = keys.inflictor
	local damage = math.max(damage_origin, damage_taken)
	if (self:GetParent():GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Length2D() > 2500 then
		ApplyDamage({victim = attacker, attacker = caster, damage = keys.original_damage*1.2, ability = ability, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+ DOTA_DAMAGE_FLAG_REFLECTION})
	else	
		ApplyDamage({victim = attacker, attacker = caster, damage = damage, ability = ability, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+DOTA_DAMAGE_FLAG_REFLECTION})
	end
	attacker:EmitSound("DOTA_Item.BladeMail.Damage")
	caster:AddNewModifier(caster, ability, "modifier_imba_balde_mail_2_cd", {duration=0.1})
	
end

--particles/econ/items/batrider/batrider_ti8_immortal_mount/batrider_ti8_immortal_firefly.vpcf


modifier_imba_balde_mail_2_cd = class({})

function modifier_imba_balde_mail_2_cd:IsHidden() 			return true end
function modifier_imba_balde_mail_2_cd:IsPurgable() 		return false end
function modifier_imba_balde_mail_2_cd:IsPurgeException() 	return false end