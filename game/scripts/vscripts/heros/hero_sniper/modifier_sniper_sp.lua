
modifier_sniper_sp=class({})
LinkLuaModifier("modifier_sniper_sp_buff", "heros/hero_sniper/modifier_sniper_sp.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_sniper_sp:IsHidden() 			
	return true 
end

function modifier_sniper_sp:IsPurgable() 		
	return false 
end

function modifier_sniper_sp:IsPurgeException() 	
	return false 
end

function modifier_sniper_sp:RemoveOnDeath() 	
	return false 
end

function modifier_sniper_sp:IsPermanent() 	
	return true 
end

function modifier_sniper_sp:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ABILITY_START,
    }
end

function modifier_sniper_sp:OnCreated(tg)
    if not IsServer() then
        return
    end
        self.VALUE= self:GetParent():TG_GetTalentValue(self:GetAbility():GetName())  
end

function modifier_sniper_sp:OnAbilityStart(tg) 
    if not IsServer() then
        return
    end
    if tg.unit == self:GetParent() then
       if  tg.ability:IsItem() or tg.ability:IsToggle() then 
           return 
        else
            self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_sniper_sp_buff", {duration=  self.VALUE or 1} )
        end
    end
end


modifier_sniper_sp_buff=class({})

function modifier_sniper_sp_buff:IsHidden() 			
	return false 
end

function modifier_sniper_sp_buff:IsPurgable() 		
	return false 
end

function modifier_sniper_sp_buff:IsPurgeException() 	
	return false 
end

function modifier_sniper_sp_buff:GetTexture() 	
	return "sniper_hphover" 
end


function modifier_sniper_sp_buff:DeclareFunctions() 
    return 
        {
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        } 
end


function modifier_sniper_sp_buff:GetModifierMoveSpeedBonus_Percentage() 
    return 50
end
