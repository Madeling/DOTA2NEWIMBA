item_bkbs=class({})
LinkLuaModifier("modifier_item_bkbs_pa", "items/item_bkbs.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bkbs_buff", "items/item_bkbs.lua", LUA_MODIFIER_MOTION_NONE)

function item_bkbs:OnSpellStart()
    self.caster=self.caster or self:GetCaster()
    self.caster:EmitSound("DOTA_Item.BlackKingBar.Activate")
    self.caster:Purge(false,true,false,false,false)
    self.caster:AddNewModifier(self.caster, self, "modifier_item_bkbs_buff", {duration=self:GetSpecialValueFor("dur")})
end

function item_bkbs:GetIntrinsicModifierName()
    return "modifier_item_bkbs_pa"
end

modifier_item_bkbs_pa=class({})


function modifier_item_bkbs_pa:IsHidden()
    return true
end

function modifier_item_bkbs_pa:IsPurgable()
    return false
end

function modifier_item_bkbs_pa:IsPurgeException()
    return false
end

function modifier_item_bkbs_pa:OnCreated()
    self.ability=self:GetAbility()
    if not  self.ability then
		return
    end
    self.hp=self.ability:GetSpecialValueFor("hp")
    self.mana=self.ability:GetSpecialValueFor("mana")
end

function modifier_item_bkbs_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS
	}
end

function modifier_item_bkbs_pa:GetModifierHealthBonus()
    return self.hp
end

function modifier_item_bkbs_pa:GetModifierManaBonus()
    return self.mana
end


modifier_item_bkbs_buff=class({})


function modifier_item_bkbs_buff:IsHidden()
    return false
end

function modifier_item_bkbs_buff:IsPurgable()
    return false
end

function modifier_item_bkbs_buff:IsPurgeException()
    return false
end

function modifier_item_bkbs_buff:GetTexture()
    return "item_bkbs"
end

function modifier_item_bkbs_buff:GetEffectName()
    return "particles/tgp/items/bkbs/black_king_bar_avatar_w.vpcf"
end

function modifier_item_bkbs_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_bkbs_buff:OnCreated()
    if self:GetAbility() == nil then
		return
	end
    self.MR=self:GetAbility():GetSpecialValueFor( "mr" )
end

function modifier_item_bkbs_buff:OnRefresh()
    self:OnCreated()
end

function modifier_item_bkbs_buff:CheckState()
    return
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end

function modifier_item_bkbs_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_item_bkbs_buff:GetModifierMagicalResistanceBonus()
    return self.MR
end