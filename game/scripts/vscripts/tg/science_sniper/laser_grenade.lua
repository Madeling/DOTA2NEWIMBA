laser_grenade=class({})
LinkLuaModifier("modifier_laser_grenade_buff", "tg/science_sniper/laser_grenade.lua", LUA_MODIFIER_MOTION_NONE)
function laser_grenade:IsHiddenWhenStolen()return false
end
function laser_grenade:IsStealable()return true
end
function laser_grenade:IsRefreshable()return true
end
function laser_grenade:OnSpellStart()
	local caster=self:GetCaster()
      local pos=self:GetCursorPosition()
      local dis=TG_Distance(caster:GetAbsOrigin(),pos)
      local time=dis/1500
      local wh= self:GetSpecialValueFor("wh")
      local sp= self:GetSpecialValueFor("sp")
      self.num= self:GetSpecialValueFor("num")
      if self.airecord==nil then
            self.airecord=0
      end
      EmitSoundOn("Hero_Sniper.ConcussiveGrenade.Cast", caster)
      local pp =
			{
				EffectName ="particles/tg_fx/heros/laser_grenade_p.vpcf",
				Ability = self,
				vSpawnOrigin =caster:GetAbsOrigin(),
				vVelocity =caster:GetForwardVector()*sp,
				fDistance =dis,
				fStartRadius = wh,
				fEndRadius = wh,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
				bProvidesVision = true,
				iVisionRadius = 300,
				iVisionTeamNumber = caster:GetTeamNumber()
			}
	ProjectileManager:CreateLinearProjectile( pp )
      Timers:CreateTimer(time-0.1 ,function()
           EmitSoundOn("Hero_Tinker.LaserImpact", caster)
            return nil
      end)
end


function laser_grenade:OnProjectileHit_ExtraData(target, location,kv)
    local caster=self:GetCaster()
	if not target then
		return
    end
    local basedmg= self:GetSpecialValueFor("basedmg")
    local dur= self:GetSpecialValueFor("dur")
    EmitSoundOn("Hero_Tinker.LaserImpact", target)
    if Is_Chinese_TG(caster,target) then
            target:AddNewModifier(caster, self, "modifier_laser_grenade_buff", {duration=dur})
      else
          local damageTable = {
                victim = target,
                attacker = caster,
                damage = basedmg,
                damage_type =DAMAGE_TYPE_MAGICAL,
                ability = self,
                }
            ApplyDamage(damageTable)
      end
end


modifier_laser_grenade_buff=class({})
function modifier_laser_grenade_buff:IsPurgable()return false
end
function modifier_laser_grenade_buff:IsPurgeException()return false
end
function modifier_laser_grenade_buff:IsHidden()return false
end
function modifier_laser_grenade_buff:AllowIllusionDuplicate()return false
end
function modifier_laser_grenade_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MODEL_SCALE
	}
end
function modifier_laser_grenade_buff:GetModifierModelScale()
    return -60
end
function modifier_laser_grenade_buff:CheckState()
    if self:GetParent()==self:GetCaster() then
      return
      {
            [MODIFIER_STATE_NO_HEALTH_BAR] = true,
      }
    end
    return {}
end