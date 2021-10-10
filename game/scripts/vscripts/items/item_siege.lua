item_siege=item_siege or class({})
LinkLuaModifier("modifier_item_siege_pa", "items/item_siege.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_siege_buff", "items/item_siege.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_siege_debuff", "items/item_siege.lua", LUA_MODIFIER_MOTION_NONE)

function item_siege:GetIntrinsicModifierName()
    return "modifier_item_siege_pa"
end


function item_siege:IsRefreshable()
    return true
end

function item_siege:OnSpellStart()
    local caster=self:GetCaster()
    local dur=self:GetSpecialValueFor("dur")
    local rd=self:GetSpecialValueFor("rd")
    local spF=self:GetSpecialValueFor("spF")
        caster:EmitSound("DOTA_Item.DoE.Activate")
        local units = FindUnitsInRadius(caster:GetTeamNumber(),
         caster:GetAbsOrigin(),
         nil,
         rd,
         DOTA_UNIT_TARGET_TEAM_FRIENDLY,
         DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
         DOTA_UNIT_TARGET_FLAG_NONE,
         FIND_ANY_ORDER, false)
        if #units>0 then
            for _, unit in pairs(units) do
                    if not unit:HasModifier("modifier_item_siege_buff") then
                        local sp=unit:GetMoveSpeedModifier(unit:GetBaseMoveSpeed(), true)
                        sp=sp>spF and sp or spF
                        unit:AddNewModifier(caster, self, "modifier_item_siege_buff", {duration = dur,sp=sp})
                    end
            end
        end
end

modifier_item_siege_pa=class({})

function modifier_item_siege_pa:IsPassive()
    return true
end


function modifier_item_siege_pa:IsDebuff()
    return false
end

function modifier_item_siege_pa:IsHidden()
    return false
end

function modifier_item_siege_pa:IsPurgable()
    return false
end

function modifier_item_siege_pa:IsPurgeException()
    return false
end

function modifier_item_siege_pa:GetTexture()
    return "item_siege_cuirass"
end

function modifier_item_siege_pa:AllowIllusionDuplicate()
    return false
end

function modifier_item_siege_pa:IsAura()
    return true
end

function modifier_item_siege_pa:GetAuraDuration()
    return 0.0
end

function modifier_item_siege_pa:GetModifierAura()
    return "modifier_item_siege_debuff"
end

function modifier_item_siege_pa:GetAuraRadius()
    return 1000
end

function modifier_item_siege_pa:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_item_siege_pa:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_item_siege_pa:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end


function modifier_item_siege_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
end

function modifier_item_siege_pa:OnCreated()
    if self:GetAbility() == nil then
		return
	end
    self.attsp=self:GetAbility():GetSpecialValueFor("attsp")
    self.stats=self:GetAbility():GetSpecialValueFor("stats")
    self.armor=self:GetAbility():GetSpecialValueFor("armor")
    self.mana=self:GetAbility():GetSpecialValueFor("mana")

end

function modifier_item_siege_pa:GetModifierAttackSpeedBonus_Constant()
    return  self.attsp
end


function modifier_item_siege_pa:GetModifierBonusStats_Strength()
    return  self.stats
end

function modifier_item_siege_pa:GetModifierBonusStats_Agility()
    return  self.stats
end

function modifier_item_siege_pa:GetModifierBonusStats_Intellect()
    return  self.stats
 end

 function modifier_item_siege_pa:GetModifierPhysicalArmorBonus()
    return  self.armor
 end

 function modifier_item_siege_pa:GetModifierConstantManaRegen()
    return  self.mana
 end


 modifier_item_siege_buff=modifier_item_siege_buff or class({})


function modifier_item_siege_buff:IsDebuff()
    return false
end

function modifier_item_siege_buff:IsHidden()
    return false
end

function modifier_item_siege_buff:IsPurgable()
    return true
end

function modifier_item_siege_buff:IsPurgeException()
    return true
end

function modifier_item_siege_buff:GetTexture()
    return "item_siege_cuirass"
end

function modifier_item_siege_buff:RemoveOnDeath()
    return true
end

function modifier_item_siege_buff:OnCreated(tg)
    if self:GetAbility()==nil then
        return
    end
    self.rs=self:GetAbility():GetSpecialValueFor("rs")
    if IsServer() then
        self:SetStackCount(tg.sp)
        local particle = ParticleManager:CreateParticle("particles/items_fx/drum_of_endurance_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW     , self:GetParent())
       self:AddParticle(particle, false, false, -1, false, false)
   end
end

function modifier_item_siege_buff:OnRefresh(tg)
    if self:GetAbility()==nil then
        return
    end
    self.evasion=self:GetAbility():GetSpecialValueFor("evasion")
    if IsServer() then
        self:SetStackCount(tg.sp)
   end
end

function modifier_item_siege_buff:DeclareFunctions()
        return
        {
            MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
            MODIFIER_PROPERTY_EVASION_CONSTANT
        }
end


function modifier_item_siege_buff:GetModifierMoveSpeed_Absolute()
    return self:GetStackCount()
end

function modifier_item_siege_buff:GetModifierEvasion_Constant()
    return self.evasion
end



modifier_item_siege_debuff=class({})

function modifier_item_siege_debuff:IsDebuff()
    if IsValidEntity(self.parent) and IsValidEntity(self.caster) then
        if self.caster:GetTeamNumber()==self.parent:GetTeamNumber() then
            return  false
        else
             return true
        end
    end
      return true
end

function modifier_item_siege_debuff:IsHidden()
    return false
end

function modifier_item_siege_debuff:IsPurgable()
    return false
end

function modifier_item_siege_debuff:IsPurgeException()
    return false
end

function modifier_item_siege_debuff:GetTexture()
    return "item_siege_cuirass"
end

function modifier_item_siege_debuff:RemoveOnDeath()
    return true
end

function modifier_item_siege_debuff:OnCreated()
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    if self:GetAbility()==nil then
        return
    end
    self.armorA=self:GetAbility():GetSpecialValueFor("armorA")
end

function modifier_item_siege_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_item_siege_debuff:GetModifierPhysicalArmorBonus()
    if IsValidEntity(self.parent) then
        if self.parent:IsBoss() then
            return 0
        end
        if self.caster:GetTeamNumber()==self.parent:GetTeamNumber() then
                return self.armorA*-1
        else
                return self.armorA
        end
    end
        return 0
end