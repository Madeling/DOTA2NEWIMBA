assassin_trap=class({})
LinkLuaModifier("modifier_assassin_trap", "heros/hero_templar_assassin/assassin_trap.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assassin_trap_debuff", "heros/hero_templar_assassin/assassin_trap.lua", LUA_MODIFIER_MOTION_NONE)

function assassin_trap:IsHiddenWhenStolen()
    return false
end

function assassin_trap:IsStealable()
    return true
end

function assassin_trap:IsRefreshable()
    return true
end

function assassin_trap:GetAssociatedPrimaryAbilities()
    return "trap_teleport"
end

function assassin_trap:OnSpellStart()
    local caster = self:GetCaster()
    if caster.trap_teleportpos~=nil then
        TG_Remove_Modifier(caster,"modifier_trap_teleport",0)
        FindClearSpaceForUnit(caster, caster.trap_teleportpos, true)
        caster.trap_teleportpos=nil
        EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_TemplarAssassin.Trap.Explode", caster)
        local fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf", PATTACH_CUSTOMORIGIN,caster)
        ParticleManager:SetParticleControl(fx2, 0, caster:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(fx2)
        local fx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_meld_hit_tgt.vpcf", PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControlEnt(fx3, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(fx3)
        caster:AddNewModifier(caster, self, "modifier_assassin_trap", {duration=10})
        local heros = FindUnitsInRadius(
            caster:GetTeamNumber(),
            caster:GetAbsOrigin(),
            nil,
            self:GetSpecialValueFor( "rd" ),
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false )
        for _, hero in pairs(heros) do
            if not hero:IsMagicImmune() then
            hero:AddNewModifier(caster , self, "modifier_assassin_trap_debuff", {duration=self:GetSpecialValueFor( "sp_dur" )})
        end
        end

    end

end


modifier_assassin_trap=class({})

function modifier_assassin_trap:IsHidden()
    return false
end

function modifier_assassin_trap:IsPurgable()
    return false
end

function modifier_assassin_trap:IsPurgeException()
    return false
end

function modifier_assassin_trap:GetModifierProjectileName()
    return "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf"
end




function modifier_assassin_trap:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_FAIL,
    }
end

function modifier_assassin_trap:OnCreated()
    self.crit = {}
    if not IsServer() then
        return
    end
    local fx = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(fx, 0,self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(fx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(fx, false, false, 15, false, false)
end


function modifier_assassin_trap:GetModifierPreAttack_CriticalStrike(tg)
    if not IsServer() then
		return
	end
    if tg.attacker == self:GetParent() and not tg.target:IsBuilding() then
        self.crit[tg.record] = true
        return self:GetAbility():GetSpecialValueFor( "crit" )+self:GetCaster():TG_GetTalentValue("special_bonus_templar_assassin_3")
	end
end


function modifier_assassin_trap:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
	if tg.attacker ~= self:GetParent()  or tg.target:IsBuilding() or not tg.target:IsAlive() then
		return
    end
    if self.crit[tg.record] then
        tg.target:EmitSound("Hero_TemplarAssassin.Meld.Attack")
        local fx2 = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_meld_focal_hit_tgt.vpcf", PATTACH_CUSTOMORIGIN, tg.target)
        ParticleManager:SetParticleControlEnt(fx2, 0,tg.target, PATTACH_POINT_FOLLOW, "attach_hitloc",tg.target:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(fx2, 1, tg.target, PATTACH_POINT_FOLLOW, "attach_hitloc", tg.target:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(fx2, 3, tg.target, PATTACH_POINT_FOLLOW, "attach_hitloc", tg.target:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(fx2)
    end
    self.crit[tg.record] = nil
    self:Destroy()
end

function modifier_assassin_trap:OnAttackFail(tg)
        if not IsServer() then
            return
        end
        self.crit[tg.record] = nil
end

function modifier_assassin_trap:OnDestroy()
        self.crit = nil
end

modifier_assassin_trap_debuff=class({})

function modifier_assassin_trap_debuff:IsDebuff()
    return true
end

function modifier_assassin_trap_debuff:IsHidden()
    return false
end

function modifier_assassin_trap_debuff:IsPurgable()
    return false
end

function modifier_assassin_trap_debuff:IsPurgeException()
    return true
end

function modifier_assassin_trap_debuff:OnCreated()
    self.SP = self:GetAbility():GetSpecialValueFor("sp")
end

function modifier_assassin_trap_debuff:OnDestroy()
    self.SP = nil
end

function modifier_assassin_trap_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_assassin_trap_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.SP
end
