unstable_concoction_throw=class({})
LinkLuaModifier("modifier_unstable_concoction_throw_stun", "heros/hero_alchemist/unstable_concoction_throw.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_unstable_concoction_throw_debuff", "heros/hero_alchemist/unstable_concoction_throw.lua", LUA_MODIFIER_MOTION_NONE)
function unstable_concoction_throw:IsHiddenWhenStolen()
    return false
end
function unstable_concoction_throw:IsStealable()
    return true
end
function unstable_concoction_throw:IsRefreshable()
    return true
end
function unstable_concoction_throw:Init()
    self.caster=self:GetCaster()
end
function unstable_concoction_throw:OnSpellStart()
    local cpos=self.caster:GetAbsOrigin()
    local target=self:GetCursorTarget()
    local team=self.caster:GetTeamNumber()
    self.num=self:GetSpecialValueFor("num")
    local rd=self:GetSpecialValueFor("rd")
    if self.caster:TG_HasTalent("special_bonus_alchemist_2") then
             self.num= self.num+1
    end
    self.curr=0
    EmitSoundOn("Hero_Alchemist.UnstableConcoction.Throw", self.caster)
    local P =
            {
                Target = target,
                Source = self.caster,
                Ability = self,
                EffectName = "particles/econ/items/alchemist/alchemist_smooth_criminal/alchemist_smooth_criminal_unstable_concoction_projectile.vpcf",
                iMoveSpeed = 1500,
                vSourceLoc = cpos,
                bDrawsOnMinimap = false,
                bDodgeable = true,
                bIsAttack = false,
                bVisibleToEnemies = true,
                bReplaceExisting = false,
                bProvidesVision = false,
                 iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_3,
            }
            ProjectileManager:CreateTrackingProjectile(P)
end
function unstable_concoction_throw:OnProjectileHit_ExtraData(target, location,kv)
    if  target==nil or target:IsMagicImmune() or target:TG_TriggerSpellAbsorb(self) then
		return
	end
      EmitSoundOn("Hero_Alchemist.UnstableConcoction.Stun", target)
      target:AddNewModifier_RS(self.caster, self, "modifier_unstable_concoction_throw_stun", {duration=self:GetSpecialValueFor("stun")})
      local damageTable=
        {
            attacker = self.caster,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability =  self,
            damage = self:GetSpecialValueFor("dmg"),
            victim = target,
        }
          ApplyDamage(damageTable)
          if self.curr<self.num then
          local heros = FindUnitsInRadius(
                  self.caster:GetTeamNumber(),
                  target:GetAbsOrigin(),
                  nil,
                  600,
                  DOTA_UNIT_TARGET_TEAM_ENEMY,
                  DOTA_UNIT_TARGET_HERO,
                  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                  FIND_CLOSEST,
                  false)
                  if #heros>0 then
                        for _, hero in pairs(heros) do
                                if hero~=target then
                                    EmitSoundOn("Hero_Alchemist.UnstableConcoction.Throw", hero)
                                    local P =
                                    {
                                        Target = hero,
                                        Source =target,
                                        Ability = self,
                                        EffectName = "particles/econ/items/alchemist/alchemist_smooth_criminal/alchemist_smooth_criminal_unstable_concoction_projectile.vpcf",
                                        iMoveSpeed = 1500,
                                        vSourceLoc = target:GetAbsOrigin(),
                                        bDrawsOnMinimap = false,
                                        bDodgeable = true,
                                        bIsAttack = false,
                                        bVisibleToEnemies = true,
                                        bReplaceExisting = false,
                                        bProvidesVision = false,
                                        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
                                    }
                                    ProjectileManager:CreateTrackingProjectile(P)
                                    self.curr=self.curr+1
                                    return
                                end
                        end
                  end
                  end
end

modifier_unstable_concoction_throw_stun=class({})
function modifier_unstable_concoction_throw_stun:IsDebuff()
    return true
end
function modifier_unstable_concoction_throw_stun:IsHidden()
    return false
end
function modifier_unstable_concoction_throw_stun:IsPurgable()
    return false
end
function modifier_unstable_concoction_throw_stun:IsPurgeException()
    return true
end
function modifier_unstable_concoction_throw_stun:CheckState()
    return {[MODIFIER_STATE_STUNNED] = true}
end
function modifier_unstable_concoction_throw_stun:DeclareFunctions()
    return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end
function modifier_unstable_concoction_throw_stun:GetOverrideAnimation()
    return ACT_DOTA_DISABLED
end
function modifier_unstable_concoction_throw_stun:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end
function modifier_unstable_concoction_throw_stun:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
function modifier_unstable_concoction_throw_stun:ShouldUseOverheadOffset()
    return true
end
function modifier_unstable_concoction_throw_stun:OnDestroy()
        self.parent=self:GetParent()
        self.ability=self:GetAbility()
        self.caster=self:GetCaster()
        if IsServer() then
                self.parent:AddNewModifier_RS(self.caster, self.ability, "modifier_unstable_concoction_throw_debuff", {duration=self.ability:GetSpecialValueFor("dur")})
        end
end

modifier_unstable_concoction_throw_debuff=class({})
function modifier_unstable_concoction_throw_debuff:IsDebuff()
    return true
end
function modifier_unstable_concoction_throw_debuff:IsPurgable()
    return false
end
function modifier_unstable_concoction_throw_debuff:IsPurgeException()
    return false
end
