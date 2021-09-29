chilling_touch= class({})

LinkLuaModifier("modifier_chilling_touch_att", "heros/hero_ancient_apparition/chilling_touch.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chilling_touch_debuff", "heros/hero_ancient_apparition/chilling_touch.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chilling_touch_f", "heros/hero_ancient_apparition/chilling_touch.lua", LUA_MODIFIER_MOTION_NONE)

function chilling_touch:GetIntrinsicModifierName()
    return "modifier_chilling_touch_att"
end

function chilling_touch:GetManaCost(iLevel)
    if self:GetCaster():TG_HasTalent("special_bonus_ancient_apparition_5") then
        return 0
    else
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end

modifier_chilling_touch_att=class({})

function modifier_chilling_touch_att:IsPassive()
	return true
end

function modifier_chilling_touch_att:IsPurgable()
    return false
end

function modifier_chilling_touch_att:IsPurgeException()
    return false
end

function modifier_chilling_touch_att:IsHidden()
    return false
end

function modifier_chilling_touch_att:GetModifierProjectileName()
    if self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() or not self:GetAbility():IsOwnersManaEnough() then
        return ""
    end
    return  "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf"
end


function modifier_chilling_touch_att:DeclareFunctions()
	return {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_PROJECTILE_NAME,
    MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
end


function modifier_chilling_touch_att:OnCreated()
    self.ATTR=self:GetAbility():GetSpecialValueFor("attr")
    self.DAM=self:GetAbility():GetSpecialValueFor("dam")
end

function modifier_chilling_touch_att:OnRefresh()
   self:OnCreated()
end


function modifier_chilling_touch_att:GetModifierAttackRangeBonus()
    return self.ATTR+self:GetParent():TG_GetTalentValue("special_bonus_ancient_apparition_4")
end



function modifier_chilling_touch_att:OnAttackLanded(tg)
    if not IsServer() then
        return
	end

    if tg.attacker == self:GetParent() then
        if self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() or not self:GetAbility():IsOwnersManaEnough() then
            return
        end
        self:GetAbility():UseResources(true, false, false)
        local dam=self:GetParent():TG_GetTalentValue("special_bonus_ancient_apparition_3")
        if tg.target:IsBuilding() then
                dam=self:GetParent():Has_Aghanims_Shard() or self.DAM*0.2 and self.DAM*0.1
            else
                dam=(self:GetParent():HasModifier("modifier_cold_feet_buff") or self:GetParent():HasModifier("modifier_ice_blast_buff")) and self.DAM*2 or self.DAM
        end

        if tg.target:GetAbsOrigin().z<=0 and self:GetParent():TG_HasTalent("special_bonus_ancient_apparition_8") then
            tg.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_chilling_touch_f", {duration=0.15})
        end
		local damage= {
            victim = tg.target,
            attacker = self:GetParent(),
            damage = dam,
            damage_type = self:GetCaster():TG_HasTalent("special_bonus_ancient_apparition_7") and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
            }
        ApplyDamage(damage)
		EmitSoundOn("Hero_Ancient_Apparition.ChillingTouch.Target", tg.target)
	end
end


modifier_chilling_touch_f=class({})

function modifier_chilling_touch_f:IsPurgable()
    return true
end

function modifier_chilling_touch_f:IsPurgeException()
    return true
end

function modifier_chilling_touch_f:IsHidden()
    return true
end

function modifier_chilling_touch_f:IsDebuff()
    return true
end


function modifier_chilling_touch_f:CheckState()
    return
    {
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_STUNNED]=true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED]=true,
    }
end
