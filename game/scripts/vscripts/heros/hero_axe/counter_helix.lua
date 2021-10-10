counter_helix = class({})

LinkLuaModifier("modifier_counter_helix_ch", "heros/hero_axe/counter_helix.lua", LUA_MODIFIER_MOTION_NONE)

function counter_helix:IsHiddenWhenStolen()return false
end
function counter_helix:IsStealable() return true
end
function counter_helix:GetIntrinsicModifierName()
    return "modifier_counter_helix_ch"
end
function counter_helix:GetCastRange()
    return self:GetSpecialValueFor("radius")+self:GetCaster():GetStrength()
end

modifier_counter_helix_ch =  class({})
function modifier_counter_helix_ch:IsPassive()return true
end
function modifier_counter_helix_ch:IsPurgable()return false
end
function modifier_counter_helix_ch:IsPurgeException()return false
end
function modifier_counter_helix_ch:IsHidden()return true
end
function modifier_counter_helix_ch:AllowIllusionDuplicate()return false
end
function modifier_counter_helix_ch:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.team=self.parent:GetTeamNumber()
    if not self.ability then
            return
    end
    self.damageTable=
    {
        attacker = self.parent,
        damage_type = DAMAGE_TYPE_PURE,
        ability =  self.ability,
	}
        self.chance= self.ability:GetSpecialValueFor("chance")
        self.dam=self.ability:GetSpecialValueFor("dam")
        self.dam_max_hp=self.ability:GetSpecialValueFor("dam_max_hp")
        self.radius=self.ability:GetSpecialValueFor("radius")
        self.asch=self.ability:GetSpecialValueFor("asch")
        if IsServer() then
                self:StartIntervalThink(3.5)
        end
end
function modifier_counter_helix_ch:OnRefresh()
    self:OnCreated()
end
function modifier_counter_helix_ch:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,}
end
function modifier_counter_helix_ch:OnAttackLanded(tg)
        if not IsServer() then
                return
        end
    if tg.target==self.parent and not self.parent:PassivesDisabled() and  self.ability:IsCooldownReady() and self.parent:IsAlive() and not self.parent:IsIllusion() and not tg.attacker:IsBuilding() then
                if PseudoRandom:RollPseudoRandom(self.ability, (self.parent:TG_HasTalent("special_bonus_axe_8") and self.parent:GetHealth()<self.parent:GetMaxHealth()*0.15 ) and 25 or self.chance) then
                        self:TurnAround(self.parent)
                end
    end
    if tg.target==self.parent and self.parent:Has_Aghanims_Shard() and PseudoRandom:RollPseudoRandom(self.ability, self.asch) and not tg.attacker:IsBuilding() then
                self:TurnAround(tg.attacker)
    end
end
function modifier_counter_helix_ch:TurnAround(caster)
                if caster==self.parent then
                        caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
                end
                EmitSoundOn("Hero_Axe.CounterHelix_Blood_Chaser",caster)
                local cpos=caster:GetAbsOrigin()
                local str=self.radius+caster:GetStrength()
                local fx = ParticleManager:CreateParticle("particles/tgp/axe/axe_ch_m.vpcf", PATTACH_ABSORIGIN_FOLLOW,caster)
                ParticleManager:SetParticleControl(fx,0,cpos)
                ParticleManager:SetParticleControl(fx,1,Vector(str,0,0))
                ParticleManager:ReleaseParticleIndex(fx)
                local dam=self.dam +caster:GetMaxHealth()* self.dam_max_hp *0.01
                local units=FindUnitsInRadius(self.team,cpos,nil,str, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
                if #units>0 then
                    for _,target in pairs(units) do
                            if target~=caster then
                                    self.damageTable.victim = target
                                    self.damageTable.damage = dam
                                    ApplyDamage(self.damageTable)
                            end
                    end
                end
                self.ability:UseResources(false, false, true)
end

function modifier_counter_helix_ch:OnIntervalThink()
        if self.parent and IsValidEntity(self.parent) and self.parent:IsAlive() and  not self.parent:IsIllusion() and self.parent:TG_HasTalent("special_bonus_axe_6") then
                self:TurnAround(self.parent)
        end
end