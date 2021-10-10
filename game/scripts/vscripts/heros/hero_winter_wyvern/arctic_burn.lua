CreateTalents("npc_dota_hero_winter_wyvern", "heros/hero_winter_wyvern/arctic_burn.lua")
arctic_burn=class({})
LinkLuaModifier("modifier_arctic_burn_buff", "heros/hero_winter_wyvern/arctic_burn.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arctic_burn_buff1", "heros/hero_winter_wyvern/arctic_burn.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arctic_burn_cd", "heros/hero_winter_wyvern/arctic_burn.lua", LUA_MODIFIER_MOTION_NONE)
function arctic_burn:IsHiddenWhenStolen()return false
end
function arctic_burn:IsRefreshable()return true
end
function arctic_burn:IsStealable()return true
end
function arctic_burn:Init()
      self.caster=self:GetCaster()
end
function arctic_burn:GetCooldown(iLevel)
        return self.caster:HasScepter() and 0 or self.BaseClass.GetCooldown(self,iLevel)
end
function arctic_burn:GetBehavior()
      if self.caster:HasScepter() then
            return DOTA_ABILITY_BEHAVIOR_TOGGLE
      else
            return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_IMMEDIATE
      end
end
function arctic_burn:OnSpellStart()
      self:Henshin(self:GetSpecialValueFor("duration"))
end
function arctic_burn:OnToggle()
      if self:GetToggleState() then
             self:Henshin(-1)
      else
                  if  self.caster:HasModifier("modifier_arctic_burn_buff") then
                        self.caster:RemoveModifierByName("modifier_arctic_burn_buff")
                  end
      end
end
function arctic_burn:Henshin(dur)
      EmitSoundOn("Hero_Winter_Wyvern.ArcticBurn.Cast", self.caster)
      local pf1 = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
      ParticleManager:ReleaseParticleIndex(pf1)
      self.caster:AddNewModifier(self.caster, self, "modifier_arctic_burn_buff", {duration=dur})
      GridNav:DestroyTreesAroundPoint(self.caster:GetAbsOrigin(), 350, false)
end


modifier_arctic_burn_buff=class({})
function modifier_arctic_burn_buff:IsPurgable()return false
end
function modifier_arctic_burn_buff:IsPurgeException()return false
end
function modifier_arctic_burn_buff:GetStatusEffectName()return "particles/status_fx/status_effect_wyvern_arctic_burn.vpcf"
end
function modifier_arctic_burn_buff:StatusEffectPriority()return 4
end
function modifier_arctic_burn_buff:RemoveOnDeath()return true
end
function modifier_arctic_burn_buff:DeclareFunctions()
    return
    {
            MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
            MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
            MODIFIER_PROPERTY_PROJECTILE_NAME,
            MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
            MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
            MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end
function modifier_arctic_burn_buff:CheckState()
    return
     {
           [MODIFIER_STATE_FLYING] = true,
       }
end
function modifier_arctic_burn_buff:OnCreated()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.pos=self.parent:GetAbsOrigin()
    self.attrg=self.ability:GetSpecialValueFor("attrg")
    self.vision=self.ability:GetSpecialValueFor("vision")
    self.projectile=self.ability:GetSpecialValueFor("projectile")
    self.sp=self.ability:GetSpecialValueFor("sp")
    self.mana=self.ability:GetSpecialValueFor("mana")
    self.buffdur=self.ability:GetSpecialValueFor("buffdur")
    self.dmg=self.ability:GetSpecialValueFor("dmg")*0.01
     self.projectile2=self.ability:GetSpecialValueFor("projectile2")
     self.maxsp=self.ability:GetSpecialValueFor("maxsp")
    self.damageTable=
    {
        attacker = self.parent,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability =  self.ability,
      }

    local pf1 = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_buff.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
      ParticleManager:SetParticleControlEnt(pf1, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.pos, true)
      ParticleManager:SetParticleControlEnt(pf1, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.pos, true)
      self:AddParticle(pf1, false, false, 4, false, false)

    local pf2 = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_flying.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
      ParticleManager:SetParticleControlEnt(pf2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.pos, true)
      ParticleManager:SetParticleControlEnt(pf2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_spine_1", self.pos, true)
      ParticleManager:SetParticleControlEnt(pf2, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_spine_2", self.pos, true)
      ParticleManager:SetParticleControlEnt(pf2, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_spine_3", self.pos, true)
      ParticleManager:SetParticleControlEnt(pf2, 4, self.parent, PATTACH_POINT_FOLLOW, "attach_spine_4", self.pos, true)
      ParticleManager:SetParticleControlEnt(pf2, 5, self.parent, PATTACH_POINT_FOLLOW, "attach_spine_5", self.pos, true)
      self:AddParticle(pf2, false, false, 4, false, false)

      if IsServer() then
            self.parent:ForcePlayActivityOnce(ACT_DOTA_GENERIC_CHANNEL_1)
            if self.parent:HasScepter() then
                  self:StartIntervalThink(1)
            end
      end
end
function modifier_arctic_burn_buff:OnRefresh()
    self.attrg=self.ability:GetSpecialValueFor("attrg")
    self.vision=self.ability:GetSpecialValueFor("vision")
    self.projectile=self.ability:GetSpecialValueFor("projectile")
    self.sp=self.ability:GetSpecialValueFor("sp")
    self.mana=self.ability:GetSpecialValueFor("mana")
    self.buffdur=self.ability:GetSpecialValueFor("buffdur")
    self.dmg=self.ability:GetSpecialValueFor("dmg")*0.01
     self.projectile2=self.ability:GetSpecialValueFor("projectile2")
     self.maxsp=self.ability:GetSpecialValueFor("maxsp")
end
function modifier_arctic_burn_buff:OnIntervalThink()
      if not self.parent:TG_HasTalent("special_bonus_winter_wyvern_6") then
            self.parent:SpendMana(self.mana,self.ability)
      end
end
function modifier_arctic_burn_buff:OnDestroy()
      if IsServer() then
            self.parent:ForcePlayActivityOnce(ACT_DOTA_ARCTIC_BURN_END)
      end
end
function modifier_arctic_burn_buff:OnAttackLanded(tg)
            if not IsServer() then
                  return
            end
            if tg.attacker == self.parent  and not tg.target:IsBuilding() and not self.parent:IsIllusion() and not tg.target:IsMagicImmune()   then
                  if self.parent:TG_HasTalent("special_bonus_winter_wyvern_5") then
                        if not self.parent:HasModifier("modifier_arctic_burn_cd") then
                              local ab=self.parent:FindAbilityByName("splinter_blast")
                              if ab and ab:GetLevel()>0 then
                                    ab:OnSpellStart(tg.target)
                                    self.parent:AddNewModifier(self.parent, self.ability, "modifier_arctic_burn_cd", {duration=6})
                              end
                        end
                  end
                  if tg.target:GetMoveSpeedModifier(tg.target:GetBaseMoveSpeed(), true)>self.maxsp then
                        tg.target:AddNewModifier(self.parent, self.ability, "modifier_imba_stunned", {duration=1})
                  end
                  self.damageTable.victim = tg.target
                  self.damageTable.damage = self.dmg*tg.target:GetMaxHealth()
                  ApplyDamage(self.damageTable)
                  self.parent:AddNewModifier(self.parent, self.ability, "modifier_arctic_burn_buff1", {duration=self.buffdur,num=self.projectile2})
            end
end
function modifier_arctic_burn_buff:GetModifierAttackRangeBonus()
    return self.attrg
end
function modifier_arctic_burn_buff:GetModifierProjectileSpeedBonus()
    return self.projectile
end
function modifier_arctic_burn_buff:GetBonusNightVision()
    return self.vision
end
function modifier_arctic_burn_buff:GetModifierMoveSpeedBonus_Percentage()
      if self.parent:HasScepter() then
            return self.sp
      end
      return 0
end
function modifier_arctic_burn_buff:GetAttackSound()
    return "Hero_Winter_Wyvern.ArcticBurn.attack"
end
function modifier_arctic_burn_buff:GetModifierProjectileName()
      return  "particles/units/heroes/hero_winter_wyvern/winter_wyvern_arctic_attack.vpcf"
end

modifier_arctic_burn_buff1=class({})
function modifier_arctic_burn_buff1:IsPurgable()return false
end
function modifier_arctic_burn_buff1:IsPurgeException()return false
end
function modifier_arctic_burn_buff1:RemoveOnDeath()return true
end
function modifier_arctic_burn_buff1:DeclareFunctions()
    return
    {
            MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,

    }
end
function modifier_arctic_burn_buff1:OnCreated(tg)
      if IsServer() then
            local sp=self:GetStackCount()+tg.num
            self:SetStackCount(sp>=3000 and 3000 or sp)
      end
end
function modifier_arctic_burn_buff1:OnRefresh(tg)
    self:OnCreated(tg)
end
function modifier_arctic_burn_buff1:GetModifierProjectileSpeedBonus()
      return self:GetStackCount()
end

modifier_arctic_burn_cd=class({})
function modifier_arctic_burn_cd:IsHidden()return true
end
function modifier_arctic_burn_cd:IsPurgable()return false
end
function modifier_arctic_burn_cd:IsPurgeException()return false
end
function modifier_arctic_burn_cd:RemoveOnDeath()return false
end