CreateTalents("npc_dota_hero_omniknight", "heros/hero_omniknight/purification.lua")
purification=class({})


LinkLuaModifier("modifier_purification_debuff", "heros/hero_omniknight/purification.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_purification_buff", "heros/hero_omniknight/purification.lua", LUA_MODIFIER_MOTION_NONE)
function purification:IsHiddenWhenStolen() 
    return false 
end

function purification:IsStealable() 
    return true 
end


function purification:IsRefreshable() 			
    return true 
end

function purification:OnSpellStart()
    local caster=self:GetCaster() 
    local target=self:GetCursorTarget() 
    local dur=self:GetSpecialValueFor("dur")
    local radius=self:GetSpecialValueFor("radius")
    local heal=self:GetSpecialValueFor("heal")+caster:TG_GetTalentValue("special_bonus_omniknight_1")
    local dur2=self:GetSpecialValueFor("dur2")
    EmitSoundOn("Hero_Omniknight.Purification", caster)
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
    local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(pfx2, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx2, 1, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(pfx2)
    target:Heal(heal, caster)
    SendOverheadEventMessage(target, OVERHEAD_ALERT_HEAL, target,heal, nil)
    if target==caster then 
        caster:AddNewModifier(caster, self, "modifier_purification_buff", {duration=dur2})
    end 
    local heroes = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
    for _, hero in pairs(heroes) do
                local damageTable = {
                victim = hero,
                attacker = caster,
                damage = heal,
                damage_type = DAMAGE_TYPE_PURE,
                ability = self, 
                }
                ApplyDamage(damageTable)
        hero:AddNewModifier(caster, self, "modifier_purification_debuff", {duration=dur})
	end
end


modifier_purification_debuff=class({})

function modifier_purification_debuff:IsPurgable() 			
    return false 
end

function modifier_purification_debuff:IsPurgeException() 	
    return false 
end

function modifier_purification_debuff:IsHidden()				
    return false 
end

function modifier_purification_debuff:IsDebuff()				
    return true 
end


function modifier_purification_debuff:CheckState()
    return 
    {
        [MODIFIER_STATE_DISARMED] = true,
    }
end


modifier_purification_buff=class({})

function modifier_purification_buff:IsPurgable() 			
    return false 
end

function modifier_purification_buff:IsPurgeException() 	
    return false 
end

function modifier_purification_buff:IsHidden()				
    return false 
end

function modifier_purification_buff:IsDebuff()				
    return false 
end

function modifier_purification_buff:OnCreated()				
    if not IsServer() then 
        return
    end 
    self.HP=self:GetCaster():GetStrength()*(self:GetAbility():GetSpecialValueFor("heal2")+self:GetCaster():TG_GetTalentValue("special_bonus_omniknight_2"))*0.01
    self:StartIntervalThink(1)
end

function modifier_purification_buff:OnIntervalThink()	
    local heroes1 = FindUnitsInRadius(self:GetParent():GetTeam(), self:GetParent():GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
    for _, hero in pairs(heroes1) do
        hero:Heal( self.HP, self:GetCaster())
        SendOverheadEventMessage(hero, OVERHEAD_ALERT_HEAL, hero,self.HP, nil)
    end			
end