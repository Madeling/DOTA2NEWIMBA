dragon_tail=class({})

LinkLuaModifier("modifier_dragon_tail", "heros/hero_dragon_knight/dragon_tail.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function dragon_tail:IsHiddenWhenStolen()
    return false
end

function dragon_tail:IsStealable()
    return true
end

function dragon_tail:IsRefreshable()
    return true
end

function dragon_tail:GetCastRange()
        if  self:GetCaster():HasModifier("modifier_elder_dragon_form") then
			return self:GetSpecialValueFor( "cast_range" )
		else
			return 600
		end
end

function dragon_tail:OnSpellStart()
    local caster = self:GetCaster()
    local pos = caster:GetAbsOrigin()
    local target = self:GetCursorTarget()
    local target_pos = target:GetAbsOrigin()
	local dis = TG_Distance(pos,target_pos)
    local dir = TG_Direction(target_pos,pos)
    if  caster:HasModifier("modifier_elder_dragon_form") then
        local P =
        {
            Target = target,
            Source = caster,
            Ability = self,
            EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform_proj.vpcf",
            iMoveSpeed = 1500,
            vSourceLoc = pos,
            bDrawsOnMinimap = false,
            bDodgeable = true,
            bIsAttack = false,
            bVisibleToEnemies = true,
            bReplaceExisting = false,
            bProvidesVision = false,
        }
        ProjectileManager:CreateTrackingProjectile( P )
    else
        if  target:TG_TriggerSpellAbsorb(self) then
            return
        end
        EmitSoundOn("Hero_DragonKnight.DragonTail.Target", caster)
        caster:ForcePlayActivityOnce(ACT_DOTA_VERSUS)
        local pf = ParticleManager:CreateParticle("particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_anim_firebreath.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW,caster)
        ParticleManager:SetParticleControlEnt(pf, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
        ParticleManager:SetParticleControlEnt(pf, 3,caster, PATTACH_POINT_FOLLOW, "attach_hitloc",pos, true)
        ParticleManager:ReleaseParticleIndex(pf)
        local P =
        {
            Ability = self,
            EffectName = "particles/tgp/tgab/ab5-1.vpcf",
            vSpawnOrigin =pos,
            fDistance = 1200,
            fStartRadius = 200,
            fEndRadius = 200,
            Source = caster,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            vVelocity = dir * 1500,
            ExtraData={dragon_tail=1}
        }
        ProjectileManager:CreateLinearProjectile(P)
        if caster:TG_HasTalent("special_bonus_dragon_knight_1") then
            Timers:CreateTimer(1, function()
                EmitSoundOn("Hero_DragonKnight.DragonTail.Target", caster)
                    local P1 =
                    {
                        Ability = self,
                        EffectName = "particles/tgp/tgab/ab5-1.vpcf",
                        vSpawnOrigin =pos+dir*1200,
                        fDistance = 1200,
                        fStartRadius = 200,
                        fEndRadius = 200,
                        Source = caster,
                        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                        vVelocity = -dir* 1500,
                        ExtraData={dragon_tail=1}
                    }
                    ProjectileManager:CreateLinearProjectile(P1)
                return nil
            end)
        end
        --local time=dis/1500
       -- caster:AddNewModifier(caster, self, "modifier_dragon_tail", {dir=dir,duration=time,target=target:entindex()})
    end

end


function dragon_tail:OnProjectileHit_ExtraData(target, location,kv)
    local caster=self:GetCaster()
    if target==nil then
        return
    end
    if  target:TG_TriggerSpellAbsorb(self) then
		return
	end
    if kv.dragon_tail==1 then
        target:AddNewModifier(caster, self, "modifier_imba_stunned", {duration=self:GetSpecialValueFor("stun_duration")})
    else
    local pos = caster:GetAbsOrigin()
    local target_pos = target:GetAbsOrigin()
    local dir = TG_Direction(target_pos,pos)
    EmitSoundOn("Hero_DragonKnight.DragonTail.Target", target)
    local explosion = self:GetSpecialValueFor("explosion")+caster:TG_GetTalentValue("special_bonus_dragon_knight_3")
    local explosion_rd = self:GetSpecialValueFor("explosion_rd")
    local dam_r = self:GetSpecialValueFor("dam_r")
    local stun_duration2 = self:GetSpecialValueFor("stun_duration2")
    local num =0
    local rg = 0
    local damageTable = {
        attacker = caster,
        damage = dam_r,
        damage_type =DAMAGE_TYPE_MAGICAL,
        ability = self,
        }
    Timers:CreateTimer(0, function()
        if num>=explosion then
            return nil
        end
        local pos2=target_pos+dir*rg
        EmitSoundOnLocationWithCaster(pos2, "Hero_DragonKnight.BreathFire", caster)
        local pf2 = ParticleManager:CreateParticle("particles/tgp/dk/dragon_tail1.vpcf", PATTACH_CUSTOMORIGIN,nil)
        ParticleManager:SetParticleControl(pf2, 0, pos2)
        ParticleManager:ReleaseParticleIndex(pf2)
        local heros = FindUnitsInRadius(
            caster:GetTeamNumber(),
            pos2,
            nil,
            explosion_rd,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,false)
            if #heros>0 then
                for _, hero in pairs(heros) do
                    if not hero:IsMagicImmune() then
                        hero:AddNewModifier(caster, self, "modifier_imba_stunned", {duration=stun_duration2})
                        damageTable.victim = hero
                        ApplyDamage(damageTable)
                    end
                end
            end
        rg=rg+350
        num=num+1
        return 0.5
      end)
    end
end

modifier_dragon_tail=class({})

function modifier_dragon_tail:IsHidden()
    return false
end

function modifier_dragon_tail:IsPurgable()
    return false
end

function modifier_dragon_tail:IsPurgeException()
    return false
end

function modifier_dragon_tail:OnCreated(tg)
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    if self.ability then
    self.stun_duration=self.ability:GetSpecialValueFor("stun_duration")+self:GetCaster():TG_GetTalentValue("special_bonus_dragon_knight_4")
    end
    if not IsServer() then
        return
    end
    self.DIR=ToVector(tg.dir)
    self.target=EntIndexToHScript(tg.target)
		if not self:ApplyHorizontalMotionController()then
			self:Destroy()
		end
end

function modifier_dragon_tail:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end
    self.parent:SetAbsOrigin(self.parent:GetAbsOrigin()+self.DIR* (1500 / (1.0 / FrameTime())))
end

function modifier_dragon_tail:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end


function modifier_dragon_tail:OnDestroy()
    if  IsServer() then
        self.parent:RemoveHorizontalMotionController(self)
        EmitSoundOn("Hero_DragonKnight.DragonTail.Target", self.target)
        self.parent:RemoveGesture(ACT_DOTA_VERSUS)
        self.parent:SetForwardVector(TG_Direction(self.target:GetAbsOrigin(),self.parent:GetAbsOrigin()))
        self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_2)
        local damageTable =
        {
            victim = self.target,
            attacker = self.parent,
            damage =self.ability:GetSpecialValueFor("dam_m"),
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self.ability,
        }
        ApplyDamage(damageTable)
        self.target:AddNewModifier(self.parent, self.ability, "modifier_imba_stunned", {duration=self.stun_duration})
    end
end

function modifier_dragon_tail:CheckState()
    return
     {
           [MODIFIER_STATE_INVULNERABLE] = true,
       }
end