empower=class({})
LinkLuaModifier("modifier_empower_buff", "heros/hero_magnataur/empower.lua", LUA_MODIFIER_MOTION_NONE)
function empower:IsHiddenWhenStolen()return false
end
function empower:IsStealable()return true
end
function empower:IsRefreshable()return true
end
function empower:Init()
      self.caster=self:GetCaster()
end
function empower:OnAbilityPhaseStart()
      EmitSoundOn("Hero_Magnataur.Empower.Cast", self.caster)
      return true
end
function empower:OnSpellStart()
      local target=self:GetCursorTarget()
      local empower_duration=self:GetSpecialValueFor( "empower_duration" )
      EmitSoundOn("Hero_Magnataur.Empower.Target", self.caster)
      target:AddNewModifier(self.caster, self, "modifier_empower_buff", {duration=empower_duration})
      self.caster:AddNewModifier(self.caster, self, "modifier_empower_buff", {duration=empower_duration})
end

modifier_empower_buff=class({})
function modifier_empower_buff:IsPurgable()
    return true
end
function modifier_empower_buff:IsPurgeException()
    return true
end
function modifier_empower_buff:IsHidden()
    return false
end
function modifier_empower_buff:AllowIllusionDuplicate()return false
end
function modifier_empower_buff:GetEffectAttachType()return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_empower_buff:GetEffectName()return "particles/units/heroes/hero_magnataur/magnataur_empower.vpcf"
end
function modifier_empower_buff:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.team=self.parent:GetTeamNumber()
    if not self.ability then
            return
    end
    self.damageTable=
    {
        attacker = self.parent,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        ability =  self.ability,
	}
        self.bonus_damage_pct= self.ability:GetSpecialValueFor("bonus_damage_pct")
        self.cleave_damage_pct=self.ability:GetSpecialValueFor("cleave_damage_pct")*0.01
        self.cleave_rd=self.ability:GetSpecialValueFor("cleave_rd")
end
function modifier_empower_buff:OnRefresh()
    self:OnCreated()
end
function modifier_empower_buff:DeclareFunctions()
	return
		{
			MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
                  MODIFIER_EVENT_ON_ATTACK_LANDED,
                  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
                  MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING
		}
end
function modifier_empower_buff:OnAttackLanded(tg)
        if not IsServer() then
                return
        end
    if tg.attacker==self.parent and not self.parent:IsIllusion()  then
            local pos=tg.target:GetAbsOrigin()
            local fx = ParticleManager:CreateParticle("particles/tgp/magnataur/cleave_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(fx, 0, pos)
            ParticleManager:SetParticleControl(fx, 1, Vector(self.cleave_rd,0,0))
            ParticleManager:SetParticleControl(fx, 2, Vector(0.5,0,0))
		ParticleManager:ReleaseParticleIndex(fx)
            local units = FindUnitsInRadius(self.team,
                  pos,
                  nil,
                  self.cleave_rd,
                  DOTA_UNIT_TARGET_TEAM_ENEMY,
                  DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                  FIND_ANY_ORDER, false)
                  if #units>0 then
                        for _, unit in pairs(units) do
                              if unit~=tg.target  then
                                    if self.caster:TG_HasTalent("special_bonus_magnataur_2") then
                                        self.damageTable.damage_type=DAMAGE_TYPE_PURE
                                    else
                                          self.damageTable.damage_type =self.parent==self.caster and DAMAGE_TYPE_PURE or DAMAGE_TYPE_PHYSICAL
                                    end
                                    self.damageTable.victim = unit
                                    self.damageTable.damage =  tg.damage*self.cleave_damage_pct
                                    ApplyDamage(self.damageTable)
                              end
                        end
                  end
    end
end
function modifier_empower_buff:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_damage_pct
end
function modifier_empower_buff:GetModifierAttackRangeBonus()
    if self.caster:TG_HasTalent("special_bonus_magnataur_4") then
        return 50
    else
        return 0
    end
end
function modifier_empower_buff:GetModifierCastRangeBonusStacking()
    if self.caster:TG_HasTalent("special_bonus_magnataur_5") then
        return 60
    else
        return 0
    end
end