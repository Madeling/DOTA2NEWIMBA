frostmourne=class({})

LinkLuaModifier("modifier_frostmourne", "heros/hero_abaddon/frostmourne.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frostmourne_stack", "heros/hero_abaddon/frostmourne.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frostmourne_debuff", "heros/hero_abaddon/frostmourne.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frostmourne_buff", "heros/hero_abaddon/frostmourne.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frostmourne_call", "heros/hero_abaddon/frostmourne.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frostmourne_cd", "heros/hero_abaddon/frostmourne.lua", LUA_MODIFIER_MOTION_NONE)
function frostmourne:GetIntrinsicModifierName()
    return "modifier_frostmourne"
end

modifier_frostmourne=class({})

function modifier_frostmourne:IsPassive()
	return true
end

function modifier_frostmourne:IsPurgable()
    return false
end

function modifier_frostmourne:IsPurgeException()
    return false
end

function modifier_frostmourne:IsHidden()
    return true
end

function modifier_frostmourne:DeclareFunctions()
	return
    {
	    MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end


function modifier_frostmourne:OnCreated()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    if not self.ability then
        return
    end
    self.hit_count=self.ability:GetSpecialValueFor("hit_count")
    self.slow_duration=self.ability:GetSpecialValueFor("slow_duration")
    self.ch=self.ability:GetSpecialValueFor("ch")
    self.hp=self.ability:GetSpecialValueFor("hp")*0.01
    self.curse_duration=self.ability:GetSpecialValueFor("curse_duration")
    self.trigger=false
end

function modifier_frostmourne:OnRefresh()
   self:OnCreated()
end

function modifier_frostmourne:OnAttackLanded(tg)
    if not IsServer() then
        return
	end

    if tg.attacker == self.parent then
        if self.parent:PassivesDisabled() or self.parent:IsIllusion() or tg.target:IsBuilding() or tg.target:IsMagicImmune()  then
            return
        end
        if tg.target:HasModifier("modifier_frostmourne_debuff") and  PseudoRandom:RollPseudoRandom(self.ability, self.ch+self.caster:TG_GetTalentValue("special_bonus_abaddon_7")) then
            local num=RandomInt(0, 3)
            if self.caster:TG_HasTalent("special_bonus_abaddon_8") then
                self.trigger=true
            end
            if num==0 or self.trigger then
                local damageTable = {
                    victim = tg.target,
                    attacker = self.caster,
                    damage = self.caster:GetMaxHealth()*self.hp,
                    damage_type =DAMAGE_TYPE_MAGICAL,
                    ability = self.ability,
                    }
                ApplyDamage(damageTable)
            end
            if num==1 or self.trigger then
                tg.target:AddNewModifier_RS(self.caster, self.ability, "modifier_frostmourne_call", {duration = 1})
                tg.target:AddNewModifier_RS(self.caster, self.ability, "modifier_axe_berserkers_call", {duration = 1})
            end
            if ( num==2 or self.trigger ) and not self.caster:HasModifier("modifier_frostmourne_cd") then
                local ab=self.caster:FindAbilityByName("aphotic_shield")
                if ab and ab:GetLevel()>0 then
                    self.caster:AddNewModifier(self.caster, self.ability, "modifier_frostmourne_cd", {duration=0.25})
                    ab:OnSpellStart()
                end
            end
        end
        if self.parent:HasModifier("modifier_borrowed_time") then
            tg.target:AddNewModifier_RS(self.parent, self.ability, "modifier_frostmourne_debuff", {duration=self.curse_duration})
        elseif not tg.target:HasModifier("modifier_frostmourne_debuff") then
                tg.target:AddNewModifier_RS(self.parent, self.ability, "modifier_frostmourne_stack", {duration=self.slow_duration})
        end
	end
end

modifier_frostmourne_stack=class({})

function modifier_frostmourne_stack:IsPurgable()
    return false
end

function modifier_frostmourne_stack:IsPurgeException()
    return false
end

function modifier_frostmourne_stack:IsHidden()
    return false
end

function modifier_frostmourne_stack:OnCreated()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.hit_count=self.ability:GetSpecialValueFor("hit_count")
    self.movement_speed=0-(self.ability:GetSpecialValueFor("movement_speed")+self.caster:TG_GetTalentValue("special_bonus_abaddon_2"))
    self.curse_duration=self.ability:GetSpecialValueFor("curse_duration")
    if IsServer() then
        self:SetStackCount(self:GetStackCount()+1)
        if self.fx1 then
            ParticleManager:DestroyParticle(self.fx1, true)
            ParticleManager:ReleaseParticleIndex(self.fx1)
        end
        self.fx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.fx1, 0,self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControl(self.fx1, 1,Vector(0,self:GetStackCount(),0))
        ParticleManager:SetParticleControl(self.fx1, 3,self.parent:GetAbsOrigin())
		self:AddParticle(self.fx1, false, false, 1, false, true)
        if self:GetStackCount()>=self.hit_count then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_frostmourne_debuff", {duration=self.curse_duration})
            self:Destroy()
        end
    end
end

function modifier_frostmourne_stack:OnRefresh()
    self:OnCreated()
end

function modifier_frostmourne_stack:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_frostmourne_stack:GetModifierMoveSpeedBonus_Percentage()
    return self.movement_speed
end


modifier_frostmourne_debuff=class({})

function modifier_frostmourne_debuff:IsPurgable()
    return false
end

function modifier_frostmourne_debuff:IsPurgeException()
    return false
end

function modifier_frostmourne_debuff:IsHidden()
    return false
end

function modifier_frostmourne_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_frostmourne_debuff:GetEffectName()
    return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf"
end


function modifier_frostmourne_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_abaddon_frostmourne.vpcf"
end

function modifier_frostmourne_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_frostmourne_debuff:OnCreated()
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    if 	self:GetAbility() then
        self.ability=self:GetAbility()
        self.curse_slow=0-(self.ability:GetSpecialValueFor("curse_slow")+self.caster:TG_GetTalentValue("special_bonus_abaddon_2"))
        self.curse_duration=self.ability:GetSpecialValueFor("curse_duration")
    end
end

function modifier_frostmourne_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_frostmourne_debuff:OnAttackLanded(tg)
    if not IsServer() then
        return
	end

    if tg.target == self.parent then
        tg.attacker:AddNewModifier(self.caster, self.ability, "modifier_frostmourne_buff", {duration=self.curse_duration})
	end
end


function modifier_frostmourne_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.curse_slow
end

modifier_frostmourne_buff=class({})

function modifier_frostmourne_buff:IsPurgable()
    return false
end

function modifier_frostmourne_buff:IsPurgeException()
    return false
end

function modifier_frostmourne_buff:IsHidden()
    return false
end


function modifier_frostmourne_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_frostmourne_buff:GetModifierAttackSpeedBonus_Constant()
    if 	self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor("curse_attack_speed")
    end
    return 0
end

modifier_frostmourne_call=class({})

function modifier_frostmourne_call:IsPurgable()
    return false
end

function modifier_frostmourne_call:IsPurgeException()
    return false
end

function modifier_frostmourne_call:IsDebuff()
    return true
end

function modifier_frostmourne_call:IsHidden()
    return true
end

function modifier_frostmourne_call:CheckState()
    return
    {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_SILENCED]=true,
        [MODIFIER_STATE_CANNOT_MISS]=true,
        [MODIFIER_STATE_MUTED]=true,
    }
end

modifier_frostmourne_cd=class({})

function modifier_frostmourne_cd:IsPurgable()
    return false
end

function modifier_frostmourne_cd:IsPurgeException()
    return false
end

function modifier_frostmourne_cd:IsHidden()
    return true
end