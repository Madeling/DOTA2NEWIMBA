tower2_disarm=class({})
LinkLuaModifier("modifier_tower2_disarm", "towers/tower2_disarm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower2_disarm2", "towers/tower2_disarm.lua", LUA_MODIFIER_MOTION_NONE)

function tower2_disarm:GetIntrinsicModifierName() 
    return "modifier_tower2_disarm" 
end

modifier_tower2_disarm = class({})

function modifier_tower2_disarm:IsBuff()	 		
    return true 
end

function modifier_tower2_disarm:IsHidden() 			
    return false 
end

function modifier_tower2_disarm:IsPurgable() 			
    return false 
end

function modifier_tower2_disarm:IsPurgeException() 	
    return false 
end

function modifier_tower2_disarm:GetTexture() 			
    return "tower2_disarm" 
end


function modifier_tower2_disarm:OnCreated()
    if not IsServer() then
        return
    end
	self:StartIntervalThink(1)
end


function modifier_tower2_disarm:OnIntervalThink()
    if not self:GetAbility():IsCooldownReady() then
		return
    end
    if not self:GetParent():IsAlive()   then
        self:StartIntervalThink(-1)
        return 
    end 
    local heros = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(), 
		self:GetParent():GetAbsOrigin(), 
		nil, 
        1000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
        false)
        
        if #heros>0 then
            for _, hero in pairs(heros) do
                hero:EmitSound("DOTA_Item.HeavensHalberd.Activate")
                hero:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_tower2_disarm2", {duration=2} )
            end
            self:GetAbility():UseResources(false, false, true)
        end      
end

modifier_tower2_disarm2 = class({})

function modifier_tower2_disarm2:IsDebuff()	 		
    return true 
end

function modifier_tower2_disarm2:IsHidden() 			
    return false 
end

function modifier_tower2_disarm2:IsPurgable() 			
    return false 
end

function modifier_tower2_disarm2:IsPurgeException() 	
    return false 
end

function modifier_tower2_disarm2:GetEffectName()	
	return "particles/generic_gameplay/generic_disarm.vpcf"
end

function modifier_tower2_disarm2:GetEffectAttachType()	
   return PATTACH_OVERHEAD_FOLLOW
end

function modifier_tower2_disarm2:GetTexture() 			
    return "tower2_disarm" 
end

function modifier_tower2_disarm2:CheckState()
    return
     {
            [MODIFIER_STATE_DISARMED] = true,
    }
end