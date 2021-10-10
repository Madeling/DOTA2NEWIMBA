CreateTalents("npc_dota_hero_centaur", "heros/hero_centaur/hoof_stomp.lua")
hoof_stomp = class({})

LinkLuaModifier("modifier_hoof_stomp", "heros/hero_centaur/hoof_stomp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hoof_stomp_buff", "heros/hero_centaur/hoof_stomp.lua", LUA_MODIFIER_MOTION_NONE)

function hoof_stomp:IsHiddenWhenStolen()
    return false
end

function hoof_stomp:IsStealable()
    return true
end

function hoof_stomp:IsRefreshable()
    return true
end

function hoof_stomp:OnSpellStart()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    local radius=self:GetSpecialValueFor( "radius" )+caster:GetCastRangeBonus()
    local stomp_damage=self:GetSpecialValueFor( "stomp_damage" )
    local stun_duration=self:GetSpecialValueFor( "stun_duration" )+caster:TG_GetTalentValue("special_bonus_centaur_3")
    local num=0
    stun_duration=stun_duration-radius/100*0.1
    EmitSoundOn("Hero_Centaur.HoofStomp", caster)
    local particle= ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6_gold/centaur_ti6_warstomp_gold.vpcf", PATTACH_ABSORIGIN,caster)
    ParticleManager:SetParticleControl(particle, 0,caster_pos)
    ParticleManager:SetParticleControl(particle, 1,Vector(radius,1,1))
    ParticleManager:SetParticleControl(particle, 2,caster_pos)
    ParticleManager:ReleaseParticleIndex( particle )
    local damageTable = {
        attacker = caster,
        damage = stomp_damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self,
    }
    local heros = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster_pos,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false)
        if #heros>0 then
            for _, hero in pairs(heros) do
                if not hero:IsMagicImmune() then
                    hero:AddNewModifier_RS(caster, self, "modifier_imba_stunned", {duration=stun_duration})
                    damageTable.victim = hero
                    ApplyDamage( damageTable )
                end
            end
        end
        CreateModifierThinker(caster, self, "modifier_hoof_stomp", {duration=self:GetSpecialValueFor( "dur" )}, caster_pos, caster:GetTeamNumber(), false)
end

modifier_hoof_stomp= class({})

function modifier_hoof_stomp:IsHidden()
	return true
end

function modifier_hoof_stomp:IsPurgable()
	return false
end

function modifier_hoof_stomp:IsPurgeException()
	return false
end


function modifier_hoof_stomp:OnCreated(tg)
    self.radius=self:GetAbility():GetSpecialValueFor( "radius" )
    self.stun2=self:GetAbility():GetSpecialValueFor( "stun2" )
    if not IsServer() then
        return
    end
    self.POS=self:GetParent():GetAbsOrigin()
    local fx = ParticleManager:CreateParticle("particles/heros/centaur/centaur_hoof_stomp_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(fx, 0,  self.POS)
    ParticleManager:SetParticleControl(fx, 1, Vector(self.radius+self:GetCaster():GetCastRangeBonus(),1,1))
    ParticleManager:SetParticleControl(fx, 2, Vector(self:GetRemainingTime(),1,1))
    self:AddParticle(fx, false, false, -1, false, false)
    self:OnIntervalThink()
    self:StartIntervalThink(FrameTime())
end


function modifier_hoof_stomp:OnIntervalThink()
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self.POS,
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false)
        if #heros>0 then
        for _, hero in pairs(heros) do
            if hero==self:GetCaster() then
                hero:AddNewModifier(hero, self:GetAbility(), "modifier_hoof_stomp_buff", {duration=1.5})
                elseif not Is_Chinese_TG(hero,self:GetParent()) and TG_Distance(hero:GetAbsOrigin(),self.POS)>=self.radius+self:GetCaster():GetCastRangeBonus()  then
                        FindClearSpaceForUnit(hero, hero:GetAbsOrigin()+hero:GetForwardVector()*-50, false)
            end
        end
    end
end


modifier_hoof_stomp_buff= class({})

function modifier_hoof_stomp_buff:IsHidden()
	return false
end

function modifier_hoof_stomp_buff:IsPurgable()
	return false
end

function modifier_hoof_stomp_buff:IsPurgeException()
	return false
end

function modifier_hoof_stomp_buff:OnCreated()
    self.damageoutgoing=self:GetAbility():GetSpecialValueFor( "damageoutgoing" )+self:GetCaster():TG_GetTalentValue("special_bonus_centaur_1")
end


function modifier_hoof_stomp_buff:OnRefresh()
    self:OnCreated()
end

function modifier_hoof_stomp_buff:DeclareFunctions()
    return
    {

        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end


function modifier_hoof_stomp_buff:GetModifierIncomingDamage_Percentage()
    return  0-self.damageoutgoing
end