charlie = class({})

LinkLuaModifier("charlie_pa", "ting/yinjianren/charlie.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_charlie_thinker", "ting/yinjianren/charlie.lua", LUA_MODIFIER_MOTION_HORIZONTAL)


function charlie:IsStealable() return false end
function charlie:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function charlie:GetIntrinsicModifierName()
	return "charlie_pa"
end
function charlie:Init()
	if IsServer() then
	self.damageTable=	{
						attacker = self:GetCaster(),
						ability = self,
						damage_type = self:GetAbilityDamageType(),
						}
	self.Knockback ={
          should_stun = 0, --打断
          knockback_duration = 0.1, --击退时间 减去不能动的时间就是太空步的时间
          duration = 0.1, --不能动的时间
          knockback_height = 0,	--击退高度

		}
	end
end

function charlie:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()

	local particle_launch_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sniper/sniper_shrapnel_launch.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle_launch_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_launch_fx, 1, Vector(pos.x, pos.y, pos.z + 1000))
	ParticleManager:ReleaseParticleIndex(particle_launch_fx)
	caster:EmitSound("Hero_Sniper.ShrapnelShoot")

	CreateModifierThinker( self:GetCaster(), self, "modifier_charlie_thinker", { duration = self:GetSpecialValueFor("duration") }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
	AddFOWViewer(self:GetCaster():GetTeamNumber(), pos, self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("duration") , false)

end

function charlie:OnProjectileHit_ExtraData(target, location, keys)
	local damage = self:GetSpecialValueFor("damage")
	if target then
		target:EmitSound("Hero_Sniper.ProjectileImpact")
		self.damageTable.victim = target
		self.damageTable.damage = keys.damage
		if keys.kno_dis  then
			self.Knockback.knockback_distance =  keys.kno_dis
			self.Knockback.center_x = keys.pos_x
			self.Knockback.center_y = keys.pos_y
			self.Knockback.center_z = keys.pos_z
			target:AddNewModifier(self:GetCaster(), self, "modifier_knockback", self.Knockback)
		end
		ApplyDamage(self.damageTable)


	end
end
modifier_charlie_thinker = class({})

--------------------------------------------------------------------------------

function modifier_charlie_thinker:IsHidden()
	return true
end

function modifier_charlie_thinker:IsPurgable()
	return false
end

function modifier_charlie_thinker:OnCreated( kv )
	if IsServer() then
		if self:GetAbility() == nil then return end
		self.ability = self:GetAbility()
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.team = self.caster:GetTeamNumber()
		self.dir = self.parent:GetForwardVector():Normalized()
		self.radius = self.ability :GetSpecialValueFor("radius")
		self.pos = self.parent:GetAbsOrigin()
		self.count_max = self.ability:GetSpecialValueFor("count")*2
		self.damage = self.ability:GetSpecialValueFor("damage")
		self.kno_dis = self.ability:GetSpecialValueFor("kno_dis")*-1

		self.info = {
				Ability = self:GetAbility(),
				EffectName = "particles/units/heroes/hero_sniper/sniper_base_attack.vpcf",
				iMoveSpeed = 2500,
				bDrawsOnMinimap = false,                          -- Optional
				bDodgeable = false,                                -- Optional
				bIsAttack = false,                                -- Optional
				bVisibleToEnemies = true,                         -- Optional
				bReplaceExisting = false,                         -- Optional
				bProvidesVision = false,
				ExtraData = {damage = self.damage,kno_dis = self.kno_dis ,pos_x = self.pos.x,pos_y = self.pos.y,pos_z = self.pos.z },				-- Optional
				}
	self.particle_shrapnel_fx = ParticleManager:CreateParticle("particles/econ/items/sniper/sniper_charlie/sniper_shrapnel_charlie.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.particle_shrapnel_fx, 0, self.pos)
	ParticleManager:SetParticleControl(self.particle_shrapnel_fx, 1, Vector(self.radius, self.radius, 0))
	ParticleManager:SetParticleControl(self.particle_shrapnel_fx, 2, self.pos)
	self:AddParticle(self.particle_shrapnel_fx, false, false, -1, false, false)
		self:StartIntervalThink(0.1)
	end
end
function modifier_charlie_thinker:OnIntervalThink()
	if IsServer() then
			local count = self.count_max
			local count_f = 2
				for i = 1 ,count_f do
					local enemies = FindUnitsInRadius(self.team, self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
					for _,enemy in pairs(enemies) do
					local dis = self.pos+ self.dir * RandomInt(1000,2000)
					local newpos =RotatePosition(self.pos, QAngle(0, RandomInt(0,360)), dis)


					local target = CreateModifierThinker(self.caster, self:GetAbility(), "charlie_pa", {duration = 0.01}, newpos, self.team, false)

					self.info.Target = enemy
					self.info.Source =  target:entindex()
					self.info.vSourceLoc= newpos
					ProjectileManager:CreateTrackingProjectile(self.info)
					target:EmitSound("Hero_Sniper.attack")
						count = count - 1
						if count == 0 then
							return
						end
					end

				end

	end
end


charlie_pa = class({})
function charlie_pa:IsPurgable() return false end
function charlie_pa:IsPurgeException() return false end
function charlie_pa:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_MODEL_SCALE,
			MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			}
end
function charlie_pa:OnCreated()
	if IsServer() then
			self.info = {
				Ability = self:GetAbility(),
				EffectName = "particles/units/heroes/hero_sniper/sniper_base_attack.vpcf",
				iMoveSpeed = 2500,
				bDrawsOnMinimap = false,                          -- Optional
				bDodgeable = false,                                -- Optional
				bIsAttack = false,                                -- Optional
				bVisibleToEnemies = true,                         -- Optional
				bReplaceExisting = false,                         -- Optional
				bProvidesVision = false,                           -- Optional
				}

	end
end

function charlie_pa:OnAttackLanded(keys)
	if IsServer() then

		if keys.attacker == self:GetParent() and keys.target then
			local chance = self:GetAbility():GetSpecialValueFor("chance")
			local count_max = self:GetAbility():GetSpecialValueFor("count")
			local count = count_max
			local damage = self:GetAbility():GetSpecialValueFor("attack")*keys.attacker:GetAverageTrueAttackDamage(keys.attacker)*0.01
			local radius = self:GetAbility():GetSpecialValueFor("radius")

			if PseudoRandom:RollPseudoRandom(self:GetAbility(), chance) then

				local pos = keys.attacker:GetAbsOrigin()
				local dir = keys.attacker:GetForwardVector():Normalized()
				for i = 1 ,count_max do
					local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,enemy in pairs(enemies) do
					local dis = pos+ dir * RandomInt(1500,2000)
					local newpos =RotatePosition(pos, QAngle(0, RandomInt(120,240)), dis)


					local target = CreateModifierThinker(keys.attacker, self:GetAbility(), "charlie_pa", {duration = 0.01}, newpos, keys.attacker:GetTeamNumber(), false)

					self.info.Target = enemy
					self.info.Source =  target:entindex()
					self.info.vSourceLoc= newpos
					self.info.ExtraData = {damage = damage}
					ProjectileManager:CreateTrackingProjectile(self.info)
					target:EmitSound("Hero_Sniper.attack")
						count = count - 1
						if count == 0 then
							return
						end
					end

				end

			end
		end
	end
end



function charlie_pa:IsHidden()
	return true
end
