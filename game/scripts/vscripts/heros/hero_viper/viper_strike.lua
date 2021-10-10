viper_strike=class({})

LinkLuaModifier("modifier_viper_strike_debuff", "heros/hero_viper/viper_strike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_viper_strike_buff", "heros/hero_viper/viper_strike.lua", LUA_MODIFIER_MOTION_NONE)

function viper_strike:IsHiddenWhenStolen()
    return false
end

function viper_strike:IsStealable()
    return true
end

function viper_strike:IsRefreshable()
    return true
end


function viper_strike:OnSpellStart()
    local caster=self:GetCaster()
    local target=self:GetCursorTarget()
    local pos=target:GetAbsOrigin()
	local sp = self:GetSpecialValueFor("projectile_speed")
    EmitSoundOn("hero_viper.viperStrike",caster)
	local fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_viper/viper_viper_strike_barb.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl( fx, 6, Vector( sp, 0, 0 ))
	ParticleManager:SetParticleControlEnt(fx,0,caster,PATTACH_POINT_FOLLOW,"attach_hitloc",caster:GetAbsOrigin(),false)
    ParticleManager:SetParticleControlEnt(fx,1,target,PATTACH_POINT_FOLLOW,"attach_hitloc",target:GetAbsOrigin(),false)
    local P =
    {
        Target = target,
        Source = caster,
        Ability = self,
        EffectName = "",
        iMoveSpeed = sp,
        vSourceLoc = caster:GetAbsOrigin(),
        bDrawsOnMinimap = false,
        bDodgeable = true,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        bProvidesVision = false,
        ExtraData = {fx = fx,}
    }
    ProjectileManager:CreateTrackingProjectile(P)
end

function viper_strike:OnProjectileHit_ExtraData(target, location,kv)
    ParticleManager:DestroyParticle(kv.fx, false)
    ParticleManager:ReleaseParticleIndex(kv.fx)
    local caster=self:GetCaster()
	if not target then
		return
    end
    if  target:TG_TriggerSpellAbsorb(self) then
        return
    end
    local duration = self:GetSpecialValueFor( "duration" )
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil,self:GetSpecialValueFor( "rd" ), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    if #enemies>0 then
        for _, enemie in pairs(enemies) do
            if Is_Chinese_TG(enemie,caster) then
                enemie:AddNewModifier(caster, self, "modifier_viper_strike_buff", {duration=duration})
            else
                enemie:AddNewModifier_RS(caster, self, "modifier_viper_strike_debuff", {duration=duration})
            end
        end
    end

    return true
end

modifier_viper_strike_buff=class({})


function modifier_viper_strike_buff:IsPurgable()
    return false
end

function modifier_viper_strike_buff:IsPurgeException()
    return false
end

function modifier_viper_strike_buff:IsHidden()
    return false
end

function modifier_viper_strike_buff:GetAttributes()
    if self:GetCaster():HasScepter() then
        return MODIFIER_ATTRIBUTE_MULTIPLE
    end
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_viper_strike_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_viper_strike_buff:GetEffectName()
    return "particles/units/heroes/hero_viper/viper_viper_strike_debuff.vpcf"
end

function modifier_viper_strike_buff:StatusEffectPriority()
	return MODIFIER_PRIORITY_LOW
end

function modifier_viper_strike_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_poison_viper.vpcf"
end

function modifier_viper_strike_buff:OnCreated()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.caster=self:GetCaster()
    self.bonus_movement_speed=self.ability:GetSpecialValueFor("bonus_movement_speed")
    self.bonus_attack_speed=self.ability:GetSpecialValueFor("bonus_attack_speed")
    self.damage=self.ability:GetSpecialValueFor("damage")
    self.rate=self.ability:GetSpecialValueFor("rate")

    if IsServer() then
        self:StartIntervalThink(1)
    end
end


function modifier_viper_strike_buff:OnIntervalThink()
    self.parent:Heal(self.damage, self.ability)
    SendOverheadEventMessage(self.parent, OVERHEAD_ALERT_HEAL, self.parent,self.damage, nil)
end

function modifier_viper_strike_buff:DeclareFunctions()
	return
        {
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
            MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	    }
end

function modifier_viper_strike_buff:GetModifierAttackSpeedBonus_Constant(tg)
    return self.bonus_attack_speed
end


function modifier_viper_strike_buff:GetModifierMoveSpeedBonus_Percentage(tg)
    return self.bonus_movement_speed
end

function modifier_viper_strike_buff:GetModifierTurnRate_Percentage()
    return self.rate
end


modifier_viper_strike_debuff=class({})

function modifier_viper_strike_debuff:IsDebuff()
    return true
end

function modifier_viper_strike_debuff:IsPurgable()
    return false
end

function modifier_viper_strike_debuff:IsPurgeException()
    return false
end

function modifier_viper_strike_debuff:IsHidden()
    return false
end

function modifier_viper_strike_debuff:GetAttributes()
    if self:GetCaster():HasScepter() then
        return MODIFIER_ATTRIBUTE_MULTIPLE
    end
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_viper_strike_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_viper_strike_debuff:GetEffectName()
    return "particles/units/heroes/hero_viper/viper_viper_strike_debuff.vpcf"
end

function modifier_viper_strike_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_LOW
end

function modifier_viper_strike_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_poison_viper.vpcf"
end

function modifier_viper_strike_debuff:OnCreated()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.caster=self:GetCaster()
    self.bonus_movement_speed=self.ability:GetSpecialValueFor("bonus_movement_speed")
    self.bonus_attack_speed=self.ability:GetSpecialValueFor("bonus_attack_speed")
    self.damage=self.ability:GetSpecialValueFor("damage")
    self.rate=self.ability:GetSpecialValueFor("rate")

    if IsServer() then
        self:StartIntervalThink(1)
    end
end


function modifier_viper_strike_debuff:OnIntervalThink()
    local damage= {
        victim = self.parent,
        attacker = self.caster,
        damage = self.damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self.ability,
        }
    ApplyDamage(damage)
end

function modifier_viper_strike_debuff:DeclareFunctions()
	return
        {
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
            MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	    }
end

function modifier_viper_strike_debuff:GetModifierAttackSpeedBonus_Constant(tg)
    return 0-self.bonus_attack_speed
end


function modifier_viper_strike_debuff:GetModifierMoveSpeedBonus_Percentage(tg)
    return 0-self.bonus_movement_speed
end

function modifier_viper_strike_debuff:GetModifierTurnRate_Percentage()
    return 0-self.rate
end