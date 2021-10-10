CreateTalents("npc_dota_hero_tidehunter","mb/hero_tidehunter.lua")
-- 04 17 by MysticBug-------
----------------------------
----------------------------
-------------------------------------------------------------------------------------------------
--extra api
-- Custom function, checks if the unit is far enough away from the inner radius
function CalculateDistance(ent1, ent2)
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local distance = (pos1 - pos2):Length2D()
	return distance
end

-- Finds units only on the outer layer of a ring
function FindUnitsInRing(teamNumber, position, cacheUnit, ring_radius, ring_width, teamFilter, typeFilter, flagFilter, order, canGrowCache)
	-- First checks all of the units in a radius
	local all_units	= FindUnitsInRadius(teamNumber, position, cacheUnit, ring_radius, teamFilter, typeFilter, flagFilter, order, canGrowCache)
	
	-- Then builds a table composed of the units that are in the outer ring, but not in the inner one.
	local outer_ring_units	=	{}

	for _,unit in pairs(all_units) do
		-- Custom function, checks if the unit is far enough away from the inner radius
		if CalculateDistance(unit:GetAbsOrigin(), position) >= ring_radius - ring_width then
			table.insert(outer_ring_units, unit)
		end
	end

	return outer_ring_units
end
--tidehunter_gush  巨浪

--召唤一股巨浪作用于 / 直线上的敌方单位 /，减速并削弱护甲
--(神杖)巨浪将会返回，将影响的敌方单位拽拖到潮汐猎人面前，减少冷却时间。

--imba 麦尔朗恩的忠告：持续时间内削弱目标8%/9%/10%+自身英雄等级 魔抗

imba_tidehunter_gush = class({})

LinkLuaModifier("modifier_imba_tidehunter_gush_debuff","mb/hero_tidehunter.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_gush_thinker","mb/hero_tidehunter.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_gush_motion","mb/hero_tidehunter.lua", LUA_MODIFIER_MOTION_NONE)

function imba_tidehunter_gush:IsHiddenWhenStolen() 		return false end
function imba_tidehunter_gush:IsRefreshable() 			return true end
function imba_tidehunter_gush:IsStealable() 				return true end
function imba_tidehunter_gush:IsNetherWardStealable()		return true end
function imba_tidehunter_gush:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target)
end
function imba_tidehunter_gush:GetCooldown( nLevel )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("cooldown_scepter")
	end
	return self.BaseClass.GetCooldown( self, nLevel )
end
function imba_tidehunter_gush:OnSpellStart()
	local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = self:GetCursorPosition()
	local gush_sound = "Hero_Tidehunter.Gush.AghsProjectile"
	-- 跟踪音效
	local dummy = CreateModifierThinker(
		caster, 
		self, 
		"modifier_imba_tidehunter_gush_thinker", 
		{duration = 15.0}, 
		caster_pos, 
		caster:GetTeamNumber(), 
		false)
	dummy.hit_table = {}
	dummy:EmitSound(gush_sound)
	-- 直线抛射物
	--local direction	= (target_pos - caster_pos):Normalized()
	local direction = (target_pos ~= caster_pos and (target_pos - caster_pos):Normalized()) or caster:GetForwardVector()
		direction.z = 0
	local info = {
		Ability				= self,
		EffectName			= "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf",
		vSpawnOrigin		= caster_pos,
		fDistance			= self:GetCastRange(caster_pos,caster) + caster:GetCastRangeBonus(),
		fStartRadius		= self:GetSpecialValueFor("aoe") + caster:TG_GetTalentValue("special_bonus_imba_tidehunter_5"),
		fEndRadius			= self:GetSpecialValueFor("aoe") + caster:TG_GetTalentValue("special_bonus_imba_tidehunter_5"),
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit		= true,
		vVelocity			= direction * self:GetSpecialValueFor("speed"),
		bProvidesVision		= false,
		ExtraData			= 
		{
			go          = 1,
			pos_x		= caster_pos.x,
			pos_y		= caster_pos.y,
			pos_z		= caster_pos.z,
			dummy		= dummy:entindex(),
		}
	}
	ProjectileManager:CreateLinearProjectile(info)
end

function imba_tidehunter_gush:OnProjectileThink_ExtraData(location, keys)
	if not IsServer() then return end
	if keys.dummy then
		EntIndexToHScript(keys.dummy):SetAbsOrigin(location)
	end
end

function imba_tidehunter_gush:OnProjectileHit_ExtraData(target, location, keys)
	if not IsServer() then return end
	local caster = self:GetCaster()
	if keys.go == 1 then
		if not target then
			--神杖效果 巨浪将会返回
			if caster:HasScepter() then
				--初始化敌人列表
				EntIndexToHScript(keys.dummy).hit_table = {} 
				local caster_pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
				local direction = (caster_pos - location):Normalized()
				direction.z = 0
				local info = {
				Ability				= self,
				EffectName			= "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf", -- Might not do anything
				vSpawnOrigin		= location,
				fDistance			= self:GetCastRange(caster_pos,caster) + caster:GetCastRangeBonus(),
				fStartRadius		= self:GetSpecialValueFor("aoe") + caster:TG_GetTalentValue("special_bonus_imba_tidehunter_5"),
				fEndRadius			= self:GetSpecialValueFor("aoe") + caster:TG_GetTalentValue("special_bonus_imba_tidehunter_5"),
				Source				= caster,
				bHasFrontalCone		= false,
				bReplaceExisting	= false,
				iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				bDeleteOnHit		= true,
				vVelocity			= direction * self:GetSpecialValueFor("speed"),
				bProvidesVision		= false,
				ExtraData			= 
				{
					go 			= 0,
					pos_x		= caster_pos.x,
					pos_y		= caster_pos.y,
					pos_z		= caster_pos.z,
					dummy		= keys.dummy,
				}
			}
			ProjectileManager:CreateLinearProjectile(info)
			end
		end

		if target and not IsInTable(target, EntIndexToHScript(keys.dummy).hit_table) then
			target:EmitSound("Ability.GushImpact")
			-- debuff 减少护甲和魔抗
			target:AddNewModifier_RS(caster, self, "modifier_imba_tidehunter_gush_debuff", {duration = self:GetDuration()})
			-- 被击中的单位提供短暂视野
			self:CreateVisibilityNode(target:GetAbsOrigin(), 200, 2)
			-- 造成伤害
			local damageTable = {
				victim 			= target,
				damage 			= self:GetSpecialValueFor("gush_damage") + caster:TG_GetTalentValue("special_bonus_imba_tidehunter_1"),
				damage_type		= self:GetAbilityDamageType(),
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self
			}
			ApplyDamage(damageTable)
			-- 入列
			table.insert(EntIndexToHScript(keys.dummy).hit_table,target)
			local knockback_table =
			{
				center_x = keys.pos_x ,
				center_y = keys.pos_y ,
				center_z = keys.pos_z ,
				duration = 0.1,
				knockback_duration = 0.1,
				knockback_distance = self:GetSpecialValueFor("knockback_distance"),
				knockback_height = 0
			}
			target:AddNewModifier( target, nil, "modifier_knockback", knockback_table )
		end
	end
	--神杖返回造成伤害和击飞
	if keys.go == 0 then  
		if target and not IsInTable(target, EntIndexToHScript(keys.dummy).hit_table) then
			target:EmitSound("Ability.GushImpact")
			target:AddNewModifier_RS(caster, self, "modifier_imba_tidehunter_gush_debuff", {duration = self:GetDuration()})
			-- 被击中的单位提供短暂视野
			self:CreateVisibilityNode(target:GetAbsOrigin(), 200, 2)
			local damageTable = {
				victim 			= target,
				damage 			= self:GetSpecialValueFor("gush_damage") + caster:TG_GetTalentValue("special_bonus_imba_tidehunter_1"),
				damage_type		= self:GetAbilityDamageType(),
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self
			}
			ApplyDamage(damageTable)
			-- 入列
			table.insert(EntIndexToHScript(keys.dummy).hit_table,target)
			-- 神杖拽回 (nerf）
			--target:AddNewModifier(caster, self, "modifier_imba_tidehunter_gush_motion", {dummy = keys.dummy})
			-- 神杖击退距离翻倍 
			local dummy_pos = EntIndexToHScript(keys.dummy):GetAbsOrigin()  
			local knockback_table =
			{
				center_x = dummy_pos.x ,
				center_y = dummy_pos.y ,
				center_z = dummy_pos.z ,
				duration = 0.1,
				knockback_duration = 0.1,
				knockback_distance = self:GetSpecialValueFor("knockback_distance") * 2,
				knockback_height = 0
			}
			target:AddNewModifier( target, nil, "modifier_knockback", knockback_table )
		end
		if not target then 
			--结束音效
			EntIndexToHScript(keys.dummy).hit_table = nil 
			EntIndexToHScript(keys.dummy):StopSound("Hero_Tidehunter.Gush.AghsProjectile")
			EntIndexToHScript(keys.dummy):RemoveSelf()
		end
	end
end

--DEBUFF 减速 减护甲 imba 减魔抗
modifier_imba_tidehunter_gush_debuff = class({})

function modifier_imba_tidehunter_gush_debuff:IsDebuff()				return true end
function modifier_imba_tidehunter_gush_debuff:IsHidden() 				return false end
function modifier_imba_tidehunter_gush_debuff:IsPurgable() 				return true end
function modifier_imba_tidehunter_gush_debuff:IsPurgeException() 		return true end
function modifier_imba_tidehunter_gush_debuff:GetEffectName()	return "particles/units/heroes/hero_tidehunter/tidehunter_gush_slow.vpcf" end
function modifier_imba_tidehunter_gush_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_gush.vpcf" end
function modifier_imba_tidehunter_gush_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_imba_tidehunter_gush_debuff:GetModifierMoveSpeedBonus_Percentage() return (self:GetAbility():GetSpecialValueFor("movement_speed")) end
function modifier_imba_tidehunter_gush_debuff:GetModifierPhysicalArmorBonus() return (0 - self:GetAbility():GetSpecialValueFor("negative_armor")) end
function modifier_imba_tidehunter_gush_debuff:GetModifierMagicalResistanceBonus() return (0 - (self:GetAbility():GetSpecialValueFor("negative_resistance") + self:GetCaster():GetLevel())) end

--模特
modifier_imba_tidehunter_gush_thinker = class({})
--神杖拽回
modifier_imba_tidehunter_gush_motion = class({})

function modifier_imba_tidehunter_gush_motion:IsDebuff()			return true end
function modifier_imba_tidehunter_gush_motion:IsHidden() 			return false end
function modifier_imba_tidehunter_gush_motion:IsPurgable() 			return true end
function modifier_imba_tidehunter_gush_motion:IsPurgeException() 	return true end
function modifier_imba_tidehunter_gush_motion:CheckState() return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true} end
function modifier_imba_tidehunter_gush_motion:DeclareFunctions()	return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_PROPERTY_MOVESPEED_LIMIT} end
function modifier_imba_tidehunter_gush_motion:GetModifierMoveSpeed_Absolute() if IsServer() then return 1 end end
function modifier_imba_tidehunter_gush_motion:GetModifierMoveSpeed_Limit() if IsServer() then return 1 end end
function modifier_imba_tidehunter_gush_motion:IsMotionController() return true end
function modifier_imba_tidehunter_gush_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_tidehunter_gush_motion:OnCreated(keys)
	if IsServer() then
		self.dummy = EntIndexToHScript(keys.dummy)
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			self:Destroy()
		end
	end
end

function modifier_imba_tidehunter_gush_motion:OnIntervalThink()
	if not self.dummy or self.dummy:IsNull() then
		self:Destroy()
		return
	end
	local current_pos = self.dummy:GetAbsOrigin()
	for i, enemy in pairs(self.dummy.hit_table) do
		if enemy and enemy:IsAlive() then
			enemy:SetOrigin(GetGroundPosition(current_pos, nil))
		else
			self.dummy.hit_table[i] = nil
		end
	end
	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("aoe"), false)
end

function modifier_imba_tidehunter_gush_motion:OnDestroy()
	if IsServer() then
		self.dummy = nil
		self:GetParent():RemoveHorizontalMotionController(self)
	end
end

--tidehunter_kraken_shell 海妖外壳
--加厚潮汐猎人的外皮，可以被动格挡物理伤害，当受到的伤害达到临界值时外皮还将移除绝大多数负面效果。\n\n不与带有伤害格挡的物品叠加。\n\n驱散类型：强驱散

--如果%damage_reset_interval%秒内没有受到来自玩家的伤害，伤害累计值将重置。
--imba 麦尔朗恩的庇护：主动使用强驱散一次，持续时间吸收5%/10%/15%/20% + 自身英雄等级的 伤害

imba_tidehunter_kraken_shell = class({})

LinkLuaModifier("modifier_imba_tidehunter_kraken_shell_time","mb/hero_tidehunter.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_kraken_shell_passive","mb/hero_tidehunter.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_kraken_shell_purge","mb/hero_tidehunter.lua", LUA_MODIFIER_MOTION_NONE)

function imba_tidehunter_kraken_shell:IsHiddenWhenStolen() 		return false end
function imba_tidehunter_kraken_shell:IsRefreshable() 			return true end
function imba_tidehunter_kraken_shell:IsStealable() 				return true end
function imba_tidehunter_kraken_shell:IsNetherWardStealable()		return true end
function imba_tidehunter_kraken_shell:OnSpellStart()
	self:GetCaster():Purge(false, true, false, true, true)
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(pfx)
	self:GetCaster():EmitSound("DOTA_Item.Pipe.Activate")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_kraken_shell_time", {duration = self:GetSpecialValueFor("damage_absorb_interval")})
end
function imba_tidehunter_kraken_shell:GetIntrinsicModifierName() return "modifier_imba_tidehunter_kraken_shell_passive" end

--主动使用持续时间吸收5%/10%/15%/20% + 自身英雄等级的 伤害
modifier_imba_tidehunter_kraken_shell_time = class({})

function modifier_imba_tidehunter_kraken_shell_time:IsDebuff()			return false end
function modifier_imba_tidehunter_kraken_shell_time:IsHidden() 			return false end
function modifier_imba_tidehunter_kraken_shell_time:IsPurgable() 		return false end
function modifier_imba_tidehunter_kraken_shell_time:IsPurgeException() 	return false end

--海妖外壳被动
modifier_imba_tidehunter_kraken_shell_passive = class({})

function modifier_imba_tidehunter_kraken_shell_passive:IsDebuff()			return false end
function modifier_imba_tidehunter_kraken_shell_passive:IsHidden() 			return true end
function modifier_imba_tidehunter_kraken_shell_passive:IsPurgable() 		return false end
function modifier_imba_tidehunter_kraken_shell_passive:IsPurgeException() 	return false end
function modifier_imba_tidehunter_kraken_shell_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,MODIFIER_EVENT_ON_TAKEDAMAGE} end
--格挡物理伤害
function modifier_imba_tidehunter_kraken_shell_passive:GetModifierPhysical_ConstantBlock() return self:GetAbility():GetSpecialValueFor("damage_reduction") end
--吸收伤害
function modifier_imba_tidehunter_kraken_shell_passive:GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then return end
	local parent = self:GetParent()
	local passive = self:GetAbility()
	if parent:HasModifier("modifier_imba_tidehunter_kraken_shell_time") then 
		--天赋 吸收伤害治愈自己
		local damage_absorb_pct = passive:GetSpecialValueFor("damage_absorb_pct") + parent:GetLevel()
		if parent:TG_HasTalent("special_bonus_imba_tidehunter_2") then 
			if parent:IsAlive() then
				parent:SetHealth(parent:GetHealth() + math.floor(damage_absorb_pct * keys.damage/100))
			end
		end
		return (0 - damage_absorb_pct)
	end
end
--结算受伤
function modifier_imba_tidehunter_kraken_shell_passive:OnTakeDamage(keys)
	local parent = self:GetParent()
	local passive = self:GetAbility()

	if not IsServer() or keys.unit ~= parent or parent:PassivesDisabled() or parent:IsIllusion() then	
		return
	end
	--刃甲 刃甲2 伤害 不计算
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
	end

	if not parent:IsAlive() then
		return
	end
	--临界值伤害存储
	if parent:HasModifier("modifier_imba_tidehunter_kraken_shell_purge") then
		parent:SetModifierStackCount("modifier_imba_tidehunter_kraken_shell_purge", nil, parent:GetModifierStackCount("modifier_imba_tidehunter_kraken_shell_purge", nil) + keys.damage)
	else
		parent:AddNewModifier(parent, passive, "modifier_imba_tidehunter_kraken_shell_purge", { duration = passive:GetSpecialValueFor("damage_reset_interval")})
		parent:SetModifierStackCount("modifier_imba_tidehunter_kraken_shell_purge", nil, parent:GetModifierStackCount("modifier_imba_tidehunter_kraken_shell_purge", nil) + keys.damage)
	end
end

modifier_imba_tidehunter_kraken_shell_purge = class({})

function modifier_imba_tidehunter_kraken_shell_purge:IsDebuff()				return false end
function modifier_imba_tidehunter_kraken_shell_purge:IsHidden() 			return true end
function modifier_imba_tidehunter_kraken_shell_purge:IsPurgable() 			return false end
function modifier_imba_tidehunter_kraken_shell_purge:IsPurgeException() 	return false end
function modifier_imba_tidehunter_kraken_shell_purge:RemoveOnDeath() 		return false end

function modifier_imba_tidehunter_kraken_shell_purge:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.3)
	end
end

function modifier_imba_tidehunter_kraken_shell_purge:OnIntervalThink()
	local parent = self:GetParent()
	local passive = self:GetAbility()
	if self:GetStackCount() >= passive:GetSpecialValueFor("damage_cleanse") then
		--print("kraken_shell damage_cleanse now ", self:GetStackCount())
		parent:EmitSound("Hero_Tidehunter.KrakenShell")
		self:GetCaster():Purge(false, true, false, true, true)
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(pfx)
		self:SetStackCount(0)
	end
end

--tidehunter_anchor_smash 锚击
--潮汐猎人挥动他巨大的锚，攻击附近敌人并造成额外伤害，同时降低他们的攻击力。

--锚击对远古生物同样有效，不过对肉山无效。
--imba 麦尔朗恩的警告：使用3次锚击后，下次攻击后将出现触手眩晕附近敌人

imba_tidehunter_anchor_smash = class({})

LinkLuaModifier("modifier_imba_tidehunter_anchor_smash_charge","mb/hero_tidehunter.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_anchor_smash_debuff","mb/hero_tidehunter.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_anchor_smash_buff","mb/hero_tidehunter.lua", LUA_MODIFIER_MOTION_NONE)

function imba_tidehunter_anchor_smash:IsHiddenWhenStolen() 		return false end
function imba_tidehunter_anchor_smash:IsRefreshable() 			return true end
function imba_tidehunter_anchor_smash:IsStealable() 				return true end
function imba_tidehunter_anchor_smash:IsNetherWardStealable()		return true end
function imba_tidehunter_anchor_smash:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) - self:GetCaster():GetCastRangeBonus()
end

function imba_tidehunter_anchor_smash:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local smash_sound = "Hero_Tidehunter.AnchorSmash"
	local smash_pfx = "particles/units/heroes/hero_tidehunter/tidehunter_anchor_hero.vpcf"
	--音效
	caster:EmitSound("Hero_Tidehunter.AnchorSmash")
	
	local pfx = ParticleManager:CreateParticle(smash_pfx, PATTACH_ABSORIGIN, caster)
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local smash_radius = ability:GetSpecialValueFor("radius") + caster:GetCastRangeBonus()
	--imba 设置攻击次数
	local buff = caster:AddNewModifier(caster, self, "modifier_imba_tidehunter_anchor_smash_charge", {duration = self:GetSpecialValueFor("reduction_duration")})
	buff:IncrementStackCount()

	--范围查找
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		caster:GetAbsOrigin(), 
		nil, 
		smash_radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
		FIND_ANY_ORDER, 
		false)
	
	--额外攻击力
	caster:AddNewModifier(caster, self, "modifier_imba_tidehunter_anchor_smash_buff", {})
	for _, enemy in pairs(enemies) do
		--对肉山无效
		if not enemy:IsBoss() then
			--攻击一次 
			caster:PerformAttack(enemy, false, true, true, false, false, false, true)
			--不会对魔免单位造成DEBUFF
			if not enemy:IsMagicImmune() then
				enemy:AddNewModifier_RS(caster, self, "modifier_imba_tidehunter_anchor_smash_debuff", {duration = self:GetSpecialValueFor("reduction_duration")})
				--如果攻击次数超过3次 造成眩晕
				if buff:GetStackCount() >= self:GetSpecialValueFor("proc_count") then 
					--触手特效
					local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
					for i=0, 2 do
						ParticleManager:SetParticleControl(pfx, i, GetGroundPosition(enemy:GetAbsOrigin(), nil))
					end
					--造成晕眩
					enemy:AddNewModifier_RS(caster, self, "modifier_stunned", {duration = 1.4})
				end
			end
		end
	end
	--移除额外攻击力修饰器
	caster:RemoveModifierByName("modifier_imba_tidehunter_anchor_smash_buff")
	--imba 次数监测
	if buff:GetStackCount() >= self:GetSpecialValueFor("proc_count") then
		buff:Destroy()
	end
end

--减少攻击力
modifier_imba_tidehunter_anchor_smash_debuff = class({})
function modifier_imba_tidehunter_anchor_smash_debuff:IsHidden()			return false end
function modifier_imba_tidehunter_anchor_smash_debuff:IsDebuff()			return true end
function modifier_imba_tidehunter_anchor_smash_debuff:IsPurgable() 			return true end
function modifier_imba_tidehunter_anchor_smash_debuff:IsPurgeException() 	return true end
function modifier_imba_tidehunter_anchor_smash_debuff:DeclareFunctions()  return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE} end
function modifier_imba_tidehunter_anchor_smash_debuff:GetModifierBaseDamageOutgoing_Percentage() return self:GetAbility():GetSpecialValueFor("damage_reduction") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_tidehunter_3") end

--额外攻击力
modifier_imba_tidehunter_anchor_smash_buff = class({})
function modifier_imba_tidehunter_anchor_smash_buff:IsHidden()			return true end
function modifier_imba_tidehunter_anchor_smash_buff:IsDebuff()			return false end
function modifier_imba_tidehunter_anchor_smash_buff:IsPurgable() 		return false end
function modifier_imba_tidehunter_anchor_smash_buff:IsPurgeException() 	return false end
function modifier_imba_tidehunter_anchor_smash_buff:DeclareFunctions()  return {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE} end
function modifier_imba_tidehunter_anchor_smash_buff:GetModifierBaseAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("attack_damage") end

--次数
modifier_imba_tidehunter_anchor_smash_charge = class({})

function modifier_imba_tidehunter_anchor_smash_charge:IsHidden()			return false end
function modifier_imba_tidehunter_anchor_smash_charge:IsDebuff() 			return false end
function modifier_imba_tidehunter_anchor_smash_charge:IsPurgable() 			return false end
function modifier_imba_tidehunter_anchor_smash_charge:IsPurgeException()	return false end

--tidehunter_ravage 毁灭
--猛击地面，触手向各个方向穿出，伤害并眩晕附近所有敌方单位。
--imba 麦尔朗恩的宣告 : 持续晕眩时间内削弱3/4/5 + 自身英雄等级的护甲

---------------------------------------------------------------------
---------------- Tidehunter Ravage  ---------------------------------
---------------------------------------------------------------------
imba_tidehunter_ravage = class({})

LinkLuaModifier("modifier_imba_tidehunter_ravage_debuff","mb/hero_tidehunter.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tidehunter_ravage_order","mb/hero_tidehunter.lua", LUA_MODIFIER_MOTION_NONE)

function imba_tidehunter_ravage:IsHiddenWhenStolen() 		return false end
function imba_tidehunter_ravage:IsRefreshable() 			return true end
function imba_tidehunter_ravage:IsStealable() 				return true end
function imba_tidehunter_ravage:IsNetherWardStealable()		return true end
function imba_tidehunter_ravage:GetAOERadius() return self:GetSpecialValueFor("radius") end
function imba_tidehunter_ravage:GetCastRange(location , target)
	return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():GetCastRangeBonus()
end
function imba_tidehunter_ravage:GetCastPoint()
	--自动施法巨浪前摇
	if IsServer() then 
		if not self:GetAutoCastState() then 
			return self.BaseClass.GetCastPoint(self)
		end
		return self:GetSpecialValueFor("gush_castpoint")
	end
end

function imba_tidehunter_ravage:GetCastAnimation()
	if IsServer() then 
		if not self:GetAutoCastState() then 
			return self.BaseClass.GetCastAnimation(self)
		end
		return ACT_DOTA_VICTORY
	end
end

function imba_tidehunter_ravage:OnAbilityPhaseStart()
	--自动施法前摇动作
	if self:GetAutoCastState() then 
		local caster = self:GetCaster()
		-- 施法音效
		caster:EmitSound("Hero_Tidehunter.Taunt.BackStroke")
		-- 施法范围特效
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_anchor_hero.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:ReleaseParticleIndex(pfx)
		-- 添加一个不能关闭自动施法的操作指令
		caster:AddNewModifier(caster, self, "modifier_imba_tidehunter_ravage_order", {duration = self:GetSpecialValueFor("gush_castpoint")})
	end
	return true
end

function imba_tidehunter_ravage:OnAbilityPhaseInterrupted()
	if self:GetAutoCastState() then 
		local caster = self:GetCaster()
		-- 结束施法动作
		--caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
		caster:FadeGesture(ACT_DOTA_VICTORY)
		-- 施法音效
		caster:StopSound("Hero_Tidehunter.Taunt.BackStroke")
		-- 移除关闭自动施法的操作指令
		if caster:HasModifier("modifier_imba_tidehunter_ravage_order") then 
			caster:RemoveModifierByName("modifier_imba_tidehunter_ravage_order")
		end
	end
	return true
end

function imba_tidehunter_ravage:OnSpellStart()
	local caster = self:GetCaster()
	local pos = caster:GetAbsOrigin()
	if not self:GetCursorTargetingNothing() then
		pos = self:GetCursorPosition()
	end
	--音效和特效
	local ravage_sound = "Ability.Ravage"
	local ravage_target_sound = "Hero_Tidehunter.RavageDamage"
	---------------------------------------------------------------
	local ravage_pfx = "particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf"
	--if HeroItems:UnitHasItem(caster, "rubick_arcana") then
		ravage_pfx = "particles/units/heroes/hero_rubick/rubick_spell_ravage.vpcf"
	--end
	---------------------------------------------------------------
	--击飞参数
	local knockback_duration = self:GetSpecialValueFor("knockback_duration")
	local knockback_height = self:GetSpecialValueFor("knockback_height")
	local knockback_damage = self:GetAbilityDamage()
	local knock_table = {}
	local duration = self:GetSpecialValueFor("duration")
	--环参数
	local radius = self:GetSpecialValueFor("radius") + caster:TG_GetTalentValue("special_bonus_imba_tidehunter_4")
	local ring_count = self:GetSpecialValueFor("ring_count")
	local ring_radius = radius / ring_count
	local ring = 1

	if not self:GetAutoCastState() then
		-- 音效
		caster:EmitSound(ravage_sound)

		-- 特效
		local pfx = ParticleManager:CreateParticle(ravage_pfx, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		for i=1,ring_count do
			ParticleManager:SetParticleControl(pfx, i, Vector(ring_radius * i, 0 , 0))
		end
		ParticleManager:ReleaseParticleIndex(pfx)

		-- 以环状圈范围搜寻敌人
		Timers:CreateTimer(function()
			local enemies =	FindUnitsInRing(caster:GetTeamNumber(),
				pos,
				nil,
				ring * ring_radius ,
				ring_radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_DAMAGE_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)
			for _,enemy in pairs(enemies) do
				if not IsInTable(enemy, knock_table) then
					-- Emit hit sound
					enemy:EmitSound(ravage_target_sound)
					-- 击飞参数
					local knockback_table =
					{
						knockback_duration = knockback_duration,
						duration = knockback_duration,
						knockback_distance = 0,
						knockback_height = knockback_height,
					}
					if enemy:HasModifier("modifier_knockback") then 
						enemy:RemoveModifierByName("modifier_knockback")
					end
					--击飞修改器
					enemy:AddNewModifier(caster, self, "modifier_knockback", knockback_table)
					--击飞特效
					local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
					for i=0, 2 do
						ParticleManager:SetParticleControl(pfx, i, GetGroundPosition(enemy:GetAbsOrigin(), nil))
					end
						-- 落地造成伤害
						Timers:CreateTimer(knockback_duration, function()
						local damageTable = {
							victim = enemy,
							damage = knockback_damage,
							damage_type = self:GetAbilityDamageType(),
							attacker = caster,
							ability = self
						}
						ApplyDamage(damageTable)
						--击飞特效移除
						ParticleManager:ReleaseParticleIndex(pfx)
						-- 击飞落地后眩晕
						enemy:AddNewModifier_RS(caster, self, "modifier_stunned", {duration = duration})
						-- DEBUFF 
						enemy:AddNewModifier_RS(caster, self, "modifier_imba_tidehunter_ravage_debuff", {duration = duration})
						-- 移除被击飞动作
						enemy:RemoveGesture(ACT_DOTA_FLAIL)
						end)
					-- 记录已经被击飞的单位
					table.insert(knock_table, enemy)
				end
			end
				-- 下一个圈
				if ring < ring_count then
					ring = ring + 1
					return knockback_duration
				end
		end)
	else 
		--自动施法 环形巨浪
		local gush_count = self:GetSpecialValueFor("gush_count") + caster:TG_GetTalentValue("special_bonus_imba_tidehunter_4","value_autocast")
		local end_pos = pos + caster:GetForwardVector():Normalized() * radius
		for i=0, gush_count-1 do
			local gush_pos = GetGroundPosition(RotatePosition(pos, QAngle(0,i * (360 / gush_count),0), end_pos), nil)
			--施放巨浪
			local gush_ability = caster:FindAbilityByName("imba_tidehunter_gush")
			if gush_ability and gush_ability:GetLevel() > 0 then 
				caster:SetCursorPosition(gush_pos)
				gush_ability:OnSpellStart()
			end
		end
		--额外冷却时间
		if not self:IsCooldownReady() then 
			local abi_cd = self:GetCooldownTimeRemaining()
			self:StartCooldown(abi_cd + self:GetSpecialValueFor("gush_ex_cooldown"))
		end
	end
end

--持续晕眩时间内削弱3/4/5 + 自身英雄等级的护甲
modifier_imba_tidehunter_ravage_debuff = class({})

function modifier_imba_tidehunter_ravage_debuff:IsDebuff()				return true end
function modifier_imba_tidehunter_ravage_debuff:IsHidden() 				return false end
function modifier_imba_tidehunter_ravage_debuff:IsPurgable() 			return true end
function modifier_imba_tidehunter_ravage_debuff:IsPurgeException() 		return true end
function modifier_imba_tidehunter_ravage_debuff:OnCreated()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_searing_arrow_trail_ember.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end

function modifier_imba_tidehunter_ravage_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_tidehunter_ravage_debuff:GetModifierPhysicalArmorBonus() return (0 - (self:GetAbility():GetSpecialValueFor("negative_armor") + self:GetCaster():GetLevel())) end

--Order
modifier_imba_tidehunter_ravage_order = class({})
-------------------------------------------------------------------------------
-- Classifications
function modifier_imba_tidehunter_ravage_order:IsHidden() return true end
function modifier_imba_tidehunter_ravage_order:IsDebuff() return false end
function modifier_imba_tidehunter_ravage_order:IsPurgable() return false end
--------------------------------------------------------------------------------
-- Initializations
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_imba_tidehunter_ravage_order:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end

function modifier_imba_tidehunter_ravage_order:OnOrder( params )
	if params.unit~=self:GetParent() then return end
	if 	params.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO then
		if params.ability == self:GetAbility() then 
			self:GetAbility():ToggleAutoCast() --不允许前摇开始期间关闭/开启 自动施法
		end
	end
end

----------------------
--new shard

imba_tidehunter_calling_Maelrawn = class({})

function imba_tidehunter_calling_Maelrawn:IsHiddenWhenStolen() 		return false end
function imba_tidehunter_calling_Maelrawn:IsRefreshable() 			return true end
function imba_tidehunter_calling_Maelrawn:IsStealable() 				return true end
function imba_tidehunter_calling_Maelrawn:IsNetherWardStealable()		return true end
function imba_tidehunter_calling_Maelrawn:GetAOERadius() return self:GetSpecialValueFor("radius") end
function imba_tidehunter_calling_Maelrawn:GetCastRange(location , target)
	return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():GetCastRangeBonus()
end

function imba_tidehunter_calling_Maelrawn:OnHeroLevelUp()
	local level = self:GetCaster():GetLevel()
	local ability = self
	local level_to_set = math.min((math.floor((level + 1) / 2) - 1), ability:GetMaxLevel())
	if ability:GetLevel() ~= level_to_set then
		ability:SetLevel(level_to_set)
	end
end

function imba_tidehunter_calling_Maelrawn:OnInventoryContentsChanged()
	--魔晶技能
	---------------------------------------------------------------
	local caster=self:GetCaster()
	if self:GetCaster():Has_Aghanims_Shard() then 
        TG_Set_Scepter(caster,false,1,"imba_tidehunter_calling_Maelrawn")
    else
        TG_Set_Scepter(caster,true,1,"imba_tidehunter_calling_Maelrawn")
    end
	---------------------------------------------------------------
end

function imba_tidehunter_calling_Maelrawn:OnSpellStart()
	local caster = self:GetCaster()
	local startpos = caster:GetAbsOrigin()
	if not self:GetCursorTargetingNothing() then
		pos = self:GetCursorPosition()
	end
	--local direction = (pos - startpos):Normalized()
	local direction = caster:GetForwardVector()
	direction.z = 0.0
	--音效和特效
	local ravage_sound = "Ability.Ravage"
	local ravage_target_sound = "Hero_Tidehunter.RavageDamage"
	---------------------------------------------------------------
	--local ravage_pfx = "particles/units/heroes/hero_rubick/rubick_spell_ravage.vpcf"
	local ravage_pfx = "particles/units/heroes/hero_rubick/rubick_spell_ravage_hit.vpcf" 
	---------------------------------------------------------------
	--击飞参数
	local knockback_damage = self:GetAbilityDamage()
	local knock_table = {}
	local duration = self:GetSpecialValueFor("duration")
	--直线参数
	local radius = self:GetSpecialValueFor("radius") + caster:TG_GetTalentValue("special_bonus_imba_tidehunter_4")
	local width = self:GetSpecialValueFor("width")
	local endpos = startpos + direction * radius
	local cube_count = self:GetSpecialValueFor("cube_count")
	local cube_radius = radius / cube_count
	local cube = 1
	local cube_angle = caster:GetForwardVector()

	-- 音效
	local tidehunter_response = {"tidehunter_tide_win_03","Ability.Ravage","Item.GreevilWhistle"}
	EmitSoundOn(tidehunter_response[math.random(1, #tidehunter_response)], caster)

	-- 以直线距离搜寻敌人
	Timers:CreateTimer(function()
		local enemies =	FindUnitsInLine(
			caster:GetTeamNumber(),  --team: DOTATeam_t
			pos,  --startPos: Vector
			endpos - cube_angle * cube * cube_radius,  --endPos: Vector
			nil, --cacheUnit: CBaseEntity | nil
			math.max(width,cube_radius),  --width: float
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		)
		--特效
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_spell_ravage_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
		for i=0, 2 do
			ParticleManager:SetParticleControl(pfx, i, endpos - cube_angle * cube * cube_radius)
		end
		for _,enemy in pairs(enemies) do
			if not IsInTable(enemy, knock_table) then
				-- Emit hit sound
				enemy:EmitSound(ravage_target_sound)
				--攻击一次必中触发任何特效
				caster:PerformAttack(enemy, false, true, true, false, false, false, true)	
				--DEBUFF 不能技能免疫
				if not enemy:IsMagicImmune() then
					enemy:AddNewModifier_RS(caster, self, "modifier_imba_tidehunter_ravage_debuff", {duration = duration})
					enemy:AddNewModifier_RS(caster, self, "modifier_stunned", {duration = duration})
				end
				--记录已经被击飞的单位
				table.insert(knock_table, enemy)
			end
		end
		--特效移除
		ParticleManager:ReleaseParticleIndex(pfx)
		--下一个
		if cube < cube_count then
			cube = cube + 1
			return 0.2
		end
	end)
end