great_cleave = class({})
LinkLuaModifier( "modifier_great_cleave", "heros/hero_sven/great_cleave.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_great_cleave_buff", "heros/hero_sven/great_cleave.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_great_cleave_buff2", "heros/hero_sven/great_cleave.lua", LUA_MODIFIER_MOTION_NONE )
function great_cleave:GetIntrinsicModifierName()
	return "modifier_great_cleave"
end

function great_cleave:IsHiddenWhenStolen()
    return false
end

function great_cleave:IsStealable()
    return true
end


function great_cleave:IsRefreshable()
    return false
end

function great_cleave:GetManaCost(iLevel)
    if self:GetCaster():TG_HasTalent("special_bonus_sven_5") then
        return 0
    else
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end


function great_cleave:OnAbilityPhaseStart()
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1.5)
	return true
end

function great_cleave:OnSpellStart()
	local caster=self:GetCaster()
	local pos=self:GetCursorPosition()
	EmitSoundOn( "Hero_Sven.SignetLayer", caster )
	EmitSoundOn( "Hero_Sven.GreatCleave.ti7", caster )
	local fx1 = ParticleManager:CreateParticle( "particles/vr/player_light_godray.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl(fx1, 0, pos)
	Timers:CreateTimer(10, function()
		if fx1 then
		ParticleManager:DestroyParticle(fx1,true)
		ParticleManager:ReleaseParticleIndex(fx1)
		end
		return nil
	end)
	local fx2 = ParticleManager:CreateParticle( "particles/heros/axe/shake.vpcf", PATTACH_ABSORIGIN_FOLLOW ,caster)
	ParticleManager:ReleaseParticleIndex(fx2)
	local fx3 = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl(fx3, 0, pos+Vector(0,0,1000))
	ParticleManager:SetParticleControl(fx3, 1, pos)
	ParticleManager:ReleaseParticleIndex(fx3)
	CreateModifierThinker(caster, self, "modifier_great_cleave_buff", {duration=10}, pos, caster:GetTeamNumber(), false)
end

modifier_great_cleave=class({})

function modifier_great_cleave:IsHidden()
	return true
end

function modifier_great_cleave:IsPurgable()
	return false
end

function modifier_great_cleave:IsPurgeException()
	return false
end

function modifier_great_cleave:OnCreated( tg )
	self.dam = self:GetAbility():GetSpecialValueFor( "dam" )
	self.swh = self:GetAbility():GetSpecialValueFor( "swh" )
	self.ewh = self:GetAbility():GetSpecialValueFor( "ewh" )
	self.dis = self:GetAbility():GetSpecialValueFor( "dis" )
	self.dam2 = self:GetAbility():GetSpecialValueFor( "dam2" )
end


function modifier_great_cleave:OnRefresh( tg )
	self:OnCreated( tg )
end



function modifier_great_cleave:DeclareFunctions()
	return
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED,
		}
end

function modifier_great_cleave:OnAttackLanded( tg )
	if not IsServer() then
        return
	end
		if tg.attacker == self:GetParent() and not self:GetParent():IsIllusion() then
			if self:GetParent():PassivesDisabled() then
				return
			end
			local target = tg.target
			if target ~= nil and not Is_Chinese_TG(target,self:GetParent()) then
				local fx="particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf"
					local damage = {
						victim = target,
						attacker = self:GetParent(),
						damage = self:GetParent():GetAverageTrueAttackDamage(self:GetParent())*self.dam2*0.01,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self:GetAbility(),
					}
					ApplyDamage( damage )
					if self:GetParent():HasModifier("modifier_gods_strength") then
					fx="particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf"
				end
				local cleaveDamage = ( self.dam * tg.damage ) / 100.0
				DoCleaveAttack(
                    self:GetParent(),
                    target,
                    self:GetAbility(),
					cleaveDamage,
                    self.swh,
                    self.ewh,
                    self.dis,
					fx )
			end
		end
end


modifier_great_cleave_buff=class({})

function modifier_great_cleave_buff:IsHidden()
	return true
end

function modifier_great_cleave_buff:IsPurgable()
	return false
end

function modifier_great_cleave_buff:IsPurgeException()
	return false
end


function modifier_great_cleave_buff:AllowIllusionDuplicate()
    return false
end

function modifier_great_cleave_buff:IsAura()
	return true
end

function modifier_great_cleave_buff:GetAuraDuration()
    return 0
end

function modifier_great_cleave_buff:GetModifierAura()
    return "modifier_great_cleave_buff2"
end

function modifier_great_cleave_buff:GetAuraRadius()
    return 800
end

function modifier_great_cleave_buff:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_great_cleave_buff:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end


function modifier_great_cleave_buff:OnCreated()
	if not IsServer() then
		return
	end
	local fx = ParticleManager:CreateParticle( "particles/tgp/sven/sword_m.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl(fx, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(fx, 6, Vector(1,1,1))
	ParticleManager:SetParticleControl(fx, 15, Vector(255,255,255))
	self:AddParticle(fx, true, false, 1, false, false)
	local fx2 = ParticleManager:CreateParticle( "particles/tgp/sven/sowrd_ground_m.vpcf", PATTACH_ABSORIGIN_FOLLOW  ,self:GetParent())
	self:AddParticle(fx2, false, false, 2, false, false)
	local fx3 = ParticleManager:CreateParticle("particles/tgp/sven/sven_circle_m.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(fx3, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(fx3, 1, Vector(800,800,800))
    ParticleManager:SetParticleControl(fx3, 2, Vector(10,1,1))
    self:AddParticle(fx3, false, false, 3, false, false)
end

modifier_great_cleave_buff2=class({})

function modifier_great_cleave_buff2:IsHidden()
	return true
end

function modifier_great_cleave_buff2:IsPurgable()
	return false
end

function modifier_great_cleave_buff2:IsPurgeException()
	return false
end

function modifier_great_cleave_buff2:OnCreated( tg )
	self.dam = self:GetAbility():GetSpecialValueFor( "dam" )
	self.swh = self:GetAbility():GetSpecialValueFor( "swh" )
	self.ewh = self:GetAbility():GetSpecialValueFor( "ewh" )
	self.dis = self:GetAbility():GetSpecialValueFor( "dis" )
	self.dam2 = self:GetAbility():GetSpecialValueFor( "dam2" )
end


function modifier_great_cleave_buff2:OnRefresh( tg )
	self.dam = self:GetAbility():GetSpecialValueFor( "dam" )
	self.swh = self:GetAbility():GetSpecialValueFor( "swh" )
	self.ewh = self:GetAbility():GetSpecialValueFor( "ewh" )
	self.dis = self:GetAbility():GetSpecialValueFor( "dis" )
	self.dam2 = self:GetAbility():GetSpecialValueFor( "dam2" )
end



function modifier_great_cleave_buff2:DeclareFunctions()
	return
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED,
		}
end

function modifier_great_cleave_buff2:OnAttackLanded( tg )
	if not IsServer() then
        return
	end
	if IsServer() then
		if tg.attacker == self:GetParent() and not self:GetParent():IsIllusion() then
			if self:GetParent():PassivesDisabled() then
				return
			end
			local target = tg.target
			if target ~= nil and not Is_Chinese_TG(target,self:GetParent()) then
				local fx="particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf"
					local damage = {
						victim = target,
						attacker = self:GetParent(),
						damage = self:GetParent():GetAverageTrueAttackDamage(self:GetParent())*self.dam2*0.01,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self:GetAbility(),
					}
					ApplyDamage( damage )
					if self:GetParent():HasModifier("modifier_gods_strength") then
					fx="particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf"
				end
				local cleaveDamage = ( self.dam * tg.damage ) / 100.0
				DoCleaveAttack(
                    self:GetParent(),
                    target,
                    self:GetAbility(),
					cleaveDamage,
                    self.swh,
                    self.ewh,
                    self.dis,
					fx )
			end
		end
	end
end