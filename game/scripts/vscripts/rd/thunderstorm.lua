thunderstorm= class({})

LinkLuaModifier("modifier_thunderstorm", "rd/thunderstorm.lua", LUA_MODIFIER_MOTION_NONE)

function thunderstorm:IsHiddenWhenStolen()
    return false
end

function thunderstorm:IsStealable()
    return true
end

function thunderstorm:IsRefreshable()
    return true
end

function thunderstorm:OnAbilityPhaseStart()
    self:GetCaster():EmitSound("Hero_Zuus.ArcLightning.Cast")
    return true
end

function thunderstorm:OnSpellStart()
    local caster = self:GetCaster()
    local cur_pos = self:GetCursorPosition()
    local caster_pos = caster:GetAbsOrigin()
    local duration=self:GetSpecialValueFor("duration")
    caster.direction_thunderstorm = cur_pos==caster_pos and caster:GetForwardVector() or TG_Direction(cur_pos,caster_pos)
    EmitSoundOn("Hero_Zuus.LightningBolt", caster)
    local p = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControl( p, 0,  caster_pos+caster:GetUpVector()*400 )
    ParticleManager:SetParticleControl( p, 1,  cur_pos )
    ParticleManager:ReleaseParticleIndex(p)
	CreateModifierThinker(caster, self, "modifier_thunderstorm", {duration = duration}, caster_pos, caster:GetTeamNumber(), false)
end

function thunderstorm:OnProjectileHit_ExtraData(target, location, kv)
    if target==nil then
        return
    end
    local caster = self:GetCaster()
    if not caster:IsMagicImmune() then
             local damageTable = {
								victim = target,
								attacker = caster,
								damage = self:GetSpecialValueFor("base_dam")+caster:GetIntellect()*self:GetSpecialValueFor("int_per")*0.01,
								damage_type = self:GetAbilityDamageType(),
								ability = self,
								}
            ApplyDamage(damageTable)
            target:AddNewModifier(caster, self, "modifier_stunned", {duration=self:GetSpecialValueFor("stun")})
    end
end

modifier_thunderstorm=class({})

function modifier_thunderstorm:IsPurgable()
    return false
end

function modifier_thunderstorm:IsPurgeException()
    return false
end

function modifier_thunderstorm:IsHidden()
    return true
end

function modifier_thunderstorm:OnCreated(tg)
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.interval=self.ability:GetSpecialValueFor("interval")
    self.wh=self.ability:GetSpecialValueFor("wh")
    self.dis=self.ability:GetSpecialValueFor("dis")
    self.sp=self.ability:GetSpecialValueFor("sp")
    if not IsServer() then
            return
    end
    self.dir=self.caster.direction_thunderstorm
    self.pos=self.caster:GetAbsOrigin()
    self.team=self.parent:GetTeamNumber()
    self.parent_pos=self.parent:GetAbsOrigin()
    self:StartIntervalThink(self.interval)
end

function modifier_thunderstorm:OnIntervalThink()
    EmitSoundOn("Hero_Zuus.LightningBolt", self.caster)
    self.X=math.random(self.pos.x-400,self.pos.x+400)
    self.Y=math.random(self.pos.y-300,self.pos.y+300)
    local projectileTable = {
        Ability = self.ability,
        EffectName = "particles/tgp/thunderstorm/thunderstorm_m.vpcf",
        vSpawnOrigin = Vector(self.X,self.Y,self.parent.z),
        fDistance = self.dis,
        fStartRadius = self.wh,
        fEndRadius = self.wh,
        Source = self.caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        bProvidesVision = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC,
        vVelocity =self.dir*self.sp
    }
    ProjectileManager:CreateLinearProjectile( projectileTable )
end