poison_nova=class({})

LinkLuaModifier("modifier_poison_nova", "heros/hero_venomancer/poison_nova.lua", LUA_MODIFIER_MOTION_NONE)

function poison_nova:IsHiddenWhenStolen()
    return false
end

function poison_nova:IsStealable()
    return true
end

function poison_nova:IsRefreshable()
    return true
end

function poison_nova:OnSpellStart()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    local pos = self:GetCursorPosition()
    local duration = self:GetSpecialValueFor("duration")
    local radius = self:GetSpecialValueFor("radius")
    caster:EmitSound("Hero_Venomancer.PoisonNova")
	local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(p1)
	local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(p2, 1, Vector(radius, 1,radius))
	ParticleManager:ReleaseParticleIndex(p2)
    if caster:TG_HasTalent("special_bonus_venomancer_8") then
        local AB=caster:FindAbilityByName("plague_ward")
        if AB and AB:GetLevel()>0 then
            local dur = AB:GetSpecialValueFor("duration")
            caster:EmitSound("Hero_Venomancer.Plague_Ward")
            for i=1,AB:GetSpecialValueFor("num") do
               local ward=CreateUnitByNameAsync("npc_plague_ward", caster_pos, true, caster, caster, caster:GetTeamNumber(),function(ward)
                ward:AddNewModifier(caster, AB, "modifier_plague_ward", {duration=dur})
                ward:AddNewModifier(caster, AB, "modifier_kill", {duration=dur})
                ward:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
                end)

            end
        end
    end
	local heros = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    if #heros>0 then
        for _, target in pairs(heros) do
                if caster:HasScepter() then
                    TG_Modifier_Num_ADD2({
                        target= target,
                        caster=caster,
                        ability=self,
                        modifier="modifier_poison_sting_debuff",
                        init= 35,
                        stack= 35,
                        duration=  3
                    })
                end
                target:AddNewModifier(caster, self, "modifier_poison_nova", {duration = duration})
        end
    end
end

modifier_poison_nova=class({})

function modifier_poison_nova:IsDebuff()
	return true
end

function modifier_poison_nova:IsHidden()
	return false
end

function modifier_poison_nova:IsPurgable()
	return false
end

function modifier_poison_nova:IsPurgeException()
	return false
end

function modifier_poison_nova:GetEffectName()
    return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf"
end

function modifier_poison_nova:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_poison_nova:GetStatusEffectName()
    return "particles/status_fx/status_effect_poison_venomancer.vpcf"
end

function modifier_poison_nova:StatusEffectPriority()
    return 4
end

function modifier_poison_nova:OnCreated()
    if not self:GetAbility() then
        return
    end
   self.damage=self:GetAbility():GetSpecialValueFor("damage")
   self.movement_slow=self:GetAbility():GetSpecialValueFor("movement_slow")
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_poison_nova:OnIntervalThink()
    if not self:GetParent():IsMagicImmune()  then
        if self:GetParent():HasModifier("modifier_poison_sting_debuff") or self:GetParent():HasModifier("modifier_plague_ward_debuff") then
            self:SetDuration(self:GetDuration(), true)
        end
        self:GetParent():EmitSound("Hero_Venomancer.PoisonNovaImpact")
        if self:GetCaster():TG_HasTalent("special_bonus_venomancer_7") then
            self:GetCaster():Heal(self.damage, self)
            SendOverheadEventMessage(self:GetCaster(), OVERHEAD_ALERT_HEAL, self:GetCaster(),self.damage, nil)
        end
        local damageTable = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = self.damage,
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
            }
        ApplyDamage(damageTable)
    end
end

function modifier_poison_nova:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_DISABLE_HEALING
    }
end

function modifier_poison_nova:GetModifierMoveSpeedBonus_Percentage()
    if  self:GetParent():IsMagicImmune()  then
        return 0
    end
	return self.movement_slow
end

function modifier_poison_nova:GetDisableHealing()
    if  self:GetParent():IsMagicImmune()  then
        return 0
    end
	return 1
end

function modifier_poison_nova:GetModifierHealAmplify_PercentageTarget()
    if  self:GetParent():IsMagicImmune()  then
        return 0
    end
    return  -100
end

function modifier_poison_nova:GetModifierHPRegenAmplify_Percentage()
    if  self:GetParent():IsMagicImmune()  then
        return 0
    end
    return -100
end