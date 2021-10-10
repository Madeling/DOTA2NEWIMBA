ion_shell=class({})

LinkLuaModifier("modifier_ion_shell_buff", "heros/hero_dark_seer/ion_shell.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function ion_shell:IsHiddenWhenStolen() 
    return false 
end

function ion_shell:IsStealable() 
    return true 
end


function ion_shell:IsRefreshable() 			
    return true 
end

function ion_shell:OnSpellStart()
    local caster=self:GetCaster()
    local cur_tar=self:GetCursorTarget()
    local duration=self:GetSpecialValueFor("duration")
    cur_tar:EmitSound("Hero_Dark_Seer.Ion_Shield_Start")
    cur_tar:AddNewModifier(caster, self, "modifier_ion_shell_buff", {duration=duration})
end

modifier_ion_shell_buff=class({})

function modifier_ion_shell_buff:IsHidden() 			
	return false 
end

function modifier_ion_shell_buff:IsPurgable() 		
	return true 
end

function modifier_ion_shell_buff:IsPurgeException() 	
	return true 
end

function modifier_ion_shell_buff:OnCreated()
    local tick_interval=self:GetAbility():GetSpecialValueFor("tick_interval")
    self.radius=self:GetAbility():GetSpecialValueFor("radius")
    self.damage_per_second=self:GetAbility():GetSpecialValueFor("damage_per_second")
    if not IsServer() then
        return
    end 
    local pp = ParticleManager:CreateParticle("particles/heros/dark/shield_wall0.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl( pp,0, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(pp)
    local particle = ParticleManager:CreateParticle("particles/econ/items/dark_seer/dark_seer_ti8_immortal_arms/dark_seer_ti8_immortal_ion_shell.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
    ParticleManager:SetParticleControl( particle, 1,Vector(100,0,0))	
    self:AddParticle(particle, false, false, 20, false, false)
    self:StartIntervalThink(tick_interval)
end

function modifier_ion_shell_buff:OnIntervalThink()
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if #enemies>0 then 
        for _,unit in pairs(enemies) do
            if not unit:IsMagicImmune() then   
                if unit~=self:GetParent() then 
                    local particle = ParticleManager:CreateParticle("particles/econ/items/dark_seer/dark_seer_ti8_immortal_arms/dark_seer_ti8_immortal_ion_shell_dmg.vpcf", PATTACH_CUSTOMORIGIN,  self:GetParent())
                    ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
                    ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), false)
                    ParticleManager:ReleaseParticleIndex(particle)      
                    local damageTable = {
                        attacker = self:GetCaster(),
                        victim = unit,
                        damage = self.damage_per_second,
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = self:GetAbility()
                    }
                    ApplyDamage(damageTable)
                end 
            end
        end
    end
    
end



function modifier_ion_shell_buff:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_ion_shell_buff:OnTakeDamage(tg)
    if not IsServer() then
        return 
    end
    if tg.unit == self:GetParent() and tg.damage>=100 and  Is_Chinese_TG(self:GetCaster(),self:GetParent()) and tg.attacker:IsRealHero() then
        tg.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ion_shell_buff", {duration=self:GetAbility():GetSpecialValueFor("duration")})
    end
end

function modifier_ion_shell_buff:GetModifierModelScale()
    if self:GetCaster():TG_HasTalent("special_bonus_dark_seer_2") and self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
        return -40
    end 
    return 0
end

function modifier_ion_shell_buff:GetModifierIncomingDamage_Percentage() 
    if self:GetCaster():TG_HasTalent("special_bonus_dark_seer_4") and self:GetParent() == self:GetCaster() then
        return -10
    end 
    return 0
end