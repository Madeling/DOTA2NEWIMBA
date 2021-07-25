command_aura=class({})
LinkLuaModifier( "modifier_command_aura", "heros/hero_vengefulspirit/command_aura.lua", LUA_MODIFIER_MOTION_NONE )

function command_aura:GetIntrinsicModifierName()
	return "modifier_command_aura"
end

modifier_command_aura=class({})

function modifier_command_aura:IsHidden()
	return false
end

function modifier_command_aura:AllowIllusionDuplicate()
	return false
end

function modifier_command_aura:OnCreated()
    self.caster=self:GetCaster()
	self.bonus_base_damage = self:GetAbility():GetSpecialValueFor( "bonus_base_damage" )
end



function modifier_command_aura:OnRefresh()
    self.bonus_base_damage = self:GetAbility():GetSpecialValueFor( "bonus_base_damage" )
end



function modifier_command_aura:DeclareFunctions()
	return 
    {
		MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
end

function modifier_command_aura:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount()
end

function modifier_command_aura:OnDeath(tg)
	if IsServer() then
        if TG_Distance(tg.unit:GetAbsOrigin(),self.caster:GetAbsOrigin())<=1200 and Is_Chinese_TG(tg.unit,self.caster) and tg.unit~=self.caster  and self.caster:IsAlive()   then
            if self:GetStackCount()>50 then 
                self:SetStackCount(50)
            else 
                self:SetStackCount(self:GetStackCount()+self.bonus_base_damage)
            end
        end
        if tg.unit==self.caster then
            self:SetStackCount(0)
        end
	end
end



