run = class({})

LinkLuaModifier("modifier_ambush_run", "ting/ambush/run.lua", LUA_MODIFIER_MOTION_NONE)



function run:IsStealable() return false end


function run:OnSpellStart()
	local caster = self:GetCaster()
	local mod = caster:FindModifierByName("down_buff")
	if mod then
		local dur = mod:GetRemainingTime()
		local ab = mod:GetAbility()
		local cooldown_remaining = ab:GetCooldownTimeRemaining()
			ab:EndCooldown()
			if cooldown_remaining > dur then
				ab:StartCooldown( cooldown_remaining - dur )
			end		
		caster:RemoveModifierByName("down_buff")
	end
	EmitSoundOn("Ability.AssassinateLoad", caster)
	caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
	caster:AddNewModifier(caster,self,"modifier_ambush_run",{duration = self:GetSpecialValueFor("duration")})
	
end





modifier_ambush_run = class({})
function modifier_ambush_run:IsHidden()
	return false
end
function modifier_ambush_run:IsDebuff()
	return false
end
function modifier_ambush_run:IsPurgable() return false end
function modifier_ambush_run:IsPurgeException() return false end
function modifier_ambush_run:GetEffectName()
    return "particles/generic_gameplay/rune_haste.vpcf"
end
function modifier_ambush_run:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
			}
end
function modifier_ambush_run:CheckState() 
    return 
    {	[MODIFIER_STATE_ROOTED] = false,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    } 
end
function modifier_ambush_run:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA 
end

function modifier_ambush_run:GetModifierMoveSpeedBonus_Percentage()
	return self.move_up
end
function modifier_ambush_run:GetModifierMoveSpeed_Limit()
    return self.move_max
end

function modifier_ambush_run:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_ambush_run:OnCreated()
	if self:GetAbility() == nil then return end 
	self.ability = self:GetAbility()
	self.move_max = self.ability:GetSpecialValueFor("move_max")
	self.move_up = self.ability:GetSpecialValueFor("move_speed")
	if IsServer() then
			

	end
end

