guardian_angel=class({})
LinkLuaModifier("modifier_guardian_angel_buff", "heros/hero_omniknight/guardian_angel.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_guardian_angel_buff2", "heros/hero_omniknight/guardian_angel.lua", LUA_MODIFIER_MOTION_NONE)
function guardian_angel:IsHiddenWhenStolen() 
    return false 
end

function guardian_angel:IsStealable() 
    return true 
end


function guardian_angel:IsRefreshable() 			
    return true 
end

function guardian_angel:OnSpellStart()
    local caster=self:GetCaster() 
    local duration=self:GetSpecialValueFor("duration")+caster:TG_GetTalentValue("special_bonus_omniknight_6")
    local radius=self:GetSpecialValueFor("radius")
    EmitSoundOn("Hero_Omniknight.GuardianAngel.Cast", caster)
    if caster:HasScepter() then 
        radius=25000
    end 
    local heroes = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
    for _, hero in pairs(heroes) do
        if self:GetAutoCastState() then 
            hero:AddNewModifier(caster, self, "modifier_guardian_angel_buff",{duration=duration})
        else 
            hero:AddNewModifier(caster, self, "modifier_guardian_angel_buff2", {duration=duration})
        end
	end
end


modifier_guardian_angel_buff=class({})

function modifier_guardian_angel_buff:IsPurgable() 			
    return false 
end

function modifier_guardian_angel_buff:IsPurgeException() 	
    return false 
end

function modifier_guardian_angel_buff:IsHidden()				
    return false 
end

function modifier_guardian_angel_buff:GetStatusEffectName()
    return "particles/status_fx/status_effect_guardian_angel.vpcf" 
   end

function modifier_guardian_angel_buff:StatusEffectPriority()
    return 15 
end

function modifier_guardian_angel_buff:GetEffectName() 
   return "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings_buff.vpcf" 
end

function modifier_guardian_angel_buff:GetEffectAttachType() 
   return PATTACH_OVERHEAD_FOLLOW 
end

function modifier_guardian_angel_buff:ShouldUseOverheadOffset() 
   return true 
end


function modifier_guardian_angel_buff:OnCreated()
    if not IsServer() then 
        return
    end 
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(pfx, false, false, 15, false, false)
end



function modifier_guardian_angel_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE, 
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL
    } 
end

function modifier_guardian_angel_buff:GetModifierIncomingPhysicalDamage_Percentage()
    return  self:GetAbility():GetSpecialValueFor("dam")-self:GetParent():TG_GetTalentValue("special_bonus_omniknight_8")
end

function modifier_guardian_angel_buff:GetAbsoluteNoDamageMagical() 
    return 1 
end

modifier_guardian_angel_buff2=class({})

function modifier_guardian_angel_buff2:IsPurgable() 			
    return false 
end

function modifier_guardian_angel_buff2:IsPurgeException() 	
    return false 
end

function modifier_guardian_angel_buff2:IsHidden()				
    return false 
end

function modifier_guardian_angel_buff2:GetStatusEffectName()
     return "particles/status_fx/status_effect_guardian_angel.vpcf" 
    end

function modifier_guardian_angel_buff2:StatusEffectPriority()
     return 15 
end

function modifier_guardian_angel_buff2:GetEffectName() 
    return "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings_buff.vpcf" 
end

function modifier_guardian_angel_buff2:GetEffectAttachType() 
    return PATTACH_OVERHEAD_FOLLOW 
end

function modifier_guardian_angel_buff2:ShouldUseOverheadOffset() 
    return true 
end

function modifier_guardian_angel_buff2:OnCreated()
    if not IsServer() then 
        return
    end 
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(pfx, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(pfx, false, false, 15, false, false)
end



function modifier_guardian_angel_buff2:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL 
    } 
end

function modifier_guardian_angel_buff2:GetModifierIncomingDamage_Percentage()
    return  self:GetAbility():GetSpecialValueFor("dam")-self:GetParent():TG_GetTalentValue("special_bonus_omniknight_7")
end


function modifier_guardian_angel_buff2:GetAbsoluteNoDamagePhysical() 
    return 1 
end