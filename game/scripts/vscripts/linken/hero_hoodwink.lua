CreateTalents("npc_dota_hero_hoodwink", "linken/hero_hoodwink.lua")
------2020.12.27--by--你收拾收拾准备出林肯吧
imba_hoodwink_acorn_shot = class({})
LinkLuaModifier("modifier_imba_hoodwink_acorn_shot", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoodwink_acorn_shot_thinker", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
function imba_hoodwink_acorn_shot:GetCastRange() return self:GetCaster():Script_GetAttackRange() + self:GetSpecialValueFor("bonus_range") end
function imba_hoodwink_acorn_shot:OnSpellStart(x)
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	self.tree_duration = self:GetSpecialValueFor("tree_duration")
	self.bounce_count = self:GetSpecialValueFor("bounce_count")
	local pfx_name = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf"
	caster:EmitSound("Hero_Hoodwink.AcornShot.Bounce")
	local tree = CreateTempTreeWithModel(pos,self.tree_duration,"models/props_tree/frostivus_tree.vmdl")
	local dummy = CreateModifierThinker(
				self:GetCaster(), -- player source
				self, -- ability source
				"modifier_imba_hoodwink_acorn_shot_thinker", -- modifier name
				{
					duration = self.tree_duration,
				}, -- kv
				pos,
				self:GetCaster():GetTeamNumber(),
				false
			)
	local heroes1 = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 50, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, hero in pairs(heroes1) do
		FindClearSpaceForUnit(hero, pos, false)
	end
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, self:GetCaster():Script_GetAttackRange() + self:GetSpecialValueFor("bonus_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, hero in pairs(heroes) do
		if hero ~= nil then
			local info =
			{
				Target = hero,
				Source = dummy,
				Ability = self,
				EffectName = pfx_name,
				iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 10,
		      	bProvidesVision = true,
				iVisionRadius = 200,
				fVisionDuration = 1,
				iVisionTeamNumber = caster:GetTeamNumber(),
				ExtraData = {},
			}
			ProjectileManager:CreateTrackingProjectile(info)
		end
		break
	end
end
function imba_hoodwink_acorn_shot:OnProjectileHit_ExtraData(target, pos, keys)
	if not target then
		return
	end
	local caster = self:GetCaster()
	target:EmitSound("Hero_Hoodwink.AcornShot.Slow")
	target:EmitSound("Hero_Hoodwink.Attack")
	target:AddNewModifier_RS(caster, self, "modifier_paralyzed", {duration = self:GetSpecialValueFor("debuff_duration")})
	local pfx = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_impact.vpcf", caster), PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	local ability = caster:FindAbilityByName("imba_hoodwink_scurry")
	local modifier = caster:FindModifierByName("modifier_imba_hoodwink_scurry_passive")
	if ability and ability:IsTrained() and modifier then
		tree_v = modifier.trees
	end
	caster:AddNewModifier(caster, self, "modifier_imba_hoodwink_acorn_shot", {})
	if tree_v then
		target:AddNewModifier(caster, ability, "modifier_imba_hoodwink_vision_debuff", {duration = 2})
	end
	caster:PerformAttack(target, true, true, true, false, false, false, true)
	caster:RemoveModifierByName("modifier_imba_hoodwink_acorn_shot")
	target:RemoveModifierByName("modifier_imba_hoodwink_vision_debuff")


	if target:IsHero() then
		local ran_pos = RotatePosition(pos, QAngle(0, math.random(1,360), 0), target:GetAbsOrigin()+target:GetForwardVector() * 150)
		local tree = CreateTempTreeWithModel(ran_pos,self.tree_duration,"models/props_tree/frostivus_tree.vmdl")
		local heroes1 = FindUnitsInRadius(caster:GetTeamNumber(), ran_pos, nil, 50, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, hero in pairs(heroes1) do
			FindClearSpaceForUnit(hero, pos, false)
		end
	end

	--Timers:CreateTimer(self:GetSpecialValueFor("bounce_delay"), function()
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetCaster():Script_GetAttackRange() + self:GetSpecialValueFor("bonus_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		if #enemy >= 1 then
			if PseudoRandom:RollPseudoRandom(self, self:GetSpecialValueFor("bounce_random")) then
				local new_target = nil
				new_target = enemy[1]
				for i=1, #enemy do
					if enemy[i] ~= target then
						new_target = enemy[i]
						break
					end
				end
				if not new_target then
					new_target = target
				end
				local pfx_name = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf"
				if new_target then
					local info =
					{
						Target = new_target,
						Source = target,
						Ability = self,
						EffectName = pfx_name,
						iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
						iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
						bDrawsOnMinimap = false,
						bDodgeable = true,
						bIsAttack = false,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						flExpireTime = GameRules:GetGameTime() + 10,
				      	bProvidesVision = true,
						iVisionRadius = 200,
						fVisionDuration = 1,
						iVisionTeamNumber = caster:GetTeamNumber(),
						ExtraData = {},
					}
					ProjectileManager:CreateTrackingProjectile(info)
				end
			end
		end
		--return nil
	--end
	--)
end

modifier_imba_hoodwink_acorn_shot =class({})

function modifier_imba_hoodwink_acorn_shot:IsDebuff() return false end
function modifier_imba_hoodwink_acorn_shot:IsHidden() return false end
function modifier_imba_hoodwink_acorn_shot:IsPurgable() return false end
function modifier_imba_hoodwink_acorn_shot:IsPurgeException() return true end
function modifier_imba_hoodwink_acorn_shot:IsStunDebuff() return false end
function modifier_imba_hoodwink_acorn_shot:RemoveOnDeath() return true end
function modifier_imba_hoodwink_acorn_shot:DeclareFunctions() return { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
function modifier_imba_hoodwink_acorn_shot:GetModifierPreAttack_BonusDamage( params )
	if IsServer() and params.attacker == self:GetParent()  then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end
modifier_imba_hoodwink_acorn_shot_thinker = class({})
function modifier_imba_hoodwink_acorn_shot_thinker:OnCreated(params)
	if IsServer() then
		--self.trees = GridNav:GetAllTreesAroundPoint( self:GetParent():GetAbsOrigin(), 30, false )
		--self.pfx = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tree.vpcf", self:GetParent()), PATTACH_CUSTOMORIGIN, nil)
		--ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		--ParticleManager:ReleaseParticleIndex(self.pfx)
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 400, 20, false)
		--self:StartIntervalThink(0.1)
	end
end
--[[function modifier_imba_hoodwink_acorn_shot_thinker:OnIntervalThink(params)
	if not IsServer() then return end
	local trees = GridNav:GetAllTreesAroundPoint( self:GetParent():GetAbsOrigin(), 30, false )
	if self:GetCaster():TG_HasTalent("special_bonus_imba_hoodwink_6") then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 400, 0.2, false)
	end
	if #self.trees ~= #trees then
		local caster = self:GetCaster()
		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetCaster():Script_GetAttackRange() + self:GetAbility():GetSpecialValueFor("bonus_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, hero in pairs(heroes) do
			if hero ~= nil then
				GridNav:DestroyTreesAroundPoint( self:GetParent():GetAbsOrigin(), 30, false )
				caster:SetCursorPosition(self:GetParent():GetAbsOrigin())
				self:GetAbility():OnSpellStart(true)
				self:StartIntervalThink(-1)
				self:Destroy()
				break
			end
		end
	end
	if #trees == 0 then
		self:StartIntervalThink(-1)
		self:Destroy()
	end
	--DebugDrawCircle(self:GetParent():GetAbsOrigin(), Vector(255,0,0), 100, 50, true, 0.1)
end	]]

function modifier_imba_hoodwink_acorn_shot_thinker:OnDestroy(params)
	if IsServer() then
		--if self.pfx then
		--	ParticleManager:DestroyParticle(self.pfx, false)
		--	ParticleManager:ReleaseParticleIndex(self.pfx)
		--end
		self:GetParent():RemoveSelf()
	end
end

imba_hoodwink_bushwhack = class({})
LinkLuaModifier("modifier_imba_hoodwink_bushwhack", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoodwink_bushwhack_thinker", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
function imba_hoodwink_bushwhack:GetCastRange() return self:GetCaster():Script_GetAttackRange() + self:GetSpecialValueFor("bonus_range") end
function imba_hoodwink_bushwhack:GetAOERadius()
	return self:GetSpecialValueFor("trap_radius")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_hoodwink_4")
end
function imba_hoodwink_bushwhack:GetCustomCastErrorLocation(pos)

	if self.int == 0 then
		return "技能不可用"
	end
end
function imba_hoodwink_bushwhack:CastFilterResultLocation(pos)

	if self.int == 0 then
		return UF_FAIL_CUSTOM
	end
end
function imba_hoodwink_bushwhack:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_hoodwink_1") then
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_hoodwink_1"))
	end
	return cooldown
end
function imba_hoodwink_bushwhack:OnSpellStart()
	local caster = self:GetCaster()
	local origin = caster
	local target_pos = self:GetCursorPosition()
	local pos = target_pos
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	direction.z = 0
	local trap_radius = self:GetSpecialValueFor("trap_radius")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_hoodwink_4")
	self.int = 0
	self.hitted = {}
	local dummy_sound = CreateModifierThinker(caster, self, "modifier_imba_hoodwink_bushwhack_thinker", {duration = 20}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	local dummy = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 20}, pos, caster:GetTeamNumber(), false)

	self.debuff_duration = self:GetSpecialValueFor("debuff_duration") + caster:TG_GetTalentValue("special_bonus_imba_hoodwink_2")
	dummy_sound:EmitSound("Hero_Hoodwink.Bushwhack.Cast")
	local info =
	{
		Target = dummy,
		Source = origin,
		EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_projectile.vpcf",
		Ability = self,
		iMoveSpeed = self:GetSpecialValueFor("projectile_speed")+caster:TG_GetTalentValue("special_bonus_imba_hoodwink_8"),
		vSourceLoc = origin:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 60,
		bProvidesVision = false,
		ExtraData = {dummy = dummy:entindex(),dummy_sound = dummy_sound:entindex()}
	}
	TG_CreateProjectile({id = 1, team = caster:GetTeamNumber(), owner = caster,	p = info})
end
function imba_hoodwink_bushwhack:OnProjectileThink_ExtraData(pos, keys)
	local caster = self:GetCaster()
	local trap_radius = self:GetSpecialValueFor("trap_radius")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_hoodwink_4")
	AddFOWViewer(self:GetCaster():GetTeamNumber(), pos, trap_radius, FrameTime(), false)
	if dummy_sound then
		EntIndexToHScript(dummy_sound):SetOrigin(pos)
	end
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, trap_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	for i=1, #enemy do
		enemy[i]:AddNewModifier_RS(caster, self, "modifier_rooted", {duration = self.debuff_duration})
	end
	for _, enemy in pairs(enemy) do
		if not IsInTable(enemy, self.hitted) then
			if enemy ~= caster then
				if #self.hitted < 1 then
					self.hitted[#self.hitted+1] = enemy
				end
			end
		end
	end
	for _, enemy in pairs(self.hitted) do
		if enemy and enemy:IsAlive() then
			if #self.hitted <= 1 then
				enemy:SetOrigin(pos)
			end
		else
			self.hitted[i] = nil
		end
	end
end
function imba_hoodwink_bushwhack:OnProjectileHit_ExtraData(target, pos, keys)
	self.hitted = nil
	local caster = self:GetCaster()
	local dummy = EntIndexToHScript(keys.dummy)
	local dummy_sound = EntIndexToHScript(keys.dummy_sound)
	local trap_radius = self:GetSpecialValueFor("trap_radius")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_hoodwink_4")
	dummy_sound:EmitSound("Hero_Hoodwink.Bushwhack.Target")
	self.int = 1
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), dummy:GetAbsOrigin(), nil, trap_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	CreateTempTreeWithModel(pos,self:GetSpecialValueFor("tree_duration"),"models/props_tree/frostivus_tree.vmdl")

	local trees = GridNav:GetAllTreesAroundPoint( dummy:GetAbsOrigin(), trap_radius, false )
	AddFOWViewer(caster:GetTeamNumber(), dummy:GetAbsOrigin(), trap_radius, self.debuff_duration, false)

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_hoodwink/hoodwink_bushwhack.vpcf", PATTACH_POINT, dummy)
	ParticleManager:SetParticleControl(self.pfx, 0, dummy:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.pfx, 1, Vector(trap_radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(self.pfx)
	local heroes1 = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 50, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, hero in pairs(heroes1) do
		FindClearSpaceForUnit(hero, pos, false)
	end
	for i=1, #enemy do
		if #trees ~= 0 then
			dummy:SetAbsOrigin(trees[1]:GetOrigin())
			enemy[i]:AddNewModifier(caster, self, "modifier_imba_hoodwink_bushwhack", {duration = 0.5, trees = trees[1]:GetOrigin(), target = dummy:entindex(), debuff_duration = self.debuff_duration})

			ApplyDamage({attacker = caster, victim = enemy[i], damage = self:GetSpecialValueFor("total_damage"), ability = self, damage_type = self:GetAbilityDamageType()})
		end
	end

	dummy:ForceKill(false)
	dummy_sound:ForceKill(false)
end
modifier_imba_hoodwink_bushwhack_thinker = class({})
function modifier_imba_hoodwink_bushwhack_thinker:OnCreated(params)
	if IsServer() then

	end
end
function modifier_imba_hoodwink_bushwhack_thinker:OnIntervalThink(params)
	if not IsServer() then return end

end

function modifier_imba_hoodwink_bushwhack_thinker:OnDestroy(params)
	if IsServer() then

		self:GetParent():RemoveSelf()
	end
end
modifier_imba_hoodwink_bushwhack = class({})
function modifier_imba_hoodwink_bushwhack:IsDebuff()			return true end
function modifier_imba_hoodwink_bushwhack:IsHidden() 			return false end
function modifier_imba_hoodwink_bushwhack:IsPurgable() 			return false end
function modifier_imba_hoodwink_bushwhack:IsPurgeException() 	return true end
function modifier_imba_hoodwink_bushwhack:IsStunDebuff()		return true end
function modifier_imba_hoodwink_bushwhack:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_imba_hoodwink_bushwhack:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_imba_hoodwink_bushwhack:GetOverrideAnimationRate() return 0.2 end
function modifier_imba_hoodwink_bushwhack:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_imba_hoodwink_bushwhack:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_hoodwink_bushwhack:ShouldUseOverheadOffset() return true end
function modifier_imba_hoodwink_bushwhack:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
			MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
			}
end
function modifier_imba_hoodwink_bushwhack:GetBonusVisionPercentage()
	return 0
end
function modifier_imba_hoodwink_bushwhack:OnCreated(params)
	if IsServer() then
		self.pos = self:GetParent():GetAbsOrigin()
		self.target = EntIndexToHScript(params.target)
		self.trees = StringToVector(params.trees)
		self.knockback_direction = (self.trees - self:GetParent():GetAbsOrigin()):Normalized()
		self.knockback_direction.z = 0.0
		self.knockback_distance = (self.trees - self:GetParent():GetAbsOrigin()):Length2D() -175
		self.int = 0
		self.debuff_duration = params.debuff_duration
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_hoodwink_bushwhack:OnIntervalThink(params)
	if not IsServer() then return end
	self.int = self.int + FrameTime()
	print(self.int)
	if self.int < 0.3 then
		local total_ticks = self:GetDuration() / FrameTime()
		local distance = self.knockback_distance / total_ticks
		local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + self.knockback_direction * distance, nil)
		next_pos.z = next_pos.z + 50
		self:GetParent():SetOrigin(next_pos)
	else
		if self.pfx2 then
			ParticleManager:DestroyParticle(self.pfx2, false)
			ParticleManager:ReleaseParticleIndex(self.pfx2)
		end
		self.pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_target.vpcf", PATTACH_POINT, self:GetParent())

		ParticleManager:SetParticleControl(self.pfx2, 0, Vector(self:GetParent():GetAbsOrigin().x, self:GetParent():GetAbsOrigin().y, self:GetParent():GetAbsOrigin().z+100))
		ParticleManager:SetParticleControl(self.pfx2, 15, Vector(self.trees.x, self.trees.y, self.trees.z+100))
		self:SetDuration(self.debuff_duration, true)
		self:StartIntervalThink(-1)
		return
	end
end

function modifier_imba_hoodwink_bushwhack:OnDestroy(params)
	if not IsServer() then
		return
	end
	if self.pfx2 then
		ParticleManager:DestroyParticle(self.pfx2, false)
		ParticleManager:ReleaseParticleIndex(self.pfx2)
	end
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	self.pos = nil
	self.trees = nil
	self.knockback_direction = nil
	self.knockback_distance = nil
end
imba_hoodwink_scurry = class({})
LinkLuaModifier("modifier_imba_hoodwink_scurry_passive", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoodwink_scurry", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoodwink_vision_debuff", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoodwink_scurry_agh", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
function imba_hoodwink_scurry:OnSpellStart()
	local caster = self:GetCaster()
	self.duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster, self, "modifier_imba_hoodwink_scurry", {duration = self.duration})
	--caster:FindModifierByName("modifier_imba_hoodwink_scurry_passive"):Destroy()
	--caster:AddNewModifier(caster, self, "modifier_imba_hoodwink_scurry_passive", {})
end
function imba_hoodwink_scurry:GetIntrinsicModifierName() return "modifier_imba_hoodwink_scurry_passive" end

modifier_imba_hoodwink_scurry_passive = class({})
function modifier_imba_hoodwink_scurry_passive:IsDebuff()			return false end
function modifier_imba_hoodwink_scurry_passive:IsHidden() 			return not self:GetCaster():IsInvisible() end
function modifier_imba_hoodwink_scurry_passive:IsPurgable() 			return false end
function modifier_imba_hoodwink_scurry_passive:IsPurgeException() 	return false end
function modifier_imba_hoodwink_scurry_passive:GetModifierInvisibilityLevel()
	if self:GetCaster():IsInvisible() then
		return 1
	else
		return 0
	end
end
function modifier_imba_hoodwink_scurry_passive:IsAura()
	if self.trees and self:GetCaster():TG_HasTalent("special_bonus_imba_hoodwink_6") then
		return true
	end
	return false
end
function modifier_imba_hoodwink_scurry_passive:GetAuraDuration() return 0.1 end
function modifier_imba_hoodwink_scurry_passive:GetModifierAura() return "modifier_imba_hoodwink_scurry_agh" end
function modifier_imba_hoodwink_scurry_passive:IsAuraActiveOnDeath() 		return false end
function modifier_imba_hoodwink_scurry_passive:GetAuraRadius() return self:GetCaster():Script_GetAttackRange() end
function modifier_imba_hoodwink_scurry_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_hoodwink_scurry_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_hoodwink_scurry_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_imba_hoodwink_scurry_passive:GetAuraEntityReject(hTarget)
	return not self:GetAbility():IsTrained() or self:GetParent():PassivesDisabled()
end
function modifier_imba_hoodwink_scurry_passive:OnCreated(params)
		local ability = self:GetAbility()
		self.radius	= ability:GetSpecialValueFor("radius")
		self.movement_speed_pct = ability:GetSpecialValueFor("movement_speed_pct_s")
		self.evasion = ability:GetSpecialValueFor("evasion_s")
		self.attack_range = ability:GetSpecialValueFor("attack_range_s")
		self.invisible_dtime = ability:GetSpecialValueFor("invisible_dtime")
	if IsServer() then
		self.trees = false
		self.modifier_bool = false
		self.invisible = false
		self.invisible_int = 0
		self:SetStackCount(0)
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_hoodwink_scurry_passive:OnRefresh(params)
		local ability = self:GetAbility()
		self.radius	= ability:GetSpecialValueFor("radius")
		self.movement_speed_pct = ability:GetSpecialValueFor("movement_speed_pct_s")
		self.evasion = ability:GetSpecialValueFor("evasion_s")
		self.attack_range = ability:GetSpecialValueFor("attack_range_s")
		self.invisible_dtime = ability:GetSpecialValueFor("invisible_dtime")
	if IsServer() then
		self.trees = false
		self.modifier_bool = false
		self.invisible = false
		self.invisible_int = 0
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_hoodwink_scurry_passive:CheckState()
	return
	{
		[MODIFIER_STATE_INVISIBLE] = (self.trees and self.invisible),
		[MODIFIER_STATE_NO_UNIT_COLLISION] = (self.trees and self.invisible),
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,

		}
end
function modifier_imba_hoodwink_scurry_passive:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
			MODIFIER_PROPERTY_EVASION_CONSTANT,
			MODIFIER_EVENT_ON_ATTACK_START,
			MODIFIER_EVENT_ON_ATTACK,
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_EVENT_ON_ABILITY_EXECUTED,
			MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
			MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
			MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
			MODIFIER_EVENT_ON_ATTACK_FAIL,
			MODIFIER_PROPERTY_INVISIBILITY_LEVEL
			}
end
function modifier_imba_hoodwink_scurry_passive:GetModifierBaseAttackTimeConstant()
	if self.trees then
		return self:GetParent():TG_GetTalentValue("special_bonus_imba_hoodwink_3")
	end
	return 2.0
end
function modifier_imba_hoodwink_scurry_passive:GetDisableAutoAttack()
	if self:GetCaster():IsInvisible() then
		return true
	else
		return false
	end
end
function modifier_imba_hoodwink_scurry_passive:GetModifierMoveSpeedBonus_Percentage()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("movement_speed_pct_s") * self:GetStackCount()
end
function modifier_imba_hoodwink_scurry_passive:GetModifierAttackRangeBonus()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("attack_range_s") * self:GetStackCount()
end

function modifier_imba_hoodwink_scurry_passive:GetModifierEvasion_Constant()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("evasion_s") * self:GetStackCount()
end
function modifier_imba_hoodwink_scurry_passive:OnAttackFail(keys)
    if not IsServer() then
        return
    end
	if keys.target ~= self:GetParent()  then
		return
	end
	if not keys.attacker:IsRangedAttacker() then
		return
	end
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MISS, keys.target, 0, nil)
end
function modifier_imba_hoodwink_scurry_passive:OnIntervalThink(params)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local trees = GridNav:GetAllTreesAroundPoint( self:GetParent():GetAbsOrigin(), self.radius, false )
	local ability2 = caster:FindAbilityByName("imba_hoodwink_sharpshooter")
	local ability3 = caster:FindAbilityByName("imba_hoodwink_jump")
	local modifier = caster:FindModifierByName("modifier_imba_hoodwink_jump")
	local dummy = nil
	if ability2 and ability2:IsTrained() and ability2.dummy_pfx ~= nil then
		dummy = EntIndexToHScript(ability2.dummy_pfx)
	end
	local trees_fa = false
	if dummy ~= nil then
		trees_fa = (dummy:GetAbsOrigin()-caster:GetAbsOrigin()):Length2D() <= ability2:GetSpecialValueFor("special_range")
	end
	if #trees ~= 0 or trees_fa then
		self.trees = true
		self:SetStackCount(5)
		self.invisible_int = self.invisible_int + FrameTime()
		if self.invisible_int >= self.invisible_dtime then
			self.invisible_int = 0
			self.invisible = true
		end
		--if ability3 then
		--	ability3:SetActivated(true)
		--end
	elseif #trees == 0 and not modifier then
		self.trees = false
		self.invisible = false
		self:SetStackCount(0)
		--if ability3 then
		--	ability3:SetActivated(false)
		--end
	end
	if caster:HasModifier("modifier_imba_hoodwink_scurry")	then
		self.modifier_bool = true
	else
		self.modifier_bool = false
	end
	if self.trees and self.modifier_bool then
		self:SetStackCount(10)
	elseif	self.modifier_bool then
		self:SetStackCount(5)
	end
end
function modifier_imba_hoodwink_scurry_passive:OnAttackStart(keys)
	if not IsServer() then return end
	if keys.attacker ~= self:GetCaster() then
		return
	end
	if keys.target:IsBuilding() or not keys.target:IsAlive() then
		return
	end
	if not keys.target:IsHero() then
		return
	end
	if self.trees then
		keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_hoodwink_vision_debuff", {duration = 2})
	end
end
function modifier_imba_hoodwink_scurry_passive:OnAttackRecordDestroy(keys)
	if not IsServer() then return end
	if keys.attacker ~= self:GetCaster() then
		return
	end
	keys.target:RemoveModifierByName("modifier_imba_hoodwink_vision_debuff")
end
function modifier_imba_hoodwink_scurry_passive:OnAttack(keys)
	if not IsServer() then return end
	if keys.attacker ~= self:GetCaster() then
		return
	end
	if keys.attacker == self:GetParent() and self:GetParent():IsRangedAttacker() then
		self.invisible = false
		self.invisible_int = 0
	end
end
function modifier_imba_hoodwink_scurry_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and not self:GetParent():IsRangedAttacker() then
		self.invisible = false
		self.invisible_int = 0
	end
end

function modifier_imba_hoodwink_scurry_passive:OnAbilityExecuted(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	local ability = self:GetCaster():FindAbilityByName("imba_hoodwink_jump")
	if keys.ability == self:GetAbility() or keys.ability == ability then
		return
	end
	self.invisible = false
	self.invisible_int = 0
end
modifier_imba_hoodwink_scurry = class({})
function modifier_imba_hoodwink_scurry:IsDebuff()			return false end
function modifier_imba_hoodwink_scurry:IsHidden() 			return false end
function modifier_imba_hoodwink_scurry:IsPurgable() 		return true end
function modifier_imba_hoodwink_scurry:IsPurgeException() 	return true end
--function modifier_imba_hoodwink_scurry:GetOverrideAnimation() return ACT_DOTA_RUN end
function modifier_imba_hoodwink_scurry:OnCreated(params)
	if IsServer() then
		self.caster = self:GetParent()
		self.caster:EmitSound("Hero_Hoodwink.Scurry.Cast")
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_hoodwink/hoodwink_scurry_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(self.pfx, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 2, self.caster:GetAbsOrigin())

		--self.caster:StartGestureWithPlaybackRate(39, 1)
		self.caster:AddActivityModifier("scurry")
	end
end
function modifier_imba_hoodwink_scurry:OnRefresh(params)
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
		self:OnCreated()
		--self.caster:EmitSound("Hero_Hoodwink.Scurry.Cast")
	end
end
function modifier_imba_hoodwink_scurry:OnRemoved()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
		self.caster:EmitSound("Hero_Hoodwink.Scurry.End")
	end
end


modifier_imba_hoodwink_vision_debuff = class({})

function modifier_imba_hoodwink_vision_debuff:IsDebuff()			return true end
function modifier_imba_hoodwink_vision_debuff:IsHidden() 			return true end
function modifier_imba_hoodwink_vision_debuff:IsPurgable() 			return false end
function modifier_imba_hoodwink_vision_debuff:IsPurgeException() 	return false end
function modifier_imba_hoodwink_vision_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_DONT_GIVE_VISION_OF_ATTACKER} end
function modifier_imba_hoodwink_vision_debuff:GetModifierNoVisionOfAttacker(keys)
	return 1
end

modifier_imba_hoodwink_scurry_agh = class({})
function modifier_imba_hoodwink_scurry_agh:IsDebuff()			return true end
function modifier_imba_hoodwink_scurry_agh:IsHidden() 			return true end
function modifier_imba_hoodwink_scurry_agh:IsPurgable() 		return false end
function modifier_imba_hoodwink_scurry_agh:IsPurgeException() 	return false end
function modifier_imba_hoodwink_scurry_agh:DeclareFunctions() return {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION} end
function modifier_imba_hoodwink_scurry_agh:GetModifierProvidesFOWVision() return 1 end

imba_hoodwink_sharpshooter = class({})
LinkLuaModifier("modifier_imba_hoodwink_sharpshooter_time", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoodwink_sharpshooter", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoodwink_sharpshooter_debuff", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoodwink_sharpshooter_thinker", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
function imba_hoodwink_sharpshooter:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_hoodwink_sharpshooter_time") then
		return  "hoodwink_sharpshooter_release"
	end
	return "hoodwink_sharpshooter"
end
function imba_hoodwink_sharpshooter:GetManaCost(a)
	if self:GetCaster():HasModifier("modifier_imba_hoodwink_sharpshooter_time") then
		return 0
	end
	return 150
end
function imba_hoodwink_sharpshooter:GetBehavior()
	if self:GetCaster():HasModifier("modifier_imba_hoodwink_sharpshooter_time") then
		return  DOTA_ABILITY_BEHAVIOR_POINT
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function imba_hoodwink_sharpshooter:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_hoodwink_5") then
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_hoodwink_5"))
	end
	return cooldown
end
function imba_hoodwink_sharpshooter:OnSpellStart()
	local caster = self:GetCaster()
	local pos = caster:GetAbsOrigin()
	local target_pos = self:GetCursorPosition()
	local right1 = caster:GetRightVector()
	local up1 = caster:GetUpVector()
	local direction = (target_pos - pos):Normalized()
	direction.z = 0
	local arrow_speed = self:GetSpecialValueFor("arrow_speed")
	local arrow_range = self:GetSpecialValueFor("arrow_range")
	self.duration = self:GetSpecialValueFor("misfire_time")
	if not caster:HasModifier("modifier_imba_hoodwink_sharpshooter_time") then
		caster:AddNewModifier(caster, self, "modifier_imba_hoodwink_sharpshooter_time", {duration = self.duration})
		self:EndCooldown()
		self:StartCooldown(0.1)
		caster:EmitSound("Hero_Hoodwink.Sharpshooter.Channel")
	else
		caster:StopSound("Hero_Hoodwink.Sharpshooter.Channel")
		caster:EmitSound("Hero_Hoodwink.Sharpshooter.Cast")
		local dummy_pfx = CreateModifierThinker(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_imba_hoodwink_sharpshooter_thinker", -- modifier name
			{
				duration = self:GetSpecialValueFor("special_duration"),
			}, -- kv
			pos,
			self:GetCaster():GetTeamNumber(),
			false
		)
		dummy_pfx:SetForwardVector(direction)
		self.dummy_pfx = dummy_pfx:entindex()

		local dummy_sound = CreateModifierThinker(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_dummy_thinker", -- modifier name
			{
				duration = 5,
			}, -- kv
			pos,
			self:GetCaster():GetTeamNumber(),
			false
		)
		dummy_sound:EmitSound("Hero_Hoodwink.Sharpshooter.Projectile")
		local damage_max = self:GetSpecialValueFor("max_damage")
		local modifier = caster:FindModifierByName("modifier_imba_hoodwink_sharpshooter_time")
		local duration_max = self:GetSpecialValueFor("max_charge_time")
		local duration = math.min(modifier:GetElapsedTime(), self:GetSpecialValueFor("max_charge_time"))
		local damage = duration / duration_max * damage_max
		local debuff_duration = duration / duration_max * self:GetSpecialValueFor("max_slow_debuff_duration")
		local flags = DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES
		if caster:TG_HasTalent("special_bonus_imba_hoodwink_7")	then
			flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		end
	    local info = {
	        Ability = self,
	        EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_projectile.vpcf",
	        vSpawnOrigin = pos,
	        fDistance = arrow_range,
	        fStartRadius = self:GetSpecialValueFor("arrow_width"),
	        fEndRadius = self:GetSpecialValueFor("arrow_width"),
	        fExpireTime = GameRules:GetGameTime() + 10,
	        Source = caster,
	        bDeleteOnHit = false,
	        bHasFrontalCone = false,
	        bReplaceExisting = false,
	        bProvidesVision = true,
			iVisionRadius = self:GetSpecialValueFor("arrow_vision"),
			iVisionTeamNumber = caster:GetTeamNumber(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = flags,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        vVelocity = direction * arrow_speed,
	        ExtraData = {damage = damage, debuff_duration = debuff_duration, dummy_pfx = self.dummy_pfx, dummy_sound = dummy_sound:entindex()}
	    }
	    ProjectileManager:CreateLinearProjectile(info)
	    caster:AddNewModifier(self:GetCaster(), self, "modifier_imba_hoodwink_sharpshooter", {duration = self:GetSpecialValueFor("recoil_duration"), direction = direction})
		caster:RemoveModifierByName("modifier_imba_hoodwink_sharpshooter_time")
	end
end
function imba_hoodwink_sharpshooter:OnProjectileThink_ExtraData(pos, keys)
	if keys.dummy_sound and EntIndexToHScript(keys.dummy_sound) then
		EntIndexToHScript(keys.dummy_sound):SetOrigin(GetGroundPosition(pos, nil))
	end
end
function imba_hoodwink_sharpshooter:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return true
	end
	local caster = self:GetCaster()
	local dmgType = caster:TG_HasTalent("special_bonus_imba_hoodwink_7") and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL
	local dummy_pfx = EntIndexToHScript(keys.dummy_pfx)
	target:EmitSound("Hero_Hoodwink.Sharpshooter.Target")
	target:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_hoodwink_sharpshooter_debuff", {duration = keys.debuff_duration})
	target:AddNewModifier_RS(self:GetCaster(), self, "modifier_paralyzed", {duration = keys.debuff_duration})
	local damageTable = {
						victim = target,
						attacker = self:GetCaster(),
						damage = keys.damage,
						damage_type = dmgType,
						ability = self,
						damage_flags = DOTA_DAMAGE_FLAG_NONE,
						}
	ApplyDamage(damageTable)
	target:EmitSound("Hero_DrowRanger.Marksmanship.Target")
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_impact.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(self.pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.pfx, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControlOrientation(self.pfx, 1, dummy_pfx:GetForwardVector(), dummy_pfx:GetRightVector(), dummy_pfx:GetUpVector())
	--ParticleManager:SetParticleControl(self.pfx, 3, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.pfx)
	--return true
end
modifier_imba_hoodwink_sharpshooter_time = class({})
function modifier_imba_hoodwink_sharpshooter_time:IsDebuff()			return false end
function modifier_imba_hoodwink_sharpshooter_time:IsHidden() 			return false end
function modifier_imba_hoodwink_sharpshooter_time:IsPurgable() 			return false end
function modifier_imba_hoodwink_sharpshooter_time:IsPurgeException() 	return false end
function modifier_imba_hoodwink_sharpshooter_time:GetTexture() return "hoodwink_sharpshooter" end
function modifier_imba_hoodwink_sharpshooter_time:OnCreated(keys)
	if IsServer() then
		local caster = self:GetCaster()
		self.duration = self:GetAbility():GetSpecialValueFor("misfire_time")
		self.duration1 = 1

		self.Pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		local time_x = self.duration
		local time_y = self.duration1
		ParticleManager:SetParticleControl(self.Pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.Pfx, 1, Vector( 0 , time_x, time_y) )
		ParticleManager:SetParticleControl(self.Pfx, 2, Vector( 2, 0, 0 ) )

		self:StartIntervalThink(0.5)
	end
end
function modifier_imba_hoodwink_sharpshooter_time:OnIntervalThink()
	local caster = self:GetCaster()
	local duration = self.duration
	self.duration = self.duration - 0.5
	if self.duration == 2 then
		caster:EmitSound("Hero_Hoodwink.Sharpshooter.MaxCharge")
	end
	if math.floor(duration) < duration then
		self.duration1 = 1
	else
		self.duration1 = 8
	end
	local time_x = math.floor(self.duration)
	local time_y = self.duration1
	self.Pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	ParticleManager:SetParticleControl(self.Pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.Pfx, 1, Vector( 0 , time_x, time_y) )
	ParticleManager:SetParticleControl(self.Pfx, 2, Vector( 2, 0, 0 ) )
end
function modifier_imba_hoodwink_sharpshooter_time:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		if self.Pfx ~= nil then
			ParticleManager:DestroyParticle(self.Pfx, false)
			ParticleManager:ReleaseParticleIndex(self.Pfx)
		end
		self:GetAbility():EndCooldown()
		self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(self:GetAbility():GetLevel() -1 ) * caster:GetCooldownReduction()) - self:GetElapsedTime())
	end
end

modifier_imba_hoodwink_sharpshooter = class({})
function modifier_imba_hoodwink_sharpshooter:IsDebuff()			return false end
function modifier_imba_hoodwink_sharpshooter:IsHidden() 			return false end
function modifier_imba_hoodwink_sharpshooter:IsPurgable() 			return false end
function modifier_imba_hoodwink_sharpshooter:IsPurgeException() 	return false end
function modifier_imba_hoodwink_sharpshooter:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
			MODIFIER_PROPERTY_MOVESPEED_LIMIT
			}
end
function modifier_imba_hoodwink_sharpshooter:GetModifierMoveSpeed_Absolute() if IsServer() then return 1 end end
function modifier_imba_hoodwink_sharpshooter:GetModifierMoveSpeed_Limit() if IsServer() then return 1 end end
function modifier_imba_hoodwink_sharpshooter:GetOverrideAnimation() return ACT_DOTA_CAST_ABILITY_4 end
function modifier_imba_hoodwink_sharpshooter:OnCreated(keys)
	if IsServer() then
		self.target_pos = keys.target_pos
		self.direction = 0-StringToVector(keys.direction)
		self.knockback_distance = self:GetAbility():GetSpecialValueFor("recoil_distance")
		self.knockback_height = self:GetAbility():GetSpecialValueFor("recoil_height")
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_hoodwink_sharpshooter:OnIntervalThink()
	local total_ticks = self:GetDuration() / FrameTime()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local distance = self.knockback_distance / total_ticks
	local height = self.knockback_height
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + self.direction * distance, nil)
	next_pos.z = next_pos.z - 4 * height * motion_progress ^ 2 + 4 * height * motion_progress
	self:GetParent():SetOrigin(next_pos)
	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 100, false)
end
function modifier_imba_hoodwink_sharpshooter:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
end

modifier_imba_hoodwink_sharpshooter_debuff = class({})
function modifier_imba_hoodwink_sharpshooter_debuff:IsDebuff()			return true end
function modifier_imba_hoodwink_sharpshooter_debuff:IsHidden() 			return false end
function modifier_imba_hoodwink_sharpshooter_debuff:IsPurgable() 			return true end
function modifier_imba_hoodwink_sharpshooter_debuff:IsPurgeException() 	return true end
function modifier_imba_hoodwink_sharpshooter_debuff:GetEffectName() return "particles/generic_gameplay/generic_break.vpcf" end
function modifier_imba_hoodwink_sharpshooter_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_hoodwink_sharpshooter_debuff:CheckState() return {[MODIFIER_STATE_PASSIVES_DISABLED] = true} end
function modifier_imba_hoodwink_sharpshooter_debuff:ShouldUseOverheadOffset() return true end


modifier_imba_hoodwink_sharpshooter_thinker = class({})
function modifier_imba_hoodwink_sharpshooter_thinker:IsDebuff()				return false end
function modifier_imba_hoodwink_sharpshooter_thinker:IsHidden() 			return false end
function modifier_imba_hoodwink_sharpshooter_thinker:IsPurgable() 			return false end
function modifier_imba_hoodwink_sharpshooter_thinker:IsPurgeException() 	return false end
function modifier_imba_hoodwink_sharpshooter_thinker:OnCreated(keys)
	if IsServer() then
		local caster = self:GetParent()
		self.ability = self:GetAbility()
		self.pfx = ParticleManager:CreateParticleForPlayer("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner())
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.ability:GetSpecialValueFor("special_range"), 0, 0))
		ParticleManager:SetParticleControl(self.pfx, 2, Vector(10, 0, 0))
		ParticleManager:SetParticleControl(self.pfx, 3, Vector(100, 0, 0))
		ParticleManager:SetParticleControl(self.pfx, 15, Vector(255, 155, 55))
		self:AddParticle(self.pfx, true, false, 15, false, false)


		self.Pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter.vpcf", PATTACH_POINT, caster)
		ParticleManager:SetParticleControl(self.Pfx2, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.Pfx2, 1, caster:GetAbsOrigin())
		self.int = 0
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_hoodwink_sharpshooter_thinker:OnIntervalThink()
	self.int = self.int + FrameTime()
	local caster = self:GetParent()
	if self.int > 5 then
		self.Pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter.vpcf", PATTACH_POINT, caster)
		ParticleManager:SetParticleControl(self.Pfx2, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.Pfx2, 1, caster:GetAbsOrigin())
		self:StartIntervalThink(-1)
	end
end
function modifier_imba_hoodwink_sharpshooter_thinker:OnRemoved()
	if IsServer() then
		local caster = self:GetParent()
		if self.Pfx2 then
			ParticleManager:DestroyParticle(self.Pfx2, false)
			ParticleManager:ReleaseParticleIndex(self.Pfx2)
		end
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
		self:GetParent():RemoveSelf()
	end
end
LinkLuaModifier("modifier_imba_hoodwink_jump", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoodwink_jump_agh", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoodwink_jump_boom", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
imba_hoodwink_jump = class({})
function imba_hoodwink_jump:GetCastRange() return self:GetCaster():Script_GetAttackRange()*3 end
function imba_hoodwink_jump:GetAOERadius() return self:GetSpecialValueFor("range_search") end
function imba_hoodwink_jump:GetIntrinsicModifierName() return "modifier_imba_hoodwink_jump_agh" end
function imba_hoodwink_jump:GetCustomCastErrorLocation(pos)
	if IsServer() then
		local trees = GridNav:GetAllTreesAroundPoint( pos, self:GetSpecialValueFor("range_search"), false )
		if #trees == 0 then
			return "范围内没有树木"
		end
	end
end
function imba_hoodwink_jump:CastFilterResultLocation(pos)
	if IsServer() then
		local trees = GridNav:GetAllTreesAroundPoint( pos, self:GetSpecialValueFor("range_search"), false )
		if #trees == 0 then
			return UF_FAIL_CUSTOM
		end
	end
end
function imba_hoodwink_jump:OnSpellStart()
	local target = self:GetCursorPosition()
	local caster = self:GetCaster():GetAbsOrigin()
	self.range = self:GetSpecialValueFor("range_search")
	self.duration = self:GetSpecialValueFor("boom")+1
	--self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_FORCESTAFF_STATUE, 0.5)
	local trees = GridNav:GetAllTreesAroundPoint( target, self.range, false )
	for i=1,#trees do
		CreateModifierThinker(self:GetCaster(), self, "modifier_imba_hoodwink_jump_boom", {duration = self.duration}, trees[i]:GetOrigin(), self:GetCaster():GetTeamNumber(), false)
		GridNav:DestroyTreesAroundPoint( trees[i]:GetOrigin(), 5, false )
		if i == 6 then
			break
		end
	end
	--[[self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_imba_hoodwink_jump",
		{
		duration = self:GetSpecialValueFor("duration"),
		pos_x = target.x, pos_y = target.y, pos_z = target.z,
		obs_x = caster.x, obs_y = caster.y, obs_z = caster.z,
		int = 0
		})]]
end
function imba_hoodwink_jump:Set_InitialUpgrade(tg)
    return {LV=1}
end
--[[modifier_imba_hoodwink_jump = class({})
function modifier_imba_hoodwink_jump:IsDebuff()				return false end
function modifier_imba_hoodwink_jump:IsHidden() 			return true end
function modifier_imba_hoodwink_jump:IsPurgable() 			return true end
function modifier_imba_hoodwink_jump:IsPurgeException() 	return true end
function modifier_imba_hoodwink_jump:DeclareFunctions()
	return {
			--MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
			MODIFIER_PROPERTY_MOVESPEED_LIMIT,
			MODIFIER_PROPERTY_DISABLE_TURNING,
			MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
			}
end

function modifier_imba_hoodwink_jump:CheckState()
    return
    {
          [MODIFIER_STATE_INVULNERABLE] = true,
          [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
      }
end

function modifier_imba_hoodwink_jump:GetDisableAutoAttack()
	return true
end
function modifier_imba_hoodwink_jump:GetModifierDisableTurning()
    return 1
end
function modifier_imba_hoodwink_jump:GetModifierMoveSpeed_Absolute() return 1 end
function modifier_imba_hoodwink_jump:GetModifierMoveSpeed_Limit() return 1 end
--function modifier_imba_hoodwink_jump:GetOverrideAnimation() return ACT_DOTA_FORCESTAFF_STATUE end
--function modifier_imba_hoodwink_jump:IsMotionController()	return true end
--function modifier_imba_hoodwink_jump:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST end
function modifier_imba_hoodwink_jump:OnCreated(keys)
	self.range = self:GetAbility():GetSpecialValueFor("range_search")
	self.duration = self:GetAbility():GetSpecialValueFor("boom")+1
	if IsServer() then
		self:GetCaster():EmitSound("Hero_Zuus.Taunt.Jump")
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.obs = Vector(keys.obs_x, keys.obs_y, keys.obs_z)
		local caster = self:GetCaster()
		local direction = (caster:GetAbsOrigin() - self.pos):Normalized()
		self.origin = self.pos + direction * (self.range / 2)
		--CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_dummy_thinker", {duration = 1}, self.origin, self:GetCaster():GetTeamNumber(), false)
		self.int = 0
		self.frame = 360 / (self:GetDuration() / 0.08)
		FindClearSpaceForUnit(self:GetParent(), self.origin, true)
		self:StartIntervalThink(0.08)
	end
end
function modifier_imba_hoodwink_jump:OnIntervalThink()

	self.int = self.int + self.frame
	local next_pos = RotatePosition(self.pos, QAngle(0,self.int, 0), self.origin) + Vector(0,0,75)
	self:GetParent():SetForwardVector((next_pos - self:GetParent():GetAbsOrigin()):Normalized())
	self:GetParent():SetOrigin(next_pos)
	local trees = GridNav:GetAllTreesAroundPoint( self:GetParent():GetAbsOrigin(), self.range/2, false )
	for i=1,#trees do
		CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_imba_hoodwink_jump_boom", {duration = self.duration}, trees[i]:GetOrigin(), self:GetCaster():GetTeamNumber(), false)
		GridNav:DestroyTreesAroundPoint( trees[i]:GetOrigin(), 5, false )
		break
	end
end

function modifier_imba_hoodwink_jump:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self.obs, true)
	end
end]]
modifier_imba_hoodwink_jump_agh = class({})

function modifier_imba_hoodwink_jump_agh:IsDebuff()			return false end
function modifier_imba_hoodwink_jump_agh:IsHidden() 		return true end
function modifier_imba_hoodwink_jump_agh:IsPurgable() 		return false end
function modifier_imba_hoodwink_jump_agh:IsPurgeException() return false end
function modifier_imba_hoodwink_jump_agh:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_hoodwink_jump_agh:OnIntervalThink()
	self:GetAbility():SetHidden(not self:GetParent():HasScepter())
	--if self:GetParent():HasScepter() then
		--self:StartIntervalThink(-1)
		--self:Destroy()
	--end
end

modifier_imba_hoodwink_jump_boom = class({})

function modifier_imba_hoodwink_jump_boom:OnCreated()
	if IsServer() then
		self.time = 0
		self.pfx = ParticleManager:CreateParticle("particles/econ/items/natures_prophet/natures_prophet_weapon_sufferwood/furion_teleport_end_team_sufferwood.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.pfx, false, false, 15, false, false)
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_hoodwink_jump_boom:OnIntervalThink()
	self.time = self.time + 0.1
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local pos = self:GetParent():GetAbsOrigin()
	--local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, ability:GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if self.time >= self:GetAbility():GetSpecialValueFor("boom") then
		self:GetParent():EmitSound("Hero_StormSpirit.StaticRemnantExplode")
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local pos = self:GetParent():GetAbsOrigin()
		--local damage =  caster:GetLevel() * self:GetAbility():GetSpecialValueFor("damage_max") --+ self:GetAbility():GetSpecialValueFor("damage_min")
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, ability:GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			local damage =  enemy:GetHealth() * self:GetAbility():GetSpecialValueFor("damage_max") * 0.01
			ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage_type = ability:GetAbilityDamageType(), damage = damage})
		end
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx,false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(ability:GetSpecialValueFor("range"),0,0))
		ParticleManager:ReleaseParticleIndex(pfx)
		self:GetParent():EmitSound("Hero_Pangolier.Gyroshell.Stun")
		self.time = 0
		self:StartIntervalThink(-1)
	end
end

function modifier_imba_hoodwink_jump_boom:OnDestroy()
	if not IsServer() then
		return
	end
	self:GetParent():RemoveSelf()
end
imba_hoodwink_decoy = class({})
LinkLuaModifier("modifier_imba_hoodwink_decoy", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hoodwink_decoy_agh", "linken/hero_hoodwink.lua", LUA_MODIFIER_MOTION_NONE)
function imba_hoodwink_decoy:Set_InitialUpgrade(tg)
    return {LV=1}
end
function imba_hoodwink_decoy:GetIntrinsicModifierName() return "modifier_imba_hoodwink_decoy_agh" end
function imba_hoodwink_decoy:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local ability = caster:FindAbilityByName("imba_hoodwink_scurry")
	local modifier_illusions =
	{
	    outgoing_damage=0,
	    incoming_damage=0,
	    bounty_base=0,
	    bounty_growth=0,
	    outgoing_damage_structure=0,
	    outgoing_damage_roshan=0,
	}
	caster.illusions = CreateIllusions(caster, caster, modifier_illusions, 1, 0, true, true)
	for i=1, #caster.illusions do
		caster.illusions[i]:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
		caster.illusions[i]:AddNewModifier(caster, self, "modifier_phased", {})
		if ability and ability:IsTrained() then
			caster.illusions[i]:AddNewModifier(caster, ability, "modifier_imba_hoodwink_scurry", {duration = duration})
		end
		caster.illusions[i]:AddNewModifier(caster, self, "modifier_imba_hoodwink_decoy", {duration = duration,pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})
	end
end
modifier_imba_hoodwink_decoy_agh = class({})

function modifier_imba_hoodwink_decoy_agh:IsDebuff()			return false end
function modifier_imba_hoodwink_decoy_agh:IsHidden() 		return true end
function modifier_imba_hoodwink_decoy_agh:IsPurgable() 		return false end
function modifier_imba_hoodwink_decoy_agh:IsPurgeException() return false end
function modifier_imba_hoodwink_decoy_agh:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_hoodwink_decoy_agh:OnIntervalThink()
	self:GetAbility():SetHidden(not self:GetParent():Has_Aghanims_Shard())
	if self:GetParent():Has_Aghanims_Shard() then
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end
modifier_imba_hoodwink_decoy = class({})

function modifier_imba_hoodwink_decoy:IsDebuff()			return false end
function modifier_imba_hoodwink_decoy:IsHidden() 			return true end
function modifier_imba_hoodwink_decoy:IsPurgable() 			return false end
function modifier_imba_hoodwink_decoy:IsPurgeException() 	return false end
function modifier_imba_hoodwink_decoy:DeclareFunctions() return
	{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}
end
function modifier_imba_hoodwink_decoy:OnCreated(keys)
	self.decoy_stun_duration = self:GetAbility():GetSpecialValueFor("decoy_stun_duration")
	self.tree_duration = self:GetAbility():GetSpecialValueFor("tree_duration")
	if IsServer() then
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self:StartIntervalThink(0.1)
	end
end
function modifier_imba_hoodwink_decoy:OnIntervalThink()
	self:GetParent():MoveToPosition(self.pos)
	self:StartIntervalThink(-1)
end
function modifier_imba_hoodwink_decoy:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.target ~= self:GetParent() then
		return
	end
	if keys.attacker:IsBuilding() then
		return
	end
	if not keys.attacker:IsHero() then
		return
	end
	if not IsEnemy(keys.attacker,self:GetParent()) then
		return
	end
	local num=0
   	for a=1,6 do
        CreateTempTree(RotatePosition(keys.attacker:GetAbsOrigin(), QAngle(0, num, 0), keys.attacker:GetAbsOrigin()+keys.attacker:GetForwardVector() * 160), self.tree_duration)
        num=num+60
    end

    local enemy = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), keys.attacker:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    for _,hero in pairs(enemy) do
        FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
    end
    keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.decoy_stun_duration})
    AddFOWViewer(self:GetCaster():GetTeamNumber(), keys.attacker:GetAbsOrigin(), 400, self.tree_duration, false)


	self:Destroy()
	self:GetParent():ForceKill(false)
end
function modifier_imba_hoodwink_decoy:OnAbilityExecuted(keys)
	if not IsServer() then return end
	if keys.target ~= self:GetParent() then
		return
	end
	if not IsEnemy(keys.ability:GetCaster(),self:GetParent()) then
		return
	end
	local num=0
   	for a=1,6 do
        CreateTempTree(RotatePosition(keys.ability:GetCaster():GetAbsOrigin(), QAngle(0, num, 0), keys.ability:GetCaster():GetAbsOrigin()+keys.ability:GetCaster():GetForwardVector() * 160), self.tree_duration)
        num=num+60
    end

    local enemy = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), keys.ability:GetCaster():GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    for _,hero in pairs(enemy) do
        FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
    end
    keys.ability:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.decoy_stun_duration})
    AddFOWViewer(self:GetCaster():GetTeamNumber(), keys.ability:GetCaster():GetAbsOrigin(), 400, self.tree_duration, false)

	self:Destroy()
	self:GetParent():ForceKill(false)
end
function modifier_imba_hoodwink_decoy:OnDestroy()
	if IsServer() then
	end
end
