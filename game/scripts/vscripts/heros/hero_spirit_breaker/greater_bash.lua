greater_bash=class({})

LinkLuaModifier("modifier_greater_bash_att", "heros/hero_spirit_breaker/greater_bash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_greater_bash_sp_buff", "heros/hero_spirit_breaker/greater_bash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_greater_bash_sp_debuff", "heros/hero_spirit_breaker/greater_bash.lua", LUA_MODIFIER_MOTION_NONE)
function greater_bash:GetIntrinsicModifierName()
    return "modifier_greater_bash_att"
end

modifier_greater_bash_att=class({})

function modifier_greater_bash_att:IsPassive()
	return true
end

function modifier_greater_bash_att:IsPurgable()
    return false
end

function modifier_greater_bash_att:IsPurgeException()
    return false
end

function modifier_greater_bash_att:IsHidden()
    return true
end

function modifier_greater_bash_att:DeclareFunctions()
	return
    {
	    MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_greater_bash_att:OnCreated()
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.chance_pct=self.ability:GetSpecialValueFor("chance_pct")
    self.damage=self.ability:GetSpecialValueFor("damage")
    self.duration=self.ability:GetSpecialValueFor("duration")
    self.knockback_duration=self.ability:GetSpecialValueFor("knockback_duration")
    self.knockback_distance=self.ability:GetSpecialValueFor("knockback_distance")
    self.knockback_height=self.ability:GetSpecialValueFor("knockback_height")
    self.sp=self.ability:GetSpecialValueFor("sp")
    self.dur=self.ability:GetSpecialValueFor("dur")
    self.Knockback={
        should_stun = true,
        knockback_duration = self.knockback_duration,
        duration = self.duration,
    }
    self.Knockback1={
        should_stun = true,
        knockback_duration = self.knockback_duration,
        duration = self.duration,
        knockback_height=100,
        knockback_distance=0,
    }
    self.damageTable = {
		attacker = self.parent,
		damage_type =DAMAGE_TYPE_MAGICAL,
		ability = self.ability,
		}
end

function modifier_greater_bash_att:OnRefresh()
   self:OnCreated()
end


function modifier_greater_bash_att:OnAttackLanded(tg)
    if not IsServer() then
        return
	end

    if tg.attacker == self.parent then
        if self.parent:PassivesDisabled() or self.parent:IsIllusion() or not self.ability:IsCooldownReady() or tg.target:IsBuilding() then
            return
        end
        if RollPseudoRandomPercentage(self.chance_pct+ self.parent:TG_GetTalentValue("special_bonus_spirit_breaker_4"),DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1 ,self.parent) then
            self.ability:UseResources(false, false, true)
            local tpos = tg.target:GetAbsOrigin()
            local cpos = self.parent:GetAbsOrigin()
            local dir = TG_Direction(tpos,cpos)
            local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf" , PATTACH_CENTER_FOLLOW,tg.target)
            ParticleManager:SetParticleControl(particle, 0, tpos)
            ParticleManager:SetParticleControl(particle, 1, tpos)
            ParticleManager:SetParticleControl(particle, 2, tpos)
            ParticleManager:ReleaseParticleIndex(particle)
            EmitSoundOn("Hero_Spirit_Breaker.GreaterBash", tg.target)
            if self.caster:TG_HasTalent("special_bonus_spirit_breaker_3") then
                self.Knockback1.center_x = tpos.x
                self.Knockback1.center_y = tpos.y
                self.Knockback1.center_z = tpos.z
                tg.target:AddNewModifier_RS(self.parent,self.ability, "modifier_knockback", self.Knockback1)
            else
                self.Knockback.knockback_height = self.knockback_height
                self.Knockback.knockback_distance = self.knockback_distance
                self.Knockback.center_x = cpos.x-dir.x
                self.Knockback.center_y = cpos.y-dir.y
                self.Knockback.center_z = cpos.z
                if tg.target:HasModifier("modifier_knockback") then
                    tg.target:RemoveModifierByName("modifier_knockback")
                end
                tg.target:AddNewModifier_RS(self.parent,self.ability, "modifier_knockback", self.Knockback)
            end
                tg.target:AddNewModifier_RS(self.parent,self.ability, "modifier_greater_bash_sp_debuff",{duration=self.dur,sp=self.sp})
                self.parent:AddNewModifier(self.parent,self.ability, "modifier_greater_bash_sp_buff", {duration=self.dur,sp=self.sp})
                self.damageTable.victim = tg.target
                self.damageTable.damage = self.parent:GetMoveSpeedModifier(self.parent:GetBaseMoveSpeed(), true)*(self.damage+self.parent:TG_GetTalentValue("special_bonus_spirit_breaker_5"))*0.01
                ApplyDamage(self.damageTable)
        end
	end
end


modifier_greater_bash_sp_debuff=class({})

function modifier_greater_bash_sp_debuff:IsDebuff()
	return true
end

function modifier_greater_bash_sp_debuff:IsPurgable()
    return false
end

function modifier_greater_bash_sp_debuff:IsPurgeException()
    return true
end

function modifier_greater_bash_sp_debuff:IsHidden()
    return false
end

function modifier_greater_bash_sp_debuff:OnCreated(tg)
    if IsServer() then
        self:SetStackCount(self:GetStackCount()+tg.sp)
    end
end

function modifier_greater_bash_sp_debuff:OnRefresh(tg)
    self:OnCreated(tg)
end

function modifier_greater_bash_sp_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_greater_bash_sp_debuff:GetModifierMoveSpeedBonus_Constant()
    return 0-self:GetStackCount()
end


modifier_greater_bash_sp_buff=class({})

function modifier_greater_bash_sp_buff:IsDebuff()
	return false
end

function modifier_greater_bash_sp_buff:IsPurgable()
    return false
end

function modifier_greater_bash_sp_buff:IsPurgeException()
    return false
end

function modifier_greater_bash_sp_buff:IsHidden()
    return false
end

function modifier_greater_bash_sp_buff:OnCreated(tg)
    if IsServer() then
        self:SetStackCount(self:GetStackCount()+tg.sp)
    end
end

function modifier_greater_bash_sp_buff:OnRefresh(tg)
    self:OnCreated(tg)
end

function modifier_greater_bash_sp_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end



function modifier_greater_bash_sp_buff:GetModifierMoveSpeedBonus_Constant()
    return self:GetStackCount()
end

function modifier_greater_bash_sp_buff:GetModifierIgnoreMovespeedLimit()
    return 1
end