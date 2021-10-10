--------------------------------------------------------------
--		   	   IMBA_FACELESS_VOID_CHRONOSPHERE              --
--------------------------------------------------------------
imba_faceless_void_chronosphere = class({})

LinkLuaModifier("modifier_imba_faceless_void_chronosphere_stamps", "mb/hero_faceless_void/faceless_void_chronosphere", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_faceless_void_chronosphere_thinker", "mb/hero_faceless_void/faceless_void_chronosphere", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_faceless_void_chronosphere_debuff", "mb/hero_faceless_void/faceless_void_chronosphere", LUA_MODIFIER_MOTION_NONE)

function imba_faceless_void_chronosphere:IsHiddenWhenStolen() 		return false end
function imba_faceless_void_chronosphere:IsRefreshable() 			return true  end
function imba_faceless_void_chronosphere:IsStealable() 				return true  end
function imba_faceless_void_chronosphere:IsNetherWardStealable() 	return true end
--时间戳记
function imba_faceless_void_chronosphere:GetIntrinsicModifierName() return "modifier_imba_faceless_void_chronosphere_stamps" end
function imba_faceless_void_chronosphere:GetAOERadius() return self:GetSpecialValueFor("base_radius") + math.min(self:GetCaster():GetModifierStackCount("modifier_imba_faceless_void_chronosphere_stamps", self:GetCaster()), self:GetSpecialValueFor("max_radius_stack")) * self:GetSpecialValueFor("extra_radius") end
function imba_faceless_void_chronosphere:GetAbilityTextureName()	return "faceless_void/maceofaeons/faceless_void_chronosphere" end
function imba_faceless_void_chronosphere:OnSpellStart()
	local caster = self:GetCaster()
	local pos    = self:GetCursorPosition()
	local radius = self:GetAOERadius()
	--caster:SpendMana(caster:GetMana(), self)
	local time = self:GetSpecialValueFor("base_duration")
	if math.random(0,49) == math.random(0,49) then
		time = 1.9
		--EmitGlobalSound("Imba.FacelessZaWarudo")
		caster:EmitSound("Imba.FacelessZaWarudo")
		caster:SetContextThink(DoUniqueString("DIO"),
									function()
										CreateChronosphere(caster, self, pos, 3000, 9, 1)
										return nil
									end,1.8)
	end
	local thinker = CreateChronosphere(caster, self, pos, radius, time, 1)

	thinker:EmitSound("Hero_FacelessVoid.Chronosphere.MaceOfAeons")
	--天赋
	if caster:TG_HasTalent("special_bonus_imba_faceless_void_1") then
		caster:GiveMana(caster:TG_GetTalentValue("special_bonus_imba_faceless_void_1"))
	end
	--Add time stamps
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

	caster:SetModifierStackCount("modifier_imba_faceless_void_chronosphere_stamps", nil, caster:GetModifierStackCount("modifier_imba_faceless_void_chronosphere_stamps", nil) + TableLength(enemies))
	--Use Mana
	caster:SetMana(100)
end

function CreateChronosphere(caster, ability, position, radius, duration, ally_behavior)
	-- Ally Behavior: 1 = Stun Allies, 2 = DO NOT EFFECT Allies, 4 = DO NOT EFFECT SPELL IMMUNE Enemies ////  add them up
	ially_behavior = ally_behavior or 1
	local thinker = CreateModifierThinker(caster, ability, "modifier_imba_faceless_void_chronosphere_thinker", {duration = duration, radius = radius, ally_behavior = ially_behavior}, position, caster:GetTeamNumber(), false)
	return thinker
end
--------------------------------------------------------------
modifier_imba_faceless_void_chronosphere_stamps = class({})

function modifier_imba_faceless_void_chronosphere_stamps:IsDebuff()				return false end
function modifier_imba_faceless_void_chronosphere_stamps:IsHidden() 			return false end
function modifier_imba_faceless_void_chronosphere_stamps:IsPurgable() 			return false end
function modifier_imba_faceless_void_chronosphere_stamps:IsPurgeException() 	return false end

--------------------------------------------------------------
modifier_imba_faceless_void_chronosphere_thinker = class({})

function modifier_imba_faceless_void_chronosphere_thinker:OnCreated(keys)
	if IsServer() then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), keys.radius, self:GetDuration(), false)
		self.radius = keys.radius
		self.ally_behavior = keys.ally_behavior
		local pfx_name = "particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf"
		if self.radius < 3000 then
			pfx_name = "particles/econ/items/faceless_void/faceless_void_mace_of_aeons/fv_chronosphere_aeons.vpcf"
		end
		local id=tonumber(tostring(PlayerResource:GetSteamID(self:GetCaster():GetPlayerOwnerID())))
		if (self:GetCaster():GetName()=="npc_dota_hero_rubick" or id == 76561198054050405 ) and self.radius < 3000 then 
			pfx_name = "particles/units/heroes/hero_rubick/rubick_faceless_void_chronosphere.vpcf"
		end
		if (id== 76561198361355161 or id ==76561198100269546 ) and self.radius < 3000 then 
			pfx_name = "particles/face/mace_of_aeons_ult/red/fv_chronosphere_aeons_red.vpcf" --laojiezhuanshu
		end
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(pfx, false, false, 16, false, false)
	end
end

function modifier_imba_faceless_void_chronosphere_thinker:IsAura() return true end
function modifier_imba_faceless_void_chronosphere_thinker:GetAuraDuration() return 0.1 end
function modifier_imba_faceless_void_chronosphere_thinker:GetModifierAura() return "modifier_imba_faceless_void_chronosphere_debuff" end
function modifier_imba_faceless_void_chronosphere_thinker:GetAuraRadius() return self.radius end
function modifier_imba_faceless_void_chronosphere_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_faceless_void_chronosphere_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_imba_faceless_void_chronosphere_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_faceless_void_chronosphere_thinker:GetAuraEntityReject(unit)
	if bit.band(self.ally_behavior, 4) == 4 and unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and unit:IsMagicImmune() then
		return true
	end
	if bit.band(self.ally_behavior, 2) == 2 and unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return true
	end
	if unit:IsInvulnerable() and unit:IsHero() then
		return true
	end
end

modifier_imba_faceless_void_chronosphere_debuff = class({})

--Chronosphere Parent Type
Chronosphere_Caster = 1
Chronosphere_Ally = 2
Chronosphere_Ally_Scepter = 3
Chronosphere_Enemy = 4
Chronosphere_Enemy_Ability = 5

function modifier_imba_faceless_void_chronosphere_debuff:OnCreated()
	self.buff_type = 0
	if self:GetParent():GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID()then
		self.buff_type = Chronosphere_Caster
	elseif self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and not self:GetCaster():HasScepter() then
		self.buff_type = Chronosphere_Ally
	elseif self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and self:GetCaster():HasScepter() then
		self.buff_type = Chronosphere_Ally_Scepter
	elseif self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and not self:GetParent():HasModifier("modifier_imba_faceless_void_chronosphere_stamps") then
		self.buff_type = Chronosphere_Enemy
	elseif self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetParent():HasModifier("modifier_imba_faceless_void_chronosphere_stamps") then
		self.buff_type = Chronosphere_Enemy_Ability
	else
		self.buff_type = Chronosphere_Enemy
	end
	self.ms = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false) * (1 - (self:GetAbility():GetSpecialValueFor("slow_scepter") / 100))
	if IsServer() and self:IsMotionController() then
		self:GetParent():InterruptMotionControllers(false)
		self.abs = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_faceless_void_chronosphere_debuff:OnIntervalThink()
	self:CheckMotionControllers()
	self:GetParent():InterruptMotionControllers(false)
	self:GetParent():SetOrigin(self.abs)
end

function modifier_imba_faceless_void_chronosphere_debuff:OnDestroy()
	if IsServer() and self:IsMotionController() then
		self.abs = nil
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
	end
	self.buff_type = nil
end

function modifier_imba_faceless_void_chronosphere_debuff:IsHidden() 			return false end
function modifier_imba_faceless_void_chronosphere_debuff:IsPurgable() 			return false end
function modifier_imba_faceless_void_chronosphere_debuff:IsPurgeException() 	return false end
function modifier_imba_faceless_void_chronosphere_debuff:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_imba_faceless_void_chronosphere_debuff:IsDebuff() return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Enemy_Ability) end
function modifier_imba_faceless_void_chronosphere_debuff:IsStunDebuff()	return self:IsDebuff() end
function modifier_imba_faceless_void_chronosphere_debuff:IsMotionController() return not (self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Ally_Scepter or self.buff_type == Chronosphere_Enemy_Ability) end
function modifier_imba_faceless_void_chronosphere_debuff:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end
function modifier_imba_faceless_void_chronosphere_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_imba_faceless_void_chronosphere_debuff:StatusEffectPriority() return 16 end
function modifier_imba_faceless_void_chronosphere_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_faceless_void_chronosphere_debuff:GetEffectName()
	if not self:IsMotionController() then
		return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf"
	else
		return nil
	end
end

function modifier_imba_faceless_void_chronosphere_debuff:CheckState()
	if self:IsMotionController() then
		return {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_ROOTED] = true, [MODIFIER_STATE_DISARMED] = true, [MODIFIER_STATE_INVISIBLE] = false, [MODIFIER_STATE_FROZEN] = true}
	elseif self.buff_type == Chronosphere_Caster or self.buff_type == Chronosphere_Enemy_Ability then
		return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	else
		return nil
	end
end

function modifier_imba_faceless_void_chronosphere_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN, MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT}
end

function modifier_imba_faceless_void_chronosphere_debuff:GetModifierMoveSpeed_AbsoluteMin()
	if self.buff_type == Chronosphere_Caster then
		return self:GetAbility():GetSpecialValueFor("chrono_ms")
	elseif self.buff_type == Chronosphere_Ally_Scepter then
		return self.ms
	else
		return nil
	end
end

function modifier_imba_faceless_void_chronosphere_debuff:GetModifierMoveSpeed_AbsoluteMax()
	if self.buff_type ==  Chronosphere_Caster then
		return self:GetAbility():GetSpecialValueFor("chrono_ms")
	elseif self.buff_type == Chronosphere_Ally_Scepter then
		return self.ms
	else
		return nil
	end
end

function modifier_imba_faceless_void_chronosphere_debuff:GetModifierTurnRate_Percentage()
	if self.buff_type == Chronosphere_Ally_Scepter then
		return (0 -self:GetAbility():GetSpecialValueFor("slow_scepter"))
	else
		return nil
	end
end

function modifier_imba_faceless_void_chronosphere_debuff:GetModifierAttackSpeedBonus_Constant()
	if self.buff_type == Chronosphere_Caster then
		return (self:GetCaster():GetModifierStackCount("modifier_imba_faceless_void_chronosphere_stamps", nil) * self:GetAbility():GetSpecialValueFor("bonus_as"))
	else
		return nil
	end
end

function modifier_imba_faceless_void_chronosphere_debuff:GetModifierAttackSpeed_Limit()
	if self.buff_type == Chronosphere_Caster then
		return 1
	else
		return 0
	end
end