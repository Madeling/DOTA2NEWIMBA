CreateTalents("npc_dota_hero_lich", "ting/hero_lich")

imba_lich_frost_nova = class({})
LinkLuaModifier("modifier_imba_frost_nova_slow", "ting/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_nova_aura", "ting/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_nova_passvie", "ting/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_nova_slow", "ting/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_nova_frozen", "ting/hero_lich", LUA_MODIFIER_MOTION_NONE)
function imba_lich_frost_nova:GetCastPoint()			
    if self:GetCaster():TG_HasTalent("special_bonus_imba_lich_7") then
        return self:GetCaster():TG_GetTalentValue("special_bonus_imba_lich_7")
    else
        return 0.35
    end
end

function imba_lich_frost_nova:OnSpellStart()
	local caster = self:GetCaster()
	--local target = self:GetCursorTarget()
	
	local caster = self:GetCaster()
	local direction = (self:GetCursorPosition()+Vector(1,1,1) - caster:GetAbsOrigin()):Normalized()
	direction.z = 0.0
	caster:EmitSound("Hero_Mirana.ArrowCast")
	--local thinker = CreateModifierThinker(caster, self, "modifier_imba_mirana_arrow_thinker", {}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false):entindex()
	caster:EmitSound("Hero_Mirana.Arrow")
	local info = 
	{
		Ability = self,
		EffectName = "particles/heros/lich/imba_lich_nov.vpcf",
		
		--EffectName = "particles/econ/items/mirana/mirana_crescent_arrow/mirana_spell_crescent_arrow.vpcf"
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = 2000 + caster:GetCastRangeBonus(),
		fStartRadius = 150,
		fEndRadius = 150,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = true,
		vVelocity = direction * 1800,
		bProvidesVision = false,
		--ExtraData = {thinker = thinker}
	}
	ProjectileManager:CreateLinearProjectile(info)

	

	--Lich_Frost_Nova_Blast(caster, target, self)
end


function imba_lich_frost_nova:OnProjectileThink_ExtraData(location, keys)
	AddFOWViewer(self:GetCaster():GetTeam(), location, 250, 0.03, false)
end

function imba_lich_frost_nova:OnProjectileHit_ExtraData(target, location, keys)
	local kill_creeps = self:GetCaster():HasScepter() or not GameRules:IsDaytime()
	if not target then
		return true
	end

	--AddFOWViewer(self:GetCaster():GetTeam(), location, self:GetSpecialValueFor("arrow_vision"), stun_duration, false)
	--SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, dmg_done, nil)
	Lich_Frost_Nova_Blast(self:GetCaster(), target, self)
	return true
end


function Lich_Frost_Nova_Blast(caster, target, ability)
	--特效

	local pfx_name = "particles/units/heroes/hero_lich/lich_frost_nova.vpcf"
	local sound_name = "Ability.FrostNova"
	local radius = ability:GetSpecialValueFor("radius")
	local damage =  ability:GetSpecialValueFor("target_damage")
	local damageTable = {
							attacker = caster,
							damage_type = ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = ability, --Optional.
							}
	--if HeroItems:UnitHasItem(caster, "lich_ti6") then
	--	pfx_name = "particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf"
	--	sound_name = "Hero_Lich.FrostBlast.Immortal"
	--end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil,radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius,radius, radius))
	local duration = ability:GetSpecialValueFor("slow_duration")
	local per = math.max((target:GetBaseMoveSpeed() - target:GetIdealSpeed())/(target:GetBaseMoveSpeed() - 100),0)
		damageTable.victim = target
		damageTable.damage = damage+caster:GetIntellect()*ability:GetSpecialValueFor("damage_per")*per

		ApplyDamage(damageTable)
	
		for _, enemy in pairs(enemies) do
			damageTable.victim = enemy
			damageTable.damage = damage

		ApplyDamage(damageTable)
		enemy:AddNewModifier_RS(caster, ability, "modifier_imba_frost_nova_slow", {duration = duration})
		enemy:AddNewModifier_RS(caster, ability, "modifier_imba_frost_nova_frozen", {duration = per})
	end
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), sound_name, target)
end

modifier_imba_frost_nova_slow = class({})

function modifier_imba_frost_nova_slow:IsDebuff()			return true end
function modifier_imba_frost_nova_slow:IsHidden() 			return false end
function modifier_imba_frost_nova_slow:IsPurgable() 		return true end
function modifier_imba_frost_nova_slow:IsPurgeException() 	return true end
function modifier_imba_frost_nova_slow:GetStatusEffectName() return "particles/status_fx/status_effect_frost_lich.vpcf" end
function modifier_imba_frost_nova_slow:StatusEffectPriority() return 15 end
function modifier_imba_frost_nova_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_frost_nova_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self.mslow) end
function modifier_imba_frost_nova_slow:GetModifierAttackSpeedBonus_Constant() return (0 - self.aslow) end
function modifier_imba_frost_nova_slow:OnCreated()
	self.mslow = self:GetAbility():GetSpecialValueFor("slow_movement_speed")
	self.aslow = self:GetAbility():GetSpecialValueFor("slow_attack_speed")
end
function modifier_imba_frost_nova_slow:OnDestroy()
	self.mslow = nil
	self.aslow = nil
end


modifier_imba_frost_nova_frozen = class({})

function modifier_imba_frost_nova_frozen:IsDebuff()			return true end
function modifier_imba_frost_nova_frozen:IsHidden() 			return false end
function modifier_imba_frost_nova_frozen:IsPurgable() 		return true end
function modifier_imba_frost_nova_frozen:IsPurgeException() 	return true end
function modifier_imba_frost_nova_frozen:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_frosty_l2_dire.vpcf"
end

function modifier_imba_frost_nova_frozen:StatusEffectPriority()
	return 11
end

function modifier_imba_frost_nova_frozen:GetEffectName()
	return "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff_model.vpcf"
end


function modifier_imba_frost_nova_frozen:CheckState()
		local state = { [MODIFIER_STATE_STUNNED] = true,
						[MODIFIER_STATE_FROZEN] = true}
		return state
end



imba_lich_frost_armor = class({})

LinkLuaModifier("modifier_imba_frost_armor", "ting/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_armor_slow", "ting/hero_lich", LUA_MODIFIER_MOTION_NONE)

function imba_lich_frost_armor:IsHiddenWhenStolen() 	return false end
function imba_lich_frost_armor:IsRefreshable() 			return true  end
function imba_lich_frost_armor:IsStealable() 			return true  end
function imba_lich_frost_armor:IsNetherWardStealable()	return true end
function imba_lich_frost_armor:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	local Talent = caster:TG_GetTalentValue("special_bonus_imba_lich_3")
	local  Getcd = cooldown - Talent
	if caster:TG_HasTalent("special_bonus_imba_lich_3") then 
		return (Getcd)
	end
	return cooldown
end
function imba_lich_frost_armor:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	target:RemoveModifierByName("modifier_imba_frost_armor")
	target:AddNewModifier(caster, self, "modifier_imba_frost_armor", {duration = self:GetSpecialValueFor("duration")})
	target:EmitSound("Imba.Hero_Lich.Frost_Armor")

end
--modifier_lich_ice_spire
modifier_imba_frost_armor = class({})

function modifier_imba_frost_armor:IsDebuff()			return false end
function modifier_imba_frost_armor:IsHidden() 			return false end
function modifier_imba_frost_armor:IsPurgable() 		return true end
function modifier_imba_frost_armor:IsPurgeException() 	return true end
function modifier_imba_frost_armor:GetStatusEffectName() return "particles/status_fx/status_effect_frost_armor.vpcf" end
function modifier_imba_frost_armor:StatusEffectPriority() return 10 end
function modifier_imba_frost_armor:GetEffectName() return "particles/hero/lich/lich_frost_armor.vpcf" end
function modifier_imba_frost_armor:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_frost_armor:ShouldUseOverheadOffset() return true end
function modifier_imba_frost_armor:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_EVENT_ON_TAKEDAMAGE,MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE} end
function modifier_imba_frost_armor:GetModifierPhysicalArmorBonus() return self.armor end
function modifier_imba_frost_armor:GetModifierIncomingPhysicalDamage_Percentage() return self.dmg_re end

function modifier_imba_frost_armor:OnCreated()

	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.armor = self.ability:GetSpecialValueFor("armor_bonus")
	self.stack = self.ability:GetSpecialValueFor("blast_duration")
	self.radius = self.ability:GetSpecialValueFor("blast_radius")
	self.duration = self.ability:GetSpecialValueFor("slow_duration")
	self.bdamage = self.ability:GetSpecialValueFor("blast_damage")
	self.dmg_re = self.ability:GetSpecialValueFor("damage_re")*-1
	self.t = true
	if IsServer() then
	self:SetStackCount(self.stack)
	if string.find(self.parent:GetUnitName(), "npc_dota_lich_ice_spire") then
		self:StartIntervalThink(1)
	end
	self.damageTable = {
					attacker = self.caster, 
					damage = self.bdamage,
					damage_type = self.ability:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE
					}
	end
	
end


function modifier_imba_frost_armor:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit == self.parent and keys.attacker:IsHero()  and self.t and (self.parent:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Length2D() < self.radius then
		self:OnIntervalThink()
		self:StartIntervalThink(1.0)
		self.parent:EmitSound("Hero_Lich.IceAge")
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_ice_age.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(pfx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 2, Vector(self.radius,self.radius,self.radius))
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end

function modifier_imba_frost_armor:OnIntervalThink()
	self.t = false
	self:SetStackCount(self:GetStackCount() - 1)
	self.parent:EmitSound("Hero_Lich.IceAge.Tick")
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_ice_age_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(pfx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 2, Vector(self.radius,self.radius,self.radius))
	ParticleManager:ReleaseParticleIndex(pfx)
	local enemy = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i=1, #enemy do
		enemy[i]:AddNewModifier_RS(self.caster, self.ability, "modifier_imba_frost_armor_slow", {duration = self.duration})
		enemy[i]:EmitSound("Hero_Lich.IceAge.Damage")
		self.damageTable.victim = enemy[i]
		ApplyDamage(self.damageTable)
	end
	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end

modifier_imba_frost_armor_slow = class({})

function modifier_imba_frost_armor_slow:IsDebuff()			return true end
function modifier_imba_frost_armor_slow:IsHidden() 			return false end
function modifier_imba_frost_armor_slow:IsPurgable() 		return true end
function modifier_imba_frost_armor_slow:IsPurgeException() 	return true end
function modifier_imba_frost_armor_slow:GetStatusEffectName() return "particles/status_fx/status_effect_frost.vpcf" end
function modifier_imba_frost_armor_slow:StatusEffectPriority() return 15 end
function modifier_imba_frost_armor_slow:GetEffectName() return "particles/units/heroes/hero_lich/lich_ice_age_debuff.vpcf" end
function modifier_imba_frost_armor_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_frost_armor_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_frost_armor_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self.mslow) end
function modifier_imba_frost_armor_slow:GetModifierAttackSpeedBonus_Constant() return (0 - self.aslow) end

function modifier_imba_frost_armor_slow:OnCreated()
	self.mslow = self:GetAbility():GetSpecialValueFor("slow_movement_speed")
	self.aslow = self:GetAbility():GetSpecialValueFor("slow_attack_speed")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_lich_5")
end
function modifier_imba_frost_armor_slow:OnDestroy()
	self.mslow = nil
	self.aslow = nil
end

imba_lich_sinister_gaze = class({})

LinkLuaModifier("modifier_imba_sinister_gaze_caster", "ting/hero_lich.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sinister_gaze_target", "ting/hero_lich.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_armor_slow", "ting/hero_lich.lua", LUA_MODIFIER_MOTION_NONE)
function imba_lich_sinister_gaze:IsHiddenWhenStolen() 		return false end
function imba_lich_sinister_gaze:IsRefreshable() 			return true end
function imba_lich_sinister_gaze:IsStealable() 				return true end
function imba_lich_sinister_gaze:IsNetherWardStealable()	return true end

function imba_lich_sinister_gaze:OnSpellStart()
	self.caster = self:GetCaster()
	self.target = self:GetCursorTarget()
	self.duration = self:GetSpecialValueFor("duration")
	if self.target:TriggerStandardTargetSpell(self) then
		return
	end
	self.caster:AddNewModifier(self.target, self, "modifier_imba_sinister_gaze_caster", {duration = self.duration})
	self.target:RemoveModifierByName("modifier_imba_sinister_gaze_target")
	self.target:AddNewModifier_RS(self.caster, self, "modifier_imba_sinister_gaze_target", {duration = self.duration})
	if self.caster:TG_HasTalent("special_bonus_imba_lich_4") then
		self.caster:Stop()
	end
	--[[if self:GetCaster():HasScepter() then 
		-- find enemies
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self.target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		--radius sinister_gaze
		for _,enemy in pairs(enemies) do
			-- find the first occurence
			if enemy ~= self.target then 
				enemy:EmitSound("Hero_Lich.SinisterGaze.Target")
				enemy:RemoveModifierByName("modifier_imba_sinister_gaze_target")
				enemy:AddNewModifier(caster, self, "modifier_imba_sinister_gaze_target", { duration = self:GetChannelTime()})
			end
		end
	end]]
end

function imba_lich_sinister_gaze:OnChannelThink(flInterval)
	if not self.target:HasModifier("modifier_imba_sinister_gaze_target") then
		self:EndChannel(false)
	end
end

function imba_lich_sinister_gaze:OnChannelFinish(bInterrupted)
	if self.caster:TG_HasTalent("special_bonus_imba_lich_4") then
		return
	end
	
	self.caster:RemoveModifierByName("modifier_imba_sinister_gaze_caster")	
	self.target:RemoveModifierByName("modifier_imba_sinister_gaze_target")
	if not self.target:IsAlive() then return end

			--self.target:AddNewModifier("")
end


modifier_imba_sinister_gaze_caster = class({})

function modifier_imba_sinister_gaze_caster:IsDebuff()			return false end
function modifier_imba_sinister_gaze_caster:IsHidden() 			return true end
function modifier_imba_sinister_gaze_caster:IsPurgable() 		return false end
function modifier_imba_sinister_gaze_caster:IsPurgeException() 	return false end
function modifier_imba_sinister_gaze_caster:GetEffectName() return "particles/units/heroes/hero_lich/lich_gaze_eyes.vpcf" end
function modifier_imba_sinister_gaze_caster:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_sinister_gaze_caster:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
	if IsServer() then
		self.parent:EmitSound("Hero_Lich.SinisterGaze.Cast")
		self:StartIntervalThink(0.2)
		self:OnIntervalThink()
	end
end
function modifier_imba_sinister_gaze_caster:OnIntervalThink()
	if IsServer() then
		local mod = self.caster:FindModifierByName("modifier_imba_sinister_gaze_target")
		if mod and self.ability:GetAutoCastState() then
			local friend = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				for _,f in pairs(friend) do
					if f:HasModifier("modifier_imba_chain_frost") and f~= self.caster then
						mod.tar = f
						return
					end
				end	
				local ice = FindUnitsInRadius(self.parent:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				for _,i in pairs(ice) do
					if string.find(i:GetUnitName(), "npc_dota_lich_ice_spire") then
						mod.tar = i
						return
					end
				end	
			mod.tar = self.parent
		end
	end
end
function modifier_imba_sinister_gaze_caster:OnDestroy()
	if IsServer() then
		self.parent:StopSound("Hero_Lich.SinisterGaze.Cast")
	end
end

modifier_imba_sinister_gaze_target = class({})
LinkLuaModifier("modifier_paralyzed", "ting/hero_lich", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_sinister_gaze_target:IsDebuff()			return true end
function modifier_imba_sinister_gaze_target:IsHidden() 			return false end
function modifier_imba_sinister_gaze_target:IsPurgable() 		return true end
function modifier_imba_sinister_gaze_target:IsPurgeException() 	return true end
function modifier_imba_sinister_gaze_target:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_FROZEN] = true} end
function modifier_imba_sinister_gaze_target:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_sinister_gaze_target:GetModifierMoveSpeedBonus_Percentage() return -100 end



function modifier_imba_sinister_gaze_target:OnCreated()
		
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		self.tar = self:GetCaster()
		self.destination = self.ability:GetSpecialValueFor("destination")
		self.duration = self.ability:GetSpecialValueFor("finish_duration")
		self.next_pos = nil
		if IsServer() then
		self.parent:EmitSound("Hero_Lich.SinisterGaze.Target")
		local pfx_name = "particles/units/heroes/hero_lich/lich_gaze.vpcf"
		--if HeroItems:UnitHasItem(self:GetCaster(), "lich_ti10_immortal_head") then
		--	pfx_name = "particles/econ/items/lich/lich_ti10_immortal_head/lich_ti10_immortal_gaze.vpcf"
		--end
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_portrait", self:GetCaster():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_sinister_gaze_target:OnIntervalThink()
	if IsServer() then
	if self.caster:TG_HasTalent("special_bonus_imba_lich_4") then
		if self.caster:IsSilenced() or self.caster:IsStunned() then
			self.parent:RemoveModifierByName("modifier_imba_sinister_gaze_target")
		end
	end
	local des = self.destination
	if self.tar ~= self.caster then
		des = des*2
	end
	local direction = GetDirection2D(self.tar:GetAbsOrigin(), self.parent:GetAbsOrigin())
	local distance = des / (1.0 / FrameTime())
	self.next_pos = GetGroundPosition(self.parent:GetAbsOrigin() + direction * distance, self.parent)
	self.parent:SetForwardVector(direction)
	self.parent:SetOrigin(self.next_pos)
	end
end

function modifier_imba_sinister_gaze_target:OnDestroy()
	if IsServer() then
		self.parent:StopSound("Hero_Lich.SinisterGaze.Target")
		self.caster:RemoveModifierByName("modifier_imba_sinister_gaze_caster")
		self.parent:AddNewModifier(self.caster,self.ability,"modifier_paralyzed",{duration = self.duration})
		GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), 200, false)
		FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
		
	end
end


imba_lich_chain_frost = class({})

LinkLuaModifier("modifier_imba_chain_frost", "ting/hero_lich", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_paralyzed", "ting/hero_lich", LUA_MODIFIER_MOTION_NONE)
function imba_lich_chain_frost:IsHiddenWhenStolen() 	return false end
function imba_lich_chain_frost:IsRefreshable() 			return true  end
function imba_lich_chain_frost:IsStealable() 			return true  end
function imba_lich_chain_frost:IsNetherWardStealable()	return true end

function imba_lich_chain_frost:OnSpellStart()
	self.caster = self:GetCaster()
	self.damage = self.caster:HasScepter() and self:GetSpecialValueFor("damage_scepter") or self:GetSpecialValueFor("damage")
	self.speed_increase = self.caster:HasScepter() and self:GetSpecialValueFor("speed_per_bounce_scepter") or self:GetSpecialValueFor("speed_per_bounce")
	self.radius = self.caster:HasScepter() and self:GetSpecialValueFor("jump_range_scepter") or self:GetSpecialValueFor("jump_range")
	self.dmg_increase = self:GetSpecialValueFor("bounces_dmg")
	self.bounces = self:GetSpecialValueFor("bounces")+self.caster:TG_GetTalentValue("special_bonus_imba_lich_6")
	local target = self:GetCursorTarget()
	local speed = self:GetSpecialValueFor("projectile_speed")
	local pfx_name = "particles/units/heroes/hero_lich/lich_chain_frost.vpcf"
	local sound_name = "Hero_Lich.ChainFrost"
	--if HeroItems:UnitHasItem(caster, "lich_ti8") then
	--	pfx_name = "particles/econ/items/lich/lich_ti8_immortal_arms/lich_ti8_chain_frost.vpcf"
	--	sound_name = "Hero_Lich.ChainFrost.TI8"
	--end
	self.damageTable = {
						attacker = self:GetCaster(),
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self, --Optional.
						}
	self.info = {	
				Ability = self,	
				EffectName = pfx_name,
				bDrawsOnMinimap = false,                          -- Optional
				bDodgeable = false,                                -- Optional
				bIsAttack = false,                                -- Optional
				bVisibleToEnemies = true,                         -- Optional
				bReplaceExisting = false,                         -- Optional
				bProvidesVision = false,                           -- Optional				
				}
		self.info.Target = target
		self.info.Source = self.caster
		self.info.iMoveSpeed = speed
		self.info.vSourceLoc= self.caster:GetAbsOrigin()
		self.info.ExtraData = {speed = speed, first = 1, bounces = 0,damage = self.damage}

	ProjectileManager:CreateTrackingProjectile(self.info)
	self.caster:EmitSound(sound_name)
end

function imba_lich_chain_frost:OnProjectileThink_ExtraData(location, keys)
	AddFOWViewer(self.caster:GetTeamNumber(), location, self:GetSpecialValueFor("vision_radius"), FrameTime(), false)
end

function imba_lich_chain_frost:OnProjectileHit_ExtraData(target, location, keys)
	local bounces = keys.bounces + 1
	local interval = math.max(self:GetSpecialValueFor("bounce_delay") - 0.01 * bounces, 0)
	local speed = keys.speed + self.speed_increase
	local dmg = keys.damage + self.dmg_increase
	local stop = true
	if keys.first == 1 then
		target:TriggerSpellReflect(self)
		target:TriggerSpellAbsorb(self)
		target:InterruptChannel()
		target:EmitSound("Hero_Lich.ChainFrostImpact.Hero")
	end
	target:EmitSound("Hero_Lich.IceAge.Damage")
	
	if not string.find(target:GetUnitName(), "npc_dota_lich_ice_spire") then
	target:AddNewModifier_RS(self.caster, self, "modifier_imba_chain_frost", {duration = self:GetSpecialValueFor("slow_duration")})
	end
	if IsNearEnemyFountain(target:GetAbsOrigin(), self.caster:GetTeamNumber(), 1100) then
		speed = self:GetSpecialValueFor("speed_fountain")
	end
	
		self.damageTable.victim = target
		self.damageTable.damage = string.find(target:GetUnitName(), "npc_dota_lich_ice_spire") and 0 or dmg
		ApplyDamage(self.damageTable)
	if self.caster:TG_HasTalent("special_bonus_imba_lich_2") then
		target:AddNewModifier_RS(self.caster, self, "modifier_paralyzed", {duration = self.caster:TG_GetTalentValue("special_bonus_imba_lich_2")})
	end
	 --结束
	if bounces > self.bounces  then
		return false
	end
	
	local hero_got = false
	local next_target = nil
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), location, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= target then
			next_target = enemy
			hero_got = true
			break
		end
	end
	if not hero_got then
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), location, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		for _, enemy in pairs(enemies) do
			if enemy ~= target and not string.find(enemy:GetUnitName(), "npc_dota_unit_undying_zombie") then
				next_target = enemy
				break
			end
		end
	end
	
	if next_target == nil  then
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), location, nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		for _, enemy in pairs(enemies) do
			if enemy ~= target and string.find(enemy:GetUnitName(), "npc_dota_lich_ice_spire") then
				next_target = enemy
				break
			end
		end
	end
	
		if next_target~=nil then
	if string.find(next_target:GetUnitName(), "npc_dota_lich_ice_spire") and string.find(target:GetUnitName(), "npc_dota_lich_ice_spire") then
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), location, nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		for _, enemy in pairs(enemies) do
			if enemy ~= target and string.find(enemy:GetUnitName(), "npc_dota_lich_ice_spire") then
				local enemies2 = FindUnitsInRadius(self.caster:GetTeamNumber(),next_target:GetOrigin() , nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
					for _, enemy2 in pairs(enemies2) do
					if enemy2~=nil and not string.find(enemy:GetUnitName(), "npc_dota_unit_undying_zombie") then
				--print("1234444")
					stop = false
					next_target = enemy
					break
					end
				
				--next_target = enemy
				--stop = true
			end
			end

		end 
	end
	end
	if next_target~=nil then
	if string.find(next_target:GetUnitName(), "npc_dota_lich_ice_spire") and string.find(target:GetUnitName(), "npc_dota_lich_ice_spire") then
		--print("123")
		if stop == true  then next_target = nil end
	end
	end
	
	if next_target then
		local pfx_name = "particles/units/heroes/hero_lich/lich_chain_frost.vpcf"
		--if HeroItems:UnitHasItem(self.caster, "lich_ti8") then
		--	pfx_name = "particles/econ/items/lich/lich_ti8_immortal_arms/lich_ti8_chain_frost.vpcf"
		--end
		self.info.Target = next_target
		self.info.Source = target
		self.info.iMoveSpeed = speed
		self.info.vSourceLoc= location
		self.info.ExtraData = {speed = speed, first = 0, bounces = bounces,damage = dmg}

		Timers:CreateTimer(interval, function()
			ProjectileManager:CreateTrackingProjectile(self.info)
		end)
		return true
	end
end

modifier_imba_chain_frost = class({})

function modifier_imba_chain_frost:IsDebuff()			return true end
function modifier_imba_chain_frost:IsHidden() 			return false end
function modifier_imba_chain_frost:IsPurgable() 		return true end
function modifier_imba_chain_frost:IsPurgeException() 	return true end
function modifier_imba_chain_frost:RemovOnDeath()		return false end
function modifier_imba_chain_frost:GetStatusEffectName() return "particles/status_fx/status_effect_frost_lich.vpcf" end
function modifier_imba_chain_frost:StatusEffectPriority() return 15 end
function modifier_imba_chain_frost:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_chain_frost:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("slow_movement_speed")) end
function modifier_imba_chain_frost:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("slow_attack_speed")) end
function modifier_imba_chain_frost:OnCreated()
	self.mslow = self:GetAbility():GetSpecialValueFor("slow_movement_speed")
	self.aslow = self:GetAbility():GetSpecialValueFor("slow_attack_speed")
end
function modifier_imba_chain_frost:OnDeath(keys)
	if IsServer() and keys.unit == self:GetParent() and  self:GetParent():IsRealHero() then
		if not self:GetCaster():TG_HasTalent("special_bonus_imba_lich_1")   then 
			return 
		end
		if self:GetParent():HasModifier("modifier_imba_chain_frost") and not string.find(keys.unit:GetUnitName(), "npc_dota_lich_ice_spire") then
			local summon = CreateUnitByName("npc_dota_lich_ice_spire", self:GetParent():GetOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeam())
			summon:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			summon:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = self:GetCaster():TG_GetTalentValue("special_bonus_imba_lich_1")})
		end
	end
end
function modifier_imba_chain_frost:OnDestroy()
	self.mslow = nil
	self.aslow = nil
end

modifier_paralyzed = class({})

function modifier_paralyzed:IsDebuff()			return true end
function modifier_paralyzed:IsHidden() 			return false end
function modifier_paralyzed:IsPurgable() 		return true end
function modifier_paralyzed:IsPurgeException() 	return true end
function modifier_paralyzed:GetEffectName() return "particles/basic_ambient/generic_paralyzed.vpcf" end
function modifier_paralyzed:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_paralyzed:ShouldUseOverheadOffset() return true end

function modifier_paralyzed:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_PROPERTY_MOVESPEED_LIMIT, MODIFIER_PROPERTY_MOVESPEED_MAX, MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT} end
function modifier_paralyzed:GetModifierMoveSpeed_Absolute() return 100 end
function modifier_paralyzed:GetModifierMoveSpeed_Limit() return 100 end
function modifier_paralyzed:GetModifierMoveSpeed_Max() return 100 end
function modifier_paralyzed:GetModifierBaseAttackTimeConstant() return 3.5 end



--冰柱
imba_lich_ice_spire = class({})
LinkLuaModifier("modifier_imba_frost_armor", "ting/hero_lich", LUA_MODIFIER_MOTION_NONE)

function imba_lich_ice_spire:IsHiddenWhenStolen() 		return false end
function imba_lich_ice_spire:IsRefreshable() 			return true  end
function imba_lich_ice_spire:IsStealable() 			return true  end

function imba_lich_ice_spire:OnInventoryContentsChanged()
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

function imba_lich_ice_spire:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local hp = caster:GetMaxHealth()
	local armor = caster:GetPhysicalArmorValue(false)
	local light = CreateUnitByName("npc_dota_lich_ice_spire", pos, true, caster, caster, caster:GetTeamNumber())
		  light:SetOwner(caster)
		  light:SetBaseMaxHealth(hp)
		  light:SetMaxHealth(hp)
		  light:SetHealth(hp)
		  light:SetPhysicalArmorBaseValue(armor)
		  light:SetMaximumGoldBounty(300)
		  light:SetMinimumGoldBounty(200)
		  light:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("duration")})
		  light:AddNewModifier(caster, self, "modifier_lich_ice_spire", {duration = self:GetSpecialValueFor("duration")})
	local ab = caster:FindAbilityByName("imba_lich_frost_armor")
	if ab and ab:GetLevel() > 0 and caster:TG_HasTalent("special_bonus_imba_lich_8") then
		local mod = light:AddNewModifier(caster, ab, "modifier_imba_frost_armor", {duration = ab:GetSpecialValueFor("duration")})
		if mod then	
			mod:OnIntervalThink()
			mod:StartIntervalThink(1)
		end
	end
	
end


