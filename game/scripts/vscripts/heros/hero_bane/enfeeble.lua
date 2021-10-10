CreateTalents("npc_dota_hero_bane", "heros/hero_bane/enfeeble.lua")
enfeeble=class({})
LinkLuaModifier("modifier_enfeeble_buff", "heros/hero_bane/enfeeble.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfeeble_debuff", "heros/hero_bane/enfeeble.lua", LUA_MODIFIER_MOTION_NONE)

function enfeeble:IsHiddenWhenStolen()
    return false
end

function enfeeble:IsRefreshable()
    return true
end

function enfeeble:IsStealable()
    return true
end


function enfeeble:OnSpellStart()
            local caster=self:GetCaster()
            local target=self:GetCursorTarget()
            if  target:TG_TriggerSpellAbsorb(self) then
                return
            end
            local tpos=target:GetAbsOrigin()
            local team=caster:GetTeamNumber()
            local dur=self:GetSpecialValueFor( "duration" )
            local radius=self:GetSpecialValueFor( "radius" )
            local num=self:GetSpecialValueFor( "num" )
            local dmg=self:GetSpecialValueFor( "dmg" )*0.01
            local damageTable = {
                  attacker = caster,
                  damage = target:GetMaxHealth(  )*dmg,
                  damage_type = DAMAGE_TYPE_MAGICAL,
                  ability = self,
            }

            EmitSoundOn( "Hero_Bane.Enfeeble", caster )
            caster:AddNewModifier(caster,self,"modifier_enfeeble_buff",{duration=dur})
            target:AddNewModifier(caster,self,"modifier_enfeeble_debuff",{duration=dur})
            local pfx = ParticleManager:CreateParticle("particles/tgp/soul_m.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(pfx, 0,target:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(pfx)
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
                  if #heros>num or    caster:TG_HasTalent("special_bonus_bane_1")  then
                        local pfx1 = ParticleManager:CreateParticle("particles/tgp/ghost_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
                        ParticleManager:SetParticleControl(pfx1, 0,tpos)
                        ParticleManager:SetParticleControl(pfx1, 1, Vector(radius,0,0))
                        ParticleManager:SetParticleControl(pfx1, 2, Vector(2,0,0))
                        ParticleManager:ReleaseParticleIndex(pfx1)
                        Timers:CreateTimer(1, function()
                              local heros1 = FindUnitsInRadius(
                                          team,
                                          tpos,
                                          nil,
                                          radius,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_NONE,
                                          FIND_CLOSEST,
                                          false)
                              for _, hero in pairs(heros1) do
                                    if not hero:IsMagicImmune() then
                                          damageTable.victim = hero
                                          ApplyDamage( damageTable )
                                          if caster:TG_HasTalent("special_bonus_bane_2") then
                                                      hero:AddNewModifier(caster,self,"modifier_rooted",{duration=1})
                                          end
                                    end
                              end
		                        return nil
	                  end)
                  end

end

modifier_enfeeble_buff=class({})

function modifier_enfeeble_buff:IsPurgable()
    return false
end

function modifier_enfeeble_buff:IsPurgeException()
    return false
end

function modifier_enfeeble_buff:IsHidden()
    return false
end


function modifier_enfeeble_buff:OnCreated()
    self.damage_reduction=self:GetAbility():GetSpecialValueFor( "damage_reduction" )/2
end


function modifier_enfeeble_buff:OnRefresh()
      self:OnCreated()
end


function modifier_enfeeble_buff:DeclareFunctions()
    return
    {

        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }
end


function modifier_enfeeble_buff:GetModifierDamageOutgoing_Percentage()
    return  self.damage_reduction
end

modifier_enfeeble_debuff=class({})

function modifier_enfeeble_debuff:IsDebuff()
    return true
end

function modifier_enfeeble_debuff:IsPurgable()
    return false
end

function modifier_enfeeble_debuff:IsPurgeException()
    return false
end

function modifier_enfeeble_debuff:IsHidden()
    return false
end

function modifier_enfeeble_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_enfeeble_debuff:GetEffectName()
    return "particles/units/heroes/hero_bane/bane_enfeeble.vpcf"
end


function modifier_enfeeble_debuff:DeclareFunctions()
    return
    {

        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end


function modifier_enfeeble_debuff:GetModifierDamageOutgoing_Percentage()
    return  0-self:GetAbility():GetSpecialValueFor( "damage_reduction" )
end

function modifier_enfeeble_debuff:GetModifierIncomingDamage_Percentage()
    if self:GetCaster():TG_HasTalent("special_bonus_bane_4")   then
            return 15
    end
            return 0
end
