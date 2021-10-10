
modifier_rune_invis_tg = class({})
LinkLuaModifier("modifier_modifier_rune_invis_tg", "modifier/rune/modifier_rune_invis_tg.lua", LUA_MODIFIER_MOTION_NONE)


function modifier_rune_invis_tg:IsPurgable() 			
    return false 
end

function modifier_rune_invis_tg:IsPurgeException() 	
    return true 
end

function modifier_rune_invis_tg:IsHidden()				
    return false 
end

function modifier_rune_invis_tg:GetTexture() 
    return "rune_invis" 
end

function modifier_rune_invis_tg:GetEffectName() 
    return "particles/generic_gameplay/rune_invisibility_plasma.vpcf" 
end

function modifier_rune_invis_tg:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_rune_invis_tg:CheckState()
    return
    {
           [MODIFIER_STATE_INVISIBLE] = true,
           [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
   }
end

function modifier_rune_invis_tg:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
    }
end

function modifier_rune_invis_tg:GetModifierInvisibilityLevel()
    return 1
end 

function modifier_rune_invis_tg:OnCreated()
    if IsServer() then 
        AddFOWViewer(self:GetParent():GetTeamNumber() , self:GetParent():GetAbsOrigin(), 2000, 10, false)
    end 
end
