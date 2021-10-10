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

function multishot:Init()
        self.caster=self:GetCaster()
end

function multishot:OnAbilityPhaseStart()
    local curpos=self:GetCursorPosition()
    local casterpos= self.caster:GetAbsOrigin()
     self.caster.shot_multishot=true
    local fx = ParticleManager:CreateParticle("particles/tgp/drow/drow_precision_modify.vpcf", PATTACH_CUSTOMORIGIN,  self.caster)
	ParticleManager:SetParticleControl(fx, 0, casterpos)
	ParticleManager:SetParticleControl(fx, 1, casterpos)
    ParticleManager:SetParticleControl(fx, 2, casterpos)
	ParticleManager:ReleaseParticleIndex(fx)
     self.caster:AddNewModifier( self.caster, self, "modifier_multishot_shot", {duration= self.caster:HasScepter() and 0.1 or 0.45,pos=curpos})
     self.caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 3)
    return true
end

function multishot:OnAbilityPhaseInterrupted()
    if  self.caster:HasModifier("modifier_multishot_shot") then
             self.caster.shot_multishot=false
             self.caster:RemoveModifierByName("modifier_multishot_shot")
    end
         self.caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
	return true
end

function multishot:OnSpellStart()
        local curpos=self:GetCursorPosition()
        AddFOWViewer( self.caster:GetTeamNumber(), curpos, 500, 3, false)
end

function multishot:OnProjectileHit_ExtraData(target, location, kv)
	if target==nil then
		return
	end
    if kv.fx then
	ParticleManager:DestroyParticle(kv.fx, true)
	ParticleManager:ReleaseParticleIndex(kv.fx)
    end
    local rd=self:GetSpecialValueFor("rd")
    local dmg=self:GetSpecialValueFor("dmg")+ self.caster:TG_GetTalentValue("special_bonus_drow_ranger_5")
    local root=self:GetSpecialValueFor("root")
    local pos=target:GetAbsOrigin()
    if  self.caster:HasScepter() then
        dmg=dmg+ self.caster:GetBaseDamageMax()*0.05
    end
    local fx=ParticleManager:CreateParticle("particles/units/heroes/hero_drow/drow_silence.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(fx, 0, pos)
    ParticleManager:SetParticleControl(fx, 1, Vector(rd,0,0))
    ParticleManager:SetParticleControl(fx, 3, pos)
    ParticleManager:ReleaseParticleIndex(fx)
    local heros = FindUnitsInRadius(
         self.caster:GetTeamNumber(),
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
                local damageTable =
                {
                    victim = hero,
                    attacker =  self.caster,
                    damage = dmg,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self,
                }
                ApplyDamage(damageTable)
                if not hero:IsMagicImmune() then
                    hero:AddNewModifier_RS( self.caster, self, "modifier_rooted", {duration=root})
                end
            end
        end
        EmitSoundOn("Hero_Clinkz.SearingArrows.Impact", target)
         self.caster:RemoveGesture(ACT_DOTA_CHANNEL_ABILITY_3)
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
            local pos=caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack1"))
            caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
            for b=1,num do
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