--2021 01 13 by MysticBug-------
--------------------------------
--------------------------------
CreateTalents("npc_dota_hero_riki", "mb/hero_riki/riki_smoke_screen")
--------------------------------------------------------------
--		   		 IMBA_RIKI_SMOKE_SCREEN                	    --
--------------------------------------------------------------

imba_riki_smoke_screen = class({})

LinkLuaModifier("modifier_imba_riki_smoke_screen", "mb/hero_riki/riki_smoke_screen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_smoke_screen_aura", "mb/hero_riki/riki_smoke_screen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_smoke_screen_aura_debuff", "mb/hero_riki/riki_smoke_screen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_smoke_screen_aura_buff", "mb/hero_riki/riki_smoke_screen", LUA_MODIFIER_MOTION_NONE)
--
LinkLuaModifier("modifier_imba_riki_mode_switch","mb/hero_riki/riki_mode_switch", LUA_MODIFIER_MOTION_NONE)

function imba_riki_smoke_screen:IsHiddenWhenStolen()	return false end
function imba_riki_smoke_screen:IsRefreshable()			return true end
function imba_riki_smoke_screen:IsStealable() 			return true end
function imba_riki_smoke_screen:IsNetherWardStealable()	return false end
function imba_riki_smoke_screen:GetCastRange(location, target) --已经计算过额外施法距离
	return self.BaseClass.GetCastRange(self, location, target)
end
function imba_riki_smoke_screen:GetAOERadius(iLevel)
	return self:GetSpecialValueFor("radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_riki_1")
end

function imba_riki_smoke_screen:GetAbilityTextureName()	
	if self:GetCaster():HasModifier("modifier_imba_riki_mode_switch") then  
		local mode_type = self:GetCaster():GetModifierStackCount("modifier_imba_riki_mode_switch", nil) or 1
		--返回对应技能图标
		return "riki/riki_smoke_screen"..mode_type
	else
		return "riki/riki_smoke_screen1"
	end 
end
function imba_riki_smoke_screen:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/riki/riki_head_ti8_gold/riki_smokebomb_ti8_gold.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/riki/riki_head_ti8/riki_smokebomb_ti8_crimson.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_riki/riki_smokebomb.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_riki.vsndevts", context )
end

function imba_riki_smoke_screen:GetBehavior()
	if self:GetCaster():TG_HasTalent("special_bonus_imba_riki_4") then
		return (DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL)
	else
		return (DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING)
	end
end

function imba_riki_smoke_screen:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = caster:TG_HasTalent("special_bonus_imba_riki_4") and self:GetCursorTarget() or caster
		local target_point = self:GetCursorPosition()
		--KV
		local duration = self:GetSpecialValueFor("duration")
		local poisoned_damage = self:GetSpecialValueFor("poisoned_damage")
		local aoe = self:GetSpecialValueFor("radius") + caster:TG_GetTalentValue("special_bonus_imba_riki_1")
		local modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_riki_mode_switch", caster)
		--extra set
		local mode_type = 1
		if modifier ~= nil then 
			mode_type = modifier:GetStackCount() or 1
		end
		local smoke_particle = "particles/econ/items/riki/riki_head_ti8/riki_smokebomb_ti8_crimson.vpcf"
		local smoke_aura = "modifier_imba_smoke_screen_aura"
		--local smoke_sound = "Hero_Riki.Smoke_Screen"
		local smoke_sound = "Hero_Riki.Smoke_Screen.ti8"
		if mode_type == 2 then 
			smoke_particle = "particles/econ/items/riki/riki_head_ti8_gold/riki_smokebomb_ti8_gold.vpcf"
		elseif mode_type == 3 then 
			smoke_particle = "particles/econ/items/riki/riki_head_ti8/riki_smokebomb_ti8.vpcf"
			--aoe = aoe + caster:GetCastRangeBonus()  不再享受施法距离增益
		end

		EmitSoundOnLocationWithCaster(target_point, smoke_sound, caster)

		local thinker = CreateModifierThinker(caster, self, smoke_aura, {duration = duration, aoe = aoe , mode_type = mode_type}, target_point, caster:GetTeamNumber(), false)
		if self:GetCaster():TG_HasTalent("special_bonus_imba_riki_4") and target_point == target:GetAbsOrigin() then 
			local particle_range = ParticleManager:CreateParticle("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW, thinker)
			ParticleManager:SetParticleControl(particle_range, 1, Vector(aoe, 0, 0))
			ParticleManager:SetParticleControl(particle_range, 2, Vector(10,0,0))
			ParticleManager:SetParticleControl(particle_range, 3, Vector(100,0,0))
			if mode_type == 2 then 
				ParticleManager:SetParticleControl(particle_range, 15, Vector(84, 255, 159))
			elseif mode_type == 3 then 
				ParticleManager:SetParticleControl(particle_range, 15, Vector(99, 184, 255))
			else
				ParticleManager:SetParticleControl(particle_range, 15, Vector(238, 44, 44))
			end
			--portable particle
			smoke_particle = "particles/econ/items/riki/riki_head_ti8/riki_smokebomb_ti8_crimson_ring_debris.vpcf"
			--portable
			thinker.bFollow = 1
			--Talent portable smoke screen move with riki
			thinker.target = target
		end
		local particle = ParticleManager:CreateParticle(smoke_particle, PATTACH_CUSTOMORIGIN, thinker)
		ParticleManager:SetParticleControlEnt(particle, 0, thinker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", thinker:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(particle, 1, Vector(aoe, aoe, aoe))
		thinker.particle = particle

		--mode 3
		if mode_type == 3 then 
			--瞬间毒伤伤害
			local enemies = FindUnitsInRadius(
				caster:GetTeamNumber(),
				target_point,
				nil,
				aoe,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)
			local damage_table = ({
						--victim = enemy,
						attacker = self:GetCaster(),
						ability = self,
						damage = poisoned_damage,
						damage_type = DAMAGE_TYPE_MAGICAL
					})
			for _,enemy in pairs(enemies) do
				if not enemy:IsMagicImmune() then
					damage_table.victim = enemy
					--造成伤害
					ApplyDamage(damage_table)
				end
			end
		end
	end
end

--------------------------------------------------------------
--		   	MODIFIER_IMBA_RIKI_SMOKE_SCREEN_SURA            --
--------------------------------------------------------------
--smoke screen aura	
modifier_imba_smoke_screen_aura = class({})
function modifier_imba_smoke_screen_aura:IsPurgable() return false end
function modifier_imba_smoke_screen_aura:IsHidden() return true end
function modifier_imba_smoke_screen_aura:IsAura() return true end
function modifier_imba_smoke_screen_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_smoke_screen_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_imba_smoke_screen_aura:GetModifierAura() return "modifier_imba_smoke_screen_aura_debuff" end
function modifier_imba_smoke_screen_aura:GetAuraRadius() return self.aoe end
function modifier_imba_smoke_screen_aura:OnCreated(keys)
	self.aoe = keys.aoe
	self.mode_type = keys.mode_type
	self.bFollow = keys.bFollow
	--if IsServer() and self:GetCaster():TG_HasTalent("special_bonus_imba_riki_4") then 
	if IsServer() then	
		self.ability = self:GetAbility()
		self.caster = self.ability:GetCaster()
		self.parent = self:GetParent()
		self.miss_rate = self.ability:GetSpecialValueFor("miss_rate")
		self.Interval = FrameTime()
		-- begin delay
		self:StartIntervalThink( FrameTime() )
	end
end
function modifier_imba_smoke_screen_aura:OnIntervalThink()
	if self.caster:TG_HasTalent("special_bonus_imba_riki_4") and self.parent.bFollow == 1 and not self.parent.target:IsNull() then 
		self.parent:SetOrigin(self.parent.target:GetAbsOrigin())
	end
	self.Interval = self.Interval + FrameTime()
	if self.mode_type == 1 or self.mode_type == 2 then 
		local units = FindUnitsInRadius(
						self.caster:GetTeamNumber(),	-- int, your team number
						self.parent:GetOrigin(),	-- point, center point
						nil,	-- handle, cacheUnit. (not known)
						self.aoe,	-- float, radius. or use FIND_UNITS_EVERYWHERE
						DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
						DOTA_UNIT_TARGET_HERO,	-- int, type filter
						0,	-- int, flag filter
						0,	-- int, order filter
						false	-- bool, can grow cache
					)
		for _,unit in pairs(units) do
		 	if unit	== self.caster then
		 		if self.mode_type == 1 and RollPseudoRandomPercentage(self.miss_rate,0,self:GetCaster()) then 
			 		-- dodge projectiles
			 		ProjectileManager:ProjectileDodge( self.caster )
			 	elseif self.mode_type == 2 then 
			 		-- TRUESIGHT FALSE 
			 		self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_smoke_screen_aura_buff", {duration = 0.5})
		 		end
		 	end
		end
	elseif self.mode_type == 3 and self:GetCaster():HasModifier("modifier_imba_riki_backstab_passive") and math.mod(string.format("%." .. 2 .. "f",self.Interval),1) == 0 then 
		local units = FindUnitsInRadius(
						self:GetCaster():GetTeamNumber(),	-- int, your team number
						self:GetParent():GetOrigin(),	-- point, center point
						nil,	-- handle, cacheUnit. (not known)
						self.aoe,	-- float, radius. or use FIND_UNITS_EVERYWHERE
						DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
						0,	-- int, flag filter
						0,	-- int, order filter
						false	-- bool, can grow cache
					)
		for _,unit in pairs(units) do
		 	--触发背刺毒伤
		 	self.caster:FindModifierByNameAndCaster("modifier_imba_riki_backstab_passive",self.caster):Poisoned_BonusDamage(unit:entindex())
		end
	end
end

function modifier_imba_smoke_screen_aura:OnDestroy() 
	self.aoe = nil 
	self.bSlow = nil
	self.bFollow = nil
	if IsServer() then 
		--Release
		ParticleManager:DestroyParticle(self:GetParent().particle, false)
		ParticleManager:ReleaseParticleIndex(self:GetParent().particle)
	end
end
--------------------------------------------------------------
--	 MODIFIER_IMBA_RIKI_SMOKE_SCREEN_SURA_DEBUFF            --
--------------------------------------------------------------
--smoke screen aura debuff   attack miss   silenced
modifier_imba_smoke_screen_aura_debuff = class({})

function modifier_imba_smoke_screen_aura_debuff:IsPurgable() return false end
function modifier_imba_smoke_screen_aura_debuff:IsHidden() return false end
function modifier_imba_smoke_screen_aura_debuff:IsDebuff() return true end
function modifier_imba_smoke_screen_aura_debuff:OnCreated(keys) self.miss_rate = self:GetAbility():GetSpecialValueFor("miss_rate") end
function modifier_imba_smoke_screen_aura_debuff:OnRefresh(keys) self.miss_rate = self:GetAbility():GetSpecialValueFor("miss_rate") end
function modifier_imba_smoke_screen_aura_debuff:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_imba_smoke_screen_aura_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_smoke_screen_aura_debuff:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_imba_smoke_screen_aura_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MISS_PERCENTAGE} end
function modifier_imba_smoke_screen_aura_debuff:GetModifierMiss_Percentage() return self.miss_rate end

modifier_imba_smoke_screen_aura_buff = class({})
function modifier_imba_smoke_screen_aura_buff:IsPurgable() return false end
function modifier_imba_smoke_screen_aura_buff:IsHidden() return true end
function modifier_imba_smoke_screen_aura_buff:IsDebuff() return false end
function modifier_imba_smoke_screen_aura_buff:CheckState() return {[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true} end