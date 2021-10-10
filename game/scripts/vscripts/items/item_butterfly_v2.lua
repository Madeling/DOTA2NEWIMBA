item_butterfly_v2=class({})
LinkLuaModifier("modifier_item_butterfly_v2_pa", "items/item_butterfly_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_butterfly_v2_buff", "items/item_butterfly_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_butterfly_v2_debuff", "items/item_butterfly_v2.lua", LUA_MODIFIER_MOTION_NONE)
function item_butterfly_v2:GetIntrinsicModifierName()
    return "modifier_item_butterfly_v2_pa"
end

function item_butterfly_v2:IsRefreshable()
    return true
end

function item_butterfly_v2:OnSpellStart()
    self.caster=self.caster or self:GetCaster()
    self.caster:EmitSound("DOTA_Item.Butterfly")
    self.caster:AddNewModifier(self.caster, self, "modifier_item_butterfly_v2_buff", {duration=self:GetSpecialValueFor("dur") })
end

modifier_item_butterfly_v2_pa=class({})

function modifier_item_butterfly_v2_pa:IsPassive()return true
end
function modifier_item_butterfly_v2_pa:IsDebuff()return false
end
function modifier_item_butterfly_v2_pa:IsHidden()return true
end
function modifier_item_butterfly_v2_pa:IsPurgable()return false
end
function modifier_item_butterfly_v2_pa:IsPurgeException()return false
end
function modifier_item_butterfly_v2_pa:GetAttributes()return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_butterfly_v2_pa:OnCreated()
    self.ability=self:GetAbility()
    if not  self.ability then
		return
    end
    self.bonus_agility= self.ability:GetSpecialValueFor("bonus_agility")
    self.bonus_evasion= self.ability:GetSpecialValueFor("bonus_evasion")
    self.bonus_attack_speed= self.ability:GetSpecialValueFor("bonus_attack_speed")
    self.bonus_damage= self.ability:GetSpecialValueFor("bonus_damage")
end

function modifier_item_butterfly_v2_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_EVASION_CONSTANT

    }
end

function modifier_item_butterfly_v2_pa:GetModifierEvasion_Constant()return self.bonus_evasion
end
function modifier_item_butterfly_v2_pa:GetModifierBonusStats_Agility()return self.bonus_agility
end
function modifier_item_butterfly_v2_pa:GetModifierAttackSpeedBonus_Constant()return self.bonus_attack_speed
end
function modifier_item_butterfly_v2_pa:GetModifierPreAttack_BonusDamage()return self.bonus_damage
end


modifier_item_butterfly_v2_buff=class({})

function modifier_item_butterfly_v2_buff:IsHidden()return false
end
function modifier_item_butterfly_v2_buff:IsPurgable()return true
end
function modifier_item_butterfly_v2_buff:IsPurgeException() return true
end
function modifier_item_butterfly_v2_buff:GetEffectAttachType()return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_item_butterfly_v2_buff:GetEffectName()
    return "particles/econ/courier/courier_shagbark/courier_shagbark_butterflies.vpcf"
end

function modifier_item_butterfly_v2_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_DODGE_PROJECTILE,
        MODIFIER_EVENT_ON_ATTACK_START
    }
end

function modifier_item_butterfly_v2_buff:OnCreated()
    self.ability,self.parent=self:GetAbility(),self:GetParent()
    if not  self.ability then
		return
    end
    self.sp= self.ability:GetSpecialValueFor("sp")
    if IsServer() then
        local particle = ParticleManager:CreateParticle("particles/tgp/items/butterfly/butterfly_buff_m.vpcf", PATTACH_ABSORIGIN_FOLLOW,self.parent)
        ParticleManager:SetParticleControl(particle,0,self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle,60,Vector(140,0,255))
        ParticleManager:SetParticleControl(particle,61,Vector(1,0,0))
        self:AddParticle(particle, false, false, 1, false, false)
    end
end

function modifier_item_butterfly_v2_buff:OnAttackStart(tg)
    if IsServer() then
        if tg.attacker==self.parent then
            tg.target:AddNewModifier(self.parent, self.ability, "modifier_item_butterfly_v2_debuff", {duration=3})
        end
    end
end


function modifier_item_butterfly_v2_buff:GetModifierDodgeProjectile()
    if RollPseudoRandomPercentage(100,0,self.parent) then
        return 1
    else
        return 0
    end
end

function modifier_item_butterfly_v2_buff:GetModifierMoveSpeedBonus_Percentage()return  self.sp
end

modifier_item_butterfly_v2_debuff=class({})

function modifier_item_butterfly_v2_debuff:IsHidden()return true
end
function modifier_item_butterfly_v2_debuff:IsPurgable()return false
end
function modifier_item_butterfly_v2_debuff:IsPurgeException()return false
end
function modifier_item_butterfly_v2_debuff:GetModifierNoVisionOfAttacker()return 1
end

function modifier_item_butterfly_v2_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_DONT_GIVE_VISION_OF_ATTACKER,
    }
end
