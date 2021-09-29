prot=class({})
LinkLuaModifier("modifier_prot_toggle", "heros/hero_pudge/prot.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_prot_debuff", "heros/hero_pudge/prot.lua", LUA_MODIFIER_MOTION_NONE)
function prot:IsHiddenWhenStolen()return false
end
function prot:IsStealable() return true
end
function prot:IsRefreshable()return true
end
function prot:GetCastRange(vLocation, hTarget)
	return  self:GetSpecialValueFor("rot_radius")
end
function prot:Init()
      self.caster=self:GetCaster()
end
function prot:OnToggle()
	if self:GetToggleState() then
			EmitSoundOn("Hero_Pudge.Rot",  self.caster)
		       self.caster:AddNewModifier( self.caster, self, "modifier_prot_toggle", {})
	else
			StopSoundOn("Hero_Pudge.Rot",  self.caster)
                  if  self.caster:HasModifier("modifier_prot_toggle") then
		            self.caster:RemoveModifierByName("modifier_prot_toggle")
                  end
	end
end

modifier_prot_toggle=class({})
function modifier_prot_toggle:IsPurgable()return false
end
function modifier_prot_toggle:IsPurgeException()return false
end
function modifier_prot_toggle:IsHidden()return false
end
function modifier_prot_toggle:RemoveOnDeath()return true
end
function modifier_prot_toggle:IsAura() return true
end
function modifier_prot_toggle:GetModifierAura() return "modifier_prot_debuff"
end
function modifier_prot_toggle:GetAuraRadius() return self.rot_radius or 0
end
function modifier_prot_toggle:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_prot_toggle:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_prot_toggle:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_prot_toggle:OnCreated()
      self.ability=self:GetAbility()
	self.parent=self:GetParent()
      if not self.ability then
            return
      end
	self.rot_radius=self.ability:GetSpecialValueFor("rot_radius")
	self.rot_tick=self.ability:GetSpecialValueFor("rot_tick")
      self.rot_damage=self.ability:GetSpecialValueFor("rot_damage")
      self.cd=self.ability:GetSpecialValueFor("cd")
      self.rd=self.ability:GetSpecialValueFor("rd")
      self.damageTable={
			victim = self.parent,
			attacker = self.parent,
			damage_type = DAMAGE_TYPE_MAGICAL,
                  damage = self.rot_damage,
			ability = self.ability,
	}
      if IsServer() then
            self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+DOTA_DAMAGE_FLAG_REFLECTION
            self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.rot_radius, 0, 0))
		self:AddParticle(self.pfx, false, false, 15, false, false)
            if not self.parent:Has_Aghanims_Shard() then
                  self:StartIntervalThink(self.rot_tick)
            end
      end
end
function modifier_prot_toggle:OnIntervalThink()
	ApplyDamage(self.damageTable)
end


modifier_prot_debuff=class({})
function modifier_prot_debuff:IsDebuff()return true
end
function modifier_prot_debuff:IsPurgable()return false
end
function modifier_prot_debuff:IsPurgeException()return false
end
function modifier_prot_debuff:IsHidden()return false
end
function modifier_prot_debuff:OnCreated()
      self.ability=self:GetAbility()
	self.parent=self:GetParent()
      self.caster=self:GetCaster()
      if not self.ability then
            return
      end
	self.rot_slow=self.ability:GetSpecialValueFor("rot_slow")
      self.rot_damage=self.ability:GetSpecialValueFor("rot_damage")
      self.rot_tick=self.ability:GetSpecialValueFor("rot_tick")
      self.maxstack=self.ability:GetSpecialValueFor("maxstack")
      self.rd=self.ability:GetSpecialValueFor("rd")
      self.hp=self.ability:GetSpecialValueFor("hp")*0.01
      self.damageTable={
			victim = self.parent,
			attacker = self.caster,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self.ability,
	}
      if IsServer() then
            self:StartIntervalThink(self.rot_tick)
      end
end
function modifier_prot_debuff:OnIntervalThink()
      self.damageTable.damage=self.rot_damage
	ApplyDamage(self.damageTable)
      if self.parent:IsHero() then
            local stack=self.caster:GetModifierStackCount("modifier_prot_toggle", self.caster)
            if stack>=self.maxstack then
                  local units=FindUnitsInRadius(self.caster:GetTeamNumber(),self.caster:GetAbsOrigin(),nil,self.rd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
                  if #units>0 then
                    for _,target in pairs(units) do
                            if not target:IsMagicImmune() then
                                    local pfx = ParticleManager:CreateParticle("particles/tgp/pudge/fart_m.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
                                    ParticleManager:SetParticleControl(pfx, 0,target:GetAbsOrigin())
                                    ParticleManager:ReleaseParticleIndex(pfx)
                                    self.damageTable.damage=self.caster:GetMaxHealth()*self.hp
                                    ApplyDamage(self.damageTable)
                            end
                    end
                end
                  stack=0
            end
                  stack=stack+1
                  self.caster:SetModifierStackCount("modifier_prot_toggle",self.caster,stack)
      end
end
function modifier_prot_debuff:DeclareFunctions()
      return
      {
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
            MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
            MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
      }
end
function modifier_prot_debuff:GetModifierMoveSpeedBonus_Percentage() return  self.rot_slow or 0
end
function modifier_prot_debuff:GetModifierHealAmplify_PercentageTarget()
      if self.caster:TG_HasTalent("special_bonus_pudge_4") then
            return  -15
      end
      return 0
end

function modifier_prot_debuff:GetModifierHPRegenAmplify_Percentage()
      if self.caster:TG_HasTalent("special_bonus_pudge_4") then
            return -15
      end
      return 0
end
function modifier_prot_debuff:CheckState()
      if self.caster:TG_HasTalent("special_bonus_pudge_3") then
	return
      {
		[MODIFIER_STATE_EVADE_DISABLED] = true,
	}
      end
      return{}
end