
oldsky_cshot = class({})

LinkLuaModifier( "modifier_oldsky_cshot_slow", "dl/oldsky/oldsky_cshot/modifier_oldsky_cshot_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_oldsky_cshot_thinker", "dl/oldsky/oldsky_cshot/modifier_oldsky_cshot_thinker", LUA_MODIFIER_MOTION_NONE )

function oldsky_cshot:IsHiddenWhenStolen() 	return false end
function oldsky_cshot:IsRefreshable() 		return true end
function oldsky_cshot:IsStealable() 			return true end

function oldsky_cshot:OnSpellStart()
    local caster = self:GetCaster()
    local radius = self:GetSpecialValueFor("cshot_radius") + caster:GetCastRangeBonus()
    caster:EmitSound("Hero_SkywrathMage.ConcussiveShot.Cast")                                            --播放音效

    local projname = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot.vpcf"
    local steamid = tonumber(tostring(PlayerResource:GetSteamID(self:GetCaster():GetPlayerOwnerID())))
    local idtable = {
                        76561198361355161,  --小太
                        76561198100269546,  --老太
                        76561198080385796,  --暗号
                        76561198319625131,  --老姐
                    }
    local green = Is_DATA_TG(idtable,steamid)    --绿色光蛋
    if green then projname = "particles/dlparticles/oldsky_cshot/green_p_skywrath_mage_concussive_shot.vpcf" end

    local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetAbsOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
        )
    if #enemies<1 then return end
    local num = 1
    if caster:HasScepter() then num = 2 end                     --判断A杖
    if caster:TG_GetTalentValue("special_bonus_oldsky_25l") == 1 then num = #enemies end      --判断天赋，范围光蛋


    for i=1,num do
        self:CshotLaunch(enemies[i],projname,self,caster,1)       --发射
    end
end

function oldsky_cshot:CshotLaunch(target,projname,ability,caster,main,source)   --发射函数，方便thinker调用
    local info =
        {
        	Target = target,
        	Source = source or caster,
        	Ability = ability,
        	EffectName = projname ,
        	iMoveSpeed = ability:GetSpecialValueFor("cshot_speed"),
        	bDrawsOnMinimap = false,
        	bDodgeable = false,
        	bIsAttack = false,
        	bVisibleToEnemies = true,
        	bReplaceExisting = false,
            flExpireTime = GameRules:GetGameTime() + 10,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,	--不加isourceattachment观察到黄字报错，尝试从人马野怪模型ATTACK_1上创建投射物

            bProvidesVision = true, --Bad key for entity "npc_dota_base": Out of range parsed value for field "teamnumber" (-1)!
		    iVisionRadius = ability:GetSpecialValueFor("cshot_visionrad"),
		    fVisionDuration = 10,
            iVisionTeamNumber = caster:GetTeamNumber(), --如果不加这一行就会出现上面那种报错

            ExtraData = {main = main}   --防止发射环创建发射环
        }
        TG_CreateProjectile({id=1,team=caster:GetTeamNumber(),owner=caster,p=info})
end

function oldsky_cshot:OnProjectileHit_ExtraData(target, location, keys)                  --击中
    if not target then return end
    if target:IsMagicImmune() or not target:IsAlive() then return end   --目标魔免或死亡那没事了

    local caster = self:GetCaster()
    local radius = self:GetSpecialValueFor("cshot_dmgrad")

    target:EmitSound("Hero_SkywrathMage.ConcussiveShot.Target") --击中音效

    local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			location,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
        )
    if #enemies<1 then return end
    for i = 1,#enemies do

        enemies[i]:AddNewModifier(caster, self, "modifier_oldsky_cshot_slow", {duration = self:GetSpecialValueFor("cshot_slowdur")})    --范围减速

        local damageTable = {                    --范围伤害
            victim = enemies[i],
            attacker = caster,
            damage = self:GetSpecialValueFor("cshot_damage"),
            damage_type = self:GetAbilityDamageType(),
            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
            ability = self, --Optional.
            }
        ApplyDamage(damageTable)

    end

    if keys.main ~= 1 then return end       --如果不是第一轮投射物就结束，不再创建发射环

    CreateModifierThinker(	                                    --创建发射环
        caster, -- player source
        self, -- ability source
        "modifier_oldsky_cshot_thinker", -- modifier name
        {
            duration = self:GetSpecialValueFor("cshot_slowdur"),
        }, -- kv
        location,   --center
        caster:GetTeamNumber(), --teamnum
        false   --bPhantomBlocker
    )

end
