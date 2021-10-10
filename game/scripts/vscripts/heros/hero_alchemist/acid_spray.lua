CreateTalents("npc_dota_hero_alchemist", "heros/hero_alchemist/acid_spray.lua")
acid_spray=class({})
LinkLuaModifier("modifier_acid_spray_th", "heros/hero_alchemist/acid_spray.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_acid_spray_debuff", "heros/hero_alchemist/acid_spray.lua", LUA_MODIFIER_MOTION_NONE)
function acid_spray:IsHiddenWhenStolen()
    return false
end
function acid_spray:IsStealable()
    return true
end
function acid_spray:IsRefreshable()
    return true
end
function acid_spray:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function acid_spray:Init()
    self.caster=self:GetCaster()
end
function acid_spray:OnSpellStart()
    local cpos=self.caster:GetAbsOrigin()
    local curpos=self:GetCursorPosition()
    local team=self.caster:GetTeamNumber()
    local duration=self:GetSpecialValueFor("duration")
    EmitSoundOn("Hero_Alchemist.AcidSpray", self.caster)
    CreateModifierThinker(self.caster, self, "modifier_acid_spray_th", {duration=duration}, curpos, team, false)
end

modifier_acid_spray_th=class({})
function modifier_acid_spray_th:IsHidden()
    return true
end
function modifier_acid_spray_th:IsPurgable()
    return false
end
function modifier_acid_spray_th:IsPurgeException()
    return false
end
function modifier_acid_spray_th:IsAura()
    return true
end
function modifier_acid_spray_th:GetModifierAura()
      return "modifier_acid_spray_debuff"
end
function modifier_acid_spray_th:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end
function modifier_acid_spray_th:GetAuraDuration()
    return 0
end
function modifier_acid_spray_th:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_acid_spray_th:GetAuraSearchTeam()
      return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_acid_spray_th:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
end
function modifier_acid_spray_th:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.team=self.parent:GetTeamNumber()
    self.cpos=self.parent:GetAbsOrigin()
    self.damageTable=
    {
        attacker = self.caster,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability =  self.ability,
	}
    if not self.ability then
            return
    end
        self.radius=self.ability:GetSpecialValueFor("radius")
        self.damage=self.ability:GetSpecialValueFor("damage")
        self.tick_rate=self.ability:GetSpecialValueFor("tick_rate")
        self.gold=self.ability:GetSpecialValueFor("gold")*-1
    if IsServer() then
            local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_CUSTOMORIGIN,nil)
                ParticleManager:SetParticleControl(fx,0,self.cpos)
                ParticleManager:SetParticleControl(fx,1,Vector(self.radius,0,0))
                self:AddParticle(fx, false, false, 4, false, false)
        self:StartIntervalThink( self.tick_rate)
    end
end
function modifier_acid_spray_th:OnRefresh()
    self:OnCreated()
end
function modifier_acid_spray_th:OnIntervalThink()
                EmitSoundOnLocationWithCaster(self.cpos, "Hero_Alchemist.AcidSpray.Damage", self.parent)
                local units=FindUnitsInRadius(self.team,self.cpos,nil,self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                if #units>0 then
                        for _,target in pairs(units) do
                                    if target:IS_TrueHero_TG()  then
                                                local lv=target:GetLevel()
                                                local gold=lv*self.gold*-1
                                                local num=tonumber(#tostring(gold))+1
                                                PlayerResource:ModifyGold(target:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified)
                                                local fx = ParticleManager:CreateParticle("particles/tgp/alchemist/msg_gold.vpcf", PATTACH_ABSORIGIN, target)
                                                ParticleManager:SetParticleControl(fx, 1, Vector(1, gold, 0))
                                                ParticleManager:SetParticleControl(fx, 2, Vector(1,num, 0))
                                                ParticleManager:SetParticleControl(fx, 3, Vector(255, 208, 0))
                                                ParticleManager:ReleaseParticleIndex(fx)
                                     end
                                                self.damageTable.victim = target
                                                self.damageTable.damage = self.damage
                                                ApplyDamage(self.damageTable)

                        end
                end
end

modifier_acid_spray_debuff=class({})
function modifier_acid_spray_debuff:IsDebuff()
    return true
end
function modifier_acid_spray_debuff:IsPurgable()
    return false
end
function modifier_acid_spray_debuff:IsPurgeException()
    return false
end
function modifier_acid_spray_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end
function modifier_acid_spray_debuff:OnCreated()
    self.ability=self:GetAbility()
    if not self.ability then
            return
    end
        self.armor_reduction=self.ability:GetSpecialValueFor("armor_reduction")*-1
end
function modifier_acid_spray_debuff:OnRefresh()
    self:OnCreated()
end
function modifier_acid_spray_debuff:GetModifierMagicalResistanceBonus()
      return  self.armor_reduction
end
function modifier_acid_spray_debuff:GetModifierMoveSpeedBonus_Percentage()
    if self:GetCaster():TG_HasTalent("special_bonus_alchemist_1") then
        return -15
    else
        return 0
    end
end