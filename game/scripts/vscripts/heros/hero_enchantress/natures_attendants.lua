natures_attendants=class({})
LinkLuaModifier("modifier_natures_attendants_hp", "heros/hero_enchantress/natures_attendants.lua", LUA_MODIFIER_MOTION_NONE)
function natures_attendants:IsHiddenWhenStolen() 
    return false 
end
function natures_attendants:IsStealable() 
    return true 
end

function natures_attendants:IsRefreshable() 			
    return true 
end

function natures_attendants:OnSpellStart()
    local caster=self:GetCaster()
    caster:EmitSound("Hero_Enchantress.NaturesAttendantsCast")
    caster:AddNewModifier(caster, self, "modifier_natures_attendants_hp", {duration = self:GetSpecialValueFor("dur")})
end


modifier_natures_attendants_hp=class({})

function modifier_natures_attendants_hp:IsPurgable() 			
    return true 
end

function modifier_natures_attendants_hp:IsPurgeException() 	
    return true 
end

function modifier_natures_attendants_hp:IsHidden()				
    return false 
end

function modifier_natures_attendants_hp:GetAttributes()				
    return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_natures_attendants_hp:OnCreated()		
    local heal_interval=self:GetAbility():GetSpecialValueFor("heal_interval")
    self.heal_int=self:GetAbility():GetSpecialValueFor("heal_int")
    self.rd=self:GetAbility():GetSpecialValueFor("rd")
    self.n=self:GetAbility():GetSpecialValueFor("num")
    self.dur2=self:GetAbility():GetSpecialValueFor("dur2")
    self.vrd=self:GetAbility():GetSpecialValueFor("vrd")
    if IsServer() then
        self.rd=self.rd+self:GetParent():GetCastRangeBonus() 
        self.vrd= self.vrd+self:GetParent():GetCastRangeBonus() 
        local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_enchantress/enchantress_natures_attendants_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        self:AddParticle(particle, false, false, 20, false, false) 
        self.particle2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_enchantress/enchantress_natures_attendants_count14.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(self.particle2, 0, self:GetParent():GetAbsOrigin())
        for num=3,11 do 
            ParticleManager:SetParticleControlEnt(self.particle2, num,  self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",  self:GetParent():GetAbsOrigin(), true)
        end
        ParticleManager:SetParticleControl(self.particle2, 60, Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
        ParticleManager:SetParticleControl(self.particle2, 61, Vector(1,1,1))
        self:AddParticle(self.particle2, false, false, 100, false, false) 
    	self:StartIntervalThink(heal_interval)
    end	
end

function modifier_natures_attendants_hp:OnRefresh()		
   self:OnCreated()	
end

function modifier_natures_attendants_hp:OnIntervalThink()			
    local heros = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  self.rd, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)               
    if #heros>0 then 
        for _,target in pairs(heros) do    
            target:Heal(self.heal_int, self:GetParent())
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,target, self.heal_int, nil) 
        end
    end
    AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.vrd, 1, false)
end	

