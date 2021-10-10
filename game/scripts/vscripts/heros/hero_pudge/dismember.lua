dismember=class({})
LinkLuaModifier("modifier_dismember_buff", "heros/hero_pudge/dismember.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dismember_debuff", "heros/hero_pudge/dismember.lua", LUA_MODIFIER_MOTION_NONE)
function dismember:IsHiddenWhenStolen()return false
end
function dismember:IsStealable() return true
end
function dismember:IsRefreshable()return true
end
function dismember:GetConceptRecipientType() return DOTA_SPEECH_USER_ALL
end
function dismember:SpeakTrigger() return DOTA_ABILITY_SPEAK_START_ACTION_PHASE
end
function dismember:Init()
      self.caster=self:GetCaster()
end
function dismember:OnSpellStart()
	local target = self:GetCursorTarget()
	if target:TG_TriggerSpellAbsorb(self) then
             self:EndChannel(true)
             self.caster:Interrupt()
		return
	end
	target:AddNewModifier(self.caster, self, "modifier_dismember_debuff", {duration = self:GetSpecialValueFor("duration_tooltip") })
      if self.caster:TG_HasTalent("special_bonus_pudge_5") then
            local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            if  #enemies>0 then
                  for _,unit in pairs(enemies) do
                        if unit~=target then
                              	unit:AddNewModifier(self.caster, self, "modifier_dismember_debuff", {duration = self:GetSpecialValueFor("duration_tooltip") })
                                    return
                        end
                  end
            end
      end
end
function dismember:OnChannelFinish(bInterrupted)
    if not  bInterrupted then
            self.caster:AddNewModifier(self.caster, self, "modifier_dismember_buff", {duration = self:GetSpecialValueFor("duration") })
    end
end
modifier_dismember_buff=class({})
function modifier_dismember_buff:IsPurgable()return false
end
function modifier_dismember_buff:IsPurgeException()return false
end
function modifier_dismember_buff:OnCreated( tg )
      self.ability=self:GetAbility()
      if not self.ability then
            return
      end
      self.parent=self:GetParent()
      self.caster=self:GetCaster()
      self.team=self.parent:GetTeamNumber()
      self.rs=self.ability:GetSpecialValueFor("rs")
      self.sp=self.ability:GetSpecialValueFor("sp")
      self.num=self.ability:GetSpecialValueFor("num")
      self.dmg=0
	if IsServer() then
                   local fx = ParticleManager:CreateParticle( "particles/econ/items/pudge/pudge_arcana/default/pudge_arcana_dismember_bloom_default.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
			ParticleManager:SetParticleControl( fx, 0, self.parent:GetAbsOrigin())
                  self:AddParticle(fx, true, false, 1, false, false)
                  local fx2 = ParticleManager:CreateParticle( "particles/heros/axe/shake.vpcf", PATTACH_ABSORIGIN_FOLLOW ,self.parent)
	            ParticleManager:ReleaseParticleIndex(fx2)
                  EmitSoundOn("Hero_Pudge.Eject.Persona",  self.parent)
            self.caster:SetRenderColor(255, 0, 0)
	end
end
function modifier_dismember_buff:OnRefresh( tg )
	if IsServer() then
                  local fx2 = ParticleManager:CreateParticle( "particles/heros/axe/shake.vpcf", PATTACH_ABSORIGIN_FOLLOW ,self.parent)
	            ParticleManager:ReleaseParticleIndex(fx2)
                  EmitSoundOn("Hero_Pudge.Eject.Persona",  self.parent)
	end
end
function modifier_dismember_buff:OnDestroy()
	if IsServer() then
                  self.caster:SetRenderColor(255,255,255)
	end
end
function modifier_dismember_buff:DeclareFunctions()
      return
      {
            MODIFIER_PROPERTY_MODEL_SCALE,
            MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
      }
end
function modifier_dismember_buff:GetModifierModelScale()
	return 30
end
function modifier_dismember_buff:GetModifierStatusResistanceStacking()
    return  self.rs
end
function modifier_dismember_buff:GetModifierMoveSpeedBonus_Percentage()
    return self.sp
end
function modifier_dismember_buff:GetModifierAttackSpeedBonus_Constant()
      if self.caster:TG_HasTalent("special_bonus_pudge_6") then
            return 90
      end
      return 0
end

modifier_dismember_debuff=class({})
function modifier_dismember_debuff:IsDebuff()return true
end
function modifier_dismember_debuff:IsPurgable()return false
end
function modifier_dismember_debuff:IsPurgeException()return false
end
function modifier_dismember_debuff:OnCreated( tg )
      self.ability=self:GetAbility()
      if not self.ability then
            return
      end
      self.parent=self:GetParent()
      self.caster=self:GetCaster()
      self.team=self.parent:GetTeamNumber()
      self.ticks=self.ability:GetSpecialValueFor("ticks")
      self.dismember_damage=self.ability:GetSpecialValueFor("dismember_damage")
      self.strength_damage=self.ability:GetSpecialValueFor("strength_damage")
      self.damageTable={
			victim = self.parent,
			attacker = self.caster,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self.ability,

	}
	if IsServer() then
                  local fx = ParticleManager:CreateParticle( "particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_motor.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( fx, 0, self.parent:GetAbsOrigin())
                  ParticleManager:SetParticleControlEnt(fx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
                  ParticleManager:SetParticleControl( fx, 2, Vector(1000,1000,1000))
                  for a=3,4 do
                  ParticleManager:SetParticleControl( fx, a, self.parent:GetAbsOrigin())
	            end
                  ParticleManager:SetParticleControl( fx, 6,Vector(1000,0,0))
                  self:AddParticle(fx, true, false, 1, false, false)
            self:StartIntervalThink(self.ticks)
	end
end
function modifier_dismember_debuff:OnIntervalThink()
      if not self.ability or not self.ability:IsChanneling() then
            self:StartIntervalThink(-1)
		self:Destroy()
		return
	end
      local dmg=self.dismember_damage+self.caster:GetStrength()*self.strength_damage
      self.caster:Heal(dmg, self)
      SendOverheadEventMessage(self.caster, OVERHEAD_ALERT_HEAL, self.caster,dmg, nil)
      self.damageTable.damage = dmg
	ApplyDamage(self.damageTable)
end
function modifier_dismember_debuff:CheckState()
	return
      {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function modifier_dismember_debuff:DeclareFunctions()
	return
       {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_dismember_debuff:GetOverrideAnimation( )
	return ACT_DOTA_FLAIL
end