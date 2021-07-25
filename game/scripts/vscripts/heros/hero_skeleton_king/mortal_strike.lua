mortal_strike=class({})
LinkLuaModifier("modifier_mortal_strike_pa", "heros/hero_skeleton_king/mortal_strike.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mortal_strike_buff", "heros/hero_skeleton_king/mortal_strike.lua", LUA_MODIFIER_MOTION_NONE)
function mortal_strike:GetIntrinsicModifierName() 
    return "modifier_mortal_strike_pa" 
end

function mortal_strike:GetBehavior()
    if self:GetCaster():TG_HasTalent("special_bonus_skeleton_king_5") then
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET
    else 
        return DOTA_ABILITY_BEHAVIOR_PASSIVE
    end
end

function mortal_strike:GetCooldown(iLevel)
    if self:GetCaster():TG_HasTalent("special_bonus_skeleton_king_5") then
        return 15
    else 
        return 0
    end
end

function mortal_strike:OnSpellStart()
    local caster=self:GetCaster()
    local pos=caster:GetAbsOrigin()+caster:GetForwardVector()*150
    for a=1,6 do 
      local unit = CreateUnitByName("npc_wraith_king_skeleton_warrior",pos, true, caster, caster, caster:GetTeamNumber())
      unit:SetHullRadius(10)
      unit:AddNewModifier(caster, self, "modifier_kill", {duration=10})
      unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
      unit:SetForwardVector(caster:GetForwardVector())
      FindClearSpaceForUnit(unit, pos, false)
    end 
end

modifier_mortal_strike_pa=class({})

function modifier_mortal_strike_pa:IsHidden() 			
    return true 
end

function modifier_mortal_strike_pa:IsPurgable() 			
    return false 
end

function modifier_mortal_strike_pa:IsPurgeException() 	
    return false 
end

function modifier_mortal_strike_pa:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_FAIL,
    }
end

function modifier_mortal_strike_pa:OnCreated() 
    self.crit = {} 
    if not self:GetAbility() then 
        return 
    end
    self.crit_mult=self:GetAbility():GetSpecialValueFor("crit_mult")
    self.ch= self:GetAbility():GetSpecialValueFor("ch")
end

function modifier_mortal_strike_pa:OnRefresh() 
    self:OnCreated() 
end


function modifier_mortal_strike_pa:GetModifierPreAttack_CriticalStrike(tg)
    if not IsServer() or self:GetParent():IsIllusion()  then
		return
	end 
    if tg.attacker == self:GetParent() and not tg.target:IsBuilding() and not self:GetParent():PassivesDisabled() then
    local ch=self:GetParent():HasModifier("modifier_vampiric_aura_buff3") and self.ch+15 or self.ch
        if RollPseudoRandomPercentage(ch,0,self:GetParent()) then
			self:GetParent():EmitSound("Hero_SkeletonKing.CriticalStrike")
            self.crit[tg.record] = true
            if self:GetParent():HasModifier("modifier_hellfire_blast_buff") then 
                if self:GetParent():HasAbility("hellfire_blast") then 
                    local AB=self:GetParent():FindAbilityByName("hellfire_blast")
                    if AB~=nil then 
                        return  self.crit_mult+AB:GetSpecialValueFor("crit")
                    else
                        return  self.crit_mult
                    end
                else
                    return  self.crit_mult
                end
            else 
                return self.crit_mult
            end  
		else
			return 0
		end
	end
end


function modifier_mortal_strike_pa:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
	if tg.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled()  or tg.target:IsBuilding() or not tg.target:IsAlive() then
		return
    end
    if self.crit[tg.record] and tg.target:IsRealHero() then
        TG_Modifier_Num_ADD2({
            target=self:GetParent(),
            caster=self:GetParent(),
            ability=self:GetAbility(),
            modifier="modifier_mortal_strike_buff",
            init=10,
            stack=10,
            duration=self:GetAbility():GetSpecialValueFor("dur")
        })
    end
    self.crit[tg.record] = nil
    end

function modifier_mortal_strike_pa:OnAttackFail(tg) 
        if not IsServer() then
            return
        end
        self.crit[tg.record] = nil
end

function modifier_mortal_strike_pa:OnDestroy() 
        self.crit = nil 
end

modifier_mortal_strike_buff=class({})

function modifier_mortal_strike_buff:IsHidden() 			
    return false 
end

function modifier_mortal_strike_buff:IsPurgable() 			
    return false 
end

function modifier_mortal_strike_buff:IsPurgeException() 	
    return false 
end

function modifier_mortal_strike_buff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
end

function modifier_mortal_strike_buff:OnCreated(tg)				
    if not IsServer() then 
        return
    end
   self:SetStackCount(tg.num)
end

function modifier_mortal_strike_buff:GetModifierBonusStats_Strength()				
    return self:GetStackCount()
end