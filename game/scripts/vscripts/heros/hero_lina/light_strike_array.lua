light_strike_array=class({})
LinkLuaModifier("modifier_light_strike_array_th", "heros/hero_lina/light_strike_array.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function light_strike_array:IsHiddenWhenStolen()return false
end
function light_strike_array:IsStealable()return true
end
function light_strike_array:IsRefreshable()return true
end
function light_strike_array:Init()
      self.caster=self:GetCaster()
end
function light_strike_array:OnSpellStart()
      local curpos=self:GetCursorPosition()
      local damage=self:GetSpecialValueFor( "light_strike_array_damage" )
      local enum=self:GetSpecialValueFor( "num" )
      self.light_strike_array_aoe=self:GetSpecialValueFor("light_strike_array_aoe")
      self.light_strike_array_stun_duration=self:GetSpecialValueFor( "light_strike_array_stun_duration" )
      self.damageTable =
       {
            attacker = self.caster,
            damage =damage+self.caster:TG_GetTalentValue("special_bonus_lina_2"),
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self,
      }
      local ang=0
      self:Light(curpos,true)
      for a=1,enum do
                   local pos1 = RotatePosition(curpos, QAngle(0, ang, 0), curpos + self.caster:GetForwardVector() * 600)
                  self:Light(pos1,true)
                  ang=ang+360/enum
      end
      CreateModifierThinker(self.caster, self, "modifier_light_strike_array_th", {duration=1}, curpos, self.caster:GetTeam(), false)
end

function light_strike_array:Light(pos,isDmg)
      EmitSoundOn("Ability.PreLightStrikeArray", self.caster)
      local fx = ParticleManager:CreateParticle("particles/econ/items/lina/lina_ti7/light_strike_array_pre_ti7.vpcf", PATTACH_CUSTOMORIGIN, nil)
      ParticleManager:SetParticleControl(fx, 0, pos)
      ParticleManager:SetParticleControl(fx, 1, Vector(self.light_strike_array_aoe, 1,100))
      ParticleManager:ReleaseParticleIndex(fx)
      local fx1 = ParticleManager:CreateParticle("particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf", PATTACH_CUSTOMORIGIN, nil)
      ParticleManager:SetParticleControl(fx1, 0,pos)
      ParticleManager:SetParticleControl(fx1, 1, Vector(self.light_strike_array_aoe, 0, 0))
      ParticleManager:ReleaseParticleIndex(fx1)
      local units=FindUnitsInRadius(self.caster:GetTeamNumber(),pos,nil,self.light_strike_array_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
       if #units>0 then
                              local stun=self:GetSpecialValueFor("array_stun")
                              for _,target in pairs(units) do
                                    if not target:IsMagicImmune() then
                                          target:AddNewModifier_RS(self.caster, self, "modifier_imba_stunned", {duration=self.light_strike_array_stun_duration})
                                          if isDmg==true then
                                                self.damageTable.victim = target
                                                ApplyDamage(self.damageTable)
                                          end
                                    end
                              end
      end
      EmitSoundOn("Ability.LightStrikeArray", self.caster)
end


modifier_light_strike_array_th=class({})
function modifier_light_strike_array_th:IsHidden()
    return true
end
function modifier_light_strike_array_th:IsPurgable()
    return false
end
function modifier_light_strike_array_th:IsPurgeException()
    return false
end
function modifier_light_strike_array_th:OnCreated()
      self.parent=self:GetParent()
      self.caster=self:GetCaster()
      self.ability=self:GetAbility()
      self.team=self.caster:GetTeamNumber()
      self.wh=self.ability:GetSpecialValueFor( "wh" )
      self.rg=self.ability:GetSpecialValueFor( "rg" )
      self.knock=self.ability:GetSpecialValueFor( "knock" )+self.caster:TG_GetTalentValue("special_bonus_lina_6")
      if IsServer() then
            self.angle=0
            self.pos=self.parent:GetAbsOrigin()
            self.dir=self.caster:GetForwardVector()
            self.Knockback ={
                  should_stun = true,
                  knockback_duration =  self.knock,
                  duration =  self.knock,
                  knockback_distance = 0,
                  knockback_height = 50,
            }
            self:OnIntervalThink()
            self:StartIntervalThink(0.1)
      end
end
function modifier_light_strike_array_th:OnIntervalThink()
      local pos1 = GetGroundPosition(RotatePosition(self.pos, QAngle(0, self.angle, 0), self.pos + self.dir* self.rg) ,nil )
      local fx = ParticleManager:CreateParticle( "particles/tgp/lina/laser_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
      ParticleManager:SetParticleControl(fx, 9,self.pos)
      ParticleManager:SetParticleControl( fx, 1, pos1)
      ParticleManager:ReleaseParticleIndex(fx)
      local heros = FindUnitsInLine(
            self.team,
            self.pos,
            pos1,
            self.caster,
            self.wh,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO,
            DOTA_UNIT_TARGET_FLAG_NONE)
      if #heros>0 then
            for _,hero in pairs(heros) do
                  local pos=hero:GetAbsOrigin()
                  self.Knockback.center_x =  pos.x+hero:GetForwardVector()
                  self.Knockback.center_y =  pos.y+hero:GetRightVector()
                  self.Knockback.center_z =  pos.z
                  hero:AddNewModifier( self.caster,self.ability, "modifier_knockback", self.Knockback)
            end
        end
      self.angle=self.angle+36
end
