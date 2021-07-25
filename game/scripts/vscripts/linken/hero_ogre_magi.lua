CreateTalents("npc_dota_hero_ogre_magi", "linken/hero_ogre_magi")
imba_ogre_magi_fireblast_ignite = class({})
LinkLuaModifier("modifier_imba_ogre_magi_fireblast_ignite_debuff", "linken/hero_ogre_magi", LUA_MODIFIER_MOTION_NONE)

function imba_ogre_magi_fireblast_ignite:IsHiddenWhenStolen() 		return false end
function imba_ogre_magi_fireblast_ignite:IsRefreshable() 			return true end
function imba_ogre_magi_fireblast_ignite:IsStealable() 			return true end
function imba_ogre_magi_fireblast_ignite:GetCastRange() return self:GetSpecialValueFor("cast_distance") +  self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_6") end
function imba_ogre_magi_fireblast_ignite:GetAOERadius()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("search_distance") +  self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_6")	
	return radius		 
end

function imba_ogre_magi_fireblast_ignite:OnSpellStart(scepter)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local pfx_name = "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite.vpcf"
	caster:EmitSound("Hero_OgreMagi.Ignite.Cast")
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = pfx_name,
		iMoveSpeed = 1000,
		iSourceAttachment = caster:ScriptLookupAttachment("attach_attack1"),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
		ExtraData = {},
	}
	
	TG_CreateProjectile({id = 1, team = caster:GetTeamNumber() , owner = caster, p = info})
	if not scepter then
		local radius = self:GetSpecialValueFor("search_distance") +  self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_6")		
		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, hero in pairs(heroes) do
			if hero ~= target then
				caster:SetCursorCastTarget(hero)
				self:OnSpellStart(true)
				if not self:GetCaster():HasScepter() then --a杖对所有英雄释放
					return
				end	
			end
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, unit in pairs(units) do
			if unit ~= target then
				caster:SetCursorCastTarget(unit)
				self:OnSpellStart(true)
				return
			end
		end	
	end	
end

function imba_ogre_magi_fireblast_ignite:OnProjectileHit_ExtraData(target, pos, keys)
	if not target or target:TG_TriggerSpellAbsorb(self) or target:IsMagicImmune() then
		return
	end
	local caster = self:GetCaster()	
	target:EmitSound("Hero_OgreMagi.Ignite.Target") 
	target:EmitSound("Hero_OgreMagi.Fireblast.Target")
	target:AddNewModifier_RS(caster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("stunned_duration")})
	local pfx = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", caster), PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	ApplyDamage({attacker = caster, victim = target, damage = self:GetSpecialValueFor("damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_1"), ability = self, damage_type = self:GetAbilityDamageType()}) 
	if target:IsAlive() then
		local buff =target:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_ogre_magi_fireblast_ignite_debuff", {duration = self:GetSpecialValueFor("debuff_duration")})
		buff:SetStackCount(buff:GetStackCount() + 1)
	end	
end
modifier_imba_ogre_magi_fireblast_ignite_debuff = class({})

function modifier_imba_ogre_magi_fireblast_ignite_debuff:IsDebuff()			return true end
function modifier_imba_ogre_magi_fireblast_ignite_debuff:IsHidden() 			return false end
function modifier_imba_ogre_magi_fireblast_ignite_debuff:IsPurgable() 			return not self:GetCaster():TG_HasTalent("special_bonus_imba_ogre_magi_8") end
function modifier_imba_ogre_magi_fireblast_ignite_debuff:IsPurgeException() 	return not self:GetCaster():TG_HasTalent("special_bonus_imba_ogre_magi_8") end
function modifier_imba_ogre_magi_fireblast_ignite_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_ogre_magi_fireblast_ignite_debuff:GetEffectName() return "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf" end
function modifier_imba_ogre_magi_fireblast_ignite_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_ogre_magi_fireblast_ignite_debuff:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("move_slow")*self:GetStackCount()) end
function modifier_imba_ogre_magi_fireblast_ignite_debuff:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("attack_slow")*self:GetStackCount()) end

function modifier_imba_ogre_magi_fireblast_ignite_debuff:OnCreated()
self.radius = self:GetAbility():GetSpecialValueFor("cast_distance")
	if IsServer() then
		self:StartIntervalThink(1)  
	end
end

function modifier_imba_ogre_magi_fireblast_ignite_debuff:OnIntervalThink()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local dmg = self:GetAbility():GetSpecialValueFor("damage_debuff")*self:GetStackCount()
	local dmgfaqiang = self:GetAbility():GetSpecialValueFor("damage_debuff")*self:GetStackCount() * (self:GetCaster():GetSpellAmplification(false) + 1)
	
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	
		parent:GetAbsOrigin(),	
		nil,	
		self.radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		0,	
		0,	
		false
	)
	if caster:Has_Aghanims_Shard() then
		for _,enemy in pairs(enemies) do	
			ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage = dmg, damage_type = ability:GetAbilityDamageType()})
		end
	else	
		ApplyDamage({victim = parent, attacker = caster, ability = ability, damage = dmg, damage_type = ability:GetAbilityDamageType()})
	end
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), dmgfaqiang, nil)
end		

imba_ogre_magi_Bloodlust = class({})

LinkLuaModifier("modifier_imba_ogre_magi_bloodlust", "linken/hero_ogre_magi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ogre_magi_bloodlust_c", "linken/hero_ogre_magi", LUA_MODIFIER_MOTION_NONE)

function imba_ogre_magi_Bloodlust:IsHiddenWhenStolen() 		return false end
function imba_ogre_magi_Bloodlust:IsRefreshable() 			return true end
function imba_ogre_magi_Bloodlust:IsStealable() 			return true end
function imba_ogre_magi_Bloodlust:OnSpellStart(scepter)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local radius = self:GetCastRange(caster:GetAbsOrigin(), caster) + caster:GetCastRangeBonus()		
	if target:IsAlive() then
		local buff = target:AddNewModifier(caster, self, "modifier_imba_ogre_magi_bloodlust_c", {duration = self:GetSpecialValueFor("buff_duration") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_2")})
	    target:AddNewModifier(caster, self, "modifier_imba_ogre_magi_bloodlust", {})
	end    
 
	if not scepter then
		local radius = self:GetCastRange(caster:GetAbsOrigin(), caster) + caster:GetCastRangeBonus()		
		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, hero in pairs(heroes) do
			if hero ~= target then
				caster:SetCursorCastTarget(hero)
				self:OnSpellStart(true)
				if not self:GetCaster():HasScepter() then --a杖对所有英雄释放
					return
				end	
			end
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, unit in pairs(units) do
			if unit ~= target then
				caster:SetCursorCastTarget(unit)
				self:OnSpellStart(true)
				return
			end
		end
	end		
	caster:EmitSound("Hero_OgreMagi.Bloodlust.Cast")
end

modifier_imba_ogre_magi_bloodlust_c = class({})

function modifier_imba_ogre_magi_bloodlust_c:IsDebuff()				return false end
function modifier_imba_ogre_magi_bloodlust_c:IsHidden() 			return true end
function modifier_imba_ogre_magi_bloodlust_c:IsPurgable() 			return true end
function modifier_imba_ogre_magi_bloodlust_c:IsPurgeException() 	return true end
function modifier_imba_ogre_magi_bloodlust_c:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_imba_ogre_magi_bloodlust = class({})

function modifier_imba_ogre_magi_bloodlust:IsDebuff()				return false end
function modifier_imba_ogre_magi_bloodlust:IsHidden() 			return false end
function modifier_imba_ogre_magi_bloodlust:IsPurgable() 			return true end
function modifier_imba_ogre_magi_bloodlust:IsPurgeException() 	return true end
function modifier_imba_ogre_magi_bloodlust:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE} end
function modifier_imba_ogre_magi_bloodlust:GetModifierMoveSpeedBonus_Percentage() 
	return self:GetAbility():GetSpecialValueFor("move_bonus")*self:GetStackCount()
end
function modifier_imba_ogre_magi_bloodlust:GetModifierAttackSpeedBonus_Constant() 
	return self:GetAbility():GetSpecialValueFor("attack_speed_bonus")*self:GetStackCount() 
end 
function modifier_imba_ogre_magi_bloodlust:GetModifierPreAttack_BonusDamage() 
	return self:GetAbility():GetSpecialValueFor("attack_damage_bonus")*self:GetStackCount()
end
function modifier_imba_ogre_magi_bloodlust:GetModifierSpellAmplify_Percentage() 
	return self:GetAbility():GetSpecialValueFor("ability_damage_bonus")*self:GetStackCount()
end
function modifier_imba_ogre_magi_bloodlust:GetEffectName() return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf" end
function modifier_imba_ogre_magi_bloodlust:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_ogre_magi_bloodlust:OnCreated()
	if IsServer() then
	local caster = self:GetCaster()	
	local target = self:GetParent()
   	local pfx1 = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", caster), PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControlEnt(pfx1, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx1, 2, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx1, 3, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(pfx1)		
	self:GetParent():EmitSound("Hero_OgreMagi.Bloodlust.Target")
	self:StartIntervalThink(0.1)
	end
end
function modifier_imba_ogre_magi_bloodlust:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end
function modifier_imba_ogre_magi_bloodlust:OnIntervalThink()
	local buffs = self:GetParent():FindAllModifiersByName("modifier_imba_ogre_magi_bloodlust_c")
	self:SetStackCount(#buffs)
	if self:GetStackCount() == 0 then
		self:Destroy()
	end
end
function modifier_imba_ogre_magi_bloodlust:OnDestroy()
	if IsServer() then
	end	
end



imba_ogre_magi_focus = class({})

LinkLuaModifier("modifier_imba_ogre_magi_focus_m", "linken/hero_ogre_magi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ogre_magi_focus_m_b", "linken/hero_ogre_magi", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_ogre_magi_focus_p", "linken/hero_ogre_magi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ogre_magi_focus_p_b", "linken/hero_ogre_magi", LUA_MODIFIER_MOTION_NONE)  
LinkLuaModifier("modifier_imba_ogre_magi_focus_check", "linken/hero_ogre_magi", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_ogre_magi_focus_check_animation", "linken/hero_ogre_magi", LUA_MODIFIER_MOTION_NONE) 

function imba_ogre_magi_focus:IsHiddenWhenStolen() 		return true end
function imba_ogre_magi_focus:IsRefreshable() 			return false end
function imba_ogre_magi_focus:IsStealable() 			return false end
function imba_ogre_magi_focus:OnSpellStart()
	local caster = self:GetCaster()	
	caster:AddNewModifier(caster, self, "modifier_imba_ogre_magi_focus_check", {duration = self:GetSpecialValueFor("buff_duration") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_3") + 1})	
	local damage_pct = caster:GetMaxHealth() * self:GetSpecialValueFor("hp_percent") * 0.01
	--if caster:GetHealth() ~= 1 then
	--	self:GetCaster():SetHealth(caster:GetHealth() * shengyu)
	--end
	local damageTable = {
		attacker = caster, 
		victim = caster, 
		damage = damage_pct, 
		ability = self, 
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
		}	
	ApplyDamage(damageTable)		
	--local random_response = RandomInt(1, 4)
	--self:EmitSound("ogre_magi_ogmag_ability_bloodlust_0"..random_response)
	--self:EmitSound("Hero_OgreMagi.Bloodlust.Target")
	if not caster:TG_HasTalent("special_bonus_imba_ogre_magi_7") then
		if PseudoRandom:RollPseudoRandom(self,self:GetSpecialValueFor("rd")) then--根据几率
			local buff = caster:AddNewModifier(caster, self, "modifier_imba_ogre_magi_focus_m_b", {duration = self:GetSpecialValueFor("buff_duration") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_3")})
			caster:AddNewModifier(caster, self, "modifier_imba_ogre_magi_focus_m", {})
		else	
			local buff = caster:AddNewModifier(caster, self, "modifier_imba_ogre_magi_focus_p_b", {duration = self:GetSpecialValueFor("buff_duration") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_3")})
			caster:AddNewModifier(caster, self, "modifier_imba_ogre_magi_focus_p", {})
		end
	else
		local buff = caster:AddNewModifier(caster, self, "modifier_imba_ogre_magi_focus_m_b", {duration = self:GetSpecialValueFor("buff_duration") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_3")})
		caster:AddNewModifier(caster, self, "modifier_imba_ogre_magi_focus_m", {})
		local buff = caster:AddNewModifier(caster, self, "modifier_imba_ogre_magi_focus_p_b", {duration = self:GetSpecialValueFor("buff_duration") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_3")})
		caster:AddNewModifier(caster, self, "modifier_imba_ogre_magi_focus_p", {})
	end		
end
modifier_imba_ogre_magi_focus_m_b = class({})
function modifier_imba_ogre_magi_focus_m_b:IsDebuff()				return false end
function modifier_imba_ogre_magi_focus_m_b:IsHidden() 			return true end
function modifier_imba_ogre_magi_focus_m_b:IsPurgable() 			return false end
function modifier_imba_ogre_magi_focus_m_b:IsPurgeException() 	return false end
function modifier_imba_ogre_magi_focus_m_b:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_imba_ogre_magi_focus_m = class({})

function modifier_imba_ogre_magi_focus_m:IsDebuff()				return false end
function modifier_imba_ogre_magi_focus_m:IsHidden() 			return false end
function modifier_imba_ogre_magi_focus_m:IsPurgable() 			return true end
function modifier_imba_ogre_magi_focus_m:IsPurgeException() 	return true end
function modifier_imba_ogre_magi_focus_m:GetTexture() return "imba_ogre_magi_focus2_2" end
function modifier_imba_ogre_magi_focus_m:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING} end
function modifier_imba_ogre_magi_focus_m:GetModifierCastRangeBonusStacking() return (self:GetAbility():GetSpecialValueFor("cast_range_bonus")*self:GetStackCount()) end


function modifier_imba_ogre_magi_focus_m:OnCreated()
	if IsServer() then		
		self:StartIntervalThink(0.1)
	end
end
function modifier_imba_ogre_magi_focus_m:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end
function modifier_imba_ogre_magi_focus_m:OnIntervalThink()
	local buffs = self:GetParent():FindAllModifiersByName("modifier_imba_ogre_magi_focus_m_b")
	self:SetStackCount(#buffs)
	if self:GetStackCount() == 0 then
		self:Destroy()
	end
end
function modifier_imba_ogre_magi_focus_m:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and keys.inflictor and not Is_Chinese_TG(keys.attacker, keys.unit) and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
		local dmg = keys.damage * (self:GetAbility():GetSpecialValueFor("hero_lifesteal")*self:GetStackCount() / 100)
		if keys.unit:IsCreep() then
			dmg = dmg / 5
		end
		self:GetParent():Heal(dmg, self.ability)
	end
end
function modifier_imba_ogre_magi_focus_m:OnDestroy()
	if IsServer() then		
	end	
end


modifier_imba_ogre_magi_focus_p_b = class({})
function modifier_imba_ogre_magi_focus_p_b:IsDebuff()				return false end
function modifier_imba_ogre_magi_focus_p_b:IsHidden() 			return true end
function modifier_imba_ogre_magi_focus_p_b:IsPurgable() 			return false end
function modifier_imba_ogre_magi_focus_p_b:IsPurgeException() 	return false end
function modifier_imba_ogre_magi_focus_p_b:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



modifier_imba_ogre_magi_focus_p = class({})

function modifier_imba_ogre_magi_focus_p:IsDebuff()				return false end
function modifier_imba_ogre_magi_focus_p:IsHidden() 			return false end
function modifier_imba_ogre_magi_focus_p:IsPurgable() 			return true end
function modifier_imba_ogre_magi_focus_p:IsPurgeException() 	return true end
function modifier_imba_ogre_magi_focus_p:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_ogre_magi_focus_p:GetModifierAttackSpeedBonus_Constant() return (self:GetAbility():GetSpecialValueFor("attack_speed_bonus")*self:GetStackCount()) end

function modifier_imba_ogre_magi_focus_p:OnCreated()
	if IsServer() then	
		self:StartIntervalThink(0.1)
	end
end
function modifier_imba_ogre_magi_focus_p:OnIntervalThink()
	local buffs = self:GetParent():FindAllModifiersByName("modifier_imba_ogre_magi_focus_p_b")
	self:SetStackCount(#buffs)
	if self:GetStackCount() == 0 then
		self:Destroy()
	end
end
function modifier_imba_ogre_magi_focus_p:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end
function modifier_imba_ogre_magi_focus_p:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and (keys.unit:IsHero() or keys.unit:IsCreep() or keys.unit:IsBoss()) and not Is_Chinese_TG(keys.attacker, keys.unit) and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
		local lifesteal = keys.damage * (self:GetAbility():GetSpecialValueFor("hero_lifesteal")*self:GetStackCount() / 100)
		if keys.unit:IsCreep() and keys.inflictor then
			lifesteal = lifesteal / 5
		end
		self:GetParent():Heal(lifesteal, self.ability)
		--local pfx = ParticleManager:CreateParticle("particles/item/vladmir/vladmir_blood_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		--ParticleManager:ReleaseParticleIndex(pfx)
	end
end
function modifier_imba_ogre_magi_focus_p:OnDestroy()
	if IsServer() then	
	end	
end
modifier_imba_ogre_magi_focus_check = class({})

function modifier_imba_ogre_magi_focus_check:IsDebuff()				return false end
function modifier_imba_ogre_magi_focus_check:IsHidden() 			return true end
function modifier_imba_ogre_magi_focus_check:IsPurgable() 			return false end
function modifier_imba_ogre_magi_focus_check:IsPurgeException() 	return false end
function modifier_imba_ogre_magi_focus_check:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.2)  
	end
end

function modifier_imba_ogre_magi_focus_check:OnIntervalThink()
	if self:GetParent():HasAbility("imba_ogre_magi_multicast") then
		if (self:GetParent():HasModifier("modifier_imba_ogre_magi_focus_m") and self:GetParent():HasModifier("modifier_imba_ogre_magi_focus_p")) and self:GetParent():FindAbilityByName("imba_ogre_magi_multicast"):IsTrained() and not self:GetParent():HasModifier("modifier_imba_ogre_magi_focus_check_animation") then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_ogre_magi_focus_check_animation", {})
		end
		if not (self:GetParent():HasModifier("modifier_imba_ogre_magi_focus_m") and self:GetParent():HasModifier("modifier_imba_ogre_magi_focus_p")) then
			self:GetParent():RemoveModifierByName("modifier_imba_ogre_magi_focus_check_animation")
		end
	end		
end
modifier_imba_ogre_magi_focus_check_animation = class({})
function modifier_imba_ogre_magi_focus_check_animation:IsHidden() 			return true end
function modifier_imba_ogre_magi_focus_check_animation:OnCreated()
	if IsServer() then
		local particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield.vpcf"
		local radius = 200
		self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleControlEnt(
			self.effect_cast,
			0,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)

		-- buff particle
		self:AddParticle(
			self.effect_cast,
			false, -- bDestroyImmediately
			false, -- bStatusEffect
			-1, -- iPriority
			false, -- bHeroEffect
			false -- bOverheadEffect
		)
	end
end
function modifier_imba_ogre_magi_focus_check_animation:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.effect_cast, true)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)		
	end	
end



imba_ogre_magi_multicast = class({})

function imba_ogre_magi_multicast:IsStealable() 			return false end

LinkLuaModifier("modifier_imba_multicast_passive", "linken/hero_ogre_magi", LUA_MODIFIER_MOTION_NONE)


modifier_multicast_attack_range = class({})

function modifier_multicast_attack_range:IsDebuff()			return false end
function modifier_multicast_attack_range:IsHidden() 		return true end
function modifier_multicast_attack_range:IsPurgable() 		return false end
function modifier_multicast_attack_range:IsPurgeException() return false end
function modifier_multicast_attack_range:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS} end
function modifier_multicast_attack_range:GetModifierAttackRangeBonus() return 10000 end

function imba_ogre_magi_multicast:GetIntrinsicModifierName() return "modifier_imba_multicast_passive" end
function imba_ogre_magi_multicast:GetAbilityTextureName() return "ogre_magi_multicast_"..self:GetCaster():GetModifierStackCount("modifier_imba_multicast_passive", nil) end
function imba_ogre_magi_multicast:ResetToggleOnRespawn() return false end

function imba_ogre_magi_multicast:OnOwnerDied()
	self.toggle = self:GetToggleState()
end

function imba_ogre_magi_multicast:OnOwnerSpawned()
	if self.toggle == nil then
		self.toggle = false
	end
	if self.toggle ~= self:GetToggleState() then
		self:ToggleAbility()
	end
end

function imba_ogre_magi_multicast:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():FindModifierByName("modifier_imba_multicast_passive"):SetStackCount(1)
	else
		self:GetCaster():FindModifierByName("modifier_imba_multicast_passive"):SetStackCount(0)
	end
	self:EndCooldown()
	self.toggle = self:GetToggleState()
end

modifier_imba_multicast_passive = class({})

function modifier_imba_multicast_passive:IsDebuff()			return false end
function modifier_imba_multicast_passive:IsHidden() 			return true end
function modifier_imba_multicast_passive:IsPurgable() 		return false end
function modifier_imba_multicast_passive:IsPurgeException() 	return false end
function modifier_imba_multicast_passive:AllowIllusionDuplicate() return false end
function modifier_imba_multicast_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE} end
function modifier_imba_multicast_passive:GetModifierPercentageCooldown() return (self:GetAbility():GetSpecialValueFor("cdr_pct")) end

function modifier_imba_multicast_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or not self:GetAbility():IsCooldownReady() or not keys.target:IsAlive() then
		return
	end
	local target = keys.target
	local ability = self:GetAbility()
	local chance_2 = self:GetAbility():GetSpecialValueFor("multicast_2") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_4")
	local chance_3 = self:GetAbility():GetSpecialValueFor("multicast_3") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_4")
	local chance_4 = self:GetAbility():GetSpecialValueFor("multicast_4") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_4")
	if self:GetParent():HasModifier("modifier_imba_ogre_magi_focus_check_animation") then
		chance_2 = self:GetAbility():GetSpecialValueFor("multicast_2") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_4") + self:GetCaster():FindAbilityByName("imba_ogre_magi_focus"):GetSpecialValueFor("multicast")
		chance_3 = self:GetAbility():GetSpecialValueFor("multicast_3") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_4") + self:GetCaster():FindAbilityByName("imba_ogre_magi_focus"):GetSpecialValueFor("multicast")
		chance_4 = self:GetAbility():GetSpecialValueFor("multicast_4") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_4") + self:GetCaster():FindAbilityByName("imba_ogre_magi_focus"):GetSpecialValueFor("multicast")
	end	
	local multicast = 0
	if PseudoRandom:RollPseudoRandom(self:GetAbility(), chance_4) then
		multicast = 4
	elseif PseudoRandom:RollPseudoRandom(self:GetAbility(), chance_3) then
		multicast = 3
	elseif PseudoRandom:RollPseudoRandom(self:GetAbility(), chance_2) then
		multicast = 2
	end
	if multicast > 0 then
		self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(-1) * self:GetParent():GetCooldownReduction())
		self:DoMultiAttack(self:GetParent(), target, multicast)
	end
end

function modifier_imba_multicast_passive:DoMultiAttack(caster, target, times)
	for i = 1, times-1 do	
		Timers:CreateTimer(i * self:GetAbility():GetSpecialValueFor("multicast_delay"), function()
			caster:StartGesture(ACT_DOTA_ATTACK)
			caster.splitattack = false
			if self:GetParent():IsAlive() and not self:GetParent():IsStunned() then
				caster:PerformAttack(target, false, true, true, true, false, false, false)
			end	
			caster.splitattack = true
			caster:EmitSound("Hero_OgreMagi.Fireblast.x"..i+1)
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
			ParticleManager:SetParticleControl(pfx, 1, Vector(i+1, 1, 0))
			return nil
		end)
	end
end

local NoMultiCastItems = {
["item_imba_blink"] = true,
["item_tpscroll"] = true,
["item_imba_black_king_bar"] = true,
["item_black_king_bar"] = true,
["item_imba_blink_boots"] = true,
["item_imba_ultimate_scepter_synth"] = true,
["item_imba_manta"] = true,
["item_imba_magic_stick"] = true,
["item_imba_magic_wand"] = true,
["item_soul_ring"] = true,
["item_imba_armlet"] = true,
["item_imba_armlet_active"] = true,
["item_imba_bloodstone"] = true,
["item_imba_cyclone"] = true,
["item_imba_radiance"] = true,
["item_imba_refresher"] = true,
["item_imba_cheese"] = true,
["item_imba_soul_ring"] = true,
["item_urn_of_shadows"] = true,
["item_smoke_of_deceit"] = true,
["item_imba_ring_of_aquila"] = true,
["item_imba_moon_shard"] = true,
["item_imba_silver_edge"] = true,
["item_imba_octarine_core"] = true,
["item_imba_octarine_core_off"] = true,
["item_bottle"] = true,
["item_dust"] = true,
["item_flask"] = true,
["item_imba_shadow_blade"] = true,
["item_ward_observer"] = true,
["item_ward_sentry"] = true,
["item_spirit_vessel"] = true,
["item_refresher_shard"] = true,
["item_ward_dispenser"] = true,
["item_travel_boots_2"] = true,
["item_travel_boots"] = true,
["item_power_treads"] = true,
["item_imba_power_treads_2"] = true,
["imba_antimage_blink"] = true,
["imba_queenofpain_blink"] = true,
["imba_riki_tricks_of_the_trade"] = true,
["imba_riki_tott_true"] = true,
["spirit_breaker_charge_of_darkness"] = true,
["tusk_snowball"] = true,
["tusk_launch_snowball"] = true,
["furion_teleportation"] = true,
["imba_faceless_void_time_walk"] = true,
["elder_titan_ancestral_spirit"] = true,
["brewmaster_primal_split"] = true,
["imba_jakiro_fire_breath"] = true,
["imba_jakiro_ice_breath"] = true,
["wisp_tether"] = true,
["wisp_tether_break"] = true,
["shredder_timber_chain"] = true,
["shredder_chakram"] = true,
["shredder_chakram_2"] = true,
["imba_chaos_knight_reality_rift"] = true,
["imba_puck_phase_shift"] = true,
["imba_puck_ethereal_jaunt"] = true,
["invoker_quas"] = true,
["invoker_exort"] = true,
["invoker_wex"] = true,
["invoker_invoke"] = true,
["imba_timbersaw_chakram"] = true,
["imba_timbersaw_chakram_2"] = true,
["item_necronomicon"] = true,
["item_necronomicon_2"] = true,
["item_necronomicon_3"] = true,
["item_demonicon"] = true,
["item_imba_necronomicon"] = true,
["item_imba_necronomicon_2"] = true,
["item_imba_necronomicon_3"] = true,
["item_imba_necronomicon_4"] = true,
["item_imba_necronomicon_5"] = true,
["item_blink"] = true,
["item_imba_soul"] = true,
["item_swift_blink"] = true,
["item_arcane_blink"] = true,
["item_overwhelming_blink"] = true,
["item_premium_power_treads"] = true,
["item_imba_arcane"] = true,
["item_manta_v2"] = true,
["item_bullwhip"] = true,
["plague_ward"] = true,
["healing_ward"] = true,
["plague_ward"] = true,
["imba_rubick_spell_steal"] = true,
["imba_morphling_replicate"] = true,
["imba_morphling_morph_replicate"] = true,
}

function modifier_imba_multicast_passive:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end

	if self.nocast or keys.unit ~= self:GetParent() or not self:GetAbility():IsCooldownReady() then
		return
	end
	if NoMultiCastItems[keys.ability:GetAbilityName()] or bit.band(keys.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_CHANNELLED) == DOTA_ABILITY_BEHAVIOR_CHANNELLED then
		return
	end
	local caster = self:GetParent()
	local ability = keys.ability
	local target = ability:GetCursorTarget()
	local pos = ability:GetCursorPosition()
	local chance_2 = self:GetAbility():GetSpecialValueFor("multicast_2") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_4")
	local chance_3 = self:GetAbility():GetSpecialValueFor("multicast_3") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_4")
	local chance_4 = self:GetAbility():GetSpecialValueFor("multicast_4") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_4")
	if self:GetParent():HasModifier("modifier_imba_ogre_magi_focus_check_animation") then
		chance_2 = self:GetAbility():GetSpecialValueFor("multicast_2") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_4") + self:GetCaster():FindAbilityByName("imba_ogre_magi_focus"):GetSpecialValueFor("multicast")
		chance_3 = self:GetAbility():GetSpecialValueFor("multicast_3") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_4") + self:GetCaster():FindAbilityByName("imba_ogre_magi_focus"):GetSpecialValueFor("multicast")
		chance_4 = self:GetAbility():GetSpecialValueFor("multicast_4") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_4") + self:GetCaster():FindAbilityByName("imba_ogre_magi_focus"):GetSpecialValueFor("multicast")
	end	
	local multicast = 0
	if PseudoRandom:RollPseudoRandom(self:GetAbility(), chance_4) then
		multicast = 4
	elseif PseudoRandom:RollPseudoRandom(self:GetAbility(), chance_3) then
		multicast = 3
	elseif PseudoRandom:RollPseudoRandom(self:GetAbility(), chance_2) then
		multicast = 2
	end
	local ability1 = caster:FindAbilityByName("imba_ogre_magi_focus")
	if multicast ~= 0 and multicast ~= 2 and ability1 and caster:TG_HasTalent("special_bonus_imba_ogre_magi_5") then
		if not keys.ability:IsItem() then
			ability1:OnSpellStart()
		end	
	end		
	if target then
		if self:GetStackCount() == 0 then
			self:DoMultiTargetAbility(caster, target, ability, multicast)
		else
			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ability:GetCastRange(caster:GetAbsOrigin(), caster) + caster:GetCastRangeBonus(), ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
			for i=2, multicast do
				if units[i] then
					self:DoMultiTargetAbility(caster, units[i], ability, 2)
				end
			end
		end
		return
	end
	if multicast > 0 then
		if pos then
			self:DoMultiPositionAbility(caster, pos, ability, multicast)
			return
		end
		self:DoMultiNoTargetAbility(caster, ability, multicast)
	end
end

function modifier_imba_multicast_passive:DoMultiTargetAbility(caster, target, ability, times)
	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(-1) * self:GetParent():GetCooldownReduction())
	for i = 1, times-1 do
		Timers:CreateTimer(i * self:GetAbility():GetSpecialValueFor("multicast_delay"), function()
			self.nocast = true
			caster:SetCursorCastTarget(target)
			ability:OnSpellStart()
			self.nocast = false
			caster:EmitSound("Hero_OgreMagi.Fireblast.x"..i+1)
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
			ParticleManager:SetParticleControl(pfx, 1, Vector(i+1, 1, 0))
			return nil
		end
		)
	end
end

function modifier_imba_multicast_passive:DoMultiPositionAbility(caster, pos, ability, times)
	for i = 1, times-1 do
		Timers:CreateTimer(i * self:GetAbility():GetSpecialValueFor("multicast_delay"), function()
			self.nocast = true
			caster:SetCursorPosition(pos)
			ability:OnSpellStart()
			self.nocast = false
			caster:EmitSound("Hero_OgreMagi.Fireblast.x"..i+1)
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
			ParticleManager:SetParticleControl(pfx, 1, Vector(i+1, 1, 0))
			return nil
		end
		)
	end
end

function modifier_imba_multicast_passive:DoMultiNoTargetAbility(caster, ability, times)
	for i = 1, times-1 do
		Timers:CreateTimer(i * self:GetAbility():GetSpecialValueFor("multicast_delay"), function()
			self.nocast = true
			ability:OnSpellStart()
			self.nocast = false
			caster:EmitSound("Hero_OgreMagi.Fireblast.x"..i+1)
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
			ParticleManager:SetParticleControl(pfx, 1, Vector(i+1, 1, 0))
			return nil
		end
		)
	end
end

function modifier_imba_multicast_passive:OnCreated()
	if IsServer() and not self:GetParent():IsIllusion() then
		self:StartIntervalThink(1.0)
		self.nocast_check = 0
		self.noattack_check = 0
	end
end

function modifier_imba_multicast_passive:OnIntervalThink()
	if self.nocast then
		self.nocast_check = self.nocast_check + 1
	else
		self.nocast_check = 0
	end
	if self.nocast_check >=5 then
		self.nocast = false
	end
end