
modifier_dlnec_dpulse_waves = class({})

function modifier_dlnec_dpulse_waves:IsHidden() return false end
function modifier_dlnec_dpulse_waves:IsPurgable() return false end
function modifier_dlnec_dpulse_waves:IsPurgeException() return false end

function modifier_dlnec_dpulse_waves:OnCreated()
    if not IsServer() then return end

    local caster = self:GetParent()
    local ability = self:GetAbility()
    local minmana = ability:GetSpecialValueFor("dpulse_minmana_percent")
    local interval = ability:GetSpecialValueFor("dpulse_interval")
    if caster:GetManaPercent() < minmana then self:Destroy() end    --蓝量不够直接没

    self:SetStackCount(1)

    self:StartIntervalThink(interval)

end

function modifier_dlnec_dpulse_waves:OnIntervalThink()
    if not IsServer() then return end

    local caster = self:GetParent()
    local ability = self:GetAbility()
    local now_manap = caster:GetManaPercent()   --判断蓝量够不够，不够直接没 百分比
    local now_manan = caster:GetMana()      --判断蓝量够不够，不够直接没 定值
    local min_manap = ability:GetSpecialValueFor("dpulse_minmana_percent")
    if now_manap < min_manap or now_manan < 200 then self:Destroy() end

    local base_manap = ability:GetSpecialValueFor("dpulse_wavemana_base_percent")
    local increase_manap = ability:GetSpecialValueFor("dpulse_wavemana_increase_percent")
    local max_mana = caster:GetMaxMana()
    local stack = self:GetStackCount()

    local cteamnum = caster:GetTeamNumber()
    local radius = ability:GetSpecialValueFor("dpulse_radius") + ability:GetSpecialValueFor("dpulse_radius_perstack")*stack --半径扩大。是否设置上限？
    local limit = ability:GetSpecialValueFor("dpulse_limit")
    if caster:Has_Aghanims_Shard() then
        radius = radius + self:GetAbility():GetSpecialValueFor("dpulse_shard")
        limit = limit + self:GetAbility():GetSpecialValueFor("dpulse_shard")
    end
    if radius > limit then radius = limit end   --设置上限
    caster:EmitSound("Hero_Necrolyte.DeathPulse")
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

    local projspeed = ability:GetSpecialValueFor("dpulse_projspeed")
    local pnamegood = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_friend.vpcf"
    local pnamebad  = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf"
    for i=1,#units do
        local projname = IsEnemy(units[i],caster) and pnamebad or pnamegood
        local info =
        {
        	Target = units[i],
        	Source = caster,
        	Ability = ability,  --不要忘记检查修饰器和技能混淆
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
    local manaincrease = max_mana*increase_manap/100
    if manaincrease < 180 then manaincrease = 180 end   --设置增加蓝量下限
    local spendmana = max_mana*base_manap/100 + stack*manaincrease   --消耗蓝量，层数加一

    caster:SpendMana(spendmana, ability)
    self:IncrementStackCount()

end
