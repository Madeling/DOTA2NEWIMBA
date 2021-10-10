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
  self.ability=self:GetAbility()
  self.parent=self:GetParent()
  self.team=self.parent:GetTeamNumber()
  self.DUR=self.ability:GetSpecialValueFor("sp")
  self.DUR2=self.ability:GetSpecialValueFor("stun")
  self.CH=self.ability:GetSpecialValueFor("ch")
  self.dam=self.ability:GetSpecialValueFor("damage")
  self.rd1=self.ability:GetSpecialValueFor("rd1")
  self.damageTable =
       {
            attacker = self.parent,
            ability = self.ability,
      }
      self.eatt=false
end
function modifier_frost_arrows:OnRefresh()
    self:OnCreated()
end
function modifier_frost_arrows:OnAttackStart(tg)
	if not IsServer() then
		return
	end
    if tg.attacker == self.parent and  not self.parent:IsIllusion() then
                 self.eatt=true
    end
end

function modifier_frost_arrows:OnAttackLanded(tg)
	if not IsServer() then
		return
	end
    if tg.attacker == self.parent and  not self.parent:IsIllusion()  and not tg.target:IsBuilding() and not self.parent:PassivesDisabled() then
        if  not tg.target:IsMagicImmune() or self.parent:TG_HasTalent("special_bonus_drow_ranger_1") then
                            self.damageTable.damage =self.dam+self.parent:TG_GetTalentValue("special_bonus_drow_ranger_7")
                            self.damageTable.damage_type =self.parent:TG_HasTalent("special_bonus_drow_ranger_2") and DAMAGE_TYPE_PURE or DAMAGE_TYPE_PHYSICAL
                            self.damageTable.victim=tg.target
                            ApplyDamage(self.damageTable)
                            tg.target:AddNewModifier_RS(self.parent, self.ability, "modifier_frost_arrows_debuff1", {duration=self.DUR})
                            if  RollPseudoRandomPercentage(self.CH, 0, self.parent) then
                                    tg.target:AddNewModifier_RS(self.parent, self.ability, "modifier_frost_arrows_debuff2", {duration=self.DUR})
                            end
        end
    end
end

function modifier_frost_arrows:OnAttack(tg)
	if not IsServer() then
		return
	end
    if tg.attacker == self.parent  and  not self.parent:IsIllusion() then
        self.parent:EmitSound("Hero_DrowRanger.FrostArrows")
        if self.eatt==true and self.parent:HasModifier("modifier_marksmanship")  then
         self.eatt = false
          local heros = FindUnitsInRadius(
                    self.team,
                    tg.target:GetAbsOrigin(),
                    nil,
                    self.rd1,
                    DOTA_UNIT_TARGET_TEAM_ENEMY,
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                    FIND_ANY_ORDER,false)
                    if #heros>0 then
                        for _, hero in pairs(heros) do
                                if  hero~=tg.target then
                                           self.parent:PerformAttack(hero, false, true, true, false, true, false, true)
                                           return
                                end
                        end
                    end
        end
    end
end

function modifier_frost_arrows:OnAttackFail(tg)
        if not IsServer() then
            return
        end
        if tg.attacker == self.parent and  not self.parent:IsIllusion() then
           self.eatt= false
        end
end

function modifier_frost_arrows:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_ATTACK_FAIL
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