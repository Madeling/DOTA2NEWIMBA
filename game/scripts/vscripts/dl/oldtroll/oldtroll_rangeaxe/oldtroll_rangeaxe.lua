
oldtroll_rangeaxe = class({})

LinkLuaModifier( "modifier_oldtroll_rangeaxe_debuff", "dl/oldtroll/oldtroll_rangeaxe/modifier_oldtroll_rangeaxe_debuff", LUA_MODIFIER_MOTION_NONE )

function oldtroll_rangeaxe:IsHiddenWhenStolen() 		return false end
function oldtroll_rangeaxe:IsRefreshable() 			return true end
function oldtroll_rangeaxe:IsStealable() 				return true end
function oldtroll_rangeaxe:GetAOERadius()           return self:GetSpecialValueFor("rangeaxe_range") end

function oldtroll_rangeaxe:OnSpellStart()

    local caster = self:GetCaster()
    local radius = self:GetSpecialValueFor("rangeaxe_range")
    local projspeed = self:GetSpecialValueFor("rangeaxe_speed")
    local duration = self:GetSpecialValueFor("rangeaxe_duration")

    caster:EmitSound("Hero_TrollWarlord.WhirlingAxes.Ranged")

    local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
    )
    if #enemies <1 then self:playeffects() end  --没人就给线性投射物

    local origin = caster:GetOrigin()
    local axeangle = self:GetSpecialValueFor("rangeaxe_angle")
	local cast_direction = (self:GetCursorPosition()-origin):Normalized()
    local cast_angle = VectorToAngles( cast_direction ).y
    local frontenemies = {}

    for _,enemy in pairs(enemies) do

        local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )

        if angle_diff<=axeangle then

            local projname = caster:GetRangedProjectileName()
            local info =
            {
                Target = enemy,
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
            TG_CreateProjectile({id=1,team=caster:GetTeamNumber(),owner=caster,p=info})
            table.insert(frontenemies, enemy)
        end
    end

    if #frontenemies <1 then self:playeffects() end

end

function oldtroll_rangeaxe:OnProjectileHit(target, location)
    local caster = self:GetCaster()
    if target then target:EmitSound("Hero_TrollWarlord.WhirlingAxes.Target") end
	if target then target:AddNewModifier(caster, self, "modifier_oldtroll_rangeaxe_debuff", {duration = self:GetSpecialValueFor("rangeaxe_duration")}) end

	local talent = false
    if caster:TG_GetTalentValue("special_bonus_oldtroll_25r")==1 then talent = true end		--天赋

	if target then
    	caster:PerformAttack(
						target,
						false,   --buseattackorb
						talent,   --bprocessprocs
						true,   --bskipcd
						true,   --ignoreinvis
						false,  --useproj
						false,  --fakeattack
						false    --nevermiss
					)
	end
end

function oldtroll_rangeaxe:playeffects()    --空斧

    local caster = self:GetCaster()

    local direction = (self:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
    for i = -2,2 do
		local pos = RotatePosition(caster:GetAbsOrigin(), QAngle(0, i * 10, 0), caster:GetAbsOrigin()+direction*100)
		local info =
		{
			Ability = self,
			EffectName = "particles/units/heroes/hero_troll_warlord/troll_warlord_whirling_axe_ranged.vpcf",
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = self:GetSpecialValueFor("rangeaxe_range")/2,
			fStartRadius = self:GetSpecialValueFor("rangeaxe_angle"),
			fEndRadius = self:GetSpecialValueFor("rangeaxe_angle"),
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = false,
			vVelocity = (pos - caster:GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("rangeaxe_speed"),
			bProvidesVision = false,
			ExtraData = {}
		}
		TG_CreateProjectile({id=0,team=caster:GetTeamNumber(),owner=caster,p=info})
	end
end
