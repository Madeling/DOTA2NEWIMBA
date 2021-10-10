mountain=class({})
function mountain:IsHiddenWhenStolen()
    return false
end
function mountain:IsStealable()
    return true
end
function mountain:IsRefreshable()
    return true
end
function mountain:Precache( context )
	PrecacheResource( "particle", "particles/tgp/mountain_m.vpcf", context )
end
function mountain:OnSpellStart()
    local caster=self:GetCaster()
    local pos=caster:GetAbsOrigin()
    local tpos=self:GetCursorPosition()
    local dmg=caster:GetPrimaryStatValue()*self:GetSpecialValueFor("Stat")
    local damageTable = {
            attacker = caster,
            ability = self,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage = dmg
        }
                local p1 = ParticleManager:CreateParticle("particles/tgp/mountain_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
                ParticleManager:SetParticleControl(p1, 0, tpos + caster:GetUpVector() * 1000)
                ParticleManager:SetParticleControl(p1, 1,  tpos)
                ParticleManager:SetParticleControl(p1, 2, Vector(1, 0, 0))
                ParticleManager:ReleaseParticleIndex(p1)
                  Timers:CreateTimer(1,function()
                        caster:EmitSound('Hero_Invoker.ChaosMeteor.Impact')
                        local heros =
                            FindUnitsInRadius(
                            caster:GetTeamNumber(),
                            tpos,
                            nil,
                            500,
                            DOTA_UNIT_TARGET_TEAM_ENEMY,
                            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                            DOTA_UNIT_TARGET_FLAG_NONE,
                            FIND_ANY_ORDER,
                            false
                        )
                        if #heros > 0 then
                            for _, hero in pairs(heros) do
                                damageTable.victim = hero
                                ApplyDamage(damageTable)
                                hero:AddNewModifier(caster, self, "modifier_imba_stunned", {duration=1})
                            end
                        end
                            return nil
                  end )
end