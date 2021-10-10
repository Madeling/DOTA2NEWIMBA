CreateTalents("npc_dota_hero_chen", "heros/hero_chen/penitence.lua")
penitence=class({})
LinkLuaModifier("modifier_penitence_debuff", "heros/hero_chen/penitence.lua", LUA_MODIFIER_MOTION_NONE)

function penitence:IsHiddenWhenStolen()
    return false
end

function penitence:IsStealable()
    return true
end


function penitence:IsRefreshable()
    return true
end


function penitence:OnSpellStart()
    local caster=self:GetCaster()
    local casterpos=caster:GetAbsOrigin()
    local curtar=self:GetCursorTarget()
    if  curtar:TG_TriggerSpellAbsorb(self) then
		return
	end
    EmitSoundOn("Hero_Chen.PenitenceCast", caster)
    if caster:TG_HasTalent("special_bonus_chen_1") then
		local heros = FindUnitsInRadius(
			caster:GetTeamNumber(),
			curtar:GetAbsOrigin(),
			curtar,
			350,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false )
		if #heros > 0 then
			for _,hero in pairs(heros) do
				if not hero:IsMagicImmune()  then
                    local projectileTable1 =
                    {
                        Target = hero,
                        Source = caster,
                        Ability = self,
                        EffectName = "particles/units/heroes/hero_chen/chen_penitence_proj.vpcf",
                        iMoveSpeed = self:GetSpecialValueFor("speed"),
                        vSourceLoc = casterpos,
                        bDrawsOnMinimap = false,
                        bDodgeable = false,
                        bIsAttack = false,
                        bVisibleToEnemies = true,
                        bReplaceExisting = false,
                        bProvidesVision = false,
                    }
                    ProjectileManager:CreateTrackingProjectile(projectileTable1)
				end
			end
		end
    else
        local projectileTable1 =
        {
            Target = curtar,
            Source = caster,
            Ability = self,
            EffectName = "particles/units/heroes/hero_chen/chen_penitence_proj.vpcf",
            iMoveSpeed = self:GetSpecialValueFor("speed"),
            vSourceLoc = casterpos,
            bDrawsOnMinimap = false,
            bDodgeable = false,
            bIsAttack = false,
            bVisibleToEnemies = true,
            bReplaceExisting = false,
            bProvidesVision = false,
        }
        ProjectileManager:CreateTrackingProjectile(projectileTable1)
	end

end

function penitence:OnProjectileHit(target, location)
    if target==nil then
        return
    end
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_penitence.vpcf", PATTACH_POINT_FOLLOW, target)
    ParticleManager:SetParticleControl(particle, 0,target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
    if not target:IsMagicImmune()  then
         local caster=self:GetCaster()
        target:AddNewModifier_RS(caster, self, "modifier_penitence_debuff", {duration=self:GetSpecialValueFor("duration")})
    end
end


modifier_penitence_debuff=class({})

function modifier_penitence_debuff:IsDebuff()
    return true
end

function modifier_penitence_debuff:IsPurgable()
    return false
end

function modifier_penitence_debuff:IsPurgeException()
    return false
end

function modifier_penitence_debuff:IsHidden()
    return false
end

function modifier_penitence_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_penitence_debuff:GetEffectName()
    return "particles/units/heroes/hero_chen/chen_penitence_debuff.vpcf"
end


function modifier_penitence_debuff:RemoveOnDeath()
	return true
end

function modifier_penitence_debuff:OnCreated()
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    if IsServer() then
        if self.parent:IsRealHero() then
            self:StartIntervalThink(1)
        end
    end
end

function modifier_penitence_debuff:OnRefresh()
    self:OnCreated()
end

function modifier_penitence_debuff:OnIntervalThink()
        local units=FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self.parent:GetAbsOrigin(),nil,350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        if #units>0 then
                for _,unit in pairs(units) do
                        self.parent:PerformAttack(unit, false, true, true, false, false, false, false)
                end
        end

end


function modifier_penitence_debuff:CheckState()
    return
    {
        [MODIFIER_STATE_ROOTED]=true,
	}
end


function modifier_penitence_debuff:DeclareFunctions()
	return
		{
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		}
end

function modifier_penitence_debuff:GetModifierIncomingDamage_Percentage()
    if self:GetCaster():TG_HasTalent("special_bonus_chen_2") then
	    return 25
    end
    return 0
end