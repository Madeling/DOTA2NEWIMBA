GameUI.CustomUIConfig().AbilitiesKv = {
	"special_bonus_imba_test"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"0"
			}
		}
	}


	//=================================================================================================================
	// 肉山
	//=================================================================================================================
	"roshan_upup"
	{
		"BaseClass"	"ability_datadriven"
		"AbilityTextureName"			"roshan_up"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
	}

	//=================================================================================================================
	// 防御塔：瞭望塔
	//=================================================================================================================
	"tower1_watchtower"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"towers/tower1_watchtower.lua"
		"AbilityTextureName"			"tower1_watchtower"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"

		"AbilityCooldown"				"90"
		"AbilityCastRange"				"2000"

		"MaxLevel"				"1"

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"rd" 				"2000"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"				"7"
			}
		}
	}

	//=================================================================================================================
	// 防御塔：攻击光环
	//=================================================================================================================
	"tower1_att"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"towers/tower1_attack.lua"
		"AbilityTextureName"			"tower1_att"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"

		"AbilityCastRange"				"2000"

		"MaxLevel"				"1"

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"rd" 				"2000"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"att"				"30"
			}
				"03"
			{
				"var_type"				"FIELD_INTEGER"
				"attsp"				"35"
			}
		}
	}

	//=================================================================================================================
	// 防御塔：防御光环
	//=================================================================================================================
	"tower1_def"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"towers/tower1_defense.lua"
		"AbilityTextureName"			"tower1_def"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"

		"AbilityCastRange"				"2000"

		"MaxLevel"				"1"

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"rd" 				"2000"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"ar"				"10"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"mr"				"30"
			}
		}
	}


	//=================================================================================================================
	// 防御塔：治疗光环
	//=================================================================================================================
	"tower1_med"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"towers/tower1_meditation.lua"
		"AbilityTextureName"			"tower1_med"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"

		"AbilityCooldown"				"10"
		"AbilityCastRange"				"1000"

		"MaxLevel"				"1"

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"rd" 				"1000"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"hp"				"30"
			}
		}
	}


	//=================================================================================================================
	// 防御塔：缴械
	//=================================================================================================================
	"tower2_disarm"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"towers/tower2_disarm.lua"
		"AbilityTextureName"			"tower2_disarm"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"

		"AbilityCooldown"				"10"
		"AbilityCastRange"				"1000"

		"MaxLevel"				"1"

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"rd" 				"1000"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"				"2"
			}
		}
	}



	//=================================================================================================================
	// 防御塔：增伤
	//=================================================================================================================
	"tower2_damage"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"towers/tower2_damage.lua"
		"AbilityTextureName"			"tower2_damage"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"

		"AbilityCastRange"				"1000"

		"MaxLevel"				"1"

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"rd" 				"1000"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"20"
			}
		}
	}



	//=================================================================================================================
	// 防御塔：快速攻击
	//=================================================================================================================
	"tower3_fastatt"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"towers/tower3_fastatt.lua"
		"AbilityTextureName"			"tower3_fastatt"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"


		"MaxLevel"				"1"

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"attsp" 				"300"
			}
		}
	}




	//=================================================================================================================
	// 防御塔：激光
	//=================================================================================================================
	"tower3_laser"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"towers/tower3_laser.lua"
		"AbilityTextureName"			"tower3_laser"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilityCastRange"				"1000"
		"MaxLevel"				"1"
		"AbilityCooldown"				"8"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"rd" 				"1000"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"rg" 				"1400"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"wh" 				"350"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"dam" 				"777"
			}
		}
	}


	//=================================================================================================================
	// 防御塔：吸血
	//=================================================================================================================
	"tower4_blood"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"towers/tower4_blood.lua"
		"AbilityTextureName"			"tower4_blood"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"

		"MaxLevel"				"1"

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"dam" 				"7"
			}
		}
	}



	//=================================================================================================================
	// 防御塔：眩晕
	//=================================================================================================================
	"tower4_stun"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"towers/tower4_stun.lua"
		"AbilityTextureName"			"tower4_stun"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"

		"MaxLevel"				"1"

	}

	//=================================================================================================================
	// 遗迹：决战时刻
	//=================================================================================================================
	"fort_ab"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"towers/fort.lua"
		"AbilityTextureName"			"fort_ab"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"MaxLevel"				"1"

	}



	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//
	//
	//
	//
	//
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	//=================================================================================================================
	// tk大招
	//=================================================================================================================
	"rearm"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_tinker/rearm.lua"
		"AbilityTextureName"			"tinker_rearm"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_CHANNELLED | DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilitySound"					"Hero_Tinker.Rearm"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0"
		"AbilityChannelTime"			"1.5 1.25 1"
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_4"
		"AbilityChannelAnimation"		"ACT_DOTA_CHANNEL_ABILITY_4"
		"HasShardUpgrade"               "1"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0.0 0.0 0.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"150 250 350"
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
					"01"
			{
				"var_type"				"FIELD_FLOAT"
				"ct"				"1.5 1.25 1"
			}
		}
	}




	//=================================================================================================================
	// 矮子
	//=================================================================================================================
		"slug"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_sniper/slug.lua"
		"AbilityTextureName"			"exp"											// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Hero_Sniper.ShrapnelShatter"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1600"
		"AbilityCastPoint"				"0.2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"8"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50"

		"AOERadius"				"350"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.25"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts"
			"particle"	"particles/units/heroes/hero_sniper/sniper_assassinate.vpcf"
			"particle"	"particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_assassinate.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"rg"				"1600"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"				"350"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"50 100 150 200"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"stundur"				"0.25"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"ar"				"7 8 9 10"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"vdur"				"3"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"				"7"
			}
			"08"
			{
				"var_type"				"FIELD_INTEGER"
				"dam2"				"80 120 160 200"
			}
			"09"
			{
				"var_type"				"FIELD_FLOAT"
				"stundur2"			"0.5"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	"device"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_sniper/device.lua"
		"AbilityTextureName"			"device"											// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"FightRecapLevel"				"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"200"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"20"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"			"0.25"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts"
			"particle"	"particles/basic_ambient/generic_range_display.vpcf"
			"particle"	"particles/econ/events/ti10/soccer_ball/soccer_ball_dust.vpcf"
			"particle"	"particles/customgames/capturepoints/cp_neutral_3.vpcf"
			"particle"	"particles/econ/items/mars/mars_ti10_taunt/mars_ti10_taunt.vpcf"
			"particle"	"particles/items2_fx/manta_phase.vpcf"
			"model"	"models/items/rattletrap/battletrap_cog/battletrap_cog.vmdl"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"				"6"
				"LinkedSpecialBonus"			"special_bonus_imba_sniper_2"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"				"1000"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"br"				"600 700 800 900"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"ch"				"20"
			}
		}
	}


	"change"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"					"ability_lua"
		"AbilityTextureName"				"sniper_take_aim"
		"ScriptFile"					"heros/hero_sniper/change.lua"
		"AbilityBehavior"					"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_TOGGLE | DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL"
		"AbilityUnitTargetFlags"				"DOTA_UNIT_TARGET_FLAG_DEAD"
		"FightRecapLevel"					"1"
		"AbilityCastPoint"					"0"
		"AbilityCooldown"					"0"
		"AbilityCastAnimation"				"ACT_DOTA_CAST_ABILITY_1"
		"precache"
		{
			"soundfile""soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts"
			"model"	"models/items/sniper/widowmaker/widowmaker.vmdl"
			"model"	"models/items/sniper/witch_hunter_set_weapon/witch_hunter_set_weapon.vmdl"
		}

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"attrg"				"150 250 350 450"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"v"				"30 40 50 60"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"sp"				"15 20 25 30"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"rate"				"100"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"mindis"				"500"
				"LinkedSpecialBonus"			"special_bonus_sniper_15r"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"minrd"				"150"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"vdur"				"4"
				"RequiresScepter"			"1"
			}
		}
	}


	"grenade"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_sniper/grenade.lua"
		"AbilityTextureName"			"sniper_shrapnel"											// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"FightRecapLevel"				"1"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilityType"				"DOTA_ABILITY_TYPE_ULTIMATE"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"0"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"40"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"			"0.25"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts"
			"particle"	"particles/themed_fx/cny_fireworks_rockets_bsnd.vpcf"
			"particle"	"particles/econ/courier/courier_trail_hw_2013/courier_trail_hw_2013_ghosts.vpcf"
			"particle"	"particles/heros/sniper/grenade1.vpcf"
			"model"	"models/items/courier/billy_bounceback/billy_bounceback_flying.vmdl"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"				"20"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"				"800"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"300 400 500"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"hp"				"1000 2000 3000"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"ar"				"10 25 40"
			}
		}
	}
	"sniper_roll"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_sniper/sniper_roll.lua"
		"AbilityTextureName"			"sniper_headshot_immortal"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityCastRange"				"0"
		"AbilityCastPoint"				"0"
		"AbilityCooldown"				"7"
		"AbilityManaCost"				"0"
		"Maxlevel"				"4"
		"precache"
		{
			"particle"	"particles/econ/courier/courier_mechjaw/mechjaw_idle_rare.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"dis"				"700"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"100 150 200 250"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"stundur"				"1.5"
			}
		}
	}
	"one_shot"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"					"ability_lua"
		"AbilityTextureName"				"sniper_take_aim"
		"ScriptFile"					"heros/hero_sniper/one_shot.lua"
		"AbilityBehavior"					"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"FightRecapLevel"					"1"
		"AbilityCastPoint"					"0.1"
		"AbilityCooldown"					"10"
		"AbilityCastAnimation"				"ACT_DOTA_CAST_ABILITY_1"
		"AbilityManaCost"					"125 100 75 50"
		"HasScepterUpgrade"			"1"
		"precache"
		{
			"particle"	"particles/heros/sniper/grenade1.vpcf"
		}

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"attrg"				"100 200 300 400"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"v"				"40 50 60 70"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"num"				"5 7 9 11"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"6 7 8 9"
				"LinkedSpecialBonus"		"special_bonus_sniper_15r"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"				"100 150 200 250"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"ch"				"25"
			}
		}
	}
	//提速
	"special_bonus_sniper_10r"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"3"
			}
		}
	}

	//独头弹额外降低目标25%魔法抗性
	"special_bonus_sniper_10l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"25"
				"ad_linked_ability"			"slug"
			}
		}
	}


	//+1枪挂榴弹伤害系数
	"special_bonus_sniper_15r"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
					"ad_linked_ability"			"one_shot"
			}
		}
	}

	//-5精准射手CD
	"special_bonus_sniper_15l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"5"
					"ad_linked_ability"			"one_shot"
			}
		}
	}

	//+10榴弹数量
	"special_bonus_sniper_20r"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"10"
				"ad_linked_ability"			"one_shot"
			}
		}
	}

	//跳跃落地后获得1秒隐身
	"special_bonus_sniper_20l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
				"ad_linked_ability"			"sniper_roll"
			}
		}
	}
	//无人机经过的敌方会使友军获得隐身效果
	"special_bonus_sniper_25r"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"0"
					"ad_linked_ability"			"grenade"
			}
}
	}
	//无人机经过的敌方会使友军获得50%移速加成
	"special_bonus_sniper_25l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"150"
					"ad_linked_ability"			"grenade"
			}
		}
	}

	//=================================================================================================================
	//飞机
	//=================================================================================================================
	"rocket_barrage"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_gyrocopter/rocket_barrage.lua"
		"AbilityTextureName"			"gyrocopter_rocket_barrage"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"				"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"500"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"9"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts"
			"particle"	"particles/econ/items/gyrocopter/hero_gyrocopter_atomic/gyro_rocket_barrage_atomic.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"					"500"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"dam"					"8 9 10 11"
				//"LinkedSpecialBonus"			"special_bonus_unique_gyrocopter_3"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"					"3"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"rocket_num"				"1"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"dam_i"					"0.1"
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"Knockback"				"30"
			}
			"07"
			{
				"var_type"					"FIELD_FLOAT"
				"Knockback_dur"				"0.1"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}



	"guided_missile"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_gyrocopter/guided_missile.lua"
		"AbilityTextureName"			"gyrocopter_homing_missile"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1200"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"22"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"120 130 140 150"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts"
			"particle"	"particles/units/heroes/hero_gyrocopter/gyro_homing_missile_fuse.vpcf"
			"particle"	"particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_guided_missile_target.vpcf"
			"particle"	"particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_guided_missile.vpcf"
			"particle"	"particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_guided_missile_explosion.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"					"1200"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"dam"					"300 400 500 600"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"stun"					"1 2 3 4"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"sp"					"600 700 800 900"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"att_num"					"2 3 4 5"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"delay"						"3"
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"att_dam"					"100"
			}
			"08"
			{
				"var_type"					"FIELD_INTEGER"
				"brd"					"300"
			}
			"09"
			{
				"var_type"					"FIELD_FLOAT"
				"bdam"				"150 200 250 300"
			}
			"10"
			{
				"var_type"					"FIELD_FLOAT"
				"bnum"				"3 4 5 6"
			}
			"11"
			{
				"var_type"					"FIELD_FLOAT"
				"num"				"4"
			}
			"12"
			{
				"var_type"					"FIELD_FLOAT"
				"per"				"50"
			}
		}
		"AbilityCastAnimation"					"ACT_DOTA_CAST_ABILITY_2"
	}



	"flak_cannon"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_gyrocopter/flak_cannon.lua"
		"AbilityTextureName"			"gyrocopter_flak_cannon"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Hero_Gyrocopter.FlackCannon"
		"HasScepterUpgrade"			"1"

		"AbilityCastPoint"				"0 0 0 0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"22"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts"
			"particle"	"particles/units/heroes/hero_gyrocopter/gyro_flak_cannon_overhead.vpcf"
			"particle"	"particles/tgp/gyrocopter/flak_cannon1.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"					"900"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"dam"					"8 9 10 11"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"psp"					"1200"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"attrg"					"100 150 200 250"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"dayv"					"1000"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"					"12"
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"num"					"10 12 14 16"
				"LinkedSpecialBonus"			"special_bonus_imba_gyrocopter_1"
			}
		}
		"AbilityCastAnimation"					"ACT_DOTA_CAST_ABILITY_3"
	}


	"call_down"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_gyrocopter/call_down.lua"
		"AbilityTextureName"			"gyrocopter_call_down"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityType"				"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"2"
		"AbilitySound"				"Hero_Gyrocopter.CallDown.Fire"
		 "HasShardUpgrade"               "1"

		"AOERadius"				"500 600 700"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"3000"
		"AbilityCastPoint"				"0.25"
		"AbilityCastAnimation"			"ACT_INVALID"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"40"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"150 200 250"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts"
			"particle"	"particles/tgp/gyrocopter/flak_cannon1.vpcf"
			"particle"	"particles/tgp/gyrocopter/calldown_marker.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"					"600 700 800"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"dam"					"200 300 400"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"delay"					"2"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"sp"					"2000"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"dis"					"3000"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"less_sp"					"20 30 40"
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"hr"					"60 70 80"
			}
			"08"
			{
				"var_type"					"FIELD_INTEGER"
				"debuff"					"2 3 4"
			}
			"09"
			{
				"var_type"					"FIELD_INTEGER"
				"m_rd"					"1500"
			}
			"10"
			{
				"var_type"					"FIELD_INTEGER"
				"m_dam"					"300 400 500"
			}
			"11"
			{
				"var_type"					"FIELD_INTEGER"
				"max_m"					"3"
			}
		}
	}


	"special_bonus_gyrocopter_1"
	{

		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}



	"special_bonus_gyrocopter_2"
	{

		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	"special_bonus_gyrocopter_3"
	{

		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	"special_bonus_gyrocopter_4"
	{

		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	"special_bonus_gyrocopter_5"
	{

		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	"special_bonus_gyrocopter_6"
	{

		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	"special_bonus_gyrocopter_7"
	{

		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	"special_bonus_gyrocopter_8"
	{

		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}



	//=================================================================================================================
	// 大牛
	//=================================================================================================================
	"echo_stomp"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_elder_titan/echo_stomp.lua"
		"AbilityTextureName"			"elder_titan_echo_stomp"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_CHANNELLED  | DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Hero_ElderTitan.EchoStomp"
		"HasScepterUpgrade"			"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
 		"AbilityCastAnimation"			"ACT_INVALID"
		"AbilityCastPoint"				"0.3"
 		"AbilityCastRange"				"500"
		"AbilityChannelTime"			"1"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"16 15 14 13 12"
		"AbilityManaCost"				"100"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts"
			"particle"	"particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_cast_combined_detail_ti7.vpcf"
			"particle"	"particles/heros/elder_titan/echo_stomp_cast_combined_ti7.vpcf"
			"particle"	"particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7.vpcf"
			"particle"	"particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_magical.vpcf"
			"particle"	"particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf"
			"particle"	"particles/items_fx/black_king_bar_avatar.vpcf"
			"particle"	"particles/generic_gameplay/generic_sleep.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_FLOAT"
				"cast_time"					"1"
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"rd"						"450"
			}
			"03"
			{
				"var_type"						"FIELD_FLOAT"
				"sleep_dur"					"2 3 4 5"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"dam"						"100 150 200 250"
				"LinkedSpecialBonus"		"special_bonus_elder_titan_1"
			}
			"05"
			{
				"var_type"						"FIELD_FLOAT"
				"limit"						"100"
			}
			"06"
			{
				"var_type"						"FIELD_FLOAT"
				"cast"						"0.3"
			}
			"07"
			{
				"var_type"						"FIELD_FLOAT"
				"dis"						"700"
			}
			"08"
			{
				"var_type"						"FIELD_FLOAT"
				"wh"						"250"
			}
			"09"
			{
				"var_type"						"FIELD_FLOAT"
				"t"						"2"
			}
			"10"
			{
				"var_type"						"FIELD_FLOAT"
				"dam2"						"400"
			}
			"11"
			{
				"var_type"						"FIELD_FLOAT"
				"stun_dur"					"1"
			}
		}
	}


	"echo_stomp_spirit"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_elder_titan/echo_stomp_spirit.lua"
		"AbilityTextureName"			"elder_titan_echo_stomp_spirit"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_CHANNELLED | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT | DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_CUSTOM"
		"FightRecapLevel"				"1"
		"HasScepterUpgrade"			"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
 		"AbilityCastAnimation"			"ACT_INVALID"
		"AbilityCastPoint"				"0"
 		"AbilityCastRange"				"500"
		"AbilityChannelTime"			"1"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"14 13 12 11"
		"AbilityManaCost"				"0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts"
			"particle"	"particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_cast_combined_detail_ti7.vpcf"
			"particle"	"particles/heros/elder_titan/echo_stomp_cast_combined_ti7.vpcf"
			"particle"	"particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7.vpcf"
			"particle"	"particles/econ/items/elder_titan/elder_titan_ti7/elder_titan_echo_stomp_ti7_magical.vpcf"
			"particle"	"particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf"
			"particle"	"particles/items_fx/black_king_bar_avatar.vpcf"
			"particle"	"particles/generic_gameplay/generic_sleep.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_FLOAT"
				"cast_time"					"1"
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"rd"						"450"
			}
			"03"
			{
				"var_type"						"FIELD_FLOAT"
				"sleep_dur"					"2 3 4 5"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"dam"						"100 150 200 250"
			}
			"05"
			{
				"var_type"						"FIELD_FLOAT"
				"limit"						"100"
			}
			"06"
			{
				"var_type"						"FIELD_FLOAT"
				"cast"						"0"
			}
			"07"
			{
				"var_type"						"FIELD_FLOAT"
				"dis"						"700"
			}
			"08"
			{
				"var_type"						"FIELD_FLOAT"
				"wh"						"250"
			}
			"09"
			{
				"var_type"						"FIELD_FLOAT"
				"t"						"2"
			}
			"10"
			{
				"var_type"						"FIELD_FLOAT"
				"dam2"						"400"
			}
			"11"
			{
				"var_type"						"FIELD_FLOAT"
				"stun_dur"					"1"
			}
		}
	}

	"ancestral_spirit"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_elder_titan/ancestral_spirit.lua"
		"AbilityTextureName"			"elder_titan_ancestral_spirit"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"				"Hero_ElderTitan.AncestralSpirit.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"			"ACT_DOTA_ANCESTRAL_SPIRIT"
		"AbilityCastGestureSlot"			"DEFAULT"
		"AbilityCastRange"				"1000 1100 1200 1300"
		"AbilityCastPoint"				"0.4 0.4 0.4 0.4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"22"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"80 90 100 110"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts"
			"particle"	"particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_cast.vpcf"
			"particle"	"particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_touch.vpcf"
			"particle"	"particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_buff.vpcf"
			"particle"	"particles/heros/elder_titan/status_effect_ghosts.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_FLOAT"
				"rg"						"1000 1100 1200 1300"
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"rd"						"450"
			}
			"03"
			{
				"var_type"						"FIELD_FLOAT"
				"dam"						"155 210 265 320"
				"LinkedSpecialBonus"		"special_bonus_elder_titan_4"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"sp"						"1000"
			}
			"05"
			{
				"var_type"						"FIELD_FLOAT"
				"dur"						"7"
			}
			"06"
			{
				"var_type"						"FIELD_FLOAT"
				"buff_dur"						"7"
			}
			"07"
			{
				"var_type"						"FIELD_FLOAT"
				"sp_tar"						"10 15 20 25"
			}
			"08"
			{
				"var_type"						"FIELD_FLOAT"
				"attsp_tar"					"10 12 14 16"
			}
			"09"
			{
				"var_type"						"FIELD_FLOAT"
				"att_tar"						"10 15 20 25"
			}
			"10"
			{
				"var_type"						"FIELD_FLOAT"
				"ar_tar"						"1.2"
			}
			"11"
			{
				"var_type"						"FIELD_FLOAT"
				"ghost_dur"					"6"
			}
			"12"
			{
				"var_type"						"FIELD_FLOAT"
				"ghost_att"					"2 2 3 3"
			}
		}
	}

	"return_spirit"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_elder_titan/ancestral_spirit.lua"
		"AbilityTextureName"			"elder_titan_return_spirit"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL"
		"MaxLevel"						"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"
 		"AbilityCastAnimation"			"ACT_INVALID"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"2"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts"
			"particle"	"particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_ambient_end.vpcf"
		}
	}


	"natural_order_spirit"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_elder_titan/natural_order_spirit.lua"
		"AbilityTextureName"			"elder_titan_natural_order"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_AURA"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
 		"AbilityCastAnimation"			"ACT_INVALID"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"rd"				"250"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"debuff"	   			 "-20"
			}
		}
	}


	"natural_order"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_elder_titan/natural_order.lua"
		"AbilityTextureName"			"elder_titan_natural_order"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
 		"AbilityCastAnimation"			"ACT_INVALID"
		"AbilityCooldown"				"4"
		"AbilityManaCost"				"100"
		"AbilityCastRange"				"250"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp.vpcf"
			"particle"	"particles/heros/elder_titan/natural_order_pm.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"rd"				"250"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"ar"	   		 "-20 -30 -40 -50"
			}
			"03"
			{
				"var_type"			"FIELD_INTEGER"
				"mr"			 "-60 -80 -90 -100"
			}
			"04"
			{
				"var_type"			"FIELD_INTEGER"
				"sr"			 "-10 -15 -20 -25"
			}
			"05"
			{
				"var_type"			"FIELD_INTEGER"
				"dur"			 "4"
			}
			"06"
			{
				"var_type"			"FIELD_INTEGER"
				"rd2"			 "250"
			}
		}
	}


	"earth_splitter"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_elder_titan/earth_splitter.lua"
		"AbilityTextureName"			"elder_titan_earth_splitter"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityType"				"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"2"
		"AbilitySound"				"Hero_ElderTitan.EarthSplitter.Cast"
		 "HasShardUpgrade"               "1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"3000"
		"AbilityCastPoint"				"0.4 0.4 0.4"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_5"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"100.0 100.0 100.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"125 175 225"
		"precache"
		{
			"soundfile""soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts"
			"particle"	"particles/econ/items/elder_titan/elder_titan_2021/elder_titan_2021_earth_splitter.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"t"						"2"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"dis"					"3000"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"wh"					"250"
					"LinkedSpecialBonus"		"special_bonus_elder_titan_6"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"dam"					"25 35 45"
				"LinkedSpecialBonus"		"special_bonus_elder_titan_5"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"stun_dur"				"1.5"
					"LinkedSpecialBonus"		"special_bonus_elder_titan_7"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"knockback"					"1000"
			}
		}
	}


	//+200 本体1技能伤害
	"special_bonus_elder_titan_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"200"
				"ad_linked_ability"			"echo_stomp"
			}
		}
	}
	//释放1技能时对自身强驱散
	"special_bonus_elder_titan_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
				"ad_linked_ability"			"echo_stomp"
			}
		}
	}
	//+600游魂移动速度
	"special_bonus_elder_titan_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"600"
				"ad_linked_ability"			"ancestral_spirit"
			}
		}
	}

	//+100游魂伤害
	"special_bonus_elder_titan_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"100"
				"ad_linked_ability"			"ancestral_spirit"
			}
		}
	}

	//+5% 裂地沟壑伤害
	"special_bonus_elder_titan_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"5"
				"ad_linked_ability"			"earth_splitter"
			}
		}
	}

	//+100裂地沟壑伤害宽度
	"special_bonus_elder_titan_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"100"
				"ad_linked_ability"			"earth_splitter"
			}
		}
	}

	//+2秒裂地沟壑眩晕时间
	"special_bonus_elder_titan_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"2"
				"ad_linked_ability"			"earth_splitter"
			}
		}
	}









	//=================================================================================================================
	// 船长
	//=================================================================================================================
	"torrent"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_kunkka/torrent.lua"
		"AbilityTextureName"			"kunkka_torrent"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"			"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Ability.Torrent"
		//"HasScepterUpgrade"			"1"
		"AOERadius"				"250"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1200"
		"AbilityCastPoint"				"0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"16"

		"AbilityCastAnimation"				"ACT_DOTA_CAST_ABILITY_1"
		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.5"		// applies 2 modifiers
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts"
			"particle"	"particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf"
			"particle"	"particles/econ/items/kunkka/kunkka_weapon_whaleblade/kunkka_spell_torrent_splash_whaleblade.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"					"250"
								"LinkedSpecialBonus"			"special_bonus_kunkka_1"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"rd2"					"250"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"delay"					"2"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"stun"					"2"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"dam"					"150 200 250 300"
				"LinkedSpecialBonus"			"special_bonus_kunkka_2"
			}
		}

	}

	"ghostship_storm"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_kunkka/ghostship_storm.lua"
		"AbilityTextureName"			"kunkka_torrent_storm"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"MaxLevel"				"1"
		"FightRecapLevel"				"1"
		"IsGrantedByScepter"			"1"
		"HasScepterUpgrade"			"1"
		"AbilitySound"				"Ability.Torrent"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.3"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_1"
		"AbilityCastRange"				"1000"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"70 65 60"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"300"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts"
			"particle"	"particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"rd_f"				"350"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"dam"				"200"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"stun"				"0.25"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"num"				"6"
				"LinkedSpecialBonus"		"special_bonus_kunkka_5"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"i"					"0.25"
			}
		}
	}


	"tidebringer"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_kunkka/tidebringer.lua"
		"AbilityTextureName"			"kunkka_tidebringer"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_AUTOCAST | DOTA_ABILITY_BEHAVIOR_ATTACK"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetFlags"			"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilitySound"				"Hero_Kunkka.Tidebringer.Attack"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"6"
		"AbilityCastRange"				"200"
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts"
			"particle"	"particles/econ/items/kunkka/kunkka_weapon_plunder/kunkka_weapon_tidebringer_plunder.vpcf"
			"particle"	"particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship.vpcf"
			"particle"	"particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_weapon/kunkka_spell_tidebringer_fxset.vpcf"
			"particle"	"particles/items_fx/abyssal_blade_crimson_jugger.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"dis"				"1000"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"swh"				"500"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"ewh"				"700"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"att"				"100 125 150 175"
				"LinkedSpecialBonus"		"special_bonus_kunkka_8"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"num"				"0.4 0.5 0.6 0.7"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"num1"				"0.1"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"x_marks_the_spot"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_kunkka/x_marks_the_spot.lua"
		"AbilityTextureName"			"kunkka_x_marks_the_spot"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Ability.XMarksTheSpot.Target"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"500 700 900 1100"
		"AbilityCastPoint"				"0.4 0.4 0.4 0.4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"25 20 15 10"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts"
			"particle"	"particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_x_spot_fxset.vpcf"
			"particle"	"particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_x_spot_red_fxset.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"dur"					"8"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"dur2"					"4"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"rg"					"500 700 900 1100"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"rd_enemy"					"350"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"gold"					"20 30 40 50"
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"v_dur"					"10"
			}
			"07"
			{
				"var_type"					"FIELD_FLOAT"
				"gold2"					"5"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"x_return"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_kunkka/x_marks_the_spot.lua"
		"AbilityTextureName"			"kunkka_return"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilitySound"				"Ability.XMarksTheSpot.Return"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_3"
		"MaxLevel"				"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"1.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"
				"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts"
		}
	}


	"ghostship"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_kunkka/ghostship.lua"
		"AbilityTextureName"			"kunkka_ghostship"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityType"				"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_DIRECTIONAL | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"2"
		"AbilitySound"				"Ability.Ghostship"
		"HasScepterUpgrade"			"1"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_GHOST_SHIP"
		"AbilityCastGestureSlot"			"DEFAULT"
		"AbilityCastRange"				"1200"
		"AbilityCastPoint"				"0.3"
		"AbilityCooldown"				"70"
		"AbilityManaCost"				"200 300 400"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts"
			"particle"	"particles/units/heroes/hero_kunkka/kunkka_ghost_ship.vpcf"
			"particle"	"particles/status_fx/status_effect_rum.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"rd_s"				"450"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"400 500 600"
				"LinkedSpecialBonus"		"special_bonus_kunkka_6"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"dis"				"2000"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"sp"				"1000"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"stun"				"2"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"sp_buff"				"30 40 50"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"dam_buff"			"-20 -30 -40"
			}
			"08"
			{
				"var_type"				"FIELD_INTEGER"
				"dur_buff"				"7 8 9"
			}
		}
	}
	//+100洪流范围
	"special_bonus_kunkka_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
				"ad_linked_ability"			"torrent"
			}
		}
	}
	//+100洪流伤害
	"special_bonus_kunkka_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
				"ad_linked_ability"			"torrent"
			}
		}
	}
	//-1秒潮汐使者CD
	"special_bonus_kunkka_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
				"ad_linked_ability"			"tidebringer"
			}
		}
	}


	//+0.5倍潮汐使者溅射伤害
	"special_bonus_kunkka_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"0.5"
				"ad_linked_ability"			"tidebringer"
			}
		}
	}

	//+2大白鲨数量
	"special_bonus_kunkka_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"2"
				"ad_linked_ability"			"ghostship_storm"
			}
		}
	}
	//+100幽灵船伤害
	"special_bonus_kunkka_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
				"ad_linked_ability"			"ghostship"
			}
		}
	}
	//白鲨突袭附带1秒眩晕
	"special_bonus_kunkka_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
				"ad_linked_ability"			"torrent"
			}
		}
	}

	//+50潮汐使者攻击力
	"special_bonus_kunkka_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"50"
				"ad_linked_ability"			"tidebringer"
			}
		}
	}


	//=================================================================================================================
	// 神谕
	//=================================================================================================================
	"fortunes_end"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_oracle/fortunes_end.lua"
		"AbilityTextureName"			"oracle_fortunes_end"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetFlags"			"DOTA_UNIT_TARGET_FLAG_INVULNERABLE | DOTA_UNIT_TARGET_FLAG_DEAD"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"HasScepterUpgrade"			"1"
		"AbilitySound"				"Hero_Oracle.FortunesEnd.Target"
		"AOERadius"				"400"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1200"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"8"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 120 140 160"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_oracle.vsndevts"
			"particle"	"particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_prj.vpcf"
			"particle"	"particles/units/heroes/hero_oracle/oracle_fortune_aoe.vpcf"
			"particle"	"particles/units/heroes/hero_oracle/oracle_fortune_purge.vpcf"
			"particle"	"particles/units/heroes/hero_oracle/oracle_fortune_dmg.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"					"400"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"dam"					"100 200 300 400"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"dur"					"2 2.5 3 3.5"
			}

		}
		"AbilityCastAnimation"					"ACT_DOTA_CAST_ABILITY_1_END"
	}

	"fates_edict"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_oracle/fates_edict.lua"
		"AbilityTextureName"			"oracle_fates_edict"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY | DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_Oracle.FatesEdict.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1200"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"10"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"200"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_oracle.vsndevts"
			"particle"	"particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"dur"				"3 4 5 6"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	"purifying_flames"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_oracle/purifying_flames.lua"
		"AbilityTextureName"			"oracle_purifying_flames"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY | DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Oracle.PurifyingFlames.Damage"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1200"
		"AbilityCastPoint"				"0.2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"2.5"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"200"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_oracle.vsndevts"
			"particle"	"particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames.vpcf"
			"particle"	"particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames_hit.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"170 240 310 380"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"heal"				"70 80 90 100"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"				"6"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"int"				"40 60 80 100"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"mana"				"25 35 45 55"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"false_promise"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_oracle/false_promise.lua"
		"AbilityTextureName"			"oracle_false_promise"
		"AbilityType"				"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"				"Hero_Oracle.FalsePromise.Cast"
		 "HasShardUpgrade"               "1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000"
		"AbilityCastPoint"				"0.3"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"45"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 150 200"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_oracle.vsndevts"
			"particle"	"particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf"
			"particle"	"particles/units/heroes/hero_oracle/oracle_false_promise.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"dur"				"8 9 10"
			}
		}
	}

	//命运煞令对敌军附带3秒缴械
	"special_bonus_oracle_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//移除命运煞令蓝耗
	"special_bonus_oracle_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//-1秒涤罪之焰CD
	"special_bonus_oracle_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"purifying_flames"
			}
		}
	}

	//移除涤罪之焰施法前摇
	"special_bonus_oracle_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//命运共同体不会再分摊伤害
	"special_bonus_oracle_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//释放虚妄之诺附带当前等级的命运煞令
	"special_bonus_oracle_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//对友军释放虚妄之诺自身也会获得
	"special_bonus_oracle_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"omni_slash"
			}
		}
	}
	//范围型涤罪之焰（300码）
	"special_bonus_oracle_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"

	}

















	//=================================================================================================================
	// 剑圣
	//=================================================================================================================
	"blade_fury"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_juggernaut/blade_fury.lua"
		"AbilityTextureName"			"juggernaut_blade_fury"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL | DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"250"
		"AbilityCastPoint"				"0 0 0 0"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"23 22 21 20"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts"
			"particle"	"particles/heros/jugg/jugg_shockwave.vpcf"
			"particle"	"particles/heros/jugg/jugg_des.vpcf"
			"particle"	"particles/base_attacks/ranged_tower_bad_explosion.vpcf"
			"particle"	"particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_blade_fury.vpcf"
			"particle"	"particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal_golden.vpcf"
			"particle"	"particles/econ/items/juggernaut/bladekeeper_bladefury/_dc_juggernaut_blade_fury.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"tick"					"0.25"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"					"250"
				"LinkedSpecialBonus"		"special_bonus_juggernaut_2"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"dam"					"100 135 170 205"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"dur"					"4"
				"LinkedSpecialBonus"		"special_bonus_juggernaut_1"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"des_rd"					"700"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	"blade_dance"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_juggernaut/blade_dance.lua"
		"AbilityTextureName"			"juggernaut_blade_dance"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityCastRange"				"0"
		"AbilityCastPoint"				"0"
		"AbilityCooldown"				"0"
		"AbilityManaCost"				"0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts"
			"particle"	"particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_crit_tgt.vpcf"
			"particle"	"particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf"
			"particle"	"particles/heros/jugg/jugg_jump.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"ch"				"25"
				"LinkedSpecialBonus"		"special_bonus_juggernaut_4"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"crit_mult"			"140 160 180 200"
				"LinkedSpecialBonus"		"special_bonus_juggernaut_3"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"agi"				"0.5 0.7 0.9 1.1"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}

	"healing_ward"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_juggernaut/healing_ward.lua"
		"AbilityTextureName"			"juggernaut_healing_ward"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilitySound"				"Hero_Juggernaut.HealingWard.Cast"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"AOERadius"				"400"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"400"
		"AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"60.0 55 50 45"
		"AbilityDuration"				"15"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts"
			"particle"	"particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healing_ward_fortunes_tout_gold.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"heal"					"3 4 5 6"
				"LinkedSpecialBonus"		"special_bonus_juggernaut_5"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"					"400"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"sp"					"400"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"					"20"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"tick"					"0.7"
			}
		}
		"AbilityCastAnimation"					"ACT_DOTA_CAST_ABILITY_2"
	}

	"healing_ward2"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_juggernaut/healing_ward2.lua"
		"AbilityTextureName"			"jugg_dog"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT | DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000"
		"AbilityCastPoint"				"0 0 0 0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"60"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts"
			"particle"	"particles/heros/jugg/jugg_dog.vpcf"
			"particle"	"particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf"
			"particle"	"particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf"
			"particle"	"particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf"
			"particle"	"particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_trigger.vpcf"
			"model"	"models/items/warlock/golem/puppet_summoner_golem/puppet_summoner_golem.vmdl"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"rd"					"1000"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"					"20"
			}
		}
	}

	"omni_slash"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_juggernaut/omni_slash.lua"
		"AbilityTextureName"			"juggernaut_omni_slash"
		"AbilityType"				"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetFlags"			"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"2"
		 "HasShardUpgrade"               "1"
		//"AbilityDraftUltScepterAbility"			"swift_slash"
		"HasScepterUpgrade"			"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"350"
		"AbilityCastPoint"				"0"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"100"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"200 250 300"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"			"0.0"		// damage only

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts"
			"particle"	"particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_dash.vpcf"
			"particle"	"particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_dash.vpcf"
			"particle"	"particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt.vpcf"
			"particle"	"particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_trail.vpcf"
			"particle"	"particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_counter.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"dur"	"1 1.2 1.4"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"dami"	"0.2"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"dis"	"350"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"rd"	"800 900 1000"
			}
		}
	}

	"swift_slash"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_juggernaut/swift_slash.lua"
		"AbilityTextureName"			"juggernaut_swift_slash"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetFlags"			"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"MaxLevel"				"1"
		"FightRecapLevel"				"1"
		"IsGrantedByScepter"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"0"
		"AbilityCastPoint"				"0"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"20"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts"
			"particle"	"particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt.vpcf"
			"particle"	"particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf"
			"particle"	"particles/heros/jugg/jugg_jump.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_FLOAT"
				"dis"			"700"
				"RequiresScepter"				"1"
			}
		}
	}



	"swift_slash2"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_juggernaut/swift_slash2.lua"
		"AbilityTextureName"			"juggernaut_swift_slash"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetFlags"			"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"MaxLevel"				"1"
		"FightRecapLevel"				"1"
		"IsGrantedByScepter"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0.2"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"14"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts"
			"particle"	"particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_FLOAT"
				"att"			"1"
				"RequiresScepter"				"1"
			}
		}
	}

	//+1秒剑刃风暴持续时间
	"special_bonus_juggernaut_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"blade_fury"
			}
		}
	}
	//+100剑刃风暴范围
	"special_bonus_juggernaut_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"100"
				"ad_linked_ability"			"blade_fury"
			}
		}
	}

	//+25%剑舞暴击倍率
	"special_bonus_juggernaut_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"25"
				"ad_linked_ability"			"blade_dance"
			}
		}
	}

	//+10%剑舞暴击概率
	"special_bonus_juggernaut_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"10"
				"ad_linked_ability"			"blade_dance"
			}
		}
	}

	//+2%守卫回血
	"special_bonus_juggernaut_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"2"
				"ad_linked_ability"			"healing_ward"
			}
		}
	}

	//-6秒居合斩CD
	"special_bonus_juggernaut_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"6"
				"ad_linked_ability"			"swift_slash2"
			}
		}
	}
	//+1秒无敌斩持续时间
	"special_bonus_juggernaut_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"omni_slash"
			}
		}
	}
	//居合斩无前摇
	"special_bonus_juggernaut_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0"
				"ad_linked_ability"			"swift_slash2"
			}
		}
	}



//凤凰
	"icarus_dive"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_phoenix/icarus_dive.lua"
		"AbilityTextureName"			"phoenix_icarus_dive"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AUTOCAST | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Hero_Phoenix.IcarusDive.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"					"0"
		"AbilityCharges"					"3"
		"AbilityChargeRestoreTime"				"20 19 18 17"
		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts"
			"particle"	"particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_icarus_dive.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"a_dur"				"14"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"dis"				"700"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"p_sp"				"1500"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"p_rd"				"200"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"s_dur"				"3"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"rd"				"500"
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"s_sp"				"1200"
			}
			"08"
			{
				"var_type"				"FIELD_FLOAT"
				"res"				"20"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}




	"fire_spirits"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_phoenix/fire_spirits.lua"
		"AbilityTextureName"			"phoenix_fire_spirits"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Phoenix.FireSpirits.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_2"
		"AbilityCastGestureSlot"		"DEFAULT"
		"AbilityCastRange"				"1400"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"12"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts"
			"particle"	"particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_fire_spirits.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"rd"			"250"
				"LinkedSpecialBonus"		"special_bonus_phoenix_1"
			}
			"02"
			{
				"var_type"			"FIELD_FLOAT"
				"dam"			"100 110 120 130"
			}
			"03"
			{
				"var_type"			"FIELD_FLOAT"
				"tick"			"0.5"
			}
			"04"
			{
				"var_type"			"FIELD_INTEGER"
				"dam_dur"		"4"
			}
			"05"
			{
				"var_type"			"FIELD_FLOAT"
				"att_sp"			"-80 -100 -120 -140"
			}
			"06"
			{
				"var_type"			"FIELD_INTEGER"
				"sp"			"1000"
			}
			"07"
			{
				"var_type"			"FIELD_INTEGER"
				"hp"			"15"
			}
			"08"
			{
				"var_type"				"FIELD_FLOAT"
				"num"				"4"
				"LinkedSpecialBonus"		"special_bonus_phoenix_2"
			}
			"09"
			{
				"var_type"				"FIELD_FLOAT"
				"dur"				"10"
			}
			"09"
			{
				"var_type"				"FIELD_FLOAT"
				"cd"				"3"
			}
		}
	}


	"sun_ray"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_phoenix/sun_ray.lua"
		"AbilityTextureName"			"phoenix_sun_ray"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Phoenix.SunRay.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"2000"
		"AbilityCastPoint"				"0.01"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"24"
		"AbilityDuration"				"8"

		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts"
			"particle"	"particles/econ/items/phoenix/phoenix_solar_forge/phoenix_sunray_solar_forge.vpcf"
			"particle"	"particles/units/heroes/hero_phoenix/phoenix_sunray_mane.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_FLOAT"
				"hp"							"2"
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"base_dam"						"40"
					"LinkedSpecialBonus"		"special_bonus_phoenix_4"
			}
			"03"
			{
				"var_type"						"FIELD_FLOAT"
				"dam_per"						"1 1.5 2 2.5"
				"LinkedSpecialBonus"		"special_bonus_phoenix_3"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"base_heal"						"20 30 40 50"
				"LinkedSpecialBonus"		"special_bonus_phoenix_4"
			}
			"05"
			{
				"var_type"						"FIELD_FLOAT"
				"heal_per"						"1 1.4 1.8 2.2"
				"LinkedSpecialBonus"		"special_bonus_phoenix_3"
			}

			"06"
			{
				"var_type"						"FIELD_INTEGER"
				"rd"							"130"
			}
			"07"
			{
				"var_type"						"FIELD_FLOAT"
				"tick"							"0.5"
			}
			"08"
			{
				"var_type"						"FIELD_FLOAT"
				"dur"							"8"
			}
			"09"
			{
				"var_type"						"FIELD_FLOAT"
				"currhp"						"10"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}

	"sun_ray_stop"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_phoenix/sun_ray_stop.lua"
		"AbilityTextureName"			"phoenix_sun_ray_stop"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"MaxLevel"						"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"
		"AbilityCastAnimation"			"ACT_INVALID"
	}


	"sun_ray_toggle_move"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_phoenix/sun_ray_toggle_move.lua"
		"AbilityTextureName"			"phoenix_sun_ray_toggle_move"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES"
		"MaxLevel"						"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"
		"AbilityCastAnimation"			"ACT_INVALID"
	}

	"supernova"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_phoenix/supernova.lua"
		"AbilityTextureName"			"phoenix_supernova"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"2"
		"HasScepterUpgrade"			"1"
		"AbilitySound"					"Hero_Phoenix.SuperNova.Begin"
		 "HasShardUpgrade"               "1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"500"
		"AbilityCastPoint"				"0.01"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_5"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"90"
		"AbilityDuration"				"5.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts"
			"particle"	"particles/heros/phoenix/phoenix_sunray_solar_forge.vpcf"
			"particle"	"particles/units/heroes/hero_phoenix/phoenix_supernova_egg.vpcf"
			"particle"	"particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
			"particle"	"particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"rd"				"1200"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"dam"				"150 200 250"
				"LinkedSpecialBonus"		"special_bonus_phoenix_6"
			}

			"03"
			{
				"var_type"			"FIELD_FLOAT"
				"tick"				"1"
			}
			"04"
			{
				"var_type"			"FIELD_INTEGER"
				"stun"				"1 2 3"
			}
			"05"
			{
				"var_type"			"FIELD_INTEGER"
				"att_num"			"8 12 16"
			"LinkedSpecialBonus"		"special_bonus_phoenix_8"
			}
			"06"
			{
				"var_type"			"FIELD_INTEGER"
				"dur"				"5"
			}
				"07"
			{
				"var_type"			"FIELD_FLOAT"
				"hpmax"				"0.5"
			}
		}
	}

	"launch_fire_spirit"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_phoenix/launch_fire_spirit.lua"
		"AbilityTextureName"			"phoenix_launch_fire_spirit"
		"AbilityType"				"DOTA_ABILITY_TYPE_BASIC"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilitySound"				"Hero_Phoenix.FireSpirits.Launch"
		"MaxLevel"				"4"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1400"
		"AbilityCastAnimation"			"ACT_INVALID"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0 0 0 0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts"
			"particle"	"particles/heros/phoenix/launch_fire_spirit.vpcf"
			"particle"	"particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_fire_spirit_ground.vpcf"
			"particle"	"particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"rd"			"250"
					"LinkedSpecialBonus"		"special_bonus_phoenix_1"
			}
			"02"
			{
				"var_type"			"FIELD_FLOAT"
				"dam"			"100 110 120 130"
			}
			"03"
			{
				"var_type"			"FIELD_FLOAT"
				"tick"			"0.5"
			}
			"04"
			{
				"var_type"			"FIELD_INTEGER"
				"dam_dur"		"4"
			}
			"05"
			{
				"var_type"			"FIELD_FLOAT"
				"att_sp"			"-80 -100 -120 -140"
			}
			"06"
			{
				"var_type"			"FIELD_INTEGER"
				"sp"			"1000"
			}

		}
	}

	//+100烈火精灵范围
	"special_bonus_phoenix_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
				"ad_linked_ability"			"fire_spirits"
			}
		}
	}
	//+1烈火精灵数量
	"special_bonus_phoenix_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
				"ad_linked_ability"			"fire_spirits"
			}
		}
	}
	//+1%烈日炙烤伤害与治疗
	"special_bonus_phoenix_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
				"ad_linked_ability"			"sun_ray"
			}
		}
	}
	//+50烈日炙烤基础伤害与治疗
	"special_bonus_phoenix_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"50"
				"ad_linked_ability"			"sun_ray"
			}
		}
	}
	//+100超新星激光范围
	"special_bonus_phoenix_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
				"ad_linked_ability"			"supernova"
			}
		}
	}
	//+100超新星伤害
	"special_bonus_phoenix_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
				"ad_linked_ability"			"supernova"
			}
		}
	}
	//+3%炽热的心当前生命百分比伤害
	"special_bonus_phoenix_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"3"
				"ad_linked_ability"			"sun_ray"
			}
		}
	}
	//+4超新星被攻击次数
	"special_bonus_phoenix_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"4"
				"ad_linked_ability"			"supernova"
			}
		}
	}
	//=================================================================================================================
	// 太妹
	//=================================================================================================================
	"refraction"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_templar_assassin/refraction.lua"
		"AbilityTextureName"			"templar_assassin_refraction"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"					"Hero_TemplarAssassin.Refraction"
		 "HasShardUpgrade"               			"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"12"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 80 60 40"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts"
			"particle"	"particles/econ/items/lanaya/ta_ti9_immortal_shoulders/ta_ti9_refraction.vpcf"
			"particle"	"particles/units/heroes/hero_templar_assassin/templar_loadout.vpcf"
			"particle"	"particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"num"					"7 8 9 10"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"att"					"18"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"attsp"					"30 40 50 60"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"					"600"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"					"12"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"meld"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_templar_assassin/meld.lua"
		"AbilityTextureName"			"templar_assassin_meld"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"					"Hero_TemplarAssassin.Meld"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"4"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts"
			"particle"	"particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal_attack_hit.vpcf"
			"particle"	"particles/econ/items/templar_assassin/templar_assassin_focal/templar_meld_focal_hit_tgt.vpcf"
			"particle"	"particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal.vpcf"
			"particle"	"particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal_start.vpcf"
			"particle"	"particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf"
			"particle"	"particles/units/heroes/hero_templar_assassin/templar_meld_overhead.vpcf"
			"particle"	"particles/econ/events/spring_2021/blink_dagger_spring_2021_end.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"dam"					"150 200 250 300"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"ar"					"-6 -7 -8 -9"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"ardur"					"12"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"healdur"					"2"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"stundur"					"0.5"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	"psi_blades"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_templar_assassin/psi_blades.lua"
		"AbilityTextureName"			"templar_assassin_psi_blades"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PURE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityCooldown"				"1"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts"
			"particle"	"particles/units/heroes/hero_templar_assassin/templar_assassin_psi_blade.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"attrg"					"120 180 240 300"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"attack_spill_range"				"630 670 710 750"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"attack_spill_width"				"100"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"attack_spill_pct"				"100"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"psionic_trap"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_templar_assassin/psionic_trap.lua"
		"AbilityTextureName"			"templar_assassin_psionic_trap"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityType"				"DOTA_ABILITY_TYPE_ULTIMATE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"				"Hero_TemplarAssassin.Trap"
		"HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"2000"
		"AbilityCastPoint"				"0.3 0.3 0.3 0.3"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_5"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"11.0 8.0 5.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"15 15 15"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts"
			"particle"	"particles/heros/templar_assassin/templar_assassin_trap_portrait.vpcf"
			"particle"	"particles/units/heroes/hero_templar_assassin/templar_assassin_trap.vpcf"
			"particle"	"particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"					"60"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"max"					"5 8 11"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"					"300"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"dam"					"350 450 550"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"confuse"					"2"
			}
		}
	}


	"assassin_trap"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_templar_assassin/assassin_trap.lua"
		"AbilityTextureName"			"templar_assassin_trap"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"MaxLevel"				"1"
		//"IsGrantedByScepter"			"1"
		//"HasScepterUpgrade"			"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.4"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0.5"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportBonus"		"100"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts"
			"particle"	"particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf"
			"particle"	"particles/units/heroes/hero_templar_assassin/templar_meld_hit_tgt.vpcf"
			"particle"	"particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf"
			"particle"	"particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal.vpcf"
			"particle"	"particles/econ/items/templar_assassin/templar_assassin_focal/templar_meld_focal_hit_tgt.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"				"7"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"rd"				"500"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"sp"				"-50"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"crit"				"300"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"sp_dur"				"3"
			}
		}

	}

	"trap_teleport"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_templar_assassin/trap_teleport.lua"
		"AbilityTextureName"			"templar_assassin_trap_teleport"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE"
		"MaxLevel"				"1"
		"FightRecapLevel"				"1"
		//"IsGrantedByScepter"			"1"
		//"HasScepterUpgrade"			"1"


		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.4"
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
		"AbilityCastRange"				"2000"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"30"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts"
			"particle"	"particles/heros/templar_assassin/trap_teleport.vpcf"
			"particle"	"particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf"
			"particle"	"particles/heros/templar_assassin/templar_assassin_trap_portrait.vpcf"
			"particle"	"particles/heros/templar_assassin/trap_teleport.vpcf"
			"particle"	"particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf"
			"particle"	"particles/heros/templar_assassin/templar_assassin_trap_portrait.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"				"7"
				"RequiresScepter"		"1"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"rd"				"500"
				"RequiresScepter"		"1"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"sp"				"-50"
				"RequiresScepter"		"1"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"crit"				"300"
				"RequiresScepter"		"1"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"sp_dur"				"3"
				"RequiresScepter"		"1"
			}
		}
	}
	//-3遮光CD
	"special_bonus_templar_assassin_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"3"
				"ad_linked_ability"			"refraction"
			}
		}
	}

	"special_bonus_templar_assassin_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	"special_bonus_templar_assassin_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"200"
				"ad_linked_ability"			"assassin_trap"
			}
		}
	}

	"special_bonus_templar_assassin_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	"special_bonus_templar_assassin_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	"special_bonus_templar_assassin_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"0.5"
				"ad_linked_ability"			"psi_blades"
			}
		}
	}

	"special_bonus_templar_assassin_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	"special_bonus_templar_assassin_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"

	}

	//=================================================================================================================
	// AA
	//=================================================================================================================
	"cold_feet"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_ancient_apparition/cold_feet.lua"
		"AbilityTextureName"			"ancient_apparition_cold_feet"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PURE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Hero_Ancient_Apparition.ColdFeetCast"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts"
			"particle"	"particles/econ/events/snowball/snowball_projectile.vpcf"
			"particle"	"particles/econ/events/snowball/snowball_projectile_explosion.vpcf"
			"particle"	"particles/status_fx/status_effect_frost_armor.vpcf"
			"particle"	"particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_frozen.vpcf"
			"model"	"models/items/crystal_maiden/snowman/crystal_maiden_snowmaiden.vmdl"
		}
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"			"ACT_DOTA_COLD_FEET"
		"AbilityCastGestureSlot"			"DEFAULT"
		"AbilityCastRange"				"900"
		"AbilityCastPoint"				"0.2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"10"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"70 80 90 100"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.5"	// Does two modifiers

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"dam"				"150 200 250 300"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"spdur"				 "1.5"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"sp"				"-30 -40 -50 -60"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"stun"				"0.75 1 1.25 1.5"
			}
				"05"
			{
				"var_type"				"FIELD_FLOAT"
				"csdur"				"3"
				"LinkedSpecialBonus"		"special_bonus_ancient_apparition_1"
			}
				"06"
			{
				"var_type"				"FIELD_FLOAT"
				"cs"				"100 120 140 160"
			}
		}
	}

	"ice_vortex"
	{
		"BaseClass"			"ability_lua"
		"ScriptFile"			"heros/hero_ancient_apparition/ice_vortex.lua"
		"AbilityTextureName"			"ancient_apparition_ice_vortex"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PURE"
		"AbilitySound"					"Hero_Ancient_Apparition.IceVortexCast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"			"ACT_DOTA_ICE_VORTEX"
		"AbilityCastGestureSlot"		"DEFAULT"
		"AbilityCastRange"				"1000"
		"AbilityCastPoint"				"0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"10"
		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"70 80 90 100"

		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts"
			"particle"	"particles/econ/items/ancient_apparition/ancient_apparation_ti8/ancient_ice_vortex_ti8.vpcf"
			"particle"	"particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_main_ti5.vpcf"
			"particle"	"particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf"
			"particle"	"particles/status_fx/status_effect_frost_lich.vpcf"

		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"				"350 400 450 500"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"				"5"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"150 200 250 300"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"sp"				"25 30 35 40"
			}

			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"dam_in"				"10"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"stun"				"1.5"
				"LinkedSpecialBonus"		"special_bonus_ancient_apparition_2"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"v"				"500"
			}


		}
	}

	"chilling_touch"
	{
		"BaseClass"	"ability_lua"
		"ScriptFile"	"heros/hero_ancient_apparition/chilling_touch.lua"
		"AbilityTextureName"			"ancient_apparition_chilling_touch"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		//"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_Ancient_Apparition.ChillingTouchCast"
		"AbilityManaCost"				"25"
		 "HasShardUpgrade"               "1"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts"
			"particle"	"particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf"

		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"50 70 90 110"
				"LinkedSpecialBonus"		"special_bonus_ancient_apparition_3"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"ch"				"15"

			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"chdur"				"3 4 5 6"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"attr"				"120 140 160 180 "
				"LinkedSpecialBonus"		"special_bonus_ancient_apparition_4"
			}
		}
	}


	"ice_blast"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_ancient_apparition/ice_blast.lua"
		"AbilityTextureName"			"ancient_apparition_ice_blast"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"//DOTA_ABILITY_BEHAVIOR_IMMEDIATE |
		"AbilityType"				"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"2"
		"AbilitySound"				"Hero_Ancient_Apparition.IceBlast.Target"
		"HasScepterUpgrade"			"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.1"
		"AbilityCastRange"				"4000"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"60"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"200 300 400"

		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts"
			"particle"		"particles/econ/items/ancient_apparition/ancient_apparation_ti8/ancient_ice_vortex_ti8.vpcf"
			"particle"		"particles/status_fx/status_effect_frost_lich.vpcf"
			"particle"		"particles/heros/aa/snowball_projectile2.vpcf"


		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"				"350"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"dur_sp"				"3"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"stun"				"1.5 2.5 3.5"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"250 350 450"
			}
		}
	}

	//+1.5秒雪球暴击时间
	"special_bonus_ancient_apparition_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1.5"
				"ad_linked_ability"			"cold_feet"
			}
		}
	}
	//+1秒冰冻光球眩晕时间
	"special_bonus_ancient_apparition_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"ice_vortex"
			}
		}
	}

	//+60寒霜之触伤害
	"special_bonus_ancient_apparition_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
				"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"60"
				"ad_linked_ability"			"chilling_touch"
			}
		}
	}

	//+55寒霜之触攻击距离
	"special_bonus_ancient_apparition_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"55"
				"ad_linked_ability"			"chilling_touch"
			}
		}
	}

	//寒霜之触不再消耗魔法
	"special_bonus_ancient_apparition_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"

	}

		//+1冰霜雪球数量
	"special_bonus_ancient_apparition_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"ice_blast"
			}
		}
	}


		//寒霜之触变为纯粹伤害
	"special_bonus_ancient_apparition_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//攻击河道中的单位会使其冰冻0.15秒
	"special_bonus_ancient_apparition_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


//老姐
	"impetus"
	{
		"BaseClass"		"ability_lua"
		"AbilityTextureName"	"enchantress_impetus"
		"ScriptFile"		"heros/hero_enchantress/impetus.lua"
		"AbilityBehavior"		"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_CREEP"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetFlags"	"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"		"SPELL_IMMUNITY_ENEMIES_YES"
		"CastFilterRejectCaster"	"1"
		"FightRecapLevel"		"1"
		"AbilityType"		"DOTA_ABILITY_TYPE_BASIC"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		"AbilityCooldown"	"0"
		"AbilityManaCost"	"0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts"
			"particle"	"particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"dam"	"10 15 20 25"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"maxdis"	"10000"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"psp"	"50"
			}
		}
		"HasScepterUpgrade"	"1"
	}


	"natures_attendants"
	{
		"BaseClass"		"ability_lua"
		"AbilityTextureName"	"enchantress_natures_attendants"
		"ScriptFile"		"heros/hero_enchantress/natures_attendants.lua"
		"AbilityBehavior"		"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"SpellImmunityType"		"SPELL_IMMUNITY_ALLIES_YES"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"			"0.3 0.3 0.3 0.3"
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"			"26 23 20 17"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"			"150 140 130 120"
		"AbilityCastRange"			"300 400 500 600"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts"
			"particle"	"particles/units/heroes/hero_enchantress/enchantress_natures_attendants_heal.vpcf"
			"particle"	"particles/units/heroes/hero_enchantress/enchantress_natures_attendants_count14.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"		"FIELD_FLOAT"
				"dur"		"10"
			}
			"02"
			{
				"var_type"		"FIELD_FLOAT"
				"heal_interval"	"0.2"
			}
			"03"
			{
				"var_type"		"FIELD_FLOAT"
				"heal_int"		"5 10 15 20"
			}
			"04"
			{
				"var_type"		"FIELD_FLOAT"
				"num"		"1"
			}
			"05"
			{
				"var_type"		"FIELD_FLOAT"
				"dur2"		"2"
			}
			"06"
			{
				"var_type"		"FIELD_FLOAT"
				"vrd"		"1000 1100 1200 1300"
			}
			"07"
			{
				"var_type"		"FIELD_FLOAT"
				"rd"		"500"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"AbilitySound"	"Hero_Enchantress.NaturesAttendantsCast"
	}

	"untouchable"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"enchantress_untouchable"
		"ScriptFile"	"heros/hero_enchantress/untouchable.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_1"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"attsp"	"-6"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"chance"	"10 12 14"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"t"	"0.5"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"dis"	"300 350 400"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
	}


	"bunny_hop"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"enchantress_bunny_hop"
		"ScriptFile"	"heros/hero_enchantress/bunny_hop.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_HIDDEN"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_BOTH"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"1"
		"IsShardUpgrade"				"1"
    		 "HasShardUpgrade"               "1"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"3"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"0"
		"AbilityCastRange"	"00"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts"
			"particle"		"particles/econ/courier/courier_trail_blossoms/courier_trail_blossoms.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"speed"	"1200"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"dis"	"400"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"AttackR"	"400"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"SP"	"-10"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"DaM"	"10"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"dur"	"3"
			}

		}
		"AbilitySound"	"Hero_Enchantress.EnchantCreep"
	}

	"enchant"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"enchantress_enchant"
		"ScriptFile"				"heros/hero_enchantress/enchant.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilitySound"				"Hero_Enchantress.EnchantCreep"
		"MaxLevel"	"4"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"30 25 20 15"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"40"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"dur"				"30"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"durhero"				"2"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"att"				"7 8 9 10"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"ar"				"10 13 16 19"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	//爱的精灵每隔2秒对自身进行弱驱散
	"special_bonus_enchantress_1"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//推进没有距离上限
	"special_bonus_enchantress_2"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//-1魔晶跳跃CD
	"special_bonus_enchantress_3"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
				"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"bunny_hop"
			}
		}
	}

	//推进命中时距离大于1500则会眩晕目标0.5秒
	"special_bonus_enchantress_4"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//触发大招击退时提升自己20%移速
	"special_bonus_enchantress_5"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"

	}
	//魅惑的野怪无视技能免疫
	"special_bonus_enchantress_6"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//不可阻挡无法被破坏
	"special_bonus_enchantress_7"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//小鹿被英雄击杀时全图小兵获得大幅度移速加成
	"special_bonus_enchantress_8"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

















	//泰罗
	"storm_bolt"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"sven_storm_bolt"
		"ScriptFile"				"heros/hero_sven/storm_bolt.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Hero_Sven.StormBoltImpact"
		 "HasShardUpgrade"               "1"
		"HasScepterUpgrade"				"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0.2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"13"


		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"110 120 130 140"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_sven.vsndevts"
			"particle"		"particles/units/heroes/hero_sven/sven_spell_storm_bolt_lightning.vpcf"
			"particle"		"particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf"
			"particle"		"particles/heros/axe/axe_bkb.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"sp"				"1600"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"stun"				"1.5"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"				"255"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"vrd"				"225"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"150 200 250 300"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"rg1"				"600"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"rg2"				"100 200 300 400"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"great_cleave"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"sven_great_cleave"
		"ScriptFile"				"heros/hero_sven/great_cleave.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
					// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000"
		"AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"30"


		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"150"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_sven.vsndevts"
			"particle"	"particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf"
			"particle"	"particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf"
			"particle"	"particles/vr/player_light_godray.vpcf"
			"particle"	"particles/tgp/sven/sowrd_ground_m.vpcf"
			"particle"	"particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start_bolt_parent.vpcf"
			"particle"	"particles/heros/axe/shake.vpcf"
			"particle"	"particles/tgp/sven/sword_m.vpcf"
			"particle"	"particles/tgp/sven/sven_circle_m.vpcf"

		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"swh"				"150"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"ewh"				"360"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"dis"				"700"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"40 60 80 100"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"dam2"				"10 11 12 13"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"warcry"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"sven_warcry"
		"ScriptFile"				"heros/hero_sven/warcry.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE | DOTA_ABILITY_BEHAVIOR_IGNORE_SILENCE"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"AbilitySound"				"Hero_Sven.WarCry"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"			"ACT_DOTA_OVERRIDE_ABILITY_3"
		"AbilityCastGestureSlot"			"DEFAULT"
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"13"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_sven.vsndevts"
			"particle"	"particles/units/heroes/hero_sven/sven_warcry_buff.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"movespeed"			"8 12 16 20"
					"LinkedSpecialBonus"		"special_bonus_sven_4"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"bonus_armor"		"5 7 9 11"
			}
			"03"
			{
				"var_type"			"FIELD_INTEGER"
				"radius"			"700"
			}
			"05"
			{
				"var_type"			"FIELD_INTEGER"
				"duration"			"7"
			}
		}
	}


	"gods_strength"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"sven_gods_strength"
		"ScriptFile"				"heros/hero_sven/gods_strength.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Sven.GodsStrength"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
 		"AbilityCastAnimation"			"ACT_DOTA_OVERRIDE_ABILITY_4"
		"AbilityCastGestureSlot"			"DEFAULT"
		"AbilityCastPoint"				"0.3 0.3 0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"90 80 70"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 150 200"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_sven.vsndevts"
			"particle"	"particles/status_fx/status_effect_gods_strength.vpcf"
			"particle"	"particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
			"particle"	"particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf"
			"particle"	"particles/units/heroes/hero_sven/sven_spell_gods_strength_ambient.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"gods_strength_damage"		"210 230 250"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"				"30"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"dur2"				"4.5"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"att"				"1.3 1.2 1.1"
			}
		}
	}
	//风暴之拳会眩晕路径上的英雄
	"special_bonus_sven_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0"
				"ad_linked_ability"			"storm_bolt"
			}
		}
	}
	//风暴之拳飞行结束后获得1秒魔免
	"special_bonus_sven_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"storm_bolt"
			}
		}
	}

	//处于守望者之剑范围内时战吼CD降低70%
	"special_bonus_sven_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0"
				"ad_linked_ability"			"warcry"
			}
		}
	}

	//战吼可以驱散天堂缴械
	"special_bonus_sven_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0"
				"ad_linked_ability"			"warcry"
			}
		}
	}



	//移除所有技能蓝耗
	"special_bonus_sven_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//战吼释放时对周围友军施加弱驱散
	"special_bonus_sven_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}
	//风暴之拳施法距离提高至全图
	"special_bonus_sven_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//永久处于神之力量状态下
	"special_bonus_sven_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//=================================================================================================================
	// 谜团
	//=================================================================================================================
	"malefice"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"enigma_malefice"
		"ScriptFile"				"heros/hero_enigma/malefice.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Hero_Enigma.Malefice"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"800"
		"AbilityCastPoint"				"0.1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"14"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 150 200 250"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.33"	// Applies multiple modifiers
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts"
			"particle"	"particles/status_fx/status_effect_enigma_malefice.vpcf"
			"particle"	"particles/units/heroes/hero_enigma/enigma_malefice.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"tick_rate"				"1"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"stun_duration"			"0.6"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"40 60 80 100"
				"LinkedSpecialBonus"		"special_bonus_enigma_1"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"4"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"rd"				"350 400 450 500"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"dam"				"100 150 200 250"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"demonic_conversion"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"enigma_demonic_conversion"
		"ScriptFile"				"heros/hero_enigma/demonic_conversion.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_CREEP | DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_BUILDING"
		"AbilitySound"					"Hero_Enigma.Demonic_Conversion"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"0"
		"AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"25"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"140 150 160 170"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts"
			"particle"	"particles/units/heroes/hero_enigma/enigma_demonic_conversion.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"spawn_count"			"3"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"split_attack_count"			"7"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"eidolon_hp"			"180 200 220 240"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"life_extension"			"2.0 2.0 2.0 2.0"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"eidolon_dmg"			"20 28 38 47"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"				"14"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"max"				"14"
			}
			"08"
			{
				"var_type"				"FIELD_INTEGER"
				"cdnum"				"7"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"midnight_pulse"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"enigma_midnight_pulse"
		"ScriptFile"				"heros/hero_enigma/midnight_pulse.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Enigma.Midnight_Pulse"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"			"ACT_DOTA_MIDNIGHT_PULSE"
		"AbilityCastGestureSlot"			"DEFAULT"
		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0.1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"30"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 150 200 250"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts"
			"particle"	"particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"550"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"damage_percent"				"7 8 9 10"
				"CalculateSpellDamageTooltip"	"0"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"9 10 11 12"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"attsp"					"40 60 80 100"
				"LinkedSpecialBonus"		"special_bonus_enigma_2"
			}
		}
	}


	"black_hole"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"hole"
		"ScriptFile"				"heros/hero_enigma/black_hole.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_CHANNELLED"
		"AbilityType"				"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"				"2"
		 "HasShardUpgrade"               "1"
		 "HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"300"
		"AbilityCastPoint"				"0.3 0.3 0.3"
		"AbilityChannelTime"			"4.0"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"
		"AbilityChannelAnimation"		"ACT_DOTA_CHANNEL_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"190 180 170"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"300 400 500"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts"
			"particle"		"particles/units/heroes/hero_enigma/enigma_blackhole.vpcf"
			"particle"		"particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5.vpcf"
			"particle"		"particles/tgp/enigma/screen_black_hole0.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"200 250 300"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"pull_radius"			"420"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"4.0 4.0 4.0"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"vision_radius"			"800 800 800"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"ch"					"15"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"					"1000 1400 1600"
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"damage_percent"				"8 9 10"
			}
		}
	}

	//+100憎恶伤害
	"special_bonus_enigma_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"100"
				"ad_linked_ability"			"malefice"
			}
		}
	}
	//+30能量获取攻速
	"special_bonus_enigma_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"30"
				"ad_linked_ability"			"midnight_pulse"
			}
		}
	}

	//能量获取对友军有效
	"special_bonus_enigma_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0"
				"ad_linked_ability"			"midnight_pulse"
			}
		}
	}

	//+2能量转化憎恶次数
	"special_bonus_enigma_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"2"
				"ad_linked_ability"			"demonic_conversion"
			}
		}
	}




//狗Y

	"serpent_ward"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"shadow_shaman_mass_serpent_ward"
		"ScriptFile"	"heros/hero_shadow_shaman/serpent_ward.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"	"2"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityCastPoint"	"0.3"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		 "HasShardUpgrade"               "1"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"60"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"300 400 500"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"1000 1500 2000"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_shadow_shaman.vsndevts"
			"particle"	"particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf"
			"model"	"npc_dota_shadowshaman_serpentward"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"dur"		"30"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"hp"		"4 5 6"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"att"		"100 140 160"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"atti"		"1.5 1.3 1.1"
				"LinkedSpecialBonus"		"special_bonus_shadow_shaman_6"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"attrg"		"650"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"hunti"		"5"
			}
			"07"
			{
				"var_type"		"FIELD_FLOAT"
				"huntrd"		"600 650 700"
			}
			"08"
			{
				"var_type"		"FIELD_FLOAT"
				"huntdur"		"2"
			}
		}
		"HasScepterUpgrade"	"1"
	}

	"shackles"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"	"shadow_shaman_shackles"
		"ScriptFile"			"heros/hero_shadow_shaman/shackles.lua"
		"AbilityBehavior"		"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_CHANNELLED | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"		"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"		"1"
		"AbilityCastPoint"		"0.1"
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
		"AbilityCooldown"		"30"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"200"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"600"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityChannelTime"			"5.25 5.5 5.5 6.0"
		"AbilityChannelAnimation"		"ACT_DOTA_CHANNEL_ABILITY_3"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_shadow_shaman.vsndevts"
			"particle"	"particles/units/heroes/hero_shadowshaman/shadowshaman_shackle.vpcf"
			"particle"	"particles/basic_ambient/generic_range_display.vpcf"

		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"hchannel_t"	"5.25 5.5 5.5 6.0"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"rd"	"600"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"d"	"1000 1200 1400 1600"
			}
		}
	}

	"voodoo"
	{
		// General
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"shadow_shaman_voodoo"
		"ScriptFile"	"heros/hero_shadow_shaman/voodoo.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"AbilityCastPoint"	"0 0 0 0"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_2"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"12"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"70 110 150 190"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"500 550 600 650"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_shadow_shaman.vsndevts"
			"particle"	"particles/econ/items/shadow_shaman/shadow_shaman_sheepstick/shadowshaman_voodoo_sheepstick.vpcf"
			"model"	"models/items/courier/mighty_chicken/mighty_chicken.vmdl"
			"model"	"models/courier/mighty_boar/mighty_boar.vmdl"
			"model"	"models/props_gameplay/chicken.vmdl"
			"model"	"models/courier/frog/frog.vmdl"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"stun"	"1.5 2 2.5 3"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"dur"	"2"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES_STRONG"
		"AbilitySound"	"Hero_ShadowShaman.Hex.Target"
	}

	"shock"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"		"ability_lua"
		"AbilityTextureName"	"shadow_shaman_ether_shock"
		"ScriptFile"		"heros/hero_shadow_shaman/shock.lua"
		"AbilityBehavior"		"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_BUILDING"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"		"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"		"1"
		"AbilityCastPoint"		"0.2"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"14 12 10 8"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"80 100 120 140"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"600 700 800 900"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_shadow_shaman.vsndevts"
			"particle"	"particles/heros/shadow_shaman/shock_pa.vpcf"
			"particle"	"particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"dam"	"150 200 250 300"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"r"	"600 700 800 900"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"atti"	"1"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"attid"		"500 600 700 800"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"attd"		"5"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"maxnum"	"2 2 3 3"
			}
		}
	}

	//+1电击单位
	"special_bonus_shadow_shaman_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"shock"
			}
		}
	}
	//+1电击持续时间
	"special_bonus_shadow_shaman_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"shock"
			}
		}
	}

	//+0.5妖术持续时间
	"special_bonus_shadow_shaman_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0.5"
				"ad_linked_ability"			"voodoo"
			}
		}
	}

	//+1秒诱导之绳持续时间
	"special_bonus_shadow_shaman_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"shackles"
			}
		}
	}
	//释放枷锁期间隐身
	"special_bonus_shadow_shaman_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//-0.3守卫攻击间隔
	"special_bonus_shadow_shaman_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
				"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"-0.3"
				"ad_linked_ability"			"serpent_ward"
			}
		}
	}
	//=================================================================================================================
	// 幻影刺客
	//=================================================================================================================
	"stifling_dagger"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"phantom_assassin_stifling_dagger"
		"ScriptFile"					"heros/hero_phantom_assassin/stifling_dagger.lua"												// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_PhantomAssassin.Dagger.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000"
		"AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"6"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"30"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts"
			"particle"	"particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_stifling_dagger.vpcf"
			"particle"	"particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_dagger_debuff.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"move_slow"					"-40 -50 -60 -70"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"dagger_speed"			"2000"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"1.5 2 2.5 3"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"					"250 300 350 400"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"phantom_strike"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"phantom_assassin_phantom_strike"
		"ScriptFile"					"heros/hero_phantom_assassin/phantom_strike.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES |　DOTA_ABILITY_BEHAVIOR_RUNE_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK "
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP | DOTA_UNIT_TARGET_TREE | DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_ALL"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES | DOTA_UNIT_TARGET_FLAG_INVULNERABLE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_PhantomAssassin.Strike.Start"
		"HasScepterUpgrade"				"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"6"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"60 40 20 0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts"
			"particle"	"particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_start.vpcf"
			"particle"	"particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_end.vpcf"
			"particle"	"particles/econ/events/new_bloom/new_bloom_tree_cast_leaves.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"bonus_attack_speed"		"100 125 150 175"
				"LinkedSpecialBonus"		"special_bonus_phantom_assassin_3"
			}

			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"2"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"cast"					"0"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"rdtree"					"100"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"castrg"					"1000"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"castrgtree"				"300 400 500 600"
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"agi"				"0.4 0.5 0.6 0.7"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"blur"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"phantom_assassin_blur"
		"ScriptFile"					"heros/hero_phantom_assassin/blur.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"


		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"45"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts"
			"particle"	"particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_blur.vpcf"
			"particle"	"particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_start.vpcf"
			"particle"	"particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf"
			"particle"	"particles/tgp/pa/base_overhead_kill.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_evasion"				"20 30 40 50"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"15"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"1500"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"vdur"						"4"
			}
		}
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_3"
	}


	"coup_de_grace"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"phantom_assassin_coup_de_grace"
		"ScriptFile"					"heros/hero_phantom_assassin/coup_de_grace.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilitySound"					"Hero_PhantomAssassin.CoupDeGrace"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts"
			"particle"	"particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop.vpcf"
			"particle"	"particles/econ/events/killbanners/screen_killbanner_compendium14_firstblood.vpcf"
			"particle"	"particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"crit_chance"				"15 16 17"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"crit_bonus"				"400 450 500"
				"LinkedSpecialBonus"		"special_bonus_phantom_assassin_8"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"crit_kill"					"1"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"						"500"
			}
		}
		}

	//匕首造成0.3秒眩晕
	"special_bonus_phantom_assassin_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0.3"
				"ad_linked_ability"			"stifling_dagger"
			}
		}
	}
	//额外对主目标投射一枚匕首
	"special_bonus_phantom_assassin_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"stifling_dagger"
			}
		}
	}

	//+60幻影突袭攻速
	"special_bonus_phantom_assassin_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"60"
				"ad_linked_ability"			"phantom_strike"
			}
		}
	}

	//-1秒幻影突袭CD
	"special_bonus_phantom_assassin_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"phantom_strike"
			}
		}
	}
	//1技能前摇降低至0.1
	"special_bonus_phantom_assassin_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0.1"
				"ad_linked_ability"			"stifling_dagger"
			}
		}

	}

	//释放魅影突袭获得0.4秒无敌
	"special_bonus_phantom_assassin_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0.4"
				"ad_linked_ability"			"blur"
			}
		}
	}

	//+200隐秘刷新技能范围
	"special_bonus_phantom_assassin_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
				"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"200"
				"ad_linked_ability"			"coup_de_grace"
			}
		}
	}

	//+50大招暴击倍数
	"special_bonus_phantom_assassin_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"50"
				"ad_linked_ability"			"coup_de_grace"
			}
		}
	}

	//=================================================================================================================
	//兽王
	//=================================================================================================================
	"wild_axes"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"beastmaster_wild_axes"
		"ScriptFile"					"heros/hero_beastmaster/wild_axes.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Beastmaster.Wild_Axes"
		"HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1500"
		"AbilityCastPoint"				"0.4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"8"


		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"80"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"175"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"spread"					"450"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"range"						"1500"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"axe_damage"				"30 60 90 120"
				"LinkedSpecialBonus"		"special_bonus_unique_beastmaster"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"						"12"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"damage_amp"				"6 8 10 12"
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"scepter_cooldown"		"0"
				"RequiresScepter"		"1"
			}
			"08"
			{
				"var_type"					"FIELD_FLOAT"
				"min_throw_duration"						"0.4"
			}
			"09"
			{
				"var_type"					"FIELD_FLOAT"
				"max_throw_duration"						"1.0"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	//=================================================================================================================
	// Beastmaster: Call of the Wild
	//=================================================================================================================
	"beastmaster_call_of_the_wild"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"ID"					"5169"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilitySound"					"Hero_Beastmaster.Call.Boar"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"45"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50 60 70 80"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"duration"				"60"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"boar_hp_tooltip"			"300 450 600 750"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"boar_damage_tooltip"		"14 26 38 50"
				"LinkedSpecialBonus"		"special_bonus_unique_beastmaster_2"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"boar_moveslow_tooltip"				"10 20 30 40"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"boar_poison_duration_tooltip"	"3.0"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	//=================================================================================================================
	// Beastmaster: Call of the Wild Boar
	//=================================================================================================================
	"beastmaster_call_of_the_wild_boar"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"ID"					"7230"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilitySound"					"Hero_Beastmaster.Call.Boar"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"42 38 34 30"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"60 65 70 75"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"duration"				"60 60 60 60"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"boar_hp_tooltip"			"300 450 600 750"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"boar_damage_tooltip"				"16 32 48 64"
				"LinkedSpecialBonus"	"special_bonus_unique_beastmaster_2"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"boar_moveslow_tooltip"				"10 20 30 40"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"boar_poison_duration_tooltip"	"3.0"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	//=================================================================================================================
	// Beastmaster: Call of the Wild Hawk
	//=================================================================================================================
	"beastmaster_call_of_the_wild_hawk"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"ID"					"7231"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilitySound"					"Hero_Beastmaster.Call.Hawk"


		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"0"
		"AbilityCastPoint"				"0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"60 50 40 30"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"30"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"duration"				"60"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"hawk_hp_tooltip"			"150 200 250 300"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"hawk_speed_tooltip"		"300 340 380 420"
				"LinkedSpecialBonus"		"special_bonus_unique_beastmaster_2"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"hawk_vision_tooltip"		"600 700 800 900"
				"LinkedSpecialBonus"	"special_bonus_unique_beastmaster_5"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	//=================================================================================================================
	// Beastmaster: Greater Hawk: Invisibility
	//=================================================================================================================
	"beastmaster_hawk_invisibility"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"ID"					"5170"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"fade_time"				"1.0"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"idle_invis_delay"		"3"		// This plus the fade time equal the total time before the hawk goes invis.
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"fade_tooltip"		"0 0 4 4"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	//=================================================================================================================
	// Beastmaster: Boar: Poison
	//=================================================================================================================
	"beastmaster_boar_poison"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"ID"					"5171"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"attack_speed"			"-10 -20 -30 -40"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"movement_speed"		"-10 -20 -30 -40"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"3.0"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	//=================================================================================================================
	// Beastmaster: Boar: Poison LEGACY
	//=================================================================================================================
	"beastmaster_greater_boar_poison"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"ID"					"5352"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"attack_speed"			"-35"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"movement_speed"		"-35"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"3.0"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	//=================================================================================================================
	// Beastmaster: Inner Beast
	//=================================================================================================================
	"beastmaster_inner_beast"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"ID"					"5172"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"


		// Casting
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"1200"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"bonus_attack_speed"	"10 20 30 40"
				"LinkedSpecialBonus"		"special_bonus_unique_beastmaster_4"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"scepter_multiplier"	"2"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"scepter_duration"		"4"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"scepter_radius"				"1200"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"scepter_cooldown"				"35"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"scepter_manacost"				"50"
			}
		}
	}

	//=================================================================================================================
	// Beastmaster: Primal Roar
	//=================================================================================================================
	"beastmaster_primal_roar"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"ID"					"5177"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Beastmaster.Primal_Roar"


		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.5 0.5 0.5"
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"90.0 80.0 70.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"150 175 200"

		// Cast Range
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.6"	// Applies multiple modifiers


		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"3.0 3.5 4.0"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"damage"					"150 225 300"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"side_damage"				"150 225 300"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"damage_radius"				"300"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"slow_movement_speed_pct"	"-60"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"slow_attack_speed_pct"		"-60"
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"push_distance"				"450"
			}
			"08"
			{
				"var_type"					"FIELD_FLOAT"
				"push_duration"				"1.0"
			}
			"09"
			{
				"var_type"					"FIELD_FLOAT"
				"slow_duration"				"3 3.5 4"
			}
			"10"
			{
				"var_type"					"FIELD_INTEGER"
				"movement_speed"			"40"
			}
			"11"
			{
				"var_type"					"FIELD_FLOAT"
				"movement_speed_duration"			"3.0"
			}
		}
	}







	//=================================================================================================================
	// 人马
	//=================================================================================================================
	"hoof_stomp"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"centaur_hoof_stomp"
		"ScriptFile"				"heros/hero_centaur/hoof_stomp.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Centaur.HoofStomp"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.3"
		"AbilityCooldown"				"10"
		"AbilityManaCost"				"100"
		"AbilityCastRange"				"325 350 375 400"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts"
			"particle"	"particles/heros/centaur/centaur_hoof_stomp_circle.vpcf"
			"particle"	"particles/econ/items/centaur/centaur_ti6_gold/centaur_ti6_warstomp_gold.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"radius"						"325 350 375 400"
			}
			"02"
			{
				"var_type"						"FIELD_FLOAT"
				"stun_duration"					"2"
				"LinkedSpecialBonus"		"special_bonus_centaur_3"
			}
			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"stomp_damage"					"100 200 300 400"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"dur"							"4"
			}
			"05"
			{
				"var_type"						"FIELD_FLOAT"
				"stun2"							"0.2"
			}
			"06"
			{
				"var_type"						"FIELD_INTEGER"
				"damageoutgoing"					"10 15 20 25"
				"LinkedSpecialBonus"		"special_bonus_centaur_1"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"double_edge"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"centaur_double_edge"
		"ScriptFile"				"heros/hero_centaur/double_edge.lua"														// unique ID number for this item.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Centaur.DoubleEdge"
		 "HasShardUpgrade"               "1"
		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"4"
		"AbilityCastRange"				"900"
		"AbilityCastPoint"				"0.1"

		//------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
				"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts"
			"particle"	"particles/heros/centaur/centaur_axe.vpcf"
			"particle"	"particles/units/heroes/hero_centaur/centaur_double_edge.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"edge_damage"					"100 200 300 400"
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"strength_damage"					"80 90 100 110"
				"LinkedSpecialBonus"				"special_bonus_centaur_8"
			}
			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"radius"						"200"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"rg"						"900"
				"LinkedSpecialBonus"		"special_bonus_centaur_2"
			}
			"05"
			{
				"var_type"						"FIELD_INTEGER"
				"rd"						"200"
			}
			"06"
			{
				"var_type"						"FIELD_INTEGER"
				"sp"						"1500"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	"c_return"
	{
		"BaseClass"					"ability_lua"
		"AbilityTextureName"			"centaur_return"
		"ScriptFile"				"heros/hero_centaur/c_return.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_3"
		"AbilityCastGestureSlot"		"DEFAULT"
		"AbilityCooldown"				"13"
				"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts"
			"particle"	"particles/heros/centaur/shield.vpcf"
			"particle"	"particles/units/heroes/hero_centaur/centaur_stampede.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"return_ar"					"300 400 500 600"
				"LinkedSpecialBonus"		"special_bonus_centaur_4"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"return_str"				"50 70 90 110"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"spdes"						"15 20 25 30"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"						"3"
			}
		}
	}


	"stampede"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"centaur_stampede"
		"ScriptFile"					"heros/hero_centaur/stampede.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES_ENEMIES_NO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Centaur.Stampede"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		"HasScepterUpgrade"			"1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"100"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"150 200 250"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.2"	// hits everything on the map
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts"
			"particle"	"particles/units/heroes/hero_centaur/centaur_stampede_overhead.vpcf"
			"particle"	"particles/units/heroes/hero_centaur/centaur_stampede.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_FLOAT"
				"duration"			"4.0 5 6"
				"LinkedSpecialBonus"		"special_bonus_centaur_6"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"sp"				"600 700 800"
			}
			"03"
			{
				"var_type"			"FIELD_FLOAT"
				"damageoutgoing"			"-30 -50 -70"
			}
			"04"
			{
				"var_type"			"FIELD_FLOAT"
				"rs"				"30 60 90"
			}
			"05"
			{
				"var_type"			"FIELD_INTEGER"
				"radius2"			"200"
			"LinkedSpecialBonus"		"special_bonus_centaur_7"
			}
			"06"
			{
				"var_type"			"FIELD_INTEGER"
				"slow_movement_speed"	"-50"
			}
			"07"
			{
				"var_type"			"FIELD_FLOAT"
				"dur2"				"1 1.5 2"
			}
		}
	}
	//+10%领地伤害减免
	"special_bonus_centaur_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"10"
				"ad_linked_ability"			"hoof_stomp"
			}
		}
	}
	//+1000双刃剑飞行距离
	"special_bonus_centaur_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1000"
				"ad_linked_ability"			"double_edge"
			}
		}
	}

	//+0.5马蹄践踏眩晕
	"special_bonus_centaur_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"0.5"
				"ad_linked_ability"			"hoof_stomp"
			}
		}
	}
	//+100被动防御基础值
	"special_bonus_centaur_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
				"ad_linked_ability"			"c_return"
			}
		}
	}

	//+1秒大招减速
	"special_bonus_centaur_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
				"ad_linked_ability"			"stampede"
			}
		}
	}

	//+1秒大招持续时间
	"special_bonus_centaur_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
				"ad_linked_ability"			"stampede"
			}
		}
	}

	//+100大招碰撞范围
	"special_bonus_centaur_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
				"ad_linked_ability"			"stampede"
			}
		}
	}
	//+100%双刃剑力量值
	"special_bonus_centaur_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
				"ad_linked_ability"			"double_edge"
			}
		}
	}
		//=================================================================================================================
	// 小娜迦
	//=================================================================================================================
	"mirror_image"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"naga_siren_mirror_image"
		"ScriptFile"					"heros/hero_naga_siren/mirror_image.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilitySound"					"Hero_NagaSiren.MirrorImage"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"Maxlevel"						"3"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"18"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"70 85 100"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts"
			"particle"	"particles/heros/naga_siren/status_effect_mirror_image.vpcf"
			"particle"	"particles/units/heroes/hero_siren/siren_net_projectile.vpcf"
			"particle"	"particles/units/heroes/hero_siren/naga_siren_mirror_image.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"illusion_duration"				"20"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"outgoing_damage"				"-50"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"incoming_damage"				"50 25 0"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"images_count"				"2"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"invuln_duration"				"0.2"
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"heal"						"70 80 90"
			}
			"07"
			{
				"var_type"					"FIELD_FLOAT"
				"ch"						"25"
			}
			"08"
			{
				"var_type"					"FIELD_FLOAT"
				"dur"						"1 2 3"
			}
			"09"
			{
				"var_type"					"FIELD_INTEGER"
				"outgoing_damage_tip"			"50"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	"ensnare"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"naga_siren_ensnare"
		"ScriptFile"					"heros/hero_naga_siren/ensnare.lua"											// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		//"AbilityUnitTargetFlags"			"DOTA_UNIT_TARGET_FLAG_INVULNERABLE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_NagaSiren.Ensnare.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"14"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"70 80 90 100"

		// Cast Range
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1200"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts"
			"particle"		"particles/units/heroes/hero_siren/siren_net_projectile.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"5"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"net_speed"				"3000"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"dam"					"100 110 120 130"
			}
		}
		"AbilityCastAnimation"					"ACT_DOTA_CAST_ABILITY_2"
	}


	"rip_tide"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"naga_siren_rip_tide"
		"ScriptFile"					"heros/hero_naga_siren/rip_tide.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_NagaSiren.Riptide.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0 0 0 0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts"
			"particle"	"particles/units/heroes/hero_siren/naga_siren_riptide.vpcf"
			"particle"	"particles/units/heroes/hero_siren/naga_siren_riptide_debuff.vpcf"
			"particle"	"particles/heros/naga_siren/naga_siren_circle.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"chance"					"35"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"armor_reduction"				"-7 -9 -11 -13"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"damage"					"50 100 150 200"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"300"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"5.0"
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"rd"						"400"
			}
			"07"
			{
				"var_type"					"FIELD_FLOAT"
				"dur"						"5"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"song_of_the_siren"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"naga_siren_song_of_the_siren"
		"ScriptFile"					"heros/hero_naga_siren/song_of_the_siren.lua"												// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"
		"HasScepterUpgrade"				"1"
		"AbilitySound"					"Hero_NagaSiren.SongOfTheSiren"
		"Maxlevel"						"4"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0"
		"AbilityCastRange"				"700 800 900 1000"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"
		 "HasShardUpgrade"               "1"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"30"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"175"
			"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts"
			"particle"	"particles/units/heroes/hero_siren/naga_siren_siren_song_cast.vpcf"
			"particle"	"particles/status_fx/status_effect_siren_song.vpcf"
			"particle"	"particles/units/heroes/hero_siren/naga_siren_song_aura.vpcf"
			"particle"	"particles/units/heroes/hero_siren/naga_siren_song_debuff.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"700 800 900 1000"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"5 6 7 8"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"attsp"						"70 80 90 100"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"sp"						"15 20 25 30"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"rege_scepter"				"10"
				"RequiresScepter"			"1"
			}
		}
	}



	//=================================================================================================================
	// 冰女
	//=================================================================================================================
	"crystal_nova"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"crystal_maiden_crystal_nova"
		"ScriptFile"				"heros/hero_crystal_maiden/crystal_nova.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityType"				"DOTA_ABILITY_TYPE_BASIC"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Hero_Crystal.CrystalNova"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"800"
		"AbilityCastPoint"				"0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"11 10 9 8"


		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"130 145 160 175"
		"precache"
		{
			"particle"	"particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
			"particle"	"particles/generic_gameplay/generic_slowed_cold.vpcf"
			"particle"	"particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
			"particle"	"particles/tgp/maiden_crystal/nova_m.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"radius"			"350 400 450 500"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"sp"			"-40 -50 -60 -70"
			}
			"03"
			{
				"var_type"			"FIELD_INTEGER"
				"attsp"			"-30 -40 -50 -60"
			}
			"04"
			{
				"var_type"			"FIELD_FLOAT"
				"duration"			"3"
			}
			"05"
			{
				"var_type"			"FIELD_FLOAT"
				"vision_duration"		"6"
			}
			"06"
			{
				"var_type"			"FIELD_INTEGER"
				"nova_damage"		"150 200 250 300"
			}
			"06"
			{
				"var_type"			"FIELD_INTEGER"
				"stun"			"1"
			}
			"07"
			{
				"var_type"			"FIELD_INTEGER"
				"dur"			"6"
			}
			"08"
			{
				"var_type"			"FIELD_INTEGER"
				"mana"			"50 75 100 125"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"frostbite"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"crystal_maiden_frostbite"
		"ScriptFile"					"heros/hero_crystal_maiden/frostbite.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityType"					"DOTA_ABILITY_TYPE_BASIC"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"hero_Crystal.frostbite"
		 "HasShardUpgrade"               "1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"8"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"140 145 150 155"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.5"	// Applies multiple modifiers
		"precache"
		{
			"particle"	"particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
			"particle"	"particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
			"particle"	"particles/econ/events/snowball/snowball_projectile.vpcf"

		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"total_damage"		"150 200 250 300"
			}
			"02"
			{
				"var_type"			"FIELD_FLOAT"
				"duration"			"3"
			}
			"03"
			{
				"var_type"			"FIELD_FLOAT"
				"rd"			"350"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"brilliance_aura"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"crystal_maiden_brilliance_aura"
		"ScriptFile"				"heros/hero_crystal_maiden/brilliance_aura.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AURA  | DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"


		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_FLOAT"
				"mana_regen"		"0.5 0.7 0.9 1.1"
			}
			"02"
			{
				"var_type"			"FIELD_FLOAT"
				"self_factor"		"3"
			}
			"03"
			{
				"var_type"			"FIELD_FLOAT"
				"spell"			"5"
			}
			"04"
			{
				"var_type"			"FIELD_FLOAT"
				"spell1"			"20 30 40 50"
			}
			"05"
			{
				"var_type"			"FIELD_FLOAT"
				"dur"			"40 50 60 70"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"freezing_field"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"crystal_maiden_freezing_field"
		"ScriptFile"				"heros/hero_crystal_maiden/freezing_field.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityType"				"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AUTOCAST  | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"				"hero_Crystal.freezingField.wind"

		"HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"800"
		"AbilityCastPoint"				"0.3"
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
		"AOERadius"				"700"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"100"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"200 400 600"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.35"	// Primarily about the damage
		"precache"
		{
			"particle"	"particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_snow_arcana1.vpcf"
			"particle"	"particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf"
			"particle"	"particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_explosion_arcana1.vpcf"
			"particle"	"particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient.vpcf"
			"particle"	"particles/tgp/maiden_crystal/snowball_m.vpcf"

		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"radius"			"800"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"explosion_radius"		"300"
			}
			"03"
			{
				"var_type"			"FIELD_INTEGER"
				"movespeed_slow"		"-25 -30 -35"

			}
			"04"
			{
				"var_type"			"FIELD_INTEGER"
				"attack_slow"		"-30 -40 -50"

			}
			"05"
			{
				"var_type"			"FIELD_FLOAT"
				"slow_duration"		"2.0"
			}

			"06"
			{
				"var_type"			"FIELD_INTEGER"
				"damage"			"250 350 450"
			}
			"07"
			{
				"var_type"			"FIELD_INTEGER"
				"duration"			"7"
				"LinkedSpecialBonus"	"special_bonus_crystal_maiden_6"
			}
		}
	}


	//冰霜新星额外轰炸对所有目标生效
	"special_bonus_crystal_maiden_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0"
				"ad_linked_ability"			"crystal_nova"
			}
		}
	}
	//冰霜新星范围内额外降低目标25% 魔抗
	"special_bonus_crystal_maiden_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"25"
				"ad_linked_ability"			"crystal_nova"
			}
		}
	}

	//冰封禁制还会传递伤害
	"special_bonus_crystal_maiden_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0"
				"ad_linked_ability"			"frostbite"
			}
		}
	}

	//奥术光环自身获得3倍法强
	"special_bonus_crystal_maiden_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"3"
				"ad_linked_ability"			"brilliance_aura"
			}
		}
	}



	//奥术光环被杀死还会提高目标40%的蓝耗
	"special_bonus_crystal_maiden_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"100"
				"ad_linked_ability"			"brilliance_aura"
			}
		}
	}

	//+1秒极寒领域时间
	"special_bonus_crystal_maiden_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"freezing_field"
			}
		}
	}
	//滚雪球
	"special_bonus_crystal_maiden_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}
	//冰原舞曲
	"special_bonus_crystal_maiden_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//=================================================================================================================
	// 斧王
	//=================================================================================================================

	"berserkers_call"
	{
		"BaseClass"		"ability_lua"
		"AbilityTextureName"	"axe_berserkers_call"
		"ScriptFile"		"heros/hero_axe/berserkers_call.lua"
		"AbilityBehavior"		"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"SpellImmunityType"		"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityType"		"DOTA_ABILITY_TYPE_BASIC"
		"AbilityCastPoint"		"0.2"
		"AbilityCastAnimation"	"ACT_DOTA_OVERRIDE_ABILITY_1"
		"AbilityCooldown"		"14 13 12 11"
		"AbilityManaCost"		"150"
		"AbilityCastRange"		"360"
		"HasScepterUpgrade"		"1"
		"precache"
		{
			"particle"	"particles/heros/axe/axe_bc_m.vpcf"
			"particle"	"particles/econ/items/axe/axe_ti9_immortal/axe_ti9_call.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"stun_time"	"1.5 2 2.5 3"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"buff_defense_time"	"1.5 2 2.5 3"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"armor"	"35 45 55 65"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"magica"	"10 15 20 25"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"360"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"attsp"	"100 120 140 160"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"num"	"2"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
		"HasScepterUpgrade"	"1"
	}
	"battle_hunger"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"axe_battle_hunger"
		"ScriptFile"	"heros/hero_axe/battle_hunger.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Axe.Battle_Hunger"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
 		"AbilityCastAnimation"			"ACT_DOTA_OVERRIDE_ABILITY_2"
		"AbilityCastGestureSlot"		"DEFAULT"
		"AbilityCastPoint"				"0.2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"10"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50 60 70 80"

		// Cast Range
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"700 775 850 925"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.1"

		"precache"
		{
			"particle"	"particles/units/heroes/hero_axe/axe_battle_hunger.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"slow"						"10 12 14 16"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"dmg"						   "10 12 14 16"
			}
		}
	}

	"axe_sprint"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"axesp"
		"ScriptFile"	"heros/hero_axe/axe_sprint.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		// "SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilityCastPoint"	"0.1"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		"AbilityCooldown"		"10"
		"AbilityManaCost"		"50"
		"AbilityCastRange"		"0"
		"AbilityCastRangeBuffer"	"0"
		"precache"
		{
			"particle"	"particles/econ/items/axe/axe_ti9_immortal/axe_ti9_gold_call.vpcf"
			"particle"	"particles/heros/axe/axe_sp_m.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"speed"	"1500"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"dis"	"800"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"hp_time"	"3"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"hp"	"500 600 700 800"
			}
		}
	}

	"counter_helix"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"axe_counter_helix"
		"ScriptFile"	"heros/hero_axe/counter_helix.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_CREEP"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetFlags"	"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_PURE"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityCooldown"			"0.2"
		"AbilityCastRange"		"250"
		 "HasShardUpgrade"         "1"
		"precache"
		{
			"particle"	"particles/heros/axe/axe_ch1.vpcf"
			"particle"	"particles/units/heroes/hero_axe/axe_counterhelix.vpcf"
			"particle"	"particles/heros/axe/ch_maxe_.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"chance"	"17"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"dam"		"70 80 90 100"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"250"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"dam_max_hp"	"1.8 2.2 2.6 3"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"asch"	"10"
			}
		}
	}

	"culling_blade"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"axe_culling_blade"
		"ScriptFile"	"heros/hero_axe/culling_blade.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetFlags"	"DOTA_UNIT_TARGET_FLAG_INVULNERABLE | DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityCastPoint"	"0.1"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		"AbilityCooldown"	"100"
		"AbilityManaCost"	"100 150 200"
		"AbilityCastRange"	"250"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
			"particle"	"particles/heros/axe/axe_cb1.vpcf"
			"particle"	"particles/heros/axe/axe_cb_ms.vpcf"
			"particle"	"particles/units/heroes/hero_axe/axe_culling_blade.vpcf"
			"particle"	"particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"base_dam"	"200 300 400"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"kill_t"	"350 450 550"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"max_hp"	"10"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"sp_t"	"10"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"sp"	"30 40 50"
			}
		}
	}

	//嘲讽增加攻速不再有人数限制
	"special_bonus_axe_1"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}
	//嘲讽不再消耗魔法
	"special_bonus_axe_2"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}
	//战斗饥渴降低目标10%状态抗性
	"special_bonus_axe_3"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}
	//战斗饥渴会获得目标6秒的视野
	"special_bonus_axe_4"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}
	//战斗饥渴会驱散一次目标的增益效果
	"special_bonus_axe_5"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}
	//每隔5秒自动触发一次螺旋反击
	"special_bonus_axe_6"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}
	//斩杀
	"special_bonus_axe_7"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"

	}
	//补救
	"special_bonus_axe_8"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}









		//=================================================================================================================
	// 夜魔
	//=================================================================================================================

	"void"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"night_stalker_void"
		"ScriptFile"	"heros/hero_night_stalker/void.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"AbilityCastPoint"	"0"
		"AbilityCooldown"	"12"
		"AbilityManaCost"	"80 90 100 110"
		"AOERadius"	"300 350 400 450"
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
		// Stats
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"0"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"particle"	"particles/items_fx/abyssal_blink_start.vpcf"
			"particle"	"particles/basic_ambient/generic_range_display.vpcf"
			"particle"	"particles/tg_pfx/heros/ns/void1.vpcf"
			"particle"	"particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"dam"	"150 200 250 300"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"rd"	"300 350 400 450"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"dur"	"2"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"v"	"-60 -70 -80 -90"
			"LinkedSpecialBonus"		"special_bonus_night_stalker_1"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"sp_n"	"-30 -40 -50 -60"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"j_n"	"2200"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"j_d"	"1500"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"j_dis"	"800"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
	}

"darkness"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"night_stalker_darkness"
		"ScriptFile"	"heros/hero_night_stalker/darkness.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"					"Hero_Nightstalker.Darkness"
		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.3 0.3 0.3"
		"AbilityCooldown"				"75"
		"AbilityManaCost"				"0"
		 "HasShardUpgrade"               "1"
		"precache"
		{
			"model"	"models/heroes/nightstalker/nightstalker.vmdl"
			"model"	"models/heroes/nightstalker/nightstalker_night.vmdl"
			"model"	"models/heroes/nightstalker/nightstalker_tail_night.vmdl"
			"model"	"models/heroes/nightstalker/nightstalker_wings_night.vmdl"
			"particle"	"particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"dur"					"25"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"v_dur"					"2"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"v"					"1000 1200 1400"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"v1"					"30 50 70"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"sp"					"10"
			}
		}
	}

"hunter_in_the_night"
	{
		"BaseClass"		"ability_lua"
		"AbilityTextureName"	"night_stalker_hunter_in_the_night"
		"ScriptFile"		"heros/hero_night_stalker/hunter_in_the_night.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"		"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_CHANNELLED"
		"AbilityChannelTime"	"1.5"
		"AbilityCooldown"		"90"
		"HasScepterUpgrade"	"1"
					"precache"
		{
			"particle"	"particles/units/heroes/hero_night_stalker/nightstalker_night_buff.vpcf"
			"particle"	"particles/units/heroes/hero_night_stalker/nightstalker_bats.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"							"FIELD_INTEGER"
				"attsp"								"50 60 70 80"
				"LinkedSpecialBonus"		"special_bonus_night_stalker_3"
			}
			"02"
			{
				"var_type"							"FIELD_INTEGER"
				"sp"								"10 15 20 25"
				"LinkedSpecialBonus"		"special_bonus_night_stalker_4"
			}
				"03"
			{
				"var_type"							"FIELD_INTEGER"
				"dur"								"10"
			}
			"04"
			{
				"var_type"							"FIELD_INTEGER"
				"dam"								"4 5 6 7"
				"LinkedSpecialBonus"		"special_bonus_night_stalker_7"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_GENERIC_CHANNEL_1"
	}

"crippling_fear"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"night_stalker_crippling_fear"
		"ScriptFile"	"heros/hero_night_stalker/crippling_fear.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Nightstalker.Trickling_Fear"

		// Unit Targeting
		//-------------------------------------------------------------------------------------------------------------
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"400"
		"AbilityCastPoint"				"0.2"
		"AbilityCooldown"				"16 14 12 10"
		"AbilityManaCost"				"50"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear_aura.vpcf"
			"particle"	"particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"dur_d"			"3"
				"LinkedSpecialBonus"		"special_bonus_night_stalker_2"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"dur_n"			"3.5 4 4.5 5"
				"LinkedSpecialBonus"		"special_bonus_night_stalker_2"
			}
			"03"
			{
				"var_type"							"FIELD_INTEGER"
				"rd"	"450"
			}

				"04"
			{
				"var_type"							"FIELD_INTEGER"
				"tr"	"-60"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	//+10%虚空视野降低
	"special_bonus_night_stalker_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"10"
				"ad_linked_ability"			"void"
			}
		}
	}
	//+1秒恐惧持续时间
	"special_bonus_night_stalker_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
				"ad_linked_ability"			"crippling_fear"
			}
		}
	}

	//+40暗影猎手攻击速度
	"special_bonus_night_stalker_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"40"
				"ad_linked_ability"			"hunter_in_the_night"
			}
		}
	}

	//+20%暗影猎手移动速度
	"special_bonus_night_stalker_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"20"
				"ad_linked_ability"			"hunter_in_the_night"
			}
		}
	}

	//+10大招持续时间
	"special_bonus_night_stalker_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"10"
				"ad_linked_ability"			"darkness"
			}
		}
	}

	//+200大招高空视野
	"special_bonus_night_stalker_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"200"
				"ad_linked_ability"			"darkness"
			}
		}
	}
	//+2%暗影猎手视野伤害
	"special_bonus_night_stalker_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"2"
				"ad_linked_ability"			"hunter_in_the_night"
			}
		}
	}
	//-10大招CD
	"special_bonus_night_stalker_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"10"
				"ad_linked_ability"			"darkness"
			}
		}
	}


	//=================================================================================================================
	// 悟空
	//=================================================================================================================
	"boundless_strike"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"monkey_king_boundless_strike"
		"ScriptFile"					"heros/hero_monkey_king/boundless_strike.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_NORMAL_WHEN_STOLEN | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"FightRecapLevel"				"1"
		 "HasShardUpgrade"               "1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"			"ACT_DOTA_MK_STRIKE"
		"AbilityCastGestureSlot"		"DEFAULT"
		"AbilityCastPoint"				"0.4"
		"AbilityCastRange"				"1200"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"20"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
		"precache"
		{
			"particle"	"particles/econ/items/monkey_king/ti7_weapon/mk_ti7_golden_immortal_strike.vpcf"
			"particle"	"particles/econ/items/monkey_king/ti7_weapon/mk_ti7_immortal_strike.vpcf"
			"particle"	"particles/econ/items/monkey_king/ti7_weapon/mk_ti7_golden_immortal_strike_cast.vpcf"
			"particle"	"particles/econ/items/monkey_king/ti7_weapon/mk_ti7_immortal_strike_cast.vpcf"
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_strike_slow.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"stun_duration"				"0.7 1.0 1.3 1.6"
				"LinkedSpecialBonus"		"special_bonus_monkey_king_2"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"strike_crit_mult"			"150 200 250 300"
				"LinkedSpecialBonus"		"special_bonus_monkey_king_1"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"strike_radius"				"200"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"strike_cast_range"			"1200"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"sp"						"-30 -40 -50 -60"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"spdur"						"4"
			}
		}
	}


	"mischief"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"monkey_king_mischief"
		"ScriptFile"					"heros/hero_monkey_king/mischief.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_RUNE_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_BUILDING | DOTA_UNIT_TARGET_CREEP"
		"AbilityUnitTargetFlags"			"DOTA_UNIT_TARGET_FLAG_INVULNERABLE | DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES | DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE"
		"FightRecapLevel"				"2"
		"MaxLevel"						"1"
		"AbilitySound"					"Hero_MonkeyKing.Transform.On"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0"
		"AbilityCastAnimation"			"ACT_INVALID"
		"AbilityCastRange"				"0"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"10"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0 0 0 0"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf"
			"model"	"models/creeps/ice_biome/diregull/diregull.vmdl"
			"model"	"models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee.vmdl"
			"model"	"models/creeps/neutral_creeps/n_creep_centaur_lrg/n_creep_centaur_lrg.vmdl"
			"model"	"models/creeps/neutral_creeps/n_creep_furbolg/n_creep_furbolg_disrupter.vmdl"
			"model"	"models/creeps/n_creep_ogre_med/n_creep_ogre_med.vmdl"
			"model"	"models/creeps/neutral_creeps/n_creep_satyr_a/n_creep_satyr_a.vmdl"
			"model"	 "models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_big.vmdl"
			"model"	"models/creeps/neutral_creeps/n_creep_worg_small/n_creep_worg_small.vmdl"
			"model"	 "models/props_debris/creep_camp001a.vmdl"
			"model"	"models/props_debris/creep_camp002a.vmdl"
			"model"	"models/props_debris/creep_camp001b.vmdl"
			"model"	 "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee.vmdl"
			"model"	"models/courier/baby_rosh/babyroshan_elemental_flying.vmdl"
			"model"	"models/courier/seekling/seekling.vmdl"
			"model" "models/items/courier/azuremircourierfinal/azuremircourierfinal.vmdl"
			"model"  "models/items/wards/chen_ward/chen_ward.vmdl"
			"model"   "models/props_gameplay/default_ward.vmdl"
			"model" "models/items/venomancer/ward/chomper_ward/chomper_ward.vmdl"
			"model" "models/items/wards/knightstatue_ward/knightstatue_ward.vmdl"
			"model"  "models/heroes/kunkka/ghostship.vmdl"
			"model"  "models/props_tree/frostivus_tree.vmdl"
			"model"   "models/props_tree/dire_tree005.vmdl"
			"model"   "models/props_tree/dire_tree004b_sfm.vmdl"
			"model"   "models/props_tree/tree_dead_02.vmdl"
			"model"   "models/props_tree/tree_pine_snow_02_destruction.vmdl"
			"model"  "models/props_tree/tree_pinestatic_02.vmdl"
			"model"   "models/props_tree/mango_tree.vmdl"
			"model" "models/props_gameplay/rune_haste01.vmdl"
			"model" "models/props_gameplay/rune_regeneration01.vmdl"
			"model" "models/props_gameplay/rune_illusion01.vmdl"
			"model" "models/props_gameplay/rune_invisibility01.vmdl"
			"model" "models/props_gameplay/rune_goldxp.vmdl"
			"model" "models/props_gameplay/pumpkin_rune.vmdl"
			"model" "models/props_gameplay/rune_doubledamage01.vmdl"
			"model"  "models/props_gameplay/rune_arcane.vmdl"
			"model"  "models/props_frostivus/frostivus_ancient/sled/elon_sled.vmdl"
			"model"  "models/creeps/roshan/roshan.vmdl"
			"model" "models/props_structures/barrel_fish.vmdl"
			"model"  "models/items/hex/fish_hex_retro/fish_hex_r"
			"model"  "models/props_tree/dire_tree007_sfm.vmdl"
			"model"  "models/props_tree/dire_tree004b_sfm.vmdl"
			"model"  "models/heroes/tiny_01/tiny_01_tree.vmdl"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"movespeed"					"200"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"reveal_radius"				"200"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"invul_duration"			"0.2"
			}
		}
	}


	"untransform"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"monkey_king_untransform"
		"ScriptFile"					"heros/hero_monkey_king/untransform.lua"												// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_HIDDEN"
		"AbilitySound"					"Hero_MonkeyKing.Transform.Off"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"
		"AbilityCastAnimation"			"ACT_INVALID"

		"MaxLevel"						"1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"1"
		"AbilityDuration"				"10.0 10.0 10.0 10.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0 0 0 0"
	}


	"tree_dance"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"monkey_king_tree_dance"
		"ScriptFile"					"heros/hero_monkey_king/tree_dance.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES | DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL | DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_TREE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilitySound"					"Hero_MonkeyKing.TreeJump.Cast"

		"FightRecapLevel"				"1"


		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1100 1200 1300 1400"
		"AbilityCastRangeBuffer"			"1500"
		"AbilityCastPoint"				"0.3"
		"AbilityCastGestureSlot"		"DEFAULT"
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"2.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_jump_start_dust.vpcf"
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf"
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_jump_treelaunch_ring.vpcf"
			"particle"	"particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf"
			"particle"	"particles/basic_ambient/generic_range_display.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"sp"						"1600"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"dis"						"1100 1200 1300 1400"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"hp"						"10 20 30 40"
			}
		}
	}


	"primal_spring"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"monkey_king_primal_spring"
		"ScriptFile"					"heros/hero_monkey_king/primal_spring.lua"												// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL | DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_MonkeyKing.Spring.Channel"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.3"
		"AbilityCastRange"				"0"
		 "AOERadius"					"350 400 450 500"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"19 17 15 13"
	//	"AbilityChannelTime"			"1.7"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
		"precache"
		{
			"particle"	"particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_cast_arcana_fire.vpcf"
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_spring_channel.vpcf"
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_jump_start_dust.vpcf"
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf"
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_jump_treelaunch_ring.vpcf"
			"particle"	"particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"impact_damage"			"100 200 300 400"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"impact_radius"			"350 400 450 500"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"dis"					"1100 1200 1300 1400"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"wukongs_command"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"monkey_king_wukongs_command"
		"ScriptFile"					"heros/hero_monkey_king/wukongs_command.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_NORMAL_WHEN_STOLEN"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_MonkeyKing.FurArmy"
       		 "HasScepterUpgrade"				"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0"
		"AbilityCastRange"				"0"
		"AbilityCastAnimation"			"ACT_INVALID"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"90"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
		"precache"
		{
			"model"		  "models/items/monkey_king/the_havoc_of_dragon_palacesix_ear_armor/the_havoc_of_dragon_palacesix_ear_shoulders.vmdl"
			"model"		"models/items/monkey_king/the_havoc_of_dragon_palacesix_ear_armor/the_havoc_of_dragon_palacesix_ear_armor.vmdl"
			"model"  "models/items/monkey_king/mk_ti9_immortal_weapon/mk_ti9_immortal_weapon.vmdl"
			"model"   "models/items/monkey_king/monkey_king_arcana_head/mesh/monkey_king_arcana.vmdl"
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_jump_start_dust.vpcf"
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf"
			"particle"	"particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_cast_arcana_fire.vpcf"
			"particle"	"particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire.vpcf"
			"particle"	"particles/econ/items/monkey_king/arcana/monkey_king_arcana_crown.vpcf"
			"particle"	"particles/econ/items/monkey_king/arcana/death/mk_arcana_death_eyes.vpcf"
			"particle"	"particles/econ/items/monkey_king/arcana/monkey_king_arcana_fire.vpcf"
			"particle"	"particles/econ/items/monkey_king/arcana/monkey_arcana_cloud.vpcf"
			"particle"	"particles/prototype_fx/item_linkens_buff.vpcf"
			"particle"	"particles/econ/items/effigies/status_fx_effigies/status_effect_vr_desat_stone.vpcf"
			"particle"	"particles/tgp/mk/att_m.vpcf"

		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"							"FIELD_INTEGER"
				"dur"								"15 20 25"
				"LinkedSpecialBonus"		"special_bonus_monkey_king_5"
			}
			"02"
			{
				"var_type"							"FIELD_INTEGER"
				"eyes"								"600"
			}
			"03"
			{
				"var_type"							"FIELD_FLOAT"
				"tip1"							""
				"RequiresScepter"				"1"
			}
			"04"
			{
				"var_type"							"FIELD_FLOAT"
				"tip2"							""
				"RequiresScepter"				"1"
			}
			"05"
			{
				"var_type"							"FIELD_FLOAT"
				"tip3"							""
				"RequiresScepter"				"1"
			}
			"06"
			{
				"var_type"							"FIELD_FLOAT"
				"att"							"50 75 100"
			}
		}
	}


	"jingu_mastery"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"monkey_king_jingu_mastery"
		"ScriptFile"					"heros/hero_monkey_king/jingu_mastery.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_MonkeyKing.IronCudgel"
		"AbilityCastAnimation"			"ACT_INVALID"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_start.vpcf"
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_overhead.vpcf"
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_tap_buff.vpcf"
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf"
			"particle"	"particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_stack.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"required_hits"				"4"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"counter_duration"			"7 8 9 10"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"charges"					"4"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_damage"				"50 70 90 110"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"lifesteal"					"10 25 40 55"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"max_duration"				"40"
			}
		}
	}


	//+40%棒击大地暴击倍率
	"special_bonus_monkey_king_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"40"
				"ad_linked_ability"			"boundless_strike"
			}
		}
	}
	//+0.4棒击大地眩晕
	"special_bonus_monkey_king_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0.4"
				"ad_linked_ability"			"boundless_strike"
			}
		}
	}

	//释放丛林之舞时获得1秒隐身
	"special_bonus_monkey_king_3"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//丛林之舞树木被摧毁不会眩晕
	"special_bonus_monkey_king_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//+5秒大招持续时间
	"special_bonus_monkey_king_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"5"
				"ad_linked_ability"			"wukongs_command"
			}
		}
	}

	//+200大招真视范围
	"special_bonus_monkey_king_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"200"
				"ad_linked_ability"			"wukongs_command"
			}
		}
	}
	//死亡后元神离开身体可以去任意地点
	"special_bonus_monkey_king_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}
	//大招召唤猴阵，中心猴子每隔数秒自动攻击附近的敌人
	"special_bonus_monkey_king_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}















	//=================================================================================================================
	// 风行
	//=================================================================================================================
	"focusfire"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"ScriptFile"	"heros/hero_windrunner/focusfire.lua"												// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityType"				"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetFlags"			"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"				"Ability.Focusfire"
		"AbilityTextureName"			"windrunner_focusfire"
		"HasScepterUpgrade"			"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"1 0.6 0.2"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"dam"						"60 80 100"
				"LinkedSpecialBonus"				"special_bonus_windrunner_5"
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"attsp"						"100 150 200"
				"LinkedSpecialBonus"				"special_bonus_windrunner_6"

			}
			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"ch"						"30 35 40"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"wh"						"100"
			}
			"05"
			{
				"var_type"						"FIELD_INTEGER"
				"num"						"4"
			}
		}
	}



"shackleshot"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"ScriptFile"	"heros/hero_windrunner/shackleshot.lua"												// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_TREE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Windrunner.ShackleshotCast"
		"AbilityTextureName"			"windrunner_shackleshot"
						"precache"
	{
		"particle"			"particles/econ/items/windrunner/wr_ti8_immortal_shoulder/wr_ti8_shackleshot.vpcf"
		"particle"			"particles/econ/items/windrunner/wr_ti8_immortal_shoulder/wr_ti8_shackleshot_pair.vpcf"
		"model"			"models/props_tree/newbloom_tree.vmdl"
		"model"			"maps/jungle_assets/trees/kapok/export/kapok_003.vmdl"
		"model"			"maps/jungle_assets/trees/flytrap/jungle_flytrap01.vmdl"
		"model"			 "maps/journey_assets/props/trees/journey_armandpine/journey_armandpine_01_inspector.vmdl"
		"model"			"models/props_tree/tree_bamboo_snow_03_destruction.vmdl"
		"model"			 "models/props_tree/tree_pine_04.vmdl"
		"model"			"models/props_tree/cypress/tree_cypress010_inspector.vmdl"
	}
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000"
		"AbilityCastPoint"				"0.2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"12"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 120 140 160"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"stun"				"1 1.5 2 2.5"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"stunrd"				"350"
			}

			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"spdur"					"4"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"sp"					"-20 -25 -30 -35"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"wh"					"100"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"dis"					"1000"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"treedur"				"5"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}




//3
"windrun"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_windrunner/windrun.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Ability.Windrun"
	//	"HasScepterUpgrade"				"1"
		"AbilityTextureName"			"windrunner_windrun"
		"precache"
		{
			"particle"			"particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf"
		}
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0"
		"AbilityCharges"				"2"
		"AbilityChargeRestoreTime"			"9"
		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.1"	// Mostly about dodging all attacks

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"sp"						"40 50 60 70"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"						"3 3 4 4"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"rd"						"300 400 500 600"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}

//2
"powershot"
{
	// General
	//-------------------------------------------------------------------------------------------------------------
	"BaseClass"	"ability_lua"
	"ScriptFile"	"heros/hero_windrunner/powershot.lua"
	"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_CHANNELLED"
	"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
	"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
	"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
	"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
	"FightRecapLevel"				"1"
	"AbilityTextureName"			"windrunner_powershot"
 	"HasShardUpgrade"               "1"
	// Casting
	//-------------------------------------------------------------------------------------------------------------
	"AbilityCastRange"				"0"
	"AbilityCastPoint"				"0.5"

	// Time
	//-------------------------------------------------------------------------------------------------------------
	"AbilityCooldown"				"10"

	// Cost
	//-------------------------------------------------------------------------------------------------------------
	"AbilityManaCost"				"90"

	"precache"
	{
		"particle"			"particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_channel_ti6.vpcf"
		"particle"			"particles/units/heroes/hero_windrunner/windrunner_spell_powershot_rubick.vpcf"
		"particle"			"particles/tg_pfx/heros/wr/such1.vpcf"
		"particle"			"particles/tg_pfx/heros/wr/su1.vpcf"
		"particle"			"particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf"
		"particle"			"particles/tg_pfx/heros/wr/wi1.vpcf"
		"particle"			"particles/units/heroes/hero_windrunner/wr_taunt_kiss_heart.vpcf"
		"particle"			"particles/econ/items/windrunner/windrunner_ti6/windrunner_ti6_powershot_dmg.vpcf"
	}

	// Special
	//-------------------------------------------------------------------------------------------------------------
	"AbilitySpecial"
	{
		"01"
		{
			"var_type"				"FIELD_FLOAT"
			"dam"				 	"100 200 300 400"
		}
		"02"
		{
			"var_type"				"FIELD_FLOAT"
			"sleep"					"1 1.25 1.5 1.75"
		}
		"03"
		{
			"var_type"				"FIELD_INTEGER"
			"rg"					"3000"
		}
		"04"
		{
			"var_type"				"FIELD_INTEGER"
			"sp1"					"3000"
		}
		"05"
		{
			"var_type"				"FIELD_FLOAT"
			"vrd"					"300"
		}
		"06"
		{
			"var_type"				"FIELD_FLOAT"
			"wh"					"150"
		}
	}
}



	//强力击射出2发箭矢
	"special_bonus_windrunner_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//强力击对友军造成同等治疗
	"special_bonus_windrunner_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//风行期间隐身
	"special_bonus_windrunner_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//+2风行持续时间
	"special_bonus_windrunner_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"2"
				"ad_linked_ability"			"windrun"
			}
		}
	}

	//+50集中火力伤害
	"special_bonus_windrunner_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"50"
				"ad_linked_ability"			"focusfire"
			}
		}
	}

	//+50集中火力攻速
	"special_bonus_windrunner_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"50"
				"ad_linked_ability"			"focusfire"
			}
		}
	}


	//大招可开启自动施法改变箭雨的朝向为前方
	"special_bonus_windrunner_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//风步时间内有10%概率躲避所有伤害
	"special_bonus_windrunner_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}






	//黑暗贤者
	"seer_vacuum"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_dark_seer/seer_vacuum.lua"
		"AbilityTextureName"			"dark_seer_vacuum"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PURE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Dark_Seer.Vacuum"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"450 500 550 600"
		"AbilityCastPoint"				"0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"24 22 20 18"
		"AOERadius"					"600"
		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 120 135 145"
		"precache"
		{
		"particle"			"particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"600"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"0.5"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"200 250 300 350"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"radius_tree"				"275"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"stun"					"1 1.25 1.5 1.75"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"radius2"					"400"
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"spdur"					"2"
			}
			"08"
			{
				"var_type"				"FIELD_FLOAT"
				"sp"					"30"
			}
			"09"
			{
				"var_type"				"FIELD_FLOAT"
				"wall"					"7"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"ion_shell"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_dark_seer/ion_shell.lua"
		"AbilityTextureName"			"dark_seer_ion_shell"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Dark_Seer.Ion_Shield_Start"
       		 "HasScepterUpgrade"             "1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0.1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"9"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 110 120 130"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.0"	// just does damage
		"precache"
		{
		"particle"			"particles/econ/items/dark_seer/dark_seer_ti8_immortal_arms/dark_seer_ti8_immortal_ion_shell.vpcf"
		"particle"			"particles/econ/items/dark_seer/dark_seer_ti8_immortal_arms/dark_seer_ti8_immortal_ion_shell_dmg.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"275"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"damage_per_second"		"120 130 140 150"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"14"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"tick_interval"				"1"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"max_charges"			"2"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"surge"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_dark_seer/surge.lua"
		"AbilityTextureName"			"dark_seer_surge"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_Dark_Seer.Surge"
		"HasScepterUpgrade"				"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"11"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"2.5"	// Value much higher than manacost
		"precache"
		{
		"particle"			"particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"3 4 5 6"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"speed_boost"			"400"
				"LinkedSpecialBonus"		"special_bonus_dark_seer_3"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}




	"seriously_punch"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_dark_seer/seriously_punch.lua"
		"AbilityTextureName"			"seriously_punch"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"AbilitySound"					"Hero_Dark_Seer.Surge"
		"FightRecapLevel"				"1"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PURE"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"300"
		"AbilityCastPoint"				"0.2"
			"HasScepterUpgrade"			"1"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"15"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"2.5"	// Value much higher than manacost
		"precache"
		{
			"particle"			"particles/units/heroes/hero_dark_seer/dark_seer_attack_normal_punch.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"dis"				"600"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"400 500 600"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"wh"				"300"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}



	//真空拉扯到的英雄大于5则会立即刷新CD
	"special_bonus_dark_seer_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//友方英雄穿过光墙还会获得2秒奔腾效果
	"special_bonus_dark_seer_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//双倍奔腾速度
	"special_bonus_dark_seer_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"500"
				"ad_linked_ability"			"surge"
			}
		}
	}


	//对自身释放离子外壳时获得15%的伤害减免
	"special_bonus_dark_seer_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//认真一拳无视林肯莲花
	"special_bonus_dark_seer_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
				"ad_linked_ability"			"seriously_punch"
			}
		}
	}

	//范围内每多一名敌人都会使认真系列伤害提高50
	"special_bonus_dark_seer_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//穿越者
	"special_bonus_dark_seer_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
				"ad_linked_ability"			"seriously_punch"
			}
		}
	}

	//+150%智力百分比伤害
	"special_bonus_dark_seer_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"150"
				"ad_linked_ability"			"seriously_punch"
			}
		}
	}







	//=================================================================================================================
	// 小黑
	//=================================================================================================================

	"frost_arrows"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_drow_ranger/frost_arrows.lua"
		"AbilityTextureName"			"drow_ranger_frost_arrows"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_DrowRanger.FrostArrows"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"precache"
		{
			"particle"			"particles/units/heroes/hero_drow/drow_frost_arrow.vpcf"
		}
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0.0 0.0 0.0 0.0"

		// Damage.
		//-------------------------------------------------------------------------------------------------------------

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"frost_arrows_movement_speed"			"-15 -20 -25 -30"
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"damage"						"80 90 100 110"
				"LinkedSpecialBonus"		"special_bonus_drow_ranger_7"
			}
			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"ch"						"15"
			}
			"04"
			{
				"var_type"						"FIELD_FLOAT"
				"stun"						"1"
			}
			"05"
			{
				"var_type"						"FIELD_FLOAT"
				"sp"						"2"
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"rd1"						"600"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"multishot"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_drow_ranger/multishot.lua"
		"AbilityTextureName"			"drow_ranger_multishot"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT  | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"				"1"
		"AbilityCastPoint"				"0.45"
		"HasScepterUpgrade"			"1"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0.0"
		"AbilityCharges"				"1 1 2 2"
		"AbilityChargeRestoreTime"			"8"
		"AbilityCastRange"				"2500"
		"AbilityManaCost"				"50"
		"precache"
		{
			"particle"			"particles/tgp/drow/drow_precision_modify.vpcf"
			"particle"			"particles/tgp/drow/drow_m0.vpcf"
			"particle"			"particles/units/heroes/hero_drow/drow_silence.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"num"					"3 4 5 6"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"					"300"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"sp"					"1800"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"sp1"					"40"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"dmg"					"30 40 50 60"
				"LinkedSpecialBonus"			"special_bonus_drow_ranger_5"
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"root"					"0.5 0.7 0.9 1.1"
			}
		}
	}


	"wave_of_silence"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_drow_ranger/wave_of_silence.lua"
		"AbilityTextureName"			"drow_ranger_wave_of_silence"												// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AUTOCAST | DOTA_ABILITY_BEHAVIOR_POINT"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Hero_DrowRanger.Silence"
		"HasShardUpgrade"               			"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"900"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"14"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"90"
		"precache"
		{
			"particle"			"particles/econ/items/drow/drow_ti6_gold/drow_ti6_silence_gold_wave.vpcf"
			"particle"			"particles/tgp/wind_m.vpcf"

		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_FLOAT"
				"wave_speed"		"2000.0"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"wave_width"		"300"
			}
			"03"
			{
				"var_type"			"FIELD_FLOAT"
				"silence_duration"	"3 4 5 6"
			}
			"04"
			{
				"var_type"			"FIELD_FLOAT"
				"knockback_distance_max"	"450"
			}
			"05"
			{
				"var_type"			"FIELD_FLOAT"
				"knockback_duration"		"0.6 0.7 0.8 0.9"
			}
			"06"
			{
				"var_type"			"FIELD_INTEGER"
				"knockback_height"		"0"
			}
			"07"
			{
				"var_type"			"FIELD_INTEGER"
				"wave_length"		"900"
			}
			"08"
			{
				"var_type"			"FIELD_INTEGER"
				"rd"			"200 240 280 320"
			}
			"09"
			{
				"var_type"			"FIELD_INTEGER"
				"dur"			"2"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}



	"marksmanship"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_drow_ranger/marksmanship.lua"
		"AbilityTextureName"			"drow_ranger_marksmanship"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"AbilityCastPoint"				"0.0"
		"AbilityCooldown"				"12"
		"precache"
		{
			"particle"			"particles/units/heroes/hero_drow/drow_shard_hypo_blast.vpcf"
			"particle"			"particles/tgp/drow/drow_m0.vpcf"
			"particle"			"particles/tgp/drow/drow_circle_m.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"agility_multiplier"				"60 90 110"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"attrg"					"50 100 150"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"sp"					"60 100 140"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"					"6"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"					"1000 1100 1200"
			}
		}
	}



//霜冻之箭的伤害无视魔免
	"special_bonus_drow_ranger_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
	}


//霜冻之箭的伤害变为纯粹
	"special_bonus_drow_ranger_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
	}


//数箭齐发施法范围提高至全图
	"special_bonus_drow_ranger_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
	}


//狂风额外攻击触发攻击特效
	"special_bonus_drow_ranger_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
	}


//+20数箭齐发伤害
	"special_bonus_drow_ranger_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"20"
				"ad_linked_ability"			"multishot"
			}
		}
	}


//-3秒狂风CD
	"special_bonus_drow_ranger_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"3"
				"ad_linked_ability"			"wave_of_silence"
			}
		}
	}


//+50霜冻之箭伤害
	"special_bonus_drow_ranger_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"50"
				"ad_linked_ability"			"frost_arrows"
			}
		}
	}


//狂风刷新数箭齐发CD
	"special_bonus_drow_ranger_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"

	}


	//尸王
	"decay"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_undying/decay.lua"
		"AbilityTextureName"			"undying_decay"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"					"Hero_Undying.Decay.Cast"
		"FightRecapLevel"				"1"
		"HasShardUpgrade"				"1"
		"HasScepterUpgrade"				"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"			"ACT_DOTA_UNDYING_DECAY"
		"AbilityCastGestureSlot"		"DEFAULT"
		"AbilityCastRange"				"650"
		"AbilityCastPoint"				"0.2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"10.0 8.0 6.0 4.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
		"precache"
		{
		"particle"			"particles/units/heroes/hero_undying/undying_decay.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"decay_damage"					"150 200 250 300"
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"str_steal"						"5"
			}
			"03"
			{
				"var_type"						"FIELD_FLOAT"
				"decay_duration"					"15"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"radius"						"400"
			}
			"05"
			{
				"var_type"						"FIELD_INTEGER"
				"hp"							"100 150 200 250"
			}
			"06"
			{
				"var_type"						"FIELD_INTEGER"
				"str_steal_scepter"				"10"
				"RequiresScepter"				"1"
			}
		}
	}
	"soul_rip"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_undying/soul_rip.lua"
		"AbilityTextureName"			"undying_soul_rip"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH | DOTA_UNIT_TARGET_TEAM_CUSTOM"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_CREEP"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Undying.SoulRip.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"			"ACT_DOTA_UNDYING_SOUL_RIP"
		"AbilityCastGestureSlot"		"DEFAULT"
		"AbilityCastPoint"				"0.2"
		"AbilityCastRange"				"750"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"4"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"120 130 140 150"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.0"	// Modifier just does damage/healing
		"precache"
		{
		"particle"			"particles/units/heroes/hero_undying/undying_soul_rip_heal.vpcf"
		"particle"			"particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf"
		"particle"			"particles/units/heroes/hero_undying/undying_fg_aura.vpcf"
		"model"			"models/items/undying/flesh_golem/corrupted_scourge_corpse_hive/corrupted_scourge_corpse_hive.vmdl"
		"model"			"models/items/undying/flesh_golem/frostivus_2018_undying_accursed_draugr_golem/frostivus_2018_undying_accursed_draugr_golem.vmdl"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"damage_per_unit"			"19 26 33 40"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"max_units"					"10 12 14 16"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"2000"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"tombstone_heal"			"40 50 60 70"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"						"10"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"zombie_num"			"2 3 4 4"
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"zombie_att"			"30 40 50 60"
			}
			"08"
			{
				"var_type"				"FIELD_FLOAT"
				"zombie_attsp"			"1.0"
			}
			"09"
			{
				"var_type"				"FIELD_FLOAT"
				"zombie_hp"				"400 600 800 1000"
			}
						"10"
			{
				"var_type"				"FIELD_FLOAT"
				"zombie_dur"				"10"
			}
		}
	}



"tombstone"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_undying/tombstone.lua"
		"AbilityTextureName"			"undying_tombstone"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"FightRecapLevel"				"1"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilitySound"					"Hero_Undying.Tombstone"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"			"ACT_DOTA_UNDYING_TOMBSTONE"
		"AbilityCastGestureSlot"		"DEFAULT"
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0.45 0.45 0.45 0.45"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"40"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"120 130 140 150"
		"precache"
		{
		"model"			"models/heroes/undying/undying_tower.vmdl"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"tombstone_health"				"8 10 12 14"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"hits_to_destroy_tooltip"				"4 5 6 7"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"30.0"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"1500"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"zombie_num"			"2"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"zombie_att"			"50 100 150 200"
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"zombie_attsp"			"0.9"
			}
			"08"
			{
				"var_type"				"FIELD_FLOAT"
				"zombie_hp"			"700 900 1100 1300"
			}
			"09"
			{
				"var_type"				"FIELD_FLOAT"
				"zombie_dur"				"15"
			}
			"10"
			{
				"var_type"				"FIELD_FLOAT"
				"sp"				"30"
			}
			"11"
			{
				"var_type"				"FIELD_FLOAT"
				"spdur"				"2 3 4 5"
			}
				"12"
			{
				"var_type"				"FIELD_FLOAT"
				"eat"				"20"
			}
		}
	}




"flesh_golem"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_undying/flesh_golem.lua"
		"AbilityTextureName"			"undying_flesh_golem"							// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Undying.FleshGolem"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"110"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 125 150"
		"precache"
		{
		"particle"			"particles/units/heroes/hero_undying/undying_fg_aura.vpcf"
		"model"			"models/items/undying/flesh_golem/corrupted_scourge_corpse_hive/corrupted_scourge_corpse_hive.vmdl"
		"model"			"models/items/undying/flesh_golem/incurable_pestilence_golem/incurable_pestilence_golem.vmdl"
		"model"			"models/heroes/undying/undying_minion.vmdl"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"hp"						"600 1200 1800"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"ar"						"7 13 18"
				"LinkedSpecialBonus"				"special_bonus_undying_7"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"sp"						"50"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"buff"						"15"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"						"50"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"dur2"						"10 12 14"
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"						"2000"
			}
			"08"
			{
				"var_type"					"FIELD_INTEGER"
				"godmg"						"15"
			}
		}
	}


	"plague_world"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_undying/plague_world.lua"
		"AbilityTextureName"			"plague_world"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_AURA | DOTA_ABILITY_BEHAVIOR_HIDDEN"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"MaxLevel"					"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"300"
			}
		}
	}



	"zombie_virus"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"			"heros/hero_undying/zombie_virus.lua"
		"AbilityTextureName"			"zombie_virus"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_HIDDEN"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"MaxLevel"					"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000"
		"AbilityCooldown"				"4"
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
		}
	}
	//+腐朽不在耗蓝
	"special_bonus_undying_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
	}

	//+噬魂不在耗蓝
	"special_bonus_undying_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
	}

	//+吃墓碑+30%状态抗性
	"special_bonus_undying_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
	}

	//+吃墓碑恢复1000生命
	"special_bonus_undying_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
	}
	//-2噬魂CD
	"special_bonus_undying_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"2"
				"ad_linked_ability"			"soul_rip"
			}
		}
	}
	//+30%吃墓碑获得的魔法抗性
	"special_bonus_undying_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"30"
				"ad_linked_ability"			"tombstone"
			}
		}
	}

	//+10大招护甲
	"special_bonus_undying_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"10"
				"ad_linked_ability"			"flesh_golem"
			}
		}
	}


//新全能

"purification_new"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_omniknight/purification_new.lua"
		"AbilityTextureName"			"omniknight_purification"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PURE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Omniknight.Purification"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"14"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 120 140 160"
		"precache"
		{
		"particle"			"particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
		"particle"			"particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"heal"					"125 175 225 275"
				"LinkedSpecialBonus"		"special_bonus_omniknight_1"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"350 400 450 500"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"				"3"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"dur2"				"5"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"miss"				"30 40 50 60"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"hp"				"30"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"guardian_angel_new"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_omniknight/guardian_angel_new.lua"
		"AbilityTextureName"			"omniknight_guardian_angel"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Omniknight.GuardianAngel.Cast"
		"AbilityDraftUltShardAbility"		"omniknight_hammer_of_purity"
			"HasScepterUpgrade"			"1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"110"
		"AbilityCastPoint"				"0.3"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"125 175 250"
		"precache"
		{

		"particle"			"particles/status_fx/status_effect_guardian_angel.vpcf"
		"particle"			"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings_buff.vpcf"
		"particle"			"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf"
		"particle"			"particles/basic_ambient/generic_range_display.vpcf"
		"model"			"models/items/courier/vaal_the_animated_constructradiant/vaal_the_animated_constructradiant_flying.vmdl"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"10"
					"LinkedSpecialBonus"		"special_bonus_omniknight_6"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"1400"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"hp"						"200 300 400"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"mana"						"50 75 100"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"ar"						"7 12 17"
			}
		}
	}


//旧全能
"purification"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_omniknight/purification.lua"
		"AbilityTextureName"			"omniknight_purification"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PURE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Omniknight.Purification"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"14"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 120 140 160"
		"precache"
		{
		"particle"			"particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
		"particle"			"particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"heal"					"125 175 225 275"
				"LinkedSpecialBonus"		"special_bonus_omniknight_1"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"350 400 450 500"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"				"1"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"dur2"				"5"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"				"800"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"heal2"				"100 150 200 250"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"repel"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_omniknight/repel.lua"
		"AbilityTextureName"			"omniknight_repel"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Omniknight.Repel"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"500"
		"AbilityCastPoint"				"0.25"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"20"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"80 90 100 110"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"3.0"	// Value much higher than cost.

		"precache"
		{
		"particle"			"particles/units/heroes/hero_omniknight/omniknight_repel_buff.vpcf"
		"particle"			"particles/units/heroes/hero_omniknight/omniknight_purification.vpcf"
		"particle"			"particles/units/heroes/hero_omniknight/omniknight_degen_aura_debuff.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"3 3 4 4"
					//"LinkedSpecialBonus"		"special_bonus_omniknight_3"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"status_resistance"				"50"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"stack"					"5"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}



	"degen_aura"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_omniknight/degen_aura.lua"
		"AbilityTextureName"			"omniknight_degen_aura"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_AURA"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"375"
		"precache"
		{
		"particle"			"particles/units/heroes/hero_omniknight/omniknight_degen_aura_debuff.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"speed_bonus"			"10 18 26 34"
				"LinkedSpecialBonus"		"special_bonus_omniknight_5"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"375"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}

	"guardian_angel"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_omniknight/guardian_angel.lua"
		"AbilityTextureName"			"omniknight_guardian_angel"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Omniknight.GuardianAngel.Cast"
		"AbilityDraftUltShardAbility"		"omniknight_hammer_of_purity"
			"HasScepterUpgrade"			"1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"110"
		"AbilityCastPoint"				"0.2"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"125 175 250"
				"precache"
		{
		"particle"			"particles/status_fx/status_effect_guardian_angel.vpcf"
		"particle"			"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings_buff.vpcf"
		"particle"			"particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"5 6 7"
					"LinkedSpecialBonus"		"special_bonus_omniknight_6"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"2000"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"dam"					"15"
			}
		}
	}




	//+100洗礼伤害/治疗
	"special_bonus_omniknight_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
				"ad_linked_ability"			"purification_new"
			}
		}
	}
	//洗礼临界值变为50%
	"special_bonus_omniknight_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"20"
				"ad_linked_ability"			"purification_new"
			}
		}
	}

	//+1秒天国恩赐持续时间
	"special_bonus_omniknight_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
				"ad_linked_ability"			"repel"
			}
		}
	}
	//+2抗性持续时间
	"special_bonus_omniknight_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"2"
				"ad_linked_ability"			"repel"
			}
		}
	}


	//+10%光环减速
	"special_bonus_omniknight_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"10"
				"ad_linked_ability"			"degen_aura"
			}
		}
	}
	//+1秒守护天使持续时间
	"special_bonus_omniknight_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
				"ad_linked_ability"			"guardian_angel"
			}
		}
	}
	//-10%大招受到的魔法伤害加成
	//20%减伤
	"special_bonus_omniknight_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"20"
				"ad_linked_ability"			"guardian_angel_new"
			}
		}
	}


	//-10%大招受到的物理伤害加成
	//-10cd
	"special_bonus_omniknight_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"10"
				"ad_linked_ability"			"guardian_angel_new"
			}
		}
	}


//剧毒
	"venomous_gale"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_venomancer/venomous_gale.lua"
		"AbilityTextureName"			"venomancer_venomous_gale"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Venomancer.VenomousGale"

       		 "HasShardUpgrade"               "1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
 		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_1"
		"AbilityCastGestureSlot"		"DEFAULT"
		"AbilityCastRange"				"800"
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"14"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"125"
		"precache"
		{
			"particle"			"particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"2"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"100 200 300 400"
				"LinkedSpecialBonus"		"special_bonus_venomancer_2"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"movement_slow"			"-30 -40 -50 -60"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"dam2"				"1 1.5 2 2.5"
			}
		}
	}

	"poison_sting"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_venomancer/poison_sting.lua"
		"AbilityTextureName"			"venomancer_poison_sting"
		"AbilityType"					"DOTA_ABILITY_TYPE_BASIC"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"4.5"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"100 110 120 130"
				"LinkedSpecialBonus"		"special_bonus_venomancer_3"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"movement_speed"			"5"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"mr"				"5"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"plague_ward"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_venomancer/plague_ward.lua"
		"AbilityTextureName"			"venomancer_plague_ward"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilitySound"					"Hero_Venomancer.Plague_Ward"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"850"
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"6"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"20 22 24 26"
		"precache"
		{
			"model"			"models/items/venomancer/ward/chomper_ward/chomper_ward.vmdlf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"14"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"hp"				"2"
				//"LinkedSpecialBonusOperation"	"SPECIAL_BONUS_MULTIPLY"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"att"				"70 80 90 100"
				"LinkedSpecialBonus"		"special_bonus_venomancer_4"
				//"LinkedSpecialBonusOperation"	"SPECIAL_BONUS_MULTIPLY"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"num"				"3"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"less"				"1"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"				"2"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"attsp"				"50 60 70 80"

			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"poison_nova"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_venomancer/poison_nova.lua"
		"AbilityTextureName"			"venomancer_poison_nova"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"2"
		"AbilitySound"				"Hero_Venomancer.PoisonNova"

		"HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.0 0.0 0.0"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"80"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"200 300 400"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.0"		// just does damage
		"precache"
		{
			"particle"			"particles/units/heroes/hero_venomancer/venomancer_poison_nova_cast.vpcf"
			"particle"			"particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf"
			"particle"			"particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf"
			"particle"			"particles/status_fx/status_effect_poison_venomancer.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"800 900 1000"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"movement_slow"				"-50"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"6 7 8"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"damage"					"100 150 200"
			}
		}
	}







	//在瘴气碰撞到的英雄旁产生一个守卫
	"special_bonus_venomancer_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
				"ad_linked_ability"			"venomous_gale"
			}
		}
	}
	//+100瘴气伤害
	"special_bonus_venomancer_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
				"ad_linked_ability"			"venomous_gale"
			}
		}
	}
	//+40毒刺额外伤害
	"special_bonus_venomancer_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"40"
				"ad_linked_ability"			"poison_sting"
			}
		}
	}

	//+30守卫攻击力
	"special_bonus_venomancer_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"30"
				"ad_linked_ability"			"plague_ward"
			}
		}
	}
	//+2%守卫毒刺效果
	"special_bonus_venomancer_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"2"
				"ad_linked_ability"			"plague_ward"
			}
		}
	}

//守卫触发毒刺
	"special_bonus_venomancer_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


//大招造成的伤害的同时治疗自身
	"special_bonus_venomancer_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

//释放大招时自动产生一组蛇棒（不占用主动CD）
	"special_bonus_venomancer_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//=================================================================================================================
	// 骷髅王
	//=================================================================================================================
	"hellfire_blast"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_skeleton_king/hellfire_blast.lua"
		"AbilityTextureName"			"skeleton_king_hellfire_blast"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_SkeletonKing.Hellfire_Blast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"7"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"95 110 125 140"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.5"	// Applies two modifiers
		"precache"
		{
			"particle"			"particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"blast_speed"			"1400"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"blast_stun_duration"	"1.1 1.4 1.7 2.0"

			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"blast_dot_duration"	"2.0"
				"LinkedSpecialBonus"		"special_bonus_skeleton_king_3"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"blast_slow"			"-30"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"					"100 200 300 400"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"crit"					"100 120 140 160"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"					"400"
			}
			"08"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"					"6"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"vampiric_aura"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_skeleton_king/vampiric_aura.lua"
		"AbilityTextureName"			"skeleton_king_vampiric_aura"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.2"
		"AbilityCastRange"				"800"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"90 80 70 60"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"200"
		"precache"
		{
			"particle"			"particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_rare_run.vpcf"
			"particle"			"particles/heros/axe/shake.vpcf"
			"particle"			"particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_reincarn_style2.vpcf"
			"particle"			"particles/econ/courier/courier_trail_hw_2013/courier_trail_hw_2013.vpcf"
			"particle"			"particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_weapon.vpcf"
			"particle"			"particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_ambient_head.vpcf"
			"particle"			"particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_victory_stub.vpcf"
			"model"			"models/items/wraith_king/arcana/wraith_king_arcana.vmdl"
			"model"			"models/heroes/wraith_king/wraith_king_prop.vmdl"
			"model"			"models/items/wraith_king/arcana/wraith_king_arcana_armor.vmdl"
			"model"			"models/items/wraith_king/arcana/wraith_king_arcana_arms.vmdl"
			"model"			"models/items/wraith_king/arcana/wraith_king_arcana_back.vmdl"
			"model"			"models/items/wraith_king/arcana/wraith_king_arcana_head.vmdl"
			"model"			"models/items/wraith_king/arcana/wraith_king_arcana_shoulder.vmdl"
			"model"			"models/items/wraith_king/arcana/wraith_king_arcana_weapon.vmdl"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"vampiric_aura"			"10 20 30 40"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"					"20"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"					"800"
			}
		}
	}

	"mortal_strike"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_skeleton_king/mortal_strike.lua"
		"AbilityTextureName"			"skeleton_king_mortal_strike"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilitySound"					"Hero_SkeletonKing.CriticalStrike"
		"AbilityCastPoint"				"0.3"
		"AbilityCastRange"				"1500"
		"AbilityCooldown"				"15"
		"precache"
		{
			"model"			"models/items/wraith_king/arcana/wk_arcana_skeleton.vmdl"
			"particle"			"particles/tgp/king/ksword_m.vpcf"
			"particle"			"particles/units/heroes/hero_earthshaker/earthshaker_totem_leap_impact_dust.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"crit_mult"					"150 200 250 300"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"ch"						"25"
				"LinkedSpecialBonus"		"special_bonus_skeleton_king_8"

			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"						"7"
			}
		}
	}

	"reincarnation"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_skeleton_king/reincarnation.lua"
		"AbilityTextureName"			"skeleton_king_reincarnation"												// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"2"
		"HasScepterUpgrade"			"1"
		"HasShardUpgrade"			"1"
		"AbilitySound"					"Hero_SkeletonKing.Reincarnate"

		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_4"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"150 100 50"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"50 45 40"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.2"	// Slow isn't the main function of this ability.
		"precache"
		{
			"particle"			"particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
			"particle"			"particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_slow_debuff.vpcf"

		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"reincarnate_time"		"3.0 3.0 3.0"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"slow_radius"			"900"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"movespeed"				"-75"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"attackslow"			"-75"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"slow_duration"			"5.0"
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"attsp"					"100 150 200"
			}
			"08"
			{
				"var_type"				"FIELD_FLOAT"
				"dur2"					"10"
			}
		}
	}



//-1秒冥火暴击CD
	"special_bonus_skeleton_king_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
				"ad_linked_ability"			"hellfire_blast"
			}
		}
	}
	//吸血灵魂不消耗魔法
	"special_bonus_skeleton_king_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"0"
				"ad_linked_ability"			"vampiric_aura"
			}
		}
	}

	//+3秒冥火暴击减速
	"special_bonus_skeleton_king_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"3"
				"ad_linked_ability"			"hellfire_blast"
			}
		}
	}
	//冥火暴击附带一次普攻可触发攻击特效
	"special_bonus_skeleton_king_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//本命一击可主动使用召唤骷髅士兵
	"special_bonus_skeleton_king_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}
	//绝冥重生可对友军英雄使用
	"special_bonus_skeleton_king_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//吸血灵魂释放结束后血量回满
	"special_bonus_skeleton_king_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//+10%本名一击暴击概率
	"special_bonus_skeleton_king_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"10"
				"ad_linked_ability"			"mortal_strike"
			}
		}
	}

	//火猫
	"searing_chains"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_ember_spirit/searing_chains.lua"
		"AbilityTextureName"			"ember_spirit_searing_chains"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Hero_EmberSpirit.SearingChains.Target"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"400"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"11"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"80 90 100 110"
		"precache"
		{
			"particle"			"particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf"
			"particle"			"particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf"
			"particle"			"particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_FLOAT"
				"duration"						"1.5 2.0 2.5 3.0"
				"LinkedSpecialBonus"			"special_bonus_ember_spirit_2"
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"radius"						"400"
			}
			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"damage"						"150 200 250 300"
				"LinkedSpecialBonus"			"special_bonus_ember_spirit_1"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"unit_count"					"2 2 3 3"
			}
			"05"
			{
				"var_type"						"FIELD_FLOAT"
				"disarm"						"0.5"
			}
			"06"
			{
				"var_type"						"FIELD_FLOAT"
				"ch"						"25"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"sleight_of_fist"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_ember_spirit/sleight_of_fist.lua"
		"AbilityTextureName"			"ember_spirit_sleight_of_fist"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"

		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0"
		"FightRecapLevel"				"1"
		"AOERadius"				"250 300 350 400"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0.0"
		"AbilityCharges"				"1 1 1 2"
		"AbilityChargeRestoreTime"			"7 6 5 4"
		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50"
		"precache"
		{
			"particle"			"particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf"
			"particle"			"particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf"
			"particle"			"particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf"
			"particle"			"particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf"
			"particle"			"particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"250 300 350 400"
			}

			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"damage"					"40 65 90 115"
				"LinkedSpecialBonus"			"special_bonus_ember_spirit_3"
				"CalculateSpellDamageTooltip"	"0"
			}

			"03"
			{
				"var_type"						"FIELD_FLOAT"
				"attack_interval"				"0.2"
			}
			"04"
			{
				"var_type"						"FIELD_FLOAT"
				"wh"					"200"
			}
			"05"
			{
				"var_type"						"FIELD_FLOAT"
				"dis"					"700 800 900 1000"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"flame_guard"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_ember_spirit/flame_guard.lua"
		"AbilityTextureName"			"ember_spirit_flame_guard"			// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_EmberSpirit.FlameGuard.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"500"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"18"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"80 90 100 110"
		"precache"
		{
			"particle"			"particles/econ/items/ember_spirit/ember_ti9/ember_ti9_flameguard.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_FLOAT"
				"duration"						"8 12 16 20"
			}

			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"radius"						"500"
			}

			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"absorb_amount"					"350 450 550 650"
				"LinkedSpecialBonus"			"special_bonus_ember_spirit_4"
			}
			"04"
			{
				"var_type"						"FIELD_FLOAT"
				"tick_interval"					"0.5"
			}
			"05"
			{
				"var_type"						"FIELD_INTEGER"
				"damage_per_second"				"55 65 75 85"
			}
			"06"
			{
				"var_type"						"FIELD_INTEGER"
				"cd"						"18"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"fire_remnant"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_ember_spirit/fire_remnant.lua"
		"AbilityTextureName"			"ember_spirit_fire_remnant"// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilitySound"					"Hero_EmberSpirit.FireRemnant.Cast"
		"AbilityDraftPreAbility"		"ember_spirit_activate_fire_remnant"
      		 "HasShardUpgrade"			"1"
       		 "HasScepterUpgrade"			"1"


		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"2500"
		"AbilityCastPoint"				"0.0"
		"AbilityCastAnimation"			"ACT_INVALID"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0.0"
		"AbilityCharges"				"3 4 5"
		"AbilityChargeRestoreTime"			"15"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"


		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"sp"				"3000"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"150 200 250"
			"LinkedSpecialBonus"			"special_bonus_ember_spirit_6"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"450"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"45.0"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"duration2"			"1.5"
			}
		}
	}


	"activate_fire_remnant"
	{
		"BaseClass"				"ability_lua"
		"ScriptFile"				"heros/hero_ember_spirit/activate_fire_remnant.lua"
		"AbilityTextureName"			"ember_spirit_activate_fire_remnant"// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityType"					"DOTA_ABILITY_TYPE_BASIC"
		"MaxLevel"						"3"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"				"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"99999"
		"AbilityCastPoint"				"0.0"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50"


		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"sp"				"3000"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"150 200 250"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"450"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"45.0"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"duration2"			"1.5"
			}
		}
	}


	//+100炎阳锁伤害
	"special_bonus_ember_spirit_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
				"ad_linked_ability"			"searing_chains"
			}
		}
	}
	//+1缠绕持续时间
	"special_bonus_ember_spirit_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"1"
				"ad_linked_ability"			"searing_chains"
			}
		}
	}

	//+100无影拳额外攻击力
	"special_bonus_ember_spirit_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"100"
				"ad_linked_ability"			"sleight_of_fist"
			}
		}
	}
	//+150烈火罩吸收伤害
	"special_bonus_ember_spirit_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"150"
				"ad_linked_ability"			"flame_guard"
			}
		}
	}


	//烈火罩吸收所有类型伤害
	"special_bonus_ember_spirit_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//+200残焰伤害
	"special_bonus_ember_spirit_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"200"
				"ad_linked_ability"			"fire_remnant"
			}
		}
	}




	//龙骑士
	"breathe_fire"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_dragon_knight/breathe_fire.lua"
		"AbilityTextureName"			"dragon_knight_breathe_fire"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_DIRECTIONAL | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_DragonKnight.BreathFire"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"750"
		"AbilityCastPoint"				"0.2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"9"


		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"80"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"
			"particle"	"particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire_.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"start_radius"			"250 250 250 250"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"end_radius"			"250 250 250 250"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"range"					"750"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"speed"					"1050"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"ar"					"-3 -6 -9 -11"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"mr"					"-10 -14 -16 -18"
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"7"
			}
			"08"
			{
				"var_type"				"FIELD_FLOAT"
				"damage"				"150 200 250 300"
			}
			"09"
			{
				"var_type"				"FIELD_FLOAT"
				"damage2"				"50"
				"LinkedSpecialBonus"		"special_bonus_dragon_knight_2"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"dragon_tail"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_dragon_knight/dragon_tail.lua"
		"AbilityTextureName"			"dragon_knight_dragon_tail"							// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_DragonKnight.DragonTail.Target"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"300"
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"9"


		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail_dragonform_proj.vpcf"
			"particle"	"particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_anim_firebreath.vpcf"
			"particle"	"particles/tgp/dk/dragon_tail1.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"stun_duration"			"1.25"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"cast_range"			"800"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"dam_m"				"100"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"dam_r"					"100 200 300 400"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"stun_duration2"			"2"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"explosion"					"2 3 4 5"
				"LinkedSpecialBonus"		"special_bonus_dragon_knight_3"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"explosion_rd"				"200"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"dragon_blood"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_dragon_knight/dragon_blood.lua"
		"AbilityTextureName"			"dragon_knight_dragon_blood"							// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityCastPoint"				"0"
		"AbilityCooldown"				"12"
		"AbilityManaCost"				"50"
		"precache"
		{
			"particle"	"particles/econ/events/newbloom_2015/shivas_guard_active_nian2015.vpcf"
			"particle"	"particles/tgp/dk/azuremircourierfinal1.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"bonus_health_regen"			"10 15 20 25"
				"LinkedSpecialBonusOperation"	"SPECIAL_BONUS_MULTIPLY"
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"bonus_armor"					"4 7 10 13"
				"LinkedSpecialBonusOperation"	"SPECIAL_BONUS_MULTIPLY"
			}
			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"dis"							"3000"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"wh"							"250"
			}
			"05"
			{
				"var_type"						"FIELD_INTEGER"
				"dam"							"100 200 300 400"
			}
			"06"
			{
				"var_type"						"FIELD_INTEGER"
				"att"							"4"
			}
			"07"
			{
				"var_type"						"FIELD_INTEGER"
				"dur"							"6"
				"LinkedSpecialBonus"		"special_bonus_dragon_knight_6"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"elder_dragon_form"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"heros/hero_dragon_knight/elder_dragon_form.lua"
		"AbilityTextureName"			"dragon_knight_elder_dragon_form"							// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PURE"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_DragonKnight.ElderDragonForm"
      		  "HasScepterUpgrade"             "1"
		"HasShardUpgrade"               "1"
		"AbilityDraftUltShardAbility"		"dragon_knight_fireball"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"			"ACT_INVALID"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"90"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.35"	// Attacks are primarily about the damage
		"precache"
		{
			"particle"	"particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_attack_black.vpcf"
			"particle"	"particles/units/heroes/hero_dragon_knight/dragon_knight_transform_black.vpcf"
			"particle"	"particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf"
			"particle"	"particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf"
			"particle"	"particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf"
			"particle"	"particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf"
			"particle"	"particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf"
			"particle"	"particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf"
			"model"	"models/heroes/dragon_knight_persona/dk_persona_dragon.vmdl"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"60"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_movement_speed"		"50 75 100"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_attack_range"		"350 350 350 350"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_attack_damage"		"0"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"corrosive_breath_damage"	"80 100 120"
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"tower_dam"						"40"
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"splash_radius"				"350"
			}
			"08"
			{
				"var_type"					"FIELD_INTEGER"
				"splash_damage_percent"		"100"
			}
			"09"
			{
				"var_type"						"FIELD_INTEGER"
				"frost_bonus_movement_speed"	"-40 -50 -60"
			}
			"10"
			{
				"var_type"						"FIELD_INTEGER"
				"frost_bonus_attack_speed"		"-40 -50 -60"
			}
			"11"
			{
				"var_type"						"FIELD_FLOAT"
				"frost_duration"				"3.0 3.0 3.0"
			}
			"12"
			{
				"var_type"						"FIELD_FLOAT"
				"mr"						"25"
			}
			"13"
			{
				"var_type"						"FIELD_FLOAT"
				"sr"						"30"
			}
			"14"
			{
				"var_type"						"FIELD_FLOAT"
				"att"						"100"
			}
		}
	}

	//飞盾经过1秒延迟会往返飞行
	"special_bonus_dragon_knight_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}
	//+20% 龙炎伤害百分比
	"special_bonus_dragon_knight_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"20"
				"ad_linked_ability"			"breathe_fire"
			}
		}
	}

	//+3火焰爆破次数
	"special_bonus_dragon_knight_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"3"
				"ad_linked_ability"			"dragon_tail"
			}
		}
	}
	//火焰气息造成的伤害治疗自身
	"special_bonus_dragon_knight_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//人形态继承碧龙效果
	"special_bonus_dragon_knight_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//+6秒火龙获得的攻击力
	"special_bonus_dragon_knight_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"6"
				"ad_linked_ability"			"dragon_blood"
			}
		}
	}

	//-25秒大招CD
	"special_bonus_dragon_knight_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"25"
				"ad_linked_ability"			"elder_dragon_form"
			}
		}
	}


	//双倍龙族血统护甲回血
	"special_bonus_dragon_knight_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}






	// 陈
	"penitence"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"	"chen_penitence"
		"ScriptFile"			"heros/hero_chen/penitence.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"					"Hero_Chen.PenitenceCast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000"
		"AbilityCooldown"				"14"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"70 80 90 100"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_chen/chen_penitence_proj.vpcf"
			"particle"	"particles/units/heroes/hero_chen/chen_penitence.vpcf"
			"particle"	"particles/units/heroes/hero_chen/chen_penitence_debuff.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"1 2 3 4"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"speed"					"2000"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	"holy_persuasion"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"	"chen_holy_persuasion"
		"ScriptFile"			"heros/hero_chen/holy_persuasion.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilitySound"					"Hero_Chen.HolyPersuasionCast"
		"AbilityUnitTargetType"		"DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_CREEP"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0"
		"HasScepterUpgrade"			"1"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1500"
		"AbilityCooldown"				"11"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"90 110 130 150"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_chen/chen_test_of_faith.vpcf"
			"particle"	"particles/units/heroes/hero_chen/chen_test_of_faith.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"hp"					"400 600 800 1000"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"sp"					"50 100 150 200"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"ar"					"4 6 8 10"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"					"12"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"num"					"1"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"dis"					"1000 1100 1200 1300"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"					"300 350 400 450"
			}
			"09"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"					"15 20 25 30"
			}
			"10"
			{
				"var_type"				"FIELD_INTEGER"
				"stun"					"1 1.25 1.5 1.75"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}



	"divine_favor"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"	"chen_divine_favor"
		"ScriptFile"			"heros/hero_chen/divine_favor.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_TOGGLE | DOTA_ABILITY_BEHAVIOR_AURA"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"2000"


		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"heal_amp"			"30 40 50 60"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"heal_rate"			"20 30 40 50"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"aura_radius"			"2000"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}



	"hand_of_god"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"	"chen_hand_of_god"
		"ScriptFile"			"heros/hero_chen/hand_of_god.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Chen.HandOfGodHealHero"
 		"HasShardUpgrade"               "1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.2"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"120"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"250 350 450"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_chen/chen_hand_of_god.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"heal_amount"			"1000 1500 2000"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"num"					"1 2 3"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"i"						"1"
			}
		}
	}


	"test_of_faith"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"chen_test_of_faith"
		"ScriptFile"				"heros/hero_chen/test_of_faith.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PURE"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Hero_Chen.TestOfFaith.Target"
		"MaxLevel"				"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000"
		"AbilityCooldown"				"8"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"damage_min"			"500"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"damage_max"			"1200"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"heal_min"			"1000"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"heal_max"			"2000"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	//范围型救赎（350码）
	"special_bonus_chen_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}
	//救赎使目标受到的伤害提高25%
	"special_bonus_chen_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//额外增加一个技能-考验-
	"special_bonus_chen_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}
	//对神圣劝化的野怪随机增加一个技能
	"special_bonus_chen_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//神力恩泽额外降低友军5%的技能冷却
	"special_bonus_chen_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//神力恩泽额外降低敌军15%的魔法抗性
	"special_bonus_chen_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

		//-上帝之手使目标获得1.5秒无敌并且每次都会恢复全部血量
	"special_bonus_chen_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//陈再受到致命伤害时自动被传回泉水并刷新TPCD(120秒内置冷却)
	"special_bonus_chen_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}






	//狼人
	"summon_wolves"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"	"lycan_summon_wolves"
		"ScriptFile"			"heros/hero_lycan/summon_wolves.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK"
		"AbilitySound"					"Hero_Lycan.SummonWolves"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
        "HasShardUpgrade"               "1"
		"AbilityCastRange"				"800"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"20"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
		"precache"
		{
			"particle"	"particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_ambient_trail.vpcf"
			"model"	"models/heroes/lycan/summon_wolves.vmdl"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"wolf_index"				"2"
				"LinkedSpecialBonus"		"special_bonus_lycan_1"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"wolf_duration"				"40"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"wolf_bat"					"0.9"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"wolf_damage"				"60 70 80 90"
				"LinkedSpecialBonus"		"special_bonus_lycan_2"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"wolf_hp"					"400 550 700 850"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"sp"						"20 25 30 35"
			}
			"07"
			{
				"var_type"					"FIELD_FLOAT"
				"sp_dur"					"2"
			}
			"08"
			{
				"var_type"					"FIELD_FLOAT"
				"dam"					"140 160 180 200"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}



	"howl"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"	"lycan_howl"
		"ScriptFile"			"heros/hero_lycan/howl.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilitySound"					"Hero_Lycan.Howl"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"26"
		"AbilityCastRange"				"2000"
		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"35 40 45 50"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportBonus"	"5"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"howl_duration"			"7 8 9 10"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"vision"				"800 1200 1600 2000"
				"LinkedSpecialBonus"		"special_bonus_lycan_4"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"sp"				"40 60 80 100"
				"LinkedSpecialBonus"		"special_bonus_lycan_3"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"2000"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"att"				"70 80 90 100"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
		"AbilityCastGestureSlot"	"DEFAULT"
	}


	"feral_impulse"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"	"lycan_feral_impulse"
		"ScriptFile"			"heros/hero_lycan/feral_impulse.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityCastRange"				"1000"
		// Casting
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"bonus_damage"			"10 20 30 40"
				"LinkedSpecialBonus"	"special_bonus_unique_lycan_4"
				"LinkedSpecialBonus"		"special_bonus_lycan_5"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"bonus_hp_regen"		"10 20 30 40"
				"LinkedSpecialBonus"	"special_bonus_unique_lycan_3"
				"LinkedSpecialBonus"		"special_bonus_lycan_6"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"shapeshift"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"	"lycan_shapeshift"
		"ScriptFile"			"heros/hero_lycan/shapeshift.lua"						// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Lycan.Shapeshift.Cast"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"
	 	"HasShardUpgrade"               "1"
		"HasScepterUpgrade"			"1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"80"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
		"precache"
		{
			"particle"	"particles/econ/items/pudge/pudge_arcana/default/pudge_arcana_dismember_ground_default.vpcf"
			"particle"	"particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_ti8_sword_crit_overtheshoulder.vpcf"
			"particle"	"particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf"
			"particle"	"particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf"
			"particle"	"particles/units/heroes/hero_lycan/lycan_shapeshift_buff.vpcf"
			"model"	"models/items/lycan/ultimate/ambry_true_form/ambry_true_form.vmdl"
			"model"	"models/items/lycan/ultimate/thegreatcalamityti4/thegreatcalamityti4.vmdl"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"25 30 35"
				"LinkedSpecialBonus"		"special_bonus_unique_lycan_1"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"speed"						"100"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"						"10"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"transformation_time"		"1.25"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"crit_chance"				"35"
				"LinkedSpecialBonus"		"special_bonus_lycan_8"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"crit_multiplier"			"150 175 200"
				"LinkedSpecialBonus"		"special_bonus_lycan_7"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"chance"				"40"
			}
			"08"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"					"30 35 40"
			}
		}
	}

"wolf_bite"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"lycan_wolf_bite"
		"ScriptFile"					"heros/hero_lycan/wolf_bite.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"AbilitySound"					"Hero_Lycan.Shapeshift.Cast"
		"MaxLevel"						"1"
		"FightRecapLevel"				"1"
		"IsGrantedByScepter"			"1"
		"HasScepterUpgrade"				"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"300"
		"AbilityCooldown"				"30"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"


		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
		"precache"
		{
			"particle"	"particles/econ/items/pudge/pudge_arcana/default/pudge_arcana_dismember_ground_default.vpcf"
			"particle"	"particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_ti8_sword_crit_overtheshoulder.vpcf"
			"particle"	"particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf"
			"particle"	"particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf"
			"particle"	"particles/units/heroes/hero_lycan/lycan_shapeshift_buff.vpcf"
			"model"		"models/items/lycan/ultimate/ambry_true_form/ambry_true_form.vmdl"
			"model"		"models/items/lycan/ultimate/thegreatcalamityti4/thegreatcalamityti4.vmdl"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"15"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"speed"						"350"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"dur"						"10"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"transformation_time"		"1.25"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"crit_chance"			"50"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"crit_multiplier"		"150 175 200"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"chance"				"35"
			}
			"08"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"					"30 35 40"
			}
		}
	}

	//+1头狼
	"special_bonus_lycan_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"
				"ad_linked_ability"			"summon_wolves"
			}
		}
	}
	//+40 头狼攻击力
	"special_bonus_lycan_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"40"
				"ad_linked_ability"			"summon_wolves"
			}
		}
	}

	//+50嗥叫移动速度
	"special_bonus_lycan_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"50"
				"ad_linked_ability"			"howl"
			}
		}
	}
	//+1000嗥叫夜间视野
	"special_bonus_lycan_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1000"
				"ad_linked_ability"			"howl"
			}
		}
	}


	//+15%野性驱使攻击力百分比
	"special_bonus_lycan_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"15"
				"ad_linked_ability"			"feral_impulse"
			}
		}
	}


	//+30野性驱使回血
	"special_bonus_lycan_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"30"
				"ad_linked_ability"			"feral_impulse"
			}
		}
	}

		//+50% 大招暴击倍率
	"special_bonus_lycan_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"50"
				"ad_linked_ability"			"shapeshift"
			}
		}
	}


			//+5% 大招暴击概率
	"special_bonus_lycan_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"5"
				"ad_linked_ability"			"shapeshift"
			}
		}
	}






	//med
	"split_shot"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"medusa_split_shot"
		"ScriptFile"					"heros/hero_medusa/split_shot.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_TOGGLE | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0"
		"AbilityCooldown"				"1.5"

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"damage_modifier"		"40 60 80 100"
			}

			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"arrow_count"				"4"
				"LinkedSpecialBonus"		"special_bonus_medusa_6"
			}
			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"dam"						"60"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"dam2"						"40"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"mystic_snake"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"medusa_mystic_snake"
		"ScriptFile"					"heros/hero_medusa/mystic_snake.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Medusa.MysticSnake.Cast"

		"HasScepterUpgrade"				"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0.2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"10"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"140 150 160 170"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile.vpcf"
			"particle"	"particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_return.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"475 475 475 475"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"snake_jumps"			"4 5 6 7"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"snake_damage"			"100 140 180 220"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"snake_mana_steal"		"11 14 17 20"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"movement_slow"			"30"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"turn_slow"				"50"
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"slow_duration"			"3"
			}
			"08"
			{
				"var_type"				"FIELD_FLOAT"
				"dam"				"10"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"mana_shield"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"medusa_mana_shield"
		"ScriptFile"					"heros/hero_medusa/mana_shield.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_TOGGLE | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"					"Hero_Medusa.ManaShield.On"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.4 0.4 0.4 0.4"

		"precache"
		{
			"particle"	"particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"damage_per_mana"		"2 2.3 2.6 2.9"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"absorption_pct"			"75"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"heal"				"30"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}

	"stone_gaze"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"medusa_stone_gaze"
		"ScriptFile"					"heros/hero_medusa/stone_gaze.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Medusa.StoneGaze.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.4"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1200"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"90"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"

		"precache"
		{
			"particle"	"particles/units/heroes/hero_medusa/medusa_stone_gaze_active.vpcf"
			"particle"	"particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff.vpcf"
			"particle"	"particles/units/heroes/hero_medusa/medusa_stone_gaze_facing.vpcf"
			"particle"	"particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
			"particle"	"particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"1200"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"6 6.5 7"
				"LinkedSpecialBonus"		"special_bonus_medusa_5"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"slow"						"35"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"stone_duration"			"3.0"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"face_duration"				"2.0"
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"vision_cone"				"0.08715"		// 85 degree cone
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_physical_damage"		"40 45 50"
			}
			"08"
			{
				"var_type"					"FIELD_INTEGER"
				"speed_boost"		"50"
			}
		}
	}

	//-2异蛇冷却
	"special_bonus_medusa_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"2"
				"ad_linked_ability"			"mystic_snake"
			}
		}
	}
	//+30%异蛇魔法吸取
	"special_bonus_medusa_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"30"
				"ad_linked_ability"			"mystic_snake"
			}
		}
	}

	//+1异蛇缠绕
	"special_bonus_medusa_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"
				"ad_linked_ability"			"mystic_snake"
			}
		}
	}
	//+150异蛇弹跳范围
	"special_bonus_medusa_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"150"
				"ad_linked_ability"			"mystic_snake"
			}
		}
	}


	//+2秒石化凝视持续时间
	"special_bonus_medusa_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"2"
				"ad_linked_ability"			"stone_gaze"
			}
		}
	}


	//+6额外箭矢
	"special_bonus_medusa_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"2"
				"ad_linked_ability"			"split_shot"
			}
		}
	}

		//+40%分裂箭攻击力百分比
	"special_bonus_medusa_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
				"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"50"
				"ad_linked_ability"			"split_shot"
			}
		}
	}


			//+10%互助蓝量上限
	"special_bonus_medusa_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"10"
				"ad_linked_ability"			"mana_shield"
			}
		}
	}




	//黑鸟
	"arcane_orb"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"obsidian_destroyer_arcane_orb"
		"ScriptFile"					"heros/hero_obsidian_destroyer/arcane_orb.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PURE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"					"Hero_ObsidianDestroyer.ArcaneOrb"
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0.25 0.25 0.25 0.25"
		"AbilityCooldown"				"1.1"
		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"150"

		"precache"
		{
			"particle"	"particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"mana_pool_damage_pct"		"8 9 10 11"
				"LinkedSpecialBonus"		"special_bonus_obsidian_destroyer_1"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"rd"					"350"
								"LinkedSpecialBonus"	"special_bonus_obsidian_destroyer_2"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"astral_imprisonment"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"obsidian_destroyer_astral_imprisonment"
		"ScriptFile"					"heros/hero_obsidian_destroyer/astral_imprisonment.lua"															// unique ID number for this item.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY | DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		//"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"					"Hero_ObsidianDestroyer.AstralImprisonment"
	"HasScepterUpgrade"					"1"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"10"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"800"
		"AbilityCastPoint"				"0.1"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"120"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.5" // applies multiple modifiers

		"precache"
		{
			"particle"	"particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"prison_duration"		"3"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"100 150 200 250"
				"LinkedSpecialBonus"	"special_bonus_obsidian_destroyer_3"
			}
			"03"
			{
				"var_type"			"FIELD_INTEGER"
				"mana_capacity_steal"	"14 16 18 20"
								"LinkedSpecialBonus"	"special_bonus_obsidian_destroyer_4"
			}
			"04"
			{
				"var_type"			"FIELD_INTEGER"
				"dur"					"6"
			}
			"05"
			{
				"var_type"			"FIELD_INTEGER"
				"dur2"					"5"
			}
			"06"
			{
				"var_type"			"FIELD_INTEGER"
				"mana"					"20"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"essence_aura"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"obsidian_destroyer_essence_aura"
		"ScriptFile"					"heros/hero_obsidian_destroyer/essence_aura.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_AURA"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilitySound"					"Hero_ObsidianDestroyer.EssenceAura"
		"HasScepterUpgrade"					"1"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"radius"			"1200"
			}
			"02"
			{
				"var_type"			"FIELD_FLOAT"
				"restore_amount"	"10 15 20 25"
								"LinkedSpecialBonus"	"special_bonus_obsidian_destroyer_6"
			}
			"03"
			{
				"var_type"			"FIELD_INTEGER"
				"restore_chance"		"20 30 40 50"
							"LinkedSpecialBonus"	"special_bonus_obsidian_destroyer_5"
			}
			"05"
			{
				"var_type"			"FIELD_INTEGER"
				"int"					"2 3 4 5"
			}
			"06"
			{
				"var_type"			"FIELD_INTEGER"
				"dur"					"6"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"sanity_eclipse"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"obsidian_destroyer_sanity_eclipse"
		"ScriptFile"					"heros/hero_obsidian_destroyer/sanity_eclipse.lua"												// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0.25 0.25 0.25"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_ObsidianDestroyer.SanityEclipse"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"120"
 		"HasShardUpgrade"               "1"
		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"200 325 450"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"base_damage"					"300 400 500"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"						"600"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"cast_range"					"700"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"damage_multiplier"			"0.7 0.8 0.9"
								"LinkedSpecialBonus"	"special_bonus_obsidian_destroyer_7"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"dur"			"4 5 6"
								"LinkedSpecialBonus"	"special_bonus_obsidian_destroyer_8"
			}
		}
	}


	//+1.5%奥术天球百分比
	"special_bonus_obsidian_destroyer_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1.5"
				"ad_linked_ability"			"arcane_orb"
			}
		}
	}
	//+75奥术天球范围
	"special_bonus_obsidian_destroyer_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"75"
				"ad_linked_ability"			"arcane_orb"
			}
		}
	}

	//+150星体禁锢伤害
	"special_bonus_obsidian_destroyer_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"100"
				"ad_linked_ability"			"astral_imprisonment"
			}
		}
	}
	//+10%获得的魔法上限
	"special_bonus_obsidian_destroyer_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"10"
				"ad_linked_ability"			"astral_imprisonment"
			}
		}
	}


	//+5%精华变迁概率
	"special_bonus_obsidian_destroyer_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"5"
				"ad_linked_ability"			"essence_aura"
			}
		}
	}


	//+5%精华变迁恢复魔法百分比
	"special_bonus_obsidian_destroyer_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"5"
				"ad_linked_ability"			"essence_aura"
			}
		}
	}

		//+0.1大招系数
	"special_bonus_obsidian_destroyer_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
				"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0.1"
				"ad_linked_ability"			"sanity_eclipse"
			}
		}
	}


			//+2秒大招禁止回蓝
	"special_bonus_obsidian_destroyer_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"2"
				"ad_linked_ability"			"sanity_eclipse"
			}
		}
	}






	//先知
	"sprout"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"furion_sprout"
		"ScriptFile"					"heros/hero_furion/sprout.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_POINT"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Furion.Sprout"

    		 "HasShardUpgrade"               "1"

		// Unit Targeting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_TREE"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"2000"
		"AbilityCastPoint"				"0.3"
		"AbilityCooldown"				"12"
		"AbilityManaCost"				"70 90 110 130"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"vision_range"			"700"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"3.5 4 4.5 5"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}








	//毒龙
	"poison_attack"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"viper_poison_attack"
		"ScriptFile"					"heros/hero_viper/poison_attack.lua"												// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"hero_viper.poisonAttack.Cast"

        "HasShardUpgrade"               "1"

		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"1"

		// Damage.
		//-------------------------------------------------------------------------------------------------------------
		"AbilityDamage"					"0 0 0 0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"
			"precache"
		{
			"particle"	"particles/econ/items/viper/viper_ti7_immortal/viper_poison_attack_ti7.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_FLOAT"
				"damage"						"70 90 110 120"
					"LinkedSpecialBonus"	"special_bonus_viper_1"
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"movement_speed"				"3 4 5 6"
			}
			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"magic_resistance"				"3 4 5 6"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"max_stacks"					"10"
			}
			"05"
			{
				"var_type"						"FIELD_INTEGER"
				"dur"							"4"
						"LinkedSpecialBonus"	"special_bonus_viper_2"
			}
			"06"
			{
				"var_type"						"FIELD_INTEGER"
				"dam"							"3 4 5 6"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"nethertoxin"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"viper_nethertoxin"
		"ScriptFile"					"heros/hero_viper/nethertoxin.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.2"
		"AbilityCastRange"				"900"
		"AOERadius"						"400"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"22"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"85"

			"precache"
		{
			"particle"	"particles/econ/items/viper/viper_immortal_tail_ti8/viper_immortal_ti8_nethertoxin.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"			"80 100 120 140"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"			"4"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"			"400"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"mr"				"10 15 20 25"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"ar"				"5 7 9 11"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	"corrosive_skin"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"viper_corrosive_skin"
		"ScriptFile"					"heros/hero_viper/corrosive_skin.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"hero_viper.CorrosiveSkin"
		"AbilityCooldown"				"10"
		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportBonus"		"10"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_viper/viper_corrosive_debuff.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"4.0"
				"LinkedSpecialBonus" 	"special_bonus_viper_4"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_attack_speed"		"30 40 50 60"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_magic_resistance"	"15 20 25 30"
				"LinkedSpecialBonus"	"special_bonus_viper_3"

			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"damage"					"10 20 30 40"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"heal"						"5 10 15 20"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"dursp"						"6"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"viper_strike"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"viper_viper_strike"
		"ScriptFile"					"heros/hero_viper/viper_strike.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"FightRecapLevel"				"2"
		"AbilitySound"					"hero_viper.viperStrike"
		"HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000"
		"AbilityCastPoint"				"0.1"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0.0"
		"AbilityCharges"				"2 3 4"
		"AbilityChargeRestoreTime"			"25"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"125 175 250"
							"precache"
		{
			"particle"	"particles/units/heroes/hero_viper/viper_viper_strike_barb.vpcf"
						"particle"	"particles/units/heroes/hero_viper/viper_viper_strike_debuff.vpcf"
												"particle"	"particles/status_fx/status_effect_poison_viper.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"5"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"100 120 140"

			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"bonus_movement_speed"	"40 60 80"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"bonus_attack_speed"	"40 60 80"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"projectile_speed"		"1600"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"rate"					"40 60 80"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"					"300 350 400"
			}
		}
	}


	//+30毒性攻击额外伤害
	"special_bonus_viper_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"30"
				"ad_linked_ability"			"poison_attack"
			}
		}
	}
	//+1秒毒性攻击持续时间
	"special_bonus_viper_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"1"
				"ad_linked_ability"			"poison_attack"
			}
		}
	}

	//+20%腐蚀皮肤魔法抗性
	"special_bonus_viper_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"20"
				"ad_linked_ability"			"corrosive_skin"
			}
		}
	}
	//+1腐蚀皮肤持续时间
	"special_bonus_viper_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"
				"ad_linked_ability"			"corrosive_skin"
			}
		}
	}











	//沙王
	"burrowstrike"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"sandking_burrowstrike"
		"ScriptFile"					"heros/hero_sand_king/burrowstrike.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"HasScepterUpgrade"			"1"
		"AbilitySound"					"Ability.SandKing_BurrowStrike"
  		"HasShardUpgrade"               "1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600 700 800 900"
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"14"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"110 120 130 140"

				"precache"
		{
			"particle"	"particles/econ/items/sand_king/sandking_barren_crown/sandking_rubyspire_burrowstrike.vpcf"
			"model"	"models/items/courier/vaal_the_animated_constructdire/vaal_the_animated_constructdire_flying.vmdl"

		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"burrow_width"		"200"
			}
			"02"
			{
				"var_type"			"FIELD_FLOAT"
				"burrow_duration"		"1.5"
			}
			"03"
			{
				"var_type"			"FIELD_INTEGER"
				"burrow_speed"		"4000"
			}
			"04"
			{
				"var_type"			"FIELD_INTEGER"
				"cast_range"		"600 700 800 900"
			}
			"05"
			{
				"var_type"			"FIELD_INTEGER"
				"damage"				"100 150 200 250"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"cast_range_scepter"				"800 1000 1200 1400"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"sand_storm"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"sandking_sand_storm"
		"ScriptFile"					"heros/hero_sand_king/sand_storm.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Ability.SandKing_SandStorm.start"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"25"
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"75"
					"precache"
		{
			"particle"	"particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"damage_tick_rate"			"0.5"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"sand_storm_radius"			"400"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"20"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"sand_storm_damage"		"30 40 50 60"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"fade_delay"			"1"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"hp"					"1 1.5 2 2.5"
						"LinkedSpecialBonus"	"special_bonus_sand_king_2"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"caustic_finale"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"sandking_caustic_finale"
		"ScriptFile"					"heros/hero_sand_king/caustic_finale.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Ability.SandKing_CausticFinale"
					"precache"
		{
			"particle"	"particles/units/heroes/hero_sandking/sandking_caustic_finale_debuff.vpcf"
						"particle"	"particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"caustic_finale_radius"		"500"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"caustic_finale_damage_base"		"20 30 40 50"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"caustic_finale_damage_pct"		"10"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"caustic_finale_duration"	"5"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"caustic_finale_slow"		"-10 -15 -20 -25"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"pct"		"10"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"epicenter"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"sandking_epicenter"
		"ScriptFile"					"heros/hero_sand_king/epicenter.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Ability.SandKing_Epicenter"
  		"HasShardUpgrade"               "1"


		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"90"
		"AbilityCastPoint"				"1.5"
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_4"
		"AbilityChannelAnimation"		"ACT_DOTA_CHANNEL_ABILITY_4"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"150 225 300"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.2"	// Damage is the main component of spell
		"precache"
		{
			"particle"	"particles/units/heroes/hero_sandking/sandking_epicenter_tell.vpcf"
			"particle"	"particles/units/heroes/hero_sandking/sandking_epicenter.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"epicenter_radius"	"500"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"epicenter_pulses"	"6 8 10"
				"LinkedSpecialBonus"	"special_bonus_sand_king_4"
			}
			"03"
			{
				"var_type"			"FIELD_INTEGER"
				"epicenter_damage"	"150 160 170"
				"LinkedSpecialBonus"	"special_bonus_sand_king_1"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"interval"		"0.25"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"		"100 150 200"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"dmg"			"10"
			}
		}
	}


	//+50地震伤害
	"special_bonus_sand_king_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"50"
				"ad_linked_ability"			"epicenter"
			}
		}
	}
	//+2%沙尘暴生命恢复
	"special_bonus_sand_king_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"2"
				"ad_linked_ability"			"sand_storm"
			}
		}
	}

	//+30%腐尸毒减速
	"special_bonus_sand_king_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"30"
				"ad_linked_ability"			"caustic_finale"
			}
		}
	}
	//+4地震次数
	"special_bonus_sand_king_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"4"
				"ad_linked_ability"			"epicenter"
			}
		}
	}

	//沙尘暴跟随沙王
	"special_bonus_sand_king_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//双向穿刺
	"special_bonus_sand_king_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//大幅度提高地震拉扯速度
	"special_bonus_sand_king_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//地震扩散每次震击增加10点伤害
	"special_bonus_sand_king_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}









	//白牛
	"charge_of_darkness"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"spirit_breaker_charge_of_darkness"
		"ScriptFile"					"heros/hero_spirit_breaker/charge_of_darkness.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_ALERT_TARGET | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Spirit_Breaker.ChargeOfDarkness"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.3"
		"AbilityCastRange"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"12"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"70 80 90 100"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	".30" // applies multiple modifiers
		"precache"
		{
			"particle"	"particles/status_fx/status_effect_charge_of_darkness.vpcf"
			"particle"	"particles/heros/spirit_breaker/spirit_breaker_charge_mist_change0.vpcf"
			"particle"	"particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_target.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"movement_speed"		"300 400 500 600"
				"LinkedSpecialBonus"	"special_bonus_spirit_breaker_1"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"stun_duration"			"1.2 1.6 2.0 2.4"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"bash_radius"			"300 300 300 300"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"dur"					"1"
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"rd"					"2000"
			}
			"08"
			{
				"var_type"				"FIELD_FLOAT"
				"dmg"					"30 35 40 45%"
			}
			"09"
			{
				"var_type"				"FIELD_FLOAT"
				"limit"					"1100 1300 1500 1700"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"bulldoze"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"spirit_breaker_bulldoze"
		"ScriptFile"					"heros/hero_spirit_breaker/bulldoze.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Spirit_Breaker.EmpoweringHaste.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"22"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
			"particle"	"particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf"
		}

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"movement_speed"				"12 18 24 30"
			}
			"02"
			{
				"var_type"						"FIELD_FLOAT"
				"duration"						"8"
			}
			"03"
			{
				"var_type"						"FIELD_FLOAT"
				"duration1"						"4"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
		"AbilityCastGestureSlot"		"DEFAULT"
	}


	"greater_bash"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"spirit_breaker_greater_bash"
		"ScriptFile"					"heros/hero_spirit_breaker/greater_bash.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"AbilitySound"					"Hero_Spirit_Breaker.GreaterBash"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"1"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportBonus"	"40"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"chance_pct"			"25"
				"LinkedSpecialBonus"	"special_bonus_spirit_breaker_4"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"damage"				"20 30 40 50"
				"LinkedSpecialBonus"	"special_bonus_spirit_breaker_5"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"0.5 0.7 0.9 1.1"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"knockback_duration"	"0.5 0.5 0.5 0.5"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"knockback_distance"	"143 152 158 162"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"knockback_height"		"50 50 50 50"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"sp"					"50"
			}
			"08"
			{
				"var_type"				"FIELD_FLOAT"
				"dur"					"4"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"nether_strike"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"spirit_breaker_nether_strike"
		"ScriptFile"					"heros/hero_spirit_breaker/nether_strike.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Spirit_Breaker.NetherStrike.Begin"
		"HasScepterUpgrade"			"1"
        "HasShardUpgrade"               "1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.7"
		"AbilityCastRange"				"1200"
		"AbilityCastRangeBuffer"			"2000"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"40"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"125 150 175"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
			"particle"	"particles/status_fx/status_effect_charge_of_darkness.vpcf"
						"particle"	"particles/econ/items/spirit_breaker/spirit_breaker_iron_surge/spirit_breaker_charge_iron.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"					"300 400 500"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"rd"					"300"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"stun"					"1"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"trd"					"1000"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"sp"					"30 40 50"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"cast"					"0.7"
			}
		}
	}




//+200冲刺速度
	"special_bonus_spirit_breaker_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"200"
				"ad_linked_ability"			"charge_of_darkness"
			}
		}
	}
	//威吓不再耗蓝
	"special_bonus_spirit_breaker_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//巨力重击击退距离降低至0
	"special_bonus_spirit_breaker_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//+25%巨力重击概率
	"special_bonus_spirit_breaker_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"25"
				"ad_linked_ability"			"greater_bash"
			}
		}
	}

	//+20%巨力重击伤害百分比
	"special_bonus_spirit_breaker_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"20"
				"ad_linked_ability"			"greater_bash"
			}
		}
	}

	//释放威吓对自身250码范围单位造成一次普通击飞
	"special_bonus_spirit_breaker_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//+1000大招施法距离
	"special_bonus_spirit_breaker_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
						"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1000"
				"ad_linked_ability"			"nether_strike"
			}
		}
	}

	//-20秒大招CD
	"special_bonus_spirit_breaker_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
				"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"20"
				"ad_linked_ability"			"nether_strike"
			}
		}
	}







//双头龙


"dual_breath"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"jakiro_dual_breath"
		"ScriptFile"	"heros/hero_jakiro/dual_breath.lua"								// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Jakiro.DualBreath"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"					"0"
		"AbilityCastPoint"					"0.1"

		"AbilityCooldown"					"0"
		"AbilityCharges"					"2"
		"AbilityChargeRestoreTime"				"10"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"					"135 140 155 170"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.25"	// Applies two modifiers
		"precache"
		{
			"particle"	"particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_dual_breath_fire.vpcf"
			"particle"	"particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_dual_breath_ice.vpcf"
						"particle"	"particles/generic_gameplay/generic_disarm.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"dis"						"3000"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"wh"						"300"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"flydis"					"1200"
			}
				"04"
			{
				"var_type"				"FIELD_INTEGER"
				"dam"				"100 110 120 130"
			}
				"05"
			{
				"var_type"				"FIELD_INTEGER"
				"disarmeddur"				"1 1.5 2 2.5"
			}
				"06"
			{
				"var_type"				"FIELD_INTEGER"
				"sp"					"1400"
			}
		}
	}



"ice_path"
	{
			"BaseClass"	"ability_lua"
		"AbilityTextureName"	"jakiro_ice_path"
		"ScriptFile"	"heros/hero_jakiro/ice_path.lua"								// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Jakiro.IcePath"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1500"
		"AbilityCastPoint"				"0.65"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"12"

		// Damage.
		//-------------------------------------------------------------------------------------------------------------
		"AbilityDamage"					"0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
		"precache"
		{
			"particle"	"particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path.vpcf"
			"particle"	"particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path_b.vpcf"
			"particle"	"particles/econ/events/ti9/high_five/high_five_impact_snow.vpcf"
			"particle"	"particles/status_fx/status_effect_frost_lich.vpcf"
			"particle"	"particles/generic_gameplay/generic_frozen.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"dis"					"1500"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"wh"					"300"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"stun"					"1 1.5 2 2.5"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"dam"					"150 200 250 300"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"b_count"					"6"
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"b_i"					"0.2"
			}
			"07"
			{
				"var_type"					"FIELD_FLOAT"
				"b_dis"					"300"
			}
			"08"
			{
				"var_type"					"FIELD_FLOAT"
				"b_rd"					"350"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}





	"macropyre"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"jakiro_macropyre"
		"ScriptFile"	"heros/hero_jakiro/macropyre.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Jakiro.Macropyre.Cast"
		"HasScepterUpgrade"   			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0.55"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"80"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"220 330 440"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf"
			"particle"	"particles/econ/items/jakiro/jakiro_ti10_immortal/jakiro_ti10_macropyre.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"damage"					"100 175 250"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"cast_range"				"1400 1600 1800"
			}

			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"path_radius"				"280"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"duration"					"10 15 20"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"burn_interval"				"1"
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"dmg"					"50 100 150"
			}
			"10"
			{
				"var_type"					"FIELD_FLOAT"
				"hp"					"10 15 20"
			}
		}
	}







//亚巴顿

	"death_coil"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"abaddon_death_coil"
		"ScriptFile"	"heros/hero_abaddon/death_coil.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_CREEP"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES_ENEMIES_NO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Abaddon.DeathCoil.Cast"

		"HasShardUpgrade"				"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"800"
		"AbilityCastPoint"				"0.1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"10"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50"
		"precache"
		{
			"particle"	"particles/econ/items/abaddon/abaddon_alliance/abaddon_death_coil_alliance.vpcf"
			"particle"	"particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"
			"particle"	"particles/econ/events/ti7/radiance_owner_ti7_smoke.vpcf"
			"particle"	"particles/dark_smoke_test.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"damage"				"100 200 300 400"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"heal"				"100 200 300 400"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"buffdur"					"3"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"debuffdur"					"3"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"ch"					"50"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"aphotic_shield"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"abaddon_aphotic_shield"
		"ScriptFile"	"heros/hero_abaddon/aphotic_shield.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		//"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Abaddon.AphoticShield.Cast"
		"HasShardUpgrade"				"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"800"
		"AbilityCastPoint"				"0.1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"11 10 9 8"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 105 110 115"

		"precache"
		{
			"particle"	"particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"10.0"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"damage_absorb"			"200 300 400 500"
				"LinkedSpecialBonus"	"special_bonus_abaddon_5"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"500"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"hp"					"4"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"frostmourne"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"abaddon_frostmourne"
		"ScriptFile"	"heros/hero_abaddon/frostmourne.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf"
			"particle"	"particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf"
			"particle"	"particles/status_fx/status_effect_abaddon_frostmourne.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_FLOAT"
				"slow_duration"				"5"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"movement_speed"				"10 15 20 25"
					"LinkedSpecialBonus"			"special_bonus_abaddon_2"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"hit_count"					"3"
			}
			"04"
			{
				"var_type"						"FIELD_FLOAT"
				"curse_duration"				"4.5"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"curse_slow"				"15 30 45 60"
							"LinkedSpecialBonus"			"special_bonus_abaddon_2"
			}
			"06"
			{
				"var_type"						"FIELD_INTEGER"
				"curse_attack_speed"			"40 60 80 100"

			}
			"07"
			{
				"var_type"						"FIELD_INTEGER"
				"hp"							"4"
			}
			"08"
			{
				"var_type"						"FIELD_INTEGER"
				"ch"							"15"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"borrowed_time"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"abaddon_borrowed_time"
		"ScriptFile"	"heros/hero_abaddon/borrowed_time.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Abaddon.BorrowedTime"
		"HasScepterUpgrade"				"1"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"
		"AbilityCastGestureSlot"				"ABSOLUTE"
		"AbilityCastRange"				"700"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"40"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0 0 0"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf"
			"particle"	"particles/status_fx/status_effect_abaddon_borrowed_time.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"hp_threshold"				"600"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"4 5 6"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"duration_scepter"				"7"
				"RequiresScepter"	"1"
			}
		}
	}




//+2迷雾持续时间
	"special_bonus_abaddon_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"
				"ad_linked_ability"			"death_coil"
			}
		}
	}
	//+10%魔霭诅咒减速
	"special_bonus_abaddon_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
				"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"10"
				"ad_linked_ability"			"frostmourne"
			}
		}
	}

	//范围型迷雾缠绕（300码）
	"special_bonus_abaddon_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//对友军释放无光之盾自身也会获得
	"special_bonus_abaddon_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//+300无光之盾
	"special_bonus_abaddon_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"300"
				"ad_linked_ability"			"aphotic_shield"
			}
		}
	}

	//+1无光之盾充能
	"special_bonus_abaddon_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"
				"ad_linked_ability"			"aphotic_shield"
			}
		}
	}


	//+15%诅咒概率
	"special_bonus_abaddon_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
						"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"15"
				"ad_linked_ability"			"frostmourne"
			}
		}
	}

	//圣水洗礼的效果会同时触发
	"special_bonus_abaddon_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}







	//复仇之魂
	"magic_missile"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"vengefulspirit_magic_missile"
		"ScriptFile"	"heros/hero_vengefulspirit/magic_missile.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_VengefulSpirit.MagicMissile"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"550"
		"AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"12 11 10 9"
		"HasScepterUpgrade"			"1"
		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 110 120 130"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"magic_missile_speed"	"2000"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"magic_missile_stun"	"1.4 1.5 1.6 1.7"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"magic_missile_damage"	"100 150 200 250"
				"LinkedSpecialBonus"	"special_bonus_vengefulspirit_5"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"				"600"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"mana"				"1000"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


	"command_aura"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"vengefulspirit_command_aura"
		"ScriptFile"	"heros/hero_vengefulspirit/command_aura.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1200"

		"HasScepterUpgrade"			"1"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"bonus_base_damage"	"5"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"wave_of_terror"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"vengefulspirit_wave_of_terror"
		"ScriptFile"	"heros/hero_vengefulspirit/wave_of_terror.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_VengefulSpirit.WaveOfTerror"
		"HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1500"
		"AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"6"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"25 30 35 40"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_FLOAT"
				"wave_speed"		"2000.0"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"wave_width"		"325"
			}
			"03"
			{
				"var_type"			"FIELD_INTEGER"
				"armor_reduction"		"-5 -6 -7 -8"
				"LinkedSpecialBonus"	"special_bonus_vengefulspirit_6"
			}
			"04"
			{
				"var_type"			"FIELD_FLOAT"
				"vision_aoe"		"350"
			}
			"05"
			{
				"var_type"			"FIELD_FLOAT"
				"duration"			"8"
			}
			"06"
			{
				"var_type"			"FIELD_FLOAT"
				"dis"			"1500"
			}
			"07"
			{
				"var_type"			"FIELD_FLOAT"
				"sp"			"-50"
			}
			"08"
			{
				"var_type"			"FIELD_FLOAT"
				"sp_dur"			"2"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}



	"nether_swap"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"vengefulspirit_nether_swap"
		"ScriptFile"	"heros/hero_vengefulspirit/nether_swap.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetFlags"			"DOTA_UNIT_TARGET_FLAG_INVULNERABLE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_VengefulSpirit.NetherSwap"
		 "HasShardUpgrade"               "1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1300 1400 1500"
		"AbilityCastPoint"				"0.2"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"20"
		"HasScepterUpgrade"			"1"
		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 150 200"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf"
			"particle"	"particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"radius"				"700"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"cast"				"1300 1400 1500"
			}
			"03"
			{
				"var_type"			"FIELD_FLOAT"
				"root"				"2 2.5 3"
			}
		}
	}

	"vs_return"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"vs_return"
		"ScriptFile"	"heros/hero_vengefulspirit/vs_return.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"MaxLevel"	"1"
		"AbilityCooldown"				"1"
		"AbilityManaCost"				"100"
	}

	//魔法箭无视魔法免疫
	"special_bonus_vengefulspirit_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}
	//+500魔法箭施法距离
	"special_bonus_vengefulspirit_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"500"
				"ad_linked_ability"			"magic_missile"
			}
		}
	}

	//-5秒移形换位冷却
	"special_bonus_vengefulspirit_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"5"
				"ad_linked_ability"			"nether_swap"
			}
		}
	}

	//恐怖波动触发攻击特效
	"special_bonus_vengefulspirit_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//+100魔法箭伤害
	"special_bonus_vengefulspirit_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"100"
				"ad_linked_ability"			"magic_missile"
			}
		}
	}

	//+4恐怖被动减甲
	"special_bonus_vengefulspirit_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"-4"
				"ad_linked_ability"			"wave_of_terror"
			}
		}
	}


	//返回0CD
	"special_bonus_vengefulspirit_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}




	//祸乱
	"enfeeble"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"bane_enfeeble"
		"ScriptFile"	"heros/hero_bane/enfeeble.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"					"Hero_Bane.Enfeeble"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.3"
		"AbilityCastRange"				"1000"
		"AbilityCastAnimation"		"ACT_DOTA_ENFEEBLE"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"16 15 14 13"


		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"40 50 60 70"

		"precache"
		{
			"particle"	"particles/tgp/soul_m.vpcf"
			"particle"	"particles/tgp/ghost_m.vpcf"
			"particle"	"particles/units/heroes/hero_bane/bane_enfeeble.vpcf"

		}

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"damage_reduction"					"10 15 20 25"
			}
			"02"
			{
				"var_type"						"FIELD_FLOAT"
				"duration"						"9"
			}
			"03"
			{
				"var_type"						"FIELD_FLOAT"
				"radius"						"500"
			}
			"04"
			{
				"var_type"						"FIELD_FLOAT"
				"num"						"1"
			}
			"05"
			{
				"var_type"						"FIELD_FLOAT"
				"dmg"						"10 11 12 13"
			}
		}
	}


	"brain_sap"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"bane_brain_sap"
		"ScriptFile"	"heros/hero_bane/brain_sap.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PURE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Bane.BrainSap"
       		"HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.3"
		"AbilityCastRange"				"1000"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"4"


		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 120 140 160"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_bane/bane_sap.vpcf"

		}


		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"brain_sap_damage"				"100 200 300 400"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"400"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"fiends_grip"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"bane_fiends_grip"
		"ScriptFile"	"heros/hero_bane/fiends_grip.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_CHANNELLED"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PURE"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Bane.FiendsGrip"



		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0.3"
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"40"
		"AbilityCharges"				"1"
		"AbilityChargeRestoreTime"			"40"


		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"200 300 400"
		"precache"
		{
			"particle"	"particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf"
			"particle"	"particles/tgp/claw_m.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_FLOAT"
				"interval"							"0.5"
			}
			"02"
			{
				"var_type"						"FIELD_FLOAT"
				"duration"						"3.5 4 4.5"
			}
			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"dmg"							"100 150 200"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"mana"							"100"
			}
			"05"
			{
				"var_type"						"FIELD_INTEGER"
				"sp"							"30 40 50"
			}
			"06"
			{
				"var_type"						"FIELD_INTEGER"
				"dis"							"800"
			}
		}
	}


	"nightmare"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"bane_nightmare"
		"ScriptFile"	"heros/hero_bane/nightmare.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AUTOCAST  | DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_Bane.Nightmare"
		 "HasShardUpgrade"               "1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"20 19 18 17 16"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"200"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"		"0.5"	// Applies two modifiers

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"dmg"						"30 35 40 45"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"3 4 5 6"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	//移除虚弱缠身的数量限制
	"special_bonus_bane_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//缠身附带1秒缠绕
	"special_bonus_bane_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//移除蚀脑的施法前摇
	"special_bonus_bane_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//虚弱使受到的伤害提高15%
	"special_bonus_bane_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//噩梦使友军移速提高30%
	"special_bonus_bane_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//蚀脑会恢复伤害20%的魔法
	"special_bonus_bane_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//梦魇
	"special_bonus_bane_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//祸乱
	"special_bonus_bane_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}



	//屠夫
	"meat_hook"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"pudge_meat_hook"
		"ScriptFile"	"heros/hero_pudge/meat_hook.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AUTOCAST  | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PURE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Pudge.AttackHookExtend"
		"HasScepterUpgrade"             "1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1400"
		"AbilityCastPoint"				"0.2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"14 13 12 11"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"125 130 135 140"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_pudge/pudge_meathook.vpcf"
			"particle"	"particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf"
			"model"	"models/heroes/pudge_cute/pudge_cute.vmdl"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"							"FIELD_INTEGER"
				"damage"							"100 200 300 400"
			}
			"02"
			{
				"var_type"							"FIELD_FLOAT"
				"hook_speed"							"2000"
			}
			"03"
			{
				"var_type"							"FIELD_INTEGER"
				"hook_width"							"100"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"hook_distance"					"1400"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"vision_radius"				"500 500 500 500"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"hook_rg"					"50"
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"hook_max"					"3000"
			}
			"08"
			{
				"var_type"					"FIELD_INTEGER"
				"dmg"					"30"
			}
			"09"
			{
				"var_type"					"FIELD_INTEGER"
				"acd"					"5"
			}
			"10"
			{
				"var_type"					"FIELD_INTEGER"
				"heal"					"5"
			}
			"11"
			{
				"var_type"					"FIELD_FLOAT"
				"hook_speed1"				"1500"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	"flesh_heap"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"pudge_flesh_heap"
		"ScriptFile"				"heros/hero_pudge/flesh_heap.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"16"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_pudge/pudge_fleshheap_count.vpcf"
			"particle"	"particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf"
			"particle"	"particles/tgp/pudge/status_effect_jason.vpcf"
			"particle"	"particles/econ/items/pudge/pudge_ti10_immortal/pudge_ti10_immortal_meathook.vpcf"
			"particle"	"particles/units/heroes/hero_pudge/pudge_swallow_release.vpcf"

		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"magic_resistance"				"10 15 20 25"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"flesh_heap_strength_buff_amount"		"1 2 3 4"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"flesh_heap_range"				"500"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"hook_speed"				"1300"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"hook_distance"				"1300"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"hook_width"				"150"
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"vision_radius"				"500"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"prot"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"pudge_rot"
		"ScriptFile"	"heros/hero_pudge/prot.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_TOGGLE | DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"				"1"
		"AbilityCastRange"				"300"
		 "HasShardUpgrade"               			"1"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_pudge/pudge_rot.vpcf"
			"particle"	"particles/tgp/pudge/fart_m.vpcf"
		}

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"rot_radius"			"300"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"rot_tick"				"1"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"rot_slow"				"-14 -20 -26 -32"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"rot_damage"			"70 90 110 130"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"rd"				"600"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"maxstack"			"5 4 3 2"
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"hp"				"1.5"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}



	"dismember"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"pudge_dismember"
		"ScriptFile"				"heros/hero_pudge/dismember.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_CHANNELLED | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetTeam"				"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"FightRecapLevel"				"2"

		"HasShardUpgrade"			"1"
		"AbilityDraftPreAbility"		"pudge_eject"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"160"
		"AbilityCastPoint"				"0"
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_4"
		"AbilityChannelAnimation"		"ACT_DOTA_CHANNEL_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityChannelTime"			"3.0 3.0 3.0"
		"AbilityCooldown"				"30 25 20"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 130 170"
		"precache"
		{
			"particle"	"particles/econ/items/pudge/pudge_arcana/default/pudge_arcana_dismember_bloom_default.vpcf"
			"particle"	"particles/heros/axe/shake.vpcf"
			"particle"	"particles/units/heroes/hero_pudge/pudge_swallow.vpcf"
			"particle"	"particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_motor.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"dismember_damage"		"30 70 110"
				"CalculateSpellDamageTooltip"		"1"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"strength_damage"			"0.3 0.6 0.9"
				"CalculateSpellDamageTooltip"		"0"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"ticks"				"0.5"
			}
			"08"
			{
				"var_type"				"FIELD_INTEGER"
				"duration_tooltip"			"3"
			}
			"09"
			{
				"var_type"				"FIELD_INTEGER"
				"duration"				"7"
			}
			"10"
			{
				"var_type"				"FIELD_INTEGER"
				"rs"				"50"
			}
			"11"
			{
				"var_type"				"FIELD_INTEGER"
				"sp"				"50"
			}
			"12"
			{
				"var_type"				"FIELD_INTEGER"
				"num"				"4"
			}
		}
	}



	//开膛手附带200点魔法伤害
	"special_bonus_pudge_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//开膛手继承A杖加血效果
	"special_bonus_pudge_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//腐烂效果下目标无法闪避
	"special_bonus_pudge_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//腐烂降低目标15%的吸血与治疗
	"special_bonus_pudge_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//肢解额外对目标300范围随机单位释放
	"special_bonus_pudge_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//肢解释放完毕后还会获得90点攻击速度
	"special_bonus_pudge_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//杰森
	"special_bonus_pudge_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//继承者
	"special_bonus_pudge_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}








//火女
"dragon_slave"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"lina_dragon_slave"
		"ScriptFile"				"heros/hero_lina/dragon_slave.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Hero_Lina.DragonSlave"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1100"
		"AbilityCastPoint"				"0.5"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"					"9 8 7 6"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 120 140 160"
		"precache"
		{
			"particle"	"particles/econ/items/lina/lina_head_headflame/lina_spell_dragon_slave_headflame.vpcf"
			"particle"	"particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf"
			"particle"	"particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"dragon_slave_speed"			"1400"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"dragon_slave_width"			"250"
			}

			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"dragon_slave_distance"			"1100"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"damage"					"200 250 300 350"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"array_rd"					"300"
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"array_stun"				"0.5"
			}
			"07"
			{
				"var_type"					"FIELD_FLOAT"
				"cast"					"0.5"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


"light_strike_array"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"lina_light_strike_array"
		"ScriptFile"				"heros/hero_lina/light_strike_array.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"AbilitySound"				"Ability.LightStrikeArray"

		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0.5"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"9 8 7 6"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 120 140 160"
		"precache"
		{
			"particle"	"particles/econ/items/lina/lina_ti7/light_strike_array_pre_ti7.vpcf"
			"particle"	"particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"light_strike_array_aoe"			"275"
			}

			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"light_strike_array_stun_duration"		"0.8"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"light_strike_array_damage"			"150 200 250 300"
				"LinkedSpecialBonus"			"special_bonus_lina_2"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"cast"					"0.5"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"num"					"4"
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"knock"					"0.5"
			}
			"07"
			{
				"var_type"					"FIELD_FLOAT"
				"wh"					"100"
			}
			"08"
			{
				"var_type"					"FIELD_FLOAT"
				"rg"					"1000"
			}
		}
		"AbilityCastAnimation"					"ACT_DOTA_CAST_ABILITY_2"
	}


	"fiery_soul"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"lina_fiery_soul"
		"ScriptFile"				"heros/hero_lina/fiery_soul.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"

		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0.5"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_2"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"12"
		"precache"
		{
			"particle"	"particles/tgp/lina/bird_m.vpcf"
			"particle"	"particles/heros/axe/shake.vpcf"
		}
		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 120 140 160"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"fiery_soul_attack_speed_bonus"	"10 20 30 40"
			}
			"02"
			{
				"var_type"						"FIELD_FLOAT"
				"fiery_soul_move_speed_bonus"	"8"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"fiery_soul_max_stacks"		"3"
				"LinkedSpecialBonus"		"special_bonus_lina_1"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"cast_time"			"20"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"				"400"
			}
		}
	}


"laguna_blade"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"lina_laguna_blade"
		"ScriptFile"				"heros/hero_lina/laguna_blade.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetFlags"			"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"							// Changes dynamically with scepter
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Ability.LagunaBladeImpact"

		"HasShardUpgrade"               "1"
		"HasScepterUpgrade"             "1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0.5"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"60 56 52"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"250 400 550"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.0"	// Modifier just delays damage
		"precache"
		{
			"particle"	"particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade.vpcf"
			"particle"	"particles/units/heroes/hero_lina/lina_spell_laguna_blade_shard_units_hit.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"damage"					"400 550 700"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"					"500"
			}

		}
	}



	//炽魂层数+1
	"special_bonus_lina_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"
				"ad_linked_ability"			"fiery_soul"
			}
		}
	}

	//+100光击阵伤害
	"special_bonus_lina_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"100"
				"ad_linked_ability"			"light_strike_array"
			}
		}
	}

	//炽魂每层+40施法距离
	"special_bonus_lina_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//普攻附带40%智力魔法伤害（炽魂）
	"special_bonus_lina_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//神灭斩对主目标造成的伤害30%治疗自身
	"special_bonus_lina_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//+0.5秒光击阵击飞时间
	"special_bonus_lina_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0.5"
				"ad_linked_ability"			"light_strike_array"
			}
		}
	}


	//神灭斩击杀目标则不消耗魔法
	"special_bonus_lina_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//神灭斩无视林肯莲花
	"special_bonus_lina_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}






	//猛犸
	"shockwave"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"magnataur_shockwave"
		"ScriptFile"				"heros/hero_magnataur/shockwave.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"				"1"

        		"HasShardUpgrade"               "1"
		"HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1300 1400 1500 1600"
		"AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"11 10 9 8"
		"AbilityDuration"				"0.6875 0.6875 0.6875 0.6875"


		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"80 90 100 110"
		"precache"
		{
			"particle"	"particles/econ/items/magnataur/shock_of_the_anvil/magnataur_shockanvil.vpcf"
			"particle"	"particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"shock_speed"				"1800"
			}

			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"shock_width"				"250"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"shock_damage"				"75 150 225 300"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"shock_distance"				"1300 1400 1500 1600"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"damageperc"				"5 7 9 11"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}



	"empower"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"magnataur_empower"
		"ScriptFile"				"heros/hero_magnataur/empower.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_Magnataur.Empower.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"800"
		"AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"8"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"35 45 55 65"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.3"
		"precache"
		{
			"particle"	"particles/tgp/magnataur/cleave_m.vpcf"
			"particle"	"particles/units/heroes/hero_magnataur/magnataur_empower.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"empower_duration"		"35"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"bonus_damage_pct"		"10 20 30 40"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"cleave_damage_pct"		"20 30 40 50"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"cleave_rd"			"340"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"skewer"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"magnataur_skewer"
		"ScriptFile"				"heros/hero_magnataur/skewer.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AUTOCAST | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Magnataur.Skewer.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.3 0.3 0.3 0.3"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"14"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"80 80 80 80"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"skewer_speed"			"1500"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"range"				"1000 1100 1200 1300"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"skewer_radius"			"150"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"skewer_damage"			"80 170 260 350"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"dur"					"6"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"reverse_polarity"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"magnataur_reverse_polarity"
		"ScriptFile"				"heros/hero_magnataur/reverse_polarity.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Magnataur.ReversePolarity.Cast"

		"AbilityDraftUltShardAbility"		"magnataur_horn_toss"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.3 0.3 0.3"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		"AbilityCooldown"				"110 105 100"
		"AbilityManaCost"				"150 225 300"
		"AbilityCastRange"				"00"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.5"	// Applies multiple modifiers
		"precache"
		{
			"particle"	"particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf"
			"particle"	"particles/tgp/whirlwind/whirlwind_m.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"pull_radius"			"500 550 600"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"polarity_damage"			"300 450 600"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"pull_duration"			"2 3 4"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"stun"				"1 1.5 2"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"dis"				"400 500 600"
			}
		}
	}



	//提高震荡波的距离和速度
	"special_bonus_magnataur_1"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//授予力量友军也变为纯粹伤害
	"special_bonus_magnataur_2"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//移除巨角冲撞施法前摇
	"special_bonus_magnataur_3"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//授予力量额外提高50攻击距离
	"special_bonus_magnataur_4"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//授予力量额外提高60施法距离
	"special_bonus_magnataur_5"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//巨角冲撞途中获得30%伤害减免
	"special_bonus_magnataur_6"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//两极反转中的磁场范围提高至全图
	"special_bonus_magnataur_7"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//提高30%体型
	"special_bonus_magnataur_8"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}




	//炼金
	"acid_spray"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"alchemist_acid_spray"
		"ScriptFile"				"heros/hero_alchemist/acid_spray.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.2"
		"AbilityCastRange"				"900"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"22.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50 80 110 140"
		"precache"
		{
			"particle"	"particles/tgp/alchemist/msg_gold.vpcf"
			"particle"	"particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"475 525 575 625"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"16"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"40 50 60 70"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"armor_reduction"			"5 6 7 8"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"tick_rate"				"1.0"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"gold"				"2 3 4 5"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	"unstable_concoction_throw"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"alchemist_unstable_concoction"
		"ScriptFile"				"heros/hero_alchemist/unstable_concoction_throw.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetFlags"			"DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"775"
		"AbilityCastPoint"				"0.2"
  		"AbilityCastAnimation"			"ACT_DOTA_ALCHEMIST_CONCOCTION_THROW"
		"AbilityCooldown"				"16"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportBonus"	"120"
		"AbilityManaCost"			"100"
		"precache"
		{
			"particle"	"particles/econ/items/alchemist/alchemist_smooth_criminal/alchemist_smooth_criminal_unstable_concoction_projectile.vpcf"
			"particle"	"particles/generic_gameplay/generic_stunned.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"dmg"					"150 200 250 300"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"stun"					"0.5 0.8 1.1 1.4"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"dur"					"10"
			}
		}
	}


	"goblins_greed"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"alchemist_goblins_greed"
		"ScriptFile"				"heros/hero_alchemist/goblins_greed.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"800"
		"AbilityCastPoint"				"0"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_2"
		"AbilityCooldown"				"10"
		"AbilityManaCost"			"25"
		"precache"
		{
				"model"	"models/props_gameplay/treasure_chest_gold.vmdl"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"egold"				"3 4 5 6"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"max"				"10 20 30 40"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}


	"chemical_rage"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"alchemist_chemical_rage"
		"ScriptFile"				"heros/hero_alchemist/chemical_rage.lua"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Alchemist.ChemicalRage.Cast"

		"AbilityDraftUltShardAbility"  			"alchemist_berserk_potion"


		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.0"
		"AbilityCastAnimation"			"ACT_INVALID"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"55.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"			"100 200 300"

		"AbilityCastAnimation"		"ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_START"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf"
			"particle"	"particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"25.0"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"base_attack_time"		"1.2 1.1 1.0"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"bonus_health_regen"	"50 75 100"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"bonus_movespeed"		"40 50 60"
			}
		}
	}


	//酸性喷雾额外造成15%减速
	"special_bonus_alchemist_1"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//不稳定化合物弹射1次
	"special_bonus_alchemist_2"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//提高10%符文拾取的金钱
	"special_bonus_alchemist_3"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//化学狂暴额外获得8点护甲
	"special_bonus_alchemist_4"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//化学狂暴额外获得20%状态抗性
	"special_bonus_alchemist_5"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}

	//金钱箱数量+1
	"special_bonus_alchemist_6"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
	}


	//额外降低化学狂暴0.1攻击间隔
	"special_bonus_alchemist_7"
	{
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0.1"
				"ad_linked_ability"			"chemical_rage"
			}
		}
	}


	// =================================================================================================================
	//
	//
	//
	// 								毒瘤英雄
	//
	//
	//
	// =================================================================================================================

///////////////////////////////
// MARS ↓
//////////////////////////////

"dlmars_bulwark"    //护身甲盾，龟壳流弹
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"dl/dlmars/dlmars_bulwark/dlmars_bulwark.lua"
		"AbilityTextureName"			"mars_bulwark"
		"FightRecapLevel"				"1"
		"MaxLevel"						"4"
		"precache"
		{
			//"particle"	"particles/units/heroes/hero_mars/mars_shield_of_mars.vpcf"
			//"particle"	"particles/units/heroes/hero_mars/mars_shield_of_mars_small.vpcf"
		}

		"AbilityType"					"DOTA_ABILITY_TYPE_BASIC"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_TOGGLE"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_2"

		// Special
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"	//表技能数据，只对流弹角度判断有用，反弹角度为这个值的两倍。原版里技能数值去override改
				"bangbangangle"					"80"
			}
			"02"	//反弹概率	唯一有用的
			{
				"var_type"						"FIELD_INTEGER"
				"bangbangchance"					"100 100 100 100"
			}
			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"bangbangspeed"					"2000"	//投射物速度
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"bangbangradius"					"2000"	//反弹索敌半径
			}
            "05"
			{
				"var_type"						"FIELD_INTEGER"
				"physical_damage_reduction"		"40 50 60 70"	//tooltip，单纯显示用，实际数值去override里调
			}
			"06"
			{
				"var_type"						"FIELD_INTEGER"
				"physical_damage_reduction_side"	"20 30 40 50"	//tooltip，单纯显示用，实际数值去override里调
			}
		}
	}

	"special_bonus_dlmars_20r"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"		//流弹附加力量值纯粹伤害，此值无用
			}
		}
		"LinkedAbility"
		{
			"01"	"dlmars_bulwark"
		}
	}

	"special_bonus_dlmars_20l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"		//+1流弹目标，此值无用
			}
		}
		"LinkedAbility"
		{
			"01"	"dlmars_bulwark"
		}
	}

	////////////////////////////////////////

	"dlmars_rebuke"     //神之遣戒，盾击滑行
	{
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"						"ability_lua"
		"ScriptFile"					"dl/dlmars/dlmars_rebuke/dlmars_rebuke.lua"
		"AbilityTextureName"			"mars_gods_rebuke"
		"FightRecapLevel"				"1"
		"MaxLevel"						"4"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_mars.vsndevts"
			"particle"	"particles/units/heroes/hero_mars/mars_shield_bash.vpcf"
			"particle"	"particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf"
			"particle"	"particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf"
		}

		// Ability General
		//-------------------------------------------------------------------------------------------------------------
		"AbilityType"					"DOTA_ABILITY_TYPE_BASIC"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AUTOCAST | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_NORMAL_WHEN_STOLEN"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"

		// Ability Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"0"
		"AbilityCastPoint"				"0.2"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Ability Resource
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"8"
		"AbilityManaCost"				"55 60 65 70"

		// Damage
		//-------------------------------------------------------------------------------------------------------------

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"rebuke_radius"					"500"	//打击半径
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"rebuke_angle"						"140"	//打击角度，左右共140
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"rebuke_damage"					"35 50 75 100"	//额外攻击力
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"rebuke_crit"				"350"		//暴击倍率
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"rebuke_rushspeed"			"1000"		//冲击盾 速度
			}
			"08"
			{
				"var_type"					"FIELD_INTEGER"
				"rebuke_rushrange"			"360 420 480 540"	//冲击盾 距离
			}
			"09"
			{
				"var_type"					"FIELD_INTEGER"
				"rebuke_tree"				"200"		//沿途破树半径
			}
			"10"
			{
				"var_type"					"FIELD_INTEGER"
				"rebuke_kbdis"				"150"		//击退距离
			}
			"11"
			{
				"var_type"					"FIELD_FLOAT"
				"rebuke_kbdur"				"0.2"				//击飞时间
			}
			"12"
			{
				"var_type"					"FIELD_FLOAT"
				"rebuke_debuffdur"			"2.4"		//减速持续时间，强制面向时间为此值一半
			}
		}
	}

	"special_bonus_dlmars_15r"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"		//360冲击盾 距离，此值无用
			}
		}
		"LinkedAbility"
		{
			"01"	"dlmars_rebuke"
		}
	}

	"special_bonus_dlmars_15l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"		//360环形炖鸡，此值无用
			}
		}
		"LinkedAbility"
		{
			"01"	"dlmars_rebuke"
		}
	}

	////////////////////////////////

	"aghsfort_mars_spear"
    {
        // General
        //-------------------------------------------------------------------------------------------------------------
        "AbilityTextureName"            "mars_spear"
        "AbilityBehavior"               "DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_DIRECTIONAL | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
        "AbilityUnitDamageType"         "DAMAGE_TYPE_MAGICAL"
        "SpellImmunityType"             "SPELL_IMMUNITY_ENEMIES_NO"
        "SpellDispellableType"          "SPELL_DISPELLABLE_YES_STRONG"
        "AbilityUnitTargetTeam"         "DOTA_UNIT_TARGET_TEAM_ENEMY"
        "AbilityUnitTargetType"         "DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
        "FightRecapLevel"               "1"
        "AbilitySound"                  "Hero_Mars.Spear.Cast"
		"HasShardUpgrade"               "1"

        // Casting
        //-------------------------------------------------------------------------------------------------------------
        "AbilityCastPoint"              "0.25"

        // Time
        //-------------------------------------------------------------------------------------------------------------
        "AbilityCooldown"               "9"

        // Cost
        //-------------------------------------------------------------------------------------------------------------
        "AbilityManaCost"               "100"

        // Special
        //-------------------------------------------------------------------------------------------------------------
        "AbilitySpecial"
        {
            "01"
            {
                "var_type"              "FIELD_INTEGER"
                "damage"                "100 200 300 400"
                "LinkedSpecialBonus"    "special_bonus_unique_mars_spear_bonus_damage"
            }
            "02"
            {
                "var_type"          "FIELD_FLOAT"
                "spear_speed"       "1400"
            }
            "03"
            {
                "var_type"          "FIELD_INTEGER"
                "spear_width"       "125"
            }
            "04"
            {
                "var_type"          "FIELD_INTEGER"
                "spear_vision"      "300"
            }
            "05"
            {
                "var_type"          "FIELD_INTEGER"
                "spear_range"       "900 1000 1100 1200"
            }
            "06"
            {
                "var_type"              "FIELD_FLOAT"
                "activity_duration"     "1.7"
            }
            "07"
            {
                "var_type"          "FIELD_FLOAT"
                "stun_duration"     "1.6 2.0 2.4 2.8"
                "LinkedSpecialBonus"    "special_bonus_unique_mars_spear_stun_duration"
            }
            "08"
            {
                "var_type"              "FIELD_FLOAT"
                "knockback_duration"    "0.25"
            }
            "09"
            {
                "var_type"              "FIELD_FLOAT"
                "knockback_distance"    "75"
            }
			"10"
            {
                "var_type"              "FIELD_INTEGER"
                "skewer_count"          "7"			//tooltip显示用
            }
             "11"
            {
                "var_type"              "FIELD_INTEGER"
                "explosion_damage"      "400"		//tooltip显示用
            }
			"12"
            {
                "var_type"              "FIELD_FLOAT"
                "trail_duration"                  "4"	//tooltip显示用
            }
        }
        "AbilityCastAnimation"      "ACT_DOTA_CAST_ABILITY_5"
    }

	"aghsfort_special_mars_spear_multiskewer"
    {
        // General
        //-------------------------------------------------------------------------------------------------------------
        "AbilityBehavior"               "DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_HIDDEN"
        "AbilityTextureName"            "mars_spear"
        "AbilitySpecial"
        {
            "01"
            {
                "var_type"              "FIELD_INTEGER"
                "value"                  "7"
            }
        }
	}

	"aghsfort_special_mars_spear_impale_explosion"
    {
        // General
        //-------------------------------------------------------------------------------------------------------------
        "AbilityBehavior"               "DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_HIDDEN"
        "AbilityTextureName"            "mars_spear"
        "AbilitySpecial"
        {
            "01"
            {
                "var_type"              "FIELD_INTEGER"
                "value"                  "400"
            }
        }
    }

	"aghsfort_special_mars_spear_burning_trail"
    {
        // General
        //-------------------------------------------------------------------------------------------------------------
        "AbilityBehavior"               "DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_HIDDEN"
        "AbilityTextureName"            "mars_spear"
        "AbilitySpecial"
        {
            "01"
            {
                "var_type"              "FIELD_FLOAT"
                "trail_duration"                  "4"
            }
            "02"
            {
                "var_type"              "FIELD_INTEGER"
                "damage_pct"                  "15"
            }
            "03"
            {
                "var_type"              "FIELD_INTEGER"
                "path_radius"                  "150"
            }
              "04"
            {
                "var_type"              "FIELD_FLOAT"
                "linger_duration"                  "0.2"
            }
            "05"
            {
                "var_type"              "FIELD_FLOAT"
                "burn_interval"                  "0.5"
            }
        }
    }

	"dlmars_controller"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"book_of_intelligence"
		"ScriptFile"	"dl/dlmars/dlmars_controller/dlmars_controller.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_HIDDEN"	//DOTA_ABILITY_BEHAVIOR_HIDDEN
		"MaxLevel"	"1"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_3"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{

		}
	}


/////////////////////////////////





////////////////////////////////
//OLDSKY 老天怒 ↓
//////////////////////////////

"oldsky_abolt"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"skywrath_mage_arcane_bolt"
		"ScriptFile"	"dl/oldsky/oldsky_abolt/oldsky_abolt.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"AbilityCastPoint"	"0.1"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_1"
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"HasScepterUpgrade"				"1"
		"HasShardUpgrade"				"1"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"5.0 4.0 3.0 2.0"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"120"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"800"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"particle"	"particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf"
			"particle"	"particles/dlparticles/oldsky_abolt/green_p_skywrath_mage_arcane_bolt.vpcf"	//自改
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"abolt_speed"	"900"	//投射物速度
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"abolt_visionrad"	"200"	//投射物视野半径
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"abolt_visiondur"	"1.5"	//投射物视野持续时间
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"abolt_range"	"700 800 900 1000"	//施法距离（A杖获取第二目标用）
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"abolt_stackdur"	"8.0"	//叠层持续时间
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"abolt_intco"	"1"	//总智力伤害系数
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"abolt_intco_stack"	"0.1"	//每层总智力伤害系数增加
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"abolt_damage"	"40 60 80 100"	//基础伤害
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"abolt_stackint"	"1"	//每层增加智力
			}
		}
	}

	"special_bonus_oldsky_25r"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"		//判定值，并非额外C的数量
			}
		}
		"LinkedAbility"
		{
			"01"	"oldsky_abolt"
		}
	}

	///////////////////////

	"oldsky_cshot"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"skywrath_mage_concussive_shot"
		"ScriptFile"	"dl/oldsky/oldsky_cshot/oldsky_cshot.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetFlags"	"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES | DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS | DOTA_UNIT_TARGET_FLAG_NO_INVIS"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"AbilityCastPoint"	"0"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_2"
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"HasScepterUpgrade"				"1"
		//"HasShardUpgrade"				"1"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"12"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"95"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"1500"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts"
			"particle"	"particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot.vpcf"
			"particle"	"particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot_slow_debuff.vpcf"
			"particle"	"particles/dlparticles/oldsky_cshot/green_p_skywrath_mage_concussive_shot.vpcf"	//自改
			"particle"	"particles/dlparticles/oldsky_cshot/slow_meepo_divining_rod_poof_end_explosion_ring.vpcf"	//自改
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"cshot_radius"	"1700 1800 1900 2000"	//索敌半径
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"cshot_speed"	"750 800 850 900"	//投掷物速度
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"cshot_visionrad"	"400"	//投射物视野半径
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"cshot_dmgrad"	"200"	//伤害半径,同时也是发射环半径
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"cshot_slowdur"	"2"	//减速持续时间，同时也是发射环持续时间
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"cshot_damage"	"60 120 180 240"	//技能伤害
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"cshot_slowpercent"	"30 35 40 45"	//百分比减速
			}
			"08"
			{
				"var_type"	"FIELD_FLOAT"
				"cshot_interval"	"1.0"	//发射环触发间隔
			}
		}
	}

	"special_bonus_oldsky_25l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"		//判定值，并非额外光蛋的数量
			}
		}
		"LinkedAbility"
		{
			"01"	"oldsky_cshot"
		}
	}

/////////////////////////

	"oldsky_aseal"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"skywrath_mage_ancient_seal"
		"ScriptFile"	"dl/oldsky/oldsky_aseal/oldsky_aseal.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"AbilityCastPoint"	"0.1"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_3"
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"HasScepterUpgrade"				"1"
		"HasShardUpgrade"				"1"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		//"AbilityCooldown"	"14"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"80 90 100 110"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"900"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"particle"	"particles/units/heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_debuff.vpcf"
			"particle"	"particles/dlparticles/oldsky_aseal/green_p_skywrath_mage_ancient_seal_debuff.vpcf"	//自改
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"aseal_duration"	"3.0 4.0 5.0 6.0"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"aseal_range"	"900"	//施法距离，供A杖索敌用
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"aseal_magicred"	"30 35 40 45"	//魔抗百分比减少
				"LinkedSpecialBonus"	"special_bonus_oldsky_15l"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"aseal_abolt"	"0.5"	//被12技能击中延长时间，魔晶
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"aseal_mflare"	"0.1"	//被4技能击中延长时间，魔晶
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"aseal_cd"	"14.0"	//冷却时间，供天赋显示用
				"LinkedSpecialBonus"	"special_bonus_oldsky_15r"

			}
		}
	}

	"special_bonus_oldsky_15r"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"-8.0"		//减CD
			}
		}
		"LinkedAbility"
		{
			"01"	"oldsky_aseal"
		}
	}

	"special_bonus_oldsky_15l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"15"		//减魔抗增加
			}
		}
		"LinkedAbility"
		{
			"01"	"oldsky_aseal"
		}
	}

	/////////////////////////////////

	"oldsky_mflare"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"skywrath_mage_mystic_flare"
		"ScriptFile"	"dl/oldsky/oldsky_mflare/oldsky_mflare.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetFlags"	"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"2"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"HasScepterUpgrade"				"1"
		//"HasShardUpgrade"				"1"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"30 25 20"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"300 500 700"
		"AbilityCastRange"	"1000"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts"
			"particle"	"particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient.vpcf"
			"particle"	"particles/econ/items/rubick/rubick_arcana/rbck_arc_skywrath_mage_mystic_flare_ambient.vpcf"    //拉比克
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"mflare_radius"		"170"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"mflare_duration"		"2.4"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"mflare_range"		"1000"	//A杖索敌范围
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"mflare_damage"		"600 1000 1400"	//满额总伤害
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"mflare_intco_exdam"		"2.0"	//爆炸伤害总智力系数
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"mflare_intco_exrad"		"1.0"	//爆炸扩大半径总智力系数
			}
		}
	}

//////////////////////////////
//troll 老巨魔 ↓
//////////////////////////
/////////////////////近战飞斧 ↓
	"oldtroll_meleeaxe"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------

		"BaseClass"						"ability_lua"
		"ScriptFile"					"dl/oldtroll/oldtroll_meleeaxe/oldtroll_meleeaxe.lua"
		"AbilityTextureName"			"troll_warlord_whirling_axes_melee"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
 		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_3"
		"AbilityCastGestureSlot"		"DEFAULT"
		"AbilityCastPoint"				"0.0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"9"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50"


		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"meleeaxe_duration"					"3"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"meleeaxe_interval"					"0.6"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"meleeaxe_radius"					"450"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"meleeaxe_miss"					"40 50 60 80"	//丢失几率
			}
		}
	}
	"special_bonus_oldtroll_25l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"
			}
		}
		"LinkedAbility"
		{
			"01"	"oldtroll_meleeaxe"
		}
	}
////////////////////////////////远程飞斧 ↓

	"oldtroll_rangeaxe"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"						"ability_lua"
		"ScriptFile"					"dl/oldtroll/oldtroll_rangeaxe/oldtroll_rangeaxe.lua"
		"AbilityTextureName"			"troll_warlord_whirling_axes_ranged"

		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"


		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"			"ACT_DOTA_WHIRLING_AXES_RANGED"
		"AbilityCastGestureSlot"		"DEFAULT"
		"AbilityCastRange"				"50000"
		"AbilityCastPoint"				"0.2 0.2 0.2 0.2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"9"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"rangeaxe_range"					"1000"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"rangeaxe_speed"					"3000"	//投射物速度
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"rangeaxe_angle"					"45"	//扇形的角度为此值的两倍
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"rangeaxe_duration"					"2.0 3.0 4.0 5.0"	//减速时间
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"rangeaxe_slow"					"45"	//百分比减速
			}
		}
	}
	"special_bonus_oldtroll_25r"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"
			}
		}
		"LinkedAbility"
		{
			"01"	"oldtroll_rangeaxe"
		}
	}

/////////////////////////////////热血战魂 ↓

	"oldtroll_fervor"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"troll_warlord_fervor"
		"ScriptFile"					"dl/oldtroll/oldtroll_fervor/oldtroll_fervor.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"fervor_aspeed"	"15 20 25 30"	//每层叠加攻速
				"LinkedSpecialBonus"	"special_bonus_oldtroll_15l"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"fervor_duration"	"5.0"		//攻速Buff持续时间
				"LinkedSpecialBonus"	"special_bonus_oldtroll_15r"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"fervor_chance"	"17"	//击晕概率百分比
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"fervor_stun"	"2"	//击晕时间
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"fervor_bat"	"0.01"	//每层减少攻击间隔
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
	}
	"special_bonus_oldtroll_15r"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"oldtroll_fervor"
		}
	}
	"special_bonus_oldtroll_15l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"15"
			}
		}
		"LinkedAbility"
		{
			"01"	"oldtroll_fervor"
		}
	}

//////////////////////////////战斗专注 ↓

	"oldtroll_btrance"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"troll_warlord_battle_trance"
		"ScriptFile"					"dl/oldtroll/oldtroll_btrance/oldtroll_btrance.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"HasScepterUpgrade"				"1"
		"HasShardUpgrade"				"1"
		"FightRecapLevel"				"2"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityCastPoint"				"0.0"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"30"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"75"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"0"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_troll_warlord.vsndevts"
			"particle"	"particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_cast.vpcf"
			"particle"	"particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"btrance_duration"	"5.0 6.0 7.0"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"btrance_aspeed"	"100 150 200"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"btrance_bat"		"0.2"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"btrance_shard"		"2.0"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
	}

////////////////////////////////////////////////////////////////////////

	/////////////////////
	//	死亡脉冲 ↓
	///////////////////

"dlnec_dpulse"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"necrolyte_death_pulse"
		"ScriptFile"					"dl/dlnec/dlnec_dpulse/dlnec_dpulse.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_AUTOCAST | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"				"1"
		"precache"
		{
			"soundfile"	"sounds/weapons/hero/necrolyte/death_pulse.vsnd"
			"particle"	"particles/units/heroes/hero_necrolyte/necrolyte_pulse_friend.vpcf"
			"particle"	"particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf"
		}
		"AbilityCastRange"				"0"
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"
		"AbilityCooldown"				"8 7 6 5"
		"AbilityDamage"					"50 100 150 200"
		"AbilityManaCost"				"100 130 160 190"
		//"IsGrantedByShard"			"1"
		"HasShardUpgrade"				"1"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"dpulse_radius"			"500"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"dpulse_heal"			"50 100 150 200"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"dpulse_damage"			"50 100 150 200"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"dpulse_intco"			"0.1"			//附加总智力伤害系数
				"LinkedSpecialBonus"	"special_bonus_dlnec_20r"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"dpulse_projspeed"		"500"			//投射物速度
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"dpulse_minmana_percent"		"15"	//瘟疫之潮最低魔法百分比
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"dpulse_interval"			"1.0"		//瘟疫之潮间隔
			}
			"08"
			{
				"var_type"				"FIELD_INTEGER"
				"dpulse_wavemana_base_percent"		"10"	//瘟疫之潮每波固定消耗魔法百分比
			}
			"09"
			{
				"var_type"				"FIELD_INTEGER"
				"dpulse_wavemana_increase_percent"		"5"	//瘟疫之潮每层增长消耗魔法百分比
			}
			"10"
			{
				"var_type"				"FIELD_INTEGER"
				"dpulse_radius_perstack"			"100"	//瘟疫之潮每层加半径
			}
			"11"
			{
				"var_type"				"FIELD_INTEGER"
				"dpulse_limit"		"1500"	//瘟疫之潮半径上限
			}
			"12"
			{
				"var_type"				"FIELD_INTEGER"
				"dpulse_shard"		"150"	//魔晶加半径
			}
			//"12"
			//{
			//	"var_type"					"FIELD_FLOAT"
			//	"reaper_damageco"			"0.7 0.8 0.9"	//测试其他技能附加大招。添加modi所需KV就可以。
			//}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	"special_bonus_dlnec_20r"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0.2"
			}
		}
		"LinkedAbility"
		{
			"01"	"dlnec_dpulse"
		}
	}


	/////////////////////
	//	竭心光环 ↓
	/////////////////////

	"dlnec_haura"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"necrolyte_heartstopper_aura"
		"ScriptFile"			"dl/dlnec/dlnec_haura/dlnec_haura.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_HP_REMOVAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"precache"
		{
			"soundfile"	"sounds/vo/necrolyte/necr_attack_04.vsnd"	//都是官方文件无改，还用precache吗？
			"soundfile"	"sounds/vo/necrolyte/necr_laugh_03.vsnd"
			"particle"	"particles/econ/events/diretide_2020/high_five/high_five_lvl1_overhead.vpcf"
		}

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"haura_hpmpgain_hero"		"90 120 150 180"	//击杀英雄固定回复
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"haura_hpmpgain_hero_percent"		"6"	//击杀英雄回复自身最大百分比
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"haura_hpmpgain_creep"	"15 20 25 30"	//击杀非英雄固定回复
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"haura_hpmpgain_creep_percent"		"1"	//击杀非英雄回复自身最大百分比
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"haura_multi_tooltip"		"6"						//英雄回复倍数，省介绍字数
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"haura_interval"		"1.0"		//竭心光环间隔和粘滞时间
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"haura_radius"			"800"		//光环半径
			}
			"08"
			{
				"var_type"				"FIELD_FLOAT"
				"haura_hploss_base_percent"		"0.6 1.2 1.8 2.4"		//竭心光环基础每次生命流失最大百分比
				"LinkedSpecialBonus"	"special_bonus_dlnec_20l"
			}
			"09"
			{
				"var_type"				"FIELD_FLOAT"
				"haura_hploss_stack_percent"		"0.4"		//竭心光环每层瘟疫每次生命流失最大百分比
			}
			"10"
			{
				"var_type"				"FIELD_INTEGER"
				"haura_speedloss_stack"		"6"		//竭心光环每层瘟疫移速流失固定数值
			}
			"11"
			{
				"var_type"				"FIELD_INTEGER"
				"haura_infect"			"6"						//感染者所需瘟疫层数
			}
			"12"
			{
				"var_type"				"FIELD_FLOAT"
				"haura_infect_duration"		"6.0"		//感染者持续时间
			}
			"13"
			{
				"var_type"				"FIELD_INTEGER"
				"haura_infect_radius"		"400"						//感染者半径
			}
			"14"
			{
				"var_type"				"FIELD_INTEGER"
				"haura_speedloss_infected_percent"		"6 12 18 24"						//感染者减速百分比
			}
			"15"
			{
				"var_type"				"FIELD_INTEGER"
				"haura_mrloss_infected"		"6 12 18 24"						//感染者减魔抗
			}
		}
	}

	"special_bonus_dlnec_20l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"2.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"dlnec_haura"
		}
	}

	/////////////////////////
	//	死神镰刀 ↓
	///////////////////////////

	"dlnec_reaper"
	{
		// General
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"necrolyte_reapers_scythe"
		"ScriptFile"					"dl/dlnec/dlnec_reaper/dlnec_reaper.lua"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Necrolyte.ReapersScythe.Target"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.1"
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		//"AbilityCooldown"				"120 100 80"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"200 350 500"

		// Cast Range
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.1"	// Primarily about the damage

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"reaper_damageco"			"0.7 0.8 0.9"	//已损失生命伤害系数
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"reaper_stun"				"1.5"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"		//每层增加复活时间
				"reaper_time_perstack"		"3"
				"LinkedSpecialBonus"	"special_bonus_dlnec_25r"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"		//每层增加复活时间
				"reaper_cd"				"120 100 80"
				"LinkedSpecialBonus"	"special_bonus_dlnec_25l"
			}
		}
	}

	"special_bonus_dlnec_25r"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"2"
			}
		}
		"LinkedAbility"
		{
			"01"	"dlnec_reaper"
		}
	}

	"special_bonus_dlnec_25l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"30"
			}
		}
		"LinkedAbility"
		{
			"01"	"dlnec_reaper"
		}
	}

	///////////////////////////
	//	死亡深渊 ↓
	////////////////////////////

	"dlnec_dabyss"
	{
		// General

		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"necrolyte_death_seeker"
		"ScriptFile"					"dl/dlnec/dlnec_dabyss/dlnec_dabyss.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_TOGGLE | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"MaxLevel"						"1"
		"FightRecapLevel"				"1"
		//"IsGrantedByShard"			"1"
		//"HasShardUpgrade"				"1"
		"IsGrantedByScepter"			"1"
		"HasScepterUpgrade"				"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"550"
		"AbilityCastPoint"				"0"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_5"

		"precache"
		{
			"soundfile"	"sounds/misc/soundboard/diretide_ghost.vsnd"
			"particle"	"particles/dlparticles/dlnec_dabyss/green_p_juggernaut_blade_fury_abyssal_golden.vpcf"	//自改
			"particle"	"particles/dlparticles/dlnec_dabyss/half_pudge_arcana_dismember_wood.vpcf"	//自改
		}


		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"dabyss_dur"		"3"		//亡语吟唱时间。考虑到没有自杀道具，此技能的命中条件变得比较苛刻，所以比预计短了1秒
				//"RequiresScepter"				"1"		这require还不清楚具体作用
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"dabyss_radius"		"400"		//亡语半径
				//"RequiresScepter"				"1"
			}
			"03"
			{
				"var_type"			"FIELD_INTEGER"
				"dabyss_reaper_stun"		"1.5"		//镰刀眩晕，所有镰刀用到的kv这里必须都有
				//"RequiresScepter"				"1"
			}
			"04"
			{
				"var_type"			"FIELD_INTEGER"
				"reaper_damageco"		"1.5"		//镰刀伤害，只在深渊里用的kv可以改名，在镰刀里用的kv名字必须一样，但数值不需要一样
				//"RequiresScepter"				"1"
			}
		}
	}


"dlzuus_sf"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"zuus_static_field"
		"ScriptFile"	"dl/dlzuus/dlzuus_sf/dlzuus_sf.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"HasShardUpgrade"				"1"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_zuus/zuus_static_field.vpcf"
		}

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"sf_per"			"5 6 7 8"	//当前生命百分比
				"LinkedSpecialBonus"	"special_bonus_dlzuus_25l"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"sf_paradura"			"0.5"	//麻痹时间
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"sf_shardam"			"1"	//静电接触伤害系数
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}
	"special_bonus_dlzuus_25l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"2"
			}
		}
		"LinkedAbility"
		{
			"01"	"dlzuus_sf"
		}
	}

	"dlzuus_sf"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"zuus_static_field"
		"ScriptFile"	"dl/dlzuus/dlzuus_sf/dlzuus_sf.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_zuus/zuus_static_field.vpcf"
		}

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"sf_per"			"5 6 7 8"	//当前生命百分比
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}

/////////////////////////////////////////////
//静电场 static field

	"dlzuus_sf"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"zuus_static_field"
		"ScriptFile"	"dl/dlzuus/dlzuus_sf/dlzuus_sf.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"HasShardUpgrade"				"1"
		"precache"
		{
			"particle"	"particles/units/heroes/hero_zuus/zuus_static_field.vpcf"
		}

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"sf_per"			"5 6 7 8"	//当前生命百分比
				"LinkedSpecialBonus"	"special_bonus_dlzuus_25l"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"sf_paradura"			"0.5"	//麻痹时间
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"sf_shardam"			"1"	//静电接触伤害系数
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}
	"special_bonus_dlzuus_25l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"2"
			}
		}
		"LinkedAbility"
		{
			"01"	"dlzuus_sf"
		}
	}

//雷枪 thunder spear
	"dlzuus_ts"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"zuus_lightning_bolt"
		"ScriptFile"	"dl/dlzuus/dlzuus_ts/dlzuus_ts.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"1000 1200 1400 1600"
		"AbilityCastPoint"	"0.5"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"6.0"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"100 115 130 145"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"particle"	"particles/dlmars_ti9_immortal_crimson_spear.vpcf"
			"particle"	"particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"
			"particle"	"particles/econ/items/disruptor/disruptor_ti8_immortal_weapon/disruptor_ti8_immortal_thunder_strike_bolt.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"ts_range"	"1000 1200 1400 1600"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"ts_speed"	"3000"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"ts_width"	"150"	//击中判定宽度
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"ts_vision"	"500"	//高空真实视野半径
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"max_charges"	"1 1 2 2"	//最大充能
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"charge_restore_time"	"6.0"	//充能时间
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"ts_vision_dur"	"3.0"	//高空真实视野持续时间
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"ts_aoerad"	"325"	//AOE伤害半径
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"ts_aoedam"	"75 125 150 175"	//AOE伤害数值
			}
			"10"
			{
				"var_type"	"FIELD_FLOAT"
				"ts_stun_dur"	"0.6"	//眩晕持续时间
			}
		}
	}
	"special_bonus_dlzuus_20l"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
			}
		}
		"LinkedAbility"
		{
			"01"	"dlzuus_ts"
		}
	}

/////////////////////////////////////////////////////
// arc lightning 闪电链

	"dlzuus_al"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"zuus_arc_lightning"
		"ScriptFile"	"dl/dlzuus/dlzuus_al/dlzuus_al.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		//////
		"precache"
		{
			"particle"	"particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"		"FIELD_FLOAT"
				"al_delay"		"0.3"	//闪电链弹跳延迟
			}
			"02"
			{
				"var_type"		"FIELD_INTEGER"
				"al_damage"		"40 60 80 100"
			}
			"03"
			{
				"var_type"		"FIELD_INTEGER"
				"al_radius"		"500"	//弹跳半径
				"LinkedSpecialBonus"	"special_bonus_dlzuus_25r"
			}
			"04"
			{
				"var_type"		"FIELD_FLOAT"
				"al_protect"	"0.8"	//弹跳保护时间
			}
			"05"
			{
				"var_type"		"FIELD_FLOAT"
				"al_intco"		"1"	//基础智力伤害系数
				"LinkedSpecialBonus"	"special_bonus_dlzuus_20r"
			}
		}
	}
	"special_bonus_dlzuus_20r"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1"
			}
		}
		"LinkedAbility"
		{
			"01"	"dlzuus_al"
		}
	}
	"special_bonus_dlzuus_25r"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"300"
			}
		}
		"LinkedAbility"
		{
			"01"	"dlzuus_al"
		}
	}

//////////////////////////////////























	// =================================================================================================================
	//
	//
	//
	// 								老IMBA英雄
	//
	//
	//
	// =================================================================================================================
	// =================================================================================================================
	// Queen of Pain's Shadow Strike
	// =================================================================================================================
	"imba_queenofpain_shadow_strike"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"queenofpain_shadow_strike"
		"ScriptFile"	"hero/hero_queen_of_pain.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"AbilityCastPoint"	"0.15"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"10 8 6 4"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"90"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"900"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts"
			"particle"	"particles/units/heroes/hero_queenofpain/queen_shadow_strike.vpcf"
			"particle"	"particles/units/heroes/hero_queenofpain/queen_shadow_strike_body.vpcf"
			"particle"	"particles/units/heroes/hero_queenofpain/queen_shadow_strike_debuff.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"strike_damage"	"50 75 100 125"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"duration_damage"	"8 13 18 23"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"movement_slow"	"20 30 40 50"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"projectile_speed"	"900"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"duration_tooltip"	"16"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
	}

	// =================================================================================================================
	// Queen of Pain's Blink
	// =================================================================================================================
	"imba_queenofpain_blink"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"queenofpain_blink"
		"ScriptFile"	"hero/hero_queen_of_pain.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilityCastPoint"	"0.15"
		"HasShardUpgrade"               "1"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"6"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"100"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"0"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts"
			"particle"	"particles/units/heroes/hero_queenofpain/queen_blink_end.vpcf"
			"particle"	"particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"blink_range"	"1500"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"min_blink_range"	"200"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"scream_damage"	"50 90 125 165"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"nausea_duration"	"3"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
	}

	// =================================================================================================================
	// Queen of Pain's Scream of Pain
	// =================================================================================================================
	"imba_queenofpain_scream_of_pain"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"queenofpain_scream_of_pain"
		"ScriptFile"	"hero/hero_queen_of_pain.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.0"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"7.0 6.5 6.0 5.5"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"110 120 130 140"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts"
			"particle"	"particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf"
			"particle"	"particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"area_of_effect"	"500"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"150 200 250 300"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"nausea_duration"	"3"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"nausea_base_dmg"	"50"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"nausea_bonus_dmg"	"1 2 3 4"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"projectile_speed"	"900"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
	}

	// =================================================================================================================
	// Queen of Pain's Delightful Torment
	// =================================================================================================================
	"imba_queenofpain_delightful_torment"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"queenofpain_delightful_torment"
		"ScriptFile"	"hero/hero_queen_of_pain.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO"
		"MaxLevel"	"1"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"cooldown_reduction"	"0.25"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
	}

	// Damage apply 0.1s Confuse
	"special_bonus_imba_queenofpain_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"0.15"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_queenofpain_delightful_torment"
		}
	}
	// cast shadow strike will attack 800 radius enemies
	"special_bonus_imba_queenofpain_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"800"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_queenofpain_shadow_strike"
		}
	}

	// Radial Sonic Wave
	"special_bonus_imba_queenofpain_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"5"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_queenofpain_sonic_wave"
		}
	}

	// =================================================================================================================
	// Queen of Pain's Sonic Wave
	// =================================================================================================================
	"imba_queenofpain_sonic_wave"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"queenofpain_sonic_wave"
		"ScriptFile"	"hero/hero_queen_of_pain.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_DIRECTIONAL | DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_PURE"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"	"2"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityCastPoint"	"0.25"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"120 80 40"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"240 360 480"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"1100"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts"
			"particle"	"particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"starting_aoe"	"100"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"distance"	"900"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"final_aoe"	"450"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"speed"	"1000"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"300 400 500"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"damage_scepter"	"325 450 575"
				"RequiresScepter"	"1"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"debuff_duration"	"1 3 5"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"damage_increase"	"15 20 25"
				"CalculateSpellDamageTooltip"	"0"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"HasScepterUpgrade"	"1"
	}

	// =================================================================================================================
	// Mirana's Starfall
	// =================================================================================================================
	"imba_mirana_starfall"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"mirana_starfall"
		"ScriptFile"	"hero/hero_mirana.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.1"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"8"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"100 120 140 160"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts"
			"particle"	"particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
			"particle"	"particles/units/heroes/hero_mirana/mirana_starfall_circle.vpcf"
			"particle"	"particles/hero/mirana/mirana_cosmic_dust.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"900"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"90 160 230 300"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"secondary_radius"	"250"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"secondary_duration"	"2"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"vision_duration"	"3"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
	}

	// =================================================================================================================
	// Mirana's Sacred Arrow
	// =================================================================================================================
	"imba_mirana_arrow"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"mirana_arrow"
		"ScriptFile"	"hero/hero_mirana.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.4"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"17.0"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"100"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts"
			"particle"	"particles/hero/mirana/mirana_sacred_arrow.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"arrow_speed"	"1200"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"arrow_width"	"115"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"arrow_max_stunrange"	"1500"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"arrow_min_stun"	"0.01"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"arrow_max_stun"	"5.0"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"arrow_bonus_damage"	"3 4 5 6"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"arrow_max_damage"	"50"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"arrow_vision"	"650"
			}
			"09"
			{
				"var_type"	"FIELD_FLOAT"
				"vision_duration"	"3.0"
			}
			"10"
			{
				"var_type"	"FIELD_INTEGER"
				"base_damage"	"180 270 360 450"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES_STRONG"
		"HasScepterUpgrade"	"1"
	}

	// =================================================================================================================
	// Mirana's Leap
	// =================================================================================================================
	"imba_mirana_leap"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"mirana_leap"
		"ScriptFile"	"hero/hero_mirana.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"SpellImmunityType"	"SPELL_IMMUNITY_ALLIES_YES"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_3"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"30 23 16 9"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"0"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"base_distance"	"1000"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"min_speed"	"2300"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"buff_radius"	"1200"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"leap_speedbonus"	"14 16 18 20"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"leap_speedbonus_as"	"20 30 40 50"
				"LinkedSpecialBonus"	"special_bonus_imba_mirana_2"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"buff_duration"	"10"
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"max_time"	"3.0"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"cooldown_increase"	"2"
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"base_height"	"100"
			}
			"10"
			{
				"var_type"	"FIELD_INTEGER"
				"height_step"	"50"
			}
			"11"
			{
				"var_type"	"FIELD_INTEGER"
				"max_height"	"700"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"HasScepterUpgrade"	"1"
	}

	// +150 Leap AS Bonus
	"special_bonus_imba_mirana_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"150"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_mirana_leap"
		}
	}

	// =================================================================================================================
	// Mirana's Cosmic Dust
	// =================================================================================================================
	"imba_mirana_cosmic_dust"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"mirana_princess_of_the_night"
		"ScriptFile"	"hero/hero_mirana.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.0"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"8.0"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"0"
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"HasScepterUpgrade"	"1"
	}

	// =================================================================================================================
	// Mirana's Moonlight Shadow
	// =================================================================================================================
	"imba_mirana_moonlight_shadow"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"mirana_invis"
		"ScriptFile"	"hero/hero_mirana.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"SpellImmunityType"	"SPELL_IMMUNITY_ALLIES_YES"
		"FightRecapLevel"	"2"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityCastPoint"	"0.4"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"100.0"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"75"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"0"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts"
			"particle"	"particles/units/heroes/hero_mirana/mirana_moonlight_recipient.vpcf"
			"particle"	"particles/units/heroes/hero_mirana/mirana_moonlight_owner.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"fade_delay"	"2.5 2.0 1.5"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"20.0"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"cd"	"100.0"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
	}

	// -70s Moonlight Shadow cooldown
	"special_bonus_imba_mirana_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"-50"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_mirana_moonlight_shadow"
		}
	}

















	// =================================================================================================================
	// Disruptor: Thunder Strike
	// =================================================================================================================
	"imba_disruptor_thunder_strike"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"disruptor_thunder_strike"
		"ScriptFile"	"hero/hero_disruptor.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"4"
		"AbilityCastPoint"	"0.05 0.05 0.05 0.05"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"	"ACT_DOTA_THUNDER_STRIKE"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"12 11 10 9"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"130 130 130 130"
		// Cast Range
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"800"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		 "HasShardUpgrade"               "1"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"cast_radius"	"480"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"240"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"strikes"	"5"
				"LinkedSpecialBonus"	"special_bonus_imba_disruptor_2"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"strike_interval"	"1.0"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"strike_damage"	"50 75 100 125"
				"LinkedSpecialBonus"	"special_bonus_imba_disruptor_1"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"AbilitySound"	"Hero_Disruptor.ThunderStrike.Target"
		"AbilityCastGestureSlot"	"DEFAULT"
	}

	// Thunder Strike Damage
	"special_bonus_imba_disruptor_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"50"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_disruptor_thunder_strike"
		}
	}

	// Thunder Strike Count
	"special_bonus_imba_disruptor_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"5"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_disruptor_thunder_strike"
		}
	}

	// Thunder Strike Can't be Dispelled
	"special_bonus_imba_disruptor_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_disruptor_thunder_strike"
		}
	}

	// =================================================================================================================
	// Disruptor: Glimpse
	// =================================================================================================================
	"imba_disruptor_glimpse"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"disruptor_glimpse"
		"ScriptFile"	"hero/hero_disruptor.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetFlags"	"DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"4"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.05 0.05 0.05 0.05"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_2"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"18"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"100"
		// Cast Range
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"1500 2000 2500 3000"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		 "HasShardUpgrade"               "1"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"backtrack_time"	"4.0"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"cast_range"	"1500 2000 2500 3000"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"travel_speed"	"2000"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"AbilitySound"	"Hero_Disruptor.Glimpse.Target"
	}

	// =================================================================================================================
	// Disruptor: Kinetic Field
	// =================================================================================================================
	"imba_disruptor_kinetic_field"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"disruptor_kinetic_field"
		"ScriptFile"	"hero/hero_disruptor.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"4"
		"AbilityCastPoint"	"0.05"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"	"ACT_DOTA_KINETIC_FIELD"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"19 18 17 16"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"70 70 70 70"
		// Cast Range
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"900"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"340 380 420 460"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"formation_time"	"0.7"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"2.4 3.0 3.6 4.2"
				"LinkedSpecialBonus"	"special_bonus_imba_disruptor_5"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"AbilitySound"	"Hero_Disruptor.KineticField"
		"AbilityCastGestureSlot"	"DEFAULT"
	}

	// Kinetic Field CD
	"special_bonus_imba_disruptor_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"-3.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_disruptor_kinetic_field"
		}
	}

	// Kinetic Field Duration
	"special_bonus_imba_disruptor_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"5.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_disruptor_kinetic_field"
		}
	}

	// =================================================================================================================
	// Disruptor: Static Storm
	// =================================================================================================================
	"imba_disruptor_static_storm"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"disruptor_static_storm"
		"ScriptFile"	"hero/hero_disruptor.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"2"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"MaxLevel"	"3"
		"AbilityCastPoint"	"0.05 0.05 0.05 0.05"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"	"ACT_DOTA_STATIC_STORM"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"60"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"125 175 225"
		// Cast Range
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"800 800 800 800"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"600"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"damage_per_second"	"150 250 350"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"5.0"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"duration_scepter"	"10.0"
				"RequiresScepter"	"1"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
		"AbilitySound"	"Hero_Disruptor.StaticStorm.Cast"
		"HasScepterUpgrade"	"1"
		"AbilityCastGestureSlot"	"DEFAULT"
	}

	// Static Storm Break
	"special_bonus_imba_disruptor_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_disruptor_static_storm"
		}
	}

	// =================================================================================================================
	// Abyssal Underlord: Firestorm
	// =================================================================================================================
	"imba_abyssal_underlord_firestorm"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"abyssal_underlord_firestorm"
		"ScriptFile"	"hero/hero_abyssal_underlord.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_BUILDING"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"4"
		"AbilityCastPoint"	"0.3"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_1"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"12.0"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"140"
		"AbilityCastRange"	"750"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"450"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"wave_count"	"6"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"wave_damage"	"25 40 55 70"
				"LinkedSpecialBonus"	"special_bonus_imba_abyssal_underlord_1"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"wave_interval"	"1.0"
				"LinkedSpecialBonus"	"special_bonus_imba_abyssal_underlord_2"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"burn_damage"	"1 2 3 4"
				"CalculateSpellDamageTooltip"	"0"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"burn_stack_damage"	"0.5"
				"CalculateSpellDamageTooltip"	"0"
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"burn_interval"	"1.0"
			}
			"08"
			{
				"var_type"	"FIELD_FLOAT"
				"burn_duration"	"3.0"
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"building_damage"	"60"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
	}

	// + 20 Firestorm Damage
	"special_bonus_imba_abyssal_underlord_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"20"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_abyssal_underlord_firestorm"
		}
	}

	// -0.9 Firestorm Interval
	"special_bonus_imba_abyssal_underlord_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"-0.7"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_abyssal_underlord_firestorm"
		}
	}

	// =================================================================================================================
	// Abyssal Underlord: Pit of Malice
	// =================================================================================================================
	"imba_abyssal_underlord_pit_of_malice"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"abyssal_underlord_pit_of_malice"
		"ScriptFile"	"hero/hero_abyssal_underlord.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_BUILDING"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"4"
		"AbilityCastPoint"	"0.2"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_2"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"22 20 18 16"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"80 100 120 140"
		"AbilityCastRange"	"750"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"550"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"pit_duration"	"12.0"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"pit_interval"	"3.6 3.4 3.2 3.0"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"ensnare_duration"	"0.9 1.2 1.5 1.8"
				"LinkedSpecialBonus"	"special_bonus_imba_abyssal_underlord_3"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"fs_extend_duration"	"1.0"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"disarm_duration"	"1.0"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"AbilitySound"	"Hero_AbyssalUnderlord.PitOfMalice"
	}

	// +0.8 Pit of Malice Root
	"special_bonus_imba_abyssal_underlord_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"0.2"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_abyssal_underlord_pit_of_malice"
		}
	}

	// =================================================================================================================
	// Abyssal Underlord: Atrophy Aura
	// =================================================================================================================
	"imba_abyssal_underlord_atrophy_aura"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"abyssal_underlord_atrophy_aura"
		"ScriptFile"	"hero/hero_abyssal_underlord.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_AURA | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"MaxLevel"	"4"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_3"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"120"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"50"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"1200"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"1200"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"damage_reduction_pct"	"7 18 29 40"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_damage_from_creep"	"5 7 9 11"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_damage_from_hero"	"30 35 40 45"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"bonus_damage_duration"	"30 40 50 60"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"bonus_damage_duration_scepter"	"70 80 90 100"
				"RequiresScepter"	"1"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"permanent_bonus"	"2 3 4 5"
				"LinkedSpecialBonus"	"special_bonus_imba_abyssal_underlord_4"
			}
			"08"
			{
				"var_type"	"FIELD_FLOAT"
				"active_duration"	"10"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
		"HasScepterUpgrade"	"1"
	}

	// +7 Atrophy Aura Permanent Bonus
	"special_bonus_imba_abyssal_underlord_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"7"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_abyssal_underlord_atrophy_aura"
		}
	}

	// =================================================================================================================
	// Abyssal Underlord: Dark Rift
	// =================================================================================================================
	"imba_abyssal_underlord_dark_rift"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"abyssal_underlord_dark_rift"
		"ScriptFile"	"hero/hero_abyssal_underlord.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_BUILDING | DOTA_UNIT_TARGET_CREEP | DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetFlags"	"DOTA_UNIT_TARGET_FLAG_INVULNERABLE"
		"SpellImmunityType"	"SPELL_IMMUNITY_ALLIES_YES"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"MaxLevel"	"3"
		"AbilityCastPoint"	"0.3"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"60"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"100 200 300"
		"AbilityCastRange"	"0"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"600"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"teleport_delay"	"4.0 3.0 2.0"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
		"AbilitySound"	"Hero_AbyssalUnderlord.DarkRift.Cast"
		"HasScepterUpgrade"	"1"
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
	}

	// =================================================================================================================
	// Abyssal Underlord: Cancel Dark Rift
	// =================================================================================================================
	"imba_abyssal_underlord_cancel_dark_rift"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"abyssal_underlord_cancel_dark_rift"
		"ScriptFile"	"hero/hero_abyssal_underlord.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"MaxLevel"	"1"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.0 0.0 0.0 0.0"
		"AbilityCastAnimation"	"ACT_DOTA_OVERRIDE_ABILITY_4"
		"AbilityCastGestureSlot"	"DEFAULT"
	}



	// =================================================================================================================
	// Bounty Hunter's Shuriken Toss
	// =================================================================================================================
	"imba_bounty_hunter_shuriken_toss"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"bounty_hunter_shuriken_toss"
		"ScriptFile"	"heros/hero_bounty_hunter/hero_bounty_hunter.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		// Unit Targeting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"AbilityCastPoint"	"0"
		"AbilityCooldown"	"10"
		"AbilityManaCost"	"140"
		// Stats
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"700"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts"
			"particle"	"particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf"
			"particle"	"particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_impact.vpcf"
			"particle"	"particles/econ/items/pudge/pudge_trapper_beam_chain/pudge_nx_meathook_chain.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"100 200 300 400"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"speed"		"1500"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"mini_stun"	"0.1"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"chain_range"	"400"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"chain_duration"	"3.0"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"pull_strength_tooltip"	"450"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
	}

	// =================================================================================================================
	// Bounty Hunter: Jinada
	// =================================================================================================================
	"imba_bounty_hunter_jinada"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"bounty_hunter_jinada"
		"ScriptFile"	"heros/hero_bounty_hunter/hero_bounty_hunter.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"MaxLevel"	"4"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_2"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"4"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"crit_damage"	"150 200 250 300"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"ms_slow"	"50"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"slow_duration"	"1.0 1.5 2.0 2.5"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"gold_steal"	"10 15 20 25"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"AbilitySound"	"Hero_BountyHunter.Jinada"
	}

	// =================================================================================================================
	// Bounty Hunter's Shadow Walk
	// =================================================================================================================
	"imba_bounty_hunter_wind_walk"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"bounty_hunter_wind_walk"
		"ScriptFile"	"heros/hero_bounty_hunter/hero_bounty_hunter.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityCastPoint"	"0.0"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"10.0"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"50"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts"
			"particle"	"particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf"
			"particle"	"particles/generic_hero_status/status_invisibility_start.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"40.0"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"fade_time"	"0.5"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_damage"	"30 60 90 120"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"move_speed"	"10"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
	}

	// =================================================================================================================
	// Bounty Hunter's Shadow Jaunt
	// =================================================================================================================
	"imba_bounty_hunter_shadow_jaunt"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"imba_bounty_hunter_shadow_jaunt"
		"ScriptFile"	"heros/hero_bounty_hunter/hero_bounty_hunter.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_BOTH"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"	"1"
		"MaxLevel"	"1"
		"AbilityCastPoint"	"0"
		"AbilityCooldown"	"10"
		"AbilityManaCost"	"0"
		// Stats
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"1200"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_riki.vsndevts"
			"particle"	"particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"range"	"1200"
			}
		}
	}

	// =================================================================================================================
	// Bounty Hunter's Track
	// =================================================================================================================
	"imba_bounty_hunter_track"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"bounty_hunter_track"
		"ScriptFile"	"heros/hero_bounty_hunter/hero_bounty_hunter.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetFlags"	"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES | DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityCastPoint"	"0.2"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		"AbilityCooldown"	"3.0"
		"AbilityManaCost"	"25"
		"HasShardUpgrade"               "1"
		// Stats
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"1500"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts"
			"particle"	"particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail.vpcf"
			"particle"	"particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_haste.vpcf"
			"particle"	"particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf"
			"particle"	"particles/hero/bounty_hunter/bounty_hunter_track_cast.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"aura_radius"	"1200"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_move_speed_pct"	"20"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_gold_self"	"75 125 175"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_gold_self_per_lvl"	"7"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_gold"	"50"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_gold_per_lvl"	"4"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"duration"	"15 30 45"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_damage_scepter"	"20"
				"RequiresScepter"	"1"
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"crit_percentage"	"140 160 180"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"HasScepterUpgrade"	"1"
	}



// =================================================================================================================
	// Rattletrap: Battery Assault
	// =================================================================================================================
	"imba_rattletrap_battery_assault"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"rattletrap_battery_assault"
		"ScriptFile"	"heros/hero_rattletrap/hero_rattletrap.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"4"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_1"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"20 18 16 14"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"100"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"275"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"10.5"
				"LinkedSpecialBonus"	"special_bonus_imba_rattletrap_1"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"interval"	"0.5"
				"LinkedSpecialBonus"	"special_bonus_imba_rattletrap_2"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"max_targets"	"1 1 2 3"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"30 50 70 90"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"passive_chance"	"20 30 40 50"
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"stun_duration"	"0.15"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
		"AbilitySound"	"Hero_Rattletrap.Battery_Assault_Impact"
		// Stats
		// -------------------------------------------------------------------------------------------------------------
		// applies many mini-stuns
		"AbilityModifierSupportValue"	"0.2"
	}

	// + 10s Battery Assault Duration
	"special_bonus_imba_rattletrap_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"10.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_rattletrap_battery_assault"
		}
	}

	// -0.3 Battery Assault Interval
	"special_bonus_imba_rattletrap_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"-0.2"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_rattletrap_battery_assault"
		}
	}

	// =================================================================================================================
	// Rattletrap: Power Cogs
	// =================================================================================================================
	"imba_rattletrap_power_cogs"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"rattletrap_power_cogs"
		"ScriptFile"	"heros/hero_rattletrap/hero_rattletrap.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"4"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.1"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_2"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"15"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"80"
		"AbilityCastRange"	"215"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"5.0 6.0 7.0 8.0"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"150 200 250 300"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"mana_burn"	"100 150 200 250"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"attacks_to_destroy"	"3"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"push_length"	"300"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"push_duration"	"1"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"cogs_radius"	"215"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"trigger_distance"	"170"
			}
			"09"
			{
				"var_type"	"FIELD_FLOAT"
				"bonus_armor"	"3 6 9 12"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
		"AbilitySound"	"Hero_Rattletrap.Power_Cogs"
	}

	// =================================================================================================================
	// Rattletrap: Rocket Flare
	// =================================================================================================================
	"imba_rattletrap_rocket_flare"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"rattletrap_rocket_flare"
		"ScriptFile"	"heros/hero_rattletrap/hero_rattletrap.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"4"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.2"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_3"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"20.0 18.0 16.0 14.0"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"40"
		"AbilityCastRange"	"0"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"800"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"10.0"
				"LinkedSpecialBonus"	"special_bonus_imba_rattletrap_3"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"truesight_duration"	"2.0 3.0 4.0 5.0"
				"LinkedSpecialBonus"	"special_bonus_imba_rattletrap_3"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"lock_duration"	"2.0"
				"LinkedSpecialBonus"	"special_bonus_imba_rattletrap_3"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"speed"	"2250"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"80 120 160 200"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"AbilitySound"	"Hero_Rattletrap.Rocket_Flare.Fire"
	}

	// +5.0 Rocket Flare Duration
	"special_bonus_imba_rattletrap_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"5.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_rattletrap_rocket_flare"
		}
	}

	// +3 Rocket Flare
	"special_bonus_imba_rattletrap_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"3"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_rattletrap_rocket_flare"
		}
	}

	// =================================================================================================================
	// Rattletrap: Hookshot
	// =================================================================================================================
	"imba_rattletrap_hookshot"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"rattletrap_hookshot"
		"ScriptFile"	"heros/hero_rattletrap/hero_rattletrap.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"	"2"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"MaxLevel"	"3"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.3 0.3 0.3 0.3"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"40 30 20"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"150 150 150"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"latch_radius"	"175"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"stun_radius"	"250"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"2.5"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"speed"	"4000 5000 6000"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"range"	"2500 3000 3500"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"max_range"	"8000"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"150 250 350"
			}
			"08"
			{
				"var_type"	"FIELD_FLOAT"
				"cooldown_scepter"	"10.0"
				"RequiresScepter"	"1"
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"range_scepter"	"6000"
				"RequiresScepter"	"1"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES_STRONG"
		"AbilitySound"	"Hero_Rattletrap.Hookshot.Fire"
		"HasScepterUpgrade"	"1"
	}

	// =================================================================================================================
	// Rattletrap: Hookshot
	// =================================================================================================================
	"imba_rattletrap_hookshot_stop"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"rattletrap_stop_hookshot"
		"ScriptFile"	"heros/hero_rattletrap/hero_rattletrap.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE"
		"FightRecapLevel"	"1"
		"MaxLevel"	"1"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.0"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"1.0"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"0"
	}





	// =================================================================================================================
	// Ability: Static Remnant
	// =================================================================================================================
	"imba_storm_spirit_static_remnant"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"storm_spirit_static_remnant"
		"ScriptFile"	"hero/hero_storm_spirit"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"4"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0 0 0 0"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_1"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"3.5"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"100"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"static_remnant_radius"	"235"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"static_remnant_damage_radius"	"260"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"static_remnant_delay"	"0.7"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"static_remnant_damage"	"120 175 230 285"
				"LinkedSpecialBonus"	"special_bonus_imba_storm_spirit_7"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"15.0"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"slow_duration"	"0.8"
				"LinkedSpecialBonus"	"special_bonus_imba_storm_spirit_1"
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"sec_damage"	"50"
				"LinkedSpecialBonus"	"special_bonus_imba_storm_spirit_7"
			}
			"08"
			{
				"var_type"	"FIELD_FLOAT"
				"sec"	"1.5"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"AbilitySound"	"Hero_StormSpirit.StaticRemnantPlant"
	}

	// +0.5s Remnant Slow Duration
	"special_bonus_imba_storm_spirit_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"1.2"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_storm_spirit_static_remnant"
		}
	}
	// +伤害
	"special_bonus_imba_storm_spirit_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"65.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_storm_spirit_static_remnant"
		}
	}

	// =================================================================================================================
	// Ability: Electric Vortex
	// =================================================================================================================
	"imba_storm_spirit_electric_vortex"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"storm_spirit_electric_vortex"
		"ScriptFile"	"hero/hero_storm_spirit"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"4"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.1"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_2"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"20 18 16 14"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"85"
		"AbilityCastRange"	"475"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"electric_vortex_pull_units_per_second"	"100"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"1.0 1.5 2.0 2.5"
				"LinkedSpecialBonus"	"special_bonus_imba_storm_spirit_2"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"475"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"extra_target"	"0 1 2 3"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"remnant_counts"	"3 4 5 6"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES_STRONG"
		"HasScepterUpgrade"	"1"
		"AbilitySound"	"Hero_StormSpirit.ElectricVortex"
	}

	// +0.5s Electric Vortex Duration
	"special_bonus_imba_storm_spirit_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"0.5"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_storm_spirit_electric_vortex"
		}
	}

	// =================================================================================================================
	// Ability: Storm Spirit Overload
	// =================================================================================================================
	"imba_storm_spirit_overload"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"storm_spirit_overload"
		"ScriptFile"	"hero/hero_storm_spirit"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"MaxLevel"	"4"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_3"
		"AbilityCooldown"	"35"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"overload_aoe"	"300"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"overload_move_slow"	"80"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"overload_attack_slow"	"80"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"0.6"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"30 40 50 60"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"passive_chance"	"10 15 20 25"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"AbilitySound"	"Hero_StormSpirit.Overload"
		// Stats
		// -------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportBonus"	"40"
	}
	// +弹射
	"special_bonus_imba_storm_spirit_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_storm_spirit_overload"
		}
	}
	// +麻痹
	"special_bonus_imba_storm_spirit_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"0.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_storm_spirit_overload"
		}
	}
	// +主动加几率
	"special_bonus_imba_storm_spirit_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"12.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_storm_spirit_overload"
		}
	}
	// +附加伤害
	"special_bonus_imba_storm_spirit_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"100.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_storm_spirit_overload"
		}
	}

	// =================================================================================================================
	// Ability: Storm Spirit Ball Lightning
	// =================================================================================================================
	"imba_storm_spirit_ball_lightning"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"storm_spirit_ball_lightning"
		"ScriptFile"	"hero/hero_storm_spirit"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"2"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"MaxLevel"	"3"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.25"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"30"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"ball_lightning_initial_mana_percentage"	"9"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"ball_lightning_initial_mana_base"	"50"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"ball_lightning_move_speed"	"400 450 500"
				"LinkedSpecialBonus"	"special_bonus_imba_storm_spirit_3"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"ball_lightning_aoe"	"150 225 300"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"ball_lightning_vision_radius"	"400"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"cast_invul_duration"	"0.5"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"travel_damage"	"10 12 14"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"mana_penalty_distance"	"3500"
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"mana_penalty_pct"	"100"
			}
			"10"
			{
				"var_type"	"FIELD_FLOAT"
				"mana_penalty_remove_delay"	"2.5"
			}
			"11"
			{
				"var_type"	"FIELD_INTEGER"
				"min_stop_distance"	"1000"
			}
		}
		"AbilitySound"	"Hero_StormSpirit.BallLightning"
	}


	"electric_rave"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"storm_spirit_electric_rave"
		"ScriptFile"	"hero/hero_storm_spirit"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"					"Ability.FrostNova"
		"MaxLevel"						"1"

		"IsShardUpgrade"				"1"
		"IsGrantedByShard"				"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.0"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_5"
		"AbilityCastGestureSlot"		"DEFAULT"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"35"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"150"
		"precache"
		{
			"particle"	"particles/econ/events/ti10/hot_potato/disco_ball_channel.vpcf"
			"particle"	"particles/econ/items/storm_spirit/strom_spirit_ti8/storm_spirit_ti8_overload_active.vpcf"
			"particle"	"particles/units/heroes/hero_leshrac/leshrac_disco_tnt.vpcf"
			"particle"	"particles/econ/events/ti6/maelstorm_ti6.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"				"750"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"				"12"
			}
		}
	}

	// +100 Ball Lightning Speed
	"special_bonus_imba_storm_spirit_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_storm_spirit_ball_lightning"
		}
	}




	// =================================================================================================================
	// Puck: Illusory Orb
	// =================================================================================================================
	"imba_puck_illusory_orb"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"puck_illusory_orb"
		"ScriptFile"	"heros/hero_puck/hero_puck.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"

		"MaxLevel"	"4"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.1 0.1 0.1 0.1"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_1"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"13 12 11 10"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"80 100 120 140"
		"AbilityCastRange"	"50000"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"225"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"max_distance"	"1950"
				"LinkedSpecialBonus"	"special_bonus_imba_puck_1"
				"LinkedSpecialBonusOperation"	"SPECIAL_BONUS_MULTIPLY"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"orb_speed"	"650"
				"LinkedSpecialBonus"	"special_bonus_imba_puck_1"
				"LinkedSpecialBonusOperation"	"SPECIAL_BONUS_MULTIPLY"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"orb_vision"	"450"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"vision_duration"	"3.34 3.34 3.34 3.34"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"120 180 240 300"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"AbilitySound"	"Hero_Puck.Illusory_Orb"
	}

	// 3x Illusory Orb Speed and Distance
	"special_bonus_imba_puck_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"3"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_puck_illusory_orb"
		}
	}
	// 攻击
	"special_bonus_imba_puck_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"0.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_puck_illusory_orb"
		}
	}
	// 自身进行一次相位转移
	"special_bonus_imba_puck_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"0.4"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_puck_illusory_orb"
		}
	}

	// =================================================================================================================
	// Puck: Ethereal Jaunt
	// =================================================================================================================
	"imba_puck_ethereal_jaunt"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"puck_ethereal_jaunt"
		"ScriptFile"	"heros/hero_puck/hero_puck.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES"
		"MaxLevel"	"1"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.0"
		"AbilityCastAnimation"	"ACT_INVALID"
		"AbilityCooldown"	"0.5"
		"AbilitySound"	"Hero_Puck.EtherealJaunt"
	}

	// =================================================================================================================
	// Puck: Waning Rift
	// =================================================================================================================
	"imba_puck_waning_rift"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"puck_waning_rift"
		"ScriptFile"	"heros/hero_puck/hero_puck.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AUTOCAST | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"4"
	    	 "HasShardUpgrade"               "1"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.0"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_2"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"13 12 11 10"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"100"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"500"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"silence_duration"	"2.0 2.5 3.0 3.5"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"140 200 260 320"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"distance"	"300 320 340 360"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"AbilitySound"	"Hero_Puck.Waning_Rift"
	}

	// -8s Waning Rift Cooldown
	"special_bonus_imba_puck_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"-6.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_puck_waning_rift"
		}
	}
	// 攻击
	"special_bonus_imba_puck_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"0.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_puck_waning_rift"
		}
	}

	// =================================================================================================================
	// Puck: Phase Shift
	// =================================================================================================================
	"imba_puck_phase_shift"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"puck_phase_shift"
		"ScriptFile"	"heros/hero_puck/hero_puck.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"SpellImmunityType"	"SPELL_IMMUNITY_ALLIES_YES"
		"MaxLevel"	"4"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_3"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"6"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"1"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"1 1.5 2 2.5"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
		"AbilitySound"	"Hero_Puck.Phase_Shift"
	}
	// 攻击
	"special_bonus_imba_puck_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"0.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_puck_phase_shift"
		}
	}
	// 驱散
	"special_bonus_imba_puck_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"0.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_puck_phase_shift"
		}
	}
	// 附加
	"special_bonus_imba_puck_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"3.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_puck_phase_shift"
		}
	}
	// =================================================================================================================
	// Puck: Dream Coil
	// =================================================================================================================
	"imba_puck_dream_coil"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"puck_dream_coil"
		"ScriptFile"	"heros/hero_puck/hero_puck.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"	"2"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"MaxLevel"	"3"
		"AbilityCastPoint"	"0.1 0.1 0.1"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_5"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"90"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"300 400 500"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"350"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"coil_duration"	"6.0"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"600 600 600"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"stun_duration"	"0.5"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"coil_stun_duration"	"1.8 2.4 3.0"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"coil_break_damage"	"300 400 500"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"attack_interval"	"2.5"
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"coil_duration_scepter"	"8"
				"RequiresScepter"	"1"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"coil_break_damage_scepter"	"400 600 800"
				"RequiresScepter"	"1"
			}
			"09"
			{
				"var_type"	"FIELD_FLOAT"
				"coil_stun_duration_scepter"	"4.5"
				"RequiresScepter"	"1"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
		"HasScepterUpgrade"	"1"
		"AbilitySound"	"Hero_Puck.Dream_Coil"
		// Stats
		// -------------------------------------------------------------------------------------------------------------
		// Does two modifiers
		"AbilityModifierSupportValue"	"0.5"
	}


//巫妖
// =================================================================================================================
	// Lich's Frost Nova
	// =================================================================================================================
	"imba_lich_frost_nova"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"lich_frost_nova"
		"ScriptFile"	"ting/hero_lich.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"AbilityCastPoint"	"0.4"
		"AbilityCharges"	"1 1 2 3"
		"AbilityChargeRestoreTime"	"8"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"75"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"2000"

		"precache"
		{
			"particle"	"particles/units/heroes/hero_lich/lich_frost_nova.vpcf"
			"particle"	"particles/status_fx/status_effect_frost_lich.vpcf"
			"particle"	"particles/units/heroes/hero_tusk/tusk_frozen_sigil_status.vpcf"
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_lich.vsndevts"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"200 250 300 350"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"slow_movement_speed"	"30"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"slow_attack_speed"	"20 30 40 50"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"aoe_damage"	"60 80 100 120"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"target_damage"	"80 100 120 140"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"slow_duration"	"4.0"
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"freez_duration"	"1.0"
			}
			"08"
			{
				"var_type"	"FIELD_FLOAT"
				"damage_per"	"2.0"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
	}


	// =================================================================================================================
	// Lich's Ice Armor
	// =================================================================================================================
	"imba_lich_frost_armor"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"lich_frost_shield"
		"ScriptFile"	"ting/hero_lich.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_ALL"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ALLIES_YES_ENEMIES_NO"
		"AbilityCastPoint"	"0.3"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"13.0"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"80"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"1200"
		"LinkedTalents"
		{
			"special_bonus_imba_lich_5"	"1"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"armor_bonus"	"4 6 8 10"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"slow_duration"	"0.6"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"slow_movement_speed"	"80"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"slow_attack_speed"	"30 40 50 60"
				"LinkedSpecialBonus"			"special_bonus_imba_lich_5"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"30.0"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"blast_duration"	"4 5 6 7"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"blast_damage"	"100 150 200 250"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"blast_radius"	"600"
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"damage_re"	"10 15 20 25"
			}


		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
	}

	// =================================================================================================================
	// Lich: Sinister Gaze
	// =================================================================================================================
	"imba_lich_sinister_gaze"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"lich_sinister_gaze"
		"ScriptFile"	"ting/hero_lich.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_CHANNELLED | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"4"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_3"
		"AbilityCooldown"	"35 30 25 20"
		"AbilityCastRange"  "1000"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"120 130 140 150"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityChannelTime"	"3"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"3"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"destination"	"50 60 70 80"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"500"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"finish_duration"	"1"
			}

		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
	}


	// =================================================================================================================
	// Lich's Chain Frost
	// =================================================================================================================
	"imba_lich_chain_frost"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"lich_chain_frost"
		"ScriptFile"	"ting/hero_lich.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetFlags"	"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"	"2"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityCastPoint"	"0.4"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"70"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"200 325 450"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"650"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"particle"	"particles/units/heroes/hero_lich/lich_chain_frost.vpcf"
			"particle"	"particles/status_fx/status_effect_frost_lich.vpcf"
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_lich.vsndevts"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"slow_duration"	"3.0"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"slow_movement_speed"	"30 40 50"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"slow_attack_speed"	"100"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"jump_range"	"600 700 800"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"jump_range_scepter"	"700 850 1000"
				"RequiresScepter"	"1"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"projectile_speed"	"900"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"speed_per_bounce"	"60"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"speed_per_bounce_scepter"	"90"
				"RequiresScepter"	"1"
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"vision_radius"	"1000"
			}
			"10"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"200 300 400"
			}
			"11"
			{
				"var_type"	"FIELD_INTEGER"
				"damage_scepter"	"300 400 500"
				"RequiresScepter"	"1"
			}
			"12"
			{
				"var_type"	"FIELD_FLOAT"
				"bounce_delay"	"0.1"
			}
			"13"
			{
				"var_type"	"FIELD_INTEGER"
				"speed_fountain"	"300"
			}
			"14"
			{
				"var_type"	"FIELD_INTEGER"
				"bounces"	"20 30 40"
				"LinkedSpecialBonus"			"special_bonus_imba_lich_6"
			}
			"15"
			{
				"var_type"	"FIELD_INTEGER"
				"bounces_dmg"	"20"
			}

		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"HasScepterUpgrade"	"1"
	}
	"imba_lich_ice_spire"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"lich_ice_spire"
		"ScriptFile"	"ting/hero_lich.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"					"Ability.FrostNova"
		"MaxLevel"						"1"

		"IsShardUpgrade"				"1"
		"IsGrantedByShard"				"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"750"
		"AbilityCastPoint"				"0.3"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_5"
		"AbilityCastGestureSlot"		"DEFAULT"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"15"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"150"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_movespeed"			"-30"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"aura_radius"				"750"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"max_hero_attacks"			"2"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"15.0"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"slow_duration"				"0.5"
			}

		}
	}

			// 大死人放冰柱子
	"special_bonus_imba_lich_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"7.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_lich_chain_frost"
		}
	}

	// 大招麻痹
	"special_bonus_imba_lich_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"1.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_lich_chain_frost"
		}
	}
	//冰盾cd
	"special_bonus_imba_lich_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"7.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_lich_frost_armor"
		}
	}


	// 不用持续释法康人
	"special_bonus_imba_lich_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------

		"LinkedAbility"
		{
			"01"	"imba_lich_sinister_gaze"
		}
	}

	//冰甲减攻速增加
	"special_bonus_imba_lich_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"200"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_lich_frost_armor"
		}
	}

	//大招弹射
	"special_bonus_imba_lich_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"40"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_lich_frost_armor"
		}
	}
	"special_bonus_imba_lich_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"0.1"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_lich_frost_nova"
		}
	}
	//冰柱带套
	"special_bonus_imba_lich_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------

		"LinkedAbility"
		{
			"01"	"imba_lich_ice_spire"
		}
	}




	// =================================================================================================================
	// Lina's Dragon Slave
	// =================================================================================================================
	"imba_lina_dragon_slave"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"lina_dragon_slave"
		"ScriptFile"	"hero/hero_lina.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"AbilityCastPoint"	"0.35"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"7.0"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"100 115 130 145"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"1100"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_lina.vsndevts"
			"particle"	"particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"primary_speed"	"1200"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"primary_start_width"	"250"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"primary_end_width"	"300"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"primary_damage"	"100 140 180 220"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"secondary_damage"	"60 80 100 120"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"secondary_amount"	"2"
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"secondary_delay"	"0.25"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"mana_normal"	"100 115 130 145"
			}
			"09"
			{
				"var_type"	"FIELD_FLOAT"
				"cd_normal"	"7.0"
			}
			"10"
			{
				"var_type"	"FIELD_INTEGER"
				"primary_speed_super"	"1800"
			}
			"11"
			{
				"var_type"	"FIELD_INTEGER"
				"primary_start_width_super"	"250"
			}
			"12"
			{
				"var_type"	"FIELD_INTEGER"
				"primary_end_width_super"	"350"
			}
			"13"
			{
				"var_type"	"FIELD_INTEGER"
				"primary_damage_super"	"200 250 300 350"
			}
			"14"
			{
				"var_type"	"FIELD_INTEGER"
				"secondary_damage_super"	"60 80 100 120"
			}
			"15"
			{
				"var_type"	"FIELD_INTEGER"
				"secondary_amount_super"	"4"
			}
			"16"
			{
				"var_type"	"FIELD_FLOAT"
				"secondary_delay_super"	"0.1"
			}
			"17"
			{
				"var_type"	"FIELD_INTEGER"
				"mana_super"	"200 230 260 290"
			}
			"18"
			{
				"var_type"	"FIELD_FLOAT"
				"cd_super"	"3.0"
			}
			"19"
			{
				"var_type"	"FIELD_INTEGER"
				"secondary_speed"	"1200"
			}
			"20"
			{
				"var_type"	"FIELD_INTEGER"
				"secondary_start_width"	"125"
			}
			"21"
			{
				"var_type"	"FIELD_INTEGER"
				"secondary_end_width"	"250"
			}
			"22"
			{
				"var_type"	"FIELD_INTEGER"
				"secondary_distance"	"700"
			}
		}
	}

	// =================================================================================================================
	// Lina's Light Strike Array
	// =================================================================================================================
	"imba_lina_light_strike_array"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"lina_light_strike_array"
		"ScriptFile"	"hero/hero_lina.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"AbilityCastPoint"	"0.35"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"7"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"90 100 110 120"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"800 900 1000 1100"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_lina.vsndevts"
			"particle"	"particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf"
			"particle"	"particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf"
			"particle"	"particles/generic_gameplay/generic_stunned.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"aoe_radius"	"230"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"cast_delay"	"0.4"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"stun_duration"	"1"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"150 200 250 300"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"cast_range"	"800 900 1000 1100"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"cd_normal"	"7.0"
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"cd_super"	"3.0"
			}
			"08"
			{
				"var_type"	"FIELD_FLOAT"
				"secondary_delay"	"0.13"
			}
			"09"
			{
				"var_type"	"FIELD_FLOAT"
				"secondary_delay_super"	"0.07"
			}
			"10"
			{
				"var_type"	"FIELD_INTEGER"
				"mana_normal"	"90 100 110 120"
			}
			"11"
			{
				"var_type"	"FIELD_INTEGER"
				"mana_super"	"180 200 220 240"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES_STRONG"
	}

	// =================================================================================================================
	// Lina's Fiery Soul
	// =================================================================================================================
	"imba_lina_fiery_soul"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"lina_fiery_soul"
		"ScriptFile"	"hero/hero_lina.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityCastPoint"	"0.0"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"7"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"0"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts"
			"particle"	"particles/units/heroes/hero_lina/lina_fiery_soul.vpcf"
			"particle"	"particles/econ/courier/courier_polycount_01/courier_trail_polycount_01a.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_as"	"10 15 20 25"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_ms"	"7 8 9 10"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"active_stacks"	"3"
			}
			"04"
			{
				"var_type"		"FIELD_INTEGER"
				"duration"		"7"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
	}

	// Stack Fire Soul As you wish
	"special_bonus_imba_lina_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"1"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_lina_fiery_soul"
		}
	}

	// =================================================================================================================
	// Lina's Laguna Blade
	// =================================================================================================================
	"imba_lina_laguna_blade"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"lina_laguna_blade"
		"ScriptFile"	"hero/hero_lina.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetFlags"	"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"2"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityCastPoint"	"0.35"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		 "HasShardUpgrade"               "1"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"70 60 50"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"280 420 560"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"700 850 1000"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_lina.vsndevts"
			"particle"	"particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf"
			"particle"	"particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"600 700 800"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"int_damage_scepter"	"2.0"
				"RequiresScepter"	"1"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"projectile_speed"	"4000"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"start_width"	"125"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"end_width"	"200"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"extra_length"	"450"
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"cd_normal"	"70 60 50"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"mana_normal"	"280 420 560"
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"start_width_super"	"125"
			}
			"10"
			{
				"var_type"	"FIELD_INTEGER"
				"end_width_super"	"300"
			}
			"11"
			{
				"var_type"	"FIELD_INTEGER"
				"extra_length_super"	"900"
			}
			"12"
			{
				"var_type"	"FIELD_FLOAT"
				"cd_super"	"3.0"
			}
			"13"
			{
				"var_type"	"FIELD_INTEGER"
				"mana_super"	"400 600 800"
			}
		}
		"HasScepterUpgrade"	"1"
	}







	// =================================================================================================================
	// Chaos Knight: Chaos Bolt
	// =================================================================================================================
	"imba_chaos_knight_chaos_bolt"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"chaos_knight_chaos_bolt"
		"ScriptFile"	"hero/hero_chaos_knight.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"4"
		"AbilityCastPoint"	"0.2 0.2 0.2 0.2"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_1"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"13 12 11 10"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"110 120 130 140"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"500"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"chaos_bolt_speed"	"1000"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"stun_min"	"1.0"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"stun_max"	"2.5 3.0 3.5 4.0"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"damage_min"	"120 160 200 240"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"damage_max"	"200 250 300 350"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"bounce_chance"	"20 25 30 35"
				"LinkedSpecialBonus"	"special_bonus_imba_chaos_knight_1"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES_STRONG"
		"AbilitySound"	"Hero_ChaosKnight.ChaosBolt.Cast"
	}

	// +20% Chaos Bolt Bounce Chance
	"special_bonus_imba_chaos_knight_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"20"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_chaos_knight_chaos_bolt"
		}
	}

	// =================================================================================================================
	// Chaos Knight: Reality Rift
	// =================================================================================================================
	"imba_chaos_knight_reality_rift"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"chaos_knight_reality_rift"
		"ScriptFile"	"hero/hero_chaos_knight.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"MaxLevel"	"4"
		"AbilityCastPoint"	"0.1"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"	"ACT_DOTA_OVERRIDE_ABILITY_2"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"6"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"50"
		"AbilityCastRange"	"475 550 625 700"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"cast_range"	"550 600 650 700"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"movement_slow"	"10 20 30 40"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"attack_slow"	"30 50 70 90"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"armor_min"	"1 2 3 4"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"armor_max"	"5 7 9 11"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"pull_chance"	"10 20 30 40"
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"3"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"AbilitySound"	"Hero_ChaosKnight.RealityRift"
		"AbilityCastGestureSlot"	"DEFAULT"
	}

	// Reality Rift Ignores Spell Immune
	"special_bonus_imba_chaos_knight_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_chaos_knight_reality_rift"
		}
	}

	// =================================================================================================================
	// Chaos Knight: Chaos Strike
	// =================================================================================================================
	"imba_chaos_knight_chaos_strike"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"chaos_knight_chaos_strike"
		"ScriptFile"	"hero/hero_chaos_knight.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"MaxLevel"	"4"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_3"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"4"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"crit_min"	"120"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"crit_max"	"130 170 210 260"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"lifesteal"	"20 40 60 80"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"extra_chance"	"15"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"max_effects"	"1"
				"LinkedSpecialBonus"	"special_bonus_imba_chaos_knight_4"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"0.5"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"AbilitySound"	"Hero_ChaosKnight.ChaosStrike"
	}

	// -2 Chaos Strike CD
	"special_bonus_imba_chaos_knight_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"-2.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_chaos_knight_chaos_strike"
		}
	}

	// +2 Chaos Strike Debuffs
	"special_bonus_imba_chaos_knight_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"2"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_chaos_knight_chaos_strike"
		}
	}

	// =================================================================================================================
	// Chaos Knight: Phantasm
	// =================================================================================================================
	"imba_chaos_knight_phantasm"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"chaos_knight_phantasm"
		"ScriptFile"	"hero/hero_chaos_knight.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetFlags"	"DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO | DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS"
		"FightRecapLevel"	"2"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"MaxLevel"	"3"
    			 "HasShardUpgrade"               "1"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.4 0.4 0.4"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"90 80 70"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"125 200 275"
		"AbilityCastRange"	"1400"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"attack_count"	"2 2 3"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"20 25 30"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"attack_cooldown"	"2"
			}
		}
		"HasScepterUpgrade"	"1"
		"AbilitySound"	"Hero_ChaosKnight.Phantasm"
	}













































	// =================================================================================================================
	//
	//
	//
	// ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓赛艇英雄↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
	//
	//
	//
	// =================================================================================================================

		//冲击波
	//=================================================================================================================
	// Keeper of the Light: Illuminate
	//=================================================================================================================
	"imba_light_illuminate"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_keeper_of_the_light.lua"
		"AbilityTextureName"			"keeper_of_the_light_illuminate"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_CHANNELLED"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilitySound"					"Hero_KeeperOfTheLight.Illuminate.Discharge"
		"precache"
		{
			"particle"		"particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf"
			"particle"		"particles/status_fx/status_effect_keeper_spirit_form.vpcf"
			"particle"		"particles/units/heroes/hero_keeper_of_the_light/kotl_illuminate_cast.vpcf"
			"particle"		"particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling_on.vpcf"
			"particle"		"particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_illuminate.vpcf"
			"particle"		"particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_illuminate_impact_small.vpcf"
			"particle"		"particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_illuminate_impact.vpcf"
			"particle"		"particles/units/heroes/hero_wisp/wisp_overcharge_b.vpcf"
			"model"			"models/courier/sw_donkey/sw_donkey_flying.vmdl"
		}

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1800"
		"AbilityCastPoint"				"0.1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"11"
		"AbilityChannelTime"			"2 3 4 5"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 125 150 175"
		"MaxLevel"					"7"
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"damage_count"				"6 8 10 12 14 16 18"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"max_channel_time"		"2 3 4 5 5 5 5"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"400"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"range"					"1550"
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"speed"					"1600.0"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"mana_cost"				"1.5"
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"mana_cost_damage"		"15.0"
			}
			"08"
			{
				"var_type"				"FIELD_FLOAT"
				"stun_duration"			"0.3"
			}
			"09"
			{
				"var_type"				"FIELD_FLOAT"
				"mana_re"			"30" //天赋回蓝
			}
			"10"
			{
				"var_type"				"FIELD_FLOAT"
				"cd_re"				"0.1" //天赋cd
			}



		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
		"HasScepterUpgrade"			"1"
		"HasShardUpgrade"			"1"
	}

	//阳炎之缚
	//=================================================================================================================
	// Keeper of the Light: Radiant Bind
	//=================================================================================================================
	"imba_light_radiant_bind"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_keeper_of_the_light.lua"
		"AbilityTextureName"			"keeper_of_the_light_radiant_bind"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET|DOTA_ABILITY_BEHAVIOR_AOE "
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_KeeperOfTheLight.ManaLeak.Cast"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.2"
		"precache"
		{
			"particle"		"particles/units/heroes/hero_wisp/wisp_overcharge_b.vpcf"
			"particle"		"particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_radiant_bind_ambient.vpcf"
		}
		// Time
		//-------------------------------------------------------------------------------------------------------------

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"60 80 100 120"
		"AbilityCooldown"				"17 16 15 14"
		// Cast Range
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"850 900 950 1000"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"6"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"slow"						"6 7 8 9"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"magic_resistance"			"20 25 30 35"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"charge_restore_time"			"14"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"mana_cost"					"1 1 2 2"
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"move_distance"					"20 30 40 50"
			}
			"07"
			{
				"var_type"					"FIELD_FLOAT"
				"radius"					"350"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}
	//灵光
	//=================================================================================================================
	// Keeper of the Light: Will-O-Wisp
	//=================================================================================================================
	"imba_light_will_o_wisp"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_keeper_of_the_light.lua"
		"AbilityTextureName"			"keeper_of_the_light_will_o_wisp"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE "
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilitySound"					"Hero_KeeperOfTheLight.ManaLeak.Cast"

		"MaxLevel"						"3"


		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"70"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"250"

		// Cast Range
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"800"
		"precache"
		{
			"particle"		"particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling.vpcf"
			"particle"		"particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling_on.vpcf"
			"particle"		"particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling_debuff.vpcf"
			"particle"		"particles/status_fx/status_effect_keeper_dazzle.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"on_count"					"3 4 5"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"725"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"hit_count"					"6 10 14"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"off_duration"				"1.8"
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"on_duration"				"1.3"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"fixed_movement_speed"		"60"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}



	//灵魂形态
	//=================================================================================================================
	// Keeper of the Light: Spirit Form
	//=================================================================================================================
	"imba_light_spirit_form"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_keeper_of_the_light.lua"
		"AbilityTextureName"			"keeper_of_the_light_spirit_form"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_TOGGLE"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"					"Hero_KeeperOfTheLight.SpiritForm"
 		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_6"
		"MaxLevel"						"1"
		// Time
		//-------------------------------------------------------------------------------------------------------------

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"particle"		"particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf"
			"particle"		"particles/econ/courier/courier_greevil_white/courier_greevil_white_ambient_3.vpcf"
		}

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"4"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"move_speed"				"25"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"cd"						"8"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"magic"						"40"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"movement_speed"			"0"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"cast_range"				"0"
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"illuminate_heal"			"0"
			}

		}
	}

	//致盲之光
	//=================================================================================================================
	// Keeper of the Light: Blinding Light
	//=================================================================================================================
	"imba_light_blinding_light"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_keeper_of_the_light.lua"
		"AbilityTextureName"			"keeper_of_the_light_blinding_light"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_POINT "
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_KeeperOfTheLight.BlindingLight"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1100 1100 1100 1100"
		"AbilityCastPoint"				"0.2"
 		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_5"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"22"
		"precache"
		{
			"particle"		"particles/econ/items/keeper_of_the_light/kotl_ti10_immortal/kotl_ti10_blinding_light.vpcf"
			"particle"		"particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf"
			"particle"		"particles/status_fx/status_effect_keeper_spirit_form.vpcf"
			"particle"		"particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling_on.vpcf"
			"particle"		"particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf"
		}
		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"150"
		"MaxLevel"						"1"


		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"miss_rate"				"50"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"4"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"600"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"150"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"duration_wisp"			"22"
			}

		}
	}


			//
	"special_bonus_imba_keeper_of_the_light_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	 "2"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_light_illuminate"
		}
	}
			//阳炎初始
		"special_bonus_imba_keeper_of_the_light_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "350"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_light_radiant_bind"
		}
	}
			//查克拉
		"special_bonus_imba_keeper_of_the_light_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	 "30.0"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_light_illuminate"
		}
	}
			//双驱散
		"special_bonus_imba_keeper_of_the_light_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	 "0.1"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_light_illuminate"
		}
	}
			//光之守卫
		"special_bonus_imba_keeper_of_the_light_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------

	}
			//致盲敲晕
		"special_bonus_imba_keeper_of_the_light_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	 "1"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_light_blinding_light"
		}
	}
			//视野
		"special_bonus_imba_keeper_of_the_light_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "1000"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_light_will_o_wisp"
		}
	}
			//致盲之光降低80%视野
		"special_bonus_imba_keeper_of_the_light_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "600"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_light_blinding_light"
		}
	}






// =================================================================================================================
	//////小小
	//=================================================================================================================
	// Tiny: Avalanche
	//=================================================================================================================
	"imba_tiny_avalanche"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_tiny.lua"
		"AbilityTextureName"			"tiny_avalanche"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Ability.Avalanche"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"26 22 18 14"


		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"120 120 120 120"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"250"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"damage_interval"				"0.3"
				"CalculateSpellDamageTooltip"	"0"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"total_duration"			"1.8"
			}

			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"stun_duration"				"0.2"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"projectile_speed"			"1200"
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"damage_per"				"20 40 60 80"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	//=================================================================================================================
	// Tiny: Toss
	//=================================================================================================================
	"imba_tiny_toss"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_tiny.lua"
		"AbilityTextureName"			"tiny_toss"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_CUSTOM"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_CUSTOM"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"				"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000 1100 1200 1300"
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"17 15 13 11"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"90 100 110 120"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.25"	// generally used for damage only

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"1.0"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"grab_radius"			"275"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"275"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"bonus_damage_pct"		"30"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"damage"				"90 180 270 360"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"toss_dis"				"1000 1100 1200 1300"
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"stun_duration"				"1.7"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	//=================================================================================================================
	// Tiny: Craggy Exterior
	//=================================================================================================================
	"imba_tiny_craggy_exterior"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_tiny.lua"
		"AbilityTextureName"			"tiny_craggy_exterior"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"AbilitySound"					"Hero_Tiny.CraggyExterior.Stun"
		"AbilityCastRange"				"1000 1100 1200 1300"
		"AbilityCooldown"				"18"
		"MaxLevel"						"1"
		"FightRecapLevel"				"1"
		"IsGrantedByShard"				"1"
        "HasShardUpgrade"               "1"

		// Stats
		//-------------------------------------------------------------------------------------------------------------

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"stun_chance"				"17"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"stun_duration"				"1.0"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"damage"					"100"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"250"
			}
		}
	}

	//=================================================================================================================
	// Tiny: Tree Grab
	//=================================================================================================================
	"imba_tiny_tree_grab"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_tiny.lua"
		"AbilityTextureName"			"tiny_tree_grab"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET|DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_TREE | DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_CUSTOM | DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"					"Hero_Tiny.CraggyExterior.Stun"
		"HasScepterUpgrade"				"1"
        "HasShardUpgrade"               "1"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"165"
		"AbilityCastPoint"				"0.0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"16 14 12 10"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"40"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportBonus"		"35"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"attack_count"				"5 10 15 20"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_damage"				"25"
				"LinkedSpecialBonus"		"special_bonus_imba_tiny_4"
				"CalculateSpellDamageTooltip"	"0"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_damage_buildings"		"60 80 100 120"
				"CalculateSpellDamageTooltip"	"0"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"attack_range"				"250"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"splash_width"				"200"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"splash_range"				"300"
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"duration_hero_enemy"				"3"
			}
			"08"
			{
				"var_type"					"FIELD_INTEGER"
				"duration_hero_fr"				"60"
			}
			"09"
			{
				"var_type"					"FIELD_INTEGER"
				"splash_damage"				"40 60 80 100"
				"CalculateSpellDamageTooltip"	"0"
			}
			"10"
			{
				"var_type"			"FIELD_FLOAT"
				"speed"		"900.0"
			}
			"11"
			{
				"var_type"					"FIELD_INTEGER"
				"splash_radius"				"275"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}

	//=================================================================================================================
	// Ability: Tiny Toss Tree
	//=================================================================================================================
	"imba_tiny_toss_tree"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_tiny.lua"
		"AbilityTextureName"			"tiny_toss_tree"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"				"1"
		"LinkedAbility"					"imba_tiny_tree_grab"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1200"
		"AbilityCastPoint"				"0.1"
 		"AbilityCastAnimation"		"ACT_INVALID"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_FLOAT"
				"speed"		"900.0"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"splash_radius"				"275"
			}
		}
	}

	//=================================================================================================================
	// Ability: Tiny Tree Channel (Scepter)
	//=================================================================================================================
	"imba_tiny_tree_channel"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_tiny.lua"
		"AbilityTextureName"			"tiny_tree_channel"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_CHANNELLED  | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"				"1"
		"MaxLevel"						"1"
        "HasScepterUpgrade"				"1"
        "IsGrantedByScepter"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityChannelTime"			"3.2"
		"AbilityCastRange"				"1200"
		"AbilityCastPoint"				"0.2"
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_4"
		"AbilityChannelAnimation"		"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"15"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"200"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"speed"		"1000.0"
				"RequiresScepter"			"1"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"range"		"1200"
				"RequiresScepter"			"1"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"splash_radius"				"400"
			}
			"04"
			{
				"var_type"			"FIELD_INTEGER"
				"tree_grab_radius"		"800"
				"RequiresScepter"			"1"
			}
			"05"
			{
				"var_type"			"FIELD_FLOAT"
				"interval"		"0.4"
				"RequiresScepter"			"1"
			}

			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"abilitychanneltime"		"3.2"
				"RequiresScepter"			"1"
			}
		}
	}


	//=================================================================================================================
	// Tiny: Grow
	//=================================================================================================================
	"imba_tiny_grow"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_tiny.lua"
		"AbilityTextureName"			"tiny_grow"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilitySound"					"Tiny.Grow"
		"AbilityCooldown"				"20"
		"precache"
		{

			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_01_head.vmdl"
			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_01_right_arm.vmdl"
			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_01_left_arm.vmdl"
			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_01_left_arm.vmdl"

			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_02_head.vmdl"
			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_02_right_arm.vmdl"
			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_02_left_arm.vmdl"
			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_02_left_arm.vmdl"

			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_03_head.vmdl"
			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_03_right_arm.vmdl"
			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_03_left_arm.vmdl"
			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_03_left_arm.vmdl"

			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_04_head.vmdl"
			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_04_right_arm.vmdl"
			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_04_left_arm.vmdl"
			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_lvl_04_left_arm.vmdl"

			"model"			"models/items/tiny/tiny_prestige/tiny_prestige_sword.vmdl"

		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_damage"				"40 80 120"
				"CalculateSpellDamageTooltip"	"0"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"scale"						"30 40 50"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"damage"					"100 200 300"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"0.8"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"400"
			}
		}
	}
		//------
	"special_bonus_imba_tiny_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "400"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_treant_eyes_in_the_forest"
		}
	}
		//---------
	"special_bonus_imba_tiny_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "400"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_treant_eyes_in_the_forest"
		}
	}
		//抓树移除使用次数限制
	"special_bonus_imba_tiny_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"LinkedAbility"
		{
			"01"	"imba_tiny_tree_grab"
		}
	}
		//抓树伤害增加
	"special_bonus_imba_tiny_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "15"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_tiny_tree_grab"
		}
	}
		//投掷抓取目标数量
	"special_bonus_imba_tiny_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "3"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_tiny_toss"
		}
	}
		//攻击击飞
	"special_bonus_imba_tiny_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "15"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_tiny_grow"
		}
	}
		//减少山崩冷却时间
	"special_bonus_imba_tiny_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "6"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_tiny_avalanche"
		}
	}
		//山岭巨人
	"special_bonus_imba_tiny_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "400"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_tiny_grow"
		}
	}




//大树
	//=================================================================================================================
	// Treant Protector: Nature's Guise
	//=================================================================================================================
	"imba_treant_natures_guise"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_treant.lua"
		"AbilityTextureName"			"treant_natures_guise"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"FightRecapLevel"				"2"
		"MaxLevel"						"1"
		"AbilitySound"					"Hero_Treant.NaturesGuise.On"
		"AbilityCooldown"				"15.0"
        "HasShardUpgrade"               "1"
		"precache"
		{
			"particle"		"particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf"
			"particle"		"particles/generic_hero_status/status_invisibility_start.vpcf"
			"particle"		"particles/units/heroes/hero_treant/treant_naturesguise_cast.vpcf"

		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"300"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"stun"						"1.0" //敲晕时间
				"LinkedSpecialBonus"			"special_bonus_imba_treant_5"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"cooldown_time"				"4"  //渐隐时间
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"regen_amp"					"40"	//恢复增加
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"movement_bonus"			"25"	//移动增加
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"damage"					"300"	//伤害
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"cri"						"200"	//暴击
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}
	//=================================================================================================================
	//  Treant Protector: Nature's Grasp
	//=================================================================================================================
	"imba_treant_natures_grasp"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_treant.lua"
		"AbilityTextureName"			"treant_natures_grasp"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_TREE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"AbilitySound"					"Hero_Treant.NaturesGuise.On"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
				"precache"
		{
			"particle"		"particles/units/heroes/hero_treant/treant_bramble_root.vpcf"
		}
		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1500"
		"AbilityCastPoint"				"0.2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"22 20 18 16"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"75 80 85 90"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"damage"					"90 110 130 150"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"movement_slow"				"25 30 35 40"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"vines_duration"				"4.5 5 5.5 6"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"range"						"1500"	//长度
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"damage_ex"						"1.5"		//额外伤害倍率
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
		"HasScepterUpgrade"			"1"
	}

	//=================================================================================================================
	// Treant Protector: Leech Seed
	//=================================================================================================================
	"imba_treant_leech_seed"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_treant.lua"
		"AbilityTextureName"			"treant_leech_seed"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_Treant.LeechSeed.Cast"

		"AbilityCastPoint"				"0.4"
		"AbilityCastRange"				"400 550 700 850"
		"FightRecapLevel"				"1"
		"precache"
		{
			"particle"		"particles/units/heroes/hero_treant/treant_leech_seed_damage_pulse.vpcf"
			"particle"		"particles/units/heroes/hero_treant/treant_leech_seed_projectile.vpcf"
		}
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"18 16 14 12"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"80 90 100 110"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_FLOAT"
				"damage_interval"				"1" //间隔 别动
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"leech_damage"					"30 50 70 90" //每次伤害
			}
			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"movement_slow"					"-10 -15 -20 -25"	//减速
			}
			"05"
			{
				"var_type"						"FIELD_INTEGER"
				"radius"						"650"	//范围 加血和寻树范围
			}
			"06"
			{
				"var_type"						"FIELD_FLOAT"
				"duration"						"5.0"
			}
			"07"
			{
				"var_type"						"FIELD_INTEGER"
				"projectile_speed"				"450"
			}
			"08"
			{
				"var_type"						"FIELD_INTEGER"
				"heal"							"50 100 150 200"
			}
			"09"
			{
				"var_type"						"FIELD_FLOAT"
				"heal_tree"						"1"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	//=================================================================================================================
	// Treant Protector: Living Armor
	//=================================================================================================================
	"imba_treant_living_armor"
	{

		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_treant.lua"
		"AbilityTextureName"			"treant_living_armor"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_CHANNELLED"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_BUILDING"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_Treant.LivingArmor.Cast"
		"AbilityChannelTime"			"1.5"
		//"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0.2"
		"FightRecapLevel"				"1"
		"precache"
		{
			"particle"		"particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_cast_beam.vpcf"
			"particle"		"particles/units/heroes/hero_treant/treant_livingarmor.vpcf"
		}
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"12"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50"

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"total_heal"		"200 300 400 500"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"bonus_armor"		"4 6 8 10"
			}
			"03"
			{
				"var_type"			"FIELD_FLOAT"
				"duration"			"12.0"
			}
			"04"
			{
				"var_type"			"FIELD_FLOAT"
				"heal_hero"			"2 2 3 4"	//英雄回血倍数
			}
			"05"
			{
				"var_type"			"FIELD_FLOAT"
				"radius"			"650"	//树木范围
			}


		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}

	//=================================================================================================================
	// Treant Protector: Overgrowth
	//=================================================================================================================
	"imba_treant_overgrowth"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_treant.lua"
		"AbilityTextureName"			"treant_overgrowth"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_Treant.Overgrowth.Cast"
		"AbilityCastRange"				"800 1000 1200"
		"AbilityCastPoint"				"0.3"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_5"

		"FightRecapLevel"				"2"

		"HasScepterUpgrade"				"1"
		"AbilityDraftUltScepterAbility"		"treant_eyes_in_the_forest"
		"precache"
		{
			"particle"		"particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_cast.vpcf"
			"particle"		"particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf"
			"particle"		"particles/basic_ambient/generic_range_display.vpcf"
			"particle"		"particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf"
			"model"		"maps/jungle_assets/trees/kapok/export/kapok_001.vmdl"
			"model"		"maps/jungle_assets/trees/kapok/export/kapok_002.vmdl"
			"model"		"maps/jungle_assets/trees/kapok/export/kapok_003.vmdl"
			"model"		"maps/jungle_assets/trees/kapok/export/kapok_004.vmdl"
		}
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"100"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"200 250 300"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_FLOAT"
				"duration"						"3.0 4.0 5.0"
			}

			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"radius"						"800 1000 1200"
			}

			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"eyes_radius"					"800"
				"LinkedSpecialBonus"			"special_bonus_imba_treant_7"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"damage"						"100 200 300"
			}
		}
	}

	//=================================================================================================================
	// Treant: Eyes In The Forest ( scepter ability )
	//=================================================================================================================
	"imba_treant_eyes_in_the_forest"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_treant.lua"
		"AbilityTextureName"			"treant_eyes_in_the_forest"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_TREE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"MaxLevel"						"1"
		"FightRecapLevel"				"1"
		//"IsGrantedByScepter"			"1"
		//"HasScepterUpgrade"				"1"
		"AbilitySound"					"Hero_Treant.Eyes.Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"500"
		"AbilityCooldown"				"18"
		"AbilityCastPoint"				"0.2"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------


		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"
		"precache"
		{
			"particle"		"particles/units/heroes/hero_treant/treant_eyesintheforest.vpcf"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_FLOAT"
				"vision_aoe"		"0" //原版修饰器用
				"RequiresScepter"				"1"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"overgrowth_aoe"		"0" //原版修饰器用
				"RequiresScepter"				"1"
			}
			"03"
			{
				"var_type"			"FIELD_INTEGER"
				"tree_respawn_seconds"		"10"
				"RequiresScepter"				"1"
			}
			"04"
			{
				"var_type"			"FIELD_INTEGER"
				"max"				"5"

			}
			"05"
			{
				"var_type"			"FIELD_INTEGER"
				"radius_root"				"600"
			}
			"06"
			{
				"var_type"			"FIELD_INTEGER"
				"duration_root"				"3"
			}
			"07"
			{
				"var_type"			"FIELD_FLOAT"
				"vision_aoe_imba"		"800" // 描述用
				"LinkedSpecialBonus"			"special_bonus_imba_treant_7"
				"RequiresScepter"				"1"
			}
			"08"
			{
				"var_type"			"FIELD_INTEGER"
				"overgrowth_aoe_imba"		"800" //描述用
				"LinkedSpecialBonus"			"special_bonus_imba_treant_7"
				"RequiresScepter"				"1"
			}
		}
	}
	//自然庇护获得隐身
	"special_bonus_imba_treant_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------

		"LinkedAbility"
		{
			"01"	"imba_treant_natures_guise"
		}
	}
	//树甲护甲提升
	"special_bonus_imba_treant_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "650"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_witch_doctor_death_ward"
		}
	}
	//缠绕之拳
	"special_bonus_imba_treant_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	 "2.2"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_treant_natures_guise"
		}
	}
	//范围活体护甲
	"special_bonus_imba_treant_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "450"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_treant_living_armor"
		}
	}
	//丛林庇护敲晕增加
	"special_bonus_imba_treant_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	 "1.2"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_treant_natures_guise"
		}
	}
	//自然庇护变为飞行移动
	"special_bonus_imba_treant_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "4"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_treant_eyes_in_the_forest"
		}
	}
		//丛林之眼范围增加
	"special_bonus_imba_treant_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "500"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_treant_eyes_in_the_forest"
		}
	}
		//丛林探险家
	"special_bonus_imba_treant_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "1000"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_treant_natures_guise"
		}
	}

	/////////////////////////////////////////
	//witch_doctor
	////////////////////////////////////////
	//=================================================================================================================
	// Witch Doctor: Paralyzing Cask  麻痹药剂
	//=================================================================================================================
	"imba_witch_doctor_paralyzing_cask"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_witch_doctor.lua"
		"AbilityTextureName"			"witch_doctor_paralyzing_cask"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_WitchDoctor.Paralyzing_Cask_Cast"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1500"
		"AbilityCastPoint"				"0.1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"11"

		// Damage.
		//-------------------------------------------------------------------------------------------------------------
		"AbilityDamage"					"75 100 125 150"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"80 100 120 140"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.5"	// Can have multiple bounces

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"particle"	"particles/units/heroes/hero_witchdoctor/witchdoctor_cask.vpcf"
			"soundfile"	"sounds/weapons/hero/witch_doctor/cask_cast.vsnd"
			"soundfile"	"sounds/weapons/hero/witch_doctor/cask_bounce01.vsnd"
			"soundfile"	"sounds/weapons/hero/witch_doctor/cask_bounce02.vsnd"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"stun_duration"			"1.0"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"paralyzed_duration"		"1.5"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"50 100 150 200"
				"LinkedSpecialBonus"	"special_bonus_imba_witch_doctor_1"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"dis"			"300"	//弹跳距离
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"bounces"				"5 5 6 10"	//弹跳次数
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"speed"					"1000"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"stun_radius"					"300"
			}
			"08"
			{
				"var_type"				"FIELD_INTEGER"
				"heal_radius"					"400"
				"LinkedSpecialBonus"	"special_bonus_imba_witch_doctor_3"
			}
			"09"
			{
				"var_type"				"FIELD_FLOAT"
				"heal_duration"					"5.0"
			}
			"10"
			{
				"var_type"				"FIELD_INTEGER"
				"bounces_enemy"					"5 5 5 5"
			}



		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	//=================================================================================================================
	// Witch Doctor: Voodoo Restoration 巫毒恢复术
	//=================================================================================================================
	"imba_witch_doctor_voodoo_restoration"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_witch_doctor.lua"
		"AbilityTextureName"			"witch_doctor_voodoo_restoration"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET "
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"AbilitySound"					"Hero_WitchDoctor.Voodoo_Restoration"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"10"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"30"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"particle"	"particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf"
			"particle"	"particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration_flame.vpcf"
			"particle"	"particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack_explosion.vpcf"
			"soundfile"	"sounds/weapons/hero/witch_doctor/voodoo_restoration.vsnd"
			"soundfile"	"sounds/weapons/hero/witch_doctor/voodoo_restoration_loop.vsnd"
			"soundfile"	"sounds/weapons/hero/witch_doctor/voodoo_restoration_off.vsnd"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"mana_per_second"			"35 45 55 65"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"600"
				"LinkedSpecialBonus"	"special_bonus_imba_witch_doctor_3"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"heal"						"15 30 45 60"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"heal_interval"				"0.5"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"heal_debuff"					"50"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"					"6.0"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	//=================================================================================================================
	// Witch Doctor: Maledict
	//=================================================================================================================
	"imba_witch_doctor_maledict"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_witch_doctor.lua"
		"AbilityTextureName"			"witch_doctor_voodoo_switcheroo"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_POINT |DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES "
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"MaxLevel"						"1"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_WitchDoctor.Maledict_Cast"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0.35 0.35 0.35 0.35"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"30"

		// Damage.
		//-------------------------------------------------------------------------------------------------------------

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"105 110 115 120"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"particle"	"particles/units/heroes/hero_witchdoctor/witchdoctor_maledict.vpcf"
			"particle"	"particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_aoe.vpcf"
			"soundfile"	"sounds/weapons/hero/witch_doctor/maledict_cast.vsnd"
			"soundfile"	"sounds/weapons/hero/witch_doctor/maledict_fail.vsnd"
			"soundfile"	"sounds/weapons/hero/witch_doctor/maledict_loop.vsnd"
			"soundfile"	"sounds/weapons/hero/witch_doctor/maledict_tick.vsnd"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"500"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"inv"						"2"	//诅咒间隔
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"slow"						"60"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"damage"					"60"	//伤害
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"duration"					"6.0"
			}
		}
		"HasScepterUpgrade"			"1"
		//"IsGrantedByScepter"		"1"
	}

	//=================================================================================================================
	// Witch Doctor: Death Ward
	//=================================================================================================================
	"imba_witch_doctor_death_ward"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_witch_doctor.lua"
		"AbilityTextureName"			"wuyi"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_CHANNELLED"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_NO_INVIS | DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE | DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE | DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES | DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_WitchDoctor.Death_WardBuild"


		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0.35 0.35 0.35"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"
		"AbilityChannelAnimation"		"ACT_DOTA_CHANNEL_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"60"
		"AbilityChannelTime"			"8.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"200 200 200"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"particle"	"particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack.vpcf"
			"particle"	"particles/units/heroes/hero_witchdoctor/witchdoctor_deathward_glow_c.vpcf"
			"particle"	"particles/units/heroes/hero_witchdoctor/witchdoctor_ward_skull.vpcf"
			"particle"	"particles/units/heroes/hero_witchdoctor/witchdoctor_ward_cast_staff_fire.vpcf"
			"soundfile"	"sounds/weapons/hero/witch_doctor/deathward_build.vsnd"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"700"
				"CalculateSpellDamageTooltip"	"0"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"channel"					"8"	//持续施法时间
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"hp"						"8"	//被击次数
				"LinkedSpecialBonus"	"special_bonus_imba_witch_doctor_6"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"inv"						"0.3" //攻击间隔
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"stun"						"0.1" //晕
			}
			"06"
			{
				"var_type"					"FIELD_FLOAT"
				"per"						"2"	//巫毒疗法倍数
			}
			"07"
			{
				"var_type"					"FIELD_FLOAT"
				"heal_radius"				"600"	//巫毒疗法范围
				"LinkedSpecialBonus"	"special_bonus_imba_witch_doctor_3"
			}

		}
	}

	//=================================================================================================================
	// Witch Doctor: Voodoo Switcheroo
	//=================================================================================================================
	"imba_witch_doctor_voodoo_switcheroo"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_witch_doctor.lua"
		"AbilityTextureName"			"witch_doctor_death_ward"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_CHANNELLED | DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"MaxLevel"						"4"
		//"IsGrantedByShard"				"1"
		//"HasShardUpgrade"				"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0.35 0.35 0.35"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"
		"AbilityChannelAnimation"		"ACT_DOTA_CHANNEL_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"28.0 26.0 24.0 22.0"
		"AbilityChannelTime"			"5.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"250"


		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"		"5.00"	//持续时间   需要再代码里改
				"LinkedSpecialBonus"	"special_bonus_imba_witch_doctor_5"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"num"			"1"	//数量
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"num_shard"		"2"	//魔晶+1
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"damage"		"40 60 80 100"	//守卫攻击
			}
			"05"
			{
				"var_type"				"FIELD_FLOAT"
				"intv"			"0.9 0.7 0.5 0.3"	//守卫间隔
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"bo"				"3"	//弹射次数
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"kno"					"50"	//击退距离
			}
			"08"
			{
				"var_type"				"FIELD_INTEGER"
				"slow"					"15 20 25 30"	//减速
			}
			"09"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"					"600"	//减速
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_4"
		"HasShardUpgrade"				"1"
	}

			//麻痹药剂伤害
	"special_bonus_imba_witch_doctor_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "100"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_witch_doctor_paralyzing_cask"
		}
	}
			//麻痹药剂冷却
		"special_bonus_imba_witch_doctor_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "2"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_witch_doctor_paralyzing_cask"
		}
	}
			//回血范围增加
		"special_bonus_imba_witch_doctor_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "100"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_witch_doctor_voodoo_restoration"
			"02"	"imba_witch_doctor_paralyzing_cask"
			"03"	"imba_witch_doctor_death_ward"
		}
	}
			//回血变开关
		"special_bonus_imba_witch_doctor_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"LinkedAbility"
		{
			"01"	"imba_witch_doctor_voodoo_restoration"
		}
	}
			//法老守卫持续时间
		"special_bonus_imba_witch_doctor_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "2"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_witch_doctor_voodoo_switcheroo"
		}
	}
			//巫蛊之物血量增加
		"special_bonus_imba_witch_doctor_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "6"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_witch_doctor_death_ward"
		}
	}
			//巫蛊之舞时获得技能免疫
		"special_bonus_imba_witch_doctor_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------

		"LinkedAbility"
		{
			"01"	"imba_witch_doctor_death_ward"
		}
	}
			//死亡咒术不可驱散
		"special_bonus_imba_witch_doctor_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------

		"LinkedAbility"
		{
			"01"	"imba_witch_doctor_maledict"
		}
	}







//=================================================================================================================
	// Luna: Lucent Beam
	//=================================================================================================================
	"imba_luna_lucent_beam"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_luna.lua"
		"AbilityTextureName"			"luna_lucent_beam"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Luna.LucentBeam.Target"


		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"800"
		"AbilityCastPoint"				"0.1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"6.0 6.0 6.0 6.0"


		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"90 100 110 120"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.5"	// Mostly about the damage

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"stun_duration"			"0.8"
				"LinkedSpecialBonus"	"special_bonus_imba_luna_4"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"beam_damage"			"60 140 220 300"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"r_radius"				"325"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"enemy_count"			"2"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"v_radius"				"500"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"v_duration"			"2.0"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	//=================================================================================================================
	// Luna: Moon Glaives
	//=================================================================================================================
	"imba_luna_moon_glaive"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_luna.lua"
		"AbilityTextureName"			"luna_moon_glaive"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilitySound"					"Hero_Luna.MoonGlaive.Impact"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"range"						"500"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"bounces"					"3 4 5 6"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"damage_reduction_percent"	"30"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"range_bonus"				"5"	//攻击距离加成
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	//=================================================================================================================
	// Luna: Lunar Blessing
	//=================================================================================================================
	"imba_luna_lunar_blessing"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_luna.lua"
		"AbilityTextureName"			"luna_lunar_blessing"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"HasScepterUpgrade"			"1"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"			"800"
				"LinkedSpecialBonus"	"special_bonus_imba_luna_6"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_all"				"10 20 30 40"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_night_vision"		"250 500 750 1000"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"stat"						"2" //主属性伤害倍率
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"p_radius"						"800"	//被动寻找范围
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"cd"							"4"		//被动冷却 必须整数
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"heal"							"24"	//被动恢复速度
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}

	//=================================================================================================================
	// Luna: Lunar Grace
	//=================================================================================================================
	"imba_luna_lunar_grace"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_luna.lua"
		"AbilityTextureName"			"luna_lunar_grace"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityCastRange"				"900"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"12"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"40"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
		"HasShardUpgrade"               "1"
	}

	//=================================================================================================================
	// Luna: Eclipse
	//=================================================================================================================
	"imba_luna_eclipse"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_luna.lua"
		"AbilityTextureName"			"luna_eclipse"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Luna.Eclipse.Cast"
		"HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.5"

		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"150"
		"AOERadius"				"675"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"150 200 250"
		"AbilityCastRange"				"1000"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"beams"						"6 9 12"
				"LinkedSpecialBonus"	"special_bonus_imba_luna_8"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"beam_interval"				"0.6 0.4 0.2"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"675"
				"LinkedSpecialBonus"	"special_bonus_imba_luna_5"
			}
			"04"
			{
				"var_type"					"FIELD_FLOAT"
				"night_duration"				"10.0"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"move_sp"				"20"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"mag"					"2"
			}


		}
	}
	//-2秒月光cd
		"special_bonus_imba_luna_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"2"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_luna_lucent_beam"
		}
	}
		//月蚀可以点地释放
		"special_bonus_imba_luna_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
	}
		//月之祝福视野共享队友
		"special_bonus_imba_luna_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------

		"LinkedAbility"
		{
			"01"	"imba_luna_lunar_blessing"
		}
	}
		//0.2全月光眩晕
		"special_bonus_imba_luna_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"0.2"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_luna_lucent_beam"
		}
	}
		//+300月蚀范围
		"special_bonus_imba_luna_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"300"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_luna_eclipse"
		}
	}
	//600光环范围
		"special_bonus_imba_luna_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"600"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_luna_lunar_blessing"
		}
	}
		//月蚀cd-20
		"special_bonus_imba_luna_7"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"20"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_luna_eclipse"
		}
	}
		//月蚀月光数量
		"special_bonus_imba_luna_8"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	 "6"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_luna_eclipse"
		}
	}







	//钢背
	//=================================================================================================================
	// Bristleback: Viscous Nasal Goo
	//=================================================================================================================

	"imba_bristleback_viscous_nasal_goo"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"					"ability_lua"
		"ScriptFile"				"ting/hero_bristleback.lua"
		"AbilityTextureName"		"bristleback_viscous_nasal_goo"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Bristleback.ViscousGoo.Cast"

		"HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0.1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"1.5 1.5 1.5 1.5"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"12 16 20 24"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"goo_speed"				"1200"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"goo_duration"			"5.0"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"base_armor"			"2"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"armor_per_stack"		"1.5 2.0 2.5 3.0"
				"LinkedSpecialBonus"	"special_bonus_imba_bristleback_2"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"base_move_slow"		"5"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"move_slow_per_stack"	"3 6 9 12"
			}
			"07"
			{
				"var_type"				"FIELD_INTEGER"
				"stack_limit"			"4 4 5 5"
				"LinkedSpecialBonus"	"special_bonus_imba_bristleback_4"
			}
			"08"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"			"600"
			}
			"09"
			{
				"var_type"				"FIELD_FLOAT"
				"fear_duration"			"0.4"
			}
			"10"
			{
				"var_type"				"FIELD_FLOAT"
				"heal_re"				"10.0"
			}

			"11"
			{
				"var_type"				"FIELD_INTEGER"
				"scept_exradius"				"300"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	//=================================================================================================================
	// Bristleback: Quill Spray
	//=================================================================================================================
	"imba_bristleback_quill_spray"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"					"ability_lua"
		"ScriptFile"				"ting/hero_bristleback.lua"
		"AbilityTextureName"		"bristleback_quill_spray"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Bristleback.QuillSpray"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastAnimation"			"ACT_INVALID"
		"AbilityCastRange"				"650"
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"2.5"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"35 35 35 35"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"750"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"quill_base_damage"		"90 110 130 150"
			}
			"03"
			{
				"var_type"				"FIELD_FLOAT"
				"quill_stack_damage"	"25"
				"LinkedSpecialBonus"	"special_bonus_imba_bristleback_5"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"quill_stack_duration"	"13.0"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"projectile_speed"		"2400"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"cooldown_reduction"		"0.3"
			}
		}
	}

	//=================================================================================================================
	// Bristleback: Bristleback
	//=================================================================================================================
	"imba_bristleback_bristleback"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"					"ability_lua"
		"ScriptFile"				"ting/hero_bristleback.lua"
		"AbilityTextureName"		"bristleback_bristleback"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_TOGGLE | DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL"
		"AbilitySound"					"Hero_Bristleback.Bristleback"
		"AbilityCooldown"				"1"
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"side_damage_reduction"			"10 15 25 30"
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"back_damage_reduction"			"20 30 40 50"
			}
			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"side_angle"					"110"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"back_angle"					"70"
			}
			"05"
			{
				"var_type"						"FIELD_INTEGER"
				"quill_release_threshold"				"310"
			}
			"06"
			{
				"var_type"						"FIELD_INTEGER"
				"ass_slow"						"30"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}

	//=================================================================================================================
	// Bristleback: Warpath
	//=================================================================================================================
	"imba_bristleback_warpath"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"					"ability_lua"
		"ScriptFile"				"ting/hero_bristleback.lua"
		"AbilityTextureName"		"bristleback_warpath"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_CHANNELLED "
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		//ACT_DOTA_VICTORY ACT_DOTA_GENERIC_CHANNEL_1
		"AbilityCastAnimation"			"ACT_DOTA_VICTORY"
		"AbilityChannelAnimation"		"ACT_DOTA_VICTORY"
		"AbilityCastPoint"				"0"
		"AbilityChannelTime"			"1.90"
		"AbilityCooldown"				"30"
		// Casting
		//-------------------------------------------------------------------------------------------------------------

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"damage_per_stack"					"25 30 35"
				"LinkedSpecialBonus"				"special_bonus_imba_bristleback_6"
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"move_speed_per_stack"				"2 3 4"
			}
			"03"
			{
				"var_type"						"FIELD_FLOAT"
				"duration_warpath"				"7.0"
			}
			"04"
			{
				"var_type"						"FIELD_INTEGER"
				"max_stacks"					"5 7 9"
			}
			"05"
			{
				"var_type"						"FIELD_FLOAT"
				"taunt_dur"						"0.6"
			}
			"06"
			{
				"var_type"						"FIELD_FLOAT"
				"armor_per_stack"						"1.5"
			}

		}
	}

	//=================================================================================================================
	// Bristleback: Hairball (Shard)
	//=================================================================================================================
	"imba_bristleback_hairball"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"					"ability_lua"
		"ScriptFile"				"ting/hero_bristleback.lua"
		"AbilityTextureName"		"bristleback_hairball"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_HIDDEN | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ALLIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilityCharges"				"1"
		"AbilityChargeRestoreTime"		"10"
		"MaxLevel"						"1"
		"FightRecapLevel"				"1"
		"IsGrantedByShard"			    "1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1500"
		"AbilityCastPoint"				"0.1"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"


		// Time
		//-------------------------------------------------------------------------------------------------------------

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"projectile_speed"		"1200"
			}
			"02"
			{
				"var_type"			"FIELD_FLOAT"
				"root"				"1.3"
			}
			"03"
			{
				"var_type"			"FIELD_INTEGER"
				"root_radius"		"350"
			}
			"04"
			{
				"var_type"			"FIELD_INTEGER"
				"quill_stack"		"2"
			}
			"05"
			{
				"var_type"			"FIELD_INTEGER"
				"goo_stack"		"1"
				"LinkedSpecialBonus"	"special_bonus_imba_bristleback_3"
			}

		}
		"HasShardUpgrade"               "1"
	}
	//战意攻击
		"special_bonus_imba_bristleback_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"29"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_bristleback_warpath"
		}
	}
	//刺叠加伤害
		"special_bonus_imba_bristleback_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"25"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_bristleback_quill_spray"
		}
	}
	//鼻涕叠加上限
		"special_bonus_imba_bristleback_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"3"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_bristleback_viscous_nasal_goo"
		}
	}
	//毛球额外释放一次鼻涕
		"special_bonus_imba_bristleback_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_bristleback_hairball"
		}
	}
	//鼻涕额外降低护甲
		"special_bonus_imba_bristleback_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"		"1.5"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_bristleback_viscous_nasal_goo"
		}
	}

	// =================================================================================================================
// Huskar: Inner Fire
	//=================================================================================================================
	"imba_huskar_inner_fire"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"huskar_inner_fire"
		"ScriptFile"	"ting/hero_huskar.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilitySound"					"Hero_Huskar.Inner_Vitality"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0.1"
		"LinkedTalents"
		{
			"special_bonus_imba_huskar_2"	"1"
			"special_bonus_imba_huskar_3"	"1"
		}
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"15"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"75 100 125 150"

		// Stats
		//-------------------------------------------------------------------------------------------------------------
		"AbilityModifierSupportValue"	"0.0"	// already gets credit for the healing
		"precache"
		{

			"particle"	"particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf"
			"particle"	"particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_cast_flame.vpcf"

		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"500"	//心炎作用范围
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"disarm_duration"		"0.5"	//缴械时间
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"knockback_distance"	"200"	//击退距离
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"knockback_duration"	"1"	//击退时间
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"range"				"600"	//跳跃施法距离
				"LinkedSpecialBonus"			"special_bonus_unique_huskar_3"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"speed"					"1200"	//跳跃速度
			}
			"08"
			{
				"var_type"				"FIELD_INTEGER"
				"duration"				"3"		//免疫破坏持续时间
			}

			"09"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"125 200 275 350"	//直接伤害
			}
			"10"
			{
				"var_type"				"FIELD_INTEGER"
				"range_re"				"250"	//被动判断范围减少至
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}
	//==========================================================
	//huskar_burning_spear
	//===========================================================================================
	"imba_huskar_burning_spear"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		//-------------------------------------------------------------------------------------------------------------
		"AbilityTextureName"	"huskar_burning_spear"
		"BaseClass"	"ability_lua"
		"ScriptFile"	"ting/hero_huskar.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"AbilityUnitTargetFlags"		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_Huskar.Burning_Spear"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.0 0.0 0.0 0.0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"1"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0 0 0 0"
		"LinkedTalents"
		{
			"special_bonus_imba_huskar_1"	"1"
			"special_bonus_imba_huskar_5"	"1"
		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
				"precache"
		{

			"particle"	"particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf"

		}
		// -------------------------------------------------------------------------------------------------------------

		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"health_cost"					"4"	//消耗的血%
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"damage"						"40 60 80 100"	//力量倍率的伤害
				"LinkedSpecialBonus"			"special_bonus_imba_huskar_1"
			}
			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"duration"						"5"			//生命上限加成持续时间
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}

	// =================================================================================================================
	// Huskar: Berserker's Blood
	// =================================================================================================================
	"imba_huskar_berserkers_blood"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"huskar_berserkers_blood"
		"ScriptFile"	"ting/hero_huskar.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"MaxLevel"	"4"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_3"
		// Special
		// -------------------------------------------------------------------------------------------------------------

			"precache"
		{

			"particle"	"particles/units/heroes/hero_huskar/huskar_berserkers_blood_regen.vpcf"
			"particle"	"particles/units/heroes/hero_huskar/huskar_berserkers_blood.vpcf"

		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"maximum_attack_speed"	"150 160 170 180"	//攻速
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"maximum_health_regen"	"40 60 80 100"	//回血率
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"hp_threshold_max"	"15"	//最大加成时生命值
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"soul"		"5"	//队友敌人死亡时被动数值
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"reduce"		"30"	//射程外伤害减免
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"move_speed"		"60 80 100 120"	//最大移动速度增加
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"range_re"		"250"	//最大移动速度增加
			}

		}
		"HasShardUpgrade"               "1"
	}


	"imba_huskar_life_break"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"huskar_life_break"
		"ScriptFile"	"ting/hero_huskar.lua"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"2"
		"AbilitySound"					"Hero_Huskar.Life_Break"
		"LinkedTalents"
		{
			"special_bonus_imba_huskar_6"	"1"
		}
		"HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.1"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"22"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0 0 0"

		// Cast Range
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"550"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"precache"
		{

			"particle"	"particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_life_break.vpcf"
			"particle"	"particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_cast_flame.vpcf"
			"particle"	""particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf""

		}
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"health_cost_percent"		"44"	//伤害百分比自己
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"health_damage"				"43"	//伤害百分比敌人
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"charge_speed"				"1600"	//跳跃速度
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"movespeed"					"-40 -50 -60"	//减速
			}
			"05"
			{
				"var_type"					"FIELD_FLOAT"
				"slow_durtion"				"3"		//减速持续时间
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"range"						"550"	//施法距离 跟上面那个一致
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"range_scepter"	"900"		//a杖施法距离
				"RequiresScepter"	"1"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"taunt_dur"	"1"	//嘲讽持续时间
			}
			"09"
			{
				"var_type"						"FIELD_INTEGER"
				"duration"						"5"			//生命上限加成持续时间
			}

		}
	}
	//火矛伤害增加
	"special_bonus_imba_huskar_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"30"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_huskar_burning_spear"
		}
	}
	//心炎减速
	"special_bonus_imba_huskar_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"60"
			}
		}

		"LinkedAbility"
		{
			"01"	"imba_huskar_inner_fire"
		}
	}
	//心炎施法距离
	"special_bonus_imba_huskar_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"350"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_huskar_inner_fire"
		}
	}
	//狂血魔抗
	"special_bonus_imba_huskar_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"80"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_huskar_berserkers_blood"
		}

	}

	//火矛变纯粹
	"special_bonus_imba_huskar_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"LinkedAbility"
		{
			"01"	"imba_huskar_burning_spear"
		}
	}
	//狂战士之血额外增加移动速度
	"special_bonus_imba_huskar_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"120"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_huskar_berserkers_blood"
		}
	}




		//电棍
	"imba_razor_plasma_field"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_razor.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_ALL"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"MaxLevel"						"4"
		"AbilityTextureName"			"razor_plasma_field"
		"AbilityCastRange"				"800"

		// Talents
		//-------------------------------------------------------------------------------------------------------------
		"LinkedTalents"
		{
			"special_bonus_imba_razor_1"	"1"
		}

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0"
		"AbilityCastAnimation"			"ACT_DOTA_OVERRIDE_ABILITY_1"
		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"10"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"125"

		"precache"
		{
			"particle"                  "particles/units/heroes/hero_razor/razor_plasmafield.vpcf"
			"particle"                  "particles/econ/items/razor/razor_ti6/razor_plasmafield_ti6.vpcf"
			"soundfile"		"soundevents/game_sounds_heroes/game_sounds_razor.vsndevts"
		}

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"damage_max"			"125 150 175 200"
				"LinkedSpecialBonus"		"special_bonus_imba_razor_1"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"damage_min"			"100"
				"LinkedSpecialBonus"		"special_bonus_imba_razor_1"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"800"
			}
			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"speed"						"800"
			}
			"05"
			{
				"var_type"					"FIELD_INTEGER"
				"kno"						"450"
			}
			"06"
			{
				"var_type"					"FIELD_INTEGER"
				"movespeed"						"10 20 30 40"
			}
			"07"
			{
				"var_type"					"FIELD_INTEGER"
				"duration_enemy"				"2"
			}
			"08"
			{
				"var_type"				"FIELD_INTEGER"
				"ability_link_stack"			"6"
			}
		}
	}
		//等离子加伤害
		"special_bonus_imba_razor_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_razor_plasma_field"
		}
	}


	"imba_razor_static_link"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_razor.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetFlags" 		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"MaxLevel"						"4"
		"AbilityTextureName"			"razor_static_link"

		// Talents
		//-------------------------------------------------------------------------------------------------------------
		"LinkedTalents"
		{
			"special_bonus_imba_razor_2"	"1"
		}

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"550"
		"AbilityCastPoint"				"0.3"
		"AbilityCastAnimation"			"ACT_DOTA_OVERRIDE_ABILITY_2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"30 30 25 20"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"90"

		"precache"
		{
			"particle"                  "particles/units/heroes/hero_razor/razor_static_link.vpcf"
			"particle"  				"particles/units/heroes/hero_razor/razor_static_link_debuff.vpcf"
			"particle"  				"particles/units/heroes/hero_razor/razor_static_link_buff.vpcf"
			"soundfile"					"soundevents/game_sounds_heroes/game_sounds_razor.vsndevts"
		}

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"link_duration"			"10 11 12 13"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"buff_duration"			"15"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"link_stack"			"6 12 18 24"
				"LinkedSpecialBonus"	"special_bonus_imba_razor_2"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"link_radius"			"700 750 800 850"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"time"						"3"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"duration_slow"			"1"
			}

		}
	}
		"special_bonus_imba_razor_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"12"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_razor_static_link"
		}
	}
	"imba_razor_unstable_current"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_razor.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET| DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_ALL"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilityCastPoint"				"0"
		"AbilityCastAnimation"			"ACT_DOTA_OVERRIDE_ABILITY_1"
		"MaxLevel"						"4"
		"AbilityTextureName"			"razor_unstable_current"
		"AbilityCooldown"				"5"
		"AbilityCastPoint"				"0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"90"
		"precache"
		{
			"particle"  				"particles/units/heroes/hero_razor/razor_base_attack.vpcf"
			"soundfile"					"soundevents/game_sounds_heroes/game_sounds_razor.vsndevts"
		}
		"LinkedTalents"
		{
			"special_bonus_imba_razor_5"	"1"
			"special_bonus_imba_razor_6"	"1"
		}

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"movespeed"				"10 12 14 16"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"0.3 0.4 0.5 0.6"
				"LinkedSpecialBonus"	"special_bonus_imba_razor_5"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"100 140 180 220"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"chance"				"15 16 17 18"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"sh"					"5 10 15 20"
				"LinkedSpecialBonus"	"special_bonus_imba_razor_6"

			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"max_sh"					"4000"
			}
		}
	}
	//被动护盾upup
		"special_bonus_imba_razor_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	"0.5"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_razor_unstable_current"
		}
	}
	//麻痹时间+0.5
		"special_bonus_imba_razor_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"20"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_razor_unstable_current"
		}
	}
	"imba_razor_eye_of_the_storm"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_razor.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_ALL"
		"AbilityUnitTargetFlags" 		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"MaxLevel"						"3"
		"AbilityTextureName"			"razor_eye_of_the_storm"
		"HasScepterUpgrade"				"1"

		// Talents
		//-------------------------------------------------------------------------------------------------------------
		"LinkedTalents"
		{
			"special_bonus_imba_razor_4"	"1"
		}

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0"
		"AbilityCastAnimation"			"ACT_DOTA_OVERRIDE_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"55"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100 150 200"

		"precache"
		{
			"particle"                  "particles/units/heroes/hero_razor/razor_rain_storm.vpcf"
			"particle"  				"particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf"
			"soundfile"					"soundevents/game_sounds_heroes/game_sounds_razor.vsndevts"
		}

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_INTEGER"
				"damage"						"80 100 120"
			}
			"02"
			{
				"var_type"						"FIELD_FLOAT"
				"duration"						"30"
			}
			"03"
			{
				"var_type"						"FIELD_FLOAT"
				"strike_interval"				"0.6 0.5 0.4"
			}
			"04"
			{
				"var_type"						"FIELD_FLOAT"
				"armor_reduction"				"1"
			}
			"05"
			{
				"var_type"						"FIELD_FLOAT"
				"scepter_target"				"2"
				"LinkedSpecialBonus"			"special_bonus_imba_razor_4"
			}
			"06"
			{
				"var_type"						"FIELD_FLOAT"
				"debuff_duration"				"10"
			}
		}
	}
	//打击数+1
	"special_bonus_imba_razor_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_razor_eye_of_the_storm"
		}
	}
	"imba_razor_whip"
	{
		// General
		//-------------------------------------------------------------------------------------------------------------
		"BaseClass"						"ability_lua"
		"ScriptFile"					"ting/hero_razor.lua"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING |DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_ALL"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"AbilityUnitTargetFlags" 		"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"MaxLevel"						"1"
		"AbilityTextureName"			"razor_static_link_alt_gold_png"

		// Talents
		//-------------------------------------------------------------------------------------------------------------
		"LinkedTalents"
		{
			"special_bonus_imba_razor_3"	"1"
		}

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"550"
		"AbilityCastPoint"				"0.15"
		"AbilityCastAnimation"			"ACT_DOTA_OVERRIDE_ABILITY_2"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"2.5"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"30"

		"precache"
		{
			"particle"                  "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf"
			"particle"  				"particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf"
			"soundfile"					"soundevents/game_sounds_heroes/game_sounds_razor.vsndevts"
		}

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"per"					"30"
			}

		}
		"HasShardUpgrade"               "1"
	}
		//消耗+盾
	"special_bonus_imba_razor_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"LinkedAbility"
		{
			"01"	"imba_razor_whip"
		}
	}










// =================================================================================================================
	// DAZZLE's Poison Touch
	// =================================================================================================================
	"imba_dazzle_poison_touch"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"dazzle_poison_touch"
		"ScriptFile"	"ting/hero_dazzle.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_AOE"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		"AbilityCastPoint"	"0.2"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_1"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"12"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"50"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"750"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts"
			"particle"	"particles/units/heroes/hero_dazzle/dazzle_poison_touch.vpcf"
			"particle"	"particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf"
			"particle"	"particles/status_fx/status_effect_poison_dazzle.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"slow_duration"	"5"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"initial_slow"	"30"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"stun_duration"	"0.01"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"projectile_speed"	"1300"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"50"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"damage_per"	"30 50 70 90"
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"tick_interval"	"1"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"max_stack"	"2 4 6 8"
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"750"
			}

		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"HasShardUpgrade"               "1"
	}

	// 增加1倍智力伤害
	"special_bonus_imba_dazzle_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_dazzle_poison_touch"
		}
	}

	// 攻击打断
	"special_bonus_imba_dazzle_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"80"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_dazzle_poison_touch"
		}
	}

	// =================================================================================================================
	// DAZZLE's Shallow Grave
	// =================================================================================================================
	"imba_dazzle_shallow_grave"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"dazzle_shallow_grave"
		"ScriptFile"	"ting/hero_dazzle.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING| DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"SpellImmunityType"	"SPELL_IMMUNITY_ALLIES_YES"
		"FightRecapLevel"	"1"
		"AbilityCastRange"	"550 700 850 1000"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.2"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_2"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"150"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts"
			"particle"	"particles/units/heroes/hero_dazzle/dazzle_shallow_grave.vpcf"
			"particle"	"particles/hero/dazzle/dazzle_shallow_grave_3.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"duration_tooltip"	"5"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"passive_stack"	"40"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"passive_duration"	"3"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"true_cd"	"55 45 35 25"
				"LinkedSpecialBonus"	"special_bonus_imba_dazzle_5"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
	}
	//薄葬cd减少
	"special_bonus_imba_dazzle_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"-5"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_dazzle_shallow_grave"
		}
	}
	// =================================================================================================================
	// DAZZLE's Shadow Wave
	// =================================================================================================================
	"imba_dazzle_shadow_wave"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"dazzle_shadow_wave"
		"ScriptFile"	"ting/hero_dazzle.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityCastPoint"	"0.2"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"14 12 10 8"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"90 100 110 120"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"900"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts"
			"particle"	"particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf"
			"particle"	"particles/units/heroes/hero_dazzle/dazzle_shadow_wave_impact_damage.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"bounce_radius"	"700"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"damage_radius"	"225"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"80 100 120 140"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_healing"	"5 10 15 20"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"HasShardUpgrade"               "1"
	}
	//紧急救助也加入aoe伤害
	"special_bonus_imba_dazzle_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------

		"LinkedAbility"
		{
			"01"	"imba_dazzle_help"
		}
	}
	//薄葬下受到治疗增加100%
	"special_bonus_imba_dazzle_6"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"100"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_dazzle_shadow_wave"
		}
	}

	// =================================================================================================================
	// DAZZLE's Weave
	// =================================================================================================================
	"imba_dazzle_weave"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"dazzle_weave"
		"ScriptFile"	"ting/hero_dazzle.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"	"2"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityCastPoint"	"0.2"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_4"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"100"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"2000"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts"
			"particle"	"particles/units/heroes/hero_dazzle/dazzle_weave.vpcf"
			"particle"	"particles/units/heroes/hero_dazzle/dazzle_armor_friend.vpcf"
			"particle"	"particles/units/heroes/hero_dazzle/dazzle_armor_enemy.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"1000"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"7.0"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"armor"		"2 2.5 3"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"cooldown"	"20 30 40"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"true_cd"	"30"
			}

		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
	}
	//编织护甲变动增加1
	"special_bonus_imba_dazzle_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"1"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_dazzle_weave"
		}
	}
"imba_dazzle_help"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"dazzle_shadow_wave_immortal_png"
		"ScriptFile"	"ting/hero_dazzle.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE| DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetFlags" "DOTA_UNIT_TARGET_FLAG_DEAD"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"MaxLevel"						"1"
		"FightRecapLevel"				"1"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityCastPoint"	"0.2"
		"AbilityChannelTime"			"1"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"180"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"400"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"1200"
		// Precache
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts"
			"particle"	"particles/units/heroes/hero_dazzle/dazzle_weave.vpcf"
			"particle"	"particles/units/heroes/hero_dazzle/dazzle_armor_friend.vpcf"
			"particle"	"particles/units/heroes/hero_dazzle/dazzle_armor_enemy.vpcf"
		}
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"600"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"vision"	"800"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"3"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"vision_duration"	"3.0"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"duration_armor"	"7.0"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
		"HasScepterUpgrade"	"1"
	}

	// =================================================================================================================
	// Doom Bringer: Doom
	// =================================================================================================================
	"imba_doom_bringer_devour"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"doom_bringer_devour"
		// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"ScriptFile"	"ting/hero_doom.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.3 0.3 0.3 0.3"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_1"
		"AbilityCooldown"	"16"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"40 50 60 70"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"300 300 300 300"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{

			"particle"	"particles/units/heroes/hero_doom_bringer/doom_bringer_doom_ring.vpcf"
			"particle"	"particles/econ/courier/courier_trail_lava/courier_trail_lava_model.vpcf"
			"particle"	"particles/econ/courier/courier_roshan_lava/courier_roshan_lava_ground.vpcf"
			"particle"	"particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff_smoke.vpcf"
			"particle"	"particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf"
			"particle"	"particles/status_fx/status_effect_doom.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_gold"	"66 106 146 186"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"regen_p"	"0.6"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"gold_hero"	"666"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"burn_damage"	"36"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"burn_damage_pct"	"1.6"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"buff_duration"	"46"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"regen"	"6"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"shard"	"16"
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"maxs"	"6"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
		"AbilitySound"	"Hero_DoomBringer.Devour"
		"HasShardUpgrade"               "1"
	}
//可以吃远古
	"special_bonus_imba_doom_2"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"LinkedAbility"
		{
			"01"	"imba_doom_bringer_devour"
		}
	}


	"imba_doom_bringer_infernal_blade"
	{
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"doom_bringer_infernal_blade"
		"ScriptFile"	"ting/hero_doom.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilityCastPoint"	"0.0 0.0 0.0 0.0"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_3"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"4"
		"AbilityManaCost"	"40"
		"AbilityCastRange"	"666"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"particle"	"particles/units/heroes/hero_doom_bringer/doom_bringer_doom_sigil_c.vpcf"
			"particle"	"particles/units/heroes/hero_doom_bringer/doom_infernal_blade.vpcf"
			"particle"	"particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"burn_damage"	"36"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"burn_damage_pct"	"1.6"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"burn_duration"	"3.6 4.6 5.6 6.6"
			}
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"ministun_duration"	"0.66"
				"LinkedSpecialBonus"	"special_bonus_imba_doom_3"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"per"	"60"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"600"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"chongneng"	"12"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"stackcount"	"2"
			}
			"09"
			{
				"var_type"	"FIELD_FLOAT"
				"Duration_SC"	"1.6"
			}
			"10"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"66"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_YES"
		"AbilitySound"	"Hero_DoomBringer.InfernalBlade.Target"
		"HasScepterUpgrade"	"1"
	}
//火刀cd-1
	"special_bonus_imba_doom_4"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_doom_bringer_infernal_blade"
		}
	}
//火刀眩晕时间+1
	"special_bonus_imba_doom_3"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"1"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_doom_bringer_infernal_blade"
		}
	}

//火刀2充能
	"special_bonus_imba_doom_5"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"2"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_doom_bringer_infernal_blade"
		}
	}

	"imba_doom_bringer_scorched_earth"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"doom_bringer_scorched_earth"
		"ScriptFile"	"ting/hero_doom.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"	"1"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.0 0.0 0.0 0.0"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_2"
		"AbilityCooldown"	"66"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"60 70 80 90"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"	"600 600 600 600"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"precache"
		{
			"particle"	"particles/units/heroes/hero_doom_bringer/doom_bringer_scorched_earth_buff.vpcf"
			"particle"	"particles/units/heroes/hero_doom_bringer/doom_scorched_earth.vpcf"
			"particle"	"particles/units/heroes/hero_doom_bringer/doom_bringer_scorched_earth_debuff.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"26 36 46 56"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"266 266 266 266"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_movement_speed_pct"	"6 12 18 24"
			}
			"04"
			{

				"var_type"	"FIELD_FLOAT"
				"duration_scepter"	"16.0"
				"RequiresScepter"	"1"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_armor"	"6"
			}
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"bonus_attackspeed"	"6"
				"LinkedSpecialBonus"	"special_bonus_imba_doom_1"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"max_stack"	"3 4 5 6"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"duration_c"	"6"
			}
		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
		"AbilitySound"	"Hero_DoomBringer.ScorchedEarthAura"
		"HasScepterUpgrade"	"1"
	}
//+30末日使者攻速
"special_bonus_imba_doom_1"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"		"30"
			}
		}
		"LinkedAbility"
		{
			"01"	"imba_doom_bringer_scorched_earth"
		}
	}

	"imba_doom_bringer_doom"
	{
		// General
		// -------------------------------------------------------------------------------------------------------------
		"BaseClass"	"ability_lua"
		"AbilityTextureName"	"doom_bringer_doom"
		"ScriptFile"	"ting/hero_doom.lua"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetType"	"DOTA_UNIT_TARGET_HERO"
		"AbilityUnitTargetTeam"	"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetFlags"	"DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES | DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS"
		"AbilityUnitDamageType"	"DAMAGE_TYPE_PURE"
		"SpellImmunityType"	"SPELL_IMMUNITY_ENEMIES_YES"
		"FightRecapLevel"	"2"
		"AbilityType"	"DOTA_ABILITY_TYPE_ULTIMATE"
		// Casting
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"	"0.5"
		"AbilityCastAnimation"	"ACT_DOTA_CAST_ABILITY_6"
		// Time
		// -------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"	"66"
		// Cost
		// -------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"	"66 166 266"
		// Special
		// -------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"duration_long"	"9"
			}
			"02"
			{
				"var_type"	"FIELD_INTEGER"
				"damage"	"66 132 198"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				"radius"	"666"
			}

		}
		"SpellDispellableType"	"SPELL_DISPELLABLE_NO"
		"HasScepterUpgrade"	"1"
	}

















































	//=================================================================================================================
	//
	//
	//													traveler的英雄
	//
	//
	//
	//=================================================================================================================



	//=================================================================================================================
	// 撕裂大地
	//=================================================================================================================
	"imba_leshrac_split_earth"
	{
		// Custom
	    //---------------------------------------------------------------------------------------------------------
	    "BaseClass"	"ability_lua"
		"AbilityTextureName"	"leshrac_split_earth"
		"ScriptFile"	"traveler/leshrac_abilities.lua"

		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES_STRONG"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Leshrac.Split_Earth"

		"HasShardUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0.7 0.7 0.7 0.7"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"8"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"80 100 120 140"

		// Damage.
		//-------------------------------------------------------------------------------------------------------------
		"AbilityDamage"					"120 180 240 300"
		"AbilityDuration"				"1.5"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_FLOAT"
				"delay"				"0.35"
			}

			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"radius"			"300"
				"LinkedSpecialBonus"	"special_bonus_imba_leshrac_1"
			}

			"03"
			{
				"var_type"			"FIELD_FLOAT"
				"duration"			"1 1.25 1.5 1.75"
			}

			//imba-效果
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"imba_count"	"3"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"imba_radius"	"175"
			}
			"06" //自身600范围产生
			{
				"var_type"	"FIELD_FLOAT"
				"imba_range"	"600"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"imba_cd_mul"	"2"
			}

			"08" //魔晶
			{
				"var_type"	"FIELD_FLOAT"
				"shard_interval"	"2.5"
			}
			"09" //魔晶-范围
			{
				"var_type"	"FIELD_FLOAT"
				"shard_radius_increase"	"75"
			}
			"10" //魔晶-范围
			{
				"var_type"	"FIELD_FLOAT"
				"shard_count"	"2"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


    //=================================================================================================================
	// 恶魔敕令
	//=================================================================================================================
	"imba_leshrac_diabolic_edict"
	{
		// Custom
	    //---------------------------------------------------------------------------------------------------------
	    "BaseClass"	"ability_lua"
		"AbilityTextureName"	"leshrac_diabolic_edict"
		"ScriptFile"	"traveler/leshrac_abilities.lua"

		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_BUILDING"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Leshrac.Diabolic_Edict"

		//"HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0.5"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"22 22 22 22"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"95 120 135 155"

		// Damage.
		//-------------------------------------------------------------------------------------------------------------
		"AbilityDamage"					"9 19 29 39"
		//"AbilityDuration"				"10"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"num_explosions"		"40"
				"LinkedSpecialBonus"	"special_bonus_imba_leshrac_7"
			}

			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"radius"			"475"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"tower_bonus"			"15"
			}

			//
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"imba_int_pct"	"100"
			}

			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"10"
				"LinkedSpecialBonus"	"special_bonus_imba_leshrac_6"
			}

			//"06"
			//{
			//	"var_type"	"FIELD_FLOAT"
			//	"interval"	"0.25"
			//}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	//=================================================================================================================
	// 闪电风暴
	//=================================================================================================================
	"imba_leshrac_lightning_storm"
	{
		// Custom
	    //---------------------------------------------------------------------------------------------------------
	    "BaseClass"	"ability_lua"
		"AbilityTextureName"	"leshrac_lightning_storm"
		"ScriptFile"	"traveler/leshrac_abilities.lua"

		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_Leshrac.Lightning_Storm"



		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"800"
		"AbilityCastPoint"				"0.1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"9 8 7 6"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"80 100 120 140"


		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"			"FIELD_INTEGER"
				"damage"			"60 80 100 120"
			}
			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"jump_count"			"2 3 4 4"
				"LinkedSpecialBonus"	"special_bonus_imba_leshrac_2"
			}
			"03"
			{
				"var_type"			"FIELD_INTEGER"
				"radius"			"500"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"jump_delay"			"0.25 0.25 0.25 0.25"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"slow_movement_speed"	"-40"
			}
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"slow_duration"			"0.5 1.0 1.5 2.0"
				"LinkedSpecialBonus"	"special_bonus_imba_leshrac_3"
			}

            // 神杖
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"interval_scepter"			"1.5"
				"RequiresScepter"		"1"
			}
			"08"
			{
				"var_type"				"FIELD_FLOAT"
				"radius_scepter"			"750"
				"RequiresScepter"		"1"
			}



		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}

	//=================================================================================================================
	// 脉冲新星
	//=================================================================================================================
	"imba_leshrac_pulse_nova"
	{
		// Custom
	    //---------------------------------------------------------------------------------------------------------
	    "BaseClass"	"ability_lua"
		"AbilityTextureName"	"leshrac_pulse_nova"
		"ScriptFile"	"traveler/leshrac_abilities.lua"

		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_TOGGLE | DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"FightRecapLevel"				"1"


		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastPoint"				"0 0 0 0"
		"AbilityCooldown"				"1.0 1.0 1.0 1.0"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"70"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"mana_cost_per_second"	"30 40 50"
			}

			"02"
			{
				"var_type"			"FIELD_INTEGER"
				"radius"			"600"
				"LinkedSpecialBonus"	"special_bonus_imba_leshrac_4"
			}
			"03"
			{
				"var_type"			"FIELD_INTEGER"
				"damage"			"200 250 300"
				"LinkedSpecialBonus"	"special_bonus_imba_leshrac_5"
			}

			//灵魂折磨-脉冲新星-伤害
			"04"
			{
				"var_type"	"FIELD_FLOAT"
				"physical_armor_reduction"	"4"
			}
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"magical_armor_reduction"	"4"
			}

			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"interval"	"1"
			}

			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"duration"	"1.5"
			}

		}
	}




	//====================================
	//天赋1:+75撕裂大地范围
	//====================================
	"special_bonus_imba_leshrac_1"
    {
	    "BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
			    "value"	   "75"
				"ad_linked_ability" "imba_leshrac_split_earth"
			}
		}
	}
	//====================================
	//天赋2:+1闪电跳跃次数
	//====================================
	"special_bonus_imba_leshrac_2"
    {
	    "BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------
		"AbilitySpecial"
		{

			"01"
			{
				"var_type"	"FIELD_FLOAT"
			    "value"	   "1"
				"ad_linked_ability" "imba_leshrac_lightning_storm"
			}

		}
	}
	//====================================
	//天赋3:+1s闪电风暴减速
	//====================================
	"special_bonus_imba_leshrac_3"
    {
	    "BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
			   "value"	   "1"
				"ad_linked_ability" "imba_leshrac_lightning_storm"
			}
		}
	}
	//====================================
	//天赋4:+100脉冲新星范围
	//====================================
	"special_bonus_imba_leshrac_4"
    {
	    "BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
			   "value"	   "100"
				"ad_linked_ability" "imba_leshrac_pulse_nova"
			}
		}
	}

	//====================================
	//天赋5:+100脉冲新星伤害
	//====================================
	"special_bonus_imba_leshrac_5"
    {
	    "BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
			   "value"	   "100"
				"ad_linked_ability" "imba_leshrac_pulse_nova"
			}
		}
	}

	//====================================
	//天赋6:+5s恶魔敕令持续时间
	//====================================
	"special_bonus_imba_leshrac_6"
    {
	    "BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
			   "value"	   "5"
				"ad_linked_ability" "imba_leshrac_diabolic_edict"
			}
		}
	}

	//====================================
	//天赋7:+20恶魔敕令爆炸次数
	//====================================
	"special_bonus_imba_leshrac_7"
    {
	    "BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
			   "value"	   "20"
				"ad_linked_ability" "imba_leshrac_diabolic_edict"
			}
		}
	}


    // ====================================================================================================================
	// Ability: Special Bonus all stats(全属性更变)
	// ====================================================================================================================
	"special_bonus_all_stats_10"
	{
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"value"	"40"
			}
		}
	}

    	//=================================================================================================================
	// 阳炎索
	//=================================================================================================================
	"imba_ember_spirit_searing_chains"
	{
		// Custom
	    //---------------------------------------------------------------------------------------------------------
	    "BaseClass"	"ability_lua"
		"AbilityTextureName"	"ember_spirit_searing_chains"
		"ScriptFile"	"traveler/imba_ember_spirit_abilities.lua"

		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"FightRecapLevel"				"1"
		"AbilitySound"					"Hero_EmberSpirit.SearingChains.Target"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"400"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"13 12 11 10"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"80 90 100 110"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_FLOAT"
				"duration"						"1.5 2.0 2.5 3.0"
				"LinkedSpecialBonus"			"special_bonus_imba_ember_spirit_1"
			}
			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"radius"						"400"
			}
			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"total_damage"					"75 150 225 300"
			}
			"04"
			{
				"var_type"						"FIELD_FLOAT"
				"tick_interval"					"0.5"
			}
			"05"
			{
				"var_type"						"FIELD_INTEGER"
				"unit_count"					"2"
			}
			"06"
			{
				"var_type"						"FIELD_INTEGER"
				"radius_scepter"				"500"
			}

			//火之传承-炎阳索-额外目标
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"chains_targets"	"3"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"chains_targets_effect_stack"	"20"
			}
			//火之传承-炎阳索-无视魔免和不可见单位
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"chains_immune_effect_stack"	"40"
			}
			//火之传承-炎阳索-牵引
			"10"
			{
				"var_type"	"FIELD_FLOAT"
				"chains_pull"	"100"
			}
			"11"
			{
				"var_type"	"FIELD_INTEGER"
				"chains_pull_effect_stack"	"60"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_1"
	}


    //=================================================================================================================
	// 无影拳
	//=================================================================================================================
	"imba_ember_spirit_sleight_of_fist"
	{
		// Custom
	    //---------------------------------------------------------------------------------------------------------
	    "BaseClass"	"ability_lua"
		"AbilityTextureName"	"ember_spirit_sleight_of_fist"
		"ScriptFile"	"traveler/imba_ember_spirit_abilities.lua"

		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"

		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0"
		"FightRecapLevel"				"1"

		"HasShardUpgrade"			"1"

		"LinkedAbility" "imba_ember_spirit_sleight_of_fist_charge"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"18 14 10 6"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"250 350 450 550"
			}

			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_hero_damage"			"40 80 120 160"
				"LinkedSpecialBonus"			"special_bonus_imba_ember_spirit_2"
				"CalculateSpellDamageTooltip"	"0"
			}

			"03"
			{
				"var_type"						"FIELD_FLOAT"
				"attack_interval"				"0.2"
			}

			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"creep_damage_penalty"			"-50"
				"CalculateSpellDamageTooltip"	"0"
			}

			//火之传承-无影拳-克敌机先
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"fist_mkb_effect_stack"	"20"
			}
			//火之传承-无影拳-躲避投射物
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"fist_dodge_effect_stack"	"40"
			}
			//火之传承-无影拳-无视护甲
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"fist_armor"	"24"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"fist_armor_effect_stack"	"60"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	//=================================================================================================================
	// 无影拳-充能
	//=================================================================================================================
	"imba_ember_spirit_sleight_of_fist_charge"
	{
		// Custom
	    //---------------------------------------------------------------------------------------------------------
	    "BaseClass"	"ability_lua"
		"AbilityTextureName"	"ember_spirit_sleight_of_fist"
		"ScriptFile"	"traveler/imba_ember_spirit_abilities.lua"

		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_AOE | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES | DOTA_ABILITY_BEHAVIOR_HIDDEN"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PHYSICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"

		"AbilityCastRange"				"700"
		"AbilityCastPoint"				"0"
		"FightRecapLevel"				"1"

		"LinkedAbility" "imba_ember_spirit_sleight_of_fist"

		//"HasShardUpgrade"			"1"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0"
		"AbilityCharges"				"2"
		"AbilityChargeRestoreTime"		"18 14 10 6"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"50"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_INTEGER"
				"radius"					"250 350 450 550"
			}

			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"bonus_hero_damage"			"40 80 120 160"
				"LinkedSpecialBonus"			"special_bonus_imba_ember_spirit_2"
				"CalculateSpellDamageTooltip"	"0"
			}

			"03"
			{
				"var_type"						"FIELD_FLOAT"
				"attack_interval"				"0.2"
			}

			"04"
			{
				"var_type"					"FIELD_INTEGER"
				"creep_damage_penalty"			"-50"
				"CalculateSpellDamageTooltip"	"0"
			}

			//火之传承-无影拳-克敌机先
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"fist_mkb_effect_stack"	"20"
			}
			//火之传承-无影拳-躲避投射物
			"06"
			{
				"var_type"	"FIELD_INTEGER"
				"fist_dodge_effect_stack"	"40"
			}
			//火之传承-无影拳-无视护甲
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"fist_armor"	"24"
			}
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"fist_armor_effect_stack"	"60"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}

	//=================================================================================================================
	// 烈火罩
	//=================================================================================================================
	"imba_ember_spirit_flame_guard"
	{
		// Custom
	    //---------------------------------------------------------------------------------------------------------
	    "BaseClass"	"ability_lua"
		"AbilityTextureName"	"ember_spirit_flame_guard"
		"ScriptFile"	"traveler/imba_ember_spirit_abilities.lua"

		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_YES"
		"AbilitySound"					"Hero_EmberSpirit.FlameGuard.Cast"

		"HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"400"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"35.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"80 90 100 110"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"						"FIELD_FLOAT"
				"duration"						"8 12 16 20"
			}

			"02"
			{
				"var_type"						"FIELD_INTEGER"
				"radius"						"400"
			}

			"03"
			{
				"var_type"						"FIELD_INTEGER"
				"absorb_amount"					"80 220 360 500"
			}
			"04"
			{
				"var_type"						"FIELD_FLOAT"
				"tick_interval"					"0.2"
			}
			"05"
			{
				"var_type"						"FIELD_INTEGER"
				"damage_per_second"				"25 35 45 55"
			}

			// 神杖
			"06"
			{
				"var_type"				"FIELD_FLOAT"
				"scepter_absorb_amount_increase_pct"	"100"
				"RequiresScepter"	"1"
			}
			"07"
			{
				"var_type"				"FIELD_FLOAT"
				"scepter_damage_per_second_increase"	"50"
				"RequiresScepter"	"1"
			}
			"08"
			{
				"var_type"				"FIELD_FLOAT"
				"scepter_explosion_damage_pct"	"50"
				"RequiresScepter"	"1"
			}

			//火之传承-烈火罩-移速
			"09"
			{
				"var_type"	"FIELD_FLOAT"
				"guard_ms"	"28"
			}
			"10"
			{
				"var_type"	"FIELD_INTEGER"
				"guard_ms_effect_stack"	"20"
			}
			//火之传承-烈火罩-冷却
			"11"
			{
				"var_type"	"FIELD_FLOAT"
				"guard_cd"	"18"
			}
			"12"
			{
				"var_type"	"FIELD_INTEGER"
				"guard_cd_effect_stack"	"40"
			}
			//火之传承-烈火罩-护甲
			"13"
			{
				"var_type"	"FIELD_FLOAT"
				"guard_armor"	"24"
			}
			"14"
			{
				"var_type"	"FIELD_INTEGER"
				"guard_armor_effect_stack"	"60"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	}

	//=================================================================================================================
	// 残焰
	//=================================================================================================================
	"imba_ember_spirit_fire_remnant"
	{
		// Custom
	    //---------------------------------------------------------------------------------------------------------
	    "BaseClass"	"ability_lua"
		"AbilityTextureName"	"ember_spirit_fire_remnant"
		"ScriptFile"	"traveler/imba_ember_spirit_abilities.lua"

		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilitySound"					"Hero_EmberSpirit.FireRemnant.Cast"
		"AbilityDraftPreAbility"		"ember_spirit_activate_fire_remnant"

        //"HasShardUpgrade"			"1"
        //"HasScepterUpgrade"			"1"

        "LinkedAbility" "imba_ember_spirit_fire_remnant_charge"


		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1500"
		"AbilityCastPoint"				"0.0"
		"AbilityCastAnimation"			"ACT_INVALID"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0.0"
		"AbilityCharges"				"3"
		"AbilityChargeRestoreTime"		"38.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"


		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"speed_multiplier"				"250"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"100 200 300"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"450"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"45.0"
			}

			//火之传承-残焰-施法距离、残焰速度
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_cr"	"3"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_ms"	"2"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"remnant_cr_effect_stack"	"20"
			}
			//火之传承-残焰-治疗
			"08"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_heal"	"50"
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"remnant_heal_effect_stack"	"40"
			}
			//火之传承-残焰-攻击力
			"10"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_dmg"	"72"
			}
			"11"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_dmg_duration"	"12"
			}
			"12"
			{
				"var_type"	"FIELD_INTEGER"
				"remnant_dmg_effect_stack"	"60"
			}

		}
	}

	//=================================================================================================================
	// 残焰-充能
	//=================================================================================================================
	"imba_ember_spirit_fire_remnant_charge"
	{
		// Custom
	    //---------------------------------------------------------------------------------------------------------
	    "BaseClass"	"ability_lua"
		"AbilityTextureName"	"ember_spirit_fire_remnant"
		"ScriptFile"	"traveler/imba_ember_spirit_abilities.lua"

		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_HIDDEN"
		"AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilitySound"					"Hero_EmberSpirit.FireRemnant.Cast"
		"AbilityDraftPreAbility"		"ember_spirit_activate_fire_remnant"

        //"HasShardUpgrade"			"1"
        //"HasScepterUpgrade"			"1"

        "LinkedAbility" "imba_ember_spirit_fire_remnant"



		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1500"
		"AbilityCastPoint"				"0.0"
		"AbilityCastAnimation"			"ACT_INVALID"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0.0"
		"AbilityCharges"				"5"
		"AbilityChargeRestoreTime"		"26"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"0"


		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"speed_multiplier"				"250"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"100 200 300"
			}
			"03"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"450"
			}
			"04"
			{
				"var_type"				"FIELD_FLOAT"
				"duration"				"45.0"
			}

			//火之传承-残焰-施法距离、残焰速度
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_cr"	"3"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_ms"	"2"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"remnant_cr_effect_stack"	"20"
			}
			//火之传承-残焰-治疗
			"08"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_heal"	"50"
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"remnant_heal_effect_stack"	"40"
			}
			//火之传承-残焰-攻击力
			"10"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_dmg"	"72"
			}
			"11"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_dmg_duration"	"12"
			}
			"12"
			{
				"var_type"	"FIELD_INTEGER"
				"remnant_dmg_effect_stack"	"60"
			}

		}
	}

	//=================================================================================================================
	// 激活残焰
	//=================================================================================================================
	"imba_ember_spirit_activate_fire_remnant"
	{
		// Custom
	    //---------------------------------------------------------------------------------------------------------
	    "BaseClass"	"ability_lua"
		"AbilityTextureName"	"ember_spirit_activate_fire_remnant"
		"ScriptFile"	"traveler/imba_ember_spirit_abilities.lua"

		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE | DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES | DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES | DOTA_ABILITY_BEHAVIOR_AUTOCAST"
		"AbilityType"					"DOTA_ABILITY_TYPE_BASIC"
		"MaxLevel"						"3"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"FightRecapLevel"				"1"

		"HasScepterUpgrade"			"1"

		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"99999"
		"AbilityCastPoint"				"0.0"
		"AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"0.0"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"150"


		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_INTEGER"
				"speed_multiplier"				"250"
			}
			"02"
			{
				"var_type"				"FIELD_INTEGER"
				"max_charges"				"3"
			}
			"03"
			{
				"var_type"						"FIELD_FLOAT"
				"charge_restore_time"			"35.0"
			}
			"04"
			{
				"var_type"				"FIELD_INTEGER"
				"damage"				"100 200 300"
			}
			"05"
			{
				"var_type"				"FIELD_INTEGER"
				"radius"				"450"
			}
			"06"
			{
				"var_type"				"FIELD_INTEGER"
				"speed"					"1300"
			}

			//火之传承-残焰-施法距离、残焰速度
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_cr"	"3"
			}
			"08"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_ms"	"2"
			}
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"remnant_cr_effect_stack"	"20"
			}
			//火之传承-残焰-治疗
			"10"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_heal"	"50"
			}
			"11"
			{
				"var_type"	"FIELD_INTEGER"
				"remnant_heal_effect_stack"	"40"
			}
			//火之传承-残焰-攻击力
			"12"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_dmg"	"72"
			}
			"13"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_dmg_duration"	"18"
			}
			"14"
			{
				"var_type"	"FIELD_INTEGER"
				"remnant_dmg_effect_stack"	"60"
			}


		}
	}



	//=================================================================================================================
	// 火之传承
	//=================================================================================================================
	"imba_ember_spirit_inheritance_of_Fire"
	{
		// Custom
	    //---------------------------------------------------------------------------------------------------------
	    "BaseClass"	"ability_lua"
		"AbilityTextureName"	"imba_ember_spirit_inheritance_of_Fire"
		"ScriptFile"	"traveler/imba_ember_spirit_abilities.lua"

		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE | DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE"
		"MaxLevel"	"1"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{


			//火之传承-每次击杀获得1层火之传承
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				"killed_stack"	"1"
			}
			//火之传承-全属性
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"stat_per_stack"	"1"
			}

			//火之传承-炎阳索-额外目标
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"chains_targets"	"2"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				"chains_targets_effect_stack"	"20"
			}
			//火之传承-炎阳索-无视魔免和不可见单位
			"05"
			{
				"var_type"	"FIELD_INTEGER"
				"chains_immune_effect_stack"	"40"
			}
			//火之传承-炎阳索-牵引
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				"chains_pull"	"100"
			}
			"07"
			{
				"var_type"	"FIELD_INTEGER"
				"chains_pull_effect_stack"	"60"
			}

			//火之传承-无影拳-克敌机先
			"08"
			{
				"var_type"	"FIELD_INTEGER"
				"fist_mkb_effect_stack"	"20"
			}
			//火之传承-无影拳-躲避投射物
			"09"
			{
				"var_type"	"FIELD_INTEGER"
				"fist_dodge_effect_stack"	"40"
			}
			//火之传承-无影拳-无视护甲
			"10"
			{
				"var_type"	"FIELD_FLOAT"
				"fist_armor"	"24"
			}
			"11"
			{
				"var_type"	"FIELD_INTEGER"
				"fist_armor_effect_stack"	"60"
			}

			//火之传承-烈火罩-移速
			"12"
			{
				"var_type"	"FIELD_FLOAT"
				"guard_ms"	"28"
			}
			"13"
			{
				"var_type"	"FIELD_INTEGER"
				"guard_ms_effect_stack"	"20"
			}
			//火之传承-烈火罩-冷却
			"14"
			{
				"var_type"	"FIELD_FLOAT"
				"guard_cd"	"18"
			}
			"15"
			{
				"var_type"	"FIELD_INTEGER"
				"guard_cd_effect_stack"	"40"
			}
			//火之传承-烈火罩-护甲
			"16"
			{
				"var_type"	"FIELD_FLOAT"
				"guard_armor"	"24"
			}
			"17"
			{
				"var_type"	"FIELD_INTEGER"
				"guard_armor_effect_stack"	"60"
			}

			//火之传承-残焰-施法距离、残焰速度
			"18"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_cr"	"3"
			}
			"19"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_ms"	"2"
			}
			"20"
			{
				"var_type"	"FIELD_INTEGER"
				"remnant_cr_effect_stack"	"20"
			}
			//火之传承-残焰-治疗
			"21"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_heal"	"50"
			}
			"22"
			{
				"var_type"	"FIELD_INTEGER"
				"remnant_heal_effect_stack"	"40"
			}
			//火之传承-残焰-攻击力
			"23"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_dmg"	"72"
			}
			"24"
			{
				"var_type"	"FIELD_FLOAT"
				"remnant_dmg_duration"	"12"
			}
			"25"
			{
				"var_type"	"FIELD_INTEGER"
				"remnant_dmg_effect_stack"	"60"
			}



		}
	}




	//====================================
	//天赋1:+0.8s炎阳索持续时间
	//====================================
	"special_bonus_imba_ember_spirit_1"
    {
	    "BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	   "0.8"
				"ad_linked_ability" "imba_ember_spirit_searing_chains"
			}
		}
	}
	//====================================
	//天赋2:+40无影拳对英雄伤害
	//====================================
	"special_bonus_imba_ember_spirit_2"
    {
	    "BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------
		"AbilitySpecial"
		{

			"01"
			{
				"var_type"	"FIELD_FLOAT"
			    "value"	   "40"
				"ad_linked_ability" "imba_ember_spirit_sleight_of_fist"
			}

		}
	}
	//====================================
	//天赋3:烈火罩自我驱散
	//====================================
	"special_bonus_imba_ember_spirit_3"
    {
	    "BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
			    "value"	   "0"
				"ad_linked_ability" "imba_ember_spirit_flame_guard"
			}
		}
	}
	//====================================
	//天赋4:残焰灼烧敌人-对600范围的敌人每秒造成45点伤害
	//====================================
	"special_bonus_imba_ember_spirit_4"
    {
	    "BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"range"	   "600"
				"ad_linked_ability" "imba_ember_spirit_fire_remnant"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"damage"	   "45"
				"ad_linked_ability" "imba_ember_spirit_fire_remnant"
			}
		}
	}
	//====================================
	//天赋5:真知灼焰：400范围敌方英雄阵亡、或灰烬之灵击杀、或灰烬之灵阵亡，将释放一个残焰。
	//====================================
	"special_bonus_imba_ember_spirit_5"
    {
	    "BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	   "400"
				"ad_linked_ability" "imba_ember_spirit_fire_remnant"
			}
		}
	}

	//====================================
	//天赋6:燎原之势：5残焰充能，26s充能时间。50魔耗。
	//====================================
	"special_bonus_imba_ember_spirit_6"
    {
	    "BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"charge"	   "5"
				"ad_linked_ability" "imba_ember_spirit_fire_remnant"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				"charge_time"	   "26"
				"ad_linked_ability" "imba_ember_spirit_fire_remnant"
			}
			"03"
			{
				"var_type"	"FIELD_FLOAT"
				"manacost"	   "50"
				"ad_linked_ability" "imba_ember_spirit_fire_remnant"
			}
		}
	}

	//====================================
	//天赋7:残焰提供400范围的高空视野
	//====================================
	"special_bonus_imba_ember_spirit_7"
    {
	    "BaseClass"	"special_bonus_undefined"
		"AbilityBehavior"	"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilityType"	"DOTA_ABILITY_TYPE_ATTRIBUTES"
		// Special
		// -------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_FLOAT"
				"value"	   "600"
				"ad_linked_ability" "imba_ember_spirit_fire_remnant"
			}
		}
	}














//////////////////////////////////////////////////////////随机自定义


	"droiyan"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"droiyan"
		"ScriptFile"				"rd/droiyan.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"MaxLevel"				"1"
	}

	"assembly"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"assembly"
		"ScriptFile"				"rd/assembly.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_FRIENDLY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_BUILDING"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityUnitTargetFlags"			"DOTA_UNIT_TARGET_FLAG_INVULNERABLE"
		"MaxLevel"				"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"300"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"60"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"10"
	}


	"tp_tp"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"tp_tp"
		"ScriptFile"				"rd/tp_tp.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"MaxLevel"				"1"
	}


"truce"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"truce"
		"ScriptFile"				"rd/truce.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"MaxLevel"				"1"
		"AbilityCooldown"				"200"
	}


	"traitor"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"traitor"
		"ScriptFile"					"rd/traitor.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"MaxLevel"				"1"
		"AbilityCooldown"				"200"
	}

	"deception"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"deception"
		"ScriptFile"					"rd/deception.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"MaxLevel"				"1"
	}

	"mother_love"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"mother_love"
		"ScriptFile"					"rd/mother_love.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"dmg"					"-10 -15 -20 -25"
			}
		}
	}


	"forbid"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"forbid"
		"ScriptFile"				"rd/forbid.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"MaxLevel"				"4"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"60"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"dur"				"15 20 25 30"
			}

		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}


	"toss_"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"roshan_halloween_toss"
		"ScriptFile"				"rd/toss_.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"MaxLevel"				"4"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000 2000 3000 4000"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"15"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"cast"				"1000 2000 3000 4000"
			}
			"02"
			{
				"var_type"				"FIELD_FLOAT"
				"rune"				"6 7 8 9"
			}
		}
		"AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_2"
	}





"wdnmd"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"wdnmd"
		"ScriptFile"					"rd/wdnmd.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityCastRange"				"1000"
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"rs"					"15"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"					"1000"
			}
		}
	}




"shell_"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"shell_"
		"ScriptFile"					"rd/shell_.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityCastPoint"				"0"
		"AbilityCooldown"				"15"
		"AbilityManaCost"				"100"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"dur"					"4"
			}
			"02"
			{
				"var_type"					"FIELD_INTEGER"
				"dmg"					"30 40 50 60"
			}
		}
	}


"money"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"money"
		"ScriptFile"					"rd/money.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
	}


"mount"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"mount"
		"ScriptFile"					"rd/mount.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_TOGGLE | DOTA_ABILITY_BEHAVIOR_IGNORE_SILENCE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityCooldown"				"1"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"sp"					"20 30 40 50"
			}
		}
	}



"dog"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"dog"
		"ScriptFile"					"rd/dog.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"AbilityCastRange"				"1000"
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"heal"					"20 30 40 50"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"hp"					"400 600 800 1000"
			}
			"03"
			{
				"var_type"					"FIELD_INTEGER"
				"rd"					"1000"
			}
		}
	}

"gamble"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"gamble"
		"ScriptFile"					"rd/gamble.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
	}


	//=================================================================================================================
	// 雷雨
	//=================================================================================================================
	"thunderstorm"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"rd/thunderstorm.lua"
		"AbilityTextureName"			"zuus_lightning_bolt"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"FightRecapLevel"				"1"
		"AbilityCastRange"				"1000"
		"AbilityCastPoint"				"0"
		"AbilityCooldown"				"20 19 18 17"
		"AbilityManaCost"				"100"
		"MaxLevel"						"4"
		"AbilityModifierSupportValue"	"0.0"
		"precache"
		{
			"particle"	"particles/tgp/thunderstorm/thunderstorm_m.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				//持续时间
				"duration"		"6"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				//雷电产生间隔
				"interval"		"0.3"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				//雷电碰撞伤害
				"base_dam"		"10 20 30 40"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				//雷电碰撞宽度
				"wh"			"100"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				//雷电飞行距离
				"dis"			"3000"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				//雷电飞行速度
				"sp"			"2000"
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				//智力百分比伤害
				"int_per"		"30 40 50 60"
			}
			"08"
			{
				"var_type"	"FIELD_FLOAT"
				//眩晕时间
				"stun"		"0.2"
			}
		}
	}

	//LU PI
	"deerskin"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"deerskin"
		"ScriptFile"					"rd/deerskin.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"dur"					"6"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"attsp"					"10 20 30 40"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"max"					"300"
			}
		}
	}

	"des_build"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"des_build"
		"ScriptFile"					"rd/des_build.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"gold"					"70 80 90 100"
			}
		}
	}

	"fight"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"fight"
		"ScriptFile"					"rd/fight.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
				"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"gold1"					"20 30 40 50"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"gold2"					"30"
			}
		}
	}


	"victory"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"victory"
		"ScriptFile"					"rd/victory.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"

	}

	"kill_trees"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"kill_trees"
		"ScriptFile"					"rd/kill_trees.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_TOGGLE"

	}

	"reduce"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"reduce"
		"ScriptFile"					"rd/reduce.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"s"					"20 30 40 50"
			}
		}
	}



	//=================================================================================================================
	// 激光炮塔
	//=================================================================================================================
	"laser_turret"
	{
		"BaseClass"						"ability_lua"
		"ScriptFile"					"rd/laser_turret.lua"
		"AbilityTextureName"			"laser_turret"
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_PURE"
		"FightRecapLevel"				"1"
		"AbilityCastRange"				"600"
		"AbilityCastPoint"				"0"
		"AbilityCooldown"				"20"
		"AbilityManaCost"				"100"
		"MaxLevel"				"4"
		"AbilityModifierSupportValue"	"0.0"
		"precache"
		{
			"soundfile"	"soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts"
			"particle"		"particles/units/heroes/hero_tinker/tinker_laser.vpcf"
			"particle"		"particles/tgp/laser_turret/ltmissile.vpcf"
		}
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"	"FIELD_INTEGER"
				//持续时间
				"duration"		"10 11 12 13"
			}
			"02"
			{
				"var_type"	"FIELD_FLOAT"
				//攻击范围
				"range"			"600 700 800 900"
			}
			"03"
			{
				"var_type"	"FIELD_INTEGER"
				//基础伤害
				"base_dam"		"70 90 110 130"
			}
			"04"
			{
				"var_type"	"FIELD_INTEGER"
				//百分比伤害
				"per"		"50"
			}
			"05"
			{
				"var_type"	"FIELD_FLOAT"
				//攻击间隔
				"interval"			"2.5 2 1.5 1"
			}
			"06"
			{
				"var_type"	"FIELD_FLOAT"
				//击退距离
				"dis"		"20"
			}
			"07"
			{
				"var_type"	"FIELD_FLOAT"
				//数量
				"num"		"3"
			}
		}
	}


	"counterattack"
	{
		"BaseClass"						"ability_lua"
		"AbilityTextureName"			"counterattack"
		"ScriptFile"					"rd/counterattack.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		"MaxLevel"				"4"
		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"dur"					"6"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"att"					"10 15 20 25"
			}
			"03"
			{
				"var_type"					"FIELD_FLOAT"
				"max"					"500"
			}
		}
	}


	"tower"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"tower"
		"ScriptFile"				"rd/tower.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"hp"					"600"
			}
			"02"
			{
				"var_type"					"FIELD_FLOAT"
				"ar"					"7"
			}
		}
	}


	"polymerization"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"polymerization"
		"ScriptFile"				"rd/polymerization.lua"													// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_UNIT_TARGET"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_BOTH"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO"
		"SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		"MaxLevel"				"1"
		// Casting
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCastRange"				"1000"
		"AbilityCastPoint"				"0"

		// Time
		//-------------------------------------------------------------------------------------------------------------
		"AbilityCooldown"				"80"

		// Cost
		//-------------------------------------------------------------------------------------------------------------
		"AbilityManaCost"				"100"

		// Special
		//-------------------------------------------------------------------------------------------------------------
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"				"FIELD_FLOAT"
				"dur"				"15"
			}
		}
	}

	"mountain"
	{
		"BaseClass"				"ability_lua"
		"AbilityTextureName"			"mountain"
		"ScriptFile"				"rd/mountain.lua"															// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		"AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_POINT"
		"AbilityUnitTargetTeam"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
		"AbilityUnitTargetType"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		"AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"
		"AbilityCooldown"				"14"
		"AbilityManaCost"				"100"
		"AbilityCastRange"				"1000"
		"AbilitySpecial"
		{
			"01"
			{
				"var_type"					"FIELD_FLOAT"
				"Stat"					"1 1.5 2 2.5"
			}
		}
	}


}