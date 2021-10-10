tombstone=class({})

LinkLuaModifier("modifier_tombstone_buff", "heros/hero_undying/tombstone.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tombstone_debuff", "heros/hero_undying/tombstone.lua", LUA_MODIFIER_MOTION_NONE)
function tombstone:IsHiddenWhenStolen() 
    return false 
end

function tombstone:IsStealable() 
    return true 
end



function tombstone:IsRefreshable() 			
    return true 
end

function tombstone:OnSpellStart()
    local curpos=self:GetCursorPosition()
    local caster=self:GetCaster() 
    local duration=self:GetSpecialValueFor("duration")
    local tombstone_health=self:GetSpecialValueFor("tombstone_health")
    local radius=self:GetSpecialValueFor("radius")
    local spdur=self:GetSpecialValueFor("spdur")
    local zombie_num=self:GetSpecialValueFor("zombie_num") 
    local zombie_att=self:GetSpecialValueFor("zombie_att") 
    local zombie_attsp=self:GetSpecialValueFor("zombie_attsp") 
    local zombie_hp=self:GetSpecialValueFor("zombie_hp") 
    local zombie_dur=self:GetSpecialValueFor("zombie_dur") 
    local soul_rip_=caster:FindAbilityByName("soul_rip")
    EmitSoundOn("Hero_Undying.Tombstone", caster)
    if soul_rip_ then 
        soul_rip_:EndCooldown()
    end
   local ts=CreateUnitByName("npc_tombstone", curpos, true, caster, caster, caster:GetTeamNumber())
   ts:SetBaseMaxHealth(tombstone_health)
   ts:SetMaxHealth(tombstone_health)
   ts:SetHealth(tombstone_health)
   ts:AddNewModifier(caster, self, "modifier_tombstone_buff", {duration=duration})
   ts:AddNewModifier(caster, self, "modifier_kill", {duration=duration})
   ts:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), curpos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)               
    if  #enemies>0 then
            for _,target in pairs(enemies) do
                    if not target:IsMagicImmune() then   
                        target:AddNewModifier(caster, self, "modifier_tombstone_debuff", {duration=spdur})
                    end
            end
    end
    for i=1,zombie_num do  
        local ZB=CreateUnitByName("npc_dota_unit_undying_zombie", curpos+caster:GetForwardVector()*200, true, caster, caster, caster:GetTeamNumber())
        ZB:SetBaseMaxHealth(zombie_hp)
        ZB:SetMaxHealth(zombie_hp)
        ZB:SetHealth(zombie_hp)
        ZB:SetBaseAttackTime(zombie_attsp)
        ZB:SetBaseDamageMax( zombie_att )
        ZB:SetBaseDamageMin( zombie_att )
        ZB:FindAbilityByName("undying_tombstone_zombie_deathstrike"):SetLevel(1)
        ZB:FindAbilityByName("neutral_spell_immunity"):SetLevel(1)
        ZB:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
        ZB:AddNewModifier(caster, self, "modifier_kill", {duration=zombie_dur})
        FindClearSpaceForUnit(ZB, ZB:GetAbsOrigin(), false)
    end
    if soul_rip_ and soul_rip_:GetLevel()>0 and soul_rip_:GetAutoCastState() then 
        ts:Kill(self, ts)
        caster:AddNewModifier(caster, self, "modifier_tombstone_eat", {duration=20 })
        if caster:TG_HasTalent("special_bonus_undying_4") then
            caster:Heal(1000, caster) 
            SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster,1000, nil)
        end
    end
end

modifier_tombstone_buff=class({})

function modifier_tombstone_buff:IsPurgable() 			
    return false 
end

function modifier_tombstone_buff:IsPurgeException() 	
    return false 
end

function modifier_tombstone_buff:IsHidden()				
    return true 
end


function modifier_tombstone_buff:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, 
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, 
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE, 
	}
end

function modifier_tombstone_buff:OnAttackLanded(tg)				
    if not IsServer() then 
        return
    end
    if  tg.target == self:GetParent() then
        if self:GetParent():GetHealth()>0 then
        self:GetParent():SetHealth(self:GetParent():GetHealth() - 1) 
        elseif self:GetParent():GetHealth()<=0 then
        self:GetParent():Kill(self:GetAbility(), tg.attacker)
        end
	end
end

function modifier_tombstone_buff:GetAbsoluteNoDamageMagical() 
    return 1 
end

function modifier_tombstone_buff:GetAbsoluteNoDamagePhysical() 
    return 1 
end

function modifier_tombstone_buff:GetAbsoluteNoDamagePure() 
    return 1 
end

modifier_tombstone_debuff=class({})

function modifier_tombstone_debuff:IsPurgable() 			
    return false 
end

function modifier_tombstone_debuff:IsPurgeException() 	
    return false 
end

function modifier_tombstone_debuff:IsHidden()				
    return false 
end

function modifier_tombstone_debuff:IsDebuff()				
    return true 
end


function modifier_tombstone_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_tombstone_debuff:GetModifierMoveSpeedBonus_Percentage(tg)				
   return (0-self:GetAbility():GetSpecialValueFor("sp"))
end