mirror_image=class({})
LinkLuaModifier("modifier_illusions_mirror_image", "heros/hero_naga_siren/mirror_image.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mirror_image_invuln", "heros/hero_naga_siren/mirror_image.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ensnare_debuff", "heros/hero_naga_siren/ensnare.lua", LUA_MODIFIER_MOTION_NONE)
function mirror_image:IsHiddenWhenStolen()
    return false
end

function mirror_image:IsStealable()
    return true
end

function mirror_image:IsRefreshable()
    return true
end

function mirror_image:OnSpellStart()
    local caster = self:GetCaster()
    local caster_team = caster:GetTeamNumber()
    local caster_pos = caster:GetAbsOrigin()
    local dur=self:GetSpecialValueFor("illusion_duration")
    local outgoing_damage=self:GetSpecialValueFor("outgoing_damage")
    local incoming_damage=self:GetSpecialValueFor("incoming_damage")
    caster:EmitSound("Hero_NagaSiren.MirrorImage")
    caster:AddNewModifier(caster, self, "modifier_mirror_image_invuln", {duration=self:GetSpecialValueFor("invuln_duration")})
    local modifier=
    {
        outgoing_damage=outgoing_damage,
        incoming_damage=incoming_damage,
        bounty_base=100,
        bounty_growth=0,
        outgoing_damage_structure=outgoing_damage,
        outgoing_damage_roshan=outgoing_damage,
    }
    caster.mirror_imageillusions=CreateIllusions(caster, caster, modifier, self:GetSpecialValueFor("images_count"), 100, true, true)
    for _, target in pairs(caster.mirror_imageillusions) do
        target:AddNewModifier(caster, self, "modifier_kill", {duration=dur})
        target:AddNewModifier(caster, self, "modifier_illusions_mirror_image", {duration=dur})
    end
end

function mirror_image:OnProjectileHit_ExtraData( target, location,kv)
	local caster=self:GetCaster()
	if target == nil  then
		return
	end
    target:AddNewModifier(caster, self, "modifier_ensnare_debuff", {duration=self:GetSpecialValueFor( "dur" )})
	return true
end

modifier_illusions_mirror_image=class({})

function modifier_illusions_mirror_image:IsPassive()
    return true
end

function modifier_illusions_mirror_image:IsHidden()
    return true
end

function modifier_illusions_mirror_image:IsPurgable()
    return false
end

function modifier_illusions_mirror_image:IsPurgeException()
    return false
end

function modifier_illusions_mirror_image:IsIllusion()
    return true
end

function modifier_illusions_mirror_image:StatusEffectPriority()
    return 4
end

function modifier_illusions_mirror_image:GetStatusEffectName()
    return "particles/heros/naga_siren/status_effect_mirror_image.vpcf"
end

function modifier_illusions_mirror_image:OnCreated(tg)
    self.chance = self:GetAbility():GetSpecialValueFor("ch")
    self.heal = self:GetAbility():GetSpecialValueFor("heal")
end

function modifier_illusions_mirror_image:OnDestroy(tg)
    self.chance = nil
    self.heal = nil
end

function modifier_illusions_mirror_image:DeclareFunctions()
    return
    {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_illusions_mirror_image:OnAttackLanded(tg)
    if not IsServer() then
		return
    end
    if tg.attacker ~= self:GetParent() or tg.target:IsBuilding() or not tg.target:IsAlive() then
		return
    end
    if self:GetCaster():HasModifier("modifier_song_of_the_siren_buff") then
        local hp=tg.damage* self.heal*0.01
        self:GetCaster():Heal(hp , self:GetParent())
        SendOverheadEventMessage(self:GetCaster(), OVERHEAD_ALERT_HEAL, self:GetCaster(),hp, nil)
    end
    if (tg.target:GetAbsOrigin().z<1 or tg.target:HasModifier("modifier_rip_tide_buff2")) and RollPseudoRandomPercentage(  self.chance,0,self:GetParent()) then
        self:GetParent():EmitSound("Hero_NagaSiren.Ensnare.Cast")
        local P = {
            Ability = self:GetAbility(),
            EffectName = "particles/units/heroes/hero_siren/siren_net_projectile.vpcf",
            iMoveSpeed = 1500,
            Source =self:GetParent(),
            Target = tg.target,
            bDrawsOnMinimap = false,
            bDodgeable = true,
            bIsAttack = false,
            bProvidesVision = true,
            bReplaceExisting = false,
            iVisionTeamNumber =self:GetParent():GetTeamNumber(),
            iVisionRadius = 300,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
        }
        ProjectileManager:CreateTrackingProjectile(P)
    end
end

modifier_mirror_image_invuln=class({})

function modifier_mirror_image_invuln:IsHidden()
    return true
end

function modifier_mirror_image_invuln:IsPurgable()
    return false
end

function modifier_mirror_image_invuln:IsPurgeException()
    return false
end

function modifier_mirror_image_invuln:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_mirror_image_invuln:GetEffectName()
    return "particles/units/heroes/hero_siren/naga_siren_mirror_image.vpcf"
end

function modifier_mirror_image_invuln:CheckState()
	return
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end
