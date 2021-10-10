fiery_soul=class({})
LinkLuaModifier("modifier_fiery_soul_pa", "heros/hero_lina/fiery_soul.lua", LUA_MODIFIER_MOTION_NONE)

function fiery_soul:IsHiddenWhenStolen()return false
end
function fiery_soul:IsStealable()return true
end
function fiery_soul:IsRefreshable()return true
end
function fiery_soul:Init()
      self.caster=self:GetCaster()
end
function fiery_soul:OnSpellStart()
      local cpos=self:GetCursorPosition()
      local rd=self:GetSpecialValueFor("rd")
      AddFOWViewer(self.caster:GetTeamNumber(), cpos, rd, 3, true)
      local fx = ParticleManager:CreateParticle("particles/tgp/lina/bird_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
      ParticleManager:SetParticleControl(fx, 0, cpos)
      ParticleManager:SetParticleControl(fx, 1, Vector(rd, 0,0))
      ParticleManager:SetParticleControl(fx, 2, Vector(3, 0,0))
      ParticleManager:ReleaseParticleIndex(fx)
      local dmg=self.caster:GetIntellect()
      local mod=self.caster:FindModifierByName("modifier_fiery_soul_pa")
      if mod and mod:GetStackCount()>0 then
            dmg=dmg*mod:GetStackCount()
            mod:SetStackCount(0)
      end
      self.damageTable =
       {
            attacker = self.caster,
            damage =dmg,
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self,
      }
      EmitSoundOn("Ability.PreLightStrikeArray", self.caster)
       Timers:CreateTimer(0.7, function()
                  local fx2 = ParticleManager:CreateParticle( "particles/heros/axe/shake.vpcf", PATTACH_ABSORIGIN_FOLLOW ,self.caster)
	            ParticleManager:ReleaseParticleIndex(fx2)
                   EmitSoundOn("Hero_Lina.DragonSlave", self.caster)
                  local units=FindUnitsInRadius(self.caster:GetTeamNumber(),cpos,nil,rd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                  if #units>0 then
                              for _,target in pairs(units) do
                                    if not target:IsMagicImmune() then
                                                self.damageTable.victim = target
                                                ApplyDamage(self.damageTable)
                                    end
                              end
                  end
                  return nil
      end)
end
function fiery_soul:GetIntrinsicModifierName()
    return "modifier_fiery_soul_pa"
end

modifier_fiery_soul_pa=class({})
function modifier_fiery_soul_pa:IsHidden()
    return false
end
function modifier_fiery_soul_pa:IsPurgable()
    return false
end
function modifier_fiery_soul_pa:IsPurgeException()
    return false
end
function modifier_fiery_soul_pa:AllowIllusionDuplicate()
    return false
end
function modifier_fiery_soul_pa:OnCreated()
        if not self:GetAbility() then
            return
        end
        self.ability=self:GetAbility()
        self.parent=self:GetParent()
        self.team=self.parent:GetTeamNumber()
        self.fiery_soul_attack_speed_bonus=self.ability:GetSpecialValueFor("fiery_soul_attack_speed_bonus")
        self.fiery_soul_move_speed_bonus=self.ability:GetSpecialValueFor("fiery_soul_move_speed_bonus")
        self.fiery_soul_max_stacks=self.ability:GetSpecialValueFor("fiery_soul_max_stacks")
        self.cast_time=self.ability:GetSpecialValueFor("cast_time")
      self.damageTable =
       {
            attacker = self.parent,
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self.ability,
      }
end
function modifier_fiery_soul_pa:OnRefresh()
       self:OnCreated()
end

function modifier_fiery_soul_pa:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_fiery_soul_pa:OnAbilityFullyCast(tg)
    if not IsServer() then
        return
    end
    if tg.unit == self.parent and not self.parent:IsIllusion() then
            if not tg.ability or tg.ability:IsItem() or tg.ability:IsToggle() then
                  return
            end
            if self:GetStackCount()<self.fiery_soul_max_stacks+self.parent:TG_GetTalentValue("special_bonus_lina_1") then
                  self:IncrementStackCount()
            end
    end
end

function modifier_fiery_soul_pa:GetModifierAttackSpeedBonus_Constant()
    if (self:GetStack()) then
            return  self.fiery_soul_attack_speed_bonus*self:GetStackCount()
    end
            return 0
end

function modifier_fiery_soul_pa:GetModifierMoveSpeedBonus_Percentage()
    if (self:GetStack()) then
            return  self.fiery_soul_move_speed_bonus*self:GetStackCount()
    end
            return 0
end

function modifier_fiery_soul_pa:GetModifierPercentageCasttime()
            if (self:GetStack()) then
                        return  self.cast_time*self:GetStackCount()
            end
                        return 0
end

function modifier_fiery_soul_pa:GetModifierCastRangeBonusStacking()
    if self.parent:TG_HasTalent("special_bonus_lina_3") then
            if (self:GetStack()) then
                        return  40*self:GetStackCount()
            end
                        return 0
    end
                        return 0
end

function modifier_fiery_soul_pa:OnDeath(tg)
        if IsServer() then
                if   tg.unit == self.parent  and not self.parent:IsIllusion() then
                        self:SetStackCount(0)
                end
        end
end

function modifier_fiery_soul_pa:OnAttackLanded(tg)
            if not IsServer() then
                  return
            end
            if tg.attacker == self.parent  and not tg.target:IsBuilding() and not self.parent:IsIllusion() and  self.parent:TG_HasTalent("special_bonus_lina_4")   then
                        self.damageTable.victim = tg.target
                        self.damageTable.damage = self.parent:GetIntellect()*0.4
                        ApplyDamage(self.damageTable)
            end
end

function modifier_fiery_soul_pa:GetStack()
     local stack=self:GetStackCount()
     if stack~=nil and stack>0 then
            return true
      end
            return false
end
