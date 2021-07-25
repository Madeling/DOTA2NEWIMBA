CreateTalents("npc_dota_hero_troll_warlord", "dl/oldtroll/oldtroll_btrance/modifier_oldtroll_btrance_ally")
oldtroll_btrance = class({})

LinkLuaModifier( "modifier_oldtroll_btrance_ally", "dl/oldtroll/oldtroll_btrance/modifier_oldtroll_btrance_ally", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_oldtroll_btrance_scepter", "dl/oldtroll/oldtroll_btrance/modifier_oldtroll_btrance_scepter", LUA_MODIFIER_MOTION_NONE )

function oldtroll_btrance:IsHiddenWhenStolen() return false end
function oldtroll_btrance:IsStealable() return true end
function oldtroll_btrance:IsRefreshable() return true end

function oldtroll_btrance:OnSpellStart()
    local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("btrance_duration")
	if caster:Has_Aghanims_Shard() then duration = duration + self:GetSpecialValueFor("btrance_shard") end   --魔晶

    EmitGlobalSound("Hero_TrollWarlord.BattleTrance.Cast.Team")
	caster:EmitSound("Hero_TrollWarlord.BattleTrance.Cast")

    local heroes = HeroList:GetAllHeroes()
	for i=1,#heroes do
		local hero = heroes[i]
		if hero ~= nil and hero:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			hero:AddNewModifier(caster,self, "modifier_oldtroll_btrance_ally", {duration = duration})
			if caster:HasScepter() then hero:AddNewModifier(caster,self, "modifier_oldtroll_btrance_scepter", {duration = duration}) end
		end
	end

end
