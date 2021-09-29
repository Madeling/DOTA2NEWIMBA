CreateTalents("npc_dota_hero_luna", "ting/hero_luna")
--月光
imba_luna_lucent_beam = class({})
function imba_luna_lucent_beam:IsHiddenWhenStolen() 		return false end
function imba_luna_lucent_beam:IsRefreshable() 			return true  end
function imba_luna_lucent_beam:IsStealable() 			return true  end
function imba_luna_lucent_beam:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	local Talent = caster:TG_GetTalentValue("special_bonus_imba_luna_1")
	local  Getcd = cooldown - Talent
	if caster:TG_HasTalent("special_bonus_imba_luna_1") then
		return (Getcd)
	end
	return cooldown
end

function imba_luna_lucent_beam:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
		if self:GetCursorTarget() then
			local target = self:GetCursorTarget()
			--slf:start(是否给视野，目标，是否是点地放的，是否是大招)
			self:start(true,target,false,false)
		else
			local target = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 1}, pos, caster:GetTeamNumber(), false)
			self:start(true,target:entindex(),true,false)
		end
end


function imba_luna_lucent_beam:start(vision,tar,bool,bool_u)	--目标位置，目标，是否是点地放的，是否是大招/触发月幕
	local caster = self:GetCaster()
	local target = tar
	local enemy_count = self:GetSpecialValueFor("enemy_count")
	local enemy_flag = true --是否是生物
	local damage = self:GetSpecialValueFor("beam_damage")
	local r_radius = self:GetSpecialValueFor("r_radius")
	local v_radius = self:GetSpecialValueFor("v_radius")
	local v_duration = self:GetSpecialValueFor("v_duration")
	local stun_duration = self:GetSpecialValueFor("stun_duration") + caster:TG_GetTalentValue("special_bonus_imba_luna_4")
	local damageTable =  {
							attacker = caster,
							damage = damage,
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}
	local pfx = "particles/units/heroes/hero_luna/luna_lucent_beam.vpcf"
	if bool_u then
		pfx = "particles/econ/items/luna/luna_lucent_ti5/luna_lucent_beam_moonfall.vpcf"
		stun_duration = caster:TG_GetTalentValue("special_bonus_imba_luna_4")
	end

	--点地并且不是大就先找人，找到了对他放月光然后攻击，造成伤害
	if bool then
		target = EntIndexToHScript(tar)
		enemy_flag = false
		if not bool_u then
		local enemies1 = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, r_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
			for _,enemy1 in pairs(enemies1) do
			--	if not enemy1:IsInvisible() then
				target = enemy1
				enemy_flag = true
				break
				end
			--end
		end
	end
	--大招不开视野
	if vision and not bool_u then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), v_radius, v_duration, false)	--500高空视野
	end
	--自己就无
	if target == caster then return end
	caster:EmitSound("Hero_Luna.LucentBeam.Target")
	local particle = ParticleManager:CreateParticle(pfx, PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(particle,	5, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle,	6, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)

	if enemy_flag then
		damageTable.victim = target
		ApplyDamage(damageTable)
		if stun_duration ~= 0 then
		target:AddNewModifier_RS(caster,self,"modifier_imba_stunned",{duration = stun_duration})
		end
	end
		--月光攻击
	if enemy_flag and not bool_u then
		local enemies2 = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_BUILDING , DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy2 in pairs(enemies2) do
			if enemy_count > 0 and enemy2~=target  then
				caster:PerformAttack(enemy2, true, true, true, false, false, false, true)
				enemy_count= enemy_count - 1
			end
		end
	end
end



--月刃

imba_luna_moon_glaive = class({})

LinkLuaModifier("modifier_imba_luna_moon_glaive", "ting/hero_luna", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_luna_moon_glaive_nodmg", "ting/hero_luna", LUA_MODIFIER_MOTION_NONE)

function imba_luna_moon_glaive:GetIntrinsicModifierName() return "modifier_imba_luna_moon_glaive" end
function imba_luna_moon_glaive:Init()
	if IsServer() then
	self.bounces = self:GetSpecialValueFor("bounces")
	self.range = self:GetSpecialValueFor("range")
	self.damage_reduction = self:GetSpecialValueFor("damage_reduction_percent")
	self.damageTable=	{
						attacker = self:GetCaster(),
						ability = self,
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
						}
	end
end
function imba_luna_moon_glaive:OnUpgrade()
	if not IsServer() then return end
	if self then
		self.bounces = self:GetSpecialValueFor("bounces")
		self.range = self:GetSpecialValueFor("range")
		self.damage_reduction = self:GetSpecialValueFor("damage_reduction_percent")
	end
end

function imba_luna_moon_glaive:GlaiveAttck(source, damage, bounce)
	local target = nil
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), source:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= source then
			target = enemy
			break
		end
	end
	if target == nil then
		return
	end
	local info =
	{
		Target = target,
		Source = source,
		Ability = self,
		EffectName = self:GetCaster():GetUnitName() == "npc_dota_hero_luna" and self:GetCaster():GetRangedProjectileName() or "particles/units/heroes/hero_luna/luna_moon_glaive.vpcf",
		iMoveSpeed = (self:GetCaster():IsRangedAttacker() and self:GetCaster():GetProjectileSpeed() or 900),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
		ExtraData = {bounces = bounce, dmg = damage}
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function imba_luna_moon_glaive:OnProjectileHit_ExtraData(target, location, keys)
	local damage_reduction  = GameRules:IsDaytime()  and self.damage_reduction or 0
	local damage = keys.dmg * (1 - damage_reduction / 100)
	if target then
		target:EmitSound("Hero_Luna.MoonGlaive.Impact")
		damage=target:IsBuilding() and keys.dmg*0.1 or damage
		self.damageTable.victim = target
		self.damageTable.damage = damage
		ApplyDamage(self.damageTable)
		local bounce = keys.bounces + 1
		if bounce >= self.bounces then
			return
		end
		local next_target = target
		self:GlaiveAttck(next_target, damage, bounce)
	end
end

modifier_imba_luna_moon_glaive = class({})

function modifier_imba_luna_moon_glaive:IsDebuff()			return false end
function modifier_imba_luna_moon_glaive:IsHidden() 			return false end
function modifier_imba_luna_moon_glaive:IsPurgable() 		return false end
function modifier_imba_luna_moon_glaive:IsPurgeException() 	return false end
function modifier_imba_luna_moon_glaive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_DEATH,MODIFIER_PROPERTY_ATTACK_RANGE_BONUS} end
function modifier_imba_luna_moon_glaive:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() then
		return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("range_bonus")
	end
end
function modifier_imba_luna_moon_glaive:OnCreated()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_ambient_moon_glaive.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
		self:SetStackCount(0)
	end
end

function modifier_imba_luna_moon_glaive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsOther() or self:GetParent():PassivesDisabled()  or not keys.target:IsAlive() then
		return
	end
	local dmg = keys.original_damage
	self:GetAbility():GlaiveAttck(keys.target, dmg, 0)
end
function modifier_imba_luna_moon_glaive:OnDeath(keys)
--not self:GetCaster():IsAlive() or keys.unit~= self:GetParent()
	if not IsServer() then return end

	if keys.unit:IS_TrueHero_TG() and keys.attacker == self:GetParent() then
		self:SetStackCount(self:GetStackCount() + 1)
	end
end



--月之祝福
imba_luna_lunar_blessing = class({})
LinkLuaModifier("modifier_imba_luna_lunar_blessing", "ting/hero_luna", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lunar_blessing", "ting/hero_luna", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_luna_beam_blink", "ting/hero_luna", LUA_MODIFIER_MOTION_NONE)
function imba_luna_lunar_blessing:GetIntrinsicModifierName() return "modifier_imba_luna_lunar_blessing" end
function imba_luna_lunar_blessing:OnUpgrade()
	if not IsServer() then return end
	local mod = self:GetCaster():FindModifierByName("modifier_imba_luna_lunar_blessing")
	if mod then
		mod.cd = self:GetSpecialValueFor("cd")
	end
end
modifier_imba_luna_lunar_blessing = class({})
LinkLuaModifier("modifier_luna_beam_blink", "ting/hero_luna", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_luna_lunar_blessing:IsDebuff()			return false end
function modifier_imba_luna_lunar_blessing:IsHidden() 			return true end
function modifier_imba_luna_lunar_blessing:IsPurgable() 		return false end
function modifier_imba_luna_lunar_blessing:IsPurgeException() 	return false end
function modifier_imba_luna_lunar_blessing:IsAura() return true end
function modifier_imba_luna_lunar_blessing:GetModifierAura() return "modifier_lunar_blessing" end
function modifier_imba_luna_lunar_blessing:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_luna_6") end
function modifier_imba_luna_lunar_blessing:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_luna_lunar_blessing:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_luna_lunar_blessing:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_imba_luna_lunar_blessing:OnCreated()
	self.cd = self:GetAbility():GetSpecialValueFor("cd")
    if not IsServer() then
		return
    end
    if not  self:GetParent():IsIllusion() then
		self.count = 0
		self:GetAbility():StartCooldown(self.cd)
        self:StartIntervalThink(1)
    end
end

function modifier_imba_luna_lunar_blessing:OnIntervalThink()
	local caster = self:GetCaster()
	if not caster:IsAlive() then return end
	self.count = self.count + 1
	if self.count == self.cd  then
		local ability = caster:FindAbilityByName("imba_luna_lucent_beam")
		local enemy_count = true
		self.count = 0
		self:GetAbility():StartCooldown(self.cd )
		if ability and ability:GetLevel() > 0 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("p_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_NO_INVIS,FIND_CLOSEST, false)
			for _,enemy in pairs(enemies) do
				--if not enemy:IsInvisible() then
					ability:start(true,enemy,false,true)
					if caster:HasScepter() then
						local damageTable = {
							victim = enemy,
							attacker = caster,
							damage = caster:GetAgility()*self:GetAbility():GetSpecialValueFor("stat"),
							damage_type = self:GetAbility():GetAbilityDamageType(),
							ability = self:GetAbility(), --Optional.
							}
						ApplyDamage(damageTable)
					end
					enemy_count = false
				--end
				if not caster:HasScepter() then
					break
				end
			end
				if enemy_count or self:GetParent():HasScepter() then
				ability:start(true,caster,false,true)
				caster:AddNewModifier(caster,self:GetAbility(),"modifier_luna_beam_blink",{})
				caster:Heal(self:GetAbility():GetSpecialValueFor("heal")*caster:GetLevel(),caster)
				caster:GiveMana(self:GetAbility():GetSpecialValueFor("heal")*caster:GetLevel())
				return
			end
		end
		if enemy_count or self:GetParent():HasScepter() then
			caster:Heal(self:GetAbility():GetSpecialValueFor("heal")*caster:GetLevel(),caster)
			caster:GiveMana(self:GetAbility():GetSpecialValueFor("heal")*caster:GetLevel())
		end

	end

end
--月袭buff
modifier_luna_beam_blink = class({})
function modifier_luna_beam_blink:IsDebuff()			return false end
function modifier_luna_beam_blink:IsHidden() 			return false end
function modifier_luna_beam_blink:IsPurgable() 		return false end
function modifier_luna_beam_blink:IsPurgeException() 	return false end
function modifier_luna_beam_blink:RemoveOnDeath() 	return true end

--月之祝福buff
modifier_lunar_blessing = class({})
function modifier_lunar_blessing:IsDebuff()			return false end
function modifier_lunar_blessing:IsHidden() 			return false end
function modifier_lunar_blessing:IsPurgable() 		return false end
function modifier_lunar_blessing:IsPurgeException() 	return false end
function modifier_lunar_blessing:DeclareFunctions() return {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,MODIFIER_PROPERTY_STATS_AGILITY_BONUS,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_BONUS_NIGHT_VISION} end
function modifier_lunar_blessing:GetModifierBonusStats_Strength() 	return self:GetStackCount()  == 0 and self:GetAbility():GetSpecialValueFor("bonus_all") end
function modifier_lunar_blessing:GetModifierBonusStats_Agility() 	return self:GetStackCount()  == 1 and self:GetAbility():GetSpecialValueFor("bonus_all") end
function modifier_lunar_blessing:GetModifierBonusStats_Intellect() 	return self:GetStackCount()  == 2 and self:GetAbility():GetSpecialValueFor("bonus_all") end
function modifier_lunar_blessing:GetBonusNightVision()
	if self:GetParent() == self:GetCaster() or self:GetCaster():TG_HasTalent("special_bonus_imba_luna_3") then
		return self:GetAbility():GetSpecialValueFor("bonus_night_vision")
	end
	return 0
end

function modifier_lunar_blessing:OnCreated()
	if IsServer() then
		self:SetStackCount(self:GetParent():GetPrimaryAttribute())
	end
end


imba_luna_lunar_grace = class({})
LinkLuaModifier("modifier_luna_beam_blink", "ting/hero_luna", LUA_MODIFIER_MOTION_NONE)
function imba_luna_lunar_grace:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	if IsServer() and not GameRules:IsDaytime()  then
		cooldown = cooldown*0.5
	end

	return cooldown
end
function imba_luna_lunar_grace:IsHiddenWhenStolen() 		return false end
function imba_luna_lunar_grace:IsRefreshable() 			return true  end
function imba_luna_lunar_grace:IsStealable() 			return true  end
function imba_luna_lunar_grace:GetBehavior()
	if self:GetCaster():HasModifier("modifier_luna_beam_blink") and not self:GetCaster():IsRooted()  then
		return DOTA_ABILITY_BEHAVIOR_POINT
	else
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
end
function imba_luna_lunar_grace:OnInventoryContentsChanged()
	if not IsServer() then return end
    if self:GetCaster():Has_Aghanims_Shard() then
       self:SetHidden(false)
	   self:SetStolen(true)
--	   self:SetHidden(false)
       self:SetLevel(1)
    else
			self:SetHidden(true)
--			self:SetHidden(false)
			self:SetLevel(0)
			self:SetStolen(true)
    end
end

function imba_luna_lunar_grace:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()

	FindClearSpaceForUnit(caster, pos, true)
	caster:EmitSound("Hero_Luna.LucentBeam.Cast")
	local target = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 1}, pos, caster:GetTeamNumber(), false)
	local ability = self:GetCaster():FindAbilityByName("imba_luna_lucent_beam")
	if ability and ability:GetLevel() > 0 then
	ability:start(true,target:entindex(),true,false)
	end
	local particle = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5_gold/luna_lucent_beam_moonfall_gold.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(particle,	5, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle,	6, caster, PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)
	caster:RemoveModifierByName("modifier_luna_beam_blink")
end





--大招

imba_luna_eclipse = class({})
LinkLuaModifier( "modifier_luna_eclipse_thinker", "ting/hero_luna", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_luna_time", "ting/hero_luna", LUA_MODIFIER_MOTION_NONE )
function imba_luna_eclipse:IsHiddenWhenStolen() 		return false end
function imba_luna_eclipse:IsRefreshable() 			return true  end
function imba_luna_eclipse:IsStealable() 			return true  end
function imba_luna_eclipse:GetAOERadius() 	return	self:GetSpecialValueFor("radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_luna_5") end
function imba_luna_eclipse:GetBehavior()
	if self:GetCaster():TG_HasTalent("special_bonus_imba_luna_2")  then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_AOE
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_AOE
	end
end
function imba_luna_eclipse:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	local Talent = caster:TG_GetTalentValue("special_bonus_imba_luna_7")
	local  Getcd = cooldown - Talent
	if caster:TG_HasTalent("special_bonus_imba_luna_7") then
		return (Getcd)
	end
	return cooldown
end

function imba_luna_eclipse:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local duration = (self:GetSpecialValueFor("beams") + caster:TG_GetTalentValue("special_bonus_imba_luna_8") - 1) * self:GetSpecialValueFor("beam_interval")
	if caster:TG_HasTalent("special_bonus_imba_luna_2") then
		if self:GetCursorTarget() then
			self:GetCursorTarget():AddNewModifier(caster, self, "modifier_luna_eclipse_thinker", {duration = duration})
		else
			CreateModifierThinker(caster, self, "modifier_luna_eclipse_thinker", {Duration = duration,pos = self:GetCursorPosition()}, self:GetCursorPosition(), caster:GetTeam(), false)
		end
	else
		caster:AddNewModifier(caster, self, "modifier_luna_eclipse_thinker", {duration = duration})
	end
	caster:EmitSound("Hero_Luna.LucentBeam.Cast")

	caster:AddNewModifier(caster,self,"modifier_imba_luna_time",{duration = self:GetSpecialValueFor("night_duration")})
end


modifier_luna_eclipse_thinker = class({})
LinkLuaModifier( "modifier_imba_luna_mag", "ting/hero_luna", LUA_MODIFIER_MOTION_NONE )
function modifier_lunar_blessing:IsDebuff()			return false end
function modifier_lunar_blessing:IsHidden() 			return false end
function modifier_luna_eclipse_thinker:OnCreated(keys)
	local caster = self:GetCaster()
	self.interval = self:GetAbility():GetSpecialValueFor("beam_interval")
	self.radius = self:GetAbility():GetSpecialValueFor("radius") +caster:TG_GetTalentValue("special_bonus_imba_luna_5")
	self.hits =  self:GetAbility():GetSpecialValueFor("beams") + caster:TG_GetTalentValue("special_bonus_imba_luna_8")
	local eclipse_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_eclipse.vpcf", PATTACH_POINT, self:GetParent())
	ParticleManager:SetParticleControl(eclipse_particle, 1, Vector(self.radius, 0, 0))

	if keys.x then
		self.target_position = Vector(keys.x, keys.y, keys.z)
		ParticleManager:SetParticleControl(eclipse_particle, 0, self.target_position)
	end
	self:AddParticle(eclipse_particle, false, false, -1, false, false)

	if IsServer() then
		self.lucent = caster:FindAbilityByName("imba_luna_lucent_beam")
		self.glaive = caster:FindAbilityByName("imba_luna_moon_glaive")
		GameRules:BeginTemporaryNight( self:GetAbility():GetSpecialValueFor("night_duration") )
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(),self.radius , self:GetAbility():GetSpecialValueFor("night_duration"), false)	--高空视野
		self:StartIntervalThink(self.interval)

	end
end

function modifier_luna_eclipse_thinker:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local position = parent:GetAbsOrigin()

	local search_flag = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local search_flag_scept = DOTA_UNIT_TARGET_HERO

	local search_type = FIND_ANY_ORDER
	local search_type_scept = FIND_CLOSEST
	local enemy_count = true
	if self.lucent and self.lucent:GetLevel()>0 then
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, caster:HasScepter() and search_flag_scept or search_flag , DOTA_UNIT_TARGET_FLAG_NO_INVIS, caster:HasScepter() and search_type_scept or search_type, false)
	for _,enemy in pairs(enemies) do
		self.lucent:start(nil,enemy,false,true)
		if self:GetAbility():GetAutoCastState() then
				enemy:AddNewModifier(caster,self:GetAbility(),"modifier_imba_luna_mag",{duration = 10})
		else
			local enemies2 = FindUnitsInRadius(enemy:GetTeamNumber(), enemy:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
			for k = 1,#enemies2,1 do
				if enemies2[k] ~= enemy  then
					caster:PerformAttack(enemies2[k], true, true, true, false, false, false, true)
				break
			end
		end
		end
		enemy_count = false
		break
	end
	if enemy_count then
	local pos = GetRandomPosition2D(position,self.radius)
	local target = CreateModifierThinker(caster, self:GetAbility(), "modifier_dummy_thinker", {duration = 1}, pos, caster:GetTeamNumber(), false)
	self.lucent:start(false,target:entindex(),true,true)
	end
	end
end

function modifier_luna_eclipse_thinker:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_luna_eclipse_thinker:IsPurgable()
	return false
end

modifier_imba_luna_time = class({})
function modifier_imba_luna_time:IsDebuff() return false end
function modifier_imba_luna_time:IsHidden() return false end
function modifier_imba_luna_time:IsPurgable() return false end
function modifier_imba_luna_time:IsPurgeException() return false end
function modifier_imba_luna_time:OnCreated()
	self.movespeed = self:GetAbility():GetSpecialValueFor("move_sp")
end

function modifier_imba_luna_time:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end


function modifier_imba_luna_time:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end

modifier_imba_luna_mag = class({})
function modifier_imba_luna_mag:IsDebuff() return false end
function modifier_imba_luna_mag:IsHidden() return false end
function modifier_imba_luna_mag:IsPurgable() return false end
function modifier_imba_luna_mag:IsPurgeException() return false end
function modifier_imba_luna_mag:OnCreated()
	self.mag = self:GetAbility():GetSpecialValueFor("mag")
	if IsServer() then
		self:SetStackCount(0)
		self:OnRefresh()
	end

end
function modifier_imba_luna_mag:OnRefresh()
	self:SetStackCount(self:GetStackCount() + 1)
end

function modifier_imba_luna_mag:DeclareFunctions()
	return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end


function modifier_imba_luna_mag:GetModifierMagicalResistanceBonus()
	return -self.mag*self:GetStackCount()
end