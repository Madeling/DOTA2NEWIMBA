
oldtroll_fervor = class({})

LinkLuaModifier( "modifier_oldtroll_fervor_troll", "dl/oldtroll/oldtroll_fervor/modifier_oldtroll_fervor_troll", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_oldtroll_fervor_stack", "dl/oldtroll/oldtroll_fervor/modifier_oldtroll_fervor_stack", LUA_MODIFIER_MOTION_NONE )

function oldtroll_fervor:GetIntrinsicModifierName()
	return "modifier_oldtroll_fervor_troll"
end
