wave_of_silence=class({})

function wave_of_silence:IsHiddenWhenStolen()
    return false
end

function wave_of_silence:IsStealable()
    return true
end

function wave_of_silence:IsRefreshable()
    return true
end

function wave_of_silence:GetCooldown(iLevel)
    return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_drow_ranger_6")
end


function wave_of_silence:OnSpellStart()
    local caster=self:GetCaster()
    local pos=self:GetCursorPosition()
    local cpos=caster:GetAbsOrigin()
    local wave_length=self:GetSpecialValueFor("wave_length")
    local wave_speed=self:GetSpecialValueFor("wave_speed")
    local wave_width=self:GetSpecialValueFor("wave_width")
    if caster:TG_HasTalent("special_bonus_drow_ranger_8") then
        local ab=caster:FindAbilityByName("multishot")
        if ab and ab:GetLevel()>0 then
            ab:EndCooldown()
            ab:RefreshCharges()
        end
    end
    local Projectile =
    {
        Ability = self,
        EffectName = "particles/units/heroes/hero_drow/drow_silence_wave.vpcf",
        vSpawnOrigin = cpos,
        fDistance = wave_length,
        fStartRadius = wave_width,
        fEndRadius =wave_width,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        vVelocity =TG_Direction(pos,cpos)*wave_speed,
        bProvidesVision = false,
    }
    ProjectileManager:CreateLinearProjectile(Projectile)
    EmitSoundOn("Hero_DrowRanger.Silence", caster)
end


function wave_of_silence:OnProjectileHit_ExtraData(target, location, kv)
    local caster=self:GetCaster()
	if target==nil then
		return
	end
    if caster:Has_Aghanims_Shard() then
        target:Purge(true, false, false, false, false)
    end

    if caster:TG_HasTalent("special_bonus_drow_ranger_4") then
        caster:PerformAttack(target, false, true, true, false, false, false, true)
    else
        caster:PerformAttack(target, false, false, true, false, false, false, true)
    end
        if not target:IsMagicImmune() then
            local knockback_duration=self:GetSpecialValueFor("knockback_duration")
            local dis= TG_Distance(caster:GetAbsOrigin(),target:GetAbsOrigin())
            local attdis=caster:Script_GetAttackRange()
            local kdis=0
            if dis<attdis then
                kdis=attdis-dis
            end
            target:AddNewModifier_RS(caster,self, "modifier_knockback", Knockback)
            target:AddNewModifier_RS(caster, self, "modifier_silence", {duration=self:GetSpecialValueFor("silence_duration")})
            local Knockback ={
                should_stun = false,
                knockback_duration = knockback_duration,
                duration = knockback_duration,
                knockback_distance = kdis,
                knockback_height = 100,
                center_x =  caster:GetAbsOrigin().x,
                center_y =  caster:GetAbsOrigin().y,
                center_z =  caster:GetAbsOrigin().z
            }
    end
end