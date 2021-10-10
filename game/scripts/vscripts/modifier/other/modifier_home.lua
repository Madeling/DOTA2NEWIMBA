modifier_home=class({})
function modifier_home:IsDebuff()
    return false
end
function modifier_home:IsHidden()
    return true
end
function modifier_home:IsPurgable()
    return false
end
function modifier_home:IsPurgeException()
    return false
end
function modifier_home:RemoveOnDeath()
    return false
end
function modifier_home:IsAura()
    return true
end
function modifier_home:GetModifierAura()
    return  "modifier_dfinv"
end
function modifier_home:GetAuraRadius()
    return 700
end
function modifier_home:GetAuraDuration()
    return 0
end
function modifier_home:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end
function modifier_home:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_home:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end
function modifier_home:OnCreated()
      if IsServer() then
            local particle = ParticleManager:CreateParticle("particles/basic_ambient/generic_range_display.vpcf", PATTACH_WORLDORIGIN,nil)
            ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle, 1, Vector(700, 0, 0))
            ParticleManager:SetParticleControl(particle, 2, Vector(10, 0, 0))
            ParticleManager:SetParticleControl(particle, 3, Vector(100, 0, 0))
            ParticleManager:SetParticleControl(particle, 15, Vector(220, 20, 60))
      end
end