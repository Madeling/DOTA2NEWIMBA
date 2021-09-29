item_sheepstick_v2=class({})

LinkLuaModifier("modifier_item_sheepstick_v2_pa", "items/item_sheepstick_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_sheepstick_v2_debuff", "items/item_sheepstick_v2.lua", LUA_MODIFIER_MOTION_NONE)

function item_sheepstick_v2:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local dur = self:GetSpecialValueFor("dur")
    if  target:TG_TriggerSpellAbsorb(self)   then
        return
    end

    if target:IsIllusion() then
        local pfx = ParticleManager:CreateParticle("particles/items_fx/item_sheepstick.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:ReleaseParticleIndex(pfx)
		target:Kill(self, caster)
		return
    end

    if not target:IsMagicImmune() then
        target:EmitSound("DOTA_Item.Sheepstick.Activate")
        if caster:HasAbility("rearm") and not caster:Has_Aghanims_Shard()  then
            dur=1
        end
        target:AddNewModifier(caster, self, "modifier_item_sheepstick_v2_debuff", {duration=dur})
    end
end

function item_sheepstick_v2:GetIntrinsicModifierName()
    return "modifier_item_sheepstick_v2_pa"
end

modifier_item_sheepstick_v2_pa =class({})

function modifier_item_sheepstick_v2_pa:IsHidden()
    return true
end

function modifier_item_sheepstick_v2_pa:IsPurgable()
    return false
end

function modifier_item_sheepstick_v2_pa:IsPurgeException()
    return false
end

function modifier_item_sheepstick_v2_pa:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_sheepstick_v2_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
end

function modifier_item_sheepstick_v2_pa:OnCreated()
    if self:GetAbility() == nil then
		return
	end
    self.str=self:GetAbility():GetSpecialValueFor("str")
    self.agi=self:GetAbility():GetSpecialValueFor("agi")
    self.int=self:GetAbility():GetSpecialValueFor("int")
    self.mana=self:GetAbility():GetSpecialValueFor("mana")
end

function modifier_item_sheepstick_v2_pa:GetModifierBonusStats_Strength()
    return self.str
end

function modifier_item_sheepstick_v2_pa:GetModifierBonusStats_Agility()
    return  self.agi
end

function modifier_item_sheepstick_v2_pa:GetModifierBonusStats_Intellect()
    return self.int
end

function modifier_item_sheepstick_v2_pa:GetModifierConstantManaRegen()
    return self.mana
end

modifier_item_sheepstick_v2_debuff=class({})

function modifier_item_sheepstick_v2_debuff:IsDebuff()
    return true
end

function modifier_item_sheepstick_v2_debuff:IsHidden()
    return false
end

function modifier_item_sheepstick_v2_debuff:IsPurgable()
    return false
end

function modifier_item_sheepstick_v2_debuff:IsPurgeException()
    return true
end


function modifier_item_sheepstick_v2_debuff:OnCreated()
    if self:GetAbility() == nil then
		return
	end
    self.ar=self:GetAbility():GetSpecialValueFor("ar")
    self.mr=self:GetAbility():GetSpecialValueFor("mr")
    if not IsServer() then
        return
    end
    local pfx = ParticleManager:CreateParticle("particles/items_fx/item_sheepstick.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(pfx)

end

function modifier_item_sheepstick_v2_debuff:CheckState()
	return
	{
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_HEXED] = true,
	}
end

function modifier_item_sheepstick_v2_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE
    }
end

function modifier_item_sheepstick_v2_debuff:GetModifierModelChange()
    return "models/items/courier/butch_pudge_dog/butch_pudge_dog.vmdl"
end


function modifier_item_sheepstick_v2_debuff:GetModifierMoveSpeed_Absolute()
    return 100
end

function modifier_item_sheepstick_v2_debuff:GetModifierMagicalResistanceBonus()
    return self.mr
end

function modifier_item_sheepstick_v2_debuff:MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS()
    return self.ar
end
