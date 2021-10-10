--------------------------------------------------------------------------------
--技能特殊动作
--------------------------------------------------------------------------------
imba_rubick_spell_steal_animation_reference = {}

imba_rubick_spell_steal_animation_reference.animations = {
-- AbilityName, bNormalWhenStolen, nActivity, nTranslate, fPlaybackRate
    {"default", nil, ACT_DOTA_CAST_ABILITY_5, "bolt"},

    {"abaddon_mist_coil", false, ACT_DOTA_CAST_ABILITY_3, "", 1.4},

    {"antimage_blink", nil, nil, "am_blink"},
    {"antimage_mana_void", false, ACT_DOTA_CAST_ABILITY_5, "mana_void"},
    {"imba_antimage_blink", nil, nil, "am_blink"},
    {"imba_antimage_mana_void", false, ACT_DOTA_CAST_ABILITY_5, "mana_void"},

    {"axe_battle_hunger", false, ACT_DOTA_CAST_ABILITY_6, ""},
    {"axe_culling_blade", false, ACT_DOTA_CAST_ABILITY_5, "culling_blade"},
    {"imba_axe_battle_hunger", false, ACT_DOTA_CAST_ABILITY_6, ""},
    {"imba_axe_culling_blade", false, ACT_DOTA_CAST_ABILITY_5, "culling_blade"},
    {"culling_blade", false, ACT_DOTA_CAST_ABILITY_5, "culling_blade"},

    {"bane_brain_sap", false, ACT_DOTA_CAST_ABILITY_5,"brain_sap"},
    {"bane_fiends_grip", false, ACT_DOTA_CHANNEL_ABILITY_5,"fiends_grip"},
    {"imba_bane_brain_sap", false, ACT_DOTA_CAST_ABILITY_5,"brain_sap"},
    {"imba_bane_fiends_grip", false, ACT_DOTA_CHANNEL_ABILITY_5,"fiends_grip"},

    {"bristleback_viscous_nasal_goo", false, ACT_DOTA_ATTACK,"",2.0},
    -- bristleback_quill_spray_lua

    {"centaur_warrunner_hoof_stomp", false, ACT_DOTA_CAST_ABILITY_5, "slam", 2.0},
    {"centaur_warrunner_double_edge", false, ACT_DOTA_ATTACK, "", 2.0},
    {"centaur_warrunner_stampede", false, ACT_DOTA_OVERRIDE_ABILITY_4, "strength"},
    {"imba_centaur_hoof_stomp", false, ACT_DOTA_CAST_ABILITY_5, "slam", 2.0},
    {"imba_centaur_double_edge", false, ACT_DOTA_ATTACK, "", 2.0},
    {"imba_centaur_stampede", false, ACT_DOTA_OVERRIDE_ABILITY_4, "strength"},

    {"chaos_knight_chaos_bolt", false, ACT_DOTA_ATTACK,"", 2.0},
    {"chaos_knight_reality_rift", true, ACT_DOTA_CAST_ABILITY_5, "strike", 2.0},
    {"chaos_knight_phantasm", true, ACT_DOTA_CAST_ABILITY_5, "remnant"},

    {"crystal_maiden_crystal_nova", false, ACT_DOTA_CAST_ABILITY_5, "crystal_nova"},
    {"crystal_maiden_frostbite", false, ACT_DOTA_CAST_ABILITY_5, "frostbite"},
    {"crystal_maiden_freezing_field", false, ACT_DOTA_CHANNEL_ABILITY_5, "freezing_field"},
    {"imba_crystal_maiden_freezing_field", false, ACT_DOTA_CHANNEL_ABILITY_5, "freezing_field"},

    {"imba_dark_willow_bramble_maze", false, ACT_DOTA_CAST_ABILITY_5, "bramble_maze"},
    {"imba_dark_willow_cursed_crown", false, ACT_DOTA_CAST_ABILITY_5, "cursed_crown"},
    {"imba_dark_willow_bedlam", false, ACT_DOTA_CAST_ABILITY_5, "bedlam"},
    {"imba_dark_willow_terrorize", false, ACT_DOTA_CAST_ABILITY_5, "terrorize"},

    {"dazzle_shallow_grave", false, ACT_DOTA_CAST_ABILITY_5, "repel"},
    {"dazzle_shadow_wave", false, ACT_DOTA_CAST_ABILITY_3, ""},
    {"dazzle_weave", false, ACT_DOTA_CAST_ABILITY_5, "crystal_nova"},

    {"earth_spirit_boulder_smash", false, ACT_DOTA_CAST_ABILITY_5, "impale"},
    {"earth_spirit_rolling_boulder", false, ACT_DOTA_CAST_ABILITY_5, "gyroshell"},
    {"earth_spirit_magnetize", false, ACT_DOTA_CAST_ABILITY_5, "shadowraze"},

    {"earthshaker_fissure", false, ACT_DOTA_CAST_ABILITY_5, "fissure"},
    {"earthshaker_enchant_totem", false, ACT_DOTA_CAST_ABILITY_5, "totem"},
    {"earthshaker_echo_slam", false, ACT_DOTA_CAST_ABILITY_5, "slam", 3.0},

    {"enigma_black_hole", false, ACT_DOTA_CHANNEL_ABILITY_5, "black_hole"},
    {"imba_enigma_black_hole", false, ACT_DOTA_CHANNEL_ABILITY_5, "black_hole"},

    {"faceless_void_chronosphere", false, ACT_DOTA_CAST_ABILITY_5, "wall"},
    {"imba_faceless_void_chronosphere", false, ACT_DOTA_CAST_ABILITY_5, "wall"},

    {"furion_sprout", false, ACT_DOTA_CAST_ABILITY_5, "sprout"},
    {"furion_teleportation", true, ACT_DOTA_CAST_ABILITY_5, "teleport"},
    {"furion_force_of_nature", false, ACT_DOTA_CAST_ABILITY_5, "summon"},
    {"furion_wrath_of_nature", false, ACT_DOTA_CAST_ABILITY_5, "wrath"},

    {"invoker_cold_snap", false, ACT_DOTA_CAST_ABILITY_5, "bolt"},
    {"invoker_ghost_walk", false, ACT_DOTA_CAST_ABILITY_5, "am_blink", 2.0},
    {"invoker_emp", false, ACT_DOTA_CAST_ABILITY_5, "crystal_nova"},
    {"invoker_sun_strike", false, ACT_DOTA_CAST_ABILITY_5, "wave"},
    {"invoker_chaos_meteor", false, ACT_DOTA_CAST_ABILITY_5, "wave"},

    {"lich_chain_frost", true, ACT_DOTA_ATTACK,"", 1.3},

    {"imba_lina_dragon_slave", false, nil, "wave"},
    {"imba_lina_light_strike_array", false, nil, "lsa"},
    {"imba_lina_laguna_blade", false, nil, "laguna"},

    {"imba_lion_earth_spike", false, ACT_DOTA_CAST_ABILITY_5, "impale"},
    {"imba_lion_hex", false, ACT_DOTA_CAST_ABILITY_3, ""},
    {"imba_lion_finger_of_death", false, ACT_DOTA_CAST_ABILITY_5, "finger"},

    {"luna_lucent_beam", false, ACT_DOTA_CAST_ABILITY_5, "bramble_maze"},

    -- mirana_sacred_arrow_lua
    {"imba_mirana_leap", false, ACT_DOTA_CAST_ABILITY_5, "shadow_realm", 1.5},

    {"imba_ogre_magi_fireblast", false, nil, "frostbite"},

    {"omniknight_purification", true, nil, "purification", 1.4},
    {"omniknight_repel", false, nil, "repel"},
    {"omniknight_guardian_angel", true, nil, "guardian_angel", 1.3},
    {"guardian_angel", true, nil, "guardian_angel", 1.3},

    {"phantom_assassin_stifling_dagger", false, ACT_DOTA_ATTACK,"", 2.0},
    {"phantom_assassin_shadow_strike", false, nil, "qop_blink"},

    {"imba_puck_illusory_orb", false, ACT_DOTA_CAST_ABILITY_5, "wave"},
    {"imba_puck_waning_rift", false, ACT_DOTA_CAST_ABILITY_5, "am_blink", 1.0},
    {"imba_puck_dream_coil", false, ACT_DOTA_CAST_ABILITY_5, "bramble_maze"},

    {"queen_of_pain_shadow_strike", false, nil, "shadow_strike"},
    {"queen_of_pain_blink", false, nil, "qop_blink"},
    {"queen_of_pain_scream_of_pain", false, nil, "scream"},
    {"queen_of_pain_sonic_wave", false, nil, "sonic_wave"},

    {"imba_nevermore_shadowraze1", false, ACT_DOTA_CAST_ABILITY_5, "shadowraze", 2.0},
    {"imba_nevermore_shadowraze2", false, ACT_DOTA_CAST_ABILITY_5, "shadowraze", 2.0},
    {"imba_nevermore_shadowraze3", false, ACT_DOTA_CAST_ABILITY_5, "shadowraze", 2.0},
    {"imba_nevermore_requiem", true, ACT_DOTA_CAST_ABILITY_5, "requiem"},

    {"sniper_assassinate", true, ACT_DOTA_CAST_ABILITY_5, "snipe"},
    {"imba_sniper_assassinate", true, ACT_DOTA_CAST_ABILITY_5, "snipe"},

    -- sven_storm_bolt
    {"sven_warcry", nil, ACT_DOTA_OVERRIDE_ABILITY_3, "strength"},
    {"sven_gods_strength", nil, ACT_DOTA_OVERRIDE_ABILITY_4, "strength"},

    {"tinker_laser", nil, ACT_DOTA_CAST_ABILITY_5, ""},

    {"slardar_slithereen_crush", false, ACT_DOTA_MK_SPRING_END, nil},
    {"imba_slardar_slithereen_crush", false, ACT_DOTA_MK_SPRING_END, nil},
    -- slardar_corrosive_haze

    {"ursa_earthshock", true, ACT_DOTA_CAST_ABILITY_5, "earthshock", 1.7},
    {"ursa_overpower", true, ACT_DOTA_OVERRIDE_ABILITY_3, "overpower"},
    {"ursa_enrage", true, ACT_DOTA_OVERRIDE_ABILITY_4, "enrage"},

    -- vengefulspirit_magic_missile
    {"vengefulspirit_wave_of_terror", nil, nil, "roar"},
    {"vengefulspirit_nether_swap", nil, nil, "qop_blink"},

    -- dawnbreaker
    {"dawnbreaker_fire_wreath", false, ACT_DOTA_CAST_ABILITY_5, "fire_wreath", 1.7},
}
--[[
Advanced:
- pudge_meat_hook
- pudge_dismember
- sand_king_burrowstrike
- slardar_guardian_sprint

Default:

]]

imba_rubick_spell_steal_animation_reference.current = 1
function imba_rubick_spell_steal_animation_reference:SetCurrentReference( spellName )
    self.current = self:FindReference( spellName )
end
function imba_rubick_spell_steal_animation_reference:SetCurrentReferenceIndex( index )
    imba_rubick_spell_steal_animation_reference.current = index
end
function imba_rubick_spell_steal_animation_reference:GetCurrentReference()
    return self.current
end

function imba_rubick_spell_steal_animation_reference:FindReference( spellName )
    for k,v in pairs(self.animations) do
        if v[1]==spellName then
            return k
        end
    end
    return 1
end
function imba_rubick_spell_steal_animation_reference:IsNormal()
    return self.animations[self.current][2] or false
end
function imba_rubick_spell_steal_animation_reference:GetActivity()
    return self.animations[self.current][3] or ACT_DOTA_CAST_ABILITY_5
end
function imba_rubick_spell_steal_animation_reference:GetTranslate()
    return self.animations[self.current][4] or ""
end
function imba_rubick_spell_steal_animation_reference:GetPlaybackRate()
    return self.animations[self.current][5] or 1
end

--------------------------------------------------------------------------------
--Interaction 相互依赖的技能
--------------------------------------------------------------------------------
imba_rubick_spell_steal_interactions_reference = {}
---1  banned  true>0  false not find
imba_rubick_spell_steal_interactions_reference.binding = {
    -- MainAbilityName,SubAbilityName, bOwnerHero,bBanned(-1/true),bBingd(true/-1),bCouple(true/-1)
    --------------------------------------------------------------------------------
    --couple ability
    --Tiderhunter
    {"imba_tidehunter_ravage","imba_tidehunter_gush","tiderhunter",true,-1,true},
    --Kukka
    {"imba_kunkka_torrent_storm","imba_kunkka_torrent","kunkka",true,-1,true},
    {"kunkka_torrent_storm","kunkka_torrent","kunkka",true,-1,true},
    -- Luna
    {"luna_eclipse","luna_lucent_beam","luna",true,-1,true},
    {"imba_luna_eclipse","imba_luna_lucent_beam","luna",true,-1,true},
    -- Spectre
    {"imba_spectre_haunt","imba_spectre_reality","spectre",true,-1,true},
    -- Zuus
    {"zuus_cloud","zuus_lightning_bolt","zuus",true,-1,true},
    --Vengeful Nether
    {"imba_vengeful_nether_swap","imba_vengeful_swap_back","vengefulspirit",true,-1,true},
    --Templar Assassin
    {"imba_templar_assassin_psionic_trap","imba_templar_assassin_trap","templar_assassin",true,-1,true},
    --Terrorblade
    --{"terrorblade_metamorphosis","terrorblade_terror_wave","terrorblade",true,-1,true},
    --MIRANA
    {"imba_mirana_cosmic_dust","imba_mirana_starfall","mirana",true,-1,true},
    --Ember Spirit
    {"fire_remnant","activate_fire_remnant","ember_spirit",true,-1,true},
    {"flame_guard",nil,"ember_spirit",-1,-1,-1},  --神奇的BUG
    --Void Spirit
    {"imba_void_spirit_void_cut","imba_void_spirit_astral_step","void_spirit",true,-1,true},
    --------------------------------------------------------------------------------
    --Binding ability  二段技能，需要来回切那种 (BUG 太多 现在全部禁用)
    --Phoenix
    --{"phoenix_icarus_dive","phoenix_icarus_dive_stop","phoenix",true,true,-1},
    --{"phoenix_fire_spirits","phoenix_launch_fire_spirit","phoenix",true,true,-1},
    --{"phoenix_sun_ray","phoenix_sun_ray_stop","phoenix",true,true,-1},

    --{"imba_phoenix_icarus_dive","imba_phoenix_icarus_dive_stop","phoenix",true,true,-1},
    --{"imba_phoenix_fire_spirits","imba_phoenix_launch_fire_spirit","phoenix",true,true,-1},
    --{"imba_phoenix_sun_ray","imba_phoenix_sun_ray_stop","phoenix",true,true,-1},
    --Pangolier
    {"imba_pangolier_swashbuckle","imba_pangolier_swashbuckle_storedforce","pangolier",-1,-1,-1},
    {"imba_pangolier_shield_crash",nil,"pangolier",-1,-1,-1},  --BUG
    {"imba_pangolier_gyroshell","imba_pangolier_gyroshell_stop","pangolier",-1,-1,-1},   --偷完模型变滚滚了
    --{"pangolier_gyroshell","pangolier_gyroshell_stop","pangolier",-1,-1,-1},
    --Nevermore
    --Alchemist
    --Elder Titan
    {"elder_titan_ancestral_spirit","elder_titan_return_spirit","elder_titan",-1,-1,-1},
    {"elder_titan_return_spirit",nil,"elder_titan",-1,-1,-1},
    {"ancestral_spirit","return_spirit","elder_titan",-1,-1,-1},
    {"return_spirit",nil,"elder_titan",-1,-1,-1},
    --Kukka X marks
    {"x_marks_the_spot","x_return","kunkka",-1,-1,-1},
    {"x_return",nil,"kunkka",-1,-1,-1},
    --Abyssal Underlord
    {"imba_abyssal_underlord_dark_rift","imba_abyssal_underlord_cancel_dark_rift","abyssal_underlord",-1,-1,-1},
    {"imba_abyssal_underlord_cancel_dark_rift",nil,"abyssal_underlord",-1,-1,-1},
    --Tusk
    {"tusk_snowball","tusk_launch_snowball","tusk",-1,-1,-1},
    {"tusk_launch_snowball",nil,"tusk",-1,-1,-1},
    --Naga Siren
    --{"naga_siren_song_of_the_siren","naga_siren_song_of_the_siren_cancel","naga_siren",true,true,-1},
    --keeper_of_the_light
    {"keeper_of_the_light_illuminate","keeper_of_the_light_illuminate_end","keeper_of_the_light",-1,-1,-1},
    --monkey_king
    {"wukongs_command","untransform","monkey_king",-1,-1,-1},
    {"untransform",nil,"monkey_king",-1,-1,-1},
    --FACELESS VOID
    {"imba_faceless_void_time_walk_reverse",nil,"faceless_void",-1,-1,-1},
    {"faceless_void_time_walk_reverse",nil,"faceless_void",-1,-1,-1},
    --Tiny
    {"tiny_toss_tree",nil,"tiny",-1,-1,-1},
    --------------------------------------------------------------------------------
    --Banned ability
    --Juggment
    --{"imba_juggernaut_omni_slash","imba_juggernaut_swift_slash","juggernaut",-1,-1,-1},
    --Shredder  伐木机
    {"imba_timbersaw_chakram","imba_timbersaw_return_chakram","shredder",-1,-1,-1},
    {"imba_timbersaw_chakram_2",nil,"shredder",-1,-1,-1},
    {"imba_shredder_chakram","imba_shredder_return_chakram","shredder",-1,-1,-1},
    {"imba_shredder_chakram_2","imba_shredder_return_chakram_2","shredder",-1,-1,-1},
    --PA  模糊不给偷 否则无敌了惹
    {"imba_phantom_assassin_blur",nil,"phantom_assassin",-1,-1,-1},
    --TK  再装填不给偷 否则无敌了惹
    {"imba_tinker_rearm",nil,"tinker",-1,-1,-1},
    {"tinker_rearm",nil,"tinker",-1,-1,-1},
    {"rearm",nil,"tinker",-1,-1,-1},
    --Bounty Hunter  暗影步不能偷，否则无敌了惹
    {"imba_bounty_hunter_shadow_jaunt",nil,"bounty_hunter",-1,-1,-1},
    --Bane
    {"imba_bane_nightmare",nil,"bane",-1,-1,-1},
    --Mars
    {"aghsfort_mars_arena_of_blood",nil,"mars",-1,-1,-1},
    {"dlimba_mars_bulwark",nil,"mars",-1,-1,-1},
    --Sand_king
    {"imba_sandking_epicenter",nil,"sand_king",-1,-1,-1},
    --Snapfire
    {"snapfire_gobble_up",nil,"snapfire",-1,-1,-1},
    --EARTHSHAKER
    {"imba_earthshaker_fissure",nil,"earthshaker",-1,-1,-1},
    {"imba_earthshaker_enchant_totem",nil,"earthshaker",-1,-1,-1},
    {"imba_earthshaker_aftershock",nil,"earthshaker",-1,-1,-1},
    {"imba_earthshaker_echo_slam",nil,"earthshaker",-1,-1,-1},
    --Naga
    --{"naga_siren_song_of_the_siren","naga_siren_song_of_the_siren_cancel","naga_siren",-1,-1,-1},
    --Invoker
    --{"invoker_invoke",nil,"invoker",-1,-1,-1},
    --courier  信使技能
    --{"courier_autodeliver",nil,"courier",-1,-1,-1},
    --{"courier_return_to_base",nil,"courier",-1,-1,-1},
    --{"courier_shield",nil,"courier",-1,-1,-1},
    --{"courier_burst",nil,"courier",-1,-1,-1},
    --Phoenix
    --{"phoenix_fire_spirits","phoenix_lanuch_fire_spirits","phoenix",-1,-1,-1},
    --{"imba_phoenix_fire_spirits","imba_phoenix_launch_fire_spirit","phoenix",-1,-1,-1},
    --{"imba_phoenix_launch_fire_spirit","imba_phoenix_fire_spirit","phoenix",-1,-1,-1},
    --{"imba_phoenix_launch_fire_spirit","imba_phoenix_fire_spirit","phoenix",-1,-1,-1},
    --keeper_of_the_light
    --{"keeper_of_the_light_illuminate_end","keeper_of_the_light_illuminate","keeper_of_the_light",-1,-1,-1},
}
--false  not find
--true>0 binding spell
---1     banned  spell
function imba_rubick_spell_steal_interactions_reference:IsBanned_SpellSteal( spellName )
    for k,v in pairs(self.binding) do
        if v[1]==spellName then
            return self.binding[k][4]
        end
    end
    return false
end

--true   couple spell
---1     not couple spell
function imba_rubick_spell_steal_interactions_reference:IsBinding_Spell( spellName )
    for k,v in pairs(self.binding) do
        if v[1]==spellName then
            return self.binding[k][5]
        end
    end
    return -1
end

function imba_rubick_spell_steal_interactions_reference:FindBinding_Spell( spellName )
    for k,v in pairs(self.binding) do
        if v[1]==spellName then
            return k
        end
    end
    return false
end

--true   couple spell
---1     not couple spell
function imba_rubick_spell_steal_interactions_reference:IsCouple_Spell( spellName )
    for k,v in pairs(self.binding) do
        if v[1]==spellName then
            return self.binding[k][6]
        end
    end
    return -1
end
--couple spell
function imba_rubick_spell_steal_interactions_reference:FindCouple_Spell( spellName )
    for k,v in pairs(self.binding) do
        if v[1]==spellName then
            return k
        end
    end
    return false
end

imba_rubick_spell_steal_interactions_reference.herokv = {
    "imba_rubick_telekinesis",
    "imba_rubick_fade_bolt",
    "imba_rubick_arcane_supremacy",
    "rubick_empty1",
    "rubick_empty2",
}
---------------------------------------------------------------------
----------------------- Morphling Replicate -------------------------
---------------------------------------------------------------------
imba_morphling_replicate_interactions = {}

imba_morphling_replicate_interactions.bannedAbility = {
    --Elder Titan
    "elder_titan_ancestral_spirit",
    "elder_titan_return_spirit",
    "ancestral_spirit",
    "return_spirit",
    --kunkka X marks
    "x_marks_the_spot",
    "x_return",
    --Abyssal Underlord
    "imba_abyssal_underlord_dark_rift",
    "imba_abyssal_underlord_cancel_dark_rift",
    --faceless_void
    "imba_faceless_void_time_walk_reverse",
    --rubick
    "imba_rubick_telekinesis",
    "imba_rubick_telekinesis_land",
    --monkey_king
    "wukongs_command",
    "untransform",
    --Tusk
    "tusk_snowball",
    "tusk_launch_snowball",
    --keeper_of_the_light
    "keeper_of_the_light_illuminate",
    "keeper_of_the_light_illuminate_end",
    --Ember Spirit
    "flame_guard",
    --Tiny
    "tiny_toss_tree",
    --Earthshaker
    "imba_earthshaker_fissure",
    "imba_earthshaker_enchant_totem",
    "imba_earthshaker_aftershock",
    --Dawnbreaker
    "dawnbreaker_celestial_hammer",
    --Invoker
    "invoker_quas",
    "invoker_wex",
    "invoker_exort",
}

imba_morphling_replicate_interactions.arcana = {
    {"npc_dota_hero_earthshaker","models/items/earthshaker/earthshaker_arcana/earthshaker_arcana.vmdl"},
    {"npc_dota_hero_phantom_assassin","models/heroes/phantom_assassin/pa_arcana.vmdl"},
    --{"npc_dota_hero_inovker","models/heroes/invoker_kid/invoker_kid.vmdl"},
    {"npc_dota_hero_rubick","models/items/rubick/rubick_arcana/rubick_arcana_base.vmdl"},
    --{"npc_dota_hero_juggernaut","models/heroes/juggernaut/juggernaut_arcana.vmdl"},
    {"npc_dota_hero_zuus","models/heroes/zeus/zeus_arcana.vmdl"},
    {"npc_dota_hero_nevermore","models/heroes/shadow_fiend/shadow_fiend_arcana.vmdl"},
    {"npc_dota_hero_pudge","models/items/pudge/arcana/pudge_arcana_base.vmdl"},
    {"npc_dota_hero_wisp","models/items/io/io_ti7/io_ti7.vmdl"},
    --{"npc_dota_hero_queenofpain","models/items/queenofpain/queenofpain_arcana/queenofpain_arcana.vmdl"}, --太loudianle
    {"npc_dota_hero_skeleton_king","models/items/wraith_king/arcana/wraith_king_arcana.vmdl"},
    {"npc_dota_hero_windrunner","models/items/windrunner/windrunner_arcana/wr_arcana_base.vmdl"},
    {"npc_dota_hero_monkey_king","models/heroes/monkey_king/monkey_king.vmdl"},
}

--可能会产生未知BUG 或者 直接炸房的英雄
imba_morphling_replicate_interactions.bannedHero = {
    "npc_dota_hero_morphling",  --禁止套娃
    "npc_dota_hero_target_dummy",  --靶子没技能，复制了等于白复制
    "npc_dota_hero_earthshaker",
    "npc_dota_hero_invoker",    --完美还原V社水人BUG  可以无限叠球
    --"npc_dota_hero_dawnbreaker", --imba 该英雄可以正常使用，V社原版请加上 否则100%炸房
    "npc_dota_hero_grimstroke",
        "npc_dota_hero_spectre",
}

function imba_morphling_replicate_interactions:FindHero_Arcana( heroName )
    for k,v in pairs(self.arcana) do
        if v[1]==heroName then
            return self.arcana[k][2]
        end
    end
    return false
end