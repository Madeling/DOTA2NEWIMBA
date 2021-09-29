item_red_cape = class({})

LinkLuaModifier("modifier_item_red_cape_pa", "items/item_red_cape.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_red_cape_buff", "items/item_red_cape.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_red_cape_mr", "items/item_red_cape.lua", LUA_MODIFIER_MOTION_NONE)

function item_red_cape:CastFilterResultTarget(target)
	if target:IsIllusion() or (IsServer() and not Is_Chinese_TG(self:GetCaster(),target)) or target:IsBuilding() then
		return UF_FAIL_CUSTOM
	end
end

function item_red_cape:GetCustomCastErrorTarget(target)
    return "不能对其使用"
end

function item_red_cape:OnSpellStart()
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local duration=self:GetSpecialValueFor("dur")
    caster:EmitSound( "Item.GlimmerCape.Activate" )
    if Is_Chinese_TG(caster,target) then
    if target:IS_TrueHero_TG() or target:IsCreep() or target:IsCreature() or target:IsCourier() or target:IsOther() then
        caster:AddNewModifier( caster, self, "modifier_item_red_cape_buff", {duration=duration})
        target:AddNewModifier( caster, self, "modifier_item_red_cape_buff", {duration=duration})
        caster:AddNewModifier( caster, self, "modifier_item_red_cape_mr", {duration=duration})
        target:AddNewModifier( caster, self, "modifier_item_red_cape_mr", {duration=duration})
    end
end
end

function item_red_cape:GetIntrinsicModifierName()
    return "modifier_item_red_cape_pa"
end


modifier_item_red_cape_pa=class({})

function modifier_item_red_cape_pa:IsHidden()
    return true
end

function modifier_item_red_cape_pa:IsPurgable()
    return false
end

function modifier_item_red_cape_pa:IsPurgeException()
    return false
end

function modifier_item_red_cape_pa:OnCreated()
    self.mr=self:GetAbility():GetSpecialValueFor("mr")
    self.attsp=self:GetAbility():GetSpecialValueFor("attsp")
end

function modifier_item_red_cape_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_item_red_cape_pa:GetModifierMagicalResistanceBonus()
    return  self.mr
end

function modifier_item_red_cape_pa:GetModifierAttackSpeedBonus_Constant()
    return  self.attsp
end

modifier_item_red_cape_buff=class({})


function modifier_item_red_cape_buff:IsHidden()
    return false
end

function modifier_item_red_cape_buff:IsPurgable()
    return true
end

function modifier_item_red_cape_buff:IsPurgeException()
    return true
end

function modifier_item_red_cape_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_red_cape_buff:GetEffectName()
    return "particles/items3_fx/glimmer_cape_initial.vpcf"
end

function modifier_item_red_cape_buff:GetTexture()
    return "item_red_cape"
end

function modifier_item_red_cape_buff:CheckState()
    return
    {
        [MODIFIER_STATE_INVISIBLE] = true,
    }
end

function modifier_item_red_cape_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end


function modifier_item_red_cape_buff:GetModifierInvisibilityLevel()
    return 1
end

function modifier_item_red_cape_buff:OnCreated()
    if not IsServer() then
        return
    end
    self:GetParent():Purge(false,true,false,false,false)
 end



function modifier_item_red_cape_buff:OnAttackStart(tg)
    if not IsServer() then
        return
    end
    if tg.attacker==self:GetParent() then
        TG_Remove_Modifier(self:GetParent(),"modifier_item_red_cape_mr",0)
    end
end

function modifier_item_red_cape_buff:OnAbilityFullyCast(tg)
    if not IsServer() then
        return
    end

    if tg.unit == self:GetParent() then
        if not tg.ability or tg.ability:IsItem() or tg.ability:IsToggle() then
            return
        end
            TG_Remove_Modifier(self:GetParent(),"modifier_item_red_cape_mr",0)
    end
end

modifier_item_red_cape_mr=class({})

function modifier_item_red_cape_mr:IsBuff()
    return true
end

function modifier_item_red_cape_mr:IsHidden()
    return false
end

function modifier_item_red_cape_mr:IsPurgable()
    return true
end

function modifier_item_red_cape_mr:IsPurgeException()
    return true
end

function modifier_item_red_cape_mr:GetTexture()
    return "item_red_cape"
end

function modifier_item_red_cape_mr:RemoveOnDeath()
    return true
end

function modifier_item_red_cape_mr:OnCreated()
   self.active_mr=self:GetAbility():GetSpecialValueFor("active_mr")
end

function modifier_item_red_cape_mr:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
end


function modifier_item_red_cape_mr:GetModifierMagicalResistanceBonus()
    return self.active_mr
end