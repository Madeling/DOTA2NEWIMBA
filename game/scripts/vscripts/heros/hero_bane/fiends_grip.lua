fiends_grip=class({})
LinkLuaModifier("modifier_fiends_grip_debuff", "heros/hero_bane/fiends_grip.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fiends_grip_pa", "heros/hero_bane/fiends_grip.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fiends_grip_cd", "heros/hero_bane/fiends_grip.lua", LUA_MODIFIER_MOTION_NONE)
function fiends_grip:IsHiddenWhenStolen()
    return false
end

function fiends_grip:IsRefreshable()
    return true
end

function fiends_grip:IsStealable()
    return true
end

function fiends_grip:OnSpellStart()
            local caster=self:GetCaster()
            local target=self:GetCursorTarget()
            local tpos=target:GetAbsOrigin()
            local team=caster:GetTeamNumber()
            if  target:TG_TriggerSpellAbsorb(self) then
                return
            end
            self.dur=self:GetSpecialValueFor( "duration" )
            if self.num==nil then self.num=0 end
            target:AddNewModifier_RS(caster,self,"modifier_fiends_grip_debuff",{duration=self.dur})
            local dir=TG_Direction(tpos,caster:GetAbsOrigin())
           if caster:TG_HasTalent("special_bonus_bane_8") then
                  local ab=caster:FindAbilityByName("enfeeble")
                  if ab and ab:GetLevel()>0 then
                        local PP=
                        {
                              EffectName="particles/tgp/dimlight_m.vpcf",
                              Ability=self,
                              Source=caster,
                              vSpawnOrigin=caster:GetAbsOrigin()+dir*-1000,
                              fDistance=3000,
                              fStartRadius=300,
                              fEndRadius=300,
                              vVelocity=dir*1000,
                              iUnitTargetTeam=DOTA_UNIT_TARGET_TEAM_ENEMY,
                              iUnitTargetType=DOTA_UNIT_TARGET_HERO,
                              ExtraData={sk=ab:entindex()}
                        }
                        ProjectileManager:CreateLinearProjectile(PP)
                  end
           end
end

function fiends_grip:OnProjectileHit_ExtraData(target, location,kv)
	if not target then
		return
    end
            if kv.sk~=nil then
                  local caster=self:GetCaster()
                  local ab=EntIndexToHScript(kv.sk)
                  local dur=ab:GetSpecialValueFor("duration")
                  caster:AddNewModifier(caster,ab,"modifier_enfeeble_buff",{duration=dur})
                  target:AddNewModifier_RS(caster,ab,"modifier_enfeeble_debuff",{duration=dur})
            end
end


function fiends_grip:GetIntrinsicModifierName()
      return "modifier_fiends_grip_pa"
 end

 modifier_fiends_grip_pa=class({})

function modifier_fiends_grip_pa:IsPurgable()
    return false
end

function modifier_fiends_grip_pa:IsPurgeException()
    return false
end


function modifier_fiends_grip_pa:IsHidden()
     if self:GetParent():TG_HasTalent("special_bonus_bane_7") then
            return false
      else
            return true
      end
end

function modifier_fiends_grip_pa:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_fiends_grip_pa:OnCreated()
     self.CD=0
end

function modifier_fiends_grip_pa:OnIntervalThink()
     self.CD=self.CD-1
     self:SetStackCount(self.CD)
     if self.CD<=0 then
            self.CD=0
            self:StartIntervalThink(-1)
      end
end

function modifier_fiends_grip_pa:OnDeath(tg)
        if IsServer() then
                if tg.attacker~=self:GetParent() and tg.attacker:IsRealHero()  and not tg.attacker:IsIllusion() and tg.unit==self:GetParent()  and not tg.unit:IsIllusion() and  self.CD==0 and tg.unit:TG_HasTalent("special_bonus_bane_7") then
                        tg.attacker:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_fiends_grip_debuff",{duration=self:GetAbility():GetSpecialValueFor("duration")})
                        self.CD=100
                        self:StartIntervalThink(1)
                end
        end
end

modifier_fiends_grip_cd=class({})

function modifier_fiends_grip_cd:IsPurgable()
    return false
end

function modifier_fiends_grip_cd:IsPurgeException()
    return false
end

function modifier_fiends_grip_cd:IsHidden()
    return false
end



modifier_fiends_grip_debuff=class({})

function modifier_fiends_grip_debuff:IsDebuff()
    return true
end

function modifier_fiends_grip_debuff:IsPurgable()
    return false
end

function modifier_fiends_grip_debuff:IsPurgeException()
    return false
end

function modifier_fiends_grip_debuff:IsHidden()
    return false
end

function modifier_fiends_grip_debuff:OnCreated()
          self.dmg=self:GetAbility():GetSpecialValueFor( "dmg" )
          self.mana=self:GetAbility():GetSpecialValueFor( "mana" )
          self.interval=self:GetAbility():GetSpecialValueFor( "interval" )
          self.dis=self:GetAbility():GetSpecialValueFor( "dis" )
          self.damageTable = {
                  attacker = self:GetCaster(),
                  victim = self:GetParent(),
                  damage = self.dmg,
                  damage_type = DAMAGE_TYPE_PURE,
                  ability = self:GetAbility(),
            }
      if IsServer() then
            EmitSoundOn( "Hero_Bane.FiendsGrip.Cast", self:GetCaster() )
            EmitSoundOn( "Hero_Bane.FiendsGrip", self:GetParent() )
            local pfx = ParticleManager:CreateParticle("particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            ParticleManager:SetParticleControl(pfx, 0,self:GetParent():GetAbsOrigin())
            ParticleManager:SetParticleControl(pfx, 1,self:GetParent():GetAbsOrigin())
            self:AddParticle( pfx, false, false, -1, false, false )
            self.pfx1 = ParticleManager:CreateParticle("particles/tgp/claw_m.vpcf", PATTACH_CUSTOMORIGIN,nil)
            ParticleManager:SetParticleControl(self.pfx1, 0,self:GetParent():GetAbsOrigin())
            ParticleManager:SetParticleControl(self.pfx1, 1,Vector(self.dis,0,0))
            ParticleManager:SetParticleControl(self.pfx1, 2,Vector(self:GetRemainingTime(),0,0))
            ParticleManager:SetParticleControl(self.pfx1, 60,Vector(112,35,35))
            ParticleManager:SetParticleControl(self.pfx1, 61,Vector(1,0,0))
            self:AddParticle( self.pfx1, false, false, -1, false, false )
            self.fiends_grip_debuff=self:GetCaster()
            self:StartIntervalThink(self.interval)
      end
end

function modifier_fiends_grip_debuff:OnIntervalThink()
            self:GetParent():Purge(true, false, false, false, false)
            ApplyDamage( self.damageTable )
            if self:GetCaster():IsAlive() then
                self:GetCaster():GiveMana(self.mana)
                SendOverheadEventMessage(self:GetCaster(), OVERHEAD_ALERT_MANA_ADD, self:GetCaster(),self.mana, nil)
            end
            self:GetParent():ReduceMana( self.mana )
            SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_MANA_LOSS, self:GetParent(),self.mana, nil)
end

function modifier_fiends_grip_debuff:OnRefresh( )
      if IsServer()  then
            self.pfx1 = ParticleManager:CreateParticle("particles/tgp/claw_m.vpcf", PATTACH_CUSTOMORIGIN,nil)
            ParticleManager:SetParticleControl(self.pfx1, 0,self:GetParent():GetAbsOrigin())
            ParticleManager:SetParticleControl(self.pfx1, 1,Vector(self.dis,0,0))
            ParticleManager:SetParticleControl(self.pfx1, 2,Vector(self:GetRemainingTime(),0,0))
            ParticleManager:SetParticleControl(self.pfx1, 60,Vector(112,35,35))
            ParticleManager:SetParticleControl(self.pfx1, 61,Vector(1,0,0))
            self:AddParticle( self.pfx1, false, false, -1, false, false )
      end
end


function modifier_fiends_grip_debuff:OnDestroy( )
            StopSoundOn( "Hero_Bane.FiendsGrip.Cast",  self:GetCaster() )
            StopSoundOn( "Hero_Bane.FiendsGrip",  self:GetParent() )
end

function modifier_fiends_grip_debuff:CheckState()
    return
    {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    }
end

function modifier_fiends_grip_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_fiends_grip_debuff:GetOverrideAnimation()
    return ACT_DOTA_FLAIL_STATUE
end

function modifier_fiends_grip_debuff:OnDeath(tg)
        if IsServer() then
                if  tg.unit:IsRealHero() and tg.unit~=self:GetParent() and TG_Distance(tg.unit:GetAbsOrigin(),self:GetParent():GetAbsOrigin())<self.dis  then
                        self:SetDuration(self:GetRemainingTime()+self.interval, true )
                        ParticleManager:SetParticleControl(self.pfx1, 2,Vector(self:GetRemainingTime(),0,0))
                end
        end
end
