modifier_truesight_f= class({})

function modifier_truesight_f:IsDebuff()			
    return false 
end

function modifier_truesight_f:IsHidden() 			
    return false 
end

function modifier_truesight_f:IsPurgable() 			
    return false 
end

function modifier_truesight_f:IsPurgeException() 	
    return false 
end

function modifier_truesight_f:RemoveOnDeath() 	
    return true 
end

function modifier_truesight_f:IsAura() 
    return true 
end

function modifier_truesight_f:GetTexture() 
    return "soul_of_truth" 
end

function modifier_truesight_f:GetModifierAura() 
    return  "modifier_truesight" 
end

function modifier_truesight_f:ShouldUseOverheadOffset() 
    return true
end

function modifier_truesight_f:GetEffectAttachType() 
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_truesight_f:GetEffectName() 
    return "particles/basic_ambient/generic_true_sight.vpcf" 
end

function modifier_truesight_f:GetAuraRadius() 
    return self:GetStackCount()
end

function modifier_truesight_f:OnCreated(tg) 
   if IsServer() then 
        self:SetStackCount(tg.num or 1000)
    end
end

function modifier_truesight_f:OnRefresh(tg) 
    self:OnCreated(tg) 
end


function modifier_truesight_f:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE 
end

function modifier_truesight_f:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_truesight_f:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_OTHER
end

