
oldsky_mflare = class({})

LinkLuaModifier( "modifier_oldsky_mflare_thinker", "dl/oldsky/oldsky_mflare/modifier_oldsky_mflare_thinker", LUA_MODIFIER_MOTION_NONE )

function oldsky_mflare:IsHiddenWhenStolen() 		return false end
function oldsky_mflare:IsRefreshable() 			return true end
function oldsky_mflare:IsStealable() 				return true end
function oldsky_mflare:GetAOERadius() return self:GetSpecialValueFor("mflare_radius") end

function oldsky_mflare:OnSpellStart(scepter)
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	caster:EmitSound("Hero_SkywrathMage.MysticFlare.Cast")		--音效

	self:playeffects("start",pos)			--特效

	CreateModifierThinker(caster, self, "modifier_oldsky_mflare_thinker", {duration = self:GetSpecialValueFor("mflare_duration")}, pos, caster:GetTeamNumber(), false)		--thinker

	if caster:HasScepter() and not scepter then			--A杖
		local radius = self:GetSpecialValueFor("mflare_range") + caster:GetCastRangeBonus()
		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		for _, hero in pairs(heroes) do
			if (hero:GetAbsOrigin() - pos):Length2D() > self:GetSpecialValueFor("mflare_radius") then
				caster:SetCursorPosition(hero:GetAbsOrigin())
				self:OnSpellStart(true)
				return
			end
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		for _, unit in pairs(units) do
			if (unit:GetAbsOrigin() - pos):Length2D() > self:GetSpecialValueFor("mflare_radius") then
				caster:SetCursorPosition(unit:GetAbsOrigin())
				self:OnSpellStart(true)
				return
			end
		end
	end
end

function oldsky_mflare:playeffects(key,pos)				--特效函数

	local steamid = tonumber(tostring(PlayerResource:GetSteamID(self:GetCaster():GetPlayerOwnerID())))
    local idtable = {
                        76561198361355161,  --小太
                        76561198100269546,  --老太
                        76561198080385796,  --暗号
                        76561198319625131,  --老姐
                    }
	local green = Is_DATA_TG(idtable,steamid)    --绿色大

	if key == "start" then
		local particle1 = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient.vpcf"
		if green then particle1 = "particles/econ/items/rubick/rubick_arcana/rbck_arc_skywrath_mage_mystic_flare_ambient.vpcf" end

		local pfx1 = ParticleManager:CreateParticle(particle1, PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl(pfx1, 0, pos)
		ParticleManager:SetParticleControl(pfx1, 1, Vector(self:GetSpecialValueFor("mflare_radius"), self:GetSpecialValueFor("mflare_duration"), 0.1))  --X半径Y时间Z打击间隔

		ParticleManager:ReleaseParticleIndex(pfx1)
	end

	if key == "end" then
		local particle2 = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient.vpcf"
		if green then particle2 = "particles/econ/items/rubick/rubick_arcana/rbck_arc_skywrath_mage_mystic_flare_ambient.vpcf" end

		local radius = self:GetCaster():GetIntellect()*self:GetSpecialValueFor("mflare_intco_exrad") + self:GetSpecialValueFor("mflare_radius")   --爆炸半径扩大

		local pfx2 = ParticleManager:CreateParticle(particle2, PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl(pfx2, 0, pos)
		ParticleManager:SetParticleControl(pfx2, 1, Vector(radius, 1.0, 0.1))  --X半径Y时间Z打击间隔

		ParticleManager:ReleaseParticleIndex(pfx2)
	end

end

--[[老天怒特效在thinker里操作较为复杂，主要因为就算在thinker里设置特效播放10秒，但在thinker消失的时候特效依然会立刻消失，无法实现爆炸效果。
	在技能里操作可以简单地实现预期效果，thinker调用函数便可。技能里设置的播放时间，半径，在技能消失后依旧生效]]

