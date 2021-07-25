--------------------------------------------------------------------------
-->游戏内部设置
--------------------------------------------------------------------------
KEY=GetDedicatedServerKeyV2("new_imba")
----------------------------------------------------------------------------------------------------------------------------------

--超级兵
CDOTAGamerules.IS_SUPER_CREEP=false
SUPER_CREEP_HP=2000
SUPER_CREEP_ATT=450
SUPER_CREEP_SP=50

--法术圣剑
SPELL_AMP_RAPIER_1 = 0.7
SPELL_AMP_RAPIER_3 = 2.0
SPELL_AMP_RAPIER_SUPER = 2.0


--是否启用抗性
RS_Switch=true

--人头提示
KILL_TIPS=true

--FV团队
GAME_LOSE_TEAM=nil

--出生延迟
SPAWN_TIME=0

--大决战
PVP=false
PVP_NUM=0

if BOT_GOOOD==nil  then
	BOT_GOOOD = {}
end

if BOT_BAD==nil  then
	BOT_BAD = {}
end

WARD = 2000
----------------------------------------------------------------------------------------------------------------------------------


--肉山位置
ROSHAN_POS=Vector(-2814, 2316, 232)

--G
GOOD_POS=Vector(-7450, -6550, 500)

--D
BAD_POS=Vector(7400, 6500, 500)

--中心位置
C_POS=Vector(-500,-300,0)


--肉山
CDOTA_PlayerResource.ROSHAN=nil

--玩家
if CDOTA_PlayerResource.TG_HERO==nil  then
	CDOTA_PlayerResource.TG_HERO = {}
end

--玩家信使
if CDOTA_PlayerResource.TG_COURIER==nil  then
	CDOTA_PlayerResource.TG_COURIER = {}
end

--肉山死亡次数
if CDOTA_PlayerResource.ROSHAN_DIE==nil  then
	CDOTA_PlayerResource.ROSHAN_DIE = 0
end

--投射物
if CDOTA_PlayerResource.Projectile==nil  then
	CDOTA_PlayerResource.Projectile = {}
end

--死亡
if CDOTA_PlayerResource.IMBA_PLAYER_DEATH_STREAK == nil then
	CDOTA_PlayerResource.IMBA_PLAYER_DEATH_STREAK = {}
end

--击杀
if CDOTA_PlayerResource.IMBA_PLAYER_KILL_STREAK == nil then
	CDOTA_PlayerResource.IMBA_PLAYER_KILL_STREAK = {}
end


--数据
if CDOTA_PlayerResource.NET_DATA == nil then
	CDOTA_PlayerResource.NET_DATA = {}
end

if CDOTA_PlayerResource.RD_SK == nil then
	CDOTA_PlayerResource.RD_SK = {}
end


if CDOTAGamerules.IMBA_FOUNTAIN == nil then
	CDOTAGamerules.IMBA_FOUNTAIN = {}
end

if CDOTAGamerules.TOWER == nil then
	CDOTAGamerules.TOWER = {}
end


----------------------------------------------------------------------------------------------------------------------------------


--赛艇甲
Shield_TABLE={ "item_imba_vanguard","item_imba_crimson_guard" ,"item_imba_greatwyrm_plate"}

--艇辉耀
Radiance_TABLE={ "item_imba_radiance","item_imba_splendid" }


----------------------------------------------------------------------------------------------------------------------------------


--防御塔技能
TOWER_ABILITY_TABLE1=
{
	"tower1_att",
	"tower1_def",
	"tower1_watchtower",
	"tower1_med",
}

TOWER_ABILITY_TABLE2=
{
	"tower2_damage",
  "tower2_disarm",
	--"tower1_watchtower",
	"tower1_med",
}

TOWER_ABILITY_TABLE3=
{
	"tower3_fastatt",
  "tower3_laser",
	--"tower1_watchtower",
	"tower1_med",
}

TOWER_ABILITY_TABLE4=
{
--	"tower4_blood",
  "tower4_stun",
  "tower2_damage",
	--"tower1_watchtower",
	"tower1_med",
}

----------------------------------------------------------------------------------------------------------------------------------

--旺旺大礼包
Gift_ITEM=
{
  "item_magic_wand",
  "item_ward_sentry",
  "item_ward_observer",
  "item_pool_blink",
  "item_boots",
  "item_bracer",
  "item_null_talisman",
  "item_wraith_band",
  "item_blades_of_attack",
  "item_infused_raindrop",
  "item_ring_of_basilius",
  "item_urn_of_shadows",
  --"item_tome_of_knowledge",
}


----------------------------------------------------------------------------------------------------------------------------------


--无法触发大晕锤的被动技能
NOT_Abyssal_Blade=
{
  "imba_slardar_bash",
  "imba_faceless_void_time_lock",
  "oldtroll_fervor",
  "greater_bash",
}


----------------------------------------------------------------------------------------------------------------------------------


--买活随机符文
RUNE_RD=
{
  "modifier_rune_regen_tg",
  "modifier_rune_haste_tg",
  "modifier_rune_invis_tg",
  "modifier_rune_doubledamage_tg",
  --"modifier_rune_arcane_tg",
}


----------------------------------------------------------------------------------------------------------------------------------


--不计算抗性的DEBUFF
NOT_RS_DEBUFF=
{
  "modifier_item_heavens_halberd_v2_debuff"
}

----------------------------------------------------------------------------------------------------------------------------------


--不移除的MODIFIER
NOT_MODIFIER_BUFF=
{
  "modifier_invoker_ice_wall_up",
  "modifier_invoker_up",
  "modifier_data_cd",
  "modifier_gnm",
  "modifier_gold",
  "modifier_player",
  "modifier_sk_cd",
}


----------------------------------------------------------------------------------------------------------------------------------

--去除目标的不死buff
KILL_MODIFIER_TABLE= {
  "modifier_refraction_buff1","modifier_false_promise_buff","modifier_false_promise_buff2","modifier_supernova_buff2","modifier_c_return_buff",
  "modifier_imba_shallow_grave","modifier_aphotic_shield"
}


----------------------------------------------------------------------------------------------------------------------------------

Female_HERO=
{
  "npc_dota_hero_vengefulspirit","npc_dota_hero_templar_assassin","npc_dota_hero_enchantress","npc_dota_hero_phantom_assassin","npc_dota_hero_naga_siren" ,
  "npc_dota_hero_crystal_maiden","npc_dota_hero_windrunner","npc_dota_hero_medusa","npc_dota_hero_drow_ranger","npc_dota_hero_puck","npc_dota_hero_lina" ,
  "npc_dota_hero_mirana","npc_dota_hero_queenofpain","npc_dota_hero_dark_willow","npc_dota_hero_death_prophet","npc_dota_hero_legion_commander",
  "npc_dota_hero_snapfire",	"npc_dota_hero_dawnbreaker" ,"npc_dota_hero_winter_wyvern" ,"npc_dota_hero_luna","npc_dota_hero_spectre"
}


----------------------------------------------------------------------------------------------------------------------------------

--随机技能1号表
RandomAbility=
{
  --IMBA
  "multishot","chilling_touch","axe_sprint","berserkers_call","counter_helix","double_edge","surge","dragon_blood","dragon_tail","searing_chains",
  "rocket_barrage","blade_dance","torrent","howl","mystic_snake","crippling_fear","essence_aura","purification","fortunes_end","shackleshot",
  "powershot","poison_nova","storm_bolt","slug","hellfire_blast","shock","caustic_finale","icarus_dive","phantom_strike","malefice","stifling_dagger",
  "epicenter","refraction","wave_of_silence","corrosive_skin","nethertoxin","plague_ward","venomous_gale","warcry","sniper_roll","burrowstrike",
  "imba_rattletrap_battery_assault","guardian_angel","sanity_eclipse","boundless_strike","shapeshift","healing_ward","sprout","midnight_pulse","seriously_punch",
  "ion_shell","culling_blade","ice_vortex","ice_blast","imba_storm_spirit_electric_vortex","imba_storm_spirit_ball_lightning","grenade","echo_stomp",
  "guided_missile","imba_bounty_hunter_shuriken_toss","imba_chaos_knight_chaos_bolt","imba_chaos_knight_chaos_strike","imba_lina_dragon_slave","imba_lina_light_strike_array",
  "imba_razor_plasma_field","oldsky_aseal","imba_leshrac_pulse_nova","aghsfort_mars_spear","imba_mirana_arrow","imba_mirana_leap","hoof_stomp","stampede","breathe_fire",
  "sleight_of_fist","song_of_the_siren","voodoo","decay","windrun","bulldoze","charge_of_darkness","greater_bash","nether_strike","dual_breath","ice_path","macropyre",
  "toss_","wdnmd","shell_","money", "mount","dog", "gamble", "thunderstorm","deerskin","des_build","fight","kill_trees","reduce","laser_turret","counterattack",
  "tower","aphotic_shield","death_coil","frostmourne","purification_new","guardian_angel_new","imba_queenofpain_blink","imba_queenofpain_shadow_strike","imba_queenofpain_scream_of_pain",
  "imba_queenofpain_sonic_wave","imba_huskar_inner_fire","imba_huskar_burning_spear","imba_huskar_berserkers_blood","polymerization","forbid","deception",
  "mother_love", "tp_tp", "assembly","imba_witch_doctor_voodoo_switcheroo","imba_witch_doctor_voodoo_restoration","brain_sap","enfeeble","nightmare",
  "imba_tiny_grow","imba_tiny_avalanche","imba_treant_natures_grasp","imba_light_radiant_bind","imba_light_blinding_light","imba_luna_lucent_beam",
  "imba_luna_lunar_blessing", "imba_luna_moon_glaive","imba_spectre_desolate","imba_phantom_lancer_spirit_lance",
  "imba_phantom_lancer_doppelwalk","imba_phantom_lancer_phantom_edge","imba_bristleback_viscous_nasal_goo","imba_bristleback_quill_spray",

--"droiyan","traitor","truce","flak_cannon","seer_vacuum"
  --原版
  "pangolier_swashbuckle","tidehunter_anchor_smash","rattletrap_hookshot", "earthshaker_aftershock","warlock_rain_of_chaos","pudge_meat_hook","queenofpain_blink",
  "shadow_shaman_voodoo",  "faceless_void_time_walk","dark_troll_warlord_ensnare","polar_furbolg_ursa_warrior_thunder_clap","centaur_khan_war_stomp","roshan_spell_block",
  "roshan_slam","hoodwink_scurry","necronomicon_archer_purge","filler_ability","necronomicon_archer_aoe","satyr_hellcaller_shockwave",

}


--随机技能被动表
RandomAbility2=
  {


    --原版
    "filler_ability",
    "roshan_spell_block",
    "necronomicon_archer_purge",
    "necronomicon_archer_aoe",
    "shredder_reactive_armor",
    "dragon_knight_dragon_blood",
    "omniknight_degen_aura",
    "huskar_burning_spear",
    "bounty_hunter_jinada",
    "ursa_fury_swipes",
    "ogre_magi_bloodlust",
    "troll_warlord_fervor",
    "centaur_return",
    "pangolier_heartpiercer",
    "pangolier_lucky_shot",
    "life_stealer_feast",
   -- "vengefulspirit_command_aura",
    "pudge_flesh_heap",
    "earthshaker_aftershock",
    "sven_great_cleave",
    "drow_ranger_marksmanship",
    "razor_eye_of_the_storm",
    "crystal_maiden_brilliance_aura",
    "kunkka_tidebringer",
    "tiny_grow",
    "sniper_headshot",
    "beastmaster_inner_beast",
    "dragon_knight_elder_dragon_form",
    "huskar_berserkers_blood",


    --IMBA
      "greater_bash",
      "tower1_watchtower",
      "blade_dance",
      "chilling_touch",
      "c_return",
      "untouchable",
      "rip_tide",
      "psi_blades",
      "counter_helix",
      "natural_order_spirit",
      "impetus",
      "feral_impulse",
      --"focusfire",
      "corrosive_skin",
      "poison_sting",
      "blur",
      "divine_favor",
      "hunter_in_the_night",
      "poison_attack",
      "degen_aura",
      "imba_storm_spirit_overload",
      "dlzuus_al",
      "oldtroll_fervor",
      "wdnmd",
      "polymerization",
      "tower",
      "counterattack",
      "laser_turret",
      "reduce",
      "kill_trees",
      --"victory",
      "fight",
      "des_build",
      "deerskin",
      "gamble",
      "dog",
      "money",
      "mount",
      --"truce",
      ---"traitor",
      "deception",
      "mother_love",
      "tp_tp",
      --"droiyan",
      "assembly",
       "imba_tiny_grow",
       "imba_luna_moon_glaive",
       "imba_luna_lunar_blessing",
       "imba_spectre_desolate",
      "imba_phantom_lancer_phantom_edge",
      "imba_bristleback_warpath",
  }


----随机被动表英雄
RandomAbilityHero=
{
  "npc_dota_hero_rubick",
  "npc_dota_hero_snapfire",
  "npc_dota_hero_monkey_king",
  "npc_dota_hero_spectre",
  "npc_dota_hero_kunkka",
  "npc_dota_hero_templar_assassin",
  "npc_dota_hero_nevermore",
  "npc_dota_hero_phoenix",
  "npc_dota_hero_techies",
  "npc_dota_hero_doom_bringer",
  "npc_dota_hero_undying",
  "npc_dota_hero_pudge",
  "npc_dota_hero_rattletrap",
  "npc_dota_hero_dazzle",
  "npc_dota_hero_invoker",
  "npc_dota_hero_visage",
  "npc_dota_hero_tusk",
  "npc_dota_hero_faceless_void",
  "npc_dota_hero_morphling",
  "npc_dota_hero_medusa",
  "npc_dota_hero_tiny",
  "npc_dota_hero_earth_spirit",
  "npc_dota_hero_hoodwink",
  "npc_dota_hero_vengefulspirit",
  "npc_dota_hero_treant",
  "npc_dota_hero_shredder",
  "npc_dota_hero_brewmaster",
}



----------------------------------------------------------------------------------------------------------------------------------


--TK不刷新的技能物品
NOT_RS_ITEM_TK=
{
  "item_bkb",
  "item_bkbs",
  "item_hand_of_god",
  "item_red_cape",
  "item_skadi_v2",
  "item_hand_of_midas",
  "item_sphere",
  "item_necronomicon",
  "item_necronomicon2",
  "item_necronomicon3",
  "item_tome_of_knowledge",
  "item_refresher",
  "item_meteor_hammer",
  "item_titan_hammer",
  "item_helm_of_the_dominator",
  "item_aeon_disk",
  "item_siege",
  "item_sphere",
  "item_manta_v2",
  "item_glimmer_cape",
  "item_imba_orb"
}


--TK3技能随机的技能
TK_RD=
{
"omniknight_purification",
"omniknight_repel",  --原版全能套
"beastmaster_wild_axes",
"double_edge",
"imba_rattletrap_battery_assault",   --胡，发条弹片
"imba_rattletrap_power_cogs",
"imba_rattletrap_rocket_flare",
"imba_life_stealer_rage",
"imba_lifestealer_open_wounds",
"abyssal_underlord_firestorm",
"abyssal_underlord_pit_of_malice",
"tiny_avalanche",
"tiny_toss",
"pudge_meat_hook", --原版屠夫钩
"berserkers_call",
"axe_sprint",
"imba_slardar_sprint",
"imba_slardar_slithereen_crush",
"storm_bolt",
"warcry",
"torrent",
"void",
"crippling_fear",
"imba_doom_bringer_devour",
"treant_natures_grasp",
"treant_leech_seed",
"treant_living_armor",
"sandking_burrowstrike",
"sandking_sand_storm",
"chaos_knight_chaos_bolt",
"imba_tidehunter_gush",
"alchemist_acid_spray",
"alchemist_unstable_concoction",
"lycan_summon_wolves",
"lycan_feral_impulse",
"mars_spear",
"imba_snapfire_scatterblast",
"imba_snapfire_firesnap_cookie",
"imba_snapfire_lil_shredder",    --胡，老奶奶连射
"imba_brewmaster_thunder_clap",
"dragon_knight_breathe_fire",
"dragon_knight_dragon_tail",
"magnataur_shockwave",
"magnataur_empower",
"magnataur_skewer", --                          力量结束
"clinkz_wind_walk",
"viper_nethertoxin",
"razor_plasma_field",
"venomancer_venomous_gale",
"riki_smoke_screen",
"riki_tricks_of_the_trade",
"nyx_assassin_impale",
"nyx_assassin_mana_burn",
"nyx_assassin_spiked_carapace",--胡，原版小强皮
"vengefulspirit_magic_missile",
"vengefulspirit_wave_of_terror",
"stifling_dagger",
"spectre_spectral_dagger",
"antimage_blink",    --胡，原版敌法跳
"antimage_spell_shield",
"slark_dark_pact",
"slark_pounce",
"ursa_earthshock",
"ursa_overpower",
"h_exp",
"rocket_barrage",
"mirana_arrow",
"mirana_leap",
"mirana_starfall",
"medusa_mystic_snake",
"faceless_void_time_walk",
"faceless_void_time_lock",
"bloodseeker_blood_bath",
"imba_bounty_hunter_shuriken_toss",
"imba_bounty_hunter_wind_walk",  --胡，赏金隐身
"luna_lucent_beam",
"furion_teleportation", --胡，原版先知传送
"skywrath_mage_arcane_bolt",
"skywrath_mage_concussive_shot", --胡，原版天怒光蛋
"skywrath_mage_ancient_seal",
"grimstroke_dark_artistry",
"grimstroke_ink_creature",
"grimstroke_spirit_walk",
"dlzuus_ts", --胡，宙斯雷枪
"witch_doctor_paralyzing_cask",
"witch_doctor_maledict",
"pugna_nether_blast",
"pugna_decrepify",   --胡，原版骨法衰老
"disruptor_thunder_strike",
"disruptor_glimpse",
"disruptor_kinetic_field",
"dazzle_poison_touch",
"dazzle_shadow_wave",
"leshrac_split_earth",
"leshrac_diabolic_edict",    --胡，老鹿爆
"leshrac_lightning_storm",
"shadow_demon_soul_catcher",
"voodoo",    --胡，小T变羊
"warlock_fatal_bonds",
"warlock_shadow_word",
"warlock_upheaval",
"jakiro_dual_breath",
"jakiro_ice_path",
"obsidian_destroyer_astral_imprisonment",    --胡，原版黑鸟星体禁锢
"queenofpain_shadow_strike",
"queenofpain_blink", --胡，原版女王跳
"queenofpain_scream_of_pain",
"necrolyte_death_pulse",
"necrolyte_sadist",
"bane_enfeeble",
"bane_brain_sap",
"bane_nightmare",
"lina_dragon_slave",
"lina_light_strike_array",
"lina_fiery_soul",
"lion_impale",
"lion_voodoo",  --胡，原版莱恩羊
"lion_mana_drain",
"imba_batrider_firefly", --胡，蝙蝠飞
"cold_feet",
"ice_vortex",
--"imba_dark_willow_shadow_realm", --天胡，小仙女变黑
"storm_spirit_electric_vortex",
"storm_spirit_static_remnant",
"windrun",
"imba_ogre_magi_focus",  --胡，蓝胖献祭
"imba_ogre_magi_Bloodlust",  --胡，蓝胖嗜血
"bunny_hop",
"surge", --                                                智力结束
}




----------------------------------------------------------------------------------------------------------------------------------


NOT_RS_SK={
  "stampede",
  "hand_of_god",
  "black_hole",
  "macropyre",
  "omni_slash",
  "ghostship",
  "guardian_angel_new",
  "grenade",
  "poison_nova",
}