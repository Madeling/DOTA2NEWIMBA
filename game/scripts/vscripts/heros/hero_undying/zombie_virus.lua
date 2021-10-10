zombie_virus=class({})
LinkLuaModifier("modifier_zombie_virus_pa", "heros/hero_undying/zombie_virus.lua", LUA_MODIFIER_MOTION_NONE)

function zombie_virus:GetIntrinsicModifierName()
    return "modifier_zombie_virus_pa"
end

modifier_zombie_virus_pa=class({})
function modifier_zombie_virus_pa:IsPassive()
        return true
end

function modifier_zombie_virus_pa:IsPurgable()
    return false
end

function modifier_zombie_virus_pa:IsPurgeException()
    return false
end

function modifier_zombie_virus_pa:IsHidden()
    return true
end

function modifier_zombie_virus_pa:AllowIllusionDuplicate()
    return false
 end

function modifier_zombie_virus_pa:DeclareFunctions()
   return
   {
      MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
   }
end

function modifier_zombie_virus_pa:OnAbilityFullyCast(tg)
        if not IsServer() then
            return
        end

        if  self:GetAbility():IsCooldownReady() and  not Is_Chinese_TG(tg.unit,self:GetParent()) and TG_Distance(tg.unit:GetAbsOrigin(),self:GetParent():GetAbsOrigin())<1000   then
                if not tg.ability or tg.ability:IsItem() or tg.ability:IsToggle() then
                    return
                end
                        local lv=self:GetParent():GetLevel()
                        local hp=500+lv*40
                        local att=lv*15
                        local ZB=CreateUnitByName("npc_dota_unit_undying_zombie", tg.unit:GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber())
                        ZB:SetBaseMaxHealth(hp)
                        ZB:SetMaxHealth(hp)
                        ZB:SetHealth(hp)
                        ZB:SetBaseAttackTime(1)
                        ZB:SetBaseDamageMax( att )
                        ZB:SetBaseDamageMin( att )
                        ZB:FindAbilityByName("undying_tombstone_zombie_deathstrike"):SetLevel(1)
                        ZB:FindAbilityByName("neutral_spell_immunity"):SetLevel(1)
                        ZB:SetControllableByPlayer(self:GetParent():GetPlayerOwnerID(), false)
                        ZB:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_kill", {duration=7})
                        FindClearSpaceForUnit(ZB, ZB:GetAbsOrigin(), false)
                        ZB:MoveToTargetToAttack( tg.unit )
                self:GetAbility():UseResources( false, false, true )
        end
end