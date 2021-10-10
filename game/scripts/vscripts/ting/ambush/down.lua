down = class({})
LinkLuaModifier("down_buff", "ting/ambush/down.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_stunned", "ting/ambush/down.lua", LUA_MODIFIER_MOTION_NONE)
--function imba_bristleback_hairball:GetIntrinsicModifierName() return "modifier_goo_auto" end
function down:IsHiddenWhenStolen() 		return false end
function down:IsRefreshable() 			return true  end
function down:IsStealable() 			return false  end


function down:OnSpellStart()
	local caster = self:GetCaster()
	EmitSoundOn("Ability.AssassinateLoad", caster)
	caster:RemoveModifierByName("down_buff")
	local mod = caster:FindModifierByName("modifier_ambush_run")
	if mod then
		local dur = mod:GetRemainingTime()
		local ab = mod:GetAbility()
		local cooldown_remaining = ab:GetCooldownTimeRemaining()
			ab:EndCooldown()
			if cooldown_remaining > dur then
				ab:StartCooldown( cooldown_remaining - dur )
			end
		caster:RemoveModifierByName("modifier_ambush_run")
	end
	ProjectileManager:ProjectileDodge(caster)
	caster:AddNewModifier(caster, self, "down_buff", {duration = self:GetSpecialValueFor("duration")})
end

down_buff = class({})
LinkLuaModifier("modifier_imba_stunned", "ting/ambush/down.lua", LUA_MODIFIER_MOTION_NONE)
function down_buff:OnCreated(keys)
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.caster = self:GetCaster()
	self.range = self.ab:GetSpecialValueFor("range_up")
	self.att = self.ab:GetSpecialValueFor("att_up")
	self.rate = self.ab:GetSpecialValueFor("rate")*-1
	if IsServer() then
	self:GetCaster():AddActivityModifier("instagib")
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_ultimate_scepter", {duration = 3})  --白牛的击退
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4,0.18)
	end
end

function down_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }
end

function down_buff:GetModifierPreAttack_BonusDamage()
    return self.att
end

function down_buff:GetModifierAttackRangeBonus()
    return  self.range
end

function down_buff:GetModifierTurnRate_Percentage()
    return  self.rate
end
function down_buff:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		--[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end

function down_buff:IsHidden()
	return false
end
function down_buff:IsPurgable()
	return false
end
function down_buff:IsPurgeException()
	return false
end


function down_buff:OnDestroy()
	if IsServer() then
		self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)

		--self.caster:RemoveModifierByName("down_debug")
		--self.parent:EmitSound("Hero_Rattletrap.Rocket_Flare.Explode")

		--CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_imba_tiny_avalanche_thinker", { duration = self:GetChannelTime() }, self:GetCaster():GetOrigin(), self:GetCaster():GetTeamNumber(), false )
	end
end

modifier_imba_stunned = class({})

function modifier_imba_stunned:IsDebuff()			return true end
function modifier_imba_stunned:IsHidden() 			return false end
function modifier_imba_stunned:IsPurgable() 		return false end
function modifier_imba_stunned:IsPurgeException() 	return true end
function modifier_imba_stunned:CheckState() return {[MODIFIER_STATE_STUNNED] = true} end
function modifier_imba_stunned:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_imba_stunned:GetOverrideAnimation() return ACT_DOTA_DISABLED end
function modifier_imba_stunned:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_imba_stunned:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_stunned:ShouldUseOverheadOffset() return true end
