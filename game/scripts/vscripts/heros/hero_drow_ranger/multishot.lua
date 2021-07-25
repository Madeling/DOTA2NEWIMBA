multishot=class({})
LinkLuaModifier("modifier_multishot_shot", "heros/hero_drow_ranger/multishot.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_multishot_th", "heros/hero_drow_ranger/multishot.lua", LUA_MODIFIER_MOTION_NONE)
function multishot:IsHiddenWhenStolen()
    return false
end

function multishot:IsStealable()
    return true
end

function multishot:IsRefreshable()
    return true
end

function multishot:GetCastPoint()
    if self:GetCaster():HasScepter() then
        return 0.1
    else
        return 0.45
    end
end

function multishot:GetCastRange()
        if self:GetCaster():TG_HasTalent("special_bonus_drow_ranger_3") then
			return 3000
		else
			return 2500
		end
end

function multishot:OnAbilityPhaseStart()
    local caster=self:GetCaster()
    local curpos=self:GetCursorPosition()
    local casterpos=caster:GetAbsOrigin()
    caster.shot_multishot=true
    local fx = ParticleManager:CreateParticle("particles/tgp/drow/drow_precision_modify.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(fx, 0, casterpos)
	ParticleManager:SetParticleControl(fx, 1, casterpos)
    ParticleManager:SetParticleControl(fx, 2, casterpos)
	ParticleManager:ReleaseParticleIndex(fx)
    caster:AddNewModifier(caster, self, "modifier_multishot_shot", {duration=caster:HasScepter() and 0.1 or 0.45,pos=curpos})
    caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 3)
    AddFOWViewer(caster:GetTeamNumber(), curpos, 500, 3, false)
    return true
end

function multishot:OnAbilityPhaseInterrupted()
	local caster = self:GetCaster()
    if caster:HasModifier("modifier_multishot_shot") then
            caster.shot_multishot=false
            caster:RemoveModifierByName("modifier_multishot_shot")
    end
        caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
	return true
end


function multishot:OnProjectileHit_ExtraData(target, location, kv)
    local caster=self:GetCaster()
	if target==nil then
		return
	end
    if kv.fx then
	ParticleManager:DestroyParticle(kv.fx, true)
	ParticleManager:ReleaseParticleIndex(kv.fx)
    end
    local rd=self:GetSpecialValueFor("rd")
    local dmg=self:GetSpecialValueFor("dmg")+caster:TG_GetTalentValue("special_bonus_drow_ranger_5")
    local dmg1=self:GetSpecialValueFor("dmg1")
    local root=self:GetSpecialValueFor("root")
    local pos=target:GetAbsOrigin()
    if caster:HasScepter() then
        dmg=dmg+caster:GetBaseDamageMax()*0.07
    end
    local fx=ParticleManager:CreateParticle("particles/units/heroes/hero_drow/drow_silence.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(fx, 0, pos)
    ParticleManager:SetParticleControl(fx, 1, Vector(rd,0,0))
    ParticleManager:SetParticleControl(fx, 3, pos)
    ParticleManager:ReleaseParticleIndex(fx)
    local heros = FindUnitsInRadius(
        caster:GetTeamNumber(),
        target:GetAbsOrigin(),
        nil,
        rd,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false )
        if #heros > 0 then
            for _,hero in pairs(heros) do
                if hero:IsSilenced() then
                    dmg=dmg+dmg*0.01*dmg1
                end
                local damageTable =
                {
                    victim = hero,
                    attacker = caster,
                    damage = dmg,
                    damage_type = caster:HasModifier("modifier_marksmanship") and DAMAGE_TYPE_PURE or DAMAGE_TYPE_PHYSICAL,
                    damage_flags=DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION ,
                    ability = self,
                }
                ApplyDamage(damageTable)
                if not hero:IsMagicImmune() then
                    hero:AddNewModifier_RS(caster, self, "modifier_rooted", {duration=root})
                end
            end
        end
        EmitSoundOn("Hero_Clinkz.SearingArrows.Impact", target)
        caster:RemoveGesture(ACT_DOTA_CHANNEL_ABILITY_3)
        target:Kill(nil, nil)
        return true
end

modifier_multishot_shot=class({})


function modifier_multishot_shot:IsPurgable()
    return false
end

function modifier_multishot_shot:IsPurgeException()
    return false
end

function modifier_multishot_shot:IsHidden()
    return true
end

function modifier_multishot_shot:RemoveOnDeath()
    return true
end

function modifier_multishot_shot:OnCreated(tg)
    if IsServer() then
        self.pos=ToVector(tg.pos)
    end
end

function modifier_multishot_shot:OnDestroy()
    if IsServer() then
        local caster=self:GetCaster()
        if caster.shot_multishot then
            local ability=self:GetAbility()
            local casterpos=caster:GetAbsOrigin()
            local team=caster:GetTeamNumber()
            local sp=ability:GetSpecialValueFor("sp")
            local sp1=ability:GetSpecialValueFor("sp1")
            local num=ability:GetSpecialValueFor("num")
            local num1=ability:GetSpecialValueFor("num1")
            local num2=caster:HasModifier("modifier_marksmanship") and  num1+num or num
            local pos=caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack1"))
            caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
            for b=1,num2 do
                EmitSoundOn("Hero_DrowRanger.FrostArrows", caster)
                local null=CreateModifierThinker(caster, ability, "modifier_multishot_th", {duration=30}, Vector(self.pos.x+RandomInt(-300, 300),self.pos.y+RandomInt(-300, 300),0), team, false)
                local fx = ParticleManager:CreateParticle("particles/tgp/drow/drow_m0.vpcf", PATTACH_CUSTOMORIGIN, nil)
                ParticleManager:SetParticleControl(fx, 0, pos)
                ParticleManager:SetParticleControl(fx, 1, null:GetAbsOrigin())
                ParticleManager:SetParticleControl(fx, 2, Vector(sp, 0, 0))
                ParticleManager:SetParticleControlEnt(fx, 7, null, PATTACH_INVALID, nil, null:GetAbsOrigin(), true)
                local PP =
                {
                    Target = null,
                    Source = caster,
                    Ability = ability,
                    EffectName = nil,
                    iMoveSpeed = sp,
                    vSourceLoc = pos,
                    bDrawsOnMinimap = true,
                    bDodgeable = false,
                    bIsAttack = false,
                    bVisibleToEnemies = true,
                    bReplaceExisting = false,
                    bProvidesVision = true,
                    iVisionTeamNumber =team,
                    iVisionRadius = 500,
                    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
                    bProvidesVision = false,
                    ExtraData = {fx = fx}
                }
                ProjectileManager:CreateTrackingProjectile(PP)
                sp=sp+sp1
            end
        end
    end
end

modifier_multishot_th=class({})


function modifier_multishot_th:IsPurgable()
    return false
end

function modifier_multishot_th:IsPurgeException()
    return false
end

function modifier_multishot_th:IsHidden()
    return true
end

function modifier_multishot_th:RemoveOnDeath()
    return true
end