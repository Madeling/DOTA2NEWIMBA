reverse_polarity=class({})
LinkLuaModifier("modifier_reverse_polarity_pa", "heros/hero_magnataur/reverse_polarity.lua", LUA_MODIFIER_MOTION_NONE)
function reverse_polarity:IsHiddenWhenStolen()return false
end
function reverse_polarity:IsStealable()return true
end
function reverse_polarity:IsRefreshable()return true
end
function reverse_polarity:GetIntrinsicModifierName()
    return "modifier_reverse_polarity_pa"
end
function reverse_polarity:Init()
      self.caster=self:GetCaster()
end
function reverse_polarity:OnSpellStart()
            EmitSoundOn("Hero_Magnataur.ReversePolarity.Cast", self.caster)
            local pull_radius=self:GetSpecialValueFor( "pull_radius" )
            local polarity_damage=self:GetSpecialValueFor( "polarity_damage" )
            local pull_duration=self:GetSpecialValueFor( "pull_duration" )
            local dis=self:GetSpecialValueFor( "dis" )
            self.stun=self:GetSpecialValueFor( "stun" )
            local team=self.caster:GetTeamNumber()
            local pos=self.caster:GetAbsOrigin()
            local Knockback ={
                                    should_stun = false,
                                    knockback_duration = 0.5,
                                    duration = 0.5,
                                    knockback_distance = dis,
                                    knockback_height = 10,
                              }
            local damageTable =
                              {
                                    attacker = self.caster,
                                    damage =polarity_damage,
                                    damage_type =DAMAGE_TYPE_MAGICAL,
                                    ability = self,
                              }
            local heros = FindUnitsInRadius(
                  team,
                  pos,
                  nil,
                  self.caster:TG_HasTalent("special_bonus_magnataur_7") and 30000 or 2000,
                  DOTA_UNIT_TARGET_TEAM_ENEMY,
                  DOTA_UNIT_TARGET_HERO,
                  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                  FIND_CLOSEST,
                  false)
                  if #heros>0 then
                        for _, hero in pairs(heros) do
                              if hero:GetModelScale()<self.caster:GetModelScale() then
                                    local tpos=hero:GetAbsOrigin()
                                    local dir=(tpos-pos):Normalized()
                                    Knockback.center_x =  hero:GetAbsOrigin().x+dir.x
                                    Knockback.center_y =  hero:GetAbsOrigin().y+dir.y
                                    Knockback.center_z = hero:GetAbsOrigin().z
                                    hero:AddNewModifier(self.caster,self, "modifier_knockback", Knockback)
                              end
                        end
                  end
            local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", PATTACH_CUSTOMORIGIN,  self.caster)
		ParticleManager:SetParticleControl(fx, 1, Vector(pull_radius,pull_radius,pull_radius))
            ParticleManager:SetParticleControl(fx, 2, Vector(0.3,0,0))
            ParticleManager:SetParticleControl(fx, 3, pos)
		ParticleManager:ReleaseParticleIndex(fx)
            local heros = FindUnitsInRadius(
                  team,
                  pos,
                  nil,
                  pull_radius,
                  DOTA_UNIT_TARGET_TEAM_ENEMY,
                  DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                  FIND_CLOSEST,
                  false)
                  if #heros>0 then
                        for _, hero in pairs(heros) do
                                    hero:InterruptMotionControllers(false)
                                    FindClearSpaceForUnit(hero, pos+self.caster:GetForwardVector()*150, true)
                                    hero:AddNewModifier_RS(self.caster, self, "modifier_imba_stunned", {duration=pull_duration})
                                      damageTable.victim = hero
                                      ApplyDamage(damageTable)
                        end
                  end
      local PP =
        {
                  Ability = self,
                  EffectName = "particles/tgp/whirlwind/whirlwind_m.vpcf",
                  vSpawnOrigin = pos,
                  fDistance = 3000,
                  fStartRadius = 250,
                  fEndRadius =250,
                  Source = self.caster,
                  bHasFrontalCone = false,
                  bReplaceExisting = false,
                  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                  vVelocity =self.caster:GetForwardVector()*2000,
        }
        ProjectileManager:CreateLinearProjectile(PP)
        EmitSoundOn("Hero_Magnataur.ShockWave.Particle", self.caster)
end

function reverse_polarity:OnProjectileHit_ExtraData(target, location, kv)
	if target==nil then
		return
	end
       if not target:IsMagicImmune() then
            target:AddNewModifier_RS(self.caster, self, "modifier_imba_stunned", {duration=self.stun})
      end
end

modifier_reverse_polarity_pa=class({})
function modifier_reverse_polarity_pa:IsHidden()
	return true
end
function modifier_reverse_polarity_pa:IsPurgable()
	return false
end
function modifier_reverse_polarity_pa:IsPurgeException()
	return false
end
function modifier_reverse_polarity_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MODEL_SCALE
    }
end
function modifier_reverse_polarity_pa:GetModifierModelScale()
    if self:GetCaster():TG_HasTalent("special_bonus_magnataur_8") then
        return 30
    else
        return 0
    end
end