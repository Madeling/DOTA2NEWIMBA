
modifier_imba_meepo_clone_controller = class({})

function modifier_imba_meepo_clone_controller:IsDebuff()			return false end
function modifier_imba_meepo_clone_controller:IsHidden() 			return true end
function modifier_imba_meepo_clone_controller:IsPurgable() 			return false end
function modifier_imba_meepo_clone_controller:IsPurgeException() 	return false end
function modifier_imba_meepo_clone_controller:RemoveOnDeath() 		return false end
function modifier_imba_meepo_clone_controller:OnCreated()
	if IsServer() then
		self.base = self:GetCaster()
		self.meepo = self:GetParent()
		self.base_item = {}
		self.clone_item = {}
	--	self:StartIntervalThink(1)
	--		self.meepo:AddNewModifier(self.meepo, nil, "modifier_imba_ability_layout_contoroller", {})
	end
end

function modifier_imba_meepo_clone_controller:OnIntervalThink()
	if self.base:GetModifierStackCount("modifier_imba_moon_shard_consume", nil) > 0 then
		self.meepo:AddNewModifier(self.base, nil, "modifier_imba_moon_shard_consume", {}):SetStackCount(self.base:GetModifierStackCount("modifier_imba_moon_shard_consume", nil))
	end
	if self.base:HasModifier("modifier_imba_consumable_scepter_consumed") then
		self.meepo:AddNewModifier(self.base, nil, "modifier_imba_consumable_scepter_consumed", {})
	end
	local base_item = {}
	local clone_item = {}
	--[[for i=0, 5 do
		base_item[i] = (self.base:GetItemInSlot(i) and self.base:GetItemInSlot(i):GetPurchaser() == self.base) and self.base:GetItemInSlot(i):GetAbilityName() or "nil"
		--clone_item[i] = self.meepo:GetItemInSlot(i) and self.meepo:GetItemInSlot(i):GetAbilityName() or nil
	end
	local same = true
	for i=0, 5 do
		if base_item[i] ~= self.base_item[i] then
			same = false
			break
		end
	end
	if not same then
		self.base_item = base_item
		-- Remove all clone's items
		for i=0, 5 do
			if self.meepo:GetItemInSlot(i) then
				UTIL_Remove(self.meepo:GetItemInSlot(i))
			end
		end
		for i=0, 5 do
			if self.base_item[i] and IMBA_BOOTS[ self.base_item[i] ] then
				self.meepo:AddItemByName(self.base_item[i])
			else
				self.meepo:AddItemByName("item_imba_dummy")
			end
		end
		for i=0, 5 do
			if self.meepo:GetItemInSlot(i) and self.meepo:GetItemInSlot(i):GetAbilityName() == "item_imba_dummy" then
				UTIL_Remove(self.meepo:GetItemInSlot(i))
			end
		end
	end]]
end

local IMBA_BOOTS = {}

IMBA_BOOTS['item_imba_arcane_boots'] = true
IMBA_BOOTS['item_imba_guardian_greaves'] = true
IMBA_BOOTS['item_imba_phase_boots_2'] = true
IMBA_BOOTS['item_imba_tranquil_boots_2'] = true
IMBA_BOOTS['item_imba_blink_boots'] = true
IMBA_BOOTS['item_imba_power_treads_2'] = true
IMBA_BOOTS['item_power_treads'] = true
IMBA_BOOTS['item_boots'] = true
IMBA_BOOTS['item_travel_boots'] = true
IMBA_BOOTS['item_travel_boots_2'] = true
IMBA_BOOTS['item_phase_boots'] = true
IMBA_BOOTS['item_tranquil_boots'] = true
IMBA_BOOTS['item_nuclear_shoes'] = true
IMBA_BOOTS['item_quantum_shoes'] = true
IMBA_BOOTS['item_premium_tranquil_boots'] = true
IMBA_BOOTS['item_premium_power_treads'] = true
IMBA_BOOTS['item_premium_phase_boots'] = true
IMBA_BOOTS['item_magic_shoes'] = false
imba_meepo_stand_we_divided = class({})

LinkLuaModifier("modifier_imba_stand_we_divided", "linken/hero_meepo.lua", LUA_MODIFIER_MOTION_NONE)

function imba_meepo_stand_we_divided:GetIntrinsicModifierName() return "modifier_imba_stand_we_divided" end
function imba_meepo_stand_we_divided:Set_InitialUpgrade() return {kv=1} end
function imba_meepo_stand_we_divided:OnAbilityPhaseStart() return false end
function imba_meepo_stand_we_divided:GetCooldown(level)
	if IsServer() then 
  local cooldown = self.BaseClass.GetCooldown(self, level)
  local caster = self:GetCaster()
    if caster:TG_HasTalent("special_bonus_imba_meepo_6") then 
      return (cooldown - caster:TG_GetTalentValue("special_bonus_imba_meepo_6"))
    end
  return cooldown
end
end

function imba_meepo_stand_we_divided:OnInventoryContentsChanged()
	if not self.buff then
		return
	end	
	for i=1, #self.buff.meepos do
	if self.buff.meepos[i]~=nil then
		if not self.buff.meepos[i]:GetTP() then
			self.buff.meepos[i]:AddItemByName("item_tpscroll"):SetCurrentCharges(30)
		end
	end
end
--[[
	Timers:CreateTimer(0.1, function()
			for i=1, #self.buff.meepos do
				for j=0, 5 do
					local item = self.buff.meepos[i]:GetItemInSlot(j)
					local base_item = self.buff.base:GetItemInSlot(j)
					if item then
						UTIL_Remove(item)
					end
				end
				for j=0, 5 do
					local item = self.buff.base:GetItemInSlot(j)
					if item and IMBA_BOOTS[item:GetAbilityName()] then
						self.buff.meepos[i]:AddItemByName(item:GetAbilityName())
					else
						self.buff.meepos[i]:AddItemByName("item_imba_dummy")
					end
				end
				if not self.buff.meepos[i]:GetTP() then
					self.buff.meepos[i]:AddItemByName("item_tpscroll"):SetCurrentCharges(30)
					self.buff.meepos[i]:SwapItems(6, 15)
				end
				self.buff.meepos[i]:CalculateStatBonus()
				for j=0, 5 do
					local item = self.buff.meepos[i]:GetItemInSlot(j)
					if item and item:GetAbilityName() == "item_imba_dummy" then
						UTIL_Remove(item)
					end
				end
			end
			return nil
		end
	)]]
end

modifier_imba_stand_we_divided = class({})

function modifier_imba_stand_we_divided:IsDebuff()			return false end
function modifier_imba_stand_we_divided:IsHidden() 			return true end
function modifier_imba_stand_we_divided:IsPurgable() 		return false end
function modifier_imba_stand_we_divided:IsPurgeException() 	return false end
function modifier_imba_stand_we_divided:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end

function modifier_imba_stand_we_divided:OnCreated()
	if IsServer() then
		if not self:GetParent():IS_TrueHero_TG() then
			return
		end
		self.base = self:GetParent()
		self.meepos = {}
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.ability.buff = self
		local pfx = ParticleManager:CreateParticleForPlayer("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.ability:GetSpecialValueFor("radius"), 0, 0))
		ParticleManager:SetParticleControl(pfx, 2, Vector(10, 0, 0))
		ParticleManager:SetParticleControl(pfx, 3, Vector(100, 0, 0))
		ParticleManager:SetParticleControl(pfx, 15, Vector(255, 155, 55))
		self:AddParticle(pfx, true, false, 15, false, false)
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_stand_we_divided:OnIntervalThink()
	if not self.parent:HasAbility("meepo_divided_we_stand") then
		self:StartIntervalThink(-1)
		return
	end
	if not self.ability:IsCooldownReady() or self.ability:GetAutoCastState() then
		return
	end
	local meepo_num = self.parent:FindAbilityByName("meepo_divided_we_stand"):GetLevel() + (self.parent:HasScepter() and 1 or 0)
	if meepo_num ~= #self.meepos then
		local meepo = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, 50000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_ANY_ORDER, false)
		for i=1, #meepo do
			if meepo[i]:GetPlayerOwnerID() == self.parent:GetPlayerOwnerID() and meepo[i]:IsRealHero() and not IsInTable(meepo[i], self.meepos) and self.base ~= meepo[i] then
				self.meepos[#self.meepos + 1] = meepo[i]
			end
		end
		for i=0, 4 do
			self.base:SwapItems(i, i + 1)
			self.base:SwapItems(i, i + 1)
		end
	end
	local nearby_meepo = {}
	if self.base:IsAlive() then
		nearby_meepo[#nearby_meepo + 1] = self.base
	end
	for i=1, #self.meepos do
		if (self.base:GetAbsOrigin() - self.meepos[i]:GetAbsOrigin()):Length2D() <= self.ability:GetSpecialValueFor("radius") and self.meepos[i]:IsAlive() then
			nearby_meepo[#nearby_meepo + 1] = self.meepos[i]
		end
	end
	local not_full = false
	for i=1, #nearby_meepo do
		if nearby_meepo[i]:GetHealth() < nearby_meepo[i]:GetMaxHealth() then
			not_full = true
			break
		end
	end
	local hp_pct = 0
	if #nearby_meepo > 1 and not_full then
		for _, hero in pairs(nearby_meepo) do
			hp_pct = hp_pct + hero:GetHealthPercent()
		end
		hp_pct = (hp_pct / #nearby_meepo) / 100
		for _, hero in pairs(nearby_meepo) do
			local health = hero:GetMaxHealth() * hp_pct
			if health >= 1 then
				hero:SetHealth(health)
			end
		end
		self.ability:UseResources(true, true, true)
	end
end

function modifier_imba_stand_we_divided:OnDeath(keys)
	if not self.base then
		return
	end
	if IsServer() and (keys.unit == self.base or IsInTable(keys.unit, self.meepos)) then
		if self.base:IsAlive() then
			TrueKill2(self.base, self.base, nil)
		end
		for i=1, #self.meepos do
			if self.meepos[i]:IsAlive() then
				TrueKill2(self.meepos[i], self.meepos[i], nil)
			end
		end
		local ability = self.base:FindAbilityByName("imba_wraith_king_reincarnation")
		if self.base:HasModifier("modifier_imba_aegis") then
			self.base:RemoveModifierByName("modifier_imba_aegis")
		else
			if ability and ability:GetLevel() > 0 and ability:IsCooldownReady() and ability:IsOwnersManaEnough() then
				ability:UseResources(true, true, true)
			end
		end
		for i=1, #self.meepos do
			local ability = self.meepos[i]:FindAbilityByName("imba_wraith_king_reincarnation")
			if self.meepos[i] then
				self.meepos[i]:RemoveModifierByName("modifier_imba_aegis")
			else
				if ability and ability:GetLevel() > 0 and ability:IsCooldownReady() and ability:IsOwnersManaEnough() then
					ability:UseResources(true, true, true)
				end
			end
		end
	end
end



imba_meepo_earthbind = class({})

LinkLuaModifier("modifier_imba_meepo_earthbind_root", "linken/hero_meepo.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_meepo_earthbind_self", "linken/hero_meepo.lua", LUA_MODIFIER_MOTION_NONE)

function imba_meepo_earthbind:IsHiddenWhenStolen() 		return false end
function imba_meepo_earthbind:IsRefreshable() 			return true end
function imba_meepo_earthbind:IsStealable() 			return true end
function imba_meepo_earthbind:GetAOERadius()			return self:GetSpecialValueFor("radius") end
function imba_meepo_earthbind:GetIntrinsicModifierName() return "modifier_imba_meepo_earthbind_self" end
function imba_meepo_earthbind:GetCooldown(level)
	if IsServer() then 
  local cooldown = self.BaseClass.GetCooldown(self, level)
  local caster = self:GetCaster()
    if caster:TG_HasTalent("special_bonus_imba_meepo_4") then 
      return (cooldown - caster:TG_GetTalentValue("special_bonus_imba_meepo_4"))
    end
  return cooldown
end
end

function imba_meepo_earthbind:OnSpellStart()
	local caster = self:GetCaster()
	local target_pos = self:GetCursorPosition()
	local pos = target_pos
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0
	local target = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 5}, pos, caster:GetTeamNumber(), false)
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_meepo/meepo_earthbind_projectile_fx.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(self.pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.pfx, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.pfx, 2, Vector(self:GetSpecialValueFor("speed"), 0, 0))
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = nil,
		iMoveSpeed = self:GetSpecialValueFor("speed"),
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 60,
		bProvidesVision = false,
		ExtraData = {pfx = self.pfx}
	}
	TG_CreateProjectile({id = 1, team = caster:GetTeamNumber(), owner = caster,	p = info})
	caster:EmitSound("Hero_Meepo.Earthbind.Cast")
end

function imba_meepo_earthbind:OnProjectileThink_ExtraData(pos, keys)
	local caster = self:GetCaster()
	AddFOWViewer(self:GetCaster():GetTeamNumber(), pos, self:GetSpecialValueFor("radius"), FrameTime(), false)
end

function imba_meepo_earthbind:OnProjectileHit_ExtraData(target, pos, keys)
	local caster = self:GetCaster()
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	AddFOWViewer(caster:GetTeamNumber(), pos, self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("duration"), false)
	local truesight = CreateUnitByName("npc_dummy_unit", pos, false, caster, caster, caster:GetTeamNumber())
	TG_AddNewModifier_RS(truesight, caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("truesight_duration")})
	TG_AddNewModifier_RS(truesight, caster, self, "modifier_item_gem_of_true_sight", {duration = self:GetSpecialValueFor("truesight_duration")})
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i=1, #enemy do
		TG_AddNewModifier_RS(enemy[i], caster, self, "modifier_imba_meepo_earthbind_root", {duration = self:GetSpecialValueFor("duration")})
		ApplyDamage({attacker = caster, victim = enemy[i], damage = self:GetSpecialValueFor("damage"), ability = self, damage_type = self:GetAbilityDamageType()})
	end
end


modifier_imba_meepo_earthbind_self = class({})
function modifier_imba_meepo_earthbind_self:IsDebuff()			return false end
function modifier_imba_meepo_earthbind_self:IsHidden() 			return true end
function modifier_imba_meepo_earthbind_self:IsPurgable() 		return false end
function modifier_imba_meepo_earthbind_self:IsPurgeException() 	return false end
function modifier_imba_meepo_earthbind_self:DeclareFunctions() 
	return {
	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	} 
end
function modifier_imba_meepo_earthbind_self:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() or keys.ability:GetAbilityName() ~= "imba_meepo_earthbind" then 
		return 
	end	
	local cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
	for i = 0, 12 do
		local current_ability = self:GetParent():GetItemInSlot(i)
		if current_ability then
			local cooldown_remaining = current_ability:GetCooldownTimeRemaining()
			current_ability:EndCooldown()
			if cooldown_remaining > cooldown_reduction then
				current_ability:StartCooldown( cooldown_remaining - cooldown_reduction )
			end
		end
	end
end




modifier_imba_meepo_earthbind_root = class({})

function modifier_imba_meepo_earthbind_root:IsDebuff()			return true end
function modifier_imba_meepo_earthbind_root:IsHidden() 			return false end
function modifier_imba_meepo_earthbind_root:IsPurgable() 		return true end
function modifier_imba_meepo_earthbind_root:IsPurgeException() 	return true end
function modifier_imba_meepo_earthbind_root:CheckState() 
	return {
	[MODIFIER_STATE_ROOTED] = self.root,  --被缠绕
	} 
end

function modifier_imba_meepo_earthbind_root:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		self.root 		= 	true
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_meepo/meepo_earthbind.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetParent(), PATTACH_ABSORIGIN, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.pfx, 60, Vector(math.random(1,100), math.random(1,100), math.random(1,100)))
		ParticleManager:SetParticleControl(self.pfx, 61, Vector(math.random(1,100), math.random(1,100), math.random(1,100)))
		self:AddParticle(self.pfx, false, false, 15, false, false)			
	end
end
function modifier_imba_meepo_earthbind_root:OnDestroy(params)
  if not IsServer() then return end
	  ParticleManager:DestroyParticle(self.pfx, false)
	  ParticleManager:ReleaseParticleIndex(self.pfx)   
end 
imba_meepo_Poof = class({})

LinkLuaModifier("modifier_imba_meepo_Poof_self", "linken/hero_meepo.lua", LUA_MODIFIER_MOTION_NONE)

function imba_meepo_Poof:IsHiddenWhenStolen() 		return false end
function imba_meepo_Poof:IsRefreshable() 			return true end
function imba_meepo_Poof:IsStealable() 			return true end
function imba_meepo_Poof:GetCooldown(level)
	if IsServer() then 
  local cooldown = self.BaseClass.GetCooldown(self, level)
  local caster = self:GetCaster()
    if caster:TG_HasTalent("special_bonus_imba_meepo_1") then 
      return (cooldown - caster:TG_GetTalentValue("special_bonus_imba_meepo_1"))
    end
  return cooldown
end
end
function imba_meepo_Poof:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	self.damage = self:GetSpecialValueFor("damage")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_meepo_2")
	self.range = self:GetSpecialValueFor("range")
	local clone = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		pos, 
		nil, 
		30000, 
		DOTA_UNIT_TARGET_TEAM_BOTH, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST, 
		false
		)
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		local damageTable = {
							victim = enemy,
							attacker = self:GetCaster(),
							damage = self.damage,
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}								
		ApplyDamage(damageTable)
	end	
	for i=1, #clone do
		if clone[i]:GetName() == "npc_dota_hero_meepo" or clone[i]:HasModifier("modifier_imba_meepo_earthbind_root") then
			next_pos = clone[i]:GetAbsOrigin()
			FindClearSpaceForUnit(caster, next_pos, false)
			caster:MoveToPositionAggressive(pos)
			caster:EmitSound("Hero_Meepo.Poof.End00")
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_meepo/meepo_poof_end.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl(pfx, 0, self:GetCaster():GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, self:GetCaster():GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 2, self:GetCaster():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				local damageTable = {
									victim = enemy,
									attacker = self:GetCaster(),
									damage = self.damage,
									damage_type = self:GetAbilityDamageType(),
									damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
									ability = self, --Optional.
									}								
				ApplyDamage(damageTable)
			end							
			break
		end
	end
end
function imba_meepo_Poof:GetIntrinsicModifierName() return "modifier_imba_meepo_Poof_self" end

modifier_imba_meepo_Poof_self = class({})

function modifier_imba_meepo_Poof_self:IsDebuff()			return false end
function modifier_imba_meepo_Poof_self:IsHidden() 			return true end
function modifier_imba_meepo_Poof_self:IsPurgable() 		return false end
function modifier_imba_meepo_Poof_self:IsPurgeException() 	return false end
function modifier_imba_meepo_Poof_self:DeclareFunctions() 
	local funcs = {
					MODIFIER_EVENT_ON_ABILITY_START,
					MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
					}
	return funcs
end
function modifier_imba_meepo_Poof_self:OnAbilityStart(keys) 
	if not IsServer() then
		return
	end	
	if keys.ability:GetAbilityName() == "imba_meepo_Poof" and keys.unit == self:GetCaster() then
		EmitSoundOn("Hero_Meepo.Poof.Channel", self:GetCaster())
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_meepo/meepo_poof_start.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 2, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)
	end 
	if self:GetParent():TG_HasTalent("special_bonus_imba_meepo_5") then 
      self:GetAbility():SetOverrideCastPoint(self:GetParent():TG_GetTalentValue("special_bonus_imba_meepo_5"))
    end	
end	
function modifier_imba_meepo_Poof_self:OnAbilityFullyCast(keys)
	local pan = keys.ability:GetAbilityName() == "imba_meepo_Poof"
	if IsServer() then	
		if not keys.unit == self:GetParent() then
			return
		end
		if keys.ability:IsItem() then
			return
		end
		if not keys.ability:GetAbilityName() == "imba_meepo_Poof" then
			return
		end	
		local cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
		for i = 0, 23 do
			local current_ability = self:GetParent():GetAbilityByIndex(i)
			if current_ability then
				local cooldown_remaining = current_ability:GetCooldownTimeRemaining()
				current_ability:EndCooldown()
				if cooldown_remaining > cooldown_reduction then
					current_ability:StartCooldown( cooldown_remaining - cooldown_reduction )
				end
			end
		end
	end	
end

imba_meepo_ransack = class({})

LinkLuaModifier("modifier_imba_meepo_ransack_self", "linken/hero_meepo.lua", LUA_MODIFIER_MOTION_NONE)

function imba_meepo_ransack:IsHiddenWhenStolen() 		return false end
function imba_meepo_ransack:IsRefreshable() 			return true end
function imba_meepo_ransack:IsStealable() 			return true end
function imba_meepo_ransack:GetIntrinsicModifierName() return "modifier_imba_meepo_ransack_self" end
function imba_meepo_ransack:OnSpellStart()
	local caster = self:GetCaster()
	local clone = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		caster:GetAbsOrigin(), 
		nil, 
		30000, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST, 
		false
		)
	for i=1, #clone do
		if clone[i]:GetName() == "npc_dota_hero_meepo" then
		local pfx = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/ti9_immortal_staff/cm_ti9_golden_staff_lvlup_globe.vpcf", PATTACH_POINT_FOLLOW, clone[i])
		ParticleManager:SetParticleControlEnt(pfx, 0, clone[i], PATTACH_POINT_FOLLOW, "attach_hitloc", clone[i]:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 5, Vector(1,1,1))
		ParticleManager:ReleaseParticleIndex(pfx)			
		clone[i]:Purge(false, true, false, true, false)
		end	
	end	
end
modifier_imba_meepo_ransack_self = class({})

function modifier_imba_meepo_ransack_self:IsDebuff()			return false end
function modifier_imba_meepo_ransack_self:IsHidden() 			return true end
function modifier_imba_meepo_ransack_self:IsPurgable() 		return false end
function modifier_imba_meepo_ransack_self:IsPurgeException() 	return false end
function modifier_imba_meepo_ransack_self:DeclareFunctions() 
	local funcs = {
					MODIFIER_EVENT_ON_ATTACK_LANDED,
					}
	return funcs
end

function modifier_imba_meepo_ransack_self:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() or not keys.target:IsAlive() or keys.target:IsBoss() then
		return
	end
	EmitSoundOn("Hero_Meepo.Ransack.Target", keys.target)
	local damage = self:GetParent():GetAgility() * (self:GetAbility():GetSpecialValueFor("agility")+self:GetParent():TG_GetTalentValue("special_bonus_imba_meepo_3"))
	local clone = FindUnitsInRadius(
		keys.attacker:GetTeamNumber(), 
		keys.attacker:GetAbsOrigin(), 
		nil, 
		30000, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST, 
		false
		)
	for i=1, #clone do
		if clone[i]:GetName() == "npc_dota_hero_meepo" then
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_meepo/meepo_ransack.vpcf", PATTACH_CUSTOMORIGIN, clone[i])
			ParticleManager:SetParticleControl(pfx, 0, clone[i]:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)			
			clone[i]:Heal(damage, keys.attacker)
		end	
	end			
	local damageTable = {
						victim = keys.target,
						attacker = keys.attacker,
						damage = damage,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, 
						ability = self:GetAbility(), 
						}								
	ApplyDamage(damageTable)			
end
	
			 

