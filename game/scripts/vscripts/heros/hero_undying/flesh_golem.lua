    flesh_golem=class({})

LinkLuaModifier("modifier_flesh_golem_buff", "heros/hero_undying/flesh_golem.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flesh_golem_buff2", "heros/hero_undying/flesh_golem.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flesh_golem_zombie", "heros/hero_undying/flesh_golem.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flesh_golem_hp", "heros/hero_undying/flesh_golem.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flesh_golem_debuff", "heros/hero_undying/flesh_golem.lua", LUA_MODIFIER_MOTION_NONE)
function flesh_golem:IsHiddenWhenStolen()
    return false
end

function flesh_golem:IsStealable()
    return true
end


function flesh_golem:IsRefreshable()
    return true
end

function flesh_golem:OnSpellStart()
    local caster=self:GetCaster()
    local dur=self:GetSpecialValueFor("dur")
    local dur2=self:GetSpecialValueFor("dur2")
    local rd=self:GetSpecialValueFor("rd")
    local buff=self:GetSpecialValueFor("buff")*0.01
    EmitSoundOn("Hero_Undying.FleshGolem.Cast", caster)
    caster:StartGesture(ACT_DOTA_SPAWN)
    caster:AddNewModifier(caster, self, "modifier_flesh_golem_buff", {duration=dur})

        local heroes = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, rd, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
        if #heroes>0 then
        for _, hero in pairs(heroes) do
                if hero:IsRealHero()  then
                    local HP=caster:GetMaxHealth()*buff
                    hero:AddNewModifier(caster, self,"modifier_flesh_golem_hp", {duration=dur2,num=HP})
                end
            end
        end
end



modifier_flesh_golem_buff=class({})

function modifier_flesh_golem_buff:IsPurgable()
    return false
end

function modifier_flesh_golem_buff:IsPurgeException()
    return false
end

function modifier_flesh_golem_buff:IsHidden()
    return false
end

function modifier_flesh_golem_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_flesh_golem_buff:GetEffectName()
    return "particles/units/heroes/hero_undying/undying_fg_aura.vpcf"
end

function modifier_flesh_golem_buff:IsAura()
    return true
end


function modifier_flesh_golem_buff:GetModifierAura()
                return "modifier_flesh_golem_debuff"
end

function modifier_flesh_golem_buff:GetAuraRadius()
    return 600
end

function modifier_flesh_golem_buff:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_flesh_golem_buff:GetAuraSearchTeam()
               return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_flesh_golem_buff:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_flesh_golem_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,
       -- MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end

function modifier_flesh_golem_buff:GetModifierModelChange(tg)
    if self:GetParent():HasModifier("modifier_tombstone_eat") then
        return "models/items/undying/flesh_golem/corrupted_scourge_corpse_hive/corrupted_scourge_corpse_hive.vmdl"
    else
        return "models/items/undying/flesh_golem/incurable_pestilence_golem/incurable_pestilence_golem.vmdl"
    end

end
--[[
function modifier_flesh_golem_buff:GetModifierMoveSpeedBonus_Constant(tg)
    return self:GetAbility():GetSpecialValueFor("sp")
end
]]
function modifier_flesh_golem_buff:GetModifierPhysicalArmorBonus(tg)
    return self:GetAbility():GetSpecialValueFor("ar")
end

function modifier_flesh_golem_buff:GetModifierHealthBonus(tg)
    return self:GetAbility():GetSpecialValueFor("hp")
end


modifier_flesh_golem_debuff=class({})

function modifier_flesh_golem_debuff:IsPurgable()
    return false
end

function modifier_flesh_golem_debuff:IsPurgeException()
    return false
end

function modifier_flesh_golem_debuff:IsHidden()
    return false
end

function modifier_flesh_golem_debuff:IsDebuff()
    return true
end

function modifier_flesh_golem_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_flesh_golem_debuff:GetModifierIncomingDamage_Percentage()
    return  self:GetAbility():GetSpecialValueFor("godmg")
end



modifier_flesh_golem_zombie=class({})

function modifier_flesh_golem_zombie:IsPurgable()
    return false
end

function modifier_flesh_golem_zombie:IsPurgeException()
    return false
end

function modifier_flesh_golem_zombie:IsHidden()
    return false
end


function modifier_flesh_golem_zombie:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,
	}
end

function modifier_flesh_golem_zombie:GetModifierModelChange(tg)
    return "models/heroes/undying/undying_minion.vmdl"
end



modifier_flesh_golem_hp=class({})

function modifier_flesh_golem_hp:IsPurgable()
    return false
end

function modifier_flesh_golem_hp:IsPurgeException()
    return false
end

function modifier_flesh_golem_hp:IsHidden()
    return false
end

function modifier_flesh_golem_hp:OnCreated(tg)
    if IsServer() then
    self:SetStackCount(tg.num)
    end
end

function modifier_flesh_golem_hp:OnRefresh(tg)
    self:OnCreated(tg)
end

function modifier_flesh_golem_hp:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        --MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_flesh_golem_hp:GetModifierHealthBonus(tg)
    return self:GetStackCount()
end
--[[
function modifier_flesh_golem_hp:GetModifierDamageOutgoing_Percentage()
    return self:GetAbility():GetSpecialValueFor("godmg")
end]]