LinkLuaModifier("modifier_invoker_ice_wall_up_sp", "modifier/modifier_invoker_ice_wall_up.lua", LUA_MODIFIER_MOTION_NONE)
modifier_invoker_ice_wall_up=class({})

function modifier_invoker_ice_wall_up:IsHidden() 			
    return true 
end

function modifier_invoker_ice_wall_up:IsPurgable() 			
    return false 
end

function modifier_invoker_ice_wall_up:IsPurgeException() 	
    return false 
end


function modifier_invoker_ice_wall_up:OnCreated(tg) 	
    self.parent=self:GetParent()	
    self.caster=self:GetCaster()	
    self.ability=self:GetAbility()
    self.team=self.parent:GetTeamNumber()	
    self.pos=Vector(tg.x,tg.y,tg.z)
    self.slow_duration=self.ability:GetSpecialValueFor("slow_duration")
    if IsServer() then  
        self.pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControl( self.pfx, 0, self.pos )
        ParticleManager:SetParticleControl( self.pfx, 1, Vector(600,0,0))
        self:AddParticle(self.pfx, false, false, 1, false, false)
        self:OnIntervalThink()
        self:StartIntervalThink(1)
    end 
end

function modifier_invoker_ice_wall_up:OnIntervalThink() 	
    local heros = FindUnitsInRadius(
        self.team,
        self.pos,
        nil,
        600, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_ANY_ORDER,false)
        if #heros>0 then
            for _, hero in pairs(heros) do
                    hero:AddNewModifier(self.parent, self.ability, "modifier_invoker_ice_wall_slow_debuff", {duration=self.slow_duration})
                    hero:AddNewModifier(self.parent, self.ability, "modifier_invoker_ice_wall_up_sp", {duration=self.slow_duration})
            end 
        end
end



modifier_invoker_ice_wall_up_sp=class({})

function modifier_invoker_ice_wall_up_sp:IsHidden() 			
    return true 
end

function modifier_invoker_ice_wall_up_sp:IsPurgable() 			
    return false 
end

function modifier_invoker_ice_wall_up_sp:IsPurgeException() 	
    return false 
end

function modifier_invoker_ice_wall_up_sp:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_invoker_ice_wall_up_sp:GetModifierMoveSpeedBonus_Percentage(tg)
    return self:GetAbility():GetSpecialValueFor("slow")
end  