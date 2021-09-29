coup_de_grace=class({})
LinkLuaModifier("modifier_coup_de_grace_pa", "heros/hero_phantom_assassin/coup_de_grace.lua", LUA_MODIFIER_MOTION_NONE)

function coup_de_grace:GetIntrinsicModifierName()
    return "modifier_coup_de_grace_pa"
end


function coup_de_grace:OnHeroDiedNearby( hVictim, hKiller, kv )
	if hVictim == nil or hKiller == nil then
		return
	end
    local caster=self:GetCaster()
    local rd = self:GetSpecialValueFor( "rd" )+caster:TG_GetTalentValue("special_bonus_phantom_assassin_7")
	if not Is_Chinese_TG(hVictim,caster) and caster:IsAlive() then
		local dis =TG_Distance(caster:GetAbsOrigin(), hVictim:GetAbsOrigin())
		if  dis <= rd then
            caster:TG_Refresh_AB_Limit()
	    end
	end
end

modifier_coup_de_grace_pa=class({})

function modifier_coup_de_grace_pa:IsDebuff()
    return false
end

function modifier_coup_de_grace_pa:IsHidden()
    return true
end

function modifier_coup_de_grace_pa:IsPurgable()
    return false
end

function modifier_coup_de_grace_pa:IsPurgeException()
    return false
end

function modifier_coup_de_grace_pa:AllowIllusionDuplicate()
    return false
end

function modifier_coup_de_grace_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_FAIL,
    }
end

function modifier_coup_de_grace_pa:OnCreated()
    self.crit = {}
    self.crit_kill = self:GetAbility():GetSpecialValueFor("crit_kill")
    self.crit_bonus = self:GetAbility():GetSpecialValueFor("crit_bonus")
    self.crit_chance = self:GetAbility():GetSpecialValueFor("crit_chance")
end

function modifier_coup_de_grace_pa:OnRefresh()
    self:OnCreated()
end

function modifier_coup_de_grace_pa:GetModifierPreAttack_CriticalStrike(tg)
    if not IsServer() or self:GetParent():IsIllusion()  then
		return
	end
    if tg.attacker == self:GetParent() and not tg.target:IsBuilding() and not self:GetParent():PassivesDisabled() then
        if PseudoRandom:RollPseudoRandom(self:GetAbility() ,self.crit_chance)then
			self:GetParent():EmitSound("Hero_PhantomAssassin.CoupDeGrace.Arcana")
			self.crit[tg.record] = true
			return self.crit_bonus+self:GetCaster():TG_GetTalentValue("special_bonus_phantom_assassin_8")
		else
			return 0
		end
	end
end


function modifier_coup_de_grace_pa:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
	if tg.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled()  or tg.target:IsBuilding() or not tg.target:IsAlive() then
		return
    end
    if self.crit[tg.record] then
		local fx = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop.vpcf", PATTACH_ABSORIGIN, tg.target)
		ParticleManager:SetParticleControlEnt(fx, 0, tg.target, PATTACH_POINT_FOLLOW, "attach_hitloc", tg.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(fx, 1, tg.target:GetAbsOrigin())
		ParticleManager:SetParticleControlOrientation(fx, 1, -self:GetParent():GetForwardVector(), self:GetParent():GetRightVector(), self:GetParent():GetUpVector())
		ParticleManager:ReleaseParticleIndex(fx)
    end
    if tg.target:IS_TrueHero_TG() and RollPseudoRandomPercentage(self.crit_kill,0,self:GetParent()) and not tg.target:HasModifier("modifier_droiyan_cbuff")  then
        local fx2 = ParticleManager:CreateParticle("particles/econ/events/killbanners/screen_killbanner_compendium14_firstblood.vpcf", PATTACH_ABSORIGIN, self:GetParent())
        ParticleManager:ReleaseParticleIndex(fx2)
        local fx4 = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop.vpcf", PATTACH_ABSORIGIN, tg.target)
        ParticleManager:SetParticleControlEnt(fx4, 0, tg.target, PATTACH_POINT_FOLLOW, "attach_hitloc", tg.target:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(fx4, 1, tg.target:GetAbsOrigin())
        ParticleManager:SetParticleControlOrientation(fx4, 1, -self:GetParent():GetForwardVector(), self:GetParent():GetRightVector(), self:GetParent():GetUpVector())
        ParticleManager:ReleaseParticleIndex(fx4)
        tg.target:EmitSound("Hero_PhantomAssassin.CoupDeGrace.Arcana")
        TG_Kill(self:GetParent(), tg.target, self:GetAbility())
        SendOverheadEventMessage( tg.target, OVERHEAD_ALERT_CRITICAL,  tg.target, 7777777, nil)
        Notifications:TopToAll({hero=self:GetParent():GetUnitName(),duration = 3.0})
        Notifications:TopToAll({image="file://{images}/custom_game/skills/pa_kill.png", duration=3.0,continue=true})
        Notifications:TopToAll({hero=tg.target:GetUnitName(),duration = 3.0,continue=true})
        Notifications:TopToAll({text = "宿命", duration = 3.0, style = {["font-size"] = "50px", color = "#CD2626"}})
    end
    self.crit[tg.record] = nil
    end

function modifier_coup_de_grace_pa:OnAttackFail(tg)
        if not IsServer() then
            return
        end
        self.crit[tg.record] = nil
end
