skewer=class({})
LinkLuaModifier("modifier_skewer_buff", "heros/hero_magnataur/skewer.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_skewer_buff1", "heros/hero_magnataur/skewer.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_skewer_debuff", "heros/hero_magnataur/skewer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skewer_cd", "heros/hero_magnataur/skewer.lua", LUA_MODIFIER_MOTION_NONE)
function skewer:IsHiddenWhenStolen()return false
end
function skewer:IsStealable()return true
end
function skewer:IsRefreshable()return true
end
function skewer:Init()
      self.caster=self:GetCaster()
end
function skewer:GetCastPoint()
    if self.caster:TG_HasTalent("special_bonus_magnataur_3") then
        return 0
    else
        return 0.2
    end
end
function skewer:OnAbilityPhaseStart()
      EmitSoundOn("Hero_Magnataur.skewer.Cast", self.caster)
      self.caster:StartGesture(ACT_DOTA_MAGNUS_SKEWER_START)
        local cur_pos=self:GetCursorPosition()
      local caster_pos=self.caster:GetAbsOrigin()
      local dir=TG_Direction(cur_pos,caster_pos)
      self.caster:SetForwardVector(dir)
      return true
end
function skewer:OnAbilityPhaseInterrupted()
      StopSoundOn("Hero_Magnataur.skewer.Cast", self.caster)
      self.caster:RemoveGesture(ACT_DOTA_MAGNUS_SKEWER_START)
      return true
end
function skewer:OnSpellStart()
      local cur_pos=self:GetCursorPosition()
      local caster_pos=self.caster:GetAbsOrigin()
      local skewer_speed=self:GetSpecialValueFor( "skewer_speed" )
       local dur=self:GetSpecialValueFor( "dur" )
      local range=self:GetSpecialValueFor( "range" )
      local dis=TG_Distance(caster_pos,cur_pos)
      dis=dis>range and range or dis
      local dir=TG_Direction(cur_pos,caster_pos)
      local time=dis/skewer_speed
      if self:GetAutoCastState() then
            if self.caster:HasModifier("modifier_skewer_buff") then
                  self.caster:RemoveModifierByName("modifier_skewer_buff")
            end
            self.caster:AddNewModifier(self.caster, self, "modifier_skewer_buff1", {duration=dur,pos=dir})
      else
            if self.caster:HasModifier("modifier_skewer_buff1") then
                  self.caster:RemoveModifierByName("modifier_skewer_buff1")
            end
            self.caster:AddNewModifier(self.caster, self, "modifier_skewer_buff", {duration= time,pos=dir})
      end
end

modifier_skewer_buff=class({})
function modifier_skewer_buff:IsHidden()
    return false
end
function modifier_skewer_buff:IsPurgable()
    return false
end
function modifier_skewer_buff:IsPurgeException()
    return false
end
function modifier_skewer_buff:RemoveOnDeath()
    return false
end
function modifier_skewer_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_skewer_buff:GetEffectName()
    return "particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf"
end
function modifier_skewer_buff:OnCreated(tg)
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.team=self.parent:GetTeamNumber()
    self.skewer_speed=self.ability:GetSpecialValueFor( "skewer_speed" )
    self.range=self.ability:GetSpecialValueFor( "range" )
    self.skewer_radius=self.ability:GetSpecialValueFor( "skewer_radius" )
    self.skewer_damage=self.ability:GetSpecialValueFor( "skewer_damage" )
    self.damageTable = {
		attacker = self.parent,
		damage_type =DAMAGE_TYPE_MAGICAL,
		ability = self.ability,
		}
    if not self.ability then
            return
    end
    if not IsServer() then
        return
    end
    self.ENEMY={}
    self.DIR=ToVector(tg.pos)
   self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_3)
    if not self:ApplyHorizontalMotionController()then
	      self:Destroy()
    end
end
function modifier_skewer_buff:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end
    if self.parent:IsStunned()  then
            self:Destroy()
            return
      end
      if self.parent:IsAlive() then
                  local heros = FindUnitsInRadius(
                  self.team,
                  self.parent:GetAbsOrigin(),
                  nil,
                  self.skewer_radius,
                  DOTA_UNIT_TARGET_TEAM_ENEMY,
                  DOTA_UNIT_TARGET_HERO,
                  DOTA_UNIT_TARGET_FLAG_NONE,
                  FIND_CLOSEST,
                  false)
                  if #heros>0 then
                        for _, hero in pairs(heros) do
                              if not Is_DATA_TG( self.ENEMY,hero) then
                                    table.insert(self.ENEMY,hero)
                                    hero:AddNewModifier(self.parent, self.ability, "modifier_skewer_debuff", {duration=self:GetRemainingTime()})
                              end
                                    hero:SetAbsOrigin(self.parent:GetAbsOrigin()+self.parent:GetForwardVector()*150)
                        end
                  end
            self.parent:SetAbsOrigin(self.parent:GetAbsOrigin()+self.DIR* (self.skewer_speed / (1.0 / g)))
      end
end
function modifier_skewer_buff:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end
function modifier_skewer_buff:OnDestroy()
    if not IsServer() then
        return
    end
    self.parent:RemoveHorizontalMotionController(self)
     self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_3)
      self.parent:ForcePlayActivityOnce(ACT_DOTA_MAGNUS_SKEWER_END)
      for _, unit in pairs(self.ENEMY) do
            if unit~=nil and IsValidEntity(unit) and unit:IsAlive() then
                        if unit:HasModifier("modifier_skewer_debuff") then
                              unit:RemoveModifierByName("modifier_skewer_debuff")
                        end
                        FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
                    self.damageTable.victim = unit
                    self.damageTable.damage = self.skewer_damage
                    ApplyDamage(self.damageTable)
            end
      end
end
function modifier_skewer_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
        MODIFIER_PROPERTY_DISABLE_TURNING,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_skewer_buff:GetModifierIgnoreCastAngle()
   return 1
end
function modifier_skewer_buff:GetModifierDisableTurning()
    return 1
end
function modifier_skewer_buff:GetModifierIncomingDamage_Percentage()
    if self.parent:TG_HasTalent("special_bonus_magnataur_6") then
        return -30
    else
        return 0
    end
end
function modifier_skewer_buff:CheckState()
        return
        {
            [MODIFIER_STATE_DISARMED] = true,
               [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        }
end

modifier_skewer_debuff=class({})
function modifier_skewer_debuff:IsHidden()
    return true
end
function modifier_skewer_debuff:IsPurgable()
    return false
end
function modifier_skewer_debuff:IsPurgeException()
    return false
end
function modifier_skewer_debuff:RemoveOnDeath()
    return false
end
function modifier_skewer_debuff:CheckState()
        return
        {
            [MODIFIER_STATE_STUNNED] = true,
            [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        }
end

modifier_skewer_buff1=class({})
function modifier_skewer_buff1:IsHidden()
    return false
end
function modifier_skewer_buff1:IsPurgable()
    return false
end
function modifier_skewer_buff1:IsPurgeException()
    return false
end
function modifier_skewer_buff1:RemoveOnDeath()
    return false
end
function modifier_skewer_buff1:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_skewer_buff1:GetEffectName()
    return "particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf"
end

function modifier_skewer_buff1:OnCreated(tg)
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.team=self.parent:GetTeamNumber()
    self.skewer_speed=self.ability:GetSpecialValueFor( "skewer_speed" )
    self.range=self.ability:GetSpecialValueFor( "range" )
    self.skewer_radius=self.ability:GetSpecialValueFor( "skewer_radius" )
    self.skewer_damage=self.ability:GetSpecialValueFor( "skewer_damage" )
    if not self.ability then
            return
    end
    if not IsServer() then
        return
    end
    self.DIR=ToVector(tg.pos)
   self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_3)
    if not self:ApplyHorizontalMotionController()then
	      self:Destroy()
    end
end
function modifier_skewer_buff1:CheckState()
        return
        {
            [MODIFIER_STATE_DISARMED] = true,
             [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        }
end
function modifier_skewer_buff1:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
        MODIFIER_PROPERTY_DISABLE_TURNING,
        MODIFIER_EVENT_ON_ORDER,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_skewer_buff1:OnOrder(tg)
        if not IsServer() then
            return
        end
        if tg.unit==self.parent  then
            if  tg.order_type == DOTA_UNIT_ORDER_HOLD_POSITION or   tg.order_type == DOTA_UNIT_ORDER_STOP then
                self:Destroy()
            end
            if ( tg.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION  or tg.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE ) and not self.parent:HasModifier("modifier_skewer_cd") then
                  self.parent:AddNewModifier(self.parent, self.ability, "modifier_skewer_cd", {duration=0.15})
                  local dis=TG_Distance(self.parent:GetAbsOrigin(),tg.new_pos)
                  dis=dis>self.range and self.range or dis
                  local dir=TG_Direction(tg.new_pos,self.parent:GetAbsOrigin())
                  if self.parent:HasModifier("modifier_skewer_buff1") then
                        self.parent:RemoveModifierByName("modifier_skewer_buff1")
                  end
                  self.parent:SetForwardVector(dir)
                  self.parent:AddNewModifier(self.parent, self.ability, "modifier_skewer_buff1", {duration=self:GetRemainingTime(),pos=dir})
            end
        end
end
function modifier_skewer_buff1:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end
function modifier_skewer_buff1:OnDestroy()
    if not IsServer() then
        return
    end
    self.parent:RemoveHorizontalMotionController(self)
     self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_3)
      self.parent:ForcePlayActivityOnce(ACT_DOTA_MAGNUS_SKEWER_END)
end
function modifier_skewer_buff1:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end
    if self.parent:IsStunned()  then
            self:Destroy()
            return
      end
      if self.parent:IsAlive() then
            self.parent:SetAbsOrigin(self.parent:GetAbsOrigin()+self.DIR* (self.skewer_speed / (1.0 / g)))
      end
end
function modifier_skewer_buff1:GetModifierIgnoreCastAngle()
   return 1
end
function modifier_skewer_buff1:GetModifierDisableTurning()
    return 1
end
function modifier_skewer_buff1:GetModifierIncomingDamage_Percentage()
    if self.parent:TG_HasTalent("special_bonus_magnataur_6") then
        return -30
    else
        return 0
    end
end

modifier_skewer_cd=class({})
function modifier_skewer_cd:IsHidden()
    return true
end
function modifier_skewer_cd:IsPurgable()
    return false
end
function modifier_skewer_cd:IsPurgeException()
    return false
end
function modifier_skewer_cd:RemoveOnDeath()
    return false
end