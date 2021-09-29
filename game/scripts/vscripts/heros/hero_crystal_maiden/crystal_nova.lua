CreateTalents("npc_dota_hero_crystal_maiden", "heros/hero_crystal_maiden/crystal_nova.lua")
crystal_nova=class({})
LinkLuaModifier("modifier_crystal_nova_debuff", "heros/hero_crystal_maiden/crystal_nova.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_crystal_nova_debuff1", "heros/hero_crystal_maiden/crystal_nova.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_crystal_nova_debuff2", "heros/hero_crystal_maiden/crystal_nova.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_crystal_nova_th", "heros/hero_crystal_maiden/crystal_nova.lua", LUA_MODIFIER_MOTION_NONE)
function crystal_nova:IsHiddenWhenStolen()
    return false
end

function crystal_nova:IsStealable()
    return true
end


function crystal_nova:IsRefreshable()
    return true
end


function crystal_nova:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function crystal_nova:OnAbilityPhaseStart()
    self.caster=self:GetCaster()
    self.caster:AddActivityModifier("glacier")
    self.caster:ForcePlayActivityOnce(ACT_DOTA_CAST_ABILITY_1)
    return true
end

function crystal_nova:OnSpellStart()
    local cpos=self.caster:GetAbsOrigin()
	local curpos=self:GetCursorPosition()
    local team=self.caster:GetTeamNumber()
    local nova_damage=self:GetSpecialValueFor("nova_damage")
    local radius=self:GetSpecialValueFor("radius")
    local vision_duration=self:GetSpecialValueFor("vision_duration")
    local duration=self:GetSpecialValueFor("duration")
    local stun=self:GetSpecialValueFor("stun")
    local dur=self:GetSpecialValueFor("dur")
    local mana=self:GetSpecialValueFor("mana")
     local damageTable =
     {
                                    attacker = self.caster,
                                    damage = nova_damage,
                                    damage_type = DAMAGE_TYPE_MAGICAL,
                                    ability = self
     }
    EmitSoundOn("Hero_Ancient_Apparition.IceVortexCast", self.caster)
    AddFOWViewer( team, curpos, radius, vision_duration, false )
    local particle = ParticleManager:CreateParticle("particles/tgp/maiden_crystal/nova_m.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl( particle, 0, curpos)
    ParticleManager:SetParticleControl( particle, 1, Vector(radius,dur,radius))
    ParticleManager:SetParticleControl( particle, 2, curpos)
    ParticleManager:ReleaseParticleIndex(particle)
    CreateModifierThinker(self.caster,self,"modifier_crystal_nova_th",{duration=dur},curpos,team,false)
    local enemies = FindUnitsInRadius(
        team,
        curpos,
        self.caster,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false)
        if  #enemies>0 then
                EmitSoundOn("Hero_Crystal.CrystalNova", self.caster)
                for _,target in pairs(enemies) do
                        if not target:IsMagicImmune() then
                                 damageTable.victim = target
                                 damageTable.damage = nova_damage
                                ApplyDamage(damageTable)
                                target:AddNewModifier_RS(self.caster, self, "modifier_crystal_nova_debuff", {duration =duration})
                                if target:GetAbsOrigin().z<=0 then
                                        target:AddNewModifier_RS(self.caster, self, "modifier_crystal_nova_debuff1", {duration=stun})
                                end
                                if  self.caster:TG_HasTalent("special_bonus_crystal_maiden_1") then
                                    local fx = ParticleManager:CreateParticle("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", PATTACH_CUSTOMORIGIN, nil)
                                    ParticleManager:SetParticleControl(fx, 0, damageTable.victim:GetAbsOrigin())
                                    ParticleManager:ReleaseParticleIndex(fx)
                                    damageTable.victim = enemies[RandomInt(1,#enemies)]
                                    damageTable.damage = nova_damage/2
                                    ApplyDamage(damageTable)
                                end
                        end
                end

                    local ma=mana*#enemies
                    self.caster:GiveMana(ma)
                    SendOverheadEventMessage(self.caster, OVERHEAD_ALERT_MANA_ADD, self.caster,ma, nil)
                   if  not self.caster:TG_HasTalent("special_bonus_crystal_maiden_1") then
                        local fx = ParticleManager:CreateParticle("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", PATTACH_CUSTOMORIGIN, nil)
                        ParticleManager:SetParticleControl(fx, 0, damageTable.victim:GetAbsOrigin())
                        ParticleManager:ReleaseParticleIndex(fx)
                        damageTable.victim = enemies[RandomInt(1,#enemies)]
                        damageTable.damage = nova_damage/2
                        ApplyDamage(damageTable)
                    end
        end
end


modifier_crystal_nova_th=class({})
function modifier_crystal_nova_th:IsHidden()
    return true
end

function modifier_crystal_nova_th:IsPurgable()
    return false
end

function modifier_crystal_nova_th:IsPurgeException()
    return false
end

function modifier_crystal_nova_th:IsAura()
    return true
end


function modifier_crystal_nova_th:GetModifierAura()
                return "modifier_crystal_nova_debuff2"
end

function modifier_crystal_nova_th:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_crystal_nova_th:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_crystal_nova_th:GetAuraSearchTeam()
               return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_crystal_nova_th:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end




modifier_crystal_nova_debuff2=class({})

function modifier_crystal_nova_debuff2:IsDebuff()
    return true
end

function modifier_crystal_nova_debuff2:IsPurgable()
    return false
end

function modifier_crystal_nova_debuff2:IsPurgeException()
    return false
end

function modifier_crystal_nova_debuff2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING ,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end

function modifier_crystal_nova_debuff2:GetModifierPercentageManacostStacking()
        return -100
end

function modifier_crystal_nova_debuff2:GetModifierMagicalResistanceBonus()
        if   self:GetCaster():TG_HasTalent("special_bonus_crystal_maiden_2") then
	            return -25
        end
            return 0
end

modifier_crystal_nova_debuff1=class({})

function modifier_crystal_nova_debuff1:IsDebuff()
    return true
end

function modifier_crystal_nova_debuff1:IsPurgable()
    return true
end

function modifier_crystal_nova_debuff1:IsPurgeException()
    return true
end

function modifier_crystal_nova_debuff1:IsHidden()
    return false
end

function modifier_crystal_nova_debuff1:GetEffectName()
    return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_crystal_nova_debuff1:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_crystal_nova_debuff1:CheckState()
    return
    {
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_TETHERED] = true
    }
end

function modifier_crystal_nova_debuff1:OnCreated(tg)
	if IsServer() then
        self:GetParent():EmitSound("hero_Crystal.frostbite")
    end
end




modifier_crystal_nova_debuff=class({})

function modifier_crystal_nova_debuff:IsDebuff()
    return true
end

function modifier_crystal_nova_debuff:IsPurgable()
    return true
end

function modifier_crystal_nova_debuff:IsPurgeException()
    return true
end

function modifier_crystal_nova_debuff:IsHidden()
    return false
end

function modifier_crystal_nova_debuff:GetEffectName()
    return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_crystal_nova_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_crystal_nova_debuff:OnCreated()
    if self:GetAbility()==nil then
        return
    end
    self.sp=self:GetAbility():GetSpecialValueFor("sp")
    self.attsp=self:GetAbility():GetSpecialValueFor("attsp")
end

function modifier_crystal_nova_debuff:OnRefresh()
    self:OnCreated()
end


function modifier_crystal_nova_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_crystal_nova_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.sp
end

function modifier_crystal_nova_debuff:GetModifierAttackSpeedBonus_Constant()
    return  self.attsp
end
