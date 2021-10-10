--2021.06.29 by你收拾收拾准备出林肯吧
CreateTalents("npc_dota_hero_spectre", "linken/hero_spectre")
function GetSplittingDagger(hero,gotime,cometime,target,damage)
	local caster = hero
	local ability = caster:FindAbilityByName("imba_spectre_splitting_dagger")
	local splitting_dagger = FindUnitsInRadius(
		caster:GetTeamNumber(), 
		caster:GetAbsOrigin(), 
		nil, 
		400, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
		FIND_ANY_ORDER, 
		false)
	for i=1, #splitting_dagger do
		if splitting_dagger[i]:HasModifier("modifier_imba_spectre_dagger_thinker") and not splitting_dagger[i]:HasModifier("modifier_imba_spectre_dagger_move_go") and not splitting_dagger[i]:HasModifier("modifier_imba_spectre_dagger_move_come") then
			splitting_dagger[i]:AddNewModifier(caster, ability, "modifier_imba_spectre_dagger_move_go", {duration = gotime, target = target:entindex(), damage = damage, cometime = cometime})
			--return	splitting_dagger[i]
			break
		end			
	end
end

imba_spectre_splitting_dagger = class({})
LinkLuaModifier("modifier_imba_spectre_dagger_passive", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spectre_dagger_thinker", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spectre_dagger_move_go", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE)  
LinkLuaModifier("modifier_imba_spectre_dagger_move_come", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE)  
LinkLuaModifier("modifier_imba_haunt_move", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_splitting_dagger_debuff", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE)  

function imba_spectre_splitting_dagger:GetIntrinsicModifierName() return "modifier_imba_spectre_dagger_passive" end
function imba_spectre_splitting_dagger:Set_InitialUpgrade(tg) 			
    return {LV=1} 
end
function imba_spectre_splitting_dagger:OnSpellStart()
end
modifier_imba_spectre_dagger_passive = class({})

function modifier_imba_spectre_dagger_passive:IsDebuff()				return false end
function modifier_imba_spectre_dagger_passive:IsHidden() 				return false end
function modifier_imba_spectre_dagger_passive:IsPurgable() 			return false end
function modifier_imba_spectre_dagger_passive:IsPurgeException() 		return false end
function modifier_imba_spectre_dagger_passive:OnCreated(keys)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()	
	if IsServer() then
		self.stack = 0
		if not self:GetParent():IsIllusion() then
			for i=1 , 4 do
				self.dummy = CreateUnitByName("npc_linken_unit", self.caster:GetAbsOrigin(), true, self.caster, self.caster, self.caster:GetTeamNumber())

				self.dummy:AddNewModifier(self.caster, self:GetAbility(), "modifier_rooted", {})

				self.dummy:AddNewModifier(self.caster, self.ability, "modifier_imba_spectre_dagger_thinker", {pos_int = i})

				self.dummy:AddNewModifier(self.caster, self:GetAbility(), "modifier_kill", {})	

				self.dummy:SetOriginalModel("models/items/spectre/spectre_arcana/spectre_arcana_dagger_fx.vmdl")
			end
		end
		self:OnIntervalThink()
		self:StartIntervalThink(0.1)	
	end	
end
function modifier_imba_spectre_dagger_passive:OnIntervalThink()
	self.stack = 0
	self:SetStackCount(self.stack)
	local splitting_dagger = FindUnitsInRadius(
		self.caster:GetTeamNumber(), 
		self.caster:GetAbsOrigin(), 
		nil, 
		400, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
		FIND_ANY_ORDER, 
		false)
	for i=1, #splitting_dagger do
		if splitting_dagger[i]:HasModifier("modifier_imba_spectre_dagger_thinker") and not splitting_dagger[i]:HasModifier("modifier_imba_spectre_dagger_move_go") and not splitting_dagger[i]:HasModifier("modifier_imba_spectre_dagger_move_come") then
			self.stack = self.stack + 1
			self:SetStackCount(self.stack)
		end	
	end	
end
modifier_imba_spectre_dagger_thinker = class({})

function modifier_imba_spectre_dagger_thinker:IsDebuff()				return false end
function modifier_imba_spectre_dagger_thinker:IsHidden() 				return false end
function modifier_imba_spectre_dagger_thinker:IsPurgable() 				return false end
function modifier_imba_spectre_dagger_thinker:IsPurgeException() 		return false end
function modifier_imba_spectre_dagger_thinker:CheckState() 
	return 
	{
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, 
	[MODIFIER_STATE_NO_HEALTH_BAR] = true, 
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	[MODIFIER_STATE_INVULNERABLE] = true, 
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
	[MODIFIER_STATE_UNSELECTABLE] = true, 
	[MODIFIER_STATE_DISARMED] = true, 
	[MODIFIER_STATE_OUT_OF_GAME] = true, 
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true
} 
end
function modifier_imba_spectre_dagger_thinker:OnCreated(keys)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	if keys then
		self.pos_int = keys.pos_int
	end		
	if IsServer() then
	   	self.pfx = ParticleManager:CreateParticle("particles/econ/items/lifestealer/lifestealer_immortal_backbone/lifestealer_immortal_backbone_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	    ParticleManager:SetParticleControlEnt(self.pfx, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	    ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	    self:AddParticle(self.pfx, false, false, -1, true, false)
		self.int = 0		
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_spectre_dagger_thinker:OnRefresh(keys)
	self:OnCreated(keys)
end
function modifier_imba_spectre_dagger_thinker:OnIntervalThink() 
	self.int = self.int + FrameTime()
	if self.int > 120 then
		self.int = 0
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
			self:OnRefresh()
		end		
	end	
	if not self.parent:HasModifier("modifier_imba_spectre_dagger_move_go") and not self.parent:HasModifier("modifier_imba_spectre_dagger_move_come") and not self.parent:HasModifier("modifier_imba_haunt_move") then
		local caster_pos = self.caster:GetAbsOrigin()
		local parent_pos = self.parent:GetAbsOrigin()
		local start_pos = caster_pos - self.caster:GetForwardVector() * 100
		self.pos_1 = start_pos + (self.caster:GetRightVector() * -35) 	+ Vector(0,0,100)
		self.pos_2 = start_pos + (self.caster:GetRightVector() * 35) 	+ Vector(0,0,100)
		self.pos_3 = start_pos + (self.caster:GetRightVector() * -100) 	+ Vector(0,0,50)
		self.pos_4 = start_pos + (self.caster:GetRightVector() * 100) 	+ Vector(0,0,50)
		if self.pos_int == 1 then
			self.parent:SetAbsOrigin(self.pos_1)	 
		elseif 	self.pos_int == 2 then
			self.parent:SetAbsOrigin(self.pos_2)
		elseif 	self.pos_int == 3 then
			self.parent:SetAbsOrigin(self.pos_3)
		elseif 	self.pos_int == 4 then
			self.parent:SetAbsOrigin(self.pos_4)
		end	

		self.parent:SetForwardVector(TG_Direction(self.caster:GetAbsOrigin()+self.caster:GetForwardVector()*150,self.parent:GetAbsOrigin()))	

		if not self.caster:IsAlive() then
			self.parent:AddNoDraw()
		else
			self.parent:RemoveNoDraw()
		end
	end		
end
function modifier_imba_spectre_dagger_thinker:OnDestroy() 
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end												
	end	
end
modifier_imba_spectre_dagger_move_go = class({})

function modifier_imba_spectre_dagger_move_go:OnCreated(keys)
	self.caster = self:GetCaster()
	if IsServer() then
		self.target = EntIndexToHScript(keys.target)
		self.time = keys.cometime
		self.damage = keys.damage
		EmitSoundOn("Hero_Spectre.Attack",self:GetParent() )
		self:OnIntervalThink()	
		self:StartIntervalThink(FrameTime())

	end 
end	
function modifier_imba_spectre_dagger_move_go:OnIntervalThink()
	local total_ticks = self:GetDuration() / FrameTime()
	local direction = TG_Direction(self.target:GetAbsOrigin(),self:GetParent():GetAbsOrigin())
	
	local distance = (TG_Distance(self.caster:GetAbsOrigin(),self.target:GetAbsOrigin())) / total_ticks
	local next_pos = self:GetParent():GetAbsOrigin() + direction * distance

	self:GetParent():SetOrigin(next_pos)
	self:GetParent():SetForwardVector(direction)
	if not self.target:IsAlive() then
		self:Destroy()
	end	
end
function modifier_imba_spectre_dagger_move_go:OnRemoved()
	if IsServer() then
		ApplyDamage(
			{attacker = self.caster, 
			victim = self.target, 
			damage = self.damage, 
			damage_type = DAMAGE_TYPE_PURE, 
			ability = self:GetAbility()}
			)
		self.target:AddNewModifier_RS(self.caster, self:GetAbility(), "modifier_imba_splitting_dagger_debuff", {duration = self:GetAbility():GetSpecialValueFor("duration")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_spectre_8")})
		if self.target:IsAlive() and not self.caster:HasModifier("modifier_imba_haunt") then
			self:GetParent():AddNewModifier(self.caster, nil, "modifier_imba_spectre_dagger_move_come", {duration = self.time, target = self.target:entindex()})
		end
		local ability = self.caster:FindAbilityByName("imba_spectre_haunt")
		if self.caster:HasModifier("modifier_imba_haunt") then
			local enemy = FindUnitsInRadius(
				self.caster:GetTeamNumber(), 
				self.caster:GetAbsOrigin(), 
				nil, 
				ability:GetSpecialValueFor("radius"), 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO, 
				DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
				FIND_ANY_ORDER, 
				false)
			for i=1, #enemy do
				if 	enemy[i] ~= self.target and #enemy >= 2 then		
					self:GetParent():AddNewModifier(self.caster, self:GetAbility(), "modifier_imba_haunt_move", {duration = self.time, target = self.target:entindex(),next_target = enemy[i]:entindex(), damage = self.damage})
					break
				else
					self:GetParent():AddNewModifier(self.caster, self:GetAbility(), "modifier_imba_spectre_dagger_move_come", {duration = 0.5, target = self.target:entindex()})	
					break	
				end	
			end	
		end		
	end
end
modifier_imba_spectre_dagger_move_come = class({})

function modifier_imba_spectre_dagger_move_come:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	if IsServer() then
		EmitSoundOn("Hero_Spectre.Attack",self:GetParent() )
		self.target = EntIndexToHScript(keys.target)
		self.int = 0	
		self.angle  = 180
		local x = math.random(0,1)
		if x == 1 then
			self.angle  = -180
		end	
		self:OnIntervalThink()	
		self:StartIntervalThink(FrameTime())

	end 
end	
function modifier_imba_spectre_dagger_move_come:OnIntervalThink(keys)

	local self_pos = self.target:GetAbsOrigin()
	local caster_pos = self.caster:GetAbsOrigin() - TG_Direction(self_pos,self.caster:GetAbsOrigin()) * 150
	local total_ticks = self:GetDuration() / FrameTime()
	local current_pos = self.parent:GetAbsOrigin()			
	local midpoint = caster_pos + TG_Direction(self_pos,caster_pos) * TG_Distance(caster_pos,self_pos) / 2
	--local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local angle = self.angle / total_ticks + (self.int * self.angle / total_ticks)
	self.int = self.int + 1
	local new_pos_1 = GetGroundPosition(RotatePosition(midpoint, QAngle(0,angle,0), self_pos), self:GetParent())
	--new_pos_1.z = new_pos_1.z - 4 * 500 * motion_progress ^ 2 + 4 * 500 * motion_progress
	--DebugDrawCircle(new_pos_1, Vector(255,0,0), 100, 50, true, 5.3)
	--DebugDrawCircle(midpoint, Vector(255,0,0), 100, 50, true, 5.3)
	self:GetParent():SetForwardVector(TG_Direction(new_pos_1,current_pos))
	self:GetParent():SetOrigin(new_pos_1)
	if not self.target:IsAlive() then
		self:Destroy()
	end				
end	
function modifier_imba_spectre_dagger_move_come:OnRemoved()
	if IsServer() then
	end
end
modifier_imba_haunt_move = class({})

function modifier_imba_haunt_move:OnCreated(keys)
	self.parent = self:GetParent()
	self.caster = self:GetCaster()		
	if IsServer() then
		self.target = EntIndexToHScript(keys.target)
		self.next_target = EntIndexToHScript(keys.next_target)
		self.damage = keys.damage			
		self.int = 0	
		self.angle  = 180
		local x = math.random(0,1)
		if x == 1 then
			self.angle  = -180
		end
		EmitSoundOn("Hero_Spectre.Attack",self:GetParent() )	
		self:OnIntervalThink()	
		self:StartIntervalThink(FrameTime())

	end 
end	
function modifier_imba_haunt_move:OnIntervalThink(keys)

	local self_pos = self.target:GetAbsOrigin()
	local current_pos = self.parent:GetAbsOrigin()
	local caster_pos = self.next_target:GetAbsOrigin()
	local total_ticks = self:GetDuration() / FrameTime()			
	local midpoint = caster_pos + TG_Direction(self_pos,caster_pos) * TG_Distance(caster_pos,self_pos) / 2

	local angle = self.angle / total_ticks + (self.int * self.angle / total_ticks)
	self.int = self.int + 1
	local new_pos_1 = GetGroundPosition(RotatePosition(midpoint, QAngle(0,angle,0), self_pos), self:GetParent())

	self:GetParent():SetForwardVector(TG_Direction(new_pos_1,current_pos))
	self:GetParent():SetOrigin(new_pos_1)
	if not self.target:IsAlive() then
		self:Destroy()
	end				
end	
function modifier_imba_haunt_move:OnRemoved()
	if IsServer() then
		ApplyDamage(
			{attacker = self.caster, 
			victim = self.target, 
			damage = self.damage, 
			damage_type = DAMAGE_TYPE_PURE, 
			ability = self:GetAbility()}
			)
		self.target:AddNewModifier_RS(self.caster, self:GetAbility(), "modifier_imba_splitting_dagger_debuff", {duration = self:GetAbility():GetSpecialValueFor("duration")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_spectre_8")})		
		if self.caster:HasModifier("modifier_imba_haunt") then
			local ability = self.caster:FindAbilityByName("imba_spectre_haunt")
			local enemy = FindUnitsInRadius(
				self.caster:GetTeamNumber(), 
				self.caster:GetAbsOrigin(), 
				nil, 
				ability:GetSpecialValueFor("radius"), 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO, 
				DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
				FIND_ANY_ORDER, 
				false)
			for i=1, #enemy do
				if 	enemy[i] ~= self.target and #enemy >= 2 then		
					self:GetParent():AddNewModifier(self.caster, self:GetAbility(), "modifier_imba_haunt_move", {duration = 0.5, target = self.next_target:entindex(),next_target = enemy[i]:entindex(), damage = self.damage})
					break
				else
					self:GetParent():AddNewModifier(self.caster, self:GetAbility(), "modifier_imba_spectre_dagger_move_come", {duration = 0.5, target = self.next_target:entindex()})	
					break	
				end	
			end
		else
			self:GetParent():AddNewModifier(self.caster, self:GetAbility(), "modifier_imba_spectre_dagger_move_come", {duration = 0.5, target = self.next_target:entindex()})	
		end				
	end
end

modifier_imba_splitting_dagger_debuff = class({})

function modifier_imba_splitting_dagger_debuff:IsDebuff()				return true end
function modifier_imba_splitting_dagger_debuff:IsHidden() 			return false end
function modifier_imba_splitting_dagger_debuff:IsPurgable() 			return false end
function modifier_imba_splitting_dagger_debuff:IsPurgeException() 	return false end
function modifier_imba_splitting_dagger_debuff:CheckState()
	if self:GetStackCount() == -1 then
		return {[MODIFIER_STATE_INVISIBLE] = false } 
	end	
end
function modifier_imba_splitting_dagger_debuff:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_splitting_dagger_debuff:GetModifierProvidesFOWVision()
	if self:GetStackCount() == -1 then 
		return 1
	end
	return 0		 
end
function modifier_imba_splitting_dagger_debuff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
        MODIFIER_EVENT_ON_ABILITY_START,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
   	} 
end
function modifier_imba_splitting_dagger_debuff:GetModifierIncomingDamage_Percentage(keys)
	if keys.damage_type == 4 then 
  		return self.add_pure
  	end	
	return 0
end
function modifier_imba_splitting_dagger_debuff:OnAbilityStart(keys)
	if not IsServer() then
		return 0
	end
	if self:GetStackCount() == -1 then	
		local ability_caster = keys.ability:GetCaster()
		if keys.target == self:GetParent() and not IsEnemy(ability_caster,self:GetParent()) then
			ability_caster:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.01})
			local cd = (keys.ability:GetCooldown(keys.ability:GetLevel() - 1)) * ability_caster:GetCooldownReduction() + self:GetCaster():TG_GetTalentValue("special_bonus_imba_spectre_7")
			if cd == nil or cd == 0 then
				cd = 25 + self:GetCaster():TG_GetTalentValue("special_bonus_imba_spectre_7")
			end	
			keys.ability:StartCooldown(cd)
			ability_caster:Stop()
			EmitSoundOn("DOTA_Item.LinkensSphere.Activate",self:GetParent() ) 
			local cast_pfx = ParticleManager:CreateParticle("particles/heros/spe/spe_sphere_rings.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
			--ParticleManager:SetParticleControlEnt(cast_pfx, 0, keys.target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(cast_pfx, 0, keys.target:GetAbsOrigin()+Vector(0, 0, 100))
			ParticleManager:ReleaseParticleIndex(cast_pfx)		
		end
	end		
end
function modifier_imba_splitting_dagger_debuff:OnCreated(keys)
	self.stack = self:GetAbility():GetSpecialValueFor("stack")	
	self.add_pure = self:GetAbility():GetSpecialValueFor("add_pure")
	if IsServer() then
		self:SetStackCount(1)
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/planeshift/void_spirit_planeshift_spells_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(math.floor(self:GetStackCount() / 10 % 10), self:GetStackCount() % 10, 0))
		self:AddParticle(self.pfx, false, false, -1, false, false)		
	end	
end
function modifier_imba_splitting_dagger_debuff:OnRefresh()
	if IsServer() then
		if self:GetStackCount() >= self.stack - 1 then 
			self:SetStackCount(-1)
		elseif self:GetStackCount() < self.stack and self:GetStackCount() ~= -1 then
			self:IncrementStackCount()
		end
	end
end
function modifier_imba_splitting_dagger_debuff:OnStackCountChanged(iStack)
	if IsServer() and self.pfx then
		if self:GetStackCount() ~= -1 then
			ParticleManager:SetParticleControl(self.pfx, 1, Vector(math.floor(self:GetStackCount() / 10 % 10), self:GetStackCount() % 10, 0))
		elseif self:GetStackCount() == -1 and not self.cast_pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
			local cast_pfx = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_minigame_v2_death_target.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(cast_pfx, 0, self:GetParent():GetAbsOrigin()+Vector(0, 0, 100))
			ParticleManager:SetParticleControl(cast_pfx, 1, self:GetParent():GetAbsOrigin()+Vector(0, 0, 100))
			ParticleManager:ReleaseParticleIndex(cast_pfx)

			self.cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_desolate_debuff.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(self.cast_pfx, 0, self:GetParent():GetAbsOrigin()+Vector(0, 0, 300))
			ParticleManager:SetParticleControl(self.cast_pfx, 1, self:GetParent():GetAbsOrigin()+Vector(0, 0, 300))
			EmitSoundOn("Hero_Nevermore.Shadowraze",self:GetParent() ) 
			--ParticleManager:ReleaseParticleIndex(self.cast_pfx)			
			--self:OnIntervalThink()		
			--self:StartIntervalThink(1.0)						
		end		
	end	
end
--function modifier_imba_splitting_dagger_debuff:OnIntervalThink()	
--end
function modifier_imba_splitting_dagger_debuff:OnDestroy() 
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
		if self.cast_pfx then
			ParticleManager:DestroyParticle(self.cast_pfx, false)
			ParticleManager:ReleaseParticleIndex(self.cast_pfx)
		end													
	end	
end
imba_spectre_spectral_dagger = class({})

LinkLuaModifier("modifier_imba_spectral_dagger_debuff", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spectral_dagger_aura", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_spectral_dagger_buff", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE)
function imba_spectre_spectral_dagger:IsHiddenWhenStolen() 		return true end
function imba_spectre_spectral_dagger:IsStealable() 			return false end
function imba_spectre_spectral_dagger:OnSpellStart()	
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local pos = self:GetCursorPosition()
	local speed = self:GetSpecialValueFor("speed")
	local path_radius = self:GetSpecialValueFor("path_radius")
		
	if not target then
		self.dummy = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 50.0}, pos, caster:GetTeamNumber(), false)
		target = self.dummy
		pos = target:GetAbsOrigin()
	end
	self.dagger_path_duration = self:GetSpecialValueFor("dagger_path_duration")
	self.slow_duration = self:GetSpecialValueFor("slow_duration")
	
	caster:AddNewModifier(caster, self, "modifier_imba_spectral_dagger_buff", {duration = self.slow_duration})
	local sound = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 50.0}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
	sound:AddNewModifier(self:GetCaster(), self, "modifier_imba_spectral_dagger_aura", {duration = self.slow_duration})
	sound:EmitSound("Hero_Spectre.DaggerCast")
	EmitSoundOn("Hero_Spectre.DaggerCast",self:GetCaster())		
		
	local info = 
	{
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName ="particles/units/heroes/hero_spectre/spectre_spectral_dagger_tracking.vpcf",
		iMoveSpeed = speed,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bDrawsOnMinimap = false,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
		ExtraData = {sound = sound:entindex()},
	}
	TG_CreateProjectile({id = 1, team = caster:GetTeamNumber() , owner = caster, p = info})
	--ProjectileManager:CreateTrackingProjectile(info)
	    		
end

function imba_spectre_spectral_dagger:OnProjectileThink_ExtraData(pos, keys)
	if keys.sound and not EntIndexToHScript(keys.sound):IsNull() then
		EntIndexToHScript(keys.sound):SetAbsOrigin(pos)
	end
	AddFOWViewer(self:GetCaster():GetTeamNumber(), pos, 200, self.dagger_path_duration, false)
end

function imba_spectre_spectral_dagger:OnProjectileHit_ExtraData(target, location, keys)
	if target and keys.sound then
		local sound=EntIndexToHScript(keys.sound)
		--sound:StopSound("Hero_Puck.Illusory_Orb")
		sound:ForceKill(false)
		local ability = self:GetCaster():FindAbilityByName("imba_spectre_splitting_dagger")
		if ability and self:GetCaster():Has_Aghanims_Shard() and target:IsHero() then
			target:AddNewModifier_RS(self:GetCaster(), ability, "modifier_imba_splitting_dagger_debuff", {duration = ability:GetSpecialValueFor("duration")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_spectre_8")})
			target:SetModifierStackCount("modifier_imba_splitting_dagger_debuff",nil,-1)
		end	
		target:AddNewModifier_RS(self:GetCaster(), self, "modifier_imba_spectral_dagger_aura", {duration = self.slow_duration})
		if not target:IsHero() then
			local pfx = ParticleManager:CreateParticle("particles/creatures/spectre/spectre_active_dispersion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin())
			--self:AddParticle(self.pfx, true, false, 15, false, false)
			Timers:CreateTimer(self.slow_duration, function()
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:ReleaseParticleIndex(pfx)
				return nil
			end)
		end	
		EmitSoundOn("Hero_Spectre.DaggerImpact",target)								
		return true
	end
end	
modifier_imba_spectral_dagger_aura = class({})
function modifier_imba_spectral_dagger_aura:IsDebuff()			return IsEnemy(self.caster,self.parent) end
function modifier_imba_spectral_dagger_aura:IsHidden() 			return true end
function modifier_imba_spectral_dagger_aura:IsPurgable() 			return false end
function modifier_imba_spectral_dagger_aura:IsPurgeException() 	return false end
function modifier_imba_spectral_dagger_aura:IsAura()
	return true
end
function modifier_imba_spectral_dagger_aura:GetAuraDuration() return 0.1 end
function modifier_imba_spectral_dagger_aura:GetModifierAura() return "modifier_imba_spectral_dagger_debuff" end
function modifier_imba_spectral_dagger_aura:IsAuraActiveOnDeath() 		return false end
function modifier_imba_spectral_dagger_aura:GetAuraRadius() 
	if not self.parent:IsHero() then
		return self.ability:GetSpecialValueFor("path_radius")
	end	
	return self.radius 
end
function modifier_imba_spectral_dagger_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_spectral_dagger_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_imba_spectral_dagger_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_spectral_dagger_aura:GetAuraEntityReject(hTarget)	
	return not self:GetAbility():IsTrained()
end
function modifier_imba_spectral_dagger_aura:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
	self.radius = self.ability:GetSpecialValueFor("radius")
	if IsServer() then
		if not self.parent:IsHero() then
			self.radius = self.ability:GetSpecialValueFor("path_radius")
		end			
		self.pfx = ParticleManager:CreateParticle("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.radius, 0, 0))
		ParticleManager:SetParticleControl(self.pfx, 2, Vector(10, 0, 0))
		ParticleManager:SetParticleControl(self.pfx, 3, Vector(100, 0, 0))
		ParticleManager:SetParticleControl(self.pfx, 15, Vector(255, 155, 55))
		self:AddParticle(self.pfx, true, false, 15, false, false)
	end
end
function modifier_imba_spectral_dagger_aura:OnRemoved()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end			
	end
end
modifier_imba_spectral_dagger_debuff = class({})

function modifier_imba_spectral_dagger_debuff:IsDebuff()			return IsEnemy(self.caster,self.parent) end
function modifier_imba_spectral_dagger_debuff:IsHidden() 			return false end
function modifier_imba_spectral_dagger_debuff:IsPurgable() 			return false end
function modifier_imba_spectral_dagger_debuff:IsPurgeException() 	return false end
function modifier_imba_spectral_dagger_debuff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

   	} 
end
function modifier_imba_spectral_dagger_debuff:CheckState()
	if not self:IsDebuff() then 
		return 
		{
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		}
	end	  
end
function modifier_imba_spectral_dagger_debuff:GetModifierMoveSpeedBonus_Percentage()
	if self:IsDebuff() then 
		return (0 - self.bonus_movespeed) 
	end
	return	self.bonus_movespeed
end
function modifier_imba_spectral_dagger_debuff:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
	self.dagger_path_duration = self.ability:GetSpecialValueFor("dagger_path_duration")
	if IsServer() then
		if IsEnemy(self.caster, self.parent) then
			local damage = self.ability:GetSpecialValueFor("damage") + self.caster:TG_GetTalentValue("special_bonus_imba_spectre_4")	
			local damageTable = {
								victim = self.parent,
								attacker = self:GetCaster(),
								damage = damage,
								damage_type = self.ability:GetAbilityDamageType(),
								ability = self.ability,
								damage_flags = DOTA_DAMAGE_FLAG_NONE,
								}
			ApplyDamage(damageTable)
			self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_spectral_dagger_buff", {duration = self.dagger_path_duration})
			EmitSoundOn("Hero_Spectre.DaggerImpact",self.parent)
		end			 
	end
end
modifier_imba_spectral_dagger_buff = class({})

function modifier_imba_spectral_dagger_buff:IsDebuff()			return IsEnemy(self.caster,self.parent) end
function modifier_imba_spectral_dagger_buff:IsHidden() 			return false end
function modifier_imba_spectral_dagger_buff:IsPurgable() 			return false end
function modifier_imba_spectral_dagger_buff:IsPurgeException() 	return false end
function modifier_imba_spectral_dagger_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

   	} 
end
function modifier_imba_spectral_dagger_buff:CheckState()
	if not self:IsDebuff() then 
		return 
		{
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		}
	end	  
end
function modifier_imba_spectral_dagger_buff:GetModifierMoveSpeedBonus_Percentage()
	if self:IsDebuff() then 
		return (0 - self.bonus_movespeed) 
	end
	return	self.bonus_movespeed
end
function modifier_imba_spectral_dagger_buff:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
	if IsServer() then
		 
	end
end
imba_spectre_desolate = class({})
LinkLuaModifier("modifier_imba_desolate_passive", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_desolate_buff", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE)
function imba_spectre_desolate:GetIntrinsicModifierName() return "modifier_imba_desolate_passive" end
function imba_spectre_desolate:GetBehavior()
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_spectre_1") then 
		return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end
function imba_spectre_desolate:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_spectre_1") then 
		return 30
	end
	return 0
end
function imba_spectre_desolate:IsHiddenWhenStolen() 		return true end
function imba_spectre_desolate:IsStealable() 			return false end
function imba_spectre_desolate:OnSpellStart()
	self.caster = self:GetCaster()
	local ability = self.caster:FindAbilityByName("imba_spectre_dispersion")
	if ability then
		ability:StartCooldown(30)
	end		
	self.caster:AddNewModifier(self.caster, self, "modifier_imba_desolate_buff", {duration = 5})
end
modifier_imba_desolate_buff = class({})

function modifier_imba_desolate_buff:IsDebuff()				return false end
function modifier_imba_desolate_buff:IsHidden() 			return false end
function modifier_imba_desolate_buff:IsPurgable() 			return false end
function modifier_imba_desolate_buff:IsPurgeException() 	return false end

modifier_imba_desolate_passive = class({})

function modifier_imba_desolate_passive:IsDebuff()			return false end
function modifier_imba_desolate_passive:IsHidden() 			return true end
function modifier_imba_desolate_passive:IsPurgable() 			return false end
function modifier_imba_desolate_passive:IsPurgeException() 	return false end
function modifier_imba_desolate_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED, 
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		}
end
function modifier_imba_desolate_passive:OnCreated()
	self.ability = self:GetAbility()
	self.as_bonus = self.ability:GetSpecialValueFor("attack_speed_bonus_pct")
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.damage = self.ability:GetSpecialValueFor("bonus_damage") + self.caster:TG_GetTalentValue("special_bonus_imba_spectre_4")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.add_pure = self.ability:GetSpecialValueFor("add_pure")
	if IsServer() then	
	end
end
function modifier_imba_desolate_passive:OnRefresh()
	self:OnCreated()
end
function modifier_imba_desolate_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_imba_desolate_passive:GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.damage_type == 4 then 
  		return self.add_pure
  	end
  	return 0	 
end
function modifier_imba_desolate_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self.parent or self.parent:PassivesDisabled() or not keys.target:IsAlive() or not keys.target:IsUnit() then
		return
	end
	local target = keys.target
	local radius = self.radius
	if self.caster:HasModifier("modifier_imba_desolate_buff") then 
		radius = self.radius - self.radius * (self.caster:TG_GetTalentValue("special_bonus_imba_spectre_1") / 100)
	end
	local damage = self.damage + self.caster:TG_GetTalentValue("special_bonus_imba_spectre_5") 
	local enemy = FindUnitsInRadius(
		target:GetTeamNumber(), 
		target:GetAbsOrigin(), 
		nil, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
		)
	for i=1, #enemy do
		local damageTable = {
							victim = enemy[i],
							attacker = self.caster,
							damage = damage,
							damage_type = self.ability:GetAbilityDamageType(),
							ability = self.ability,
							damage_flags = DOTA_DAMAGE_FLAG_NONE,
							}
		damageTable.damage = damage / #enemy		
		ApplyDamage(damageTable)
	end
	if not self.parent:IsIllusion() then	
		GetSplittingDagger(self.caster,0.25,0.25,target,0)
	end

	target:EmitSound("Hero_Clinkz.SearingArrows.Impact")
end
imba_spectre_dispersion = class({})

LinkLuaModifier("modifier_imba_dispersion_passive", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dispersion_buff", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE)

function imba_spectre_dispersion:GetIntrinsicModifierName() return "modifier_imba_dispersion_passive" end
function imba_spectre_dispersion:GetBehavior()
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_spectre_2") then 
		return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end
function imba_spectre_dispersion:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_spectre_2") then 
		return 30
	end
	return 0
end
function imba_spectre_dispersion:IsHiddenWhenStolen() 		return true end
function imba_spectre_dispersion:IsStealable() 			return false end
function imba_spectre_dispersion:OnSpellStart()
	self.caster = self:GetCaster()
	local ability = self.caster:FindAbilityByName("imba_spectre_desolate")
	if ability then
		ability:StartCooldown(30)
	end	
	self.caster:AddNewModifier(self.caster, self, "modifier_imba_dispersion_buff", {duration = 5})



	self.caster:RemoveModifierByName("modifier_imba_dispersion_passive")
	self.caster:AddNewModifier(self.caster, self, "modifier_imba_dispersion_passive", {})

end
modifier_imba_dispersion_buff = class({})

function modifier_imba_dispersion_buff:IsDebuff()			return false end
function modifier_imba_dispersion_buff:IsHidden() 			return false end
function modifier_imba_dispersion_buff:IsPurgable() 		return false end
function modifier_imba_dispersion_buff:IsPurgeException() 	return false end

modifier_imba_dispersion_passive = class({})

function modifier_imba_dispersion_passive:IsDebuff()			return false end
function modifier_imba_dispersion_passive:IsHidden() 			return true end
function modifier_imba_dispersion_passive:IsPurgable() 			return false end
function modifier_imba_dispersion_passive:IsPurgeException() 	return false end
function modifier_imba_dispersion_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE, 
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_AVOID_DAMAGE 
		}
end
function modifier_imba_dispersion_passive:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.damage_reflection_pct = self.ability:GetSpecialValueFor("damage_reflection_pct")
	self.add_pure = self.ability:GetSpecialValueFor("add_pure")
	self.min_radius = self.ability:GetSpecialValueFor("min_radius")
	self.max_radius = self.ability:GetSpecialValueFor("max_radius")	
	self.hp_int = self.ability:GetSpecialValueFor("hp_int")	
	if IsServer() then	
	end
end
function modifier_imba_dispersion_passive:OnRefresh()
	self:OnCreated()
end
function modifier_imba_dispersion_passive:GetModifierAvoidDamage(keys)
	if self.caster:TG_HasTalent("special_bonus_imba_spectre_6") and (bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS) then
		return 1
	end
end
function modifier_imba_dispersion_passive:GetModifierIncomingDamage_Percentage(keys)
	if not self:GetParent():PassivesDisabled() then		
		if keys.damage_type == 4 then 
	  		return 0 - self.damage_reflection_pct + self.add_pure
	  	end	
		return 0 - self.damage_reflection_pct
	end
	return 0	
end

function modifier_imba_dispersion_passive:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() or not keys.attacker:IsUnit() or keys.attacker:IsBoss() or self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
	end
	--PrintTable(keys)
	local caster = self:GetCaster()
	local attacker = keys.attacker
	local ability = self:GetAbility()
	local min_radius = self.min_radius
	local max_radius = self.max_radius	
	if caster:HasModifier("modifier_imba_dispersion_buff") then 
		min_radius = self.min_radius + self.min_radius * (caster:TG_GetTalentValue("special_bonus_imba_spectre_2") / 100)
		max_radius = self.max_radius + self.max_radius * (caster:TG_GetTalentValue("special_bonus_imba_spectre_2") / 100)	
	end
	local damage_reflection_pct = self.damage_reflection_pct 	
	local damage_origin = keys.original_damage * (damage_reflection_pct / 100)
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),	
		nil,	
		max_radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	
		0,	
		false
	)		
	for _, enemy in pairs(enemies) do
		local damage_table = ({
			victim = enemy,
			attacker = caster,
			ability = ability,
			damage = damage_origin,
			damage_type = keys.damage_type,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_HPLOSS
		})
		local distance = math.min(math.max(TG_Distance(enemy:GetAbsOrigin(),caster:GetAbsOrigin()), min_radius),max_radius)
		local int = (max_radius - distance) * (1 / (max_radius-min_radius))			
		damage_table.damage = damage_origin * int
		ApplyDamage(damage_table)
	end
	if keys.damage > self.caster:GetMaxHealth() * (self.hp_int / 100) then	
		GetSplittingDagger(self.caster,0.8,0.5,attacker,keys.damage)
		local pfx = ParticleManager:CreateParticle("particles/creatures/spectre/spectre_active_dispersion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, self:GetCaster():GetAbsOrigin())
		--self:AddParticle(self.pfx, true, false, 15, false, false)
		Timers:CreateTimer(1.2	, function()
			ParticleManager:DestroyParticle(pfx, false)
			ParticleManager:ReleaseParticleIndex(pfx)
			return nil
		end)		
	end		
end
imba_spectre_haunt = class({})
LinkLuaModifier("modifier_imba_haunt", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_haunt_debuff", "linken/hero_spectre", LUA_MODIFIER_MOTION_NONE)
function imba_spectre_haunt:GetCustomCastErrorTarget(target)
	if not target:IsHero() then
		return "无法释放"
	end
	if not IsEnemy(target, self:GetCaster()) then
		return "无法释放"
	end	
end
function imba_spectre_haunt:CastFilterResultTarget(target)
	if IsServer() then

		if not target:IsHero() then
			return UF_FAIL_CUSTOM
		end
		if not IsEnemy(target, self:GetCaster()) then
			return UF_FAIL_CUSTOM
		end			
	end
end
function imba_spectre_haunt:GetCastPoint()
	if	IsServer()  then 
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_imba_haunt") then
			return 0.1
		else
			return 0.3
		end
	end		 
end
function imba_spectre_haunt:GetBehavior()
	if not self:GetCaster():HasModifier("modifier_imba_haunt") then  
		return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT
	end
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end
function imba_spectre_haunt:GetManaCost(a) 
	if self:GetCaster():HasModifier("modifier_imba_haunt") then  
		return 0	
	end
	return 200 
end
function imba_spectre_haunt:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_haunt") then  
		return  "spectre_reality"	
	end
	return "spectre_haunt"
end
function imba_spectre_haunt:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:HasScepter() then 
		return (cooldown - self:GetSpecialValueFor("sce_cd"))
	end
	return cooldown
end
function imba_spectre_haunt:IsHiddenWhenStolen() 		return true end
function imba_spectre_haunt:IsStealable() 			return false end
function imba_spectre_haunt:OnSpellStart()

	if not self:GetCaster():FindModifierByName("modifier_imba_haunt") then
		local duration = self:GetSpecialValueFor("duration") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_spectre_3")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_haunt", {duration = duration})	
		local enemy = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(), 
			self:GetCaster():GetAbsOrigin(), 
			nil, 
			40000, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			FIND_ANY_ORDER, 
			false)
		for i=1, #enemy do
			Timers:CreateTimer(FrameTime()*i*2, function()
				enemy[i]:AddNewModifier(self:GetCaster(), self, "modifier_imba_haunt_debuff", {duration = duration})
				return nil
			end)		
		end
		self:EndCooldown()
	else
		local pos = self:GetCursorPosition()
		local target = nil
		local enemy = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(), 
			pos, 
			nil, 
			40000, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO, 
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
			FIND_CLOSEST, 
			false)
		if #enemy < 1 then
			Notifications:Bottom(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), {text="没有找到视野内的敌人", duration=1.5, style={color="#FF0000", ["font-size"]="40px"}})
		end	 	
		for i=1, #enemy do
			target = enemy[i]
			if target then
				FindClearSpaceForUnit(self:GetCaster(), target:GetAbsOrigin(), false)
				self:GetCaster():MoveToTargetToAttack(target)
				EmitSoundOn("Hero_Spectre.Reality",target )
				self:EndCooldown()
				self:StartCooldown(1)				
				break
			end							
		end		 
	end				
end
modifier_imba_haunt = class({})

function modifier_imba_haunt:IsDebuff()				return false end
function modifier_imba_haunt:IsHidden() 			return false end
function modifier_imba_haunt:IsPurgable() 			return false end
function modifier_imba_haunt:IsPurgeException() 	return false end
function modifier_imba_haunt:GetTexture() return "spectre_haunt" end
function modifier_imba_haunt:OnCreated(keys)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()	
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.agility = self.ability:GetSpecialValueFor("agility")
	if IsServer() then
		EmitSoundOn("Hero_Spectre.Haunt", self:GetParent())
		self.pfx = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_blademail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, self:GetCaster():GetAbsOrigin())		
		self:OnIntervalThink()
		self:StartIntervalThink(0.1)	
	end	
end
function modifier_imba_haunt:OnIntervalThink()
	local enemy = FindUnitsInRadius(
		self.caster:GetTeamNumber(), 
		self.caster:GetAbsOrigin(), 
		nil, 
		self.radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
		FIND_ANY_ORDER, 
		false)
	for i=1, #enemy do
		local damage = self.caster:GetAgility() * (self.agility / 100)
		GetSplittingDagger(self.caster,0.5,0.5,enemy[i],damage)		
	end		
end
function modifier_imba_haunt:OnRemoved()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
		self:GetAbility():EndCooldown()
		self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(self:GetAbility():GetLevel() -1 ) * self:GetCaster():GetCooldownReduction()) - self:GetElapsedTime())					
	end
end
modifier_imba_haunt_debuff = class({})

function modifier_imba_haunt_debuff:IsDebuff()				return true end
function modifier_imba_haunt_debuff:IsHidden() 			return false end
function modifier_imba_haunt_debuff:IsPurgable() 			return false end
function modifier_imba_haunt_debuff:IsPurgeException() 	return false end
--[[function modifier_imba_haunt_debuff:CheckState()	
	return {[MODIFIER_STATE_INVISIBLE] = false } 
end
function modifier_imba_haunt_debuff:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_haunt_debuff:GetModifierProvidesFOWVision()
	return 1
end
function modifier_imba_haunt_debuff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
   	} 
end]]
function modifier_imba_haunt_debuff:OnCreated(keys)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()	
	if IsServer() then
		self.pfx = ParticleManager:CreateParticleForPlayer("particles/econ/items/spectre/spectre_arcana/spectre_arcana_debut_screen_border.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner())
		ParticleManager:SetParticleControl(self.pfx, 0, Vector(0, 0, 0))
		self:AddParticle(self.pfx, true, false, 15, false, false)	
	end	
end
function modifier_imba_haunt_debuff:OnRemoved()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end			
	end
end

