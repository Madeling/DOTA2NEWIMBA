power_surge=class({})
LinkLuaModifier("modifier_power_surge", "tg/science_sniper/power_surge.lua", LUA_MODIFIER_MOTION_NONE)
function power_surge:IsHiddenWhenStolen()return false
end
function power_surge:IsStealable()return true
end
function power_surge:IsRefreshable()return true
end
function power_surge:OnSpellStart()
	local caster=self:GetCaster()
      local pos=self:GetCursorPosition()
      local dur= self:GetSpecialValueFor("dur")
      EmitSoundOn("Hero_Disruptor.ThunderStrike.Cast", caster)
      local fx1 = ParticleManager:CreateParticle( "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", PATTACH_ABSORIGIN_FOLLOW , caster)
      ParticleManager:ReleaseParticleIndex(fx1)
      CreateModifierThinker(caster, self, "modifier_power_surge", {duration=dur}, pos, caster:GetTeamNumber(), false)
end

modifier_power_surge=class({})
function modifier_power_surge:IsPurgable()return false
end
function modifier_power_surge:IsPurgeException()return false
end
function modifier_power_surge:IsHidden()return true
end
function modifier_power_surge:AllowIllusionDuplicate()return false
end
function modifier_power_surge:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.team=self.parent:GetTeamNumber()
    if not self.ability then
            return
    end
      self.interval= self.ability:GetSpecialValueFor("interval")
      self.rd= self.ability:GetSpecialValueFor("rd")
      self.dmg= self.ability:GetSpecialValueFor("dmg")
      self.stun= self.ability:GetSpecialValueFor("stun")
      self.pos=self.parent:GetAbsOrigin()
      if IsServer() then
            self.mod=self.caster:FindModifierByName("modifier_laser_cannon_ch")
            self.damageTable=
            {
                  attacker = self.caster,
                  damage_type = DAMAGE_TYPE_MAGICAL,
                  damage=self.dmg,
                  ability =  self.ability,
                  }
                self:StartIntervalThink( self.interval)
        end
end
function modifier_power_surge:OnIntervalThink()
      AddFOWViewer(self.team, self.pos, self.rd, 1, false)
      EmitSoundOn("Hero_Disruptor.ThunderStrike.Target", self.parent)
      local fx1 = ParticleManager:CreateParticle( "particles/tg_fx/heros/power_surge_electric_m.vpcf", PATTACH_CUSTOMORIGIN , nil)
      ParticleManager:SetParticleControl(fx1,0,self.pos+Vector(0,0,200))
      ParticleManager:ReleaseParticleIndex(fx1)
      local units = FindUnitsInRadius(
                  self.team,
                  self.pos,
                  nil,
                  self.rd,
                  DOTA_UNIT_TARGET_TEAM_ENEMY,
                  DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                  FIND_ANY_ORDER, false)
                  if #units>0 then
                          for _,target in pairs(units) do
                                    self.damageTable.victim=target
                                    ApplyDamage(self.damageTable)
                                    target:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration= self.stun})
                                    if self.mod~=nil and target:IsRealHero() then
                                          self.mod:IncrementStackCount()
                                    end
                        end
                  end
end