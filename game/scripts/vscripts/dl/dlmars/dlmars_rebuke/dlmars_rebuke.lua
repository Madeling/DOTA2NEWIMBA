
dlmars_rebuke = class({})

LinkLuaModifier( "modifier_dlmars_rebuke_skewer", "dl/dlmars/dlmars_rebuke/modifier_dlmars_rebuke_skewer", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_dlmars_rebuke_mars", "dl/dlmars/dlmars_rebuke/modifier_dlmars_rebuke_mars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dlmars_rebuke_lookatme", "dl/dlmars/dlmars_rebuke/modifier_dlmars_rebuke_lookatme", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dlmars_rebuke_slow", "dl/dlmars/dlmars_rebuke/modifier_dlmars_rebuke_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dlmars_rebuke_stun", "dl/dlmars/dlmars_rebuke/modifier_dlmars_rebuke_stun", LUA_MODIFIER_MOTION_NONE )

function dlmars_rebuke:IsHiddenWhenStolen() return false end
function dlmars_rebuke:IsStealable() return true end
function dlmars_rebuke:IsRefreshable() return true end
--function dlmars_rebuke:GetAOERadius() return self:GetSpecialValueFor("rebuke_radius") + self:GetCaster():GetCastRangeBonus() end    --绿圈显示范围受施法距离加成

-------------------------------

function dlmars_rebuke:OnSpellStart()
    local caster = self:GetCaster()
    local origin = caster:GetOrigin()
    local point = self:GetCursorPosition()
    local radius = self:GetSpecialValueFor("rebuke_radius")
    local angle = self:GetSpecialValueFor("rebuke_angle")/2         --除以二
    local cast_direction = (point-origin):Normalized()  cast_direction.z = 0

    if not self:GetAutoCastState() then     --无自动施法开始

        if caster:TG_HasTalent("special_bonus_dlmars_15l") then angle = 180 end     --天赋环形炖鸡,这里不用判断是否冲击盾因为上面判断过了

        local modimars = caster:AddNewModifier(caster, self, "modifier_dlmars_rebuke_mars", {})      --施法时马尔斯攻击力增加和暴击，冲击盾不享受此加成

        self.isegg = false
        if RandomInt(1, 100) > 98 then      --彩蛋概率
            radius = radius + 500
            EmitGlobalSound("mars_mars_wheel_all_11")
            self.isegg = true
        end

        self:duangduang(radius,angle,cast_direction,false)       --执行炖鸡函数，最后一个参数指不是冲击盾，播放特效用

        modimars:Destroy()  --马尔斯攻击力buff取消
    end     --无自动施法结束

    ----------------------

    if self:GetAutoCastState() then     --冲击盾开始
        local rushspeed = self:GetSpecialValueFor("rebuke_rushspeed")
        local rushrange = self:GetSpecialValueFor("rebuke_rushrange")

        if caster:TG_HasTalent("special_bonus_dlmars_15r") then rushrange = rushrange + 360 end

        local caster = self:GetCaster()
		local direction = (self:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
		direction.z = 0.0
		local pos = (self:GetCursorPosition() - caster:GetAbsOrigin()):Length2D() <= rushrange and self:GetCursorPosition() or caster:GetAbsOrigin() + direction * rushrange    --施法点在距离内则冲至施法点，外则最远距离
		local duration = (pos-caster:GetAbsOrigin()):Length2D() / rushspeed
		caster:AddNewModifier(caster, self, "modifier_dlmars_rebuke_skewer", {duration = duration, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})        --炖鸡发生在此modi结束时
		local randomsound = RandomInt(1,13)
		if randomsound >= 1 and randomsound <4 then	caster:EmitSound("mars_mars_song_01") end
		if randomsound >= 4 and randomsound <7 then	caster:EmitSound("mars_mars_yes_02") end
		if randomsound >= 7 and randomsound <= 10 then	caster:EmitSound("mars_mars_wheel_deny_02") end
		caster:Purge(false, true, false, false, false)      --释放冲击盾净化自己，bool RemovePositiveBuffs, bool RemoveDebuffs, bool BuffsCreatedThisFrameOnly, bool RemoveStuns, bool RemoveExceptions
    end         --冲击盾结束

end

-----------------------

function dlmars_rebuke:duangduang(radius,angle,cast_direction,ison)     --炖鸡函数

    local caught = false    --判断面前是否有人，播放特效用
    local caster = self:GetCaster()
    local origin = caster:GetOrigin()
    local knockbackdur = self:GetSpecialValueFor("rebuke_kbdur")    --击退时间
    local knockbackdis = self:GetSpecialValueFor("rebuke_kbdis")    --鸡腿距离
    local debuffdur = self:GetSpecialValueFor("rebuke_debuffdur")   --负面状态持续时间（包含击退时间）
	local cast_angle = VectorToAngles( cast_direction ).y

    local enemies = FindUnitsInRadius(
		    caster:GetTeamNumber(),	-- int, your team number
		    origin,	-- point, center point
		    nil,	-- handle, cacheUnit. (not known)
		    radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		    DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		    0,	-- int, order filter
		    false	-- bool, can grow cache
        )

    if #enemies<1 then
        if caster:TG_HasTalent("special_bonus_dlmars_15l") and not ison then     --天赋360炖鸡，无目标小声。非冲击盾才会播放环形
            self:playeffects360(radius,cast_direction,caught)       --播放环形特效
        else
            self:playeffects(radius,cast_direction,caught)      --播放特效
        end
    else
        for _,enemy in pairs(enemies) do
            local enemy_direction = (enemy:GetOrigin() - origin):Normalized()        --判断角度
		    local enemy_angle = VectorToAngles( enemy_direction ).y
            local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )

            if angle_diff < angle then      --角度内有打击目标
                caught = true
                caster:PerformAttack(
					enemy,
					true,   --bUseattackorb
                    true,   --bProcessProcs
					true,   --bSkipcd
					true,   --Ignoreinvis
					false,   --bUseproj
					false,  --bFakeattack
					true    --bNevermiss
				)
                local knockback ={
                    should_stun =false,
                    knockback_duration =knockbackdur,
                    duration =knockbackdur,
                    knockback_distance = knockbackdis,
                    knockback_height = 50,      --击退高度
                    center_x =  caster:GetAbsOrigin().x,
                    center_y =  caster:GetAbsOrigin().y,
                    center_z =  caster:GetAbsOrigin().z,
                }
                if enemy then enemy:AddNewModifier(caster, self, "modifier_knockback", knockback) end   --加if可能会防止目标死了报错

                Timers:CreateTimer(knockbackdur, function()      --强制面向modi会中断击退modi，设置延迟击退完毕后生效
                    if enemy then enemy:AddNewModifier(caster, self, "modifier_dlmars_rebuke_lookatme", {duration = 0.5*debuffdur}) end     --强制面向，持续时间是减速的一半
                    if enemy then enemy:AddNewModifier(caster, self, "modifier_dlmars_rebuke_slow", {duration = debuffdur}) end     --减缓移动和转身速度
                end)

                self:playeffectshit(enemy,cast_direction)       --播放挨打特效
            end
        end

        --特效部分要放在for循环下面，这样才能判断caught
        if caster:TG_HasTalent("special_bonus_dlmars_15l") and not ison then     --天赋360炖鸡，非冲击盾才会播放环形
            self:playeffects360(radius,cast_direction,caught)       --播放环形特效
        else
            self:playeffects(radius,cast_direction,caught)      --播放特效
        end

    end
end

------------------------

function dlmars_rebuke:playeffects(radius,cast_direction,caught)        --特效函数
    -- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash.vpcf"	--"particles/units/heroes/hero_mars/mars_shield_bash.vpcf"
	local sound_cast = "Hero_Mars.Shield.Cast"
	if not caught then
		sound_cast = "Hero_Mars.Shield.Cast.Small"
    end

    local caster = self:GetCaster()
    local origin = caster:GetOrigin()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster )
    ParticleManager:SetParticleControl( effect_cast, 0, origin )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius,radius,radius) )    --CP1调整大小

    if self.isegg then
	    ParticleManager:SetParticleControl( effect_cast, 60, Vector(0,0,205) )      --CP60调整颜色
        ParticleManager:SetParticleControl( effect_cast, 61, Vector(1,0,0) )        --CP61X轴颜色开关
    end

    local steamid = tonumber(tostring(PlayerResource:GetSteamID(self:GetCaster():GetPlayerOwnerID())))
    local idtable = {
        76561198361355161,  --小太
        76561198100269546,  --老太
        76561198319625131,  --老姐
    }
    local pink = Is_DATA_TG(idtable,steamid)    --粉色盾击

    if pink then
	    ParticleManager:SetParticleControl( effect_cast, 60, Vector(255,105,180) )      --CP60调整颜色
        ParticleManager:SetParticleControl( effect_cast, 61, Vector(1,0,0) )        --CP61X轴颜色开关
    end

	ParticleManager:SetParticleControlForward( effect_cast, 0, cast_direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( origin, sound_cast, caster )
end

-----------------------

function dlmars_rebuke:playeffects360(radius,cast_direction,caught)     --环形特效函数
    local caster = self:GetCaster()
    local origin = caster:GetOrigin()

    self:playeffects(radius,cast_direction,caught)

    local newpos1 = RotatePosition(origin, QAngle(0, 120, 0), origin + cast_direction)   --原点，角度，目标点
    local newdirection1 = (newpos1-origin):Normalized()
    self:playeffects(radius,newdirection1,caught)

    local newpos2 = RotatePosition(origin, QAngle(0, 120, 0), origin + newdirection1)
    local newdirection2 = (newpos2-origin):Normalized()
    self:playeffects(radius,newdirection2,caught)
end

-----------------------

function dlmars_rebuke:playeffectshit( target, cast_direction )     --挨打特效函数
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf"
	local sound_cast = "Hero_Mars.Shield.Crit"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 1, cast_direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end
