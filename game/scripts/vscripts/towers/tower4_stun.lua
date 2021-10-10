tower4_stun=class({})
LinkLuaModifier("modifier_tower4_stun", "towers/tower4_stun.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower4_stun2", "towers/tower4_stun.lua", LUA_MODIFIER_MOTION_NONE)

function tower4_stun:GetIntrinsicModifierName() 
    return "modifier_tower4_stun" 
end

modifier_tower4_stun = class({})

function modifier_tower4_stun:GetTexture() 			
    return "tower4_stun" 
end

function modifier_tower4_stun:IsHidden() 			
    return false 
end

function modifier_tower4_stun:IsPurgable() 			
    return false 
end

function modifier_tower4_stun:IsPurgeException() 	
    return false 
end

function modifier_tower4_stun:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end


function modifier_tower4_stun:OnAttackLanded(tg) 	
   if not IsServer() then
        return
    end
    if tg.attacker ~= self:GetParent() and tg.target==self:GetParent() then
        tg.attacker:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_tower4_stun2", {duration=0.1} )
    end
end

modifier_tower4_stun2 = class({})

function modifier_tower4_stun2:IsDebuff()	 		
    return true 
end

function modifier_tower4_stun2:IsHidden() 			
    return false 
end

function modifier_tower4_stun2:IsPurgable() 			
    return false 
end

function modifier_tower4_stun2:IsPurgeException() 	
    return false 
end

function modifier_tower4_stun2:GetEffectName()	
	return "particles/generic_gameplay/generic_bashed.vpcf"
end

function modifier_tower4_stun2:GetEffectAttachType()	
   return PATTACH_OVERHEAD_FOLLOW
end
function modifier_tower4_stun2:GetTexture() 			
    return "tower4_stun" 
end
function modifier_tower4_stun2:CheckState()
    return
     {
            [MODIFIER_STATE_STUNNED] = true,
    }
end