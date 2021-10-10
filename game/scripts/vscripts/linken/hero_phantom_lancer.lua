----2021.01.01--by 你收拾收拾准备出林肯吧
CreateTalents("npc_dota_hero_phantom_lancer", "linken/hero_phantom_lancer")
modifier_imba_illusion_no_order = class({})
LinkLuaModifier("modifier_imba_illusion_no_order", "linken/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_illusion_no_order:IsDebuff()				return true end
function modifier_imba_illusion_no_order:IsHidden() 			return true end
function modifier_imba_illusion_no_order:IsPurgable() 			return false end
function modifier_imba_illusion_no_order:IsPurgeException() 	return false end
function modifier_imba_illusion_no_order:CheckState()
	return
		{
		[MODIFIER_STATE_COMMAND_RESTRICTED]	= true,
		[MODIFIER_STATE_ROOTED]	= true,
		--[MODIFIER_STATE_DISARMED]	= true,
		[MODIFIER_STATE_INVULNERABLE]	= true,
		[MODIFIER_STATE_UNSELECTABLE]	= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP]	= true,
		--[MODIFIER_STATE_NO_HEALTH_BAR]	= true,
		}
end

imba_phantom_lancer_spirit_lance = class({})
LinkLuaModifier("modifier_imba_spirit_lance_slow", "linken/hero_phantom_lancer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spirit_lance_att", "linken/hero_phantom_lancer.lua", LUA_MODIFIER_MOTION_NONE)
function imba_phantom_lancer_spirit_lance:IsStealable() 	return true end
function imba_phantom_lancer_spirit_lance:CastFilterResultTarget(target)
	if target == self:GetCaster() then
		return UF_FAIL_FRIENDLY
	end
	if target:IsBuilding() then
		return UF_FAIL_BUILDING
	end
	if Is_Chinese_TG(target, self:GetCaster()) then
		return UF_FAIL_FRIENDLY
	end
	if target:IsInvulnerable() then
		return UF_FAIL_INVULNERABLE
	end
	if target:IsMagicImmune() and not self:GetCaster():Has_Aghanims_Shard()  then
		return UF_FAIL_MAGIC_IMMUNE_ENEMY
	end
end

function imba_phantom_lancer_spirit_lance:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	elseif Is_Chinese_TG(target, self:GetCaster()) then
		return "#dota_hud_error_cant_cast_on_friendly"
	end
	if target:IsBuilding() then
		return "#dota_hud_error_cant_cast_on_building"
	end
	if target:IsMagicImmune() and not self:GetCaster():Has_Aghanims_Shard() then
		return "#dota_hud_error_cant_cast_on_magicImmune"
	end
end

function imba_phantom_lancer_spirit_lance:OnSpellStart(keys)
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local illusion_duration = self:GetSpecialValueFor("illusion_duration")
	self:GetCaster():EmitSound("Hero_PhantomLancer.SpiritLance.Throw")


	--[[caster:RemoveModifierByName("modifier_imba_phantom_edge")
	local ability = caster:FindAbilityByName("imba_phantom_lancer_phantom_edge")
	caster:AddNewModifier(caster, ability, "modifier_imba_phantom_edge", {})

	caster:RemoveModifierByName("modifier_imba_juxtapose_passive")
	local ability2 = caster:FindAbilityByName("imba_phantom_lancer_juxtapose")
	caster:AddNewModifier(caster, ability2, "modifier_imba_juxtapose_passive", {})]]


	local pfx_name = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_projectile.vpcf"
	local speed = self:GetSpecialValueFor("lance_speed")

	local info =
	{
		Target = target,
		Source = caster,
		Ability = self,
		EffectName = pfx_name,
		iMoveSpeed = speed,
		iSourceAttachment = caster:ScriptLookupAttachment("attach_attack1"),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
		ExtraData = {},
	}

	TG_CreateProjectile({id = 1, team = caster:GetTeamNumber() , owner = caster, p = info})


	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_caster.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(self.pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(
		self.pfx,
		0,
		self:GetCaster(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		caster:GetAbsOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex(self.pfx)
end


function imba_phantom_lancer_spirit_lance:OnProjectileHit_ExtraData(target, pos, keys)
	if not target  then
		return
	end
	if target:TG_TriggerSpellAbsorb(self) then
		return
	end
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor("lance_damage")

	target:AddNewModifier_RS(caster, self, "modifier_imba_spirit_lance_slow", {duration = self:GetSpecialValueFor("duration")})

	local damageTable = {
					victim = target,
					attacker = self:GetCaster(),
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self,
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					}
	--self:GetCaster():PerformAttack(target, true, true, true, false, false, false, true)
	ApplyDamage(damageTable)
	self:GetCaster():EmitSound("Hero_PhantomLancer.SpiritLance.Impact")
	local modifier_illusions =
	{
	    outgoing_damage=0,
	    incoming_damage=0,
	    bounty_base=0,
	    bounty_growth=0,
	    outgoing_damage_structure=0,
	    outgoing_damage_roshan=0,
	}
	local ability = caster:FindAbilityByName("imba_phantom_lancer_phantom_edge")
	if target:IsAlive() and target and caster:IsAlive() and not caster:IsIllusion() then
		caster.illusions = CreateIllusions(caster, caster, modifier_illusions, 1, 0, false, false)
		for i=1, #caster.illusions do
			FindClearSpaceForUnit(caster.illusions[i], target:GetAbsOrigin(), false)
			caster.illusions[i]:SetForwardVector(TG_Direction(target:GetAbsOrigin(),caster.illusions[i]:GetAbsOrigin()))
			caster.illusions[i]:AddNewModifier(caster, self, "modifier_kill", {duration = 15})
			caster.illusions[i]:AddNewModifier(caster, self, "modifier_phased", {duration = 15})
			caster.illusions[i]:AddNewModifier(caster, self, "modifier_imba_spirit_lance_att", {duration = 15, target_entindex = target:entindex()})
			caster.illusions[i]:AddNewModifier(caster, ability, "modifier_imba_phantom_edge_move", {duration = 15})
		end
	end
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	if #enemy >= 1 then
		if PseudoRandom:RollPseudoRandom(self, self:GetSpecialValueFor("bounce_chance")) then
			local new_target = nil
			new_target = enemy[1]
			for i=1, #enemy do
				if enemy[i] ~= target then
					new_target = enemy[i]
					break
				end
			end
			if not new_target then
				new_target = target
			end
			local pfx_name = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_projectile.vpcf"
			local speed = self:GetSpecialValueFor("lance_speed")
			if new_target then
				local info =
				{
					Target = new_target,
					Source = target,
					Ability = self,
					EffectName = pfx_name,
					iMoveSpeed = speed,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
					bDrawsOnMinimap = false,
					bDodgeable = true,
					bIsAttack = false,
					bVisibleToEnemies = true,
					bReplaceExisting = false,
					flExpireTime = GameRules:GetGameTime() + 10,
					bProvidesVision = false,
					ExtraData = {},
				}
				ProjectileManager:CreateTrackingProjectile(info)
			end
		end
	end
end
modifier_imba_spirit_lance_att = class({})

function modifier_imba_spirit_lance_att:IsDebuff()				return false end
function modifier_imba_spirit_lance_att:IsHidden() 			return true end
function modifier_imba_spirit_lance_att:IsPurgable() 			return false end
function modifier_imba_spirit_lance_att:IsPurgeException() 	return false end
function modifier_imba_spirit_lance_att:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
   	}
end
function modifier_imba_spirit_lance_att:CheckState()
	return
		{
		[MODIFIER_STATE_INVULNERABLE]	= true,
		[MODIFIER_STATE_UNSELECTABLE]	= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP]	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR]	= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]	= true,
		}
end
function modifier_imba_spirit_lance_att:OnCreated(keys)
	self.caster = self:GetParent()
	self.att_count = self:GetAbility():GetSpecialValueFor("att_count") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_phantom_lancer_2")
	if IsServer() then
		self.int = 0
        self.target = EntIndexToHScript(keys.target_entindex)
        self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_spirit_lance_att:OnIntervalThink()
	if self.target then
		self.caster:MoveToTargetToAttack(self.target)
		self.caster:SetAttacking(self.target)
		self.caster:SetForceAttackTarget(self.target)
		Timers:CreateTimer(FrameTime(), function()
				self.caster:SetForceAttackTarget(nil)
				return nil
			end
		)
	end
	if not self.target or not self.target:IsAlive() then
		self.caster:ForceKill(false)
	end
end
function modifier_imba_spirit_lance_att:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() then
		return
	end
	if not self.target or not self.target:IsAlive() then
		return
	end
	self.int = self.int + 1
	if self.int >= self.att_count then
	--self:GetCaster():PerformAttack(self.target, true, true, true, false, false, false, true)
		self.caster:ForceKill(false)
	end
end
modifier_imba_spirit_lance_slow = class({})

function modifier_imba_spirit_lance_slow:IsDebuff()				return true end
function modifier_imba_spirit_lance_slow:IsHidden() 			return false end
function modifier_imba_spirit_lance_slow:IsPurgable() 			return true end
function modifier_imba_spirit_lance_slow:IsPurgeException() 	return true end
function modifier_imba_spirit_lance_slow:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        --MODIFIER_EVENT_ON_HEAL_RECEIVED,
        --MODIFIER_PROPERTY_DISABLE_HEALING
   	}
end
function modifier_imba_spirit_lance_slow:OnCreated()
	self.slow = 0-self:GetAbility():GetSpecialValueFor("movement_speed_pct")
	if IsServer() then
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
	end
end
function modifier_imba_spirit_lance_slow:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end
end
function modifier_imba_spirit_lance_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end
--[[function modifier_imba_spirit_lance_slow:GetDisableHealing()
    return  1
end
function modifier_imba_spirit_lance_slow:OnHealReceived(keys)
    if keys.unit == self:GetParent() and not keys.unit:IsBoss() then
	 	local damageTable = {
							victim = self:GetParent(),
							attacker = self:GetCaster(),
							damage = keys.gain*0.1,
							damage_type = DAMAGE_TYPE_MAGICAL,
							ability = self:GetAbility(),
							damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
							}
		ApplyDamage(damageTable)
    end
end]]

imba_phantom_lancer_doppelwalk = class({})
LinkLuaModifier("modifier_imba_doppelwalk_thinker", "linken/hero_phantom_lancer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_doppelwalk_delay", "linken/hero_phantom_lancer.lua", LUA_MODIFIER_MOTION_NONE)
function imba_phantom_lancer_doppelwalk:GetAOERadius()
	return self:GetSpecialValueFor("target_aoe")
end
function imba_phantom_lancer_doppelwalk:GetCooldown(i) return self.BaseClass.GetCooldown(self, i) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_phantom_lancer_4") end
function imba_phantom_lancer_doppelwalk:GetCastRange() return self:GetSpecialValueFor("cast_range") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_phantom_lancer_5") end
function imba_phantom_lancer_doppelwalk:OnSpellStart()
	local caster = self:GetCaster()
	local target_pos = self:GetCursorPosition()
	local modifier = caster:GetModifierCount()
	local duration = self:GetSpecialValueFor("illusion_duration")
	local search_radius = self:GetSpecialValueFor("search_radius")
	local delay = self:GetSpecialValueFor("delay")
	local target_aoe = self:GetSpecialValueFor("target_aoe")
	local illusion_number = self:GetSpecialValueFor("illusion_number")
	self:GetCaster():Purge(false, true, false, true, false)
	self:GetCaster():EmitSound("Hero_PhantomLancer.Doppelganger.Cast")
	ProjectileManager:ProjectileDodge(caster)
	local illusions = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		search_radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)


		caster:AddNewModifier(caster, self, "modifier_imba_doppelwalk_delay",
			{
			duration = delay,
			target_aoe = target_aoe,
			illusion_duration = duration,
			illusion_number = illusion_number
			}
		)

	local modifier_illusions =
	{
	    outgoing_damage=-100,
	    incoming_damage=-100,
	    bounty_base=0,
	    bounty_growth=0,
	    outgoing_damage_structure=0,
	    outgoing_damage_roshan=0,
	}
	caster.illusions = CreateIllusions(caster, caster, modifier_illusions, 1, 0, true, true)
	for i=1, #caster.illusions do
	    caster.illusions[i]:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
	    caster.illusions[i]:AddNewModifier(caster, self, "modifier_phased", {})
	    caster.illusions[i]:AddNewModifier(caster, self, "modifier_imba_illusion_no_order", {})
	end

end
modifier_imba_doppelwalk_thinker  = class({})

function modifier_imba_doppelwalk_thinker:OnCreated(keys)
	self.target_aoe = keys.target_aoe
	self.max_range = self:GetAbility():GetSpecialValueFor("cast_range") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_phantom_lancer_5")
	if IsServer() then
		self.target_pos = self:GetParent():GetAbsOrigin()
		self.pos = self:GetParent():GetOrigin()



		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantom_lancer_doppleganger_aoe.vpcf", PATTACH_POINT, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.pfx, 2, Vector(self.target_aoe,self.target_aoe,self.target_aoe))
		ParticleManager:SetParticleControl(self.pfx, 3, Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex(self.pfx)


		local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"
		self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber() )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.target_aoe, 0, -100 ) )
		ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( 1 , 0, 0 ) )

	end
end

function modifier_imba_doppelwalk_thinker:OnDestroy()
	if not IsServer() then return end
	if self.effect_cast then
		ParticleManager:DestroyParticle( self.effect_cast, true )
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end
	--UTIL_Remove( self:GetParent() )
	self:GetParent():RemoveSelf()
end
function modifier_imba_doppelwalk_thinker:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end
function modifier_imba_doppelwalk_thinker:SetValidTarget( location )
	local origin = self.pos
	local vec = location-origin
	local direction = vec
	direction.z = 0
	direction = direction:Normalized()

	if vec:Length2D()>self.max_range then
		vec = direction * self.max_range
	end

	self.target_pos = GetGroundPosition( origin + vec, nil )
	self:GetParent():SetAbsOrigin(self.target_pos)
	self:GetCaster():SetAbsOrigin(self.target_pos)

end
function modifier_imba_doppelwalk_thinker:OnOrder( params )
	if params.unit~=self:GetCaster() then return end

	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self:SetValidTarget( params.new_pos )
	elseif
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetValidTarget( params.target:GetOrigin() )
	end
end




modifier_imba_doppelwalk_delay = class({})

function modifier_imba_doppelwalk_delay:IsDebuff()				return false end
function modifier_imba_doppelwalk_delay:IsHidden() 				return false end
function modifier_imba_doppelwalk_delay:IsPurgable() 			return false end
function modifier_imba_doppelwalk_delay:IsPurgeException() 		return false end
function modifier_imba_doppelwalk_delay:OnCreated(keys)
	self.illusion_duration = keys.illusion_duration
	self.illusion_number = keys.illusion_number
	self.target_aoe = keys.target_aoe
	self.target_pos = self:GetParent():GetAbsOrigin()
	if IsServer() then


		self.dummy_pfx = CreateModifierThinker(
				self:GetParent(), -- player source
				self:GetAbility(), -- ability source
				"modifier_imba_doppelwalk_thinker", -- modifier name
				{
					duration = 1.1,
					target_aoe = self.target_aoe,
				}, -- kv
				self:GetParent():GetAbsOrigin(),
				self:GetCaster():GetTeamNumber(),
				false
			)

		self:GetParent():AddNoDraw()
	end
end
function modifier_imba_doppelwalk_delay:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true, --缴械
		[MODIFIER_STATE_SILENCED] = true, --沉默
		[MODIFIER_STATE_MUTED] = true,  --变形
		[MODIFIER_STATE_OUT_OF_GAME] = true,  --除外
		[MODIFIER_STATE_INVULNERABLE] = true, --无敌
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end

function modifier_imba_doppelwalk_delay:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		local duration = self:GetAbility():GetSpecialValueFor("duration")
		if not self:GetParent():IsIllusion() then
			local next_pos = self.dummy_pfx:GetAbsOrigin() + RandomVector(self.target_aoe):Normalized() * RandomInt(100, self.target_aoe)
			FindClearSpaceForUnit(self:GetParent(), self.dummy_pfx:GetAbsOrigin(), false)
		end
	end

end
function modifier_imba_doppelwalk_delay:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()

			local modifier_illusions =
			{
				outgoing_damage=self:GetAbility():GetSpecialValueFor("illusion_proc_chance_pct")-100,
	    		incoming_damage=self:GetAbility():GetSpecialValueFor("tooltip_total_illusion_damage_in_pct")-100,
			    bounty_base=0,
			    bounty_growth=0,
			    outgoing_damage_structure=0,
			    outgoing_damage_roshan=0,
			}
		self:GetParent():RemoveNoDraw()
		self.dummy_pfx:Destroy()

	self:GetCaster():EmitSound("Hero_PhantomLancer.Doppelganger.Appear")
	end
	self.pos = nil
	self.illusion_duration = nil
	self.illusion_number = nil
	self.target_aoe = nil
	self.target_pos = nil
end


imba_phantom_lancer_phantom_edge = class({})
LinkLuaModifier("modifier_imba_phantom_edge", "linken/hero_phantom_lancer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_edge_move", "linken/hero_phantom_lancer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_edge_move_delay", "linken/hero_phantom_lancer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_edge_add", "linken/hero_phantom_lancer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_edge_debuff", "linken/hero_phantom_lancer.lua", LUA_MODIFIER_MOTION_NONE)

function imba_phantom_lancer_phantom_edge:GetIntrinsicModifierName()
  return "modifier_imba_phantom_edge"
end
function imba_phantom_lancer_phantom_edge:GetBehavior()
	--if self:GetCaster():TG_HasTalent("special_bonus_imba_phantom_lancer_7") then
	--	return  DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL
	--else
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	--end
end
function imba_phantom_lancer_phantom_edge:GetCastRange() return self:GetSpecialValueFor("max_distance") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_phantom_lancer_1") end
function imba_phantom_lancer_phantom_edge:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "dota_hud_error_cant_cast_on_self"
	elseif not target:IsIllusion() or target:GetPlayerOwnerID() ~= self:GetParent():GetPlayerOwnerID() then
		return "无法非自身幻象施放"
	end
end
function imba_phantom_lancer_phantom_edge:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		local casterID = caster:GetPlayerOwnerID()
		local targetID = target:GetPlayerOwnerID()

		if target == caster then
			return UF_FAIL_CUSTOM
		end

		if target:IsCourier() then
			return UF_FAIL_COURIER
		end
		if casterID ~= targetID then
			return UF_FAIL_OTHER
		end
		if not target:IsIllusion() then
			return UF_FAIL_CUSTOM
		end
	end
end

modifier_imba_phantom_edge = class({})
function modifier_imba_phantom_edge:IsDebuff()      return false end
function modifier_imba_phantom_edge:IsHidden()      return true end
function modifier_imba_phantom_edge:IsPurgable()    return false end
function modifier_imba_phantom_edge:IsPurgeException()  return false end
function modifier_imba_phantom_edge:DeclareFunctions()
	return {
			MODIFIER_EVENT_ON_ORDER,
			}
end
function modifier_imba_phantom_edge:OnOrder(keys)
	if keys.unit == self:GetParent() then
		if self:GetParent():HasModifier("modifier_imba_phantom_edge_move") then
			self:GetParent():RemoveModifierByName("modifier_imba_phantom_edge_move")
			--self:GetParent():FindModifierByName("modifier_imba_phantom_edge_move"):Destroy()
		end
		if self:GetParent():HasModifier("modifier_imba_phantom_edge_move_delay") then
			self:GetParent():RemoveModifierByName("modifier_imba_phantom_edge_move_delay")
			--self:GetParent():FindModifierByName("modifier_imba_phantom_edge_move_delay"):Destroy()
		end
		if keys.order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET and not self:GetParent():HasModifier("modifier_imba_phantom_edge_move") then
			return
		end
		if keys.target ~= nil then
			if Is_Chinese_TG(self:GetParent(), keys.target) then
				return
			end
		end
		if not keys.target and not self:GetParent():HasModifier("modifier_imba_phantom_edge_move") then
			return
		end
		self.agility_duration = self:GetAbility():GetSpecialValueFor("agility_duration")
		self.max_distance = self:GetAbility():GetSpecialValueFor("max_distance") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_phantom_lancer_1")
		self.min_distance = self:GetAbility():GetSpecialValueFor("min_distance")
		if TG_Distance(self:GetParent():GetAbsOrigin(), keys.target:GetAbsOrigin()) > self.max_distance and keys.target ~= nil then
			self:GetParent():AddNewModifier(keys.target, self:GetAbility(), "modifier_imba_phantom_edge_move_delay", {})
		end
		if not self:GetParent():PassivesDisabled() then
			--if self:GetAbility():IsCooldownReady() then
				if TG_Distance(self:GetParent():GetAbsOrigin(), keys.target:GetAbsOrigin()) <= self.max_distance and TG_Distance(self:GetParent():GetAbsOrigin(), keys.target:GetAbsOrigin()) > self.min_distance then
					self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_phantom_edge_move", {duration = self.agility_duration})
					self:GetParent():RemoveModifierByName("modifier_imba_phantom_edge_move_delay")
					--self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(self:GetAbility():GetLevel() -1 ) * self:GetParent():GetCooldownReduction()))
				end
			--end
		end
	end
end
function modifier_imba_phantom_edge:OnCreated(keys)
	self.agility_duration = self:GetAbility():GetSpecialValueFor("agility_duration")
	self.max_distance = self:GetAbility():GetSpecialValueFor("max_distance") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_phantom_lancer_1")
	self.min_distance = self:GetAbility():GetSpecialValueFor("min_distance")
	if IsServer() then
	end
end



modifier_imba_phantom_edge_move_delay = class({})
function modifier_imba_phantom_edge_move_delay:IsDebuff()      return false end
function modifier_imba_phantom_edge_move_delay:IsHidden()      return true end
function modifier_imba_phantom_edge_move_delay:IsPurgable()    return false end
function modifier_imba_phantom_edge_move_delay:IsPurgeException()  return false end
function modifier_imba_phantom_edge_move_delay:OnCreated(keys)
	--self.target = keys.target
	--print(self:GetCaster())
	self.agility_duration = self:GetAbility():GetSpecialValueFor("agility_duration")
	self.max_distance = self:GetAbility():GetSpecialValueFor("max_distance") + self:GetParent():TG_GetTalentValue("special_bonus_imba_phantom_lancer_1")
	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_imba_phantom_edge_move_delay:OnIntervalThink()
	--print(self:GetParent()==self:GetCaster())
	if not self:GetCaster():IsAlive() then
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end
	if TG_Distance(self:GetParent():GetAbsOrigin(), self:GetCaster():GetAbsOrigin()) <= self.max_distance then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_phantom_edge_move", {duration = self.agility_duration})
		self:Destroy()
		return
	end
end


modifier_imba_phantom_edge_move = class({})
function modifier_imba_phantom_edge_move:OnCreated(keys)
	if self:GetAbility()==nil then
		return
	end
	--self.bonus_speed = self:GetAbility():GetSpecialValueFor("bonus_speed") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_phantom_lancer_7")
	self.agility_duration = self:GetAbility():GetSpecialValueFor("agility_duration")
	--self.shard = self:GetAbility():GetSpecialValueFor("shard")
	--self.shard_duration = self:GetAbility():GetSpecialValueFor("shard_duration")
	if IsServer() then
		self:GetCaster():EmitSound("Hero_PhantomLancer.PhantomEdge")
		--self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_lancer/phantomlancer_edge_boost.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		--ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
		--ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())
		--ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end
--[[function modifier_imba_phantom_edge_move:OnRefresh(keys)
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end
end]]
function modifier_imba_phantom_edge_move:CheckState()
	return
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSLOWABLE] = true,
		}
end
function modifier_imba_phantom_edge_move:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
			MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
			MODIFIER_EVENT_ON_ATTACK,
			}
end
function modifier_imba_phantom_edge_move:GetModifierIgnoreMovespeedLimit() return 1 end
function modifier_imba_phantom_edge_move:GetModifierMoveSpeed_Absolute()
  	return self:GetAbility():GetSpecialValueFor("bonus_speed") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_phantom_lancer_7")
end
function modifier_imba_phantom_edge_move:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() then
		return
	end
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_phantom_edge_add", {duration = self.agility_duration})
	keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_phantom_edge_debuff", {duration = self.agility_duration})
	--if PseudoRandom:RollPseudoRandom(self:GetAbility(), self.shard) and self:GetParent():Has_Aghanims_Shard() then
	--	keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self.shard_duration})
	--end
	self:Destroy()
end
function modifier_imba_phantom_edge_move:OnDestroy(keys)
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end
end

modifier_imba_phantom_edge_add = class({})
function modifier_imba_phantom_edge_add:OnCreated(keys)
	if IsServer() then

	end
end
function modifier_imba_phantom_edge_add:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			}
end
--[[function modifier_imba_phantom_edge_add:GetStatusEffectName()
  return "particles/units/heroes/hero_phantom_lancer/phantomlancer_doppelwalk.vpcf"
end]]
function modifier_imba_phantom_edge_add:GetModifierBonusStats_Agility()
  return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

modifier_imba_phantom_edge_debuff = class({})
function modifier_imba_phantom_edge_debuff:OnCreated(keys)
	if self:GetAbility()==nil then
		return
	end
	self.incoming = 0-self:GetAbility():GetSpecialValueFor("incoming")
end
function modifier_imba_phantom_edge_debuff:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
			}
end
function modifier_imba_phantom_edge_debuff:GetModifierTotalDamageOutgoing_Percentage()
  return self.incoming
end

imba_phantom_lancer_juxtapose = class({})
LinkLuaModifier("modifier_imba_juxtapose_passive", "linken/hero_phantom_lancer.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_juxtapose_illusion", "linken/hero_phantom_lancer.lua", LUA_MODIFIER_MOTION_NONE)
function imba_phantom_lancer_juxtapose:GetCastRange() return self:GetSpecialValueFor("aura_range") end
function imba_phantom_lancer_juxtapose:GetIntrinsicModifierName() return "modifier_imba_juxtapose_passive" end
function imba_phantom_lancer_juxtapose:GetCooldown(i)
	if self:GetCaster():HasScepter() then
		return self.BaseClass.GetCooldown(self, i) + self:GetSpecialValueFor("cd_sce")
	end
	return self.BaseClass.GetCooldown(self, i)
end
function imba_phantom_lancer_juxtapose:OnOwnerDied()
	self.toggle = self:GetToggleState()
end

function imba_phantom_lancer_juxtapose:OnOwnerSpawned()
	if self.toggle == nil then
		self.toggle = false
	end
	if self.toggle ~= self:GetToggleState() then
		self:ToggleAbility()
	end
end

function imba_phantom_lancer_juxtapose:OnToggle()
	self:EndCooldown()
	self.toggle = self:GetToggleState()
end
modifier_imba_juxtapose_passive = class({})

function modifier_imba_juxtapose_passive:IsDebuff()				return false end
function modifier_imba_juxtapose_passive:IsHidden() 			return true end
function modifier_imba_juxtapose_passive:IsPermanent() 		return true end
function modifier_imba_juxtapose_passive:IsPurgable() 			return false end
function modifier_imba_juxtapose_passive:IsPurgeException() 	return false end
function modifier_imba_juxtapose_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
--function modifier_imba_juxtapose_passive:AllowIllusionDuplicate() return true end
function modifier_imba_juxtapose_passive:OnCreated( kv )
	local caster = self:GetCaster()
	self.att_pct = self:GetAbility():GetSpecialValueFor("att_pct") + caster:TG_GetTalentValue("special_bonus_imba_phantom_lancer_3")
	self.mag_pct = self:GetAbility():GetSpecialValueFor("mag_pct") + caster:TG_GetTalentValue("special_bonus_imba_phantom_lancer_3")
	self.du_pct = self:GetAbility():GetSpecialValueFor("du_pct")
	if not IsServer() then return end
end

function modifier_imba_juxtapose_passive:DeclareFunctions()
	return
		{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ABILITY_START,
		}
end
function modifier_imba_juxtapose_passive:GetModifierMagicalResistanceBonus() return self:GetAbility():GetSpecialValueFor("magic_resistance")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_phantom_lancer_6") end
function modifier_imba_juxtapose_passive:OnAttackStart( keys )
	if not IsServer() then return end
	if self:GetParent():PassivesDisabled() then
		return
	end
	if keys.target ~= self:GetParent()  then
		return
	end
	if not keys.attacker:IsHero() then
		return
	end
	if not IsEnemy(keys.attacker, keys.target) then
		return
	end
	if PseudoRandom:RollPseudoRandom(self:GetAbility(), self.att_pct) and self:GetAbility():IsCooldownReady() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_juxtapose_illusion", {duration = self.du_pct})
		if not self:GetParent():IsDisarmed() then
			self:GetParent():PerformAttack(keys.attacker, false, true, true, false, true, false, true)
		end
		if self:GetAbility():GetToggleState() then
			local next_pos = self:GetParent():GetAbsOrigin() + RandomVector(300):Normalized() * RandomInt(100, 300)
			FindClearSpaceForUnit(self:GetParent(), next_pos, false)
		end
		self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(-1)) * self:GetParent():GetCooldownReduction())
	end
end
function modifier_imba_juxtapose_passive:OnAbilityStart( keys )
	if not IsServer() then return end
	if self:GetParent():PassivesDisabled() then
		return
	end
	if keys.target ~= self:GetParent() then
		return
	end
	if not keys.ability:GetCaster():IsHero() then
		return
	end
	if not IsEnemy(keys.target, keys.ability:GetCaster()) then
		return
	end
	if PseudoRandom:RollPseudoRandom(self:GetAbility(), self.mag_pct) and self:GetAbility():IsCooldownReady() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_juxtapose_illusion", {duration = self.du_pct})
		if not self:GetParent():IsDisarmed() then
			self:GetParent():PerformAttack(keys.ability:GetCaster(), false, true, true, false, true, false, true)
		end
		if self:GetAbility():GetToggleState() then
			local next_pos = self:GetParent():GetAbsOrigin() + RandomVector(300):Normalized() * RandomInt(100, 300)
			FindClearSpaceForUnit(self:GetParent(), next_pos, false)
		end
		self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(-1)) * self:GetParent():GetCooldownReduction())
	end
end
function modifier_imba_juxtapose_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if self:GetParent():PassivesDisabled() then
		return
	end
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local ability2 = self:GetParent():FindAbilityByName("imba_phantom_lancer_spirit_lance")
	local chance_pct = ability:GetSpecialValueFor("proc_chance_pct") + caster:TG_GetTalentValue("special_bonus_imba_phantom_lancer_3")
	--local enemies = FindUnitsInRadius(caster:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if PseudoRandom:RollPseudoRandom(ability, chance_pct) and self:GetAbility():IsCooldownReady() and ability2:IsTrained() and ability2 then
		if (self:GetCaster():Has_Aghanims_Shard() or not keys.target:IsMagicImmune()) then
			self:GetParent():SetCursorCastTarget(keys.target)
			ability2:OnSpellStart(true)
			--keys.target:AddNewModifier(caster, ability2, "modifier_imba_spirit_lance_slow", {duration = ability2:GetSpecialValueFor("duration")})
			if keys.target:IsHero() then
				self:GetAbility():StartCooldown((self:GetAbility():GetCooldown(-1)) * self:GetParent():GetCooldownReduction())
			end
			--local caster = self:GetCaster()
		end
	end
end
modifier_imba_juxtapose_illusion = class({})

function modifier_imba_juxtapose_illusion:IsDebuff()			return false end
function modifier_imba_juxtapose_illusion:IsHidden() 			return false end
function modifier_imba_juxtapose_illusion:IsPurgable() 			return false end
function modifier_imba_juxtapose_illusion:IsPurgeException() 	return false end
function modifier_imba_juxtapose_illusion:CheckState()
    return
   		 {
          [MODIFIER_STATE_INVULNERABLE] = true,
      		}
end
function modifier_imba_juxtapose_illusion:OnCreated( kv )
	if not IsServer() then return end
	ProjectileManager:ProjectileDodge(self:GetParent())
	self.pfx = ParticleManager:CreateParticle("particles/heros/phantom_lancer/phantom_lancer.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
end
function modifier_imba_juxtapose_illusion:OnDestroy()
	if not IsServer() then return end
	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end
