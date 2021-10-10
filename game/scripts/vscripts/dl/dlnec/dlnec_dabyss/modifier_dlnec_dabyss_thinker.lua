
modifier_dlnec_dabyss_thinker = class({})

function modifier_dlnec_dabyss_thinker:IsHidden() return false end
function modifier_dlnec_dabyss_thinker:IsDebuff() return true end
function modifier_dlnec_dabyss_thinker:IsStunDebuff() return false end
function modifier_dlnec_dabyss_thinker:IsPurgable() return false end
function modifier_dlnec_dabyss_thinker:IsPurgeException() return false end

function modifier_dlnec_dabyss_thinker:OnCreated()
    if not IsServer() then return end

    --print("abysscreated")
    local ability = self:GetAbility()
    local pos = self:GetParent():GetAbsOrigin()
    local radius = ability:GetSpecialValueFor("dabyss_radius")

    local sound1 = "soundboard.diretide.ghost"
    self:GetParent():EmitSound(sound1) --播放音效

    self:playeffects(pos,radius)    --播放特效

end

function modifier_dlnec_dabyss_thinker:OnRemoved()
    if not IsServer() then return end

    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local thinker = self:GetParent()
    local cteamnum = caster:GetTeamNumber()
    local radius = ability:GetSpecialValueFor("dabyss_radius")
    local pos = self:GetParent():GetAbsOrigin()

    local enemies = FindUnitsInRadius(
			cteamnum,	-- int, your team number
			thinker:GetAbsOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			FIND_ANY_ORDER,	-- int, order filter
			false	-- bool, can grow cache
        )

    if #enemies<1 then return end

    for _,enemy in pairs(enemies) do
        enemy:AddNewModifier(caster, ability, "modifier_dlnec_reaper_judge", {duration = ability:GetSpecialValueFor("dabyss_reaper_stun")+0.1})   --不加judge不加层数
        enemy:AddNewModifier(caster, ability, "modifier_dlnec_reaper_target", {duration = ability:GetSpecialValueFor("dabyss_reaper_stun")})
    end

    self:playeffects2(pos,radius)   --播放特效2

end

function modifier_dlnec_dabyss_thinker:playeffects(pos,radius)
    local particle_cast1 = "particles/dlparticles/dlnec_dabyss/green_p_juggernaut_blade_fury_abyssal_golden.vpcf"   --剑圣转
    local particle_cast3 = "particles/dlparticles/dlnec_dabyss/half_pudge_arcana_dismember_wood.vpcf"    --屠夫钩

    local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil ) --剑圣转
    local effect_cast3 = ParticleManager:CreateParticle( particle_cast3, PATTACH_WORLDORIGIN, nil ) --屠夫钩

    ParticleManager:SetParticleControl( effect_cast1, 0, pos )  --剑圣转
    ParticleManager:SetParticleControl( effect_cast1, 5, Vector(radius+100,0,0) )   --半径，剑圣转要比预想的大100，视觉效果才正

    ParticleManager:SetParticleControl( effect_cast3, 0, pos ) --屠夫钩
    ParticleManager:SetParticleControl( effect_cast3, 14, Vector(1,0,0) )   --不知道是什么，但可以让钩子颜色更自然
    ParticleManager:SetParticleControl( effect_cast3, 15, Vector(0,255,0) ) --钩子光晕颜色

    self:AddParticle(effect_cast1, false, false, 15, false, false)  --要加这一行并且不能release，否则剑圣转特效不会随着thinker消失,中间是priority

    ParticleManager:ReleaseParticleIndex( effect_cast3 )    --解放屠夫钩

end

function modifier_dlnec_dabyss_thinker:playeffects2(pos,radius)
    local particle_cast1 = "particles/econ/items/pugna/pugna_ti9_immortal/pugna_ti9_immortal_netherblast_pre.vpcf"   --骨法爆

    local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil ) --骨法爆

    ParticleManager:SetParticleControl( effect_cast1, 0, pos )  --骨法爆
    ParticleManager:SetParticleControl( effect_cast1, 1, Vector(radius,3,1) )   --X为半径，Y为时间，Z不知道

    ParticleManager:ReleaseParticleIndex( effect_cast1 )

end
