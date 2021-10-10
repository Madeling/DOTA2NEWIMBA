untouchable=untouchable or class({})
LinkLuaModifier("modifier_untouchable", "heros/hero_enchantress/untouchable.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_untouchable_debuff", "heros/hero_enchantress/untouchable.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_untouchable_buff", "heros/hero_enchantress/untouchable.lua", LUA_MODIFIER_MOTION_NONE)
function untouchable:GetIntrinsicModifierName()
    return "modifier_untouchable"
end

modifier_untouchable =  class({})

function modifier_untouchable:IsPassive()
	return true
end


function modifier_untouchable:IsPurgable()
    return false
end

function modifier_untouchable:IsPurgeException()
    return false
end

function modifier_untouchable:IsHidden()
    return true
end

function modifier_untouchable:OnCreated(tg)
    if IsServer() then
        if not self:GetAbility() then
            return
        end
        self.ability=self:GetAbility()
        self.parent=self:GetParent()
        self.team=self.parent:GetTeamNumber()
        self.T=self.ability:GetSpecialValueFor("t")
        self.chance=self.ability:GetSpecialValueFor("chance")
        self.dis=self.ability:GetSpecialValueFor("dis")
    end
end

function modifier_untouchable:OnRefresh(tg)
    self:OnCreated( tg )
end

function modifier_untouchable:OnAttackStart(tg)
    if not IsServer() then
		return
	end
    if tg.target == self.parent and not self.parent:IsIllusion() then
        if ( self.parent:PassivesDisabled() and not self.parent:TG_HasTalent("special_bonus_enchantress_7")  ) or tg.attacker:IsBuilding() or  tg.attacker:IsMagicImmune() or tg.attacker==self.parent then
		    return
        end
                tg.attacker:AddNewModifier(self.parent, self.ability, "modifier_untouchable_debuff", {duration=5})
                if RollPseudoRandomPercentage(self.chance,0,self.parent) then
                self.parent:AddNewModifier(self.parent, self.ability, "modifier_untouchable_buff", {duration=2})
                local Knockback =
                {
                    should_stun =  self.T,
                    knockback_duration =  self.T,
                    duration =  self.T,
                    knockback_distance = self.dis,
                    knockback_height = 100,
                    center_x =  tg.target:GetAbsOrigin().x,
                    center_y =  tg.target:GetAbsOrigin().y,
                    center_z =  tg.target:GetAbsOrigin().z
                }
                tg.attacker:AddNewModifier_RS(self.parent, self.ability, "modifier_knockback", Knockback)
        end
    end
end

function modifier_untouchable:OnDeath(tg)
	if IsServer() then
        if tg.unit ==self.parent and not self.parent:IsIllusion() and self.parent:TG_HasTalent("special_bonus_enchantress_8")  then
            for a=1,#CDOTA_PlayerResource.TG_HERO do
                    if CDOTA_PlayerResource.TG_HERO~=nil and #CDOTA_PlayerResource.TG_HERO>0  then
                            if CDOTA_PlayerResource.TG_HERO[a]:GetTeamNumber()==self.parent:GetTeamNumber() then
                                    CDOTA_PlayerResource.TG_HERO[a]:AddNewModifier(self.parent, self.ability, "modifier_untouchable_buff", {duration=7})
                            end
                    end
            end
        end
    end
end

function modifier_untouchable:DeclareFunctions()
	return
    {
    MODIFIER_EVENT_ON_ATTACK_START,
    MODIFIER_EVENT_ON_DEATH
    }
end


modifier_untouchable_debuff= class({})
function modifier_untouchable_debuff:IsDebuff()
    return true
end

function modifier_untouchable_debuff:IsPurgable()
    return false
end

function modifier_untouchable_debuff:IsPurgeException()
    return false
end

function modifier_untouchable_debuff:IsHidden()
    return false
end

function modifier_untouchable_debuff:OnCreated()
    self.attsp=self:GetAbility():GetSpecialValueFor("attsp")*self:GetParent():GetLevel()
end

function modifier_untouchable_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_untouchable_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attsp
end


modifier_untouchable_buff=class({})
function modifier_untouchable_buff:IsPurgable()
    return false
end

function modifier_untouchable_buff:IsPurgeException()
    return false
end

function modifier_untouchable_buff:IsHidden()
    return false
end

function modifier_untouchable_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_untouchable_buff:GetModifierMoveSpeedBonus_Percentage()
	return 30
end