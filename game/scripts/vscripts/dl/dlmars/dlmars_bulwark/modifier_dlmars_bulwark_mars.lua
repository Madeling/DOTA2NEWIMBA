
modifier_dlmars_bulwark_mars = ({})

function modifier_dlmars_bulwark_mars:IsHidden() return false end
function modifier_dlmars_bulwark_mars:IsBuff() return true end
function modifier_dlmars_bulwark_mars:IsDebuff() return false end
function modifier_dlmars_bulwark_mars:IsStunDebuff() return false end
function modifier_dlmars_bulwark_mars:IsPurgable() return false end
function modifier_dlmars_bulwark_mars:IsPurgeException() return false end

function modifier_dlmars_bulwark_mars:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,	--检测不到技能的普攻
	}

	return funcs
end

function modifier_dlmars_bulwark_mars:OnTakeDamage(keys)
	--[[original_damage	原伤害.会被大炮放大，不会因为减甲而增加
		damage	实际伤害
		damage_type	伤害类型，物理为1魔法为2纯粹为4
		attacker	伤害者
		unit	受害者
		inflictor	技能伤害才会有
	]]
	if not IsServer() then return end

	if keys.unit ~= self:GetCaster() then return end
	if keys.damage_type ~= 1 then return end 	--物理伤害
	if not keys.attacker:IsRangedAttacker() then return end		--远程
	if keys.attacker:IsBuilding() or keys.inflictor then return end		--不弹建筑和技能
	if self:GetCaster():PassivesDisabled() then return end		--破坏

	local caster = self:GetCaster()
	local attacker = keys.attacker
	local ability = self:GetAbility()

	local angle_front = ability:GetSpecialValueFor( "bangbangangle" )
	local bangbangchance = ability:GetSpecialValueFor("bangbangchance")
	local bangbangradius = ability:GetSpecialValueFor("bangbangradius")
	local bangbangspeed = ability:GetSpecialValueFor("bangbangspeed")

	local facing_direction = caster:GetAnglesAsVector().y		--角度判断
	local attacker_vector = (attacker:GetOrigin() - caster:GetOrigin())
	local attacker_direction = VectorToAngles( attacker_vector ).y
	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ))

	if not (angle_diff < angle_front) then return end	--不是正面攻击那没事了
	if RandomInt(1,100) > bangbangchance then return end	--几率没到那没事了

	local projname = attacker:GetRangedProjectileName()
	local projdamage = keys.original_damage

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		bangbangradius,	-- float, radius. or use FIND_UNITS_EVERYWHERE 用了everywhere就是全图单位
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter 或者从远到近，或者随机单位
		false	-- bool, can grow cache
	)
	if #enemies<1 then return end

	local talent = caster:TG_HasTalent("special_bonus_dlmars_20l") and 2 or 1		--天赋2流弹目标

	for i=1,talent do
		if not enemies[i] or enemies[i]:HasModifier("modifier_fountain_aura_buff") then return end	--有天赋却只有一个目标,或者目标在泉水

		ability:straybullet(enemies[i],projname,projdamage,bangbangspeed)

	end

end
