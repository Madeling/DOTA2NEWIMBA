
focusfire=focusfire or class({})
LinkLuaModifier("modifier_focusfire_att", "heros/hero_windrunner/focusfire.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_focusfire_attsp", "heros/hero_windrunner/focusfire.lua", LUA_MODIFIER_MOTION_NONE)

function focusfire:IsHiddenWhenStolen()
    return false
end

function focusfire:IsStealable()
    return true
end


function focusfire:GetIntrinsicModifierName()
    return "modifier_focusfire_att"
end

function focusfire:GetCooldown(iLevel)
	if self:GetCaster():HasScepter() then
		return 0
	else
		return self.BaseClass.GetCooldown(self,iLevel)
	end

end

function focusfire:OnProjectileHit_ExtraData(target, location, kv)
	if target then
		local damageTable = {
						victim = target,
						attacker = self:GetCaster(),
						damage =  self:GetSpecialValueFor( "dam" )+self:GetCaster():TG_GetTalentValue("special_bonus_windrunner_5"),
						damage_type =DAMAGE_TYPE_MAGICAL,
						ability = self,
						}
						ApplyDamage(damageTable)
	end
end

modifier_focusfire_att = modifier_focusfire_att or class({})
function modifier_focusfire_att:IsPassive()
	return true
end

function modifier_focusfire_att:IsPurgable()
    return false
end

function modifier_focusfire_att:IsPurgeException()
    return false
end

function modifier_focusfire_att:IsHidden()
    return true
end

function modifier_focusfire_att:OnCreated()
	if IsServer() then
		self.wh=self:GetAbility():GetSpecialValueFor( "wh" )
		self.ch=self:GetAbility():GetSpecialValueFor( "ch" )
		self.num=self:GetAbility():GetSpecialValueFor( "num" )
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_focusfire_attsp", {})
	end
end


function modifier_focusfire_att:OnRefresh()
		self:OnCreated()
end


function modifier_focusfire_att:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK,}
end

function modifier_focusfire_att:OnAttack(tg)
	if not IsServer() or not self:GetAbility():IsCooldownReady() or self:GetParent():IsIllusion() or tg.target==tg.attacker then
		return
	end
	if tg.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() and  RollPseudoRandomPercentage(self.ch,0,self:GetParent()) then
			tg.attacker:EmitSound("Ability.Powershot")
			local pos=tg.attacker:GetAbsOrigin()
			local tpos=tg.target:GetAbsOrigin()
			local dirt=pos==tpos and tg.attacker:GetForwardVector()  or TG_Direction(tpos,pos)
			for i=1,self.num do
				local dir=TG_Direction(RotatePosition(pos, QAngle(0, math.random(-5,5), 0), pos + dirt * 1000),tpos)
				local projectileTable2 =
				{
				EffectName ="particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
				Ability = self:GetAbility(),
				vSpawnOrigin =pos,
				vVelocity =dir*5000,
				fDistance =2000,
				fStartRadius = self.wh,
				fEndRadius = self.wh,
				Source = tg.attacker,
				bIgnoreSource=true,
				bHasFrontalCone = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				}
				Projectile=ProjectileManager:CreateLinearProjectile( projectileTable2 )
			end
			self:GetAbility():UseResources(false, false, true)
	end
end



modifier_focusfire_attsp=modifier_focusfire_attsp or class({})


function modifier_focusfire_attsp:IsHidden()
	return true
end

function modifier_focusfire_attsp:IsPurgable()
	return false
end

function modifier_focusfire_attsp:IsPurgeException()
	return false
end
function modifier_focusfire_attsp:DeclareFunctions()
	return
	{MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
   end

   function modifier_focusfire_attsp:GetModifierAttackSpeedBonus_Constant()
	if not self:GetParent():PassivesDisabled() then
		if self:GetCaster():HasScepter() then
			return self:GetAbility():GetSpecialValueFor( "attsp" )+self:GetCaster():TG_GetTalentValue("special_bonus_windrunner_6")+75
		else
			return self:GetAbility():GetSpecialValueFor( "attsp" )+self:GetCaster():TG_GetTalentValue("special_bonus_windrunner_6")
		end
   	end
end