CreateTalents("npc_dota_hero_tiny", "ting/hero_tiny")
--山崩
imba_tiny_avalanche = class({})
LinkLuaModifier("modifier_imba_tiny_toss_self", "ting/hero_tiny", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_tiny_tree_animation", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tiny_avalanche_thinker", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tiny_avalanche_flags", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)


function imba_tiny_avalanche:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function imba_tiny_avalanche:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	local Talent = caster:TG_GetTalentValue("special_bonus_imba_tiny_7")
	local  Getcd = cooldown - Talent
	if caster:TG_HasTalent("special_bonus_imba_tiny_7") then
		return (Getcd)
	end
	return cooldown
end
function imba_tiny_avalanche:OnSpellStart()
	local vPos = self:GetCursorPosition()
    local caster = self:GetCaster()
	self.casterPos = caster:GetAbsOrigin()
	self.direction = TG_Direction(vPos, self.casterPos)
	local duration = self:GetSpecialValueFor("total_duration")*math.max(caster:GetModelScale(),1)
	caster:StartGesture(ACT_TINY_AVALANCHE)
    EmitSoundOnLocationWithCaster(vPos, "Ability.Avalanche", caster)
	CreateModifierThinker( self:GetCaster(), self, "modifier_imba_tiny_avalanche_thinker", { duration = duration ,direction_x = self.direction.x,direction_y = self.direction.y,direction_z = self.direction.z}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end



modifier_imba_tiny_avalanche_thinker = class({})
LinkLuaModifier("modifier_imba_tiny_avalanche_flags", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------

function modifier_imba_tiny_avalanche_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_imba_tiny_avalanche_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_imba_tiny_avalanche_thinker:OnCreated( kv )
	if IsServer() then
		self.damage = self:GetAbility():GetSpecialValueFor("damage_per")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")*math.max(self:GetCaster():GetModelScale(),1)
		self.interval= self:GetAbility():GetSpecialValueFor("damage_interval")
		self.movement = self.radius*2
		self.direction = Vector(kv.direction_x,kv.direction_y,kv.direction_z)
		self.tick = 3
		self.Avalanches = {}

		self:OnIntervalThink()
		self:StartIntervalThink( self.interval )
	end
end

--------------------------------------------------------------------------------

function modifier_imba_tiny_avalanche_thinker:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():IsNull() then
			self:Destroy()
			return
		end

		local vNewAvalancheDir1 = self.direction

		if self.tick >= 3 then
			EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Ability.Avalanche", self:GetCaster() )

			local vRadius = Vector( self.radius, self.radius, self.radius )
			local nFXIndex1 = ParticleManager:CreateParticle( "particles/creatures/storegga/storegga_avalanche.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex1, 0, self:GetParent():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex1, 1, vRadius )
			ParticleManager:SetParticleControlForward( nFXIndex1, 0, vNewAvalancheDir1 )
			self:AddParticle( nFXIndex1, false, false, -1, false, false )
			self.tick = self.tick - 3
			local Avalanche1 =
			{
			vCurPos = self:GetParent():GetAbsOrigin()- vNewAvalancheDir1 * self.movement,
			vDir = vNewAvalancheDir1,
			nFX = nFXIndex1,
			}

		table.insert( self.Avalanches, Avalanche1 )
			for _,ava in pairs ( self.Avalanches ) do
				local vNewPos = ava.vCurPos + ava.vDir * self.movement
				vNewPos.z = GetGroundHeight( vNewPos, self:GetCaster() )
				ava.vCurPos = vNewPos
				ParticleManager:SetParticleControl( ava.nFX, 0, vNewPos )
				local caster  = self:GetCaster()
				local target = CreateModifierThinker(caster, self:GetAbility(), "modifier_dummy_thinker", {duration = 5}, ava.vCurPos, caster:GetTeamNumber(), false)
			end
		end

		for _,ava in pairs ( self.Avalanches ) do
			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), ava.vCurPos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false then
					enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_tiny_avalanche_flags",{duration = 1})
					enemy:AddNewModifier_RS(self:GetCaster(),self:GetAbility(),"modifier_imba_stunned",{duration = 0.2})
					local damageInfo =
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility(),
					}
					ApplyDamage( damageInfo )
				end
			end
		end
		self.tick = self.tick + 1
	end
end
--投掷
imba_tiny_toss = class({})
LinkLuaModifier("modifier_imba_tiny_toss_self", "ting/hero_tiny", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_tiny_toss_motion", "ting/hero_tiny", LUA_MODIFIER_MOTION_HORIZONTAL)
function imba_tiny_toss:IsStealable() return false end
function imba_tiny_toss:CastFilterResultLocation(location)
	if not IsServer() then return end
	local alls = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("grab_radius")*math.max(1,self:GetCaster():GetModelScale()*0.8), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP, FIND_ANY_ORDER, false)
		local count = 0
		for _,all in pairs(alls) do
			if all:HasModifier("modifier_imba_tiny_tree_grab_debuff") then
				count = count +1
			end
		end
		if #alls - count <=1 then
		return UF_FAIL_CUSTOM
		end
		return UF_SUCCESS
end

function imba_tiny_toss:GetCustomCastErrorLocation(location)
	return "附近没有垃圾给你扔"
end

function imba_tiny_toss:OnSpellStart()
	local caster = self:GetCaster()
	local max_dis = self:GetSpecialValueFor("toss_dis") + caster:GetCastRangeBonus()
	local dur = self:GetSpecialValueFor("duration")
	local stun_dur = self:GetSpecialValueFor("stun_duration")
	local pos = self:GetCursorPosition()
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	local height = 700
	local distance = (pos - caster:GetAbsOrigin()):Length2D() + height/2
	local tralve_duration = distance/max_dis *dur
	local radius = self:GetSpecialValueFor("grab_radius")*math.max(1,caster:GetModelScale()*0.8)
	local damage = self:GetSpecialValueFor("damage")
	local impact_radius = self:GetSpecialValueFor("radius")
	local count = caster:TG_GetTalentValue("special_bonus_imba_tiny_5") + 1
	caster:StartGesture(ACT_TINY_TOSS)
	EmitSoundOn("Ability.TossThrow", caster)
	local enemies_tick =  FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
			caster:GetAbsOrigin(), nil, radius,
			DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE,FIND_CLOSEST, false)
    for _,enemy in pairs(enemies_tick) do
		EmitSoundOn("Hero_Tiny.Toss.Target", enemy)
		if enemy ~= self:GetCaster() and not enemy:HasModifier("modifier_imba_tiny_craggy_mod") and not enemy:HasModifier("modifier_imba_tiny_tree_grab_debuff") then
		if not Is_Chinese_TG(enemy,caster) then
		enemy:AddNewModifier_RS(caster, self, "modifier_imba_stunned", {duration = stun_dur})
		end
		enemy:AddNewModifier(caster, self, "modifier_imba_tiny_toss_motion", {duration = tralve_duration, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z, dis = distance,height = height ,damage = damage ,impact_radius = impact_radius})
		count = count - 1
		if count == 0  then
			return
		end
		end
	end
end

modifier_imba_tiny_toss_motion = class({})

function modifier_imba_tiny_toss_motion:IsDebuff()			return false end
function modifier_imba_tiny_toss_motion:IsHidden() 			return true end
function modifier_imba_tiny_toss_motion:IsPurgable() 		return false end
function modifier_imba_tiny_toss_motion:IsPurgeException() 	return false end
function modifier_imba_tiny_toss_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION,MODIFIER_EVENT_ON_ORDER} end
function modifier_imba_tiny_toss_motion:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_imba_tiny_toss_motion:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end
function modifier_imba_tiny_toss_motion:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_INVULNERABLE] = Is_Chinese_TG(self:GetParent(),self:GetCaster()),}
end
function modifier_imba_tiny_toss_motion:IsMotionController() return true end
function modifier_imba_tiny_toss_motion:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_tiny_toss_motion:OnCreated(keys)
	if IsServer() then
		if self:CheckMotionControllers() then
			self.impact_radius = keys.impact_radius
			--print(self.impact_radius)
			self.duration = keys.duration
			self.damage = keys.damage
			--print(self.damage)
			self.pos = Vector(keys.pos_x, keys.pos_y, keys.pos_z)
			self.dis = keys.dis
			local dis_t =(self.dis/self.duration)
			self.distance = dis_t*FrameTime()
			self.height = keys.height
			self.dist_a = 0
			self:OnIntervalThink()
			self:StartIntervalThink(FrameTime())
		else
			self:Destroy()
		end
	end
end
function modifier_imba_tiny_toss_motion:OnOrder(keys)
	if not IsServer() then
		return
	end
	if keys.unit==self:GetParent() and Is_Chinese_TG(self:GetParent(),self:GetCaster())then
		if  keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
			self:Destroy()
		end
	end
end
function modifier_imba_tiny_toss_motion:OnIntervalThink()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local distance = self.distance
	local direction = (self.pos - self:GetParent():GetAbsOrigin()):Normalized()
	direction.z = 0.0
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + direction * distance, nil)
	next_pos.z = next_pos.z - 4 * self.height * motion_progress ^ 2 + 4 * self.height * motion_progress
	self:GetParent():SetOrigin(next_pos)

end

function modifier_imba_tiny_toss_motion:OnDestroy()
	if IsServer() then
		self.pos = nil
		self.height = nil

		EmitSoundOn("Ability.TossImpact", self:GetParent())
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.impact_radius, self.impact_radius, self.impact_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
			for _,enemy in pairs( enemies ) do
					--enemy:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_tiny_avalanche_flags",{duration = 1})
					local damageInfo =
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility(),
					}
					ApplyDamage( damageInfo )
			end
		if self:GetParent():HasModifier("modifier_imba_tiny_avalanche_flags") then
			local damageInfo =
					{
						victim = self:GetParent(),
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility(),
					}
					ApplyDamage( damageInfo )
		end
		--小投掷
		if self:GetParent():GetName() == "npc_dota_broodmother_spiderling" then
			local radius = self:GetAbility():GetSpecialValueFor("grab_radius")*math.max(1,self:GetCaster():GetModelScale()*0.8)
			local pos = self:GetCaster():GetAbsOrigin()
			local direction = (pos - self:GetParent():GetAbsOrigin()):Normalized()
			local height = 750
			local distance = math.min((pos - self:GetParent():GetAbsOrigin()):Length2D() + height/2,self:GetAbility():GetSpecialValueFor("toss_dis")+self:GetCaster():GetCastRangeBonus())
			local enemies_tick =  FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(), nil, 300,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE,FIND_CLOSEST, false)

				if #enemies_tick >= 1 then
				for _,e in pairs(enemies_tick) do
					if not e:HasModifier("modifier_imba_tiny_tree_grab_debuff") then
						EmitSoundOn("Hero_Tiny.Toss.Target", e)
						self:GetParent():StartGesture(ACT_TINY_TOSS)
						e:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_tiny_toss_motion",
							{duration = 0.9, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z, dis = distance,height = height ,damage = self.damage,impact_radius = self.impact_radius})
							return
					end
				end
				end
		end
	end
end


modifier_imba_tiny_toss_self = class({})
function modifier_imba_tiny_toss_self:IsHidden()		return false end
function modifier_imba_tiny_toss_self:IsPurgable()	return false end
function modifier_imba_tiny_toss_self:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end
function modifier_imba_tiny_toss_self:GetStatusEffectName()	return "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_cast_flame.vpcf" end
function modifier_imba_tiny_toss_self:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end
function modifier_imba_tiny_toss_self:GetPriority() return {MODIFIER_PROPERTY_ULTRA} end
function modifier_imba_tiny_toss_self:IsMotionController() return true end
function modifier_imba_tiny_toss_self:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_imba_tiny_toss_self:OnCreated(keys)
	if IsServer() then
		self.direction = StringToVector(keys.direction)
		self.speed = 800
		self.caster =self:GetParent()
		self.caster:AddActivityModifier("taunt_ti9")
		self.caster:StartGestureWithPlaybackRate(ACT_DOTA_TAUNT, 0.7)
		self.dis = 0
		self.time = 0
		self.z = self:GetParent():GetAbsOrigin().z

		--self.caster:StartGesture(ACT_DOTA_TAUNT)
		self:GetCaster():EmitSound("Hero_Huskar.Life_Break")
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_tiny_toss_self:OnIntervalThink()
	local me = self:GetParent()
	local dt = FrameTime()
	local new_pos = me:GetAbsOrigin() + self.direction * (self.speed / (1.0 / dt))
	self.time = self.time + dt
	if self.time > 0.2 then
		local grow = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(grow, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(grow)
		self.time = self.time - 0.2
	end

	local mods = self.caster:GetModelScale()
	self.dis = self.dis+self.speed*dt
	self.direction.z = 0.0
	if self.dis < 120 then
	new_pos.z =self.z*((self.dis+30)/120)
	elseif self.dis > 990 then
	new_pos.z = self.z*(990/self.dis)
	else
	new_pos.z = self.z/(2.5*mods)
	end
--[[
	if self.dis < 120 then
	new_pos.z = 350 - (mods-0.9)*self.dis+self.z
	elseif self.dis > 990 then
	new_pos.z = 1200 - self.dis -mods*300+self.z
	else
	new_pos.z = 120 - (mods-1)*100 + self.z
	end]]
	if self.dis>1100 then
		self:StartIntervalThink(-1)
		self:OnDestroy()
		return
	end
	me:SetOrigin(new_pos)
end

function modifier_imba_tiny_toss_self:OnDestroy()
	if IsServer() then
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	self.direction = nil
	self.speed = nil
	self.caster = nil
	end
end
--抓树 / 扔树




imba_tiny_tree_grab = class({})
LinkLuaModifier("modifier_imba_tiny_grabtree", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tiny_tree_grab_debuff", "ting/hero_tiny", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_imba_tiny_tree_grab_hero_flag", "ting/hero_tiny", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_imba_tiny_toss_tree_flag", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tiny_tree_grab_flag", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)
function imba_tiny_tree_grab:GetAbilityTextureName()
		if self:GetCaster():HasModifier("modifier_imba_tiny_tree_grab_hero_flag") and self:GetCaster():HasModifier("modifier_imba_tiny_grabtree") then
			return "tiny_tree_grab_png"
		end
		if not self:GetCaster():HasModifier("modifier_imba_tiny_tree_grab_hero_flag") and not self:GetCaster():HasModifier("modifier_imba_tiny_grabtree") then
			return "tiny_tree_grab_png"
		end
		return "tiny_toss_tree_png"
end

function imba_tiny_tree_grab:GetCastRange()
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_imba_tiny_grabtree") or self:GetCaster():HasModifier("modifier_imba_tiny_tree_grab_hero_flag") then
		return 1300
		end
		return 275*math.max(self:GetCaster():GetModelScale(),1) - self:GetCaster():GetCastRangeBonus()
	end
	return 200
end
function imba_tiny_tree_grab:CastFilterResultTarget(target)
	if IsServer() then
	if not self:GetCaster():HasModifier("modifier_imba_tiny_grabtree") and not self:GetCaster():HasModifier("modifier_imba_tiny_tree_grab_hero_flag") then

		if target~=nil then
			--print(tostring(target:GetName()))
			if string.find(target:GetUnitName(), "npc_dota_creep") then
				return UF_FAIL_CUSTOM
			end
			if target:IsBuilding() or (not Is_Chinese_TG(self:GetCaster(),target) and target:IsMagicImmune()) or target == self:GetCaster() then
				return UF_FAIL_CUSTOM
			end
		end

	end
	return UF_SUCCESS
	end
end

function imba_tiny_tree_grab:GetCustomCastErrorTarget(target)
	if target:IsCreep()  then
		return "又想偷了是吧"
	end
	if target == self:GetCaster() then
		return "自己抓自己想上天是吧"
	end
	return "你怎么什么都想抓"
end

function imba_tiny_tree_grab:OnSpellStart()
	local pos = self:GetCursorPosition()
	local caster = self:GetCaster()
	local distance = (pos - caster:GetAbsOrigin()):Length2D()
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	EmitSoundOn("Hero_Tiny.Tree.Throw", caster)
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4_END)

	if caster:HasModifier("modifier_imba_tiny_grabtree") then
		local info =
    {
        Ability = self,
		EffectName = "particles/units/heroes/hero_tiny/tiny_tree_linear_proj.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = 0,
		fEndRadius = 0,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_NONE,
		bDeleteOnHit = true,
		vVelocity = direction*self:GetSpecialValueFor("speed"),
		bProvidesVision = false,
    }
    ProjectileManager:CreateLinearProjectile(info)
	caster:RemoveModifierByName("modifier_imba_tiny_grabtree")
		if caster:HasModifier("modifier_imba_tiny_tree_grab_flag") then
			local mod = caster:FindModifierByName("modifier_imba_tiny_tree_grab_flag")
			self:EndCooldown()
			self:StartCooldown( mod:GetRemainingTime() )
			caster:RemoveModifierByName("modifier_imba_tiny_tree_grab_flag")
		end
	return
	end
	if caster:HasModifier("modifier_imba_tiny_tree_grab_hero_flag") then
		local en = caster:FindModifierByName("modifier_imba_tiny_tree_grab_hero_flag"):GetCaster()
		local damage = (self:GetCaster():GetAverageTrueAttackDamage(caster)+en:GetAverageTrueAttackDamage(en))*1.5
		local impact_radius = self:GetSpecialValueFor("splash_radius")
		if caster:HasModifier("modifier_imba_tiny_tree_grab_hero_flag") then
			local tar = caster:FindModifierByName("modifier_imba_tiny_tree_grab_hero_flag"):GetCaster()
			local height = 40*math.max(self:GetCaster():GetModelScale(),1)
			tar:RemoveModifierByName("modifier_imba_tiny_tree_grab_debuff")
			tar:AddNewModifier(caster, self, "modifier_imba_tiny_toss_motion", {duration = 0.3, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z, dis = distance,height = height,damage = damage,impact_radius = impact_radius})
			caster:RemoveModifierByName("modifier_imba_tiny_tree_grab_hero_flag")
			if caster:HasModifier("modifier_imba_tiny_tree_grab_flag") then
				local mod = caster:FindModifierByName("modifier_imba_tiny_tree_grab_flag")
				self:EndCooldown()
				self:StartCooldown( mod:GetRemainingTime() )
				caster:RemoveModifierByName("modifier_imba_tiny_tree_grab_flag")
			end
		end
		return
	end


	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
	local trees = GridNav:GetAllTreesAroundPoint( target_point, 1, false )


	if #trees > 0 then
		--caster:EmitSound(caster.tree_grab_sound)
		GridNav:DestroyTreesAroundPoint(target_point, 1, false)
		local tr = caster:AddNewModifier(caster, self, "modifier_imba_tiny_grabtree", {})
		EmitSoundOnLocationWithCaster(target_point, "Hero_Tiny.Tree.Target", caster)
		tr:SetStackCount(self:GetSpecialValueFor("attack_count"))
	else
		if self:GetCursorTarget() ~= nil and not caster:HasModifier("modifier_imba_tiny_tree_grab_flag") then
		local dur = Is_Chinese_TG(caster,self:GetCursorTarget()) and self:GetSpecialValueFor("duration_hero_fr") or self:GetSpecialValueFor("duration_hero_enemy")
		self:GetCursorTarget():RemoveModifierByName("modifier_imba_tiny_toss_motion")
		self:GetCursorTarget():AddNewModifier(caster,self,"modifier_imba_tiny_tree_grab_debuff",{duration = dur })
		local mod = caster:AddNewModifier(self:GetCursorTarget(),self,"modifier_imba_tiny_tree_grab_hero_flag",{duration = dur})
		mod:SetStackCount(self:GetSpecialValueFor("attack_count"))
		end
	end

	if caster:HasModifier("modifier_imba_tiny_grabtree") or caster:HasModifier("modifier_imba_tiny_tree_grab_hero_flag") then
	--cd相关
		caster:AddNewModifier(caster,self,"modifier_imba_tiny_tree_grab_flag",{duration = self:GetCooldownTimeRemaining()})
	else

		caster:GiveMana(self:GetManaCost(self:GetLevel()))
	end
			self:EndCooldown()
end
function imba_tiny_tree_grab:OnProjectileHit_ExtraData(target, pos, keys)
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, self:GetSpecialValueFor("splash_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		if caster:HasModifier("modifier_item_monkey_king_bar_v2_pa") then
			local mod = caster:FindModifierByName("modifier_item_monkey_king_bar_v2_pa")
			if mod then
				mod.miss = true
				caster:PerformAttack(enemy, true, true, true, false, false, false, true)
				mod.miss = false
			end
		else
			caster:PerformAttack(enemy, true, true, true, false, false, false, true)
		end
	end
end
--抓树冷却标记
modifier_imba_tiny_tree_grab_flag = class({})

function modifier_imba_tiny_tree_grab_flag:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end


function modifier_imba_tiny_tree_grab_flag:IsHidden()
	return true
end

function modifier_imba_tiny_tree_grab_flag:IsPurgable()
	return false
end

function modifier_imba_tiny_tree_grab_flag:IsPurgeException()
	return false
end
--扔树冷却标记
modifier_imba_tiny_toss_tree_flag = class({})

function modifier_imba_tiny_toss_tree_flag:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end


function modifier_imba_tiny_toss_tree_flag:IsHidden()
	return true
end

function modifier_imba_tiny_toss_tree_flag:IsPurgable()
	return false
end

function modifier_imba_tiny_toss_tree_flag:IsPurgeException()
	return false
end

modifier_imba_tiny_grabtree = class({})
LinkLuaModifier("modifier_imba_tiny_toss_tree_flag", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_tiny_grabtree:IsDebuff() return false end
function modifier_imba_tiny_grabtree:IsPurgable() return false end
function modifier_imba_tiny_grabtree:IsPurgeException() return false end
function modifier_imba_tiny_grabtree:OnCreated()
	self.attack_range = self:GetAbility():GetSpecialValueFor("attack_range")
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage") +  self:GetCaster():TG_GetTalentValue("special_bonus_imba_tiny_4")
	self.damage_builiding = self:GetAbility():GetSpecialValueFor("bonus_damage_buildings")
	if IsServer() then
		self.tree = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/tiny/tiny_prestige/tiny_prestige_sword.vmdl"})
		self.tree:FollowEntity(self:GetParent(), true)
		AddAnimationTranslate(self:GetParent(), "tree")
	end
end


function modifier_imba_tiny_grabtree:OnDestroy()
	if IsServer() then
		UTIL_Remove(self.tree)
		RemoveAnimationTranslate(self:GetParent())
		local caster = self:GetCaster()
		local ab = self:GetAbility()
		if ab then
				if caster:HasModifier("modifier_imba_tiny_tree_grab_flag") then
				local mod = caster:FindModifierByName("modifier_imba_tiny_tree_grab_flag")
				ab:EndCooldown()
				ab:StartCooldown( mod:GetRemainingTime() )
				caster:RemoveModifierByName("modifier_imba_tiny_tree_grab_flag")
				else
				ab:EndCooldown()
			end
		end
	end
end

function modifier_imba_tiny_grabtree:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,}
end

function modifier_imba_tiny_grabtree:OnAttackLanded(keys)
	local caster = self:GetCaster()
	if IsServer() then
		-- Checking for keys.no_attack_cooldown == false is to prevent Tree Volley (aghs ability) from consuming tree charges
		if caster == keys.attacker and keys.target then
			if caster:HasModifier("modifier_imba_tiny_tree_channel") then
				return
			end


				-- Splash is centered around a point abit intfron of tiny, tweeked by "splash_distance"
				local splash_distance = caster:GetForwardVector() * self:GetAbility():GetSpecialValueFor("splash_width")
				local splash_radius = self:GetAbility():GetSpecialValueFor("splash_range")+ (caster:Script_GetAttackRange()-self.attack_range)/2
				local splash_damage = self:GetAbility():GetSpecialValueFor("splash_damage")
				splash_distance.z = 0

				-- Initiate splash damage_table
				local damage_table = {}
				damage_table.attacker = caster
				damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
				damage_table.damage = caster:GetAverageTrueAttackDamage(caster) * (splash_damage / 100)
				damage_table.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
				local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), caster:GetAbsOrigin() + splash_distance, nil, splash_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )


				for _,enemy in pairs(enemies) do
					-- Dont deal damage to main target twice
					if enemy ~= keys.target then
						damage_table.victim = enemy
						ApplyDamage(damage_table)

						EmitSoundOn("Hero_Tiny.Tree.Target", caster)
						local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_craggy_cleave.vpcf", PATTACH_POINT, caster)
						ParticleManager:SetParticleControl(nfx, 0, enemy:GetAbsOrigin())
						ParticleManager:SetParticleControl(nfx, 1, enemy:GetAbsOrigin())
						ParticleManager:SetParticleControlForward(nfx, 2, caster:GetForwardVector())
						ParticleManager:ReleaseParticleIndex(nfx)
					end
				end

				if not caster:TG_HasTalent("special_bonus_imba_tiny_3") then
				self:SetStackCount(self:GetStackCount() - 1)
				if self:GetStackCount() == 0 then
					self:GetParent():RemoveModifierByName("modifier_imba_tiny_grabtree")
				end
				end
			end
		end
end


function modifier_imba_tiny_grabtree:GetModifierAttackRangeBonus()
	return self.attack_range
end
function modifier_imba_tiny_grabtree:GetModifierTotalDamageOutgoing_Percentage(keys)

	if keys.inflictor or self:GetParent():HasModifier("modifier_imba_tiny_tree_channel") then
		return 0
	end
	if keys.target:IsBuilding() then
		return self.damage_builiding
	end
  	return self.damage
end

--山崩标记
modifier_imba_tiny_avalanche_flags = class({})

function modifier_imba_tiny_avalanche_flags:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end


function modifier_imba_tiny_avalanche_flags:IsHidden()
	return true
end

function modifier_imba_tiny_avalanche_flags:IsPurgable()
	return false
end

function modifier_imba_tiny_avalanche_flags:IsPurgeException()
	return false
end
--抓人标记
modifier_imba_tiny_tree_grab_hero_flag = class({})
LinkLuaModifier("modifier_imba_tiny_toss_tree_flag", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_tiny_tree_grab_hero_flag:OnCreated()
	self.attack_range = self:GetAbility():GetSpecialValueFor("attack_range")
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_tiny_4")
	self.damage_buildings = self:GetAbility():GetSpecialValueFor("bonus_damage_buildings")
end
function modifier_imba_tiny_tree_grab_hero_flag:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_imba_tiny_tree_grab_hero_flag:CheckState()
	return {
		--[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED ] = not Is_Chinese_TG(self:GetCaster(),self:GetParent()),
		--[MODIFIER_STATE_ROOTED] = not Is_Chinese_TG(self:GetCaster(),self:GetParent()),
		}
end

function modifier_imba_tiny_tree_grab_hero_flag:IsHidden()
	return false
end

function modifier_imba_tiny_tree_grab_hero_flag:IsPurgable()
	return false
end

function modifier_imba_tiny_tree_grab_hero_flag:IsPurgeException()
	return false
end
function modifier_imba_tiny_tree_grab_hero_flag:RemoveOnDeath()
	return true
end

function modifier_imba_tiny_tree_grab_hero_flag:OnDestroy()
	if IsServer() then
		local caster = self:GetParent()
		local ab = self:GetAbility()
		if ab then
				if caster:HasModifier("modifier_imba_tiny_tree_grab_flag") then
				local mod = caster:FindModifierByName("modifier_imba_tiny_tree_grab_flag")
				ab:EndCooldown()
				ab:StartCooldown( mod:GetRemainingTime() )
				caster:RemoveModifierByName("modifier_imba_tiny_tree_grab_flag")
				else
				ab:EndCooldown()
			end
		end
	end
end

function modifier_imba_tiny_tree_grab_hero_flag:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,}
end
function modifier_imba_tiny_tree_grab_hero_flag:GetModifierIgnoreCastAngle()
    return 1
end
function modifier_imba_tiny_tree_grab_hero_flag:OnAttackLanded(keys)
	local caster = self:GetParent()
	if IsServer() then
		-- Checking for keys.no_attack_cooldown == false is to prevent Tree Volley (aghs ability) from consuming tree charges
		if caster == keys.attacker and keys.target then
			if caster:HasModifier("modifier_imba_tiny_tree_channel") then
				return
			end

				-- Splash is centered around a point abit intfron of tiny, tweeked by "splash_distance"
				local splash_distance = caster:GetForwardVector() * self:GetAbility():GetSpecialValueFor("splash_width")
				local splash_radius = self:GetAbility():GetSpecialValueFor("splash_range") + caster:Script_GetAttackRange()-self.attack_range
				local splash_damage = self:GetAbility():GetSpecialValueFor("splash_damage")
				splash_distance.z = 0

				-- Initiate splash damage_table
				local damage_table = {}
				damage_table.attacker = caster
				damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
				damage_table.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
				local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin() + splash_distance, nil, splash_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )


				for _,enemy in pairs(enemies) do
					-- Dont deal damage to main target twice
					if enemy ~= keys.target then
						damage_table.damage = caster:GetAverageTrueAttackDamage(caster) * (splash_damage / 100)
						if enemy:HasModifier("modifier_imba_tiny_tree_grab_debuff") then
							damage_table.damage = damage_table.damage * 1.5
						end
						damage_table.victim = enemy
						ApplyDamage(damage_table)

						EmitSoundOn("Hero_Tiny.Tree.Target", caster)
						local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_craggy_cleave.vpcf", PATTACH_POINT, caster)
						ParticleManager:SetParticleControl(nfx, 0, enemy:GetAbsOrigin())
						ParticleManager:SetParticleControl(nfx, 1, enemy:GetAbsOrigin())
						ParticleManager:SetParticleControlForward(nfx, 2, caster:GetForwardVector())
						ParticleManager:ReleaseParticleIndex(nfx)
					end
				end
		end
	end
end


function modifier_imba_tiny_tree_grab_hero_flag:GetModifierAttackRangeBonus()
	return self.attack_range
end
function modifier_imba_tiny_tree_grab_hero_flag:GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.inflictor or self:GetParent():HasModifier("modifier_imba_tiny_tree_channel") then
		return 0
	end
	if keys.target:IsBuilding() then
		return self.damage_builiding
	end
  	return self.damage
end


--抓人debuff
modifier_imba_tiny_tree_grab_debuff = class({})

function modifier_imba_tiny_tree_grab_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end


function modifier_imba_tiny_tree_grab_debuff:IsHidden()
	return true
end

function modifier_imba_tiny_tree_grab_debuff:IsPurgable()
	return false
end
function modifier_imba_tiny_tree_grab_debuff:IsPurgeException()
	return false
end
function modifier_imba_tiny_tree_grab_debuff:RemoveOnDeath()
	return true
end
function modifier_imba_tiny_tree_grab_debuff:OnCreated( kv )
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then
			self:Destroy()
			return
		end
		AddAnimationTranslate(self:GetCaster(), "tree")
		self.hold_time = kv.hold_time
		--print( "hold_time" .. self.hold_time )

		self.nProjHandle = -1
		self.flTime = 0.0
		self.flHeight = 0.0

		self.impact_radius = 400
		self:GetParent():StartGesture(ACT_DOTA_DIE)
		self.bDropped = false
		self:StartIntervalThink( 20 )
	end
end

--------------------------------------------------------------------------------

function modifier_imba_tiny_tree_grab_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_imba_tiny_tree_grab_debuff:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = Is_Chinese_TG(self:GetParent(),self:GetCaster()),
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
	return state
end
function modifier_imba_tiny_tree_grab_debuff:OnOrder(keys)
	if not IsServer() then
		return
	end
	if keys.unit==self:GetParent() and Is_Chinese_TG(self:GetParent(),self:GetCaster())then
		if  keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
			self:Destroy()
		end
	end
end
--------------------------------------------------------------------------------

function modifier_imba_tiny_tree_grab_debuff:OnDestroy()
	if IsServer() then

		RemoveAnimationTranslate(self:GetCaster())
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
		--local ability_slot3 = self:GetCaster():FindAbilityByName("imba_tiny_toss_tree")
		--if ability_slot3 then
		--local ability_slot4 = self:GetAbility()
		--self:GetCaster():SwapAbilities(ability_slot3:GetAbilityName(), ability_slot4:GetAbilityName(), false, true)
		--end
		self:GetCaster():RemoveModifierByName("modifier_imba_tiny_tree_grab_hero_flag")
	end
end

--------------------------------------------------------------------------------

function modifier_imba_tiny_tree_grab_debuff:OnIntervalThink()
	if IsServer() then
		if self.bDropped == false then
			self.bDropped = true
			self:GetCaster():RemoveModifierByName( "modifier_storegga_grabbed_buff" )

			self.nProjHandle = -2
			self.flTime = 0.5
			self.flHeight = GetGroundHeight( self:GetParent():GetAbsOrigin(), self:GetParent() )

			self:StartIntervalThink( self.flTime )
			return
		else
			local vLocation = GetGroundPosition( self:GetParent():GetAbsOrigin(), self:GetParent() )

			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 0, vLocation )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.impact_radius, self.impact_radius, self.impact_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOnLocationWithCaster( vLocation, "Ability.TossImpact", self:GetCaster() )
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_imba_tiny_tree_grab_debuff:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		local vLocation = me:GetAbsOrigin()
		if self.nProjHandle == -1 then
			local attach = self:GetCaster():ScriptLookupAttachment( "attach_attack2" )
			vLocation = self:GetCaster():GetAttachmentOrigin( attach )
		elseif self.nProjHandle ~= -2 then
			vLocation = ProjectileManager:GetLinearProjectileLocation( self.nProjHandle )
		end
		vLocation.z = 0.0
		me:SetOrigin( vLocation )
	end
end

--------------------------------------------------------------------------------

function modifier_imba_tiny_tree_grab_debuff:UpdateVerticalMotion( me, dt )
	if IsServer() then
		local vMyPos = me:GetOrigin()
		if self.nProjHandle == -1 then
			local attach = self:GetCaster():ScriptLookupAttachment( "attach_attack2" )
			local vLocation = self:GetCaster():GetAttachmentOrigin( attach )
			vMyPos.z = vLocation.z
		else
			local flGroundHeight = GetGroundHeight( vMyPos, me )
			local flHeightChange = dt * self.flTime * self.flHeight * 1.3
			vMyPos.z = math.max( vMyPos.z - flHeightChange, flGroundHeight )
		end
		me:SetOrigin( vMyPos )
	end
end

--------------------------------------------------------------------------------

function modifier_imba_tiny_tree_grab_debuff:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_imba_tiny_tree_grab_debuff:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
--[[
function modifier_imba_tiny_tree_grab_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end]]

--------------------------------------------------------------------------------

function modifier_imba_tiny_tree_grab_debuff:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetCaster() then
			self:Destroy()
		end
	end

	return 0
end
--a杖扔树
imba_tiny_tree_channel = class({})
LinkLuaModifier("modifier_imba_tiny_tree_channel", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tiny_tree_animation", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)
function imba_tiny_tree_channel:GetAOERadius()
	return self:GetSpecialValueFor("splash_radius")
end
function imba_tiny_tree_channel:GetCastRange()
	if IsServer() then
		return self:GetSpecialValueFor("range")*math.max(self:GetCaster():GetModelScale(),1)
	end
	return self:GetSpecialValueFor("range")
end
function imba_tiny_tree_channel:IsStealable() return false end
function imba_tiny_tree_channel:OnInventoryContentsChanged()
	if not IsServer() then return end
    if self:GetCaster():HasScepter() then
       self:SetHidden(false)
       self:SetLevel(1)
    else
			self:SetHidden(true)
    end
end
function imba_tiny_tree_channel:OnSpellStart()
	local caster = self:GetCaster()
	local tar_pos = self:GetCursorPosition()
	caster:AddNewModifier(caster,self,"modifier_imba_tiny_tree_channel",{duration = self:GetSpecialValueFor("abilitychanneltime"),tar_pos_x =tar_pos.x,tar_pos_y =tar_pos.y,tar_pos_z =tar_pos.z })
end

function imba_tiny_tree_channel:OnChannelFinish()
	if IsServer() then
		self:GetCaster():RemoveModifierByName("modifier_imba_tiny_tree_channel")
	end
end
function imba_tiny_tree_channel:OnProjectileHit_ExtraData(target, pos, keys)
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("splash_radius")*math.max(self:GetCaster():GetModelScale()*0.8,1)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		if caster:HasModifier("modifier_item_monkey_king_bar_v2_pa") then
			local mod = caster:FindModifierByName("modifier_item_monkey_king_bar_v2_pa")
			if mod then
				mod.miss = true
				caster:PerformAttack(enemy, true, true, true, false, false, false, true)
				mod.miss = false
			end
		else
			caster:PerformAttack(enemy, true, true, true, false, false, false, true)
		end
	end
end
modifier_imba_tiny_tree_channel = class({})
function modifier_imba_tiny_tree_channel:IsHidden() return false end
function modifier_imba_tiny_tree_channel:IsPurgable() return false end
function modifier_imba_tiny_tree_channel:IsPurgeException() return false end
function modifier_imba_tiny_tree_channel:IsDebuff() return false end
function modifier_imba_tiny_tree_channel:CheckState() return {MODIFIER_STATE_CANNOT_MISS = true} end
function modifier_imba_tiny_tree_channel:OnCreated(keys)
	if IsServer() then
		self.tar_pos = Vector(keys.tar_pos_x,keys.tar_pos_y,keys.tar_pos_z)
		self.tree_radius = self:GetAbility():GetSpecialValueFor("tree_grab_radius")*math.max(self:GetCaster():GetModelScale(),1)
		self.interval = self:GetAbility():GetSpecialValueFor("interval")/math.max(self:GetCaster():GetModelScale()*0.9,1)
		local nFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_tiny/tiny_tree_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(nFXIndex1, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(nFXIndex1, 2, Vector(self.tree_radius, 0, 0))
		self:AddParticle(nFXIndex1, false, false, 15, false, false)

		local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_tiny/tiny_tree_channel_tgt_ground_dark_crack.vpcf", PATTACH_POINT, self:GetCaster())
				ParticleManager:SetParticleControl(nFXIndex2, 0, self.tar_pos)
				ParticleManager:ReleaseParticleIndex(nFXIndex2)

		self:StartIntervalThink(self.interval)
	end
end
function modifier_imba_tiny_tree_channel:OnIntervalThink()
	if IsServer() then
		EmitSoundOn("Hero_Tiny.Tree.Throw", self:GetCaster())
		local trees = GridNav:GetAllTreesAroundPoint( self:GetCaster():GetOrigin(), self.tree_radius, false )
		if #trees > 0 then
		local pos = trees[1]:GetAbsOrigin()
		pfx_name = "particles/units/heroes/hero_tiny/tiny_tree_channel_tree_spiral.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, pos)
		ParticleManager:ReleaseParticleIndex(pfx)
		GridNav:DestroyTreesAroundPoint(pos, 1, false)

		local direction = (self.tar_pos-pos):Normalized()
		local distance = (pos-self.tar_pos):Length2D()

		local caster = self:GetCaster()
		local speed = self:GetAbility():GetSpecialValueFor("speed")*math.max(caster:GetModelScale(),1)
	local info =
    {
        Ability = self:GetAbility(),
		EffectName = "particles/units/heroes/hero_tiny/tiny_tree_linear_proj.vpcf",
		vSpawnOrigin = pos,
		fDistance = distance,
		fStartRadius = 0,
		fEndRadius = 0,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_NONE,
		bDeleteOnHit = true,
		vVelocity = direction*speed,
		bProvidesVision = false,
    }
    ProjectileManager:CreateLinearProjectile(info)

	else
		self:GetCaster():Stop()

	end
	end
end

--长大
imba_tiny_grow = class({})

LinkLuaModifier("modifier_imba_tiny_toss_self", "ting/hero_tiny", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_tiny_tree_animation", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tiny_grow", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)


function imba_tiny_grow:IsStealable() return false end
function imba_tiny_grow:OnSpellStart()
	self:swash()
end

function imba_tiny_grow:swash()
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage")
	local dur = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")*math.max(caster:GetModelScale(),1)
	caster:StartGesture(ACT_TINY_AVALANCHE)
	EmitSoundOn("Tiny.Grow", self:GetCaster())

    local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(fx, 1, Vector(700,1,1))
	ParticleManager:ReleaseParticleIndex(fx)
	local fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(fx2, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(fx2)


	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
				ApplyDamage({
						victim 			= enemy,
						damage 			= damage,
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self,
						})
		local Knockback ={
          should_stun = dur, --打断
          knockback_duration = dur, --击退时间 减去不能动的时间就是太空步的时间
          duration = dur, --不能动的时间
          knockback_distance = 0,
          knockback_height = 600,	--击退高度
          center_x =  caster:GetAbsOrigin().x,	--施法者为中心
          center_y =  caster:GetAbsOrigin().y,
          center_z =  caster:GetAbsOrigin().z,
		}
	  		enemy:AddNewModifier_RS(caster, self, "modifier_knockback", Knockback)  --白牛的击退
	end
end
function imba_tiny_grow:IsStealable()
    return false
end

function imba_tiny_grow:GetIntrinsicModifierName()
	return "modifier_imba_tiny_grow"
end

function imba_tiny_grow:OnUpgrade()
	if IsServer() then
		self:GetCaster():StartGesture(ACT_TINY_GROWL)
		EmitSoundOn("Tiny.Grow", self:GetCaster())

		local grow = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(grow, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(grow)
	end
end
--[[
function imba_tiny_grow:Grow(level)
	local model_path = "models/items/tiny/tiny_prestige/tiny_prestige_lvl_0"..level

	if level < 5 then -- model bullshit

			-- Set new model
			self:GetCaster():SetOriginalModel(model_path..".vmdl")
			self:GetCaster():SetModel(model_path..".vmdl")
			-- Remove old wearables
			UTIL_Remove(self.head)
			UTIL_Remove(self.rarm)
			UTIL_Remove(self.larm)
			UTIL_Remove(self.body)
			-- Set new wearables
			self.head = SpawnEntityFromTableSynchronous("prop_dynamic", {model = model_path.."_head.vmdl"})
			self.rarm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = model_path.."_right_arm.vmdl"})
			self.larm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = model_path.."_left_arm.vmdl"})
			self.body = SpawnEntityFromTableSynchronous("prop_dynamic", {model = model_path.."_body.vmdl"})
			-- lock to bone
			self.head:FollowEntity(self:GetCaster(), true)
			self.rarm:FollowEntity(self:GetCaster(), true)
			self.larm:FollowEntity(self:GetCaster(), true)
			self.body:FollowEntity(self:GetCaster(), true)
	end
end
]]


modifier_imba_tiny_grow = class({})
function modifier_imba_tiny_grow:IsPurgable() return false end
function modifier_imba_tiny_grow:IsPurgeException() return false end
function modifier_imba_tiny_grow:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_MODEL_SCALE,
			MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
			MODIFIER_PROPERTY_MODEL_CHANGE,
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			}
end


function modifier_imba_tiny_grow:OnAttackLanded(keys)
	if IsServer() then
		-- Checking for keys.no_attack_cooldown == false is to prevent Tree Volley (aghs ability) from consuming tree charges
		if keys.attacker == self:GetParent() and keys.target then
			if PseudoRandom:RollPseudoRandom(self:GetAbility(), keys.attacker:TG_GetTalentValue("special_bonus_imba_tiny_6")) then
				local ab = self:GetAbility()
				if ab and ab:GetLevel()>0 then
					ab:swash()
				end
			end
		end
	end
end

function modifier_imba_tiny_grow:GetModifierModelChange()

	return "models/items/tiny/tiny_prestige/tiny_prestige_lvl_0"..tostring(self:GetAbility():GetLevel() + 1)..".vmdl"
end
function modifier_imba_tiny_grow:GetModifierModelScale()
	return self:GetAbility():GetSpecialValueFor("scale")
end
function modifier_imba_tiny_grow:GetModifierBaseAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_imba_tiny_grow:IsHidden()
	return true
end

function modifier_imba_tiny_grow:CheckState()
	if self:GetCaster():TG_HasTalent("special_bonus_imba_tiny_8") then
		return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
	end
end



--被动晕
imba_tiny_craggy_exterior = class({})
LinkLuaModifier("modifier_imba_tiny_craggy_mod", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tiny_toss_motion", "ting/hero_tiny", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_tiny_craggy_passive", "ting/hero_tiny", LUA_MODIFIER_MOTION_NONE)
function imba_tiny_craggy_exterior:GetIntrinsicModifierName() return "modifier_imba_tiny_craggy_passive" end
function imba_tiny_craggy_exterior:CastFilterResultLocation(location)
	if not IsServer() then return end
	local ab = self:GetCaster():FindAbilityByName("imba_tiny_toss")
	if ab and ab:GetLevel()>0 then
		return UF_SUCCESS
	end
	return UF_FAIL_CUSTOM
end

function imba_tiny_craggy_exterior:GetCustomCastErrorLocation(location)
	return "你需要先学习投掷技能"
end
function imba_tiny_craggy_exterior:OnInventoryContentsChanged()
	if not IsServer() then return end
    if self:GetCaster():Has_Aghanims_Shard() then
       self:SetHidden(false)
       self:SetLevel(1)
    else
			self:SetHidden(true)
    end
end

function imba_tiny_craggy_exterior:OnSpellStart()
	local pos = self:GetCursorPosition()
	local caster = self:GetCaster()
	local stone = CreateUnitByName("npc_dota_broodmother_spiderling", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	local height = 700
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	local distance = (pos - caster:GetAbsOrigin()):Length2D() + height/2
	local tralve_duration = distance / 800
	local dur = 1.3
	local ab = self:GetCaster():FindAbilityByName("imba_tiny_toss")
	if ab and ab:GetLevel() > 0 then
	EmitSoundOn("Ability.TossThrow", caster)
	EmitSoundOn("Hero_Tiny.Toss.Target", stone)
	local damage = ab:GetSpecialValueFor("damage")
	local impact_radius = ab:GetSpecialValueFor("impact_radius")
	stone:AddNewModifier(caster, ab, "modifier_imba_tiny_toss_motion",
		{duration = dur, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z, dis = distance,height = height,damage = damage,impact_radius = impact_radius})
	stone:AddNewModifier(caster, self, "modifier_imba_tiny_craggy_mod", {duration = dur+0.3})
	end
end
modifier_imba_tiny_craggy_mod = class({})

function modifier_imba_tiny_craggy_mod:OnCreated()
		if IsServer() then
		local grow = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(grow, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(grow)
		self:GetParent():SetModelScale(1.0)
		end

end

function modifier_imba_tiny_craggy_mod:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,
		}
end
function modifier_imba_tiny_craggy_mod:CheckState()
	local state = {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end

function modifier_imba_tiny_craggy_mod:IsHidden()
	return false
end
function modifier_imba_tiny_craggy_mod:IsPurgable()
	return false
end
function modifier_imba_tiny_craggy_mod:IsPurgeException()
	return false
end


function modifier_imba_tiny_craggy_mod:OnDestroy()
	if IsServer() then
		local grow = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(grow, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(grow)
		UTIL_Remove(self:GetParent())
		--CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_imba_tiny_avalanche_thinker", { duration = self:GetChannelTime() }, self:GetCaster():GetOrigin(), self:GetCaster():GetTeamNumber(), false )
	end
end


function modifier_imba_tiny_craggy_mod:GetModifierModelChange()
    return "models/heroes/tiny/tiny_01/tiny_01.vmdl"
end
modifier_imba_tiny_craggy_passive = class({})
function modifier_imba_tiny_craggy_passive:IsHidden() return true end
function modifier_imba_tiny_craggy_passive:IsPurgable() return false end
function modifier_imba_tiny_craggy_passive:IsPurgeException() return false end
function modifier_imba_tiny_craggy_passive:IsDebuff() return false end
function modifier_imba_tiny_craggy_passive:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end
function modifier_imba_tiny_craggy_passive:GetModifierPhysicalArmorBonus()
	return self:GetParent():GetLevel()
end
function modifier_imba_tiny_craggy_passive:OnAttackLanded(keys)
	if not IsServer() or keys.target ~= self:GetParent() or self:GetParent():PassivesDisabled()  or self:GetParent():IsIllusion()  or keys.attacker:IsMagicImmune() then
		return
	end

	local range = self:GetAbility():GetSpecialValueFor("radius")*math.max(self:GetParent():GetModelScale(),1)
	if (keys.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() < range then
		if PseudoRandom:RollPseudoRandom(self:GetAbility(), self:GetAbility():GetSpecialValueFor("stun_chance")) then
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_craggy_hit.vpcf", PATTACH_POINT_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)

			keys.attacker:AddNewModifier(keys.target,self:GetAbility(),"modifier_imba_stunned",{duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
			ApplyDamage({
						victim 			= keys.attacker,
						damage 			= self:GetAbility():GetSpecialValueFor("damage"),
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self:GetAbility(),
						})
			if self:GetAbility() == nil then
				self:GetParent():RemoveModifierByName("modifier_imba_tiny_craggy_passive")
			end

		end
	end
end
