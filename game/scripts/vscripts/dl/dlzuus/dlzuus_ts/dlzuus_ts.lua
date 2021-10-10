dlzuus_ts = class({})

LinkLuaModifier( "modifier_dlzuus_charges", "dl/dlzuus/dlzuus_ts/modifier_dlzuus_charges", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_dlzuus_truesight", "dl/dlzuus/dlzuus_ts/modifier_dlzuus_truesight", LUA_MODIFIER_MOTION_BOTH )

function dlzuus_ts:IsHiddenWhenStolen() return false end
function dlzuus_ts:IsStealable() return true end
function dlzuus_ts:IsRefreshable() return true end
function dlzuus_ts:GetIntrinsicModifierName()
	return "modifier_dlzuus_charges"
end

--[[function dlzuus_ts:OnStolen(self)	--还以为是控制拉比克偷到的技能行为，原来是控制被拉比克偷后，宙斯自己的技能行为
	self:SetOverrideCastPoint(1.0)
end]]

function dlzuus_ts:OnUpgrade()
	local AB=self:GetCaster():FindAbilityByName("zuus_lightning_bolt")
	if AB~=nil then
		AB:SetLevel(self:GetLevel()) --给里技能加等级
	end
end

function dlzuus_ts:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeamNumber()
	local point = self:GetCursorPosition()
	-- load data
	local projectile_name = "particles/heros/zuus/dlmars_ti9_immortal_crimson_spear.vpcf"
	local id=tonumber(tostring(PlayerResource:GetSteamID(caster:GetPlayerOwnerID())))
	if  id== 76561198361355161 or id ==76561198100269546 or id == 76561198319625131 then 
		projectile_name = "particles/dlparticles/dlzuus_pinkspear/mars_p_ti9_immortal_crimson_spear_pink.vpcf"
	end
	local projectile_distance = self:GetSpecialValueFor("ts_range")+caster:GetCastRangeBonus()
	local projectile_speed = self:GetSpecialValueFor("ts_speed")
	local projectile_radius = self:GetSpecialValueFor("ts_width")
	local projectile_vision = self:GetSpecialValueFor("ts_vision")
	EmitSoundOn( "Hero_Zuus.ArcLightning.Cast", caster )
	-- calculate direction
	local direction = point - caster:GetOrigin()
	direction.z = 0
    direction = direction:Normalized()

	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetOrigin(),

	    bDeleteOnHit = true,

	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,

	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius =projectile_radius,
		vVelocity = direction * projectile_speed,

		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 20.0,

		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		fVisionDuration = 2,
		iVisionTeamNumber = team
	}
 --   ProjectileManager:CreateLinearProjectile(info)
 TG_CreateProjectile({id=0,team=team,owner=caster,p=info})
end



function dlzuus_ts:OnProjectileHitHandle(t, pos, ipro)
	local caster = self:GetCaster()
	TG_IS_ProjectilesValue1(caster,function()
        t=nil
    end)
	local projectile_vision = self:GetSpecialValueFor("ts_vision")
	local vdur = self:GetSpecialValueFor("ts_vision_dur")
	local sdur = self:GetSpecialValueFor("ts_stun_dur")
	AddFOWViewer( caster:GetTeamNumber(), pos, projectile_vision,vdur, false)

	CreateModifierThinker(	--范围持续反隐
		caster, -- player source
		self, -- ability source
		"modifier_dlzuus_truesight", -- modifier name
		{
			duration = vdur,
		}, -- kv
		pos,
		caster:GetTeamNumber(),
		false
	)

	if not t then return end

	caster:PerformAttack(
					t,
					true,
					true,
					true,
					true,
					false,
					false,
					true
				)

	if t:IsHero() or t:IsBoss() then
		local aoerad = self:GetSpecialValueFor("ts_aoerad")
		local aoedam = self:GetSpecialValueFor("ts_aoedam")

		local stun = t:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_stunned", -- modifier name
					{
						duration = sdur
					} -- kv
				)

		local damageTable = {
			attacker = caster,
			damage = aoedam,
			damage_type = self:GetAbilityDamageType(),
			ability = self,
		}

		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			pos,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			aoerad,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_DAMAGE_FLAG_NONE,	-- int, flag filter
			FIND_ANY_ORDER,	-- int, order filter
			false	-- bool, can grow cache
		)
		if #enemies>0 then
			for _,enemy in pairs(enemies) do
				-- damage enemies
				damageTable.victim = enemy
				ApplyDamage( damageTable )
			end
		end
		self:playeffects(t)
	--	ProjectileManager:DestroyLinearProjectile( ipro )
		return true --消失
	end
	--print(caster:TG_GetTalentValue("special_bonus_dlzuus_20l"))
	if caster:TG_GetTalentValue("special_bonus_dlzuus_20l")==0 then return true end --没有点天赋打小兵也消失，点了天赋穿透
end

function dlzuus_ts:playeffects(t)
	local sound_cast = "Hero_Zuus.LightningBolt"

	--[[local particle_cast = "particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local tpos = t:GetAbsOrigin() tpos.z=tpos.z+200
	ParticleManager:SetParticleControl( effect_cast, 1, tpos )]]
	local tpos = t:GetAbsOrigin() tpos.z=tpos.z+200

	local particle_cast2 = "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"
	local effect_cast2 = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, nil )
	local t0pos = t:GetAbsOrigin() t0pos.z = t0pos.z+1000
	ParticleManager:SetParticleControl( effect_cast2, 0, t0pos )
	ParticleManager:SetParticleControl( effect_cast2, 1, tpos )

	local particle_cast3 = "particles/econ/items/disruptor/disruptor_ti8_immortal_weapon/disruptor_ti8_immortal_thunder_strike_bolt.vpcf"
	local effect_cast3 = ParticleManager:CreateParticle( particle_cast3, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast3, 0, tpos )
	ParticleManager:SetParticleControl( effect_cast3, 2, tpos )

	--ParticleManager:ReleaseParticleIndex( effect_cast )
	ParticleManager:ReleaseParticleIndex( effect_cast2 )
	ParticleManager:ReleaseParticleIndex( effect_cast3 )
		EmitSoundOn( sound_cast, t )
end
