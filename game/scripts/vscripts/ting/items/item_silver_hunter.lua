item_imba_silver_hunter = class({})
LinkLuaModifier("modifier_imba_silver_passive", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_silver_invisible", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_silver_light", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_silver_pfx", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)

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

function modifier_imba_silver_invisible:IsDebuff()			return false end
function modifier_imba_silver_invisible:IsHidden() 			return false end
function modifier_imba_silver_invisible:IsPurgable() 		return false end
function modifier_imba_silver_invisible:IsPurgeException() 	return false end 
function modifier_imba_silver_invisible:OnCreated()
	self.cd = self:GetAbility():GetSpecialValueFor("inv_s")
end
function modifier_imba_silver_invisible:DeclareFunctions() 	return {MODIFIER_EVENT_ON_ATTACK, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_DISABLE_AUTOATTACK, MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ABILITY_EXECUTED,MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end

function modifier_imba_silver_invisible:GetDisableAutoAttack() return true end	
function modifier_imba_silver_invisible:GetTexture()		return "item_silver_hunter" end	
function modifier_imba_silver_invisible:CheckState()
	local tab_a = {[MODIFIER_STATE_INVISIBLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	local tab_b = {
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
		}
	if self:GetParent():HasModifier("modifier_imba_silver_passive") then
		if self:GetParent():FindModifierByName("modifier_imba_silver_passive"):GetStackCount() > 0 then 
			return tab_b 
		else 
			return tab_a
		end
	end
	return 
end
function modifier_imba_silver_invisible:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and self:GetParent():IsRangedAttacker() then
		self:Destroy()
	end
end

function modifier_imba_silver_invisible:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and not self:GetParent():IsRangedAttacker() then
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


--被动 附近有隐身的敌人就增加移动速度
modifier_imba_silver_passive = class({})
LinkLuaModifier("modifier_imba_silver_pfx", "ting/items/item_silver_hunter", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_silver_passive:GetTexture()		return "item_silver_hunter" end	
function modifier_imba_silver_passive:IsDebuff()			return false end
function modifier_imba_silver_passive:IsHidden() 			return true end
function modifier_imba_silver_passive:IsPurgable() 			return false end
function modifier_imba_silver_passive:IsPurgeException() 	return false end

function modifier_imba_silver_passive:OnCreated()		
		
	self.radius = self:GetAbility():GetSpecialValueFor("radius_s")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_asp = self:GetAbility():GetSpecialValueFor("bonus_asp")
	self.bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.hp = self:GetAbility():GetSpecialValueFor("hp")
	if not IsServer() then return end
	self:StartIntervalThink(0.5)
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
	self:SetStackCount(1)
	else
	self:SetStackCount(0)
	end
end

function modifier_imba_silver_passive:OnDestroy()
	self.radius = nil
	self.bonus_damage = nil
	self.bonus_asp = nil
	self.bonus_stats  = nil
	self.hp = nil
end
function modifier_imba_silver_passive:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_BONUS,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS, } end
function modifier_imba_silver_passive:GetModifierBonusStats_Intellect() return self.bonus_stats end
function modifier_imba_silver_passive:GetModifierBonusStats_Agility() return self.bonus_stats end
function modifier_imba_silver_passive:GetModifierBonusStats_Strength() return self.bonus_stats end
function modifier_imba_silver_passive:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_imba_silver_passive:GetModifierAttackSpeedBonus_Constant() return self.bonus_asp end
function modifier_imba_silver_passive:GetModifierHealthBonus() return self.hp end
--反隐
modifier_imba_silver_light = class({})


function modifier_imba_silver_light:GetTexture()		return "item_silver_hunter" end	
function modifier_imba_silver_light:IsDebuff()			return true end
function modifier_imba_silver_light:IsHidden() 			return false end
function modifier_imba_silver_light:IsPurgable() 		return true end
function modifier_imba_silver_light:OnCreated()
	self.msp = self:GetAbility():GetSpecialValueFor("msp")
end
function modifier_imba_silver_light:OnDestroy()
	self.msp = nil
end
function modifier_imba_silver_light:GetEffectName() return "particles/items2_fx/true_sight_debuff.vpcf" end
function modifier_imba_silver_light:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_silver_light:CheckState()
	return {[MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_NO_UNIT_COLLISION] = false,[MODIFIER_STATE_TRUESIGHT_IMMUNE] = false,[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = false}
end
function modifier_imba_silver_light:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_silver_light:DeclareFunctions() 	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_silver_light:GetModifierMoveSpeedBonus_Percentage()	return -1*self.msp end

--特效
modifier_imba_silver_pfx = class({})
function modifier_imba_silver_pfx:GetTexture()		return "item_silver_hunter1" end	
function modifier_imba_silver_pfx:IsDebuff()			return false end
function modifier_imba_silver_pfx:IsHidden() 			return true end
function modifier_imba_silver_pfx:IsPurgable() 			return false end
function modifier_imba_silver_pfx:IsPurgeException() 	return false end
function modifier_imba_silver_pfx:OnCreated()
	self.ability = self:GetAbility()
	self.msp = self.ability:GetSpecialValueFor("msp")
	self.asp = self.ability:GetSpecialValueFor("extra_asp")
end
function modifier_imba_silver_pfx:OnDestroy()
	self.ability = nil
	self.msp = nil
	self.asp = nil
end
function modifier_imba_silver_pfx:GetStatusEffectName() return "particles/status_fx/status_effect_slark_shadow_dance.vpcf" end
function modifier_imba_silver_pfx:GetEffectAttachType() return PATTACH_ABSORIGIN end
function modifier_imba_silver_pfx:DeclareFunctions() 	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_silver_pfx:GetModifierMoveSpeedBonus_Percentage()	return self.msp end
function modifier_imba_silver_pfx:GetModifierAttackSpeedBonus_Constant() return self.asp end


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

