tower4_blood=class({})
LinkLuaModifier("modifier_tower4_blood", "towers/tower4_blood.lua", LUA_MODIFIER_MOTION_NONE)

function tower4_blood:GetIntrinsicModifierName() 
    return "modifier_tower4_blood" 
end

modifier_tower4_blood = class({})

function modifier_tower4_blood:GetTexture() 			
    return "tower4_blood" 
end

function modifier_tower4_blood:IsHidden() 			
    return false 
end

function modifier_tower4_blood:IsPurgable() 			
    return false 
end

function modifier_tower4_blood:IsPurgeException() 	
    return false 
end

function modifier_tower4_blood:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end


function modifier_tower4_blood:OnAttackLanded(tg) 	
   if not IsServer() then
        return
    end
    if tg.attacker == self:GetParent() then
    local hp=tg.damage*0.07
    self:GetParent():Heal( hp, self:GetParent() )
    SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(),hp, nil)
end
end