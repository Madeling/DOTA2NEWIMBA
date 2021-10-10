--------------------------------------------------------------
--		   	   IMBA_FACELESS_VOID_TIME_LOCK                 --
--------------------------------------------------------------
imba_faceless_void_time_lock = class({})

LinkLuaModifier("modifier_imba_faceless_void_time_lock_passive", "mb/hero_faceless_void/faceless_void_time_lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_faceless_void_time_lock_reduce", "mb/hero_faceless_void/faceless_void_time_lock", LUA_MODIFIER_MOTION_NONE)

function imba_faceless_void_time_lock:OnUpgrade()
	local ability = self:GetCaster():FindAbilityByName("faceless_void_backtrack")
	if ability then
		ability:SetLevel(self:GetLevel())
	end
end

function imba_faceless_void_time_lock:GetIntrinsicModifierName() return "modifier_imba_faceless_void_time_lock_passive" end

modifier_imba_faceless_void_time_lock_passive = class({})

function modifier_imba_faceless_void_time_lock_passive:IsDebuff()			return false end
function modifier_imba_faceless_void_time_lock_passive:IsHidden() 			return true end
function modifier_imba_faceless_void_time_lock_passive:IsPurgable() 		return false end
function modifier_imba_faceless_void_time_lock_passive:IsPurgeException() 	return false end

function modifier_imba_faceless_void_time_lock_passive:DeclareFunctions()	return {MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL} end

--function modifier_imba_faceless_void_time_lock_passive:OnAttackLanded(keys)
function modifier_imba_faceless_void_time_lock_passive:GetModifierProcAttack_BonusDamage_Magical(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return 
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	if PseudoRandom:RollPseudoRandom(self:GetAbility(), self:GetAbility():GetSpecialValueFor("bash_chance")) then
	--if RollPseudoRandomPercentage(self:GetAbility():GetSpecialValueFor("bash_chance"),0,self:GetParent()) then
		--resource
		local bash_damage = self:GetAbility():GetSpecialValueFor("bash_damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_faceless_void_2")
		local bash_duration = self:GetAbility():GetSpecialValueFor("bash_duration")
		local buff = self:GetParent():GetModifierStackCount("modifier_imba_faceless_void_time_lock_reduce", self:GetParent())
		local radius = math.max(self:GetAbility():GetSpecialValueFor("radius_min"), self:GetAbility():GetSpecialValueFor("bash_radius") - self:GetAbility():GetSpecialValueFor("radius_reduce") * buff)
		--if cooldown ready
		if self:GetAbility():IsCooldownReady() then
			local damageTable = {
					--victim = enemy,
					attacker = self:GetParent(),
					damage = bash_damage,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
					ability = self:GetAbility(), --Optional.
			}
			--IMBA Create a Chronosphere
			CreateChronosphere(self:GetParent(), self:GetAbility(), keys.target:GetAbsOrigin(), radius, bash_duration, 2)
			if not self:GetParent():TG_HasTalent("special_bonus_imba_faceless_void_5") then
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_faceless_void_time_lock_reduce", {duration = self:GetAbility():GetSpecialValueFor("reduce_duration")})
			end
			--AOE Damage
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), keys.target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				if enemy ~= keys.target then 
					damageTable.victim = enemy
					ApplyDamage(damageTable)
				end
			end
			--Start Cooldown
			self:GetAbility():UseResources(true, true, true)
		end
		--play sound 
		keys.target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
		--play effect 
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pfx, 0, keys.target:GetAbsOrigin() )
        ParticleManager:SetParticleControl(pfx, 1, keys.target:GetAbsOrigin() )
        ParticleManager:SetParticleControlEnt(pfx, 2, self:GetParent(), PATTACH_CUSTOMORIGIN, "attach_hitloc", keys.target:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(pfx)
		--IMBA Time Lord 
		for i = 0, 23 do
			local current_ability = keys.target:GetAbilityByIndex(i)
			if current_ability and not current_ability:IsCooldownReady() and current_ability:GetCooldownTime() ~= 0 then
				current_ability:StartCooldown( current_ability:GetCooldownTimeRemaining() + self:GetAbility():GetSpecialValueFor("cooldown_increase") )
			end
		end
		--Target effect
		--眩晕
		keys.target:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = bash_duration})
		--attack once 
		Timers:CreateTimer(0.33, function()
			--异步攻击，否则一起木大木大会BOOM
			if not self:GetAbility():IsNull() and keys.target:IsAlive() then
				self:GetParent():PerformAttack(keys.target, false, true, true, false, false, false, false)
			end
		end)
		--target damage
		return bash_damage
	end
end

--------------------------------------------------------------
modifier_imba_faceless_void_time_lock_reduce = class({})

function modifier_imba_faceless_void_time_lock_reduce:IsDebuff()			return true end
function modifier_imba_faceless_void_time_lock_reduce:IsHidden() 			return false end
function modifier_imba_faceless_void_time_lock_reduce:IsPurgable() 			return false end
function modifier_imba_faceless_void_time_lock_reduce:IsPurgeException() 	return false end

function modifier_imba_faceless_void_time_lock_reduce:OnRefresh() self:IncrementStackCount() end