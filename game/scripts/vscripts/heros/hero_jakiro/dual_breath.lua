dual_breath=dual_breath or class({})
LinkLuaModifier("modifier_dual_breath_debuff", "heros/hero_jakiro/dual_breath.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dual_breath_motion", "heros/hero_jakiro/dual_breath.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function dual_breath:IsHiddenWhenStolen()
    return false
end

function dual_breath:IsStealable()
    return true
end

function dual_breath:IsRefreshable()
    return true
end

function dual_breath:OnSpellStart()
	local caster = self:GetCaster()
	local casterpos = caster:GetAbsOrigin()
	local curpos = caster:GetCursorPosition()
	local dir=TG_Direction(curpos,casterpos)
	local distance =TG_Distance(casterpos,curpos)
	local flydis = self:GetSpecialValueFor("flydis")
	distance=distance>flydis and flydis or distance
	local duration = distance / self:GetSpecialValueFor("sp")
	local wh = self:GetSpecialValueFor("wh")
	local dis = self:GetSpecialValueFor("dis")
	caster:SetForwardVector(dir)
	caster:AddNewModifier(caster, self, "modifier_dual_breath_motion", {duration = duration, direction = dir})
	EmitSoundOn( "Hero_Jakiro.DualBreath.Cast", caster )
	local Projectile =
	{
		Ability = self,
		EffectName = "particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_dual_breath_fire.vpcf",
		vSpawnOrigin =casterpos,
		fDistance = dis,
		fStartRadius = wh,
		fEndRadius = wh,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		vVelocity = dir * 2000,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(Projectile)

	local Projectile2 =
	{
		Ability = self,
		EffectName = "particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_dual_breath_ice.vpcf",
		vSpawnOrigin =casterpos,
		fDistance = dis,
		fStartRadius = wh,
		fEndRadius = wh,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		vVelocity = dir * 2000,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(Projectile2)
end


function dual_breath:OnProjectileHit_ExtraData(target, location, kv)
	if not target then
		return
	end
	local disarmeddur=self:GetSpecialValueFor("disarmeddur")
	local dam=self:GetSpecialValueFor("dam")
	if not target:IsMagicImmune() then
		target:AddNewModifier_RS( self:GetCaster(), self, "modifier_dual_breath_debuff", {duration=disarmeddur})
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

modifier_dual_breath_motion = modifier_dual_breath_motion or class({})

function modifier_dual_breath_motion:IsDebuff()
	return false
end

function modifier_dual_breath_motion:IsHidden()
	return true
end

function modifier_dual_breath_motion:IsPurgable()
	return false
end

function modifier_dual_breath_motion:IsPurgeException()
	return false
end

function modifier_dual_breath_motion:RemoveOnDeath()
	return false
end

function modifier_dual_breath_motion:OnCreated(tg)
	self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
	self.speed= self.ability:GetSpecialValueFor("sp")
	if IsServer() then
		self.direction = ToVector(tg.direction)
		if not self:ApplyHorizontalMotionController()then
			self:Destroy()
		end
	end
end

function modifier_dual_breath_motion:UpdateHorizontalMotion( t, g )
		GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(),300,false)
    	self.parent:SetAbsOrigin(self.parent:GetAbsOrigin() + self.direction * (self.speed / (1/g)))
end

function modifier_dual_breath_motion:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end

function modifier_dual_breath_motion:OnDestroy()
	if IsServer() then
		self.parent:RemoveHorizontalMotionController(self)
	end
end


function modifier_dual_breath_motion:CheckState()
	return
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_dual_breath_motion:GetMotionPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end

function modifier_dual_breath_motion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end


function modifier_dual_breath_motion:GetActivityTranslationModifiers()
   return 	"ti7"
end

function modifier_dual_breath_motion:GetOverrideAnimation()
	return ACT_DOTA_SPAWN
end

modifier_dual_breath_debuff=modifier_dual_breath_debuff or class({})

function modifier_dual_breath_debuff:IsDebuff()
    return true
end
function modifier_dual_breath_debuff:IsPurgable()
    return true
end
function modifier_dual_breath_debuff:IsPurgeException()
    return true
end
function modifier_dual_breath_debuff:IsHidden()
    return false
end

function modifier_dual_breath_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_disarm.vpcf"
end

function modifier_dual_breath_debuff:GetEffectAttachType()
   return PATTACH_OVERHEAD_FOLLOW
end

function modifier_dual_breath_debuff:CheckState()
    return
     {
            [MODIFIER_STATE_DISARMED] = true,
    }
end
