CreateTalents("npc_dota_hero_magnataur", "heros/hero_magnataur/shockwave.lua")
shockwave=class({})
function shockwave:IsHiddenWhenStolen()return false
end
function shockwave:IsStealable()return true
end
function shockwave:IsRefreshable()return true
end
function shockwave:Init()
      self.caster=self:GetCaster()
end
function shockwave:OnAbilityPhaseStart()
      EmitSoundOn("Hero_Magnataur.ShockWave.Cast", self.caster)
      return true
end
function shockwave:OnSpellStart()
      local curpos=self:GetCursorPosition()
      local cpos=self.caster:GetAbsOrigin()
      local dir=(curpos-cpos):Normalized()
      self.shock_speed=self:GetSpecialValueFor( "shock_speed" )
      self.shock_width=self:GetSpecialValueFor( "shock_width" )
      self.shock_distance=self:GetSpecialValueFor( "shock_distance" )
      self.shock_damage=self:GetSpecialValueFor( "shock_damage" )
      self.damageperc=self:GetSpecialValueFor( "damageperc" )*0.01
      if  cpos==curpos then
            dir=self.caster:GetForwardVector()
      end
      if self.caster:TG_HasTalent("special_bonus_magnataur_1") then
            self.shock_speed=self.shock_speed+500
            self.shock_distance=self.shock_distance+500
      end
      local PP =
        {
                  Ability = self,
                  EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
                  vSpawnOrigin = cpos,
                  fDistance = self.shock_distance,
                  fStartRadius = self.shock_width,
                  fEndRadius =self.shock_width,
                  Source = self.caster,
                  bHasFrontalCone = false,
                  bReplaceExisting = false,
                  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                  vVelocity =dir*self.shock_speed,
                  ExtraData = {split=1}
        }
        ProjectileManager:CreateLinearProjectile(PP)
        EmitSoundOn("Hero_Magnataur.ShockWave.Particle", self.caster)
     if self.caster:HasScepter() then
        Timers:CreateTimer(1, function()
            EmitSoundOn("Hero_Magnataur.ShockWave.Particle", self.caster)
            local p = {
                EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
                Ability = self,
                vSpawnOrigin = cpos+dir*self.shock_distance,
                fStartRadius = self.shock_width,
                fEndRadius = self.shock_width,
                vVelocity = -dir * self.shock_speed,
                fDistance = self.shock_distance,
                Source = self.caster,
                  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                ExtraData = {split=3}
            }
            ProjectileManager:CreateLinearProjectile(p)
            return nil
        end)
    end
end
function shockwave:OnProjectileHit_ExtraData(target, location, kv)
	if target==nil then
		return
	end
       if not target:IsMagicImmune() then
            local dmg=self.shock_damage
            if kv.split~=nil and kv.split==1 then
                  if  target:IsRealHero() then
                        local cpos=target:GetAbsOrigin()
                        local rdpos=cpos+RandomVector(self.shock_distance)
                        local dir=(rdpos-cpos):Normalized()
                              local PP =
                              {
                                          Ability = self,
                                          EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
                                          vSpawnOrigin = cpos,
                                          fDistance = self.shock_distance,
                                          fStartRadius = self.shock_width,
                                          fEndRadius =self.shock_width,
                                          Source = self.caster,
                                          bHasFrontalCone = false,
                                          bReplaceExisting = false,
                                          iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                                          iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          vVelocity =dir*self.shock_speed+500,
                                          ExtraData = {split=2}
                              }
                              ProjectileManager:CreateLinearProjectile(PP)
                              EmitSoundOn("Hero_Magnataur.ShockWave.Target", self.caster)
                  end
            end

            if kv.split~=nil and kv.split==2 then
                  dmg=dmg*self.damageperc
            end
                  local damageTable =
                              {
                                    victim = target,
                                    attacker = self.caster,
                                    damage =dmg,
                                    damage_type =DAMAGE_TYPE_MAGICAL,
                                    ability = self,
                              }
                  ApplyDamage(damageTable)

            if self.caster:Has_Aghanims_Shard() and not target:HasModifier("modifier_skewer_debuff") then
                        local tpos=target:GetAbsOrigin()
                        local cpos=self.caster:GetAbsOrigin()
                        local dir=(tpos-cpos):Normalized()
                              local Knockback ={
                                    should_stun = false,
                                    knockback_duration = 0.2,
                                    duration = 0.2,
                                    knockback_distance = 80,
                                    knockback_height = 10,
                                    center_x =  target:GetAbsOrigin().x+dir.x,
                                    center_y =  target:GetAbsOrigin().y+dir.y,
                                    center_z = target:GetAbsOrigin().z,
                              }
                              target:AddNewModifier(self.caster,self, "modifier_knockback", Knockback)
            end
      end
end