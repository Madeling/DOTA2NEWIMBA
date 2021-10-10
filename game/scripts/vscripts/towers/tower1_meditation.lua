tower1_med=class({})
LinkLuaModifier("modifier_tower1_med", "towers/tower1_meditation.lua", LUA_MODIFIER_MOTION_NONE)

function tower1_med:GetIntrinsicModifierName() 
    return "modifier_tower1_med" 
end

modifier_tower1_med = class({})

function modifier_tower1_med:IsBuff()	 		
    return true 
end

function modifier_tower1_med:IsHidden() 			
    return false 
end

function modifier_tower1_med:IsPurgable() 			
    return false 
end

function modifier_tower1_med:IsPurgeException() 	
    return false 
end
function modifier_tower1_med:GetTexture() 			
    return "tower1_med" 
end

function modifier_tower1_med:OnCreated()
    if not IsServer() then
        return
    end
			self:StartIntervalThink(1)
end


function modifier_tower1_med:OnIntervalThink()
    if not  self:GetAbility():IsCooldownReady()  then
		return
    end

    local heros = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(), 
		self:GetParent():GetAbsOrigin(), 
		nil, 
		1000, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
        false)
        
        if #heros>0 then
            for _, hero in pairs(heros) do
                hero:Heal( 30*0.01*hero:GetMaxHealth(), self:GetParent() )
                SendOverheadEventMessage(hero, OVERHEAD_ALERT_HEAL, hero,100, nil)
            end
            self:GetAbility():UseResources(true, true, true)
        end  
end
