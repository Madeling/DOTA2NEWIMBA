smoke_bomb = class({})

LinkLuaModifier("modifier_smoke_bomb", "ting/ambush/smoke_bomb.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ambush_motion", "ting/ambush/smoke_bomb.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_smoke_bomb_thinker", "ting/ambush/smoke_bomb.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_smoke_bomb_inv", "ting/ambush/smoke_bomb.lua", LUA_MODIFIER_MOTION_NONE)



function smoke_bomb:IsHiddenWhenStolen() 	return false end
function smoke_bomb:IsRefreshable() 			return true  end
function smoke_bomb:IsStealable() 			return true  end
function smoke_bomb:IsNetherWardStealable()	return true end
function smoke_bomb:GetAOERadius() 	return 750 end
--[[
function smoke_bomb:OnUpgrade()
	if self:GetLevel() <= 4 then
		local caster = self:GetCaster()
		local name = "ambush"
		local ability = caster:FindAbilityByName(name)		
		ability:SetLevel(1)
	end	
end
]]
function smoke_bomb:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local radius = 1000
	local pos	= self:GetCursorPosition()
    local particleName = "particles/items2_fx/smoke_of_deceit.vpcf"
    local casterPos = caster:GetAbsOrigin()


	caster:EmitSound("Hero_Techies.LandMine.Plant")
	local stone = CreateUnitByName("npc_sniper_bait", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	local height = 300
	local direction = (pos - caster:GetAbsOrigin()):Normalized()
	local distance = (pos - caster:GetAbsOrigin()):Length2D() + height/2
	local tralve_duration = distance / 800
	local dur = 0.5
	local damage = 1
	local impact_radius = 1
	stone:AddNewModifier(caster, ab, "modifier_ambush_motion",{duration = dur, pos_x = pos.x, pos_y = pos.y, pos_z = pos.z, dis = distance,height = height,damage = damage,impact_radius = impact_radius})
	
    Timers:CreateTimer(0.5, function()
       CreateModifierThinker( caster, self, "modifier_smoke_bomb_thinker", { duration = duration}, pos, self:GetCaster():GetTeamNumber(), false ) 
    end
	)
end


modifier_smoke_bomb = class({})
function modifier_smoke_bomb:IsDebuff()			return false end
function modifier_smoke_bomb:IsHidden() 			return false end
function modifier_smoke_bomb:IsPurgable() 			return false end
function modifier_smoke_bomb:GetEffectName() return "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf" end
function modifier_smoke_bomb:CheckState()
	return {
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true		
			}

end
function modifier_smoke_bomb:DeclareFunctions() return 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	} 
end

function modifier_smoke_bomb:GetDisableAutoAttack() return true end	
function modifier_smoke_bomb:GetModifierInvisibilityLevel() 
	return 1
end
function modifier_smoke_bomb:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_bonus
end
function modifier_smoke_bomb:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker == self:GetParent() then
		self:Destroy()
	end
end
function modifier_smoke_bomb:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit == self.parent then 
		local name = params.ability:GetAbilityName() 
		if params.ability == self.ab or name == "assassinate" then return end
			self:Destroy()
		end			
	end
end
function modifier_smoke_bomb:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.movement_bonus = self.ab:GetSpecialValueFor("move_s")
	self.parent = self:GetParent()
	if IsServer() then 
		self.mod = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/spring2021_ambush_sniper_cape/spring2021_ambush_sniper_cape.vmdl"})
		self.mod:SetParent(self:GetParent(), nil)
        self.mod:FollowEntity(self:GetParent(), true)
		self.parent:EmitSound("Hero_Treant.NaturesGuise.On")

	end
end
function modifier_smoke_bomb:OnDestroy()
	if IsServer() and self.mod then
		self.mod:RemoveSelf()
		self.parent:EmitSound("Hero_Treant.NaturesGuise.Off")
	end
end

modifier_ambush_motion = class({})

function modifier_ambush_motion:IsDebuff()			return false end
function modifier_ambush_motion:IsHidden() 			return true end
function modifier_ambush_motion:IsPurgable() 		return false end
function modifier_ambush_motion:IsPurgeException() 	return false end
function modifier_ambush_motion:DeclareFunctions() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION,MODIFIER_EVENT_ON_ORDER} end
function modifier_ambush_motion:GetOverrideAnimation() return ACT_DOTA_FLAIL end
function modifier_ambush_motion:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end
function modifier_ambush_motion:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_INVULNERABLE] = Is_Chinese_TG(self:GetParent(),self:GetCaster()),}
end
function modifier_ambush_motion:DeclareFunctions()
	return {MODIFIER_PROPERTY_MODEL_CHANGE}
end

function modifier_ambush_motion:GetModifierModelChange() 
	return "models/items/techies/bigshot/fx_bigshot_stasis.vmdl"
end


function modifier_ambush_motion:OnCreated(keys)
	if IsServer() then
			self:GetParent():SetModelScale(0.5)
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

	end
end

function modifier_ambush_motion:OnIntervalThink()
	local motion_progress = math.min(self:GetElapsedTime() / self:GetDuration(), 1.0)
	local distance = self.distance
	local direction = (self.pos - self:GetParent():GetAbsOrigin()):Normalized()
	direction.z = 0.0   
	local next_pos = GetGroundPosition(self:GetParent():GetAbsOrigin() + direction * distance, nil)
	next_pos.z = next_pos.z - 4 * self.height * motion_progress ^ 2 + 4 * self.height * motion_progress
	self:GetParent():SetOrigin(next_pos)
	
end

function modifier_ambush_motion:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end


modifier_smoke_bomb_thinker = class({})
LinkLuaModifier("modifier_smoke_bomb_inv", "ting/ambush/smoke_bomb.lua", LUA_MODIFIER_MOTION_NONE)
function modifier_smoke_bomb_thinker:IsDebuff()			return false end
function modifier_smoke_bomb_thinker:IsHidden() 			return true end
function modifier_smoke_bomb_thinker:IsPurgable() 		return false end
function modifier_smoke_bomb_thinker:IsPurgeException() 	return false end
function modifier_smoke_bomb_thinker:IsAura() return true end
function modifier_smoke_bomb_thinker:GetModifierAura() return "modifier_smoke_bomb_inv" end
function modifier_smoke_bomb_thinker:GetAuraRadius() return self.radius end
function modifier_smoke_bomb_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_smoke_bomb_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_smoke_bomb_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end


function modifier_smoke_bomb_thinker:OnCreated()
	if not self:GetAbility() then return end
	self.ab = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.damage = self.ab:GetSpecialValueFor("damage")/20
	self.radius = self.ab:GetSpecialValueFor("radius")
	self.pos = self.parent:GetAbsOrigin()
	if IsServer() then
		self.damageTable = {
						attacker = self.caster,
						damage_type = self.ab:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self.ab, --Optional.
								}
		self:OnIntervalThink()
		self:StartIntervalThink(0.3)
	end
end
function modifier_smoke_bomb_thinker:OnIntervalThink()
	if IsServer() then	
		local particle1 = ParticleManager:CreateParticle("particles/items2_fx/smoke_of_deceit.vpcf", PATTACH_CUSTOMORIGIN, nil)	
		ParticleManager:SetParticleControl(particle1, 0, self.pos)
		ParticleManager:SetParticleControl(particle1, 1, Vector(self.radius, self.radius/2, self.radius/2))
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			self.damageTable.victim = enemy
			self.damageTable.damage = self.damage 
			ApplyDamage(self.damageTable)
		end			 


	--ParticleManager:ReleaseParticleIndex(particle1)	
	end
end	

modifier_smoke_bomb_inv = class({})
function modifier_smoke_bomb_inv:IsDebuff()			return false end
function modifier_smoke_bomb_inv:IsHidden() 			return false end
function modifier_smoke_bomb_inv:IsPurgable() 		return false end
function modifier_smoke_bomb_inv:IsPurgeException() 	return false end
function modifier_smoke_bomb_inv:DeclareFunctions() return { MODIFIER_PROPERTY_EVASION_CONSTANT} end
function modifier_smoke_bomb_inv:GetStatusEffectName() return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf" end
function modifier_smoke_bomb_inv:GetModifierEvasion_Constant()
    return self.bonus_evasion
end
function modifier_smoke_bomb_inv:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.bonus_evasion = self.ab:GetSpecialValueFor("ev")
end