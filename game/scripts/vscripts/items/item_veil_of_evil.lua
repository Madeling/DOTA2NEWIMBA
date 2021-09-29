item_veil_of_evil=class({})
LinkLuaModifier("modifier_item_veil_of_evil_pa", "items/item_veil_of_evil.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_veil_of_evil_debuff", "items/item_veil_of_evil.lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_item_veil_of_evil_debuff2", "items/item_veil_of_evil.lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_item_veil_of_evil_buff", "items/item_veil_of_evil.lua", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_item_veil_of_evil_buff2", "items/item_veil_of_evil.lua", LUA_MODIFIER_MOTION_NONE)

function item_veil_of_evil:GetIntrinsicModifierName()
    return "modifier_item_veil_of_evil_pa"
end
--[[ 废弃
function item_veil_of_evil:OnSpellStart()
    local caster=self:GetCaster()
    local dur=self:GetSpecialValueFor("dur")
    local dur2=self:GetSpecialValueFor("dur2")
    local rd=self:GetSpecialValueFor("rd")
        caster:EmitSound("DOTA_Item.ShivasGuard.Activate")
        caster:AddNewModifier(caster, self, "modifier_item_veil_of_evil_buff2", {duration=3})
        local dam=self:GetSpecialValueFor("dam")*0.01*caster:GetIntellect()
        local units = FindUnitsInRadius(
         caster:GetTeamNumber(),
         caster:GetAbsOrigin(),
         nil,
         rd,
         DOTA_UNIT_TARGET_TEAM_ENEMY,
         DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
         DOTA_UNIT_TARGET_FLAG_NONE,
         FIND_ANY_ORDER, false)
        for _, unit in pairs(units) do
            if not unit:HasModifier("modifier_item_veil_of_evil_debuff2") then
                local damageTable = {
                    victim = unit,
                    attacker = caster,
                    damage = dam,
                    damage_type =DAMAGE_TYPE_MAGICAL,
                    damage_flags = DOTA_UNIT_TARGET_FLAG_NONE,
                    ability = self,
                    }
                ApplyDamage(damageTable)
                unit:AddNewModifier(caster, self, "modifier_item_veil_of_evil_debuff2", {duration = dur})
            end
        end
       -- caster:AddNewModifier(caster, self, "modifier_item_veil_of_evil_buff", {duration=dur2})
end
]]
modifier_item_veil_of_evil_pa=class({})

function modifier_item_veil_of_evil_pa:IsPassive()
    return true
end


function modifier_item_veil_of_evil_pa:IsDebuff()
    return false
end

function modifier_item_veil_of_evil_pa:IsHidden()
    return false
end

function modifier_item_veil_of_evil_pa:IsPurgable()
    return false
end

function modifier_item_veil_of_evil_pa:IsPurgeException()
    return false
end

function modifier_item_veil_of_evil_pa:GetTexture()
    return "item_veil_of_evil"
end

function modifier_item_veil_of_evil_pa:IsAura()
    return true
end

function modifier_item_veil_of_evil_pa:GetAuraDuration()
    return 0.1
end

function modifier_item_veil_of_evil_pa:GetModifierAura()
    return "modifier_item_veil_of_evil_debuff"
end

function modifier_item_veil_of_evil_pa:GetAuraRadius()
    return 1000
end

function modifier_item_veil_of_evil_pa:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_veil_of_evil_pa:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_veil_of_evil_pa:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end


function modifier_item_veil_of_evil_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        --MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        --MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_item_veil_of_evil_pa:OnCreated()
    if self:GetAbility() == nil then
		return
	end
    self.stats=self:GetAbility():GetSpecialValueFor("stats")
    self.armor=self:GetAbility():GetSpecialValueFor("armor")
    self.mana=self:GetAbility():GetSpecialValueFor("mana")
   self.spell=self:GetAbility():GetSpecialValueFor("spell")
end

--[[
function modifier_item_veil_of_evil_pa:GetModifierBonusStats_Strength()
    return  self.stats
end

function modifier_item_veil_of_evil_pa:GetModifierBonusStats_Agility()
    return  self.stats
end
]]

function modifier_item_veil_of_evil_pa:OnTakeDamage(tg)
    if IsServer() then
        if tg.attacker==self:GetParent() and self:GetParent():IsAlive() and self:GetAbility():IsCooldownReady() and tg.damage>=100 and tg.damage_type==DAMAGE_TYPE_MAGICAL and not tg.unit:IsBuilding() then --
            self:GetAbility():UseResources(false, false, true)
            local damageTable = {
                victim = tg.unit,
                attacker = self:GetParent(),
                damage = self:GetCaster():GetPrimaryStatValue()*self:GetAbility():GetSpecialValueFor("dam2")*0.01,
                damage_type =DAMAGE_TYPE_MAGICAL,
                damage_flags=DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                ability = self:GetAbility(),
                }
            ApplyDamage(damageTable)
        end
    end
end


function modifier_item_veil_of_evil_pa:GetModifierBonusStats_Intellect()
    return  self.stats
 end

 function modifier_item_veil_of_evil_pa:GetModifierPhysicalArmorBonus()
    return  self.armor
 end

 function modifier_item_veil_of_evil_pa:GetModifierConstantManaRegen()
    return  self.mana
 end


 function modifier_item_veil_of_evil_pa:GetModifierSpellAmplify_Percentage()
    return self.spell
end


--[[
 modifier_item_veil_of_evil_buff=class({})


 function modifier_item_veil_of_evil_buff:IsDebuff()
     return false
 end

 function modifier_item_veil_of_evil_buff:IsHidden()
     return false
 end

 function modifier_item_veil_of_evil_buff:IsPurgable()
     return false
 end

 function modifier_item_veil_of_evil_buff:IsPurgeException()
     return false
 end

 function modifier_item_veil_of_evil_buff:GetTexture()
     return "item_veil_of_evil"
 end

 function modifier_item_veil_of_evil_buff:OnCreated()
    if self:GetAbility()==nil then
        return
    end
    self.spell=self:GetAbility():GetSpecialValueFor("spell")
end



 function modifier_item_veil_of_evil_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
end

function modifier_item_veil_of_evil_buff:GetModifierSpellAmplify_Percentage()
    return  self.spell
end


modifier_item_veil_of_evil_buff2=class({})


function modifier_item_veil_of_evil_buff2:IsDebuff()
    return false
end

function modifier_item_veil_of_evil_buff2:IsHidden()
    return true
end

function modifier_item_veil_of_evil_buff2:IsPurgable()
    return false
end

function modifier_item_veil_of_evil_buff2:IsPurgeException()
    return false
end

function modifier_item_veil_of_evil_buff2:OnCreated()
   local rd=self:GetAbility():GetSpecialValueFor("rd")
   if IsServer() then
    local particle = ParticleManager:CreateParticle("particles/econ/events/ti7/shivas_guard_active_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(rd,rd,400))
    ParticleManager:SetParticleControl(particle, 2,  self:GetParent():GetAbsOrigin())
    self:AddParticle(particle, true, false, -1, false, false)
   end
end

function modifier_item_veil_of_evil_buff2:OnRefresh()
   self:OnCreated()
 end
]]


 modifier_item_veil_of_evil_debuff=class({})


 function modifier_item_veil_of_evil_debuff:IsDebuff()
     return true
 end

 function modifier_item_veil_of_evil_debuff:IsHidden()
     return false
 end

 function modifier_item_veil_of_evil_debuff:IsPurgable()
     return false
 end

 function modifier_item_veil_of_evil_debuff:IsPurgeException()
     return false
 end

 function modifier_item_veil_of_evil_debuff:GetTexture()
     return "item_veil_of_evil"
 end

 function modifier_item_veil_of_evil_debuff:RemoveOnDeath()
     return true
 end

 function modifier_item_veil_of_evil_debuff:OnCreated()
    if self:GetAbility()==nil then
        return
    end
    self.attsp=self:GetAbility():GetSpecialValueFor("attsp")
    self.sp=self:GetAbility():GetSpecialValueFor("sp")
    self.hpr=self:GetAbility():GetSpecialValueFor("hpr")
end

 function modifier_item_veil_of_evil_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end

function modifier_item_veil_of_evil_debuff:GetModifierHealAmplify_PercentageTarget()
    return  self.hpr
end

function modifier_item_veil_of_evil_debuff:GetModifierHPRegenAmplify_Percentage()
    return self.hpr
end

function modifier_item_veil_of_evil_debuff:GetModifierAttackSpeedBonus_Constant()
    return  self.attsp
end

function modifier_item_veil_of_evil_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.sp
end

function modifier_item_veil_of_evil_debuff:GetModifierMagicalResistanceBonus()
    if self:GetCaster():HasItemInInventory("item_three_knives") then
        return -50
    else
        return -25
    end
end
--[[
modifier_item_veil_of_evil_debuff2=class({})


function modifier_item_veil_of_evil_debuff2:IsDebuff()
    return true
end

function modifier_item_veil_of_evil_debuff2:IsHidden()
    return false
end

function modifier_item_veil_of_evil_debuff2:IsPurgable()
    return false
end

function modifier_item_veil_of_evil_debuff2:IsPurgeException()
    return false
end

function modifier_item_veil_of_evil_debuff2:GetTexture()
    return "item_veil_of_evil"
end

function modifier_item_veil_of_evil_debuff2:RemoveOnDeath()
    return true
end

function modifier_item_veil_of_evil_debuff2:OnCreated()
    if self:GetAbility()==nil then
        return
    end
    self.spell=self:GetAbility():GetSpecialValueFor("spell")
end


function modifier_item_veil_of_evil_debuff2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_item_veil_of_evil_debuff2:GetModifierIncomingDamage_Percentage()
    return  self.spell
end
]]