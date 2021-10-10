item_sky_lance = class({})

LinkLuaModifier("modifier_item_sky_lance_force_ally", "ting/items/item_sky_lance", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_item_sky_lance_range", "ting/items/item_sky_lance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_sky_lance_fow_position", "ting/items/item_sky_lance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_sky_lance_nerf", "ting/items/item_sky_lance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_sky_lance_asp", "ting/items/item_sky_lance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_sky_lance_passive", "ting/items/item_sky_lance", LUA_MODIFIER_MOTION_NONE)


function item_sky_lance:GetIntrinsicModifierName()
	return "modifier_item_sky_lance_passive"
end

function item_sky_lance:CastFilterResultTarget(target)
	if self:GetCaster() == target or target:HasModifier("modifier_imba_gyrocopter_homing_missile") then
		return UF_SUCCESS
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_CUSTOM, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, self:GetCaster():GetTeamNumber())
	end
end

function item_sky_lance:GetCastRange(location, target)
	if not target or target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		return self:GetSpecialValueFor("cast_range_enemy")
	end
end

function item_sky_lance:OnSpellStart()
	if not IsServer() then return end
	
	local ability = self
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	local duration = ability:GetSpecialValueFor("duration")

	if caster:GetTeamNumber() == target:GetTeamNumber() then
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
		target:AddNewModifier(caster, ability, "modifier_item_sky_lance_force_ally", {duration = duration,tar = 1})
		if target == caster then
		local buff2 = caster:AddNewModifier(caster, ability, "modifier_item_sky_lance_asp", {duration = ability:GetSpecialValueFor("range_duration")})
		buff2.target = target
		buff2:SetStackCount(0)
		end
	else
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
		target:AddNewModifier(caster, ability, "modifier_item_sky_lance_force_ally", {duration = duration,tar = 2})
		caster:AddNewModifier(target, ability, "modifier_item_sky_lance_force_ally", {duration = duration,tar = 2})
		target:AddNewModifier(caster, ability, "modifier_item_sky_lance_fow_position", {duration = ability:GetSpecialValueFor("range_duration")})
		
		local buff = caster:AddNewModifier(caster, ability, "modifier_item_sky_lance_range", {duration = ability:GetSpecialValueFor("range_duration")})
		buff.target = target
		buff:SetStackCount(ability:GetSpecialValueFor("max_attacks"))
		local buff3 = caster:AddNewModifier(caster, ability, "modifier_item_sky_lance_asp", {duration = ability:GetSpecialValueFor("range_duration")})
		buff3.target = target
		buff3:SetStackCount(ability:GetSpecialValueFor("max_attacks"))
		
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", self:GetCaster())
	end
end

modifier_item_sky_lance_passive = class({})
LinkLuaModifier("modifier_item_sky_lance_nerf", "ting/items/item_sky_lance", LUA_MODIFIER_MOTION_NONE)
function modifier_item_sky_lance_passive:IsDebuff()			return false end
function modifier_item_sky_lance_passive:IsHidden() 			return true end
function modifier_item_sky_lance_passive:IsPurgable() 		return false end
function modifier_item_sky_lance_passive:IsPurgeException() 	return false end
function modifier_item_sky_lance_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,MODIFIER_PROPERTY_STATS_AGILITY_BONUS,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_HEALTH_BONUS}end
function modifier_item_sky_lance_passive:GetModifierBonusStats_Intellect() return self.int end
function modifier_item_sky_lance_passive:GetModifierBonusStats_Agility() return self.agi end
function modifier_item_sky_lance_passive:GetModifierBonusStats_Strength() return self.str end
function modifier_item_sky_lance_passive:GetModifierMagicalResistanceBonus() return self.mg end
function modifier_item_sky_lance_passive:GetModifierPreAttack_BonusDamage() return self.att end
function modifier_item_sky_lance_passive:GetModifierHealthBonus() return self.hp end
function modifier_item_sky_lance_passive:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() and not self:GetParent():HasModifier("modifier_item_hurricane_pike") and not self:GetParent():HasModifier("modifier_item_dragon_lance")then
		return self.ran
	end
end

function modifier_item_sky_lance_passive:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.int = self:GetAbility():GetSpecialValueFor("int")
	self.hp = self:GetAbility():GetSpecialValueFor("hp")
	self.str = self:GetAbility():GetSpecialValueFor("str")
	self.agi = self:GetAbility():GetSpecialValueFor("agi")
	self.ran = self:GetAbility():GetSpecialValueFor("ran")
	self.mg = self:GetAbility():GetSpecialValueFor("mg")
	self.att = self:GetAbility():GetSpecialValueFor("att")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.dur = self:GetAbility():GetSpecialValueFor("dur_nerf")
	self.dur_sil = self:GetAbility():GetSpecialValueFor("sil_dur")
end

function modifier_item_sky_lance_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent()  and not keys.target:IsMagicImmune() then
		if PseudoRandom:RollPseudoRandom(self:GetAbility(), self.chance) then
			local mod = keys.target:FindModifierByName("modifier_silence")
			if mod ~= nil then
				mod:SetDuration(mod:GetRemainingTime()+self.dur_sil,true)
			else
				keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_silence", {duration = self.dur_sil})
			end		
			keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_sky_lance_nerf", {duration = self.dur})
		end	
	end
end

modifier_item_sky_lance_force_ally = class({})

function modifier_item_sky_lance_force_ally:IsDebuff() return false end
function modifier_item_sky_lance_force_ally:IsHidden() return true end
function modifier_item_sky_lance_force_ally:IsPurgable() return false end
function modifier_item_sky_lance_force_ally:GetMotionPriority() 	
	return DOTA_MOTION_CONTROLLER_PRIORITY_LOW
end
function modifier_item_sky_lance_force_ally:OnCreated(params)
	if not IsServer() then return end
	--对时间结界，决斗或黑洞内的单位无效。
	if self:GetParent():HasModifier("modifier_imba_legion_commander_duel") or self:GetParent():HasModifier("modifier_black_hole_debuff2") or self:GetParent():HasModifier("modifier_imba_faceless_void_chronosphere_debuff") or self:GetParent():HasModifier("modifier_seer_vacuum_m") then
		self:Destroy()
		return
	end
	--特效
	local pfx_name = "particles/econ/events/ti9/force_staff_ti9.vpcf"
	
	self.pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
		--	self.distance = self:GetAbility():GetSpecialValueFor("push_length")
	--kv
	if params.tar == 1 then 
		self.angle = self:GetParent():GetForwardVector()
		self.distance = self:GetAbility():GetSpecialValueFor("push_length")
	else
		self.angle = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
		self.distance = self:GetAbility():GetSpecialValueFor("enemy_length")
	end
	--speed
	self.force_pos = GetGroundPosition(( self:GetParent():GetAbsOrigin() + self.angle * self.distance ), nil)
	self.speed = self.distance / self:GetDuration()

	if self:ApplyHorizontalMotionController() == false then
		self:Destroy()
	end
	
end

function modifier_item_sky_lance_force_ally:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	--over motion
	self:GetParent():RemoveHorizontalMotionController( self )
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
	--remove kv
	self.pfx = nil 
	self.angle = nil 
	self.distance = nil 
	self.force_pos = nil 
	self.speed = nil
end

function modifier_item_sky_lance_force_ally:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end
	local distance = (self.force_pos - me:GetAbsOrigin()):Normalized()
	local next_pos = me:GetAbsOrigin() + distance * self.speed * dt
	me:SetOrigin( next_pos )
	GridNav:DestroyTreesAroundPoint(next_pos, 80, false)
end

function modifier_item_sky_lance_force_ally:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_item_sky_lance_force_ally:CheckState()
	if Is_Chinese_TG(self:GetParent(),self:GetCaster()) then
		local state =
		{
			[MODIFIER_STATE_INVULNERABLE] = true,
		}
	return state
	end
	return
end

--无视距离数次攻击目标
modifier_item_sky_lance_range = class({})
function modifier_item_sky_lance_range:IsDebuff() return false end
function modifier_item_sky_lance_range:IsHidden() return false end
function modifier_item_sky_lance_range:IsPurgable() return false end
function modifier_item_sky_lance_range:IsStunDebuff() return false end
function modifier_item_sky_lance_range:IgnoreTenacity() return true end
function modifier_item_sky_lance_range:GetTexture()			
    return "item_sky_lance"
end
function modifier_item_sky_lance_range:OnCreated()
	if not IsServer() then return end
	self.ar = 0
	self:StartIntervalThink(FrameTime())
end

function modifier_item_sky_lance_range:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():GetAttackTarget() == self.target then
		if self:GetParent():IsRangedAttacker() then
			self.ar = 999999
		end
	else
		self.ar = 0
	end
end

function modifier_item_sky_lance_range:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,}
	return decFuncs
end



function modifier_item_sky_lance_range:GetModifierAttackRangeBonus()
	if not IsServer() then return end
	return self.ar
end

function modifier_item_sky_lance_range:OnAttack( keys )
	if not IsServer() then return end
	if keys.target == self.target and keys.attacker == self:GetParent() then
		if self:GetStackCount() > 1 then
			self:DecrementStackCount()
		else
			self:Destroy()
		end
	end
end

function modifier_item_sky_lance_range:OnOrder( keys )
	if not IsServer() then return end
	
	if keys.target == self.target and keys.unit == self:GetParent() and keys.order_type == 4 then
		if self:GetParent():IsRangedAttacker() then
			self.ar = 999999
		end		
	end
end
--获得敌人视野
modifier_item_sky_lance_fow_position = class({})
function modifier_item_sky_lance_fow_position:IsDebuff()			return true end
function modifier_item_sky_lance_fow_position:IsHidden() 			return true end
function modifier_item_sky_lance_fow_position:IsPurgable() 			return false end
function modifier_item_sky_lance_fow_position:IsPurgeException() 	return true end
function modifier_item_sky_lance_fow_position:CheckState() 			return {[MODIFIER_STATE_PROVIDES_VISION] = true} end
function modifier_item_sky_lance_fow_position:DeclareFunctions() return {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION} end
function modifier_item_sky_lance_fow_position:GetModifierProvidesFOWVision() return 1 end

modifier_item_sky_lance_nerf = class({})
function modifier_item_sky_lance_nerf:IsDebuff()			return true end
function modifier_item_sky_lance_nerf:IsHidden() 			return false end
function modifier_item_sky_lance_nerf:IsPurgable() 			return false end
function modifier_item_sky_lance_nerf:IsPurgeException() 	return true end
function modifier_item_sky_lance_nerf:DeclareFunctions() return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE} end
function modifier_item_sky_lance_nerf:GetEffectName() return "particles/items3_fx/mage_slayer_debuff.vpcf" end
function modifier_item_sky_lance_nerf:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_item_sky_lance_nerf:GetModifierTotalDamageOutgoing_Percentage() return self.nerf end
function modifier_item_sky_lance_nerf:GetTexture()			
    return "item_sky_lance"
end
function modifier_item_sky_lance_nerf:OnCreated()
	self.nerf = -1*self:GetAbility():GetSpecialValueFor("nerf")
end

modifier_item_sky_lance_asp = class({})
function modifier_item_sky_lance_asp:IsDebuff()			return false end
function modifier_item_sky_lance_asp:IsHidden() 			return false end
function modifier_item_sky_lance_asp:IsPurgable() 			return false end
function modifier_item_sky_lance_asp:IsPurgeException() 	return false end
function modifier_item_sky_lance_asp:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_item_sky_lance_asp:GetEffectName() 
    return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf" 
end
function modifier_item_sky_lance_asp:GetTexture()			
    return "item_sky_lance"
end
function modifier_item_sky_lance_asp:OnCreated()
	self.as = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.dur = self:GetAbility():GetSpecialValueFor("sil_dur")
end
function modifier_item_sky_lance_asp:GetModifierAttackSpeedBonus_Constant()
	return self.as
end
function modifier_item_sky_lance_asp:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and keys.target == self.target and not self.target:IsMagicImmune() and self:GetStackCount() ~= 0 then
		local mod = keys.target:FindModifierByName("modifier_silence")
		if mod ~= nil then
			mod:SetDuration(mod:GetRemainingTime()+self.dur,true)
		else
		keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_silence", {duration = self.dur})
		end		
		if self:GetStackCount() > 0 then 
			self:DecrementStackCount()
		else
			self:SetStackCount(0) 
		end
	end	
end

		