yinjianren = class({})


LinkLuaModifier("modifier_yinjianren_passive", "ting/yinjianren/yinjianren.lua", LUA_MODIFIER_MOTION_NONE)
function yinjianren:GetIntrinsicModifierName() return "modifier_yinjianren_passive" end
function yinjianren:Set_InitialUpgrade() return {LV=1} end
function yinjianren:OnUpgrade()
	if not IsServer() then return end
	local mod = self:GetCaster():FindModifierByName("modifier_yinjianren_passive")
	if mod then
		mod.rb = self:GetSpecialValueFor("range_bonus")
		mod.cd_re = self:GetSpecialValueFor("cd")
		mod.damage = self:GetSpecialValueFor("damage")
		mod:StartIntervalThink(1)
	end
end
function yinjianren:OnSpellStart()

end

modifier_yinjianren_passive = class({})
function modifier_yinjianren_passive:IsPurgable()return false
end
function modifier_yinjianren_passive:IsPurgeException()return false
end
function modifier_yinjianren_passive:IsHidden()return true
end

function modifier_yinjianren_passive:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
			--MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
			}
end
function modifier_yinjianren_passive:GetModifierAttackRangeBonus()
	return self.rb
end
--[[
function modifier_yinjianren_passive:GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsServer() then
		if self:GetParent():IsInvisible() then
		print("123")
			return self.damage
		end
	end
	return 0
	--return 0
end]]
function modifier_yinjianren_passive:OnCreated()
	self.rb = 400
	self.cd_re = 1
	self.damage = 40
	self.parent = self:GetParent()
end
function modifier_yinjianren_passive:OnIntervalThink()
	if IsServer() then
		if self.parent:IsInvisible() then
			local cooldown_reduction = self.cd_re
			for i = 0, 23 do
				local current_ability = self.parent:GetAbilityByIndex(i)
				if current_ability then
					local cooldown_remaining = current_ability:GetCooldownTimeRemaining()
					current_ability:EndCooldown()
					if cooldown_remaining > cooldown_reduction then
						current_ability:StartCooldown( cooldown_remaining - cooldown_reduction )
					end
				end
			end
		end
	end
end
