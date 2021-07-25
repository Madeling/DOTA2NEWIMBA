modifier_black_dragon=class({})

function modifier_black_dragon:IsHidden() 
    return false
end

function modifier_black_dragon:IsPurgable() 
    return false 
end

function modifier_black_dragon:IsPurgeException() 
    return false 
end

function modifier_black_dragon:RemoveOnDeath()
    return true 
end

function modifier_black_dragon:OnCreated()
    if not IsServer() then
        return
    end

end

function modifier_black_dragon:OnTakeDamage(tg)
    if not IsServer() then
        return
    end
    if tg.unit == self:GetParent() then
     if RollPseudoRandomPercentage(25,0,self) then 
            local tar_pos=tg.attacker:GetAbsOrigin()
            local pfx= ParticleManager:CreateParticle("particles/neutral_fx/black_dragon_fireball.vpcf", PATTACH_CUSTOMORIGIN,nil)
            ParticleManager:SetParticleControl(pfx, 0, tar_pos)
            ParticleManager:SetParticleControl(pfx, 1, tar_pos)
            ParticleManager:SetParticleControl(pfx, 2, Vector(1,0,0))
            ParticleManager:SetParticleControl(pfx, 3, tar_pos)
            ParticleManager:ReleaseParticleIndex( pfx )
            local damageTable = {
                victim = tg.attacker,
                attacker =  self:GetParent(),
                damage = tg.damage*0.3,
                damage_type =DAMAGE_TYPE_MAGICAL,
                damage_flags = DOTA_UNIT_TARGET_FLAG_NONE, 
                ability = nil,
                }
            ApplyDamage(damageTable)
        end
    end
   
end

function modifier_black_dragon:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end