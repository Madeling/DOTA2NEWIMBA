natures_attendants=class({})
LinkLuaModifier("modifier_natures_attendants_hp", "heros/hero_enchantress/natures_attendants.lua", LUA_MODIFIER_MOTION_NONE)
function natures_attendants:IsHiddenWhenStolen()
    return false
end
function natures_attendants:IsStealable()
    return true
end

function natures_attendants:IsRefreshable()
    return true
end

function natures_attendants:OnSpellStart()
    local caster=self:GetCaster()
    caster:EmitSound("Hero_Enchantress.NaturesAttendantsCast")
    caster:AddNewModifier(caster, self, "modifier_natures_attendants_hp", {duration = self:GetSpecialValueFor("dur")})
end

modifier_natures_attendants_hp=class({})

function modifier_natures_attendants_hp:IsPurgable()
    return true
end

function modifier_natures_attendants_hp:IsPurgeException()
    return true
end

function modifier_natures_attendants_hp:IsHidden()
    return false
end

function modifier_natures_attendants_hp:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_natures_attendants_hp:OnCreated()
    if not self:GetAbility() then
            return
    end
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.team=self.parent:GetTeamNumber()
    self.heal_interval=self.ability:GetSpecialValueFor("heal_interval")
    self.heal_int=self.ability:GetSpecialValueFor("heal_int")
    self.rd=self.ability:GetSpecialValueFor("rd")
    self.n=self.ability:GetSpecialValueFor("num")
    self.dur2=self.ability:GetSpecialValueFor("dur2")
    self.vrd=self.ability:GetSpecialValueFor("vrd")
    if IsServer() then
        self.rd=self.rd+self.parent:GetCastRangeBonus()
        self.vrd= self.vrd+self.parent:GetCastRangeBonus()
        local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_enchantress/enchantress_natures_attendants_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        self:AddParticle(particle, false, false, 20, false, false)
        self.particle2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_enchantress/enchantress_natures_attendants_count14.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
        ParticleManager:SetParticleControl(self.particle2, 0, self.parent:GetAbsOrigin())
        for num=3,11 do
            ParticleManager:SetParticleControlEnt(self.particle2, num,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",  self.parent:GetAbsOrigin(), true)
        end
        ParticleManager:SetParticleControl(self.particle2, 60, Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
        ParticleManager:SetParticleControl(self.particle2, 61, Vector(1,1,1))
        self:AddParticle(self.particle2, false, false, 100, false, false)
        self.num=0
    	self:StartIntervalThink(self.heal_interval)
    end
end

function modifier_natures_attendants_hp:OnRefresh()
    self:OnCreated()
end

function modifier_natures_attendants_hp:OnIntervalThink()
    if self.parent:TG_HasTalent("special_bonus_enchantress_1") then
            self.num=self.num+self.heal_interval
            if  self.num>=2 then
                    self.parent:Purge(false,true,false,false,false)
                    self.num=0
            end
    end
    local cpos=self.parent:GetAbsOrigin()
    local heros = FindUnitsInRadius(self.team, cpos, nil,  self.rd, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if #heros>0 then
        for _,target in pairs(heros) do
            target:Heal(self.heal_int, self.parent)
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,target, self.heal_int, nil)
        end
    end
    AddFOWViewer(self.team, cpos, self.vrd, 1, false)
end
