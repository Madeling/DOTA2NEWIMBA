CreateTalents("npc_dota_hero_slardar","mb/hero_slardar.lua")
-- 04 25 by MysticBug-------
----------------------------
----------------------------

--extra api
function GetDirection2D(vEndPoint, vStartPoint)
	vEndPoint.z = 0
	vStartPoint.z = 0
	local direction = (vEndPoint - vStartPoint):Normalized()
	direction.z = 0
	return direction
end

function FindUnitsInTrapezoid(teamNumber, vDirection, vPosition, startRadius, endRadius, flLength, hCacheUnit, targetTeam, targetUnit, targetFlags, findOrder, bCache)
	local circle_r = math.sqrt(math.pow(endRadius / 2, 2) + math.pow(flLength, 2))
	local enemy = FindUnitsInRadius(teamNumber, vPosition, hCacheUnit, circle_r, targetTeam, targetUnit, targetFlags, findOrder, bCache)
	local ta = {}
	local vStartPoint = {RotatePosition(vPosition, QAngle(0,90,0), vPosition + vDirection * (startRadius / 2)), RotatePosition(vPosition, QAngle(0,-90,0), vPosition + vDirection * (startRadius / 2))}
	local vEndPoint = {RotatePosition(vPosition + vDirection * flLength, QAngle(0,90,0), (vPosition + vDirection * flLength) + vDirection * (endRadius / 2)), RotatePosition(vPosition + vDirection * flLength, QAngle(0,-90,0), (vPosition + vDirection * flLength) + vDirection * (endRadius / 2))}
	local A = vStartPoint[1]
	local B = vEndPoint[1]
	local C = vEndPoint[2]
	local D = vStartPoint[2]
	if GameRules:IsCheatMode() then
		DebugDrawLine(A, B, 255, 0, 0, true, 5)
		DebugDrawLine(B, C, 255, 0, 0, true, 5)
		DebugDrawLine(C, D, 255, 0, 0, true, 5)
		DebugDrawLine(D, A, 255, 0, 0, true, 5)
	end
	for i=1, #enemy do
		local pos = enemy[i]:GetAbsOrigin()
		local a = (B.x - A.x) * (pos.y - A.y) - (B.y - A.y) * (pos.x - A.x)
		local b = (C.x - B.x) * (pos.y - B.y) - (C.y - B.y) * (pos.x - B.x)
		local c = (D.x - C.x) * (pos.y - C.y) - (D.y - C.y) * (pos.x - C.x)
		local d = (A.x - D.x) * (pos.y - D.y) - (A.y - D.y) * (pos.x - D.x)
		if (a >= 0 and b >= 0 and c >= 0 and d >= 0) or (a <= 0 and b <= 0 and c <= 0 and d <= 0) then
			table.insert(ta, enemy[i])
		end
	end
	return ta
end
--slardar_sprint  守卫冲刺
--/斯拉达向指定位置冲刺一段距离，对击中的每个敌方单位造成伤害。击中的第一个敌方英雄将被顶飞，并被击退。若击中树木、建筑或悬崖，目标将会被撞眩晕。/
--斯拉达向前蜿行，移动速度得到显著提升，并且可以穿越单位。
--斯拉达在河道的移动速度提升，并能突破极限。

--在水洼或河道中获得额外生命恢复、护甲和状态抗性

imba_slardar_sprint = class({})
LinkLuaModifier("modifier_imba_slardar_sprint_motion","mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slardar_sprint_buff","mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slardar_sprint_river","mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)

function imba_slardar_sprint:IsHiddenWhenStolen()  	 return false end
function imba_slardar_sprint:IsRefreshable()		return true end
function imba_slardar_sprint:IsStealable() 			 return true end
function imba_slardar_sprint:GetCastRange(location , target)
	return self:GetSpecialValueFor("sprint_range")
end
function imba_slardar_sprint:GetIntrinsicModifierName()
	return "modifier_imba_slardar_sprint_river"
end

function imba_slardar_sprint:OnSpellStart()
	local caster = self:GetCaster()	
	local direction = (self:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
	direction.z = 0.0
	local pos = (self:GetCursorPosition() - caster:GetAbsOrigin()):Length2D() <= (self:GetSpecialValueFor("sprint_range")) and self:GetCursorPosition() or caster:GetAbsOrigin() + direction * (self:GetSpecialValueFor("sprint_range"))
	local duration = (caster:GetAbsOrigin() - pos):Length2D() / (self:GetSpecialValueFor("sprint_speed") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_magnus_1"))
	--位移
	caster:AddNewModifier(caster, self, "modifier_imba_slardar_sprint_motion", {duration = duration, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z})	
	--local sound_name = "Hero_Slardar.Sprint"
	--if HeroItems:UnitHasItem(self:GetCaster(), "slardar_immortal_back_ti9") then
	local sound_name = "Hero_Slardar.Sprint.TI9"
	--end 
	caster:EmitSound(sound_name)
	ProjectileManager:ProjectileDodge(caster)
	--添加移速 相位 BUFF
	caster:AddNewModifier(caster,self,"modifier_imba_slardar_sprint_buff",{duration = self:GetSpecialValueFor("duration")})
end

modifier_imba_slardar_sprint_motion = class({})

function modifier_imba_slardar_sprint_motion:IsDebuff()				return false end
function modifier_imba_slardar_sprint_motion:IsHidden() 			return true end
function modifier_imba_slardar_sprint_motion:IsPurgable() 			return false end
function modifier_imba_slardar_sprint_motion:IsPurgeException() 	return false end
--相位
function modifier_imba_slardar_sprint_motion:CheckState() return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true} end
function modifier_imba_slardar_sprint_motion:DeclareFunctions()	return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, MODIFIER_PROPERTY_MOVESPEED_LIMIT} end
--function modifier_imba_slardar_sprint_motion:GetModifierMoveSpeed_Absolute() if IsServer() then return 1 end end
--function modifier_imba_slardar_sprint_motion:GetModifierMoveSpeed_Limit() if IsServer() then return 1 end end
function modifier_imba_slardar_sprint_motion:IsMotionController() return true end
function modifier_imba_slardar_sprint_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_slardar_sprint_motion:OnCreated(keys)
	if IsServer() then
		self.first_hitted = nil 
		self.hitted = {}
		self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
		self.bash_state = self:GetCaster():FindAbilityByName("imba_slardar_bash")
		self.speed = self:GetAbility():GetSpecialValueFor("sprint_speed") + self:GetParent():TG_GetTalentValue("special_bonus_imba_slardar_1")
		if self:CheckMotionControllers() then
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
			--特效
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_horn", self:GetParent():GetAbsOrigin(), true)
			self:AddParticle(pfx, false, false, 15, false, false)

		--	local pfx2 = ParticleManager:CreateParticle("particles/pangolier/pangolier_gyroshellaa.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		--	ParticleManager:SetParticleControl(pfx2, 0, self:GetParent():GetAbsOrigin()) --origin
		--	self:AddParticle(pfx2, false, false, -1, true, false)
		else
			self:Destroy()
		end
	end
end

function modifier_imba_slardar_sprint_motion:OnIntervalThink()
	local current_pos = self:GetParent():GetAbsOrigin()
	local distacne = self.speed / (1.0 / FrameTime())
	local direction = (self.pos - current_pos):Normalized()
	direction.z = 0
	local next_pos = GetGroundPosition((current_pos + direction * distacne), nil)
	self:GetParent():SetOrigin(next_pos)
	--当前位置
	local horn_pos = self:GetParent():GetAttachmentOrigin(self:GetParent():ScriptLookupAttachment("attach_horn"))
	--搜寻敌人
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("sprint_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		--如果是第一个敌人 被撞飞
		if not enemy:IsMagicImmune() and enemy:IsHero() and not self.first_hitted then 
			self.first_hitted = enemy
		end
		--入列
		if not IsInTable(enemy, self.hitted) and not enemy:HasModifier("modifier_imba_tricks_of_the_trade_caster") then
			--造成伤害
			if not enemy:IsMagicImmune() then 
				local damageTable = {
								victim = enemy,
								attacker = self:GetCaster(),
								damage = self:GetAbility():GetSpecialValueFor("sprint_damage_pct") * self:GetParent():GetIdealSpeed() / 100,
								damage_type = DAMAGE_TYPE_MAGICAL,
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = self:GetAbility(), --Optional.
								}
				ApplyDamage(damageTable)
			end
			--imba效果 重击冲刺
			if self.bash_state and self.bash_state:GetAutoCastState() and self.bash_state:IsCooldownReady() then 
				--音效
				enemy:EmitSound("Hero_Slardar.Bash")
				--眩晕
				enemy:AddNewModifier_RS(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_min") + self:GetParent():TG_GetTalentValue("special_bonus_imba_slardar_3")})
			end	
			--入列
			table.insert(self.hitted,enemy)
		end
	end
	--撞飞第一个敌人
	if self.first_hitted and self.first_hitted:IsAlive() then
		--改变撞击位置
		self.first_hitted:SetOrigin(GetGroundPosition(horn_pos, nil))
		--初始化kv
		local first_enemy_pos = self.first_hitted:GetAbsOrigin()
		local first_enemy = self.first_hitted
		local tree_radius = 120
		local wall_radius = 50
		local building_radius = 30
		local blocker_radius = 70
		--查看是否遇到墙 类似玛尔斯大招的墙
		local arena_walls = Entities:FindAllByClassnameWithin( "npc_dota_phantomassassin_gravestone", first_enemy_pos, wall_radius )
		for _,arena_wall in pairs(arena_walls) do
			if arena_wall:HasModifier( "modifier_mars_arena_of_blood_lua_blocker" ) then
				--撞到墙上
				self:Bumped()
				return			
			end
		end
		--查看是否遇到地图边界墙
		local thinkers = Entities:FindAllByClassnameWithin( "npc_dota_thinker", first_enemy_pos, wall_radius )
		for _,thinker in pairs(thinkers) do
			if thinker:IsPhantomBlocker() then
				--撞到墙上
				self:Bumped()
				return
			end
		end
		--查看是否遇到悬崖
		local base_loc = GetGroundPosition( first_enemy_pos, first_enemy )
		local search_loc = GetGroundPosition( base_loc + direction*wall_radius, first_enemy )
		if search_loc.z-base_loc.z>10 and (not GridNav:IsTraversable( search_loc )) then
			--撞到墙上
			self:Bumped()
			return
		end
		--查看是否遇到树
		if GridNav:IsNearbyTree( first_enemy_pos, tree_radius, false) then
			--撞到墙上
			self:Bumped()
			return
		end
		--查看是否遇到建筑
		local buildings = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			first_enemy_pos,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			building_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
			DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		if #buildings>0 then
			--撞到墙上
			self:Bumped()
			return
		end
	end
end

function modifier_imba_slardar_sprint_motion:Bumped()
	local caster = self:GetCaster()
	-- 获得碰撞视野
	AddFOWViewer(caster:GetTeamNumber(), self.first_hitted:GetOrigin(), 200, 2, false)
	-- 音效
	self.first_hitted:EmitSound("Hero_Slardar.Bash")
	--造成长时间眩晕
	self.first_hitted:AddNewModifier_RS(caster,self:GetAbility(),"modifier_stunned",{duration = self:GetAbility():GetSpecialValueFor("stun_max")})
	-- 位移结束
	self:Destroy()
end

function modifier_imba_slardar_sprint_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		if self .first_hitted and self .first_hitted:IsAlive() then 
			FindClearSpaceForUnit(self .first_hitted, self .first_hitted:GetAbsOrigin(), true)
		end
		self.first_hitted = nil 
		self.hitted = nil
		self.pos = nil
		self.speed = nil
		self:GetParent():RemoveHorizontalMotionController(self)
		--重击冷却
		if self.bash_state and self.bash_state:GetAutoCastState() and self.bash_state:IsCooldownReady() then
		--开始冷却 
			self.bash_state:StartCooldown((self.bash_state:GetCooldown(-1)) * self:GetParent():GetCooldownReduction())
		end
		self.bash_state = nil
		--添加移速 相位 BUFF
		--self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_slardar_sprint_buff",{duration = self:GetAbility():GetSpecialValueFor("duration")})
	end
end

--自身加速 相位
modifier_imba_slardar_sprint_buff = class({})

function modifier_imba_slardar_sprint_buff:IsDebuff()				return false end
function modifier_imba_slardar_sprint_buff:IsHidden() 			return false end
function modifier_imba_slardar_sprint_buff:IsPurgable() 			return true end
function modifier_imba_slardar_sprint_buff:IsPurgeException() 	return true end
function modifier_imba_slardar_sprint_buff:GetEffectName() return "particles/units/heroes/hero_slardar/slardar_sprint.vpcf" end
function modifier_imba_slardar_sprint_buff:GetEffectAttachType() return PATTACH_ROOTBONE_FOLLOW end
--PATTACH_POINT_FOLLOW PATTACH_OVERHEAD_FOLLOW
--相位
function modifier_imba_slardar_sprint_buff:CheckState() return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true} end
function modifier_imba_slardar_sprint_buff:DeclareFunctions()	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_slardar_sprint_buff:GetModifierMoveSpeedBonus_Percentage()
	--[[if self:GetCaster():HasModifier("modifier_imba_slardar_sprint_river") then
		local river_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_slardar_sprint_river",self:GetCaster())
		if river_modifier and not river_modifier:IsHidden() then 
			return self:GetAbility():GetSpecialValueFor("river_speed_tooltip")
		end
	end]]
	return self:GetAbility():GetSpecialValueFor("bonus_speed")
end

--河道和水洼加速(被动)
modifier_imba_slardar_sprint_river = class({})
function modifier_imba_slardar_sprint_river:IsDebuff() return false end
function modifier_imba_slardar_sprint_river:IsHidden() return not (self:GetParent():GetAbsOrigin().z <=0 or self:GetParent():HasModifier("modifier_imba_slardar_slithereen_crush_scepter_aura")) end
	--return not (self:GetParent():GetAbsOrigin().z < 160 and (self:GetParent():HasGroundMovementCapability()) or self:GetParent():HasModifier("modifier_imba_slardar_slithereen_crush_scepter_aura")) end
function modifier_imba_slardar_sprint_river:GetEffectName()
	if not self:IsHidden() then
		--local pfx_name = "particles/units/heroes/hero_slardar/slardar_sprint_river.vpcf"
		--if HeroItems:UnitHasItem(self:GetCaster(), "slardar_immortal_back_ti9") then
		local pfx_name = "particles/econ/items/slardar/slardar_back_ti9/slardar_back_ti9_sprint_river.vpcf"
		--end 
		return pfx_name 
	end
end

function modifier_imba_slardar_sprint_river:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(0.1)
end

function modifier_imba_slardar_sprint_river:OnIntervalThink()
	if not IsServer() then return end
	if not self:IsHidden() and not self:GetCaster():HasModifier("modifier_bloodseeker_thirst") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bloodseeker_thirst", {})
	elseif self:IsHidden() and self:GetParent():FindModifierByNameAndCaster("modifier_bloodseeker_thirst", self:GetCaster()) then
		self:GetParent():RemoveModifierByNameAndCaster("modifier_bloodseeker_thirst", self:GetCaster())
	end
end

function modifier_imba_slardar_sprint_river:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_slardar_sprint_river:GetModifierConstantHealthRegen()
	if not self:IsHidden() and self:GetCaster():HasScepter() then return self:GetAbility():GetSpecialValueFor("puddle_regen") end
end
function modifier_imba_slardar_sprint_river:GetModifierPhysicalArmorBonus()
	if not self:IsHidden() and self:GetCaster():HasScepter() then return self:GetAbility():GetSpecialValueFor("puddle_armor") end
end
function modifier_imba_slardar_sprint_river:GetModifierStatusResistanceStacking()
	if not self:IsHidden() and self:GetCaster():HasScepter() then return self:GetAbility():GetSpecialValueFor("puddle_status_resistance") end
end
function modifier_imba_slardar_sprint_river:GetModifierMoveSpeedBonus_Percentage()
	if not self:IsHidden() then return self:GetAbility():GetSpecialValueFor("river_speed") end
end

--slardar_slithereen_crush 鱼人碎击
--猛击地面，对附近地面单位造成伤害并眩晕。眩晕结束后还会受到减速。
--imba
--/斯拉达获得对应加速和提升攻击速度效果/ 
--/斯拉达每次施放鱼人碎击都会产生一滩水洼，提供与河道相同的移动速度/。

--神杖效果
--麦尔朗恩的警告：斯拉达每次施放鱼人碎击会使800码范围内不受鱼人碎击影响的敌人受到触手缠绕，该效果无法驱散.

imba_slardar_slithereen_crush = class({})

LinkLuaModifier("modifier_imba_slardar_slithereen_crush_debuff","mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slardar_slithereen_crush_buff","mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slardar_slithereen_crush_root","mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slardar_slithereen_crush_scepter","mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slardar_slithereen_crush_scepter_aura","mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)

function imba_slardar_slithereen_crush:IsHiddenWhenStolen()  return false end
function imba_slardar_slithereen_crush:IsRefreshable()		return true end
function imba_slardar_slithereen_crush:IsStealable() 	return true end
function imba_slardar_slithereen_crush:GetCastRange(location , target)
	return self:GetSpecialValueFor("crush_radius")
end

function imba_slardar_slithereen_crush:OnSpellStart()
	local caster = self:GetCaster()
	--KV
	local debuff_modifier = "modifier_imba_slardar_slithereen_crush_debuff"
	local buff_modifier = "modifier_imba_slardar_slithereen_crush_buff"
	local scepter_modifier = "modifier_imba_slardar_slithereen_crush_root"
	local allbuff_duration = self:GetSpecialValueFor("crush_extra_slow_duration")
	local stun_duration =  self:GetSpecialValueFor("stun_duration")
	local radius = self:GetSpecialValueFor("crush_radius")
	--shard ability
	local bash_abi = caster:FindAbilityByName("imba_slardar_bash")
	local armor_reduction_max = caster:GetLevel()
	if bash_abi and bash_abi:GetLevel() > 0 then 
		armor_reduction_max = bash_abi:GetSpecialValueFor("armor_reduction_max")
	end
	--特效
	--local crush_particle = "particles/units/heroes/hero_slardar/slardar_crush.vpcf"
	--local crush_target = "particles/units/heroes/hero_slardar/slardar_crush_entity.vpcf"
	--local crush_scepter = "particles/econ/items/slardar/slardar_takoyaki/slardar_crush_tako.vpcf"
	--local crush_sound = "Hero_Slardar.Slithereen_Crush"
	--[if HeroItems:UnitHasItem(self:GetCaster(), "slardar_immortal_weapon_ti6") then
	local crush_particle = "particles/econ/items/slardar/slardar_takoyaki_gold/slardar_crush_tako_gold.vpcf"
	local crush_target = "particles/econ/items/slardar/slardar_takoyaki_gold/slardar_crush_entity_tako_gold.vpcf"
	local crush_scepter = "particles/econ/items/slardar/slardar_takoyaki_gold/slardar_crush_tako_gold.vpcf"
	local crush_sound = "Hero_Slardar.Slithereen_Crush_Tako"
	--end
	--添加水洼
	local dummy = CreateModifierThinker(
		caster,
		self,
		"modifier_imba_slardar_slithereen_crush_scepter",
		{duration = self:GetSpecialValueFor("puddle_duration")},
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false		
	)
	
	--落地特效
	local crush = ParticleManager:CreateParticle(crush_particle, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(crush, 0, caster:GetAbsOrigin())
	--释放特效
	ParticleManager:DestroyParticle(crush, false)
	ParticleManager:ReleaseParticleIndex(crush)

	--猛击音效
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(),crush_sound,caster)
	local damage_table = ({
		victim = enemy,
		attacker = caster,
		ability = self,
		damage = self:GetAbilityDamage(),
		damage_type = self:GetAbilityDamageType()
	})

	--神杖效果
	if caster:HasScepter() then
		local scepter_radius = self:GetSpecialValueFor("scepter_radius")
		local scepter_root_duration = self:GetSpecialValueFor("scepter_root_duration")
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			scepter_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)
		for _,unit in pairs(units) do
			if not unit:IsMagicImmune() then
				--缠绕特效
				local unit_pfx = ParticleManager:CreateParticle(crush_scepter, PATTACH_ABSORIGIN, unit)
				ParticleManager:SetParticleControl(unit_pfx, 0, unit:GetAbsOrigin())
				ParticleManager:DestroyParticle(unit_pfx, false)
				ParticleManager:ReleaseParticleIndex(unit_pfx)
				--被缠绕
				unit:AddNewModifier_RS(caster, 
					self, 
					scepter_modifier, 
					{duration = scepter_root_duration}
				) 
				--造成伤害
				damage_table.victim = unit
				ApplyDamage(damage_table)
				-----------------------------
				--Value Shard 
				if self:GetCaster():Has_Aghanims_Shard() then 
					unit:AddNewModifier_RS(caster, bash_abi, "modifier_imba_slardar_bash_amplify_damage", {duration = 5.0})
					--叠满
					unit:SetModifierStackCount("modifier_imba_slardar_bash_amplify_damage", nil, unit:GetModifierStackCount("modifier_imba_slardar_bash_amplify_damage", nil) + armor_reduction_max)
				end
			end
		end
	else
		--碎击效果
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		for _,enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
				damage_table.victim = enemy 
				--造成伤害
				ApplyDamage(damage_table)
				--击中特效
				local target_pfx = ParticleManager:CreateParticle(crush_target, PATTACH_ABSORIGIN, enemy)
				ParticleManager:SetParticleControl(target_pfx, 0, enemy:GetAbsOrigin())
				ParticleManager:DestroyParticle(target_pfx, false)
				ParticleManager:ReleaseParticleIndex(target_pfx)
				--眩晕
				enemy:AddNewModifier_RS(self:GetCaster(), self, "modifier_stunned", {duration = stun_duration})
				--减攻速和减移速
				enemy:AddNewModifier_RS(self:GetCaster(), 
					self, 
					debuff_modifier, 
					{duration = allbuff_duration + stun_duration})
				-----------------------------
				--Value Shard
				if self:GetCaster():Has_Aghanims_Shard() then 
					enemy:AddNewModifier_RS(caster, bash_abi, "modifier_imba_slardar_bash_amplify_damage", {duration = 5.0})
					--叠满
					enemy:SetModifierStackCount("modifier_imba_slardar_bash_amplify_damage", nil, enemy:GetModifierStackCount("modifier_imba_slardar_bash_amplify_damage", nil) + armor_reduction_max)
				end
			end
		end	
	end
	
	--自己添加BUFF
	caster:AddNewModifier(
		caster,
		self,
		buff_modifier,
		{duration = allbuff_duration}
	)
	
end
--DEBUFF 减少移速和攻速
modifier_imba_slardar_slithereen_crush_debuff = class({})

function modifier_imba_slardar_slithereen_crush_debuff:IsDebuff()		return true end
function modifier_imba_slardar_slithereen_crush_debuff:IsHidden() 		return false end
function modifier_imba_slardar_slithereen_crush_debuff:IsPurgable() 		return true end
function modifier_imba_slardar_slithereen_crush_debuff:IsPurgeException() 	return true end
function modifier_imba_slardar_slithereen_crush_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_slardar_crush.vpcf" end
function modifier_imba_slardar_slithereen_crush_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_slardar_slithereen_crush_debuff:GetModifierAttackSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("crush_attack_slow_tooltip")) end
function modifier_imba_slardar_slithereen_crush_debuff:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("crush_extra_slow")) end

--BUff 增加自身攻速和移速
modifier_imba_slardar_slithereen_crush_buff = class({})
function modifier_imba_slardar_slithereen_crush_buff:IsDebuff()			return false end
function modifier_imba_slardar_slithereen_crush_buff:IsHidden() 		return false end
function modifier_imba_slardar_slithereen_crush_buff:IsPurgable() 		return true end
function modifier_imba_slardar_slithereen_crush_buff:IsPurgeException() 	return true end
function modifier_imba_slardar_slithereen_crush_buff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_imba_slardar_slithereen_crush_buff:GetModifierAttackSpeedBonus_Constant() return (self:GetAbility():GetSpecialValueFor("crush_attack_slow_tooltip")) end
function modifier_imba_slardar_slithereen_crush_buff:GetModifierMoveSpeedBonus_Percentage() return (self:GetAbility():GetSpecialValueFor("crush_extra_slow")) end

--神杖缠绕
modifier_imba_slardar_slithereen_crush_root = class({})
function modifier_imba_slardar_slithereen_crush_root:IsDebuff()			return true end
function modifier_imba_slardar_slithereen_crush_root:IsHidden() 		return false end
function modifier_imba_slardar_slithereen_crush_root:IsPurgable() 		return false end
function modifier_imba_slardar_slithereen_crush_root:IsPurgeException() 	return false end
function modifier_imba_slardar_slithereen_crush_root:GetEffectName() return "particles/status_fx/status_effect_slardar_crush.vpcf" end
function modifier_imba_slardar_slithereen_crush_root:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_slardar_slithereen_crush_root:CheckState() return {[MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_ROOTED] = true,[MODIFIER_STATE_SILENCED] = true} end

--斯拉达每次施放鱼人碎击都会产生一滩水洼，提供与河道相同的移动速度及其他加成。
modifier_imba_slardar_slithereen_crush_scepter = class({})

function modifier_imba_slardar_slithereen_crush_scepter:IsDebuff()			return false end
function modifier_imba_slardar_slithereen_crush_scepter:IsHidden() 			return true end
function modifier_imba_slardar_slithereen_crush_scepter:IsPurgable() 		return false end
function modifier_imba_slardar_slithereen_crush_scepter:IsPurgeException() 	return false end
function modifier_imba_slardar_slithereen_crush_scepter:IsAura() return true end
function modifier_imba_slardar_slithereen_crush_scepter:GetAuraDuration() return 0.1 end
function modifier_imba_slardar_slithereen_crush_scepter:GetModifierAura() return "modifier_imba_slardar_slithereen_crush_scepter_aura" end
function modifier_imba_slardar_slithereen_crush_scepter:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("puddle_radius") end
function modifier_imba_slardar_slithereen_crush_scepter:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end
function modifier_imba_slardar_slithereen_crush_scepter:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_slardar_slithereen_crush_scepter:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_imba_slardar_slithereen_crush_scepter:OnCreated()
	if IsServer() then
		local puddle_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_water_puddle.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(puddle_particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(puddle_particle, 1, Vector(self:GetAbility():GetSpecialValueFor("scepter_puddle_radius"), 0, 0))
		self:AddParticle(puddle_particle, false, false, -1, false, false)
	end
end

function modifier_imba_slardar_slithereen_crush_scepter:OnDestroy()
	if IsServer() then 
		self:GetParent():ForceKill(false)
		return 
	end
end

modifier_imba_slardar_slithereen_crush_scepter_aura = class({})

function modifier_imba_slardar_slithereen_crush_scepter_aura:IsDebuff()			return false end
function modifier_imba_slardar_slithereen_crush_scepter_aura:IsHidden() 			return true end
function modifier_imba_slardar_slithereen_crush_scepter_aura:IsPurgable() 			return false end
function modifier_imba_slardar_slithereen_crush_scepter_aura:IsPurgeException() 	return false end

--slardar_bash 深海重击
--攻击%attack_count%次后，下次攻击将击晕目标。

--不能与碎颅锤叠加 lore
--imba slardar_amplify_damage 侵蚀雾霭:首次攻击削弱2/3/4/5护甲,之后每次攻击削弱敌人的1护甲，最多削弱10/18/24/35护甲，加深他受到的物理伤害，同时提供目标的真实视域，显示隐身单位。

--重击冲刺：也可以使用自动施法，冷却时间内使用守卫冲刺将会对每个遇到的敌方单位造成当前重击等级眩晕，该效果无视技能免疫
--CD 10/15/20/25

--斯拉达教你做人：攻击受鱼人碎击神杖效果影响的单位必定触发重击

imba_slardar_bash = class({})
LinkLuaModifier("modifier_imba_slardar_bash_passive","mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slardar_bash_buff","mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slardar_bash_charge","mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slardar_bash_amplify_damage","mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)

function imba_slardar_bash:IsHiddenWhenStolen() 		return false end
function imba_slardar_bash:IsRefreshable() 			return true end
function imba_slardar_bash:IsStealable() 				return false end
function imba_slardar_bash:GetIntrinsicModifierName() return "modifier_imba_slardar_bash_passive" end

function imba_slardar_bash:OnOwnerDied()
	--self.toggle = self:GetToggleState()
	self.toggle = self:GetAutoCastState()
	if self:GetAutoCastState() then 
		self:ToggleAutoCast()
	end
end

function imba_slardar_bash:OnOwnerSpawned()
	if self.toggle == nil then
		self.toggle = false
	end
	if self:GetAutoCastState() then 
		self:ToggleAutoCast()
	end
end

modifier_imba_slardar_bash_passive = class({})

function modifier_imba_slardar_bash_passive:IsDebuff()			return false end
function modifier_imba_slardar_bash_passive:IsHidden() 			return true end
function modifier_imba_slardar_bash_passive:IsPurgable() 		return false end
function modifier_imba_slardar_bash_passive:IsPurgeException() 	return false end
function modifier_imba_slardar_bash_passive:AllowIllusionDuplicate() return false end
function modifier_imba_slardar_bash_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_START,MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_slardar_bash_passive:OnAttackStart(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	--imba 攻击次数监测 攻击受鱼人碎击神杖效果影响的单位必定触发重击
	if keys.target:HasModifier("modifier_imba_slardar_slithereen_crush_root") or self:GetParent():GetModifierStackCount("modifier_imba_slardar_bash_charge", nil) >= self:GetAbility():GetSpecialValueFor("attack_count") then
		--额外攻击力
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_slardar_bash_buff", {})
	end
end
function modifier_imba_slardar_bash_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end

	local parent = self:GetParent()
	local passive = self:GetAbility()
	local stun_duration = passive:GetSpecialValueFor("duration") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_slardar_3")
	local reduce_duration = passive:GetSpecialValueFor("reduce_duration")
	local armor_reduction_first = passive:GetSpecialValueFor("armor_reduction_first")
	local armor_reduction_max = passive:GetSpecialValueFor("armor_reduction_max")
	local armor_reduction_once = passive:GetSpecialValueFor("armor_reduction_once")

	--imba 侵蚀雾霭
	if not keys.target:HasModifier("modifier_imba_slardar_bash_amplify_damage") then 
		keys.target:AddNewModifier_RS(parent, passive, "modifier_imba_slardar_bash_amplify_damage", {duration = reduce_duration})
		--首次叠加
		keys.target:SetModifierStackCount("modifier_imba_slardar_bash_amplify_damage", nil, keys.target:GetModifierStackCount("modifier_imba_slardar_bash_amplify_damage", nil) + armor_reduction_first)
	else
		--刷新
		keys.target:AddNewModifier_RS(parent, passive, "modifier_imba_slardar_bash_amplify_damage", {duration = reduce_duration}) 
		--每次叠加1层 + 技能等级层数
		if keys.target:GetModifierStackCount("modifier_imba_slardar_bash_amplify_damage", nil) < armor_reduction_max then
			keys.target:SetModifierStackCount("modifier_imba_slardar_bash_amplify_damage", nil, keys.target:GetModifierStackCount("modifier_imba_slardar_bash_amplify_damage", nil) + armor_reduction_once)
		elseif keys.target:GetModifierStackCount("modifier_imba_slardar_bash_amplify_damage", nil) > armor_reduction_max then 
			keys.target:SetModifierStackCount("modifier_imba_slardar_bash_amplify_damage", nil, armor_reduction_max )
		end
	end
	--imba 设置攻击次数
	local buff = parent:AddNewModifier(parent, passive, "modifier_imba_slardar_bash_charge", {})
	--攻击受鱼人碎击神杖效果影响的单位必定触发重击
	if keys.target:HasModifier("modifier_imba_slardar_slithereen_crush_root") then
		--造成眩晕
		keys.target:AddNewModifier_RS(parent, passive, "modifier_stunned", {duration = stun_duration})
		parent:RemoveModifierByName("modifier_imba_slardar_bash_buff")
		return 
	end
	--imba 攻击次数监测
	if buff:GetStackCount() >= passive:GetSpecialValueFor("attack_count") then
		--造成眩晕
		keys.target:AddNewModifier_RS(parent, passive, "modifier_stunned", {duration = stun_duration})
		parent:RemoveModifierByName("modifier_imba_slardar_bash_buff") 
		buff:Destroy()
	else
		--增加计数
		buff:IncrementStackCount()
	end
end

--计数
modifier_imba_slardar_bash_charge = class({})
function modifier_imba_slardar_bash_charge:IsHidden()			return false end
function modifier_imba_slardar_bash_charge:IsDebuff() 			return false end
function modifier_imba_slardar_bash_charge:IsPurgable() 		return false end
function modifier_imba_slardar_bash_charge:IsPurgeException()	return false end
--额外攻击力
modifier_imba_slardar_bash_buff = class({})
function modifier_imba_slardar_bash_buff:IsHidden()			return true end
function modifier_imba_slardar_bash_buff:IsDebuff()			return false end
function modifier_imba_slardar_bash_buff:IsPurgable() 		return false end
function modifier_imba_slardar_bash_buff:IsPurgeException() 	return false end
function modifier_imba_slardar_bash_buff:DeclareFunctions()  return {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE} end
function modifier_imba_slardar_bash_buff:GetModifierBaseAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_slardar_2") end
--减少护甲
modifier_imba_slardar_bash_amplify_damage = class({})

function modifier_imba_slardar_bash_amplify_damage:IsDebuff()			return true end
function modifier_imba_slardar_bash_amplify_damage:IsHidden() 			return false end
function modifier_imba_slardar_bash_amplify_damage:IsPurgable() 		
	if self:GetCaster():TG_HasTalent("special_bonus_imba_slardar_1") then
		return false 
	else
		return true
	end
end
function modifier_imba_slardar_bash_amplify_damage:RemoveOnDeath() return true end
function modifier_imba_slardar_bash_amplify_damage:GetPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_imba_slardar_bash_amplify_damage:GetTexture() return "slardar_amplify_damage" end
function modifier_imba_slardar_bash_amplify_damage:GetEffectName() return "particles/econ/items/slardar/slardar_ti10_head/slardar_ti10_gold_amp_damage.vpcf" end
function modifier_imba_slardar_bash_amplify_damage:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
--MODIFIER_PRIORITY_SUPER_ULTRA
function modifier_imba_slardar_bash_amplify_damage:CheckState()
	if self:GetParent():HasModifier("modifier_slark_shadow_dance") then
		local state = {[MODIFIER_STATE_PROVIDES_VISION] = true}
		return state
	end
	--显影
	local state = {[MODIFIER_STATE_PROVIDES_VISION] = true,
		[MODIFIER_STATE_INVISIBLE] = false}
	return state
end
function modifier_imba_slardar_bash_amplify_damage:DeclareFunctions() return {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_slardar_bash_amplify_damage:GetModifierProvidesFOWVision() 
	if not self:GetParent():HasModifier("modifier_slark_shadow_dance") then
		return 1 
	else
		return 0
	end
end
function modifier_imba_slardar_bash_amplify_damage:GetModifierPhysicalArmorBonus() 
	return (0 - self:GetStackCount()) 
end

--slardar_trap 深海陷阱
--斯拉达点亮头灯，持续时间内魅惑范围内的所有敌人缓慢向斯拉达移动.完全施法完毕，触手将吞噬%eaten_radius%范围的敌人，造成目标%base_damage%伤害和目标当前生命值%damage_pct%%的魔法伤害.不在吞噬范围内的只受到基础伤害
--imba 雾霭来袭:施法开始对受影响的目标施放斯拉达等级削弱护甲的侵蚀雾霭.

imba_slardar_trap = class({})

LinkLuaModifier("modifier_imba_slardar_trap_caster", "mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slardar_trap_thinker", "mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slardar_trap_target", "mb/hero_slardar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_surge_buff", "heros/hero_dark_seer/surge.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function imba_slardar_trap:IsHiddenWhenStolen() 		return false end
function imba_slardar_trap:IsRefreshable() 			return true end
function imba_slardar_trap:IsStealable() 				return true end
function imba_slardar_trap:GetCastRange(location , target) return self.BaseClass.GetCastRange(self,location,target) + self:GetCaster():GetCastRangeBonus() end
function imba_slardar_trap:GetAOERadius() return self:GetSpecialValueFor("trap_radius") end

function imba_slardar_trap:OnSpellStart()
	local caster = self:GetCaster()
	--local pos = self:GetCursorPosition()
	local pos = self:GetCaster():GetAbsOrigin()
	--self.pos = pos
	self.thinker = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = self:GetSpecialValueFor("duration") + FrameTime() * 2}, pos, caster:GetTeamNumber(), false)
	self.thinker:AddNewModifier(caster, self, "modifier_imba_slardar_trap_thinker", {duration = self:GetSpecialValueFor("duration")})
	GameRules:BeginNightstalkerNight(self:GetSpecialValueFor("duration"))
	--隐身
	caster:AddNewModifier(caster, self, "modifier_imba_slardar_trap_caster", {duration = self:GetSpecialValueFor("duration")})
	--播放斯拉达信息
	--Notifications:BottomToAll({text = "#slardar_trap_breathe", duration = 2.0, style = {["font-size"] = "50px", color = "Blue"} })
end

--function imba_slardar_trap:OnChannelFinish(bInterrupted)
function imba_slardar_trap:OnTrapFinish(bInterrupted)
	if self.thinker and not self.thinker:IsNull() then
		local buff = self.thinker:FindModifierByName("modifier_imba_slardar_trap_thinker")
		Timers:CreateTimer(FrameTime(), function()
				if buff ~= nil and not buff:IsNull() then 
					buff:SetDuration( 0.1, true )
				end
				return nil
			end
		)
		self.thinker:ForceKill(false)
	end
	--清理KV
	--self.pos = nil
end

--隐身 
modifier_imba_slardar_trap_caster = class({})

LinkLuaModifier("modifier_generic_invisible_lua", "mb/generic/modifier_generic_invisible_lua.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_slardar_trap_caster:IsDebuff()			return false end
function modifier_imba_slardar_trap_caster:IsHidden() 			return true end
function modifier_imba_slardar_trap_caster:IsPurgable() 		return false end
function modifier_imba_slardar_trap_caster:IsPurgeException() 	return false end
function modifier_imba_slardar_trap_caster:OnCreated(keys)
	if not IsServer() then return end
	--如果没攻击就进入隐身
	if not self:GetParent():HasModifier("modifier_generic_invisible_lua") then 
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_invisible_lua", {duration = self:GetRemainingTime()})
	end
	self:StartIntervalThink(0.3)
end

function modifier_imba_slardar_trap_caster:OnIntervalThink()
	--移动替身
	if self:GetAbility().thinker and not self:GetAbility().thinker:IsNull() then
		self:GetAbility().thinker:SetOrigin(self:GetParent():GetAbsOrigin())
	end
end
function modifier_imba_slardar_trap_caster:DeclareFunctions() return {MODIFIER_EVENT_ON_ORDER,MODIFIER_EVENT_ON_ATTACK_LANDED} end
function modifier_imba_slardar_trap_caster:OnOrder( params )
	if params.unit~=self:GetParent() then return end
	-- right click, force attack
	if  params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET then 
		--获得加速
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_surge_buff", {duration = self:GetRemainingTime()})
	end
end
function modifier_imba_slardar_trap_caster:OnAttackLanded(keys)
	if not IsServer() then
		return 
	end
	if keys.attacker ~= self:GetParent() or self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() or not keys.target:IsAlive() then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() then
		return
	end
	--移除隐身效果
	if self:GetParent():HasModifier("modifier_generic_invisible_lua") then 
		self:GetParent():RemoveModifierByName("modifier_generic_invisible_lua")
	end
end
function modifier_imba_slardar_trap_caster:OnDestroy()
	if not IsServer() then return end
	--print("trap caster duration",self:GetRemainingTime())
	self:GetAbility():OnTrapFinish(true)
end

--范围引诱监视器
modifier_imba_slardar_trap_thinker = class({})

function modifier_imba_slardar_trap_thinker:OnCreated()
	if IsServer() then
		self:GetParent():EmitSound("Hero_Slardar.Amplify_Damage")
		self.trap_table = {}
		local pfx = ParticleManager:CreateParticle("particles/ambient/tower_laser_blind.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(pfx, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_portrait", self:GetCaster():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)

		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_slardar_trap_thinker:OnIntervalThink()
	if not IsServer() then return end
	--local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("trap_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	local direction = GetDirection2D(self:GetCaster():GetAbsOrigin(), self:GetParent():GetAbsOrigin())
	local enemies =	FindUnitsInTrapezoid(self:GetCaster():GetTeamNumber(), direction, GetGroundPosition(self:GetParent():GetAbsOrigin(), nil), self:GetAbility():GetSpecialValueFor("eaten_radius"), self:GetAbility():GetSpecialValueFor("trap_radius"), self:GetAbility():GetSpecialValueFor("trap_radius"), nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	if self:GetCaster():TG_HasTalent("special_bonus_imba_slardar_4") then 
		enemies = FindUnitsInTrapezoid(self:GetCaster():GetTeamNumber(), direction, GetGroundPosition(self:GetParent():GetAbsOrigin(), nil), self:GetAbility():GetSpecialValueFor("eaten_radius"), self:GetAbility():GetSpecialValueFor("trap_radius"), self:GetAbility():GetSpecialValueFor("trap_radius"), nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		--enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("trap_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	end
	for _,enemy in pairs(enemies) do
	  	if not enemy:HasModifier("modifier_imba_slardar_bash_amplify_damage") then 
			--音效
			enemy:EmitSound("Hero_Lich.SinisterGaze.Target")
			--imba 侵蚀雾霭
			enemy:AddNewModifier_RS(self:GetCaster(), self:GetAbility(), "modifier_imba_slardar_bash_amplify_damage", {duration = 15})
			enemy:SetModifierStackCount("modifier_imba_slardar_bash_amplify_damage", nil, enemy:GetModifierStackCount("modifier_imba_slardar_bash_amplify_damage", nil) + self:GetCaster():GetLevel())
		end	
		--记录
		if not IsInTable(enemy,self.trap_table) then 
			table.insert(self.trap_table, enemy)
		end
	end
end


function modifier_imba_slardar_trap_thinker:OnDestroy()
	if IsServer() then
		local damageTable = {
						attacker = self:GetCaster(),
						damage_type = self:GetAbility():GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self:GetAbility(), --Optional.
						}
		for _,enemy in pairs(self.trap_table) do
			if not enemy:IsNull() and enemy:IsAlive() and not enemy:IsMagicImmune() then 
				enemy:StopSound("Hero_Lich.SinisterGaze.Target")
				enemy:EmitSound("Hero_Slardar.Amplify_Damage")
				damageTable.victim = enemy
				damageTable.damage = self:GetAbility():GetSpecialValueFor("base_damage") + self:GetAbility():GetSpecialValueFor("damage_pct") * enemy:GetHealth()/100
				ApplyDamage(damageTable)
				--1
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = 1.0})
				--击中特效
				local target_pfx = ParticleManager:CreateParticle("particles/econ/items/slardar/slardar_takoyaki_gold/slardar_crush_tako_teeth_gold.vpcf", PATTACH_ABSORIGIN, food)
				ParticleManager:SetParticleControl(target_pfx, 0, enemy:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(target_pfx)
			end
		end
	end
end

-----------------
--废弃
--引诱
modifier_imba_slardar_trap_target = class({})

function modifier_imba_slardar_trap_target:IsDebuff()			return true end
function modifier_imba_slardar_trap_target:IsHidden() 			return false end
function modifier_imba_slardar_trap_target:IsPurgable() 		return true end
function modifier_imba_slardar_trap_target:IsPurgeException() 	return true end
function modifier_imba_slardar_trap_target:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_FROZEN] = true} end

function modifier_imba_slardar_trap_target:OnCreated()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/ambient/tower_laser_blind.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		--particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf
		--local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_portrait", self:GetCaster():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_slardar_trap_target:OnIntervalThink()
	local direction = GetDirection2D(self.caster:GetAbsOrigin(), self.parent:GetAbsOrigin())
	local distance = self.ability:GetSpecialValueFor("destination") / (1.0 / FrameTime())
	local next_pos = GetGroundPosition(self.parent:GetAbsOrigin() + direction * distance, self.parent)
	self.parent:SetForwardVector(direction)
	self.parent:SetOrigin(next_pos)
end

function modifier_imba_slardar_trap_target:OnDestroy()
	if IsServer() then
		GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), 200, false)
		FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
	end
end