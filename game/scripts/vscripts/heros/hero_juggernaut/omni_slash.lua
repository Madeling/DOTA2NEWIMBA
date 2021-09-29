omni_slash=class({})
LinkLuaModifier("modifier_omni_slash_buff", "heros/hero_juggernaut/omni_slash.lua", LUA_MODIFIER_MOTION_NONE)

function omni_slash:IsHiddenWhenStolen()
    return false
end

function omni_slash:IsStealable()
    return true
end

function omni_slash:IsRefreshable()
    return true
end

function omni_slash:CastFilterResultTarget(tg)
    local caster=self:GetCaster()
    if  caster:HasModifier("modifier_blade_fury_buff") and not caster:HasModifier("modifier_item_aghanims_shard") then
        return UF_FAIL_CUSTOM
    end
    if  tg:GetTeamNumber()==caster:GetTeamNumber() then
        return UF_FAIL_CUSTOM
    end
    if IsServer() and  not tg:IsAlive() then
        return UF_FAIL_DEAD
	end
end

function omni_slash:GetCustomCastErrorTarget(tg)
    return "无法使用"
end


function omni_slash:OnSpellStart()
    local caster=self:GetCaster()
    local target=self:GetCursorTarget()
    local dur=self:GetSpecialValueFor("dur")+caster:TG_GetTalentValue("special_bonus_juggernaut_7")
    EmitSoundOn("Hero_Juggernaut.ArcanaTrigger", caster)
    caster:Purge(false,true,false,false,false)
    caster:AddNewModifier(caster, self, "modifier_omni_slash_buff",{duration=dur,target = target:entindex()})
    local p1 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_dash.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(p1, 0, caster, PATTACH_ABSORIGIN, nil, caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(p1, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(p1, 2, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p1)

    local p2 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_dash.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(p2, 0, caster, PATTACH_ABSORIGIN, nil, caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(p2, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(p2, 2, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p2)
end

function omni_slash:OnInventoryContentsChanged()
    local caster=self:GetCaster()
    if caster:HasScepter() then
        TG_Set_Scepter(caster,false,1,"swift_slash2")
    else
        TG_Set_Scepter(caster,true,1,"swift_slash2")
    end
end

modifier_omni_slash_buff=modifier_omni_slash_buff or class({})

function modifier_omni_slash_buff:IsHidden()
    return false
end


function modifier_omni_slash_buff:IsPurgable()
    return false
end

function modifier_omni_slash_buff:IsPurgeException()
    return false
end

function modifier_omni_slash_buff:GetStatusEffectName()
    return "particles/status_fx/status_effect_omnislash.vpcf"
end

function modifier_omni_slash_buff:StatusEffectPriority()
    return 100
end


function modifier_omni_slash_buff:OnCreated(tg)
    self.parent=self:GetParent()
    if not IsServer() then
        return
    end
        local i=self:GetAbility():GetSpecialValueFor("dami")
        self.kills=0
        self.end_pos=nil
        self.target = EntIndexToHScript(tg.target)
        self:SetStackCount(self:GetDuration()-1)
        self.parent:SetForwardVector(TG_Direction(self.target:GetAbsOrigin(),self.parent:GetAbsOrigin()))
        self.parent:SetAttacking(self.target)
        self.parent:SetForceAttackTarget(self.target)
        self.parent:SetAbsOrigin( self.target:GetAbsOrigin())
        self:OnIntervalThink()
        self:StartIntervalThink(i)
end

function modifier_omni_slash_buff:OnIntervalThink()
    self:SetStackCount(self:GetRemainingTime())
    EmitSoundOn("Hero_Juggernaut.Attack", self.parent)
    FindClearSpaceForUnit(self.parent, self.target:GetAbsOrigin()+RandomVector(666), true)
    local dir= TG_Direction(self.target:GetAbsOrigin(),self.parent:GetAbsOrigin())
    local p1 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_dash.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(p1, 0, self.parent, PATTACH_ABSORIGIN, nil, self.parent:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(p1, 1,  self.target:GetAbsOrigin())
    ParticleManager:SetParticleControl(p1, 2,  self.target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p1)
    local p2 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_dash.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(p2, 0, self.parent, PATTACH_ABSORIGIN, nil, self.parent:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(p2, 1,  self.target:GetAbsOrigin())
    ParticleManager:SetParticleControl(p2, 2,  self.target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p2)
    self.parent:SetForwardVector(dir)
    self.parent:SetAttacking(self.target)
    self.parent:SetForceAttackTarget(self.target)
    local pfx_tgt = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(pfx_tgt, 0, self.parent:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx_tgt, 1, self.target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(pfx_tgt)
    local pfx_trail = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_trail.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(pfx_trail, 0, self.parent:GetAbsOrigin())
    ParticleManager:SetParticleControl(pfx_trail, 1, self.target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(pfx_trail)
    self.parent:PerformAttack(self.target, false, true, true, false, true, false, true)
end

function modifier_omni_slash_buff:OnDestroy()
    if not IsServer() then
        return
    end
    if self.kills and self.kills>0 then
        local pfx = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_counter.vpcf", PATTACH_OVERHEAD_FOLLOW,self.parent)
        ParticleManager:SetParticleControl(pfx, 1, Vector(1, self.kills, 0))
        ParticleManager:SetParticleControl(pfx, 2, Vector(#tostring( self.kills), 0, 0))
        ParticleManager:ReleaseParticleIndex(pfx)
    end
    if self.target~=nil then
        FindClearSpaceForUnit(self.parent, self.target:GetAbsOrigin(), true)
    elseif self.end_pos~=nil then
        FindClearSpaceForUnit(self.parent, self.end_pos, true)
    else
        FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
    end
        self.parent:SetForceAttackTarget(nil)
end


function modifier_omni_slash_buff:OnDeath(tg)
	if not IsServer() then
		return
    end
    if tg.unit == self.target then
        if tg.unit:IS_TrueHero_TG() and tg.attacker==self.parent then
            self.end_pos=tg.unit:GetAbsOrigin()
            self.kills = self.kills + 1
            local time=self:GetRemainingTime()+1
            self:SetStackCount(time-1)
            self:SetDuration(time, true)
        end
            local enemies = FindUnitsInRadius(tg.attacker:GetTeamNumber(), tg.unit:GetAbsOrigin(), nil,800 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_FARTHEST, false)
            if  #enemies>0 then
                 self.target=enemies[RandomInt(1, #enemies)]
                 if (self.target==nil or not self.target:IsAlive()) and tg.attacker:HasModifier("modifier_omni_slash_buff") then
                    self.parent:RemoveModifierByName("modifier_omni_slash_buff")
                    return
                end
            else
                if tg.attacker:HasModifier("modifier_omni_slash_buff") then
                    self.parent:RemoveModifierByName("modifier_omni_slash_buff")
                    return
                end
            end
    end
end

function modifier_omni_slash_buff:CheckState()
    return
    {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

function modifier_omni_slash_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_omni_slash_buff:GetModifierMoveSpeed_Absolute()
    return 1
end

function modifier_omni_slash_buff:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_4
end