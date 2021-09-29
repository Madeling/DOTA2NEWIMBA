chemical_rage=class({})
LinkLuaModifier("modifier_chemical_rage_buff", "heros/hero_alchemist/chemical_rage.lua", LUA_MODIFIER_MOTION_NONE)

function chemical_rage:IsHiddenWhenStolen()
    return false
end
function chemical_rage:IsStealable()
    return true
end
function chemical_rage:IsRefreshable()
    return true
end
function chemical_rage:Init()
    self.caster=self:GetCaster()
end
function chemical_rage:OnSpellStart()
      local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf", PATTACH_ABSORIGIN, self.caster)
      ParticleManager:ReleaseParticleIndex(fx)
      local fx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", PATTACH_ABSORIGIN, self.caster)
      ParticleManager:SetParticleControl(fx1, 1,  self.caster:GetAbsOrigin())
      ParticleManager:ReleaseParticleIndex(fx1)
      self.caster:AddNewModifier(self.caster, self, "modifier_chemical_rage_buff", {duration=self:GetSpecialValueFor("duration")+self.caster:GetModifierStackCount("modifier_goblins_greed_pa", self.caster)*self:GetSpecialValueFor("dur")})
      EmitSoundOn("Hero_Alchemist.ChemicalRage.Cast", self.caster)
      if self.caster:HasScepter() then
                local units=FindUnitsInRadius(self.caster:GetTeamNumber(),self.caster:GetAbsOrigin(),nil,500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                if #units>0 then
                        for _,target in pairs(units) do
                                if target~=self.caster then
                                    local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf", PATTACH_ABSORIGIN, target)
                                    ParticleManager:ReleaseParticleIndex(fx)
                                    target:AddNewModifier(self.caster, self, "modifier_chemical_rage_buff", {duration=5})
                                end
                        end
                end
        end
end

modifier_chemical_rage_buff=class({})
function modifier_chemical_rage_buff:IsDebuff()
      return false
end
function modifier_chemical_rage_buff:IsPurgable()
      return false
end
function modifier_chemical_rage_buff:IsPurgeException()
      return false
end
function modifier_chemical_rage_buff:AllowIllusionDuplicate()
      return false
end
function modifier_chemical_rage_buff:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.team=self.parent:GetTeamNumber()
    if not self.ability then
            return
    end
      self.base_attack_time=self.ability:GetSpecialValueFor("base_attack_time")
      self.bonus_health_regen=self.ability:GetSpecialValueFor("bonus_health_regen")
      self.bonus_movespeed=self.ability:GetSpecialValueFor("bonus_movespeed")
      self.cost=self.ability:GetSpecialValueFor("cost")
      self.rs=self.ability:GetSpecialValueFor("rs")
      self.att=self.ability:GetSpecialValueFor("att")
      self.gold=self.caster:GetModifierStackCount("modifier_goblins_greed_pa", self.caster)
end
function modifier_chemical_rage_buff:OnRefresh()
      self:OnCreated()
end
function modifier_chemical_rage_buff:DeclareFunctions()
	return
		{
			MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
                  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
                  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
                  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
                  MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
                  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
                  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
                  MODIFIER_EVENT_ON_ATTACK_LANDED
		}
end
function modifier_chemical_rage_buff:OnAttackLanded(tg)
            if not IsServer() then
                  return
            end
            if tg.attacker == self.parent  and tg.target:IsRealHero() and not self.parent:IsIllusion()   then
                                                PlayerResource:ModifyGold(tg.target:GetPlayerOwnerID(), self.cost*-1, false, DOTA_ModifyGold_Unspecified)
                                                local fx = ParticleManager:CreateParticle("particles/tgp/alchemist/msg_gold.vpcf", PATTACH_ABSORIGIN, tg.target)
                                                ParticleManager:SetParticleControl(fx, 1, Vector(1, self.cost, 0))
                                                ParticleManager:SetParticleControl(fx, 2, Vector(1,3, 0))
                                                ParticleManager:SetParticleControl(fx, 3, Vector(255, 208, 0))
                                                ParticleManager:ReleaseParticleIndex(fx)
            end
end
function modifier_chemical_rage_buff:GetModifierBaseAttackTimeConstant()
	return self.base_attack_time-self.parent:TG_GetTalentValue("special_bonus_alchemist_7")
end
function modifier_chemical_rage_buff:GetModifierMoveSpeedBonus_Constant()
    return self.bonus_movespeed
end
function modifier_chemical_rage_buff:GetModifierConstantHealthRegen()
    return self.bonus_health_regen
end
function modifier_chemical_rage_buff:GetModifierPreAttack_BonusDamage()
    return self.gold*self.att
end
function modifier_chemical_rage_buff:GetModifierPhysicalArmorBonus( )
    if self.parent:TG_HasTalent("special_bonus_alchemist_4") then
        return 8
    else
        return 0
    end
end
function modifier_chemical_rage_buff:GetModifierStatusResistanceStacking( )
    if self.parent:TG_HasTalent("special_bonus_alchemist_5") then
        return 20+self.gold*self.rs
    else
        return self.gold*self.rs
    end
end
function modifier_chemical_rage_buff:GetActivityTranslationModifiers()
    return "chemical_rage"
end
function modifier_chemical_rage_buff:GetAttackSound()
    return "Hero_Alchemist.ChemicalRage.Attack"
end
function modifier_chemical_rage_buff:CheckState()
    return {[MODIFIER_STATE_CANNOT_MISS] = true}
end