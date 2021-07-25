--等离子场
CreateTalents("npc_dota_hero_razor", "ting/hero_razor")
imba_razor_plasma_field = class({})
LinkLuaModifier("modifier_imba_razor_plasma_field", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_razor_unstable_current_ampbuff", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
function imba_razor_plasma_field:OnSpellStart()
	local caster = self:GetCaster()
	EmitSoundOn("Ability.PlasmaField", caster)
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
	local duration = math.ceil((self:GetSpecialValueFor("radius")/self:GetSpecialValueFor("speed"))*100)/100
	caster:AddNewModifier(caster, self, "imba_razor_unstable_current_ampbuff", {duration = -1})
	caster:AddNewModifier(caster, self, "modifier_imba_razor_plasma_field", {duration = duration*2})
end

modifier_imba_razor_plasma_field_slow = class({})
LinkLuaModifier("modifier_imba_razor_plasma_field_slow", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_razor_plasma_field_slow:OnCreated()
	self.movespeed = self:GetAbility():GetSpecialValueFor("movespeed")
end
function modifier_imba_razor_plasma_field_slow:OnRefresh()
	self:IncrementStackCount()
end
function modifier_imba_razor_plasma_field_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end


function modifier_imba_razor_plasma_field_slow:GetModifierMoveSpeedBonus_Percentage()
	if Is_Chinese_TG(self:GetCaster(),self:GetParent()) then
		return self.movespeed
	else 
		return -self.movespeed
	end
return self.movespeed
end

modifier_imba_razor_plasma_field = class({})
LinkLuaModifier("modifier_imba_razor_plasma_field", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_razor_plasma_field:OnCreated(table)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local currentRadius = 0
		local maxRadius = self:GetAbility():GetSpecialValueFor("radius")
		local currentRadius2 = self:GetAbility():GetSpecialValueFor("radius")
		local speed = self:GetAbility():GetSpecialValueFor("speed") 											--圈属性
		local damage_max = self:GetAbility():GetSpecialValueFor("damage_max")+caster:TG_GetTalentValue("special_bonus_imba_razor_1")
		local damage_min = self:GetAbility():GetSpecialValueFor("damage_min")+caster:TG_GetTalentValue("special_bonus_imba_razor_1")
		local damage = (damage_max - damage_min)*0.001
		local kno = self:GetAbility():GetSpecialValueFor("kno")*0.001
		local kno_duration = 0.0003																				--伤害击退
		local dur = self:GetAbility():GetSpecialValueFor("duration_enemy")
		local ability_link = caster:FindAbilityByName("imba_razor_static_link")
		local ability_link_stack = self:GetAbility():GetSpecialValueFor("ability_link_stack")
		local Knockback ={
        should_stun = false,
        knockback_duration = 0.3,
        knockback_height = 0,
		}
		local damageTable = {
							attacker = caster,
							damage_type = ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = ability, --Optional.
							}
		self.modifier = self:GetParent():FindModifierByName("imba_razor_unstable_current_ampbuff")
		caster:AddNewModifier(caster, ability, "modifier_imba_razor_plasma_field_slow", {duration = self:GetRemainingTime()*2})
		local pfx = "particles/units/heroes/hero_razor/razor_plasmafield.vpcf"
		if self:GetCaster():HasModifier("modifier_imba_razor_eye_of_the_storm") then
			pfx = "particles/econ/items/razor/razor_ti6/razor_plasmafield_ti6.vpcf"
		end
		local nfx = ParticleManager:CreateParticle(pfx, PATTACH_POINT_FOLLOW, caster)
					ParticleManager:SetParticleControl(nfx, 0, caster:GetAbsOrigin())
					ParticleManager:SetParticleControl(nfx, 1, Vector(speed, maxRadius, 1))
		local enemyHit = {}
		local enemyHit2 = {}
		
		Timers:CreateTimer(0,
		function()
			if currentRadius < maxRadius and not self:IsNull() then		
				local enemies = self:FindEnemyUnitsInRing(caster,caster:GetAbsOrigin(), currentRadius+50, currentRadius-50 )
				for _, enemy in pairs(enemies) do
					if not enemyHit[enemy] then
						enemy:AddNewModifier_RS(caster, ability, "modifier_imba_razor_plasma_field_slow", {duration = dur})
						if (enemy:GetOrigin() - caster:GetOrigin()):Length2D() < 800 then
						local dir=TG_Direction(enemy:GetAbsOrigin(),caster:GetAbsOrigin())
						local dd = maxRadius-(enemy:GetOrigin() - caster:GetOrigin()):Length2D()
						Knockback.center_x =  enemy:GetAbsOrigin().x-dir.x
						Knockback.center_y =  enemy:GetAbsOrigin().y-dir.y
						Knockback.center_z =  enemy:GetAbsOrigin().z
						Knockback.duration = dd*kno_duration*1.3
						Knockback.knockback_distance =dd*kno*0.7
						enemy:AddNewModifier(caster,self, "modifier_knockback", Knockback)
						end
							damageTable.victim = enemy
							damageTable.damage = math.max(damage*(enemy:GetOrigin() - caster:GetOrigin()):Length2D(),0)+damage_min	
							self:Applydamage(damageTable)	

						enemyHit[enemy] = true
					end
				end
				currentRadius = currentRadius + maxRadius*FrameTime()
				return 0.03
			else
				if not self:IsNull() and currentRadius2 > 0 then
				ParticleManager:SetParticleControl(nfx, 1, Vector(-speed, maxRadius, 1))
				local enemies2 = self:FindEnemyUnitsInRing(caster,caster:GetAbsOrigin(), currentRadius2+50, currentRadius2-100 )
				for _, enemy in pairs(enemies2) do
					if not enemyHit2[enemy] then
						enemy:AddNewModifier_RS(caster, ability, "modifier_imba_razor_plasma_field_slow", {duration = dur})
						local dir=TG_Direction(enemy:GetAbsOrigin(),caster:GetAbsOrigin())
						Knockback.center_x =  enemy:GetAbsOrigin().x+dir.x
						Knockback.center_y =  enemy:GetAbsOrigin().y+dir.y
						Knockback.center_z =  enemy:GetAbsOrigin().z
						Knockback.duration = (enemy:GetOrigin() - caster:GetOrigin()):Length2D()*0.0003
						Knockback.knockback_distance =(enemy:GetOrigin() - caster:GetOrigin()):Length2D()*kno
						
						enemy:AddNewModifier(caster,self, "modifier_knockback", Knockback)
							damageTable.victim = enemy
							damageTable.damage = math.max(damage*(enemy:GetOrigin() - caster:GetOrigin()):Length2D(),0)+damage_min	
							self:Applydamage(damageTable)	
							
					if self:ShouldLink(enemy,ability_link) then
						ability_link:Onlink(caster,enemy,ability_link:GetSpecialValueFor("link_duration"),ability_link:GetSpecialValueFor("link_stack")/ability_link_stack,false)
					end
						enemyHit2[enemy] = true
					end
				end
				
				currentRadius2 = currentRadius2 - maxRadius*FrameTime()
				return 0.03
			end
			end
		end)
	self:AddParticle(nfx, false, false, 0, false, false)
	end 
end

function modifier_imba_razor_plasma_field:IsPurgeException()
	return false
end

function modifier_imba_razor_plasma_field:IsPurgable()
	return false
end

function modifier_imba_razor_plasma_field:IsHidden()
	return true
end

function modifier_imba_razor_plasma_field:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_imba_razor_plasma_field:FindEnemyUnitsInRing(caster,position, maxRadius, minRadius, hData)
	if not self:IsNull() then
		local team = caster:GetTeamNumber()
		local iTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
		local iType = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
		local iFlag = DOTA_UNIT_TARGET_FLAG_NONE
		local iOrder = FIND_ANY_ORDER
	
		local innerRing = FindUnitsInRadius(team, position, nil, minRadius, iTeam, iType, iFlag, iOrder, false)
		local outerRing = FindUnitsInRadius(team, position, nil, maxRadius, iTeam, iType, iFlag, iOrder, false)
		local resultTable = {}
		for _, unit in ipairs(outerRing) do
			if not unit:IsNull() then
				local addToTable = true
				for _, exclude in ipairs(innerRing) do
					if unit == exclude then
						addToTable = false
						break
					end
				end
				if addToTable then
					table.insert(resultTable, unit)
				end
			end
		end
		return resultTable
		
	else return {} end
end
function modifier_imba_razor_plasma_field:ShouldLink(enemy,ability)
	if not IsServer() then return end
	local enemy = enemy
	local ability = ability
	if ability~=nil then
	if enemy:IsAlive() and ability:GetLevel()>0 then
		local modifier = enemy:FindModifierByName("modifier_imba_razor_plasma_field_slow") 
		if modifier~=nil and self:GetCaster():HasModifier("modifier_imba_razor_eye_of_the_storm") then
			if modifier:GetStackCount() == 1 then 
				return true
			end
		end
	end
	end
	return false
end
function modifier_imba_razor_plasma_field:Applydamage(tab)
	if IsServer() then 
		ApplyDamage(tab)
		if tab.victim:IsAlive() and tab.victim:IsHero() and self:GetCaster():HasModifier("modifier_imba_razor_eye_of_the_storm") then
				self:GetCaster():PerformAttack(tab.victim, false, true, true, false, true, false, false)
		end
		if self.modifier~=nil and tab.victim:IsHero() then
			self.modifier:SetStackCount(math.min(self.modifier:GetStackCount()+1,self:GetCaster():GetLevel()*2))
		end
	end
end

--静电链接
imba_razor_static_link = class({})
LinkLuaModifier("modifier_imba_razor_static_link", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_razor_static_link_enemy", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_razor_static_link_buff", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_paralyzed", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_razor_static_link_att", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_razor_unstable_current_ampbuff", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
function imba_razor_static_link:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("link_duration") 
	local stack = (self:GetSpecialValueFor("link_stack")+caster:TG_GetTalentValue("special_bonus_imba_razor_2"))/2
	local att = true
	self:Onlink(caster,target,duration,stack,att)
end

function imba_razor_static_link:Onlink(caster,target,duration,stack,att)
	local caster = caster
	local target = target
	local duration = duration
	local att = att
	if target:TriggerSpellAbsorb( self ) then return end
	local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_static_link.vpcf", PATTACH_POINT_FOLLOW, caster)
					ParticleManager:SetParticleControlEnt(nfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_static", caster:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(nfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	if att == true then
		if caster:HasModifier("modifier_imba_razor_static_link_att") then
			caster:RemoveModifierByName("modifier_imba_razor_static_link_att")
		end
		if target:HasModifier("modifier_imba_razor_static_link") then
			target:RemoveModifierByName("modifier_imba_razor_static_link")
		end
		caster:AddNewModifier(target, self, "modifier_imba_razor_static_link_att", {duration = duration})
		
	end
	
	local main = target:AddNewModifier(caster, self, "modifier_imba_razor_static_link", {duration = duration, target = target:entindex(),stack = stack})
	main:AddParticle(nfx, false, false, 0, false, false)
	if att == true then 
		if main~=nil then
			main:SetStackCount(2)
		end
	end
end


modifier_imba_razor_static_link = class({})
function modifier_imba_razor_static_link:OnCreated(kv)
	if IsServer() then
		self.parent = self:GetParent()
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.duration_slow = self.ability:GetSpecialValueFor("duration_slow")
		self.duration = self.ability:GetSpecialValueFor("buff_duration")
		self.time = self.ability:GetSpecialValueFor("time")
		self.stack_count = 0
		self.stack = kv.stack
		self.buffer = 100
		self.link_radius =self.ability:GetSpecialValueFor("link_radius")
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_paralyzed", {duration = self.duration_slow})
			EmitSoundOn("Ability.static.start", self.caster)
			EmitSoundOn("Ability.static.loop", self.caster)
		self:StartIntervalThink(0.5)
	end 
end

function modifier_imba_razor_static_link:OnIntervalThink()
	if self.caster:IsAlive() and  self.parent:IsAlive() then
		local breakLink = (self.parent:GetOrigin() - self.caster:GetOrigin()):Length2D() < self.link_radius+self.caster:GetCastRangeBonus()
		if breakLink then
			self.stack_count = self.stack_count+1
			if math.fmod(self.stack_count,self.time*2) == 0 then
				self.parent:AddNewModifier_RS(self.caster, self.ability, "modifier_paralyzed", {duration = self.duration_slow})
				--print(tostring(self.caster:GetAttacksPerSecond()))
			end
			local debuff = self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_razor_static_link_enemy", {duration = self.duration})
			if debuff~=nil then
				debuff:SetStackCount(debuff:GetStackCount()+self.stack)
			end
			local buff = self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_razor_static_link_buff", {duration = self.duration})
			if buff~=nil then
				buff:SetStackCount(buff:GetStackCount()+self.stack)
			end
			--self.caster:PerformAttack(self.parent, false, true, true, false, true, false, false)
		else
			self:Destroy()
		end
	else
		self:Destroy()
	end
end


function modifier_imba_razor_static_link:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
		if self~=nil and self:GetParent()~=nil then
			if self.caster:HasModifier("modifier_imba_razor_static_link_att") then
				self.caster:RemoveModifierByName("modifier_imba_razor_static_link_att")
			end
		end
		StopSoundOn("Ability.static.start", self.caster)
		StopSoundOn("Ability.static.loop", self.caster)
	end
end

function modifier_imba_razor_static_link:IsPurgeException()
	return false
end

function modifier_imba_razor_static_link:IsPurgable()
	return false
end

function modifier_imba_razor_static_link:IsHidden()
	return true
end


modifier_imba_razor_static_link_att = class({})
function modifier_imba_razor_static_link_att:IsDebuff()
	return false
end
function modifier_imba_razor_static_link_att:IsPurgeException()
	return false
end
function modifier_imba_razor_static_link_att:IsHidden()
	return true
end
function modifier_imba_razor_static_link_att:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_ORDER
	}
end
function modifier_imba_razor_static_link_att:OnCreated(params)
	if not IsServer() then return end
	self.target	= self:GetCaster()
	self.caster = self:GetParent()
	self.bFocusing = true
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_razor_static_link_att:OnIntervalThink()
	if self.caster:AttackReady() and self.target and not self.target:IsNull() and self.target:IsAlive() and (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self.caster:Script_GetAttackRange() and self.bFocusing then
		self.caster:PerformAttack(self.target, true, true, false, true, true, false, false)
	end
	
end
function modifier_imba_razor_static_link_att:OnDestroy()
	self.target	= nil
	self.caster = nil
	if not IsServer() then return end
	self:StartIntervalThink(-1)
end
function modifier_imba_razor_static_link_att:OnOrder(keys)
	if keys.unit == self:GetParent() then
		if keys.order_type == DOTA_UNIT_ORDER_STOP or keys.order_type == DOTA_UNIT_ORDER_CONTINUE then
			self.bFocusing	= false
		else
			self.bFocusing	= true
		end
	end
end
---
modifier_paralyzed = class({})

function modifier_paralyzed:IsDebuff()			return true end
function modifier_paralyzed:IsHidden() 			return false end
function modifier_paralyzed:IsPurgable() 		return true end
function modifier_paralyzed:IsPurgeException() 	return true end
function modifier_paralyzed:GetEffectName() return "particles/basic_ambient/generic_paralyzed.vpcf" end
function modifier_paralyzed:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_paralyzed:ShouldUseOverheadOffset() return true end

function modifier_paralyzed:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_PROPERTY_MOVESPEED_LIMIT, MODIFIER_PROPERTY_MOVESPEED_MAX, MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT} end
function modifier_paralyzed:GetModifierMoveSpeed_Absolute() return 100 end
function modifier_paralyzed:GetModifierMoveSpeed_Limit() return 100 end
function modifier_paralyzed:GetModifierMoveSpeed_Max() return 100 end
function modifier_paralyzed:GetModifierBaseAttackTimeConstant() return 3.5 end


modifier_imba_razor_static_link_buff = class({})
function modifier_imba_razor_static_link_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function modifier_imba_razor_static_link_buff:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

function modifier_imba_razor_static_link_buff:IsDebuff()
	return false
end

function modifier_imba_razor_static_link_buff:GetEffectName()
	return "particles/units/heroes/hero_razor/razor_static_link_buff.vpcf"
end
function modifier_imba_razor_static_link_buff:IsPurgeException()
	return false
end
function modifier_imba_razor_static_link_buff:IsPurgable()
	return false
end

modifier_imba_razor_static_link_enemy = class({})
function modifier_imba_razor_static_link_enemy:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function modifier_imba_razor_static_link_enemy:GetModifierPreAttack_BonusDamage()
	return -self:GetStackCount()
end

function modifier_imba_razor_static_link_enemy:GetAttributes()
	return MODIFIER_ATTRIBUTE_NONE
end

function modifier_imba_razor_static_link_enemy:IsDebuff()
	return true
end

function modifier_imba_razor_static_link_enemy:GetEffectName()
	return "particles/units/heroes/hero_razor/razor_static_link_debuff.vpcf"
end
function modifier_imba_razor_static_link_enemy:IsPurgeException()
	return false
end
function modifier_imba_razor_static_link_enemy:IsPurgable()
	return false
end
---被动
imba_razor_unstable_current = class({})
LinkLuaModifier("modifier_imba_razor_unstable_current_passive", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_paralyzed", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_razor_unstable_current_ampbuff", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_razor_unstable_current_armor", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
function imba_razor_unstable_current:GetIntrinsicModifierName()
	return "modifier_imba_razor_unstable_current_passive"
end
function imba_razor_unstable_current:OnUpgrade()
	if IsServer() then
	local mod = self:GetCaster():FindModifierByName("modifier_imba_razor_unstable_current_passive")
	if mod then
		mod.chance = self:GetSpecialValueFor("chance")
		mod.damage = self:GetSpecialValueFor("damage")
	end
	end
end
function imba_razor_unstable_current:OnSpellStart()
	if IsServer() then
		self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
		local modifier = self:GetCaster():AddNewModifier(self:GetCaster(),self,"imba_razor_unstable_current_armor",{duration = -1})
		local mod = self:GetCaster():FindModifierByName("imba_razor_unstable_current_ampbuff") 
		if mod~=nil and modifier~=nil then
			modifier:SetStackCount(math.min(modifier:GetStackCount()+mod:GetStackCount()*(self:GetSpecialValueFor("sh")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_razor_6")),self:GetSpecialValueFor("max_sh")))
			mod:SetStackCount(0)
		end		
	end
end

modifier_imba_razor_unstable_current_passive = class({})
LinkLuaModifier("modifier_imba_razor_unstable_current", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_paralyzed", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_razor_unstable_current_ampbuff", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_razor_unstable_current_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_imba_razor_unstable_current_passive:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end
function modifier_imba_razor_unstable_current_passive:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.damage = self.ability:GetSpecialValueFor("damage")
	if IsServer() then
		self.damageTable =  {
							attacker = self.parent,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self.ability, --Optional.
							}
	end
	
end
function modifier_imba_razor_unstable_current_passive:OnAttackLanded(keys)
	
	if IsServer() and keys.target == self.parent and not keys.attacker:IsBuilding() and not keys.attacker:IsMagicImmune() then
		if PseudoRandom:RollPseudoRandom(self.ability,self.chance) then
		if self.parent:HasModifier("modifier_imba_razor_eye_of_the_storm") then
			self:Findenmy(keys.attacker)
		end
			self.damageTable.victim = keys.attacker
			self.damageTable.damage = self.damage
			self:Applydamage(self.damageTable)		
		end
	--self.caster:ReduceMana(self.caster:GetMaxMana()*0.01*self.attack_mana)
	end
end
function modifier_imba_razor_unstable_current_passive:OnAbilityFullyCast(params)
	if IsServer() then
		if not Is_Chinese_TG(params.unit,self.parent) then 
			local target = params.ability:GetCursorTarget() or nil 
			if target and target:IsAlive() and target == self.parent and params.unit:IsHero() and not params.unit:IsMagicImmune() then
				if self.parent:HasModifier("modifier_imba_razor_eye_of_the_storm") then
					self:Findenmy(params.unit)
				end
					self.damageTable.victim = params.unit
					self.damageTable.damage = self.damage							
					self:Applydamage(self.damageTable)
			end
			
		end
	end
end
function modifier_imba_razor_unstable_current_passive:Applydamage(tab)
	if not IsServer() then return end
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_unstable_current.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
	ParticleManager:SetParticleControlEnt(pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, tab.victim, PATTACH_POINT_FOLLOW, "attach_hitloc", tab.victim:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	tab.victim:Purge(true, false, false, false, false)
	tab.victim:AddNewModifier(self.parent, self:GetAbility(), "modifier_paralyzed", {duration = self:GetAbility():GetSpecialValueFor("duration")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_razor_5")})
	
	EmitSoundOn("Hero_Zuus.StaticField", self.parent)
	ApplyDamage(tab)
		local modifier = self.parent:AddNewModifier(self.parent, self:GetAbility(), "imba_razor_unstable_current_ampbuff", {duration = -1})
		if modifier ~= nil then
			modifier:SetStackCount(math.min(modifier:GetStackCount()+1,self:GetCaster():GetLevel()*2))
		end
end

function modifier_imba_razor_unstable_current_passive:Findenmy(enemy)
	if IsServer() then 
		local target = enemy
		local team  = self.caster:GetTeamNumber()
		local point = target:GetAbsOrigin()
		local radius = 400
		local enemies = FindUnitsInRadius(team, point, nil,radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _,enemy in pairs(enemies) do 
			if enemy~=nil and not enemy:IsMagicImmune() and enemy~=target then
				self.damageTable.victim = enemy
				self.damageTable.damage = self.damage							
				self:Applydamage(self.damageTable)
			end
		end
	
	end
end

function modifier_imba_razor_unstable_current_passive:IsHidden()
	return true
end



--电工buff
imba_razor_unstable_current_ampbuff = class({})
LinkLuaModifier("imba_razor_unstable_current_ampbuff", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)


function imba_razor_unstable_current_ampbuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
end

function imba_razor_unstable_current_ampbuff:GetModifierSpellAmplify_Percentage()
	return self:GetStackCount()
end
function imba_razor_unstable_current_ampbuff:IsDebuff()
	return false
end
function imba_razor_unstable_current_ampbuff:IsHidden()
	return false
end
function imba_razor_unstable_current_ampbuff:IsPurgable()
	return false
end
function imba_razor_unstable_current_ampbuff:IsPurgeException()
	return false
end
function imba_razor_unstable_current_ampbuff:RemoveOnDeath()
	return true
end
--电盾buff
imba_razor_unstable_current_armor = class({})
LinkLuaModifier("imba_razor_unstable_current_armor", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)

function imba_razor_unstable_current_armor:IsDebuff()
	return false
end
function imba_razor_unstable_current_armor:IsHidden()
	return false
end
function imba_razor_unstable_current_armor:IsPurgable()
	return false
end
function imba_razor_unstable_current_armor:IsPurgeException()
	return false
end

function imba_razor_unstable_current_armor:RemoveOnDeath()
	return true
end
function imba_razor_unstable_current_armor:DeclareFunctions()
	return {MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK}
end

function imba_razor_unstable_current_armor:GetEffectName() return "particles/econ/events/ti7/mjollnir_shield_ti7_beam_zap.vpcf" end
function imba_razor_unstable_current_armor:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function imba_razor_unstable_current_armor:OnCreated()
	if IsServer() then
		self:GetParent():EmitSound("DOTA_Item.Mjollnir.DeActivate")
	end
end


function imba_razor_unstable_current_armor:GetModifierTotal_ConstantBlock(keys)
	local stack = self:GetStackCount()
	self:SetStackCount(math.max(0, stack - math.max(0,keys.damage)))
	if self:GetStackCount() == 0 then self:Destroy() return end
	return stack
end



----风暴之眼
imba_razor_eye_of_the_storm = class({})
LinkLuaModifier("modifier_imba_razor_eye_of_the_storm", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_razor_eye_of_the_storm_debuff", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_razor_unstable_current_ampbuff", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
function imba_razor_eye_of_the_storm:OnSpellStart()
	local caster = self:GetCaster()
	EmitSoundOn("Hero_Razor.Storm.Cast", caster)
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
	caster:AddNewModifier(caster, self, "imba_razor_unstable_current_ampbuff", {duration = -1})
	caster:AddNewModifier(caster, self, "modifier_imba_razor_eye_of_the_storm", {duration = self:GetSpecialValueFor("duration")})
end

modifier_imba_razor_eye_of_the_storm = class({})
function modifier_imba_razor_eye_of_the_storm:OnCreated(table)
	if IsServer() then
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		
		self.interval = self.ability:GetSpecialValueFor("strike_interval")
		self.targets = self.caster:HasScepter() and self.ability:GetSpecialValueFor("scepter_target") or 1
		if self.caster:TG_HasTalent("special_bonus_imba_razor_4") then 
		self.targets = self.targets+self.caster:TG_GetTalentValue("special_bonus_imba_razor_4")
		end
		self.modifier = self.caster:FindModifierByName("imba_razor_unstable_current_ampbuff")
		self.damage = self.ability:GetSpecialValueFor("damage")
		self.duration =self.ability:GetSpecialValueFor("debuff_duration")
		self.damageTable = {
							attacker = self.parent,
							damage = self.damage,
							damage_type = self.ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self.ability, --Optional.
							}
		EmitSoundOn("Hero_Razor.Storm.Loop", self.caster)
		self:StartIntervalThink( self.interval ) 
	end 
end

function modifier_imba_razor_eye_of_the_storm:OnIntervalThink()

		local modifier = self.caster:AddNewModifier(self.caster, self:GetAbility(), "imba_razor_unstable_current_ampbuff", {duration = -1})
		if modifier ~= nil then
			modifier:SetStackCount(math.min(modifier:GetStackCount()+1,self.caster:GetLevel()*2))
		end
	local enmeys = self:Findenmys()	
		
	local ability = self:GetAbility()
	for _,enemy in pairs(enmeys) do
		EmitSoundOn("Hero_razor.lightning", enemy)
		if enemy~=nil and enemy:IsAlive() then 
			local duration = self.duration
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, self.caster:GetAbsOrigin() + Vector(0,0,500))
			ParticleManager:SetParticleControlEnt(iParticleID, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			self:AddParticle(iParticleID, false, false, 0, false, false)
			if not enemy:IsBuilding() then
				enemy:AddNewModifier(self.caster, self:GetAbility(), "modifier_imba_razor_eye_of_the_storm_debuff", {duration = duration})
			end
				self.damageTable.victim = enemy								
				self:Applydamage(self.damageTable)
		end
	end
end
function modifier_imba_razor_eye_of_the_storm:Findenmys()
	if IsServer() then
		if not self:IsNull() then 
		local targets = self.targets
		local enemytab = {}
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil,self.caster:Script_GetAttackRange()+self.caster:GetCastRangeBonus(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		for _,enemy in pairs(enemies) do
			if enemy:HasModifier("modifier_imba_razor_static_link") then
				local mod = enemy:FindModifierByName("modifier_imba_razor_static_link")
				if mod~=nil then				
					if mod:GetStackCount() == 2 then
					if not self:IsInTable(enemy,enemytab) then
					table.insert(enemytab, enemy)
					targets = targets -1
					if targets == 0 then return enemytab end
					end
					end
				end
			end
		end
		local enemies2 = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil,self.caster:Script_GetAttackRange()+self.caster:GetCastRangeBonus(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		for _,enemy in pairs(enemies2) do
			if not self:IsInTable(enemy,enemytab) then
			table.insert(enemytab, enemy)
			targets = targets -1
			if targets == 0 then return enemytab end
			end
		end
		
		local enemies3 = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil,self.caster:Script_GetAttackRange()+self.caster:GetCastRangeBonus(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		for _,enemy in pairs(enemies3) do
			if not self:IsInTable(enemy,enemytab) then
			table.insert(enemytab, enemy)
			targets = targets -1
			if targets == 0 then return enemytab end
			end
		end
		if self.caster:HasScepter() then
		local enemies3 = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil,self.caster:Script_GetAttackRange()+self.caster:GetCastRangeBonus(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		for _,enemy in pairs(enemies3) do
			if not self:IsInTable(enemy,enemytab) then
			table.insert(enemytab, enemy)
			targets = targets -1
			if targets == 0 then return enemytab end
			end
		end	
		end
		return enemytab
		else
		return {}
	end
	end
end

function modifier_imba_razor_eye_of_the_storm:IsInTable(value, tab)
	for k =1,#tab do
		if tab[k][1] == value
		then
			return true
    end
	end
	
    return false
end 
function modifier_imba_razor_eye_of_the_storm:Applydamage(tab)
	if IsServer() then
		ApplyDamage(tab)
		if self.modifier~=nil and tab.victim:IsHero() then
			self.modifier:SetStackCount(math.min(self.modifier:GetStackCount()+1,self.caster:GetLevel()*2))
		end 
	end
end

function modifier_imba_razor_eye_of_the_storm:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
		StopSoundOn("Hero_Razor.Storm.Loop", self.caster)
		EmitSoundOn("Hero_Razor.StormEnd", self.caster)
	end
end

function modifier_imba_razor_eye_of_the_storm:IsDebuff()
	return false
end

function modifier_imba_razor_eye_of_the_storm:GetEffectName()
	return "particles/units/heroes/hero_razor/razor_rain_storm.vpcf"
end

function modifier_imba_razor_eye_of_the_storm:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_imba_razor_eye_of_the_storm:IsPurgeException()
	return false
end
function modifier_imba_razor_eye_of_the_storm:IsPurgable()
	return false
end
modifier_imba_razor_eye_of_the_storm_debuff = class({})
function modifier_imba_razor_eye_of_the_storm_debuff:OnCreated()
	self.armor = self:GetAbility():GetSpecialValueFor("armor_reduction")
end

function modifier_imba_razor_eye_of_the_storm_debuff:OnRefresh()
	self:IncrementStackCount()
end


function modifier_imba_razor_eye_of_the_storm_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_imba_razor_eye_of_the_storm_debuff:GetModifierPhysicalArmorBonus()
	return -(self:GetStackCount() * self.armor)
end

function modifier_imba_razor_eye_of_the_storm_debuff:IsDebuff()
	return true
end

function modifier_imba_razor_eye_of_the_storm_debuff:IsPurgeException()
	return false
end
function modifier_imba_razor_eye_of_the_storm_debuff:IsPurgable()
	return false
end
imba_razor_whip = class({})
LinkLuaModifier("modifier_imba_razor_whip", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_razor_whip_enemy", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_razor_whip_buff", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_paralyzed", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_razor_whip_att", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_razor_unstable_current_ampbuff", "ting/hero_razor", LUA_MODIFIER_MOTION_NONE)

function imba_razor_whip:OnInventoryContentsChanged()
	if not IsServer() then return end
    if self:GetCaster():Has_Aghanims_Shard() then 
       self:SetHidden(false)
	   self:SetStolen(true)
--	   self:SetHidden(false)
       self:SetLevel(1)
    else
			self:SetHidden(true)
--			self:SetHidden(false)
			self:SetLevel(0)
			self:SetStolen(true)
    end
end

function imba_razor_whip:GetCastRange( vLocation, hTarget )
	if IsServer() then
		return self:GetCaster():Script_GetAttackRange()
	end
	
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end 
function imba_razor_whip:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local per = self:GetSpecialValueFor("per")
	local count = 0		
	local modifier =self:GetCaster():FindModifierByName("imba_razor_unstable_current_ampbuff")
	if modifier ~= nil then
	count = math.ceil(modifier:GetStackCount()/2)
	local mod = self:GetCaster():AddNewModifier(caster,self,"imba_razor_unstable_current_armor",{duration = -1})
	if mod ~= nil and caster:TG_HasTalent("special_bonus_imba_razor_3") then
		mod:SetStackCount(math.min(mod:GetStackCount()+count*per,6000))
	end
	end
	
	if target:TriggerSpellAbsorb( self ) then return end		
	EmitSoundOn("Hero_razor.lightning", caster)
	target:AddNewModifier(caster,self,"modifier_imba_stunned",{duration = 0.03})
	caster:PerformAttack(target, false, true, true, false, true, false, false)
	if count~=0 then
	local damageTable = {
							attacker = caster,
							damage = count*per,
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}	
	local point = GetGroundPosition(target:GetAbsOrigin(), target)	
	local particleName = "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf"
	local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, point)
		Timers:CreateTimer(0.4, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
						end)
					
	local particleName2 = "particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf"
	local pfx2 = ParticleManager:CreateParticle(particleName2, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx2, 0, point)
		Timers:CreateTimer(0.05, function()
			ParticleManager:DestroyParticle(pfx2, false)
			ParticleManager:ReleaseParticleIndex(pfx2)
							end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in ipairs(enemies) do
				if enemy~=nil and not enemy:IsMagicImmune() then
					damageTable.victim = enemy						
					self:Applydamage(damageTable,modifier,count)	
				end
				end
	if modifier~=nil then
			modifier:SetStackCount(math.max((modifier:GetStackCount()-count),0))
	end
	end
end
function imba_razor_whip:Applydamage(tab)
	if not IsServer() then return end
	ApplyDamage(tab)
		local modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "imba_razor_unstable_current_ampbuff", {duration = -1})
		if modifier ~= nil then
			modifier:SetStackCount(math.min(modifier:GetStackCount()+1,self:GetCaster():GetLevel()*2))
		end
end

