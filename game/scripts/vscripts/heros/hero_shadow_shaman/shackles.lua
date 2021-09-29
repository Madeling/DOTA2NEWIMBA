shackles=class({})
LinkLuaModifier("modifier_shackles_ctrl", "heros/hero_shadow_shaman/shackles.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shackles_stun", "heros/hero_shadow_shaman/shackles.lua", LUA_MODIFIER_MOTION_NONE)
function shackles:IsHiddenWhenStolen()
    return false
end

function shackles:IsStealable()
    return false
end

function shackles:IsRefreshable()
    return true
end

function shackles:CastFilterResultTarget(target)
    local caster=self:GetCaster()
	if not target:IsHero() or target==caster or target:IsMagicImmune() or (target:HasAbility("traitor") and not self:GetAutoCastState()) then
		return UF_FAIL_CUSTOM
	end
end

function shackles:GetCustomCastErrorTarget(target)
        return "无法对其使用"
end

function shackles:GetChannelTime()
    return self:GetSpecialValueFor("hchannel_t")+self:GetCaster():TG_GetTalentValue("special_bonus_shadow_shaman_4")
end

function shackles:OnSpellStart()
    local caster= self:GetCaster()
    local curtar= self:GetCursorTarget()
    local hchannel_t=self:GetSpecialValueFor("hchannel_t")
    self.TAR=curtar
    if curtar:TG_TriggerSpellAbsorb(self)  then
        self:EndChannel(true)
        caster:Stop()
		return
    end
    EmitSoundOn("Hero_ShadowShaman.Shackles.Cast", caster)
    EmitSoundOn("Hero_ShadowShaman.Shackles", caster)
    if self:GetAutoCastState() then
        if not Is_Chinese_TG(caster,curtar) then
            if caster:TG_HasTalent("special_bonus_shadow_shaman_5") then
                caster:AddNewModifier( caster, self, "modifier_invisible", {duration=hchannel_t+caster:TG_GetTalentValue("special_bonus_shadow_shaman_4")})
            end
            curtar:AddNewModifier(caster, self, "modifier_shackles_stun", {duration=hchannel_t+caster:TG_GetTalentValue("special_bonus_shadow_shaman_4")})
        else
            Notifications:Bottom(PlayerResource:GetPlayer(caster:GetPlayerOwnerID()), {text="无法操控自己人", duration=1.25, style={color="#EEEE00", ["font-size"]="30px"}})
            caster:Stop()
            self:EndCooldown()
            caster:GiveMana(200)
            return
        end
    else
        if curtar:HasModifier("modifier_shackles_ctrl") then
            curtar:RemoveModifierByName("modifier_shackles_ctrl")
        end
        if not Is_Chinese_TG(caster,curtar) then
            if caster:TG_HasTalent("special_bonus_shadow_shaman_5") then
                caster:AddNewModifier( caster, self, "modifier_invisible", {duration=hchannel_t+caster:TG_GetTalentValue("special_bonus_shadow_shaman_4")})
            end
            if curtar.fire_remnantTB and #curtar.fire_remnantTB>0 then
                for a=0,#curtar.fire_remnantTB do
                    if curtar.fire_remnantTB[a] and IsValidEntity(curtar.fire_remnantTB[a]) then
                        local mod=curtar.fire_remnantTB[a]:FindModifierByName("modifier_kill")
                        if mod then
                             mod:SetDuration(0, true)
                        end
                    end
                end
                curtar.fire_remnantTB={}
                local modifier = curtar:FindModifierByName("modifier_fire_remnant_num")
                if modifier  then
                    modifier:SetStackCount(0)
                end
            end
            curtar:AddNewModifier(caster, self, "modifier_shackles_ctrl", {duration =hchannel_t+caster:TG_GetTalentValue("special_bonus_shadow_shaman_4")})
        else
            Notifications:Bottom(PlayerResource:GetPlayer(caster:GetPlayerOwnerID()), {text="无法操控自己人", duration=1.25, style={color="#EEEE00", ["font-size"]="30px"}})
            caster:Stop()
            self:EndCooldown()
            caster:GiveMana(200)
            return
        end
    end
end


function shackles:OnChannelFinish(bInterrupted)
    local caster = self:GetCaster()
    StopSoundOn("Hero_ShadowShaman.Shackles", caster)
   if  bInterrupted then
          if self.TAR~=nil then
            local modifier= self.TAR:FindModifierByName("modifier_shackles_ctrl")
            if modifier~=nil then modifier:Destroy()end
            local modifier1= self.TAR:FindModifierByName("modifier_shackles_stun")
            if modifier1~=nil then modifier1:Destroy()end
        end
     end
end


modifier_shackles_ctrl= class({})

function modifier_shackles_ctrl:IsDebuff()
    return true
end

function modifier_shackles_ctrl:IsPurgable()
    return false
end

function modifier_shackles_ctrl:IsPurgeException()
    return false
end

function modifier_shackles_ctrl:IsHidden()
    return false
end

function modifier_shackles_ctrl:RemoveOnDeath()
	return true
end

function modifier_shackles_ctrl:OnCreated()
    self.caster=self:GetCaster()
    self.PL=self:GetParent()
    if not IsServer() then
        return
    end
    self.DIS=self:GetAbility():GetSpecialValueFor("d")
    local caster_pos=self.caster:GetAbsOrigin()
    local caster_ow=self.caster:GetPlayerOwner()
    if self.PL:IsMoving() then
        self.PL:Stop()
    end
 --[[  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_shackle.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self.PL)
    ParticleManager:SetParticleControlEnt(particle, 1, self.PL, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self.PL:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 1, self.PL, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self.PL:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 4, self.PL, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self.PL:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 5, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster_pos, true)
    ParticleManager:SetParticleControlEnt(particle, 6, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster_pos, true)]]
    local particle = ParticleManager:CreateParticle("particles/econ/items/shadow_shaman/ss_fall20_tongue/shadowshaman_shackle_net_fall20.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW,  self.PL)
    ParticleManager:SetParticleControlEnt(particle, 0, self.caster, PATTACH_POINT_FOLLOW  , "attach_hitloc", self.caster:GetAbsOrigin(), false)
    ParticleManager:SetParticleControlEnt(particle, 1,self.PL, PATTACH_CENTER_FOLLOW , "attach_hitloc",self.PL:GetAbsOrigin(), false)
    self:AddParticle(particle, false, false, 15, false, false)
        local particle2 = ParticleManager:CreateParticleForPlayer("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW,self.caster,self.caster:GetPlayerOwner())
        ParticleManager:SetParticleControl(particle2, 1, Vector(self.DIS, 0, 0))
        ParticleManager:SetParticleControl(particle2, 2, Vector(10, 0, 0))
        ParticleManager:SetParticleControl(particle2, 3, Vector(100, 0, 0))
        ParticleManager:SetParticleControl(particle2, 15, Vector(220, 20, 60))
        self:AddParticle(particle2, false, false, 15, false, false)
    self.ID = self.PL:GetPlayerOwnerID()
    self.TEAMID = self.PL:GetTeamNumber()
    self.PL:SetCanSellItems(false)
    self.PL:SetHasInventory(false)
    self.PL:SetTeam(self.caster:GetTeamNumber())
    self.PL:SetControllableByPlayer(self.caster:GetPlayerOwnerID(), false)
    if not self.PL:IsIllusion() then
        Notifications:Bottom(PlayerResource:GetPlayer(self.ID), {text="你的英雄已被敌方阵营操控", duration=3, style={color="#E8E8E8", ["font-size"]="40px"}})
    end
        self:StartIntervalThink(0.01)
end

function modifier_shackles_ctrl:OnIntervalThink()
    if TG_Distance(self:GetCaster():GetAbsOrigin(),self.PL:GetAbsOrigin())>self.DIS then
        self:StartIntervalThink(-1)
        self:Destroy()
    end
end

function modifier_shackles_ctrl:OnDestroy()
    if IsServer() then
     self.PL:SetCanSellItems(true)
     self.PL:SetHasInventory(true)
     self.PL:SetTeam(self.TEAMID)
     self.PL:SetControllableByPlayer( self.ID, true)
     if not self.PL:IsIllusion() then
        Notifications:Bottom(PlayerResource:GetPlayer(self.ID), {text="操控结束", duration=2, style={color="#E8E8E8", ["font-size"]="40px"}})
    end
    if self:GetAbility() then
    self:GetAbility():EndChannel(true)
    end
    if self.PL.fire_remnantTB and #self.PL.fire_remnantTB>0 then
        for a=0,#self.PL.fire_remnantTB do
            if self.PL.fire_remnantTB[a] and IsValidEntity(self.PL.fire_remnantTB[a]) then
                local mod=self.PL.fire_remnantTB[a]:FindModifierByName("modifier_kill")
                if mod then
                     mod:SetDuration(0, true)
                end
            end
        end
        self.PL.fire_remnantTB={}
        local modifier = self.PL:FindModifierByName("modifier_fire_remnant_num")
        if modifier  then
            modifier:SetStackCount(0)
        end
    end
    end
end

function modifier_shackles_ctrl:CheckState()
    return
    {
        [MODIFIER_STATE_TETHERED] = true,
    }
end

modifier_shackles_stun= class({})

function modifier_shackles_stun:IsDebuff()
    return true
end

function modifier_shackles_stun:IsPurgable()
    return false
end

function modifier_shackles_stun:IsPurgeException()
    return false
end

function modifier_shackles_stun:IsHidden()
    return true
end

function modifier_shackles_stun:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_shackles_stun:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end


function modifier_shackles_stun:OnCreated()
    self.PL=self:GetParent()
    self.caster=self:GetCaster()
    if not IsServer() then
        return
    end
    local particle = ParticleManager:CreateParticle("particles/econ/items/shadow_shaman/ss_fall20_tongue/shadowshaman_shackle_net_fall20.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW,  self.PL)
    ParticleManager:SetParticleControlEnt(particle, 0, self.caster, PATTACH_POINT_FOLLOW  , "attach_hitloc", self.caster:GetAbsOrigin(), false)
    ParticleManager:SetParticleControlEnt(particle, 1,self.PL, PATTACH_CENTER_FOLLOW , "attach_hitloc",self.PL:GetAbsOrigin(), false)
    self:AddParticle(particle, false, false, 15, false, false)
end

function modifier_shackles_stun:CheckState()
    return
    {
        [MODIFIER_STATE_STUNNED] = true,
    }
end
