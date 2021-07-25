bulldoze=class({})

LinkLuaModifier("modifier_bulldoze_buff", "heros/hero_spirit_breaker/bulldoze.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_bulldoze_buff1", "heros/hero_spirit_breaker/bulldoze.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function bulldoze:IsHiddenWhenStolen() 
    return false 
end

function bulldoze:IsStealable() 
    return false 
end

function bulldoze:IsRefreshable() 			
    return true 
end


function bulldoze:GetManaCost(iLevel)	
    if self:GetCaster():TG_HasTalent("special_bonus_spirit_breaker_2") then
        return 0
    else 
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end


function bulldoze:OnSpellStart()
    local caster = self:GetCaster()
    EmitSoundOn("Hero_Spirit_Breaker.Bulldoze.Cast", caster)
    caster:StartGesture(ACT_DOTA_SPAWN)
    caster:AddNewModifier(caster, self, "modifier_bulldoze_buff", {duration=self:GetSpecialValueFor("duration")})
    caster:AddNewModifier(caster, self, "modifier_bulldoze_buff1", {duration=self:GetSpecialValueFor("duration1")})
    if caster:TG_HasTalent("special_bonus_spirit_breaker_6") then
        local Knockback={
            should_stun = true,
            knockback_duration = 0.5,
            duration = 0.5,
            knockback_height = 100,
            knockback_distance = 150,
        }
        local heros = FindUnitsInRadius(
            caster:GetTeamNumber(),
            caster:GetAbsOrigin(),
            nil,
            250,
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
            FIND_CLOSEST,
            false)
        if #heros>0 then
            for _, hero in pairs(heros) do
                    EmitSoundOn("Hero_Spirit_Breaker.GreaterBash",hero) 
                    local pos=hero:GetAbsOrigin()
                    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf" , PATTACH_CENTER_FOLLOW,hero)
                    ParticleManager:SetParticleControl(particle, 0, pos)
                    ParticleManager:SetParticleControl(particle, 1, pos)
                    ParticleManager:SetParticleControl(particle, 2, pos)
                    ParticleManager:ReleaseParticleIndex(particle)
                    Knockback.center_x = pos.x
                    Knockback.center_y = pos.y
                    Knockback.center_z = pos.z
                    hero:AddNewModifier(caster,self, "modifier_knockback", Knockback)
            end
        end
    end
end

modifier_bulldoze_buff=class({})

function modifier_bulldoze_buff:IsHidden() 			
    return false 
end

function modifier_bulldoze_buff:IsPurgable() 			
    return false 
end

function modifier_bulldoze_buff:IsPurgeException() 	
    return false 
end

function modifier_bulldoze_buff:RemoveOnDeath() 	
    return true 
end

function modifier_bulldoze_buff:OnCreated()
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.movement_speed=self.ability:GetSpecialValueFor( "movement_speed" )
    self.status_resistance=self.ability:GetSpecialValueFor( "status_resistance" )
    if IsServer() then   
        local particle = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf" , PATTACH_ABSORIGIN_FOLLOW, self.parent,self.caster:GetPlayerOwner())
        ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, Vector(1,1,1))
        self:AddParticle( particle, false, false, 20, false, false )  
    end 
end

function modifier_bulldoze_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_bulldoze_buff:CheckState()
    if self.parent:HasModifier("modifier_charge_of_darkness") or self.parent:HasModifier("modifier_charge_of_darkness_forward") then 
        return
        {
            [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
            [MODIFIER_STATE_NO_HEALTH_BAR] = true,   
        } 
    else 
        return {}
    end
end


function modifier_bulldoze_buff:GetModifierMoveSpeedBonus_Percentage()
    return self.movement_speed
end

modifier_bulldoze_buff1=class({})

function modifier_bulldoze_buff1:IsHidden() 			
    return false 
end

function modifier_bulldoze_buff1:IsPurgable() 			
    return false 
end

function modifier_bulldoze_buff1:IsPurgeException() 	
    return false 
end

function modifier_bulldoze_buff1:RemoveOnDeath() 	
    return true 
end