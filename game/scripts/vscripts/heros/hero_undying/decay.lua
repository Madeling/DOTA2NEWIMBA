CreateTalents("npc_dota_hero_undying", "heros/hero_undying/decay.lua")
decay=class({})

LinkLuaModifier("modifier_decay_buff", "heros/hero_undying/decay.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_decay_debuff", "heros/hero_undying/decay.lua", LUA_MODIFIER_MOTION_NONE)
function decay:IsHiddenWhenStolen()
    return false
end

function decay:IsStealable()
    return true
end


function decay:IsRefreshable()
    return true
end

function decay:GetAOERadius()
    if self:GetCaster():Has_Aghanims_Shard() then
        return self:GetSpecialValueFor("radius")+150
    end
    return self:GetSpecialValueFor("radius")
end

function decay:GetManaCost(iLevel)
    if self:GetCaster():TG_HasTalent("special_bonus_undying_1") then
        return 0
    else
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end

function decay:OnSpellStart()
    local curpos=self:GetCursorPosition()
    local caster=self:GetCaster()
    local decay_damage=self:GetSpecialValueFor("decay_damage")
    local radius=self:GetSpecialValueFor("radius")
    local decay_duration=self:GetSpecialValueFor("decay_duration")
    local str_steal=self:GetSpecialValueFor("str_steal")
    local hp=self:GetSpecialValueFor("hp")
    EmitSoundOn("Hero_Undying.Decay.Cast", caster)
    if caster:HasScepter() then
        str_steal=10
    end
    if caster:Has_Aghanims_Shard() then
        radius=radius+150
    end
    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_decay.vpcf", PATTACH_CUSTOMORIGIN,caster)
    ParticleManager:SetParticleControl(particle,0,curpos)
    ParticleManager:SetParticleControl(particle,1,Vector(radius,0,0))
    ParticleManager:SetParticleControl(particle,2,curpos)
    ParticleManager:ReleaseParticleIndex(particle)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), curpos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if  #enemies>0 then
        for _,target in pairs(enemies) do
                if not target:IsMagicImmune() then
                    if target:IsRealHero() then
                        TG_Modifier_Num_ADD2({
                            target=caster,
                            caster=caster,
                            ability=self,
                            modifier="modifier_decay_buff",
                            init=str_steal,
                            stack=str_steal,
                            duration=decay_duration
                        })
                        TG_Modifier_Num_ADD2({
                            target=target,
                            caster=caster,
                            ability=self,
                            modifier="modifier_decay_debuff",
                            init=str_steal,
                            stack=str_steal,
                            duration=TG_StatusResistance_GET(target,decay_duration)
                        })
                    end
                    local damage= {
                        victim = target,
                        attacker = caster,
                        damage = decay_damage,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        damage_flag=DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                        ability = self,
                        }
                    ApplyDamage(damage)
                    caster:Heal(hp, caster)
                    SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster,hp, nil)
                end
        end
    end
end



modifier_decay_buff=class({})

function modifier_decay_buff:IsPurgable()
    return false
end

function modifier_decay_buff:IsPurgeException()
    return false
end

function modifier_decay_buff:IsHidden()
    return false
end

function modifier_decay_buff:IsDebuff()
    return false
end

function modifier_decay_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_decay_buff:OnCreated(tg)
    if not IsServer() then
        return
    end
   self:SetStackCount(tg.num)
end

function modifier_decay_buff:GetModifierBonusStats_Strength()
    return self:GetStackCount()
end

function modifier_decay_buff:GetModifierModelScale()
    local curr=self:GetParent():GetModelScale()
    return curr+self:GetStackCount()*0.1
end

modifier_decay_debuff=class({})

function modifier_decay_debuff:IsPurgable()
    return false
end

function modifier_decay_debuff:IsPurgeException()
    return false
end

function modifier_decay_debuff:IsHidden()
    return false
end

function modifier_decay_debuff:IsDebuff()
    return true
end

function modifier_decay_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_decay_debuff:OnCreated(tg)
    if not IsServer() then
        return
    end
   self:SetStackCount(tg.num)
end

function modifier_decay_debuff:GetModifierBonusStats_Strength()
    return (0-self:GetStackCount())
end

function modifier_decay_debuff:GetModifierDamageOutgoing_Percentage()
    return (0-self:GetStackCount())
end