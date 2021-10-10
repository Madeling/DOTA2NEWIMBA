culling_blade=class({})

LinkLuaModifier("modifier_culling_blade_sp", "heros/hero_axe/culling_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_culling_blade_buff", "heros/hero_axe/culling_blade.lua", LUA_MODIFIER_MOTION_NONE)
function culling_blade:IsHiddenWhenStolen()return false
end
function culling_blade:IsRefreshable()return true
end
function culling_blade:IsStealable()return true
end
function culling_blade:OnSpellStart()
    local curtar= self:GetCursorTarget()
    local hero=false
    self.caster=self.caster or self:GetCaster()
    if curtar:GetHealth() <= self:GetSpecialValueFor("kill_t")+self:GetSpecialValueFor("max_hp")*0.01 * self.caster:GetMaxHealth() then
            self.caster:EmitSound("Hero_Axe.Culling_Blade_Success")
            curtar:Purge(true, true, false, false, true)
            local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_CUSTOMORIGIN,  self.caster)
            ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", curtar:GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", curtar:GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(particle, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", curtar:GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(particle, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", curtar:GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(particle, 8, target, PATTACH_POINT_FOLLOW, "attach_hitloc", curtar:GetAbsOrigin(), false)
            ParticleManager:ReleaseParticleIndex(particle)
            local particle2 = ParticleManager:CreateParticle("particles/heros/axe/axe_cb1.vpcf", PATTACH_CUSTOMORIGIN,  self.caster)
            ParticleManager:SetParticleControlEnt(particle2, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", curtar:GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(particle2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", curtar:GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(particle2, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", curtar:GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(particle2, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", curtar:GetAbsOrigin(), false)
            ParticleManager:SetParticleControlEnt(particle2, 8, target, PATTACH_POINT_FOLLOW, "attach_hitloc", curtar:GetAbsOrigin(), false)
            ParticleManager:ReleaseParticleIndex(particle2)
            if  curtar:IsRealHero() then
                    hero=true
            end
            TG_Kill(self.caster, curtar, self)
            self.caster:AddNewModifier(self.caster, self, "modifier_culling_blade_sp", {duration =self:GetSpecialValueFor("sp_t") })
            if  hero==true then
                    self.caster:AddNewModifier(self.caster, self, "modifier_culling_blade_buff", {})
                    if self.caster:TG_HasTalent("special_bonus_axe_7") then
                            local hp=self.caster:GetMaxHealth()*0.5
                            local mana=self.caster:GetMaxMana()*0.5
                            self.caster:Heal(hp, self)
                            SendOverheadEventMessage(self.caster, OVERHEAD_ALERT_HEAL, self.caster,hp, nil)
                            self.caster:GiveMana(mana)
                            SendOverheadEventMessage(self.caster, OVERHEAD_ALERT_MANA_ADD, self.caster,mana, nil)
                    end
                    self:EndCooldown()
            end
    else
            local damage =
            {
                victim = curtar,
                attacker = self.caster,
                damage = self:GetSpecialValueFor("base_dam"),
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self,
            }
            ApplyDamage(damage)
            local particles = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, curtar)
            ParticleManager:ReleaseParticleIndex(particles)
            self.caster:EmitSound("Hero_Axe.Culling_Blade_Fail")
    end
end


modifier_culling_blade_sp=class({})
function modifier_culling_blade_sp:IsPurgable()return false
end
function modifier_culling_blade_sp:IsPurgeException()return false
end
function modifier_culling_blade_sp:IsHidden()return false
end
function modifier_culling_blade_sp:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end
function modifier_culling_blade_sp:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("sp")
end
function modifier_culling_blade_sp:GetEffectName()
    return "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf"
end

modifier_culling_blade_buff=class({})

function modifier_culling_blade_buff:IsHidden()
    return false
end

function modifier_culling_blade_buff:IsPurgable()
    return false
end

function modifier_culling_blade_buff:IsPurgeException()
    return false
end

function modifier_culling_blade_buff:RemoveOnDeath()
    return false
end

function modifier_culling_blade_buff:IsPermanent()
    return true
end

function modifier_culling_blade_buff:AllowIllusionDuplicate()
    return false
end
function modifier_culling_blade_buff:OnCreated()
        if IsServer() then
                self:IncrementStackCount()
        end
end
function modifier_culling_blade_buff:OnRefresh()
        self:OnCreated()
end
function modifier_culling_blade_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
end
function modifier_culling_blade_buff:GetModifierHealthBonus()
        return self:GetStackCount()*20
end