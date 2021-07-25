item_imba_maelstrom = class({})

LinkLuaModifier("modifier_imba_maelstrom_passive", "items/old_imba/item_maelstrom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_maelstrom_unique", "items/old_imba/item_maelstrom", LUA_MODIFIER_MOTION_NONE)

function item_imba_maelstrom:GetIntrinsicModifierName() return "modifier_imba_maelstrom_passive" end

modifier_imba_maelstrom_passive = class({})

function modifier_imba_maelstrom_passive:IsDebuff()			return false end
function modifier_imba_maelstrom_passive:IsHidden() 		return true end
function modifier_imba_maelstrom_passive:IsPermanent() 		return true end
function modifier_imba_maelstrom_passive:IsPurgable() 		return false end
function modifier_imba_maelstrom_passive:IsPurgeException() return false end
function modifier_imba_maelstrom_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_maelstrom_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_maelstrom_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_maelstrom_passive:GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_imba_maelstrom_passive:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_as") end

function modifier_imba_maelstrom_passive:OnCreated()
--	self:SetMaelStromParticle()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_maelstrom_unique", {})
	end
end

function modifier_imba_maelstrom_passive:OnDestroy()
	if IsServer() and not self:GetParent():HasModifier("modifier_imba_maelstrom_passive") then
		self:GetParent():RemoveModifierByName("modifier_imba_maelstrom_unique")
	end
end

modifier_imba_maelstrom_unique = class({})

function modifier_imba_maelstrom_unique:IsDebuff()			return false end
function modifier_imba_maelstrom_unique:IsHidden() 			return true end
function modifier_imba_maelstrom_unique:IsPurgable() 		return false end
function modifier_imba_maelstrom_unique:IsPurgeException() 	return false end
function modifier_imba_maelstrom_unique:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_maelstrom_unique:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_imba_maelstrom_unique:OnCreated()
	--self:SetMaelStromParticle()
	self.ability = self:GetAbility()
end

function modifier_imba_maelstrom_unique:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or not keys.target:IsUnit() or not self:GetParent().splitattack or not self:GetParent().kuangzhandianchui or not keys.target:IsAlive() then
		return
	end
	if PseudoRandom:RollPseudoRandom(self.ability, self.ability:GetSpecialValueFor("proc_chance")) then
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")
		local units = {}
		units[#units + 1] = keys.target
		for i, aunit in pairs(units) do
			local units1 = FindUnitsInRadius(self:GetParent():GetTeamNumber(), aunit:GetAbsOrigin(), nil, self.ability:GetSpecialValueFor("bounce_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			for _, unit1 in pairs(units1) do
				local no_yet = true
				for _, unit in pairs(units) do
					if unit == unit1 or unit1 == self:GetParent() then
						no_yet = false
						break
					end
				end
				if no_yet then
					units[#units + 1] = unit1
					break
				end
			end
		end
		table.insert(units, 1, self:GetParent())
		for k, unit in pairs(units) do
			if k < #units then
				units[k+1]:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
				local pfx = ParticleManager:CreateParticle(self.chain_pfx, PATTACH_POINT_FOLLOW, unit)
				ParticleManager:SetParticleControlEnt(pfx, 0, units[k], PATTACH_POINT_FOLLOW, (units[k] == caster and "attach_attack1" or "attach_hitloc"), units[k]:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, units[k+1], PATTACH_POINT_FOLLOW, "attach_hitloc", units[k+1 >= #units and k or k+1]:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(pfx, 2, Vector(1,1,1))
				ParticleManager:SetParticleControl(pfx, 15, self.color)
				ParticleManager:ReleaseParticleIndex(pfx)
				local damageTable = {
									victim = units[k+1],
									attacker = self:GetCaster(),
									damage = self.ability:GetSpecialValueFor("bounce_damage"),
									damage_type = DAMAGE_TYPE_PURE,
									damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
									ability = self:GetAbility(), --Optional.
									}
				ApplyDamage(damageTable)
			end
		end
	end
end


item_imba_mjollnir = class({})

LinkLuaModifier("modifier_imba_mjollnir_passive", "items/old_imba/item_maelstrom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mjollnir_unique", "items/old_imba/item_maelstrom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_mjollnir_shield", "items/old_imba/item_maelstrom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_mjollnir_slow", "items/old_imba/item_maelstrom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_mjollnir_cooldown", "items/old_imba/item_maelstrom", LUA_MODIFIER_MOTION_NONE)

function item_imba_mjollnir:GetIntrinsicModifierName() return "modifier_imba_mjollnir_passive" end

function item_imba_mjollnir:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	target:RemoveModifierByName("modifier_item_imba_mjollnir_shield")
	target:AddNewModifier(caster, self, "modifier_item_imba_mjollnir_shield", {duration = self:GetSpecialValueFor("static_duration")})
	target:EmitSound("DOTA_Item.Mjollnir.Activate")
	--print(target:HasInventory())
end

modifier_imba_mjollnir_passive = class({})

function modifier_imba_mjollnir_passive:IsDebuff()			return false end
function modifier_imba_mjollnir_passive:IsHidden() 			return true end
function modifier_imba_mjollnir_passive:IsPermanent() 		return true end
function modifier_imba_mjollnir_passive:IsPurgable() 		return false end
function modifier_imba_mjollnir_passive:IsPurgeException() 	return false end
function modifier_imba_mjollnir_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_mjollnir_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_mjollnir_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_mjollnir_passive:GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_imba_mjollnir_passive:GetModifierAttackSpeedBonus_Constant() return self.bonus_as end

function modifier_imba_mjollnir_passive:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.bonus_damage=self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_as=self:GetAbility():GetSpecialValueFor("bonus_as")
	--self:SetMaelStromParticle()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_mjollnir_unique", {})
	end
end

function modifier_imba_mjollnir_passive:OnDestroy()
	if IsServer() and not self:GetParent():HasModifier("modifier_imba_mjollnir_passive") then
		self:GetParent():RemoveModifierByName("modifier_imba_mjollnir_unique")
	end
end

modifier_imba_mjollnir_unique = class({})

function modifier_imba_mjollnir_unique:IsDebuff()			return false end
function modifier_imba_mjollnir_unique:IsHidden() 			return true end
function modifier_imba_mjollnir_unique:IsPurgable() 		return false end
function modifier_imba_mjollnir_unique:IsPurgeException() 	return false end
function modifier_imba_mjollnir_unique:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_mjollnir_unique:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function modifier_imba_mjollnir_unique:OnCreated()
	if self:GetAbility() == nil then
		return
	end
	--self:SetMaelStromParticle()
	self.ability = self:GetAbility()
	self.proc_chance = self.ability:GetSpecialValueFor("proc_chance")
	self.mjollnir_cooldown = self.ability:GetSpecialValueFor("mjollnir_cooldown")
	self.bounce_damage = self.ability:GetSpecialValueFor("bounce_damage")
	self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self:GetAbility(), --Optional.
		}
end

function modifier_imba_mjollnir_unique:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() or keys.target:IsCourier() or keys.target:IsOther() or not keys.target:IsAlive() then
		return
	end--
	if PseudoRandom:RollPseudoRandom(self.ability,self.proc_chance) and not self:GetParent():HasModifier("modifier_item_imba_mjollnir_cooldown") then
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")
		self:GetParent():AddNewModifier(self:GetParent(), self.ability, "modifier_item_imba_mjollnir_cooldown", {duration = self.mjollnir_cooldown})
		if self:GetParent():HasItemInInventory("item_three_knives") then
			self.damageTable.damage=self.bounce_damage+self:GetCaster():GetPrimaryStatValue()*0.3
		else
			self.damageTable.damage=self.bounce_damage
		end
		local units = {}
		units[#units + 1] = keys.target
		for i, aunit in pairs(units) do
			local units1 = FindUnitsInRadius(
				self:GetParent():GetTeamNumber(),
				aunit:GetAbsOrigin(),
				nil,
				self.ability:GetSpecialValueFor("bounce_radius"),
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				FIND_CLOSEST,
				false)
			if #units1>0 then
			for _, unit1 in pairs(units1) do
				local no_yet = true
				for _, unit in pairs(units) do
					if unit == unit1 or unit1 == self:GetParent() then
						no_yet = false
						break
					end
				end
				if no_yet then
					units[#units + 1] = unit1
					break
				end
			end
			end
		end
		table.insert(units, 1, self:GetParent())
		local num=1
		Timers:CreateTimer(0, function()
			if units~=nil and #units>0 then
				if num<#units then
					units[num+1]:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
					local pfx = ParticleManager:CreateParticle("particles/items2_fx/mjollnir_shield_arc_01.vpcf", PATTACH_POINT_FOLLOW, units[num+1])
					ParticleManager:SetParticleControlEnt(pfx, 0, units[num], PATTACH_POINT_FOLLOW, (units[num] == self:GetCaster() and "attach_attack1" or "attach_hitloc"), units[num]:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(pfx, 1, units[num+1], PATTACH_POINT_FOLLOW, "attach_hitloc", units[num+1 >= #units and num or num+1]:GetAbsOrigin(), true)
					ParticleManager:SetParticleControl(pfx, 2, Vector(1,1,1))
					ParticleManager:ReleaseParticleIndex(pfx)
					self.damageTable.victim = units[num+1]
					ApplyDamage(self.damageTable)
					num=num+1
					return 0.25
				else
					return nil
				end
			end
		end)
	--[[	for k, unit in pairs(units) do
			if k < #units then
				units[k+1]:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
				local pfx = ParticleManager:CreateParticle("particles/econ/events/ti10/maelstrom_ti10.vpcf", PATTACH_POINT_FOLLOW, unit)
				ParticleManager:SetParticleControlEnt(pfx, 0, units[k], PATTACH_POINT_FOLLOW, (units[k] == caster and "attach_attack1" or "attach_hitloc"), units[k]:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, units[k+1], PATTACH_POINT_FOLLOW, "attach_hitloc", units[k+1 >= #units and k or k+1]:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(pfx, 2, Vector(1,1,1))
				ParticleManager:ReleaseParticleIndex(pfx)
				ParticleManager:ReleaseParticleIndex(pfx)
				self.damageTable.victim = units[k+1]
				ApplyDamage(self.damageTable)
			end
		end]]
	end
end



modifier_item_imba_mjollnir_shield = class({})

function modifier_item_imba_mjollnir_shield:IsDebuff()			return false end
function modifier_item_imba_mjollnir_shield:IsHidden() 			return false end
function modifier_item_imba_mjollnir_shield:IsPurgable() 		return true end
function modifier_item_imba_mjollnir_shield:IsPurgeException() 	return true end
function modifier_item_imba_mjollnir_shield:GetStatusEffectName() return "particles/status_fx/status_effect_mjollnir_shield.vpcf" end
function modifier_item_imba_mjollnir_shield:StatusEffectPriority() return 15 end
function modifier_item_imba_mjollnir_shield:OnCreated()
	if self:GetAbility() == nil then
		return
	end
	self.ability = self:GetAbility()
--	self:SetMaelStromParticle()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/items2_fx/mjollnir_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(pfx, false, false, 15, false, false)
		self:GetParent():EmitSound("DOTA_Item.Mjollnir.Loop")
	end
end
function modifier_item_imba_mjollnir_shield:OnDestroy()
--	self.chain_pfx = nil
--	self.shield_pfx = nil
--	self.color = nil
	if IsServer() then
		self:GetParent():StopSound("DOTA_Item.Mjollnir.Loop")
		self:GetParent():EmitSound("DOTA_Item.Mjollnir.DeActivate")
	end
end
function modifier_item_imba_mjollnir_shield:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end

function modifier_item_imba_mjollnir_shield:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() or not self:IsHeroDamage(keys.attacker, keys.damage) then
		return
	end
	self:SetStackCount(self:GetStackCount() + 1)
	if self:GetStackCount() >= self.ability:GetSpecialValueFor("static_proc_count") then
		self:SetStackCount(0)
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.ability:GetSpecialValueFor("static_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
		for _, enemy in pairs(enemies) do
			local pfx = ParticleManager:CreateParticle("particles/items2_fx/mjollnir_shield_arc_01.vpcf", PATTACH_POINT_FOLLOW, enemy)
			ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			local change = RandomFloat(1.0, 2.0)
			ParticleManager:SetParticleControl(pfx, 2, Vector(RandomFloat(1.0, 2.0),RandomFloat(1.0, 2.0),RandomFloat(1.0, 2.0)))
		--	ParticleManager:SetParticleControl(pfx, 15, self.color)
			ParticleManager:ReleaseParticleIndex(pfx)
			ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = self.ability:GetSpecialValueFor("static_damage"), ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL})
			enemy:AddNewModifier_RS(self:GetCaster(), self.ability, "modifier_item_imba_mjollnir_slow", {duration = self.ability:GetSpecialValueFor("static_slow_duration")})
		end
	end
end

function modifier_item_imba_mjollnir_shield:IsHeroDamage(attacker, damage)
	if damage > 0 then
		if attacker:IsBoss() or attacker:IsControllableByAnyPlayer() or attacker:GetName() == "npc_dota_shadowshaman_serpentward" then
			return true
		else
			return false
		end
	end
end

modifier_item_imba_mjollnir_slow = class({})

function modifier_item_imba_mjollnir_slow:IsDebuff()			return true end
function modifier_item_imba_mjollnir_slow:IsHidden() 			return false end
function modifier_item_imba_mjollnir_slow:IsPurgable() 			return true end
function modifier_item_imba_mjollnir_slow:IsPurgeException() 	return true end
function modifier_item_imba_mjollnir_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_item_imba_mjollnir_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("static_slow")) end
function modifier_item_imba_mjollnir_slow:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("static_slow")) end

modifier_item_imba_mjollnir_cooldown = class({})
function modifier_item_imba_mjollnir_cooldown:IsDebuff()			return false end
function modifier_item_imba_mjollnir_cooldown:IsHidden() 			return true end
function modifier_item_imba_mjollnir_cooldown:IsPurgable() 			return false end
function modifier_item_imba_mjollnir_cooldown:IsPurgeException() 	return false end