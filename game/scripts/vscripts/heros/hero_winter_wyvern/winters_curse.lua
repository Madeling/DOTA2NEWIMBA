winters_curse=class({})
LinkLuaModifier("modifier_winters_curse_debuff", "heros/hero_winter_wyvern/winters_curse.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_winters_curse_debuff1", "heros/hero_winter_wyvern/winters_curse.lua", LUA_MODIFIER_MOTION_NONE)
function winters_curse:IsHiddenWhenStolen()return false
end
function winters_curse:IsRefreshable()return true
end
function winters_curse:IsStealable()return true
end
function winters_curse:Init()
      self.caster=self:GetCaster()
end
function winters_curse:OnSpellStart()
       local tar=self:GetCursorTarget()
       local dur=self:GetSpecialValueFor("duration")
       EmitSoundOn("Hero_Winter_Wyvern.WintersCurse.Cast", self.caster)
       EmitSoundOn("Hero_Winter_Wyvern.WintersCurse.Target", tar)
      local pf1 = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
      ParticleManager:SetParticleControl(pf1, 0, self.caster:GetAbsOrigin())
      ParticleManager:SetParticleControl(pf1, 1, self.caster:GetAbsOrigin())
      ParticleManager:ReleaseParticleIndex(pf1)

       tar:AddNewModifier(self.caster, self, "modifier_winters_curse_debuff", {duration=dur})
end

modifier_winters_curse_debuff=class({})
function modifier_winters_curse_debuff:IsHidden()return true
end
function modifier_winters_curse_debuff:IsPurgable()return false
end
function modifier_winters_curse_debuff:IsPurgeException()return false
end
function modifier_winters_curse_debuff:IsAura()
      return true
end
function modifier_winters_curse_debuff:GetAuraDuration()return 0
end
function modifier_winters_curse_debuff:GetModifierAura()
      return "modifier_winters_curse_debuff1"
end
function modifier_winters_curse_debuff:GetAuraRadius()
    return 525
end
function modifier_winters_curse_debuff:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifier_winters_curse_debuff:GetAuraSearchTeam()
       if self.parent:GetTeamNumber()==self.ability.caster:GetTeamNumber() then
            return DOTA_UNIT_TARGET_TEAM_ENEMY
            else
            return DOTA_UNIT_TARGET_TEAM_FRIENDLY
      end
end
function modifier_winters_curse_debuff:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
end
function modifier_winters_curse_debuff:CheckState()
        return
        {
            [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
            [MODIFIER_STATE_FROZEN]=true,
            [MODIFIER_STATE_STUNNED]=true,
            [MODIFIER_STATE_MUTED]=true,
        }
end
function modifier_winters_curse_debuff:OnCreated()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.damage_reduction=self.ability:GetSpecialValueFor( "damage_reduction" )
    if IsServer() then
      local pf1 = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
      ParticleManager:SetParticleControl(pf1, 0, self.parent:GetAbsOrigin())
      ParticleManager:SetParticleControl(pf1, 2, Vector(1000,1000,1000))
      self:AddParticle(pf1, false, false, 4, false, false)
      local pf2 = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
      ParticleManager:SetParticleControl(pf2, 0, self.parent:GetAbsOrigin())
      ParticleManager:SetParticleControl(pf2, 2, Vector(525,525,525))
      self:AddParticle(pf2, false, false, 4, false, false)
      local pf3 = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
      self:AddParticle(pf3, false, false, 4, false, false)
      local pf4 = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_beams.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
      ParticleManager:SetParticleControl(pf4, 1, self.parent:GetAbsOrigin())
      ParticleManager:ReleaseParticleIndex(pf4)
      end
end
function modifier_winters_curse_debuff:OnRefresh()
      self:OnCreated()
end
function modifier_winters_curse_debuff:DeclareFunctions()
    return
    {

        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end
function modifier_winters_curse_debuff:GetModifierIncomingDamage_Percentage()
   if self.parent:GetTeamNumber()==self:GetCaster():GetTeamNumber() then
            return -100
    end
            return  0
end

modifier_winters_curse_debuff1=class({})
function modifier_winters_curse_debuff1:IsHidden()return true
end
function modifier_winters_curse_debuff1:IsPurgable()return false
end
function modifier_winters_curse_debuff1:IsPurgeException()return false
end
function modifier_winters_curse_debuff1:GetEffectAttachType()return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_winters_curse_debuff1:GetEffectName()return "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_status.vpcf"
end

function modifier_winters_curse_debuff1:OnCreated()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetAuraOwner()
    self.damage_reduction=self.ability:GetSpecialValueFor( "damage_reduction" )
    self.bonus_attack_speed=self.ability:GetSpecialValueFor( "bonus_attack_speed" )
    if IsServer() then
      	ExecuteOrderFromTable({
		UnitIndex = self.parent:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
            TargetIndex = self.caster:entindex(),
		Queue = false,
	})
      end
end
function modifier_winters_curse_debuff1:OnRefresh()
      self.caster=self:GetAuraOwner()
    if IsServer() then
      	ExecuteOrderFromTable({
		UnitIndex = self.parent:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
            TargetIndex = self.caster:entindex(),
		Queue = false,
	})
      end
end
function modifier_winters_curse_debuff1:DeclareFunctions()
    return
    {

        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_DISABLE_HEALING
    }
end
function modifier_winters_curse_debuff1:GetModifierIncomingDamage_Percentage()
      if  self.ability.caster:TG_HasTalent("special_bonus_winter_wyvern_7") then
            return 0
      end
      return  0-self.damage_reduction
end
function modifier_winters_curse_debuff1:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed
end
function modifier_winters_curse_debuff1:CheckState()
        return
        {
            [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
            [MODIFIER_STATE_ATTACK_ALLIES] = true,
            [MODIFIER_STATE_SILENCED]=true,
            [MODIFIER_STATE_MUTED]=true,
            [MODIFIER_STATE_TAUNTED]=true,
            [MODIFIER_STATE_COMMAND_RESTRICTED]=true,
            [MODIFIER_STATE_DISARMED]=false,
        }
end
function modifier_winters_curse_debuff1:GetDisableHealing()
   if  self.ability.caster:TG_HasTalent("special_bonus_winter_wyvern_8") then
            return 1
    end
	      return 0
end

function modifier_winters_curse_debuff1:GetModifierHealAmplify_PercentageTarget()
   if  self.ability.caster:TG_HasTalent("special_bonus_winter_wyvern_8") then
           return  -100
    end
            return 0
end

function modifier_winters_curse_debuff1:GetModifierHPRegenAmplify_Percentage()
   if  self.ability.caster:TG_HasTalent("special_bonus_winter_wyvern_8") then
            return -100
    end
            return 0
end