meld=class({})
LinkLuaModifier("modifier_meld_buff", "heros/hero_templar_assassin/meld.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_meld_buff2", "heros/hero_templar_assassin/meld.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_meld_debuffar", "heros/hero_templar_assassin/meld.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_meld_debuffheal", "heros/hero_templar_assassin/meld.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_meld_debuffstun", "heros/hero_templar_assassin/meld.lua", LUA_MODIFIER_MOTION_NONE)

function meld:IsHiddenWhenStolen()
    return false
end

function meld:IsStealable()
    return true
end

function meld:IsRefreshable()
    return true
end

function meld:OnSpellStart()
    local caster = self:GetCaster()
    caster:Stop()
    caster:EmitSound("Hero_TemplarAssassin.Meld")
    caster:AddNewModifier(caster, self, "modifier_meld_buff2", {duration=0.2})
    caster:AddNewModifier(caster, self, "modifier_meld_buff", {})
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

function meld:OnProjectileHit_ExtraData(target, location,kv)
    local caster=self:GetCaster()
	if not target then
		return
    end
    if not target:IsBuilding() then
            if caster:TG_HasTalent("special_bonus_templar_assassin_8") then
                    local modifier=
                    {
                        outgoing_damage=0,
                        incoming_damage=0,
                        bounty_base=0,
                        bounty_growth=0,
                        outgoing_damage_structure=0,
                        outgoing_damage_roshan=0,
                    }
                    local illusions=CreateIllusions(caster, caster, modifier, 1, 0, false, false)
                    for _, tar  in pairs(illusions) do
                        tar:AddNewModifier(caster, self, "modifier_kill", {duration=2})
                        FindClearSpaceForUnit(tar, target:GetAbsOrigin()+TG_Direction(target:GetAbsOrigin(),caster:GetAbsOrigin())*caster:Script_GetAttackRange(), false)
                    end
            end
        caster:EmitSound("Hero_TemplarAssassin.Meld.Attack")
            target:AddNewModifier(caster, self, "modifier_meld_debuffar", {duration=self:GetSpecialValueFor( "ardur" )})
            target:AddNewModifier(caster, self, "modifier_meld_debuffheal", {duration=self:GetSpecialValueFor( "healdur" )})
        if  target:HasModifier("modifier_assassin_trap_debuff") and not  target:IsMagicImmune() then
            target:AddNewModifier(caster, self, "modifier_meld_debuffstun", {duration=self:GetSpecialValueFor( "healdur" )})
        end
        local fx = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal_attack_hit.vpcf", PATTACH_CUSTOMORIGIN,target)
        ParticleManager:SetParticleControlEnt(fx, 0,target, PATTACH_POINT_FOLLOW, "attach_hitloc",target:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(fx, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(fx)
        local fx2 = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_meld_focal_hit_tgt.vpcf", PATTACH_CUSTOMORIGIN, target)
        ParticleManager:SetParticleControlEnt(fx2, 0,target, PATTACH_POINT_FOLLOW, "attach_hitloc",target:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(fx2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(fx2, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(fx2)
    local dam=self:GetSpecialValueFor( "dam" )
    local damageTable = {
        victim = target,
        attacker = caster,
        damage =dam,
        damage_type =DAMAGE_TYPE_PHYSICAL,
        ability = self,
        }
        ApplyDamage(damageTable)
        SendOverheadEventMessage(target, OVERHEAD_ALERT_CRITICAL, target, dam, nil)
        local heros = FindUnitsInLine(
            caster:GetTeam(),
            target:GetAbsOrigin(),
            target:GetAbsOrigin()+caster:GetForwardVector()*600,
            caster,
            50,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
            if heros~=nil and #heros>0 then
                for _,target in pairs(heros) do
                    caster:PerformAttack(target,false, false, true, false, true, false, false)
                end
            end
    end
end

modifier_meld_buff=class({})


function modifier_meld_buff:IsHidden()
    return false
end

function modifier_meld_buff:IsPurgable()
    return false
end

function modifier_meld_buff:IsPurgeException()
    return false
end


function modifier_meld_buff:CheckState()
    return
    {
        [MODIFIER_STATE_INVISIBLE] = true,
    }
end

function modifier_meld_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_UNIT_MOVED,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
end

function modifier_meld_buff:GetModifierInvisibilityLevel()
    return 1
end

function modifier_meld_buff:GetActivityTranslationModifiers()
    return "meld"
end


function modifier_meld_buff:OnAttack(tg)
    if not IsServer() then
        return
    end
    if tg.attacker == self:GetParent() and not tg.attacker:IsIllusion() then
        if not self.HIT then
        local fx = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(fx)
        local P =
        {
            Target = tg.target,
            Source = self:GetParent(),
            Ability = self:GetAbility(),
            EffectName = "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf",
            iMoveSpeed = 1600,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
            bDrawsOnMinimap = false,
            bDodgeable = false,
            bIsAttack = false,
            bVisibleToEnemies = true,
            bReplaceExisting = false,
            bProvidesVision = false,
        }
        TG_CreateProjectile({id=1,team=self:GetParent():GetTeamNumber(),owner=self:GetParent(),p=P})
        self.HIT=true
        end
    end
end

function modifier_meld_buff:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker == self:GetParent() and not  self:GetParent():IsIllusion() and self.HIT then
        self.HIT2=true
        self:Destroy()
    end
end

function modifier_meld_buff:OnUnitMoved(tg)
    if not IsServer() then
        return
    end
    if tg.unit == self:GetParent() and not  self:GetParent():IsIllusion()  then
        if self.HIT then
            if  self.HIT2 then
                self:Destroy()
            end
        else
            self:Destroy()
        end
    end
end

function modifier_meld_buff:OnAbilityFullyCast(tg)
    if not IsServer() then
        return
    end

    if tg.unit == self:GetParent() and not  self:GetParent():IsIllusion()  then
        if tg.ability:IsItem()then
            self:Destroy()
        end
    end
end

function modifier_meld_buff:OnCreated()
    self.HIT=false
    self.HIT2=false
    if not IsServer() then
        return
    end
    local fx = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(fx, 0,self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(fx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(fx, false, false, 15, false, false)
end

function modifier_meld_buff:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():EmitSound("Hero_TemplarAssassin.Meld.Move")
end


modifier_meld_buff2=class({})

function modifier_meld_buff2:IsHidden()
    return true
end

function modifier_meld_buff2:IsPurgable()
    return false
end

function modifier_meld_buff2:IsPurgeException()
    return false
end


function modifier_meld_buff2:CheckState()
    return
    {
        [MODIFIER_STATE_INVULNERABLE] = true,
    }
end

modifier_meld_debuffar=class({})

function modifier_meld_debuffar:IsDebuff()
    return true
end

function modifier_meld_debuffar:IsHidden()
    return false
end

function modifier_meld_debuffar:IsPurgable()
    return false
end

function modifier_meld_debuffar:IsPurgeException()
    return false
end

function modifier_meld_debuffar:GetEffectName()
    return "particles/units/heroes/hero_templar_assassin/templar_meld_overhead.vpcf"
end

function modifier_meld_debuffar:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_meld_debuffar:OnCreated()
    self.AR=self:GetAbility():GetSpecialValueFor( "ar" )
end

function modifier_meld_debuffar:OnDestroy()
    self.AR=nil
end

function modifier_meld_debuffar:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_meld_debuffar:GetModifierPhysicalArmorBonus()
    return  self.AR
end

modifier_meld_debuffheal=class({})

function modifier_meld_debuffheal:IsDebuff()
    return true
end

function modifier_meld_debuffheal:IsHidden()
    return false
end

function modifier_meld_debuffheal:IsPurgable()
    return false
end

function modifier_meld_debuffheal:IsPurgeException()
    return false
end

function modifier_meld_debuffheal:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_DISABLE_HEALING,
	}
end

function modifier_meld_debuffheal:GetDisableHealing()
    return 1
end

modifier_meld_debuffstun=class({})

function modifier_meld_debuffstun:IsDebuff()
    return true
end

function modifier_meld_debuffstun:IsHidden()
    return false
end

function modifier_meld_debuffstun:IsPurgable()
    return true
end

function modifier_meld_debuffstun:IsPurgeException()
    return true
end

function modifier_meld_debuffstun:CheckState()
    return
    {
        [MODIFIER_STATE_TETHERED] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }

end