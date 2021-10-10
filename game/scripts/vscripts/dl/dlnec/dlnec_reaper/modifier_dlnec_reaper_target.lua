
modifier_dlnec_reaper_target = class({})

function modifier_dlnec_reaper_target:IsHidden() return false end
function modifier_dlnec_reaper_target:IsBuff() return false end
function modifier_dlnec_reaper_target:IsDebuff() return true end
function modifier_dlnec_reaper_target:IsStunDebuff() return true end
function modifier_dlnec_reaper_target:IsPurgable() return false end
function modifier_dlnec_reaper_target:IsPurgeException() return false end
function modifier_dlnec_reaper_target:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_dlnec_reaper_target:RemoveOnDeath() return self:GetParent():IsIllusion() end

function modifier_dlnec_reaper_target:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_dlnec_reaper_target:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_dlnec_reaper_target:GetOverrideAnimation() return ACT_DOTA_DISABLED end
function modifier_dlnec_reaper_target:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_dlnec_reaper_target:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_dlnec_reaper_target:ShouldUseOverheadOffset() return true end

function modifier_dlnec_reaper_target:OnCreated()
    if not IsServer() then return end

    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local target = self:GetParent()

    target:AddNewModifier(caster, ability, "modifier_dlnec_reaper_permanent", {})

    --local abilitystring = print(self:GetAbility():GetAbilityName())   --测试打印调用此modi的其他技能名称。有效。
    local dabyss = caster:FindAbilityByName("dlnec_dabyss")
    if dabyss and self:GetAbility() == dabyss then  --播放特效，死亡深渊特效有区别
        self:playeffects_dabyss(target)
    else
        self:playeffects(target)
    end

    --[[local respawntime = self:GetParent():GetRespawnTime()
    if respawntime then print("get") else print("no") end
    print(respawntime.."respawn")   --哎，怎么乱加]]

end

function modifier_dlnec_reaper_target:OnRemoved()   --onremoved移除前，ondestroy移除后，用remove的话，可能不需要像老技能一样两层光环来确保击杀者NEC。
    if not IsServer() then return end

    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local target = self:GetParent()

    if not ability then return end

    local damage = (target:GetMaxHealth() - target:GetHealth()) * ability:GetSpecialValueFor("reaper_damageco")
    local damageTable = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = self:GetAbility():GetAbilityDamageType(),
        damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, --Optional.
        ability = ability, --Optional.
        }
    ApplyDamage(damageTable)    --确保击杀者为nec的代码在addon_game_mode的伤害过滤器里

end

function modifier_dlnec_reaper_target:playeffects(t)

    local particle_cast1 = "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf"        --链子，cp6061共调色
    local particle_cast2 = "particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf"  --刀子，cp0斩向cp1
    local sound1 = "Hero_Necrolyte.ReapersScythe.Target"

    local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil ) --链子
    local effect_cast2 = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, nil ) --刀子
    local tpos1 = t:GetAbsOrigin() tpos1.z = 500
    local tpos2 = t:GetAbsOrigin()

    tpos2.x = tpos2.x + RandomInt(-1, 1)    --让镰刀每次从不同方向斩击
    tpos2.y = tpos2.y + RandomInt(-1, 1)

    t:EmitSound(sound1) --播放音效

    local steamid = tonumber(tostring(PlayerResource:GetSteamID(self:GetCaster():GetPlayerOwnerID())))
    local idtable = {
                        76561198361355161,  --小太
                        76561198100269546,  --老太
                    }

    local pink = Is_DATA_TG(idtable,steamid)    --粉色
    if pink then
        ParticleManager:SetParticleControl( effect_cast1, 60, Vector(255,105,180) )
        ParticleManager:SetParticleControl( effect_cast1, 61, Vector(255,105,180) )
        ParticleManager:SetParticleControl( effect_cast2, 60, Vector(255,105,180) )
        ParticleManager:SetParticleControl( effect_cast2, 61, Vector(255,105,180) )
    end

    ParticleManager:SetParticleControl( effect_cast1, 0, tpos1 )    --控制链子

    ParticleManager:SetParticleControl( effect_cast2, 0, tpos2 )    --控制刀子
    ParticleManager:SetParticleControl( effect_cast2, 1, tpos1 )

    ParticleManager:ReleaseParticleIndex( effect_cast1 )    --解放链子
    ParticleManager:ReleaseParticleIndex( effect_cast2 )    --解放刀子

end

function modifier_dlnec_reaper_target:playeffects_dabyss(t)

    local particle_cast1 = "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf"        --链子，cp6061共调色
    local particle_cast2 = "particles/dlparticles/dlnec_reaper/random_necro_ti7_immortal_scythe_start.vpcf"  --自改，死神刀子，没有cp控制方向，自改成随机方向
    local sound1 = "Hero_Necrolyte.ReapersScythe.Target"

    local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil ) --链子
    local effect_cast2 = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, nil ) --死神刀子
    local tpos1 = t:GetAbsOrigin() tpos1.z = 500
    local tpos2 = t:GetAbsOrigin()

    --[[tpos2.x = tpos2.x + RandomInt(-1, 1)    --让镰刀每次从不同方向斩击
    tpos2.y = tpos2.y + RandomInt(-1, 1)]]

    t:EmitSound(sound1) --播放音效

    local steamid = tonumber(tostring(PlayerResource:GetSteamID(self:GetCaster():GetPlayerOwnerID())))
    local idtable = {
                        76561198361355161,  --小太
                        76561198100269546,  --老太
                    }

    local pink = Is_DATA_TG(idtable,steamid)    --粉色
    if pink then
        ParticleManager:SetParticleControl( effect_cast1, 60, Vector(255,105,180) )
        ParticleManager:SetParticleControl( effect_cast1, 61, Vector(255,105,180) )
    end

    ParticleManager:SetParticleControl( effect_cast1, 0, tpos1 )    --控制链子

    ParticleManager:SetParticleControl( effect_cast2, 0, tpos2 )    --控制死神刀子
    ParticleManager:SetParticleControl( effect_cast2, 1, tpos1 )

    ParticleManager:ReleaseParticleIndex( effect_cast1 )    --解放链子
    ParticleManager:ReleaseParticleIndex( effect_cast2 )    --解放死神刀子

end
