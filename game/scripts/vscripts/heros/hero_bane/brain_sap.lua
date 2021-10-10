brain_sap=class({})

function brain_sap:IsHiddenWhenStolen()
    return false
end

function brain_sap:IsRefreshable()
    return true
end

function brain_sap:IsStealable()
    return true
end

function brain_sap:GetCastPoint()
    if self:GetCaster():TG_HasTalent("special_bonus_bane_3")   then
        return 0
    end
        return 0.3
end

function brain_sap:GetCooldown(iLevel)
      if self:GetCaster():HasScepter() then
            return self.BaseClass.GetCooldown(self,iLevel)-3
      end
            return self.BaseClass.GetCooldown(self,iLevel)
end

function brain_sap:OnSpellStart()
            local caster=self:GetCaster()
            local target=self:GetCursorTarget()
            if  target:TG_TriggerSpellAbsorb(self) then
                return
            end
            local tpos=target:GetAbsOrigin()
            local team=caster:GetTeamNumber()
            local brain_sap_damage=self:GetSpecialValueFor( "brain_sap_damage" )
            local radius=self:GetSpecialValueFor( "radius" )
            local damageTable = {
                  attacker = caster,
                  damage = brain_sap_damage,
                  damage_type = DAMAGE_TYPE_PURE,
                  ability = self,
            }
            local heros = FindUnitsInRadius(
                  team,
                  tpos,
                  nil,
                  radius,
                  DOTA_UNIT_TARGET_TEAM_ENEMY,
                  DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                  DOTA_UNIT_TARGET_FLAG_NONE,
                  FIND_CLOSEST,
                  false)
            if #heros>0 then
                  for _, hero in pairs(heros) do
                        if not hero:IsMagicImmune() then
                                    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_sap.vpcf", PATTACH_CUSTOMORIGIN, nil)
                                    ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false )
                                    ParticleManager:SetParticleControlEnt( pfx, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), false )
                                    ParticleManager:ReleaseParticleIndex(pfx)
                                    damageTable.victim = hero
                                    ApplyDamage( damageTable )
                                    if hero:HasModifier("modifier_enfeeble_debuff") then
                                          local mod=hero:FindModifierByName("modifier_enfeeble_debuff")
                                          mod:SetDuration( mod:GetDuration(), true )
                                    end
                                    caster:Heal(brain_sap_damage, self)
                                    SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster,brain_sap_damage, nil)
                                    if caster:TG_HasTalent("special_bonus_bane_6")   then
                                          local mana=brain_sap_damage*0.2
                                          caster:GiveMana(mana)
                                          SendOverheadEventMessage(caster, OVERHEAD_ALERT_MANA_ADD, caster,mana, nil)
                                          hero:AddNewModifier(caster, self, "modifier_silence", {duration=0.3})
                                    end
                        end
                  end
            end
            EmitSoundOn( "Hero_Bane.BrainSap", caster )

end