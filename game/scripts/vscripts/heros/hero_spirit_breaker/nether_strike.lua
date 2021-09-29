nether_strike=class({})

LinkLuaModifier("modifier_nether_strike_illusions", "heros/hero_spirit_breaker/nether_strike.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_nether_strike_die", "heros/hero_spirit_breaker/nether_strike.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function nether_strike:IsHiddenWhenStolen()
    return false
end

function nether_strike:IsStealable()
    return false
end

function nether_strike:IsRefreshable()
    return true
end

function nether_strike:GetCastRange( vLocation, hTarget )
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )+self:GetCaster():TG_GetTalentValue("special_bonus_spirit_breaker_7")
end

function nether_strike:GetCooldown(iLevel)
    return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_spirit_breaker_8")
end

function nether_strike:GetCastPoint()
   if self:GetCaster():Has_Aghanims_Shard() then
        return 0
    end
    return 0.7
end

function nether_strike:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    EmitSoundOn("Hero_Spirit_Breaker.NetherStrike.Begin", caster)
    return true
end


function nether_strike:OnSpellStart()
    local caster = self:GetCaster()
    local target=self:GetCursorTarget()
    local caster_pos=caster:GetAbsOrigin()
    local target_pos=target:GetAbsOrigin()
    local dir=TG_Direction(caster_pos,target_pos)
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
    if  target:TG_TriggerSpellAbsorb(self) then
		return
	end
    local sp=self:GetSpecialValueFor("sp")
    local damage=self:GetSpecialValueFor("damage")
    local Knockback={
        should_stun = true,
        knockback_duration = 1,
        duration = 1,
        knockback_height = 100,
        knockback_distance = 50
    }
    local damageTable = {
		attacker = caster,
        victim = target,
		damage_type =DAMAGE_TYPE_MAGICAL,
		ability = self,
		}
    if self:GetAutoCastState() then
        local trd=self:GetSpecialValueFor("trd")
        local modifier=
        {
            outgoing_damage=0,
            incoming_damage=0,
            bounty_base=0,
            bounty_growth=0,
            outgoing_damage_structure=0,
            outgoing_damage_roshan=0,
        }
        local heros = FindUnitsInRadius(
            caster:GetTeamNumber(),
            target_pos,
            nil,
            trd,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_CLOSEST,
            false)
        if #heros>0 then
                local num=1
                Timers:CreateTimer(0, function()
                if heros[num] and IsValidEntity(heros[num]) and heros[num]:IsAlive() then
                    local illusions=CreateIllusions(caster, caster, modifier, 1,100, false, false)
                    for _, illusion in pairs(illusions) do
                        illusion:AddNewModifier(caster, self, "modifier_kill", {duration=30})
                        illusion:AddNewModifier(caster, self, "modifier_nether_strike_illusions", {target=heros[num]:entindex()})
                    end
                    num=num+1
                end
                if num>#heros then
                    return nil
                else
                    return 0.2
                end
                end)
        end
    else
        caster:SetForwardVector(dir)
        FindClearSpaceForUnit(caster,target_pos+caster:GetForwardVector()*-150, true)
        caster:MoveToTargetToAttack(target)
        caster:SetAngles(0, 0, 0)
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf" , PATTACH_CENTER_FOLLOW,target)
        ParticleManager:SetParticleControl(particle, 0, target_pos)
        ParticleManager:SetParticleControl(particle, 1, target_pos)
        ParticleManager:SetParticleControl(particle, 2, target_pos)
        ParticleManager:ReleaseParticleIndex(particle)
        EmitSoundOn("Hero_Spirit_Breaker.GreaterBash", target)
        if caster:HasScepter() then
            target:AddNewModifier(caster,self, "modifier_nether_strike_die",{duration=0.2})
        end
        damageTable.damage = damage+(caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true)*(sp)*0.01)
        ApplyDamage(damageTable)
        Knockback.center_x = target_pos.x
        Knockback.center_y = target_pos.y
        Knockback.center_z = target_pos.z
        target:AddNewModifier_RS(caster,self, "modifier_knockback",Knockback)
    end
end


modifier_nether_strike_illusions=class({})

function modifier_nether_strike_illusions:IsHidden()
    return false
end

function modifier_nether_strike_illusions:IsPurgable()
    return false
end

function modifier_nether_strike_illusions:IsPurgeException()
    return false
end

function modifier_nether_strike_illusions:IsIllusion()
    return true
end

function modifier_nether_strike_illusions:RemoveOnDeath()
    return false
end

function modifier_nether_strike_illusions:GetStatusEffectName()
    return "particles/status_fx/status_effect_charge_of_darkness.vpcf"
end

function modifier_nether_strike_illusions:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_nether_strike_illusions:GetMotionPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_LOW
end

function modifier_nether_strike_illusions:OnCreated(tg)
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.team=self.parent:GetTeamNumber()
    self.stun=self.ability:GetSpecialValueFor("stun")
    self.damage=self.ability:GetSpecialValueFor("damage")
    if not IsServer() then
        return
    end
    self.damageTable = {
		attacker = self.caster,
		damage_type =DAMAGE_TYPE_MAGICAL,
		ability = self.ability,
		}
    self.parent:AddActivityModifier("charge")
    local particle = ParticleManager:CreateParticle("particles/econ/items/spirit_breaker/spirit_breaker_iron_surge/spirit_breaker_charge_iron.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
    ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 60, Vector(RandomInt(0, 255),RandomInt(0, 255),RandomInt(0, 255)))
    ParticleManager:SetParticleControl(particle, 61, Vector(1,0,0))
    self:AddParticle( particle, false, false, 20, false, false )
    EmitSoundOn("Hero_Spirit_Breaker.Charge.Impact",self.parent)
    self.target=EntIndexToHScript(tg.target)
		if not self:ApplyHorizontalMotionController()then
			self:Destroy()
		end

end

function modifier_nether_strike_illusions:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end
    local cpos=self.parent:GetAbsOrigin()
    local tpos=self.target:GetAbsOrigin()
    local dis=TG_Distance(cpos,tpos)
    local dir=TG_Direction(tpos,cpos)
    self.parent:MoveToPosition(tpos)
    if  not self.parent:IsAlive() or not self.target or not self.target:IsAlive() or dis<=100 then
            local heros = FindUnitsInRadius(
                self.team,
                cpos,
                nil,
                300,
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                FIND_CLOSEST,
                false)
            if #heros>0 then
                for _, hero in pairs(heros) do
                        EmitSoundOn("Hero_Spirit_Breaker.GreaterBash",hero)
                        local pos=hero:GetAbsOrigin()
                        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf" , PATTACH_CENTER_FOLLOW,hero)
                        ParticleManager:SetParticleControl(particle, 0, pos)
                        ParticleManager:SetParticleControl(particle, 1, pos)
                        ParticleManager:SetParticleControl(particle, 2, pos)
                        ParticleManager:ReleaseParticleIndex(particle)
                        hero:AddNewModifier_RS(self.parent,self.ability, "modifier_imba_stunned", {duration=self.stun})
                        self.damageTable.victim = hero
                        self.damageTable.damage = self.damage
                        ApplyDamage(self.damageTable)
                end
            end
        self:Destroy()
        self.parent:Kill(self.ability, self.parent)
        return
    end
    self.parent:StartGesture(ACT_DOTA_RUN)
    self.parent:SetAbsOrigin(cpos+dir*(1200 / (1.0 / g)))
end

function modifier_nether_strike_illusions:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end

function modifier_nether_strike_illusions:OnDestroy()
    if not IsServer() then
        return
    end
    self.parent:ClearActivityModifiers()
    self.parent:RemoveGesture(ACT_DOTA_RUN)
    self.parent:StartGesture(ACT_DOTA_SPIRIT_BREAKER_CHARGE_END)
    self.parent:RemoveHorizontalMotionController(self)
end

function modifier_nether_strike_illusions:CheckState()
    return
    {
          [MODIFIER_STATE_DISARMED] = true,
          [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
          [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
          [MODIFIER_STATE_INVULNERABLE] = true,
          [MODIFIER_STATE_UNSELECTABLE] = true,
          [MODIFIER_STATE_UNTARGETABLE] = true,
          [MODIFIER_STATE_NO_HEALTH_BAR] = true,
      }
end


modifier_nether_strike_die=class({})

function modifier_nether_strike_die:IsHidden()
    return true
end

function modifier_nether_strike_die:IsPurgable()
    return false
end

function modifier_nether_strike_die:IsPurgeException()
    return false
end


function modifier_nether_strike_die:DeclareFunctions()
	return
		{
            MODIFIER_EVENT_ON_DEATH
		}
end


function modifier_nether_strike_die:OnDeath(tg)
    if not IsServer() then
        return
    end

    if tg.unit == self:GetParent() and tg.inflictor==self:GetAbility()  then
        self:GetAbility():EndCooldown()
    end
end
