CreateTalents("npc_dota_hero_abaddon", "heros/hero_abaddon/death_coil.lua")
death_coil=class({})
LinkLuaModifier("modifier_death_coil_buff", "heros/hero_abaddon/death_coil.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_death_coil_debuff", "heros/hero_abaddon/death_coil.lua", LUA_MODIFIER_MOTION_NONE)
function death_coil:IsHiddenWhenStolen()
    return false
end

function death_coil:IsRefreshable()
    return true
end

function death_coil:IsStealable()
    return true
end

function death_coil:OnSpellStart()
	local target=self:GetCursorTarget()
	local caster=self:GetCaster()
    local fx="particles/econ/items/abaddon/abaddon_alliance/abaddon_death_coil_alliance.vpcf"
    if not Is_Chinese_TG(caster,target) then
        fx="particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"
    end
    EmitSoundOn("Hero_Abaddon.DeathCoil.Cast", caster)
	local pp=
	{
		Target=target,
		Source=caster,
		Ability=self,
		EffectName=fx,
		iMoveSpeed=2000,
		vSourceLoc=caster:GetAbsOrigin(),
		bDodgeable=true,
		bIsAttack=false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
        bDrawsOnMinimap = false,
	}
	ProjectileManager:CreateTrackingProjectile(pp)
end

function death_coil:OnProjectileHit(target, location)
	if not target then
		return
	end
    if  target:TG_TriggerSpellAbsorb(self) then
        return
    end
    EmitSoundOn("Hero_Abaddon.DeathCoil.Target", target)
    local caster=self:GetCaster()
    if caster:TG_HasTalent("special_bonus_abaddon_3") then
    local heros = FindUnitsInRadius(
        caster:GetTeamNumber(),
        target:GetAbsOrigin(),
        nil,
        300,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,false)
        if #heros>0 then
            for _, hero in pairs(heros) do
                if Is_Chinese_TG(caster,hero) then
                    local heal=self:GetSpecialValueFor("heal")
                    hero:Heal(heal, self)
                    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hero, heal, nil)
                    hero:AddNewModifier(caster, self, "modifier_death_coil_buff", {duration=self:GetSpecialValueFor("buffdur")+caster:TG_GetTalentValue("special_bonus_abaddon_1")})
                else
                    if not hero:IsMagicImmune() then
                        local damageTable=
                        {
                            victim=hero,
                            attacker=caster,
                            damage=self:GetSpecialValueFor("damage"),
                            damage_type=DAMAGE_TYPE_MAGICAL,
                            ability=self,
                        }
                        ApplyDamage(damageTable)
                        if caster:Has_Aghanims_Shard() then
                            caster:PerformAttack(hero, true, true, true, false, true, false, true)
                        end
                        hero:AddNewModifier_RS(caster, self, "modifier_death_coil_debuff", {duration=self:GetSpecialValueFor("debuffdur")+caster:TG_GetTalentValue("special_bonus_abaddon_1")})
                    end
                end
            end
        end
    else
        if Is_Chinese_TG(caster,target) then
            local heal=self:GetSpecialValueFor("heal")
            target:Heal(heal, self)
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal, nil)
            target:AddNewModifier(caster, self, "modifier_death_coil_buff", {duration=self:GetSpecialValueFor("buffdur")+caster:TG_GetTalentValue("special_bonus_abaddon_1")})
        else
            if not target:IsMagicImmune() then
                local damageTable=
                {
                    victim=target,
                    attacker=caster,
                    damage=self:GetSpecialValueFor("damage"),
                    damage_type=DAMAGE_TYPE_MAGICAL,
                    ability=self,
                }
                ApplyDamage(damageTable)
                if caster:Has_Aghanims_Shard() then
                    caster:PerformAttack(target, true, true, true, false, true, false, true)
                end
                target:AddNewModifier_RS(caster, self, "modifier_death_coil_debuff", {duration=self:GetSpecialValueFor("debuffdur")+caster:TG_GetTalentValue("special_bonus_abaddon_1")})
            end
        end
    end
	return true
end

modifier_death_coil_buff=class({})

function modifier_death_coil_buff:IsPurgable()
    return true
end

function modifier_death_coil_buff:IsPurgeException()
    return true
end

function modifier_death_coil_buff:IsHidden()
    return false
end

function modifier_death_coil_buff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_death_coil_buff:GetEffectName()
    return "particles/econ/events/ti7/radiance_owner_ti7_smoke.vpcf"
end


function modifier_death_coil_buff:CheckState()
    return
    {
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
    }
end

function modifier_death_coil_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_AVOID_DAMAGE
	}

end

function modifier_death_coil_buff:GetModifierAvoidDamage(tg)
    if self:GetAbility() and tg.target==self:GetParent() and PseudoRandom:RollPseudoRandom(self:GetAbility(), self:GetAbility():GetSpecialValueFor("ch")) then
        return 1
    else
        return 0
    end
end

modifier_death_coil_debuff=class({})

function modifier_death_coil_debuff:IsPurgable()
    return true
end

function modifier_death_coil_debuff:IsPurgeException()
    return true
end

function modifier_death_coil_debuff:IsHidden()
    return false
end

function modifier_death_coil_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_death_coil_debuff:GetEffectName()
    return "particles/dark_smoke_test.vpcf"
end


function modifier_death_coil_debuff:CheckState()
    return
    {
        [MODIFIER_STATE_CANNOT_MISS] = false,
        [MODIFIER_STATE_PROVIDES_VISION] = true,

    }
end

function modifier_death_coil_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
        MODIFIER_PROPERTY_MISS_PERCENTAGE
	}
end

function modifier_death_coil_debuff:GetModifierProvidesFOWVision()
    return 1
end

function modifier_death_coil_debuff:GetModifierMiss_Percentage()
    return 100
end