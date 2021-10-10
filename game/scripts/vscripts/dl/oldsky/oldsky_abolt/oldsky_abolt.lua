CreateTalents("npc_dota_hero_skywrath_mage", "dl/oldsky/oldsky_abolt/modifier_oldsky_abolt_stack")
oldsky_abolt = class({})

LinkLuaModifier( "modifier_oldsky_abolt_stack", "dl/oldsky/oldsky_abolt/modifier_oldsky_abolt_stack", LUA_MODIFIER_MOTION_NONE )

function oldsky_abolt:IsHiddenWhenStolen() 	return false end
function oldsky_abolt:IsRefreshable() 		return true end
function oldsky_abolt:IsStealable() 			return true end

function oldsky_abolt:OnSpellStart(scepter,talent)
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    caster:EmitSound("Hero_SkywrathMage.ArcaneBolt.Cast")

    local projname = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf"

    local steamid = tonumber(tostring(PlayerResource:GetSteamID(self:GetCaster():GetPlayerOwnerID())))
    local idtable = {
                        76561198361355161,  --小太
                        76561198100269546,  --老太
                        76561198080385796,  --暗号
                        76561198319625131,  --老姐
                    }
    local green = Is_DATA_TG(idtable,steamid)    --绿色C
	if green then projname = "particles/dlparticles/oldsky_abolt/green_p_skywrath_mage_arcane_bolt.vpcf" end

	local projspeed = self:GetSpecialValueFor("abolt_speed")
	if caster:Has_Aghanims_Shard() then projspeed = projspeed + 300 end	--魔晶加C速度

    local info =
    {
        Target = target,
        Source = caster,
        Ability = self,
        EffectName = projname ,
        iMoveSpeed = projspeed ,
        bDrawsOnMinimap = false,
        bDodgeable = false,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = GameRules:GetGameTime() + 10,

        bProvidesVision = true, --Bad key for entity "npc_dota_base": Out of range parsed value for field "teamnumber" (-1)!
		iVisionRadius = self:GetSpecialValueFor("abolt_visionrad"),
		fVisionDuration = 10,
		iVisionTeamNumber = caster:GetTeamNumber(), --如果不加这一行就会出现上面那种报错
    }

    TG_CreateProjectile({id=1,team=caster:GetTeamNumber(),owner=caster,p=info})

	if caster:HasScepter() and not scepter then                 --A杖C。因为加了参数所以不会触发下面代码
		local radius = self:GetSpecialValueFor("abolt_range") + caster:GetCastRangeBonus()
		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		for _, hero in pairs(heroes) do
			if hero ~= target then
				caster:SetCursorCastTarget(hero)
				self:OnSpellStart(true) --当成功触发onspellstart，下面的代码也将停止执行。简单完美地还原了A杖效果，秒啊
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

	if caster:TG_GetTalentValue("special_bonus_oldsky_25r") == 1 and not talent then     --天赋加一个C，onspellstart加一个参数,注意一旦上面A杖的onspellstart触发就不继续往下走了

        local radius = self:GetSpecialValueFor("abolt_range") + caster:GetCastRangeBonus()					--搜寻排序跟A杖区别开换成最远，否则永远都是3个C打两个人 ↓
		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_FARTHEST, false)
		for _, hero in pairs(heroes) do
			if hero ~= target then
				caster:SetCursorCastTarget(hero)
				self:OnSpellStart(true,true) --当成功触发onspellstart，下面的代码也将停止执行。简单完美地还原了A杖效果，秒啊
				return
			end
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_FARTHEST, false)
		for _, unit in pairs(units) do
			if unit ~= target then
				caster:SetCursorCastTarget(unit)
				self:OnSpellStart(true,true)
				return
			end
		end
    end

end

function oldsky_abolt:OnProjectileHit(target, location)
    if not target then return end
    if target:IsMagicImmune() or target:TriggerStandardTargetSpell(self) or not target:IsAlive() then return end
    if target:TG_TriggerSpellAbsorb(self) then return end

    target:EmitSound("Hero_SkywrathMage.ArcaneBolt.Impact")
    local caster = self:GetCaster()

    AddFOWViewer(caster:GetTeamNumber(), location, self:GetSpecialValueFor("abolt_visionrad"), self:GetSpecialValueFor("abolt_visiondur"), false)

    caster:AddNewModifier(caster, self, "modifier_oldsky_abolt_stack", {duration = self:GetSpecialValueFor("abolt_stackdur")})

    local buff = caster:FindModifierByName("modifier_oldsky_abolt_stack")
    local intco_stack = 0
    if buff then intco_stack = buff:GetStackCount()*self:GetSpecialValueFor("abolt_intco_stack") end --可能可以防报错

    local intco = self:GetSpecialValueFor("abolt_intco") + intco_stack   --基础智力系数加层数智力系数

	local dmg = self:GetSpecialValueFor("abolt_damage") + caster:GetIntellect() * intco
	local damageTable = {
						victim = target,
						attacker = caster,
						damage = dmg,
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self, --Optional.
						}
	ApplyDamage(damageTable)
end
