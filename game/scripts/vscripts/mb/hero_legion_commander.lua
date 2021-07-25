-- Author:MysticBug xx/xx/2020
--extra api
CreateTalents("npc_dota_hero_legion_commander", "mb/hero_legion_commander.lua")
function IsEnemy(caster, target)
  if caster:GetTeamNumber()==target:GetTeamNumber() then   
    return false  
  else
    return true
  end 
end

function TriggerStandardTargetSpell(BaseNPC,ability)
	if IsEnemy(BaseNPC, ability:GetCaster()) then
		BaseNPC:TriggerSpellReflect(ability)
		return BaseNPC:TriggerSpellAbsorb(ability)
	end
	return false
end
--重伤
--冲锋
--------------------------------------------------------------
--	    IMBA_LEGION_COMMANDER_OVERWHELMING_ODDS     	    --
--------------------------------------------------------------
imba_legion_commander_overwhelming_odds = class({})

imba_legion_commander_overwhelming_odds.false_extend_buff = {
	"modifier_imba_legion_commander_overwhelming_odds_buff",
	"modifier_imba_legion_commander_duel_shard",
	"modifier_item_bkbs_buff",
	"modifier_item_bkb_buff",
	"modifier_imba_legion_commander_duel",
}

LinkLuaModifier("modifier_imba_legion_commander_overwhelming_odds_buff", "mb/hero_legion_commander.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_legion_commander_overwhelming_odds_debuff", "mb/hero_legion_commander.lua", LUA_MODIFIER_MOTION_NONE)

function imba_legion_commander_overwhelming_odds:IsHiddenWhenStolen() 			return false end
function imba_legion_commander_overwhelming_odds:IsRefreshable() 				return true end
function imba_legion_commander_overwhelming_odds:IsStealable() 				return true end
function imba_legion_commander_overwhelming_odds:IsNetherWardStealable()		return false end
function imba_legion_commander_overwhelming_odds:GetAOERadius() return self:GetSpecialValueFor("radius") + self:GetCaster():GetCastRangeBonus() end
function imba_legion_commander_overwhelming_odds:GetCastRange(location , target)
	return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():GetCastRangeBonus()
end
function imba_legion_commander_overwhelming_odds:OnSpellStart()
	local caster = self:GetCaster()
	local caster_pos = self:GetCaster():GetAbsOrigin()
	if not self:GetCursorTargetingNothing() then
		caster_pos = self:GetCursorPosition()
	end
	--load data
	--Hero_LegionCommander.Overwhelming.Cast qianyao
	local sound_cast = "Hero_LegionCommander.Overwhelming.Location"
	local damage = self:GetSpecialValueFor("damage")
	local damage_per_unit = self:GetSpecialValueFor("damage_per_unit")
	local damage_per_hero = self:GetSpecialValueFor("damage_per_hero")
	local illusion_dmg_pct = self:GetSpecialValueFor("illusion_dmg_pct")

	local bonus_speed_creeps = self:GetSpecialValueFor("bonus_speed_creeps")
	local bonus_speed_heroes = self:GetSpecialValueFor("bonus_speed_heroes")

	local odds_duration = self:GetSpecialValueFor("duration")
	local odds_radius = self:GetSpecialValueFor("radius") + caster:GetCastRangeBonus()

	local buff_modifier = "modifier_imba_legion_commander_overwhelming_odds_buff"
	local debuff_modifier = "modifier_imba_legion_commander_overwhelming_odds_debuff"
	--Pre Damage Table
	local damage_table = ({
					--victim = enemy,
					attacker = caster,
					ability = self,
					--damage = self.damage,
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					damage_type = self:GetAbilityDamageType()
				})
	--音效
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_cast, caster)
	--范围查找
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, odds_radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER, false)

	local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			caster_pos, 
			nil, 
			odds_radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER, 
			false)
	--特效
	local pfx = ParticleManager:CreateParticle("particles/econ/items/legion/legion_overwhelming_odds_ti7/legion_commander_odds_ti7.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster_pos)
	--Pre Damage --maybe #table some memebers is nill?
	local final_damage = damage + damage_per_unit * #units + damage_per_hero * math.max(#enemies - #units,1)
	--print("how many units?",#enemies,#units,final_damage)
	for _,enemy in pairs(enemies) do
		if not enemy:IsMagicImmune() then
			damage_table.damage = final_damage 
			damage_table.victim = enemy
			ApplyDamage(damage_table)
			--幻象和召唤物 额外附加百分比伤害
			if enemy:IsSummoned() or enemy:IsIllusion() then
				damage_table.damage = math.floor(enemy:GetMaxHealth() * illusion_dmg_pct / 100)
				ApplyDamage(damage_table)
			end
			--IMBA 箭伤效果
			enemy:AddNewModifier_RS(self:GetCaster(), self, debuff_modifier, {duration = odds_duration})
			enemy:EmitSound("Hero_LegionCommander.Overwhelming.Hero")
		end
	end
	--释放特效
	ParticleManager:ReleaseParticleIndex(pfx)

	--buff self
	local bonus_speed = math.max(#enemies - #units,1) * bonus_speed_heroes + #units * bonus_speed_creeps
	caster:AddNewModifier(caster, self, buff_modifier, {duration = odds_duration , bonus_speed = bonus_speed})
	caster:EmitSound("Hero_LegionCommander.Overwhelming.Buff")
	--IMBA Buff Self
	if caster:GetModifierCount() > 0 then
		local buffs = caster:FindAllModifiers()
		for _, buff in pairs(buffs) do
			if (not buff:IsDebuff() or buff:GetCaster():GetTeamNumber() ~= caster:GetTeamNumber()) and not (buff.IsMotionController and buff:IsMotionController()) and buff:GetDuration() >= 0.5 and not IsInTable(buff:GetName(), self.false_extend_buff) then
				local duration = (buff:GetRemainingTime() + self:GetSpecialValueFor("buff_duration") + 0.1 * #enemies)
				buff:SetDuration(duration, true)
			end
		end
	end
end

--DEBUFF 箭伤 降低回复效果
modifier_imba_legion_commander_overwhelming_odds_debuff = class({})

function modifier_imba_legion_commander_overwhelming_odds_debuff:IsDebuff()		return true end
function modifier_imba_legion_commander_overwhelming_odds_debuff:IsHidden() 		return false end
function modifier_imba_legion_commander_overwhelming_odds_debuff:IsPurgable() 		return false end
function modifier_imba_legion_commander_overwhelming_odds_debuff:IsPurgeException() 	return true end
function modifier_imba_legion_commander_overwhelming_odds_debuff:GetEffectName() return "particles/econ/items/legion/legion_overwhelming_odds_ti7/legion_commander_odds_ti7_buff.vpcf" end
function modifier_imba_legion_commander_overwhelming_odds_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_legion_commander_overwhelming_odds_debuff:OnCreated()
    if self:GetAbility()==nil then return end 
    self.ability=self:GetAbility()	
    self.heal_amp=self:GetAbility():GetSpecialValueFor( "heal_amp")
    self.heal_rate=self:GetAbility():GetSpecialValueFor( "heal_rate")
end

function modifier_imba_legion_commander_overwhelming_odds_debuff:OnRefresh()
   self:OnCreated()
end
function modifier_imba_legion_commander_overwhelming_odds_debuff:DeclareFunctions()
 	return 
    {
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    }
end
function modifier_imba_legion_commander_overwhelming_odds_debuff:GetModifierHealAmplify_PercentageTarget() return  0-self.heal_amp end
function modifier_imba_legion_commander_overwhelming_odds_debuff:GetModifierHPRegenAmplify_Percentage() return 0-self.heal_rate end

--Buff 增加自身移速
modifier_imba_legion_commander_overwhelming_odds_buff = class({})

function modifier_imba_legion_commander_overwhelming_odds_buff:IsDebuff()			return false end
function modifier_imba_legion_commander_overwhelming_odds_buff:IsHidden() 			return false end
function modifier_imba_legion_commander_overwhelming_odds_buff:IsPurgable() 		return false end
function modifier_imba_legion_commander_overwhelming_odds_buff:GetEffectName() return "particles/econ/items/legion/legion_overwhelming_odds_ti7/legion_commander_odds_ti7_buff.vpcf" end
function modifier_imba_legion_commander_overwhelming_odds_buff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_legion_commander_overwhelming_odds_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_legion_commander_overwhelming_odds_buff:OnCreated(keys) if IsServer() then self.bonus_speed = keys.bonus_speed end end
function modifier_imba_legion_commander_overwhelming_odds_buff:GetModifierMoveSpeedBonus_Percentage() return self.bonus_speed end


--------------------------------------------------------------
--	    IMBA_LEGION_COMMANDER_PRESS_THE_ATTACK     	        --
--------------------------------------------------------------
imba_legion_commander_press_the_attack = class({})

LinkLuaModifier("modifier_imba_legion_commander_press_the_attack", "mb/hero_legion_commander.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_legion_commander_immune", "mb/hero_legion_commander.lua", LUA_MODIFIER_MOTION_NONE)

function imba_legion_commander_press_the_attack:IsHiddenWhenStolen() 			return false end
function imba_legion_commander_press_the_attack:IsRefreshable() 				return true end
function imba_legion_commander_press_the_attack:IsStealable() 				return true end
function imba_legion_commander_press_the_attack:IsNetherWardStealable()		return false end
function imba_legion_commander_press_the_attack:GetCooldown( iLevel )
	return self.BaseClass.GetCooldown( self, iLevel ) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_legion_commander_4")
end
function imba_legion_commander_press_the_attack:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local sound_cast = "Hero_LegionCommander.PressTheAttack"
	local press_duration = self:GetSpecialValueFor("duration")
	--音效
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_cast, caster)
	--强驱散一次
	target:Purge(false, true, false, true, true)
	target:AddNewModifier(caster, self, "modifier_imba_legion_commander_press_the_attack", {duration = press_duration})
	if target ~= caster then 
		caster:Purge(false, true, false, true, true)
		caster:AddNewModifier(caster, self, "modifier_imba_legion_commander_press_the_attack", {duration = press_duration})
	end
	--天赋 获得 2.5s技能免疫效果
	if caster:TG_HasTalent("special_bonus_imba_legion_commander_5") then 
		target:AddNewModifier(caster, self, "modifier_imba_legion_commander_immune", {duration = caster:TG_GetTalentValue("special_bonus_imba_legion_commander_5")})
		if target ~= caster then 
			caster:AddNewModifier(caster, self, "modifier_imba_legion_commander_immune", {duration = caster:TG_GetTalentValue("special_bonus_imba_legion_commander_5")})
		end
	end
end
--攻速 回复 imba 状态
modifier_imba_legion_commander_press_the_attack = class({})

function modifier_imba_legion_commander_press_the_attack:IsDebuff()			return false end
function modifier_imba_legion_commander_press_the_attack:IsHidden() 			return false end
function modifier_imba_legion_commander_press_the_attack:IsPurgable() 		return true end
function modifier_imba_legion_commander_press_the_attack:IsPurgeException() 	return true end
--不朽特效
function modifier_imba_legion_commander_press_the_attack:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING} end
function modifier_imba_legion_commander_press_the_attack:OnCreated(keys)
	if self:GetAbility()==nil then return end
	if IsServer() then 
		local pfx = ParticleManager:CreateParticle("particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		for a=0,3 do 
			ParticleManager:SetParticleControl(pfx,a,self:GetParent():GetAbsOrigin())
		end 
		self:AddParticle(pfx, false, false, 20, false, false)
	end 
 end
function modifier_imba_legion_commander_press_the_attack:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("attack_speed") end
function modifier_imba_legion_commander_press_the_attack:GetModifierConstantHealthRegen() return self:GetAbility():GetSpecialValueFor("hp_regen") end
function modifier_imba_legion_commander_press_the_attack:GetModifierStatusResistanceStacking() return self:GetAbility():GetSpecialValueFor("status_resistance") end
function modifier_imba_legion_commander_press_the_attack:OnDestroy() end

modifier_imba_legion_commander_immune = class({})

function modifier_imba_legion_commander_immune:IsHidden() 			return false end
function modifier_imba_legion_commander_immune:IsPurgable() 		return false end
function modifier_imba_legion_commander_immune:IsPurgeException() return false end
function modifier_imba_legion_commander_immune:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_imba_legion_commander_immune:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_legion_commander_immune:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true,} end
------------------------------------------------------------------------------
---------------Legion Commander Moment Of Courage-----------------------------
------------------------------------------------------------------------------
imba_legion_commander_moment_of_courage = class({})

LinkLuaModifier("modifier_imba_legion_commander_moment_of_courage_passive", "mb/hero_legion_commander.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_legion_commander_moment_of_courage_lifesteal", "mb/hero_legion_commander.lua", LUA_MODIFIER_MOTION_NONE)

function imba_legion_commander_moment_of_courage:GetIntrinsicModifierName() return "modifier_imba_legion_commander_moment_of_courage_passive" end
--远程偏斜
function imba_legion_commander_moment_of_courage:OnProjectileHit_ExtraData( target, location, ExtraData )
	if not target then return end
	--print("RangedAttacker hit ---",ExtraData.projdamage)
	ApplyDamage(  
		{
		victim = target,
		attacker = self:GetCaster(),
		damage = ExtraData.projdamage,	
		ability = self,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		}
	)
end
modifier_imba_legion_commander_moment_of_courage_passive = class({})

function modifier_imba_legion_commander_moment_of_courage_passive:IsDebuff()			return false end
function modifier_imba_legion_commander_moment_of_courage_passive:IsHidden() 			return true end
function modifier_imba_legion_commander_moment_of_courage_passive:IsPurgable() 		return false end
function modifier_imba_legion_commander_moment_of_courage_passive:IsPurgeException() 	return false end
function modifier_imba_legion_commander_moment_of_courage_passive:DeclareFunctions()	return {MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,MODIFIER_EVENT_ON_ATTACK_LANDED} end
--招架 偏斜
function modifier_imba_legion_commander_moment_of_courage_passive:GetModifierPhysical_ConstantBlock(keys)
	if not IsServer() then return end
	if keys.target ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() then
		return 
	end
	--技能不计算
	if keys.inflictor then return  end
	--计算概率
	if self:GetAbility():IsCooldownReady() and PseudoRandom:RollPseudoRandom(self:GetAbility(), self:GetAbility():GetSpecialValueFor("trigger_chance") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_legion_commander_2")) then
		--吸血BUFF
		--print("attack chance ",self:GetAbility():GetSpecialValueFor("trigger_chance") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_legion_commander_2"))
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_legion_commander_moment_of_courage_lifesteal", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})
		--远程偏斜
		--反击攻击距离内的任意单位
		if keys.attacker:IsRangedAttacker() and not self:GetParent():IsDisarmed() then
			local range_block_radius = self:GetAbility():GetSpecialValueFor("range_block_radius")
			local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(), 
			self:GetParent():GetAbsOrigin(), 
			nil, 
			range_block_radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, 
			FIND_FARTHEST, 
			false)
			for _, enemy in pairs(enemies) do
				if not enemy:IsInvisible() and not enemy:IsInvulnerable() then
					--偏斜
					local info =
					{
						Target = enemy,
						Source = self:GetParent(),
						Ability = self:GetAbility(),
						EffectName = keys.attacker:GetRangedProjectileName(),
						iMoveSpeed = 2000,
						vSourceLoc = self:GetParent():GetAbsOrigin(),
						bDrawsOnMinimap = false,
						bDodgeable = true,
						bIsAttack = true,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						bProvidesVision = false,
						ExtraData = {
							projdamage = keys.damage
						}
					} 
					ProjectileManager:CreateTrackingProjectile(info)
					--反击动作
					self:GetParent():StartGesture(ACT_DOTA_ATTACK)
					break
				end
			end
			--偏斜降低伤害
			return keys.damage * (self:GetAbility():GetSpecialValueFor("range_block_pct") / 100)
		else
			--近战招架 然后 反击
			if not keys.attacker:IsInvisible() and not keys.attacker:IsInvulnerable() and not keys.attacker:IsOutOfGame() and keys.attacker:IsAlive() and not self:GetParent():IsDisarmed() then
				--反击动作
				self:GetParent():StartGesture(ACT_DOTA_ATTACK)
				--反击一次
				self:GetParent():PerformAttack(keys.attacker, false, true, true, false, true, false, false)
				--动作结束
			end
			--降低伤害
			return keys.damage * (self:GetAbility():GetSpecialValueFor("melee_block_pct") / 100)
		end
	end
end
function modifier_imba_legion_commander_moment_of_courage_passive:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	if self:GetParent():HasModifier("modifier_imba_legion_commander_moment_of_courage_lifesteal") then
		--print("Courage Heal",keys.damage)
		--反击音效
		self:GetParent():EmitSound("Hero_LegionCommander.Courage")
		--吸血
		self:GetParent():Heal(keys.damage * (self:GetAbility():GetSpecialValueFor("hp_leech_percent") / 100), self:GetAbility())
		--吸血特效
		local pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(pfx)
		--吸血数值显示
		SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(), keys.damage * (self:GetAbility():GetSpecialValueFor("hp_leech_percent") / 100), self:GetParent())
		--技能冷却
		self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(-1)) * self:GetParent():GetCooldownReduction())
		--移除
		self:GetParent():RemoveModifierByName("modifier_imba_legion_commander_moment_of_courage_lifesteal")
	end
end

--勇气之霎持续时间
modifier_imba_legion_commander_moment_of_courage_lifesteal = class({})

function modifier_imba_legion_commander_moment_of_courage_lifesteal:IsDebuff()			return false end
function modifier_imba_legion_commander_moment_of_courage_lifesteal:IsBuff()			return true end
function modifier_imba_legion_commander_moment_of_courage_lifesteal:IsHidden() 			return false end
function modifier_imba_legion_commander_moment_of_courage_lifesteal:IsPurgable() 		return false end
function modifier_imba_legion_commander_moment_of_courage_lifesteal:IsPurgeException() 	return false end

--------------------------------------------------------------
--	    		IMBA_LEGION_COMMANDER_DUEL     	       		--
--------------------------------------------------------------
imba_legion_commander_duel = class({})

LinkLuaModifier("modifier_imba_legion_commander_duel", "mb/hero_legion_commander.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_legion_commander_duel_buff", "mb/hero_legion_commander.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_legion_commander_duel_shard", "mb/hero_legion_commander.lua", LUA_MODIFIER_MOTION_NONE)

function imba_legion_commander_duel:IsHiddenWhenStolen() 			return false end
function imba_legion_commander_duel:IsRefreshable() 				return true end
function imba_legion_commander_duel:IsStealable() 				return true end
function imba_legion_commander_duel:IsNetherWardStealable()		return false end
function imba_legion_commander_duel:OnOwnerDied()
	if self:GetAutoCastState() then 
		self:ToggleAutoCast()
	end
end
function imba_legion_commander_duel:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	--林肯直接结束
	if target:TriggerSpellAbsorb(self) then 
		return 
	end
	--如果是幻象直接秒杀
	if target:IsIllusion() then
		target:Kill(self, caster)
		return
	end
	--load kv
	local sound_cast = "Hero_LegionCommander.Duel.Cast"
	local duel_radius = self:GetSpecialValueFor("victory_range")
	local dark_duel_radius = self:GetSpecialValueFor("dark_duel_range")
	local duel_duration = self:GetSpecialValueFor("duration")
	local reward_damage = self:GetSpecialValueFor("reward_damage") + caster:TG_GetTalentValue("special_bonus_imba_legion_commander_3")

	local min_reward_damage = self:GetSpecialValueFor("min_reward_damage_pct") * reward_damage / 100
	--if HeroItems:UnitHasItem(self:GetCaster(), "legion_commander_arcana") then
		sound_cast = "Hero_LegionCommander.Duel.Cast.Arcana"
	--end
	if caster:HasScepter() then 
		duel_duration = self:GetSpecialValueFor("duration_scepter")
	end
	----------------------------------------------------------------------------------------------
	--check auto cast 
	if not self:GetAutoCastState() then
		--音效
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_cast, caster)
		--对自己施法强攻
		local press_abi = caster:FindAbilityByName("imba_legion_commander_press_the_attack")
		if press_abi then 
			caster:SetCursorCastTarget(caster)
			press_abi:OnSpellStart()
		end
		--普通决斗
		caster:AddNewModifier(caster, self, "modifier_imba_legion_commander_duel",{duration = duel_duration, duel_target = target:entindex()})
		caster:AddNewModifier(caster, self, "modifier_imba_legion_commander_duel_buff",{duration = duel_duration})
		target:AddNewModifier(caster, self, "modifier_imba_legion_commander_duel",{duration = duel_duration, duel_target = caster:entindex()})
		target:AddNewModifier(caster, self, "modifier_imba_legion_commander_duel_buff",{duration = duel_duration})
	else
		--黑暗决斗
		--清空
		self.teammates_table = {}
		self.enemies_table = {}
		--敌方
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			target:GetAbsOrigin(), 
			nil, 
			dark_duel_radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO, 
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, --只寻找在视野范围内的,幻象不能参加,无视技能免疫
			FIND_ANY_ORDER, 
			false)
		--cal damage
		self.enemies_table.divide_reward_damage = math.max(min_reward_damage,reward_damage / (#enemies or 1))
		--add duel 
		for _, enemy in pairs(enemies) do
			if enemy:IsAlive() then
				enemy:AddNewModifier(caster, self, "modifier_imba_legion_commander_duel", {duration = duel_duration, duel_target = caster:entindex() , bdark_duel = true})
				table.insert(self.enemies_table,enemy:entindex())
			end
		end
		
		--我方
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			caster:GetAbsOrigin(), 
			nil, 
			dark_duel_radius, 
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
			DOTA_UNIT_TARGET_HERO, 
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, --只寻找在视野范围内的，幻象不能参加
			FIND_ANY_ORDER, 
			false)
		--cal damage
		self.teammates_table.divide_reward_damage = math.max(min_reward_damage,reward_damage / (#units or 1))
		--add duel 
		for _, unit in pairs(units) do
			if unit:IsAlive() then
				unit:AddNewModifier(caster, self, "modifier_imba_legion_commander_duel", {duration = duel_duration, duel_target = target:entindex() , bdark_duel = true})
				table.insert(self.teammates_table,unit:entindex())
			end
		end
	end
	--新增魔晶效果
	if caster:Has_Aghanims_Shard() then 
		caster:AddNewModifier(caster, self, "modifier_imba_legion_commander_duel_shard", {duration = duel_duration, duel_target = target:entindex()})
	end
end

modifier_imba_legion_commander_duel = class({})

function modifier_imba_legion_commander_duel:IsDebuff()				return false end
function modifier_imba_legion_commander_duel:IsBuff()				return false end
function modifier_imba_legion_commander_duel:IsHidden() 			return false end
function modifier_imba_legion_commander_duel:IsPurgable() 			return false end
function modifier_imba_legion_commander_duel:IsPurgeException() 	return false end
function modifier_imba_legion_commander_duel:RemoveOnDeath() 		return true end
function modifier_imba_legion_commander_duel:DeclareFunctions() 
	local funcs = {
		MODIFIER_EVENT_ON_HERO_KILLED,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end
function modifier_imba_legion_commander_duel:OnCreated(keys)
	if IsServer() then
		self.duel_target = EntIndexToHScript(keys.duel_target)
		self.duel_winner = nil
		self.bdark_duel = keys.bdark_duel
	
		self:GetParent():SetForceAttackTarget( self.duel_target ) -- for creeps
		self:GetParent():MoveToTargetToAttack( self.duel_target ) -- for heroes
		--决斗发起者创建特效
		if self:GetParent() == self:GetCaster() then
			--print("duel first",self:GetParent():GetName())
			--决斗圈特效
			local pfx_name = "particles/units/heroes/hero_legion_commander/legion_duel_ring.vpcf"
			--if HeroItems:UnitHasItem(self:GetCaster(), "legion_commander_arcana") then
				pfx_name = "particles/econ/items/legion/legion_weapon_voth_domosh/legion_duel_ring_arcana.vpcf"
			--end
			--黑暗决斗
			if self:GetAbility():GetAutoCastState() then 
				pfx_name = "particles/juedou/legion_dark_duel_ring.vpcf"
			end
			self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_POINT_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(self.pfx, 60, Vector(8,299,96))
			ParticleManager:SetParticleControl(self.pfx, 61, Vector(0,0,0))
			self:AddParticle(self.pfx, false, false, 16, false, false)
			--播放循环音效
			EmitSoundOn("Hero_LegionCommander.Duel.FP", self:GetCaster())	
		end
		--更新目标或者攻击对象  无敌的目标会导致不攻击了
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_legion_commander_duel:OnIntervalThink()
	if IsServer() then
		self:GetParent():SetForceAttackTarget( self.duel_target ) -- for creeps
		self:GetParent():MoveToTargetToAttack( self.duel_target ) -- for heroes
		--敌法盾BUG 黑暗决斗BUG
		if (self.duel_target:GetName() == "npc_dota_thinker") or (self:GetParent():GetName() == "npc_dota_thinker") or not self:GetCaster():HasModifier("modifier_imba_legion_commander_duel") then 
			self:GetParent():Stop()
			self:Destroy()
		end
	end
end
function modifier_imba_legion_commander_duel:OnHeroKilled(keys)
	if not IsServer() then
		return
	end
	--print("team damage +++ enemies damage ---",self:GetAbility().teammates_table.divide_reward_damage,self:GetAbility().enemies_table.divide_reward_damage)
	--jugg
	--attack jugg  target lc                          
	--attack lc    target jugg      	
	if keys.target == self.duel_target then 
		self.duel_winner = self:GetParent()
		self:Destroy()
	end
	if self.duel_target ~= nil and not self.duel_target:IsAlive() then 
		self:Destroy()
	end
	if not self:GetCaster():IsAlive() then 
		self:Destroy()
	end
end
--神帐只受到来自决斗双方的伤害
function modifier_imba_legion_commander_duel:GetModifierIncomingDamage_Percentage(keys)
	if not self:GetCaster():HasScepter() then return 0 end
	--print("duel damage check",keys.attacker:GetName(),self.duel_target:GetName(),self:GetParent():GetName())
	if self.bdark_duel then
		if not IsInTable(keys.attacker:entindex(), self:GetAbility().enemies_table) and not IsInTable(keys.attacker:entindex(), self:GetAbility().teammates_table) then 
			return -100
		else
			return 0
		end
	end 
	if keys.attacker ~= self.duel_target and keys.attacker ~= self:GetParent() then 
		return -100
	end
end
function modifier_imba_legion_commander_duel:OnRemoved()
	if IsServer() then
		self:GetParent():SetForceAttackTarget( nil )
	end
end
function modifier_imba_legion_commander_duel:OnDestroy()
	if IsServer() then 
		--赢的英雄获得攻击力加成
		if self.duel_winner and self.duel_winner ~= nil and self.duel_winner == self:GetParent() then 
			local final_reward_damage = self:GetAbility():GetSpecialValueFor("reward_damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_legion_commander_3")
			if self.bdark_duel then 
				--平分攻击力
				--print("team damage +++ enemies damage ---",self:GetAbility().teammates_table.divide_reward_damage,self:GetAbility().enemies_table.divide_reward_damage)
				if self.duel_winner:GetTeamNumber() == self:GetCaster():GetTeamNumber() then 
					final_reward_damage = self:GetAbility().teammates_table.divide_reward_damage
				elseif self.duel_winner:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
					final_reward_damage = self:GetAbility().enemies_table.divide_reward_damage
				end
			end
			self.duel_winner:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_legion_commander_duel_damage_boost",{})
			self.duel_winner:SetModifierStackCount("modifier_legion_commander_duel_damage_boost", nil, self.duel_winner:GetModifierStackCount("modifier_legion_commander_duel_damage_boost", nil) + final_reward_damage)
			self.duel_winner:CalculateStatBonus(true) --刷新状态 攻击力
			--胜利音效
			self.duel_winner:EmitSound("Hero_LegionCommander.Duel.Victory")
			--胜利特效
			local winner_pfx_name = "particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf"
			local winner_pfx = ParticleManager:CreateParticle(winner_pfx_name, PATTACH_OVERHEAD_FOLLOW, self.duel_winner)
			ParticleManager:ReleaseParticleIndex(winner_pfx)
			ParticleManager:DestroyParticle(winner_pfx, false)
			--释放强攻
			local press_abi = self:GetCaster():FindAbilityByName("imba_legion_commander_press_the_attack")
			if press_abi then 
				self:GetCaster():SetCursorCastTarget(self.duel_winner)
				press_abi:OnSpellStart()
			end
		end
		--释放特效
		if self:GetParent() == self:GetCaster() and self.pfx ~= nil then 
			ParticleManager:DestroyParticle(self.pfx, false)
			self.pfx = nil
			--结束决斗音效
			self:GetCaster():StopSound("Hero_LegionCommander.Duel.FP")
			local press_abi = self:GetCaster():FindAbilityByName("imba_legion_commander_press_the_attack")
			if press_abi then 
				self:GetCaster():SetCursorCastTarget(self:GetCaster())
				press_abi:OnSpellStart()
			end
		end
		--clear kv
		self.duel_target = nil 
		self.duel_winner = nil
		self.bdark_duel = nil 
	end
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_imba_legion_commander_duel:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true, --无视命令控制
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, --飞行穿树用
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true, --穿越单位和地形
		[MODIFIER_STATE_SILENCED] = true, --沉默不能施法
		[MODIFIER_STATE_MUTED] = true, --禁物品
		[MODIFIER_STATE_MAGIC_IMMUNE] = (self:GetCaster():HasScepter() and self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber()),
	}
	return state
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_imba_legion_commander_duel:GetEffectName() 
	return (self:GetCaster():HasScepter() and self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and "particles/items_fx/black_king_bar_avatar.vpcf") 
end
function modifier_imba_legion_commander_duel:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_legion_commander_duel:GetStatusEffectName()
	return "particles/status_fx/status_effect_legion_commander_duel.vpcf"
end
function modifier_imba_legion_commander_duel:StatusEffectPriority() 
    return 100 
end

modifier_imba_legion_commander_duel_buff = class({})
function modifier_imba_legion_commander_duel_buff:IsDebuff()			return false end
function modifier_imba_legion_commander_duel_buff:IsBuff()				return false end
function modifier_imba_legion_commander_duel_buff:IsHidden() 			return true end
function modifier_imba_legion_commander_duel_buff:IsPurgable() 			return false end
function modifier_imba_legion_commander_duel_buff:IsPurgeException() 	return false end
function modifier_imba_legion_commander_duel_buff:DeclareFunctions()     return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
--单挑提升护甲或者降低护甲
function modifier_imba_legion_commander_duel_buff:GetModifierPhysicalArmorBonus() 
	--print("duel_armor +++",IsEnemy(self:GetCaster(), self:GetParent()) and (0 - self:GetAbility():GetSpecialValueFor("duel_armor")) or self:GetAbility():GetSpecialValueFor("duel_armor"))
	return IsEnemy(self:GetCaster(), self:GetParent()) and (0 - self:GetAbility():GetSpecialValueFor("duel_armor")) or self:GetAbility():GetSpecialValueFor("duel_armor")
end

-------------------------------------------------------------
--Shard Abi 
modifier_imba_legion_commander_duel_shard = class({})

function modifier_imba_legion_commander_duel_shard:IsDebuff()			return false end
function modifier_imba_legion_commander_duel_shard:IsBuff()				return false end
function modifier_imba_legion_commander_duel_shard:IsHidden() 			return false end
function modifier_imba_legion_commander_duel_shard:GetTexture()			return "item_aghanims_shard" end
function modifier_imba_legion_commander_duel_shard:IsPurgable() 			return false end
function modifier_imba_legion_commander_duel_shard:IsPurgeException() 	return false end
function modifier_imba_legion_commander_duel_shard:RemoveOnDeath() 		return true end
function modifier_imba_legion_commander_duel_shard:OnCreated( keys )
	if IsServer() then
		self.duel_target = EntIndexToHScript(keys.duel_target)
		--2 sec cast odds once 
		self:StartIntervalThink(2.0) 
		--Cast odds quickly
		local odds_abi = self:GetCaster():FindAbilityByName("imba_legion_commander_overwhelming_odds") 
		if odds_abi and odds_abi:GetLevel() > 0 then 
			self:GetCaster():SetCursorPosition(self.duel_target:GetAbsOrigin())
			odds_abi:OnSpellStart()
		end
	end
end

function modifier_imba_legion_commander_duel_shard:OnIntervalThink()
	-------------------------------------------------------------------------
	--Value Shard Abi 
	--Cast odds!
	local odds_abi = self:GetCaster():FindAbilityByName("imba_legion_commander_overwhelming_odds") 
	if odds_abi and odds_abi:GetLevel() > 0 then 
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(), 
			self:GetParent():GetAbsOrigin(), 
			nil, 
			900, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO, 
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, --只寻找在视野范围内的
			FIND_ANY_ORDER, 
			false)
		if #enemies > 0 then 
			self:GetCaster():SetCursorPosition((enemies[RandomInt(1,#enemies)]):GetAbsOrigin())
		else
			local forward_pos = GetGroundPosition(( self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * 250 ), nil) 
			self:GetCaster():SetCursorPosition(forward_pos)
		end
		odds_abi:OnSpellStart()
	end
	-------------------------------------------------------------------------
end

function modifier_imba_legion_commander_duel_shard:OnDestroy()
	if IsServer() then 
		--Cast End Odds! 
		local odds_abi = self:GetCaster():FindAbilityByName("imba_legion_commander_overwhelming_odds") 
		if odds_abi and odds_abi:GetLevel() > 0 then
			local forward_pos = GetGroundPosition(( self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * 250 ), nil) 
			self:GetCaster():SetCursorPosition(forward_pos)
			odds_abi:OnSpellStart()
		end
		self.duel_target = nil 
	end
end