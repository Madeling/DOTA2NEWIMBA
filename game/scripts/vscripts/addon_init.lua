if IsClient() then
    AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
    HEROSKV = LoadKeyValues("scripts/npc/herolist.txt")
    HeroTalent = LoadKeyValues("scripts/npc/kv/talent.kv")
    HEROSK = LoadKeyValues("scripts/npc/kv/hero_sk.kv")
	require("/tools/client_utils")
end
