enchant= class({})
LinkLuaModifier("modifier_enchant_buff", "heros/hero_enchantress/enchant.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enchant_bkb_buff", "heros/hero_enchantress/enchant.lua", LUA_MODIFIER_MOTION_NONE)
function enchant:IsHiddenWhenStolen()
    return false
end

function enchant:IsStealable()
    return true
end


function enchant:IsRefreshable()
    return true
end

function enchant:CastFilterResultTarget(target)
	if (not target:IsNeutralUnitType()  and not target:IsHero()) or  target:IsIllusion()  then
		return UF_FAIL_CUSTOM
	end
end

function enchant:GetCustomCastErrorTarget(target)
    return "只能对野怪，英雄使用"
end

function enchant:OnSpellStart()
	local caster = self:GetCaster()
    local target= self:GetCursorTarget()
    local dur=self:GetSpecialValueFor("dur")
    local unit=target
    caster:EmitSound("Hero_Enchantress.EnchantCreep")
    if target:IS_TrueHero_TG() then
        if  target:TG_TriggerSpellAbsorb(self)   then
            return
        end
        target:AddNewModifier_RS(caster, self, "modifier_confuse", {duration=self:GetSpecialValueFor("durhero")})
    elseif target:IsNeutralUnitType()  and not target:IsBoss() and not target:IsAncient() then
        for a=0,2 do
            unit=CreateUnitByName(target:GetUnitName(), target:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
            unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
            unit:AddNewModifier(caster, self, "modifier_kill", {duration = dur})
            unit:AddNewModifier(caster, self, "modifier_enchant_buff", {duration=dur})
            if  caster:TG_HasTalent("special_bonus_enchantress_6") then
                        unit:AddNewModifier(caster, self, "modifier_enchant_bkb_buff", {duration=dur})
            end
        end
    end
end

modifier_enchant_buff=class({})


function modifier_enchant_buff:IsPurgable()
    return false
end

function modifier_enchant_buff:IsPurgeException()
    return false
end

function modifier_enchant_buff:IsHidden()
    return false
end

function modifier_enchant_buff:OnCreated()
    self.ATT=self:GetAbility():GetSpecialValueFor("att")*self:GetCaster():GetLevel()
    self.AR=self:GetAbility():GetSpecialValueFor("ar")
	if not IsServer() then
		return
    end
    self:GetParent():Interrupt()
    self:GetParent():Stop()
end


function modifier_enchant_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end

function modifier_enchant_buff:GetModifierPhysicalArmorBonus()
    return  self.AR
end

function modifier_enchant_buff:GetModifierPreAttack_BonusDamage()
	return self.ATT
end


function modifier_enchant_buff:CheckState()
	return
	 {
		   [MODIFIER_STATE_DOMINATED] = true,
	}
end


modifier_enchant_bkb_buff=class({})
function modifier_enchant_bkb_buff:IsHidden()
    return true
end

function modifier_enchant_bkb_buff:IsPurgable()
    return false
end

function modifier_enchant_bkb_buff:IsPurgeException()
    return false
end

function modifier_enchant_bkb_buff:GetTexture()
    return "item_black_king_bar"
end

function modifier_enchant_bkb_buff:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_enchant_bkb_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_enchant_bkb_buff:CheckState()
    return
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end
