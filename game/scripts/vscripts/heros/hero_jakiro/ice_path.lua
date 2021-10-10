
ice_path=ice_path or class({})
ice_path_ani={}
ice_path_ani[1]=1
ice_path_ani[2]=1.2
ice_path_ani[3]=1.6
ice_path_ani[4]=2
LinkLuaModifier("modifier_ice_path_debuff", "heros/hero_jakiro/ice_path.lua", LUA_MODIFIER_MOTION_NONE)
function ice_path:IsHiddenWhenStolen()
    return false
end

function ice_path:IsStealable()
    return true
end

function ice_path:IsRefreshable()
    return true
end

function ice_path:OnAbilityPhaseStart()
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1,ice_path_ani[self:GetLevel()])
    return true
end

function ice_path:OnAbilityPhaseInterrupted()
	self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
    return true
end

function ice_path:OnSpellStart()
	local caster = self:GetCaster()
	local casterpos = caster:GetAbsOrigin()
	local hpos=caster:GetUpVector()*100
	local dis=self:GetSpecialValueFor("dis")
	local casterposend = casterpos+caster:GetForwardVector()*dis
	casterposend.z=0
	local dir=TG_Direction(casterposend,casterpos)
	local wh=self:GetSpecialValueFor("wh")
	local b_count=self:GetSpecialValueFor("b_count")
	local b_i=self:GetSpecialValueFor("b_i")
	local b_dis=self:GetSpecialValueFor("b_dis")
	local b_rd=self:GetSpecialValueFor("b_rd")
	local b_dam=self:GetSpecialValueFor("b_dam")
	local stun=self:GetSpecialValueFor("stun")
	local dam=self:GetSpecialValueFor("dam")
	EmitSoundOn( "Hero_Jakiro.IcePath", caster )
	local pfx = ParticleManager:CreateParticle( "particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, casterpos+hpos )
	ParticleManager:SetParticleControl( pfx, 1, casterposend+hpos )
	ParticleManager:SetParticleControl( pfx, 2, casterpos+hpos )
	ParticleManager:ReleaseParticleIndex( pfx )
	local pfx2 = ParticleManager:CreateParticle( "particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path_b.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx2, 0, casterpos+hpos )
	ParticleManager:SetParticleControl( pfx2, 1, casterposend +hpos)
	ParticleManager:SetParticleControl( pfx2, 2, Vector( stun, 0, 0 ) )
	ParticleManager:SetParticleControl( pfx2, 9, casterpos+hpos )
	ParticleManager:ReleaseParticleIndex( pfx2 )

	local Projectile=
	{
		Ability = self,
		vSpawnOrigin = casterpos,
		EffectName =nil,
		fDistance = dis,
		fStartRadius = wh,
		fEndRadius = wh,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam	 = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		vVelocity	=dir*1000,
		bProvidesVision = true,
		iVisionRadius = 500,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	ProjectileManager:CreateLinearProjectile( Projectile)
	local dis2=0
	local count=b_count
	local num=0

	Timers:CreateTimer(1, function()
		dis2=dis2+b_dis
		num=num+1
		local bpos=casterpos+dir*dis2
		EmitSoundOnLocationWithCaster( bpos, "TG.jkboom", caster )
		local p = ParticleManager:CreateParticle( "particles/econ/events/ti9/high_five/high_five_impact_snow.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( p, 3, bpos )
		ParticleManager:ReleaseParticleIndex( p )
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), bpos, nil, b_rd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,target in pairs(enemies) do
			local damageTable = {
				victim = target,
				attacker =  self:GetCaster(),
				damage = dam/2,
				damage_type =DAMAGE_TYPE_MAGICAL,
				ability = self,
				}
				ApplyDamage(damageTable)
		end
		if num>=count then
			return nil
		else
			return  b_i
		end
	end
	)
end

function ice_path:OnProjectileHit_ExtraData(target, location, kv)

	if not target then
		return
	end
	local stun=self:GetSpecialValueFor("stun")
	local dam=self:GetSpecialValueFor("dam")
	if not target:IsMagicImmune() then
		target:AddNewModifier_RS(  self:GetCaster(), self, "modifier_ice_path_debuff", {duration=stun} )
		local damageTable = {
			victim = target,
			attacker =  self:GetCaster(),
			damage = dam,
			damage_type =DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_UNIT_TARGET_FLAG_NONE,
			ability = self,
			}
			ApplyDamage(damageTable)
	end
end

modifier_ice_path_debuff=modifier_ice_path_debuff or class({})
function modifier_ice_path_debuff:IsDebuff()
    return true
end
function modifier_ice_path_debuff:IsPurgable()
    return false
end
function modifier_ice_path_debuff:IsPurgeException()
    return true
end
function modifier_ice_path_debuff:IsHidden()
    return false
end


function modifier_ice_path_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost_lich.vpcf"
   end

function modifier_ice_path_debuff:StatusEffectPriority()
   return 100
end

function modifier_ice_path_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_frozen.vpcf"
end

function modifier_ice_path_debuff:GetEffectAttachType()
   return PATTACH_ABSORIGIN_FOLLOW
end



function modifier_ice_path_debuff:CheckState()
    return
     {
            [MODIFIER_STATE_FROZEN] = true,
            [MODIFIER_STATE_STUNNED] = true,
            [MODIFIER_STATE_MUTED] = true,
            [MODIFIER_STATE_SILENCED] = true,
    }
end
