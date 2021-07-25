item_imba_death = class({})
LinkLuaModifier("modifier_imba_death_passive", "ting/items/item_death", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_invisible", "ting/items/item_death", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_invisible_ex_cd", "ting/items/item_death", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_mark", "ting/items/item_death", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_invisible_ex", "ting/items/item_death", LUA_MODIFIER_MOTION_NONE)

function item_imba_death:GetIntrinsicModifierName() return "modifier_imba_death_passive" end
function item_imba_death:GetAbilityTextureName() return "death"  end
function item_imba_death:OnSpellStart()
	if not IsServer() then return end	
	self:GetCaster():EmitSound("DOTA_Item.InvisibilitySword.Activate")
	if not self:GetCaster():HasModifier("modifier_imba_death_invisible_ex_cd") then 
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_imba_death_invisible_ex",{duration = self:GetSpecialValueFor("duration_inv")})
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_imba_death_invisible_ex_cd",{duration = self:GetSpecialValueFor("inv_cd")})
	end
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
--破坏+反隐
modifier_imba_death_mark = class({})
function modifier_imba_death_mark:IsDebuff()	return true end
function modifier_imba_death_mark:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_death_mark:RemoveOnDeath() return true end
function modifier_imba_death_mark:IsHidden() return false end
function modifier_imba_death_mark:IsPurgable() return false end
function modifier_imba_death_mark:IsPurgeException() return false end
function modifier_imba_death_mark:CheckState() return {[MODIFIER_STATE_INVISIBLE] = false,[MODIFIER_STATE_PASSIVES_DISABLED] = true} end
function modifier_imba_death_mark:DeclareFunctions() return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_PROVIDES_FOW_POSITION, MODIFIER_EVENT_ON_DEATH} end
function modifier_imba_death_mark:GetModifierProvidesFOWVision() return 1 end
function modifier_imba_death_mark:GetModifierTotalDamageOutgoing_Percentage()
    return  self.nerf*-1
end 
function modifier_imba_death_mark:GetStatusEffectName() return "particles/status_fx/status_effect_slark_shadow_dance.vpcf" end
function modifier_imba_death_mark:GetEffectAttachType() return PATTACH_ABSORIGIN end
function modifier_imba_death_mark:GetTexture()		return "item_death" end	
function modifier_imba_death_mark:OnCreated()
	self.nerf = self:GetAbility():GetSpecialValueFor("broken_nerf")
end
function modifier_imba_death_mark:OnDeath(keys)
	if not IsServer() then
		return
	end

	if keys.unit == self:GetParent() and keys.unit:IS_TrueHero_TG() then
		local allies = FindUnitsInRadius(keys.attacker:GetTeamNumber(),
									keys.unit:GetAbsOrigin(),
									nil,
									self:GetAbility():GetSpecialValueFor("radius_ex"),
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_HERO,
									DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
									FIND_ANY_ORDER,
									false)
		local modifier_ex = keys.attacker:FindModifierByName("modifier_imba_death_passive") 
		if modifier_ex~=nil then
				local item_ex = modifier_ex:GetAbility()
				keys.attacker:RemoveModifierByName("modifier_imba_death_invisible_ex_cd")
				item_ex:EndCooldown()
		end
	
	for _,ally in pairs(allies) do
		if ally:IS_TrueHero_TG() then
			if ally:HasModifier("modifier_imba_death_passive") then
			local modifier = ally:FindModifierByName("modifier_imba_death_passive") 
				if modifier~=nil then
				local item = modifier:GetAbility()
				item:EndCooldown()
	--			print(ally:GetName())
--[[				print(tostring(ally:GetName()))
				ally:EmitSound("Hero_PhantomAssassin.Blur")
				ally:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_imba_death_invisible_ex",{duration = self:GetAbility():GetSpecialValueFor("duration_inv")})
				local pfx = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_death_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
				ParticleManager:SetParticleControlEnt(pfx, 1, ally, PATTACH_ABSORIGIN_FOLLOW, nil, ally:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(pfx)]]
				ally:RemoveModifierByName("modifier_imba_death_invisible_ex_cd")
				end
			end
		end
	end
	end
end

--主动隐身

modifier_imba_death_invisible = class({})
LinkLuaModifier("modifier_imba_death_mark", "ting/items/item_death", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_death_invisible:IsDebuff()			return false end
function modifier_imba_death_invisible:IsHidden() 			return false end
function modifier_imba_death_invisible:IsPurgable() 		return false end
function modifier_imba_death_invisible:IsPurgeException() 	return false end 
function modifier_imba_death_invisible:IsPurgeException() 	return false end 
function modifier_imba_death_invisible:OnCreated()
	if not self:GetAbility() then   
		return  
	end 
	self.critical = self:GetAbility():GetSpecialValueFor("critical")
	self.critical_ex = self:GetAbility():GetSpecialValueFor("critical_ex")
	self.broken_duration = self:GetAbility():GetSpecialValueFor("broken_duration")
	self.movespeed = self:GetAbility():GetSpecialValueFor("move_speed_ex")
	self.duration_ex = self:GetAbility():GetSpecialValueFor("stun_duration_ex")
	self.duration = self:GetAbility():GetSpecialValueFor("stun_duration")
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
	if keys.attacker == self:GetParent() then 
		if  not keys.target:IsBuilding() and not keys.target:IsOther() and keys.attacker:HasModifier("modifier_imba_death_invisible") then
			keys.target:AddNewModifier_RS(keys.attacker,self:GetAbility(),"modifier_imba_death_mark",{duration = self.broken_duration})
		local cast_angle = VectorToAngles(keys.target:GetForwardVector() * -1)
		local angle = VectorToAngles((keys.attacker:GetAbsOrigin() - keys.target:GetAbsOrigin()):Normalized())
		local degree = math.abs(AngleDiff(cast_angle[2], angle[2]))
		local min_degree = 65
	--print(tostring(degree))
			if degree <= min_degree then
				keys.target:AddNewModifier_RS(keys.attacker,self:GetAbility(),"modifier_imba_stunned",{duration = self.duration_ex})
			else
				keys.target:AddNewModifier_RS(keys.attacker,self:GetAbility(),"modifier_imba_stunned",{duration = self.duration})
			end
		end
		self:Destroy()
	end
end

function modifier_imba_death_invisible:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() then
		local cast_angle = VectorToAngles(keys.target:GetForwardVector() * -1)
		local angle = VectorToAngles((keys.attacker:GetAbsOrigin() - keys.target:GetAbsOrigin()):Normalized())
		local degree = math.abs(AngleDiff(cast_angle[2], angle[2]))
		local min_degree = 65
		if degree <= min_degree then
			return self.critical_ex
			else
			return self.critical
		
		end
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
	self:Destroy()
end



function modifier_imba_death_invisible:GetEffectName() 
		return "particles/generic_hero_status/status_invisibility_start.vpcf" 
end
function modifier_imba_death_invisible:GetEffectAttachType() return PATTACH_ABSORIGIN end
function modifier_imba_death_invisible:GetModifierInvisibilityLevel() return 1 end



--强隐cd
modifier_imba_death_invisible_ex_cd = class({})
function modifier_imba_death_invisible_ex_cd:IsDebuff()			return false end
function modifier_imba_death_invisible_ex_cd:IsHidden() 			return true end
function modifier_imba_death_invisible_ex_cd:IsPurgable() 		return false end
function modifier_imba_death_invisible_ex_cd:IsPurgeException() 	return false end 

--强隐 
modifier_imba_death_invisible_ex = class({})
function modifier_imba_death_invisible_ex:IsDebuff()			return false end
function modifier_imba_death_invisible_ex:IsHidden() 			return false end
function modifier_imba_death_invisible_ex:IsPurgable() 		return false end
function modifier_imba_death_invisible_ex:IsPurgeException() 	return false end 
function modifier_imba_death_invisible_ex:GetEffectName() return "particles/generic_hero_status/status_invisibility_start.vpcf" end
function modifier_imba_death_invisible_ex:GetEffectAttachType() return PATTACH_ABSORIGIN end
function modifier_imba_death_invisible_ex:GetModifierInvisibilityLevel() return 1 end
function modifier_imba_death_invisible_ex:GetTexture()		return "item_death" end	
function modifier_imba_death_invisible_ex:DeclareFunctions() 	return {MODIFIER_PROPERTY_DISABLE_AUTOATTACK,MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end
function modifier_imba_death_invisible_ex:GetTexture()		return "item_death" end	
function modifier_imba_death_invisible_ex:CheckState()
	local tab = {
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
		}

	return tab
end


--被动
modifier_imba_death_passive = class({})
LinkLuaModifier("modifier_imba_death_invisible_ex", "ting/items/item_death", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_invisible_ex_cd", "ting/items/item_death", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_death_passive:GetTexture()		return "item_death" end	
function modifier_imba_death_passive:IsDebuff()			return false end
function modifier_imba_death_passive:IsHidden() 			return true end
function modifier_imba_death_passive:IsPurgable() 			return false end
function modifier_imba_death_passive:IsPurgeException() 	return false end


function modifier_imba_death_passive:OnCreated()		
	if not self:GetAbility() then   
		return  
	end 
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_asp = self:GetAbility():GetSpecialValueFor("bonus_asp")
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
	self.movespeed = self:GetAbility():GetSpecialValueFor("movespeed")
end
function modifier_imba_death_passive:OnDeath(keys)
	if not IsServer() then
		return
	end
	if keys.unit:IS_TrueHero_TG() and keys.attacker:HasModifier("modifier_imba_death_passive") and keys.attacker == self:GetParent() then
	--print(keys.attacker:GetName())
	if not keys.attacker:HasModifier("modifier_imba_death_invisible_ex_cd") then 
		keys.attacker:EmitSound("DOTA_Item.InvisibilitySword.Activate")
		keys.attacker:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_imba_death_invisible_ex",{duration = self:GetAbility():GetSpecialValueFor("duration_inv")})
		local pfx = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_death_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
		ParticleManager:SetParticleControlEnt(pfx, 1, keys.attacker, PATTACH_ABSORIGIN_FOLLOW, nil, keys.attacker:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		keys.attacker:AddNewModifier(keys.attacker,self:GetAbility(),"modifier_imba_death_invisible_ex_cd",{duration = self:GetAbility():GetSpecialValueFor("inv_cd")})
	end
	end
end

function modifier_imba_death_passive:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_PROVIDES_FOW_POSITION, MODIFIER_EVENT_ON_DEATH} end
function modifier_imba_death_passive:GetModifierBonusStats_Agility() return self.bonus_agi end
function modifier_imba_death_passive:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_imba_death_passive:GetModifierAttackSpeedBonus_Constant() return self.bonus_asp end
function modifier_imba_death_passive:GetModifierMoveSpeedBonus_Percentage() return self.movespeed end





