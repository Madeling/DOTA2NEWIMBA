CreateTalents("npc_dota_hero_dragon_knight", "heros/hero_dragon_knight/breathe_fire.lua")
breathe_fire=class({})

LinkLuaModifier("modifier_breathe_fire_debuff", "heros/hero_dragon_knight/breathe_fire.lua", LUA_MODIFIER_MOTION_NONE)

function breathe_fire:IsHiddenWhenStolen()
    return false
end

function breathe_fire:IsStealable()
    return true
end

function breathe_fire:IsRefreshable()
    return true
end


function breathe_fire:OnSpellStart()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    local start_radius=self:GetSpecialValueFor( "start_radius" )
    local end_radius=self:GetSpecialValueFor( "end_radius" )
    local range=self:GetSpecialValueFor( "range" )
    local speed=self:GetSpecialValueFor( "speed" )
    local fx="particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"
    if caster:HasModifier("modifier_elder_dragon_form") then
        speed=speed*2
        range=range*2
        fx="particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire_.vpcf"
    end
    EmitSoundOn("Hero_DragonKnight.BreathFire", caster)
        local Projectile =
        {
        Ability = self,
        EffectName = fx,
        vSpawnOrigin = caster_pos,
        fDistance = range,
        fStartRadius = start_radius,
        fEndRadius =end_radius,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        vVelocity =caster:GetForwardVector()*speed,
        bProvidesVision = false,
        }
        ProjectileManager:CreateLinearProjectile(Projectile)
end


function breathe_fire:OnProjectileHit_ExtraData(target, location, kv)
    local caster=self:GetCaster()
	if target==nil then
		return
	end
    if target:IsAlive() and  not target:IsMagicImmune() then
        local damage=self:GetSpecialValueFor( "damage" )
        local duration=self:GetSpecialValueFor( "duration" )
        if caster:HasModifier("modifier_elder_dragon_form") then
            local damage2=self:GetSpecialValueFor( "damage2" )+caster:TG_GetTalentValue("special_bonus_dragon_knight_2")
            damage=damage+damage*damage2*0.01
        end
        target:AddNewModifier_RS(caster, self, "modifier_breathe_fire_debuff", {duration=duration})
        local damageTable =
        {
            victim = target,
            attacker = caster,
            damage =damage,
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self,
        }
        ApplyDamage(damageTable)
            if caster:TG_HasTalent("special_bonus_dragon_knight_4") then
                    caster:Heal(damage, self)
                    SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster,damage, nil)
            end
    end
end

modifier_breathe_fire_debuff=class({})

function modifier_breathe_fire_debuff:IsDebuff()
	return true
end

function modifier_breathe_fire_debuff:IsHidden()
	return false
end

function modifier_breathe_fire_debuff:IsPurgable()
	return true
end

function modifier_breathe_fire_debuff:IsPurgeException()
	return true
end

function modifier_breathe_fire_debuff:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.ar=self.ability:GetSpecialValueFor("ar")
    self.mr=self.ability:GetSpecialValueFor("mr")
end

function modifier_breathe_fire_debuff:OnRefresh()
    self.ar=self.ability:GetSpecialValueFor("ar")
    self.mr=self.ability:GetSpecialValueFor("mr")
end

function modifier_breathe_fire_debuff:DeclareFunctions()
    return
    {

        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_breathe_fire_debuff:GetModifierMagicalResistanceBonus()
	return self.mr
end

function modifier_breathe_fire_debuff:GetModifierPhysicalArmorBonus()
	return self.ar
end
