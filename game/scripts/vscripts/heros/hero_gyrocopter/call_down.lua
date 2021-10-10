call_down=class({})
LinkLuaModifier("modifier_call_down", "heros/hero_gyrocopter/call_down.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_call_down_buff", "heros/hero_gyrocopter/call_down.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_call_down_debuff", "heros/hero_gyrocopter/call_down.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_call_down_sniper", "heros/hero_gyrocopter/call_down.lua", LUA_MODIFIER_MOTION_NONE)
function call_down:IsHiddenWhenStolen()
    return false
end

function call_down:IsStealable()
    return true
end

function call_down:IsRefreshable()
    return true
end

function call_down:GetAOERadius()
    return self:GetSpecialValueFor("rd")
end


function call_down:OnSpellStart()
    local caster=self:GetCaster()
    local caster_pos=caster:GetAbsOrigin()
    local pos=self:GetCursorPosition()
    local m_rd=self:GetSpecialValueFor("m_rd")
    local delay=self:GetSpecialValueFor("delay")
    local dis=self:GetSpecialValueFor("dis")
    local sp=self:GetSpecialValueFor("sp")
    local max_m=self:GetSpecialValueFor("max_m")+1
    max_m= caster:TG_HasTalent("special_bonus_gyrocopter_6") and max_m+1 or max_m
    local dis_time=dis/sp
    local m_time=dis_time/max_m
    if caster:TG_HasTalent("special_bonus_gyrocopter_8") then
        local ab=caster:FindAbilityByName("rocket_barrage")
        if ab and ab:GetLevel()>0 then
            ab:OnSpellStart()
        end
        local ab1=caster:FindAbilityByName("guided_missile")
        if ab1  then
            ab1:EndCooldown()
        end
    end
    caster:AddNewModifier(caster, self, "modifier_call_down_buff", {duration=dis_time,t=m_time})
end

function call_down:OnProjectileHit_ExtraData( target, location, table )
    if target==nil then
         return
    end

    local caster = self:GetCaster()
    if not caster:IsMagicImmune() then
        EmitSoundOn("Hero_Gyrocopter.Rocket_Barrage.Impact", caster)
         local damageTable = {
             victim = target,
             attacker = caster,
             damage = self:GetSpecialValueFor("m_dam"),
             damage_type =DAMAGE_TYPE_MAGICAL,
             ability = self,
             }
         ApplyDamage(damageTable)
     end
 end

modifier_call_down=class({})

function modifier_call_down:IsHidden()
	return true
end

function modifier_call_down:IsPurgable()
	return false
end

function modifier_call_down:IsPurgeException()
	return false
end

function modifier_call_down:OnCreated()
    if not IsServer() then
        return
    end
    local rd= self:GetAbility():GetSpecialValueFor( "rd" )
    local particle1= ParticleManager:CreateParticle("particles/tgp/gyrocopter/calldown_marker.vpcf",PATTACH_CUSTOMORIGIN , nil)
    ParticleManager:SetParticleControl(particle1, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle1, 1,Vector(rd,rd,(0-rd)))
    self:AddParticle(particle1, false, false, 100, false, false)
    local P=
    {
        Target = self:GetParent(),
        Source = self:GetCaster(),
        Ability = self:GetAbility(),
        vSourceLoc = self:GetCaster():GetAbsOrigin(),
        EffectName ="particles/tgp/gyrocopter/calldown1.vpcf",
        iMoveSpeed =50,
        bDrawsOnMinimap = false,
        bDodgeable = false,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bProvidesVision = false,
    }
    ProjectileManager:CreateTrackingProjectile(P)
end

function modifier_call_down:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():EmitSound("Hero_Gyrocopter.CallDown.Damage")

    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        self:GetAbility():GetSpecialValueFor( "rd" ),
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false)
        for _, hero in pairs(heros) do
            if not hero:IsMagicImmune() then
                local damageTable = {
                    victim = hero,
                    attacker = self:GetParent(),
                    damage = self:GetAbility():GetSpecialValueFor( "dam" ),
                    damage_type =DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility(),
                    }
                ApplyDamage(damageTable)
                hero:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_call_down_debuff", {duration=self:GetAbility():GetSpecialValueFor( "debuff" )})
             end
        end
end



modifier_call_down_buff=class({})
function modifier_call_down_buff:IsHidden()
	return false
end

function modifier_call_down_buff:IsPurgable()
	return false
end

function modifier_call_down_buff:IsPurgeException()
	return false
end

function modifier_call_down_buff:OnCreated(tg)
    self.SP=self:GetAbility():GetSpecialValueFor("sp")
    if IsServer() then
        local time =0
        local max_m=self:GetAbility():GetSpecialValueFor("max_m")
        max_m= self:GetParent():TG_HasTalent("special_bonus_gyrocopter_6") and max_m+1 or max_m
        self.dir=self:GetParent():GetForwardVector()
        Timers:CreateTimer(0, function()
            time=time+1
            self:GetParent():EmitSound("Hero_Gyrocopter.CallDown.Fire")
            CreateModifierThinker(
                self:GetParent(),
                self:GetAbility(),
                "modifier_call_down",
                {duration=delay},
                self:GetParent():GetAbsOrigin(),
                self:GetParent():GetTeamNumber(),
                false)
            if time>=max_m or not self:GetParent() then
                return nil
            else
                return tg.t
            end
        end)
        self:StartIntervalThink(FrameTime())
    end
end

function modifier_call_down_buff:OnIntervalThink()
    self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.dir*(2000 / (1/FrameTime())))
end

function modifier_call_down_buff:Destroy()
    if IsServer() then
        FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetAbsOrigin(), false)
    end
end

function modifier_call_down_buff:CheckState()
    return
    {
        [MODIFIER_STATE_FLYING] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

function modifier_call_down_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_VISUAL_Z_DELTA,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
    }
end

function modifier_call_down_buff:GetModifierPercentageCasttime()
    return -100
end

function modifier_call_down_buff:GetModifierIgnoreCastAngle()
    return 1
end

function modifier_call_down_buff:GetVisualZDelta()
    return 300
end

function modifier_call_down_buff:GetModifierMoveSpeed_Absolute()
    return self.SP
end

modifier_call_down_debuff=class({})

function modifier_call_down_debuff:IsHidden()
	return false
end

function modifier_call_down_debuff:IsPurgable()
	return true
end

function modifier_call_down_debuff:IsPurgeException()
	return true
end

function modifier_call_down_debuff:OnCreated()
    self.HR=self:GetAbility():GetSpecialValueFor("hr")
    self.LSP=self:GetAbility():GetSpecialValueFor("less_sp")
end

function modifier_call_down_debuff:OnRefresh()
    self.HR=self:GetAbility():GetSpecialValueFor("hr")
    self.LSP=self:GetAbility():GetSpecialValueFor("less_sp")
end

function modifier_call_down_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET
    }
end

function modifier_call_down_debuff:GetModifierHPRegenAmplify_Percentage()
    return (0- self.HR)
end

function modifier_call_down_debuff:GetModifierHealAmplify_PercentageTarget()
    return (0- self.HR)
end

function modifier_call_down_debuff:GetModifierMoveSpeedBonus_Percentage()
    return (0-self.LSP)
end
