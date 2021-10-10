CreateTalents("npc_dota_hero_shadow_shaman", "heros/hero_shadow_shaman/shock.lua")
shock= class({})
LinkLuaModifier("modifier_shock_dam", "heros/hero_shadow_shaman/shock.lua", LUA_MODIFIER_MOTION_NONE)

function shock:IsHiddenWhenStolen()
    return false
end

function shock:IsStealable()
    return true
end

function shock:IsRefreshable()
    return true
end

function shock:CastFilterResultTarget(target)
	if target:IsBuilding() and  (IsServer() and  not Is_Chinese_TG(target,self:GetCaster())) then
		return UF_FAIL_CUSTOM
	end
end

function shock:GetCustomCastErrorTarget(target)
    return "dota_hud_error_cant_cast_on_other"
end

function shock:OnSpellStart()
    local caster=self:GetCaster()
    local curtar=self:GetCursorTarget()
    local dam=self:GetSpecialValueFor("dam")
    local attd=self:GetSpecialValueFor( "attd")+caster:TG_GetTalentValue("special_bonus_shadow_shaman_2")
    if curtar:TG_TriggerSpellAbsorb(self)  and not Is_Chinese_TG(curtar,caster) then
		    return
	end
    if caster:Has_Aghanims_Shard() then
            caster:AddNewModifier(caster, self, "modifier_shock_dam", {duration =attd})
    end
        curtar:EmitSound("Hero_ShadowShaman.EtherShock.target")
         if not Is_Chinese_TG(caster,curtar) and not curtar:IsBuilding() then
            local enemies = FindUnitsInRadius(
                curtar:GetTeamNumber(),
                curtar:GetAbsOrigin(),
                nil,
                self:GetSpecialValueFor("attid")+caster:GetCastRangeBonus(),
                DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_NONE,
                FIND_ANY_ORDER,
                false)
            for _,target in pairs(enemies) do
             local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
             ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false )
             ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false )
             ParticleManager:SetParticleControl(particle, 10, target:GetAbsOrigin())
             ParticleManager:SetParticleControl(particle, 11, target:GetAbsOrigin())
             ParticleManager:ReleaseParticleIndex(particle)
              local damageTable = {
                                    victim = target,
                                    attacker = caster,
                                    damage =dam,
                                    damage_type = DAMAGE_TYPE_MAGICAL,
                                    ability = self,
                                    }
            ApplyDamage(damageTable)
        end
        elseif Is_Chinese_TG(caster,curtar) then
            local particle= ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
            ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false )
            ParticleManager:SetParticleControlEnt( particle, 1, curtar, PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", curtar:GetAbsOrigin(), false )
            ParticleManager:ReleaseParticleIndex(particle)
            curtar:AddNewModifier(caster, self, "modifier_shock_dam", {duration =attd})
        end
 end


modifier_shock_dam = modifier_shock_dam or class({})


function modifier_shock_dam:IsPurgable()
    return false
end

function modifier_shock_dam:IsPurgeException()
    return false
end

function modifier_shock_dam:IsHidden()
    return false
end

function modifier_shock_dam:RemoveOnDeath()
	return true
end


function modifier_shock_dam:OnCreated()
    self.maxnum=self:GetAbility():GetSpecialValueFor("maxnum")+self:GetCaster():TG_GetTalentValue("special_bonus_shadow_shaman_1")
    self.attid=self:GetAbility():GetSpecialValueFor("attid")
    self.dam= self:GetAbility():GetSpecialValueFor("dam")/2
    local atti =self:GetAbility():GetSpecialValueFor( "atti")
    if not IsServer() then
        return
    end
    local fx = ParticleManager:CreateParticle("particles/heros/shadow_shaman/shock_pa.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt( fx, 0, self:GetParent(), PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
    self:AddParticle(fx, false, false, 20, false, false)
	self:StartIntervalThink(atti)
end

function modifier_shock_dam:OnRefresh()
    self.maxnum=self:GetAbility():GetSpecialValueFor("maxnum")+self:GetCaster():TG_GetTalentValue("special_bonus_shadow_shaman_1")
    self.attid=self:GetAbility():GetSpecialValueFor("attid")
    self.dam= self:GetAbility():GetSpecialValueFor("dam")/2
    local atti =self:GetAbility():GetSpecialValueFor( "atti")
end

function modifier_shock_dam:OnDestroy()
    self.maxnum=nil
    self.dam= nil
    self.attid=nil
end

function modifier_shock_dam:OnIntervalThink()

    local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.attid, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if #enemies>0 then
                    for num=1,self.maxnum do
                        local unit=enemies[RandomInt(1,#enemies)]
                        if unit~=nil and unit:IsAlive() and not unit:IsMagicImmune() then
                            unit:EmitSound("Hero_ShadowShaman.EtherShock.target")
                            local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
                            ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false )
                            ParticleManager:SetParticleControlEnt( particle, 1, unit, PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), false )
                            ParticleManager:SetParticleControl(particle, 10, unit:GetAbsOrigin())
                            ParticleManager:SetParticleControl(particle, 11, unit:GetAbsOrigin())
                            ParticleManager:ReleaseParticleIndex(particle)
                            local damageTable = {
                                                victim = unit,
                                                attacker = self:GetCaster(),
                                                damage =self.dam,
                                                damage_type = DAMAGE_TYPE_MAGICAL,
                                                ability = self:GetAbility(),
                                                }
                            ApplyDamage(damageTable)
                        end
                    end
    end
end
