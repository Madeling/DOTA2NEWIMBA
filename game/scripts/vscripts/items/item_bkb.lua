item_bkb=class({})
LinkLuaModifier("modifier_item_bkb_pa", "items/item_bkb.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bkb_buff", "items/item_bkb.lua", LUA_MODIFIER_MOTION_NONE)

function item_bkb:OnSpellStart()
    self.caster=self.caster or self:GetCaster()
    self.caster:EmitSound("DOTA_Item.BlackKingBar.Activate")
    self.caster:Purge(false,true,false,false,false)
    if  self.caster.item_bkbdur==nil then
        self.caster.item_bkbdur=0
    end
    if self.caster.item_bkbdur<3 then
        self.caster.item_bkbdur= self.caster.item_bkbdur+1
    end
    self:SetLevel(self.caster.item_bkbdur)
    self.caster:AddNewModifier(self.caster, self, "modifier_item_bkb_buff", {duration=self:GetSpecialValueFor("dur")})

end

function item_bkb:GetIntrinsicModifierName()
    return "modifier_item_bkb_pa"
end

modifier_item_bkb_pa=class({})


function modifier_item_bkb_pa:IsHidden()
    return true
end

function modifier_item_bkb_pa:IsPurgable()
    return false
end

function modifier_item_bkb_pa:IsPurgeException()
    return false
end

function modifier_item_bkb_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS
	}
end

function modifier_item_bkb_pa:OnCreated()
    self.ability=self:GetAbility()
    if not  self.ability then
		return
    end
    self.str=self.ability:GetSpecialValueFor( "str" )
    self.att=self.ability:GetSpecialValueFor( "att" )
    self.mana=self.ability:GetSpecialValueFor("mana")
end

function modifier_item_bkb_pa:GetModifierBonusStats_Strength()
    return  self.str
end

function modifier_item_bkb_pa:GetModifierPreAttack_BonusDamage()
    return self.att
end

function modifier_item_bkb_pa:GetModifierManaBonus()
    return self.mana
end

modifier_item_bkb_buff=class({})


function modifier_item_bkb_buff:IsHidden()
    return false
end

function modifier_item_bkb_buff:IsPurgable()
    return false
end

function modifier_item_bkb_buff:IsPurgeException()
    return false
end

function modifier_item_bkb_buff:GetTexture()
    return "item_black_king_bar"
end

function modifier_item_bkb_buff:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_item_bkb_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_bkb_buff:OnCreated()
    if self:GetAbility() == nil then
		return
	end
    self.MR=self:GetAbility():GetSpecialValueFor( "mr" )
end

function modifier_item_bkb_buff:OnRefresh()
    self:OnCreated()
end


function modifier_item_bkb_buff:CheckState()
    return
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end

function modifier_item_bkb_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_item_bkb_buff:GetModifierMagicalResistanceBonus()
    return self.MR
end

function modifier_item_bkb_buff:GetModifierModelScale()
    return 70
end