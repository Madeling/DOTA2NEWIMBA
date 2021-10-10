CreateTalents("npc_dota_hero_phantom_assassin", "heros/hero_phantom_assassin/stifling_dagger.lua")
stifling_dagger=class({})

LinkLuaModifier("modifier_stifling_dagger_debuff", "heros/hero_phantom_assassin/stifling_dagger.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function stifling_dagger:IsHiddenWhenStolen()
    return false
end

function stifling_dagger:IsStealable()
    return true
end

function stifling_dagger:IsRefreshable()
    return true
end

function stifling_dagger:GetCastPoint()
    if self:GetCaster():TG_HasTalent("special_bonus_phantom_assassin_5") then
        return 0.1
    else
        return 0.3
    end
end

function stifling_dagger:OnSpellStart()
	local caster=self:GetCaster()
    local caster_pos=caster:GetAbsOrigin()
    local caster_team=caster:GetTeamNumber()
	local target=self:GetCursorTarget()
    local target_pos=target:GetAbsOrigin()
	local dagger_speed = self:GetSpecialValueFor( "dagger_speed" )
    local rd = self:GetSpecialValueFor( "rd" )
    local sp = self:GetSpecialValueFor( "sp" )
    caster:EmitSound("Hero_PhantomAssassin.Dagger.Cast")
    local heros = FindUnitsInRadius(
        caster_team,
        target_pos,
        nil,
        rd,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false)
        if #heros>0 then
	for _, hero in pairs(heros) do
			local P =
			{
				Target = hero,
				Source = caster,
				Ability = self,
				EffectName = "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_stifling_dagger.vpcf",
				iMoveSpeed = dagger_speed,
				vSourceLoc = caster_pos,
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				bProvidesVision = false,
			}
            TG_CreateProjectile({id=1,team=caster_team,owner=caster,p=P})
            dagger_speed=dagger_speed<=1000 and 1000 or (dagger_speed-100)
	end
end
    if caster:TG_HasTalent("special_bonus_phantom_assassin_2") then
        local P =
        {
            Target = target,
            Source = caster,
            Ability = self,
            EffectName = "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_stifling_dagger.vpcf",
            iMoveSpeed = dagger_speed,
            vSourceLoc = caster_pos,
            bDrawsOnMinimap = false,
            bDodgeable = true,
            bIsAttack = false,
            bVisibleToEnemies = true,
            bReplaceExisting = false,
            bProvidesVision = false,
        }
        TG_CreateProjectile({id=1,team=caster_team,owner=caster,p=P})
    end

end

function stifling_dagger:OnProjectileHit_ExtraData( target, location,kv)
    local caster=self:GetCaster()
	TG_IS_ProjectilesValue1(caster,function()
		target=nil
    end)
	if not target then
		return
	end
	if  target:TG_TriggerSpellAbsorb(self) then
		return
    end
    target:EmitSound("Hero_PhantomAssassin.Dagger.Target")
	caster:PerformAttack(target, false, true, true, false, true, false, true)
	if not target:IsMagicImmune() then
		target:AddNewModifier_RS(caster, self, "modifier_stifling_dagger_debuff", {duration = self:GetSpecialValueFor("duration")})
        if caster:TG_HasTalent("special_bonus_phantom_assassin_1") then
            target:AddNewModifier_RS(caster, self, "modifier_imba_stunned", {duration = 0.3})
        end
	end
end

modifier_stifling_dagger_debuff=class({})

function modifier_stifling_dagger_debuff:IsDebuff()
	return true
end

function modifier_stifling_dagger_debuff:IsHidden()
	return false
end

function modifier_stifling_dagger_debuff:IsPurgable()
	return true
end

function modifier_stifling_dagger_debuff:IsPurgeException()
	return true
end

function modifier_stifling_dagger_debuff:GetEffectName()
    return "particles/econ/items/phantom_assassin/pa_ti8_immortal_head/pa_ti8_immortal_dagger_debuff.vpcf"
end

function modifier_stifling_dagger_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_stifling_dagger_debuff:OnCreated()
    self.SP=self:GetAbility():GetSpecialValueFor("move_slow")
end

function modifier_stifling_dagger_debuff:OnRefresh()
    self.SP=self:GetAbility():GetSpecialValueFor("move_slow")
end


function modifier_stifling_dagger_debuff:CheckState()
	return
	{
        [MODIFIER_STATE_PROVIDES_VISION] = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED ] = true,
        [MODIFIER_STATE_TETHERED] = true,
	}
end

function modifier_stifling_dagger_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_stifling_dagger_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.SP
end
