CreateTalents("npc_dota_hero_keeper_of_the_light", "ting/hero_keeper_of_the_light")
--冲击波		
imba_light_illuminate = class({})  
LinkLuaModifier("modifier_imba_light_illuminate", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)	--冲击波蓄力
LinkLuaModifier("modifier_imba_light_illuminate_thinker", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE) -- 冲击波本体
LinkLuaModifier("modifier_imba_light_light_spell", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE) --是否在蓄力冲击波 换图标用
LinkLuaModifier("modifier_imba_light_light_think", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)	--马甲单位的buff
LinkLuaModifier("modifier_imba_light_spirit_flag", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)	--a杖冲击波
LinkLuaModifier("modifier_imba_light_spirit_cd", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)	--冲击波的cd 记录
function imba_light_illuminate:GetManaCost() return self:GetCaster():HasModifier("modifier_imba_light_light_spell") and 0 or 150 end
function imba_light_illuminate:GetChannelTime() 
	return self:GetSpecialValueFor("max_channel_time")
end
function imba_light_illuminate:GetAbilityTextureName() 
		if self:GetCaster():HasModifier("modifier_imba_light_light_spell") then
			return "keeper_of_the_light_illuminate_end_png"
		end

		return "keeper_of_the_light_illuminate_png"
end
function imba_light_illuminate:GetBehavior()
	if self:GetCaster():HasModifier("modifier_imba_light_light_spell") then 
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

function imba_light_illuminate:CastFilterResultTarget(target)
	if  IsEnemy(target, self:GetCaster()) then
		return UF_FAIL_CUSTOM
	end
	if target:GetUnitName() ==  "npc_dota_ignis_fatuus" then
		return UF_SUCCESS
	end
	
	if not self:GetCaster():HasScepter() and Is_Chinese_TG(target,self:GetCaster()) then
		return UF_FAIL_CUSTOM
	end
	
end

function imba_light_illuminate:OnSpellStart()

	self.caster		= self:GetCaster()
	self.max_channel_time = self:GetSpecialValueFor("max_channel_time")
	if self.caster:HasModifier("modifier_imba_light_light_spell") then --假装替换技能 
		local caster = self.caster:FindModifierByName("modifier_imba_light_light_spell"):GetCaster()
		caster:RemoveModifierByName("modifier_imba_light_illuminate")		
		self.caster:Stop()
		return 
	end
	

	self.position	= self:GetCursorPosition()

	if self:GetCursorTarget() then
			local target = self:GetCursorTarget()
			if target:GetUnitName() == "npc_dota_ignis_fatuus" then --回血点亮那个球
				target:SetHealth(target:GetMaxHealth())
				local ab = self.caster:FindAbilityByName("imba_light_will_o_wisp") 
				if ab and ab:GetLevel() > 0 then
					if not target:HasModifier("modifier_imba_light_will_o_wisp_t") then
						local mod = target:AddNewModifier(self.caster,ab,"modifier_imba_light_will_o_wisp_t",{duration = ab:GetSpecialValueFor("on_duration")})
						target:AddNewModifier(self.caster,ab,"modifier_imba_light_will_o_wisp_t_on",{duration = ab:GetSpecialValueFor("on_duration")})
						if mod then
							mod:SetStackCount(1)
						end
					else
						local mod = target:FindModifierByName("modifier_imba_light_will_o_wisp_t")
						mod:SetStackCount(mod:GetStackCount()+1)
						target:RemoveModifierByName("modifier_imba_light_will_o_wisp_t_off")
						target:AddNewModifier(self.caster,ab,"modifier_imba_light_will_o_wisp_t_on",{duration = ab:GetSpecialValueFor("on_duration")})
					end
				end
			end
			if self.caster:HasScepter() then
				self.caster:EmitSound("Hero_KeeperOfTheLight.Illuminate.Charge")
				target:AddNewModifier(self.caster, self, "modifier_imba_light_spirit_flag", {duration = self.max_channel_time})
			end
			self.caster:Stop()
	else	
		if self.caster:Has_Aghanims_Shard() then	--魔晶代替施法
				local mp = self.caster:GetMaxMana()
				local light_think = CreateUnitByName("npc_dota_ignis_fatuus", self.caster:GetAbsOrigin(), true, self.caster, self.caster, self.caster:GetTeamNumber())
					light_think:FaceTowards(self.position)
					light_think:AddNewModifier(self.caster, self, "modifier_imba_light_illuminate", {duration = self.max_channel_time,sprit = 1})
					light_think:AddNewModifier(self.caster, self, "modifier_imba_light_light_think", {duration = self.max_channel_time})
					light_think:SetMaxMana(mp)
					light_think:SetMana(mp)
					self.caster:AddNewModifier(light_think, self, "modifier_imba_light_light_spell", {duration = self.max_channel_time})


					self.caster:Stop()
					self.caster:EmitSound("Hero_KeeperOfTheLight.Illuminate.Charge")
			else	--自己施法
			self.caster:AddNewModifier(self.caster, self, "modifier_imba_light_illuminate", {duration = self.max_channel_time})
			self.caster:AddNewModifier(self.caster, self, "modifier_imba_light_light_spell", {duration = self.max_channel_time})
			self.caster:EmitSound("Hero_KeeperOfTheLight.Illuminate.Charge")
			end			
	end
end


function imba_light_illuminate:OnChannelFinish(bInterrupted)
	local caster = self:GetCaster()
	if not caster:Has_Aghanims_Shard() then
		caster:RemoveModifierByName("modifier_imba_light_illuminate")
	end
end

--换技能记录cd
modifier_imba_light_spirit_cd = class({})
function modifier_imba_light_spirit_cd:IsDebuff()		return false end
function modifier_imba_light_spirit_cd:IsHidden()		return true end
function modifier_imba_light_spirit_cd:IsPurgable()	return false end
function modifier_imba_light_spirit_cd:IsPurgeException()	return false end
function modifier_imba_light_spirit_cd:RemoveOnDeath()		return false end
--是否在蓄力冲击波
modifier_imba_light_light_spell = class({})
LinkLuaModifier("modifier_imba_light_spirit_cd", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)	--冲击波的cd 记录
function modifier_imba_light_light_spell:IsDebuff()		return false end
function modifier_imba_light_light_spell:IsHidden()		return false end
function modifier_imba_light_light_spell:IsPurgable()	return false end
function modifier_imba_light_light_spell:OnCreated()
	if IsServer() then 
		local ab = self:GetAbility()
		if ab then
			self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_imba_light_spirit_cd",{duration = ab:GetCooldownTimeRemaining()})
			ab:EndCooldown()
		end
	end
end
function modifier_imba_light_light_spell:OnDestroy()
	if IsServer() then
		local ab = self:GetAbility()
		local parent = self:GetParent()
		if ab then 
			if parent:HasModifier("modifier_imba_light_spirit_cd") then
				local mod = parent:FindModifierByName("modifier_imba_light_spirit_cd")
				ab:EndCooldown()
				ab:StartCooldown( mod:GetRemainingTime() )
				parent:RemoveModifierByName("modifier_imba_light_spirit_cd")
			else
				ab:EndCooldown()
			end
		end
	end
end
--替身的状态buff
modifier_imba_light_light_think = class({})
function modifier_imba_light_light_think:IsHidden()		return true end
function modifier_imba_light_light_think:IsDebuff()		return false end
function modifier_imba_light_light_think:IsPurgable()	return false end
function modifier_imba_light_light_think:IsPurgeException()	return false end
function modifier_imba_light_light_think:CheckState() return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true,[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true ,[MODIFIER_STATE_UNSELECTABLE]=true } end




--冲击波thinker
modifier_imba_light_illuminate = class({})
LinkLuaModifier("modifier_imba_light_illuminate_thinker", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_light_illuminate:IsPurgable()	return false end

function modifier_imba_light_illuminate:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf"
end
--particles/econ/courier/courier_trail_01/courier_trail_01.vpcf
function modifier_imba_light_illuminate:GetStatusEffectName()
	return "particles/status_fx/status_effect_keeper_spirit_form.vpcf"
end


function modifier_imba_light_illuminate:OnCreated(keys)
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	-- AbilitySpecials
	self.range							= self.ability:GetSpecialValueFor("range")+self.caster:GetCastRangeBonus()
	self.speed							= self.ability:GetSpecialValueFor("speed")
	self.mana_cost 						= self.ability:GetSpecialValueFor("mana_cost")*0.01
	self.sprit = keys.sprit
	self.caster_location	= self.caster:GetAbsOrigin()
	self.max_count = self.ability:GetSpecialValueFor("max_channel_time")*10
	self.count_per = self.caster:TG_HasTalent("special_bonus_imba_keeper_of_the_light_1") and self.max_count or 2 

	
	self.position			= self.ability.position

	
	if not IsServer() then return end
	self.mana = 0
	self.direction	= (self.position - self.caster_location):Normalized()

	self.game_time_start		= GameRules:GetGameTime()

	self.vision_counter 		= 1
	self.vision_time_count		= GameRules:GetGameTime()
	
	self.weapon_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/kotl_illuminate_cast.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.weapon_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.weapon_particle, false, false, -1, false, false)
	
	self.particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling_on.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle2, 2, Vector(0, 0, 0))
	self:AddParticle(self.particle2, false, false, -1, false, false)
	self:OnIntervalThink()
	self:StartIntervalThink(0.1)
end

function modifier_imba_light_illuminate:OnIntervalThink()
	if not IsServer() then return end
	local mod = self.caster:FindAllModifiersByName("modifier_imba_radiant_bind_debuff_flag")
	for _,m in pairs(mod) do
		local target = m:GetCaster()
		if target:IsAlive() then
			local mana = target:GetMaxMana()*self.mana_cost
			target:SpendMana(mana,self.ability)
			self.mana = mana + self.mana
		end
	end

	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetStackCount()*36,2.5, false)	
	if self:GetParent():GetMana() > self:GetParent():GetMaxMana()*0.2 then
	local mana2 = self:GetParent():GetMaxMana()*self.mana_cost
	self:GetParent():SpendMana(mana2,self.ability)
	self.mana = mana2 + self.mana
	end
	local mod =  self.caster:FindModifierByName("modifier_imba_light_light_spell") 
	self:SetStackCount(math.min(self:GetStackCount()+self.count_per,self.max_count))
	if mod then
		mod:SetStackCount(self:GetStackCount())
	end
end

function modifier_imba_light_illuminate:OnDestroy()
	if not IsServer() then return end

	self.direction					= (self.position - self.caster_location):Normalized()
	self.duration 					= self.range / self.speed

	self.game_time_end				= GameRules:GetGameTime()
	
	self:GetParent():EmitSound("Hero_KeeperOfTheLight.Illuminate.Discharge")

	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1_END)
	self.caster:RemoveModifierByName("modifier_imba_light_light_spell")
	self.caster:EmitSound("keeper_of_the_light_keep_illuminate_06")
	local think = CreateModifierThinker(self.caster, self.ability, "modifier_imba_light_illuminate_thinker", {
		duration		= self.range / self.speed,
		direction_x 	= self.direction.x,	-- x direction of where Illuminate will travel
		direction_y 	= self.direction.y,	-- y direction of where Illuminate will travel
		channel_time 	= self:GetStackCount(),	-- total time Illuminate was channeled for
		mana_cost 		= self.mana ,
	}, 
	self.caster_location, self.caster:GetTeamNumber(), false)

	
	-- Remove the "spirit" channeling Illuminate
	if self.sprit == 1 then
		self:GetParent():ForceKill(false)
	end

end

-----------------------------
-- ILLUMINATE WAVE THINKER --
-----------------------------
modifier_imba_light_illuminate_thinker = class({})
LinkLuaModifier("imba_light_illuminate_move", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_light_will_o_wisp_move", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_light_illuminate_thinker:OnCreated( params )
	if not IsServer() then return end

	self.ability	= self:GetAbility()
	self.parent		= self:GetParent()
	self.caster		= self:GetCaster()
	self.damage_count			= self.ability:GetSpecialValueFor("damage_count")
	self.mana_cost_damage		= self.ability:GetSpecialValueFor("mana_cost_damage")
	self.radius					= self.ability:GetSpecialValueFor("radius")
	self.speed					= self.ability:GetSpecialValueFor("speed")
	self.channel_time			= params.channel_time
	self.mana_cost				= params.mana_cost
	self.damage				    = self.damage_count*self.channel_time + self.mana_cost*self.mana_cost_damage*0.01
	self.mana_re				= self.mana_cost*self.ability:GetSpecialValueFor("mana_re")*0.01
	self.cd_re					= self.mana_cost*self.ability:GetSpecialValueFor("cd_re")*0.01 
	self.duration				= params.duration
	self.direction				= Vector(params.direction_x, params.direction_y, 0)
	self.direction_angle		= math.deg(math.atan2(self.direction.x, self.direction.y))

	
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_illuminate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle, 1, self.direction * self.speed)
	ParticleManager:SetParticleControl(self.particle, 3, self.parent:GetAbsOrigin())
	
	self:AddParticle(self.particle, false, false, -1, false, false)
	
	self.hit_targets = {}
	if self.caster:TG_HasTalent("special_bonus_imba_keeper_of_the_light_5") then
	
		if self.caster:HasScepter() then
				self.caster:Heal(self.damage, self.caster)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.caster, self.damage, nil)
		end
		
		if self.caster:TG_HasTalent("special_bonus_imba_keeper_of_the_light_3") then
			self.caster:GiveMana(self.mana_re)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self.caster, self.mana_re, nil)
		end	
		
		if self.caster:TG_HasTalent("special_bonus_imba_keeper_of_the_light_4") then
			local cooldown_reduction = self.cd_re
			for i = 0, 23 do
				local current_ability = self.caster:GetAbilityByIndex(i)
				if current_ability and current_ability:GetAbilityType()~= 1 then
					local cooldown_remaining = current_ability:GetCooldownTimeRemaining()
					current_ability:EndCooldown()
						if cooldown_remaining > cooldown_reduction then
							current_ability:StartCooldown( cooldown_remaining - cooldown_reduction )
						end
				end
			end
		end	
		table.insert(self.hit_targets, self:GetCaster())
	end
	
	self:OnIntervalThink()
	self:StartIntervalThink(0.03)
end

function modifier_imba_light_illuminate_thinker:OnIntervalThink()
	if not IsServer() then return end
	
	local targets 	= FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damage	= self.damage
	
	local valid_targets	=	{}

	-- Borrowed from Bristleback logic which I still don't fully understand, but essentially this checks to make sure the target is within the "front" of the wave, because the local targets table returns everything in a circle
	for _, target in pairs(targets) do
		local target_pos 	= target:GetAbsOrigin()
		local target_angle	= math.deg(math.atan2((target_pos.x - self.parent:GetAbsOrigin().x), target_pos.y - self.parent:GetAbsOrigin().y))
		
		local difference = math.abs(self.direction_angle - target_angle)
		
		-- If the enemy's position is not within the front semi-circle, remove them from the table
		if difference <= 90 or difference >= 270 then
			table.insert(valid_targets, target)
		end
	end
	
	-- By the end, the valid_targets table SHOULD have every unit that's actually in the "front" (semi-circle) of the wave, aka they should actually be hit by the wave
	for _, target in pairs(valid_targets) do
	
		local hit_already = false
	
		for _, hit_target in pairs(self.hit_targets) do
			if hit_target == target then
				hit_already = true
				break
			end
		end
		
		if not hit_already then
			if target:GetTeam() ~= self.caster:GetTeam() then
				local damage_type	= DAMAGE_TYPE_MAGICAL
				

			
				local damageTable = {
					victim 			= target,
					damage 			= damage,
					damage_type		= damage_type,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self.caster,
					ability 		= self.ability
				}
				
				ApplyDamage(damageTable)
				target:AddNewModifier(self.parent, self:GetAbility(), "modifier_imba_light_will_o_wisp_move", {duration = 0.4})
				
			else
				if self.caster:HasScepter() then
				target:Heal(damage, self.caster)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, damage, nil)
				end
				if self.caster:TG_HasTalent("special_bonus_imba_keeper_of_the_light_3") then
					target:GiveMana(self.mana_re)
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, target, self.mana_re, nil)
				end	
				if self.caster:TG_HasTalent("special_bonus_imba_keeper_of_the_light_4") then
						local cooldown_reduction = self.cd_re
								for i = 0, 23 do
									local current_ability = target:GetAbilityByIndex(i)
										if current_ability and current_ability:GetAbilityType()~= 1 then
											local cooldown_remaining = current_ability:GetCooldownTimeRemaining()
											current_ability:EndCooldown()
											if cooldown_remaining > cooldown_reduction then
											current_ability:StartCooldown( cooldown_remaining - cooldown_reduction )
											end
										end
								end
				end	
			end
			
			-- Apply sounds (wave sound + horse sounds)
			target:EmitSound("Hero_KeeperOfTheLight.Illuminate.Target")
			target:EmitSound("Hero_KeeperOfTheLight.Illuminate.Target.Secondary")
			
			-- Apply the "hit by Illuminate" particle
			local particle_name = "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_illuminate_impact_small.vpcf"
			
			-- Heroes get a larger particle (supposedly)
			if target:IsHero() then
				particle_name = "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_illuminate_impact.vpcf"
			end
			
			local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle)
			
			-- Add the target to the list of targets hit so they can't get hit again
			table.insert(self.hit_targets, target)
		end
	end

	-- Move the wave forward by a frame
	self.parent:SetAbsOrigin(self.parent:GetAbsOrigin() + (self.direction * self.speed * FrameTime()))
end

-- Safety destructor?
function modifier_imba_light_illuminate_thinker:OnDestroy()
	if not IsServer() then return end

	--self.parent:RemoveSelf()
end


modifier_imba_light_spirit_flag = class({})
LinkLuaModifier("modifier_imba_light_illuminate_thinker", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_light_spirit_flag:IsDebuff() return false end
function modifier_imba_light_spirit_flag:IsPurgable() return false end
function modifier_imba_light_spirit_flag:IsPurgeException() return false end
function modifier_imba_light_spirit_flag:IsHidden() return false end
function modifier_imba_light_spirit_flag:GetEffectName() return "particles/units/heroes/hero_wisp/wisp_overcharge_b.vpcf" end
function modifier_imba_light_spirit_flag:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_light_spirit_flag:OnCreated()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.mana   =  0
	self.mana_cost = self:GetAbility():GetSpecialValueFor("mana_cost")*0.1
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_imba_light_spirit_flag:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local newpos =RotatePosition(self.parent:GetAbsOrigin(), QAngle(0, math.random(0,360), 0), self.parent:GetAbsOrigin() + self.parent:GetForwardVector():Normalized() * 850) 
	local dir = (self.parent:GetAbsOrigin() - newpos):Normalized()
	
	local mod = self.caster:FindAllModifiersByName("modifier_imba_radiant_bind_debuff_flag")
	for _,m in pairs(mod) do
		local target = m:GetCaster()
		if target:IsAlive() then
			local mana = target:GetMaxMana()*self.mana_cost
			target:SpendMana(mana,self.ability)
			self.mana = mana + self.mana
		end
	end

	if self.caster:GetMana() > self.caster:GetMaxMana()*0.2 then
	local mana2 = self.caster:GetMaxMana()*self.mana_cost
	self.caster:SpendMana(mana2,self.ability)
	self.mana = mana2 + self.mana
	end

	
	
	CreateModifierThinker(self:GetCaster(),self:GetAbility(), "modifier_imba_light_illuminate_thinker", {
		duration		= 1.8,
		direction_x 	= dir.x,	
		direction_y 	= dir.y,	
		channel_time 	= 10,	-- total time Illuminate was channeled for
		mana_cost 		= self.mana
	}, 
	newpos, self:GetCaster():GetTeamNumber(), false)
	self.mana = 0
end

--阳炎之缚
imba_light_radiant_bind = class({})  

LinkLuaModifier("modifier_imba_radiant_bind_debuff", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_radiant_bind_debuff_flag", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
function imba_light_radiant_bind:GetAOERadius()
	return self:GetCaster():TG_GetTalentValue("special_bonus_imba_keeper_of_the_light_2")
end
function imba_light_radiant_bind:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	if target:TriggerStandardTargetSpell(self) then
		return
	end 
	caster:EmitSound("Hero_KeeperOfTheLight.ManaLeak.Cast")
	caster:EmitSound("Hero_KeeperOfTheLight.ManaLeak.Target")
	if caster:TG_HasTalent("special_bonus_imba_keeper_of_the_light_2") then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)				
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(caster,self,"modifier_imba_radiant_bind_debuff",{duration = duration})
		end
	else
		target:AddNewModifier(caster,self,"modifier_imba_radiant_bind_debuff",{duration = duration})	
	end
	
end



--debuff
modifier_imba_radiant_bind_debuff = class({})
LinkLuaModifier("modifier_imba_radiant_bind_debuff_flag", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_radiant_bind_debuff:IsDebuff() return true end
function modifier_imba_radiant_bind_debuff:IsPurgable() return not (self:GetParent():HasModifier("modifier_imba_light_blinding_light_debuff") and self.talant) end
function modifier_imba_radiant_bind_debuff:IsHidden() return false end
function modifier_imba_radiant_bind_debuff:GetEffectName() return "particles/units/heroes/hero_wisp/wisp_overcharge_b.vpcf" end
function modifier_imba_radiant_bind_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_radiant_bind_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,} end
function modifier_imba_radiant_bind_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.slow*self:GetStackCount()
end
function modifier_imba_radiant_bind_debuff:GetModifierMagicalResistanceBonus()
    return self.mag
end



function modifier_imba_radiant_bind_debuff:OnCreated()
	self.slow = self:GetAbility():GetSpecialValueFor("slow")*-1
	self.mag = self:GetAbility():GetSpecialValueFor("magic_resistance")*-1
	self.move_distance =  self:GetAbility():GetSpecialValueFor("move_distance")
	self.mana_cost = self:GetAbility():GetSpecialValueFor("mana_cost")*0.01
	self.talant = self:GetCaster():TG_HasTalent("special_bonus_imba_keeper_of_the_light_4")
	if IsServer() then
	self.pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_radiant_bind_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.pfx2, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.pfx2, 1, Vector(200,0,0 ))
	self:GetParent():EmitSound("Hero_KeeperOfTheLight.ManaLeak.Target.FP")
	self:AddParticle(self.pfx2, false, false, 15, false, false)	
	self:GetCaster():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_imba_radiant_bind_debuff_flag",{duration = self:GetRemainingTime()})
		self.pos = self:GetParent():GetAbsOrigin()
		self.distance = 0
		self:OnIntervalThink()
		self:StartIntervalThink(0.2)
	end
end
function modifier_imba_radiant_bind_debuff:OnIntervalThink()
	local new_pos = self:GetParent():GetAbsOrigin()
	local distance = (self.pos - new_pos):Length2D()
	self.distance = distance + self.distance
	self.pos = new_pos
	if self.distance >= 100 then 
		self.distance = self.distance - 100
		self:SetStackCount(self:GetStackCount() + 1)
	end
	if distance < self.move_distance then
		local mana = self:GetParent():GetMaxMana()*self.mana_cost
		self:GetParent():SpendMana(mana,self:GetAbility())
		self:GetCaster():GiveMana(mana)

				local damageTable = {
					victim 			= self:GetParent(),
					damage 			= mana,
					damage_type		= DAMAGE_TYPE_MAGICAL,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
					ability 		= self:GetAbility()
				}
				
				ApplyDamage(damageTable)
	end
end

function modifier_imba_radiant_bind_debuff:OnDestroy()
	if IsServer() then
	StopSoundEvent("Hero_KeeperOfTheLight.ManaLeak.Target.FP", self:GetParent())
	self:GetCaster():RemoveModifierByNameAndCaster("modifier_imba_radiant_bind_debuff_flag",self:GetParent())
	end
end

modifier_imba_radiant_bind_debuff_flag = class({})
function modifier_imba_radiant_bind_debuff_flag:IsDebuff() return false end
function modifier_imba_radiant_bind_debuff_flag:IsPurgable() return false end
function modifier_imba_radiant_bind_debuff_flag:IsHidden() return true end
function modifier_imba_radiant_bind_debuff_flag:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

--致盲之光
imba_light_blinding_light = class({})  
LinkLuaModifier("modifier_imba_light_blinding_light_debuff", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_light_blinding_light_fattus_dur", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_light_will_o_wisp_t_vision", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)

function imba_light_blinding_light:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function imba_light_blinding_light:OnSpellStart()
	self.caster = self:GetCaster()
	self.pos = self:GetCursorPosition()
	self.radius = self:GetSpecialValueFor("radius")
	self.duration = self:GetSpecialValueFor("duration")	
	self.stack = self:GetSpecialValueFor("stak")
	self.duration_wisp = self:GetSpecialValueFor("duration_wisp")
	self.damage = self:GetSpecialValueFor("damage")
	self.duration_t =  self.caster:TG_GetTalentValue("special_bonus_imba_keeper_of_the_light_6")
	self:light(self.pos)
	local hp = self.caster:GetMaxHealth()
	local mp = self.caster:GetMaxMana()
	local armor = self.caster:GetPhysicalArmorValue(false)
	local light = CreateUnitByName("npc_dota_ignis_fatuus", self.pos, true, self.caster, self.caster, self.caster:GetTeamNumber())
		  light:SetOwner(caster)
		  light:SetBaseMaxHealth(hp)
		  light:SetMaxHealth(hp)
		  light:SetHealth(hp)
		  light:SetPhysicalArmorBaseValue(armor)
		  light:SetMaximumGoldBounty(300)
		  light:SetMinimumGoldBounty(100)
		  light:AddNewModifier(self.caster, self, "modifier_imba_light_blinding_light_fattus_dur", {duration = self.duration_wisp})
		  if self.caster:TG_HasTalent("special_bonus_imba_keeper_of_the_light_8") then
			light:AddNewModifier(self.caster, self, "modifier_imba_light_will_o_wisp_t_vision", {duration = self.duration_wisp})
		  end
		  if self.caster:TG_HasTalent("special_bonus_imba_keeper_of_the_light_7") then
			light:AddNewModifier(self.caster, self, "modifier_item_gem_of_true_sight", {duration = self.duration_wisp})
		  end
		  
		  
	--target:AddNewModifier(caster,self,"modifier_imba_radiant_bind_debuff",{duration = self:GetSpecialValueFor("duration")})
end

function imba_light_blinding_light:light(position)
	if not IsServer() then return end

	-- Emit sound
	self.caster:EmitSound("Hero_KeeperOfTheLight.BlindingLight")
	
	local particle = ParticleManager:CreateParticle("particles/econ/items/keeper_of_the_light/kotl_ti10_immortal/kotl_ti10_blinding_light.vpcf", PATTACH_POINT_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(particle, 0, position)
	ParticleManager:SetParticleControl(particle, 1, position)
	ParticleManager:SetParticleControl(particle, 2, Vector(self.radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle)

	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), position, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for _, enemy in pairs(enemies) do		
		local mod = enemy:FindModifierByName("modifier_imba_radiant_bind_debuff") 
		if mod then
			mod:SetStackCount(mod:GetStackCount()+self.stack)
		end
		if self:GetCaster():TG_HasTalent("special_bonus_imba_keeper_of_the_light_6") then
			enemy:AddNewModifier(self.caster, self, "modifier_imba_stunned", {duration = self.duration_t})
		end
		enemy:AddNewModifier(self.caster, self, "modifier_imba_light_blinding_light_debuff", {duration = self.duration}) --miss
		local damageTable = {
					victim 			= enemy,
					damage 			= self.damage,
					damage_type		= DAMAGE_TYPE_MAGICAL,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self.caster,
					ability 		= self
				}
			ApplyDamage(damageTable)		
	end
end
modifier_imba_light_blinding_light_fattus_dur = class({})
LinkLuaModifier("modifier_imba_light_will_o_wisp_t_off", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_light_will_o_wisp_move", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_light_blinding_light_fattus_dur:IsDebuff() return false end
function modifier_imba_light_blinding_light_fattus_dur:IsPurgable() return false end
function modifier_imba_light_blinding_light_fattus_dur:IsPurgeException() return false end
function modifier_imba_light_blinding_light_fattus_dur:IsHidden() return false end
function modifier_imba_light_blinding_light_fattus_dur:CheckState() return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true} end
function modifier_imba_light_blinding_light_fattus_dur:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf"
end

function modifier_imba_light_blinding_light_fattus_dur:GetStatusEffectName()
	return "particles/status_fx/status_effect_keeper_spirit_form.vpcf"
end
function modifier_imba_light_blinding_light_fattus_dur:OnCreated()
	self.parent = self:GetParent()
	if IsServer() then
		self.particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling_on.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.particle2, 2, Vector(0, 0, 0))
		self:AddParticle(self.particle2, false, false, -1, false, false)
	end
end

function modifier_imba_light_blinding_light_fattus_dur:OnDestroy()
	if IsServer() then
		self.parent:ForceKill(false)
	end
end


modifier_imba_light_blinding_light_debuff = class({})
function modifier_imba_light_blinding_light_debuff:IsDebuff() return true end
function modifier_imba_light_blinding_light_debuff:IsPurgable() return not (self:GetParent():HasModifier("modifier_imba_radiant_bind_debuff") and self.talant)  end
function modifier_imba_light_blinding_light_debuff:IsHidden() return false end
function modifier_imba_light_blinding_light_debuff:GetPriority() return MODIFIER_PRIORITY_ULTRA  end
function modifier_imba_light_blinding_light_debuff:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf"
end

function modifier_imba_light_blinding_light_debuff:OnCreated()
	self.miss_rate = self:GetAbility():GetSpecialValueFor("miss_rate")
	self.talant = self:GetCaster():TG_HasTalent("special_bonus_imba_keeper_of_the_light_4")
end

function modifier_imba_light_blinding_light_debuff:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = false} end
function modifier_imba_light_blinding_light_debuff:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE
    }

    return decFuncs
end

function modifier_imba_light_blinding_light_debuff:GetModifierMiss_Percentage()
    return self.miss_rate
end
--变白
imba_light_spirit_form = class({})  

LinkLuaModifier("modifier_imba_light_spirit_form", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_light_spirit_form_passive", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
function imba_light_spirit_form:GetIntrinsicModifierName() return "modifier_imba_light_spirit_form_passive" end
function imba_light_spirit_form:Set_InitialUpgrade() 			
    return {LV=1} 
end
function imba_light_spirit_form:OnSpellStart()
	
end
function imba_light_spirit_form:OnToggle()
	
end

modifier_imba_light_spirit_form = class({})
function modifier_imba_light_spirit_form:IsDebuff() return false end
function modifier_imba_light_spirit_form:IsPurgable() return true end
function modifier_imba_light_spirit_form:IsHidden() return false end
function modifier_imba_light_spirit_form:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL} end
function modifier_imba_light_spirit_form:GetModifierMagicalResistanceDecrepifyUnique( params )
	return self.mag
end
function modifier_imba_light_spirit_form:GetAbsoluteNoDamagePhysical()
	if self:GetCaster() == self:GetParent() then return 1
	else return nil end
end
function modifier_imba_light_spirit_form:CheckState()
	return
		{
			[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		}
end
function modifier_imba_light_spirit_form:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf"
end

function modifier_imba_light_spirit_form:GetModifierMoveSpeedBonus_Percentage() return self.move end

function modifier_imba_light_spirit_form:GetStatusEffectName()
	return "particles/econ/courier/courier_greevil_white/courier_greevil_white_ambient_3.vpcf"
end
function modifier_imba_light_spirit_form:OnCreated()
	self.move = self:GetAbility():GetSpecialValueFor("move_speed")
	self.mag = self:GetAbility():GetSpecialValueFor("magic")*-1
	if IsServer() then
		self:GetParent():EmitSound("Hero_KeeperOfTheLight.SpiritForm")
	end
end
		
function modifier_imba_light_spirit_form:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_keeper_of_the_light_spirit_form")
		if self:GetRemainingTime() > 0 then
			self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor("cd"))
		end
	end
end
modifier_imba_light_spirit_form_passive = class({})
LinkLuaModifier("modifier_imba_light_spirit_form", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_light_spirit_form_passive:IsDebuff() return false end
function modifier_imba_light_spirit_form_passive:IsPurgable() return false end
function modifier_imba_light_spirit_form_passive:IsPurgeException() return false end
function modifier_imba_light_spirit_form_passive:IsHidden() return true end
function modifier_imba_light_spirit_form_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_imba_light_spirit_form_passive:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() or self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() then 
		return 
	end
	if self:GetParent():GetUnitName() == "npc_dota_hero_morphling" then
		return
	end
	if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
		return 
	end 
	if self:GetAbility():GetCooldownTimeRemaining() == 0 and self:GetAbility():GetToggleState() then
		self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_imba_light_spirit_form",{duration = self:GetAbility():GetSpecialValueFor("duration")})
		self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_keeper_of_the_light_spirit_form",{duration = self:GetAbility():GetSpecialValueFor("duration")})
	end
end
--灵光
imba_light_will_o_wisp = class({})  
LinkLuaModifier("modifier_imba_light_will_o_wisp_t", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_light_will_o_wisp_move", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_light_will_o_wisp_t_off", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_light_will_o_wisp_t_on", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)

function imba_light_will_o_wisp:OnSpellStart()
	local pos = self:GetCursorPosition()
	local caster = self:GetCaster()
	
	local on_count				= self:GetSpecialValueFor("on_count")
	local off_duration			= self:GetSpecialValueFor("off_duration")
	local on_duration			= self:GetSpecialValueFor("on_duration")
	local hit_count				= self:GetSpecialValueFor("hit_count")

	-- Calculate total duration that the wisp will be present for using on and off durations
	-- The initial off duration + total amount of time it's on + total amount of time it's off minus one instace
	local duration = (on_duration * on_count) + (off_duration * (on_count - 1))

	local light = CreateUnitByName("npc_dota_ignis_fatuus", pos, true, caster, caster, caster:GetTeamNumber())
	if caster:TG_HasTalent("special_bonus_imba_keeper_of_the_light_8") then
		light:AddNewModifier(caster, self, "modifier_imba_light_will_o_wisp_t_vision", {duration = duration+10})
	end
	if caster:TG_HasTalent("special_bonus_imba_keeper_of_the_light_7") then
		light:AddNewModifier(caster, self, "modifier_item_gem_of_true_sight", {duration = duration+10})
	end
	local mod = light:AddNewModifier(caster,self,"modifier_imba_light_will_o_wisp_t",{duration = duration+10})	
		  light:SetOwner(caster)
		  light:SetBaseMaxHealth(hit_count)
		  light:SetMaxHealth(hit_count)
		  light:SetHealth(hit_count)
		  light:SetMaximumGoldBounty(300)
		  light:SetMinimumGoldBounty(300)
	light:AddNewModifier(caster,self,"modifier_imba_light_will_o_wisp_t_on",{duration = on_duration})	
	if mod then
		mod:SetStackCount(on_count)
	end
	

end

modifier_imba_light_will_o_wisp_t = class({})

function modifier_imba_light_will_o_wisp_t:IsDebuff() return false end
function modifier_imba_light_will_o_wisp_t:IsPurgable() return false end
function modifier_imba_light_will_o_wisp_t:IsHidden() return false end
function modifier_imba_light_will_o_wisp_t:DeclareFunctions() 
    return 
    {    
		MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, 
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, 
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE, 
        MODIFIER_PROPERTY_DISABLE_HEALING, 
    } 
end
function modifier_imba_light_will_o_wisp_t:OnAttackLanded(keys)
    if not IsServer() then
        return
	end  
    if  keys.target == self:GetParent() and keys.attacker:IsRealHero() then
        if self:GetParent():GetHealth()>0 then
        self:GetParent():SetHealth(self:GetParent():GetHealth() - 1) 
        elseif self:GetParent():GetHealth()<=0 then
        self:GetParent():RemoveModifierByName("modifier_imba_light_will_o_wisp_t")
        end
    end
end
function modifier_imba_light_will_o_wisp_t:GetDisableHealing() 
    return 1 
end

function modifier_imba_light_will_o_wisp_t:GetAbsoluteNoDamageMagical() 
    return 1 
end

function modifier_imba_light_will_o_wisp_t:GetAbsoluteNoDamagePhysical() 
    return 1 
end

function modifier_imba_light_will_o_wisp_t:GetAbsoluteNoDamagePure() 
    return 1 
end

function modifier_imba_light_will_o_wisp_t:OnCreated()
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	
	if IsServer() then
	self.parent:EmitSound("Hero_KeeperOfTheLight.Wisp.Cast")
	self.parent:EmitSound("Hero_KeeperOfTheLight.Wisp.Spawn")
	self.parent:EmitSound("Hero_KeeperOfTheLight.Wisp.Aura")
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius, 1, 1))
	ParticleManager:SetParticleControl(self.particle, 2, Vector(0, 0, 0))
	self:AddParticle(self.particle, false, false, -1, false, false)
	
	self.particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling_on.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle2, 2, Vector(0, 0, 0))
	self:AddParticle(self.particle2, false, false, -1, false, false)
	
	-- Destroy trees around cast point
	GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.radius, true )

	end
end

function modifier_imba_light_will_o_wisp_t:OnDestroy()
	if not IsServer() then return end
	
	self.parent:EmitSound("Hero_KeeperOfTheLight.Wisp.Destroy")
	self.parent:StopSound("Hero_KeeperOfTheLight.Wisp.Aura")
	
	
	if not self.parent:HasModifier("modifier_imba_light_blinding_light_fattus_dur") then
		self.parent:ForceKill(false)
	end
end

modifier_imba_light_will_o_wisp_t_on = class({})
LinkLuaModifier("modifier_imba_light_will_o_wisp_t_off", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_light_will_o_wisp_move", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_light_will_o_wisp_t_on_in", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_light_will_o_wisp_t_on:IsDebuff() return false end
function modifier_imba_light_will_o_wisp_t_on:IsPurgable() return false end
function modifier_imba_light_will_o_wisp_t_on:IsPurgeException() return false end
function modifier_imba_light_will_o_wisp_t_on:IsHidden() return true end
function modifier_imba_light_will_o_wisp_t_on:IsAura() 
    return true
end

function modifier_imba_light_will_o_wisp_t_on:GetModifierAura() 
    return "modifier_imba_light_will_o_wisp_t_on_in" 
end

function modifier_imba_light_will_o_wisp_t_on:GetAuraDuration() 
    return 0
end

function modifier_imba_light_will_o_wisp_t_on:GetAuraRadius() 
    return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_imba_light_will_o_wisp_t_on:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_light_will_o_wisp_t_on:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_imba_light_will_o_wisp_t_on:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
end
function modifier_imba_light_will_o_wisp_t_on:OnCreated(keys)
	self.duration_off = self:GetAbility():GetSpecialValueFor("off_duration")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	if IsServer() then
		self.parent = self:GetParent()
		self.parent:EmitSound("Hero_KeeperOfTheLight.Wisp.Active")
		self.mod_pfx = self:GetParent():FindModifierByName("modifier_imba_light_will_o_wisp_t")
		if self.mod_pfx then
			ParticleManager:SetParticleControl(self.mod_pfx.particle, 2, Vector(1, 0, 0))
			ParticleManager:SetParticleControl(self.mod_pfx.particle2, 2, Vector(1, 0, 0))
		end
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())
	end
	
end
function modifier_imba_light_will_o_wisp_t_on:OnIntervalThink()
	if IsServer() then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			
			for _, enemy in pairs(enemies) do
				if not enemy:HasModifier("modifier_imba_light_will_o_wisp_move") then
					enemy:AddNewModifier(self.parent, self:GetAbility(), "modifier_imba_light_will_o_wisp_move", {duration = self:GetRemainingTime()})
				end
				
				enemy:FaceTowards(self.parent:GetAbsOrigin())
			end
	end
end
function modifier_imba_light_will_o_wisp_t_on:OnDestroy()
	if IsServer() then
	if self.parent:IsAlive() then
		if self.mod_pfx  then
			if self.mod_pfx:GetStackCount() == 1 then
				self.parent:RemoveModifierByName("modifier_imba_light_will_o_wisp_t")
				return
			end
			self.parent:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_light_will_o_wisp_t_off",{duration = self.duration_off})
			self.mod_pfx:SetStackCount(self.mod_pfx:GetStackCount()-1)
		end
	end
	end
end
--隐身
modifier_imba_light_will_o_wisp_t_on_in = class({})
function modifier_imba_light_will_o_wisp_t_on_in:IsDebuff() return false end
function modifier_imba_light_will_o_wisp_t_on_in:IsPurgable() return false end
function modifier_imba_light_will_o_wisp_t_on_in:IsPurgeException() return false end
function modifier_imba_light_will_o_wisp_t_on_in:IsHidden() return false end

function modifier_imba_light_will_o_wisp_t_on_in:DeclareFunctions() return {MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end
function modifier_imba_light_will_o_wisp_t_on_in:CheckState()
	return {[MODIFIER_STATE_INVISIBLE] = (self:GetParent():GetUnitName() ~= "npc_dota_ignis_fatuus"), [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
end
function modifier_imba_light_will_o_wisp_t_on_in:GetModifierInvisibilityLevel() 
	return 1
end

--熄灭
modifier_imba_light_will_o_wisp_t_off = class({})
LinkLuaModifier("modifier_imba_light_will_o_wisp_t_on", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_light_will_o_wisp_t_off:IsDebuff() return false end
function modifier_imba_light_will_o_wisp_t_off:IsPurgable() return false end
function modifier_imba_light_will_o_wisp_t_off:IsPurgeException() return false end
function modifier_imba_light_will_o_wisp_t_off:IsHidden() return true end
function modifier_imba_light_will_o_wisp_t_off:DeclareFunctions() return {MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end
function modifier_imba_light_will_o_wisp_t_off:CheckState()
	return { [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
end
function modifier_imba_light_will_o_wisp_t_off:OnCreated()
	self.duration_on = self:GetAbility():GetSpecialValueFor("on_duration")
	self.parent = self:GetParent()
	if IsServer() then
		self.mod_pfx = self:GetParent():FindModifierByName("modifier_imba_light_will_o_wisp_t")
		if self.mod_pfx then
			ParticleManager:SetParticleControl(self.mod_pfx.particle, 2, Vector(0, 0, 0))
			ParticleManager:SetParticleControl(self.mod_pfx.particle2, 2, Vector(0, 0, 0))
		end
	end
end

function modifier_imba_light_will_o_wisp_t_off:OnDestroy()
	if IsServer() then
		if self.mod_pfx and self.parent then
			self.parent:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_light_will_o_wisp_t_on",{duration = self.duration_on})
		end
	end
end

modifier_imba_light_will_o_wisp_move = class({})

function modifier_imba_light_will_o_wisp_move:IsDebuff()			return true end
function modifier_imba_light_will_o_wisp_move:IsHidden() 			return false end
function modifier_imba_light_will_o_wisp_move:IsPurgable() 		return false end
function modifier_imba_light_will_o_wisp_move:IsPurgeException() 	return false end
function modifier_imba_light_will_o_wisp_move:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling_debuff.vpcf"
end
function modifier_imba_light_will_o_wisp_move:GetStatusEffectName()
	return "particles/status_fx/status_effect_keeper_dazzle.vpcf"
end
function modifier_imba_light_will_o_wisp_move:CheckState() return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_FROZEN] = true} end
function modifier_imba_light_will_o_wisp_move:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		self.direction = TG_Direction(self.caster:GetAbsOrigin(), self.parent:GetAbsOrigin())
		self.destination = 80
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_light_will_o_wisp_move:OnIntervalThink()
	if IsServer() then
		if self.caster and self.parent then
			local distance = self.destination / (1.0 / FrameTime())
			local next_pos = GetGroundPosition(self.parent:GetAbsOrigin() + self.direction * distance, self.parent)
				self.parent:SetForwardVector(self.direction)
				self.parent:SetOrigin(next_pos)
		end
	end
end

function modifier_imba_light_will_o_wisp_move:OnDestroy()
	if IsServer() then
		GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), 200, false)
		FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
	end
end
--天赋降低视野
modifier_imba_light_will_o_wisp_t_vision = class({})
LinkLuaModifier("modifier_imba_light_will_o_wisp_t_vision_debuff", "ting/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_light_will_o_wisp_t_vision:IsDebuff() return false end
function modifier_imba_light_will_o_wisp_t_vision:IsPurgable() return false end
function modifier_imba_light_will_o_wisp_t_vision:IsPurgeException() return false end
function modifier_imba_light_will_o_wisp_t_vision:IsHidden() return true end

function modifier_imba_light_will_o_wisp_t_vision:IsAura() 
    return true
end

function modifier_imba_light_will_o_wisp_t_vision:GetModifierAura() 
    return "modifier_imba_light_will_o_wisp_t_vision_debuff" 
end

function modifier_imba_light_will_o_wisp_t_vision:GetAuraDuration() 
    return 0
end

function modifier_imba_light_will_o_wisp_t_vision:GetAuraRadius() 
    return self:GetCaster():TG_GetTalentValue("special_bonus_imba_keeper_of_the_light_8")
end

function modifier_imba_light_will_o_wisp_t_vision:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_light_will_o_wisp_t_vision:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_light_will_o_wisp_t_vision:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_light_will_o_wisp_t_vision:OnCreated()

	self.parent = self:GetParent()
	if IsServer() then

	end
end

function modifier_imba_light_will_o_wisp_t_vision:OnDestroy()
	if IsServer() then

	end
end

modifier_imba_light_will_o_wisp_t_vision_debuff = class({})
function modifier_imba_light_will_o_wisp_t_vision_debuff:IsDebuff() return true end
function modifier_imba_light_will_o_wisp_t_vision_debuff:IsPurgable() return false end
function modifier_imba_light_will_o_wisp_t_vision_debuff:IsPurgeException() return false end
function modifier_imba_light_will_o_wisp_t_vision_debuff:IsHidden() return false end

function modifier_imba_light_will_o_wisp_t_vision_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE} end
function modifier_imba_light_will_o_wisp_t_vision_debuff:GetBonusVisionPercentage() return -80 end
