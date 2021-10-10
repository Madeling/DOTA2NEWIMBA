CreateTalents("npc_dota_hero_nevermore", "mb/hero_nevermore")
imba_nevermore_shadowraze = class({})

function imba_nevermore_shadowraze:IsHiddenWhenStolen() 	return false end
function imba_nevermore_shadowraze:IsRefreshable() 			return true end
function imba_nevermore_shadowraze:IsStealable() 			return true end
function imba_nevermore_shadowraze:GetCooldown(i) return self:GetSpecialValueFor("charge_time") end
function imba_nevermore_shadowraze:GetCastRange() return self:GetSpecialValueFor("length") end
function imba_nevermore_shadowraze:OnUpgrade()
	if not AbilityChargeController:IsChargeTypeAbility(self) then
		AbilityChargeController:AbilityChargeInitialize(self, self:GetSpecialValueFor("charge_time"), self:GetSpecialValueFor("max_charges"), 1, true, true)
	else
		AbilityChargeController:ChangeChargeAbilityConfig(self, self:GetSpecialValueFor("charge_time"), self:GetSpecialValueFor("max_charges"), 1, true, true)
	end
end

function imba_nevermore_shadowraze:OnSpellStart()
	local caster = self:GetCaster()
	local direction = caster:GetForwardVector():Normalized()
	local length = self:GetSpecialValueFor("length") + caster:GetCastRangeBonus()
	local pfx_number = math.floor(length / self:GetSpecialValueFor("radius")) + 1
	local pfx_name = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"
	local sound_name = "Hero_Nevermore.Shadowraze"
	--if HeroItems:UnitHasItem(caster, "shadow_fiend/head_arcana") then
		pfx_name = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf"
		sound_name = "Hero_Nevermore.Shadowraze.Arcana"
	--end
	for i=1, pfx_number do
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		local pos = GetGroundPosition(caster:GetAbsOrigin() + direction * ((i - 1) * self:GetSpecialValueFor("radius")), nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
	local enemies = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster:GetAbsOrigin() + direction * length, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
	for _, enemy in pairs(enemies) do
		local buff = enemy:AddNewModifier(caster, self, "modifier_imba_shadowraze_combo", {duration = self:GetSpecialValueFor("combo_modifier_duration")})
		buff:SetStackCount(buff:GetStackCount() + 1)
		local dmg = self:GetSpecialValueFor("raze_damage") + math.min(enemy:GetModifierStackCount("modifier_imba_shadowraze_combo", caster) - 1, 0) * self:GetSpecialValueFor("combo_dmg_bonus")
		local damageTable = {
							victim = enemy,
							attacker = caster,
							damage = dmg,
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}
		ApplyDamage(damageTable)
	end
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_name, caster)
end

--add by MysterBug 06 21
----------------------------------------------
imba_nevermore_shadowraze1 = class({})

LinkLuaModifier("modifier_imba_shadowraze_combo", "mb/hero_nevermore", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadowraze_point_combo", "mb/hero_nevermore", LUA_MODIFIER_MOTION_NONE)

function imba_nevermore_shadowraze1:IsHiddenWhenStolen() 	return false end
function imba_nevermore_shadowraze1:IsRefreshable() 			return true end
function imba_nevermore_shadowraze1:IsStealable() 			return true end
function imba_nevermore_shadowraze1:GetCooldown(i) return self:GetSpecialValueFor("charge_time") end
function imba_nevermore_shadowraze1:GetCastRange() return self:GetSpecialValueFor("length") end
function imba_nevermore_shadowraze1:GetCastPoint()
	--魔王之力减少100%施法前摇
	if self:GetCaster():HasModifier("modifier_imba_nevermore_necromastery_caster") then 
		return 0
	end
	return self.BaseClass.GetCastPoint(self)
end
function imba_nevermore_shadowraze1:OnUpgrade()
	local caster = self:GetCaster()
	local shadowraze2 = caster:FindAbilityByName("imba_nevermore_shadowraze2")
	local shadowraze3 = caster:FindAbilityByName("imba_nevermore_shadowraze3")
	if shadowraze2 then 
		shadowraze2:SetLevel(self:GetLevel())
	end
	if shadowraze3 then 
		shadowraze3:SetLevel(self:GetLevel())
	end
end
--[[function imba_nevermore_shadowraze1:OnToggle()
	print("toggle nevermore switch +++")
	if self:GetAutoCastState() then
		local shadowraze2 = caster:FindAbilityByName("imba_nevermore_shadowraze2")
		local shadowraze3 = caster:FindAbilityByName("imba_nevermore_shadowraze3")
		if shadowraze2 then 
			if not shadowraze2:GetAutoCastState() then 
				shadowraze2:ToggleAutoCast()
			end
		end
		if shadowraze3 then 
			if not shadowraze3:GetAutoCastState() then 
				shadowraze3:ToggleAutoCast()
			end
		end
	else
		local shadowraze2 = caster:FindAbilityByName("imba_nevermore_shadowraze2")
		local shadowraze3 = caster:FindAbilityByName("imba_nevermore_shadowraze3")
		if shadowraze2 then 
			if shadowraze2:GetAutoCastState() then 
				shadowraze2:ToggleAutoCast()
			end
		end
		if shadowraze3 then 
			if shadowraze3:GetAutoCastState() then 
				shadowraze3:ToggleAutoCast()
			end
		end
	end
end]]
function imba_nevermore_shadowraze1:OnSpellStart()
	local caster = self:GetCaster()
	if self:GetAutoCastState() then
		--imba cast
		CastLinesShadoWraze(caster,self)
	else
		--classic ZXC cast
		CastPointsShadoWraze(caster,self)	
	end
end

modifier_imba_shadowraze_combo = class({})

function modifier_imba_shadowraze_combo:IsDebuff()			return true end
function modifier_imba_shadowraze_combo:IsHidden() 			return false end
function modifier_imba_shadowraze_combo:IsPurgable() 		return false end
function modifier_imba_shadowraze_combo:IsPurgeException() 	return false end

modifier_imba_shadowraze_point_combo = class({})

function modifier_imba_shadowraze_point_combo:IsDebuff()			return true end
function modifier_imba_shadowraze_point_combo:IsHidden() 			return false end
function modifier_imba_shadowraze_point_combo:IsPurgable() 			return false end
function modifier_imba_shadowraze_point_combo:IsPurgeException() 	return false end
function modifier_imba_shadowraze_point_combo:OnCreated(keys)
	if IsServer() then
		self.combo_tables = {}
		self.combo_type = keys.combo_type
		table.insert(self.combo_tables,self.combo_type)
		self.pfx_name_tables = {
			"particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze_ovr.vpcf",
			"particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze_double.vpcf",
			"particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze_triple.vpcf"
		}
		local pfx = ParticleManager:CreateParticle(self.pfx_name_tables[1], PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(pfx)
		ParticleManager:DestroyParticle(pfx, false)
		--print("OnCreated---",self.combo_type)
	end
end
function modifier_imba_shadowraze_point_combo:OnRefresh( keys)
	if not IsServer() then return end
	self.combo_type = keys.combo_type
	--print("OnRefresh+++",self.combo_type)
	if not IsInTable(self.combo_type,self.combo_tables) then
		--入列 
		table.insert(self.combo_tables,self.combo_type)
		--pfx
		local pfx = ParticleManager:CreateParticle(self.pfx_name_tables[#self.combo_tables], PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(pfx)
		ParticleManager:DestroyParticle(pfx, false)
		if #self.combo_tables >= 3 then 
			--Talent samll RequiemOfSouls
			if self:GetCaster():TG_HasTalent("special_bonus_imba_nevermore_4") then 
				local requiem_abi = self:GetCaster():FindAbilityByName("imba_nevermore_requiem")
				if requiem_abi and requiem_abi:GetLevel() > 0 then
					--print("boom raze pos",self:GetParent():GetAbsOrigin())
					requiem_abi:OnSpellStart(true,self:GetParent():GetAbsOrigin())
				end
			end
			--boom 
			CastCombsShadoWraze(self:GetCaster(),self:GetAbility(),self:GetParent():GetAbsOrigin())
			self:Destroy()
		end
	end
end
function modifier_imba_shadowraze_point_combo:OnDestroy()
	self.combo_tables = {}
end

--add by MysterBug ZXC 
imba_nevermore_shadowraze2 = class({})

function imba_nevermore_shadowraze2:IsHiddenWhenStolen() 	return false end
function imba_nevermore_shadowraze2:IsRefreshable() 			return true end
function imba_nevermore_shadowraze2:IsStealable() 			return true end
function imba_nevermore_shadowraze2:GetCooldown(i) return self:GetSpecialValueFor("charge_time") end
function imba_nevermore_shadowraze2:GetCastRange() return self:GetSpecialValueFor("length") end
function imba_nevermore_shadowraze2:GetCastPoint()
	--魔王之力减少100%施法前摇
	if self:GetCaster():HasModifier("modifier_imba_nevermore_necromastery_caster") then 
		return 0
	end
	return self.BaseClass.GetCastPoint(self)
end
function imba_nevermore_shadowraze2:OnSpellStart()
	local caster = self:GetCaster()
	if self:GetAutoCastState() then
		--imba cast
		CastLinesShadoWraze(caster,self)
	else
		--classic ZXC cast
		CastPointsShadoWraze(caster,self)	
	end
end

imba_nevermore_shadowraze3 = class({})

function imba_nevermore_shadowraze3:IsHiddenWhenStolen() 	return false end
function imba_nevermore_shadowraze3:IsRefreshable() 			return true end
function imba_nevermore_shadowraze3:IsStealable() 			return true end
function imba_nevermore_shadowraze3:GetCooldown(i) return self:GetSpecialValueFor("charge_time") end
function imba_nevermore_shadowraze3:GetCastRange() return self:GetSpecialValueFor("length") end
function imba_nevermore_shadowraze3:GetCastPoint()
	--魔王之力减少100%施法前摇
	if self:GetCaster():HasModifier("modifier_imba_nevermore_necromastery_caster") then 
		return 0
	end
	return self.BaseClass.GetCastPoint(self)
end
function imba_nevermore_shadowraze3:OnSpellStart()
	local caster = self:GetCaster()
	if self:GetAutoCastState() then
		--imba cast
		CastLinesShadoWraze(caster,self)
	else
		--classic ZXC cast
		CastPointsShadoWraze(caster,self)	
	end
end

function CastLinesShadoWraze(caster, ability)
	local nevermore_response = {"nevermore_nev_ability_shadow_11", "nevermore_nev_ability_shadow_19", "nevermore_nev_ability_shadow_23"}
	local direction = caster:GetForwardVector():Normalized()
	local length = ability:GetSpecialValueFor("autocast_length") + caster:GetCastRangeBonus()
	local pfx_radius = ability:GetSpecialValueFor("radius") + caster:TG_GetTalentValue("special_bonus_imba_nevermore_3")
	local pfx_number = math.floor(length / ability:GetSpecialValueFor("radius")) + 1
	local pfx_name = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"
	local sound_name = "Hero_Nevermore.Shadowraze"
	--if HeroItems:UnitHasItem(caster, "shadow_fiend/head_arcana") then
		pfx_name = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf"
		sound_name = "Hero_Nevermore.Shadowraze.Arcana"
	--end
	for i=1, pfx_number do
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		local pos = GetGroundPosition(caster:GetAbsOrigin() + direction * ((i - 1) * ability:GetSpecialValueFor("radius")), nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:SetParticleControl(pfx, 3, Vector(pfx_radius, 1, 1))
		ParticleManager:ReleaseParticleIndex(pfx)
	end
	local enemies = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster:GetAbsOrigin() + direction * length, nil, pfx_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
	for _, enemy in pairs(enemies) do
		local buff = enemy:AddNewModifier(caster, ability, "modifier_imba_shadowraze_combo", {duration = ability:GetSpecialValueFor("combo_modifier_duration")})
		buff:SetStackCount(buff:GetStackCount() + 1)
		local dmg = ability:GetSpecialValueFor("raze_damage") + math.min(enemy:GetModifierStackCount("modifier_imba_shadowraze_combo", caster) - 1, 1) * ability:GetSpecialValueFor("combo_dmg_bonus")
		--print("lines combo damage ---",dmg)
		ApplyDamage(
			{
				victim = enemy,
				attacker = caster,
				damage = dmg,
				damage_type = ability:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = ability, --Optional.
			}
		)
	end
	EmitSoundOn(nevermore_response[math.random(1, #nevermore_response)], caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_name, caster)
end

function CastPointsShadoWraze(caster,ability,lord_pos)
	local nevermore_response = {"nevermore_nev_ability_shadow_11", "nevermore_nev_ability_shadow_19", "nevermore_nev_ability_shadow_23"}
 	local direction = caster:GetForwardVector():Normalized()
	local length = ability:GetSpecialValueFor("length")
	local pfx_radius = ability:GetSpecialValueFor("radius") + caster:TG_GetTalentValue("special_bonus_imba_nevermore_3")
	local pfx_name = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"
	local sound_name = "Hero_Nevermore.Shadowraze"
	--if HeroItems:UnitHasItem(caster, "shadow_fiend/head_arcana") then
		pfx_name = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf"
		sound_name = "Hero_Nevermore.Shadowraze.Arcana"
	--end
	--特效
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	local pos = caster:GetAbsOrigin() + caster:GetForwardVector() * length
	--魔王之力充能
	if lord_pos then
		pos = lord_pos
	end
	ParticleManager:SetParticleControl(pfx, 0, pos)
	ParticleManager:SetParticleControl(pfx, 3, Vector(pfx_radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(pfx)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, pfx_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false)
	local hero_hit = false
	for _, enemy in pairs(enemies) do
		local buff = enemy:AddNewModifier(caster, ability, "modifier_imba_shadowraze_combo", {duration = ability:GetSpecialValueFor("combo_modifier_duration")})
		local buff_point = enemy:AddNewModifier(caster, ability, "modifier_imba_shadowraze_point_combo", {duration = ability:GetSpecialValueFor("combo_modifier_duration") , combo_type = ability:GetAbilityName()})
		if buff then 
			buff:SetStackCount(buff:GetStackCount() + 1)
		end
		if buff_point then 
			buff_point:SetStackCount(buff_point:GetStackCount() + 1)
		end
		local dmg = ability:GetSpecialValueFor("raze_damage") + math.min(enemy:GetModifierStackCount("modifier_imba_shadowraze_combo", caster) - 1, 1) * ability:GetSpecialValueFor("combo_dmg_bonus")
		--print("point combo damage ---",dmg)
		ApplyDamage(
			{
				victim = enemy,
				attacker = caster,
				damage = dmg,
				damage_type = ability:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = ability, --Optional.
			}
		)
		if enemy:IsHero() then
			hero_hit = true
		end
	end
	--音效
	EmitSoundOn(nevermore_response[math.random(1, #nevermore_response)], caster)
	EmitSoundOn(sound_name, caster)
	--降低毁灭阴影冷却
	if hero_hit == true then 
		for i = 0, 2 do
			local current_ability = caster:GetAbilityByIndex(i)
			if current_ability and current_ability ~= ability and not current_ability:IsCooldownReady() and not IsRefreshableByAbility(current_ability:GetName()) and not current_ability:GetAutoCastState() then
				current_ability_cd = current_ability:GetCooldownTimeRemaining()
				current_ability:EndCooldown()
				local final_cd = current_ability_cd - ability:GetSpecialValueFor("hit_time")
				if current_ability_cd > ability:GetSpecialValueFor("hit_time") then
					current_ability:StartCooldown(final_cd)
				else
					--print("ability cd",final_cd)
				    current_ability:StartCooldown(current_ability_cd)
				end
			end
		end
	end
end 
--autocast nothing 
--imba shadowraze boom
function CastCombsShadoWraze(caster,ability,pos)
	local nevermore_response = {"nevermore_nev_ability_shadow_11", "nevermore_nev_ability_shadow_19", "nevermore_nev_ability_shadow_23"}
	local length = ability:GetSpecialValueFor("length")
	local pfx_radius = ability:GetSpecialValueFor("radius") + caster:TG_GetTalentValue("special_bonus_imba_nevermore_3")
	local pfx_name = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"
	local sound_name = "Hero_Nevermore.Shadowraze"
	--if HeroItems:UnitHasItem(caster, "shadow_fiend/head_arcana") then
		pfx_name = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf"
		sound_name = "Hero_Nevermore.Shadowraze.Arcana"
	--end
	--center boom
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, pos)
	ParticleManager:SetParticleControl(pfx, 3, Vector(pfx_radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(pfx)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, pfx_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false)
	for _, enemy in pairs(enemies) do
		--only refresh combs duration
		enemy:AddNewModifier(caster, ability, "modifier_imba_shadowraze_combo", {duration = ability:GetSpecialValueFor("combo_modifier_duration")})
		local dmg = ability:GetSpecialValueFor("raze_damage") + math.min(enemy:GetModifierStackCount("modifier_imba_shadowraze_combo", caster) - 1, 1) * ability:GetSpecialValueFor("combo_dmg_bonus")
		ApplyDamage(
			{
				victim = enemy,
				attacker = caster,
				damage = dmg,
				damage_type = ability:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = ability, --Optional.
			}
		)
	end
	local end_pos = pos + pos:Normalized() * length
	local boom_count = math.floor(length / 50)
	for i=1, boom_count do
		local boom_pos = GetGroundPosition(RotatePosition(pos, QAngle(0, i * (360 / boom_count), 0), end_pos), nil)
		local boom_pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(boom_pfx, 0, boom_pos)
		ParticleManager:SetParticleControl(boom_pfx, 3, Vector(pfx_radius, 1, 1))
		ParticleManager:ReleaseParticleIndex(boom_pfx)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), boom_pos, nil, pfx_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false)
		for _, enemy in pairs(enemies) do
			--only refresh combs duration
			enemy:AddNewModifier(caster, ability, "modifier_imba_shadowraze_combo", {duration = ability:GetSpecialValueFor("combo_modifier_duration")})
			local dmg = ability:GetSpecialValueFor("raze_damage") + math.min(enemy:GetModifierStackCount("modifier_imba_shadowraze_combo", caster) - 1, 1) * ability:GetSpecialValueFor("combo_dmg_bonus")
			ApplyDamage(
				{
				victim = enemy,
				attacker = caster,
				damage = dmg / 2,
				damage_type = ability:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = ability, --Optional.
				}
			)
		end
	end
	--音效
	EmitSoundOn(nevermore_response[math.random(1, #nevermore_response)], caster)
	EmitSoundOn(sound_name, caster)	
end

imba_nevermore_necromastery = class({})

LinkLuaModifier("modifier_imba_necromastery_counter", "mb/hero_nevermore", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_imba_necromastery_perm", "mb/hero_nevermore", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_necromastery_temp", "mb/hero_nevermore", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_nevermore_necromastery_caster", "mb/hero_nevermore", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_nevermore_necromastery_charge", "mb/hero_nevermore", LUA_MODIFIER_MOTION_NONE)

function imba_nevermore_necromastery:GetIntrinsicModifierName() return "modifier_imba_necromastery_counter" end
--add by MysterBug
function imba_nevermore_necromastery:GetBehavior()
	if self:GetCaster():Has_Aghanims_Shard() then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
end
function imba_nevermore_necromastery:OnSpellStart()
	local caster = self:GetCaster()
	local nevermore_response = {"nevermore_nev_arc_laugh_01", "nevermore_nev_arc_laugh_02", "nevermore_nev_arc_laugh_03"}
	--全部灵魂数量
	local souls_counter = caster:GetModifierStackCount("modifier_imba_necromastery_counter", caster)
	--消耗所有临时灵魂
	if not caster:HasScepter() then 
		local temp = caster:FindAllModifiersByName("modifier_imba_necromastery_temp")
		for _, buff in pairs(temp) do
			buff:Destroy()
		end
	end
	EmitSoundOn(nevermore_response[math.random(1, #nevermore_response)], caster)
	--魔王之力
	caster:AddNewModifier(caster, self, "modifier_imba_nevermore_necromastery_caster", {duration = self:GetSpecialValueFor("lord_power_duration") + souls_counter*0.1})
end

function imba_nevermore_necromastery:CreateSoulPfx(caster, target)
	local info = 
	{
		Target = caster,
		Source = target,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_nevermore/nevermore_souls.vpcf",
		iMoveSpeed = self:GetSpecialValueFor("soul_projectile_speed"),
		vSourceLoc = target:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

------------------------------------------------------------------
--魔王之力 攻击间隔 攻击距离 施法无前摇
modifier_imba_nevermore_necromastery_caster = class({})
function modifier_imba_nevermore_necromastery_caster:IsDebuff()			return false end
function modifier_imba_nevermore_necromastery_caster:IsHidden() 			return false end
function modifier_imba_nevermore_necromastery_caster:IsPurgable() 		return false end
function modifier_imba_nevermore_necromastery_caster:IsPurgeException() 	return false end
function modifier_imba_nevermore_necromastery_caster:DeclareFunctions() return {MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_nevermore_necromastery_caster:GetModifierBaseAttackTimeConstant() return self:GetAbility():GetSpecialValueFor("attack_time") end
function modifier_imba_nevermore_necromastery_caster:GetModifierAttackRangeBonus() return self:GetAbility():GetSpecialValueFor("attack_range") end
--function modifier_imba_nevermore_necromastery_caster:GetModifierPercentageCasttime() return self:GetAbility():GetSpecialValueFor("cast_time_pct") end
function modifier_imba_nevermore_necromastery_caster:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or keys.target:GetTeamNumber() == self:GetParent():GetTeamNumber() or not keys.target:IsHero() or not keys.target:IsAlive() or self:GetParent():IsIllusion() then
		return 
	end
	--
	local buff = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_nevermore_necromastery_charge", {})
	--imba 攻击次数监测
	if buff:GetStackCount() >= self:GetAbility():GetSpecialValueFor("attack_count") then
		--造成随机爆炸影压
		local raze_abi = self:GetParent():FindAbilityByName("imba_nevermore_shadowraze"..RandomInt(1,3))
		if raze_abi then 
			CastPointsShadoWraze(self:GetParent(),raze_abi,keys.target:GetAbsOrigin())
		end
		self:GetParent():RemoveModifierByName("modifier_imba_nevermore_necromastery_charge") 
		buff:Destroy()
	else
		--增加计数
		buff:IncrementStackCount()
	end
end

--计数
modifier_imba_nevermore_necromastery_charge = class({})
function modifier_imba_nevermore_necromastery_charge:IsHidden()			return false end
function modifier_imba_nevermore_necromastery_charge:IsDebuff() 		return false end
function modifier_imba_nevermore_necromastery_charge:IsPurgable() 		return false end
function modifier_imba_nevermore_necromastery_charge:IsPurgeException()	return false end
------------------------------------------------------------------
modifier_imba_necromastery_counter = class({})

function modifier_imba_necromastery_counter:IsDebuff()			return false end
function modifier_imba_necromastery_counter:IsBuff()			return true end
function modifier_imba_necromastery_counter:IsHidden() 			return false end
function modifier_imba_necromastery_counter:IsPurgable() 		return false end
function modifier_imba_necromastery_counter:IsPurgeException() 	return false end
function modifier_imba_necromastery_counter:DestroyOnExpire()	return false end
function modifier_imba_necromastery_counter:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_TAKEDAMAGE, MODIFIER_EVENT_ON_DEATH} end
function modifier_imba_necromastery_counter:GetModifierPreAttack_BonusDamage() return (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("damage_per_soul")) end
function modifier_imba_necromastery_counter:OnCreated() 
	self.perm_counter = 0
end--record perm souls
function modifier_imba_necromastery_counter:SoulsUpdate()
	if self:GetAbility() == nil then return end	
	local max_souls = self:GetAbility():GetSpecialValueFor("max_souls")
	local max_temp_soul = self:GetAbility():GetSpecialValueFor("max_temp_soul")
	local buff = self:GetParent():FindModifierByName("modifier_imba_necromastery_temp")
	local temp_counter = 0
	if buff then temp_counter = buff:GetStackCount() end
	--perm + temp --> now stack 
	local souls = math.min(temp_counter + self.perm_counter, max_souls + max_temp_soul)
	self:SetStackCount(souls)
end
function modifier_imba_necromastery_counter:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or keys.target:GetTeamNumber() == self:GetParent():GetTeamNumber() or not keys.target:IsHero() or not keys.target:IsAlive() or self:GetParent():IsIllusion() then
		return 
	end
	--临时魂
	for i=1, self:GetAbility():GetSpecialValueFor("hero_attack_souls") + math.floor(self:GetParent():GetLevel() / self:GetAbility():GetSpecialValueFor("harvest_levels_per_soul")) do
		--self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_necromastery_temp", {duration = self:GetAbility():GetSpecialValueFor("temp_soul_duration")})
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_necromastery_temp", {duration = self:GetAbility():GetSpecialValueFor("temp_soul_duration")}):AddSouls()
	end
	--local dummy = CreateModifierThinker(self:GetParent(), nil, "modifier_dummy_thinker", {duration = 3.0}, keys.target:GetAbsOrigin(), self:GetParent():GetTeamNumber(), false)
	--self:GetAbility():CreateSoulPfx(self:GetParent(), keys.target)
end

function modifier_imba_necromastery_counter:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if not keys.inflictor or keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or keys.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() or 
		not keys.inflictor:GetName() == "imba_nevermore_shadowraze1" or 
		not keys.inflictor:GetName() == "imba_nevermore_shadowraze2" or 
		not keys.inflictor:GetName() == "imba_nevermore_shadowraze3" or 
		not keys.unit:IsHero() or 
		not self:GetParent():IsAlive() then --死亡造成伤害不加魂
		return 
	end	
	for i=1, self:GetAbility():GetSpecialValueFor("hero_attack_souls") + math.floor(self:GetParent():GetLevel() / self:GetAbility():GetSpecialValueFor("harvest_levels_per_soul")) do
		--self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_necromastery_temp", {duration = self:GetAbility():GetSpecialValueFor("temp_soul_duration")})
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_necromastery_temp", {duration = self:GetAbility():GetSpecialValueFor("temp_soul_duration")}):AddSouls()
	end
	--local dummy = CreateModifierThinker(self:GetParent(), nil, "modifier_dummy_thinker", {duration = 3.0}, keys.unit:GetAbsOrigin(), self:GetParent():GetTeamNumber(), false)
	--self:GetAbility():CreateSoulPfx(self:GetParent(), keys.unit)
end

function modifier_imba_necromastery_counter:OnDeath(keys)
	if not IsServer() or self:GetParent():IsIllusion() then
		return
	end
	-------------------------------------owner death
	if keys.unit == self:GetParent() then
		local temp = self:GetParent():FindModifierByName("modifier_imba_necromastery_temp")
		if temp then temp:Destroy() end
		--无神杖永久灵魂丢失一半 临时灵魂全丢失
		if not self:GetParent():HasScepter() then
			local lose = math.floor(self.perm_counter / 2)  
			if lose == 0 then return end
			for i=1,lose do
				self.perm_counter = math.max(self.perm_counter - 1,1) --最低保留一个魂吧
			end
		end
		--Update Souls
		self:SoulsUpdate()
		--Death requiem
		local ability = self:GetParent():FindAbilityByName("imba_nevermore_requiem")
		if ability and ability:GetLevel() > 0 and not self:GetParent():IsIllusion() then
			self:GetParent():SetCursorPosition(self:GetParent():GetAbsOrigin())
			ability:OnSpellStart()
		end
		return 
	end
	-------------------------------------kill 
	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or keys.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() or not self:GetParent():IsAlive() then
		return 
	end
	local souls = keys.unit:IsTrueHero() and self:GetAbility():GetSpecialValueFor("hero_kill_souls") or 1
	local max_soul = self:GetAbility():GetSpecialValueFor("max_souls")
	for i=1, souls do
		if self.perm_counter < max_soul then 
			self.perm_counter = self.perm_counter + 1
			self:IncrementStackCount()
		else
			--添加临时灵魂
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_necromastery_temp", {duration = self:GetAbility():GetSpecialValueFor("temp_soul_duration")}):AddSouls()
		end
	end
	--local dummy = CreateModifierThinker(self:GetParent(), nil, "modifier_dummy_thinker", {duration = 3.0}, keys.unit:GetAbsOrigin(), self:GetParent():GetTeamNumber(), false)
	--self:GetAbility():CreateSoulPfx(self:GetParent(), keys.unit)
end

--获取临时有持续时间的灵魂
modifier_imba_necromastery_temp = class({})
function modifier_imba_necromastery_temp:IsHidden() return true end
--function modifier_imba_necromastery_temp:RemoveOnDeath() return self:GetParent():IsIllusion() end
function modifier_imba_necromastery_temp:AllowIllusionDuplicate() return false end
function modifier_imba_necromastery_temp:IsPurgable() return false end
function modifier_imba_necromastery_temp:IsPurgeException() return false end
function modifier_imba_necromastery_temp:GetAttributes() return MODIFIER_ATTRIBUTE_NONE end
--------------------------------------------------------------------------------
-- Initializations
function modifier_imba_necromastery_temp:OnCreated()
	-- references
	if not IsServer() then return end
	
	self.stack_counter = {}
	
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_necromastery_temp:OnIntervalThink()
	Stack_RetATValue(self.stack_counter, function(i, j)
		return self.stack_counter[i].current_game_time and self.stack_counter[i].duration and GameRules:GetDOTATime(true, true) - self.stack_counter[i].current_game_time <= self.stack_counter[i].duration
	end)
	
	if #self.stack_counter ~= self:GetStackCount() then
		self:SetStackCount(#self.stack_counter)
		--Update Counter
		if self:GetParent():HasModifier("modifier_imba_necromastery_counter") then 
			self:GetParent():FindModifierByName("modifier_imba_necromastery_counter"):SoulsUpdate()
		end
	end
end

function modifier_imba_necromastery_temp:AddSouls()
	if IsServer() then 
		local duration = self:GetAbility():GetSpecialValueFor("temp_soul_duration")
		local max_temp_soul = self:GetAbility():GetSpecialValueFor("max_temp_soul")
		
		if self:GetStackCount() < max_temp_soul then
			-- record stack duration
			table.insert(self.stack_counter, {
				current_game_time	= GameRules:GetDOTATime(true, true),
				duration = duration
			})
			self:IncrementStackCount()
			--Update Counter
			if self:GetParent():HasModifier("modifier_imba_necromastery_counter") then 
				self:GetParent():FindModifierByName("modifier_imba_necromastery_counter"):SoulsUpdate()
			end
		end

		-- refresh buff duration and add stacks
		self:SetDuration(duration, true)
	end
end

function modifier_imba_necromastery_temp:RemoveSouls()
	if IsServer() then 
		self:DecrementStackCount()
		if self:GetStackCount() <= 0 then 
			self:Destroy()
		end
	end
end

imba_nevermore_dark_lord = class({})

LinkLuaModifier("modifier_imba_dark_lord_aura", "mb/hero_nevermore", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dark_lord_debuff", "mb/hero_nevermore", LUA_MODIFIER_MOTION_NONE)

function imba_nevermore_dark_lord:GetCastRange() return self:GetSpecialValueFor("radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_nevermore_2") - self:GetCaster():GetCastRangeBonus() end
function imba_nevermore_dark_lord:GetIntrinsicModifierName() return "modifier_imba_dark_lord_aura" end

modifier_imba_dark_lord_aura = class({})

function modifier_imba_dark_lord_aura:IsDebuff()			return false end
function modifier_imba_dark_lord_aura:IsHidden() 			return true end
function modifier_imba_dark_lord_aura:IsPurgable() 			return false end
function modifier_imba_dark_lord_aura:IsPurgeException() 	return false end
function modifier_imba_dark_lord_aura:IsAura() return true end
function modifier_imba_dark_lord_aura:GetAuraDuration() return 0.5 end
function modifier_imba_dark_lord_aura:GetModifierAura() return "modifier_imba_dark_lord_debuff" end
function modifier_imba_dark_lord_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_nevermore_2") end
function modifier_imba_dark_lord_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_dark_lord_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_dark_lord_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_imba_dark_lord_debuff = class({})

function modifier_imba_dark_lord_debuff:IsDebuff()			return true end
function modifier_imba_dark_lord_debuff:IsHidden() 			return true end
function modifier_imba_dark_lord_debuff:IsPurgable() 		return false end
function modifier_imba_dark_lord_debuff:IsPurgeException() 	return false end

function modifier_imba_dark_lord_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_dark_lord_debuff:GetModifierPhysicalArmorBonus()
	if self:GetCaster():PassivesDisabled() then
		return nil
	end
	if not IsServer() or self:GetAbility() == nil then
		return nil
	else
		return (0 - self:GetAbility():GetSpecialValueFor("armor_reduction"))
	end
end

--[[function modifier_imba_dark_lord_debuff:OnCreated()
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("soul_tick_time"))
	end
end]]

--[[function modifier_imba_dark_lord_debuff:OnIntervalThink()
	local ability = self:GetCaster():FindAbilityByName("imba_nevermore_necromastery")
	if ability and ability:GetLevel() > 0 and self:GetParent():IsHero() and not self:GetCaster():PassivesDisabled() and self:GetCaster():IsAlive() then
		--for i=1, self:GetAbility():GetSpecialValueFor("souls_per_tick") do
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_imba_necromastery_temp", {duration = ability:GetSpecialValueFor("temp_soul_duration")}):AddSouls()
		--end
	end
end]]
--DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
imba_nevermore_requiem = class({})

LinkLuaModifier("modifier_imba_requiem_enemy_debuff", "mb/hero_nevermore", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_requiem_caster_scepter", "mb/hero_nevermore", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_requiem_thinker", "mb/hero_nevermore", LUA_MODIFIER_MOTION_NONE)

function imba_nevermore_requiem:IsHiddenWhenStolen() 	return false end
function imba_nevermore_requiem:IsRefreshable() 		return true end
function imba_nevermore_requiem:IsStealable() 			return true end
function imba_nevermore_requiem:GetAOERadius() return self:GetSpecialValueFor("radius") end
function imba_nevermore_requiem:GetCastRange()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("radius")
	else
		return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
	end
end

function imba_nevermore_requiem:GetBehavior()
	if not self:GetCaster():TG_HasTalent("special_bonus_imba_nevermore_1") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET 
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end
end

function imba_nevermore_requiem:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local cast_pos = caster:GetAbsOrigin()
	if not self:GetCursorTargetingNothing() then
		cast_pos = self:GetCursorPosition()
	end
	self.fx = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_requiem_thinker", {duration = 10.0}, cast_pos, caster:GetTeamNumber(), false)
	local sound_name = "Hero_Nevermore.RequiemOfSoulsCast"
	local pfx_name_2 = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf"
	local pfx_name_3 = "particles/units/heroes/hero_nevermore/nevermore_wings.vpcf"
	--if HeroItems:UnitHasItem(caster, "shadow_fiend/head_arcana") then
		pfx_name_2 = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_requiemofsouls.vpcf"
		pfx_name_3 = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_wings.vpcf"
		sound_name = "Hero_Nevermore.ROS.Arcana.Cast"
	--end
	self.fx:EmitSound(sound_name)
	local pfx = ParticleManager:CreateParticle(pfx_name_2, PATTACH_ABSORIGIN_FOLLOW, self.fx)
	ParticleManager:SetParticleControl(pfx, 1, self.fx:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)
	local pfx_wings = ParticleManager:CreateParticle(pfx_name_3, PATTACH_POINT_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(pfx_wings)
	return true
end

function imba_nevermore_requiem:OnAbilityPhaseInterrupted()
	StopSoundOn("Hero_Nevermore.RequiemOfSoulsCast", self.fx)
	self.fx:ForceKill(false)
	self.fx = nil
	return true
end

function imba_nevermore_requiem:OnSpellStart(talent,talent_pos)
	local caster = self:GetCaster()
	local cast_pos = caster:GetAbsOrigin()
	if not self:GetCursorTargetingNothing() then
		cast_pos = self:GetCursorPosition()
	end
	local buff = caster:FindModifierByName("modifier_imba_necromastery_counter")
	local souls = buff and buff:GetStackCount() or (self:IsStolen() and 46 or 0)
	if talent then
		souls = souls * caster:TG_GetTalentValue("special_bonus_imba_nevermore_4")/100 or 0
		cast_pos = talent_pos
	end
	local lines = math.floor(souls / self:GetSpecialValueFor("soul_conversion")) --IsInToolsMode() and 102 or 
	local length = self:GetSpecialValueFor("radius")
	local end_pos = cast_pos + caster:GetForwardVector():Normalized() * length
	local speed = self:GetSpecialValueFor("line_speed")
	local arcana = 0
	local pfx_name = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf"
	local pfx_name_2 = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf"
	local pfx_name_3 = "particles/units/heroes/hero_nevermore/nevermore_wings.vpcf"
	local sound_name = "Hero_Nevermore.RequiemOfSouls"
	--if HeroItems:UnitHasItem(caster, "head_arcana") then
		arcana = 1
		pfx_name = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_requiemofsouls_line.vpcf"
		pfx_name_2 = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_requiemofsouls.vpcf"
		pfx_name_3 = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_wings.vpcf"
		sound_name = "Hero_Nevermore.ROS.Arcana"
	--end
	local thinker_sce = CreateModifierThinker(caster, self, "modifier_imba_requiem_thinker", {duration = 20.0}, caster:GetAbsOrigin() + Vector(0,0,-10000), caster:GetTeamNumber(), false):entindex()
	EntIndexToHScript(thinker_sce):SetModel("models/heroes/shadow_fiend/fx_shadow_fiend_arcana_hand.vmdl")
	EntIndexToHScript(thinker_sce).dmg = 0
	EntIndexToHScript(thinker_sce).steal = {}
	EntIndexToHScript(thinker_sce):GiveVisionForBothTeam(20.0)
	--太吵了先关闭了
	if not talent then
		EntIndexToHScript(thinker_sce):EmitSound(sound_name)
	end
	for i=0, lines-1 do
		local pos = GetGroundPosition(RotatePosition(cast_pos, QAngle(0,i * (360 / lines),0), end_pos), nil)
		local direction = (pos - cast_pos):Normalized()
		direction.z = 0
		local duration = length / speed
		local velocity = direction * speed
		local info = 
		{
			Ability = self,
			EffectName = nil,
			vSpawnOrigin = cast_pos,
			fDistance = length,
			fStartRadius = self:GetSpecialValueFor("line_width_start"),
			fEndRadius = self:GetSpecialValueFor("line_width_end"),
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			bDeleteOnHit = true,
			vVelocity = direction * speed,
			bProvidesVision = false,
			ExtraData = {go = 1, pos_x = cast_pos.x, pos_y = cast_pos.y, pos_z = cast_pos.z, thinker_sce = thinker_sce, lines = i, total = lines, pfx = arcana}
		}
		ProjectileManager:CreateLinearProjectile(info)
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, cast_pos)
		ParticleManager:SetParticleControl(pfx, 1, velocity)
		ParticleManager:SetParticleControl(pfx, 2, Vector(0,duration,0))
		ParticleManager:ReleaseParticleIndex(pfx)
	end
	if self.fx and not self.fx:IsNull() and self.fx ~= nil then 
		local pfx2 = ParticleManager:CreateParticle(pfx_name_2, PATTACH_ABSORIGIN_FOLLOW, self.fx)
		ParticleManager:SetParticleControl(pfx2, 1, self.fx:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx2)
		local pfx3 = ParticleManager:CreateParticle(pfx_name_3, PATTACH_POINT_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(pfx3)
	end
end

function imba_nevermore_requiem:OnProjectileHit_ExtraData(target, location, keys)
	if keys.go == 1 then
		if not target then
			if self:GetCaster():HasScepter() and keys.thinker_sce and keys.lines == 0 then
				local buff = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_requiem_caster_scepter", {duration = self:GetSpecialValueFor("atk_duration")})
				if buff and not buff:IsNull() and buff ~= nil then
					buff:SetStackCount(EntIndexToHScript(keys.thinker_sce).dmg)
					EntIndexToHScript(keys.thinker_sce).steal = nil
					EntIndexToHScript(keys.thinker_sce):ForceKill(false)
				end
			end
			-------------BACK
			local caster = self:GetCaster()
			local cast_pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
			local length = self:GetSpecialValueFor("radius")
			local speed = self:GetSpecialValueFor("line_speed")
			local direction = (cast_pos - location):Normalized()
			local duration = length / speed
			direction.z = 0
			local velocity = direction * speed
			local i = keys.lines
			local pfx_name = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf"
			local sound_name = "Hero_Nevermore.RequiemOfSouls"
			if keys.pfx == 1 then
				pfx_name = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_requiemofsouls_line.vpcf"
				sound_name = "Hero_Nevermore.ROS.Arcana"
			end
			if i == 0 then
				if not caster:TG_HasTalent("special_bonus_imba_nevermore_4") then 
					EntIndexToHScript(keys.thinker_sce):EmitSound(sound_name)
				end
			end
			local info = 
			{
				Ability = self,
				EffectName = nil,
				vSpawnOrigin = location,
				fDistance = length,
				fStartRadius = self:GetSpecialValueFor("line_width_end"),
				fEndRadius = self:GetSpecialValueFor("line_width_start"),
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				bDeleteOnHit = true,
				vVelocity = direction * speed,
				bProvidesVision = false,
				ExtraData = {thinker_sce = keys.thinker_sce, go = 0, lines = i}
			}
			ProjectileManager:CreateLinearProjectile(info)
			local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, location)
			ParticleManager:SetParticleControl(pfx, 1, velocity)
			ParticleManager:SetParticleControl(pfx, 2, Vector(0,duration,0))
			ParticleManager:ReleaseParticleIndex(pfx)
			return true
		end
		if target:IsTrueHero() and not IsInTable(target, EntIndexToHScript(keys.thinker_sce).steal) then
			EntIndexToHScript(keys.thinker_sce).steal[#EntIndexToHScript(keys.thinker_sce).steal+1] = target
			local cast_pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
			local distance = (cast_pos - target:GetAbsOrigin()):Length2D()
			local dmg = (target:GetBaseDamageMax() + target:GetBaseDamageMin()) / 2
			local dmg_lost = dmg * (self:GetSpecialValueFor("reduction_damage") / 100)
			local dmg_steal_pct = math.min(distance / self:GetSpecialValueFor("radius"), 1.0) * ((self:GetSpecialValueFor("max_atk_gain") / 100) - (self:GetSpecialValueFor("min_atk_gain") / 100)) + (self:GetSpecialValueFor("min_atk_gain") / 100)
			EntIndexToHScript(keys.thinker_sce).dmg = EntIndexToHScript(keys.thinker_sce).dmg + dmg_steal_pct * dmg_lost
			local pfx_screen = ParticleManager:CreateParticleForPlayer("particles/hero/nevermore/screen_requiem_indicator.vpcf", PATTACH_ABSORIGIN_FOLLOW, target, PlayerResource:GetPlayer(target:GetPlayerID()))
			ParticleManager:ReleaseParticleIndex(pfx_screen)
		end
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_requiem_enemy_debuff", {duration = self:GetSpecialValueFor("slow_duration")})
		--fear
		if self:GetCaster():IsAlive() and not target:IsMagicImmune() then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_nevermore_requiem_fear", {duration = self:GetSpecialValueFor("slow_duration")/2})
		end
		local damageTable = {
							victim = target,
							attacker = self:GetCaster(),
							damage = self:GetSpecialValueFor("line_damage"),
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}
		ApplyDamage(damageTable)
	end
	if keys.go == 0 and target then
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_requiem_enemy_debuff", {duration = self:GetSpecialValueFor("slow_duration")})
		--fear
		if self:GetCaster():IsAlive() and not target:IsMagicImmune() then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_nevermore_requiem_fear", {duration = self:GetSpecialValueFor("slow_duration")/2})
		end	
		local damageTable = {
							victim = target,
							attacker = self:GetCaster(),
							damage = self:GetSpecialValueFor("line_damage"),
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}
		ApplyDamage(damageTable)
		self:GetCaster():Heal(self:GetSpecialValueFor("line_damage"), self)
	end
end

modifier_imba_requiem_thinker = class({})

modifier_imba_requiem_caster_scepter = class({})

function modifier_imba_requiem_caster_scepter:IsDebuff()			return false end
function modifier_imba_requiem_caster_scepter:IsHidden() 			return false end
function modifier_imba_requiem_caster_scepter:IsPurgable() 			return true end
function modifier_imba_requiem_caster_scepter:IsPurgeException() 	return true end
function modifier_imba_requiem_caster_scepter:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
function modifier_imba_requiem_caster_scepter:GetModifierPreAttack_BonusDamage() return self:GetStackCount() end

modifier_imba_requiem_enemy_debuff = class({})

function modifier_imba_requiem_enemy_debuff:IsDebuff()			return true end
function modifier_imba_requiem_enemy_debuff:IsHidden() 			return false end
function modifier_imba_requiem_enemy_debuff:IsPurgable() 		return true end
function modifier_imba_requiem_enemy_debuff:IsPurgeException() 	return true end
function modifier_imba_requiem_enemy_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE} end
function modifier_imba_requiem_enemy_debuff:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("reduction_ms")) end
function modifier_imba_requiem_enemy_debuff:GetModifierBaseDamageOutgoing_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("reduction_damage")) end


------------------------------------------------
--add by MysterBug ZXC 
imba_nevermore_shadowraze_omg = class({})

function imba_nevermore_shadowraze_omg:IsHiddenWhenStolen() 	return false end
function imba_nevermore_shadowraze_omg:IsRefreshable() 			return true end
function imba_nevermore_shadowraze_omg:IsStealable() 			return true end
function imba_nevermore_shadowraze_omg:GetCastRange() return self:GetSpecialValueFor("length") end

function imba_nevermore_shadowraze_omg:OnSpellStart()
	local caster = self:GetCaster()
	if self:GetAutoCastState() then
		--imba cast
		CastLinesShadoWraze(caster,self)
	else
		--classic ZXC cast
		CastPointsShadoWraze(caster,self)	
	end
end