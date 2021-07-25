
modifier_oldsky_cshot_thinker = class({})

function modifier_oldsky_cshot_thinker:IsHidden() return true end
function modifier_oldsky_cshot_thinker:IsDebuff() return true end
function modifier_oldsky_cshot_thinker:IsStunDebuff() return false end
function modifier_oldsky_cshot_thinker:IsPurgable() return true end

function modifier_oldsky_cshot_thinker:OnCreated()
    if not IsServer() then return end

    self:playeffects()

    self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("cshot_interval"))

end

function modifier_oldsky_cshot_thinker:OnIntervalThink()

    local caster = self:GetCaster()
    local thinker = self:GetParent()
    local ability = self:GetAbility()
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
			thinker:GetAbsOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			ability:GetSpecialValueFor("cshot_dmgrad"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
        )
    if #enemies<1 then return end   --发射环内没人那没事了

    for _,enemy in pairs(enemies) do
        local targets = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			enemy:GetAbsOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			ability:GetSpecialValueFor("cshot_radius"),	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
        )
        if #targets<2 then return end   --发射环内有人但是2000码内就他一个那没事了

        ability:CshotLaunch(targets[2],projname,ability,caster,0,enemy) --发射

    end

end

function modifier_oldsky_cshot_thinker:playeffects()

    local steamid = tonumber(tostring(PlayerResource:GetSteamID(self:GetCaster():GetPlayerOwnerID())))
    local idtable = {
                        76561198361355161,  --小太
                        76561198100269546,  --老太
                        76561198080385796,  --暗号
                        76561198319625131,  --老姐
                    }
    local green = Is_DATA_TG(idtable,steamid)    --绿色C

    local particle_cast1 = "particles/dlparticles/oldsky_cshot/slow_meepo_divining_rod_poof_end_explosion_ring.vpcf"

    local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
    tpos = self:GetParent():GetAbsOrigin()  tpos.z = tpos.z - 100   --调这么低光环也没贴地，估计是别的原因。原来是PATTACH的原因，absfollow就下不去.

    ParticleManager:SetParticleControl( effect_cast1, 0, tpos )
    if green then ParticleManager:SetParticleControl( effect_cast1, 6, Vector(0,255,0) ) end

    self:AddParticle(effect_cast1, false, false, 15, false, false)

end
