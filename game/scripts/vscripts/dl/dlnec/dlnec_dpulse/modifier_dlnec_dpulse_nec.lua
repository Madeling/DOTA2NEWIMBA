
modifier_dlnec_dpulse_nec = class({})

function modifier_dlnec_dpulse_nec:IsHidden() return true end
function modifier_dlnec_dpulse_nec:IsPurgable() return false end
function modifier_dlnec_dpulse_nec:IsPurgeException() return false end
function modifier_dlnec_dpulse_nec:RemoveOnDeath() return self:GetParent():IsIllusion() end

function modifier_dlnec_dpulse_nec:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_dlnec_dpulse_nec:OnDeath(params)
	if not IsServer() then return end
	if not params.unit then return end	--可能能防报错吧我也不知道随手一加
	if not params.attacker then return end	--可能能防报错吧我也不知道随手一加
    if params.attacker~=self:GetParent() then return end    --不是本人那没事了
	if self:GetParent():PassivesDisabled() then return end  --被破坏那没事了
	if params.unit:IsBuilding() then return end           --是建筑那没事了
	if params.unit:IsMagicImmune() then return end        --魔免单位那没事了
    --if params.attacker:IsIllusion() then return end --分身能继承吗？

    local target = params.unit
    local caster = self:GetParent()
	local radius = self:GetAbility():GetSpecialValueFor("dpulse_radius")
	if caster:Has_Aghanims_Shard() then radius = radius + self:GetAbility():GetSpecialValueFor("dpulse_shard") end	--魔晶
    local cteamnum = caster:GetTeamNumber()
	target:EmitSound("Hero_Necrolyte.DeathPulse")
	if caster.PID==nil then caster.PID={} end	--不加这个分身会报错

    local units = FindUnitsInRadius(
			cteamnum,	-- int, your team number
			target:GetAbsOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_ANY_ORDER,	-- int, order filter
			false	-- bool, can grow cache
        )

    if #units<1 then return end

    local projspeed = self:GetAbility():GetSpecialValueFor("dpulse_projspeed")
    local pnamegood = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_friend.vpcf"
    local pnamebad  = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf"
    for i=1,#units do
        local projname = IsEnemy(units[i],caster) and pnamebad or pnamegood
        local info =
        {
        	Target = units[i],
            Source = target,
        	Ability = self:GetAbility(),    --不要忘了检查修饰器和技能的区别
        	EffectName = projname ,
			iMoveSpeed = projspeed,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,	--不加isourceattachment观察到黄字报错，尝试从人马野怪模型ATTACK_1上创建投射物
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
