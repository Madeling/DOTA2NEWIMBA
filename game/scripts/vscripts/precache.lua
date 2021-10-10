
function Awake()
    AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
    HEROSKV = LoadKeyValues("scripts/npc/herolist.txt")
    HeroTalent = LoadKeyValues("scripts/npc/kv/talent.kv")
    HEROSK = LoadKeyValues("scripts/npc/kv/hero_sk.kv")
    LinkLuaModifier("lm_take_no_damage", "modifier/lm_take_no_damage.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_roshan_up", "modifier/roshan/modifier_roshan_up.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_rune_regen_tg", "modifier/rune/modifier_rune_regen_tg.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_rune_doubledamage_tg", "modifier/rune/modifier_rune_doubledamage_tg.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_rune_arcane_tg", "modifier/rune/modifier_rune_arcane_tg.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_rune_haste_tg", "modifier/rune/modifier_rune_haste_tg.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_rune_invis_tg", "modifier/rune/modifier_rune_invis_tg.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_black_dragon", "modifier/neutralunit/modifier_black_dragon.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_player", "modifier/player/modifier_player.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_gnm", "modifier/player/modifier_gnm.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_helide", "modifier/player/modifier_helide.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_data_cd", "modifier/player/modifier_data_cd.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_sk_cd", "modifier/player/modifier_sk_cd.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_confuse", "modifier/old_imba/modifier_confuse.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_dummy_thinker", "modifier/old_imba/modifier_dummy_thinker.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_paralyzed", "modifier/other/modifier_paralyzed.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_truesight_f", "modifier/other/modifier_truesight_f.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_kill_illusion", "modifier/other/modifier_kill_illusion.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_home", "modifier/other/modifier_home.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_imba_meepo_clone_controller", "linken/hero_meepo.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_imba_stunned", "modifier/old_imba/modifier_imba_stunned.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_imba_bashed", "modifier/old_imba/modifier_imba_stunned.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_invoker_up", "modifier/modifier_invoker_up.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_invoker_ice_wall_up", "modifier/modifier_invoker_ice_wall_up.lua", LUA_MODIFIER_MOTION_NONE )
   -- LinkLuaModifier("modifier_generic_knockback_lua", "mb/generic/modifier_generic_knockback_lua.lua", LUA_MODIFIER_MOTION_BOTH )
    LinkLuaModifier("modifier_generic_invisible_lua", "mb/generic/modifier_generic_invisible_lua.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_generic_custom_indicator", "mb/generic/modifier_generic_custom_indicator.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_bane_vision", "heros/hero_bane/modifier_bane_vision.lua", LUA_MODIFIER_MOTION_NONE)

    LinkLuaModifier("modifier_animation", "libraries/modifiers/modifier_animation.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_animation_freeze", "libraries/modifiers/modifier_animation_freeze.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_animation_translate", "libraries/modifiers/modifier_animation_translate.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_animation_translate_permanent", "libraries/modifiers/modifier_animation_translate_permanent.lua", LUA_MODIFIER_MOTION_NONE )


    LinkLuaModifier("modifier_dfinv", "modifier/player/modifier_dfinv.lua", LUA_MODIFIER_MOTION_NONE )
    LinkLuaModifier("modifier_veteran_sp", "modifier/veteran/modifier_veteran_sp.lua", LUA_MODIFIER_MOTION_NONE )

    LinkLuaModifier("modifier_gold", "modifier/other/modifier_gold.lua", LUA_MODIFIER_MOTION_NONE )
end
