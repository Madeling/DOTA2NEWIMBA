fire_remnant=class({})

LinkLuaModifier("modifier_fire_remnant_num", "heros/hero_ember_spirit/fire_remnant.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fire_remnant_esr", "heros/hero_ember_spirit/fire_remnant.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fire_remnant_hb", "heros/hero_ember_spirit/fire_remnant.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_debuff", "heros/hero_ember_spirit/searing_chains.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fire_remnant_duration", "heros/hero_ember_spirit/fire_remnant.lua", LUA_MODIFIER_MOTION_NONE)

function fire_remnant:IsHiddenWhenStolen()
    return false
end

function fire_remnant:IsRefreshable()
    return true
end

function fire_remnant:IsStealable()
    return true
end

function fire_remnant:GetAssociatedSecondaryAbilities()
    return "activate_fire_remnant"
end


function fire_remnant:OnUpgrade()
    local caster = self:GetCaster()
    if caster:HasAbility("activate_fire_remnant") then
        local AB = caster:FindAbilityByName("activate_fire_remnant")
        if AB then
            AB:SetLevel(self:GetLevel())
        end
	end
end

function fire_remnant:OnSpellStart()
    local caster = self:GetCaster()
    local pos = caster:GetAbsOrigin()
    local duration = self:GetSpecialValueFor("duration")
	local cur_pos = self:GetCursorPosition()
	local dis = TG_Distance(pos,cur_pos)
    local dir = TG_Direction(cur_pos,pos)
    if caster.fire_remnantTB==nil  then
        caster.fire_remnantTB={}
        caster:AddNewModifier(caster, self, "modifier_fire_remnant_num", {})
    end
    EmitSoundOn("Hero_EmberSpirit.FireRemnant.Cast", caster)
    local ESR=CreateUnitByName("npc_dota_ember_spirit_remnant", pos+dir*100, true, nil, nil,caster:GetTeamNumber())
    ESR:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
    ESR:AddNewModifier(caster, self, "modifier_fire_remnant_hb", {})
    table.insert (caster.fire_remnantTB,#caster.fire_remnantTB+1, ESR)
    local mod = caster:FindModifierByName("modifier_fire_remnant_num")
    if mod  then
        mod:IncrementStackCount()
    end
	local pp =
	{
		Ability = self,
		EffectName = "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = dis,
		fStartRadius = 0,
		fEndRadius = 0,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		vVelocity = dir * 3000,
        bProvidesVision = false,
        ExtraData = {ESR=ESR:entindex()}
	}
    ProjectileManager:CreateLinearProjectile(pp)
end

function fire_remnant:OnProjectileThink_ExtraData(location, kv)
    local ESR=EntIndexToHScript(kv.ESR)
    if ESR~=nil then
        ESR:SetAbsOrigin(GetGroundPosition(location, nil))
    end
end

function fire_remnant:OnProjectileHit_ExtraData(target, location, kv)
    local ESR=EntIndexToHScript(kv.ESR)
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
    local team=caster:GetTeamNumber()
    ESR:AddNewModifier(caster, self, "modifier_fire_remnant_esr", {duration = duration})
    ESR:SetAbsOrigin(GetGroundPosition(location, nil))
    EmitSoundOn("Hero_EmberSpirit.Remnant.Appear", ESR)
    if caster:Has_Aghanims_Shard() then
        AddFOWViewer(team, location, 1000, duration, false)
    end
    if caster:HasScepter() then
        local heroes = FindUnitsInRadius(team, location, nil, 360, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
        if #heroes>0 then
            for a=1,#heroes do
                caster:PerformAttack(heroes[a], false, false, true, false, false, false, true)
            end
        end
    end
end

modifier_fire_remnant_num=class({})

function modifier_fire_remnant_num:IsHidden()
    return true
end

function modifier_fire_remnant_num:IsPurgable()
    return false
end

function modifier_fire_remnant_num:IsPurgeException()
    return false
end

function modifier_fire_remnant_num:RemoveOnDeath()
    return false
end


modifier_fire_remnant_esr=class({})

function modifier_fire_remnant_esr:IsHidden()
    return true
end

function modifier_fire_remnant_esr:IsPurgable()
    return false
end

function modifier_fire_remnant_esr:IsPurgeException()
    return false
end


function modifier_fire_remnant_esr:RemoveOnDeath()
    return true
end

function modifier_fire_remnant_esr:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.pos=self.parent:GetAbsOrigin()
    self.act={81,82,74}
    self.radius=self.ability:GetSpecialValueFor("radius")
    self.duration=self.ability:GetSpecialValueFor("duration2")
    self.damage=self.ability:GetSpecialValueFor("damage")+self.caster:TG_GetTalentValue("special_bonus_ember_spirit_6")
    if IsServer() then
            self.caster:AddNewModifier(self.caster, self.ability, "modifier_fire_remnant_duration", {duration=self:GetRemainingTime()})
            local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant.vpcf", PATTACH_CUSTOMORIGIN, nil)
            ParticleManager:SetParticleControl(pf, 0, self.pos)
            ParticleManager:SetParticleControlEnt(pf, 1, self.caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", self.pos, false)
            ParticleManager:SetParticleControl(pf, 2, Vector(self.act[RandomInt(1, #self.act)], 0, 0))
            ParticleManager:SetParticleControl(pf, 60, Vector(RandomInt(0, 255),RandomInt(0, 255),RandomInt(0, 255)))
            ParticleManager:SetParticleControl(pf, 61, Vector(1,0,0))
            self:AddParticle(pf, false, false, 4, false, false)
    end
end

function modifier_fire_remnant_esr:OnDestroy()
    if IsServer() then
        for i =1 ,#self.caster.fire_remnantTB, -1 do
            if self.caster.fire_remnantTB[i] and self.caster.fire_remnantTB[i] == self.parent then
                EmitSoundOn("Hero_EmberSpirit.FireRemnant.Explode", self.caster.fire_remnantTB[i])
                table.remove(self.caster.fire_remnantTB, i)
                local heroes = FindUnitsInRadius(self.caster:GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
                if #heroes>0 then
                    for a=1,#heroes do
                        if not heroes[a]:IsMagicImmune() then
                            EmitSoundOn("Hero_EmberSpirit.SearingChains.Target", heroes[a])
                            heroes[a]:AddNewModifier_RS( self.caster, self.ability, "modifier_searing_chains_debuff", {duration=self.duration} )
                            local dam=
                            {
                                victim = heroes[a],
                                attacker = self.caster,
                                ability = self.ability,
                                damage = self.damage,
                                damage_type = DAMAGE_TYPE_MAGICAL,
                            }
                            ApplyDamage(dam)
                        end
                    end
                end
            end
        end
        self.caster:RemoveModifierByName("modifier_fire_remnant_duration")
    end
end

function modifier_fire_remnant_esr:CheckState()
    return
    {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }
end

modifier_fire_remnant_hb=class({})

function modifier_fire_remnant_hb:IsHidden()
    return true
end

function modifier_fire_remnant_hb:IsPurgable()
    return false
end

function modifier_fire_remnant_hb:IsPurgeException()
    return false
end

function modifier_fire_remnant_hb:RemoveOnDeath()
    return true
end

function modifier_fire_remnant_hb:CheckState()
    return
    {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
end


modifier_fire_remnant_duration=class({})

function modifier_fire_remnant_duration:IsHidden()
    return false
end

function modifier_fire_remnant_duration:IsPurgable()
    return false
end

function modifier_fire_remnant_duration:IsPurgeException()
    return false
end

function modifier_fire_remnant_duration:RemoveOnDeath()
    return false
end

function modifier_fire_remnant_duration:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end