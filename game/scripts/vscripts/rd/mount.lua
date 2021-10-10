
mount=class({})
LinkLuaModifier("modifier_mount", "rd/mount.lua", LUA_MODIFIER_MOTION_NONE)
function mount:IsHiddenWhenStolen() 
    return false 
end

function mount:IsStealable() 
    return true 
end


function mount:IsRefreshable() 			
    return false 
end

function mount:Precache( context )
	PrecacheResource( "model", "models/items/keeper_of_the_light/ti7_immortal_mount/kotl_ti7_immortal_horse.vmdl", context )
	PrecacheResource( "particle", "particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient.vpcf", context )
end


function mount:OnToggle()
    local caster=self:GetCaster() 
    if self:GetToggleState() then
        caster:AddNewModifier(caster, self, "modifier_mount", {})
  
    else 
        if caster:HasModifier("modifier_mount") then
            caster:RemoveModifierByName("modifier_mount")
        end
    end
end


modifier_mount=class({})

function modifier_mount:IsHidden() 			
    return true 
end

function modifier_mount:IsPurgable() 		
    return false
end

function modifier_mount:IsPurgeException() 
    return false 
end

function modifier_mount:GetEffectAttachType() 			
    return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_mount:GetEffectName() 			
    return "particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient.vpcf" 
end

function modifier_mount:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE 
    } 
end

function modifier_mount:GetModifierModelChange() 
    return "models/items/keeper_of_the_light/ti7_immortal_mount/kotl_ti7_immortal_horse.vmdl"
end

function modifier_mount:GetModifierModelScale() 
    return 30
end

function modifier_mount:GetModifierMoveSpeedBonus_Percentage() 
    return self:GetAbility():GetSpecialValueFor("sp")
end

function modifier_mount:CheckState() 
    return 
    {
        [MODIFIER_STATE_FLYING]=true,
        [MODIFIER_STATE_NO_HEALTH_BAR]=true,
        [MODIFIER_STATE_DISARMED]=true,
        [MODIFIER_STATE_SILENCED]=true,
    } 
end