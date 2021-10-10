soul_rip=class({})
LinkLuaModifier("modifier_soul_rip_pa", "heros/hero_undying/soul_rip.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_soul_rip_buff", "heros/hero_undying/soul_rip.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tombstone_eat", "heros/hero_undying/soul_rip.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tombstone_eat2", "heros/hero_undying/soul_rip.lua", LUA_MODIFIER_MOTION_NONE)

function soul_rip:IsHiddenWhenStolen() 
    return false 
end

function soul_rip:IsStealable() 
    return true 
end


function soul_rip:IsRefreshable() 			
    return true 
end


function soul_rip:GetIntrinsicModifierName() 
    return "modifier_soul_rip_pa" 
end


function soul_rip:GetManaCost(iLevel)	
    if self:GetCaster():TG_HasTalent("special_bonus_undying_2") then
        return 0
    else 
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end

function soul_rip:GetCooldown(iLevel)  
        return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_undying_5")
end

function soul_rip:OnSpellStart()
    local target=self:GetCursorTarget()
    local caster=self:GetCaster() 
    local radius=self:GetSpecialValueFor("radius") 
    local tombstone_heal=self:GetSpecialValueFor("tombstone_heal") 
    local damage_per_unit=self:GetSpecialValueFor("damage_per_unit") 
    local max_units=self:GetSpecialValueFor("max_units") 
    EmitSoundOn("Hero_Undying.SoulRip.Cast", caster)
    target=target==nil and caster or target
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)               
    if  #enemies>0 then
        local NUM=#enemies
        if NUM>max_units then
            NUM=max_units
        end 
        if Is_Chinese_TG(target,caster) then 
            local hp=NUM*tombstone_heal
            for _,unit in pairs(enemies) do
                local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_soul_rip_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW ,target)
                ParticleManager:SetParticleControl(particle,0,target:GetAbsOrigin())
                ParticleManager:SetParticleControl(particle,1,unit:GetAbsOrigin())
                ParticleManager:ReleaseParticleIndex(particle)
            end
            if target:GetUnitName()=="npc_tombstone" then
                    target:Kill(self, target)
                        caster:AddNewModifier(caster, self, "modifier_tombstone_eat", {duration=20 })
                        if caster:TG_HasTalent("special_bonus_undying_4") then
                            caster:Heal(1000, caster) 
                            SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster,1000, nil)
                        end
                else 
                    target:AddNewModifier(caster, self, "modifier_soul_rip_buff", {duration=self:GetSpecialValueFor("dur"),num=hp })    
                    target:Heal(hp, caster) 
                    SendOverheadEventMessage(target, OVERHEAD_ALERT_HEAL, target,hp, nil)
            end 

        else
            for _,unit in pairs(enemies) do
                local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW ,unit)
                ParticleManager:SetParticleControl(particle,0,target:GetAbsOrigin())
                ParticleManager:SetParticleControl(particle,1,unit:GetAbsOrigin())
                ParticleManager:SetParticleControl(particle,1,target:GetAbsOrigin())
                ParticleManager:ReleaseParticleIndex(particle)
            end       
            local damage= {
                victim = target,
                attacker = caster,
                damage = NUM*damage_per_unit,
                damage_type = DAMAGE_TYPE_MAGICAL,
                damage_flag=DOTA_UNIT_TARGET_FLAG_NONE,
                ability = self,
                }
            ApplyDamage(damage)
        end
    end
end


modifier_soul_rip_pa=class({})


function modifier_soul_rip_pa:IsHidden() 			
	return true 
end

function modifier_soul_rip_pa:IsPurgable() 		
	return false 
end

function modifier_soul_rip_pa:IsPurgeException() 	
	return false 
end

function modifier_soul_rip_pa:OnCreated()
    self.ab=self:GetAbility()
    if IsServer() then 
        self:StartIntervalThink(0.5)
   end
end

function modifier_soul_rip_pa:OnIntervalThink()
    if self:GetCaster():IsAlive() and self.ab and self.ab:GetAutoCastState() and self.ab:GetLevel()>0 and self.ab:IsOwnersManaEnough() and self.ab:IsCooldownReady() then
        self.ab:OnSpellStart()
        self.ab:UseResources(true, false, true)
    end
end


modifier_soul_rip_buff=class({})

function modifier_soul_rip_buff:IsPurgable() 			
    return false 
end

function modifier_soul_rip_buff:IsPurgeException() 	
    return false 
end

function modifier_soul_rip_buff:IsHidden()				
    return false 
end

function modifier_soul_rip_buff:IsDebuff()				
    return false 
end

function modifier_soul_rip_buff:OnCreated(tg)				
   if IsServer() then 
    self:SetStackCount(tg.num)
    end 
end

function modifier_soul_rip_buff:OnRefresh(tg)				
     self:OnCreated(tg)
 end

function modifier_soul_rip_buff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end

function modifier_soul_rip_buff:GetModifierHealthBonus() 	
    return self:GetStackCount()
end





modifier_tombstone_eat=class({})

function modifier_tombstone_eat:IsPurgable() 			
    return false 
end

function modifier_tombstone_eat:IsPurgeException() 	
    return false 
end

function modifier_tombstone_eat:IsHidden()				
    return false 
end

function modifier_tombstone_eat:GetEffectAttachType()				
    return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_tombstone_eat:GetEffectName()				
    return "particles/units/heroes/hero_undying/undying_fg_aura.vpcf" 
end

function modifier_tombstone_eat:OnCreated()				
   if IsServer() then 
    TG_Set_Scepter(self:GetParent(),false,1,"plague_world")
    TG_Set_Scepter(self:GetParent(),false,1,"zombie_virus")
    end 
end

function modifier_tombstone_eat:OnDestroy()				
    if IsServer() then 
        TG_Set_Scepter(self:GetParent(),true,0,"plague_world")
        TG_Set_Scepter(self:GetParent(),true,0,"zombie_virus")
        if self:GetParent():HasModifier("modifier_plague_world_pa") then 
            self:GetParent():RemoveModifierByName("modifier_plague_world_pa")
        end 
        if self:GetParent():HasModifier("modifier_zombie_virus_pa") then 
            self:GetParent():RemoveModifierByName("modifier_zombie_virus_pa")
        end 
    end 
end


function modifier_tombstone_eat:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_tombstone_eat:GetModifierModelChange(tg)	
    if self:GetParent():HasModifier("modifier_flesh_golem_buff") then 
        return "models/items/undying/flesh_golem/corrupted_scourge_corpse_hive/corrupted_scourge_corpse_hive.vmdl"
    else 
        return "models/items/undying/flesh_golem/frostivus_2018_undying_accursed_draugr_golem/frostivus_2018_undying_accursed_draugr_golem.vmdl"
    end 
end

function modifier_tombstone_eat:GetModifierMagicalResistanceBonus(tg)	
        return 30+self:GetCaster():TG_GetTalentValue("special_bonus_undying_6")
end

function modifier_tombstone_eat:GetModifierStatusResistanceStacking() 
    if self:GetCaster():TG_HasTalent("special_bonus_undying_3") then
        return 30
    else
        return 0
    end
end


