CreateTalents("npc_dota_hero_doom_bringer", "ting/hero_doom")
imba_doom_bringer_doom = class({})

LinkLuaModifier("modifier_imba_doom_enemy", "ting/hero_doom", LUA_MODIFIER_MOTION_NONE)

function imba_doom_bringer_doom:IsHiddenWhenStolen() 		return false end
function imba_doom_bringer_doom:IsRefreshable() 			return true end
function imba_doom_bringer_doom:IsStealable() 				return true end
--function imba_doom_bringer_doom:GetAbilityTargetTeam()		return self:GetCaster():TG_HasTalent("special_bonus_imba_doom_4") and DOTA_UNIT_TARGET_TEAM_BOTH or DOTA_UNIT_TARGET_TEAM_ENEMY end
function imba_doom_bringer_doom:GetCastRange() return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end


function imba_doom_bringer_doom:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	target:TriggerSpellReflect(self)--莲花 触发莲花
	if target:TriggerSpellAbsorb(self) then return end --触发林肯 直接写就是无视林肯	
	target:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_doom_enemy", {duration =self:GetSpecialValueFor("duration_long")})
end

modifier_imba_doom_enemy = class({})

function modifier_imba_doom_enemy:IsDebuff()			return true end
function modifier_imba_doom_enemy:IsHidden() 			return false end
function modifier_imba_doom_enemy:IsPurgable() 			return false end
function modifier_imba_doom_enemy:IsPurgeException() 	return false end
function modifier_imba_doom_enemy:CheckState() return {[MODIFIER_STATE_MUTED] = true, [MODIFIER_STATE_SILENCED] = true, [MODIFIER_STATE_PASSIVES_DISABLED] = self:GetCaster():HasScepter()} end
function modifier_imba_doom_enemy:GetEffectName() return "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf" end
function modifier_imba_doom_enemy:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_doom_enemy:GetStatusEffectName() return "particles/status_fx/status_effect_doom.vpcf" end
function modifier_imba_doom_enemy:StatusEffectPriority() return 15 end

function modifier_imba_doom_enemy:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.damage = self.ability:GetSpecialValueFor("damage") 
	if IsServer() then	
		self.damagetable = {victim = self.parent, 
			attacker = self.caster, 
			ability = self.ability, 
			damage_type = DAMAGE_TYPE_PURE,
			damage = self.damage}
		self.intv = 1 - self.parent:GetStatusResistance()
		self:GetParent():EmitSound("Hero_DoomBringer.Doom")
		self:StartIntervalThink(self.intv)
	end
end
function modifier_imba_doom_enemy:OnIntervalThink()
		ApplyDamage(self.damagetable) 
end

function modifier_imba_doom_enemy:OnDestroy()
	self.damage = nil
	if IsServer() then
		self:GetParent():StopSound("Hero_DoomBringer.Doom")
	end
end


					----阎刃----开了自动施法 主动会施加阎刃debuff 平a会施加阎刃 
imba_doom_bringer_infernal_blade = class({}) 
LinkLuaModifier("modifier_imba_doom_enemy", "ting/hero_doom", LUA_MODIFIER_MOTION_NONE)  	--
LinkLuaModifier("modifier_imba_doom_bringer_infernal_blade", "ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_doom_bringer_infernal_blade_debuff", "ting/hero_doom", LUA_MODIFIER_MOTION_NONE)


function imba_doom_bringer_infernal_blade:IsHiddenWhenStolen() 		return false end
function imba_doom_bringer_infernal_blade:IsRefreshable() 			return true end
function imba_doom_bringer_infernal_blade:IsStealable() 				return true end
function imba_doom_bringer_infernal_blade:GetIntrinsicModifierName() return "modifier_imba_doom_bringer_infernal_blade" end
function imba_doom_bringer_infernal_blade:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	local Talent = caster:TG_GetTalentValue("special_bonus_imba_doom_4")
	local  Getcd = cooldown - Talent
	if caster:TG_HasTalent("special_bonus_imba_doom_4") then 
		return (Getcd)
	end
	return cooldown
end
function imba_doom_bringer_infernal_blade:CastFilterResultTarget(hTarget)

	if IsServer() then
		
		if  hTarget:IsCourier() then
		return UF_FAIL_CUSTOM
		end 
		if self:GetCaster()==hTarget then 
			self:ToggleAutoCast()
		end
		local nResult = UnitFilter(			
			hTarget,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,
			self:GetCaster():GetTeamNumber()
		)
		--a杖二技能额外效果 能对魔免用
		if hTarget ~= self:GetCaster() and hTarget:IsMagicImmune() and  self:GetCaster():HasModifier("modifier_imba_doom_bringer_scorched_earth_passive_scepter") then return UF_SUCCESS end
		if hTarget ~= self:GetCaster() and hTarget:IsMagicImmune() and  hTarget:HasModifier("modifier_imba_doom_enemy") then return UF_SUCCESS end
		if nResult ~= UF_SUCCESS then 
			return nResult	
		end
		return UF_SUCCESS 
	end
end
function imba_doom_bringer_infernal_blade:OnUpgrade()
	if IsServer() then
	local mod = self:GetCaster():FindModifierByName("modifier_imba_doom_bringer_infernal_blade")
	if mod then
		mod.duration_sc = self:GetSpecialValueFor("Duration_SC")
		mod.burn_duration = self:GetSpecialValueFor("burn_duration")
		mod.stun_doom = self:GetSpecialValueFor("ministun_duration")
	end
	end
end
function imba_doom_bringer_infernal_blade:OnSpellStart()
	if  not IsServer() then  return end
	local caster = self:GetCaster() 
	local target = self:GetCursorTarget()
	
	self:GetCaster():EmitSound("Hero_DoomBringer.InfernalBlade.Target")
	target:TriggerSpellReflect(self)
	if target:TriggerSpellAbsorb(self) then return end 
	local min_per = self:GetSpecialValueFor("per")*0.01
	target:AddNewModifier_RS(caster,self,"modifier_imba_stunned",{duration=(self:GetSpecialValueFor("ministun_duration")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_doom_3","value"))*min_per})
	target:AddNewModifier_RS(caster, self, "modifier_imba_doom_bringer_infernal_blade_debuff", {duration = min_per*self:GetSpecialValueFor("burn_duration")})
		local pfx4 = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_lvl_death_bonus.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx4, 0, target:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(pfx4)
	if target:HasModifier("modifier_imba_doom_enemy") then 
	self:AddDoom(target:FindModifierByName("modifier_imba_doom_enemy"):GetRemainingTime(),target)
	end

end
function imba_doom_bringer_infernal_blade:AddDoom(duration,target)
local enemy_hero = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
	target:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), 
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_ANY_ORDER, false)	
		for _,enemy in pairs(enemy_hero) do	
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_doom_enemy", {duration = duration})	
		end

end

modifier_imba_doom_bringer_infernal_blade = class({})
function modifier_imba_doom_bringer_infernal_blade:IsDebuff()			return false end
function modifier_imba_doom_bringer_infernal_blade:IsHidden() 
	if self:GetStackCount() > 0 then
		return false
	end
	return true
end		
function modifier_imba_doom_bringer_infernal_blade:IsPurgable() 		return false end
function modifier_imba_doom_bringer_infernal_blade:IsPurgeException() 	return false end
function modifier_imba_doom_bringer_infernal_blade:DeclareFunctions() --,MODIFIER_EVENT_ON_ATTACK,MODIFIER_EVENT_ON_ATTACK_RECORD,MODIFIER_EVENT_ON_ORDER
	return	{MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_EVENT_ON_DEATH} end
	


function modifier_imba_doom_bringer_infernal_blade:OnCreated()
	self.ab = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.time = 4
	self.duration_sc = self.ab:GetSpecialValueFor("Duration_SC")
	self.burn_duration = self.ab:GetSpecialValueFor("burn_duration")
	self.stun_doom = self.ab:GetSpecialValueFor("ministun_duration")
	if not IsServer() then return end
	self:SetStackCount(0)
	self:StartIntervalThink(self.time)
end

function modifier_imba_doom_bringer_infernal_blade:OnIntervalThink()
	if self.caster:TG_HasTalent("special_bonus_imba_doom_5") then 
	if self:GetStackCount()<self.caster:TG_GetTalentValue("special_bonus_imba_doom_5") then 
	self:IncrementStackCount()
	end
	end

end

function modifier_imba_doom_bringer_infernal_blade:OnAttackLanded(keys)
	if IsServer() then		
		if keys.target:GetTeamNumber() == keys.attacker:GetTeamNumber() or keys.target:IsOther() or not keys.target:IsAlive() then return  end
		if keys.attacker == self.parent and not
		self.parent:IsSilenced() and not
		self.parent:IsIllusion() and not keys.target:IsBuilding() and self.parent:HasModifier("modifier_imba_doom_bringer_scorched_earth_passive_scepter") then 
		keys.target:AddNewModifier(keys.attacker,self.ab,"modifier_imba_doom_bringer_infernal_blade_debuff", {duration =self.duration_sc})		
		end

		--现在会攻击带有大招末日标记的敌人 会无视魔免的给火刀
		if keys.attacker == self.parent and
		self.ab:GetAutoCastState() and not
		self.parent:IsSilenced() and not
		self.parent:IsIllusion() and not keys.target:IsBuilding() and not keys.target:IsOther() then		
				if self.ab:IsFullyCastable()or self:GetStackCount() > 0 then
				if keys.target:IsMagicImmune() and not (keys.target:HasModifier("modifier_imba_doom_enemy") or keys.attacker:HasModifier("modifier_imba_doom_bringer_scorched_earth_passive_scepter")) then
				return 
				end
				local pfx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
				self:AddParticle(pfx3, false, false, 15, false, false)
				keys.target:AddNewModifier_RS(keys.attacker, self.ab, "modifier_imba_doom_bringer_infernal_blade_debuff", {duration = self.burn_duration})
				keys.target:AddNewModifier_RS(self.caster,self.ab,"modifier_imba_stunned",{duration=self.stun_doom+self.parent:TG_GetTalentValue("special_bonus_imba_doom_3","value")})
				keys.target:AddNewModifier_RS(self.caster, self.ab, "modifier_imba_doom_enemy", {duration=self.stun_doom+self.parent:TG_GetTalentValue("special_bonus_imba_doom_3","value")})
				if self:GetStackCount() > 0 and not self.ab:IsFullyCastable() then
					self:DecrementStackCount() 
					else
				self.ab:UseResources(true, true, true) 
					end
				end
		end
				
	end
end

function modifier_imba_doom_bringer_infernal_blade:OnDeath(keys)
	if IsServer() and keys.unit == self.parent then 		
		self:Destroy()
	end
end





---火刀灼烧
modifier_imba_doom_bringer_infernal_blade_debuff= class({})
function modifier_imba_doom_bringer_infernal_blade_debuff:IsDebuff()			return true end
function modifier_imba_doom_bringer_infernal_blade_debuff:IsHidden() 			return false end
function modifier_imba_doom_bringer_infernal_blade_debuff:IsPurgable() 			return true end
function modifier_imba_doom_bringer_infernal_blade_debuff:CheckState() return {[MODIFIER_STATE_PASSIVES_DISABLED] = self:GetCaster():HasScepter()} end
function modifier_imba_doom_bringer_infernal_blade_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end --多个buff不会刷新 而是独立生效
function modifier_imba_doom_bringer_infernal_blade_debuff:GetEffectName() return "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf" end
function modifier_imba_doom_bringer_infernal_blade_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_doom_bringer_infernal_blade_debuff:OnCreated()
	self.ability = self:GetAbility()
	self.damage1 = self.ability :GetSpecialValueFor("burn_damage")/2
	self.damage2 = self.ability :GetSpecialValueFor("burn_damage_pct")/200
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	if IsServer() then 
	self.damagetable = ({victim = self.parent, 
			attacker = self.caster, 
			ability = self.ability , 
			damage_type = DAMAGE_TYPE_MAGICAL,})	
		local pfx4 = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx4, 0, self.parent:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(pfx4)
		self.caster:EmitSound("Hero_DoomBringer.InfernalBlade.Target")
		if self.parent:HasModifier("modifier_imba_doom_enemy") then
			self.ability:AddDoom(self.parent:FindModifierByName("modifier_imba_doom_enemy"):GetRemainingTime(),self.parent)
		end
		self:StartIntervalThink(0.5)
	 end	
end
function modifier_imba_doom_bringer_infernal_blade_debuff:OnIntervalThink()
	if IsServer() then
		self.damagetable.damage = self.damage1+self:GetParent():GetMaxHealth()*self.damage2
		ApplyDamage(self.damagetable)		
	end
end

--被动 266范围的焦土 附近人身上如果中了末日预言/火刀/DOOM的越多 焦土的范围会更大并且doom移动速度就越快 出a获得主动
imba_doom_bringer_scorched_earth = class({})
LinkLuaModifier("modifier_imba_doom_bringer_scorched_earth_passive", "ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_doom_bringer_scorched_earth_passive_up", "ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_doom_enemy", "ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_doom_bringer_scorched_earth_passive_scepter", "ting/hero_doom", LUA_MODIFIER_MOTION_NONE)

function imba_doom_bringer_scorched_earth:IsHiddenWhenStolen() 		return false end
function imba_doom_bringer_scorched_earth:IsRefreshable() 			return true end
function imba_doom_bringer_scorched_earth:IsStealable() 				return true end
function imba_doom_bringer_scorched_earth:GetBehavior() return self:GetCaster():HasScepter() and DOTA_ABILITY_BEHAVIOR_NO_TARGET or DOTA_ABILITY_BEHAVIOR_PASSIVE end
function imba_doom_bringer_scorched_earth:GetIntrinsicModifierName() return "modifier_imba_doom_bringer_scorched_earth_passive" end
function imba_doom_bringer_scorched_earth:OnUpgrade()
	if not IsServer() then return end
	local mod = self:GetCaster():FindModifierByName("modifier_imba_doom_bringer_scorched_earth_passive")
	if mod then
		mod.maxs = self:GetSpecialValueFor("max_stack")
		mod.damage = self:GetSpecialValueFor("damage")/2
		mod.duration_c = self:GetSpecialValueFor("duration_c")
		mod.radius = self:GetSpecialValueFor("radius")


	end
end
function imba_doom_bringer_scorched_earth:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetCaster()	
	caster:AddNewModifier(caster,self,"modifier_imba_doom_bringer_scorched_earth_passive_scepter", {duration = self:GetSpecialValueFor("duration_scepter")+0.1})
	
end

--被动焦土
modifier_imba_doom_bringer_scorched_earth_passive = class({})
LinkLuaModifier("modifier_imba_doom_bringer_scorched_earth_passive_up", "ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_doom_bringer_scorched_earth_passive:IsDebuff()			return false end
function modifier_imba_doom_bringer_scorched_earth_passive:IsHidden() 			return false end
function modifier_imba_doom_bringer_scorched_earth_passive:IsPurgable() 		return false end
function modifier_imba_doom_bringer_scorched_earth_passive:IsPurgeException() 	return false end
function modifier_imba_doom_bringer_scorched_earth_passive:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_doom_bringer_scorched_earth_passive:GetModifierMoveSpeedBonus_Percentage() return 
	self.ab:GetSpecialValueFor("bonus_movement_speed_pct")
end
function modifier_imba_doom_bringer_scorched_earth_passive:OnCreated() 
	self.ab = self:GetAbility()
	self.parent = self:GetParent()
	self.duration_c = self.ab:GetSpecialValueFor("duration_c")
	self.radius = self.ab:GetSpecialValueFor("radius")
	self.maxs = self.ab:GetSpecialValueFor("max_stack")
	self.damage = self.ab:GetSpecialValueFor("damage")/2
	if IsServer() then 
	self.damagetable = ({
			attacker = self.parent, 
			ability = self.ab, 
			damage_type = self.ab:GetAbilityDamageType(),})
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_scorched_earth_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	self.pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_scorched_earth.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(pfx, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.pfx2, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.pfx2, 1, Vector(self.radius, 0, 0))
	self:AddParticle(pfx, false, false, 15, false, false)
	self:AddParticle(self.pfx2, false, false, 15, false, false)	
	self:SetStackCount(0)
	self:StartIntervalThink(0.5)
	end
end
function modifier_imba_doom_bringer_scorched_earth_passive:OnDeath(keys)
	if IsServer() and keys.unit == self.parent then 		
		self:Destroy()
	end
end
function modifier_imba_doom_bringer_scorched_earth_passive:OnRefresh()
	if IsServer() then 
	ParticleManager:SetParticleControl(self.pfx2, 1, Vector(self.radius, 0, 0))
	self:AddParticle(self.pfx2, false, false, 15, false, false)	
	end
end


function modifier_imba_doom_bringer_scorched_earth_passive:OnIntervalThink()
	local stackcount = 0
    local enemy_hero = FindUnitsInRadius(self.parent:GetTeamNumber(),
	self.parent:GetAbsOrigin(), nil, 1600, 
	DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_ANY_ORDER, false)
	
	for _,enemy in pairs(enemy_hero) do	
	if enemy:HasModifier("modifier_imba_doom_bringer_infernal_blade_debuff") or enemy:HasModifier("modifier_imba_doom_bringer_scorched_earth_passive_scepter")  then
		stackcount=stackcount+1		
	end
	if enemy:HasModifier("modifier_imba_doom_enemy") then
		local modifier1 = enemy:FindModifierByName("modifier_imba_doom_enemy"):GetAbility():GetName()
		if modifier1 == "imba_doom_bringer_doom" then stackcount=stackcount+self.maxs end
	end
	
	if self.parent:HasModifier("modifier_imba_doom_bringer_scorched_earth_passive_scepter") then 
		stackcount=stackcount+self.maxs 
	end
	
	end
	if stackcount~=0  or self:GetStackCount() > 0 then  
		if self.radius ~= 666 then
			self.radius = 666
			self:GetCaster():EmitSound("Hero_DoomBringer.ScorchedEarthAura")			
		end
		else 
	self.radius = self.ab:GetSpecialValueFor("radius")
	end

	
	local enemy_creeps = FindUnitsInRadius(self.parent:GetTeamNumber(),
	self.parent:GetAbsOrigin(), nil,self.radius , 
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER, false)

	
	for _,enemy in pairs(enemy_creeps) do
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_scorched_earth_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		self:AddParticle(pfx, false, false, 15, false, false)
		self.damagetable.victim = enemy
		self.damagetable.damage = self.damage
		ApplyDamage(self.damagetable)
	end
	
	if stackcount > self.maxs then stackcount =self.maxs end
	if stackcount > self:GetStackCount()-1 and stackcount~= 0 and self.parent:IsAlive() then
	self:SetStackCount(stackcount)
	local modifier = self.parent:AddNewModifier(self.parent,self.ab,"modifier_imba_doom_bringer_scorched_earth_passive_up",{duration = self.duration_c})
	if modifier~=nil then
	modifier:SetStackCount(stackcount)
	end
	
	end
	self:OnRefresh()
end
----------焦土额外随动的加成修饰器--
modifier_imba_doom_bringer_scorched_earth_passive_up = class({})
function modifier_imba_doom_bringer_scorched_earth_passive_up:IsDebuff()			return false end
function modifier_imba_doom_bringer_scorched_earth_passive_up:IsHidden() 			return true end
function modifier_imba_doom_bringer_scorched_earth_passive_up:IsPurgable() 		return false end
function modifier_imba_doom_bringer_scorched_earth_passive_up:IsPurgeException() 	return false end
function modifier_imba_doom_bringer_scorched_earth_passive_up:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_EVENT_ON_DEATH} end
function modifier_imba_doom_bringer_scorched_earth_passive_up:GetModifierMoveSpeedBonus_Percentage() return 
	self:GetStackCount()*self.movespeed
end
function modifier_imba_doom_bringer_scorched_earth_passive_up:GetModifierAttackSpeedBonus_Constant() return 
	self:GetStackCount()*(self:GetAbility():GetSpecialValueFor("bonus_attackspeed")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_doom_1"))
end

function modifier_imba_doom_bringer_scorched_earth_passive_up:GetModifierPhysicalArmorBonus() return 
	self:GetStackCount()*self.movespeed
end
function modifier_imba_doom_bringer_scorched_earth_passive_up:OnCreated()
	self.ab = self:GetAbility()
	self.caster = self:GetCaster()
	self.attspeed = self.ab:GetSpecialValueFor("bonus_attackspeed")+self.caster:TG_GetTalentValue("special_bonus_imba_doom_1")
	self.movespeed = self.ab:GetSpecialValueFor("bonus_armor") 
end



function modifier_imba_doom_bringer_scorched_earth_passive_up:OnDestroy()
	if not IsServer() then return end
	local modifier = self.caster:FindModifierByName("modifier_imba_doom_bringer_scorched_earth_passive")
	if modifier then 
		modifier:SetStackCount(0)
	end
end




--标记用，是否是a杖技能
modifier_imba_doom_bringer_scorched_earth_passive_scepter= class({})
function modifier_imba_doom_bringer_scorched_earth_passive_scepter:IsDebuff()			return false end
function modifier_imba_doom_bringer_scorched_earth_passive_scepter:IsHidden() 			return false end
function modifier_imba_doom_bringer_scorched_earth_passive_scepter:IsPurgable() 		return false end
function modifier_imba_doom_bringer_scorched_earth_passive_scepter:IsPurgeException() 	return false end
--function modifier_imba_doom_bringer_scorched_earth_passive_scepter:RemoveOnDeath() 		return false end
function modifier_imba_doom_bringer_scorched_earth_passive_scepter:GetEffectName() return "particles/units/heroes/hero_doom_bringer/doom_bringer_doom_ring.vpcf" end
function modifier_imba_doom_bringer_scorched_earth_passive_scepter:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_doom_bringer_scorched_earth_passive_scepter:DeclareFunctions() return 
{MODIFIER_EVENT_ON_DEATH}end 

function modifier_imba_doom_bringer_scorched_earth_passive_scepter:OnCreated()
	if not IsServer() then return end
	self:GetParent():EmitSound("Hero_DoomBringer.Doom")
	if self:GetParent() == self:GetCaster() then 

	for i=1, 10 do
		local pfx1 = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_lava/courier_trail_lava_model.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(pfx1, false, false, 15, false, false)
		local pfx2 = ParticleManager:CreateParticle("particles/econ/courier/courier_roshan_lava/courier_roshan_lava_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(pfx2, 15, Vector(213,114,10))
		self:AddParticle(pfx2, false, false, 15, false, false)
		local pfx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff_smoke.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(pfx3, false, false, 15, false, false)
		end
	
	end
end

function modifier_imba_doom_bringer_scorched_earth_passive_scepter:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_DoomBringer.Doom")
	end
end

function modifier_imba_doom_bringer_scorched_earth_passive_scepter:OnDeath(keys)
	if IsServer() and keys.unit == self:GetParent() then
		self:Destroy()
	end
end




--吞噬 ---
imba_doom_bringer_devour = class({})
LinkLuaModifier("modifier_imba_doom_bringer_devour_delicious", "ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_doom_bringer_devour_ovredoom_kill_flag","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
---------野怪--------------
LinkLuaModifier("imba_doom_roshan_bash","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_doom_black_dragon_splash_attack","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_doom_centaur_khan_endurance_aura","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_doom_alpha_wolf_critical_strike","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_doom_satyr_hellcaller_unholy_aura","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_doom_centaur_khan_endurance_aura_speed","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_doom_satyr_hellcaller_unholy_aura_heal","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_doom_granite_golem_hp_aura","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_doom_granite_golem_hp_aura_health","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_doom_ghost_frost_attack","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_doom_ghost_frost_attack_slow","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
function imba_doom_bringer_devour:IsHiddenWhenStolen() 		return false end
function imba_doom_bringer_devour:IsRefreshable() 			return true end
function imba_doom_bringer_devour:IsStealable() 				return false end

function imba_doom_bringer_devour:GetCastRange() return self:GetCaster():TG_HasTalent("special_bonus_imba_doom_1") and 666 or 300 end
--function imba_doom_bringer_devour:GetIntrinsicModifierName() return "modifier_imba_doom_bringer_devour_delicious" end
--兽王4个 凤凰12 屠夫1(原版)23  船长124 水人123（1bug ） 可能bug  巨魔1234 4被动 bug
-- 可能bug 沙发12345 德鲁伊123(不能吃熊) 火枪 14 23可能bug 
--滚滚1 2？替换普通模式  土狗枷锁 变鸡替换普通 卡尔禁止 火女 原版炽魂 母鸡 陈1234 不能偷赎罪


function imba_doom_bringer_devour:CastFilterResultTarget( hTarget )
	if IsServer() then
		
		if hTarget:IsCourier() then 
		return UF_FAIL_CUSTOM
		end 
		if hTarget:IsBoss() and self:GetLevel()~=4 then return UF_FAIL_CUSTOM end
		if self:GetCaster()==hTarget then 
			self:ToggleAutoCast()
		end
		local nResult = UnitFilter(			--天赋之前可通过目标属性
			hTarget,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,
			self:GetCaster():GetTeamNumber()
		)
		if hTarget:IsAncient() and not self:GetCaster():TG_HasTalent("special_bonus_imba_doom_2") then	
			return UF_FAIL_CUSTOM 
		end

	
		if nResult ~= UF_SUCCESS then --？？如果目标属性没有被通过 就返回结果？指UF_SUCCESS？
			return nResult	
		end
		return UF_SUCCESS --通过了目标就返回成功 大概就是可以对他施法
	end
end

function imba_doom_bringer_devour:OnSpellStart()
--[[	tab_hero_name={"npc_dota_hero_beastmaster",
			  "npc_dota_hero_kunkka",
			  "npc_dota_hero_morphling", 
			  "npc_dota_hero_nevermore",
			  "npc_dota_hero_lone_druid",
			  "npc_dota_hero_pangolier",
			  "npc_dota_hero_shadow_shaman",
			  "npc_dota_hero_chen",}
	tab_hero_ability_name = {
	{"beastmaster_call_of_the_wild_boar","beastmaster_call_of_the_wild_hawk","beastmaster_inner_beast"},
	{"beastmaster_wild_axes","imba_kunkka_x_marks_the_spot","imba_kunkka_tidebringer"},
	{"morphling_waveform","imba_morphling_morphling","imba_morphling_adaptive_strike"},
	{"imba_nevermore_shadowraze1","imba_nevermore_shadowraze2","imba_nevermore_dark_lord"},
	{"imba_lone_druid_spirit_link","imba_lone_druid_savage_roar"},
	{"pangolier_swashbuckle","imba_pangolier_shield_crash","imba_pangolier_lucky_shot"},
	{"imba_pangolier_swashbuckle","imba_pangolier_shield_crash","shadow_shaman_shackles"},
	{"chen_penitence","tg_chen_holy","tg_chen_tof"}
	}
	]]--
	
	tab_hero_ability_name_change = {
	{"beastmaster_call_of_the_wild_boar","beastmaster_inner_beast"},--兽王2 技能换被动
	{"imba_kunkka_return","imba_kunkka_tidebringer"},	--船长3 技能
	{"imba_morphling_morph_ring","imba_morphling_waveform"},				--水人技能
	{"imba_morphling_morph_sheild","imba_morphling_morphling"},				
	{"imba_morphling_morph_conversion","imba_morphling_adaptive_strike"},	
	{"imba_nevermore_shadowraze3","imba_nevermore_dark_lord"}, --影魔c炮换被动
	{"imba_pangolier_swashbuckle","pangolier_swashbuckle"},	--滚滚戳
	{"tg_ss_shackles","shadow_shaman_shackles"},	--狗y控
	{"tg_chen_pen","chen_penitence"},				--陈一技能
	{"imba_lone_druid_spirit_bear_return","imba_lone_druid_spirit_bear_demolish"}, --熊灵回归
	{"imba_sniper_take_aim_near","imba_sniper_headshot"},	--火枪切枪
	{"imba_sniper_take_aim_far","sniper_headshot"},
	{"imba_brewmaster_primal_thunder_clap","imba_brewmaster_thunder_clap"},	--熊猫技能
	{"imba_brewmaster_primal_cinder_brew","imba_brewmaster_cinder_brew"},
	{"imba_brewmaster_primal_drunken_brawler","imba_brewmaster_drunken_brawler"},
	{"imba_faceless_void_time_lock","faceless_void_time_lock"},--jb
	{"imba_axe_battle_hunger","axe_battle_hunger"},--斧王
	{"dlimba_mars_bulwark","mars_bulwark"}--马尔斯3
	}
	tab_OverDoom_band_kill={"npc_imba_roshan","npc_dota_roshan","npc_dota_lone_druid_bear","npc_dota_lone_druid_bear1",
	"npc_dota_lone_druid_bear2","npc_dota_lone_druid_bear3","npc_dota_lone_druid_bear4"}
	
	tab_neutral_ability = {
	{"roshan_bash","imba_doom_roshan_bash"},--肉山敲晕
	{"black_dragon_splash_attack","imba_doom_black_dragon_splash_attack"},	--黑龙溅射
	{"centaur_khan_endurance_aura","imba_doom_centaur_khan_endurance_aura"},				--熊大光环
	{"alpha_wolf_critical_strike","imba_doom_alpha_wolf_critical_strike"},				--狼暴击
	{"satyr_hellcaller_unholy_aura","imba_doom_satyr_hellcaller_unholy_aura"},			--大撒特光环
	{"granite_golem_hp_aura","imba_doom_granite_golem_hp_aura_health"}, ----------花岗岩生命上限
	{"ghost_frost_attack","imba_doom_ghost_frost_attack"},
	}
	
	if  not IsServer() then  return end
	self.caster = self:GetCaster() 
	self.target = self:GetCursorTarget()	
	--吃技能开关，关了不吃技能
	--if self.target:TriggerSpellReflect(self) then return end--莲花个jb
	--print(tostring(self.target:GetName()))
	if  self.caster:GetTeamNumber()~=self.target:GetTeamNumber() and (self.target:TriggerSpellAbsorb(self)) or  self.target:GetName() == "npc_dota_hero_doom_bringer" then
		return
	end
	
	if self.caster:GetTeamNumber()~=self.target:GetTeamNumber() then 
		self.target:AddNewModifier(self.caster,self,"modifier_imba_doom_bringer_devour_ovredoom_kill_flag",{duration=0.02})		
	end
	
	self:OverDoom() --结算伤害	
	---------------------------------------------------------------------
	--水人不允许通过吞噬获取指定野怪技能，只能通过变身一瞬间获取末日吞噬获取的基础技能
	if self.caster:GetName() == "npc_dota_hero_morphling" then return end
	---------------------------------------------------------------------
	if  self:GetCaster() == self.caster and  self:GetAutoCastState() and  not self.target:IsHero() then
		--自带吃远古与敌人了
		if self.target:IsNeutralUnitType() or self.target:IsCreep() then 

		self:devour_ability() --获取技能
		end
	end
	local imba_doom_ability_1 = self:GetCaster():GetAbilityByIndex(3)	
	local imba_doom_ability_2 = self:GetCaster():GetAbilityByIndex(4) 
	if self:IsInTable_name(tostring(imba_doom_ability_1:GetName()),tab_neutral_ability) and not self.caster:HasModifier(tostring(self:IsInTable_name_value(tostring(imba_doom_ability_1:GetName()),tab_neutral_ability))) then 
	self.caster:AddNewModifier(self.caster,self,tostring(self:IsInTable_name_value(tostring(imba_doom_ability_1:GetName()),tab_neutral_ability)),{duration=-1})
	end
	if self:IsInTable_name(tostring(imba_doom_ability_2:GetName()),tab_neutral_ability) and not self.caster:HasModifier(tostring(self:IsInTable_name_value(tostring(imba_doom_ability_2:GetName()),tab_neutral_ability)))then 
	self.caster:AddNewModifier(self.caster,self,tostring(self:IsInTable_name_value(tostring(imba_doom_ability_2:GetName()),tab_neutral_ability)),{duration=-1})
	end
	
end


function imba_doom_bringer_devour:OverDoom()
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_mouth", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		self.caster:EmitSound("Hero_DoomBringer.Devour")
	if self.target:IsAncient() and self:GetCaster():TG_HasTalent("special_bonus_imba_doom_2") and not self.target:IsBoss() then 
		self.target:Kill(self, self.caster)
		return
	end
	
	if not self.target:IsRealHero() and not self:IsInTable_ban(tostring(self.target:GetName()),tab_OverDoom_band_kill) and not self.target:IsAncient() and not self.target:IsBoss() then 
	--print(tostring(self.target:GetName()))
	self.target:Kill(self, self.caster)
--	self.target:AddNoDraw()	
	else 	
				--if self:GetCaster():Has_Aghanims_Shard() then
				if self:GetCaster():HasModifier("modifier_item_aghanims_shard") then
				if self.target:GetLevel()>24 or math.fmod(self.target:GetLevel(),3) == 0  then
				ApplyDamage({victim = self.target, 
				attacker = self.caster, 
				ability = self, 
				damage_type = self:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				damage = self.target:GetMaxHealth()/100*self:GetSpecialValueFor("shard")})
				end
				end
		if not self.target:IsAlive() then return end
		if self.target:HasModifier("modifier_imba_doom_bringer_infernal_blade_debuff") then 
					local modifier = self.target:FindAllModifiers()
					local count = 0
					for k,v in ipairs(modifier) do
						if v:GetName() == "modifier_imba_doom_bringer_infernal_blade_debuff"
							then count = count+v:GetRemainingTime()
						end
					end
				local over_damage = (self:GetSpecialValueFor("burn_damage")+(self:GetSpecialValueFor("burn_damage_pct")*self.target:GetMaxHealth()/100))*count*0.66
		

				ApplyDamage({victim = self.target, 
				attacker = self.caster, 
				ability = self, 
				damage_type = self:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				damage = over_damage})

				local delicious = self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_imba_doom_bringer_devour_delicious",{duration=self:GetSpecialValueFor("buff_duration")})
				if delicious:GetStackCount()<self:GetSpecialValueFor("maxs") then delicious:IncrementStackCount() end			
				
		end
			
	end
	
end
function imba_doom_bringer_devour:Has_Aghanims_Shard()
  return  self:HasModifier("modifier_item_aghanims_shard")
end
function imba_doom_bringer_devour:IsInTable_name(value, tab)
	for k =1,#tab do
		if tab[k][1] == value
		then
			return true
    end
	end
	
    return false
end 

function imba_doom_bringer_devour:IsInTable_name_value(value, tab)
	for k =1,#tab do
		if tab[k][1] == value
		then
			return tab[k][2]
    end
	end
	
    return false
end 
function imba_doom_bringer_devour:IsInTable_ban(value, tab)
	for k =1,#tab do
	if tab[k] == value
	then return true 
	end
	end
	return false

end

function imba_doom_bringer_devour:devour_ability()
    	
	if self.caster:HasAbility("doom_bringer_empty1") then
	self.new1= self.caster:FindAbilityByName("doom_bringer_empty1")
	self.new2= self.caster:FindAbilityByName("doom_bringer_empty2")				
	end
	if self:IsInTable_name(tostring(self.new1:GetName()),tab_neutral_ability) then 
	self.caster:RemoveModifierByName(tostring(self:IsInTable_name_value(tostring(self.new1:GetName()),tab_neutral_ability)))
	end
	if self:IsInTable_name(tostring(self.new2:GetName()),tab_neutral_ability) then 
	self.caster:RemoveModifierByName(tostring(self:IsInTable_name_value(tostring(self.new2:GetName()),tab_neutral_ability)))
	end
	--获取目标前3个技能
	local abilityName = {}

		for i = 0,2 do
		local ability_target = self.target:GetAbilityByIndex(i)				
		if ability_target~= nil then
			table.insert(abilityName,ability_target)
		end
		end	

	--分配技能栏
	if #abilityName == 0 or #abilityName ==nil  then return end
	if #abilityName ==1  then self.ability0 = abilityName[1] self.ability1 = nil end
	if #abilityName ==2  then self.ability0 = abilityName[1] self.ability1 = abilityName[2] end
	if #abilityName ==3  then 

	local roll = math.random(0,2)		--随机技能 以及用这种方式ban某些技能 
	if self.target:GetUnitName() =="npc_dota_hero_lone_druid" or self.target:GetUnitName() =="npc_dota_roshan" then roll = 2 end	--熊 肉山 1
	if roll == 0 then self.ability0 = abilityName[1] self.ability1 = abilityName[2]  end
	if roll == 1 then self.ability0 = abilityName[1] self.ability1 = abilityName[3]  end
	if roll == 2 then self.ability0 = abilityName[2] self.ability1 = abilityName[3]  end
end
	
	--应用技能
	if self.new1:GetToggleState() then self.new1:ToggleAbility() end
	if self.new2:GetToggleState() then self.new2:ToggleAbility() end
	self.caster:RemoveAbility(self.new1:GetName())  
	self.caster:RemoveAbility(self.new2:GetName())
	--	print(tostring(self.ability2:GetName()))
	self.new1=self.caster:AddAbility(tostring(self.ability0:GetName())) 
	self.new1:SetStolen( true )
	self.new1:SetLevel(self.ability0:GetLevel())
	
	

			if self.ability1== nil then 
				self.new2=self.caster:AddAbility("doom_bringer_empty2")
				self.new2:SetLevel(0)
			else 
				self.new2=self.caster:AddAbility(tostring(self.ability1:GetName()))
				self.new2:SetLevel(self.ability1:GetLevel())
			end
			
	
	self.new2:SetStolen( true )
	--print(tostring(self.new1:GetName()))
	--print(tostring(self.new2:GetName()))
	---------野怪技能判断-----------
	if self:IsInTable_name(tostring(self.new1:GetName()),tab_neutral_ability) then 
	self.caster:AddNewModifier(self.caster,self,tostring(self:IsInTable_name_value(tostring(self.new1:GetName()),tab_neutral_ability)),{duration=-1})
	end
	if self:IsInTable_name(tostring(self.new2:GetName()),tab_neutral_ability) then 
	self.caster:AddNewModifier(self.caster,self,tostring(self:IsInTable_name_value(tostring(self.new2:GetName()),tab_neutral_ability)),{duration=-1})
	end
end
modifier_imba_doom_bringer_devour_delicious= class({})
function modifier_imba_doom_bringer_devour_delicious:IsDebuff()			return false end
function modifier_imba_doom_bringer_devour_delicious:IsHidden() 		
	if self:GetStackCount() > 0 then
		return false
	end
	return true
end
--吞噬buff
function modifier_imba_doom_bringer_devour_delicious:IsPurgable() 		return false end
function modifier_imba_doom_bringer_devour_delicious:IsPurgeException() 	return false end
function modifier_imba_doom_bringer_devour_delicious:RemoveOnDeath() 	return true end
function modifier_imba_doom_bringer_devour_delicious:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE} end
function modifier_imba_doom_bringer_devour_delicious:GetModifierConstantHealthRegen() return self:GetStackCount()*self.re end
function modifier_imba_doom_bringer_devour_delicious:GetModifierHealthRegenPercentage() return self:GetStackCount()*self.re_p end
function modifier_imba_doom_bringer_devour_delicious:OnCreated()
	self.re = self:GetAbility():GetSpecialValueFor("regen")
	self.re_p = self:GetAbility():GetSpecialValueFor("regen_P")
end
function modifier_imba_doom_bringer_devour_delicious:OnDestroy()
	self.re = nil
	self.re_p = nil
end

--吞噬技能的持续时间
--[[modifier_imba_doom_bringer_devour_abilitybuff= class({})

function modifier_imba_doom_bringer_devour_abilitybuff:IsDebuff()			return false end
function modifier_imba_doom_bringer_devour_abilitybuff:IsHidden() 			return false end
function modifier_imba_doom_bringer_devour_abilitybuff:IsPurgable() 		return false end
function modifier_imba_doom_bringer_devour_abilitybuff:IsPurgeException() 	return false end
function modifier_imba_doom_bringer_devour_abilitybuff:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_imba_doom_bringer_devour_abilitybuff:RemoveOnDeath() 	return not self:GetParent():TG_HasTalent("special_bonus_imba_doom_6") end
function modifier_imba_doom_bringer_devour_abilitybuff:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()then
		return
	end
-----------火女被动限制----------
	
	if self:GetParent():HasModifier("modifier_imba_fiery_soul_stacks")then
	local modifier = self:GetParent():FindModifierByName("modifier_imba_fiery_soul_stacks")
	
	if modifier:GetStackCount()>2 then modifier:SetStackCount(2) end
	if self:GetParent():HasModifier("modifier_imba_fiery_soul_active") then
	modifier:SetStackCount(3)
	end
	end
end
function modifier_imba_doom_bringer_devour_abilitybuff:OnDestroy() 
	if not IsServer() then return end
	if self:GetParent() == self:GetCaster() then 
		local imba_doom_ability_1 = self:GetParent():GetAbilityByIndex(3)	
		local imba_doom_ability_2 = self:GetParent():GetAbilityByIndex(4) 
		if imba_doom_ability_1:GetToggleState() then imba_doom_ability_1:ToggleAbility() end
		if imba_doom_ability_2:GetToggleState() then imba_doom_ability_2:ToggleAbility() end
		self:GetParent():RemoveAbility(tostring(imba_doom_ability_1:GetName()))
		self:GetParent():RemoveAbility(tostring(imba_doom_ability_2:GetName()))
		self:GetParent():AddAbility("doom_bringer_empty1")
		self:GetParent():AddAbility("doom_bringer_empty2")

	end
end
]]
--标记用 是否是吃死的 
modifier_imba_doom_bringer_devour_ovredoom_kill_flag= class({})
function modifier_imba_doom_bringer_devour_ovredoom_kill_flag:IsDebuff()			return true end
function modifier_imba_doom_bringer_devour_ovredoom_kill_flag:IsHidden() 			return true end
function modifier_imba_doom_bringer_devour_ovredoom_kill_flag:IsPurgable() 		return false end
function modifier_imba_doom_bringer_devour_ovredoom_kill_flag:IsPurgeException() 	return false end
function modifier_imba_doom_bringer_devour_ovredoom_kill_flag:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end
function modifier_imba_doom_bringer_devour_ovredoom_kill_flag:OnDeath(keys)
--not self:GetCaster():IsAlive() or keys.unit~= self:GetParent() 
	if not IsServer() or self:GetParent()~= keys.unit then return end
	local modifier = nil

	modifier = self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_doom_bringer_devour_delicious",{duration=self:GetAbility():GetSpecialValueFor("buff_duration")})

	local gold = 0
	
	if keys.unit:IsRealHero() then modifier:SetStackCount(self:GetAbility():GetSpecialValueFor("maxs")) 
	gold = self:GetAbility():GetSpecialValueFor("gold_hero") 
	else 
		if modifier:GetStackCount()<6 then modifier:IncrementStackCount() 
		gold = self:GetAbility():GetSpecialValueFor("bonus_gold") end	
	end
	if gold ~= 0 then 
	self:GetCaster():ModifyGold(gold, false, DOTA_ModifyGold_CreepKill)
	SendOverheadEventMessage(PlayerResource:GetPlayer(self:GetCaster():GetPlayerID()), OVERHEAD_ALERT_GOLD, self:GetCaster(), gold,nil)
	end
	keys.unit:AddNoDraw()
end

-------------------------模拟野怪技能--------------------------------------
-------------------------大沙特回血被动-------------------------------------
imba_doom_satyr_hellcaller_unholy_aura= class({})
LinkLuaModifier("imba_doom_satyr_hellcaller_unholy_aura_heal","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
function imba_doom_satyr_hellcaller_unholy_aura:IsAura() return true end
function imba_doom_satyr_hellcaller_unholy_aura:GetAuraDuration() return 1 end
function imba_doom_satyr_hellcaller_unholy_aura:IsHidden() 			return true end
function imba_doom_satyr_hellcaller_unholy_aura:RemoveOnDeath()			return false end
function imba_doom_satyr_hellcaller_unholy_aura:GetModifierAura() return "imba_doom_satyr_hellcaller_unholy_aura_heal" end
function imba_doom_satyr_hellcaller_unholy_aura:GetAuraRadius() return 1200 end
function imba_doom_satyr_hellcaller_unholy_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function imba_doom_satyr_hellcaller_unholy_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function imba_doom_satyr_hellcaller_unholy_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

imba_doom_satyr_hellcaller_unholy_aura_heal= class({})
function imba_doom_satyr_hellcaller_unholy_aura_heal:IsDebuff()			return false end
function imba_doom_satyr_hellcaller_unholy_aura_heal:IsHidden() 			return false end
function imba_doom_satyr_hellcaller_unholy_aura_heal:IsPurgable() 			return false end
function imba_doom_satyr_hellcaller_unholy_aura_heal:IsPurgeException() 	return false end
function imba_doom_satyr_hellcaller_unholy_aura_heal:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT} end
function imba_doom_satyr_hellcaller_unholy_aura_heal:GetModifierConstantHealthRegen() 
	if self.heal~=nil then
		return self.heal
	end
end

function imba_doom_satyr_hellcaller_unholy_aura_heal:OnCreated() 
	self.heal=36
end
function imba_doom_satyr_hellcaller_unholy_aura_heal:OnRemoved() 
	self.heal=nil
end


-------------------------狼被动暴击------------------------------
imba_doom_alpha_wolf_critical_strike= class({})
function imba_doom_alpha_wolf_critical_strike:IsDebuff()			return false end
function imba_doom_alpha_wolf_critical_strike:IsHidden() 		return false end
function imba_doom_alpha_wolf_critical_strike:IsPurgable() 		return false end
function imba_doom_alpha_wolf_critical_strike:IsPurgeException() return false end
function imba_doom_alpha_wolf_critical_strike:RemoveOnDeath()			return false end
function imba_doom_alpha_wolf_critical_strike:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE, MODIFIER_EVENT_ON_ATTACK_LANDED, MODIFIER_EVENT_ON_ATTACK_FAIL} end
function imba_doom_alpha_wolf_critical_strike:OnCreated() self.crit = {} end
function imba_doom_alpha_wolf_critical_strike:OnDestroy() self.crit = nil end
function imba_doom_alpha_wolf_critical_strike:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() and not self:GetParent():PassivesDisabled() then
		if PseudoRandom:RollPseudoRandom(self:GetAbility(), 30) then
			self:GetParent():EmitSound("Hero_SkeletonKing.CriticalStrike")
			self.crit[keys.record] = true
			return 250
		else
			return 0
		end
	end
end

function imba_doom_alpha_wolf_critical_strike:OnAttackFail(keys) self.crit[keys.record] = nil end

function imba_doom_alpha_wolf_critical_strike:OnAttackLanded(keys)
	if keys.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled() or keys.target:IsOther() or keys.target:IsBuilding() or not keys.target:IsAlive() then
		return
	end
	self.crit[keys.record] = nil
end
---------------------------------------熊光环------------------------------
imba_doom_centaur_khan_endurance_aura= class({})
LinkLuaModifier("imba_doom_centaur_khan_endurance_aura_speed","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
function imba_doom_centaur_khan_endurance_aura:IsAura() return true end
function imba_doom_centaur_khan_endurance_aura:GetAuraDuration() return 1 end
function imba_doom_centaur_khan_endurance_aura:IsHidden() 			return true end
function imba_doom_centaur_khan_endurance_aura:RemoveOnDeath()			return false end
function imba_doom_centaur_khan_endurance_aura:GetModifierAura() return "imba_doom_centaur_khan_endurance_aura_speed" end
function imba_doom_centaur_khan_endurance_aura:GetAuraRadius() return 1200 end
function imba_doom_centaur_khan_endurance_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function imba_doom_centaur_khan_endurance_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function imba_doom_centaur_khan_endurance_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

imba_doom_centaur_khan_endurance_aura_speed= class({})
function imba_doom_centaur_khan_endurance_aura_speed:IsDebuff()			return false end
function imba_doom_centaur_khan_endurance_aura_speed:IsHidden() 			return false end
function imba_doom_centaur_khan_endurance_aura_speed:IsPurgable() 			return false end
function imba_doom_centaur_khan_endurance_aura_speed:IsPurgeException() 	return false end
function imba_doom_centaur_khan_endurance_aura_speed:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function imba_doom_centaur_khan_endurance_aura_speed:GetModifierAttackSpeedBonus_Constant() 
	if self.speed~=nil then
		return self.speed
	end
end

function imba_doom_centaur_khan_endurance_aura_speed:OnCreated() 
	self.speed=90
end
function imba_doom_centaur_khan_endurance_aura_speed:OnRemoved() 
	self.speed=nil
end

--------------------------------黑龙分裂---------------------
imba_doom_black_dragon_splash_attack = class({})

function imba_doom_black_dragon_splash_attack:IsDebuff()			return false end
function imba_doom_black_dragon_splash_attack:IsHidden() 			return false end
function imba_doom_black_dragon_splash_attack:IsPurgable() 		return false end
function imba_doom_black_dragon_splash_attack:RemoveOnDeath()			return false end
function imba_doom_black_dragon_splash_attack:IsPurgeException() 	return false end
function imba_doom_black_dragon_splash_attack:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function imba_doom_black_dragon_splash_attack:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() or keys.target:IsOther() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
		local dmg = keys.damage 
	DoCleaveAttack(self:GetParent(), keys.target, self:GetAbility(), dmg, 250, 250, 250, "particles/item/bfury/bfury_cleave.vpcf")

end

function DoCleaveAttack(hAttacker, hTarget, hAbility, fDamage, fStartRadius, fEndRadius, fDistance, sHitEffect)
	local target = hAttacker:IsRangedAttacker() and hTarget or hAttacker
	local direction = GetDirection2D(hTarget:GetAbsOrigin(), hAttacker:GetAbsOrigin())
	local enemy = FindUnitsInTrapezoid(hAttacker:GetTeamNumber(), direction, GetGroundPosition(target:GetAbsOrigin(), nil), fStartRadius, fEndRadius, fDistance, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	local pfx = nil
	if sHitEffect then
		pfx = ParticleManager:CreateParticle(sHitEffect, PATTACH_CUSTOMORIGIN, hAttacker)
		ParticleManager:SetParticleControl(pfx, 0, hAttacker:IsRangedAttacker() and hTarget:GetAbsOrigin() or hAttacker:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(pfx, 0, (hTarget:GetAbsOrigin() - hAttacker:GetAbsOrigin()):Normalized())
	end
	for i=1, #enemy do
		if enemy[i] ~= hTarget then
			ApplyDamage({attacker = hAttacker, victim = enemy[i], ability = hAbility, damage = fDamage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR})
			if pfx then
				ParticleManager:SetParticleControlEnt(pfx, i + 16, enemy[i], PATTACH_POINT, "attach_hitloc", enemy[i]:GetAbsOrigin(), true)
			end
		end
	end
	if pfx then
		ParticleManager:ReleaseParticleIndex(pfx)
	end
end
----------------------------肉山敲晕-------------------------
imba_doom_roshan_bash = class({})

function imba_doom_roshan_bash:IsDebuff()			return false end
function imba_doom_roshan_bash:IsHidden() 			return false end
function imba_doom_roshan_bash:IsPurgable() 		return false end
function imba_doom_roshan_bash:IsPurgeException() 	return false end
function imba_doom_roshan_bash:RemoveOnDeath()			return false end
function imba_doom_roshan_bash:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function imba_doom_roshan_bash:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() or keys.target:IsOther() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if PseudoRandom:RollPseudoRandom(self:GetAbility(), 30) then
		keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_stunned", {duration = 1.65 })
	end

end
--------------------花岗岩被动-----------------
--[[imba_doom_granite_golem_hp_aura= class({})
LinkLuaModifier("imba_doom_granite_golem_hp_aura_health","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
function imba_doom_granite_golem_hp_aura:IsAura() return true end
function imba_doom_granite_golem_hp_aura:GetAuraDuration() return 1 end
function imba_doom_granite_golem_hp_aura:IsHidden() 			return true end
function imba_doom_granite_golem_hp_aura:GetModifierAura() return "imba_doom_granite_golem_hp_aura_health" end
function imba_doom_granite_golem_hp_aura:GetAuraRadius() return 1200 end
function imba_doom_granite_golem_hp_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function imba_doom_granite_golem_hp_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function imba_doom_granite_golem_hp_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end]]

imba_doom_granite_golem_hp_aura_health= class({})
function imba_doom_granite_golem_hp_aura_health:IsDebuff()			return false end
function imba_doom_granite_golem_hp_aura_health:RemoveOnDeath()			return false end
function imba_doom_granite_golem_hp_aura_health:IsHidden() 			return false end
function imba_doom_granite_golem_hp_aura_health:IsPurgable() 			return false end
function imba_doom_granite_golem_hp_aura_health:IsPurgeException() 	return false end
function imba_doom_granite_golem_hp_aura_health:DeclareFunctions() return {MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE} end
function imba_doom_granite_golem_hp_aura_health:GetModifierExtraHealthPercentage() 
	if self.health~=nil then
		return self.health
	end
end

function imba_doom_granite_golem_hp_aura_health:OnCreated() 
	self.health=25
end

function imba_doom_granite_golem_hp_aura_health:OnRemoved() 
	self.health=nil
end

-----------------鬼魂减速-----------------
imba_doom_ghost_frost_attack = class({})
LinkLuaModifier("imba_doom_ghost_frost_attack_slow","ting/hero_doom", LUA_MODIFIER_MOTION_NONE)
function imba_doom_ghost_frost_attack:IsDebuff()			return false end
function imba_doom_ghost_frost_attack:IsHidden() 			return true end
function imba_doom_ghost_frost_attack:IsPurgable() 		return false end
function imba_doom_ghost_frost_attack:IsPurgeException() 	return false end
function imba_doom_ghost_frost_attack:RemoveOnDeath()			return false end
function imba_doom_ghost_frost_attack:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end

function imba_doom_ghost_frost_attack:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() or keys.target:IsOther() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "imba_doom_ghost_frost_attack_slow", {duration = 3.5 })
	


end

imba_doom_ghost_frost_attack_slow= class({})
function imba_doom_ghost_frost_attack_slow:IsDebuff()			return true end
function imba_doom_ghost_frost_attack_slow:IsHidden() 			return false end
function imba_doom_ghost_frost_attack_slow:IsPurgable() 			return false end
function imba_doom_ghost_frost_attack_slow:IsPurgeException() 	return false end
function imba_doom_ghost_frost_attack_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE} end
function imba_doom_ghost_frost_attack_slow:GetModifierMoveSpeedBonus_Percentage() return -40 end
function imba_doom_ghost_frost_attack_slow:GetModifierAttackSpeedBonus_Constant() return -150 end
function imba_doom_ghost_frost_attack_slow:GetModifierMagicalResistanceDecrepifyUnique()	return -35 end
function imba_doom_ghost_frost_attack_slow:GetStatusEffectName() return "particles/status_fx/status_effect_frost_lich.vpcf" end
function imba_doom_ghost_frost_attack_slow:StatusEffectPriority() return 15 end







