goblins_greed=class({})
LinkLuaModifier("modifier_goblins_greed_pa", "heros/hero_alchemist/goblins_greed.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_goblins_greed_buff", "heros/hero_alchemist/goblins_greed.lua", LUA_MODIFIER_MOTION_NONE)

function goblins_greed:Init()
    self.caster=self:GetCaster()
end
function goblins_greed:IsHiddenWhenStolen()
    return false
end
function goblins_greed:IsStealable()
    return true
end
function goblins_greed:IsRefreshable()
    return false
end
function goblins_greed:Init()
    self.caster=self:GetCaster()
end
function goblins_greed:OnSpellStart()
      EmitSoundOn("DOTA_Item.Hand_Of_Midas", self.caster)
      local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", PATTACH_ABSORIGIN, self.caster)
      ParticleManager:SetParticleControl(fx, 1,  self.caster:GetAbsOrigin())
      ParticleManager:ReleaseParticleIndex(fx)
      self.caster:AddNewModifier(self.caster, self, "modifier_goblins_greed_buff", {duration=self:GetSpecialValueFor("dur")})
end
function goblins_greed:GetIntrinsicModifierName()
    return "modifier_goblins_greed_pa"
end

modifier_goblins_greed_buff=class({})
function modifier_goblins_greed_buff:IsDebuff()
      return false
end
function modifier_goblins_greed_buff:IsPurgable()
      return false
end
function modifier_goblins_greed_buff:IsPurgeException()
      return false
end
function modifier_goblins_greed_buff:AllowIllusionDuplicate()
      return false
end
function modifier_goblins_greed_buff:RemoveOnDeath()
      return true
end
function modifier_goblins_greed_buff:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.team=self.parent:GetTeamNumber()
    if not self.ability then
            return
    end
      if IsServer() then
            local gold=math.floor(self.caster:GetGold()*self.ability:GetSpecialValueFor("gold")*0.01)
            self:SetStackCount(gold)
            PlayerResource:ModifyGold(self.caster:GetPlayerOwnerID(), gold*-1, false, DOTA_ModifyGold_Unspecified)
      end
end
function modifier_goblins_greed_buff:OnRefresh()
    self:OnCreated()
end
function modifier_goblins_greed_buff:DeclareFunctions()
    return
    {
            MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end
function modifier_goblins_greed_buff:GetModifierPreAttack_BonusDamage()
    return  self:GetStackCount()
end



modifier_goblins_greed_pa=class({})
function modifier_goblins_greed_pa:IsDebuff()
      return false
end
function modifier_goblins_greed_pa:IsPurgable()
      return false
end
function modifier_goblins_greed_pa:IsPurgeException()
      return false
end
function modifier_goblins_greed_pa:AllowIllusionDuplicate()
      return false
end
function modifier_goblins_greed_pa:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.team=self.parent:GetTeamNumber()
    if not self.ability then
            return
    end
        self.egold=self.ability:GetSpecialValueFor("egold")
        self.max=self.ability:GetSpecialValueFor("max")
      if IsServer() then
            self:SetStackCount(0)
      end
end
function modifier_goblins_greed_pa:OnRefresh()
        self.egold=self.ability:GetSpecialValueFor("egold")
        self.max=self.ability:GetSpecialValueFor("max")
end
function modifier_goblins_greed_pa:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_DEATH
	}
end
function modifier_goblins_greed_pa:OnDeath(tg)
        if IsServer() then
                if   tg.attacker==self.parent and not self.parent:IsIllusion()  then
                        local stack=self:GetStackCount()
                        local gold=self.egold+stack*2
                        local num=tonumber(#tostring(gold))+1
                        PlayerResource:ModifyGold(self.caster:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified)
                        local fx = ParticleManager:CreateParticle("particles/tgp/alchemist/msg_gold.vpcf", PATTACH_ABSORIGIN, tg.unit)
                        ParticleManager:SetParticleControl(fx, 1, Vector(5, gold, 0))
                        ParticleManager:SetParticleControl(fx, 2, Vector(1,num, 0))
                        ParticleManager:SetParticleControl(fx, 3, Vector(255, 208, 0))
                        ParticleManager:ReleaseParticleIndex(fx)
                        if  stack<self.max then
                              local max=stack+4
                              max=max>self.max and self.max or max
                              self:SetStackCount(max)
                        end
                end
                if   tg.unit==self.parent and not self.parent:IsIllusion()  then
                        self:SetStackCount(math.floor(self:GetStackCount()/2))
                end
        end
end
