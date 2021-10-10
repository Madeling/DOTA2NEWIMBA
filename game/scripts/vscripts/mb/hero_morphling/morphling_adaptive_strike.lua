-- Author: MysticBug 03/01/2021
----------------------------------------------------------------------------------------------------------------
--imba_morphling_adaptive_strike								
--变体打击（敏捷 + 力量 + 智力)
--用猛烈的水波打击一个敌方单位,根据变体精灵敏捷造成敏捷系数额外伤害，力量造成击退和眩晕，智力提高施法距离和范围
--如果变体精灵的敏捷比力量高50%%，将造成最大伤害。
--如果变体精灵的力量比敏捷高50%%，将造成最大眩晕。

--imba
--1.变体追击：打击受波浪形态影响的目标伤害提升50%
--2.变体压制：打击目标降低攻击速度

--extra api 
function AdaptiveStrikeQuadraticModel(min,max,min_stamp,max_stamp,compare_stamp)
	local stamp = (compare_stamp > max_stamp and max_stamp) or (compare_stamp < min_stamp and min_stamp) or compare_stamp
	local interval = (max - min)/(max_stamp - min_stamp) * stamp + (max + min)/2
	--print(min,max,min_stamp,stamp,interval)
	if min > max then      
		return string.format("%." .. 2 .. "f",(interval < max and max) or (interval > min and min) or interval)
	else
		return string.format("%." .. 2 .. "f",(interval > max and max) or (interval < min and min) or interval)
	end
end

---------------------------------------------------------------------
----------------------- Morphling Adaptive Strike -------------------
---------------------------------------------------------------------
imba_morphling_adaptive_strike = class({})
LinkLuaModifier("modifier_imba_morphling_adaptive_strike_debuff", "mb/hero_morphling/morphling_adaptive_strike", LUA_MODIFIER_MOTION_NONE)

function imba_morphling_adaptive_strike:IsHiddenWhenStolen() 		return false end
function imba_morphling_adaptive_strike:IsRefreshable() 			return true end
function imba_morphling_adaptive_strike:IsStealable() 			return true end
function imba_morphling_adaptive_strike:IsNetherWardStealable()	return true end
function imba_morphling_adaptive_strike:GetAbilityTextureName() return "morphling_adaptive_strike_agi_ethereal_blade" end
function imba_morphling_adaptive_strike:GetCastRange(location , target)
	return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():GetCastRangeBonus()
end
function imba_morphling_adaptive_strike:OnSpellStart(str)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	--------------------------------------------------------------------------------------------------
	local pfx_name = "particles/units/heroes/hero_morphling/morphling_adaptive_strike_agi_proj.vpcf"
	--------------------------------------------------------------------------------------------------
	caster:EmitSound("Hero_Morphling.AdaptiveStrike.Cast")
	-- 对目标
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = pfx_name,
		iMoveSpeed = self:GetSpecialValueFor("projectile_speed") + math.floor(self:GetCaster():GetIntellect()),
		iSourceAttachment = caster:ScriptLookupAttachment("attach_attack1"),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
		ExtraData = { str = str },
	}
	--释放抛射物
	ProjectileManager:CreateTrackingProjectile(info)

	--Shard 4额外目标
	if caster:Has_Aghanims_Shard() then 
		local strike_count = self:GetSpecialValueFor("shard_strike_count")
		local radius = self:GetCastRange(caster:GetAbsOrigin(), caster) + caster:GetCastRangeBonus()		
		--优先英雄
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			caster:GetAbsOrigin(), 
			nil, 
			radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO, 
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER, 
			false)

		for _, enemy in pairs(enemies) do
			if enemy ~= target then
				info.Target = enemy
				info.ExtraData = { str = str , bshard = 1}
				--释放抛射物
				ProjectileManager:CreateTrackingProjectile(info)
				strike_count = strike_count - 1 
				if strike_count == 0 then 
					break
				end
			end
		end
		--然后普通单位
		if strike_count > 0 then 
			local units = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			caster:GetAbsOrigin(), 
			nil, 
			radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER, 
			false)
			for _, unit in pairs(units) do
				if unit ~= target then
					info.Target = unit
					info.ExtraData = { str = str , bshard = 1}
					--释放抛射物
					ProjectileManager:CreateTrackingProjectile(info)
					strike_count = strike_count - 1 
					if strike_count == 0 then 
						break
					end
				end
			end	
		end
	end
end

function imba_morphling_adaptive_strike:OnProjectileHit_ExtraData(target, pos, keys)
	--被吸收 林肯 AM 盾  结束
	if not target or (not keys.bshard and target:TG_TriggerSpellAbsorb(self)) or target:IsMagicImmune() then return end
	--if not target or target:IsMagicImmune() then return end
	local caster = self:GetCaster()	
	target:EmitSound("Hero_Morphling.AdaptiveStrike")

	--伤害 (agi - str)/str > 50  damage_max
	local damage_base = self:GetSpecialValueFor("damage_base")
	local damage_min = self:GetSpecialValueFor("damage_min")
	local damage_max = self:GetSpecialValueFor("damage_max")
	--打击受波浪形态影响的目标基础伤害提升50%
	if target:HasModifier("modifier_imba_morphling_waveform_debuff") then 
		damage_base = damage_base * 1.5
	end

	local caster_agi = caster:GetAgility()
	--眩晕 (str - agi)/agi > 50  stun_max 
	local stun_min = self:GetSpecialValueFor("stun_min")
	local stun_max = self:GetSpecialValueFor("stun_max")
	local caster_str = caster:GetStrength()
	--击退距离
	local knockback_min = self:GetSpecialValueFor("knockback_min")
	local knockback_max = self:GetSpecialValueFor("knockback_max")
	local compare_bouns = self:GetSpecialValueFor("compare_bouns")
	--结算
	local gt = math.floor((caster_agi - caster_str)/caster_str * 100)
	--damage 简单的初中知识
	local damage_interval = AdaptiveStrikeQuadraticModel(damage_min,damage_max,-compare_bouns,compare_bouns,gt)
	local stun_final = AdaptiveStrikeQuadraticModel(stun_max,stun_min,-compare_bouns,compare_bouns,gt)
	local knockback_final = AdaptiveStrikeQuadraticModel(knockback_max,knockback_min,-compare_bouns,compare_bouns,gt)
	local damage_final = math.floor(damage_base + damage_interval * caster_agi)
	--ethereal 不朽
	local pfx_name = "particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf"
	--if HeroItems:UnitHasItem(self:GetCaster(), "blade_of_tears") then
		pfx_name = "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf"
	--end
	--adaptive strike str and cooldown
	if keys.str == 1 then 
		damage_final = math.floor(damage_base + damage_min * caster_agi)
		knockback_final = knockback_min
		stun_final = stun_min
		pfx_name = "particles/units/heroes/hero_morphling/morphling_adaptive_strike_str.vpcf"
		--End Ability Cooldown Talent(no using now)
		--local curCooldown = self:GetCooldownTimeRemaining()
		--[[if curCooldown > self:GetSpecialValueFor("shared_cooldown") then
			self:EndCooldown()
			self:StartCooldown(curCooldown - self:GetSpecialValueFor("shared_cooldown"))
		end]]	
	end
	--print("adaptive_strike  caster_agi  caster_str  damage_interval damage_final stun_final knockback_final",caster_agi,caster_str,damage_interval,gt,damage_final,stun_final,knockback_final)
	--造成伤害
	ApplyDamage(
		{
			attacker = caster, 
			victim = target, 
			damage = damage_final, 
			ability = self, 
			damage_type = self:GetAbilityDamageType()
		}
	)
	--击退    
	local caster_pos = caster:GetAbsOrigin()
	local knockback_table =
	{
		center_x = caster_pos.x ,
		center_y = caster_pos.y ,
		center_z = caster_pos.z ,
		duration = stun_final,
		knockback_duration = 0.5,
		knockback_distance = math.ceil(knockback_final),
		knockback_height = 50
	}
	target:AddNewModifier( caster, self, "modifier_knockback", knockback_table )
	--眩晕
	--target:AddNewModifier_RS(caster, self, "modifier_stunned", {duration = stun_final})
	--减攻速
	target:AddNewModifier_RS(caster, self, "modifier_imba_morphling_adaptive_strike_debuff", {duration = self:GetSpecialValueFor("debuff_duration")})
	------------------------------------------------------------------------------------------------------------------------------------------ 
	--击中特效
	--------------------------------------------------------------------------------------------------
	local pfx = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement(pfx_name, caster), PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_CUSTOMORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	--------------------------------------------------------------------------------------------------
end

modifier_imba_morphling_adaptive_strike_debuff = class({})

function modifier_imba_morphling_adaptive_strike_debuff:IsDebuff()			return true end
function modifier_imba_morphling_adaptive_strike_debuff:IsHidden() 			return false end
function modifier_imba_morphling_adaptive_strike_debuff:IsPurgable() 		return true end
function modifier_imba_morphling_adaptive_strike_debuff:IsPurgeException() 	return true end
function modifier_imba_morphling_adaptive_strike_debuff:GetEffectName() return "particles/basic_ambient/generic_paralyzed.vpcf" end
function modifier_imba_morphling_adaptive_strike_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_morphling_adaptive_strike_debuff:ShouldUseOverheadOffset() return true end
function modifier_imba_morphling_adaptive_strike_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_morphling_adaptive_strike_debuff:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("attack_speed_slow")) end