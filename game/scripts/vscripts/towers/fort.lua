fort_ab=class({})

LinkLuaModifier("modifier_fort_ab", "towers/fort.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fort_ab", "towers/fort.lua", LUA_MODIFIER_MOTION_NONE)


function fort_ab:GetIntrinsicModifierName() 
    return "modifier_fort_ab" 
end

modifier_fort_ab = class({})

function modifier_fort_ab:IsBuff()	 		
    return true 
end

function modifier_fort_ab:IsHidden() 			
    return false 
end

function modifier_fort_ab:IsPurgable() 			
    return false 
end

function modifier_fort_ab:IsPurgeException() 	
    return false 
end

function modifier_fort_ab:OnCreated()
    self.ab2=true
    if not IsServer() then
        return
    end
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_disarmed", {})
    self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_tower_truesight_aura", {} )
	self:StartIntervalThink(1)
end


function modifier_fort_ab:OnIntervalThink()
    if not self:GetParent():IsAlive() then   
        return  
    end 
    if self:GetParent():GetHealthPercent()<=80 and self:GetParent():HasModifier("modifier_disarmed")  then
        self:GetParent():RemoveModifierByName("modifier_disarmed")
    end
    
    if self:GetParent():GetHealthPercent()<=50 and self.ab2  then
        self.ab2=false	
        local heros = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(), 
            self:GetParent():GetAbsOrigin(), 
            nil, 
            2000, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO, 
            DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
            FIND_ANY_ORDER, 
            false)

            if heros~=nil then
                for _,target in pairs(heros) do
                    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, target)
                    ParticleManager:SetParticleControl(particle, 0,target:GetAbsOrigin()+target:GetUpVector()*120)
                    ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()+target:GetUpVector()*2000)
                    ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin()+target:GetUpVector()*120)
                    ParticleManager:ReleaseParticleIndex(particle)
                        local damageTable = {
                            attacker =  self:GetParent(),
                            victim = target,
                            damage = 10000,
                            damage_type = DAMAGE_TYPE_PURE,
                            ability = self:GetAbility()
                        }
                        ApplyDamage(damageTable) 
               end
            end
    end
    

    if self:GetParent():GetHealthPercent()<=20  then
        local particle = ParticleManager:CreateParticle("particles/econ/events/ti6/mekanism_ti6.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:ReleaseParticleIndex(particle)
        self:GetParent():Heal( self:GetParent():GetMaxHealth()*0.3, self:GetParent() )
        self:GetParent():RemoveAbility( "fort_ab" )
	end
 end 