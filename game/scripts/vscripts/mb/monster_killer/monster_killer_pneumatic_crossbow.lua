-- Editors:
-- MysticBug, 25.09.2021
--Abilities
------------------------------------------------------------
--		   		 MONSTER_KILLER_PNEUMATIC_CROSSBOW        --
------------------------------------------------------------
monster_killer_pneumatic_crossbow = class({})

LinkLuaModifier( "modifier_monster_killer_pneumatic_crossbow_pa", "mb/monster_killer/monster_killer_pneumatic_crossbow.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_monster_killer_pneumatic_crossbow_cd", "mb/monster_killer/monster_killer_pneumatic_crossbow.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_monster_killer_pneumatic_crossbow_buff", "mb/monster_killer/monster_killer_pneumatic_crossbow.lua", LUA_MODIFIER_MOTION_NONE )

function monster_killer_pneumatic_crossbow:IsHiddenWhenStolen() 	return false end
function monster_killer_pneumatic_crossbow:IsRefreshable() 		return true  end
function monster_killer_pneumatic_crossbow:IsStealable() 		return true  end
function monster_killer_pneumatic_crossbow:GetIntrinsicModifierName() return "modifier_monster_killer_pneumatic_crossbow_pa" end
--------------------------------------------------------------------------------
-- Ability Start
function monster_killer_pneumatic_crossbow:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local pierce_count = self:GetSpecialValueFor("pierce_count")
	-- reload crossbow
	caster:SetModifierStackCount("modifier_monster_killer_pneumatic_crossbow_pa", nil , caster:GetModifierStackCount("modifier_monster_killer_pneumatic_crossbow_pa", nil) + pierce_count)
	-- Sound
	caster:EmitSound("Ability.AssassinateLoad")
	-- Test
	caster:AddNewModifier(caster, self, "modifier_monster_killer_pneumatic_crossbow_pa", {})
end


function monster_killer_pneumatic_crossbow:OnProjectileHitHandle(target, location, iProjectileHandle)
	if target then
		--Damage
		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetAverageTrueAttackDamage(target),
			damage_type = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
		}

		ApplyDamage(damageTable)
		--Effect
	end
end
---------------------------------------------------------------------
--Modifiers
modifier_monster_killer_pneumatic_crossbow_pa = class({})

function modifier_monster_killer_pneumatic_crossbow_pa:IsDebuff()			return false end
function modifier_monster_killer_pneumatic_crossbow_pa:IsHidden() 			return false end
function modifier_monster_killer_pneumatic_crossbow_pa:IsPurgable() 		return false end
function modifier_monster_killer_pneumatic_crossbow_pa:IsPurgeException() 	return false end
function modifier_monster_killer_pneumatic_crossbow_pa:DeclareFunctions()	return {MODIFIER_EVENT_ON_ATTACK,MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,MODIFIER_PROPERTY_PROJECTILE_NAME,MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND} end
function modifier_monster_killer_pneumatic_crossbow_pa:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	--load kv
	local ability               = self:GetAbility()
    local fusillade_time        = ability:GetSpecialValueFor("fusillade_time")
    local fusillade_cd          = ability:GetSpecialValueFor("fusillade_cd")
    local damage_pct            = ability:GetSpecialValueFor("damage_pct")
    local cleave_starting_width = ability:GetSpecialValueFor("cleave_starting_width")
    local cleave_ending_width   = ability:GetSpecialValueFor("cleave_ending_width")
    local cleave_distance       = ability:GetSpecialValueFor("cleave_distance")
    local cleave_damage         = ability:GetSpecialValueFor("cleave_damage")
	--Check CD
	if not keys.attacker:HasModifier("modifier_monster_killer_pneumatic_crossbow_cd") then
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monster_killer_pneumatic_crossbow_buff", {duration = fusillade_time})
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monster_killer_pneumatic_crossbow_cd", {duration = fusillade_cd})
    end
	--Active Piecre Crossbow
	if self:GetStackCount() > 0 then
		if self:GetParent():HasModifier("modifier_monster_killer_shapeshift_buff") then
			--Split Attack
			--print("do cleave attack",cleave_starting_width,self:GetParent():GetAverageTrueAttackDamage(self:GetParent())*cleave_damage*0.01)
			local pfx = "particles/heroes/monster_killer/monster_killer_cleave.vpcf"
			DoCleaveAttack(
				self:GetParent(),
				keys.target,
				self:GetAbility(),
				self:GetParent():GetAverageTrueAttackDamage(self:GetParent())*cleave_damage*0.01,
				cleave_starting_width,
				cleave_ending_width,
				cleave_distance,
				pfx)
		else
			-- create projectile
			local info = {
				Source = self:GetParent(),
				Ability = self:GetAbility(),
				vSpawnOrigin = self:GetParent():GetAbsOrigin(),

				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,

				EffectName = "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot_v2.vpcf",
				fDistance = self:GetParent():Script_GetAttackRange() * 2,
				fStartRadius = cleave_starting_width,
				fEndRadius = cleave_starting_width,
				vVelocity = self:GetParent():GetForwardVector() * (self:GetParent():IsRangedAttacker() and self:GetParent():GetProjectileSpeed() or 900),

				bProvidesVision = true,
				iVisionRadius = 250,
				iVisionTeamNumber = self:GetParent():GetTeamNumber(),
			}
			ProjectileManager:CreateLinearProjectile(info)
		end
		self:DecrementStackCount()
	end
end

function modifier_monster_killer_pneumatic_crossbow_pa:GetModifierTotalDamageOutgoing_Percentage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsRealHero() then
		return self:GetAbility():GetSpecialValueFor("damage_pct")
	end
end

function modifier_monster_killer_pneumatic_crossbow_pa:GetModifierProjectileName(keys) return "particles/econ/items/windrunner/windranger_arcana/windranger_arcana_base_attack_v2.vpcf" end
function modifier_monster_killer_pneumatic_crossbow_pa:GetAttackSound()
	if self:GetParent():HasModifier("modifier_monster_killer_shapeshift_buff") then
		return "Hero_Lycan.Attack"
	else
		return "Hero_Hoodwink.Attack"
	end
end

---------------------------------------------------------------------
--Modifiers
modifier_monster_killer_pneumatic_crossbow_cd = class({})

function modifier_monster_killer_pneumatic_crossbow_cd:IsDebuff()			return true end
function modifier_monster_killer_pneumatic_crossbow_cd:IsHidden() 			return false end
function modifier_monster_killer_pneumatic_crossbow_cd:IsPurgable() 		return false end
function modifier_monster_killer_pneumatic_crossbow_cd:IsPurgeException() 	return false end

---------------------------------------------------------------------
--Modifiers
modifier_monster_killer_pneumatic_crossbow_buff = class({})

function modifier_monster_killer_pneumatic_crossbow_buff:IsHidden() 			return true end
function modifier_monster_killer_pneumatic_crossbow_buff:IsPurgable() 			return false end
function modifier_monster_killer_pneumatic_crossbow_buff:IsPurgeException() 	return false end
function modifier_monster_killer_pneumatic_crossbow_buff:AllowIllusionDuplicate() 	return false end
function modifier_monster_killer_pneumatic_crossbow_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_monster_killer_pneumatic_crossbow_buff:OnCreated()
    self.parent=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.attsp= self.ability:GetSpecialValueFor("attsp")
end

function modifier_monster_killer_pneumatic_crossbow_buff:GetModifierAttackSpeedBonus_Constant() return self.attsp end