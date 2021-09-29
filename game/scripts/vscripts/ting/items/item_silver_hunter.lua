item_imba_silver_hunter = class({})
LinkLuaModifier("modifier_imba_silver_passive", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_silver_invisible", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_silver_light", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_silver_pfx", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_silver_debuff", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)
function item_imba_silver_hunter:GetIntrinsicModifierName() return "modifier_imba_silver_passive" end
function item_imba_silver_hunter:GetAbilityTextureName() 
if self:GetCaster():HasModifier("modifier_imba_silver_pfx") then
return "silver_hunter1"  end

return "silver_hunter"  end
function item_imba_silver_hunter:OnSpellStart()
	if not IsServer() then return end	
	if self:GetCaster():HasModifier("modifier_imba_silver_invisible") then
		self:GetCaster():EmitSound("Item.CrimsonGuard.Cast")
    	local pfx = ParticleManager:CreateParticle("particles/world_outpost/world_outpost_radiant_ambient_shockwave.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(pfx, 1, self:GetCaster():GetAbsOrigin())		
		ParticleManager:ReleaseParticleIndex(pfx)
	local modifier = self:GetCaster():FindModifierByName("modifier_imba_silver_invisible")
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do	
		if enemy:IsInvisible() then
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_silver_light",{duration = self:GetSpecialValueFor("invisiable_e")})
		end
		--揭示附近敌人		
	end
	modifier:SetDuration(modifier:GetRemainingTime()+self:GetSpecialValueFor("extra_duration"),true)
	return
	end
	
	if not self:GetCaster():HasModifier("modifier_imba_silver_invisible") then	

		self:GetCaster():EmitSound("DOTA_Item.InvisibilitySword.Activate")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_silver_invisible", {duration = self:GetSpecialValueFor("invisiable_s")})
		self:EndCooldown()
		return
	end
end

--主动隐身

modifier_imba_silver_invisible = class({})
LinkLuaModifier("modifier_imba_silver_debuff", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_silver_light", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_silver_invisible:IsDebuff()			return false end
function modifier_imba_silver_invisible:IsHidden() 			return false end
function modifier_imba_silver_invisible:IsPurgable() 		return false end
function modifier_imba_silver_invisible:IsPurgeException() 	return false end 
function modifier_imba_silver_invisible:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.cd = self.ab:GetSpecialValueFor("inv_s")
	self.dur = self.ab:GetSpecialValueFor("dura_normal")
	self.damage = self.ab:GetSpecialValueFor("damage_exr")
end
function modifier_imba_silver_invisible:DeclareFunctions() 	return {MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,MODIFIER_EVENT_ON_ATTACK, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_DISABLE_AUTOATTACK, MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ABILITY_EXECUTED,MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end

function modifier_imba_silver_invisible:GetDisableAutoAttack() return true end	
function modifier_imba_silver_invisible:GetTexture()		return "item_silver_hunter" end	
function modifier_imba_silver_invisible:CheckState()
	return {[MODIFIER_STATE_INVISIBLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true}

end


function modifier_imba_silver_invisible:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() then 
		if  not keys.target:IsBuilding() and not keys.target:IsOther() and keys.attacker:HasModifier("modifier_imba_silver_invisible") then
		if keys.target:HasModifier("modifier_imba_silver_debuff") then
			self.dur = self.dur*2
		end
			keys.target:AddNewModifier(self:GetParent(),self.ab,"modifier_imba_silver_debuff",{duration = self.dur})
			keys.target:AddNewModifier(self:GetParent(),self.ab,"modifier_imba_silver_light",{duration = self.dur})
			keys.attacker:AddNewModifier(self:GetParent(),self.ab,"modifier_imba_silver_debuff",{duration = self.dur})
			if keys.target:IsAlive() then
				local damage= {
				victim = keys.target,
				attacker = keys.attacker,
				damage = self.damage,
				damage_type = DAMAGE_TYPE_PURE,
				ability = self.ab,
				}
				ApplyDamage(damage)
				 SendOverheadEventMessage(key.target, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self.damage, keys.target)
			end
		end
		self:Destroy()
	end
end

function modifier_imba_silver_invisible:OnAbilityExecuted(keys)
	if not IsServer() then
		return
	end
	
	if keys.unit ~= self:GetParent() then
		return
	end
	
	 if keys.ability:GetAbilityName() == "item_imba_silver_hunter" then
		return
	end	
	self:Destroy()
end

function modifier_imba_silver_invisible:OnDestroy()
	if not IsServer() then return end
	if self:GetAbility() and self:GetAbility():GetCooldownTime() == 0  then
	self:GetAbility():StartCooldown(self.cd*self:GetCaster():GetCooldownReduction())
	end
	self.cd = nil
end

function modifier_imba_silver_invisible:GetEffectName() return "particles/generic_hero_status/status_invisibility_start.vpcf" end
function modifier_imba_silver_invisible:GetEffectAttachType() return PATTACH_ABSORIGIN end
function modifier_imba_silver_invisible:GetModifierInvisibilityLevel() return 1 end
function modifier_imba_silver_invisible:GetModifierProjectileSpeedBonus()
    return  99999
end


modifier_imba_silver_debuff = class({})
function modifier_imba_silver_debuff:IsDebuff()			return not self.fre end
function modifier_imba_silver_debuff:IsHidden() 			return false end
function modifier_imba_silver_debuff:IsPurgable() 			return true end
function modifier_imba_silver_debuff:GetEffectName() return self.fre and "particles/items3_fx/star_emblem_friend_shield.vpcf" or "particles/items3_fx/star_emblem_brokenshield.vpcf" end
function modifier_imba_silver_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_silver_debuff:GetTexture()		return "item_silver_hunter" end	
function modifier_imba_silver_debuff:DeclareFunctions() return 
	{		
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	} 
end

function modifier_imba_silver_debuff:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.asp = self.ab:GetSpecialValueFor("attack_speed_buff") or 0
	self.msp = self.ab:GetSpecialValueFor("move_speed_max_buff") or 0
	self.armor = self.ab:GetSpecialValueFor("armor") or 0
	self.msp_min = self.ab:GetSpecialValueFor("move_speed_buff_min") or 0
	self.fre = Is_Chinese_TG(self:GetCaster(),self:GetParent())
	if IsServer() then
		self:SetStackCount(self.msp)
		self:StartIntervalThink(0.5)
	end
end
function modifier_imba_silver_debuff:OnRefresh() 
	self:OnCreated()
end

function modifier_imba_silver_debuff:OnIntervalThink()
	if self.msp > self.msp_min then
		self.msp = self.msp - 10
		self:SetStackCount(self.msp)
	end
end
function modifier_imba_silver_debuff:GetModifierPhysicalArmorBonus()
	return self.fre and self.armor or self.armor*-1
end
function modifier_imba_silver_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.fre and self.asp or self.asp*-1 
end
function modifier_imba_silver_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.fre and self:GetStackCount() or self:GetStackCount()*-1
end

--被动 附近有隐身的敌人就增加移动速度
modifier_imba_silver_passive = class({})
LinkLuaModifier("modifier_imba_silver_pfx", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_silver_passive:GetTexture()		return "item_silver_hunter" end	
function modifier_imba_silver_passive:IsDebuff()			return false end
function modifier_imba_silver_passive:IsHidden() 			return true end
function modifier_imba_silver_passive:IsPurgable() 			return false end
function modifier_imba_silver_passive:IsPurgeException() 	return false end

function modifier_imba_silver_passive:OnCreated()		
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.radius = self.ab:GetSpecialValueFor("radius_s")
	self.bonus_damage = self.ab:GetSpecialValueFor("bonus_damage")
	self.bonus_asp = self.ab:GetSpecialValueFor("bonus_asp")
	self.bonus_stats = self.ab:GetSpecialValueFor("bonus_all_stats")
	self.miss = self.ab:GetSpecialValueFor("miss")
	self.msp = self.ab:GetSpecialValueFor("move_speed")
	if not IsServer() then return end
	self:StartIntervalThink(1)
end
function modifier_imba_silver_passive:OnIntervalThink()
	if not IsServer() then return end
	local count = 0
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
	if enemy:IsInvisible() or enemy:HasModifier("modifier_imba_silver_light") then
		count = count +1
	end
	end
	if count>0 then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_silver_pfx",{duration = 1.5})
	end
end


function modifier_imba_silver_passive:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_EVASION_CONSTANT,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS, } end
function modifier_imba_silver_passive:GetModifierBonusStats_Intellect() return self.bonus_stats end
function modifier_imba_silver_passive:GetModifierBonusStats_Agility() return self.bonus_stats end
function modifier_imba_silver_passive:GetModifierBonusStats_Strength() return self.bonus_stats end
function modifier_imba_silver_passive:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_imba_silver_passive:GetModifierAttackSpeedBonus_Constant() return self.bonus_asp end
function modifier_imba_silver_passive:GetModifierEvasion_Constant()
	return self.miss
end
function modifier_imba_silver_passive:GetModifierEvasion_Constant()
	return self.miss
end
function modifier_imba_silver_passive:GetModifierMoveSpeedBonus_Constant()
	return self.msp
end
--反隐
modifier_imba_silver_light = class({})


function modifier_imba_silver_light:GetTexture()		return "item_silver_hunter" end	
function modifier_imba_silver_light:IsDebuff()			return true end
function modifier_imba_silver_light:IsHidden() 			return false end
function modifier_imba_silver_light:IsPurgable() 		return true end
function modifier_imba_silver_light:OnCreated()
	if self:GetAbility() == nil then return end
	self.msp = self:GetAbility():GetSpecialValueFor("msp")
end

function modifier_imba_silver_light:GetEffectName() return "particles/items2_fx/true_sight_debuff.vpcf" end
function modifier_imba_silver_light:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_silver_light:CheckState()
	return {[MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_NO_UNIT_COLLISION] = false,[MODIFIER_STATE_TRUESIGHT_IMMUNE] = false,[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = false}
end
function modifier_imba_silver_light:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_silver_light:DeclareFunctions() 	return { MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_silver_light:GetModifierMoveSpeedBonus_Percentage()	return -1*self.msp end
function modifier_imba_silver_light:GetModifierProvidesFOWVision() return 1 end
--特效
modifier_imba_silver_pfx = class({})
function modifier_imba_silver_pfx:GetTexture()		return "item_silver_hunter1" end	
function modifier_imba_silver_pfx:IsDebuff()			return false end
function modifier_imba_silver_pfx:IsHidden() 			return true end
function modifier_imba_silver_pfx:IsPurgable() 			return false end
function modifier_imba_silver_pfx:IsPurgeException() 	return false end
function modifier_imba_silver_pfx:OnCreated()
	if self:GetAbility() == nil then return  end
	self.ability = self:GetAbility()
	self.msp = self.ability:GetSpecialValueFor("msp") or 0
end

function modifier_imba_silver_pfx:GetStatusEffectName() return "particles/status_fx/status_effect_slark_shadow_dance.vpcf" end
function modifier_imba_silver_pfx:GetEffectAttachType() return PATTACH_ABSORIGIN end
function modifier_imba_silver_pfx:DeclareFunctions() 	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_silver_pfx:GetModifierMoveSpeedBonus_Percentage()	return self.msp end



--王冠
--主动使用后5s内持续揭露附近的隐身生物

item_imba_crown = class({})
LinkLuaModifier("modifier_item_king_light", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_king_miss", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_king_passive", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)

function item_imba_crown:GetIntrinsicModifierName() return "modifier_item_king_passive" end
function item_imba_crown:OnSpellStart()
	self:GetCaster():EmitSound("Item.CrimsonGuard.Cast")
	    local pfx = ParticleManager:CreateParticle("particles/world_outpost/world_outpost_dire_ambient_shockwave.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(pfx, 1, self:GetCaster():GetAbsOrigin())		
		ParticleManager:ReleaseParticleIndex(pfx)
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_item_king_light",{duration = self:GetSpecialValueFor("duration")})
end

modifier_item_king_passive = class({})
function modifier_item_king_passive:IsDebuff()			return false end
function modifier_item_king_passive:IsHidden() 			return true end
function modifier_item_king_passive:IsPurgable() 		return false end
function modifier_item_king_passive:IsPurgeException() 	return false end
function modifier_item_king_passive:OnCreated()
	if self:GetAbility()==nil then 
		return
	end 
	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.hp = self:GetAbility():GetSpecialValueFor("bonus_hp")
end
function modifier_item_king_passive:OnDestroy()
	self.bonus_all_stats = nil 
	self.hp = nil
end
function modifier_item_king_passive:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_BONUS,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end
function modifier_item_king_passive:GetModifierBonusStats_Intellect() return self.bonus_all_stats end
function modifier_item_king_passive:GetModifierBonusStats_Agility() return self.bonus_all_stats end
function modifier_item_king_passive:GetModifierBonusStats_Strength() return self.bonus_all_stats end
function modifier_item_king_passive:GetModifierHealthBonus() return self.hp end

--揭露附近隐身单位
modifier_item_king_light = class({})
function modifier_item_king_light:IsDebuff()			return false end
function modifier_item_king_light:IsHidden() 			return false end
function modifier_item_king_light:IsPurgable() 			return false end
function modifier_item_king_light:IsPurgeException() 	return false end
function modifier_item_king_light:GetEffectName() return "particles/basic_ambient/generic_true_sight.vpcf" end
function modifier_item_king_light:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_item_king_light:GetTexture()	return "item_crown_png" end
function modifier_item_king_light:OnCreated()
	self.parent = self:GetParent()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	if not IsServer() then return end
	self:StartIntervalThink(0.1)
end

function modifier_item_king_light:OnIntervalThink()
	if not IsServer() then return end
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
	enemy:AddNewModifier(self.parent, self:GetAbility(), "modifier_item_dustofappearance",{duration = 0.12})
	end
end

function modifier_item_king_light:OnDestroy()
	self.radius = nil
end

