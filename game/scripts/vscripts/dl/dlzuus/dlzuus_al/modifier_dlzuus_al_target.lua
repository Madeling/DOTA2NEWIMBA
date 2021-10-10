modifier_dlzuus_al_target = class({})

function modifier_dlzuus_al_target:IsHidden() return true end
function modifier_dlzuus_al_target:IsDebuff() return true end
function modifier_dlzuus_al_target:IsBuff() return false end
function modifier_dlzuus_al_target:IsStunDebuff() return false end
function modifier_dlzuus_al_target:IsPurgable() return false end
function modifier_dlzuus_al_target:IsPurgeException() return false end
--function modifier_dlzuus_al_target:RemoveOnDeath() return true end

function modifier_dlzuus_al_target:OnCreated()
    if not IsServer() then return end

    local target = self:GetParent()
    local caster = self:GetAbility():GetCaster()
    local al_damage = self:GetAbility():GetSpecialValueFor("al_damage")
    --local int1 = caster:GetIntellect()      --白字绿字总智力
    local baseint = caster:GetBaseIntellect()    --白字基础智力
    local intco = self:GetAbility():GetSpecialValueFor("al_intco")
    local intco2 = caster:TG_GetTalentValue("special_bonus_dlzuus_20r") or 0
    local total_damage = al_damage + baseint*intco + baseint*intco2

    local damage = {
		victim = target,
		attacker = caster,
		damage = total_damage,
		ability = self:GetAbility(),
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
    ApplyDamage( damage )
end

function modifier_dlzuus_al_target:OnRemoved()
    if not IsServer() then return end

    local target = self:GetParent()
    local caster = self:GetAbility():GetCaster()
    local radius = self:GetAbility():GetSpecialValueFor("al_radius") + caster:TG_GetTalentValue("special_bonus_dlzuus_25r") --天赋加半径
    local dur = self:GetAbility():GetSpecialValueFor("al_delay")

    local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter,注意测试魔免单位，隐身单位，虚无单位，无敌单位，世界外单位
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
    )
    if #enemies<1 then return end

    local ntarget = enemies[1]
    for i=1,#enemies do
        if enemies[i]~=self:GetParent() and not enemies[i]:IsMagicImmune() and not enemies[i]:HasModifier("modifier_dlzuus_al_protect") then
            ntarget = enemies[i]
            break
        end
    end

    if ntarget==self:GetParent() then return end
    --if ntarget:HasModifier("modifier_dlzuus_al_protect") then return end
    local debuff = ntarget:AddNewModifier(
        caster, -- player source
        self:GetAbility(), -- ability source
        "modifier_dlzuus_al_target", -- modifier name
        {
            duration = dur
        }
    )
    self:playeffects(target,ntarget)
end

function modifier_dlzuus_al_target:OnDestroy()  --remove是消失前，destroy是消失后
    if not IsServer() then return end
    if not self:GetParent():IsAlive() then return end

    local al_protect = self:GetAbility():GetSpecialValueFor("al_protect")
    local protect = self:GetParent():AddNewModifier(
        self:GetAbility():GetCaster(), -- player source
        self:GetAbility(), -- ability source
        "modifier_dlzuus_al_protect", -- modifier name
        {
            duration = al_protect
        }
    )
end

function modifier_dlzuus_al_target:playeffects(t,nt)
    local particle_cast = "particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf"
    local sound_cast = "Hero_Zuus.ArcLightning.Cast"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
    local tpos = t:GetAbsOrigin()   tpos.z = tpos.z+100
    local ntpos = nt:GetAbsOrigin() ntpos.z = ntpos.z+100   --不加100在脚底下，调成0在地底下

    ParticleManager:SetParticleControl( effect_cast, 0, tpos )
    ParticleManager:SetParticleControl( effect_cast, 1, ntpos )

    --[[ParticleManager:SetParticleControlEnt(      --如果想要电隐身而特效不走形，得用上面的api，否则找不到模型的attachment，特效会连到世界中心
		effect_cast,
		0,
		t,
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0),
		true
    )
    ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		nt,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
    )]]

    ParticleManager:ReleaseParticleIndex( effect_cast )
    EmitSoundOn( sound_cast, nt )
end
