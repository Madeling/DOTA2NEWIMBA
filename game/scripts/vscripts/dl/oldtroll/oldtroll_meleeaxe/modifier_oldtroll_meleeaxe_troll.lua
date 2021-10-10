
modifier_oldtroll_meleeaxe_troll = class({})

function modifier_oldtroll_meleeaxe_troll:IsHidden() return true end
function modifier_oldtroll_meleeaxe_troll:IsPurgable() return false end
function modifier_oldtroll_meleeaxe_troll:IsPurgeException() return false end
function modifier_oldtroll_meleeaxe_troll:RemoveOnDeath() return self:GetParent():IsIllusion() end

function modifier_oldtroll_meleeaxe_troll:OnCreated()
    if not IsServer() then return end

    self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("meleeaxe_interval"))

end

function modifier_oldtroll_meleeaxe_troll:OnRemoved()
    if not IsServer() then return end

end

function modifier_oldtroll_meleeaxe_troll:OnIntervalThink()
    if not IsServer() then return end

    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    local radius = ability:GetSpecialValueFor("meleeaxe_radius")
    local damage = ability:GetSpecialValueFor("meleeaxe_damage")
    local duration = ability:GetSpecialValueFor("meleeaxe_duration")
    local talent = false
    if caster:TG_GetTalentValue("special_bonus_oldtroll_25l")==1 then talent = true end     --天赋

    local casterpos = caster:GetAbsOrigin()
    local casterdir = caster:GetForwardVector()
    for i = 0,7 do
        local axepos = RotatePosition(casterpos, QAngle(0, i*45, 0), casterpos + casterdir * (radius-175))
        self:playeffects(casterpos,axepos,caster)
    end

    local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetAbsOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			FIND_ANY_ORDER,	-- int, order filter
			false	-- bool, can grow cache
        )

    if #enemies<1 then return end
    for i=1,#enemies do
        caster:PerformAttack(
            enemies[i],
            false,   --buseattackorb
            talent,   --bprocessprocs
            true,   --bskipcd
            true,   --ignoreinvis
            false,  --useproj
            false,  --fakeattack
            false    --nevermiss
        )
        enemies[i]:EmitSound("Hero_TrollWarlord.WhirlingAxes.Target")
        if enemies[i] then enemies[i]:AddNewModifier(caster, ability, "modifier_oldtroll_meleeaxe_debuff", {duration = duration}) end
    end

end

function modifier_oldtroll_meleeaxe_troll:playeffects(casterpos,axepos,caster)
    local particle_cast1 = "particles/units/heroes/hero_troll_warlord/troll_warlord_whirling_axe_melee.vpcf"    --巨魔近战斧头

    local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_ABSORIGIN_FOLLOW, caster ) --巨魔近战斧头

    ParticleManager:SetParticleControl(effect_cast1, 0, casterpos + Vector(0, 0, 100))  --斧头起点
	ParticleManager:SetParticleControl(effect_cast1, 1, axepos + Vector(0, 0, 100))     --斧头终点
    ParticleManager:SetParticleControl(effect_cast1, 4, Vector(self:GetAbility():GetSpecialValueFor("meleeaxe_interval"), 0, 0))    --斧头持续时间

    ParticleManager:ReleaseParticleIndex(effect_cast1)  --释放斧头

end

