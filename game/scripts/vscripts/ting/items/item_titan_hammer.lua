item_imba_titan_hammer = class({})
LinkLuaModifier("modifier_imba_titan_hammer_passive", "ting/items/item_titan_hammer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_titan_hammer_d", "ting/items/item_titan_hammer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_titan_hammer_up", "ting/items/item_titan_hammer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_titan_hammer_stun", "ting/items/item_titan_hammer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_titan_hammer_arrmorb", "ting/items/item_titan_hammer", LUA_MODIFIER_MOTION_NONE)
function item_imba_titan_hammer:GetIntrinsicModifierName() return "modifier_imba_titan_hammer_passive" end
function item_imba_titan_hammer:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	--ParticleManager:FireParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", PATTACH_POINT, caster:GetOwner(), {[0] = point})
  -- 	ParticleManager:FireParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_magical.vpcf", PATTACH_POINT, caster, {[0] = point})
	EmitSoundOn("DOTA_Item.MeteorHammer.Channel", caster)
	local particle= ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell_ground_impact.vpcf", PATTACH_ABSORIGIN,caster)
    ParticleManager:SetParticleControl(particle, 0,point)
    ParticleManager:SetParticleControl(particle, 1,Vector(255,255,255))
    ParticleManager:SetParticleControl(particle, 2,Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
    ParticleManager:SetParticleControl(particle, 3,point)
    ParticleManager:ReleaseParticleIndex( particle )
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		for _, hero in pairs(heroes) do
		local distance = (point - hero:GetAbsOrigin()):Length2D()
		if hero:IsInvulnerable() then return end
		if not hero:IsMagicImmune() then 
		end
			local modifier = hero:AddNewModifier(caster,self,"modifier_imba_titan_hammer_arrmorb",{duration = self:GetSpecialValueFor("duration")})
			modifier:SetStackCount(math.min(100,100 - math.ceil(caster:GetStrength()/self:GetSpecialValueFor("strbb"))))
			
			if distance < 150 then 
							hero:AddNewModifier(caster,self,"modifier_imba_titan_hammer_stun",{duration = self:GetSpecialValueFor("stun")})
			end
				local damageTable = {
                                    victim = hero,
                                    attacker = caster,
                                    damage = caster:GetStrength()*self:GetSpecialValueFor("strd"),
                                    damage_type =DAMAGE_TYPE_PHYSICAL,
                                    damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
                                    ability = self,
                                    }
                            ApplyDamage(damageTable)
			
		end
end

modifier_imba_titan_hammer_passive = class({})
LinkLuaModifier("modifier_titan_hammer_d", "ting/items/item_titan_hammer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_titan_hammer_up", "ting/items/item_titan_hammer", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_titan_hammer_passive:IsDebuff()			return false end
function modifier_imba_titan_hammer_passive:IsHidden() 			return true end
function modifier_imba_titan_hammer_passive:IsPurgable() 		return false end
function modifier_imba_titan_hammer_passive:IsPurgeException() 	return false end
function modifier_imba_titan_hammer_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_MANA_REGEN_CONSTANT} end
function modifier_imba_titan_hammer_passive:OnCreated()
	self.ab = self:GetAbility()
	self.duration = self.ab:GetSpecialValueFor("duration")
	self.str = self.ab:GetSpecialValueFor("str")
	self.att = self.ab:GetSpecialValueFor("damage")
	self.hpre = self.ab:GetSpecialValueFor("hpre")
	self.mare = self.ab:GetSpecialValueFor("manare")
end
function modifier_imba_titan_hammer_passive:GetModifierConstantHealthRegen()
	return self.hpre
end
function modifier_imba_titan_hammer_passive:GetModifierConstantManaRegen()
	return self.mare
end
function modifier_imba_titan_hammer_passive:GetModifierBonusStats_Strength()
	return self.str
end
function modifier_imba_titan_hammer_passive:GetModifierPreAttack_BonusDamage()
	return self.att
end

function modifier_imba_titan_hammer_passive:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() and not keys.target:IsMagicImmune() then 
	local target = keys.target
	local attacker = keys.attacker
	if target:GetPhysicalArmorValue(true) == 0 then return end
	if target:GetPhysicalArmorValue(true) > 0 then
		if target:HasModifier("modifier_titan_hammer_up") then
			local a = target:FindModifierByName("modifier_titan_hammer_up"):GetStackCount()
			if a - math.ceil(attacker:GetStrength()) > 0 then 
			local modifier = target:AddNewModifier(attacker,self.ab,"modifier_titan_hammer_up",{duration = self.duration})
			modifier:SetStackCount(a - math.ceil(attacker:GetStrength()))
		else
			target:RemoveModifierByName("modifier_titan_hammer_up")
			local modifier = target:AddNewModifier(attacker,self.ab,"modifier_titan_hammer_d",{duration = self.duration})
			modifier:SetStackCount(math.abs(a - math.ceil(attacker:GetStrength())))
		end
			else
		local modifier = target:AddNewModifier(attacker,self.ab,"modifier_titan_hammer_d",{duration = self.duration})
		local stack = modifier:GetStackCount()
		modifier:SetStackCount(stack+math.ceil(attacker:GetStrength()))
		end
	else
		if target:HasModifier("modifier_titan_hammer_d") then
			local a = target:FindModifierByName("modifier_titan_hammer_d"):GetStackCount()
			if a - math.ceil(attacker:GetStrength()) > 0 then 
			local modifier = target:AddNewModifier(attacker,self.ab,"modifier_titan_hammer_d",{duration = self.duration})
			modifier:SetStackCount(a - math.ceil(attacker:GetStrength()))
			else
			target:RemoveModifierByName("modifier_titan_hammer_d")
			local modifier = target:AddNewModifier(attacker,self.ab,"modifier_titan_hammer_up",{duration = self.duration})
			modifier:SetStackCount(math.abs(a - math.ceil(attacker:GetStrength())))
			end
		else
		local modifier = target:AddNewModifier(attacker,self.ab,"modifier_titan_hammer_up",{duration = self.duration})
				local stack = modifier:GetStackCount()
		modifier:SetStackCount(stack+math.ceil(attacker:GetStrength()))
		end
	end
	end
end

function modifier_imba_titan_hammer_passive:OnDestroy()
	self.str = nil
	self.att = nil
	self.hpre = nil
	self.mare = nil
	self.duration = nil
	self.ab = nil
end


modifier_titan_hammer_d = class({})
function modifier_titan_hammer_d:IsDebuff()			return true end
function modifier_titan_hammer_d:IsHidden() 			return false end
function modifier_titan_hammer_d:IsPurgable() 			return true end
function modifier_titan_hammer_d:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_titan_hammer_d:GetTexture()			return "item_titan_hammer" end
function modifier_titan_hammer_d:OnCreated()
	self.armord = -1*self:GetAbility():GetSpecialValueFor("strb")*0.01
end
function modifier_titan_hammer_d:OnDestroy()
	self.armord = nil
end
function modifier_titan_hammer_d:GetModifierPhysicalArmorBonus() return self.armord*self:GetStackCount() end


modifier_titan_hammer_up = class({})
function modifier_titan_hammer_up:IsDebuff()			return false end
function modifier_titan_hammer_up:IsHidden() 			return false end
function modifier_titan_hammer_up:IsPurgable() 			return true end
function modifier_titan_hammer_up:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_titan_hammer_up:GetTexture()			return "item_titan_hammer" end
function modifier_titan_hammer_up:OnCreated()
	self.armorup = self:GetAbility():GetSpecialValueFor("strb")*0.01
end
function modifier_titan_hammer_up:OnDestroy()
	self.armorup = nil
end
function modifier_titan_hammer_up:GetModifierPhysicalArmorBonus() return self.armorup*self:GetStackCount() end



modifier_imba_titan_hammer_stun = class({})
function modifier_imba_titan_hammer_stun:IsDebuff()			return true end
function modifier_imba_titan_hammer_stun:IsHidden() 			return false end
function modifier_imba_titan_hammer_stun:IsPurgable() 			return false end
function modifier_imba_titan_hammer_stun:IsPurgeException() 	return true end
function modifier_imba_titan_hammer_stun:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_imba_titan_hammer_stun:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_imba_titan_hammer_stun:GetOverrideAnimation() return ACT_DOTA_DISABLED end
function modifier_imba_titan_hammer_stun:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_imba_titan_hammer_stun:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_titan_hammer_stun:ShouldUseOverheadOffset() return true end
function modifier_imba_titan_hammer_stun:GetTexture()			return "item_titan_hammer" end

modifier_imba_titan_hammer_arrmorb = class({})
function modifier_imba_titan_hammer_arrmorb:IsDebuff()			return true end
function modifier_imba_titan_hammer_arrmorb:IsHidden() 			return false end
function modifier_imba_titan_hammer_arrmorb:IsPurgable() 			return false end
function modifier_imba_titan_hammer_arrmorb:IsPurgeException() 	return true end
function modifier_imba_titan_hammer_arrmorb:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE} end
function modifier_imba_titan_hammer_arrmorb:GetModifierPhysicalArmorBase_Percentage() return self:GetStackCount() end
function modifier_imba_titan_hammer_arrmorb:GetTexture()			return "item_titan_hammer" end

