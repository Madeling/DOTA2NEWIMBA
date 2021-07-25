
item_drums_v2= class({})

LinkLuaModifier("modifier_item_drums_v2_pa", "items/item_drums_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_drums_v2_aura", "items/item_drums_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_drums_v2_buff", "items/item_drums_v2.lua", LUA_MODIFIER_MOTION_NONE)

function item_drums_v2:GetIntrinsicModifierName() 
    return "modifier_item_drums_v2_pa" 
end

function item_drums_v2:OnSpellStart()
    local ab = self
    local caster = ab:GetCaster()
    local rd = ab:GetSpecialValueFor("rd")
    local dur = ab:GetSpecialValueFor("dur")
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
            if unit:HasModifier("modifier_item_drums_v2_buff") then
                unit:RemoveModifierByName( "modifier_item_drums_v2_buff" )
            end
                unit:AddNewModifier(caster, ab, "modifier_item_drums_v2_buff", {duration = dur})
        end
    end
end



   modifier_item_drums_v2_pa=modifier_item_drums_v2_pa or class({})

function modifier_item_drums_v2_pa:IsBuff()				
    return true 
end
function modifier_item_drums_v2_pa:IsDebuff()             
    return false
end
function modifier_item_drums_v2_pa:IsHidden() 			
    return true 
end

function modifier_item_drums_v2_pa:IsPurgable() 			
    return false 
end

function modifier_item_drums_v2_pa:IsPurgeException() 	
    return false 
end

function modifier_item_drums_v2_pa:RemoveOnDeath() 	
    return self:GetParent():IsIllusion()
end

function modifier_item_drums_v2_pa:IsPassive() 	
    return true 
end

function modifier_item_drums_v2_pa:IsAura() 
    return true 
end

function modifier_item_drums_v2_pa:GetAuraDuration() 
    return 0
end

function modifier_item_drums_v2_pa:GetModifierAura() 
    return "modifier_item_drums_v2_aura" 
end

function modifier_item_drums_v2_pa:GetAuraRadius() 
    return self:GetAbility():GetSpecialValueFor("aura_rd")  
end

function modifier_item_drums_v2_pa:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_item_drums_v2_pa:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function modifier_item_drums_v2_pa:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC 
end

function modifier_item_drums_v2_pa:DeclareFunctions() 
    return 
    {
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, 
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS, 
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, 
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, 
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
end

function modifier_item_drums_v2_pa:GetModifierBonusStats_Strength() 
    return self.str
end

function modifier_item_drums_v2_pa:GetModifierBonusStats_Agility() 
    return self.agi
end

function modifier_item_drums_v2_pa:GetModifierBonusStats_Intellect() 
    return self.int
end

function modifier_item_drums_v2_pa:GetModifierAttackSpeedBonus_Constant() 
    return self.attsp
end

function modifier_item_drums_v2_pa:GetModifierMoveSpeedBonus_Constant() 
    return self.sp
end

function modifier_item_drums_v2_pa:GetModifierConstantManaRegen() 
    return self.mana
end

function modifier_item_drums_v2_pa:GetModifierConstantHealthRegen() 
    return self.hp
end

function modifier_item_drums_v2_pa:OnCreated()
    if self:GetAbility()==nil then 
        return 
    end 
    local ab=self:GetAbility()
    self.str=ab:GetSpecialValueFor("str") 
    self.agi=ab:GetSpecialValueFor("agi") 
    self.int=ab:GetSpecialValueFor("int") 
    self.attsp=ab:GetSpecialValueFor("attsp") 
    self.sp=ab:GetSpecialValueFor("sp") 
    self.mana=ab:GetSpecialValueFor("mana") 
    self.hp=ab:GetSpecialValueFor("hp") 
end

function modifier_item_drums_v2_pa:OnRefresh()
    self:OnCreated()
end



modifier_item_drums_v2_aura = modifier_item_drums_v2_aura or class({})

function modifier_item_drums_v2_aura:IsBuff()				
    return true 
end

function modifier_item_drums_v2_aura:IsHidden() 			
    return false 
end

function modifier_item_drums_v2_aura:IsPurgable() 			
    return false 
end

function modifier_item_drums_v2_aura:IsPurgeException() 	
    return false 
end

function modifier_item_drums_v2_aura:RemoveOnDeath() 	
    return true
end


function modifier_item_drums_v2_aura:OnCreated()
    if self:GetAbility()==nil then 
        return 
    end 
    self.aura_attsp=self:GetAbility():GetSpecialValueFor("aura_attsp") 
    self.aura_sp=self:GetAbility():GetSpecialValueFor("aura_sp") 
end

function modifier_item_drums_v2_aura:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end

function modifier_item_drums_v2_aura:GetModifierAttackSpeedBonus_Constant() 
    return self.aura_attsp
end

function modifier_item_drums_v2_aura:GetModifierMoveSpeedBonus_Constant() 
        return self.aura_sp
end


modifier_item_drums_v2_buff = modifier_item_drums_v2_buff or class({})

function modifier_item_drums_v2_buff:IsBuff()				
    return true 
end

function modifier_item_drums_v2_buff:IsHidden() 			
    return false 
end

function modifier_item_drums_v2_buff:IsPurgable() 			
    return false 
end

function modifier_item_drums_v2_buff:IsPurgeException() 	
    return false 
end

function modifier_item_drums_v2_buff:RemoveOnDeath() 	
    return true
end

function modifier_item_drums_v2_buff:GetEffectName() 
    return "particles/econ/events/ti9/ti9_drums_musicnotes.vpcf" 
end

function modifier_item_drums_v2_buff:GetEffectAttachType() 
    return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_item_drums_v2_buff:GetTexture()
    return "item_ancient_janggo" 
end

function modifier_item_drums_v2_buff:OnCreated()
    if self:GetAbility()==nil then 
        return 
    end 
    self.sp=self:GetAbility():GetSpecialValueFor("spbuff") 
end

function modifier_item_drums_v2_buff:CheckState()
    return 
    {
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

function modifier_item_drums_v2_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, 
    }
end


function modifier_item_drums_v2_buff:GetModifierMoveSpeedBonus_Constant() 
    return self.sp
end