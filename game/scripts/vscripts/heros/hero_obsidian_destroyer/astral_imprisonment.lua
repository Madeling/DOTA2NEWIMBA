astral_imprisonment=class({})
LinkLuaModifier("modifier_astral_imprisonment", "heros/hero_obsidian_destroyer/astral_imprisonment.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_astral_imprisonment_buff", "heros/hero_obsidian_destroyer/astral_imprisonment.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_astral_imprisonment_debuff", "heros/hero_obsidian_destroyer/astral_imprisonment.lua", LUA_MODIFIER_MOTION_NONE)
function astral_imprisonment:IsHiddenWhenStolen()
    return false
end

function astral_imprisonment:IsStealable()
    return true
end

function astral_imprisonment:IsRefreshable()
    return true
end

function astral_imprisonment:OnSpellStart()
    local caster=self:GetCaster()
    local target=self:GetCursorTarget()
    local duration=self:GetSpecialValueFor("prison_duration")
    EmitSoundOn("Hero_ObsidianDestroyer.AstralImprisonment", target)
    target:AddNewModifier(caster, self, "modifier_astral_imprisonment", {duration=duration})

end

modifier_astral_imprisonment=class({})

function modifier_astral_imprisonment:IsHidden()
    return false
end

function modifier_astral_imprisonment:IsPurgable()
    return false
end

function modifier_astral_imprisonment:IsPurgeException()
    return false
end

function modifier_astral_imprisonment:RemoveOnDeath()
    return true
end

function modifier_astral_imprisonment:OnCreated()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.caster=self:GetCaster()
    self.dam=self.ability:GetSpecialValueFor("damage")+self.caster:TG_GetTalentValue("special_bonus_obsidian_destroyer_3")
    self.dur=self.ability:GetSpecialValueFor("dur")
    self.mana_capacity_steal=self.ability:GetSpecialValueFor("mana_capacity_steal")+self.caster:TG_GetTalentValue("special_bonus_obsidian_destroyer_4")
    if IsServer() then
        local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pf, 0,self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControl(pf, 3,self.parent:GetAbsOrigin())
        self:AddParticle(pf, false, false, -1, false, false)
        self.parent:AddNoDraw()
        if not Is_Chinese_TG(self.parent,self.caster) and self.parent:IsRealHero() then
            local mana=self.mana_capacity_steal*self.parent:GetMaxMana()*0.01
            self.caster:AddNewModifier(self.caster, self.ability, "modifier_astral_imprisonment_buff", {duration=self.dur,num=mana})
            self.damage= {
                attacker = self.caster,
                damage = self.dam,
                victim = self.parent,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self.ability,
                }
            ApplyDamage(self.damage)
        end
    end
end


function modifier_astral_imprisonment:OnDestroy()
    if IsServer() then
        self.parent:RemoveNoDraw()
        StopSoundOn("Hero_ObsidianDestroyer.AstralImprisonment", self.parent)
        EmitSoundOn("Hero_ObsidianDestroyer.AstralImprisonment.End", self.parent)
        if not Is_Chinese_TG(self.parent,self.caster) then
            self.damage= {
                attacker = self.caster,
                damage = self.dam,
                victim = self.parent,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self.ability,
                }
            ApplyDamage(self.damage)
            if self.parent:IsRealHero() then
                self.parent:AddNewModifier_RS(self.caster, self.ability, "modifier_astral_imprisonment_debuff", {duration=self.ability:GetSpecialValueFor("dur2")})
            end
        end
        local pf1 = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_end.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pf1, 0,self.parent:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(pf1)
    end
end

function modifier_astral_imprisonment:CheckState()
    if self.parent==self.caster then
        if self.caster:HasScepter() then
            return
            {
                [MODIFIER_STATE_INVULNERABLE] = true,
                [MODIFIER_STATE_OUT_OF_GAME] = true,
                [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
                [MODIFIER_STATE_DISARMED] = true,
            }
        else
            return
            {
                [MODIFIER_STATE_INVULNERABLE] = true,
                [MODIFIER_STATE_OUT_OF_GAME] = true,
                [MODIFIER_STATE_STUNNED] = true,
            }
        end
    else
        if  Is_Chinese_TG(self.parent,self.caster) then
            return
            {
                [MODIFIER_STATE_INVULNERABLE] = true,
                [MODIFIER_STATE_OUT_OF_GAME] = true,
                [MODIFIER_STATE_STUNNED] = true,
              }
            else
                return
                {
                      [MODIFIER_STATE_INVULNERABLE] = true,
                      [MODIFIER_STATE_OUT_OF_GAME] = true,
                      [MODIFIER_STATE_STUNNED] = true,
                      [MODIFIER_STATE_DISARMED] = true,
                      [MODIFIER_STATE_ROOTED] = true,
                      [MODIFIER_STATE_MUTED] = true,
                  }
        end
    end

end


modifier_astral_imprisonment_buff=class({})

function modifier_astral_imprisonment_buff:IsHidden()
    return false
end

function modifier_astral_imprisonment_buff:IsPurgable()
    return false
end

function modifier_astral_imprisonment_buff:IsPurgeException()
    return false
end

function modifier_astral_imprisonment_buff:OnCreated(tg)
    if IsServer() then
        self:SetStackCount(tg.num)
    end
end

function modifier_astral_imprisonment_buff:OnRefresh(tg)
        self:OnCreated(tg)
end

function modifier_astral_imprisonment_buff:DeclareFunctions()
    return
     {
        MODIFIER_PROPERTY_MANA_BONUS,
    }
end

function modifier_astral_imprisonment_buff:GetModifierManaBonus()
    return self:GetStackCount()
end

modifier_astral_imprisonment_debuff=class({})

function modifier_astral_imprisonment_debuff:IsDebuff()
    return true
end

function modifier_astral_imprisonment_debuff:IsHidden()
    return false
end

function modifier_astral_imprisonment_debuff:IsPurgable()
    return false
end

function modifier_astral_imprisonment_debuff:IsPurgeException()
    return false
end

function modifier_astral_imprisonment_debuff:OnCreated()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.caster=self:GetCaster()
    self.mana=self.ability:GetSpecialValueFor("mana")
end

function modifier_astral_imprisonment_debuff:DeclareFunctions()
    return
     {
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    }
end

function modifier_astral_imprisonment_debuff:OnAbilityExecuted(tg)
    if IsServer() then
        if tg.unit==self.parent and not tg.ability:IsToggle() and not self.parent:IsIllusion() then
            local mana=self.parent:GetMaxMana()*self.mana*0.01
            if self.parent:GetMana()>=mana then
                self.parent:ReduceMana(mana)
            end
        end
    end
end

function modifier_astral_imprisonment_debuff:OnAttack(tg)
    if IsServer() then
        if tg.attacker==self.parent and not self.parent:IsIllusion() then
            local mana=self.parent:GetMaxMana()*self.mana*0.01
            if self.parent:GetMana()>=mana then
                self.parent:ReduceMana(mana)
            end
        end
    end
end