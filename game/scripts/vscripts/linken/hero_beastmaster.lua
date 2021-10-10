--2021.09.09---by你收拾收拾准备出林肯吧
--CreateTalents("npc_dota_hero_beastmaster", "linken/hero_beastmaster")
imba_beastmaster_wild_axes = class({})

--发射单个飞斧 两个斧子相撞时造成附近敌人攻击速度的比例伤害
LinkLuaModifier("modifier_imba_beastmaster_wild_axes_pfx", "linken/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_beastmaster_wild_axes_debuff", "linken/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)


function imba_beastmaster_wild_axes:OnSpellStart()
	self.caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	if TG_Distance(self.caster:GetAbsOrigin(),pos) < 450 then
		pos = self.caster:GetAbsOrigin() + self.caster:GetForwardVector() * 450
	end	
	local dummy_end = CreateModifierThinker(
						self.caster, -- player source
						self, -- ability source
						"modifier_dummy_thinker", -- modifier name
						{
							duration = 20,
						}, -- kv
						pos,
						self.caster:GetTeamNumber(),
						false
					)	
	--[[local dummy_pfx = CreateModifierThinker(
						self.caster, -- player source
						self, -- ability source
						"modifier_imba_beastmaster_wild_axes_pfx", -- modifier name
						{
							duration = 20,
							dummy_end = dummy_end:entindex()
						}, -- kv
						self.caster:GetAbsOrigin(),
						self.caster:GetTeamNumber(),
						false
					)]]	
	local dummy_pfx = CreateUnitByName(
		"npc_linken_unit", 
		self.caster:GetAbsOrigin(), 
		false, 
		self.caster, 
		self.caster, 
		self.caster:GetTeamNumber()
		)
	dummy_pfx:AddNewModifier(self.caster, self, "modifier_imba_beastmaster_wild_axes_pfx", {duration = 20})
	dummy_pfx:AddNewModifier(self.caster, self, "modifier_kill", {duration = 20})
	local info =
	{
		Target = dummy_end,
		Source = self.caster,
		EffectName = "",
		Ability = self,
		iMoveSpeed = self:GetSpecialValueFor("speed"),
		vSourceLoc = self.caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 60,
		bProvidesVision = false,
		ExtraData = {dummy_pfx = dummy_pfx:entindex(),dummy_end = dummy_end:entindex(),go_come = 0 }
	}
	TG_CreateProjectile({id = 1, team = self.caster:GetTeamNumber(), owner = self.caster,	p = info})
						
end	
function imba_beastmaster_wild_axes:OnProjectileThink_ExtraData(pos, keys)
	local caster = self:GetCaster()
	if keys.dummy_pfx then
		EntIndexToHScript(keys.dummy_pfx):SetOrigin(pos)
	end
end
function imba_beastmaster_wild_axes:OnProjectileHit_ExtraData(target, pos, keys)
	local caster = self:GetCaster()
	local dummy_pfx = EntIndexToHScript(keys.dummy_pfx)
	local dummy_end = EntIndexToHScript(keys.dummy_end)
	local go_come = keys.go_come
	if go_come == 0 then
		local modifier = dummy_pfx:FindModifierByName("modifier_imba_beastmaster_wild_axes_pfx")
		if modifier then
			modifier.caught_enemies = {}
			modifier.go_come = 1
		end	
		local info =
		{
			Target = self.caster,
			Source = dummy_end,
			EffectName = "",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor("speed"),
			vSourceLoc = dummy_end:GetAbsOrigin(),
			bDrawsOnMinimap = false,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
			bDodgeable = false,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			flExpireTime = GameRules:GetGameTime() + 60,
			bProvidesVision = false,
			ExtraData = {dummy_pfx = dummy_pfx:entindex(),dummy_end = dummy_end:entindex(),go_come = 1 }
		}
		--Timers:CreateTimer(1, function()
			TG_CreateProjectile({id = 1, team = caster:GetTeamNumber(), owner = caster,	p = info})
			--return nil
		--end)	
	elseif go_come == 1 then
		dummy_pfx:Destroy()
		dummy_end:Destroy()		
		--dummy_pfx:ForceKill(false)
		--dummy_end:ForceKill(false)
	end	

end
modifier_imba_beastmaster_wild_axes_pfx = class({})

function modifier_imba_beastmaster_wild_axes_pfx:CheckState() return 
	{
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, 
	[MODIFIER_STATE_NO_HEALTH_BAR] = true, 
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true, 
	[MODIFIER_STATE_INVULNERABLE] = true, 
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true, 
	[MODIFIER_STATE_OUT_OF_GAME] = true, 
	[MODIFIER_STATE_UNSELECTABLE] = true, 
	[MODIFIER_STATE_DISARMED] = true, 
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true
} 
end
function modifier_imba_beastmaster_wild_axes_pfx:OnCreated(keys)
	if IsServer() then
		if not self:GetAbility() then
			return
		end	
		self.parent = self:GetParent()
		self.ability =self:GetAbility()
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.axe_boom_rad = self.ability:GetSpecialValueFor("axe_boom_rad")
		self.axe_boom_dam = self.ability:GetSpecialValueFor("axe_boom_dam") * 0.01
		self.duration = self.ability:GetSpecialValueFor("duration")
		self.caught_enemies = {}
		self.damageTable = {
		attacker = self:GetCaster(),
		damage = self.ability:GetSpecialValueFor("axe_damage"),
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability,
		}		
		self.go_come = 0
		self.duang = false
		self.caster = self:GetParent() 
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_wildaxe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(self.pfx, 0, self.caster:GetAbsOrigin())
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_beastmaster_wild_axes_pfx:OnIntervalThink(keys)
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),
		self.parent:GetAbsOrigin(),	
		nil,	
		self.radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,	
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	
		0,	
		false
	)	
	for _,enemy in pairs(enemies) do
		if not self.caught_enemies[enemy] then
			self.caught_enemies[enemy] = true
			self.damageTable.victim = enemy
			enemy:AddNewModifier(self:GetCaster(), self.ability, "modifier_imba_beastmaster_wild_axes_debuff", {duration = self.duration})
			ApplyDamage( self.damageTable )
		end	
	end
	GridNav:DestroyTreesAroundPoint( self.parent:GetAbsOrigin(), 80, true )	

	local flamebreak = Entities:FindAllInSphere(self:GetParent():GetAbsOrigin(), 100)
	for i=1, #flamebreak do
		if  string.find(flamebreak[i]:GetName(), "npc_") and flamebreak[i]:HasModifier("modifier_imba_beastmaster_wild_axes_pfx") and flamebreak[i] ~= self:GetParent() and not IsEnemy(flamebreak[i], self:GetParent())  then
			self.duang = true
			local modifier = flamebreak[i]:FindModifierByName("modifier_imba_beastmaster_wild_axes_pfx")
			if modifier then
				modifier.duang = true
			end				
			break
		end
	end
	if self.duang then
		local enemies = FindUnitsInRadius(
			self.parent:GetTeamNumber(),	
			self.parent:GetAbsOrigin(),
			nil,	
			self.axe_boom_rad,	
			DOTA_UNIT_TARGET_TEAM_ENEMY,	
			DOTA_UNIT_TARGET_HERO,	
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	
			0,	
			false	
		)	
		for _,enemy in pairs(enemies) do
			self.damageTable.victim = enemy
			self.damageTable.damage = enemy:GetDisplayAttackSpeed() * self.axe_boom_dam
			ApplyDamage( self.damageTable )
		end


		local dummy_pfx = ParticleManager:CreateParticle("particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_attack_blur_counterhelix.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(dummy_pfx, 0, self.parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(dummy_pfx)
		self:Destroy()
		self.parent:ForceKill(false)
	end	
end
function modifier_imba_beastmaster_wild_axes_pfx:OnRemoved()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
		self.caught_enemies = {}
		self.go_come = 0
	end
end

modifier_imba_beastmaster_wild_axes_debuff = class({})
function modifier_imba_beastmaster_wild_axes_debuff:IsDebuff()			return true end
function modifier_imba_beastmaster_wild_axes_debuff:IsHidden() 			return false end
function modifier_imba_beastmaster_wild_axes_debuff:IsPurgable() 		return true end
function modifier_imba_beastmaster_wild_axes_debuff:IsPurgeException() 	return true end
function modifier_imba_beastmaster_wild_axes_debuff:DeclareFunctions() 
	return {
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
			} 
end
function modifier_imba_beastmaster_wild_axes_debuff:OnCreated(keys)
	if IsServer() then
		self.parent 	= 	self:GetParent()
		self.caster 	= 	self:GetCaster()
		self.ability 	= 	self:GetAbility()
		self.damage_amp = self.ability:GetSpecialValueFor("damage_amp")	
		self:IncrementStackCount()
	end
end
function modifier_imba_beastmaster_wild_axes_debuff:OnRefresh(keys)
	self:OnCreated()
end
function modifier_imba_beastmaster_wild_axes_debuff:GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker == self.caster or keys.attacker:GetPlayerOwnerID() == self.caster:GetPlayerOwnerID() then 
  		return self.damage_amp + self.damage_amp * self:GetStackCount()
  	end	
	return nil
end
imba_beastmaster_call_of_the_wild = class({})

LinkLuaModifier("modifier_imba_call_of_the_wild_passive", "linken/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_call_of_the_wild_debuff", "linken/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)
function imba_beastmaster_call_of_the_wild:GetIntrinsicModifierName() return "modifier_imba_call_of_the_wild_passive" end
function imba_beastmaster_call_of_the_wild:OnSpellStart()
	self.caster = self:GetCaster()
	self.beastmaster_boar = CreateUnitByName(
		"npc_imba_beastmaster_greater_boar", 
		self.caster:GetAbsOrigin() + self.caster:GetForwardVector() * 200, 
		true, 
		self.caster, 
		self.caster, 
		self.caster:GetTeamNumber()
		)

	local duration = self:GetSpecialValueFor("duration")	
	self.beastmaster_boar:AddNewModifier(self.caster, self, "modifier_imba_call_of_the_wild_passive", {duration = duration})
	self.beastmaster_boar:AddNewModifier(self.caster, self, "modifier_kill", {duration = duration})
	self.beastmaster_boar:SetControllableByPlayer(self.caster:GetPlayerOwnerID(), false)						
end	

modifier_imba_call_of_the_wild_passive = class({})
function modifier_imba_call_of_the_wild_passive:IsDebuff()			return false end
function modifier_imba_call_of_the_wild_passive:IsHidden() 			return true end
function modifier_imba_call_of_the_wild_passive:IsPurgable() 		return false end
function modifier_imba_call_of_the_wild_passive:IsPurgeException() 	return false end
function modifier_imba_call_of_the_wild_passive:DeclareFunctions() 
	return {
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			} 
end
function modifier_imba_call_of_the_wild_passive:OnCreated(keys)
	if IsServer() then
		self.parent 	= 	self:GetParent()
		self.caster 	= 	self:GetCaster()
		self.ability 	= 	self:GetAbility()
		self.boar_poison_duration = self.ability:GetSpecialValueFor("boar_poison_duration")	
		self.boar_hp = 		self.ability:GetSpecialValueFor("boar_hp") * 0.01
		self.boar_damage = 	self.ability:GetSpecialValueFor("boar_damage") * 0.01
		if not self.parent:IsHero() then
   			self.parent:Set_HP(self.caster:GetMaxHealth() * self.boar_hp,true)
    		self.parent:SetBaseDamageMax(self.caster:GetAttackDamage()*self.boar_damage)
    		self.parent:SetBaseDamageMin(self.caster:GetAttackDamage()*self.boar_damage)
		end	
	end
end
function modifier_imba_call_of_the_wild_passive:OnRefresh(keys)
	self:OnCreated()
end
function modifier_imba_call_of_the_wild_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self.parent or self.parent:PassivesDisabled() or not keys.target:IsAlive() or not keys.target:IsUnit() then
		return
	end
	keys.target:AddNewModifier(self.caster, self.ability, "modifier_imba_call_of_the_wild_debuff", {duration = self.boar_poison_duration})
end
modifier_imba_call_of_the_wild_debuff = class({})
function modifier_imba_call_of_the_wild_debuff:IsDebuff()			return true end
function modifier_imba_call_of_the_wild_debuff:IsHidden() 			return false end
function modifier_imba_call_of_the_wild_debuff:IsPurgable() 		return true end
function modifier_imba_call_of_the_wild_debuff:IsPurgeException() 	return true end
function modifier_imba_call_of_the_wild_debuff:DeclareFunctions() 
	return {
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			} 
end
function modifier_imba_call_of_the_wild_debuff:OnCreated(keys)
		self.parent 	= 	self:GetParent()
		self.caster 	= 	self:GetCaster()
		self.ability 	= 	self:GetAbility()
		self.boar_moveslow = self.ability:GetSpecialValueFor("boar_moveslow")
		self.att_sp_dam = self.ability:GetSpecialValueFor("att_sp_dam")	* 0.01
	if IsServer() then
		self:IncrementStackCount()
		self:OnIntervalThink()
		self:StartIntervalThink(1)
	end
end
function modifier_imba_call_of_the_wild_debuff:OnRefresh(keys)
	self:OnCreated()
end
function modifier_imba_call_of_the_wild_debuff:OnIntervalThink(keys)		
	local damageTable = {
						victim = self.parent,
						attacker = self.caster,
						damage = (self.att_sp_dam * self.parent:GetDisplayAttackSpeed()) + (self.att_sp_dam / 2 * self:GetStackCount()) ,
						damage_type = self.ability:GetAbilityDamageType(),
						ability = self.ability,
						damage_flags = DOTA_DAMAGE_FLAG_NONE,
						}
	ApplyDamage(damageTable)	
end
function modifier_imba_call_of_the_wild_debuff:GetModifierMoveSpeedBonus_Percentage()
	return (0 - self.boar_moveslow) 
end

imba_beastmaster_call_of_the_wild_hawk = class({})

LinkLuaModifier("modifier_imba_beastmaster_call_of_the_wild_hawk_passive", "linken/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_call_of_the_wild_hawk_kill_move", "linken/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)
function  imba_beastmaster_call_of_the_wild_hawk:GetAOERadius()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("hawk_vision_tooltip") --+  self:GetCaster():TG_GetTalentValue("special_bonus_imba_ogre_magi_6")	
	return radius		 
end
function imba_beastmaster_call_of_the_wild_hawk:OnSpellStart()
	self.caster = self:GetCaster()
	local pos = self.caster:GetCursorPosition()
	local beastmaster_boar_hawk = CreateUnitByName(
		"npc_imba_beastmaster_hawk", 
		self.caster:GetAbsOrigin() + self.caster:GetForwardVector() * 200, 
		true, 
		self.caster, 
		self.caster, 
		self.caster:GetTeamNumber()
		)

	local duration = self:GetSpecialValueFor("duration")	
	beastmaster_boar_hawk:AddNewModifier(
		self.caster, 
		self, 
		"modifier_imba_beastmaster_call_of_the_wild_hawk_passive",
		{
			duration = duration ,
			pos = pos
		}
		)
	beastmaster_boar_hawk:AddNewModifier(self.caster, self, "modifier_kill", {duration = duration})
	beastmaster_boar_hawk:SetControllableByPlayer(self.caster:GetPlayerOwnerID(), false)
	--print(beastmaster_boar_hawk:IsSummoned())
	Timers:CreateTimer(0.1, function ()
		beastmaster_boar_hawk:MoveToPosition(pos)
		return nil
	end)
end	

modifier_imba_beastmaster_call_of_the_wild_hawk_passive = class({})
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:IsDebuff()			return false end
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:IsHidden() 			return true end
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:IsPurgable() 		return false end
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:IsPurgeException() 	return false end
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:DeclareFunctions() 
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED, 
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, 
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, 
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE, 
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_DISABLE_HEALING,
	} 
end
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:GetDisableHealing() return 1 end
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:GetAbsoluteNoDamageMagical() return 1 end
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:GetAbsoluteNoDamagePure() return 1 end
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:CheckState() 
return {
        [MODIFIER_STATE_INVISIBLE] = true, 
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED]	= true,
		
        }
end
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:GetModifierInvisibilityLevel() return 1 end
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:OnCreated(keys)
	self.parent 	= 	self:GetParent()
	self.caster 	= 	self:GetCaster()
	self.ability 	= 	self:GetAbility()
	if IsServer() then	
		self.boar_hp = 	self.ability:GetSpecialValueFor("hawk_hp_tooltip") * 2
		self.vision = 	self.ability:GetSpecialValueFor("hawk_vision_tooltip")
		self.agh_hp = 	self.ability:GetSpecialValueFor("agh_hp") * 0.01
		self.pos = StringToVector(keys.pos)
		self.parent:Set_HP(self.boar_hp,true)
		self.int = 0.1
		self.auto = false
		self.dummy = CreateModifierThinker(
						self.caster, -- player source
						self.ability, -- ability source
						"modifier_dummy_thinker", -- modifier name
						{
							duration = self:GetDuration(),
						}, -- kv
						self.pos+TG_Direction2(self.pos,self.parent:GetAbsOrigin()) * self.vision,
						self.caster:GetTeamNumber(),
						false
					)	
		self:StartIntervalThink(self.int)	
	end
end
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:OnRefresh(keys)
	self:OnCreated()
end
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:OnIntervalThink(keys)	
	AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), self.vision, self.int, false)
	if self.ability:GetAutoCastState() then
		local next_pos = RotatePosition(self.pos, QAngle(0,5,0), self.dummy:GetAbsOrigin())
		self.dummy:SetOrigin(next_pos)
		self.parent:MoveToPosition(self.dummy:GetAbsOrigin())
		self.auto = true
	elseif not self.ability:GetAutoCastState() and self.auto then
		self.parent:Stop()
		self.auto = false	
	end
	if self.caster:Has_Aghanims_Shard() and self.ability:GetAutoCastState() then
		local enemies = FindUnitsInRadius(
			self.parent:GetTeamNumber(),	
			self.parent:GetAbsOrigin(),
			nil,	
			self.vision,	
			DOTA_UNIT_TARGET_TEAM_ENEMY,	
			DOTA_UNIT_TARGET_HERO,	
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	
			0,	
			false	
		)	
		for _,enemy in pairs(enemies) do
			if enemy:GetHealth() / enemy:GetMaxHealth() <= self.agh_hp then
				self.parent:AddNewModifier(
					self.caster, 
					self.ability, 
					"modifier_imba_call_of_the_wild_hawk_kill_move", 
					{
						duration = 1.5,
						enemy = enemy:entindex(),
					})
				self:StartIntervalThink(-1)
				self:Destroy()
				self.dummy:Destroy()
				break
			end
		end
	end
end
function modifier_imba_beastmaster_call_of_the_wild_hawk_passive:OnAttackLanded(keys)
	if not IsServer() or keys.target ~= self:GetParent() then
		return
	end
	local dmg = (keys.attacker:IsHero() or keys.attacker:IsTower()) and 2 or 1
	if self.enemy == 0 then
		dmg = self.parent:GetMaxHealth()
	end	
	if dmg > self.parent:GetHealth() then
		self.parent:Kill(self:GetAbility(), keys.attacker)
		return
	end
	self.parent:SetHealth(self.parent:GetHealth() - dmg)
end
modifier_imba_call_of_the_wild_hawk_kill_move = class({})
function modifier_imba_call_of_the_wild_hawk_kill_move:IsDebuff()			return true end
function modifier_imba_call_of_the_wild_hawk_kill_move:IsHidden() 			return false end
function modifier_imba_call_of_the_wild_hawk_kill_move:IsPurgable() 		return true end
function modifier_imba_call_of_the_wild_hawk_kill_move:IsPurgeException() 	return true end
function modifier_imba_call_of_the_wild_hawk_kill_move:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, 
		MODIFIER_PROPERTY_MOVESPEED_LIMIT
	} 
end
function modifier_imba_call_of_the_wild_hawk_kill_move:CheckState() 
return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE]	= true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED]	= true,
        }
end
function modifier_imba_call_of_the_wild_hawk_kill_move:GetModifierMoveSpeed_Absolute() if IsServer() then return 1 end end
function modifier_imba_call_of_the_wild_hawk_kill_move:GetModifierMoveSpeed_Limit() if IsServer() then return 1 end end
function modifier_imba_call_of_the_wild_hawk_kill_move:OnCreated(keys)
		self.parent 	= 	self:GetParent()
		self.caster 	= 	self:GetCaster()
		self.ability 	= 	self:GetAbility()
	if IsServer() then
		self.agh_hp = self.ability:GetSpecialValueFor("agh_hp") * 0.01
		self.enemy = EntIndexToHScript(keys.enemy)
		self.parent:Stop()
		self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CHANNEL_ABILITY_5,1.8)
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_shard_dive_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.pfx, 0, self.parent:GetAbsOrigin())
		--ParticleManager:SetParticleControl(self.pfx, 2, self.parent:GetAbsOrigin())		
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_call_of_the_wild_hawk_kill_move:OnRefresh(keys)
	self:OnCreated()
end
function modifier_imba_call_of_the_wild_hawk_kill_move:OnIntervalThink(keys)
	if 	self.enemy and self.enemy:IsAlive() then	
		local speed = 1200 / (1 / FrameTime())

		local direction = TG_Direction2(self.enemy:GetAbsOrigin(),self.parent:GetAbsOrigin())
		local next_pos = GetGroundPosition(self.parent:GetAbsOrigin() + direction * speed,nil)
		self.parent:SetForwardVector(direction)
		self.parent:SetOrigin(next_pos)
	elseif not self.enemy or not self.enemy:IsAlive() then
		self:Destroy()
	end
	if TG_Distance(self.enemy:GetAbsOrigin(),self.parent:GetAbsOrigin()) <= 20 then
		self.parent:FadeGesture(ACT_DOTA_CHANNEL_ABILITY_5)
		self:Destroy()
	end
end
function modifier_imba_call_of_the_wild_hawk_kill_move:OnRemoved()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
		if self.enemy and self.enemy:IsAlive() then
			local damageTable = {
			attacker = self.caster, 
			victim = self.enemy, 
			damage = self.enemy:GetMaxHealth() * self.agh_hp, 
			ability = self.ability, 
			damage_type = DAMAGE_TYPE_PURE
			}		
			ApplyDamage(damageTable)
		end
		if self.parent then
			self.parent:Kill(self.ability, self.parent)
		end
	end
end
--兽王光环 增加友军攻击速度 降低敌人攻击速度 主动使用持续xx秒  所承受伤害由范围内中立单位同时承受，同时中立单位攻击速度攻击力移动速度提升至极限，友军免疫中立单位伤害。
imba_beastmaster_inner_beast = class({})

LinkLuaModifier("modifier_imba_beastmaster_inner_beast_passive", "linken/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_beastmaster_inner_beast_buff", "linken/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_beastmaster_inner_beast_tooltip", "linken/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)
function imba_beastmaster_inner_beast:GetIntrinsicModifierName() return "modifier_imba_beastmaster_inner_beast_passive" end
function imba_beastmaster_inner_beast:OnSpellStart()
	self:GetCaster():RemoveModifierByName("modifier_imba_beastmaster_inner_beast_passive")
	self:GetCaster():AddNewModifier(
		self:GetCaster(), 
		self, 
		"modifier_imba_beastmaster_inner_beast_passive",
		{
			duration = -1 ,
		}
		)
	local duration = self:GetSpecialValueFor("duration")
	self:GetCaster():AddNewModifier(
		self:GetCaster(), 
		self, 
		"modifier_imba_beastmaster_inner_beast_tooltip",
		{
			duration = duration ,
		}
		)		
end	
function imba_beastmaster_inner_beast:Hasmodif()
	return self:GetCaster():HasModifier("modifier_imba_beastmaster_inner_beast_tooltip")
end
modifier_imba_beastmaster_inner_beast_passive = class({})
function modifier_imba_beastmaster_inner_beast_passive:IsDebuff()			return false end
function modifier_imba_beastmaster_inner_beast_passive:IsHidden() 			return true end
function modifier_imba_beastmaster_inner_beast_passive:IsPurgable() 		return false end
function modifier_imba_beastmaster_inner_beast_passive:IsPurgeException() 	return false end
function modifier_imba_beastmaster_inner_beast_passive:IsAura()				return true end
function modifier_imba_beastmaster_inner_beast_passive:GetAuraDuration() 	return 0.1 end
function modifier_imba_beastmaster_inner_beast_passive:GetModifierAura() 	return "modifier_imba_beastmaster_inner_beast_buff" end
function modifier_imba_beastmaster_inner_beast_passive:IsAuraActiveOnDeath() return false end
function modifier_imba_beastmaster_inner_beast_passive:GetAuraRadius() 		return self.radius end
function modifier_imba_beastmaster_inner_beast_passive:GetAuraSearchFlags() 	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_beastmaster_inner_beast_passive:GetAuraSearchTeam() 	return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_imba_beastmaster_inner_beast_passive:GetAuraSearchType() 	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_beastmaster_inner_beast_passive:GetAuraEntityReject(hTarget)	
	if not self:GetParent():IsAlive() or not self:GetAbility():IsTrained() or self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() or not hTarget or hTarget:IsBoss() then
	    return true	
    else
		return false	
	end	
end
function modifier_imba_beastmaster_inner_beast_passive:DeclareFunctions() 
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE, 
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	} 
end
function modifier_imba_beastmaster_inner_beast_passive:GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker:IsAlive() then
		if ((self.nu ~= 0 and self:GetAbility():Hasmodif()) or keys.attacker:GetTeamNumber() == DOTA_TEAM_NEUTRALS or keys.attacker:IsSummoned()) and not keys.attacker:IsBoss() then 
			return -100
		end	
	end
end
function modifier_imba_beastmaster_inner_beast_passive:OnCreated(keys)
	self.parent 	= 	self:GetParent()
	self.caster 	= 	self:GetCaster()
	self.ability 	= 	self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
	if IsServer() then	
		self.nu = 0
		self:StartIntervalThink(0.1)
	end
end
function modifier_imba_beastmaster_inner_beast_passive:OnIntervalThink(keys)
	self.nu = 0
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	
		self:GetParent():GetAbsOrigin(),
		nil,	
		self.radius,	
		DOTA_UNIT_TARGET_TEAM_BOTH,	
		DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	
		0,	
		false	
	)
	for _,enemy in pairs(enemies) do
		if (enemy:GetTeamNumber() == DOTA_TEAM_NEUTRALS or (enemy:IsSummoned() and enemy:GetPlayerOwnerID() == self.caster:GetPlayerOwnerID()) ) and not enemy:IsBoss() then
			if enemy:GetName() ~= "npc_dota_beastmaster_hawk" then
				--print(enemy:GetName())
				self.nu = self.nu + 1
			end
		end
	end
	--print(self.nu)
end
function modifier_imba_beastmaster_inner_beast_passive:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	if not self:GetAbility():Hasmodif() then
		return
	end
	if keys.attacker:IsHero() and not keys.attacker:IsIllusion() then
		self.attacker = keys.attacker
	end
	if keys.attacker:GetTeamNumber() == DOTA_TEAM_NEUTRALS then return end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then	return end
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	
		self:GetParent():GetAbsOrigin(),
		nil,	
		self.radius,	
		DOTA_UNIT_TARGET_TEAM_BOTH,	
		DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	
		0,	
		false	
	)
	for _,enemy in pairs(enemies) do
		if (enemy:GetTeamNumber() == DOTA_TEAM_NEUTRALS or (enemy:IsSummoned() and enemy:GetPlayerOwnerID() == self.caster:GetPlayerOwnerID()) ) and not enemy:IsBoss() and self.nu > 0 then
			local damageTable = {
								victim = enemy,
								attacker = self.attacker,
								damage = keys.original_damage/self.nu,
								damage_type = keys.damage_type,
								ability = self:GetAbility(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE,
								}
			ApplyDamage(damageTable)
		end
	end

end
modifier_imba_beastmaster_inner_beast_buff = class({})
function modifier_imba_beastmaster_inner_beast_buff:IsDebuff()			return (IsEnemy(self:GetParent(),self:GetCaster()) and not self:GetParent():GetTeamNumber() == DOTA_TEAM_NEUTRALS) or (IsEnemy(self:GetParent(),self:GetCaster()) and self:GetParent():GetTeamNumber() ~= DOTA_TEAM_NEUTRALS) end
function modifier_imba_beastmaster_inner_beast_buff:IsHidden() 			return self:GetParent():GetTeamNumber() == DOTA_TEAM_NEUTRALS and not self:GetAbility():Hasmodif() end
function modifier_imba_beastmaster_inner_beast_buff:IsPurgable() 		return false end
function modifier_imba_beastmaster_inner_beast_buff:IsPurgeException() 	return false end
function modifier_imba_beastmaster_inner_beast_buff:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	} 
end
function modifier_imba_beastmaster_inner_beast_buff:OnCreated(keys)
		self.parent 	= 	self:GetParent()
		self.caster 	= 	self:GetCaster()
		self.ability 	= 	self:GetAbility()
		self.as_bonus = self.ability:GetSpecialValueFor("bonus_attack_speed")
		self.inner_beast = self.ability:GetSpecialValueFor("inner_beast")
	if IsServer() then
		--self:StartIntervalThink(FrameTime())
	end
end
--[[function modifier_imba_beastmaster_inner_beast_buff:OnIntervalThink(keys)
	if self.parent:GetAttackTarget() == self.caster then
		self.att = true
	elseif self.parent:GetAttackTarget() == nil then
		self.att = false
	end
end]]

function modifier_imba_beastmaster_inner_beast_buff:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():GetTeamNumber() == DOTA_TEAM_NEUTRALS and self:GetAbility():Hasmodif() then
		return self.as_bonus * self.inner_beast
	elseif IsEnemy(self:GetParent(),self:GetCaster()) then
		return -self.as_bonus
	elseif self:GetParent():GetTeamNumber() == DOTA_TEAM_NEUTRALS and not self:GetAbility():Hasmodif() then
		return nil
	end
	return self.as_bonus
end
function modifier_imba_beastmaster_inner_beast_buff:GetModifierIgnoreMovespeedLimit()
	if self:GetParent():GetTeamNumber() == DOTA_TEAM_NEUTRALS and self:GetAbility():Hasmodif() then
		return 1
	elseif self:GetParent():GetTeamNumber() == DOTA_TEAM_NEUTRALS and not self:GetAbility():Hasmodif() then
		return nil
	end
	return 0
end
function modifier_imba_beastmaster_inner_beast_buff:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetParent():GetTeamNumber() == DOTA_TEAM_NEUTRALS and self:GetAbility():Hasmodif() then
		return self.as_bonus * self.inner_beast
	elseif self:GetParent():GetTeamNumber() == DOTA_TEAM_NEUTRALS and not self:GetAbility():Hasmodif() then
		return nil
	end
	return nil
end
function modifier_imba_beastmaster_inner_beast_buff:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent():GetTeamNumber() == DOTA_TEAM_NEUTRALS and self:GetAbility():Hasmodif() then
		return self.as_bonus * self.inner_beast
	elseif self:GetParent():GetTeamNumber() == DOTA_TEAM_NEUTRALS and not self:GetAbility():Hasmodif() then
		return nil
	end
	return nil
end
function modifier_imba_beastmaster_inner_beast_buff:GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker:IsAlive() then
		if not IsEnemy(self:GetParent(),self:GetCaster()) and (keys.attacker:GetTeamNumber() == DOTA_TEAM_NEUTRALS and not keys.attacker:IsBoss()) and self:GetAbility():Hasmodif() then 
			return -100
		elseif not IsEnemy(self:GetParent(),self:GetCaster()) and (keys.attacker:GetTeamNumber() == DOTA_TEAM_NEUTRALS and not keys.attacker:IsBoss()) and not self:GetAbility():Hasmodif() then
			return nil
		end	
	end
end
function modifier_imba_beastmaster_inner_beast_buff:CheckState() 
	return 
		{
        [MODIFIER_STATE_NO_UNIT_COLLISION] = self:GetParent():GetTeamNumber() == DOTA_TEAM_NEUTRALS and self:GetAbility():Hasmodif() or nil,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = self:GetParent():GetTeamNumber() == DOTA_TEAM_NEUTRALS and self:GetAbility():Hasmodif() or nil ,
        }
end

function modifier_imba_beastmaster_inner_beast_buff:OnRemoved()
	if IsServer() then
	end
end

modifier_imba_beastmaster_inner_beast_tooltip = class({})
function modifier_imba_beastmaster_inner_beast_tooltip:IsDebuff()			return false end
function modifier_imba_beastmaster_inner_beast_tooltip:IsHidden() 			return false end
function modifier_imba_beastmaster_inner_beast_tooltip:IsPurgable() 		return false end
function modifier_imba_beastmaster_inner_beast_tooltip:IsPurgeException() 	return false end
--原始咆哮
imba_beastmaster_primal_roar = class({})

LinkLuaModifier("modifier_imba_beastmaster_primal_roar_move", "linken/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_beastmaster_primal_roar_move_come", "linken/hero_beastmaster", LUA_MODIFIER_MOTION_NONE)
--function imba_beastmaster_primal_roar:GetIntrinsicModifierName() return "modifier_imba_call_of_the_wild_passive" end
function imba_beastmaster_primal_roar:GetCastRange(pos, target)
	if not self.range_porcupine then
		self.range_porcupine = 0
	end
	if IsClient() then
		return self.BaseClass.GetCastRange(self, pos, target)
	else
		return self.BaseClass.GetCastRange(self, pos, target) + self.range_porcupine
	end
end
function imba_beastmaster_primal_roar:OnSpellStart()
	local caster		 	= self:GetCaster()
	self.beastmaster_boar = nil
	
	if self.range_porcupine > 0 then
		local ability = caster:FindAbilityByName("imba_beastmaster_call_of_the_wild") 
		if ability.beastmaster_boar and ability.beastmaster_boar:IsAlive() then
			self.beastmaster_boar = ability.beastmaster_boar
			caster	= self.beastmaster_boar
		end
	end
	local target 			= self:GetCursorTarget()	
	local stun_duration 	= self:GetSpecialValueFor("duration")
	local search_range 		= self:GetSpecialValueFor("search_range")
	local search_angle 		= self:GetSpecialValueFor("search_angle")
	local hawk			 	= nil
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})	
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	
		target:GetAbsOrigin(),
		nil,	
		search_range,	
		DOTA_UNIT_TARGET_TEAM_BOTH,	
		DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	
		0,	
		false	
	)


	for _,enemy in pairs(enemies) do
		local st_direction 	= VectorToAngles(caster:GetAbsOrigin()-target:GetAbsOrigin()).y
		local end_direction = VectorToAngles(target:GetAbsOrigin()-enemy:GetAbsOrigin()).y
		local suc 			= math.abs( AngleDiff(st_direction,end_direction)) < search_angle
		if enemy:GetName() == "npc_dota_beastmaster_hawk" and enemy:GetPlayerOwnerID() == caster:GetPlayerOwnerID() and suc then
			hawk = enemy
			hawk:AddNewModifier(
				caster, 
				self, 
				"modifier_imba_beastmaster_primal_roar_move", 
				{
					duration = 3,
					target = target:entindex()
				}
			)
		elseif enemy:GetTeamNumber() == DOTA_TEAM_NEUTRALS and enemy ~= target and not enemy:IsBoss() then
			enemy:AddNewModifier(
				caster, 
				self, 
				"modifier_imba_beastmaster_primal_roar_move", 
				{
					duration = 3,
					target = target:entindex()
				}
			)
		end
	end
end	
modifier_imba_beastmaster_primal_roar_move = class({})
function modifier_imba_beastmaster_primal_roar_move:IsDebuff()			return true end
function modifier_imba_beastmaster_primal_roar_move:IsHidden() 			return false end
function modifier_imba_beastmaster_primal_roar_move:IsPurgable() 		return false end
function modifier_imba_beastmaster_primal_roar_move:IsPurgeException() 	return false end
function modifier_imba_beastmaster_primal_roar_move:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, 
		MODIFIER_PROPERTY_MOVESPEED_LIMIT
	} 
end
function modifier_imba_beastmaster_primal_roar_move:CheckState() 
return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE]	= true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED]	= true,
        }
end
function modifier_imba_beastmaster_primal_roar_move:GetModifierMoveSpeed_Absolute() if IsServer() then return 1 end end
function modifier_imba_beastmaster_primal_roar_move:GetModifierMoveSpeed_Limit() if IsServer() then return 1 end end
function modifier_imba_beastmaster_primal_roar_move:OnCreated(keys)
		self.parent 	= 	self:GetParent()
		self.caster 	= 	self:GetCaster()
		self.ability 	= 	self:GetAbility()
	if IsServer() then
		self.enemy = EntIndexToHScript(keys.target)
		self.pos = self.caster:GetAbsOrigin()
		self.parent:Stop()
		self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CHANNEL_ABILITY_5,1.8)
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_shard_dive_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.pfx, 0, self.parent:GetAbsOrigin())	
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_beastmaster_primal_roar_move:OnRefresh(keys)
	self:OnCreated()
end
function modifier_imba_beastmaster_primal_roar_move:OnIntervalThink(keys)
	if 	self.enemy and self.enemy:IsAlive() then	
		local speed = 1200 / (1 / FrameTime())

		local direction = TG_Direction2(self.enemy:GetAbsOrigin(),self.parent:GetAbsOrigin())
		local next_pos = GetGroundPosition(self.parent:GetAbsOrigin() + direction * speed,nil)
		self.parent:SetForwardVector(direction)
		self.parent:SetOrigin(next_pos)
	elseif not self.enemy or not self.enemy:IsAlive() then
		self:Destroy()
	end
	if TG_Distance(self.enemy:GetAbsOrigin(),self.parent:GetAbsOrigin()) <= 20 then
		self.parent:FadeGesture(ACT_DOTA_CHANNEL_ABILITY_5)
		self:Destroy()
	end
end
function modifier_imba_beastmaster_primal_roar_move:OnRemoved()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end

		if self.parent:IsAlive() and self.parent:GetName() == "npc_dota_beastmaster_hawk" and self.parent:GetPlayerOwnerID() == self.caster:GetPlayerOwnerID()then
			self.parent:Kill(self.ability, self.parent)
		end
		if self.parent:IsAlive() and self.enemy:IsAlive() then
			self.parent:SetForceAttackTarget(self.enemy)
		end
		if 	self.enemy and self.enemy:IsAlive() and self.parent:GetName() == "npc_dota_beastmaster_hawk" and self.parent:GetPlayerOwnerID() == self.caster:GetPlayerOwnerID() then
			self.enemy:AddNewModifier(
				self.caster, 
				self.ability, 
				"modifier_imba_beastmaster_primal_roar_move_come", 
				{
					duration = 3,
					pos = self.pos
				}
			)
		end
	end
end
modifier_imba_beastmaster_primal_roar_move_come = class({})
function modifier_imba_beastmaster_primal_roar_move_come:IsDebuff()			return true end
function modifier_imba_beastmaster_primal_roar_move_come:IsHidden() 			return false end
function modifier_imba_beastmaster_primal_roar_move_come:IsPurgable() 		return false end
function modifier_imba_beastmaster_primal_roar_move_come:IsPurgeException() 	return false end
function modifier_imba_beastmaster_primal_roar_move_come:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, 
		MODIFIER_PROPERTY_MOVESPEED_LIMIT
	} 
end
function modifier_imba_beastmaster_primal_roar_move_come:CheckState() 
return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE]	= true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED]	= true,
        }
end
function modifier_imba_beastmaster_primal_roar_move_come:GetModifierMoveSpeed_Absolute() if IsServer() then return 1 end end
function modifier_imba_beastmaster_primal_roar_move_come:GetModifierMoveSpeed_Limit() if IsServer() then return 1 end end
function modifier_imba_beastmaster_primal_roar_move_come:OnCreated(keys)
		self.parent 	= 	self:GetParent()
		self.caster 	= 	self:GetCaster()
		self.ability 	= 	self:GetAbility()
	if IsServer() then
		self.enemy = self.parent
		self.st_pos = self.enemy:GetAbsOrigin()
		self.pos = StringToVector(keys.pos)
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_shard_dive_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.pfx, 0, self.parent:GetAbsOrigin())	
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_beastmaster_primal_roar_move_come:OnRefresh(keys)
	self:OnCreated()
end
function modifier_imba_beastmaster_primal_roar_move_come:OnIntervalThink(keys)
	if 	self.enemy and self.enemy:IsAlive() then	
		local speed = 1200 / (1 / FrameTime())

		local direction = TG_Direction2(self.pos,self.parent:GetAbsOrigin())
		local next_pos = GetGroundPosition(self.parent:GetAbsOrigin() + direction * speed,nil)
		self.parent:SetForwardVector(direction)
		self.parent:SetOrigin(next_pos)
	elseif not self.enemy or not self.enemy:IsAlive() then
		self:Destroy()
	end
	if TG_Distance(self.pos,self.parent:GetAbsOrigin()) <= 20 then
		self:Destroy()
	end
	if TG_Distance(self.st_pos,self.parent:GetAbsOrigin()) > 1000 then
		self:Destroy()
	end
end
function modifier_imba_beastmaster_primal_roar_move_come:OnRemoved()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end
end