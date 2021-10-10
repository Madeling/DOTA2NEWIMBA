corrosive_skin=class({})

LinkLuaModifier("modifier_corrosive_skin_pa", "heros/hero_viper/corrosive_skin.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_corrosive_skin_debuff", "heros/hero_viper/corrosive_skin.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_corrosive_skin_buff", "heros/hero_viper/corrosive_skin.lua", LUA_MODIFIER_MOTION_NONE)
function corrosive_skin:GetIntrinsicModifierName()
    return "modifier_corrosive_skin_pa"
end

function corrosive_skin:OnSpellStart()
    local caster=self:GetCaster()
    EmitSoundOn("hero_viper.Nethertoxin.Cast",caster)
    caster:AddNewModifier(caster, self, "modifier_corrosive_skin_buff", {duration=self:GetSpecialValueFor("dursp")+caster:TG_GetTalentValue("special_bonus_viper_4")})
end

modifier_corrosive_skin_buff=class({})


function modifier_corrosive_skin_buff:IsPurgable()
    return false
end

function modifier_corrosive_skin_buff:IsPurgeException()
    return false
end

function modifier_corrosive_skin_buff:IsHidden()
    return false
end

function modifier_corrosive_skin_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_corrosive_skin_buff:GetEffectName()
    return "particles/econ/courier/courier_roshan_ti8/courier_roshan_ti8.vpcf"
end


function modifier_corrosive_skin_buff:OnCreated()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.bonus_magic_resistance=self.ability:GetSpecialValueFor("bonus_magic_resistance")
end

function modifier_corrosive_skin_buff:OnRefresh()
   self:OnCreated()
end

function modifier_corrosive_skin_buff:DeclareFunctions()
	return
        {
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	    }
end

function modifier_corrosive_skin_buff:GetModifierMoveSpeedBonus_Percentage(tg)
    return (self.bonus_magic_resistance+self.parent:TG_GetTalentValue("special_bonus_viper_3"))*2
end

function modifier_corrosive_skin_buff:CheckState()
    return
    {
          [MODIFIER_STATE_FLYING] = true,
      }
end

modifier_corrosive_skin_pa=class({})

function modifier_corrosive_skin_pa:IsPassive()
	return true
end

function modifier_corrosive_skin_pa:IsPurgable()
    return false
end

function modifier_corrosive_skin_pa:IsPurgeException()
    return false
end

function modifier_corrosive_skin_pa:IsHidden()
    return true
end

function modifier_corrosive_skin_pa:AllowIllusionDuplicate()
    return false
end

function modifier_corrosive_skin_pa:DeclareFunctions()
	return
        {
            MODIFIER_EVENT_ON_TAKEDAMAGE,
            MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	    }
end

function modifier_corrosive_skin_pa:GetModifierMagicalResistanceBonus(tg)
    if self.parent and self.parent:HasModifier("modifier_corrosive_skin_buff") then
        return 0
    end
    return self.bonus_magic_resistance+self.parent:TG_GetTalentValue("special_bonus_viper_3")
end

function modifier_corrosive_skin_pa:OnCreated()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.bonus_magic_resistance=self.ability:GetSpecialValueFor("bonus_magic_resistance")
    self.duration=self.ability:GetSpecialValueFor("duration")
end

function modifier_corrosive_skin_pa:OnRefresh()
   self:OnCreated()
end


function modifier_corrosive_skin_pa:OnTakeDamage(tg)
    if not IsServer() then
        return
	end

    if tg.unit == self.parent and tg.attacker~=self.parent then
        if self.parent:PassivesDisabled() or self.parent:IsIllusion() or tg.attacker:IsBuilding() then
            return
        end
        tg.attacker:AddNewModifier_RS(self.parent, self.ability, "modifier_corrosive_skin_debuff", {duration=self.duration+self.parent:TG_GetTalentValue("special_bonus_viper_4")})
	end
end


modifier_corrosive_skin_debuff=class({})

function modifier_corrosive_skin_debuff:IsDebuff()
    return true
end

function modifier_corrosive_skin_debuff:IsPurgable()
    return true
end

function modifier_corrosive_skin_debuff:IsPurgeException()
    return true
end

function modifier_corrosive_skin_debuff:IsHidden()
    return false
end

function modifier_corrosive_skin_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_corrosive_skin_debuff:GetEffectName()
    return "particles/units/heroes/hero_viper/viper_corrosive_debuff.vpcf"
end


function modifier_corrosive_skin_debuff:OnCreated()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.caster=self:GetCaster()
    self.damage=self.ability:GetSpecialValueFor("damage")
    self.bonus_attack_speed=self.ability:GetSpecialValueFor("bonus_attack_speed")
    if IsServer() then
        self:StartIntervalThink(1)
    end
end


function modifier_corrosive_skin_debuff:OnIntervalThink()
    local damage= {
        victim = self.parent,
        attacker = self.caster,
        damage = self.damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self.ability,
        }
    ApplyDamage(damage)
end


function modifier_corrosive_skin_debuff:DeclareFunctions()
	return
        {
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	    }
end

function modifier_corrosive_skin_debuff:GetModifierAttackSpeedBonus_Constant(tg)
    return 0-self.bonus_attack_speed
end
