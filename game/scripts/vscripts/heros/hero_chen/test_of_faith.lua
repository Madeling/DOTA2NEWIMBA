test_of_faith=class({})

function test_of_faith:IsHiddenWhenStolen() 
    return false 
end

function test_of_faith:IsStealable() 
    return true 
end


function test_of_faith:IsRefreshable() 			
    return true 
end

function test_of_faith:OnSpellStart()
    local caster=self:GetCaster()
    local curtar=self:GetCursorTarget()
    EmitSoundOn("Hero_Chen.PenitenceCast", curtar)
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_test_of_faith.vpcf", PATTACH_ABSORIGIN_FOLLOW, curtar) 
    ParticleManager:SetParticleControl(particle, 0,curtar:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle) 
    if Is_Chinese_TG(curtar,caster) then 
        local hp=RandomInt(self:GetSpecialValueFor("heal_min"), self:GetSpecialValueFor("heal_max"))
        curtar:Heal(hp, self)
        SendOverheadEventMessage(hero, OVERHEAD_ALERT_HEAL, curtar,hp, nil)
    else 
        if  curtar:TG_TriggerSpellAbsorb(self) then
            return
        end
        local damageTable = {
            victim = curtar,
            attacker = caster,
            damage = RandomInt(self:GetSpecialValueFor("damage_min"), self:GetSpecialValueFor("damage_max")),
            damage_type = DAMAGE_TYPE_PURE,
            ability = self,
            }
        ApplyDamage(damageTable)
    end
end