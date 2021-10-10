CreateTalents("npc_dota_hero_ember_spirit", "heros/hero_ember_spirit/searing_chains.lua")
searing_chains=class({})

LinkLuaModifier("modifier_searing_chains_pa", "heros/hero_ember_spirit/searing_chains.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_debuff", "heros/hero_ember_spirit/searing_chains.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_disarm", "heros/hero_ember_spirit/searing_chains.lua", LUA_MODIFIER_MOTION_NONE)
function searing_chains:IsHiddenWhenStolen()
    return false
end

function searing_chains:IsRefreshable()
    return true
end

function searing_chains:IsStealable()
    return true
end

function searing_chains:GetIntrinsicModifierName()
    return "modifier_searing_chains_pa"
end

function searing_chains:OnSpellStart()
    local caster = self:GetCaster()
    local pos = caster:GetAbsOrigin()
    local radius = self:GetSpecialValueFor("radius")
    local unit_count = self:GetSpecialValueFor("unit_count")
    local damage = self:GetSpecialValueFor("damage")+caster:TG_GetTalentValue("special_bonus_ember_spirit_1")
    local duration = self:GetSpecialValueFor("duration")
    local disarm = self:GetSpecialValueFor("disarm")
    EmitSoundOn("Hero_EmberSpirit.SearingChains.Cast", caster)
	local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlForward(pf, 0, caster:GetForwardVector())
	ParticleManager:SetParticleControl(pf, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(pf)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
    if #heroes>0 then
        local num=#heroes<unit_count and #heroes or unit_count
        for a=1,num do
            EmitSoundOn("Hero_EmberSpirit.SearingChains.Target", heroes[a])
			local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", PATTACH_CUSTOMORIGIN, heroes[a])
			ParticleManager:SetParticleControlEnt(pf, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
			ParticleManager:SetParticleControlEnt(pf, 1, heroes[a], PATTACH_POINT_FOLLOW, "attach_hitloc", heroes[a]:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pf)
            heroes[a]:AddNewModifier_RS( caster, self, "modifier_searing_chains_debuff", {duration=duration+caster:TG_GetTalentValue("special_bonus_ember_spirit_2")} )
            heroes[a]:AddNewModifier_RS( caster, self, "modifier_disarmed", {duration=disarm} )
            local dam=
            {
                victim = heroes[a],
                attacker = caster,
                ability = self,
                damage = damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
            }
            ApplyDamage(dam)
        end
    end
end

modifier_searing_chains_pa=class({})

function modifier_searing_chains_pa:IsPassive()
    return true
end

function modifier_searing_chains_pa:IsHidden()
    return true
end

function modifier_searing_chains_pa:IsPurgable()
    return false
end

function modifier_searing_chains_pa:IsPurgeException()
    return false
end

function modifier_searing_chains_pa:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_searing_chains_pa:OnCreated()
   self.ability=self:GetAbility()
   self.parent=self:GetParent()
   self.ch=self.ability:GetSpecialValueFor("ch")
   self.duration=self.ability:GetSpecialValueFor("duration")
   self.damage=(self.ability:GetSpecialValueFor("damage")+self:GetCaster():TG_GetTalentValue("special_bonus_ember_spirit_1"))/2
   self.dam=
   {
       attacker = self.parent,
       ability = self.ability,
       damage = self.damage,
       damage_type = DAMAGE_TYPE_MAGICAL,
   }
end

function modifier_searing_chains_pa:OnRefresh()
    self.ch=self.ability:GetSpecialValueFor("ch")
    self.duration=self.ability:GetSpecialValueFor("duration")
    self.damage=self.ability:GetSpecialValueFor("damage")/2
    self.dam=
    {
        attacker = self.parent,
        ability = self.ability,
        damage = self.damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
 end

function modifier_searing_chains_pa:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker==self.parent and RollPseudoRandomPercentage(self.ch,0,self.parent) then
        local tar=tg.target
        if not tar:IsMagicImmune() and not tar:IsBuilding() then
            EmitSoundOn("Hero_EmberSpirit.SearingChains.Target", tar)
            self.dam.victim=tar
            ApplyDamage(self.dam)
            tar:AddNewModifier(self.parent, self.ability, "modifier_searing_chains_debuff", {duration=self.duration})
        end
    end
end

modifier_searing_chains_debuff=class({})

function modifier_searing_chains_debuff:IsDebuff()
    return true
end

function modifier_searing_chains_debuff:IsHidden()
    return false
end

function modifier_searing_chains_debuff:IsPurgable()
    return true
end

function modifier_searing_chains_debuff:IsPurgeException()
    return true
end

function modifier_searing_chains_debuff:GetEffectName()
    return "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf"
end

function modifier_searing_chains_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_searing_chains_debuff:CheckState()
    return
    {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_TETHERED] = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
    }
end
