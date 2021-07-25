CreateTalents("npc_dota_hero_zuus", "dl/dlzuus/dlzuus_al/modifier_dlzuus_al_protect")
dlzuus_al = class({})

LinkLuaModifier( "modifier_dlzuus_al_protect", "dl/dlzuus/dlzuus_al/modifier_dlzuus_al_protect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dlzuus_al_target", "dl/dlzuus/dlzuus_al/modifier_dlzuus_al_target", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dlzuus_al_zuus", "dl/dlzuus/dlzuus_al/modifier_dlzuus_al_zuus", LUA_MODIFIER_MOTION_NONE )

function dlzuus_al:GetIntrinsicModifierName()
	return "modifier_dlzuus_al_zuus"
end
