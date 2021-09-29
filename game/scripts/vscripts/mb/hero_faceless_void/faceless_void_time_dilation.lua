--------------------------------------------------------------
--		   	 IMBA_FACELESS_VOID_TIME_DILATION               --
--------------------------------------------------------------
imba_faceless_void_time_dilation = class({})

LinkLuaModifier("modifier_imba_time_dilation_slow", "mb/hero_faceless_void/faceless_void_time_dilation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_time_dilation_buff", "mb/hero_faceless_void/faceless_void_time_dilation", LUA_MODIFIER_MOTION_NONE)

function imba_faceless_void_time_dilation:IsHiddenWhenStolen() 		return false end
function imba_faceless_void_time_dilation:IsRefreshable() 			return true  end
function imba_faceless_void_time_dilation:IsStealable() 			return true  end
function imba_faceless_void_time_dilation:IsNetherWardStealable() 	return true end

function imba_faceless_void_time_dilation:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end
function imba_faceless_void_time_dilation:GetAbilityTextureName()	return "faceless_void/brancerofaeons/faceless_void_time_dilation_crimson" end
function imba_faceless_void_time_dilation:OnSpellStart()
	local caster          = self:GetCaster()
	local pfx_name        = "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_red_timedialate.vpcf"
	local pfx_debuff_name = "particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_dialatedebuf_red.vpcf"
	local sound_name      = "Hero_FacelessVoid.TimeDilation.Cast.ti7"
	--end
	caster:EmitSound(sound_name)
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius")))
	ParticleManager:ReleaseParticleIndex(pfx)
	local cooldown_ability = 0
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		local cooldown_ability_per = 0
		for i=0,23 do
			local ability = enemy:GetAbilityByIndex(i)
			if ability then
				if not ability:IsCooldownReady() and not ability:IsPassive() and ability:GetCooldownTime() ~= 0 then
					cooldown_ability_per = cooldown_ability_per + 1
					cooldown_ability = cooldown_ability + 1
					--print(ability:GetName(), ability:GetCooldownTimeRemaining())
					ability:StartCooldown(ability:GetCooldownTimeRemaining() + self:GetSpecialValueFor("cooldown_increase"))
				else
					ability:StartCooldown(self:GetSpecialValueFor("cooldown_start"))
				end
			end
		end
		if cooldown_ability_per ~= 0 then
			EmitSoundOnLocationWithCaster(enemy:GetAbsOrigin(), "Hero_FacelessVoid.TimeDilation.Target", enemy)
			local debuff = enemy:AddNewModifier_RS(caster, self, "modifier_imba_time_dilation_slow", {duration = self:GetSpecialValueFor("cooldown_increase")})
			debuff:SetStackCount(cooldown_ability_per)
			local pfx2 = ParticleManager:CreateParticle(pfx_debuff_name, PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(pfx2, 1, Vector(cooldown_ability_per, 0, 0))
			debuff:AddParticle(pfx2, false, false, 15, false, false)
		end
	end
	if cooldown_ability ~= 0 then
		local buff = caster:AddNewModifier(caster, self, "modifier_imba_time_dilation_buff", {duration = self:GetSpecialValueFor("cooldown_increase")})
		buff:SetStackCount(cooldown_ability)
	end
end

modifier_imba_time_dilation_slow = class({})

function modifier_imba_time_dilation_slow:IsDebuff()			return true end
function modifier_imba_time_dilation_slow:IsHidden() 			return false end
function modifier_imba_time_dilation_slow:IsPurgable() 			return true end
function modifier_imba_time_dilation_slow:IsPurgeException() 	return true end
function modifier_imba_time_dilation_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_time_dilation_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetStackCount() * self.move_slow) end
function modifier_imba_time_dilation_slow:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetStackCount() * self.attack_slow) end
function modifier_imba_time_dilation_slow:OnCreated()
	self.move_slow   = self:GetAbility():GetSpecialValueFor("move_slow")
	self.attack_slow = self:GetAbility():GetSpecialValueFor("attack_slow")
	if IsServer() then 
		self.ability          = self:GetAbility()
		self.caster           = self.ability:GetCaster()
		self.parent           = self:GetParent()
		self.damage_per_stack = self.ability:GetSpecialValueFor("damage_per_stack") + self.caster:TG_GetTalentValue("special_bonus_imba_faceless_void_8")
		self.damage_table     =
		{	
			victim      = self.parent,
			attacker    = self.caster,
			ability     = self.ability,
			--damage      = self.damage_per_stack * self:GetStackCount(),
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_time_dilation_slow:OnIntervalThink()	
    if not self.parent:IsAlive() then return end 
   	self.damage_table.damage = self.damage_per_stack * self:GetStackCount()
    ApplyDamage(self.damage_table)
end

modifier_imba_time_dilation_buff = class({})

function modifier_imba_time_dilation_buff:IsDebuff()			return false end
function modifier_imba_time_dilation_buff:IsHidden() 			return false end
function modifier_imba_time_dilation_buff:IsPurgable() 			return true end
function modifier_imba_time_dilation_buff:IsPurgeException() 	return true end
function modifier_imba_time_dilation_buff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_time_dilation_buff:GetEffectName() return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf" end
function modifier_imba_time_dilation_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_time_dilation_buff:GetModifierMoveSpeedBonus_Percentage() return (self:GetStackCount() * self.move_bonus) end
function modifier_imba_time_dilation_buff:GetModifierAttackSpeedBonus_Constant() return (self:GetStackCount() * self.attack_bonus) end
function modifier_imba_time_dilation_buff:OnCreated()
	self.move_bonus   = self:GetAbility():GetSpecialValueFor("move_bonus")
	self.attack_bonus = self:GetAbility():GetSpecialValueFor("attack_bonus")
end
