if L_TG == nil then
	L_TG = class({})
	_G.L_TG = L_TG
end


require('game')
require('addon_init')
require('precache')
require('tools/notifications')
require('tools/timers')
require('tools/tg_utils')
require('tools/util')
require('tools/network')
require('tools/pseudorandom')
require('tools/abilitychargecontroller')
require('events/events')
require('events/custom_events')
require('units/unit')
require('towers/building')
require('players/player')
require('tools/keyvalues')
require('tools/animations')
function Precache( context )
	GameRules.L_TG = L_TG()


	--加载
	Awake()

	PrecacheItemByNameSync( "item_ward_sentry", context )
	PrecacheItemByNameSync( "item_ward_observer", context )
	PrecacheItemByNameSync( "item_magic_wand", context )
	PrecacheItemByNameSync( "item_faerie_fire", context )
	PrecacheItemByNameSync( "item_enchanted_mango", context )
	PrecacheItemByNameSync( "item_refresher_shard", context )

	--音效
	PrecacheResource("soundfile", "soundevents/new_soundevents.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/imba_soundevents.vsndevts", context)

	for hero, _ in pairs(HEROSKV) do
		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_"..string.sub(hero,15)..".vsndevts", context )
	end

	--特效
	PrecacheResource("particle", "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_stunned.vpcf", context)
	PrecacheResource("particle", "particles/winter_fx/winter_present_projectile.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/clinkz/clinkz_maraxiform/clinkz_ti9_summon_projectile_arrow.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/ti6/mekanism_ti6.vpcf", context)
	PrecacheResource("particle", "particles/basic_ambient/generic_paralyzed.vpcf", context)
	--[[
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

function Activate()
	GameRules.L_TG:InitGameMode()
end

--初始游戏设置
function L_TG:InitGameMode()
	mode = GameRules:GetGameModeEntity()

	--GameRules:SetIgnoreLobbyTeamsInCustomGame(true)

	--每个队伍最大BAN人数量
	GameRules:SetCustomGameBansPerTeam(6)

	--为自定义游戏设置启用（true）或禁用（false）自动启动。
	GameRules:EnableCustomGameSetupAutoLaunch(true)

	--是否开启自动锁定
	GameRules:LockCustomGameSetupTeamAssignment(false)

	--设置游戏结束延迟。
	GameRules:SetCustomGameEndDelay(99999)

	--设置等待自动启动的时间。
	GameRules:SetCustomGameSetupAutoLaunchDelay(15)

	--设置剩余时间（以秒为单位），用于自定义游戏设置。0 =立即完成，-1 =永远等待
	--GameRules:SetCustomGameSetupRemainingTime(10)

	--设置（游戏前）阶段超时。0 =即时，-1 =永远（直到调用FinishCustomGameGameSetup）
	--GameRules:SetCustomGameSetupTimeout(10)

	--设置胜利消息。
	--GameRules:SetCustomVictoryMessage("小废物们赢了的呢")

	--置胜利消息的持续时间。
	--GameRules:SetCustomVictoryMessageDuration(10)

	--设置是否已触发“第一滴血”。
	GameRules:SetFirstBloodActive(true)

	--控制是否使用正常的DOTA英雄重生规则。
	GameRules:SetHeroRespawnEnabled(true)

	--设置英雄随机分配之前的惩罚时间
	GameRules:SetHeroSelectPenaltyTime(0)

	--设置玩家选择英雄的时间。
	GameRules:SetHeroSelectionTime(60)

	--设置是否在屏幕上方显示多重杀手，连胜和第一流的标语。
	GameRules:SetHideKillMessageHeaders(false)

	--设置符文生成之间的时间间隔。
	GameRules:SetRuneSpawnTime(120)

	--设置是否可以选择相同的英雄。
	GameRules:SetSameHeroSelectionEnabled(false)

	--设置玩家在策略阶段和进入赛前阶段之间的时间。
	GameRules:SetShowcaseTime(4)

	--设置玩家在选择英雄和进入展示阶段之间的时间。
	GameRules:SetStrategyTime(0)

	--设置白天时间
	--GameRules:SetTimeOfDay(DAY)

	--设置树的重新生长时间。
	GameRules:SetTreeRegrowTime(60)

	--设置英雄是否使用基本的NPC功能来确定其赏金，而不是DOTA特定的公式。
	GameRules:SetUseBaseGoldBountyOnHeroes(true)

	--设置是否使用自定义经验表
	GameRules:SetUseCustomHeroXPValues(false)

	--设置商店是否可以购买全部物品
	GameRules:SetUseUniversalShopMode(true)

	--设置风的方向
	--GameRules:SetWeatherWindDirection(WEATHER_DIR)


--------------------------------------------------------------------------??


	--是否允许掉落中立物品
	mode:SetAllowNeutralItemDrops(true)


	--是否开启随机英雄的奖励
	mode:SetRandomHeroBonusItemGrantDisabled(false)


	--设置是否启用暂停
	mode:SetPauseEnabled(false)

	--关闭/打开用于显示商店推荐商品的面板。
	--mode:SetRecommendedItemsDisabled(true)


	--设置应用于非固定重生时间的比例。1 =默认的DOTA重生计算。
	--mode:SetRespawnTimeScale(0.35)


	--设置是否开启英雄选择时期的金钱惩罚
	mode:SetSelectionGoldPenaltyEnabled(false)

	--关闭/打开购买物品的隐藏位置。如果关闭了购买，玩家必须在商店购买物品。
	mode:SetStashPurchasingDisabled(false)

	--是否隐藏推荐物品
	mode:SetStickyItemDisabled(false)

	--是否启动偷塔保护
	mode:SetTowerBackdoorProtectionEnabled(true)

	--启用或禁用看不见的战争迷雾。当启用地图的各个部分时，玩家从未见过的部分将被战争迷雾完全隐藏。
	mode:SetUnseenFogOfWarEnabled(false)

	--设置英雄级别的自定义XP值。该表应在打开之前定义。
	mode:SetUseCustomHeroLevels(false)

	--设定赏金符文产生率。
	mode:SetBountyRuneSpawnInterval(120)

	--是否启动买活。
	mode:SetBuybackEnabled(true)

	--mode:SetCustomBuybackCostEnabled( BUYBACK )


	--mode:SetCustomBuybackCooldownEnabled( BUYBACK )

	--为团队雕文设置自定义冷却时间。
	mode:SetCustomGlyphCooldown(360)

	--允许定义英雄可以达到的最高等级（默认为30）。
	mode:SetCustomHeroMaxLevel(30)

	--为团队扫描功能设置自定义冷却时间。
	mode:SetCustomScanCooldown(60)

	--允许定义英雄XP值表
	--mode:SetCustomXPRequiredToReachNextLevel(XP_TABLE)

	--启用或禁用昼/夜循环。
	mode:SetDaynightCycleDisabled(false)

	--ban人时间
	mode:SetDraftingBanningTimeOverride(20)

	--选人时间
	mode:SetDraftingHeroPickSelectTimeOverride(60)

	--设置一个固定的延迟，让所有玩家在之后重生。
	mode:SetFixedRespawnTime(6)

	--打开或关闭战争迷雾。
	mode:SetFogOfWarDisabled(false)

	--设置喷泉恢复魔力的恒定速率。（默认为-1）
	mode:SetFountainConstantManaRegen(10)

	--设置喷泉恢复健康的百分比。（默认为-1）
	mode:SetFountainPercentageHealthRegen(10)

	--设置喷泉恢复魔力的百分比。（默认为-1）
	mode:SetFountainPercentageManaRegen(10)

	--信使开启
	mode:SetFreeCourierModeEnabled(true)

	--打开/关闭获取黄金时的声音。
	mode:SetGoldSoundDisabled(false)

	--用于禁用死亡时的黄金损失。
	mode:SetLoseGoldOnDeath(false)

	--设置单位的最大攻击速度。
	mode:SetMaximumAttackSpeed(700)

	--设置单位的最低攻击速度。
	mode:SetMinimumAttackSpeed(1)

	--覆盖顶部游戏栏上的团队值。
	mode:SetTopBarTeamValuesOverride(false)

	--打开/关闭顶部游戏栏上的团队值。
	mode:SetTopBarTeamValuesVisible(true)

	--为背包中的物品设置交换冷却时间。
	mode:SetCustomBackpackSwapCooldown(2)

	--mode:SetBotsAlwaysPushWithHuman(true)
	--mode:SetBotThinkingEnabled(true)
	--mode:SetBotsInLateGame(true)


		--地图抉择
		GameRules:SetStartingGold(2000)
		GameRules:SetCreepSpawningEnabled(true)
		GameRules:SetPreGameTime(90)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS,10)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS,10)
	if GetMapName() =="6v6v6" then
		GameRules:SetStartingGold(1000)
		GameRules:SetCreepSpawningEnabled(false)
		GameRules:SetPreGameTime(10)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS,6)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS,6)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_1,6)
	end

--------------------------------------------------------------------------??
	--官方事件
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( L_TG, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "dota_on_hero_finish_spawn", Dynamic_Wrap( L_TG, "OnHeroFinishSpawn" ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( L_TG, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( L_TG, 'OnEntityKilled' ), self )
	ListenToGameEvent("player_chat", Dynamic_Wrap(L_TG, 'OnPlayerChat'), self)
	ListenToGameEvent("dota_rune_activated_server", Dynamic_Wrap(L_TG, 'OnRuneActivated'), self)
	ListenToGameEvent( "dota_buyback", Dynamic_Wrap( L_TG, "OnPlayerBuyback" ), self )
	ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(L_TG, 'OnPlayerLevelUp'), self)
	ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(L_TG, 'OnItemPickedUp'), self)
	ListenToGameEvent("dota_player_pick_hero", Dynamic_Wrap(L_TG, 'OnPlayerPickHero'), self)
	ListenToGameEvent("dota_tower_kill", Dynamic_Wrap(L_TG, 'OnTowerKill'), self)
	ListenToGameEvent("dota_player_learned_ability", Dynamic_Wrap(L_TG, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent( "dota_match_done", Dynamic_Wrap( L_TG, "OnGameFinished" ), self )
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(L_TG, 'OnDisconnect'), self)
	--ListenToGameEvent( "dota_hero_entered_shop", Dynamic_Wrap( L_TG, "OnHeroEnteredShop" ), self )
	--ListenToGameEvent( "dota_player_team_changed", Dynamic_Wrap( L_TG, "OnPlayerTeamChanged" ), self )
	--ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap( L_TG, 'OnPlayerUsedAB' ), self )
	--ListenToGameEvent( "game_end", Dynamic_Wrap( L_TG, 'OnGameEnd' ), self )	--winner ( byte ): winner team/user id
	--ListenToGameEvent( "dota_item_spawned", Dynamic_Wrap( L_TG, "OnItemSpawned" ), self )
	--ListenToGameEvent('player_connect_full', Dynamic_Wrap(L_TG, 'OnConnectFull'), self)
	--ListenToGameEvent('player_disconnect', Dynamic_Wrap(L_TG, 'OnDisconnect'), self)
	--ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( L_TG, "OnNonPlayerUsedAbility" ), self )
	--ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(L_TG, 'OnTeamKillCredit'), self)
	--ListenToGameEvent("dota_illusions_created", Dynamic_Wrap(L_TG, 'OnIllusionsCreated'), self)
	--ListenToGameEvent('player_connect', Dynamic_Wrap(L_TG, 'PlayerConnect'), self)
	--ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(L_TG, 'OnPlayerTakeTowerDamage'), self)
	--ListenToGameEvent('last_hit', Dynamic_Wrap(L_TG, 'OnLastHit'), self)
	--ListenToGameEvent('tree_cut', Dynamic_Wrap(L_TG, 'OnTreeCut'), self)
	--ListenToGameEvent( "dota_player_reconnected", Dynamic_Wrap( L_TG, 'OnPlayerReconnected' ), self )
	--ListenToGameEvent('entity_hurt', Dynamic_Wrap(L_TG, 'OnEntityHurt'), self)
	--ListenToGameEvent( "dota_item_purchased", Dynamic_Wrap( L_TG, "OnItemPurchased" ), self )
	--ListenToGameEvent( "npc_replaced", Dynamic_Wrap( L_TG, "OnNPCReplaced" ), self )

	--过滤器
	--GameRules:GetGameModeEntity():SetAbilityTuningValueFilter(Dynamic_Wrap(L_TG, "AbilityValueFilter"), self)
	--GameRules:GetGameModeEntity():SetBountyRunePickupFilter(Dynamic_Wrap(L_TG, "BountyRuneFilter"), self)
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(L_TG, "DamageFilter"), self)
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(L_TG, "OrderFilter"), self)
	--GameRules:GetGameModeEntity():SetHealingFilter(Dynamic_Wrap(L_TG, "HealFilter"), self)
	--GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap(L_TG, "ItemPickFilter"), self)
	GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(L_TG, "ModifierAddFilter"), self)
	GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(L_TG, "ExpFilter"), self)
	GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(L_TG, "GoldFilter"), self)
	--GameRules:GetGameModeEntity():SetRuneSpawnFilter(Dynamic_Wrap(L_TG, "RuneSpawnFilter"), self)
	--GameRules:GetGameModeEntity():SetTrackingProjectileFilter(Dynamic_Wrap(L_TG, "TrackingProjectileFilter"), self)
	custom_events:Start()
end



----------------------------------------------------------------------------------------------------------------------------------


--[[
function L_TG:AbilityValueFilter(tg)
	local caster=tg.entindex_caster_const  and EntIndexToHScript(tg.entindex_caster_const) or nil

	local ability=tg.entindex_ability_const  and EntIndexToHScript(tg.entindex_ability_const) or nil

	local name=tg.value_name_const

	local value=tg.value
	print(name)
	print(value)

	return true
end
]]


----------------------------------------------------------------------------------------------------------------------------------



--	DamageFilter
--  *entindex_victim_const
--	*entindex_attacker_const
--	*entindex_inflictor_const
--	*damagetype_const
--	*damage

function L_TG:DamageFilter(tg)

	local unit =tg.entindex_victim_const and EntIndexToHScript(tg.entindex_victim_const) or nil

	local attacker =tg.entindex_attacker_const and EntIndexToHScript(tg.entindex_attacker_const) or nil

	local ability =tg.entindex_inflictor_const and EntIndexToHScript(tg.entindex_inflictor_const) or nil


---------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
	--[[
	★骷髅王绿魂。
	--]]
		if attacker and  unit and unit:HasAbility("reincarnation") and unit:IsRealHero() and unit:GetHealth()<=500   then
		local ab=unit:FindAbilityByName("reincarnation")
		if ab then
			if ab~=nil and ab:GetLevel()>0 and not  ab:IsCooldownReady()  and   unit:HasScepter() and not  unit:HasModifier("modifier_reincarnation_ghost") then
				         unit:AddNewModifier( unit, ab, "modifier_reincarnation_ghost", {duration=4})
			end
		end
	end
---------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

	--[[
	★火猫盾。
	--]]
	if attacker and  unit and unit:HasModifier("modifier_flame_guard_buff")then
		local mod=unit:FindModifierByName("modifier_flame_guard_buff")
		local stack=mod:GetStackCount()
		local type=tg.damagetype_const
		local dam=tg.damage
		if type==DAMAGE_TYPE_MAGICAL or unit:TG_HasTalent("special_bonus_ember_spirit_5") then
			if  stack>=dam then
				mod:SetStackCount(stack-dam)
				return false
			else
				tg.damage=dam-stack
				mod:SetStackCount(0)
				if unit:HasModifier("modifier_flame_guard_buff") then
					unit:RemoveModifierByName("modifier_flame_guard_buff")
				end
			end
		end
	end


----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

	--[[
	★猴子bA。
	--]]
	if attacker and  unit and unit:HasModifier("modifier_wukongs_command_buff5") and unit:HasScepter() and tg.damage>=unit:GetHealth() then
		unit:RemoveModifierByName("modifier_wukongs_command_buff5")
		unit:AddNewModifier(unit, nil, "modifier_wukongs_command_buff6", {duration=3.5})
		return false
	end



----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

	--[[
	★人马护盾。
	--]]
	if attacker and  unit and unit:HasModifier("modifier_c_return_buff") then
			local BUFF=unit:FindModifierByName("modifier_c_return_buff")
			if  BUFF then
				local dam=tg.damage
				local num=BUFF:GetStackCount()
				if num > dam then
					BUFF:SetStackCount(num-dam)
					return false
				else
					tg.damage=tg.damage-num
					BUFF:SetStackCount(0)
					unit:RemoveModifierByName("modifier_c_return_buff")
					if unit:HasAbility("c_return") then
						local ab=unit:FindAbilityByName("c_return")
						if ab:GetLevel()>0 then
							unit:AddNewModifier(unit,  ab, "modifier_c_return_buffsp", {duration=2})
							ab:UseResources(false, false, true)
						end
					end
				end
			end
	end



----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

	--[[
	★血棘。
	--]]
	if unit and attacker and attacker:HasItemInInventory("item_bloodthorn_v2")  then
		if attacker~=unit then
			local item=attacker:FindItemInInventory("item_bloodthorn_v2")
			local type=tg.damagetype_const
			local dam=tg.damage
			if  not unit:IsBuilding() and  item and not item:IsInBackpack() then
					if unit:HasModifier("modifier_item_bloodthorn_v2_debuff") then
							tg.damage=dam+dam*0.4
							SendOverheadEventMessage(unit, OVERHEAD_ALERT_CRITICAL, unit, tg.damage, nil)
					else
							tg.damage=dam+dam*0.2
							SendOverheadEventMessage(unit, OVERHEAD_ALERT_CRITICAL, unit, tg.damage, nil)
					end
			end
		end
	end

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

	--[[
	★NEC大招确保击杀。
	--]]
	if unit and unit:HasModifier("modifier_dlnec_reaper_judge") and not unit:HasModifier("modifier_winter_wyvern_winters_curse_aura") then
		local reapermodi = unit:FindModifierByName("modifier_dlnec_reaper_judge")
		if reapermodi and reapermodi:GetCaster() and reapermodi:GetAbility() and (reapermodi:GetAbility() ~= ability or reapermodi:GetCaster() ~= attacker) then
			local reaper_caster = reapermodi:GetCaster()
			local reaper_ability = reapermodi:GetAbility()
			if unit:GetHealth() <= tg.damage then
				local damageTable = {
									victim = unit,
									attacker = reaper_caster,
									damage = unit:GetHealth() + 10,
									damage_type = DAMAGE_TYPE_PURE,
									damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT, --Optional.
									ability = reaper_ability,
									}
				ApplyDamage(damageTable)
				return false
			end
		end
	end

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

	--[[
	★死亡。
	]]
	if unit and Is_DATA_TG(CDOTA_PlayerResource.TG_HERO, unit)  and tg.damage>=unit:GetHealth() then
		local rest=6
		if GetMapName() ~="6v6v6" then
			local t = GameRules:GetDOTATime(false, false)
				if t<=600 then
					rest=RandomInt(6,8)
				elseif t>600 and t<=1200 then
					rest=RandomInt(15,25)
				elseif t>1200  then
					local time=unit:GetLevel()+(t-1200)/100
					rest=time>=60 and 60 or time
				end
		end
			GameRules:GetGameModeEntity():SetFixedRespawnTime(rest+unit:GetRespawnTimeChangeNormal())
			if  attacker and unit:HasModifier("modifier_dlnec_reaper_permanent") then
				local mod=unit:FindModifierByName("modifier_dlnec_reaper_permanent")
				if mod then
					GameRules:GetGameModeEntity():SetFixedRespawnTime(rest+(mod:GetStackCount()*(3+attacker:TG_GetTalentValue("special_bonus_dlnec_25r"))))
				end
			end
	end

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

	--[[
	★老圣剑法强距离计算。
	--]]
	if attacker and ability and (unit:GetAbsOrigin() - attacker:GetAbsOrigin()):Length2D() > 2500 then
		local attacker_buffs = attacker and attacker:FindAllModifiers() or nil
		local rapier_spellAMP = 0
		local total_spellAMP = attacker:GetSpellAmplification(false)
		for _, buff in pairs(attacker_buffs) do
			local name=buff:GetName()
			if name == "modifier_imba_rapier_magic_unique" then
				rapier_spellAMP = rapier_spellAMP + SPELL_AMP_RAPIER_1
			end
			if name == "modifier_imba_rapier_magic_three_unique" then
				rapier_spellAMP = rapier_spellAMP + SPELL_AMP_RAPIER_3
			end
			if name == "modifier_imba_rapier_super_passive" then
				rapier_spellAMP = rapier_spellAMP + SPELL_AMP_RAPIER_SUPER
			end
		end
		tg.damage = tg.damage / (1 + total_spellAMP)
		tg.damage = tg.damage * (1 + (total_spellAMP - rapier_spellAMP))
	end


		return true
end



----------------------------------------------------------------------------------------------------------------------------------


--[[
function L_TG:BountyRuneFilter(tg)
	return true
end
]]


----------------------------------------------------------------------------------------------------------------------------------



function L_TG:OrderFilter(keys)
	local units = keys["units"]
	local unit = units["0"] and EntIndexToHScript(units["0"]) or nil
	local ability =keys.entindex_ability and EntIndexToHScript(keys.entindex_ability) or nil
	local target =keys.entindex_target and EntIndexToHScript(keys.entindex_target) or nil

	if not unit then
		return true
	end

	--[[
	★无了。
	--]]
	if  unit:HasModifier("modifier_gnm") or  unit:HasModifier("modifier_helide")  then
		return false
	end

----------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------
	-- 育母突袭施法距离判断
	------------------------------------------------------------------------------------
	if keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET and EntIndexToHScript(keys.entindex_ability):GetName() == "imba_broodmother_spider_strikes" then
		local ability = EntIndexToHScript(keys.entindex_ability)
		local target = EntIndexToHScript(keys.entindex_target)
		if target:HasModifier("modifier_imba_spin_web_debuff") and target:FindModifierByName("modifier_imba_spin_web_debuff"):GetStackCount() == -1 and not target:HasModifier("modifier_fountain_aura_buff") then
			ability.range_global = 50000
		else
			ability.range_global = 0
		end
	end
	------------------------------------------------------------------------------------
	-- 蛛网施法距离判断
	------------------------------------------------------------------------------------

	if keys.order_type == DOTA_UNIT_ORDER_CAST_POSITION and EntIndexToHScript(keys.entindex_ability):GetName() == "imba_broodmother_spin_web" then
		local ability = EntIndexToHScript(keys.entindex_ability)
		if #Entities:FindAllByClassnameWithin("npc_dota_broodmother_web", Vector(keys.position_x, keys.position_y, keys.position_z), ability:GetSpecialValueFor("radius") * 2) > 0 then
			ability.range = 50000
		else
			ability.range = 0
		end
	end

----------------------------------------------------------------------------------------------------

	--[[
	★老英霸 混乱效果。
	--]]
	if  unit:HasModifier("modifier_confuse") and target then

		-- Determine order type
		local rand = math.random

		-- Change "move to target" to "move to position"
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
			local target_loc = target:GetAbsOrigin()
			keys.position_x = target_loc.x
			keys.position_y = target_loc.y
			keys.position_z = target_loc.z
			keys.entindex_target = 0
			keys.order_type = DOTA_UNIT_ORDER_MOVE_TO_POSITION
		end

		-- Change "attack target" to "attack move"
		if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
			local target_loc = target:GetAbsOrigin()
			keys.position_x = target_loc.x
			keys.position_y = target_loc.y
			keys.position_z = target_loc.z
			keys.entindex_target = 0
			keys.order_type = DOTA_UNIT_ORDER_ATTACK_MOVE
		end

		-- Change "cast on target" target
		if keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET or keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET_TREE then
			local caster_loc = unit:GetAbsOrigin()
			local target_loc = target:GetAbsOrigin()
			local target_distance = (target_loc - caster_loc):Length2D()
			local found_new_target = false
			local nearby_units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, caster_loc, nil, target_distance, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
			if #nearby_units >= 1 then
				keys.entindex_target = nearby_units[1]:GetEntityIndex()

			-- If no target was found, change to "cast on position" order
			else
				keys.position_x = target_loc.x
				keys.position_y = target_loc.y
				keys.position_z = target_loc.z
				keys.entindex_target = 0
				keys.order_type = DOTA_UNIT_ORDER_CAST_POSITION
			end
		end

		-- Spin positional orders a random angle
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or keys.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE or keys.order_type == DOTA_UNIT_ORDER_CAST_POSITION then

			-- Calculate new order position
			local target_loc = Vector(keys.position_x, keys.position_y, keys.position_z)
			local origin_loc = unit:GetAbsOrigin()
			local order_vector = target_loc - origin_loc
			local new_order_vector = RotatePosition(origin_loc, QAngle(0, rand(45, 315), 0), origin_loc + order_vector)

			-- Override order
			keys.position_x = new_order_vector.x
			keys.position_y = new_order_vector.y
			keys.position_z = new_order_vector.z
		end
	end

	return true
end



----------------------------------------------------------------------------------------------------------------------------------



--	HealingFilter
--  *entindex_target_const
--	*entindex_healer_const
--	*entindex_inflictor_const
--	*heal
--[[
function L_TG:HealFilter(tg)

	local target =tg.entindex_target_const and EntIndexToHScript(tg.entindex_target_const) or nil

	local healer =tg.entindex_healer_const and EntIndexToHScript(tg.entindex_healer_const) or nil

	local ability =tg.entindex_inflictor_const and EntIndexToHScript(tg.entindex_inflictor_const) or nil


	return true
end
]]


----------------------------------------------------------------------------------------------------------------------------------



--	ItemAddedToInventoryFilter
--  *item_entindex_const
--	*item_parent_entindex_const
--	*inventory_parent_entindex_const
--	*suggested_slot
--[[
function L_TG:ItemPickFilter(tg)
	return true
end
]]


----------------------------------------------------------------------------------------------------------------------------------



--	ModifierGainedFilter
--  *entindex_parent_const
--	*entindex_ability_const
--	*entindex_caster_const
--	*name_const
--	*duration

function L_TG:ModifierAddFilter(tg)
	local ability = tg.entindex_ability_const and EntIndexToHScript(tg.entindex_ability_const) or nil

	local caster = tg.entindex_caster_const and EntIndexToHScript(tg.entindex_caster_const) or nil

	local target = tg.entindex_parent_const and EntIndexToHScript(tg.entindex_parent_const) or nil

	local modifier_name = tg.name_const

  --[[
	  抗性 -小问题舍弃

	if target~=nil and tg.duration>0 and ability~=nil then
		local modifier = target:HasModifier(modifier_name) and target:FindModifierByName(modifier_name) or nil
		local cname=ability:GetClassname()
		if (modifier~=nil and modifier:IsDebuff() and  (cname=="item_lua" or cname=="ability_lua") and not TableContains(NOT_RS_DEBUFF,modifier_name)) or modifier_name=="modifier_stunned" then
			local status_res = target:GetStatusResistance()
			local dur=math.ceil(tg.duration*status_res*100)/100
			if status_res>0 then
				tg.duration = tg.duration-dur
			elseif status_res<0 then
				tg.duration = tg.duration+dur*-1
			end
			return true
		end
	end
]]


	if target and target:HasModifier("modifier_bulldoze_buff1") then
		local mod=target:FindModifierByName(modifier_name)
		if mod and  mod:IsDebuff() then
			tg.duration=0
		end
	end

	if target and target:HasModifier("modifier_blade_fury_buff") then
		local mod=target:FindModifierByName(modifier_name)
		if mod and not mod:IsDebuff() and tg.duration~=nil and tg.duration>0 then
			tg.duration=tg.duration+tg.duration*0.4
		end
	end

	--[[
		神符
	]]
	if modifier_name == "modifier_rune_regen" then
		target:AddNewModifier(target, nil,"modifier_rune_regen_tg" , {duration = 15})--"modifier_rune_regen_tg"
		return false
	end
	if modifier_name == "modifier_rune_haste" then
		target:AddNewModifier(target, nil, "modifier_rune_haste_tg", {duration = 15})--"modifier_rune_haste_tg"
		return false
	end
	if modifier_name == "modifier_rune_invis" then
		target:AddNewModifier(target, nil, "modifier_rune_invis_tg", {duration = 10})--"modifier_rune_invis_tg"
		return false
	end
	if modifier_name == "modifier_rune_doubledamage" then
		target:AddNewModifier(target, nil, "modifier_rune_doubledamage_tg", {duration = 15})
		return false
	end
	if modifier_name == "modifier_rune_arcane" then
		target:AddNewModifier(target, nil,"modifier_rune_arcane_tg" , {duration = 15})--"modifier_rune_arcane_tg"
		return false
	end

	return true
end



----------------------------------------------------------------------------------------------------------------------------------



--[[
DOTA_ModifyXP_CreepKill = 2
DOTA_ModifyXP_HeroKill = 1
DOTA_ModifyXP_MAX = 6
DOTA_ModifyXP_Outpost = 5
DOTA_ModifyXP_RoshanKill = 3
DOTA_ModifyXP_TomeOfKnowledge = 4
DOTA_ModifyXP_Unspecified = 0
]]
function L_TG:ExpFilter(tg)

	local hero = PlayerResource.TG_HERO[tg.player_id_const + 1]
	if hero==nil then
		return
	end
	local const=tg.reason_const
	local experience=tg.experience
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
	if const == DOTA_ModifyXP_HeroKill then
		tg.experience=experience+experience*0.09
	end
	return true
end



----------------------------------------------------------------------------------------------------------------------------------



--[[
DOTA_ModifyGold_AbandonedRedistribute = 5
DOTA_ModifyGold_AbilityCost = 7
DOTA_ModifyGold_AbilityGold = 19
DOTA_ModifyGold_BountyRune = 17
DOTA_ModifyGold_Building = 11
DOTA_ModifyGold_Buyback = 2
DOTA_ModifyGold_CheatCommand = 8
DOTA_ModifyGold_CourierKill = 16
DOTA_ModifyGold_CreepKill = 13
DOTA_ModifyGold_Death = 1
DOTA_ModifyGold_GameTick = 10
DOTA_ModifyGold_HeroKill = 12
DOTA_ModifyGold_NeutralKill = 14
DOTA_ModifyGold_PurchaseConsumable = 3
DOTA_ModifyGold_PurchaseItem = 4
DOTA_ModifyGold_RoshanKill = 15
DOTA_ModifyGold_SelectionPenalty = 9
DOTA_ModifyGold_SellItem = 6
DOTA_ModifyGold_SharedGold = 18
DOTA_ModifyGold_Unspecified = 0
DOTA_ModifyGold_WardKill = 20
]]
function L_TG:GoldFilter(tg)
	local hero = PlayerResource.TG_HERO[tg.player_id_const + 1]
	if hero==nil then
		return
	end
	local const=tg.reason_const
	local gold=tg.gold
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
	if const == DOTA_ModifyGold_HeroKill then
		tg.gold=gold+Hero_KEG
		if gold>Threshold_KEG then
			tg.gold=Threshold_KEG+gold*Perc_KEG
		end
	elseif const == DOTA_ModifyGold_NeutralKill then
		tg.gold=gold*Neutral_KEG
	elseif const == DOTA_ModifyGold_CreepKill then
		tg.gold=gold*Creep_KEG
	end

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

	if hero:HasModifier("modifier_item_hand_of_god_buff") then
		tg.gold=math.floor(tg.gold+tg.gold*0.1)
	end

	if hero:HasModifier("modifier_unstable_concoction_throw_debuff") then
		tg.gold=math.floor(tg.gold*0.3)
	end


	return true
end



----------------------------------------------------------------------------------------------------------------------------------



--[[
	{
		rune_type                       	= 2 (number)
		spawner_entindex_const          	= 609 (number)


		DOTA_RUNE_ARCANE = 6
		DOTA_RUNE_BOUNTY = 5
		DOTA_RUNE_COUNT = 8
		DOTA_RUNE_DOUBLEDAMAGE = 0
		DOTA_RUNE_HASTE = 1
		DOTA_RUNE_ILLUSION = 2
		DOTA_RUNE_INVALID = -1
		DOTA_RUNE_INVISIBILITY = 3
		DOTA_RUNE_REGENERATION = 4
		DOTA_RUNE_XP = 7
	}

function L_TG:RuneSpawnFilter(tg)
	local spawner =tg.spawner_entindex_const and EntIndexToHScript(tg.spawner_entindex_const) or nil
	print(spawner:GetName())
	return true
end
 ]]


----------------------------------------------------------------------------------------------------------------------------------



--[[
	dodgeable: 1
	entindex_ability_const: 357
	entindex_source_const: 349
	entindex_target_const: 413
	expire_time: 99.298980712891
	is_attack: 0
	max_impact_time: 0
	move_speed: 3000

function L_TG:TrackingProjectileFilter(tg)


	local ability=EntIndexToHScript(tg.entindex_ability_const)
	local attacker=EntIndexToHScript(tg.entindex_source_const)
	local target=EntIndexToHScript(tg.entindex_target_const)
	local is_attack=tg.is_attack
   --[[
		火枪：探测器

	if target~=nil and (target:GetClassname()~="dota_item_drop" and target:GetClassname()~="dota_item_rune" ) and  (target:HasModifier( "modifier_device_buff" ) and attacker:HasModifier( "modifier_device_debuff" ) and is_attack==1 and attacker:IsRangedAttacker())then
		local ab=target:FindAbilityByName( "device" )
		local rd=0
		local ch=0
		local bot=nil
		if ab~=nil then
			rd=ab:GetSpecialValueFor( "br" )
			ch=ab:GetSpecialValueFor( "ch" )
			bot= ab.BOTB
		end

		if RollPseudoRandomPercentage(ch,0,ab) then
			local enemies = FindUnitsInRadius(
				attacker:GetTeamNumber(),
				attacker:GetAbsOrigin(),
				nil,
				rd,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false)
			if #enemies>0 then
				attacker:PerformAttack(TG_Random_Table(enemy), false, false, true, false, true, false, true)
			end
		elseif bot~=nil then
			attacker:PerformAttack(bot, false, false, true, false, true, false, true)
		end
		return false
	else
		return true
	end

end
]]
