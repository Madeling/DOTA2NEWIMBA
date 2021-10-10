gods_strength = class({})
LinkLuaModifier( "modifier_gods_strength", "heros/hero_sven/gods_strength.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gods_strength2", "heros/hero_sven/gods_strength.lua", LUA_MODIFIER_MOTION_NONE )
function gods_strength:IsHiddenWhenStolen()
    return false
end

function gods_strength:IsStealable()
    return true
end


function gods_strength:IsRefreshable()
    return true
end


function gods_strength:GetManaCost(iLevel)
    if self:GetCaster():TG_HasTalent("special_bonus_sven_5") then
        return 0
    else
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end


function gods_strength:OnSpellStart()
	local caster=self:GetCaster()
	local dur = self:GetSpecialValueFor( "dur" )
	local dur2 = self:GetSpecialValueFor( "dur2" )
	EmitSoundOn( "Hero_Sven.GodsStrength", caster )
	local fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( fx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( fx )
	caster:AddNewModifier( caster, self, "modifier_gods_strength", { duration = caster:TG_HasTalent("special_bonus_sven_8") and -1 or dur } )
	caster:AddNewModifier( caster, self, "modifier_gods_strength2", { duration =  dur2 } )
end


modifier_gods_strength = class({})

function modifier_gods_strength:IsHidden()
    return false
end

function modifier_gods_strength:IsPurgable()
	return false
end

function modifier_gods_strength:IsPurgeException()
    return false
end

function modifier_gods_strength:RemoveOnDeath()
    if self:GetCaster():TG_HasTalent("special_bonus_sven_8") then
    		return false
    end
       	return true
end


function modifier_gods_strength:GetStatusEffectName()
	return "particles/status_fx/status_effect_gods_strength.vpcf"
end


function modifier_gods_strength:StatusEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end


function modifier_gods_strength:GetHeroEffectName()
	return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end


function modifier_gods_strength:HeroEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end


function modifier_gods_strength:OnCreated( tg )
	self.gods_strength_damage = self:GetAbility():GetSpecialValueFor( "gods_strength_damage" )
	if IsServer() then
		local fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon" , self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( fx, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head" , self:GetParent():GetOrigin(), true )
		self:AddParticle( fx, false, false, 15, false, true )
		local p2 = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        self:AddParticle( p2, false, false, 20, false, false )
	end
end


function modifier_gods_strength:OnRefresh( tg )
	self.gods_strength_damage = self:GetAbility():GetSpecialValueFor( "gods_strength_damage" )
end


function modifier_gods_strength:DeclareFunctions()
	return
		{
			MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
			MODIFIER_PROPERTY_MODEL_SCALE
		}
end

function modifier_gods_strength:GetModifierBaseDamageOutgoing_Percentage()
	return self.gods_strength_damage
end

function modifier_gods_strength:GetOverrideAnimation()
    return ACT_DOTA_OVERRIDE_ABILITY_4
end

function modifier_gods_strength:GetModifierModelScale()
    return 50
end


modifier_gods_strength2= class({})


function modifier_gods_strength2:IsHidden()
    return false
end

function modifier_gods_strength2:IsPurgable()
	return false
end

function modifier_gods_strength2:IsPurgeException()
    return false
end

function modifier_gods_strength2:OnCreated( tg )
	self.att = self:GetAbility():GetSpecialValueFor( "att" )
end


function modifier_gods_strength2:OnRefresh( tg )
	self.att = self:GetAbility():GetSpecialValueFor( "att" )
end


function modifier_gods_strength2:DeclareFunctions()
	return
		{
			MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		}
end

function modifier_gods_strength2:GetModifierBaseAttackTimeConstant()
	return self.att
end


function modifier_gods_strength2:CheckState()
    return
    {
        [MODIFIER_STATE_CANNOT_MISS ] = true,
    }
end