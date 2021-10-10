item_premium_power_treads=class({})

LinkLuaModifier("modifier_item_premium_power_treads_pa", "items/item_premium_power_treads.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_premium_power_treads_attsp", "items/item_premium_power_treads.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_premium_power_treads_cast", "items/item_premium_power_treads.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_premium_power_treads_attdis", "items/item_premium_power_treads.lua", LUA_MODIFIER_MOTION_NONE)


function item_premium_power_treads:GetAbilityTextureName()
    local caster = self:GetCaster()
    if caster:HasModifier("modifier_item_premium_power_treads_attdis") then    
        return "p1"
    elseif caster:HasModifier("modifier_item_premium_power_treads_attsp") then
        return "p2"
    elseif caster:HasModifier("modifier_item_premium_power_treads_cast") then
        return "p3"
    end  
    return "p1"
end


function item_premium_power_treads:OnSpellStart()
    local caster = self:GetCaster()
    if caster.curr_modifier_num == nil then
		caster.curr_modifier_num=1
	end	

	if  caster.modifier_table  == nil then
		caster.modifier_table={}
		caster.modifier_table[1] = "modifier_item_premium_power_treads_attdis"
		caster.modifier_table[2] = "modifier_item_premium_power_treads_attsp"
		caster.modifier_table[3] = "modifier_item_premium_power_treads_cast"
    end

    if caster:HasModifier( caster.modifier_table[caster.curr_modifier_num] ) then
        caster:RemoveModifierByName( caster.modifier_table[caster.curr_modifier_num] )
    end
    caster.curr_modifier_num=caster.curr_modifier_num+1
    if caster.curr_modifier_num>3 then
        caster.curr_modifier_num=1
    end
    caster:AddNewModifier(caster, self,caster.modifier_table[caster.curr_modifier_num], {})
    self:GetAbilityTextureName()
end

function item_premium_power_treads:GetIntrinsicModifierName() 
    return "modifier_item_premium_power_treads_pa" 
end

modifier_item_premium_power_treads_pa=class({})


function modifier_item_premium_power_treads_pa:IsHidden() 			
    return true 
end

function modifier_item_premium_power_treads_pa:IsPurgable() 		
    return false
end

function modifier_item_premium_power_treads_pa:IsPurgeException() 
    return false 
end

function modifier_item_premium_power_treads_pa:RemoveOnDeath() 
    return self:GetParent():IsIllusion() and true or false 
end

function modifier_item_premium_power_treads_pa:AllowIllusionDuplicate() 	
    return false 
end

function modifier_item_premium_power_treads_pa:OnCreated() 
    if self:GetAbility() == nil then
		return
	end
    self.all_stat=self:GetAbility():GetSpecialValueFor( "all_stat" ) 
    self.sp=self:GetAbility():GetSpecialValueFor( "sp" ) 
    self.attsp=self:GetAbility():GetSpecialValueFor( "attsp" ) 
    if not IsServer() or self:GetParent():IsIllusion() then
        return 
    end
    self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(),"modifier_item_premium_power_treads_attdis", {})
end


function modifier_item_premium_power_treads_pa:OnDestroy() 
    if self:GetParent():IsIllusion() then
        return 
    end
    if IsServer() then 
        if self:GetParent():HasModifier(  "modifier_item_premium_power_treads_attdis" ) then 
            self:GetParent():RemoveModifierByName( "modifier_item_premium_power_treads_attdis")
        elseif self:GetCaster().modifier_table~=nil then
                if self:GetParent():HasModifier( self:GetCaster().modifier_table[self:GetCaster().curr_modifier_num] ) then
                    self:GetParent():RemoveModifierByName( self:GetCaster().modifier_table[self:GetCaster().curr_modifier_num] )
                end 
        end     
    end 
    self:GetCaster().curr_modifier_num=nil
    self:GetCaster().modifier_table=nil
end



function modifier_item_premium_power_treads_pa:DeclareFunctions() 
    return 
    {   
        MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    } 
end

function modifier_item_premium_power_treads_pa:GetModifierBonusStats_Strength() 
    return self.all_stat
end

function modifier_item_premium_power_treads_pa:GetModifierBonusStats_Agility() 
    return self.all_stat
end

function modifier_item_premium_power_treads_pa:GetModifierBonusStats_Intellect() 
    return self.all_stat
end

function modifier_item_premium_power_treads_pa:GetModifierMoveSpeedBonus_Special_Boots() 
    return self.sp 
end

function modifier_item_premium_power_treads_pa:GetModifierAttackSpeedBonus_Constant() 
    return self.attsp
end

modifier_item_premium_power_treads_attdis=class({})

function modifier_item_premium_power_treads_attdis:IsBuff()			
    return true 
end

function modifier_item_premium_power_treads_attdis:IsHidden() 			
    return false 
end

function modifier_item_premium_power_treads_attdis:IsPurgable() 		
    return false
end

function modifier_item_premium_power_treads_attdis:IsPurgeException() 
    return false 
end

function modifier_item_premium_power_treads_attdis:GetTexture()
    return "item_Power_Treads_(Strength)_icon" 
end

function modifier_item_premium_power_treads_attdis:RemoveOnDeath() 
    return false 
end

function modifier_item_premium_power_treads_attdis:AllowIllusionDuplicate() 	
    return false 
end

function modifier_item_premium_power_treads_attdis:OnCreated()
    if self:GetAbility() == nil then
		return
	end
    self.att_dis=self:GetAbility():GetSpecialValueFor("att_dis")
end

function modifier_item_premium_power_treads_attdis:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    } 
end

function modifier_item_premium_power_treads_attdis:GetModifierAttackRangeBonus() 
    return  self.att_dis
end

modifier_item_premium_power_treads_attsp=class({})

function modifier_item_premium_power_treads_attsp:IsBuff()			
    return true 
end

function modifier_item_premium_power_treads_attsp:IsHidden() 			
    return false 
end

function modifier_item_premium_power_treads_attsp:IsPurgable() 		
    return false
end

function modifier_item_premium_power_treads_attsp:IsPurgeException() 
    return false 
end

function modifier_item_premium_power_treads_attsp:GetTexture()
    return "item_Power_Treads_(Agility)_icon" 
end

function modifier_item_premium_power_treads_attsp:RemoveOnDeath() 
    return false 
end

function modifier_item_premium_power_treads_attsp:AllowIllusionDuplicate() 	
    return false 
end


function modifier_item_premium_power_treads_attsp:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    } 
end

function modifier_item_premium_power_treads_attsp:OnCreated()
    if self:GetAbility() == nil then
		return
	end
    self.att_sp=self:GetAbility():GetSpecialValueFor("att_sp")
end

function modifier_item_premium_power_treads_attsp:GetModifierAttackSpeedBonus_Constant() 
    return self.att_sp
end


modifier_item_premium_power_treads_cast=class({})

function modifier_item_premium_power_treads_cast:IsBuff()			
    return true 
end

function modifier_item_premium_power_treads_cast:IsHidden() 			
    return false 
end

function modifier_item_premium_power_treads_cast:IsPurgable() 		
    return false
end

function modifier_item_premium_power_treads_cast:IsPurgeException() 
    return false 
end

function modifier_item_premium_power_treads_cast:GetTexture()
    return "item_Power_Treads_(Intelligence)_icon" 
end

function modifier_item_premium_power_treads_cast:RemoveOnDeath() 
    return false 
end

function modifier_item_premium_power_treads_cast:AllowIllusionDuplicate() 	
    return false 
end

function modifier_item_premium_power_treads_cast:OnCreated()
    if self:GetAbility() == nil then
		return
	end
    self.cast_dis=self:GetAbility():GetSpecialValueFor("cast_dis")
end

function modifier_item_premium_power_treads_cast:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    } 
end

function modifier_item_premium_power_treads_cast:GetModifierCastRangeBonusStacking() 
    return  self.cast_dis
end