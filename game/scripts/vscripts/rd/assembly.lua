assembly=class({})
LinkLuaModifier("modifier_assembly", "rd/assembly.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assembly_buff", "rd/assembly.lua", LUA_MODIFIER_MOTION_NONE)
function assembly:IsRefreshable() 			
    return false 
end

function assembly:OnSpellStart()
    local target=self:GetCursorTarget()
    local caster=self:GetCaster() 
    local hero = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)               
    if  #hero>0 then
        for _,unit in pairs(hero) do
            unit:SetAbsOrigin(target:GetAbsOrigin())
            unit:AddNewModifier(caster, self, "modifier_assembly", {duration=5}) 
        end
    end
    target:AddNewModifier(caster, self, "modifier_assembly_buff", {duration=5}) 
    AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), 3000, 5, false)
end


modifier_assembly_buff=class({})

function modifier_assembly_buff:IsHidden() 		
    return false 
end

function modifier_assembly_buff:IsPurgable() 		
    return false 
end

function modifier_assembly_buff:IsPurgeException() 
    return false 
end

function modifier_assembly_buff:DeclareFunctions()
	return 
    {
        MODIFIER_PROPERTY_MODEL_CHANGE
	}
end

function modifier_assembly_buff:GetModifierModelChange()
    return "models/props_structures/wooden_sentry_tower001.vmdl"
end

modifier_assembly=class({})

function modifier_assembly:IsHidden() 		
    return false 
end

function modifier_assembly:IsPurgable() 		
    return false 
end

function modifier_assembly:IsPurgeException() 
    return false 
end

function modifier_assembly:CheckState()
    return 
    {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

function modifier_assembly:DeclareFunctions()
	return 
    {
	    MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_VISUAL_Z_DELTA,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end

function modifier_assembly:GetModifierModelScale()
    if self:GetAbility() then 
    	return -70
    end
    return 0
end

function modifier_assembly:GetVisualZDelta()
    return 350
end

function modifier_assembly:GetModifierAttackRangeBonus()
    return 500
end
