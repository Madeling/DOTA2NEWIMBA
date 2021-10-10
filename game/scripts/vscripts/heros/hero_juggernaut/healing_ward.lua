healing_ward=class({})
LinkLuaModifier("modifier_healing_ward_buff", "heros/hero_juggernaut/healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_healing_ward_buff2", "heros/hero_juggernaut/healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
function healing_ward:IsHiddenWhenStolen() 
    return false 
end

function healing_ward:IsStealable() 
    return true 
end


function healing_ward:IsRefreshable() 			
    return true 
end

function healing_ward:OnSpellStart()
    local caster = self:GetCaster()
    local cur_pos=self:GetCursorPosition()
    local dur=self:GetSpecialValueFor("dur")
    if self:GetAutoCastState() then
        caster:AddNewModifier(caster, self, "modifier_healing_ward_buff", {duration =dur})
    else 
        local ward=CreateUnitByName("npc_dota_healing_ward", cur_pos, true, caster, caster, caster:GetTeamNumber())
        ward:SetControllableByPlayer(caster:GetPlayerID(), true)
        ward:AddNewModifier(caster, self, "modifier_kill", {duration=dur})
        ward:AddNewModifier(caster, self, "modifier_healing_ward_buff2", {duration=dur})
        ward:AddNewModifier(caster, self, "modifier_healing_ward_buff", {duration =dur})
        local ab=ward:GetAbilityByIndex(0)
        ab:SetLevel(1)
        Timers:CreateTimer(0.1, function()
            ward:MoveToNPC(caster)
            return nil
        end)
    end
end

modifier_healing_ward_buff=class({})


function modifier_healing_ward_buff:IsHidden() 			
	return false 
end

function modifier_healing_ward_buff:IsPurgable() 		
	return false 
end

function modifier_healing_ward_buff:IsPurgeException() 	
	return false 
end

function modifier_healing_ward_buff:OnCreated(tg)
    self.RD=self:GetAbility():GetSpecialValueFor("rd")
    self.TICK=self:GetAbility():GetSpecialValueFor("tick")
    self.HEAL=self:GetAbility():GetSpecialValueFor("heal")+self:GetCaster():TG_GetTalentValue("special_bonus_juggernaut_5")
    if not IsServer() then
        return
    end
    self.RD= self.RD+self:GetParent():GetCastRangeBonus()
    local particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healing_ward_fortunes_tout_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(self.RD,0,(0-self.RD)))
    self:AddParticle( particle, false, false, 20, false, false )
    self:StartIntervalThink( self.TICK)
end

function modifier_healing_ward_buff:OnRefresh(tg)
    self:OnDestroy()
    self:OnCreated(tg)
end

function modifier_healing_ward_buff:OnIntervalThink()
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        self.RD,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
        FIND_CLOSEST,
        false)
    if #heros>0 then 
            for _, hero in pairs(heros) do
                if hero:IsAlive() then 
                    local hp=hero:GetMaxHealth()*self.HEAL*0.01
                    hero:Heal(hp, self:GetParent())
                    SendOverheadEventMessage(hero, OVERHEAD_ALERT_HEAL, hero,hp,nil)
                end
            end 
    end
end

modifier_healing_ward_buff2=class({})

function modifier_healing_ward_buff2:IsHidden() 			
	return true 
end

function modifier_healing_ward_buff2:IsPurgable() 		
	return false 
end

function modifier_healing_ward_buff2:IsPurgeException() 	
	return false 
end


function modifier_healing_ward_buff2:CheckState()
    return 
    {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end