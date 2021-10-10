nethertoxin=class({})

LinkLuaModifier("modifier_nethertoxin_th", "heros/hero_viper/nethertoxin.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nethertoxin_debuff", "heros/hero_viper/nethertoxin.lua", LUA_MODIFIER_MOTION_NONE)


function nethertoxin:GetAOERadius()
    return 400
end

function nethertoxin:OnSpellStart()
    local caster=self:GetCaster()
    EmitSoundOn("hero_viper.Nethertoxin.Cast",caster)
    CreateModifierThinker(self:GetCaster(), self, "modifier_nethertoxin_th", {duration=5}, self:GetCursorPosition(), caster:GetTeamNumber(), false)
end

modifier_nethertoxin_th=class({})


function modifier_nethertoxin_th:IsPurgable()
    return false
end

function modifier_nethertoxin_th:IsPurgeException()
    return false
end

function modifier_nethertoxin_th:IsHidden()
    return true
end

function modifier_nethertoxin_th:IsAura()
    return true
end


function modifier_nethertoxin_th:GetModifierAura()
    return "modifier_nethertoxin_debuff"
end

function modifier_nethertoxin_th:GetAuraRadius()
    return 400
end

function modifier_nethertoxin_th:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_nethertoxin_th:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_nethertoxin_th:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_nethertoxin_th:OnCreated()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.damage=self.ability:GetSpecialValueFor("damage")
    self.radius=self.ability:GetSpecialValueFor("radius")
    if IsServer() then
        local p1 = ParticleManager:CreateParticle("particles/econ/items/viper/viper_immortal_tail_ti8/viper_immortal_ti8_nethertoxin.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(p1, 0, self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControl(p1, 1, Vector(self.radius,self.radius,self.radius))
        ParticleManager:SetParticleControl(p1, 3, self.parent:GetAbsOrigin())
        self:AddParticle(p1, false, false, -1, false, false)
        self:StartIntervalThink(1)
    end
end

function modifier_nethertoxin_th:OnIntervalThink()
    local heros = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if #heros>0 then
        for _, target in pairs(heros) do
            if not target:IsMagicImmune() then
                EmitSoundOn("Hero_Viper.NetherToxin.Damage", target)
                local damage= {
                    victim = target,
                    attacker = self:GetCaster(),
                    damage = self.damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self.ability,
                    }
                ApplyDamage(damage)
            end
        end
    end

end

modifier_nethertoxin_debuff=class({})

function modifier_nethertoxin_debuff:IsDebuff()
    return true
end

function modifier_nethertoxin_debuff:IsPurgable()
    return false
end

function modifier_nethertoxin_debuff:IsPurgeException()
    return false
end

function modifier_nethertoxin_debuff:IsHidden()
    return false
end

function modifier_nethertoxin_debuff:OnCreated()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.mr=self.ability:GetSpecialValueFor("mr")
    self.ar=self.ability:GetSpecialValueFor("ar")
end

function modifier_nethertoxin_debuff:CheckState()
    if self.parent:IsMagicImmune() then
        return {}
    else
    return
    {
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
        [MODIFIER_STATE_SILENCED] = true,
    }
    end
end

function modifier_nethertoxin_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_EVENT_ON_ABILITY_START
	}
end

function modifier_nethertoxin_debuff:GetModifierPhysicalArmorBonus(tg)
    return 0-self.ar
end

function modifier_nethertoxin_debuff:GetModifierMagicalResistanceBonus(tg)
    return 0-self.mr
end