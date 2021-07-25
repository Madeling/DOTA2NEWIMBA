CreateTalents("npc_dota_hero_drow_ranger", "heros/hero_drow_ranger/frost_arrows.lua")
frost_arrows=class({})

LinkLuaModifier("modifier_frost_arrows", "heros/hero_drow_ranger/frost_arrows.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frost_arrows_debuff1", "heros/hero_drow_ranger/frost_arrows.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frost_arrows_debuff2", "heros/hero_drow_ranger/frost_arrows.lua", LUA_MODIFIER_MOTION_NONE)

function frost_arrows:GetIntrinsicModifierName()
    return "modifier_frost_arrows"
end

modifier_frost_arrows = class({})

function modifier_frost_arrows:IsPassive()
	return true
end

function modifier_frost_arrows:IsPurgable()
    return false
end

function modifier_frost_arrows:IsPurgeException()
    return false
end

function modifier_frost_arrows:IsHidden()
    return true
end


function modifier_frost_arrows:OnCreated()
  self.DUR=self:GetAbility():GetSpecialValueFor("sp")
  self.DUR2=self:GetAbility():GetSpecialValueFor("stun")
  self.CH=self:GetAbility():GetSpecialValueFor("ch")
  self.dam=self:GetAbility():GetSpecialValueFor("damage")
  self.ch1=self:GetAbility():GetSpecialValueFor("ch1")
  self.rd1=self:GetAbility():GetSpecialValueFor("rd1")
end
function modifier_frost_arrows:OnRefresh()
    self:OnCreated()
  end

function modifier_frost_arrows:OnAttackLanded(tg)
	if not IsServer() then
		return
	end

    if tg.attacker == self:GetParent()  then
        if  tg.target:IsOther() or tg.target:IsBuilding() then
            return
        end
        if not tg.target:IsMagicImmune()  then
            tg.target:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_frost_arrows_debuff1", {duration=self.DUR})
            if tg.target:HasModifier("wave_of_silence") then
                self.CH=self.CH+self.ch1
            end
            if self:GetParent():HasScepter() then
                local heros = FindUnitsInRadius(
                    self:GetParent():GetTeamNumber(),
                    tg.target:GetAbsOrigin(),
                    nil,
                    self.rd1,
                    DOTA_UNIT_TARGET_TEAM_ENEMY,
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_NONE,
                    FIND_ANY_ORDER,false)
                    if #heros>0 then
                        for _, hero in pairs(heros) do
                                if  not tg.target:IsMagicImmune() or self:GetParent():TG_HasTalent("special_bonus_drow_ranger_1") then
                                    local damage= {
                                        victim = hero,
                                        attacker = self:GetParent(),
                                        damage = self.dam+self:GetCaster():TG_GetTalentValue("special_bonus_drow_ranger_7"),
                                        damage_type = self:GetParent():TG_HasTalent("special_bonus_drow_ranger_2") and DAMAGE_TYPE_PURE or DAMAGE_TYPE_PHYSICAL,
                                        ability = self:GetAbility(),
                                        }
                                    ApplyDamage(damage)
                                end
                        end
                    end
                else
                    if  not tg.target:IsMagicImmune() or self:GetParent():TG_HasTalent("special_bonus_drow_ranger_1") then
                        local damage= {
                            victim = tg.target,
                            attacker = self:GetParent(),
                            damage = self.dam+self:GetCaster():TG_GetTalentValue("special_bonus_drow_ranger_7"),
                            damage_type = self:GetParent():TG_HasTalent("special_bonus_drow_ranger_2") and DAMAGE_TYPE_PURE or DAMAGE_TYPE_PHYSICAL,
                            ability = self:GetAbility(),
                            }
                        ApplyDamage(damage)
                    end
                end
---------------------------------------------------------------------------------------------------------------------------------------
                if PseudoRandom:RollPseudoRandom(self:GetAbility(),  self.CH) then
                        if self:GetParent():HasModifier("modifier_marksmanship") then
                            local heros = FindUnitsInRadius(
                                self:GetParent():GetTeamNumber(),
                                tg.target:GetAbsOrigin(),
                                nil,
                                self.rd1,
                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_ANY_ORDER,false)
                                if #heros>0 then
                                    for _, hero in pairs(heros) do
                                        if  not hero:IsMagicImmune() then
                                        hero:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_frost_arrows_debuff2", {duration=self.DUR2})
                                        end
                                    end
                                end
                        else
                            tg.target:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_frost_arrows_debuff2", {duration=self.DUR2})
                        end
                end
        end
    end
end

function modifier_frost_arrows:OnAttack(tg)
	if not IsServer() then
		return
	end

    if tg.attacker == self:GetParent()  then
        self:GetParent():EmitSound("Hero_DrowRanger.FrostArrows")
    end
end

function modifier_frost_arrows:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end


function modifier_frost_arrows:GetModifierProjectileName()
    return  "particles/units/heroes/hero_drow/drow_frost_arrow.vpcf"
end


modifier_frost_arrows_debuff1= class({})

function modifier_frost_arrows_debuff1:IsDebuff()
	return true
end

function modifier_frost_arrows_debuff1:IsPurgable()
    return true
end

function modifier_frost_arrows_debuff1:IsPurgeException()
    return true
end

function modifier_frost_arrows_debuff1:IsHidden()
    return false
end

function modifier_frost_arrows_debuff1:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_frost_arrows_debuff1:GetEffectName()
    return "particles/units/heroes/hero_drow/drow_hypothermia_counter_debuff.vpcf"
end

function modifier_frost_arrows_debuff1:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end



function modifier_frost_arrows_debuff1:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("frost_arrows_movement_speed")
end


modifier_frost_arrows_debuff2= class({})

function modifier_frost_arrows_debuff2:IsDebuff()
	return true
end

function modifier_frost_arrows_debuff2:IsPurgable()
    return true
end

function modifier_frost_arrows_debuff2:IsPurgeException()
    return true
end

function modifier_frost_arrows_debuff2:IsHidden()
    return false
end

function modifier_frost_arrows_debuff2:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_frost_arrows_debuff2:GetEffectName()
    return "particles/units/heroes/hero_drow/drow_hypothermia_counter_debuff.vpcf"
end



function modifier_frost_arrows_debuff2:CheckState()
    return
    {
        [MODIFIER_STATE_FROZEN] = true,
        [MODIFIER_STATE_ROOTED]=true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED]=true,
    }
end