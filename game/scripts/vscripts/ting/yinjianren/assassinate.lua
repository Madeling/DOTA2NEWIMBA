assassinate = class({})

LinkLuaModifier("modifier_assassinate_target", "ting/yinjianren/assassinate.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_paralyzed", "ting/yinjianren/assassinate.lua", LUA_MODIFIER_MOTION_NONE)

function assassinate:IsHiddenWhenStolen() 		return false end
function assassinate:IsRefreshable() 			return true end
function assassinate:IsStealable() 				return true end
function assassinate:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Ability.AssassinateLoad")
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_assassinate_target", {duration = self:GetCastPoint()})
	self:GetCaster():AddActivityModifier("MGC")
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4,2)
	return true
end

function assassinate:OnAbilityPhaseInterrupted()
	self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)
	return true
end

function assassinate:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	caster:EmitSound("Ability.Assassinate")

	local thinker = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false):entindex()
	EntIndexToHScript(thinker).hitted = {}
	EntIndexToHScript(thinker):EmitSound("Hero_Sniper.AssassinateProjectile")
	local info =
	{
		Target = target,
		Source = caster,
		Ability = self,
		EffectName = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf",
		iMoveSpeed = 3000,
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
		ExtraData = {thinker = thinker},
	}
	ProjectileManager:CreateTrackingProjectile(info)
end

function assassinate:OnProjectileThink_ExtraData(location, keys)
		local thinker = EntIndexToHScript(keys.thinker)
		local aoe_size = 200

		local damageTable = {
								attacker = self:GetCaster(),
								damage_type = self:GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self, --Optional.
								}

		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, aoe_size, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if not Is_DATA_TG(thinker.hitted, enemy) then
				table.insert(thinker.hitted, enemy)

			if self:GetCaster():HasScepter() then
				local Knockback ={
				  should_stun = 0, --打断
				  knockback_duration = 0.3, --击退时间 减去不能动的时间就是太空步的时间
				  duration = 0.3, --不能动的时间     kno_distance
				  knockback_distance = self:GetSpecialValueFor("kno_distance"),
				  knockback_height = 100,	--击退高度
				  center_x =  self:GetCaster():GetAbsOrigin().x,	--施法者为中心
				  center_y =  self:GetCaster():GetAbsOrigin().y,
				  center_z =  self:GetCaster():GetAbsOrigin().z,
				}
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_knockback", Knockback)  --白牛的击退
			end


				damageTable.victim = enemy
				damageTable.damage = self:GetSpecialValueFor("damage")
				ApplyDamage(damageTable)

				--[[
				if self:GetCaster():HasScepter() then
					self:GetCaster():PerformAttack(enemy, false, true, true, true, true, false, true)
				end]]
			end
		end
end

function assassinate:OnProjectileHit_ExtraData(target, location, keys)
	if target then
		local caster = self:GetCaster()
		if (target:IsCreep() or  target:IsNeutralUnitType() ) and not target:IsBoss() and not target:IsAncient()  then
				target:Kill(self, caster)
			else

			local damage = self:GetSpecialValueFor("damage_att")*self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())
			local damageTable = {
								attacker = caster,
								damage_type = self:GetAbilityDamageType(),
								ability = self, --Optional.
								}
			if target:IsHero() and not target:IsRangedAttacker() then --target:IsElite()
				local Knockback ={
				  should_stun = 0, --打断
				  knockback_duration = 0.3, --击退时间 减去不能动的时间就是太空步的时间
				  duration = 0.3, --不能动的时间     kno_distance
				  knockback_distance = self:GetSpecialValueFor("kno_distance"),
				  knockback_height = 100,	--击退高度
				  center_x =  caster:GetAbsOrigin().x,	--施法者为中心
				  center_y =  caster:GetAbsOrigin().y,
				  center_z =  caster:GetAbsOrigin().z,
				}
				target:AddNewModifier(caster, self, "modifier_knockback", Knockback)  --白牛的击退
			end

			if target:IsHero() and  target:IsRangedAttacker() then
			target:AddNewModifier(caster,self,"modifier_paralyzed",{duration = self:GetSpecialValueFor("slow_duration")})
			end

			damageTable.victim = target
			damageTable.damage = damage
			ApplyDamage(damageTable)

		end
	end
	self:GetCaster():RemoveModifierByName("ghillie_suit_pa_inv")
	EntIndexToHScript(keys.thinker).hitted = nil
	EntIndexToHScript(keys.thinker):ForceKill(false)

end

modifier_assassinate_target = class({})

function modifier_assassinate_target:IsDebuff()			return true end
function modifier_assassinate_target:IsHidden() 			return false end
function modifier_assassinate_target:IsPurgable() 			return false end
function modifier_assassinate_target:IsPurgeException() 	return false end
function modifier_assassinate_target:GetEffectName() return "particles/units/heroes/hero_sniper/sniper_crosshair.vpcf" end
function modifier_assassinate_target:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_assassinate_target:ShouldUseOverheadOffset() return true end



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