
warcry = class({})
LinkLuaModifier( "modifier_warcry","heros/hero_sven/warcry.lua", LUA_MODIFIER_MOTION_NONE )

function warcry:IsHiddenWhenStolen() 
    return false 
end

function warcry:IsStealable() 
    return true 
end

function warcry:IsRefreshable() 			
    return true 
end

function warcry:GetManaCost(iLevel)	
    if self:GetCaster():TG_HasTalent("special_bonus_sven_5") then
        return 0
    else 
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end

function warcry:GetCooldown(iLevel)  
	local caster=self:GetCaster()
	local cd=self.BaseClass.GetCooldown(self,iLevel)
	if caster:TG_HasTalent("special_bonus_sven_3") and caster:HasModifier("modifier_great_cleave_buff2") then
		return cd*0.4
	else
		return cd
	end
end

function warcry:OnSpellStart()
	local caster=self:GetCaster()
	local radius = self:GetSpecialValueFor( "radius" )+caster:GetCastRangeBonus() 
	local duration = self:GetSpecialValueFor(  "duration" )
	EmitSoundOn( "Hero_Sven.WarCry",caster)
	if caster:TG_HasTalent("special_bonus_sven_4") and caster:HasModifier("modifier_item_heavens_halberd_v2_debuff") then
		caster:RemoveModifierByName("modifier_item_heavens_halberd_v2_debuff")
	end
	caster:Purge(false, true, false, true, true)
	local heros = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	if #heros > 0 then
		for _,hero in pairs(heros) do
			if caster:TG_HasTalent("special_bonus_sven_6") then 
				hero:Purge(false,true,false,false,false)
			end
				hero:AddNewModifier( caster, self, "modifier_warcry", { duration = duration })
		end
	end
end


modifier_warcry = class({})

function modifier_warcry:IsHidden() 			
    return false 
end

function modifier_warcry:IsPurgable() 		
    return true
end

function modifier_warcry:IsPurgeException() 
    return true 
end

function modifier_warcry:GetPriority() 
    return MODIFIER_PRIORITY_LOW
end

function modifier_warcry:OnCreated( tg )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	if IsServer() then
		local fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl(fx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlEnt( fx, 1, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_head", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( fx, false, false, 15, false, true )
	end
end


function modifier_warcry:OnRefresh( tg )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
end



function modifier_warcry:DeclareFunctions()
	return
	 {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_warcry:GetOverrideAnimation() 
    return ACT_DOTA_OVERRIDE_ABILITY_3
end

function modifier_warcry:GetActivityTranslationModifiers( tg )
	if self:GetParent() == self:GetCaster() then
		return "sven_warcry"
	end
	return 0
end

function modifier_warcry:GetModifierMoveSpeedBonus_Percentage( tg )
	return self.movespeed
end

function modifier_warcry:GetModifierPhysicalArmorBonus( tg )
	return self.bonus_armor
end
