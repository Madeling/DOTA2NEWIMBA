laser_cannon=class({})
LinkLuaModifier("modifier_laser_cannon_ch", "tg/science_sniper/laser_cannon.lua", LUA_MODIFIER_MOTION_NONE)

function laser_cannon:GetIntrinsicModifierName()
    return "modifier_laser_cannon_ch"
end

function laser_cannon:OnProjectileHit_ExtraData(target, location,kv)
    local caster=self:GetCaster()
	if not target then
		return
    end
      self.basedmg=self:GetSpecialValueFor("basedmg")
      self.agi=self:GetSpecialValueFor("agi")
      self.rd=self:GetSpecialValueFor("rd")
      local damageTable = {
                victim = target,
                attacker = caster,
                damage = self.basedmg+self.agi*caster:GetPrimaryStatValue(),
                damage_type =DAMAGE_TYPE_MAGICAL,
                ability = self,
                }
            ApplyDamage(damageTable)
end

modifier_laser_cannon_ch = class({})
function modifier_laser_cannon_ch:IsPurgable()return false
end
function modifier_laser_cannon_ch:IsPurgeException()return false
end
function modifier_laser_cannon_ch:IsHidden()return false
end
function modifier_laser_cannon_ch:AllowIllusionDuplicate()return false
end
function modifier_laser_cannon_ch:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.team=self.parent:GetTeamNumber()
    if not self.ability then
            return
    end
        self.chance= self.ability:GetSpecialValueFor("chance")
        self.stack= self.ability:GetSpecialValueFor("stack")
end
function modifier_laser_cannon_ch:OnRefresh()
    self:OnCreated()
end
function modifier_laser_cannon_ch:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_DEATH,MODIFIER_PROPERTY_PROJECTILE_NAME}
end
function modifier_laser_cannon_ch:OnAttackLanded(tg)
        if not IsServer() then
                return
        end
    if tg.attacker==self.parent and self.ability:GetLevel()>0  and not self.parent:PassivesDisabled() and not self.parent:IsIllusion() and RollPseudoRandomPercentage( self.chance+self:GetStackCount(), 0, self.parent) and not  tg.target:IsBuilding()    then
            EmitSoundOn("Hero_Tinker.Laser", self.parent)
            local P =
                  {
                        Target = tg.target,
                        Source = self.parent,
                        Ability = self.ability,
                        EffectName = "particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_assassinate.vpcf",
                        iMoveSpeed = 2000,
                        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
                        bDrawsOnMinimap = false,
                        bDodgeable = true,
                        bIsAttack = false,
                        bVisibleToEnemies = true,
                        bReplaceExisting = false,
                        bProvidesVision = false,
                  }
                  ProjectileManager:CreateTrackingProjectile(P)

    end
end

function modifier_laser_cannon_ch:OnDeath(tg)
      if not IsServer() then
            return
      end
      if tg.attacker== self.parent  and self.ability:GetLevel()>0 and  not self.parent:PassivesDisabled() and not self.parent:IsIllusion()  and tg.unit:IsRealHero() then
                  self:IncrementStackCount()
      end
end

function modifier_laser_cannon_ch:GetModifierProjectileName()
    return   "particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_base_attack.vpcf"
end