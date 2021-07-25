x_marks_the_spot=class({})
LinkLuaModifier("modifier_x_marks_the_spot_buff", "heros/hero_kunkka/x_marks_the_spot.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_x_marks_the_spot_debuff", "heros/hero_kunkka/x_marks_the_spot.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_x_marks_the_spot_v_tar", "heros/hero_kunkka/x_marks_the_spot.lua", LUA_MODIFIER_MOTION_NONE)

function x_marks_the_spot:IsHiddenWhenStolen()
    return false
end

function x_marks_the_spot:IsStealable()
    return true
end

function x_marks_the_spot:IsRefreshable()
    return true
end

function x_marks_the_spot:OnSpellStart()
   local caster=self:GetCaster()
   local cur_tar=self:GetCursorTarget()
   if  cur_tar:TG_TriggerSpellAbsorb(self)  then
        return
   end
   caster.x_marks_the_spot={}
   local ab=caster:FindAbilityByName("x_return")
   if ab~=nil then
        ab:SetLevel(1)
   end
   caster:SwapAbilities("x_marks_the_spot", "x_return", false, true)
   table.insert (caster.x_marks_the_spot,cur_tar)
   if Is_Chinese_TG(caster,cur_tar) and cur_tar:IsHero() then
        cur_tar:AddNewModifier(caster, self, "modifier_x_marks_the_spot_buff", {duration=self:GetSpecialValueFor("dur")})
    else
        cur_tar:AddNewModifier_RS(caster, self, "modifier_x_marks_the_spot_debuff", {duration=self:GetSpecialValueFor("dur2")})
    end
end


modifier_x_marks_the_spot_buff=class({})


function modifier_x_marks_the_spot_buff:IsHidden()
	return false
end

function modifier_x_marks_the_spot_buff:IsPurgable()
    return false
end

function modifier_x_marks_the_spot_buff:IsPurgeException()
    return false
end

function modifier_x_marks_the_spot_buff:OnCreated()
    if not IsServer() then
        return
    end
   self.pos = self:GetParent():GetAbsOrigin()
   EmitSoundOn("Ability.XMarksTheSpot.Target", self:GetParent())
   EmitSoundOn("Ability.XMark.Target_Movement", self:GetParent())
    local  particle = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_x_spot_fxset.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
    ParticleManager:SetParticleControlEnt(particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
   self:AddParticle(particle, false, false, 20, false, false)
end


function modifier_x_marks_the_spot_buff:OnDestroy()
    if not IsServer() then
        return
    end
    FindClearSpaceForUnit(self:GetParent(), self.pos, false)
    StopSoundOn("Ability.XMark.Target_Movement",self:GetParent())
    EmitSoundOn("Ability.XMarksTheSpot.Return", self:GetParent())
    self:GetCaster():SwapAbilities("x_marks_the_spot", "x_return", true, false)
end


modifier_x_marks_the_spot_debuff=class({})


function modifier_x_marks_the_spot_debuff:IsHidden()
	return false
end

function modifier_x_marks_the_spot_debuff:IsPurgable()
    return false
end

function modifier_x_marks_the_spot_debuff:IsPurgeException()
    return false
end

function modifier_x_marks_the_spot_debuff:OnCreated()
    if not IsServer() then
        return
    end
    self.pos = self:GetParent():GetAbsOrigin()
    EmitSoundOn("Ability.XMarksTheSpot.Target", self:GetParent())
    EmitSoundOn("Ability.XMark.Target_Movement", self:GetParent())
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_x_marks_the_spot_v_tar", {duration=self:GetAbility():GetSpecialValueFor("dur2")})
    local  particle = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_x_spot_red_fxset.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
    ParticleManager:SetParticleControlEnt(particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
    self:AddParticle(particle, false, false, 20, false, false)
end


function modifier_x_marks_the_spot_debuff:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetCaster():SwapAbilities("x_marks_the_spot", "x_return", true, false)
    local tar=nil
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        self:GetAbility():GetSpecialValueFor("rd_enemy"),
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false)
        if heros and  #heros>0 then
            tar=TG_Random_Table(heros)
            if #heros==1 and tar==self:GetParent() then
                tar=nil
            end
        end
        if tar then
            FindClearSpaceForUnit(tar, self.pos, false)
        else
            PlayerResource:ModifyGold(self:GetParent():GetPlayerOwnerID(), 0 - (self:GetAbility():GetSpecialValueFor("gold")*self:GetParent():GetLevel()), false, DOTA_ModifyGold_Death)
        end

        if not self:GetParent():IsMagicImmune() then
            self:GetParent():AddNewModifier( self:GetParent(),  self:GetAbility(), "modifier_stunned", {duration=0.1})
            FindClearSpaceForUnit(self:GetParent(), self.pos, false)
        end
            StopSoundOn("Ability.XMark.Target_Movement",self:GetParent())
            EmitSoundOn("Ability.XMarksTheSpot.Return", self:GetParent())
end


x_return=class({})

function x_return:IsHiddenWhenStolen()
    return false
end

function x_return:IsStealable()
    return false
end

function x_return:IsRefreshable()
    return true
end

function x_return:OnSpellStart()
    local caster=self:GetCaster()
    if caster.x_marks_the_spot and #caster.x_marks_the_spot>0 then
        for _, tar in pairs(caster.x_marks_the_spot) do
            if tar~=nil then
                if Is_Chinese_TG(caster,tar) then
                    TG_Remove_Modifier(tar,"modifier_x_marks_the_spot_buff",0)
                else
                    TG_Remove_Modifier(tar,"modifier_x_marks_the_spot_debuff",0)
                end
            end
        end
        caster.x_marks_the_spot=nil
        local ab= caster:FindAbilityByName("x_marks_the_spot")
        if ab then
            ab:SetActivated(true)
        end
    end
 end


modifier_x_marks_the_spot_v_tar=class({})

function modifier_x_marks_the_spot_v_tar:IsDebuff()
	return true
end

function modifier_x_marks_the_spot_v_tar:IsHidden()
	return true
end

function modifier_x_marks_the_spot_v_tar:IsPurgable()
    return false
end

function modifier_x_marks_the_spot_v_tar:IsPurgeException()
    return false
end



function modifier_x_marks_the_spot_v_tar:CheckState()
    return
    {
        [MODIFIER_STATE_PROVIDES_VISION] = true,
    }
end