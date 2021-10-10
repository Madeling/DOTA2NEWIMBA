laser_gun=class({})
LinkLuaModifier("modifier_laser_gun_laser", "tg/science_sniper/laser_gun.lua", LUA_MODIFIER_MOTION_NONE)
function laser_gun:IsHiddenWhenStolen()return false
end
function laser_gun:IsStealable()return true
end
function laser_gun:IsRefreshable()return true
end
function laser_gun:GetAOERadius()
      return self:GetSpecialValueFor("rd")
end
function laser_gun:OnSpellStart()
	local caster=self:GetCaster()
      local pos=self:GetCursorPosition()
      local interval= self:GetSpecialValueFor("interval")
      local num= self:GetSpecialValueFor("num")
      CreateModifierThinker(caster, self, "modifier_laser_gun_laser", {duration=interval*num}, pos, caster:GetTeamNumber(), false)
end




modifier_laser_gun_laser =  class({})
function modifier_laser_gun_laser:IsPassive()return true
end
function modifier_laser_gun_laser:IsPurgable()return false
end
function modifier_laser_gun_laser:IsPurgeException()return false
end
function modifier_laser_gun_laser:IsHidden()return true
end
function modifier_laser_gun_laser:AllowIllusionDuplicate()return false
end
function modifier_laser_gun_laser:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.team=self.parent:GetTeamNumber()
    if not self.ability then
            return
    end
      self.interval= self.ability:GetSpecialValueFor("interval")
      self.num= self.ability:GetSpecialValueFor("num")
      self.rd= self.ability:GetSpecialValueFor("rd")
      self.attr= self.ability:GetSpecialValueFor("attr")
      self.basedmg= self.ability:GetSpecialValueFor("basedmg")
      self.dmgrd= self.ability:GetSpecialValueFor("dmgrd")
      self.pos=self.parent:GetAbsOrigin()
      if IsServer() then
            self.damageTable=
            {
                  attacker = self.caster,
                  damage_type = DAMAGE_TYPE_MAGICAL,
                  damage=self.basedmg+self.attr*self.caster:GetPrimaryStatValue(),
                  ability =  self.ability,
                  }
                self:StartIntervalThink( self.interval)
        end
end

function modifier_laser_gun_laser:OnIntervalThink()
      EmitSoundOn("Hero_Tinker.Laser", self.parent)
      local pos= self.pos+RandomVector(self.rd)
      local fx = ParticleManager:CreateParticle( "particles/econ/items/tinker/tinker_ti10_immortal_laser/tinker_ti10_immortal_laser.vpcf", PATTACH_CUSTOMORIGIN , nil)
      ParticleManager:SetParticleControl(fx,9,pos+Vector(RandomInt(-500, 500),RandomInt(-500, 500),1000))
      ParticleManager:SetParticleControl(fx,1,pos)
      ParticleManager:ReleaseParticleIndex(fx)
      local fx1 = ParticleManager:CreateParticle( "particles/econ/items/abaddon/abaddon_alliance/abaddon_aphotic_shield_alliance_explosion.vpcf", PATTACH_CUSTOMORIGIN , nil)
      ParticleManager:SetParticleControl(fx1,0,pos)
      ParticleManager:ReleaseParticleIndex(fx1)
      local units = FindUnitsInRadius(
                  self.team,
                  pos,
                  nil,
                  self.dmgrd,
                  DOTA_UNIT_TARGET_TEAM_ENEMY,
                  DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                  FIND_ANY_ORDER, false)
                  if #units>0 then
                        local enemy=units[RandomInt(1, #units)]
                        local tpos=enemy:GetAbsOrigin()
                          for _,target in pairs(units) do
                                    FindClearSpaceForUnit(target,tpos, false)
                                    self.damageTable.victim=target
                                    ApplyDamage(self.damageTable)
                        end
                  end
end
