macropyre=class({})
LinkLuaModifier("modifier_macropyre_debuff", "heros/hero_jakiro/macropyre.lua", LUA_MODIFIER_MOTION_NONE)
function macropyre:IsHiddenWhenStolen()
    return false
end

function macropyre:IsStealable()
    return true
end

function macropyre:IsRefreshable()
    return true
end

function macropyre:OnSpellStart()
    local caster = self:GetCaster()
    local cpos = caster:GetAbsOrigin()
	local pos = self:GetCursorPosition()
    local team = caster:GetTeamNumber()
    local dir=TG_Direction(pos,cpos)
    local dis=TG_Distance(pos,cpos)
    local dur = self:GetSpecialValueFor("duration")
    local cast_range=self:GetSpecialValueFor("cast_range")
    local path_radius=self:GetSpecialValueFor("path_radius")
    local pos1 = RotatePosition(pos, QAngle(0, 60, 0), pos + dir * 350)
    local pos2 = RotatePosition(pos, QAngle(0, -60, 0), pos + dir * 350)
    CreateModifierThinker(caster, self, "modifier_macropyre_debuff", {duration=dur}, pos1, team, false)
    CreateModifierThinker(caster, self, "modifier_macropyre_debuff", {duration=dur}, pos2, team, false)
    if  cpos==pos then
            dir=caster:GetForwardVector()
      end
    local pp =
    {
        EffectName ="particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf",
        Ability = self,
        vSpawnOrigin =cpos,
        vVelocity =dir*2000,
        fDistance =cast_range+dis,
        fStartRadius = path_radius,
        fEndRadius = path_radius,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
    }
    ProjectileManager:CreateLinearProjectile( pp )
    EmitSoundOn("Hero_Jakiro.Macropyre.Cast", caster)
end


function macropyre:OnProjectileThink_ExtraData(vLocation, table)
	GridNav:DestroyTreesAroundPoint(vLocation,300,false)
end

function macropyre:OnProjectileHit_ExtraData(target, location, kv)
    local caster = self:GetCaster()
    if target==nil then
        return
    end
    local hp=self:GetSpecialValueFor( "hp" )
	local damageTable = {
		attacker = caster,
        victim = target	,
        damage = target:GetMaxHealth()*hp*0.01,
		damage_type =DAMAGE_TYPE_MAGICAL,
		ability = self,
		}
    ApplyDamage(damageTable)
end

modifier_macropyre_debuff=class({})

function modifier_macropyre_debuff:IsPurgable()
    return false
end

function modifier_macropyre_debuff:IsPurgeException()
    return false
end

function modifier_macropyre_debuff:IsHidden()
    return true
end

function modifier_macropyre_debuff:OnCreated()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.team=self.parent:GetTeamNumber()
    self.stpos=self.parent:GetAbsOrigin()
    self.cast_range=self.ability:GetSpecialValueFor("cast_range")
    self.path_radius=self.ability:GetSpecialValueFor("path_radius")
    self.damage=self.ability:GetSpecialValueFor("damage")
    self.burn_interval=self.ability:GetSpecialValueFor("burn_interval")
    self.dmg=self.ability:GetSpecialValueFor("dmg")
    if IsServer() then
        self.damageTable = {
            attacker = self.parent,
            damage = self.caster:HasScepter() and self.dmg+self.damage  or self.damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self.ability,
        }
        self.root=true
        self.dir=self.caster:GetForwardVector()
        self.pos=self.stpos+self.dir*self.cast_range
        self.pfx = ParticleManager:CreateParticle( "particles/econ/items/jakiro/jakiro_ti10_immortal/jakiro_ti10_macropyre.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControl( self.pfx, 0, self.stpos )
        ParticleManager:SetParticleControl( self.pfx, 1, self.pos)
        ParticleManager:SetParticleControl( self.pfx, 2, Vector(self:GetRemainingTime(),0,0))
        self:AddParticle(self.pfx, false, false, 1, false, false)
        EmitSoundOn("hero_jakiro.macropyre", self.parent)
        self:StartIntervalThink(self.burn_interval)
    end
end

function modifier_macropyre_debuff:OnIntervalThink()
    local heros = FindUnitsInLine(
        self.team,
        self.stpos,
        self.pos,
        self.parent,
        self.path_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE)
        if heros and #heros>0 then
            for _,target in pairs(heros) do
                    if self.caster:HasScepter() and self.root  then
                        target:AddNewModifier_RS(self.parent, self, "modifier_rooted", {duration=1})
                    end
                    self.damageTable.victim = target
                    ApplyDamage(self.damageTable)
            end
            self.root=false
        end
end
