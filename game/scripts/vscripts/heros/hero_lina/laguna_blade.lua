laguna_blade=class({})
LinkLuaModifier("modifier_laguna_blade_pa", "heros/hero_lina/laguna_blade.lua", LUA_MODIFIER_MOTION_NONE)
function laguna_blade:IsHiddenWhenStolen()return false
end
function laguna_blade:IsStealable()return true
end
function laguna_blade:IsRefreshable()return true
end
function laguna_blade:GetCooldown(iLevel)
      if self.caster:Has_Aghanims_Shard() then
            return self.BaseClass.GetCooldown(self,iLevel)-40
      else
            return self.BaseClass.GetCooldown(self,iLevel)
      end
end
function laguna_blade:Init()
      self.caster=self:GetCaster()
end
function laguna_blade:OnSpellStart()
      local tar=self:GetCursorTarget()
      local rd=self:GetSpecialValueFor("rd")
      local dmg=self:GetSpecialValueFor("damage")
      if   tar:TG_TriggerSpellAbsorb(self)  and not self.caster:TG_HasTalent("special_bonus_lina_8")  then
		return
	end
      local fx = ParticleManager:CreateParticle("particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade.vpcf", PATTACH_ABSORIGIN, self.caster)
	ParticleManager:SetParticleControlEnt(fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_attack1", self.caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(fx, 1, tar, PATTACH_POINT_FOLLOW, "attach_hitloc", tar:GetAbsOrigin(), true)
      ParticleManager:ReleaseParticleIndex(fx)
      if   self.caster:Has_Aghanims_Shard() then
            dmg=dmg+self.caster:GetIntellect()
      end
      self.damageTable =
       {
            attacker = self.caster,
            damage =dmg,
            damage_type =self.caster:HasScepter() and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL,
            ability = self,
      }
      EmitSoundOn("Ability.LagunaBlade", self.caster)
      local units=FindUnitsInRadius(self.caster:GetTeamNumber(),tar:GetAbsOrigin(),nil,rd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
                  if #units>0 then
                              for _,target in pairs(units) do
                                    if not target:IsMagicImmune()  or  self.caster:HasScepter() then
                                                local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade_shard_units_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
                                                ParticleManager:SetParticleControl(fx, 0, target:GetAbsOrigin())
                                                ParticleManager:ReleaseParticleIndex(fx)
                                                if target==tar and self.caster:TG_HasTalent("special_bonus_lina_5") then
                                                      local hp=self.damageTable.damage*0.3
                                                      self.caster:Heal(hp, self)
                                                      SendOverheadEventMessage(self.caster, OVERHEAD_ALERT_HEAL, self.caster,hp, nil)
                                                end
                                                self.damageTable.victim = target
                                                ApplyDamage(self.damageTable)
                                    end
                              end
      end
      EmitSoundOn("Ability.LagunaBladeImpact", self.caster)
end
function laguna_blade:GetIntrinsicModifierName()
    return "modifier_laguna_blade_pa"
end

modifier_laguna_blade_pa=class({})
function modifier_laguna_blade_pa:IsHidden()
    return true
end
function modifier_laguna_blade_pa:IsPurgable()
    return false
end
function modifier_laguna_blade_pa:IsPurgeException()
    return false
end
function modifier_laguna_blade_pa:AllowIllusionDuplicate()
    return false
end
function modifier_laguna_blade_pa:OnCreated()
        if not self:GetAbility() then
            return
        end
        self.ability=self:GetAbility()
        self.parent=self:GetParent()
        self.team=self.parent:GetTeamNumber()
end
function modifier_laguna_blade_pa:OnRefresh()
       self:OnCreated()
end
function modifier_laguna_blade_pa:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_DEATH,
    }
end
function modifier_laguna_blade_pa:OnDeath(tg)
        if IsServer() then
                if   tg.attacker == self.parent  and not self.parent:IsIllusion() and tg.inflictor~=nil and tg.inflictor:GetName()=="laguna_blade" and tg.unit:IsRealHero() then
                        self.ability:EndCooldown()
                        if self.parent:TG_HasTalent("special_bonus_lina_7") then
                              self.parent:GiveMana(self.ability:GetManaCost(self.ability:GetLevel()))
                        end
                end
        end
end