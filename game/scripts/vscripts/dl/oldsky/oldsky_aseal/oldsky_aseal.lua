
oldsky_aseal = class({})

LinkLuaModifier( "modifier_oldsky_aseal_debuff", "dl/oldsky/oldsky_aseal/modifier_oldsky_aseal_debuff", LUA_MODIFIER_MOTION_NONE )

function oldsky_aseal:IsHiddenWhenStolen() 	return false end
function oldsky_aseal:IsRefreshable() 		return true end
function oldsky_aseal:IsStealable() 			return true end
function oldsky_aseal:GetCooldown() return self:GetSpecialValueFor("aseal_cd") + self:GetCaster():TG_GetTalentValue("special_bonus_oldsky_15r") end		--天赋减CD

function oldsky_aseal:OnSpellStart(scepter)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TG_TriggerSpellAbsorb(self) then
        return
    end
	target:EmitSound("Hero_SkywrathMage.AncientSeal.Target")
	target:AddNewModifier(caster, self, "modifier_oldsky_aseal_debuff", {duration = self:GetSpecialValueFor("aseal_duration")})
	if caster:HasScepter() and not scepter then
		local radius = self:GetSpecialValueFor("aseal_range") + caster:GetCastRangeBonus()
		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		for _, hero in pairs(heroes) do
			if hero ~= target then
				caster:SetCursorCastTarget(hero)
				self:OnSpellStart(true)
				return
			end
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		for _, unit in pairs(units) do
			if unit ~= target then
				caster:SetCursorCastTarget(unit)
				self:OnSpellStart(true)
				return
			end
		end
	end
end
