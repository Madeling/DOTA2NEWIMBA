flak_cannon=class({})

LinkLuaModifier("modifier_flak_cannon", "heros/hero_gyrocopter/flak_cannon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flak_cannon_pa", "heros/hero_gyrocopter/flak_cannon.lua", LUA_MODIFIER_MOTION_NONE)
function flak_cannon:GetIntrinsicModifierName()
    return "modifier_flak_cannon_pa"
end

function flak_cannon:IsHiddenWhenStolen()
    return false
end

function flak_cannon:IsStealable()
    return true
end

function flak_cannon:IsRefreshable()
    return true
end

function flak_cannon:OnSpellStart()
    local caster = self:GetCaster()
    EmitSoundOn("Hero_Gyrocopter.FlackCannon", caster)
    caster:AddNewModifier(caster, self, "modifier_flak_cannon", {duration=self:GetSpecialValueFor( "dur" )})
end

function flak_cannon:OnProjectileHit_ExtraData( target, location, table )
    if target==nil then
         return
    end

    local caster = self:GetCaster()
    if not target:IsAttackImmune() and not target:IsInvisible() then
        local dam=self:GetSpecialValueFor( "dam" )
        EmitSoundOn("Hero_Gyrocopter.Rocket_Barrage.Impact", caster)
         local damageTable = {
             victim = target,
             attacker = caster,
             damage = caster:GetLevel()*dam,
             damage_type =DAMAGE_TYPE_MAGICAL,
             ability = self,
             }
         ApplyDamage(damageTable)
     end
 end

modifier_flak_cannon_pa=class({})

function modifier_flak_cannon_pa:IsHidden()
	return false
end

function modifier_flak_cannon_pa:IsPurgable()
	return false
end

function modifier_flak_cannon_pa:IsPurgeException()
	return false
end


function modifier_flak_cannon_pa:OnCreated(tg)
    if not IsServer() then
        return
    end
  self:StartIntervalThink(1.6)
end


function modifier_flak_cannon_pa:OnIntervalThink()
    if self:GetParent():IsAlive() and self:GetParent():HasScepter() then
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        500,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false)
        if  #heros>0 then
            for _, hero in pairs(heros) do
                self:GetParent():PerformAttack(hero, false, true, true, false, true, false, true)
            end
        end
    end
end

modifier_flak_cannon=class({})

function modifier_flak_cannon:IsHidden()
	return false
end

function modifier_flak_cannon:IsPurgable()
	return false
end

function modifier_flak_cannon:IsPurgeException()
	return false
end

function modifier_flak_cannon:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


function modifier_flak_cannon:GetEffectName()
	return "particles/units/heroes/hero_gyrocopter/gyro_flak_cannon_overhead.vpcf"
end



function modifier_flak_cannon:CheckState()
    return
    {
        [MODIFIER_STATE_FLYING] = true,
    }
end


function modifier_flak_cannon:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_BONUS_DAY_VISION,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION
    }
end

function modifier_flak_cannon:GetModifierAttackRangeBonus()
    return self.ATTRG
end

function modifier_flak_cannon:GetBonusDayVision()
    return self.DAYV
end

function modifier_flak_cannon:GetBonusNightVision()
    if self:GetCaster():TG_HasTalent("special_bonus_gyrocopter_5") then
    return 1000
    end
    return 0
end


function modifier_flak_cannon:OnCreated(tg)
    self.ATTRG=self:GetAbility():GetSpecialValueFor( "attrg" )
    self.DAYV=self:GetAbility():GetSpecialValueFor( "dayv" )
    self.rd=self:GetAbility():GetSpecialValueFor( "rd" )
    self.NUM=self:GetAbility():GetSpecialValueFor( "num" )
    if not IsServer() then
        return
    end
    self:SetStackCount( self.NUM)
end

function modifier_flak_cannon:OnRefresh(tg)
    self:OnCreated(tg)
end


function modifier_flak_cannon:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker==self:GetParent() and tg.target~=self:GetParent() then
        local heros = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            tg.target:GetAbsOrigin(),
            nil,
            self.rd,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_ANY_ORDER,
            false)
            if  self.NUM>0 then
                self.NUM=self.NUM-1
                self:SetStackCount( self.NUM)
            for _, hero in pairs(heros) do
                if not hero:IsInvisible() and not hero:IsAttackImmune() then
                    local P=
                    {
                        Target = hero,
                        Source = self:GetParent(),
                        Ability = self:GetAbility(),
                        iSourceAttachment = RollPseudoRandomPercentage(50,0,self:GetAbility()) and DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 or DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
                        EffectName ="particles/tgp/gyrocopter/flak_cannon1.vpcf",
                        iMoveSpeed = self:GetParent():TG_HasTalent("special_bonus_gyrocopter_4") and 2500 or self:GetAbility():GetSpecialValueFor( "psp" ),
                        bDrawsOnMinimap = false,
                        bDodgeable = true,
                        bIsAttack = false,
                        bVisibleToEnemies = true,
                        bReplaceExisting = false,
                        bProvidesVision = false,
                    }
                    ProjectileManager:CreateTrackingProjectile(P)

                end
            end
        end
    end
end