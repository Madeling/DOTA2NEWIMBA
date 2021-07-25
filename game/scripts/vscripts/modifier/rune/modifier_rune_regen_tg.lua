modifier_rune_regen_tg = class({})

function modifier_rune_regen_tg:IsBuff()				
    return true 
end

function modifier_rune_regen_tg:IsPurgable() 			
    return false 
end

function modifier_rune_regen_tg:IsPurgeException() 	
    return true 
end

function modifier_rune_regen_tg:IsHidden()				
    return false 
end

function modifier_rune_regen_tg:GetTexture() 
    return "rune_regen" 
end

function modifier_rune_regen_tg:GetEffectName() 
    return "particles/generic_gameplay/rune_regeneration.vpcf" 
end

function modifier_rune_regen_tg:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_rune_regen_tg:OnCreated()
    if not IsServer() then
        return
    end
	self:StartIntervalThink(1)
end


function modifier_rune_regen_tg:OnIntervalThink()
    self:GetParent():Purge(false,true,false,false,false)
    self:GetParent():Heal( 100,  self:GetParent() )
    SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(),100, nil)
    self:GetParent():GiveMana(50)
    SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_MANA_ADD, self:GetParent(),50, nil)
end