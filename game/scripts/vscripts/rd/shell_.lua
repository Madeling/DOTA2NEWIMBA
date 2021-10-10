shell_=class({})
LinkLuaModifier("modifier_shell_", "rd/shell_.lua", LUA_MODIFIER_MOTION_NONE)
function shell_:IsHiddenWhenStolen() 
    return false 
end

function shell_:IsStealable() 
    return true 
end


function shell_:IsRefreshable() 			
    return true 
end


function shell_:OnSpellStart()
    local caster=self:GetCaster() 
    caster:AddNewModifier(caster,self, "modifier_shell_", {duration=self:GetSpecialValueFor("dur")})
end


modifier_shell_=class({})

function modifier_shell_:IsHidden() 			
    return false 
end

function modifier_shell_:IsPurgable() 		
    return false
end

function modifier_shell_:IsPurgeException() 
    return false 
end

function modifier_shell_:OnCreated() 
    if IsServer() then
        self.rd=self:GetParent():GetHullRadius()
        self:GetParent():SetHullRadius(250)
    end
end

function modifier_shell_:OnDestroy() 
    if IsServer() then
        self:GetParent():SetHullRadius(self.rd)
    end
end

function modifier_shell_:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_MODEL_SCALE
    } 
end

function modifier_shell_:CheckState() 
    return 
    {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY]=true
    } 
end

function modifier_shell_:GetModifierModelScale() 
    return 200
end

function modifier_shell_:GetModifierIncomingDamage_Percentage() 
    if self:GetAbility() then
        return 0-self:GetAbility():GetSpecialValueFor("dmg")
    end
    return 0
end