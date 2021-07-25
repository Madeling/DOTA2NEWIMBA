CreateTalents("npc_dota_hero_venomancer", "heros/hero_venomancer/venomous_gale.lua")
venomous_gale=class({})

LinkLuaModifier("modifier_venomous_gale_debuff", "heros/hero_venomancer/venomous_gale.lua", LUA_MODIFIER_MOTION_NONE)

function venomous_gale:IsHiddenWhenStolen()
    return false
end

function venomous_gale:IsStealable()
    return true
end

function venomous_gale:IsRefreshable()
    return true
end


function venomous_gale:OnSpellStart()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    local pos = self:GetCursorPosition()
    local dir = TG_Direction(pos+Vector(1,1,1),caster_pos)
    caster:EmitSound("Hero_Venomancer.VenomousGale")
    local projectileTable =
	{
		EffectName ="particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
		Ability = self,
		vSpawnOrigin =caster_pos,
		vVelocity =dir*1200,
		fDistance =1200,
		fStartRadius = 200,
		fEndRadius = 200,
		Source = caster,
		TreeBehavior = PROJECTILES_NOTHING,
		bCutTrees = true,
		bTreeFullCollision = false,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile( projectileTable )
end

function venomous_gale:OnProjectileHit_ExtraData(target, location, kv)
    if target==nil then
        return
    end
    local caster = self:GetCaster()
    local dam = self:GetSpecialValueFor( "dam" )+caster:TG_GetTalentValue("special_bonus_venomancer_2")
    if not target:IsMagicImmune()  then
        if target:IsRealHero() and caster:HasAbility("plague_ward") then
            local AB=caster:FindAbilityByName("plague_ward")
            if AB~=nil and AB:GetLevel()>0 then
                if caster:TG_HasTalent("special_bonus_venomancer_1") then
                    local ward1=CreateUnitByName("npc_plague_ward", target:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
                    ward1:AddNewModifier(caster, AB, "modifier_plague_ward", {duration=12})
                    ward1:AddNewModifier(caster, AB, "modifier_kill", {duration=12})
                    ward1:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
                end
                if caster:Has_Aghanims_Shard() then
                    local ward2=CreateUnitByName("npc_plague_ward", target:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
                    ward2:AddNewModifier(caster, AB, "modifier_plague_ward", {duration=12})
                    ward2:AddNewModifier(caster, AB, "modifier_kill", {duration=12})
                    ward2:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
                end
            end
        end
        target:AddNewModifier_RS(caster, self, "modifier_venomous_gale_debuff", {duration=self:GetSpecialValueFor("duration")})
        local damageTable = {
            victim = target,
            attacker = caster,
            damage = dam,
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self,
            }
            ApplyDamage(damageTable)
    end
end


modifier_venomous_gale_debuff=class({})

function modifier_venomous_gale_debuff:IsDebuff()
	return true
end

function modifier_venomous_gale_debuff:IsHidden()
	return false
end

function modifier_venomous_gale_debuff:IsPurgable()
	return true
end

function modifier_venomous_gale_debuff:IsPurgeException()
	return true
end

function modifier_venomous_gale_debuff:CheckState()
    return
    {
        [MODIFIER_STATE_TETHERED] = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
    }
end

function modifier_venomous_gale_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT
    }
end

function modifier_venomous_gale_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("movement_slow")
end

function modifier_venomous_gale_debuff:GetModifierIncomingSpellDamageConstant()
	return self:GetCaster():GetLevel()*self:GetAbility():GetSpecialValueFor("dam2")
end