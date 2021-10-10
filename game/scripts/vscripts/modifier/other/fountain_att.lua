modifier_fountain_att=class({})


function modifier_fountain_att:IsHidden() 			
    return false 
end

function modifier_fountain_att:IsPurgable() 			
    return false 
end

function modifier_fountain_att:IsPurgeException() 	
    return false 
end


function modifier_fountain_att:IsPermanent() 	
    return true 
end

function modifier_fountain_att:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end


function modifier_fountain_att:OnAttackLanded(tg) 	
   if not IsServer() then
        return
    end
    if tg.attacker == self:GetParent() then
        tg.target:AddNewModifier( self:GetParent(), nil, "modifier_stunned", {duration=10} )
        local damageTable =
        {
            victim = tg.target,
            attacker = self:GetParent():GetMaxHealth()*0.5,
            damage =damage,
            damage_type =DAMAGE_TYPE_PURE,
            damage_flags =DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
            ability = nil,
        }
        ApplyDamage(damageTable)
    end
end