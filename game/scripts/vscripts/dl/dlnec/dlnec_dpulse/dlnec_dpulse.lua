dlnec_dpulse = class({})

LinkLuaModifier( "modifier_dlnec_dpulse_nec", "dl/dlnec/dlnec_dpulse/modifier_dlnec_dpulse_nec", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dlnec_dpulse_waves", "dl/dlnec/dlnec_dpulse/modifier_dlnec_dpulse_waves", LUA_MODIFIER_MOTION_NONE )

function dlnec_dpulse:IsHiddenWhenStolen() return false end
function dlnec_dpulse:IsStealable() return true end
function dlnec_dpulse:IsRefreshable() return true end
function dlnec_dpulse:GetAOERadius() return self:GetSpecialValueFor("dpulse_radius") end
function dlnec_dpulse:GetIntrinsicModifierName()
	return "modifier_dlnec_dpulse_nec"
end


function dlnec_dpulse:OnSpellStart()

    local caster = self:GetCaster()
    local radius = self:GetSpecialValueFor("dpulse_radius")
    if caster:Has_Aghanims_Shard() then radius = radius + self:GetSpecialValueFor("dpulse_shard") end   --魔晶
    local cteamnum = caster:GetTeamNumber()
    caster:EmitSound("Hero_Necrolyte.DeathPulse")
    local iswaving = false --caster:FindModifierByName("modifier_dlnec_dpulse_waves")   --艹，忘了这行干嘛的了

    if self:GetAutoCastState() and not iswaving then --瘟疫之潮
        caster:AddNewModifier(caster, self, "modifier_dlnec_dpulse_waves", {})
    end

    local units = FindUnitsInRadius(
			cteamnum,	-- int, your team number
			caster:GetAbsOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_ANY_ORDER,	-- int, order filter
			false	-- bool, can grow cache
        )

    if #units<1 then return end

    local projspeed = self:GetSpecialValueFor("dpulse_projspeed")
    local pnamegood = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_friend.vpcf"
    local pnamebad  = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf"
    for i=1,#units do
        local projname = IsEnemy(units[i],caster) and pnamebad or pnamegood
        local info =
        {
        	Target = units[i],
        	Source = caster,
        	Ability = self,
        	EffectName = projname ,
        	iMoveSpeed = projspeed,
        	bDrawsOnMinimap = false,
        	bDodgeable = false,
        	bIsAttack = false,
        	bVisibleToEnemies = true,
        	bReplaceExisting = false,
        	flExpireTime = GameRules:GetGameTime() + 10,
        	bProvidesVision = false,
        }
        TG_CreateProjectile({id=1,team=cteamnum,owner=caster,p=info})
    end

end

function dlnec_dpulse:OnProjectileHit(target, location)
    if not target then return end
    local caster = self:GetCaster()
    local intco = self:GetSpecialValueFor("dpulse_intco")
    local heal = self:GetSpecialValueFor("dpulse_heal") + caster:GetIntellect()*intco
    local damage = self:GetSpecialValueFor("dpulse_damage") + caster:GetIntellect()*intco + caster:GetIntellect()*caster:TG_GetTalentValue("special_bonus_dlnec_20r")   --基础伤害+智力系数+天赋智力系数
    local bad = IsEnemy(target,caster)
    if not bad then target:Heal(heal, self) end --治疗
    if bad then
        local damagetable = {
            victim = target,
            attacker = caster,
            damage = damage,
            ability = self,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
        }
        ApplyDamage(damagetable)
    end

    --target:AddNewModifier(caster, self, "modifier_dlnec_reaper_target", {duration = 2}) 测试其他技能附加大招。需要添加modi所用的KV。我忘记Linkmodi了也有用。

end
