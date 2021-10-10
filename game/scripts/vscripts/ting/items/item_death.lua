item_imba_death = class({})
LinkLuaModifier("modifier_imba_death_passive", "ting/items/item_death", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_invisible", "ting/items/item_death", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_ex", "ting/items/item_death", LUA_MODIFIER_MOTION_NONE)

function item_imba_death:GetIntrinsicModifierName() return "modifier_imba_death_passive" end
function item_imba_death:GetAbilityTextureName() return "death"  end
function item_imba_death:OnSpellStart()

	self:GetCaster():EmitSound("DOTA_Item.InvisibilitySword.Activate")


	local pfx = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_death_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(pfx, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local ex = true
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius_s"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do	
		if enemy and enemy:IS_TrueHero_TG() then 
			ex = false
			break
		end
	end
	local modifier = self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_imba_death_invisible",{duration = self:GetSpecialValueFor("duration")})
	if ex == true then
		if modifier~=nil then
			modifier:SetStackCount(1)
		end
	else
		if modifier~=nil then
			modifier:SetStackCount(0)
		end
	end

end


--主动隐身

modifier_imba_death_invisible = class({})
LinkLuaModifier("modifier_imba_death_ex", "ting/items/item_death", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_death_invisible:IsDebuff()			return false end
function modifier_imba_death_invisible:IsHidden() 			return false end
function modifier_imba_death_invisible:IsPurgable() 		return false end
function modifier_imba_death_invisible:IsPurgeException() 	return false end 
function modifier_imba_death_invisible:IsPurgeException() 	return false end 
function modifier_imba_death_invisible:OnCreated()
	if self:GetAbility() == nil then 
		return  
	end 
	self.ability = self:GetAbility()
	self.critical = self.ability:GetSpecialValueFor("critical")
	self.movespeed = self.ability:GetSpecialValueFor("move_speed_ex")
	self.duration = self.ability:GetSpecialValueFor("duration_ex")
	self.ex = true
end
function modifier_imba_death_invisible:DeclareFunctions() 	return {MODIFIER_EVENT_ON_TAKEDAMAGE,MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS, MODIFIER_PROPERTY_DISABLE_AUTOATTACK, MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ABILITY_EXECUTED,MODIFIER_PROPERTY_INVISIBILITY_LEVEL,MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end

function modifier_imba_death_invisible:GetDisableAutoAttack() return true end	
function modifier_imba_death_invisible:GetModifierProjectileSpeedBonus()
    return  99999
end
function modifier_imba_death_invisible:GetModifierMoveSpeedBonus_Constant() return self.movespeed end
function modifier_imba_death_invisible:GetTexture()		return "item_death" end	
function modifier_imba_death_invisible:CheckState()
	local tab_a = {[MODIFIER_STATE_INVISIBLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	local tab_b = {
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
		}
	if self:GetStackCount() > 0 then
			return tab_b 
		else 
			return tab_a
	end
	return tab_a
end
function modifier_imba_death_invisible:OnTakeDamage(keys)
	if self.ex then 
		if keys.attacker == self:GetParent() and keys.unit:IS_TrueHero_TG() then
			self:SetStackCount(0)
			self.ex = false
		end
	end
end
function modifier_imba_death_invisible:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and keys.attacker:HasModifier("modifier_imba_death_invisible") then 
		keys.attacker:AddNewModifier(keys.attacker,self.ability,"modifier_rune_flying_haste",{duration = self.duration})
		keys.attacker:AddNewModifier(keys.attacker,self.ability,"modifier_imba_death_ex",{duration = self.duration})
		self:Destroy()
	end
end

function modifier_imba_death_invisible:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() then	
			return self.critical		
	end
end
function modifier_imba_death_invisible:OnAbilityExecuted(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	if keys.ability:GetAbilityName() == "item_imba_death" then
		return
	end	
	if keys.unit == self:GetParent() and keys.unit:HasModifier("modifier_imba_death_invisible") then 
		keys.unit:AddNewModifier(keys.unit,self.ability,"modifier_rune_flying_haste",{duration = self.duration})
		keys.unit:AddNewModifier(keys.unit,self.ability,"modifier_imba_death_ex",{duration = self.duration})
	end
	self:Destroy()
end



function modifier_imba_death_invisible:GetEffectName() 
		return "particles/generic_hero_status/status_invisibility_start.vpcf" 
end

function modifier_imba_death_invisible:GetEffectAttachType() return PATTACH_ABSORIGIN end
function modifier_imba_death_invisible:GetModifierInvisibilityLevel() return 1 end



--标记
modifier_imba_death_ex = class({})
function modifier_imba_death_ex:IsDebuff()			return false end
function modifier_imba_death_ex:IsHidden() 			return true end
function modifier_imba_death_ex:IsPurgable() 		return false end
function modifier_imba_death_ex:IsPurgeException() 	return false end 
function modifier_imba_death_ex:DeclareFunctions() 	return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE} end
function modifier_imba_death_ex:GetModifierTotalDamageOutgoing_Percentage(keys)
	if not keys.target:IsBuilding() then
		return self.damage_ex
	end
end
function modifier_imba_death_ex:OnCreated()
	if self:GetAbility() == nil then return end
	self.damage_ex = self:GetAbility():GetSpecialValueFor("damage_ex")
end



--被动
modifier_imba_death_passive = class({})

LinkLuaModifier("modifier_imba_death_ex", "ting/items/item_death", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_death_passive:GetTexture()		return "item_death" end	
function modifier_imba_death_passive:IsDebuff()			return false end
function modifier_imba_death_passive:IsHidden() 			return true end
function modifier_imba_death_passive:IsPurgable() 			return false end
function modifier_imba_death_passive:IsPurgeException() 	return false end


function modifier_imba_death_passive:OnCreated()		
	if not self:GetAbility() then   
		return  
	end 
	self.ability = self:GetAbility()
	self.parent  = self:GetParent()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_asp = self.ability:GetSpecialValueFor("bonus_asp")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.movespeed = self.ability:GetSpecialValueFor("movespeed")
	self.chance    = self.ability:GetSpecialValueFor("crit_chance")
	self.crit	   = self.ability:GetSpecialValueFor("critical")
end

function modifier_imba_death_passive:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() then
			if PseudoRandom:RollPseudoRandom(self.ability, self.chance) then
				return self.crit		
			end
	end
end

function modifier_imba_death_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_PROVIDES_FOW_POSITION, MODIFIER_EVENT_ON_DEATH} end
function modifier_imba_death_passive:GetModifierBonusStats_Agility() return self.bonus_agi end
function modifier_imba_death_passive:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_imba_death_passive:GetModifierAttackSpeedBonus_Constant() return self.bonus_asp end
function modifier_imba_death_passive:GetModifierMoveSpeedBonus_Percentage() return self.movespeed end





