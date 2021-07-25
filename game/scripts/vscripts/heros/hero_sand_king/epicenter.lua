epicenter=class({})
LinkLuaModifier("modifier_epicenter", "heros/hero_sand_king/epicenter.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_epicenter_s", "heros/hero_sand_king/epicenter.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_epicenter_m", "heros/hero_sand_king/epicenter.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function epicenter:IsHiddenWhenStolen()
    return false
end

function epicenter:IsStealable()
    return true
end

function epicenter:IsRefreshable()
    return true
end

function epicenter:GetIntrinsicModifierName()
    return "modifier_epicenter_s"
end

function epicenter:OnAbilityPhaseStart()
    local caster=self:GetCaster()
    EmitSoundOn( "Ability.SandKing_Epicenter.spell", caster )
    caster.epicenterfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter_tell.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(caster.epicenterfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_tail", caster:GetAbsOrigin(), false)
    return true
end

function epicenter:OnAbilityPhaseInterrupted()
	local caster = self:GetCaster()
    if caster.epicenterfx then
        ParticleManager:DestroyParticle(caster.epicenterfx, false)
        ParticleManager:ReleaseParticleIndex(caster.epicenterfx)
        caster.epicenterfx=nil
    end
	return true
end

function epicenter:OnSpellStart()
	local caster = self:GetCaster()
    local epicenter_pulses = self:GetSpecialValueFor("epicenter_pulses")+caster:TG_GetTalentValue("special_bonus_sand_king_4")
    local interval = self:GetSpecialValueFor("interval")
    EmitSoundOn( "Ability.SandKing_Epicenter", caster )
    caster:AddNewModifier(caster, self, "modifier_epicenter", {duration=epicenter_pulses*interval})
    if caster.epicenterfx then
        ParticleManager:DestroyParticle(caster.epicenterfx, false)
        ParticleManager:ReleaseParticleIndex(caster.epicenterfx)
        caster.epicenterfx=nil
    end
end


modifier_epicenter=class({})

function modifier_epicenter:IsPurgable()
    return false
end

function modifier_epicenter:IsPurgeException()
    return false
end

function modifier_epicenter:IsHidden()
    return true
end

function modifier_epicenter:OnCreated()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.team=self.caster:GetTeamNumber()
    self.epicenter_radius=self.ability:GetSpecialValueFor("epicenter_radius")
    self.radius=self.ability:GetSpecialValueFor("radius")
    self.interval=self.ability:GetSpecialValueFor("interval")
    self.dmg=self.ability:GetSpecialValueFor("dmg")
    self.epicenter_damage=self.ability:GetSpecialValueFor("epicenter_damage")+self.caster:TG_GetTalentValue("special_bonus_sand_king_1")
    self.damageTable=
                        {
                            attacker = self.caster,
                            damage = self.epicenter_damage,
                            damage_type = DAMAGE_TYPE_MAGICAL,
                            ability = self.ability,
                        }
    if not IsServer() then
        return
    end
    self:StartIntervalThink(self.interval)
end

function modifier_epicenter:OnIntervalThink()
    local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(fx, 0, self.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(fx, 1, Vector(self.epicenter_radius,1,1))
	ParticleManager:ReleaseParticleIndex(fx)
    local targets = FindUnitsInRadius(
            self.team,
            self.caster:GetAbsOrigin(),
            nil,
            self.epicenter_radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false)
        if #targets>0 then
            for _, target in pairs(targets) do
                        if not target:HasModifier("modifier_black_hole_debuff2") and target:IsAlive() then
                            target:AddNewModifier(self.caster, self.ability, "modifier_epicenter_m", {duration=0.12,pos=self.caster:GetAbsOrigin()})
                        end
                        self.damageTable. victim = target
                        ApplyDamage(self.damageTable)
            end
            self.epicenter_radius=self.epicenter_radius+self.radius
            if self.caster:TG_HasTalent("special_bonus_sand_king_8") then
                self.epicenter_damage=self.epicenter_damage+self.dmg
            end
        end
end

function modifier_epicenter:OnDestroy()
    if not IsServer() then
        return
    end
    StopSoundOn( "Ability.SandKing_Epicenter", self.caster )
end


modifier_epicenter_s=class({})

function modifier_epicenter_s:IsPurgable()
    return false
end

function modifier_epicenter_s:IsPurgeException()
    return false
end

function modifier_epicenter_s:IsHidden()
    return true
end

function modifier_epicenter_s:AllowIllusionDuplicate()
    return false
end

function modifier_epicenter_s:OnCreated()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.team=self.caster:GetTeamNumber()
    self.epicenter_radius=self.ability:GetSpecialValueFor("epicenter_radius")
    self.epicenter_damage=self.ability:GetSpecialValueFor("epicenter_damage")+self.caster:TG_GetTalentValue("special_bonus_sand_king_1")
     self.damageTable=
                        {
                            attacker = self.caster,
                            damage = self.epicenter_damage,
                            damage_type = DAMAGE_TYPE_MAGICAL,
                            ability = self.ability,
                        }
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_epicenter_s:OnIntervalThink()
    if self.caster:Has_Aghanims_Shard() and self.caster:IsAlive() then
    local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(fx, 0, self.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(fx, 1, Vector(self.epicenter_radius,1,1))
	ParticleManager:ReleaseParticleIndex(fx)
    local targets = FindUnitsInRadius(
            self.team,
            self.caster:GetAbsOrigin(),
            nil,
            self.epicenter_radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false)
        if #targets>0 then
            for _, target in pairs(targets) do
                    self.damageTable.victim = target
                    ApplyDamage( self.damageTable)
            end
        end
    end
end


modifier_epicenter_m= class({})

function modifier_epicenter_m:IsDebuff()
    return true
end

function modifier_epicenter_m:IsHidden()
    return false
end

function modifier_epicenter_m:IsPurgable()
    return false
end

function modifier_epicenter_m:IsPurgeException()
    return false
end

function modifier_epicenter_m:RemoveOnDeath()
	return false
end

function modifier_epicenter_m:GetMotionPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end

function modifier_epicenter_m:OnCreated(tg)
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    if not IsServer() then
        return
    end
    self.POS=self.parent:GetAbsOrigin()
    self.CENTER= ToVector(tg.pos)
    self.DIR= TG_Direction2(self.CENTER,self.POS)
    self.SP=500
    if self.caster:TG_HasTalent("special_bonus_sand_king_7") then
        self.SP=800
    end
        if not self:ApplyHorizontalMotionController() then
            self:Destroy()
        end
end


function modifier_epicenter_m:UpdateHorizontalMotion(t, g)
    if not IsServer() then
        return
    end
    if  self.parent:IsAlive() then
    self.parent:SetAbsOrigin(self.parent:GetAbsOrigin()+self.DIR*( self.SP/(1/g)))
end
end

function modifier_epicenter_m:OnDestroy()
    if  IsServer() then
        self.parent:RemoveHorizontalMotionController(self)
    end
end

function modifier_epicenter_m:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end