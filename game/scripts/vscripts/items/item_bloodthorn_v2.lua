item_bloodthorn_v2 = class({})

LinkLuaModifier("modifier_item_bloodthorn_v2_pa", "items/item_bloodthorn_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bloodthorn_v2_debuff", "items/item_bloodthorn_v2.lua", LUA_MODIFIER_MOTION_NONE)

function item_bloodthorn_v2:OnSpellStart()
    self.caster=self.caster or self:GetCaster()
    local target = self:GetCursorTarget()
    local dur = self:GetSpecialValueFor("dur")
    if  target:TG_TriggerSpellAbsorb(self)   then
        return
    end

    if not target:IsMagicImmune() then
        target:EmitSound("DOTA_Item.Bloodthorn.Activate")
        target:AddNewModifier_RS( self.caster,self,"modifier_item_bloodthorn_v2_debuff",{duration=dur})
    end
end


function item_bloodthorn_v2:GetIntrinsicModifierName()
    return "modifier_item_bloodthorn_v2_pa"
end


modifier_item_bloodthorn_v2_pa = class({})

function modifier_item_bloodthorn_v2_pa:IsHidden()
    return true
end

function modifier_item_bloodthorn_v2_pa:IsPurgable()
    return false
end

function modifier_item_bloodthorn_v2_pa:IsPurgeException()
    return false
end

function modifier_item_bloodthorn_v2_pa:AllowIllusionDuplicate()
    return false
end

function modifier_item_bloodthorn_v2_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,

   }
end

function modifier_item_bloodthorn_v2_pa:OnCreated()
    self.parent=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.int=self.ability:GetSpecialValueFor("int")
    self.att=self.ability:GetSpecialValueFor("att")
    self.attsp=self.ability:GetSpecialValueFor("attsp")
    self.mana=self.ability:GetSpecialValueFor("mana")
end

function modifier_item_bloodthorn_v2_pa:GetModifierBonusStats_Intellect()
    return self.int
end

function modifier_item_bloodthorn_v2_pa:GetModifierPreAttack_BonusDamage()
    return self.att
end

function modifier_item_bloodthorn_v2_pa:GetModifierAttackSpeedBonus_Constant()
    return self.attsp
end

function modifier_item_bloodthorn_v2_pa:GetModifierConstantManaRegen()
    return self.mana
end




modifier_item_bloodthorn_v2_debuff =class({})

function modifier_item_bloodthorn_v2_debuff:IsDebuff()
    return true
end

function modifier_item_bloodthorn_v2_debuff:IsHidden()
    return false
end

function modifier_item_bloodthorn_v2_debuff:IsPurgable()
    return true
end

function modifier_item_bloodthorn_v2_debuff:IsPurgeException()
    return true
end


function modifier_item_bloodthorn_v2_debuff:GetEffectName()
    return "particles/items2_fx/orchid.vpcf"
end

function modifier_item_bloodthorn_v2_debuff:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_item_bloodthorn_v2_debuff:ShouldUseOverheadOffset()
    return true
end

function modifier_item_bloodthorn_v2_debuff:CheckState()
    return
    {
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_EVADE_DISABLED] = true,
    }
end

function modifier_item_bloodthorn_v2_debuff:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
   }
end

function modifier_item_bloodthorn_v2_debuff:OnCreated()
        self.ability,self.parent,self.caster=self:GetAbility(),self:GetParent(),self:GetCaster()
        self.dam=0
end

function modifier_item_bloodthorn_v2_debuff:OnTakeDamage(tg)
    if not IsServer() then
        return
    end

    if tg.unit == self.parent and  self.dam then
            self.dam=self.dam+tg.damage
    end
end

function modifier_item_bloodthorn_v2_debuff:OnDestroy()
    if IsServer() then
        if self.dam>0 then
            local pfx = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
            ParticleManager:SetParticleControl(pfx, 1, Vector(1,0,0))
            ParticleManager:SetParticleControl(pfx, 2, Vector(1,0,0))
            ParticleManager:ReleaseParticleIndex(pfx)
            if not self.parent:IsMagicImmune() then
                local damageTable = {
                    victim = self.parent,
                    attacker = self.caster,
                    damage = self.dam*self.ability:GetSpecialValueFor("desdmg")*0.01,
                    damage_type =DAMAGE_TYPE_MAGICAL,
                    ability = self.ability,
                    }
                ApplyDamage(damageTable)
            end
        end
    end
end