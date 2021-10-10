healing_ward2=class({})
LinkLuaModifier("modifier_healing_ward2_buff", "heros/hero_juggernaut/healing_ward2.lua", LUA_MODIFIER_MOTION_NONE)

function healing_ward2:IsHiddenWhenStolen() 
    return false 
end

function healing_ward2:IsStealable() 
    return true 
end


function healing_ward2:IsRefreshable() 			
    return true 
end

function healing_ward2:OnSpellStart()
    local caster = self:GetCaster()
    local ow=caster:GetOwner()
    caster:EmitSound("TG.juggdog")
    ow:Heal(ow:GetMaxHealth()*0.3, caster)
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, ow:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
   --[[ local dur=self:GetSpecialValueFor("dur")
    local heros = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        self:GetSpecialValueFor("rd"),
        DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
        FIND_CLOSEST,
        false)
    if #heros>0 then 
            for _, hero in pairs(heros) do
                if hero:IsAlive() and caster:GetOwner()==hero then 
                    hero:EmitSound("TG.juggdog")
                    local particle2 = ParticleManager:CreateParticle("particles/heros/jugg/jugg_dog.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
                    ParticleManager:SetParticleControl(particle2, 0, hero:GetUpVector()*600)
                    ParticleManager:ReleaseParticleIndex(particle2)
                    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
                    ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
                    ParticleManager:SetParticleControl(particle, 1, hero:GetAbsOrigin())
                    ParticleManager:ReleaseParticleIndex(particle)
                    hero:AddNoDraw()
                    Timers:CreateTimer(0.2, function()
                        hero:RemoveNoDraw()
                        return nil
                    end)
                    hero:AddNewModifier(caster, self, "modifier_healing_ward2_buff", {duration =dur})

                    caster:ForceKill(false)
                end
            end 
        else
            Notifications:Bottom(PlayerResource:GetPlayer(caster:GetOwner():GetPlayerOwnerID()), {text="范围内没有找到剑圣狗白白牺牲了o(╥﹏╥)o", duration=3, style={color="white", ["font-size"]="30px"}}) 
            caster:ForceKill(false)
        end
        ]]
end

modifier_healing_ward2_buff=class({})


function modifier_healing_ward2_buff:IsHidden() 			
	return false 
end

function modifier_healing_ward2_buff:IsPurgable() 		
	return false 
end

function modifier_healing_ward2_buff:IsPurgeException() 	
	return false 
end

function modifier_healing_ward2_buff:GetTexture()
	return "jugg_dog" 
end

function modifier_healing_ward2_buff:OnCreated(tg)
    if not IsServer() then
        return
    end
    local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle( particle, false, false, 20, false, false )   
    local particle2 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(particle2, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle2, 1, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle2, 3, Vector(1,0,0))
    ParticleManager:SetParticleControl(particle2, 6, Vector(1,0,0))
    ParticleManager:SetParticleControlEnt( particle2, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetAbsOrigin(), false )
 
    self:AddParticle( particle2, false, false, 20, false, false ) 
    local particle3 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_trigger.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle3, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle3, 1, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle3, 3, Vector(1,0,0))
    ParticleManager:SetParticleControl(particle3, 6, Vector(1,0,0))
    ParticleManager:SetParticleControlEnt( particle3, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetAbsOrigin(), false )
    self:AddParticle( particle3, false, false, 20, false, false ) 
    
end

function modifier_healing_ward2_buff:OnRefresh(tg)
    if not IsServer() then
        return
    end
    local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle( particle, false, false, 20, false, false )   
    local particle2 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
    ParticleManager:SetParticleControlEnt( particle2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false )
    ParticleManager:SetParticleControlEnt( particle2, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
    ParticleManager:SetParticleControlEnt( particle2, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetAbsOrigin(), false )
    ParticleManager:SetParticleControlEnt( particle2, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false )
    ParticleManager:SetParticleControlEnt( particle2, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false )
    self:AddParticle( particle2, false, false, 20, false, false ) 

    
end
