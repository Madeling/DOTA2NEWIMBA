plague_world=class({})

LinkLuaModifier("modifier_plague_world_pa", "heros/hero_undying/plague_world.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_plague_world_debuff", "heros/hero_undying/plague_world.lua", LUA_MODIFIER_MOTION_NONE)


function plague_world:GetIntrinsicModifierName()
    return "modifier_plague_world_pa"
end

modifier_plague_world_pa = class({})

function modifier_plague_world_pa:IsPassive()
    return true
end

function modifier_plague_world_pa:IsHidden()
   return false
end

function modifier_plague_world_pa:IsPurgable()
   return false
end

function modifier_plague_world_pa:IsPurgeException()
   return false
end

function modifier_plague_world_pa:AllowIllusionDuplicate()
   return false
end

function modifier_plague_world_pa:IsAura()
   if self:GetParent():PassivesDisabled() then
       return false
   else
       return true
   end
end

function modifier_plague_world_pa:GetAuraDuration()
   return 0
end

function modifier_plague_world_pa:GetModifierAura()
   return "modifier_plague_world_debuff"
end

function modifier_plague_world_pa:GetAuraRadius()
   return 600
end

function modifier_plague_world_pa:GetAuraSearchFlags()
   return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_plague_world_pa:GetAuraSearchTeam()
   return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_plague_world_pa:GetAuraSearchType()
   return DOTA_UNIT_TARGET_HERO
end


modifier_plague_world_debuff = class({})

function modifier_plague_world_debuff:IsDebuff()
   return true
end

function modifier_plague_world_debuff:IsHidden()
   return false
end

function modifier_plague_world_debuff:IsPurgable()
   return false
end

function modifier_plague_world_debuff:IsPurgeException()
   return false
end

function modifier_plague_world_debuff:GetEffectName()
   return "particles/units/heroes/hero_omniknight/omniknight_degen_aura_debuff.vpcf"
end

function modifier_plague_world_debuff:GetEffectAttachType()
   return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_plague_world_debuff:DeclareFunctions()
   return
   {
      MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
      MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
   }
end


function modifier_plague_world_debuff:GetModifierMoveSpeedBonus_Percentage()
   return -40
end

function modifier_plague_world_debuff:GetModifierAttackSpeedBonus_Constant()
   return  0-self:GetParent():GetLevel()*5
end
