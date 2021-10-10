------2020.10.27--by--你收拾收拾准备出林肯吧
CreateTalents("npc_dota_hero_earthshaker", "linken/hero_earthshaker.lua")
imba_earthshaker_fissure = class({})
LinkLuaModifier("modifier_imba_earthshaker_fissure_armor", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_earthshaker_fissure_thinker", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_earthshaker_fissure", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_earthshaker_fissure:IsHiddenWhenStolen() 		return false end
function imba_earthshaker_fissure:IsRefreshable() 			return true end
function imba_earthshaker_fissure:IsStealable() 			return true end
function imba_earthshaker_fissure:GetCastRange() return self:GetSpecialValueFor("fissure_range") end
function imba_earthshaker_fissure:GetCastPoint()
	if	IsServer()  then 
		local caster = self:GetCaster()
		local ability = caster:FindAbilityByName("imba_earthshaker_aftershock")
		local ability2 = caster:FindAbilityByName("imba_earthshaker_stars_aura")
		if self:GetCaster():HasScepter() and self:GetCaster():HasModifier("modifier_imba_earthshaker_enchant_totem_yidong") then
			return 0
		end
		return 0.69
	end		 
end
function imba_earthshaker_fissure:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_earthshaker_3") then 
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_earthshaker_3"))
	end
	return cooldown
end
function imba_earthshaker_fissure:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0.0
	local ability = caster:FindAbilityByName("imba_earthshaker_aftershock")
	local ability2 = caster:FindAbilityByName("imba_earthshaker_stars_aura")
	local length = self:GetSpecialValueFor("fissure_range") + caster:GetCastRangeBonus()
	local pos0 = caster:GetAbsOrigin() + direction * 128
	local pos1 = caster:GetAbsOrigin() + direction * (length + 128)
	local total = (length / 80)
	local sound_name = "Hero_EarthShaker.Fissure"
	local pfx_name = "particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf"
	local pos_start = pos0
	local pos_end = pos1
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local magic_immune_duration = self:GetSpecialValueFor("magic_immune_duration") 
	local duration_int = self:GetSpecialValueFor("duration_int")
	local fissure_radius = self:GetSpecialValueFor("fissure_radius")
	local fissure_duration = self:GetSpecialValueFor("fissure_duration")
	local armor_duration = self:GetSpecialValueFor("armor_duration")
	local attack_immune_int = self:GetSpecialValueFor("attack_immune_int")
	if caster:HasModifier("modifier_imba_earthshaker_enchant_totem_yidong") then
		fissure_duration = fissure_duration * ((100-self:GetSpecialValueFor("attack_immune_int")) * 0.01)
		stun_duration = stun_duration * ((100-self:GetSpecialValueFor("attack_immune_int")) * 0.01)
	end
	if not ability:IsTrained() and ability2:IsTrained() then
		fissure_duration = fissure_duration * ((100-self:GetSpecialValueFor("duration_int")) * 0.01)
		stun_duration = stun_duration * ((100-self:GetSpecialValueFor("duration_int")) * 0.01)
	end			

	local direc = (pos_end - pos_start):Normalized()
	direc.z = 0
	local sound = CreateModifierThinker(caster, self, "modifier_imba_earthshaker_fissure_thinker", {duration = 10.0}, pos_end, caster:GetTeamNumber(), false)
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, pos_start)
	ParticleManager:SetParticleControl(pfx, 1, pos_end)
	ParticleManager:SetParticleControl(pfx, 2, Vector(fissure_duration, 0, 0))
	ParticleManager:ReleaseParticleIndex(pfx)
	for j = 0, total do
		local block = CreateModifierThinker(caster, self, "modifier_imba_earthshaker_fissure_thinker", {duration = fissure_duration , destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
		block:SetHullRadius(80)
	end
	local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, fissure_radius , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	if not ability:IsTrained() and ability2:IsTrained() then
		for k = 1, #enemy do
			if not enemy[k]:IsMagicImmune() then  
				TG_AddNewModifier_RS(enemy[k], caster, self, "modifier_stunned", {duration = stun_duration})
				TG_AddNewModifier_RS(enemy[k] ,caster, self, "modifier_imba_earthshaker_fissure_armor", {duration = armor_duration})
				ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetSpecialValueFor("damage"), damage_type = self:GetAbilityDamageType(), ability = self})
			end	
		end
	else
		for k = 1, #enemy do
			if not enemy[k]:IsMagicImmune() then  
				TG_AddNewModifier_RS(enemy[k], caster, self, "modifier_stunned", {duration = stun_duration})
				ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetSpecialValueFor("damage"), damage_type = self:GetAbilityDamageType(), ability = self})
			else
				TG_AddNewModifier_RS(enemy[k], caster, self, "modifier_stunned", {duration = magic_immune_duration})	--对魔免造成1秒眩晕
			end	
			if enemy[k]:IsAttackImmune() then  --对虚无造成1.5倍伤害
				ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetSpecialValueFor("damage") * attack_immune_int, damage_type = self:GetAbilityDamageType(), ability = self})
			end
		end
	end	
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, length * 1.3, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for i=1, #enemy do
		FindClearSpaceForUnit(enemy[i], enemy[i]:GetAbsOrigin(), true)
		enemy[i]:AddNewModifier(caster, self, "modifier_phased", {duration = 0.2})  --添加相位修饰器？
	end
	caster:EmitSound(sound_name)
	local ability2 = caster:FindAbilityByName("imba_earthshaker_stars_aura")
	ability2:Thestars(pos, true)
end

modifier_imba_earthshaker_fissure_thinker = class({})
function modifier_imba_earthshaker_fissure_thinker:IsAura()					return true end
function modifier_imba_earthshaker_fissure_thinker:GetAuraDuration() 		return 0.4 end
function modifier_imba_earthshaker_fissure_thinker:GetModifierAura() 		return "modifier_imba_earthshaker_fissure" end
function modifier_imba_earthshaker_fissure_thinker:IsAuraActiveOnDeath() 	return false end
function modifier_imba_earthshaker_fissure_thinker:GetAuraRadius() 			return 150 end
function modifier_imba_earthshaker_fissure_thinker:GetAuraSearchFlags() 	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_earthshaker_fissure_thinker:GetAuraSearchTeam() 		return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_earthshaker_fissure_thinker:GetAuraSearchType() 		return DOTA_UNIT_TARGET_HERO end

modifier_imba_earthshaker_fissure = class({})
function modifier_imba_earthshaker_fissure:CheckState() 
	return 
	{
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = self:GetParent():Has_Aghanims_Shard(),
		
	} 
end



modifier_imba_earthshaker_fissure_armor = class({})

function modifier_imba_earthshaker_fissure_armor:IsDebuff()				return true end
function modifier_imba_earthshaker_fissure_armor:IsHidden() 			return false end
function modifier_imba_earthshaker_fissure_armor:IsPurgable() 			return false end
function modifier_imba_earthshaker_fissure_armor:IsPurgeException() 	return false end
function modifier_imba_earthshaker_fissure_armor:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_earthshaker_fissure_armor:OnCreated( kv )
	self.armor = 0-self:GetAbility():GetSpecialValueFor("armor")
	if self:GetCaster():Has_Aghanims_Shard() then
		self.armor = self.armor * 2
	end	
	if IsServer() then	
	end
end		
function modifier_imba_earthshaker_fissure_armor:GetModifierPhysicalArmorBonus(keys)
	return self.armor
end

imba_earthshaker_aftershock = class({})
LinkLuaModifier("modifier_imba_earthshaker_aftershock", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_earthshaker_aftershock_cd", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE) 
function imba_earthshaker_aftershock:IsHiddenWhenStolen() 		return true end
function imba_earthshaker_aftershock:IsRefreshable() 			return true end
function imba_earthshaker_aftershock:IsStealable() 				return false end
function imba_earthshaker_aftershock:GetCastRange()  			
	return self:GetSpecialValueFor("aftershock_range") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_1") - self:GetCaster():GetCastRangeBonus() 
end
function imba_earthshaker_aftershock:ResetToggleOnRespawn() 	return false end
function imba_earthshaker_aftershock:GetIntrinsicModifierName() return "modifier_imba_earthshaker_aftershock" end--是否默认拥有
function imba_earthshaker_aftershock:OnSpellStart() 
	local caster = self:GetCaster()
	local swap = "imba_earthshaker_aftershock"
	local unswap = "imba_earthshaker_stars_aura"
	local swap_ability = caster:FindAbilityByName(swap)
	local unswap_ability = caster:FindAbilityByName(unswap)
	if caster:FindModifierByName("modifier_imba_earthshaker_aftershock") and not caster:FindModifierByName("modifier_imba_earthshaker_stars_aura") then
		caster:RemoveModifierByName("modifier_imba_earthshaker_aftershock")
		self:GetCaster():AddNewModifier(
		self:GetCaster(), 
		unswap_ability, 
		"modifier_imba_earthshaker_stars_aura", 
		{})
	end		
	Timers:CreateTimer(FrameTime(), function()
		caster:SwapAbilities(swap, unswap, false, true)
		unswap_ability:SetLevel(swap_ability:GetLevel())
		unswap_ability:StartCooldown(swap_ability:GetCooldown(swap_ability:GetLevel()-1))
		swap_ability:SetHidden(true)
		swap_ability:SetLevel(0)
	end)
end

modifier_imba_earthshaker_aftershock_cd = class({}) 
function modifier_imba_earthshaker_aftershock_cd:IsDebuff()			return true end
function modifier_imba_earthshaker_aftershock_cd:IsHidden() 			return false end
function modifier_imba_earthshaker_aftershock_cd:IsPurgable() 		return false end
function modifier_imba_earthshaker_aftershock_cd:IsPurgeException() 	return false end

modifier_imba_earthshaker_aftershock = class({}) 

function modifier_imba_earthshaker_aftershock:IsDebuff()			return false end
function modifier_imba_earthshaker_aftershock:IsHidden() 			return true end
function modifier_imba_earthshaker_aftershock:IsPurgable() 		return false end
function modifier_imba_earthshaker_aftershock:IsPurgeException() 	return false end
function modifier_imba_earthshaker_aftershock:IsRefreshable() 			return true end
function modifier_imba_earthshaker_aftershock:IsHiddenWhenStolen() 		return true end
function modifier_imba_earthshaker_aftershock:IsRefreshable() 			return true end
function modifier_imba_earthshaker_aftershock:IsStealable() 				return false end
function modifier_imba_earthshaker_aftershock:GetCastRange() 			return self:GetSpecialValueFor("aftershock_range") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_1")end
function modifier_imba_earthshaker_aftershock:DeclareFunctions() 
	return{MODIFIER_EVENT_ON_ABILITY_FULLY_CAST}  
end

function modifier_imba_earthshaker_aftershock:OnAbilityFullyCast( params )
	self.radius = self:GetAbility():GetSpecialValueFor( "aftershock_range" ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_1")
	
	if IsServer() and not self:GetParent():PassivesDisabled() then
		if self:GetParent():HasScepter() and params.ability:GetAbilityName() == "imba_earthshaker_enchant_totem"  then  --拥有a杖时 返回
			return
		end
		if self:GetAbility():GetLevel() == 0 then return end
		if params.unit ~= self:GetParent() or params.ability:IsItem() then 
			return 
		end
			local IsTriggerByAbility = {
			["wisp_spirits_in"] = true,
			["imba_kunkka_return"] = true,
			["imba_nyx_assassin_burrow"] = true,
			["imba_nyx_assassin_unburrow"] = true,
			["shadow_demon_shadow_poison_release"] = true,
			["imba_ember_spirit_activate_fire_remnant"] = true, 
			["imba_bane_nightmare_end"] = true,
			["morphling_morph_replicate"] = true,
			["ability_capture"] = true, 
			["imba_earthshaker_stars_aura"] = true,
		}
		if not IsTriggerByAbility[params.ability:GetAbilityName()] then		
			self:CastAftershock()  --运行余震
			if not self:GetParent():PassivesDisabled() and not self:GetParent():HasModifier("modifier_imba_earthshaker_aftershock_cd") then  --不在cd时运行地质形成
				if params.unit ~= self:GetParent() or params.ability:IsItem() then return end	
				self:Aftershockspecial() --运行地质生成
				self:GetCaster():AddNewModifier(
				self:GetCaster(), 
				self:GetAbility(), 
				"modifier_imba_earthshaker_aftershock_cd", 
				{duration = (self:GetAbility():GetSpecialValueFor( "cooldown" ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_6")) * self:GetParent():GetCooldownReduction()}) 				
			end 
		end		                  
	end
			
end
function modifier_imba_earthshaker_aftershock:Aftershockspecial()  --地质生成
	if not IsServer() then return end
		local caster = self:GetCaster()
		local direction = caster:GetForwardVector():Normalized()
		local length = self:GetAbility():GetSpecialValueFor("fissure_range") + caster:GetCastRangeBonus()
		local pos0 = caster:GetAbsOrigin() + direction * 128
		local pos1 = caster:GetAbsOrigin() + direction * (length + 128)
		local angle = 360 / self:GetAbility():GetSpecialValueFor("number")
		local total = (length / 80)
		local sound_name = "Hero_EarthShaker.Fissure"
		local pfx_name = "particles/units/heroes/hero_earthshaker/earthshaker_fissure.vpcf"
	--[[	Timers:CreateTimer(0.03, function()  --不同步运行各个沟壑效果，减少卡顿

				local pos_start = pos0
				local pos_end = pos1
					pos_start = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 1, 0), pos0)
					pos_end = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 1, 0), pos1)
				local direc = (pos_end - pos_start):Normalized()
				direc.z = 0
				local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, pos_end, caster:GetTeamNumber(), false)
				sound:EmitSound(sound_name)
				
					local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, pos_start)
					ParticleManager:SetParticleControl(pfx, 1, pos_end)
					ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetAbility():GetSpecialValueFor("fissure_duration"), 0, 0))
					ParticleManager:ReleaseParticleIndex(pfx)
					for j = 0, total do
						local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetAbility():GetSpecialValueFor("fissure_duration"), destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
						block:SetHullRadius(80)
					end

					local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, self:GetAbility():GetSpecialValueFor("fissure_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
					for k = 1, #enemy do
						enemy[k]:AddNewModifier(self, self, "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("fissure_stun")})
						ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetAbility():GetSpecialValueFor("fissure_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
					end
				

		end)
		Timers:CreateTimer(0.06, function()

				local pos_start = pos0
				local pos_end = pos1
					pos_start = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 2, 0), pos0)
					pos_end = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 2, 0), pos1)
				local direc = (pos_end - pos_start):Normalized()
				direc.z = 0
				local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, pos_end, caster:GetTeamNumber(), false)
				sound:EmitSound(sound_name)
				
					local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, pos_start)
					ParticleManager:SetParticleControl(pfx, 1, pos_end)
					ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetAbility():GetSpecialValueFor("fissure_duration"), 0, 0))
					ParticleManager:ReleaseParticleIndex(pfx)
					for j = 0, total do
						local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetAbility():GetSpecialValueFor("fissure_duration"), destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
						block:SetHullRadius(80)
					end

					local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, self:GetAbility():GetSpecialValueFor("fissure_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
					for k = 1, #enemy do
						enemy[k]:AddNewModifier(self, self, "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("fissure_stun")})
						ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetAbility():GetSpecialValueFor("fissure_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
					end
				

		end)	]]
		Timers:CreateTimer(0.15, function()

				local pos_start = pos0
				local pos_end = pos1
					pos_start = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 3, 0), pos0)
					pos_end = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 3, 0), pos1)
				local direc = (pos_end - pos_start):Normalized()
				direc.z = 0
				local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, pos_end, caster:GetTeamNumber(), false)
				sound:EmitSound(sound_name)
				
					local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, pos_start)
					ParticleManager:SetParticleControl(pfx, 1, pos_end)
					ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetAbility():GetSpecialValueFor("fissure_duration"), 0, 0))
					ParticleManager:ReleaseParticleIndex(pfx)
					for j = 0, total do
						local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetAbility():GetSpecialValueFor("fissure_duration"), destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
						block:SetHullRadius(80)
					end

					local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, self:GetAbility():GetSpecialValueFor("fissure_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
					for k = 1, #enemy do
						enemy[k]:AddNewModifier(self, self, "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("fissure_stun")})
						ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetAbility():GetSpecialValueFor("fissure_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
					end
				

		end)	
		Timers:CreateTimer(0.06, function()

				local pos_start = pos0
				local pos_end = pos1
					pos_start = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 4, 0), pos0)
					pos_end = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 4, 0), pos1)
				local direc = (pos_end - pos_start):Normalized()
				direc.z = 0
				local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, pos_end, caster:GetTeamNumber(), false)
				sound:EmitSound(sound_name)
				
					local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, pos_start)
					ParticleManager:SetParticleControl(pfx, 1, pos_end)
					ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetAbility():GetSpecialValueFor("fissure_duration"), 0, 0))
					ParticleManager:ReleaseParticleIndex(pfx)
					for j = 0, total do
						local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetAbility():GetSpecialValueFor("fissure_duration"), destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
						block:SetHullRadius(80)
					end

					local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, self:GetAbility():GetSpecialValueFor("fissure_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
					for k = 1, #enemy do
						enemy[k]:AddNewModifier(self, self, "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("fissure_stun")})
						ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetAbility():GetSpecialValueFor("fissure_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
					end
				

		end)	
		Timers:CreateTimer(0.03, function()

				local pos_start = pos0
				local pos_end = pos1
					pos_start = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 5, 0), pos0)
					pos_end = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 5, 0), pos1)
				local direc = (pos_end - pos_start):Normalized()
				direc.z = 0
				local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, pos_end, caster:GetTeamNumber(), false)
				sound:EmitSound(sound_name)
				
					local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, pos_start)
					ParticleManager:SetParticleControl(pfx, 1, pos_end)
					ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetAbility():GetSpecialValueFor("fissure_duration"), 0, 0))
					ParticleManager:ReleaseParticleIndex(pfx)
					for j = 0, total do
						local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetAbility():GetSpecialValueFor("fissure_duration"), destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
						block:SetHullRadius(80)
					end

					local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, self:GetAbility():GetSpecialValueFor("fissure_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
					for k = 1, #enemy do
						enemy[k]:AddNewModifier(self, self, "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("fissure_stun")})
						ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetAbility():GetSpecialValueFor("fissure_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
					end
				

		end)	
		Timers:CreateTimer(0, function()

				local pos_start = pos0
				local pos_end = pos1
					pos_start = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 6, 0), pos0)
					pos_end = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle * 6, 0), pos1)
				local direc = (pos_end - pos_start):Normalized()
				direc.z = 0
				local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 2.0}, pos_end, caster:GetTeamNumber(), false)
				sound:EmitSound(sound_name)
			
					local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(pfx, 0, pos_start)
					ParticleManager:SetParticleControl(pfx, 1, pos_end)
					ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetAbility():GetSpecialValueFor("fissure_duration"), 0, 0))
					ParticleManager:ReleaseParticleIndex(pfx)
					for j = 0, total do
						local block = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetAbility():GetSpecialValueFor("fissure_duration"), destroy_sound = "Hero_EarthShaker.FissureDestroy"}, pos_start + (direc * (length / total)) * j, caster:GetTeamNumber(), true)
						block:SetHullRadius(80)
					end

					local enemy = FindUnitsInLine(caster:GetTeamNumber(), pos_start, pos_end, nil, self:GetAbility():GetSpecialValueFor("fissure_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
					for k = 1, #enemy do
						enemy[k]:AddNewModifier(self, self, "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("fissure_stun")})
						ApplyDamage({attacker = caster, victim = enemy[k], damage = self:GetAbility():GetSpecialValueFor("fissure_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
					end
				

		end)		
		local enemy = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, length * 1.3, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for i=1, #enemy do
			FindClearSpaceForUnit(enemy[i], enemy[i]:GetAbsOrigin(), true)
			enemy[i]:AddNewModifier(caster, self, "modifier_phased", {duration = 0.2})
		end
		caster:EmitSound(sound_name)
end	
	
function modifier_imba_earthshaker_aftershock:CastAftershock()  --余震
	self.radius = self:GetAbility():GetSpecialValueFor( "aftershock_range" ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_1")
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do		
		TG_AddNewModifier_RS(enemy, self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("aftershock_stun_duration")})
		ApplyDamage({attacker = self:GetCaster(), victim = enemy, damage = self:GetAbility():GetSpecialValueFor("aftershock_damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
	end
	Timers:CreateTimer(FrameTime(), function()self:PlayEffects() end )
end			


function modifier_imba_earthshaker_aftershock:PlayEffects()
	local particle_cast = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_v2.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

imba_earthshaker_stars_aura = class({}) --星辰光环
LinkLuaModifier("modifier_imba_earthshaker_stars_aura", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_earthshaker_stars_aura_cast_time", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_earthshaker_aftershock_cd", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE)  
LinkLuaModifier("modifier_imba_earthshaker_stars_aura_thinker", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_imba_earthshaker_stars_aura_caster", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier( "modifier_imba_earthshaker_stars_cd", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_earthshaker_stars_aura:IsHiddenWhenStolen() 		return true end
function imba_earthshaker_stars_aura:IsRefreshable() 			return true end
function imba_earthshaker_stars_aura:IsStealable() 				return false end
function imba_earthshaker_stars_aura:GetCastRange() 	
	return self:GetSpecialValueFor("stars_radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_1") - self:GetCaster():GetCastRangeBonus() 
end
function imba_earthshaker_stars_aura:GetIntrinsicModifierName() return "modifier_imba_earthshaker_stars_aura" end--是否默认拥有
function imba_earthshaker_stars_aura:OnSpellStart()
	local caster = self:GetCaster()
	local swap = "imba_earthshaker_aftershock"
	local unswap = "imba_earthshaker_stars_aura"
	local swap_ability = caster:FindAbilityByName(swap)
	local pos = caster:GetAbsOrigin()
	local unswap_ability = caster:FindAbilityByName(unswap)
	local ability2 = caster:FindAbilityByName("imba_earthshaker_stars_aura")
	ability2:Thestars(pos, true)	
	if caster:FindModifierByName("modifier_imba_earthshaker_stars_aura") and not caster:FindModifierByName("modifier_imba_earthshaker_aftershock") then
		caster:RemoveModifierByName("modifier_imba_earthshaker_stars_aura")
		self:GetCaster():AddNewModifier(
		self:GetCaster(), 
		unswap_ability, 
		"modifier_imba_earthshaker_aftershock", 
		{})
	end		
	self:GetCaster():AddNewModifier(
	self:GetCaster(), 
	swap_ability, 
	"modifier_imba_earthshaker_aftershock_cd", 
	{duration = (swap_ability:GetSpecialValueFor( "cooldown" ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_6")) * caster:GetCooldownReduction()}) 	
	caster:SwapAbilities(swap, unswap, true, false)
	swap_ability:SetLevel(unswap_ability:GetLevel())
	swap_ability:StartCooldown(unswap_ability:GetCooldown(unswap_ability:GetLevel()-1))
	unswap_ability:SetHidden(true)
	unswap_ability:SetLevel(0)		
end	
function imba_earthshaker_stars_aura:Thestars(vpos, vbool)
	if not IsServer() then return end
 	local pos = vpos
 	local damage = self:GetSpecialValueFor("damage")
 	local radius = self:GetSpecialValueFor("stars_radius")
 	local bool = vbool
 	local caster = self:GetCaster()
 	local ability = caster:FindAbilityByName("imba_earthshaker_aftershock")
	local ability2 = caster:FindAbilityByName("imba_earthshaker_stars_aura")	
 	self.delay = 0.5
 	if caster:HasModifier("modifier_imba_earthshaker_stars_cd") then
 		pos = caster:GetAbsOrigin()
 	end
	if not caster:HasModifier("modifier_imba_earthshaker_stars_cd") and pos ~= caster:GetAbsOrigin() then
		Timers:CreateTimer(0.1, function()
			caster:AddNewModifier( --进入内置cd
			caster, 
			ability2, 
			"modifier_imba_earthshaker_stars_cd", 
			{duration = (self:GetSpecialValueFor( "stars_cd" ) + caster:TG_GetTalentValue("special_bonus_imba_earthshaker_6")) * caster:GetCooldownReduction()}) 
		end)	
	end			
	if not ability:IsTrained() and ability2:IsTrained() then
		if bool then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_stars_aura_caster", {})
		end	
		local pfx_fly = ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx_fly, 0, caster:GetAbsOrigin() + Vector(0,0,1500))
		ParticleManager:SetParticleControl(pfx_fly, 1, pos)
		ParticleManager:SetParticleControl(pfx_fly, 2, Vector(self.delay,0,0))
		ParticleManager:ReleaseParticleIndex(pfx_fly)
		Timers:CreateTimer(self.delay, function()
				caster:EmitSound("Hero_Invoker.ChaosMeteor.Impact")
				if bool then
					FindClearSpaceForUnit(self:GetCaster(), pos, true)
					self:GetCaster():RemoveModifierByName("modifier_imba_earthshaker_stars_aura_caster")
				end	
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				for i=1, #enemies do
						local damageTable = {
						victim 			= enemies[i],
						damage 			= damage,
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= caster,
						ability 		= self
						}
					self:Bash(enemies[i], i)	
					ApplyDamage(damageTable)
				end
				caster:MoveToPositionAggressive(pos)					
				return nil
			end
		)			
	end
end
function imba_earthshaker_stars_aura:Bash(target, i)
	if not IsServer() then return end
	
	local parent_loc	= self:GetCaster():GetAbsOrigin()
	
		if i ~= 1 then
			knockback_properties = {
				 center_x 			= parent_loc.x,
				 center_y 			= parent_loc.y,
				 center_z 			= parent_loc.z,
				 duration 			= 0.8,
				 knockback_duration = 0.8,
				 knockback_distance = 300,
				 knockback_height 	= 300,
			}
		else	
			knockback_properties = {
				 center_x 			= parent_loc.x,
				 center_y 			= parent_loc.y,
				 center_z 			= parent_loc.z,
				 duration 			= 0.8,
				 knockback_duration = 0.8,
				 knockback_distance = 0,
				 knockback_height 	= 300,
			}
		end
	if target:HasModifier("modifier_knockback")	then
		target:RemoveModifierByName("modifier_knockback")
	end					
	local knockback_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_knockback", knockback_properties)
end

modifier_imba_earthshaker_stars_cd = class({}) 
function modifier_imba_earthshaker_stars_cd:IsDebuff()			return true end
function modifier_imba_earthshaker_stars_cd:IsHidden() 			return false end
function modifier_imba_earthshaker_stars_cd:IsPurgable() 		return false end
function modifier_imba_earthshaker_stars_cd:IsPurgeException() 	return false end

modifier_imba_earthshaker_stars_aura = class({}) 
function modifier_imba_earthshaker_stars_aura:IsDebuff()			return false end
function modifier_imba_earthshaker_stars_aura:IsHidden() 			return true end
function modifier_imba_earthshaker_stars_aura:IsPurgable() 		return false end
function modifier_imba_earthshaker_stars_aura:IsPurgeException() 	return false end
function modifier_imba_earthshaker_stars_aura:IsAura() return true end
function modifier_imba_earthshaker_stars_aura:GetAuraDuration() return 0.1 end
function modifier_imba_earthshaker_stars_aura:GetModifierAura() return "modifier_imba_earthshaker_stars_aura_cast_time" end
function modifier_imba_earthshaker_stars_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_earthshaker_stars_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_imba_earthshaker_stars_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_imba_earthshaker_stars_aura:GetAuraEntityReject(unit) return false end

function modifier_imba_earthshaker_stars_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end
modifier_imba_earthshaker_stars_aura_thinker = class({})

modifier_imba_earthshaker_stars_aura_caster = class({})

function modifier_imba_earthshaker_stars_aura_caster:IsDebuff()			return false end
function modifier_imba_earthshaker_stars_aura_caster:IsHidden() 		return true end
function modifier_imba_earthshaker_stars_aura_caster:IsPurgable() 		return false end
function modifier_imba_earthshaker_stars_aura_caster:IsPurgeException() return false end
function modifier_imba_earthshaker_stars_aura_caster:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true, [MODIFIER_STATE_NOT_ON_MINIMAP] = true, [MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_OUT_OF_GAME] = true, [MODIFIER_STATE_UNSELECTABLE] = true} end

function modifier_imba_earthshaker_stars_aura_caster:OnCreated()
	if IsServer() then
		self:GetParent():AddNoDraw()
	end
end

function modifier_imba_earthshaker_stars_aura_caster:OnDestroy()
	if IsServer() then
		self:GetCaster():RemoveNoDraw()
	end
end	
modifier_imba_earthshaker_stars_aura_cast_time = class({}) 
function modifier_imba_earthshaker_stars_aura_cast_time:IsDebuff()
	if 	self:GetCaster():GetTeamNumber()==self:GetParent():GetTeamNumber() then		
		return false	
	else
		return true
	end	
end
function modifier_imba_earthshaker_stars_aura_cast_time:IsHidden() 			return self:GetAbility():GetLevel() == 0 end
function modifier_imba_earthshaker_stars_aura_cast_time:IsPurgable() 		return false end
function modifier_imba_earthshaker_stars_aura_cast_time:IsPurgeException() 	return false end
function modifier_imba_earthshaker_stars_aura_cast_time:DeclareFunctions() 
	return {
			MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
			} 
end
function modifier_imba_earthshaker_stars_aura_cast_time:GetModifierPercentageCasttime() 
	local cast_time = self:GetAbility():GetSpecialValueFor("cast_time")
	if IsServer()  then
		if not Is_Chinese_TG(self:GetCaster(), self:GetParent()) then	
			cast_time = (-1 * self:GetAbility():GetSpecialValueFor("enemy_cast_time"))
			return cast_time
		end	  
		return cast_time
	end	
end

imba_earthshaker_echo_slam	= class({})

function imba_earthshaker_echo_slam:IsHiddenWhenStolen() 		return false end
function imba_earthshaker_echo_slam:IsRefreshable() 			return true end
function imba_earthshaker_echo_slam:IsStealable() 			return true end
function imba_earthshaker_echo_slam:GetCastRange() 			return self:GetSpecialValueFor("echo_slam_damage_echo_range") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_7") end
function imba_earthshaker_echo_slam:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	return cooldown
end
function imba_earthshaker_echo_slam:OnSpellStart()
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("imba_earthshaker_aftershock")
	local ability2 = caster:FindAbilityByName("imba_earthshaker_stars_aura")	
	local hero_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("echo_slam_damage_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)	
	if #hero_enemies > 0 then
		self:GetCaster():EmitSound("Hero_EarthShaker.EchoSlam")
	else
		self:GetCaster():EmitSound("Hero_EarthShaker.EchoSlamSmall")
		self.pos = caster:GetAbsOrigin()
	end
	Timers:CreateTimer(0.5, function()
		if #hero_enemies == 2 then
			local random_response	= RandomInt(1, 4)
			if random_response >= 3 then random_response = random_response + 1 end				
			self:GetCaster():EmitSound("earthshaker_erth_ability_echo_0"..random_response)
		elseif #hero_enemies >= 3 then
			self:GetCaster():EmitSound("earthshaker_erth_ability_echo_03")
		elseif #hero_enemies == 0 then
			self:GetCaster():EmitSound("earthshaker_erth_ability_echo_0"..(RandomInt(6, 7)))
		end
	end) 
	local echo_slam_range  = self:GetSpecialValueFor("echo_slam_damage_echo_range") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_7")
	local fi = FIND_ANY_ORDER
	if not ability:IsTrained() and ability2:IsTrained() then
		fi = FIND_CLOSEST
	end			
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, echo_slam_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, fi, false)	
	local effect_counter = 0
	if not ability:IsTrained() and ability2:IsTrained() then
		for _, enemy in pairs(enemies) do
			self.ta = enemy
			self.pos = enemy:GetAbsOrigin()
			break
		end
	end		

	for _, enemy in pairs(enemies) do		
		local damageTable = {
			victim 			= enemy,
			damage 			= self:GetSpecialValueFor("echo_slam_initial_damage"),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}
		if enemy:IS_TrueHero_TG() then
			local pfx_screen = ParticleManager:CreateParticleForPlayer("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_screen.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy, PlayerResource:GetPlayer(enemy:GetPlayerID()))
			ParticleManager:ReleaseParticleIndex(pfx_screen)
		end
		if ability:IsTrained() and not ability2:IsTrained() then
			TG_AddNewModifier_RS(enemy, self:GetCaster(), self, "modifier_paralyzed", {duration = self:GetSpecialValueFor("paralyzed_duration")})	
			TG_AddNewModifier_RS(enemy, self:GetCaster(), self, "modifier_confuse", {duration = self:GetSpecialValueFor("confuse_duration")})
		end			
		ApplyDamage(damageTable)		
		local echo_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), enemy:GetAbsOrigin(), nil, echo_slam_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if ability:IsTrained() and not ability2:IsTrained() then
			for _, echo_enemy in pairs(echo_enemies) do
				if echo_enemy ~= enemy then
					echo_enemy:EmitSound("Hero_EarthShaker.EchoSlamEcho")				
					TG_CreateProjectile({id=1, team=caster:GetTeamNumber(), owner=caster, p=
					{
						Target 				= echo_enemy,
						Source 				= enemy,
						Ability 			= self,
						EffectName 			= "particles/units/heroes/hero_earthshaker/earthshaker_echoslam.vpcf",
						iMoveSpeed			= 1200,
						vSourceLoc 			= self.pos,
						bDrawsOnMinimap 	= false,
						bDodgeable 			= false,
						bIsAttack 			= false,
						bVisibleToEnemies 	= true,
						bReplaceExisting 	= false,
						flExpireTime 		= GameRules:GetGameTime() + 10.0,
						bProvidesVision 	= false,

						ExtraData = {
							damage = self:GetSpecialValueFor("echo_slam_echo_damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_4"),
							hp = enemy:GetHealth()
						}
					}})
					if echo_enemy:IsRealHero() then --英雄反弹两次
						effect_counter = effect_counter + 1
						TG_CreateProjectile({id=1, team=caster:GetTeamNumber(), owner=caster, p=
						{
							Target 				= echo_enemy,
							Source 				= enemy,
							Ability 			= self,
							EffectName 			= "particles/units/heroes/hero_earthshaker/earthshaker_echoslam.vpcf",
							iMoveSpeed			= 1200,
							vSourceLoc 			= enemy:GetAbsOrigin(),
							bDrawsOnMinimap 	= false,
							bDodgeable 			= false,
							bIsAttack 			= false,
							bVisibleToEnemies 	= true,
							bReplaceExisting 	= false,
							flExpireTime 		= GameRules:GetGameTime() + 10.0,
							bProvidesVision 	= false,

							ExtraData = {
								damage = self:GetSpecialValueFor("echo_slam_echo_damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_4"),
								hp = enemy:GetHealth()
							}
						}})
					end
				end
			end	
		else
			for _, echo_enemy in pairs(echo_enemies) do
				if echo_enemy ~= enemy then
					echo_enemy:EmitSound("Hero_EarthShaker.EchoSlamEcho")				
					TG_CreateProjectile({id=1, team=caster:GetTeamNumber(), owner=caster, p=
					{
						Target 				= self.ta,
						Source 				= echo_enemy,
						Ability 			= self,
						EffectName 			= "particles/units/heroes/hero_earthshaker/earthshaker_echoslam.vpcf",
						iMoveSpeed			= 1200,
						vSourceLoc 			= enemy:GetAbsOrigin(),
						bDrawsOnMinimap 	= false,
						bDodgeable 			= false,
						bIsAttack 			= false,
						bVisibleToEnemies 	= true,
						bReplaceExisting 	= false,
						flExpireTime 		= GameRules:GetGameTime() + 10.0,
						bProvidesVision 	= false,

						ExtraData = {
							damage = self:GetSpecialValueFor("echo_slam_echo_damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_4"),
							hp = echo_enemy:GetHealth()
						}
					}})
				end
			end
		end
	end
	local echo_slam_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	if ability:IsTrained() and not ability2:IsTrained() then
		ParticleManager:SetParticleControl(echo_slam_particle, 0, self:GetCaster():GetAbsOrigin()) 
		ParticleManager:SetParticleControl(echo_slam_particle, 1, Vector(echo_slam_range, echo_slam_range, echo_slam_range )) 
		ParticleManager:ReleaseParticleIndex(echo_slam_particle)
	else
		ability2:Thestars(self.pos, true)					
		Timers:CreateTimer(0.5, function()
			ParticleManager:SetParticleControl(echo_slam_particle, 0, self.pos) 
			ParticleManager:SetParticleControl(echo_slam_particle, 1, Vector(echo_slam_range, echo_slam_range, echo_slam_range )) 
			ParticleManager:ReleaseParticleIndex(echo_slam_particle)			
		end)
		self:EndCooldown()
		self:StartCooldown((self:GetCooldown(self:GetLevel() -1 )) * 0.5 * self:GetCaster():GetCooldownReduction())
	end						
end

function imba_earthshaker_echo_slam:OnProjectileHit_ExtraData(target, location, data)
	if target and not target:IsMagicImmune() then
		local damage = data.damage + data.hp * self:GetSpecialValueFor("add_damage_hp") * 0.01
		local damageTable = {
			victim 			= target,
			damage 			= damage,
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}		
		ApplyDamage(damageTable)
	end
end

imba_earthshaker_enchant_totem = class({})
LinkLuaModifier( "modifier_imba_earthshaker_enchant_totem_buff", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_imba_earthshaker_enchant_totem_yidong", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_imba_earthshaker_enchant_totem_buff_atbo", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_imba_earthshaker_enchant_totem_buff_sabo", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_imba_earthshaker_enchant_totem_buff_cdbo", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_imba_earthshaker_aftershock_cd", "linken/hero_earthshaker.lua", LUA_MODIFIER_MOTION_NONE) 

function imba_earthshaker_enchant_totem:IsDebuff()			return false end
function imba_earthshaker_enchant_totem:IsHidden() 			return true end
function imba_earthshaker_enchant_totem:IsPurgable() 		return false end
function imba_earthshaker_enchant_totem:IsPurgeException() 	return false end 
function imba_earthshaker_enchant_totem:GetCastPoint()
	if	IsServer()  then
		local caster = self:GetCaster()
		local ability = caster:FindAbilityByName("imba_earthshaker_aftershock")
		local ability2 = caster:FindAbilityByName("imba_earthshaker_stars_aura")
		local point = (100-ability2:GetSpecialValueFor("cast_time"))*0.01 * 0.69 
		if self:GetCaster():HasScepter() and self:GetCaster() ~= self:GetCursorTarget() and ability:IsTrained() and not ability2:IsTrained() then
			return 0
		end
		return point
	end		 
end
function imba_earthshaker_enchant_totem:GetCooldown(level)
	--if not IsServer() then return end
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_earthshaker_5") then 
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_earthshaker_5"))
	end
	return cooldown
end


function imba_earthshaker_enchant_totem:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE --a杖改变技能释放效果
	end

	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function imba_earthshaker_enchant_totem:GetCastRange(vLocation, hTarget)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("Scepter_Range")
	end

	return self.BaseClass.GetCastRange(self, vLocation, hTarget)
end

function imba_earthshaker_enchant_totem:CastFilterResultLocation(vLocation)  --缠绕不能释放
	if self:GetCaster():HasScepter() and self:GetCaster():IsRooted() then
		return UF_FAIL_CUSTOM
	end
end

function imba_earthshaker_enchant_totem:GetCustomCastErrorLocation(vLocation)
	return "dota_hud_error_ability_disabled_by_root"
end

function imba_earthshaker_enchant_totem:CastFilterResultTarget(target)
	if target ~= self:GetCaster() then
		return UF_FAIL_OBSTRUCTED
	end
end

function imba_earthshaker_enchant_totem:OnAbilityPhaseStart()  --有a杖施法前摇为0	
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("imba_earthshaker_aftershock")
	local ability2 = caster:FindAbilityByName("imba_earthshaker_stars_aura")	
	if self:GetCaster():HasScepter() and self:GetCaster() ~= self:GetCursorTarget() and ability:IsTrained() and not ability2:IsTrained() then
		--self:SetOverrideCastPoint(0)
	elseif not ability:IsTrained() and ability2:IsTrained() then
		self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1.5)	
	end	
	return true  
end

function imba_earthshaker_enchant_totem:OnSpellStart()  
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("imba_earthshaker_aftershock")
	local ability2 = caster:FindAbilityByName("imba_earthshaker_stars_aura")	
	self.pos = caster:GetAbsOrigin()
	if not ability:IsTrained() and ability2:IsTrained() and self:GetCaster():HasScepter() then 
		self.pos = self:GetCursorPosition()
	elseif	self:GetCaster():HasScepter() then
		self.pos = self:GetCursorPosition()
	end	
	if self:GetCaster():HasScepter() and self:GetCaster() ~= self:GetCursorTarget() then   --拥有a杖时添加移动修饰器、不添加buff修饰器
		if ability:IsTrained() and not ability2:IsTrained() then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_yidong", {duration = 1, pos_x = self.pos.x, pos_y = self.pos.y, pos_z = self.pos.z})
		elseif not ability:IsTrained() and ability2:IsTrained() then

			ability2:Thestars(self.pos, true)
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff", {duration = self:GetSpecialValueFor("buff_duration")})
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_atbo", {duration = self:GetSpecialValueFor("buff_duration")})
		end
	else
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff", {duration = self:GetSpecialValueFor("buff_duration")})
		EmitSoundOn("Hero_EarthShaker.Totem", self:GetCaster())	
		if ability:IsTrained() and not ability2:IsTrained() then 
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_cdbo", {duration = self:GetSpecialValueFor("buff_duration")})
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_sabo", {duration = self:GetSpecialValueFor("buff_duration")})
		end	
		if not ability:IsTrained() and ability2:IsTrained() then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earthshaker_enchant_totem_buff_atbo", {duration = self:GetSpecialValueFor("buff_duration")})
		else
			
		end
		ability2:Thestars(self.pos, true)				
	end	
	if ability:IsTrained() and not ability2:IsTrained() and self:GetCaster():HasScepter() and self:GetCaster() == self:GetCursorTarget() and not self:GetCaster():PassivesDisabled() then  --如果有a并且对自身释放则播放余震和地质形成（190行）
		local duration1 = (ability:GetSpecialValueFor( "cooldown" )) * self:GetCaster():GetCooldownReduction()
		if caster:TG_HasTalent("special_bonus_imba_earthshaker_6") then
			duration1 = (ability:GetSpecialValueFor( "cooldown" ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_6")) * self:GetCaster():GetCooldownReduction()
		end
		self:GetCaster():FindModifierByName("modifier_imba_earthshaker_aftershock"):CastAftershock()
		if  not self:GetCaster():HasModifier("modifier_imba_earthshaker_aftershock_cd") then
			self:GetCaster():FindModifierByName("modifier_imba_earthshaker_aftershock"):Aftershockspecial()
				self:GetCaster():AddNewModifier(
				self:GetCaster(), 
				ability, 
				"modifier_imba_earthshaker_aftershock_cd", 
				{duration = duration1}) 			
		end
	end		
end

modifier_imba_earthshaker_enchant_totem_buff_atbo = class({}) --攻击修饰器
function modifier_imba_earthshaker_enchant_totem_buff_atbo:IsDebuff()			return false end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:IsHidden() 			return false end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:IsPurgable() 			return false end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:IsPurgeException() 	return false end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = true} end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:DeclareFunctions()return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, MODIFIER_EVENT_ON_ATTACK_START, MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, MODIFIER_EVENT_ON_ATTACK} end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:GetModifierBaseDamageOutgoing_Percentage()
	return (self:GetAbility():GetSpecialValueFor("at_bo"))
end

function modifier_imba_earthshaker_enchant_totem_buff_atbo:GetModifierAttackRangeBonus() 
	return (75) 
end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:OnCreated()
self.number = self:GetAbility():GetSpecialValueFor("buff_number")
self.max_number = self:GetAbility():GetSpecialValueFor("buff_max")	
	if IsServer() then
		local caster = self:GetCaster()
		if  caster:TG_HasTalent("special_bonus_imba_earthshaker_2") then
			self.number = self:GetAbility():GetSpecialValueFor("buff_number") + caster:TG_GetTalentValue("special_bonus_imba_earthshaker_2")
			self.max_number = self:GetAbility():GetSpecialValueFor("buff_max") + caster:TG_GetTalentValue("special_bonus_imba_earthshaker_2")	
		end	
		for i=1, self.number do
			if self:GetStackCount() < self.max_number then
				self:IncrementStackCount()
			end	
		end	
	end	
end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end		
end
function modifier_imba_earthshaker_enchant_totem_buff_atbo:OnAttack( keys )
local caster = self:GetCaster()
	if IsServer() then
		if keys.attacker == caster then
			local current_stacks = self:GetStackCount()
			if current_stacks > 1 then
				self:DecrementStackCount()
			else
				self:Destroy()
				caster:FindModifierByName("modifier_imba_earthshaker_enchant_totem_buff"):Destroy()
			end
		end
	end
end	
function modifier_imba_earthshaker_enchant_totem_buff_atbo:OnAttackStart(keys)
local caster = self:GetCaster()
	if IsServer() then
		if keys.attacker == caster then
			local int = keys.attacker:GetAttacksPerSecond() + 1
			keys.attacker:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, int)
		end
	end
end	

modifier_imba_earthshaker_enchant_totem_buff_sabo = class({}) --技能增强修饰器
function modifier_imba_earthshaker_enchant_totem_buff_sabo:IsDebuff()			return false end
function modifier_imba_earthshaker_enchant_totem_buff_sabo:IsHidden() 			return false end
function modifier_imba_earthshaker_enchant_totem_buff_sabo:IsPurgable() 			return false end
function modifier_imba_earthshaker_enchant_totem_buff_sabo:IsPurgeException() 	return false end
function modifier_imba_earthshaker_enchant_totem_buff_sabo:DeclareFunctions()return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE} end
function modifier_imba_earthshaker_enchant_totem_buff_sabo:GetModifierSpellAmplify_Percentage()
	local caster = self:GetCaster() 
	
	if caster:TG_HasTalent("special_bonus_imba_earthshaker_5") then
		return (self:GetAbility():GetSpecialValueFor("sa_bo") * 1.5)
	end
	return (self:GetAbility():GetSpecialValueFor("sa_bo"))	
end
modifier_imba_earthshaker_enchant_totem_buff_cdbo = class({}) --减少cd修饰器
function modifier_imba_earthshaker_enchant_totem_buff_cdbo:IsDebuff()			return false end
function modifier_imba_earthshaker_enchant_totem_buff_cdbo:IsHidden() 			return false end
function modifier_imba_earthshaker_enchant_totem_buff_cdbo:IsPurgable() 			return false end
function modifier_imba_earthshaker_enchant_totem_buff_cdbo:IsPurgeException() 	return false end
function modifier_imba_earthshaker_enchant_totem_buff_cdbo:DeclareFunctions()return {MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE} end
function modifier_imba_earthshaker_enchant_totem_buff_cdbo:GetModifierPercentageCooldown()
	local caster = self:GetCaster() 
	
	if caster:TG_HasTalent("special_bonus_imba_earthshaker_5") then
		return  (self:GetAbility():GetSpecialValueFor("cd_bo") * 1.5)
	end
	return (self:GetAbility():GetSpecialValueFor("cd_bo"))
end
modifier_imba_earthshaker_enchant_totem_buff = class({})
function modifier_imba_earthshaker_enchant_totem_buff:IsDebuff()			return false end
function modifier_imba_earthshaker_enchant_totem_buff:IsHidden() 			return true end
function modifier_imba_earthshaker_enchant_totem_buff:IsPurgable() 			return false end
function modifier_imba_earthshaker_enchant_totem_buff:IsPurgeException() 	return false end
function modifier_imba_earthshaker_enchant_totem_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK, 
	}  
end
function modifier_imba_earthshaker_enchant_totem_buff:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		EmitSoundOn( "Hero_EarthShaker.Totem.Attack", params.target )
	end
end
function modifier_imba_earthshaker_enchant_totem_buff:OnCreated( kv )
	if IsServer() then
		self.particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf"
		self.effect_cast = ParticleManager:CreateParticle( self.particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )

		local attach = "attach_attack1"
		if self:GetCaster():ScriptLookupAttachment( "attach_totem" )~=0 then attach = "attach_totem" end
		ParticleManager:SetParticleControlEnt(
			self.effect_cast,
			0,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			attach,
			Vector(0,0,0), 
			true 
		)

		self:AddParticle(
			self.effect_cast,
			false,
			false,
			-1,
			false,
			false
		)
		end
end
function modifier_imba_earthshaker_enchant_totem_buff:OnRefresh( kv )
	if IsServer() then
		if self.effect_cast then
			ParticleManager:DestroyParticle(self.effect_cast, false)
			ParticleManager:ReleaseParticleIndex(self.effect_cast)	
		end	
		self:OnCreated()
	end
end
function modifier_imba_earthshaker_enchant_totem_buff:OnDestroy()
	if IsServer() then
		if self.effect_cast then
			ParticleManager:DestroyParticle(self.effect_cast, false)
			ParticleManager:ReleaseParticleIndex(self.effect_cast)	
		end
	end	
end
modifier_imba_earthshaker_enchant_totem_yidong = class({})  --移动修饰器
function modifier_imba_earthshaker_enchant_totem_yidong:IsDebuff()			return false end
function modifier_imba_earthshaker_enchant_totem_yidong:IsHidden() 			return true end
function modifier_imba_earthshaker_enchant_totem_yidong:IsPurgable() 			return false end
function modifier_imba_earthshaker_enchant_totem_yidong:IsPurgeException() 	return false end
function modifier_imba_earthshaker_enchant_totem_yidong:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_PROPERTY_MOVESPEED_LIMIT} end
function modifier_imba_earthshaker_enchant_totem_yidong:GetModifierMoveSpeed_Absolute() if IsServer() then return 1 end end
function modifier_imba_earthshaker_enchant_totem_yidong:GetModifierMoveSpeed_Limit() if IsServer() then return 1 end end
function modifier_imba_earthshaker_enchant_totem_yidong:CheckState()  return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true} end
function modifier_imba_earthshaker_enchant_totem_yidong:GetOverrideAnimation()
	if IsServer() then return end
	return ACT_DOTA_OVERRIDE_ABILITY_2
end
function modifier_imba_earthshaker_enchant_totem_yidong:OnCreated(keys)
	if IsServer() then	
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self:GetParent():MoveToPosition(self.pos)
		self.distance = (self.pos - self:GetParent():GetAbsOrigin()):Length() / (self:GetDuration() / FrameTime() - 2)
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())
	if self:GetParent():HasAbility("imba_earthshaker_echo_slam") then
			self:GetParent():FindAbilityByName("imba_earthshaker_echo_slam"):SetActivated(false)  --飞跃时回音击不可用
		end	
	end
end
function modifier_imba_earthshaker_enchant_totem_yidong:OnIntervalThink()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1)
	local height = 600
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + (self.pos - self:GetParent():GetAbsOrigin()):Normalized() * self.distance, nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)
	if self:GetParent():IsStunned() or self:GetParent():IsHexed() then
		self:Destroy()
		return
	end	
end

function modifier_imba_earthshaker_enchant_totem_yidong:OnDestroy()  --移动到目的地后添加buff修饰器
	local TalentValue = self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_6")
	if IsServer() then
		local caster = self:GetCaster()
		local ability = caster:FindAbilityByName("imba_earthshaker_aftershock")
		local ability2 = caster:FindAbilityByName("imba_earthshaker_stars_aura")
		local duration1 = (ability:GetSpecialValueFor( "cooldown" )) * self:GetCaster():GetCooldownReduction()
		if caster:TG_HasTalent("special_bonus_imba_earthshaker_6") then
			duration1 = (ability:GetSpecialValueFor( "cooldown" ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_earthshaker_6")) * self:GetCaster():GetCooldownReduction()
		end				
		self:GetParent():MoveToPositionAggressive(self.pos)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_earthshaker_enchant_totem_buff", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_earthshaker_enchant_totem_buff_sabo", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_earthshaker_enchant_totem_buff_cdbo", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})

		if self:GetCaster():FindAbilityByName("imba_earthshaker_aftershock"):IsTrained() then
			EmitSoundOn("Hero_EarthShaker.Totem", self:GetCaster())	
			self:GetCaster():FindModifierByName("modifier_imba_earthshaker_aftershock"):CastAftershock()
			if self:GetCaster():HasModifier("modifier_imba_earthshaker_aftershock") and self:GetCaster():HasScepter() and not self:GetCaster():PassivesDisabled() and not self:GetCaster():HasModifier("modifier_imba_earthshaker_aftershock_cd") then  --不在cd时运行地质形成
				self:GetCaster():FindModifierByName("modifier_imba_earthshaker_aftershock"):Aftershockspecial() --运行地质生成
				self:GetCaster():AddNewModifier(
				self:GetCaster(), 
				ability, 
				"modifier_imba_earthshaker_aftershock_cd", 
				{duration = duration1}) 				
			end 				
		end				
		if self:GetParent():HasAbility("imba_earthshaker_echo_slam") then
			self:GetParent():FindAbilityByName("imba_earthshaker_echo_slam"):SetActivated(true)  --移动后可用回音击
		end			 	
	end
end