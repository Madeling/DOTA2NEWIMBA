--2021 01 13 by MysticBug-------
--------------------------------
--------------------------------
--------------------------------------------------------------
--		   		 IMBA_RIKI_BLINK_STRIKE               	    --
--------------------------------------------------------------

imba_riki_blink_strike = class({})
LinkLuaModifier("modifier_imba_riki_back_to_back", "mb/hero_riki/riki_blink_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_riki_blink_strike_illusion", "mb/hero_riki/riki_blink_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_riki_blink_strike_mark", "mb/hero_riki/riki_blink_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_riki_blink_strike_crit", "mb/hero_riki/riki_blink_strike", LUA_MODIFIER_MOTION_NONE)

function imba_riki_blink_strike:IsHiddenWhenStolen() 	return false end
function imba_riki_blink_strike:IsRefreshable() 		return true end
function imba_riki_blink_strike:IsStealable() 			return true end
function imba_riki_blink_strike:IsNetherWardStealable()	return false end
--[[function imba_riki_blink_strike:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_riki_3")
end]]
function imba_riki_blink_strike:GetCooldown(iLevel)	
	return self.BaseClass.GetCooldown(self, iLevel) + self:GetCaster():TG_GetTalentValue("special_bonus_imba_riki_3")
end

function imba_riki_blink_strike:CastFilterResultTarget(target)
	if target:IsInvulnerable() then
		return UF_FAIL_INVULNERABLE
	end
	if target == self:GetCaster() or target:IsOther() or target:IsCourier() or target:IsBuilding() then
		return UF_FAIL_CUSTOM
	end
end

function imba_riki_blink_strike:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	else
		return "#dota_hud_error_cant_cast_on_other"
	end
end

function imba_riki_blink_strike:GetAbilityTextureName()	
	if self:GetCaster():HasModifier("modifier_imba_riki_mode_switch") then  
		local mode_type = self:GetCaster():GetModifierStackCount("modifier_imba_riki_mode_switch", nil) or 1
		--返回对应技能图标
		return "riki/riki_blink_strike"..mode_type
	else
		return "riki/riki_blink_strike1"
	end 
end

function imba_riki_blink_strike:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold_start.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_riki.vsndevts", context )
end
function imba_riki_blink_strike:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerStandardTargetSpell(self) then
		return
	end
	--KV
	local bonus_damage = self:GetSpecialValueFor("bonus_damage")
	local startpos = caster:GetAbsOrigin()
	local endpos = target:GetAbsOrigin() + (target:GetForwardVector() * -1) * 100
	local poisoned_radius = self:GetSpecialValueFor("poisoned_radius") + caster:TG_GetTalentValue("special_bonus_imba_riki_6","value_radius")
	--IMBA
	local illusion_duration = self:GetSpecialValueFor("illusion_duration")
	local images_do_damage_percent = 0
	local images_take_damage_percent = 20
	local modifier = caster:FindModifierByNameAndCaster("modifier_imba_riki_mode_switch", caster)
	local modifier_illusions =
	{
	    outgoing_damage=images_do_damage_percent - 100,
	    incoming_damage=images_take_damage_percent - 100,
	    bounty_base=0,
	    bounty_growth=0,
	    outgoing_damage_structure=0,
	    outgoing_damage_roshan=0,
	}
	--创建幻象
	caster.illusions = CreateIllusions(caster, caster, modifier_illusions, 1, 0, false, false)
	for i=1, #caster.illusions do
		FindClearSpaceForUnit(caster.illusions[i], caster:GetAbsOrigin(), true)
		caster.illusions[i]:SetForwardVector(TG_Direction(target:GetAbsOrigin(),caster.illusions[i]:GetAbsOrigin()))
		caster.illusions[i]:AddNewModifier(caster, self, "modifier_kill", {duration = illusion_duration})
		caster.illusions[i]:AddNewModifier(caster, self, "modifier_phased", {duration = illusion_duration})
		caster.illusions[i]:AddNewModifier(caster, self, "modifier_imba_riki_blink_strike_illusion", {duration = illusion_duration})
	end
	--Particle
	--local pfx_name1 = "particles/units/heroes/hero_riki/riki_blink_strike_start.vpcf"
	--local pfx_name2 = "particles/units/heroes/hero_riki/riki_blink_strike.vpcf"
	local pfx_name1 = "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold_start.vpcf"
	local pfx_name2 = "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold.vpcf"

	local pfx2 = ParticleManager:CreateParticle(pfx_name2, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, startpos)  --start
	ParticleManager:SetParticleControl(pfx2, 1, endpos) --endpos
	ParticleManager:DestroyParticle(pfx2, false)
	ParticleManager:ReleaseParticleIndex(pfx2)
	--Move
	FindClearSpaceForUnit(caster, endpos, true)
	--Hero_Riki.Blink_Strike.Immortal Hero_Riki.Blink_Strike
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Riki.Blink_Strike.Immortal", caster)
	--IMBA 1
	if modifier == nil or modifier:GetStackCount() == 1 then
		--IMBA attack line enemies
		local enemies = FindUnitsInLine(
				self:GetCaster():GetTeamNumber(),
				startpos,
				endpos,										
				nil,
				caster:Script_GetAttackRange(),  --riki attack range with
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
			)
		for _,enemy in pairs(enemies) do 
			if caster:HasModifier("modifier_item_monkey_king_bar_v2_pa") and not caster:HasModifier("modifier_item_butterfly_v2_buff") then 
				caster:PerformAttack(enemy, false, true, true, false, true, false, true)
			else
				caster:PerformAttack(enemy, false, true, true, false, true, false, false)
			end
		end
		--Talent 6
		if caster:TG_HasTalent("special_bonus_imba_riki_6") then 
			target:AddNewModifier(caster,self,"modifier_imba_riki_back_to_back",{duration = self:GetSpecialValueFor("back_duration")})
		end	
		
	end
	--IMBA 2
	if modifier ~=nil and modifier:GetStackCount() == 2 then 
		if caster:TG_HasTalent("special_bonus_imba_riki_6") then 
			caster:AddNewModifier(caster, self, "modifier_rune_super_invis", {duration = self:GetSpecialValueFor("back_duration")})
		end
	end
	--IMBA 3
	if modifier ~=nil and modifier:GetStackCount() == 3 then 
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),
			target:GetAbsOrigin(),
			nil,
			poisoned_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)
		local damage_table = ({
					--victim = enemy,
					attacker = caster,
					ability = self,
					damage = bonus_damage,
					damage_type = DAMAGE_TYPE_MAGICAL
				})
		for _,enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
				damage_table.victim = enemy
				--造成伤害
				ApplyDamage(damage_table)
				--毒伤
				if caster:HasModifier("modifier_imba_riki_backstab_passive") then 
					caster:FindModifierByNameAndCaster("modifier_imba_riki_backstab_passive",caster):Poisoned_BonusDamage(enemy:entindex())
				end	
			end
		end
		--pfx
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_shard_fan_of_knives.vpcf", PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(particle, 62, Vector(1, 255, 255))
		ParticleManager:ReleaseParticleIndex(particle)
	end

	--Apply Damage
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		Timers:CreateTimer(0.03, function()
			caster:SetForceAttackTarget(nil)
		end)
		ApplyDamage({victim = target, attacker = caster, damage = bonus_damage, damage_type = self:GetAbilityDamageType()})
		--add debuff
		if modifier ~=nil and modifier:GetStackCount() == 2 then 
			caster:AddNewModifier(caster, self, "modifier_imba_riki_blink_strike_crit", {})
			caster:PerformAttack(target, false, true, true, false, true, false, true)
			caster:RemoveModifierByName("modifier_imba_riki_blink_strike_crit")
		end 
		-- Order the caster to attack the target
		caster:MoveToTargetToAttack(target)
	end
end

--------------------------------------------------------------
--		       MODIFIER_IMBA_RIKI_BACK_TO_BACK     	        --
--------------------------------------------------------------
modifier_imba_riki_back_to_back = class({})
function modifier_imba_riki_back_to_back:IsDebuff() return true end
function modifier_imba_riki_back_to_back:IsHidden() return false end
function modifier_imba_riki_back_to_back:IsPurgable() return false end
function modifier_imba_riki_back_to_back:DeclareFunctions() return {MODIFIER_PROPERTY_DISABLE_TURNING,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_imba_riki_back_to_back:GetModifierDisableTurning()	return 1 end
function modifier_imba_riki_back_to_back:GetModifierMoveSpeedBonus_Percentage()	return -self:GetAbility():GetSpecialValueFor("movement_slow") end

--------------------------------------------------------------
--		MODIFIER_IMBA_RIKI_BLINK_STRIKE_ILLUSION     	    --
--------------------------------------------------------------
modifier_imba_riki_blink_strike_illusion = class({})
function modifier_imba_riki_blink_strike_illusion:IsDebuff()				return false end
function modifier_imba_riki_blink_strike_illusion:IsHidden() 			return true end
function modifier_imba_riki_blink_strike_illusion:IsPurgable() 			return false end
function modifier_imba_riki_blink_strike_illusion:IsPurgeException() 	return false end
function modifier_imba_riki_blink_strike_illusion:GetStatusEffectName() return "particles/status_fx/status_effect_building_placement_good.vpcf" end
function modifier_imba_riki_blink_strike_illusion:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA + 16 end
function modifier_imba_riki_blink_strike_illusion:CheckState()
	return 
		{
		[MODIFIER_STATE_COMMAND_RESTRICTED]	= true,
		[MODIFIER_STATE_ROOTED]	= true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP]	= true,
		[MODIFIER_STATE_INVISIBLE] = true
		}
end
function modifier_imba_riki_blink_strike_illusion:DeclareFunctions() 	return {MODIFIER_EVENT_ON_ORDER} end
function modifier_imba_riki_blink_strike_illusion:OnOrder( params )
	if params.unit~=self:GetCaster() or params.target~=self:GetParent() then return end
	-- right click, switch position 
	if	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetValidTarget( params.target:GetOrigin() )
	end
end

function modifier_imba_riki_blink_strike_illusion:SetValidTarget( location )
	--switch location
	local caster_location = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetUpVector() * 50
	self:GetCaster():SetAbsOrigin(location)
	FindClearSpaceForUnit(self:GetParent(), caster_location, false)
	EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Hero_Riki.Blink_Strike.Immortal", self:GetCaster())
	self:Destroy()
	self:GetParent():RemoveSelf()
end

--------------------------------------------------------------
--		modifier_imba_riki_blink_strike_mark     	    --
--------------------------------------------------------------
modifier_imba_riki_blink_strike_mark = class({})
function modifier_imba_riki_blink_strike_mark:IsDebuff()			return false end
function modifier_imba_riki_blink_strike_mark:IsHidden() 			return true end
function modifier_imba_riki_blink_strike_mark:IsPurgable() 			return false end
function modifier_imba_riki_blink_strike_mark:IsPurgeException() 	return false end
function modifier_imba_riki_blink_strike_mark:GetStatusEffectName() return "particles/status_fx/status_effect_building_placement_good.vpcf" end
function modifier_imba_riki_blink_strike_mark:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA + 16 end
function modifier_imba_riki_blink_strike_mark:DeclareFunctions() 	return {MODIFIER_EVENT_ON_ORDER} end
function modifier_imba_riki_blink_strike_mark:OnCreated()
	if IsServer() then 
	 	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/planeshift/void_spirit_planeshift_active_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    	ParticleManager:SetParticleControl(self.particle, 1, Vector(self:GetRemainingTime(),1,1))
    	self:AddParticle(self.particle, false, false, 15, false, true)
    end
end
function modifier_imba_riki_blink_strike_mark:OnRefresh()
	if IsServer() then
		ParticleManager:SetParticleControl(self.particle, 1, Vector(self:GetRemainingTime(),1,1))
	end
end
function modifier_imba_riki_blink_strike_mark:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
end
function modifier_imba_riki_blink_strike_mark:OnOrder( params )
	if params.unit~=self:GetCaster() or params.target~=self:GetParent() then return end
	-- right click, switch position 
	if	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetValidTarget( params.target:GetOrigin() )
	end
end

function modifier_imba_riki_blink_strike_mark:SetValidTarget( location )
	--switch location
	FindClearSpaceForUnit(self:GetCaster(), location, false)
	EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Hero_Riki.Blink_Strike.Immortal", self:GetCaster())
	self:Destroy()
end

--------------------------------------------------------------
--			MODIFIER_IMBA_RIKI_BLINK_STRIKE_CRIT     	    --
--------------------------------------------------------------
modifier_imba_riki_blink_strike_crit = class({})
function modifier_imba_riki_blink_strike_crit:IsDebuff()			return false end
function modifier_imba_riki_blink_strike_crit:IsHidden() 			return true end
function modifier_imba_riki_blink_strike_crit:IsPurgable() 			return false end
function modifier_imba_riki_blink_strike_crit:IsPurgeException() 	return false end
function modifier_imba_riki_blink_strike_crit:OnCreated() 
    self.strike_crit_mult=self:GetAbility():GetSpecialValueFor("strike_crit_mult")
end
function modifier_imba_riki_blink_strike_crit:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
end

function modifier_imba_riki_blink_strike_crit:GetModifierPreAttack_CriticalStrike() return  self.strike_crit_mult or 0 end