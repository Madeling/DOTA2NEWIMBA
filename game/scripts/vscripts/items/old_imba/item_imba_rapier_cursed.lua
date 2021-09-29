item_imba_rapier_cursed = class({})

LinkLuaModifier("modifier_imba_rapier_super_passive", "items/old_imba/item_imba_rapier_cursed.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rapier_super_unique", "items/old_imba/item_imba_rapier_cursed.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rapier_unique_passive", "items/old_imba/item_imba_rapier_cursed.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rapier_magic_unique_passive", "items/old_imba/item_imba_rapier_cursed.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_rapier_cursed:GetIntrinsicModifierName() return "modifier_imba_rapier_super_passive" end

function item_imba_rapier_cursed:OnOwnerDied()
	local caster=self:GetCaster()
	if (not caster:IsTrueHero() and not caster:IsIllusion()) or not caster:IsReincarnating() then

		caster:DropItemAtPositionImmediate(self, caster:GetAbsOrigin())
		local pos = caster:GetAbsOrigin() + caster:GetForwardVector() * 100
		pos = RotatePosition(caster:GetAbsOrigin(), QAngle(0, RandomInt(0, 360), 0), pos)
		self:LaunchLoot(false, 250, 0.5, pos)
		Notifications:BottomToAll({hero=self:GetPurchaser():GetUnitName(), duration=5.0, class="NotificationMessage"})
		Notifications:BottomToAll({text="#"..self:GetPurchaser():GetUnitName(), continue=true})
		Notifications:BottomToAll({text="掉落了", continue=true})
		Notifications:BottomToAll({text="#DOTA_Tooltip_ability_"..self:GetName(), continue=true})
		self:SetPurchaser(nil)
	--	local rapier_cursed = CreateItem("item_imba_rapier_cursed", nil, nil)
	--	if rapier_cursed then
	--		CreateItemOnPositionSync(caster:GetAbsOrigin()+caster:GetUpVector()*100, rapier_cursed)
		--end
		for i = 2, 3 do
		AddFOWViewer(i,caster:GetAbsOrigin(), 300,7, false)
		end
		--CreateModifierThinker(nil, self, "modifier_imba_rapier_vision", {}, self:GetAbsOrigin(), DOTA_TEAM_NEUTRALS, false)
	end
end

modifier_imba_rapier_super_passive = class({})

function modifier_imba_rapier_super_passive:IsDebuff()			return false end
function modifier_imba_rapier_super_passive:IsHidden() 			return true end
function modifier_imba_rapier_super_passive:IsPurgable() 		return false end
function modifier_imba_rapier_super_passive:IsPurgeException() 	return false end
function modifier_imba_rapier_super_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_rapier_super_passive:DeclareFunctions() return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_PROVIDES_FOW_POSITION} end
function modifier_imba_rapier_super_passive:GetModifierSpellAmplify_Percentage()
	if IsServer() then
		if self:GetParent():IsIllusion() then
			return 0
		else
			return self:GetAbility():GetSpecialValueFor("spell_power")
		end
	else
		return self:GetAbility():GetSpecialValueFor("spell_power")
	end
end
function modifier_imba_rapier_super_passive:GetModifierPreAttack_BonusDamage()
	if self:GetParent():HasModifier("modifier_imba_haunt_timer") then
		return 0
	end
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end
function modifier_imba_rapier_super_passive:GetModifierProvidesFOWVision() return 1 end

function modifier_imba_rapier_super_passive:OnCreated()
	if self:GetAbility() then
	self.time_to_double=self:GetAbility():GetSpecialValueFor("time_to_double")
	self.base_corruption=self:GetAbility():GetSpecialValueFor("base_corruption")
end
	if IsServer() then
		if not self:GetParent():IsIllusion() then
			local pfx = ParticleManager:CreateParticle("particles/tgp/items/rapier_super/rapier_super_buff_m.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW   , self:GetParent())
			ParticleManager:SetParticleControl(pfx,0,self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx,1,Vector(200,0,0))
			self:AddParticle(pfx, false, false, 15, false, true)
		end
		self:StartIntervalThink(0.1)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_rapier_super_unique", {})
		--lifesteal
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_rapier_unique_passive", {})
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_rapier_magic_unique_passive", {})
	end
end

function modifier_imba_rapier_super_passive:OnIntervalThink()
	self:SetStackCount(math.floor(self:GetElapsedTime() / self.time_to_double))
	local dmg_pct = self.base_corruption / (1.0 / 0.1)
	dmg_pct = dmg_pct * self:GetStackCount() / 100
	local dmg = self:GetParent():GetMaxHealth() * dmg_pct
	self:GetParent():SetHealth(math.max(1, self:GetParent():GetHealth() - dmg))
end

function modifier_imba_rapier_super_passive:OnDestroy()
	if IsServer() then
		if not self:GetParent():HasModifier("modifier_imba_rapier_super_passive") then
			self:GetParent():RemoveModifierByName("modifier_imba_rapier_super_unique")
		end
		if not self:GetParent():HasModifier("modifier_imba_rapier_unique") and not self:GetParent():HasModifier("modifier_imba_rapier_three_unique") and not self:GetParent():HasModifier("modifier_imba_rapier_super_passive") then
			self:GetParent():RemoveModifierByName("modifier_imba_rapier_unique_passive")
		end
		if not self:GetParent():HasModifier("modifier_imba_rapier_magic_unique") and not self:GetParent():HasModifier("modifier_imba_rapier_magic_three_unique") and not self:GetParent():HasModifier("modifier_imba_rapier_super_passive") then
			self:GetParent():RemoveModifierByName("modifier_imba_rapier_magic_unique_passive")
		end
	end
end

modifier_imba_rapier_super_unique = class({})

function modifier_imba_rapier_super_unique:OnCreated()
	self.ability = self:GetAbility()
	self.re = self.ability:GetSpecialValueFor("damage_reduction")*-1
	self.res = self.ability:GetSpecialValueFor("disable_reduction")
	if self:GetParent():HasModifier("modifier_imba_bristleback_passive")  then
		self.re = -10
		self.res = 20
	end
end

function modifier_imba_rapier_super_unique:OnDestroy() self.ability = nil end
function modifier_imba_rapier_super_unique:IsDebuff()			return false end
function modifier_imba_rapier_super_unique:IsHidden() 			return true end
function modifier_imba_rapier_super_unique:IsPurgable() 		return false end
function modifier_imba_rapier_super_unique:IsPurgeException() 	return false end
function modifier_imba_rapier_super_unique:DeclareFunctions() return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING} end
function modifier_imba_rapier_super_unique:GetModifierIncomingDamage_Percentage() return self.re end
function modifier_imba_rapier_super_unique:GetModifierStatusResistanceStacking() return self.res end


modifier_imba_rapier_unique_passive = class({})
function modifier_imba_rapier_unique_passive:IsDebuff()				return false end
function modifier_imba_rapier_unique_passive:IsHidden() 			return true end
function modifier_imba_rapier_unique_passive:IsPurgable() 			return false end
function modifier_imba_rapier_unique_passive:IsPurgeException() 	return false end
function modifier_imba_rapier_unique_passive:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = true} end
function modifier_imba_rapier_unique_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_DEATH} end
function modifier_imba_rapier_unique_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and (keys.target:IsHero() or keys.target:IsCreep() or keys.target:IsBoss()) then
		local lifesteal = keys.damage * (self:GetAbility():GetSpecialValueFor("lifesteal_percent") / 100)
		self:GetParent():Heal(lifesteal, self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), lifesteal, nil)
	end
end
function modifier_imba_rapier_unique_passive:OnDeath(keys)
	if not IsServer() or self:GetParent():IsIllusion() or keys.reincarnate then
		return
	end
	if IsEnemy(keys.unit, self:GetParent()) and keys.unit:IsTrueHero() and not keys.unit:IsClone() and not keys.unit:IsTempestDouble() and (self:GetParent():GetAbsOrigin() - keys.unit:GetAbsOrigin()):Length2D() <= self:GetAbility():GetSpecialValueFor("effect_radius") then
		for i=0, 5 do
			local item = self:GetParent():GetItemInSlot(i)
			if item and item:GetName() == "item_imba_rapier" then
				item:SetCurrentCharges(item:GetCurrentCharges() + 1)
			end
		end
	end
end

modifier_imba_rapier_magic_unique_passive = class({})
function modifier_imba_rapier_magic_unique_passive:IsDebuff()			return false end
function modifier_imba_rapier_magic_unique_passive:IsHidden() 			return true end
function modifier_imba_rapier_magic_unique_passive:IsPurgable() 			return false end
function modifier_imba_rapier_magic_unique_passive:IsPurgeException() 	return false end
function modifier_imba_rapier_magic_unique_passive:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = true} end
function modifier_imba_rapier_magic_unique_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_imba_rapier_magic_unique_passive:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and keys.inflictor and IsEnemy(keys.attacker, keys.unit) and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
		local dmg = keys.damage * (self:GetAbility():GetSpecialValueFor("spell_lifesteal_percent") / 100)
		if keys.unit:IsCreep() then
			dmg = dmg / 5
		end
		self:GetParent():Heal(dmg, self:GetAbility())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), dmg, nil)
		--自动移除雾效果
		if self:GetParent():HasModifier("modifier_smoke_of_deceit") then
			self:GetParent():RemoveModifierByName("modifier_smoke_of_deceit")
		end
	end
end



item_imba_rapier_magic = class({})

LinkLuaModifier("modifier_imba_rapier_magic_unique", "items/old_imba/item_imba_rapier_cursed.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_rapier_magic = class({})

function item_imba_rapier_magic:GetIntrinsicModifierName() return "modifier_imba_rapier_magic_unique" end

function item_imba_rapier_magic:OnOwnerDied()
	if (not self:GetCaster():IsTrueHero() and not self:GetCaster():IsIllusion()) or not self:GetCaster():IsReincarnating() then
		self:GetCaster():DropItemAtPositionImmediate(self, self:GetCaster():GetAbsOrigin())
		self:LaunchLoot(false, 250, 0.5, self:GetCaster():GetAbsOrigin() + RandomVector(100))
		Notifications:BottomToAll({hero=self:GetPurchaser():GetUnitName(), duration=5.0, class="NotificationMessage"})
		Notifications:BottomToAll({text="#"..self:GetPurchaser():GetUnitName(), continue=true})
		Notifications:BottomToAll({text="掉落了", continue=true})
		Notifications:BottomToAll({text="#DOTA_Tooltip_ability_"..self:GetName(), continue=true})
		self:SetPurchaser(nil)
		for i = 2, 3 do
		AddFOWViewer(i, self:GetCaster():GetAbsOrigin(), 300,7, false)
		end
		--CreateModifierThinker(nil, self, "modifier_imba_rapier_vision", {}, self:GetAbsOrigin(), DOTA_TEAM_NEUTRALS, false)
	end
end

modifier_imba_rapier_magic_unique = class({})

function modifier_imba_rapier_magic_unique:IsDebuff()			return false end
function modifier_imba_rapier_magic_unique:IsHidden() 			return true end
function modifier_imba_rapier_magic_unique:IsPurgable() 		return false end
function modifier_imba_rapier_magic_unique:IsPurgeException() 	return false end
function modifier_imba_rapier_magic_unique:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_rapier_magic_unique:DeclareFunctions() return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE} end
function modifier_imba_rapier_magic_unique:GetModifierSpellAmplify_Percentage()
	if IsServer() then
		if self:GetParent():IsIllusion() then
			return 0
		else
			return self:GetAbility():GetSpecialValueFor("spell_power")
		end
	else
		return self:GetAbility():GetSpecialValueFor("spell_power")
	end
end
function modifier_imba_rapier_magic_unique:OnCreated()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_imba_rapier_magic_unique_passive",{})
	end
end
function modifier_imba_rapier_magic_unique:OnDestroy()
	if IsServer() then
		if not self:GetParent():HasModifier("modifier_imba_rapier_magic_unique") and not self:GetParent():HasModifier("modifier_imba_rapier_magic_three_unique") then
			self:GetParent():RemoveModifierByName("modifier_imba_rapier_magic_unique_passive")
		end
	end
end


LinkLuaModifier("modifier_imba_rapier_vision", "items/old_imba/item_imba_rapier_cursed.lua", LUA_MODIFIER_MOTION_NONE)

modifier_imba_rapier_vision = class({})

function modifier_imba_rapier_vision:OnCreated()
	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink(3)
	end
end

function modifier_imba_rapier_vision:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() or self:GetAbility():GetPurchaser() then
		self:Destroy()
		return
	end
	for i = 2, 3 do
		AddFOWViewer(i, self:GetAbility():GetAbsOrigin(), 300,3, false)
	end
end