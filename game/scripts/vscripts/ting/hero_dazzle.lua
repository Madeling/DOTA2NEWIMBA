CreateTalents("npc_dota_hero_dazzle", "ting/hero_dazzle")

imba_dazzle_poison_touch = class({})

LinkLuaModifier("modifier_imba_poison_touch_slow", "ting/hero_dazzle", LUA_MODIFIER_MOTION_NONE)

function imba_dazzle_poison_touch:IsHiddenWhenStolen() 		return false end
function imba_dazzle_poison_touch:IsRefreshable() 			return true  end
function imba_dazzle_poison_touch:IsStealable() 			return true  end
function imba_dazzle_poison_touch:IsNetherWardStealable()	return true end
function imba_dazzle_poison_touch:Init( )
	self.pfx_project = "particles/units/heroes/hero_dazzle/dazzle_poison_touch.vpcf"
	self.sound = "Hero_Dazzle.Poison_Cast"
	self.sound2 = "Hero_Dazzle.Poison_Touch"
	self.sound3 = "Hero_Dazzle.Poison_Tick"
end

function imba_dazzle_poison_touch:OnSpellStart()

	self.caster = self:GetCaster()
	self.target = self:GetCursorTarget()	
	self.stack = self:GetSpecialValueFor("max_stack")-1
	self.speed = self:GetSpecialValueFor("projectile_speed")
	self.duration = self:GetSpecialValueFor("slow_duration")
	self.radius = self:GetSpecialValueFor("radius") + self.caster:GetCastRangeBonus() + 300

	self.damageTable = {
						
						attacker = self.caster,
						damage = self:GetSpecialValueFor("damage"),
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self, --Optional.
						}
	self.info = 
			{
				vSourceLoc = self.caster:GetAbsOrigin(),
				Source = self.caster,
				Ability = self,	
				EffectName = self.pfx_project,
				iMoveSpeed = self.speed,
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				bProvidesVision = false,	
			}
	self.info.Target = self.target
	ProjectileManager:CreateTrackingProjectile(self.info)
			self.caster:EmitSound(self.sound)
			if self.target ~= nil then
				if self.caster:Has_Aghanims_Shard() then
					self.caster:PerformAttack(self.target, false, true, true, false, true, false, false)
				end
			end	

		local enemy = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for i=1, #enemy do
			if self.stack == 0 then return end
			if enemy[i]~= self.target then
				self.info.Target = enemy[i]

			ProjectileManager:CreateTrackingProjectile(self.info)
			self.stack = self.stack - 1
			end
		end

end



function imba_dazzle_poison_touch:OnProjectileHit(target, pos)

	if not target then
		return
	end
	if target:TriggerStandardTargetSpell(self) then
		return
	end 
	self.damageTable.victim = target

	if target~=nil and target:IsAlive() then
	ApplyDamage(damageTable)
	target:AddNewModifier_RS(self.caster, self, "modifier_imba_poison_touch_slow", {duration = self.duration})	
	target:AddNewModifier(self.caster, self, "modifier_imba_stunned", {duration = 0.01})
	target:EmitSound(self.sound2)
	end
end

modifier_imba_poison_touch_slow = class({})

function modifier_imba_poison_touch_slow:IsDebuff()				return true end
function modifier_imba_poison_touch_slow:IsHidden() 			return false end
function modifier_imba_poison_touch_slow:IsPurgable() 			return true end
function modifier_imba_poison_touch_slow:IsPurgeException() 	return true end
function modifier_imba_poison_touch_slow:GetStatusEffectName()  return "particles/status_fx/status_effect_poison_dazzle.vpcf" end
function modifier_imba_poison_touch_slow:StatusEffectPriority() return 15 end
function modifier_imba_poison_touch_slow:GetEffectName() return "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf" end
function modifier_imba_poison_touch_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_poison_touch_slow:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_EVENT_ON_ATTACK_LANDED}
end
function modifier_imba_poison_touch_slow:GetModifierMoveSpeedBonus_Percentage()
 return self.slow  end

function modifier_imba_poison_touch_slow:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.target ~= self:GetParent() then
		return
	end	



	if keys.target ~= nil and keys.target:IsAlive() then 
	if self.caster:TG_HasTalent("special_bonus_imba_dazzle_3") then
		if PseudoRandom:RollPseudoRandom(self:GetAbility(),self.caster:TG_GetTalentValue("special_bonus_imba_dazzle_3")) then
			keys.target:AddNewModifier(self.caster, self.ability, "modifier_imba_stunned", {duration =self.stun})
		end
	end
	self.damageTable.victim = keys.target
	ApplyDamage(self.damageTable)
	end
end

function modifier_imba_poison_touch_slow:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.slow = self.ability:GetSpecialValueFor("initial_slow")*-1
	self.damage_stack = self.ability:GetSpecialValueFor("damage_per")+self.caster:TG_GetTalentValue("special_bonus_imba_dazzle_2")*self.caster:GetIntellect()
	self.stun = self.ability:GetSpecialValueFor("stun_duration")

	self.damageTable = {
						attacker = self.caster,
						damage = self.damage_stack,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						damage_flags = DOTA_DAMAGE_FLAG_NONE, 
						ability = self.ability, 
						}
	if IsServer() then
		self.inter = self.ability:GetSpecialValueFor("tick_interval")*(1 - self.parent:GetStatusResistance())
		self:StartIntervalThink(self.inter)
	end
end

function modifier_imba_poison_touch_slow:OnIntervalThink()
	self.damageTable.victim = self.parent
	self:GetParent():AddNewModifier(self.caster, self.ability, "modifier_imba_stunned", {duration = self.stun })
	ApplyDamage(self.damageTable)
	EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), self.ability.sound3, self.parent)
end


imba_dazzle_shallow_grave = class({})

LinkLuaModifier("modifier_imba_shallow_grave", "ting/hero_dazzle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_false_promise_buff2", "heros/hero_oracle/false_promise.lua", LUA_MODIFIER_MOTION_NONE)
function imba_dazzle_shallow_grave:IsHiddenWhenStolen() 		return false end
function imba_dazzle_shallow_grave:IsRefreshable() 			return true  end
function imba_dazzle_shallow_grave:IsStealable() 			return true  end
function imba_dazzle_shallow_grave:IsNetherWardStealable()	return true end


function imba_dazzle_shallow_grave:Init()
	self.sound1 = "Hero_Dazzle.Shallow_Grave"
	self.pfx1 = "particles/units/heroes/hero_dazzle/dazzle_shallow_grave.vpcf"
end
function imba_dazzle_shallow_grave:OnSpellStart()
	self.caster = self:GetCaster()
	self.target = self:GetCursorTarget()
	self.target:AddNewModifier(self.caster, self, "modifier_imba_shallow_grave", {duration = self:GetSpecialValueFor("duration_tooltip")})
	self.target:AddNewModifier(self.caster, self, "modifier_false_promise_buff2", {duration = self:GetSpecialValueFor("duration_tooltip")})
	self:StartCooldown(self:GetSpecialValueFor("true_cd")+self.caster:TG_GetTalentValue("special_bonus_imba_dazzle_5")) 
end

modifier_imba_shallow_grave = class({})
function modifier_imba_shallow_grave:IsDebuff()				return false end
function modifier_imba_shallow_grave:IsHidden() 			return false end
function modifier_imba_shallow_grave:IsPurgable() 			return false end
function modifier_imba_shallow_grave:IsPurgeException() 	return false end
function modifier_imba_shallow_grave:GetEffectName() return self.ability.pfx1 end
function modifier_imba_shallow_grave:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_shallow_grave:OnCreated()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if IsServer() then
	self.heal = self.parent:GetMaxHealth()*0.05
	self:StartIntervalThink(1)
	EmitSoundOn(self.ability.sound1, self.parent)
		
	end
end


function modifier_imba_shallow_grave:OnIntervalThink()
	if IsServer() then
		self.parent:SetHealth(math.min(self.parent:GetHealth()+self.heal,self:GetParent():GetMaxHealth()))
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.parent, self.heal, nil)
	end
end


function modifier_imba_shallow_grave:OnDestroy()

	if IsServer() then
		StopSoundOn(self.ability.sound1, self.parent)
		if self.caster:TG_HasTalent("special_bonus_imba_dazzle_6") then
			self.parent:SetHealth(self.parent:GetMaxHealth())
		end

	end

end



imba_dazzle_shadow_wave = class({})


function imba_dazzle_shadow_wave:IsHiddenWhenStolen() 		return false end
function imba_dazzle_shadow_wave:IsRefreshable() 			return true  end
function imba_dazzle_shadow_wave:IsStealable() 				return true  end
function imba_dazzle_shadow_wave:IsNetherWardStealable()	return true end
function imba_dazzle_shadow_wave:Init()
	self.sound = "Hero_Dazzle.Shadow_Wave"
	self.pfx1= "particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf"
	self.pfx2 = "particles/units/heroes/hero_dazzle/dazzle_shadow_wave_impact_damage.vpcf"
end
function imba_dazzle_shadow_wave:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	self.bonus_healing = self:GetSpecialValueFor("bonus_healing")/100
	self.damage = self:GetSpecialValueFor("damage")
	self.health = self:GetSpecialValueFor("damage")
	self.radius = self:GetSpecialValueFor("damage_radius")
	self.radius2 = self:GetSpecialValueFor("bounce_radius")
	self.damageTable = {
								attacker = caster,
								damage_type = self:GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self, --Optional.
								}
	--魔晶
			if target ~= nil then
				if caster:Has_Aghanims_Shard() and not Is_Chinese_TG(caster,target) then
				caster:PerformAttack(target, false, true, true, false, true, false, false)
				end
			end
	--弹跳		
	local units = {}
	units[#units + 1] = target
	for _, aunit in pairs(units) do
		local units1 = FindUnitsInRadius(target:GetTeamNumber(), aunit:GetAbsOrigin(), nil, self.radius2, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
		for _, unit1 in pairs(units1) do
			local no_yet = true
			for _, unit in pairs(units) do
				if unit == unit1 or unit1 == caster then
					no_yet = false
					break
				end
			end
			if no_yet then
				units[#units + 1] = unit1
				break
			end
		end
	end
	if caster ~= target then
		table.insert(units, 1, caster)
	end

	for k, unit in pairs(units) do
		local i = (k == #units) and k or (k + 1)
		local pfx = ParticleManager:CreateParticle(self.pfx1, PATTACH_CUSTOMORIGIN, nil)
		if unit == caster then
			ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_attack1", unit:GetAbsOrigin(), true)
		else
			ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		end
		
		ParticleManager:SetParticleControlEnt(pfx, 1, units[i], PATTACH_POINT_FOLLOW, "attach_hitloc", units[i]:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
		if Is_Chinese_TG(unit,self:GetCaster()) then
		self.health = (unit:GetMaxHealth() - unit:GetHealth()) * self.bonus_healing + self.damage
		
		unit:Heal(self.health, caster)	
		
		else
		
		self.health = (unit:GetMaxHealth()*self.bonus_healing) + self.damage
			self.damageTable.victim = unit
			self.damageTable.damage = self.health
			ApplyDamage(self.damageTable)
		end

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, self.health, nil)

		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), self.sound, caster)
		if self:GetCaster():TG_HasTalent("special_bonus_imba_dazzle_1") then
			self.damage = self.health
		end
		--周围aoe伤害
		local enemies = FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if Is_Chinese_TG(enemy,self:GetCaster()) then
				enemy:Heal(self.damage, caster)	
			else
				self.damageTable.victim = enemy
				self.damageTable.damage = self.damage
				ApplyDamage(self.damageTable)				
			end		
			local pfx2 = ParticleManager:CreateParticle(self.pfx2, PATTACH_CUSTOMORIGIN, enemy)
			ParticleManager:SetParticleControlEnt(pfx2, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(pfx2, 1, enemy:GetAbsOrigin() + (enemy:GetAbsOrigin() - unit:GetAbsOrigin()):Normalized() * 100)
			ParticleManager:ReleaseParticleIndex(pfx2)
		end
	end
end



imba_dazzle_weave = class({})

LinkLuaModifier("modifier_imba_weave", "ting/hero_dazzle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dazzle_weave_passive", "ting/hero_dazzle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_weave_armor", "ting/hero_dazzle", LUA_MODIFIER_MOTION_NONE)

function imba_dazzle_weave:IsHiddenWhenStolen() 	return false end
function imba_dazzle_weave:IsRefreshable() 			return true  end
function imba_dazzle_weave:IsStealable() 			return true  end
function imba_dazzle_weave:IsNetherWardStealable()	return true end

function imba_dazzle_weave:GetIntrinsicModifierName() 
	return "modifier_imba_dazzle_weave_passive"
end
function imba_dazzle_weave:Init()
	self.pfx1 = "particles/units/heroes/hero_dazzle/dazzle_weave.vpcf"
	self.sound1 = "Hero_Dazzle.Shadow_Wave"
end
function imba_dazzle_weave:OnUpgrade()
	if not IsServer() then return end
	local mod = self:GetCaster():FindModifierByName("modifier_imba_dazzle_weave_passive")
	if mod then
		mod.duration = self:GetSpecialValueFor("duration")
		mod.radius = self:GetSpecialValueFor("radius")
	end
end
function imba_dazzle_weave:GetAOERadius() return self:GetSpecialValueFor("radius") end

function imba_dazzle_weave:OnSpellStart()
	
	self.caster = self:GetCaster()
	self.pos = self:GetCursorPosition()
	self.radius = self:GetSpecialValueFor("radius")
	self.duration = self:GetSpecialValueFor("duration")
	self.cd = self:GetSpecialValueFor("true_cd")
	local units = FindUnitsInRadius(self.caster:GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _, unit in pairs(units) do
		if unit~= nil then
			local modifier = unit:AddNewModifier(self.caster,self,"modifier_imba_weave_armor",{duration = self.duration})	
			if modifier ~= nil then
				modifier:SetStackCount(modifier:GetStackCount()+4)
			end
		end
	end
	local pfx = ParticleManager:CreateParticle(self.pfx1, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, Vector(self.pos.x, self.pos.y, self.pos.z + 128))
	ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius,self.radius))
	ParticleManager:ReleaseParticleIndex(pfx)
	AddFOWViewer(self.caster:GetTeamNumber(), self.pos,self.radius, 2, false)
	self.caster:EmitSound(self.sound1)
	self:StartCooldown(self.cd) 

end


modifier_imba_dazzle_weave_passive = class({})
LinkLuaModifier("modifier_imba_weave_armor", "ting/hero_dazzle", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_dazzle_weave_passive:IsDebuff()		return false end
function modifier_imba_dazzle_weave_passive:IsHidden() 		return true end
function modifier_imba_dazzle_weave_passive:IsPurgable() 		return false end
function modifier_imba_dazzle_weave_passive:IsPurgeException() 	return false end
function modifier_imba_dazzle_weave_passive:AllowIllusionDuplicate() return false end
function modifier_imba_dazzle_weave_passive:DeclareFunctions() return {MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_imba_dazzle_weave_passive:OnCreated()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.ab = self:GetAbility()
	self.duration = self.ab:GetSpecialValueFor("duration")
	self.radius = self.ab:GetSpecialValueFor("radius")

end	
function modifier_imba_dazzle_weave_passive:GetModifierPercentageCooldown()  return self:GetAbility():GetSpecialValueFor("cooldown")  end
function modifier_imba_dazzle_weave_passive:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self.parent or self.parent:PassivesDisabled() or self.parent:IsIllusion() or self.parent~=self.caster then 
		return 
	end

	if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
		return 
	end


	local target = keys.ability:GetCursorTarget() or nil 
	local point = self.caster:GetAbsOrigin()
	if target~=nil then
		point = target:GetAbsOrigin()
	end
	
	local units = FindUnitsInRadius(self.caster:GetTeamNumber(), point, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC ,DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false)
	for _, unit in pairs(units) do
		if unit:IsAlive() then
			unit:AddNewModifier(self.caster,self.ab,"modifier_imba_weave_armor",{duration = self.duration})	
		end
	
	end
end

function BitWiseAbilityBehavior(hAbility,pszAbilityBehavior)
	if type(hAbility:GetBehavior()) == "userdata" then 
		if hAbility:GetBehavior():BitwiseAnd(pszAbilityBehavior) then 
			return true
		end
	elseif bit.band(hAbility:GetBehavior(), pszAbilityBehavior) == pszAbilityBehavior then 
		return true
	end
	return false
end

modifier_imba_weave_armor = class({})

function modifier_imba_weave_armor:IsHidden() 			return false end
function modifier_imba_weave_armor:IsPurgable() 			return false end
function modifier_imba_weave_armor:IsPurgeException() 	return false end
function modifier_imba_weave_armor:ShouldUseOverheadOffset() return true end
function modifier_imba_weave_armor:IsDebuff()
	if Is_Chinese_TG(self:GetParent(),self:GetCaster()) then
		return false
	else
		return true
	end
end

function modifier_imba_weave_armor:OnCreated()
		self.armor = self:GetAbility():GetSpecialValueFor("armor")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_dazzle_4")
	if IsServer() then
		self:SetStackCount(0)
		self:OnRefresh()
		local particle = "particles/units/heroes/hero_dazzle/dazzle_armor_enemy.vpcf"
		if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			particle = "particles/units/heroes/hero_dazzle/dazzle_armor_friend.vpcf"
		end
		local pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end
function modifier_imba_weave_armor:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + 1)
	end
end

function modifier_imba_weave_armor:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_imba_weave_armor:GetModifierPhysicalArmorBonus()
	if Is_Chinese_TG(self:GetParent(),self:GetCaster()) then 
		return self.armor*self:GetStackCount()
	else 
		return 0 - self.armor*self:GetStackCount()
	end
	return 0
end

imba_dazzle_help = class({})

LinkLuaModifier("modifier_imba_weave_armor", "ting/hero_dazzle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_weave_armor_out", "ting/hero_dazzle", LUA_MODIFIER_MOTION_NONE)

function imba_dazzle_help:IsHiddenWhenStolen() 	return false end
function imba_dazzle_help:IsRefreshable() 			return false  end
function imba_dazzle_help:IsStealable() 			return false  end
function imba_dazzle_help:IsNetherWardStealable()	return true end


function imba_dazzle_help:OnInventoryContentsChanged()
	if not IsServer() then return end
    if self:GetCaster():HasScepter() then 
       self:SetHidden(false)
	   self:SetStolen(true)
--	   self:SetHidden(false)
       self:SetLevel(1)
    else
			self:SetHidden(true)
--			self:SetHidden(false)
			self:SetStolen(true)
    end
end
function imba_dazzle_help:GetAOERadius() return	self:GetSpecialValueFor("radius") end
function imba_dazzle_help:Init()
	self.pfx1 = "particles/generic_gameplay/screen_death_indicator.vpcf"
	self.pfx2 = "particles/units/heroes/hero_dazzle/dazzle_weave.vpcf"
	self.sound1 = "Hero_Dazzle.Shadow_Wave"
end



function imba_dazzle_help:OnSpellStart()
	self.caster = self:GetCaster()
	self.pos = self:GetCursorPosition()
	self.radius = self:GetSpecialValueFor("radius")
	self.duration = self:GetSpecialValueFor("duration")
	self.duration_armor = self:GetSpecialValueFor("duration_armor")
	local units = FindUnitsInRadius(self.caster:GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO ,DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false)
	for _, unit in pairs(units) do
	--if self:GetAutoCastState() then
		if unit:IsConsideredHero() and not unit:IsAlive() and unit:IsRealHero() then		
			local pfx_screen = ParticleManager:CreateParticleForPlayer(self.pfx1, PATTACH_ABSORIGIN_FOLLOW, unit, PlayerResource:GetPlayer(unit:GetPlayerID()))
			ParticleManager:ReleaseParticleIndex(pfx_screen)	
			--unit:AddNewModifier(caster,self,"modifier_imba_weave_lock",{duration = -1})
			PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), unit)
					Timers:CreateTimer(1,
					function() 
							PlayerResource:SetCameraTarget(unit:GetPlayerOwnerID(), nil)
					end)				
		end
	end	
	Notifications:BottomToAll({text ="暗影牧师正在进行复活仪式！", duration = 1,style = {["font-size"] = "80px", color = "#CD2626"}})
end

function imba_dazzle_help:OnChannelFinish(bInterrupted)	

    if not bInterrupted then 
	local health = 0.5
	local units = FindUnitsInRadius(self.caster:GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO ,DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false)
	for _, unit in pairs(units) do
	--if self:GetAutoCastState() then
		if unit:IsConsideredHero() and not unit:IsAlive() and unit:IsRealHero() then		
				local rezPosition = unit:GetAbsOrigin()
				unit:RespawnHero(false, false)
				unit:SetAbsOrigin(rezPosition)
				local ability = self.caster:FindAbilityByName("imba_dazzle_weave") 
				if ability ~= nil then
					if ability:GetLevel()>1 then 
						local modifier = unit:AddNewModifier(self.caster,ability,"modifier_imba_weave_armor",{duration = self.duration_armor})
						if modifier ~= nil then
							modifier:SetStackCount(modifier:GetStackCount()+4)
						end
					end
				end
					if unit:HasModifier("modifier_fountain_aura_buff") then
						unit:RemoveModifierByName("modifier_fountain_aura_buff")
					end
				unit:AddNewModifier(self.caster,self,"modifier_imba_weave_armor_out",{duration = self.duration})	
				unit:SetHealth(unit:GetMaxHealth()*health)
		PlayerResource:SetCameraTarget(unit:GetPlayerID(), nil)
		end
	end

	local pfx = ParticleManager:CreateParticle(self.pfx2, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, Vector(self.pos.x, self.pos.y, self.pos.z + 128))
	ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(pfx)
	AddFOWViewer(self.caster:GetTeamNumber(), self.pos, self.radius, 2, false)
	self.caster:EmitSound(self.sound1)
	end
end

modifier_imba_weave_armor_out = class({})

function modifier_imba_weave_armor_out:IsDebuff()			return false end
function modifier_imba_weave_armor_out:IsHidden() 			return false end
function modifier_imba_weave_armor_out:IsPurgable() 			return false end
function modifier_imba_weave_armor_out:IsPurgeException() 	return false end
function modifier_imba_weave_armor_out:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_MUTED] = true, [MODIFIER_STATE_SILENCED] = true,[MODIFIER_STATE_DISARMED] = true} end
function modifier_imba_weave_armor_out:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA  end
function modifier_imba_weave_armor_out:GetAbilityTextureName() return "dazzle_shadow_wave_immortal_png" end
function modifier_imba_weave_armor_out:GetEffectName()
	return "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf"
end

function modifier_imba_weave_armor_out:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end

function modifier_imba_weave_armor_out:OnCreated()
	if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_fountain_aura_buff") then
		self:GetParent():RemoveModifierByName("modifier_fountain_aura_buff")
	end
end



