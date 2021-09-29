
CreateTalents("npc_dota_hero_lina", "heros/hero_lina/dragon_slave.lua")
dragon_slave=class({})
function dragon_slave:IsHiddenWhenStolen()return false
end
function dragon_slave:IsStealable()return true
end
function dragon_slave:IsRefreshable()return true
end
function dragon_slave:Init()
      self.caster=self:GetCaster()
end
function dragon_slave:OnSpellStart()
      local curpos=self:GetCursorPosition()
      local cpos=self.caster:GetAbsOrigin()
      local dir=(curpos-cpos):Normalized()
      local dragon_slave_speed=self:GetSpecialValueFor( "dragon_slave_speed" )
      local dragon_slave_width=self:GetSpecialValueFor( "dragon_slave_width" )
      local dragon_slave_distance=self:GetSpecialValueFor( "dragon_slave_distance" )
      if  cpos==curpos then
            dir=self.caster:GetForwardVector()
      end
      local PP =
        {
                  Ability = self,
                  EffectName = "particles/econ/items/lina/lina_head_headflame/lina_spell_dragon_slave_headflame.vpcf",
                  vSpawnOrigin = cpos,
                  fDistance = dragon_slave_distance,
                  fStartRadius = dragon_slave_width,
                  fEndRadius =dragon_slave_width,
                  Source = self.caster,
                  bHasFrontalCone = false,
                  bReplaceExisting = false,
                  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                  vVelocity =dir*dragon_slave_speed,
        }
        ProjectileManager:CreateLinearProjectile(PP)
         local PP1 =
        {
                  Ability = self,
                  EffectName = "particles/econ/items/lina/lina_head_headflame/lina_spell_dragon_slave_headflame.vpcf",
                  vSpawnOrigin = cpos,
                  fDistance = dragon_slave_distance,
                  fStartRadius = dragon_slave_width,
                  fEndRadius =dragon_slave_width,
                  Source = self.caster,
                  bHasFrontalCone = false,
                  bReplaceExisting = false,
                  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                  vVelocity =dir*dragon_slave_speed,
                  ExtraData = {array=1}
        }
        ProjectileManager:CreateLinearProjectile(PP1)
        EmitSoundOn("Hero_Lina.DragonSlave", self.caster)
end
function dragon_slave:OnProjectileHit_ExtraData(target, location, kv)
	if target==nil then
		return
	end
      if kv.array~=nil and kv.array==1 then
               if  target:IsHero() then
                  local tpos=target:GetAbsOrigin()
                  local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", PATTACH_CUSTOMORIGIN, nil)
                  ParticleManager:SetParticleControl(fx, 0, tpos)
                  ParticleManager:SetParticleControl(fx, 1, Vector(250, 1,100))
                  ParticleManager:ReleaseParticleIndex(fx)
                  Timers:CreateTimer(0.3, function()
                  local fx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_CUSTOMORIGIN, nil)
                  ParticleManager:SetParticleControl(fx1, 0,tpos)
                  ParticleManager:SetParticleControl(fx1, 1, Vector(250, 0, 0))
                  ParticleManager:ReleaseParticleIndex(fx1)
                  local units=FindUnitsInRadius(self.caster:GetTeamNumber(),tpos,nil,self:GetSpecialValueFor("array_rd"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
                  if #units>0 then
                              local stun=self:GetSpecialValueFor("array_stun")
                              for _,target in pairs(units) do
                                    if not target:IsMagicImmune() then
                                          target:AddNewModifier_RS(self.caster, self, "modifier_imba_stunned", {duration=stun})
                                    end
                              end
                  end
                        return nil
                  end)
                  return true
            end
      else
            if not target:IsMagicImmune() then
                        local damage=self:GetSpecialValueFor( "damage" )
                        local damageTable =
                        {
                              victim = target,
                              attacker = self.caster,
                              damage =damage,
                              damage_type =DAMAGE_TYPE_MAGICAL,
                              ability = self,
                        }
                        ApplyDamage(damageTable)
            end
      end
end