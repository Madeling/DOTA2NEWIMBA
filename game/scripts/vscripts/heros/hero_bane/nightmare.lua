nightmare=class({})

LinkLuaModifier("modifier_nightmare_buff", "heros/hero_bane/nightmare.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nightmare_debuff", "heros/hero_bane/nightmare.lua", LUA_MODIFIER_MOTION_NONE)

function nightmare:IsHiddenWhenStolen()
    return false
end

function nightmare:IsRefreshable()
    return true
end

function nightmare:IsStealable()
    return true
end

function nightmare:OnSpellStart()
            local caster=self:GetCaster()
            local target=self:GetCursorTarget()
            if  target:TG_TriggerSpellAbsorb(self) then
                return
            end
            local tpos=target:GetAbsOrigin()
            local team=caster:GetTeamNumber()
            local dur=self:GetSpecialValueFor( "duration" )
            if Is_Chinese_TG(caster,target) then
                  target:AddNewModifier(caster,self,"modifier_nightmare_buff",{duration=dur})
            else
                  target:Stop()
                  target:Interrupt()
                  target:AddNewModifier_RS(caster,self,"modifier_nightmare_debuff",{duration=dur})
            end
end

modifier_nightmare_buff=class({})

function modifier_nightmare_buff:IsPurgable()
    return true
end

function modifier_nightmare_buff:IsPurgeException()
    return true
end

function modifier_nightmare_buff:IsHidden()
    return false
end

function modifier_nightmare_buff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_nightmare_buff:GetEffectName()
    return "particles/units/heroes/hero_bane/bane_nightmare.vpcf"
end


function modifier_nightmare_buff:OnCreated()
                self.dmg=self:GetAbility():GetSpecialValueFor( "dmg" )
      if IsServer() then
            EmitSoundOn( "Hero_Bane.Nightmare", self:GetParent() )
            EmitSoundOn( "Hero_Bane.Nightmare.Loop", self:GetParent() )
      end
end

function modifier_nightmare_buff:OnDestroy( )
            StopSoundOn( "Hero_Bane.Nightmare.Loop",  self:GetParent() )
            EmitSoundOn( "Hero_Bane.Nightmare.End", self:GetParent() )
end

function modifier_nightmare_buff:CheckState()
    return
    {
        [MODIFIER_STATE_NIGHTMARED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_MUTED] = true,
    }
end

function modifier_nightmare_buff:DeclareFunctions()
    return
    {
             MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
            MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end


function modifier_nightmare_buff:GetModifierIncomingDamage_Percentage()
    return  (0-self.dmg)
end

function modifier_nightmare_buff:OnTakeDamage(tg)
    if not IsServer() then
            return
   end
      if tg.unit == self:GetParent() and tg.attacker~=self:GetParent() and   tg.attacker:IsHero() and tg.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  then
            local dur=self:GetAbility():GetSpecialValueFor( "duration" )
            if Is_Chinese_TG(tg.unit ,tg.attacker) then
                  tg.attacker:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_nightmare_buff",{duration=dur})
            else
                  tg.attacker:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_nightmare_debuff",{duration=dur})
            end
                 self:Destroy()
	end
end

function modifier_nightmare_buff:GetOverrideAnimation()
    return ACT_DOTA_FLAIL_STATUE
end

function modifier_nightmare_buff:GetOverrideAnimationRate()
    return 0.5
end

function modifier_nightmare_buff:GetModifierMoveSpeedBonus_Percentage()
    if self:GetCaster():TG_HasTalent("special_bonus_bane_5")   then
            return 30
      end
            return 0
end


modifier_nightmare_debuff=class({})

function modifier_nightmare_debuff:IsPurgable()
    return true
end

function modifier_nightmare_debuff:IsPurgeException()
    return true
end

function modifier_nightmare_debuff:IsHidden()
    return false
end

function modifier_nightmare_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_nightmare_debuff:GetEffectName()
    return "particles/econ/items/bane/slumbering_terror/bane_slumber_nightmare.vpcf"
end

function modifier_nightmare_debuff:CheckState()
    return
    {
        [MODIFIER_STATE_NIGHTMARED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_ATTACK_ALLIES  ] = true,
    }
end

function modifier_nightmare_debuff:OnCreated()
      self.dmg=self:GetAbility():GetSpecialValueFor( "dmg" )
      if IsServer() then
            EmitSoundOn( "Hero_Bane.Nightmare", self:GetParent() )
            EmitSoundOn( "Hero_Bane.Nightmare.Loop", self:GetParent() )

            if not self:GetAbility():GetAutoCastState(  ) then
                  local heros = FindUnitsInRadius(
                        self:GetCaster():GetTeamNumber(),
                        self:GetParent():GetAbsOrigin(),
                        nil,
                        1000,
                        DOTA_UNIT_TARGET_TEAM_ENEMY,
                        DOTA_UNIT_TARGET_HERO,
                        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                        FIND_CLOSEST,
                        false)
                  if #heros>1 then
                              for _, hero in pairs(heros) do
                                    if hero~= self:GetParent() then
                                          self.tar= hero
                                    end
                              end
                              self:GetParent():MoveToTargetToAttack( self.tar )
                  else
                        self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_disarmed",{duration=self:GetRemainingTime()})
                  end
            end
      end
end


function modifier_nightmare_debuff:OnDestroy( )
            StopSoundOn( "Hero_Bane.Nightmare.Loop",  self:GetParent() )
            EmitSoundOn( "Hero_Bane.Nightmare.End", self:GetParent() )
end

function modifier_nightmare_debuff:DeclareFunctions()
    return
    {
                        MODIFIER_EVENT_ON_TAKEDAMAGE,
                    MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
                    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
    }
end

function modifier_nightmare_debuff:OnTakeDamage(tg)
    if not IsServer() then
            return
   end
      if tg.unit == self:GetParent() and tg.attacker~=self:GetParent() and tg.attacker~=self:GetCaster() and   tg.attacker:IsHero() and tg.damage_category==DOTA_DAMAGE_CATEGORY_ATTACK  then
            local dur=self:GetAbility():GetSpecialValueFor( "duration" )
            if Is_Chinese_TG(tg.unit ,tg.attacker) then
                  tg.attacker:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_nightmare_debuff",{duration=dur})
            else
                  tg.attacker:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_nightmare_buff",{duration=dur})
            end
            self:Destroy()
	end
end

function modifier_nightmare_debuff:GetOverrideAnimationRate()
    return 0.5
end

function modifier_nightmare_debuff:GetModifierOverrideAbilitySpecialValue(tg)
      print(tg.ability)
    return 1
end

function modifier_nightmare_debuff:GetModifierMoveSpeedBonus_Percentage()
      if self:GetCaster():Has_Aghanims_Shard() then
                  return 50
      end
         return 0
end

function modifier_nightmare_debuff:GetModifierAttackSpeedBonus_Constant()
      if self:GetCaster():Has_Aghanims_Shard() then
                  return self:GetParent():GetLevel()*7
      end
         return 0
end