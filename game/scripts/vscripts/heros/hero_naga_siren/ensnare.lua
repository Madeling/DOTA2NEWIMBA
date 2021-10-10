ensnare = class({})
LinkLuaModifier("modifier_ensnare_buff", "heros/hero_naga_siren/ensnare.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ensnare_debuff", "heros/hero_naga_siren/ensnare.lua", LUA_MODIFIER_MOTION_NONE)
function ensnare:IsHiddenWhenStolen()
    return false
end

function ensnare:IsStealable()
    return true
end

function ensnare:IsRefreshable()
    return true
end

function ensnare:OnSpellStart()
    local caster = self:GetCaster()
    local caster_team = caster:GetTeamNumber()
    local caster_pos = caster:GetAbsOrigin()
    local target = self:GetCursorTarget()
    caster:EmitSound("Hero_NagaSiren.Ensnare.Cast")
    local P = {
        Ability = self,
        EffectName = "particles/units/heroes/hero_siren/siren_net_projectile.vpcf",
        iMoveSpeed = self:GetSpecialValueFor( "net_speed" ),
        Source =caster,
        Target = target,
        bDrawsOnMinimap = false,
        bDodgeable = true,
        bIsAttack = false,
        bProvidesVision = true,
        bReplaceExisting = false,
        iVisionTeamNumber =caster_team,
        iVisionRadius = 300,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
    }
    TG_CreateProjectile({id=1,team=caster_team,owner=caster,p=P})
end


function ensnare:OnProjectileHit_ExtraData( target, location,kv)
	local caster=self:GetCaster()
	TG_IS_ProjectilesValue1(caster,function()
		target=nil
    end)
	if target == nil  then
		return
	end
    if  target:TG_TriggerSpellAbsorb(self) then
        return
    end
    target:AddNewModifier_RS(caster, self, "modifier_ensnare_debuff", {duration=self:GetSpecialValueFor( "duration" )})
	return true
end

modifier_ensnare_debuff=class({})

function modifier_ensnare_debuff:IsDebuff()
	return true
end

function modifier_ensnare_debuff:IsHidden()
	return false
end

function modifier_ensnare_debuff:IsPurgable()
	return true
end

function modifier_ensnare_debuff:IsPurgeException()
	return true
end

function modifier_ensnare_debuff:OnCreated()
    self.dam=self:GetAbility():GetSpecialValueFor( "dam" )
    if not IsServer() then
        return
    end
    local pos=self:GetParent():GetAbsOrigin()
    local fx = ParticleManager:CreateParticle( "particles/units/heroes/hero_siren/siren_net.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent() )
    ParticleManager:SetParticleControl( fx, 0, pos )
    for num=18,22 do
        ParticleManager:SetParticleControl( fx, num, pos )
    end
    self:AddParticle(fx, false, false, -1, false, false)
    if (pos.z<1 or self:GetParent():HasModifier("modifier_rip_tide_buff2"))  and not self:GetParent():HasFlyMovementCapability() then
        self:StartIntervalThink(1)
    end

end

function modifier_ensnare_debuff:OnIntervalThink()
    local damage = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage =  self.dam,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_UNIT_TARGET_FLAG_NONE,
        ability = self:GetAbility(),
    }
    ApplyDamage( damage )
end

function modifier_ensnare_debuff:OnDestroy()
    self.dam=nil
end

function modifier_ensnare_debuff:CheckState()
	return
	{
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
        [MODIFIER_STATE_TETHERED] = true,
	}
end