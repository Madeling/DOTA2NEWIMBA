splinter_blast=class({})
LinkLuaModifier("modifier_splinter_blast_debuff", "heros/hero_winter_wyvern/splinter_blast.lua", LUA_MODIFIER_MOTION_NONE)
function splinter_blast:IsHiddenWhenStolen()return false
end
function splinter_blast:IsRefreshable()return true
end
function splinter_blast:IsStealable()return true
end
function splinter_blast:Init()
      self.caster=self:GetCaster()
end
function splinter_blast:OnSpellStart(target)
    local tar=self:GetCursorTarget() or target
    if tar==nil  then
            return
    end
    local rd=self:GetSpecialValueFor("rd")
    local sp=1000
      if self.caster:TG_HasTalent("special_bonus_winter_wyvern_4") then
            rd=rd+200
            sp=sp+1500
      end
    EmitSoundOn("Hero_Winter_Wyvern.SplinterBlast.Cast", self.caster)
    local heros = FindUnitsInRadius(
                  self.caster:GetTeamNumber(),
                  tar:GetAbsOrigin(),
                  nil,
                  rd,
                  DOTA_UNIT_TARGET_TEAM_ENEMY,
                  DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                  FIND_ANY_ORDER,
                  false)
                  if #heros>0 then
                        for _, hero in pairs(heros) do
                        local P =
                                    {
                                    Target = hero,
                                    Source = self.caster,
                                    Ability = self,
                                    EffectName = "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
                                    iMoveSpeed = sp,
                                    vSourceLoc = self.caster:GetAbsOrigin(),
                                    bDrawsOnMinimap = false,
                                    bDodgeable = true,
                                    bIsAttack = false,
                                    bVisibleToEnemies = true,
                                    bReplaceExisting = false,
                                    bProvidesVision = false,
                                    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
                                    ExtraData={dmg=0,e=1}
                                    }
                                    ProjectileManager:CreateTrackingProjectile(P)
                        end
                  end
      EmitSoundOn("Hero_Winter_Wyvern.SplinterBlast.Projectile", self.caster)
end

function splinter_blast:OnProjectileHit_ExtraData(target, location,kv)
    if  target==nil or target:IsMagicImmune() or target:TG_TriggerSpellAbsorb(self) then
		return
	end
      EmitSoundOn("Hero_Winter_Wyvern.SplinterBlast.Target", target)
      if kv.e~=nil then
            target:AddNewModifier(self.caster, self, "modifier_splinter_blast_debuff", {duration=self:GetSpecialValueFor("dur")})--
      end
      if self.caster:TG_HasTalent("special_bonus_winter_wyvern_3") then
            target:AddNewModifier(self.caster, self, "modifier_imba_stunned", {duration=0.7})
      end
      local dmg=self:GetSpecialValueFor("dmg")
      local damageTable=
            {
                  attacker = self.caster,
                  damage_type = DAMAGE_TYPE_MAGICAL,
                  ability =  self,
                  damage = (kv.dmg~=nil and kv.dmg==1) and dmg/2 or dmg,
                  victim = target,
            }
            ApplyDamage(damageTable)
end

modifier_splinter_blast_debuff=class({})
function modifier_splinter_blast_debuff:IsPurgable()return true
end
function modifier_splinter_blast_debuff:IsPurgeException()return true
end
function modifier_splinter_blast_debuff:RemoveOnDeath()return true
end
function modifier_splinter_blast_debuff:GetEffectAttachType()return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_splinter_blast_debuff:GetEffectName()return "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast_slow.vpcf"
end
function modifier_splinter_blast_debuff:DeclareFunctions()
    return
    {
            MODIFIER_EVENT_ON_DAMAGE_CALCULATED,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end
function modifier_splinter_blast_debuff:OnCreated()
          if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.pos=self.parent:GetAbsOrigin()
     self.sp=0-self.ability:GetSpecialValueFor("sp")
end

function modifier_splinter_blast_debuff:OnDamageCalculated(tg)
      if  IsServer() and tg.target==self.parent and not self.parent:IsIllusion() and tg.attacker:IsHero()  then
            local heros = FindUnitsInRadius(
                              self.ability.caster:GetTeamNumber(),
                              self.parent:GetAbsOrigin(),
                              nil,
                              600,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                              DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                              FIND_ANY_ORDER,
                              false)
                              if #heros>0 then
                                    for _, hero in pairs(heros) do
                                          if hero~=self.parent then
                                                EmitSoundOn("Hero_Winter_Wyvern.SplinterBlast.Cast", self.parent)
                                                EmitSoundOn("Hero_Winter_Wyvern.SplinterBlast.Projectile", self.parent)
                                                local P =
                                                            {
                                                            Target = hero,
                                                            Source = self.parent,
                                                            Ability = self.ability,
                                                            EffectName = "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
                                                            iMoveSpeed = 1500,
                                                            vSourceLoc = self.parent:GetAbsOrigin(),
                                                            bDrawsOnMinimap = false,
                                                            bDodgeable = true,
                                                            bIsAttack = false,
                                                            bVisibleToEnemies = true,
                                                            bReplaceExisting = false,
                                                            bProvidesVision = false,
                                                            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
                                                            ExtraData={dmg=1}
                                                            }
                                                            ProjectileManager:CreateTrackingProjectile(P)
                                                self:SetDuration(0, true)
                                                return
                                          end
                                    end
                              end

      end
end
function modifier_splinter_blast_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.sp
end
