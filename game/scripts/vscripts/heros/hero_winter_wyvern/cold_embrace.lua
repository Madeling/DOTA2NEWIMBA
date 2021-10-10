cold_embrace=class({})
LinkLuaModifier("modifier_cold_embrace_buff", "heros/hero_winter_wyvern/cold_embrace.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bkb_buff", "items/item_bkb.lua", LUA_MODIFIER_MOTION_NONE)
function cold_embrace:IsHiddenWhenStolen()return false
end
function cold_embrace:IsRefreshable()return true
end
function cold_embrace:IsStealable()return true
end
function cold_embrace:Init()
      self.caster=self:GetCaster()
end
function cold_embrace:OnSpellStart()
       local tar=self:GetCursorTarget()
       EmitSoundOn("Hero_Winter_Wyvern.ColdEmbrace.Cast", self.caster)
       tar:AddNewModifier(self.caster, self, "modifier_cold_embrace_buff", {duration=self:GetSpecialValueFor("duration")})
       for a=1,self:GetSpecialValueFor("num") do
            local unit=CreateUnitByName("npc_wendigo", tar:GetAbsOrigin()+RandomVector(300), true,nil, nil, self.caster:GetTeamNumber())
            unit:AddNewModifier(self.caster, self, "modifier_kill", {duration=self:GetSpecialValueFor("dur")})
      end
end

modifier_cold_embrace_buff=class({})
function modifier_cold_embrace_buff:IsPurgable()return false
end
function modifier_cold_embrace_buff:IsPurgeException()return false
end
function modifier_cold_embrace_buff:GetStatusEffectName()return "particles/status_fx/status_effect_wyvern_cold_embrace.vpcf"
end
function modifier_cold_embrace_buff:StatusEffectPriority()return 4
end
function modifier_cold_embrace_buff:RemoveOnDeath()return true
end
function modifier_cold_embrace_buff:OnCreated()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.pos=self.parent:GetAbsOrigin()
    self.heal_additive=self.ability:GetSpecialValueFor("heal_additive")
    self.heal_percentage=self.ability:GetSpecialValueFor("heal_percentage")*0.01
      local pf1 = ParticleManager:CreateParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
      self:AddParticle(pf1, false, false, 4, false, false)
      if IsServer() then
            EmitSoundOn("Hero_Winter_Wyvern.ColdEmbrace", self.caster)
            self:StartIntervalThink(1)
      end
end
function modifier_cold_embrace_buff:OnRefresh()
      self.heal_additive=self.ability:GetSpecialValueFor("heal_additive")
      self.heal_percentage=self.ability:GetSpecialValueFor("heal_percentage")*0.01
end
function modifier_cold_embrace_buff:OnIntervalThink()
      local hp=self.heal_additive+self.heal_percentage*self.parent:GetMaxHealth()
      if self.ability.caster:Has_Aghanims_Shard() then
            hp=hp*2
      end
      self.parent:Heal(hp, self.ability)
      SendOverheadEventMessage(self.parent, OVERHEAD_ALERT_HEAL, self.parent,hp, nil)
      if self.ability.caster:TG_HasTalent("special_bonus_winter_wyvern_1") then
            self.parent:GiveMana(120)
            SendOverheadEventMessage(self.parent, OVERHEAD_ALERT_MANA_ADD, self.parent,120, nil)
    end
end
function modifier_cold_embrace_buff:OnDestroy()
      if IsServer() then
            if self.ability.caster:TG_HasTalent("special_bonus_winter_wyvern_2") then
                  self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_bkbs_buff", {duration=2})
            end
      end
end
function modifier_cold_embrace_buff:CheckState()
    return
     {
           [MODIFIER_STATE_STUNNED] = true,
           [MODIFIER_STATE_ATTACK_IMMUNE] = true,
           [MODIFIER_STATE_FROZEN] = true,
       }
end
function modifier_cold_embrace_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_cold_embrace_buff:GetModifierMagicalResistanceBonus()
      if self.ability.caster:Has_Aghanims_Shard() then
                  return 50
      end
      return 0
end