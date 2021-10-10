mana_shield=class({})

LinkLuaModifier( "modifier_mana_shield", "heros/hero_medusa/mana_shield.lua", LUA_MODIFIER_MOTION_NONE )

function mana_shield:IsHiddenWhenStolen() 
    return false 
end

function mana_shield:IsStealable() 
    return true 
end

function mana_shield:IsRefreshable() 			
    return true 
end


function mana_shield:ProcsMagicStick()
	return false
end

function mana_shield:OnToggle()
	local caster = self:GetCaster()
    if self:GetToggleState() then
        if not caster:HasModifier("modifier_mana_shield") then
			caster:AddNewModifier(caster, self, "modifier_mana_shield", {})
		end
	else
        if caster:HasModifier("modifier_mana_shield") then
			caster:RemoveModifierByName("modifier_mana_shield")
		end
	end
end


modifier_mana_shield=class({})

function modifier_mana_shield:IsHidden()
	return false
end

function modifier_mana_shield:IsDebuff()
	return false
end

function modifier_mana_shield:IsPurgable()
	return false
end

function modifier_mana_shield:IsPurgeException()
	return false
end

function modifier_mana_shield:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_mana_shield:GetEffectName()
	return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf"
end

function modifier_mana_shield:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_mana_shield:OnCreated(tg)
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
	self.damage_per_mana = self.ability:GetSpecialValueFor( "damage_per_mana" )
    self.absorb_pct = self.ability:GetSpecialValueFor( "absorption_pct" )/100
    self.heal = self.ability:GetSpecialValueFor( "heal" )+self:GetCaster():TG_GetTalentValue("special_bonus_medusa_8")
    if not IsServer() then 
        return 
    end
	EmitSoundOn( "Hero_Medusa.ManaShield.On",self.parent)
end

function modifier_mana_shield:OnRefresh(tg)
	self.damage_per_mana = self.ability:GetSpecialValueFor( "damage_per_mana" )
    self.absorb_pct = self.ability:GetSpecialValueFor( "absorption_pct" )/100	
    self.heal = self.ability:GetSpecialValueFor( "heal" )+self:GetCaster():TG_GetTalentValue("special_bonus_medusa_8")
end


function modifier_mana_shield:OnDestroy()
    if not IsServer() then
         return 
    end
	EmitSoundOn( "Hero_Medusa.ManaShield.Off", self.parent)
end

function modifier_mana_shield:GetModifierIncomingDamage_Percentage(tg)
	if tg.target~=self:GetParent() then    
		return  0
	end 
	local absorb = -100*self.absorb_pct
	local damage_absorbed = tg.damage * self.absorb_pct
	local manacost = damage_absorbed/self.damage_per_mana
    local mana = self.parent:GetMana()
	if mana<manacost then
		damage_absorbed = mana * self.damage_per_mana
		absorb = -damage_absorbed/tg.damage*100
        manacost = mana
    else 
        if mana<self.parent:GetMaxMana()*self.heal*0.01 then
            self.parent:Heal(manacost, self.parent)
        end
    end
	self.parent:SpendMana( manacost, self.ability )
    EmitSoundOn("Hero_Medusa.ManaShield.Proc", self:GetParent())
	local pf = ParticleManager:CreateParticle( "particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(pf, 1, Vector( damage, 0, 0 ))
	ParticleManager:ReleaseParticleIndex(pf)
	return absorb
end