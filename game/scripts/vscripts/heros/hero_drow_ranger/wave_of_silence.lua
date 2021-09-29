wave_of_silence=class({})
LinkLuaModifier("modifier_wave_of_silence_th", "heros/hero_drow_ranger/wave_of_silence.lua", LUA_MODIFIER_MOTION_NONE)
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
    local dir=TG_Direction(pos,cpos)
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
        EffectName = "particles/econ/items/drow/drow_ti6_gold/drow_ti6_silence_gold_wave.vpcf",
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
        vVelocity =dir*wave_speed,
        bProvidesVision = false,
    }
    ProjectileManager:CreateLinearProjectile(Projectile)
    EmitSoundOn("Hero_DrowRanger.Silence", caster)
    if self:GetAutoCastState() then
            local time=wave_length/wave_speed
            local endpos=cpos+dir*(wave_length/2)
            local dur=self:GetSpecialValueFor("dur")
            Timers:CreateTimer(time, function()
                        EmitSoundOn("DOTA_Item.Cyclone.Activate", caster)
                        local fx = ParticleManager:CreateParticle("particles/tgp/wind_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
                        ParticleManager:SetParticleControl(fx, 0, endpos)
                        ParticleManager:SetParticleControl(fx, 5, Vector(self:GetSpecialValueFor("rd"), 0, 0))
                        ParticleManager:SetParticleControl(fx, 6, Vector(dur, 0, 0))
                        ParticleManager:ReleaseParticleIndex(fx)
                        CreateModifierThinker(caster, self, "modifier_wave_of_silence_th", {duration=dur},endpos, caster:GetTeamNumber(), false)
                        return nil
            end)
    end
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
    end
        if not target:IsMagicImmune() then
            local knockback_duration=self:GetSpecialValueFor("knockback_duration")
            local dis= TG_Distance(caster:GetAbsOrigin(),target:GetAbsOrigin())
            local attdis=caster:Script_GetAttackRange()
            local kdis=0
            if dis<attdis then
                kdis=attdis-dis
            end
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
            target:AddNewModifier_RS(caster,self, "modifier_knockback", Knockback)
            target:AddNewModifier_RS(caster, self, "modifier_silence", {duration=self:GetSpecialValueFor("silence_duration")})
    end
end


modifier_wave_of_silence_th=class({})
function modifier_wave_of_silence_th:IsDebuff()
	return false
end
function modifier_wave_of_silence_th:IsPurgable()
    return false
end
function modifier_wave_of_silence_th:IsPurgeException()
    return false
end
function modifier_wave_of_silence_th:IsHidden()
    return true
end
function modifier_wave_of_silence_th:OnCreated()
    if not IsServer() then
        return
    end
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.team=self.parent:GetTeamNumber()
    self.rd=self.ability:GetSpecialValueFor("rd")
    self.dur=self.ability:GetSpecialValueFor("dur")
    self.pos=self.parent:GetAbsOrigin()
    self.Knockback =
       {
            should_stun = true,
            knockback_duration = 0.2,
            duration = 0.2,
            knockback_distance = 200,
            knockback_height = 10,
      }
    self:StartIntervalThink(0.2)
end
function modifier_wave_of_silence_th:OnIntervalThink()
            local targets = FindUnitsInRadius(
                                            self.team,
                                            self.pos,
                                            nil,
                                            self.rd,
                                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                                            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                                            DOTA_UNIT_TARGET_FLAG_NONE,
                                            FIND_ANY_ORDER,
                                            false)
                  if  #targets>0 then
                        for _, target in pairs(targets) do
                            if  not target:IsMagicImmune() then
                                    local pos=target:GetAbsOrigin()
                                    self.Knockback.center_x =  pos.x+target:GetForwardVector()
                                    self.Knockback.center_y =  pos.y+target:GetRightVector()
                                    self.Knockback.center_z =  pos.z
                                    target:InterruptMotionControllers(true)
                                    target:AddNewModifier(self.parent,self.ability, "modifier_knockback", self.Knockback)
                            end
                        end
            end
end