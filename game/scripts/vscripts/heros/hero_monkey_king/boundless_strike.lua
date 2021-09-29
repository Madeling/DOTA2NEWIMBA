CreateTalents("npc_dota_hero_monkey_king", "heros/hero_monkey_king/boundless_strike.lua")
boundless_strike=class({})
LinkLuaModifier("modifier_boundless_strike_start", "heros/hero_monkey_king/boundless_strike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boundless_strike_buff", "heros/hero_monkey_king/boundless_strike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boundless_strike_debuff2", "heros/hero_monkey_king/boundless_strike.lua", LUA_MODIFIER_MOTION_NONE)
function boundless_strike:IsHiddenWhenStolen()
    return false
end
function boundless_strike:IsStealable()
    return true
end
function boundless_strike:IsRefreshable()
    return true
end
function boundless_strike:Init()
  self.caster=self:GetCaster()
end

function boundless_strike:OnAbilityPhaseStart()
    self.caster:EmitSound("Hero_MonkeyKing.Strike.Cast")
	self.caster:AddNewModifier(self.caster, self, "modifier_boundless_strike_start", { duration = self:GetCastPoint()})
    return true
end

function boundless_strike:OnAbilityPhaseInterrupted()
	self.caster:StopSound("Hero_MonkeyKing.Strike.Cast")
	self.caster:RemoveModifierByName("modifier_boundless_strike_start")
	return true
end

function boundless_strike:OnSpellStart()
    self.caster:MK()
    self.caster:RemoveModifierByName("modifier_boundless_strike_start")
    local caster_pos = self.caster:GetAbsOrigin()
    local cur_pos = self:GetCursorPosition()
    local strike_radius=self:GetSpecialValueFor("strike_radius")
    local strike_cast_range=self:GetSpecialValueFor("strike_cast_range")
    local spdur=self:GetSpecialValueFor("spdur")
     local stun_duration=self:GetSpecialValueFor("stun_duration")+ self.caster:TG_GetTalentValue("special_bonus_night_stalker_2")
    local dir=self.caster:GetForwardVector()
    local end_pos=caster_pos+dir*(strike_cast_range+self.caster:GetCastRangeBonus())
    local cast=self:GetAutoCastState()
    local fxname="particles/econ/items/monkey_king/ti7_weapon/mk_ti7_golden_immortal_strike.vpcf"
    if cast then
        fxname="particles/econ/items/monkey_king/ti7_weapon/mk_ti7_immortal_strike.vpcf"
    end
    local particle = ParticleManager:CreateParticle(fxname, PATTACH_CUSTOMORIGIN, self.caster)
    ParticleManager:SetParticleControl(particle, 0, caster_pos)
    ParticleManager:SetParticleControlForward(particle, 0, dir)
    ParticleManager:SetParticleControl(particle, 1, end_pos)
    ParticleManager:ReleaseParticleIndex(particle)
    self.caster:AddNewModifier(self.caster, self, "modifier_boundless_strike_buff", {})
    EmitSoundOnLocationWithCaster(caster_pos, "Hero_MonkeyKing.Strike.Impact", self.caster)
	local heros = FindUnitsInLine(
        self.caster:GetTeamNumber(),
        caster_pos,
        end_pos,
        nil,
        strike_radius,
        self:GetAbilityTargetTeam(),
        self:GetAbilityTargetType(),
        self:GetAbilityTargetFlags())
    if #heros>0 then
        for _, hero in pairs(heros) do
            self.caster:PerformAttack(hero, false, true, true, false, true, false, true)
            if cast then
                local pos=caster_pos+dir*TG_Distance(hero:GetAbsOrigin(),caster_pos)
                FindClearSpaceForUnit(hero, pos, true)
                hero:AddNewModifier_RS(self.caster, self, "modifier_boundless_strike_debuff2", { duration =spdur })
            else
                hero:AddNewModifier_RS(self.caster, self, "modifier_stunned", { duration =stun_duration })
            end
        end
    end
    self.caster:RemoveModifierByName("modifier_boundless_strike_buff")
    EmitSoundOnLocationWithCaster(end_pos, "Hero_MonkeyKing.Strike.Impact.EndPos", self.caster)
    if self.caster:Has_Aghanims_Shard() then
    local modifier=
    {
        outgoing_damage=-90,
        incoming_damage=50,
        bounty_base=0,
        bounty_growth=0,
        outgoing_damage_structure=0,
        outgoing_damage_roshan=0,
    }
        local illusions=CreateIllusions(self.caster, self.caster, modifier, 1, 300, false, true)
        for i=1,#illusions do
            illusions[i]:AddNewModifier(self.caster, self, "modifier_kill", {duration=12})
            FindClearSpaceForUnit(illusions[i], cur_pos, true)
        end
    end
end

modifier_boundless_strike_start=class({})

function modifier_boundless_strike_start:IsHidden()
	return true
end

function modifier_boundless_strike_start:IsPurgable()
	return false
end

function modifier_boundless_strike_start:IsPurgeException()
	return false
end

function modifier_boundless_strike_start:OnCreated(tg)
    local parent=self:GetParent()
    local pos= parent:GetAbsOrigin()
    if not IsServer() then
        return
    end
    local cast=self:GetAbility():GetAutoCastState()
    local fxname="particles/econ/items/monkey_king/ti7_weapon/mk_ti7_golden_immortal_strike_cast.vpcf"
    if cast then
        fxname="particles/econ/items/monkey_king/ti7_weapon/mk_ti7_immortal_strike_cast.vpcf"
    end
    local particle = ParticleManager:CreateParticle(fxname, PATTACH_CUSTOMORIGIN_FOLLOW,parent)
    ParticleManager:SetParticleControl(particle, 0, pos)
    ParticleManager:SetParticleControlEnt(particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_weapon_bot",pos, true)
    ParticleManager:SetParticleControlEnt(particle, 2, parent, PATTACH_POINT_FOLLOW, "attach_weapon_top", pos, true)
    ParticleManager:SetParticleControl(particle, 3, pos)
    self:AddParticle(particle, false, false, 15, false, false)
end

modifier_boundless_strike_buff=class({})
function modifier_boundless_strike_buff:IsDebuff()
	return false
end

function modifier_boundless_strike_buff:IsHidden()
	return true
end

function modifier_boundless_strike_buff:IsPurgable()
	return false
end

function modifier_boundless_strike_buff:IsPurgeException()
	return false
end

function modifier_boundless_strike_buff:AllowIllusionDuplicate()
	return false
end

function modifier_boundless_strike_buff:OnCreated()
    self.strike_crit_mult=self:GetAbility():GetSpecialValueFor("strike_crit_mult")
end

function modifier_boundless_strike_buff:OnRefresh()
    self:OnCreated()
end


function modifier_boundless_strike_buff:CheckState()
    return
    {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
end

function modifier_boundless_strike_buff:DeclareFunctions()
    return
    {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
end

function modifier_boundless_strike_buff:GetModifierPreAttack_CriticalStrike()
	return  self.strike_crit_mult+self:GetCaster():TG_GetTalentValue("special_bonus_night_stalker_1")
end


modifier_boundless_strike_debuff2=class({})
function modifier_boundless_strike_debuff2:IsDebuff()
	return true
end

function modifier_boundless_strike_debuff2:IsHidden()
	return false
end

function modifier_boundless_strike_debuff2:IsPurgable()
	return false
end

function modifier_boundless_strike_debuff2:IsPurgeException()
	return false
end

function modifier_boundless_strike_debuff2:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_boundless_strike_debuff2:GetEffectName()
	return "particles/units/heroes/hero_monkey_king/monkey_king_strike_slow.vpcf"
end


function modifier_boundless_strike_debuff2:OnCreated()
    self.SP=self:GetAbility():GetSpecialValueFor("sp")
end

function modifier_boundless_strike_debuff2:OnRefresh()
    self:OnCreated()
end


function modifier_boundless_strike_debuff2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

end

function modifier_boundless_strike_debuff2:GetModifierMoveSpeedBonus_Percentage()
    return self.SP
end