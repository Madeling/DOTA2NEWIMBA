double_edge=class({})

function double_edge:IsHiddenWhenStolen() 
    return false 
end

function double_edge:IsStealable() 
    return true 
end

function double_edge:IsRefreshable() 			
    return true 
end

function double_edge:GetCooldown(iLevel)
    local cd=self.BaseClass.GetCooldown(self,iLevel)
    if  self:GetCaster():Has_Aghanims_Shard() then 
        return cd-1
    else 
        return cd
    end
end

function double_edge:OnSpellStart()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    local radius=self:GetSpecialValueFor( "radius" )
    local rg=self:GetSpecialValueFor( "rg" )+caster:TG_GetTalentValue("special_bonus_centaur_2")
    local rd=self:GetSpecialValueFor( "rd" )
    local sp=self:GetSpecialValueFor( "sp" )
    EmitSoundOn("Hero_Centaur.DoubleEdge.TI9", caster)
        local Projectile = 
        {
        Ability = self,
        EffectName = "particles/heros/centaur/centaur_axe.vpcf",
        vSpawnOrigin = caster_pos,
        fDistance = rg,
        fStartRadius = rd,
        fEndRadius =rd,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        fExpireTime = GameRules:GetGameTime() + 10.0,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        vVelocity =caster:GetForwardVector()*sp,
        bProvidesVision = false,
        }                
        ProjectileManager:CreateLinearProjectile(Projectile)
end



function double_edge:OnProjectileHit_ExtraData(target, location, kv)
    local caster=self:GetCaster()
    TG_IS_ProjectilesValue1(caster,function()
        target=nil
    end)
	if target==nil then
		return
	end
    if target:IsAlive() and  not target:IsMagicImmune() then
        local edge_damage=self:GetSpecialValueFor( "edge_damage" )
        local strength_damage=self:GetSpecialValueFor( "strength_damage" )+caster:TG_GetTalentValue("special_bonus_centaur_8")
        local damageTable =
        {
            victim = target,
            attacker = caster,
            damage =edge_damage+math.floor(caster:GetStrength())*strength_damage*0.01,
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self,
        }
        ApplyDamage(damageTable)
        local POS=target:GetAbsOrigin()
        local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_CUSTOMORIGIN, target)
        ParticleManager:SetParticleControlEnt(fx, 0, target, PATTACH_POINT, "attach_hitloc", POS, true)
        ParticleManager:SetParticleControlEnt(fx, 1, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(fx, 2, POS)
        ParticleManager:ReleaseParticleIndex(fx)
        EmitSoundOn("Hero_Centaur.DoubleEdge.TI9", target)
    end 
end