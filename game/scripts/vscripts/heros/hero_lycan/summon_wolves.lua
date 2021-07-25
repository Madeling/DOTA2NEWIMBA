summon_wolves=class({})

LinkLuaModifier("modifier_summon_wolves", "heros/hero_lycan/summon_wolves.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_summon_wolves_buff", "heros/hero_lycan/summon_wolves.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_summon_wolves_debuff", "heros/hero_lycan/summon_wolves.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_summon_wolves_buff1", "heros/hero_lycan/summon_wolves.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wolf_bite_debuff", "heros/hero_lycan/wolf_bite.lua", LUA_MODIFIER_MOTION_NONE)
function summon_wolves:IsHiddenWhenStolen()
    return false
end

function summon_wolves:IsStealable()
    return true
end

function summon_wolves:IsRefreshable()
    return true
end


function summon_wolves:OnSpellStart()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    local pos = caster_pos+caster:GetForwardVector()*250
    local team = caster:GetTeamNumber()
    local lv = tostring(self:GetLevel())
    local id = caster:GetPlayerOwnerID()
    local target = self:GetCursorTarget()
    local wolf_index = self:GetSpecialValueFor( "wolf_index" )+caster:TG_GetTalentValue("special_bonus_lycan_1")
    local wolf_duration = self:GetSpecialValueFor( "wolf_duration" )
    EmitSoundOn("Hero_Lycan.SummonWolves", caster)
    for a=1,wolf_index do
        local unit=CreateUnitByName("npc_dota_lycan_wolf"..lv, pos, true, caster, caster,team)
        unit:SetControllableByPlayer(id, true)
        unit:AddNewModifier(caster, self, "modifier_kill", {duration=wolf_duration})
        unit:AddNewModifier(caster, self, "modifier_summon_wolves", {duration=wolf_duration})
        unit:AddNewModifier(caster, self, "modifier_summon_wolves_buff1", {duration=wolf_duration})
        FindClearSpaceForUnit(unit, pos, false)
        if  target~=nil then
            local tpos=target:GetAbsOrigin()
            local dis=TG_Distance(tpos,caster_pos)
            local dir=TG_Direction(caster_pos,tpos)
            local Knockback ={
                should_stun = false,
                knockback_duration = 0.6,
                duration = 0.6,
                knockback_distance = dis,
                knockback_height = 150,
                center_x =  dir.x+caster_pos.x,
                center_y =  dir.y+caster_pos.y,
                center_z =  caster_pos.z,
            }
            unit:AddNewModifier(caster,self, "modifier_summon_wolves_buff", {duration=0.5,target=target:entindex()})
            unit:AddNewModifier(caster,self, "modifier_knockback", Knockback)
        end
    end
end


modifier_summon_wolves=class({})

function modifier_summon_wolves:IsHidden()
	return true
end

function modifier_summon_wolves:IsPurgable()
	return false
end

function modifier_summon_wolves:IsPurgeException()
	return false
end

function modifier_summon_wolves:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.wolf_bat=self.ability:GetSpecialValueFor("wolf_bat")
    self.wolf_damage=self.ability:GetSpecialValueFor("wolf_damage")+self.caster:TG_GetTalentValue("special_bonus_lycan_7")
    self.wolf_bat=self.ability:GetSpecialValueFor("wolf_bat")
    self.wolf_hp=self.ability:GetSpecialValueFor("wolf_hp")
    self.sp_dur=self.ability:GetSpecialValueFor("sp_dur")
    self.sp=self.ability:GetSpecialValueFor("sp")
    if IsServer() then
        self.parent:SetBaseDamageMin(self.wolf_damage)
        self.parent:SetBaseDamageMax(self.wolf_damage)
        self.parent:SetBaseAttackTime(self.wolf_bat)
    end
end

function modifier_summon_wolves:OnRefresh()
    self:OnCreated()
end


function modifier_summon_wolves:DeclareFunctions()
    return
    {

        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }
end

function modifier_summon_wolves:GetModifierExtraHealthBonus()
	return self.wolf_hp
end

modifier_summon_wolves_buff=class({})

function modifier_summon_wolves_buff:IsHidden()
	return true
end

function modifier_summon_wolves_buff:IsPurgable()
	return false
end

function modifier_summon_wolves_buff:IsPurgeException()
	return false
end

function modifier_summon_wolves_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_summon_wolves_buff:GetEffectName()
	return "particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_ambient_trail.vpcf"
end


function modifier_summon_wolves_buff:OnCreated(tg)
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.dam=self.ability:GetSpecialValueFor("dam")
    self.sp_dur=self.ability:GetSpecialValueFor("sp_dur")
    if IsServer() then
    self.target=EntIndexToHScript(tg.target)
end
end

function modifier_summon_wolves_buff:OnDestroy()
    if IsServer() then

        if  self.target and  IsValidEntity(self.target) and not self.target:IsMagicImmune() then
            self.target:AddNewModifier_RS(self.caster, self.ability, "modifier_summon_wolves_debuff", {duration = self.sp_dur})
            local damageTable = {
                victim = self.target,
                attacker = self.caster,
                damage = self.dam,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self.ability,
                }
            ApplyDamage(damageTable)
        end
    end
end



modifier_summon_wolves_debuff=class({})

function modifier_summon_wolves_debuff:IsHidden()
	return false
end

function modifier_summon_wolves_debuff:IsPurgable()
	return true
end

function modifier_summon_wolves_debuff:IsPurgeException()
	return true
end

function modifier_summon_wolves_debuff:IsDebuff()
	return true
end

function modifier_summon_wolves_debuff:OnCreated()
    self.ability=self:GetAbility()
    self.sp=self.ability:GetSpecialValueFor("sp")
end

function modifier_summon_wolves_debuff:OnRefresh()
    self:OnCreated()
end

function modifier_summon_wolves_debuff:DeclareFunctions()
    return
    {

        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_summon_wolves_debuff:GetModifierMoveSpeedBonus_Percentage()
	return 0-self.sp
end

modifier_summon_wolves_buff1=class({})

function modifier_summon_wolves_buff1:DeclareFunctions()
    return
    {

        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_summon_wolves_buff1:OnCreated()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
end


function modifier_summon_wolves_buff1:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
	if tg.attacker ~= self.parent or  tg.target:IsBuilding() then
		return
    end
    if tg.target:IsRealHero() then
        tg.target:AddNewModifier(self:GetCaster(), self.ability, "modifier_wolf_bite_debuff", {duration=10})
    end
end