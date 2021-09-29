psi_blades=class({})
LinkLuaModifier("modifier_psi_blades_pa", "heros/hero_templar_assassin/psi_blades.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_psi_blades_debuff", "heros/hero_templar_assassin/psi_blades.lua", LUA_MODIFIER_MOTION_NONE)

function psi_blades:IsHiddenWhenStolen()
    return false
end

function psi_blades:IsStealable()
    return false
end

function psi_blades:GetIntrinsicModifierName()
    return "modifier_psi_blades_pa"
end


function psi_blades:GetBehavior()
        if self:GetCaster():TG_HasTalent("special_bonus_templar_assassin_2")  then
            return DOTA_ABILITY_BEHAVIOR_POINT
        else
            return DOTA_ABILITY_BEHAVIOR_PASSIVE
        end
end

function psi_blades:OnSpellStart()
    local caster = self:GetCaster()
    if caster:TG_HasTalent("special_bonus_templar_assassin_2") then
            local pos=self:GetCursorPosition()
            local heros = FindUnitsInRadius(
            caster:GetTeamNumber(),
            pos,
            nil,
            200,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_OTHER,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false )
            if #heros>0 then
                for _,target in pairs(heros) do
                        if  target:GetName()=="npc_dota_base_additive" then
                            caster:AddNewModifier(caster, self, "modifier_rooted", {duration=1.5})

                                local p = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_loadout.vpcf", PATTACH_WORLDORIGIN, nil)
                                        ParticleManager:SetParticleControl(p, 0, caster:GetAbsOrigin())
                                        ParticleManager:ReleaseParticleIndex(p)
                                Timers:CreateTimer(1.5, function()
                                        caster:EmitSound("Hero_TemplarAssassin.Meld")
                                        local p1 = ParticleManager:CreateParticle("particles/econ/events/spring_2021/blink_dagger_spring_2021_end.vpcf", PATTACH_WORLDORIGIN, nil)
                                        ParticleManager:SetParticleControl(p1, 0, pos)
                                        ParticleManager:ReleaseParticleIndex(p1)
                                        FindClearSpaceForUnit(caster, pos, true)
                                        return nil
	                            end)
                                return
                        end
                end
            end
    end
end

modifier_psi_blades_pa=class({})

function modifier_psi_blades_pa:IsHidden()
    return true
end

function modifier_psi_blades_pa:IsPurgable()
    return false
end

function modifier_psi_blades_pa:IsPurgeException()
    return false
end

function modifier_psi_blades_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_psi_blades_pa:OnCreated()
    self.DIS=self:GetAbility():GetSpecialValueFor("attack_spill_range")
    self.WH=self:GetAbility():GetSpecialValueFor("attack_spill_width")
    self.ATTRG=self:GetAbility():GetSpecialValueFor( "attrg" )
end

function modifier_psi_blades_pa:OnRefresh()
    self:OnCreated()
end

function modifier_psi_blades_pa:OnAttack(tg)
    if not IsServer() then
        return
    end
    if  tg.attacker == self:GetParent() then
        self.DIR=self:GetParent():GetForwardVector()
    end
end

function modifier_psi_blades_pa:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if  tg.attacker == self:GetParent() and not self:GetParent():IsIllusion()   then
            self.DIR=self.DIR==nil and self:GetParent():GetForwardVector() or self.DIR
            local heros = FindUnitsInLine(
            self:GetParent():GetTeam(),
            tg.target:GetAbsOrigin(),
            tg.target:GetAbsOrigin()+self.DIR*self.DIS,
            self:GetParent(),
            self.WH,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
            if heros~=nil and #heros>0 then
                for _,target in pairs(heros) do
                        if target~= tg.target then
                        local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_psi_blade.vpcf", PATTACH_CUSTOMORIGIN, nil)
                        ParticleManager:SetParticleControlEnt(fx, 0,tg.target, PATTACH_POINT_FOLLOW, "attach_hitloc",tg.target:GetAbsOrigin(), true)
                        ParticleManager:SetParticleControlEnt(fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
                        ParticleManager:ReleaseParticleIndex(fx)
                        local damageTable = {
                            attacker = self:GetParent(),
                            victim = target,
                            damage = self:GetParent():GetAverageTrueAttackDamage(self:GetParent()),
                            damage_type = DAMAGE_TYPE_PURE,
                            ability = self:GetAbility()
                        }
                        ApplyDamage(damageTable)
                        if self:GetCaster():TG_HasTalent("special_bonus_templar_assassin_7") then
                                self:GetCaster():PerformAttack(target, false, false, true, false, true, false, true)
                        end
                        target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_psi_blades_debuff", {duration = 0.5+self:GetCaster():TG_GetTalentValue("special_bonus_templar_assassin_6")})
                    end
                end
            end
	end
end

function modifier_psi_blades_pa:GetModifierAttackRangeBonus()
    return  self.ATTRG
end

modifier_psi_blades_debuff=class({})

function modifier_psi_blades_debuff:IsDebuff()
    return true
end

function modifier_psi_blades_debuff:IsHidden()
    return false
end

function modifier_psi_blades_debuff:IsPurgable()
    return false
end

function modifier_psi_blades_debuff:IsPurgeException()
    return false
end

function modifier_psi_blades_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_psi_blades_debuff:GetModifierAttackSpeedBonus_Constant()
    return -2000
end

function modifier_psi_blades_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -100
end