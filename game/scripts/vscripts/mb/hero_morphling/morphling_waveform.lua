-- Author: MysticBug 03/01/2021
---------------------------------------------------------------------
----------------------- Morphling Waveform --------------------------
---------------------------------------------------------------------
CreateTalents("npc_dota_hero_morphling", "mb/hero_morphling/morphling_waveform")
imba_morphling_waveform = class({})
LinkLuaModifier("modifier_imba_morphling_waveform_motion", "mb/hero_morphling/morphling_waveform", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_morphling_waveform_burst", "mb/hero_morphling/morphling_waveform", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_morphling_waveform_debuff", "mb/hero_morphling/morphling_waveform", LUA_MODIFIER_MOTION_NONE)

function imba_morphling_waveform:IsHiddenWhenStolen() 		return false end
function imba_morphling_waveform:IsRefreshable() 			return true end
function imba_morphling_waveform:IsStealable() 			return true end
function imba_morphling_waveform:IsNetherWardStealable()	return true end
------------------------------------------------------------------------------------------------------------------------------------------
function imba_morphling_waveform:GetAbilityTextureName() return "morphling/crown_of_tears/morphling_waveform" end
------------------------------------------------------------------------------------------------------------------------------------------
function imba_morphling_waveform:GetCastRange(location , target)
	if IsClient() then
		if self:GetCaster():HasModifier("modifier_imba_morphling_waveform_burst") then
			return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():GetCastRangeBonus() + self:GetSpecialValueFor("secondcastrange") 
		else
			return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():GetCastRangeBonus()	
		end
	end
end
--充能的技能的一些小BUG
function imba_morphling_waveform:OnOwnerSpawned()
	if IsServer() then 
		self:SetActivated(true)
	end
end

function imba_morphling_waveform:OnSpellStart()
	local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = self:GetCursorPosition()
	local direction = (target_pos - caster_pos):Normalized()
	direction.z = 0.0
	local range = self.BaseClass.GetCastRange(self,caster_pos,caster) + self:GetCaster():GetCastRangeBonus()
	if self:GetCaster():HasModifier("modifier_imba_morphling_waveform_burst") then
		range = range + self:GetSpecialValueFor("secondcastrange")
	end
	local speed = self:GetSpecialValueFor("speed")
	local burst_duration = self:GetSpecialValueFor("effect_duration")
	local pos = ((target_pos - caster_pos):Length2D() <= range) and target_pos or (caster_pos + direction * range)
	local duration = (caster_pos - pos):Length2D() / speed
	caster:AddNewModifier(caster, self, "modifier_imba_morphling_waveform_motion", {duration = duration, distacne = (caster_pos - pos):Length2D()})
	caster:EmitSound("Hero_Morphling.Waveform")
	ProjectileManager:ProjectileDodge(caster)
	self:SetActivated(false)
end

--Motion
modifier_imba_morphling_waveform_motion = class({})

function modifier_imba_morphling_waveform_motion:IsDebuff() return false end
function modifier_imba_morphling_waveform_motion:IsHidden() return true end
function modifier_imba_morphling_waveform_motion:IsPurgable() return false end
function modifier_imba_morphling_waveform_motion:IsStunDebuff() return false end
--状态无敌 NO允许施法
function modifier_imba_morphling_waveform_motion:CheckState() return {[MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_MAGIC_IMMUNE] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true ,[MODIFIER_STATE_INVULNERABLE] = true ,[MODIFIER_STATE_NO_HEALTH_BAR] = true} end
function modifier_imba_morphling_waveform_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_DISABLE_TURNING,MODIFIER_PROPERTY_IGNORE_CAST_ANGLE} end
function modifier_imba_morphling_waveform_motion:GetModifierDisableTurning() return 1 end
function modifier_imba_morphling_waveform_motion:GetOverrideAnimation() return ACT_DOTA_CAST_ABILITY_1 end
function modifier_imba_morphling_waveform_motion:GetModifierIgnoreCastAngle() return 1 end
function modifier_imba_morphling_waveform_motion:IsMotionController() return true end
function modifier_imba_morphling_waveform_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function modifier_imba_morphling_waveform_motion:OnCreated(keys)
	if not IsServer() then return end
	--kv
	self.hitted = {}
	self.angle = self:GetParent():GetForwardVector()
	self.width = self:GetAbility():GetSpecialValueFor("width")
	self.effect_duration = self:GetAbility():GetSpecialValueFor("effect_duration")
	self.distance = keys.distacne
	self.damageTable = {
			attacker = self:GetParent(),
			damage = self:GetAbility():GetAbilityDamage(),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self:GetAbility(), --Optional.
		}
	--speed
	self.force_pos = GetGroundPosition(( self:GetParent():GetAbsOrigin() + self.angle * self.distance ), nil)
	self.speed = self.distance / self:GetDuration()
	--add burst 
	if self:GetParent():HasModifier("modifier_imba_morphling_waveform_burst") then 
		self.width = self:GetAbility():GetSpecialValueFor("width") + self:GetAbility():GetSpecialValueFor("secondcastwidth")
	end
	--start Horizontal motion controller
	if self:ApplyHorizontalMotionController() == false then
		self:Destroy()
	else
		------------------------------------------------------------------------------------------------------------------------------------------
		--特效
		local pfx_name = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf"
		--if HeroItems:UnitHasItem(self:GetCaster(), "crown_of_tears") then
			pfx_name = "particles/econ/items/morphling/morphling_crown_of_tears/morphling_crown_waveform.vpcf"
		--end

		self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
		local pfx_pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetUpVector() * 50
		ParticleManager:SetParticleControl(self.pfx, 0, pfx_pos)
		ParticleManager:SetParticleControl(self.pfx, 1, self.angle * self.speed)
		self:AddParticle(self.pfx, false, false, 15, false, false)
		------------------------------------------------------------------------------------------------------------------------------------------
	end
end

function modifier_imba_morphling_waveform_motion:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	--over motion
	self:GetParent():RemoveHorizontalMotionController( self )
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
	--加速时间
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_morphling_waveform_burst", {duration = self.effect_duration})
	--remove kv
	self.hitted = nil
	self.pfx = nil 
	self.angle = nil 
	self.width = nil
	self.effect_duration = nil 
	self.distance = nil 
	self.damageTable = nil
	self.force_pos = nil 
	self.speed = nil
	self:GetAbility():SetActivated(true)
end

function modifier_imba_morphling_waveform_motion:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end
	local distance = (self.force_pos - me:GetAbsOrigin()):Normalized()
	me:SetOrigin( me:GetAbsOrigin() + distance * self.speed * dt )
	--damage
	local enemies = FindUnitsInLine(
		self:GetParent():GetTeamNumber(), 
		self:GetParent():GetAbsOrigin(), 
		self.force_pos, 
		nil,
		self.width, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
	)
	for _, enemy in pairs(enemies) do
		if not IsInTable(enemy, self.hitted) then
			if not enemy:IsMagicImmune() then 
				--造成减速
				enemy:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_imba_morphling_waveform_debuff", {duration = self.effect_duration})
				--造成伤害
				self.damageTable.victim = enemy
				------------------------------------------------------------------------------------------------------------------------------------------
				self.damageTable.damage = self:GetAbility():GetAbilityDamage() + self:GetCaster():TG_GetTalentValue("special_bonus_imba_morphling_1")
				------------------------------------------------------------------------------------------------------------------------------------------
				--波浪对受变体打击影响的目标造成伤害提升50%
				if enemy:HasModifier("modifier_imba_morphling_adaptive_strike_debuff") then 
					self.damageTable.damage = self:GetAbility():GetAbilityDamage() * 1.5
				end
				ApplyDamage(self.damageTable)
				--------------------------------------------------------------------------------------------------
				table.insert(self.hitted,enemy)
				--------------------------------------------------------------------------------------------------
			end
			--天赋2 波浪形态攻击敌人 
			if self:GetCaster():TG_HasTalent("special_bonus_imba_morphling_3") then
				if not enemy:IsInvulnerable() and not enemy:IsOutOfGame() and self:GetCaster():IsAlive() then
					self:GetCaster():PerformAttack(enemy, false, true, true, false, true, false, false)
					----------------------------------------------------------------------------------------------
					table.insert(self.hitted,enemy)
					----------------------------------------------------------------------------------------------
				end
			end
		end
	end
	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self.width, false)
end

function modifier_imba_morphling_waveform_motion:OnHorizontalMotionInterrupted()
	self:Destroy()
end

--加速计时器
modifier_imba_morphling_waveform_burst = class({})

function modifier_imba_morphling_waveform_burst:IsDebuff()			return false end
function modifier_imba_morphling_waveform_burst:IsHidden() 		return true end
function modifier_imba_morphling_waveform_burst:IsPurgable() 		return false end
function modifier_imba_morphling_waveform_burst:IsPurgeException() return false end

--DEBUFF 减移速
modifier_imba_morphling_waveform_debuff = class({})

function modifier_imba_morphling_waveform_debuff:IsDebuff()			return true end
function modifier_imba_morphling_waveform_debuff:IsHidden() 		return false end
function modifier_imba_morphling_waveform_debuff:IsPurgable() 		return true end
function modifier_imba_morphling_waveform_debuff:IsPurgeException() return true end
function modifier_imba_morphling_waveform_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_morphling_waveform_debuff:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("slow_pct")) end
function modifier_imba_morphling_waveform_debuff:GetEffectName() return "particles/units/heroes/hero_magnataur/magnataur_skewer_debuff.vpcf" end
function modifier_imba_morphling_waveform_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end