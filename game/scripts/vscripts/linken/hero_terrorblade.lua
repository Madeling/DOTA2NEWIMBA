-------------------------2020.09.10 by你收拾收拾准备出林肯吧
CreateTalents("npc_dota_hero_terrorblade", "linken/hero_terrorblade")
function GetDemonicPower(hero)
	if hero:GetModifierStackCount("modifier_imba_terrorblade_demonic_power_passive", nil) == 0 then
		return 1
	else
		return hero:GetModifierStackCount("modifier_imba_terrorblade_demonic_power_passive", nil)	
	end	
	
end
imba_terrorblade_demonic_power = class({})

LinkLuaModifier("modifier_imba_terrorblade_demonic_power", "linken/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_terrorblade_demonic_power_passive", "linken/hero_terrorblade", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_terrorblade_demonic_power_truekill", "linken/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)

function imba_terrorblade_demonic_power:IsHiddenWhenStolen() 		return false end
function imba_terrorblade_demonic_power:IsRefreshable() 			return true end
function imba_terrorblade_demonic_power:IsStealable() 				return false end
function imba_terrorblade_demonic_power:GetIntrinsicModifierName() return "modifier_imba_terrorblade_demonic_power_passive" end
function imba_terrorblade_demonic_power:GetCastRange()
	return self:GetSpecialValueFor("terror_wave_radius") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_terrorblade_7") - self:GetCaster():GetCastRangeBonus()	
end
function imba_terrorblade_demonic_power:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST 
end
function imba_terrorblade_demonic_power:CastFilterResult()
	self.truekill = self:GetSpecialValueFor("truekill")
	if IsServer() then
		if self:GetAutoCastState() and GetDemonicPower(self:GetCaster()) < self.truekill then
			return UF_FAIL_CUSTOM
		end
	end	
end

function imba_terrorblade_demonic_power:GetCustomCastError()
	self.truekill = self:GetSpecialValueFor("truekill")
	if self:GetAutoCastState() and GetDemonicPower(self:GetCaster()) < self.truekill then
		return "恶魔能量不足"
	end
end
function imba_terrorblade_demonic_power:OnSpellStart()
	local caster = self:GetCaster()
	local pos = caster:GetAbsOrigin()	
	self.truekill = self:GetSpecialValueFor("truekill")
	self.metamorphosis_duration = self:GetSpecialValueFor("metamorphosis_duration")
	self.terror_wave_radius = self:GetSpecialValueFor("terror_wave_radius") + caster:TG_GetTalentValue("special_bonus_imba_terrorblade_7")
	self.wave_radius_duration = self:GetSpecialValueFor("wave_radius_duration") + caster:TG_GetTalentValue("special_bonus_imba_terrorblade_8")
	local modifier = caster:FindModifierByName("modifier_imba_terrorblade_demonic_power_passive")	
	local terror_wave_sound = "Hero_Terrorblade.Metamorphosis.Scepter"
	--恐怖心潮特效
	local terror_wave_pfx = "particles/units/heroes/hero_terrorblade/terrorblade_scepter.vpcf"
	--大圣特效 真tm契合
	local pfx2 = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/water/monkey_king_spring_arcana_water.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 0, pos)
	ParticleManager:SetParticleControl(pfx2, 1, Vector(self.terror_wave_radius, self.terror_wave_radius, self.terror_wave_radius))
	ParticleManager:SetParticleControl(pfx2, 2, Vector(self.terror_wave_radius, self.terror_wave_radius, self.terror_wave_radius))
	ParticleManager:ReleaseParticleIndex(pfx2)

	caster:EmitSound(terror_wave_sound)
	local pfx = ParticleManager:CreateParticle(terror_wave_pfx, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, pos)
	ParticleManager:ReleaseParticleIndex(pfx)
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.terror_wave_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)
	for i=1, #enemy do
		TG_AddNewModifier_RS(enemy[i], caster, self, "modifier_terrorblade_fear", {duration = self.wave_radius_duration})
		if self:GetAutoCastState() and GetDemonicPower(caster) >= self.truekill then
			--恐怖心潮秒杀判断
			EmitSoundOnClient("Imba.terrorblade.heart", enemy[i]:GetPlayerOwner())		
			enemy[i]:AddNewModifier(caster, self, "modifier_terrorblade_fear", {duration = 3})			
			enemy[i]:AddNewModifier(caster, self, "modifier_terrorblade_demonic_power_truekill", {duration = 3})		
		end			
	end
	if self:GetAutoCastState() and GetDemonicPower(caster) >= self.truekill then
		modifier:SetStackCount(modifier:GetStackCount() - self.truekill)
	end
	local ability = caster:FindAbilityByName("imba_terrorblade_metamorphosis")
	local metamorphosis = caster:FindModifierByName("modifier_imba_cmetamorphosis_aura")
	if metamorphosis and ability and self:GetCaster():HasScepter() then
		metamorphosis:SetDuration(metamorphosis:GetRemainingTime()+self.metamorphosis_duration, true)
	elseif not metamorphosis and ability and self:GetCaster():HasScepter() then
		caster:AddNewModifier(caster, ability, "modifier_imba_cmetamorphosis_aura", {duration = self.metamorphosis_duration})
	end	
	--caster:RemoveModifierByName("modifier_imba_terrorblade_demonic_power_passive")
	--caster:AddNewModifier(caster, self, "modifier_imba_terrorblade_demonic_power_passive", {})
end
--延迟秒杀计时器
modifier_terrorblade_demonic_power_truekill = class({})

function modifier_terrorblade_demonic_power_truekill:IsDebuff()			return true end
function modifier_terrorblade_demonic_power_truekill:IsHidden() 		return true end
function modifier_terrorblade_demonic_power_truekill:IsPurgable() 		return true end
function modifier_terrorblade_demonic_power_truekill:IsPurgeException() return true end
function modifier_terrorblade_demonic_power_truekill:CheckState()
	return 
		{
		[MODIFIER_STATE_COMMAND_RESTRICTED]	= true,
		[MODIFIER_STATE_DISARMED]	= true,
		[MODIFIER_STATE_INVULNERABLE]	= true,
		[MODIFIER_STATE_UNSELECTABLE]	= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP]	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR]	= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]	= true,
		}
end
function modifier_terrorblade_demonic_power_truekill:OnCreated()
	if IsServer() then
		self.pfx = ParticleManager:CreateParticleForPlayer("particles/heros/terrorblade/terrorblade_demonic_power_truekill.vpcf", PATTACH_EYES_FOLLOW, self:GetParent(), PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()))
		self:AddParticle(self.pfx, false, false, 15, false, false)
		PlayerResource:SetCameraTarget(self:GetParent():GetPlayerOwnerID(), self:GetParent())
	end
end
function modifier_terrorblade_demonic_power_truekill:OnDestroy() 
	if IsServer() then
		EmitSoundOnClient("Imba.terrorblade.buy_back", self:GetParent():GetPlayerOwner())
		if self.pfx then
			ParticleManager:DestroyParticle( self.pfx, false )
			ParticleManager:ReleaseParticleIndex( self.pfx )	
		end
		PlayerResource:SetCameraTarget(self:GetParent():GetPlayerID(), nil)
		local pfx_screen = ParticleManager:CreateParticleForPlayer("particles/heros/terrorblade/terrorblade_demonic_power_truekill_tga.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), PlayerResource:GetPlayer(self:GetParent():GetPlayerID()))
		ParticleManager:ReleaseParticleIndex( pfx_screen )
		--if pfx_screen then
		--	ParticleManager:DestroyParticle( pfx_screen, false )
		--	ParticleManager:ReleaseParticleIndex( pfx_screen )	
		--end							
		TG_Kill(self:GetCaster(), self:GetParent(), self:GetAbility()) 
	end	
end
--恶魔能量检测计数器
modifier_imba_terrorblade_demonic_power_passive = class({})

function modifier_imba_terrorblade_demonic_power_passive:IsDebuff()				return false end
function modifier_imba_terrorblade_demonic_power_passive:IsHidden() 			return false end
function modifier_imba_terrorblade_demonic_power_passive:IsPurgable() 			return false end
function modifier_imba_terrorblade_demonic_power_passive:IsPurgeException() 	return false end
function modifier_imba_terrorblade_demonic_power_passive:RemoveOnDeath() 		return false end
function modifier_imba_terrorblade_demonic_power_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_DEATH} end
function modifier_imba_terrorblade_demonic_power_passive:OnCreated()
self.maxstack = self:GetAbility():GetSpecialValueFor("maxstack") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_terrorblade_3")	
	if IsServer() then
	end
end
function modifier_imba_terrorblade_demonic_power_passive:OnDeath(keys)
self.maxstack = self:GetAbility():GetSpecialValueFor("maxstack") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_terrorblade_3")	
	if IsServer() then
		if self:GetParent():IsIllusion() then
			return
		end	
		local caster = self:GetCaster()
		local attacker = keys.attacker
		local unit = keys.unit

		local int = 1
		if not Is_Chinese_TG(caster, attacker) and Is_Chinese_TG(caster, unit) and unit:IS_TrueHero_TG() and not unit:IsTempestDouble() then
			if self:GetStackCount() < self.maxstack then
				self:SetStackCount(self:GetStackCount() + int)
			end	
		end
	end
end
--1层 施法距离作用范围增加30%2层 造成的伤害20%吸血 3层 获得视野 4层 可对魔免生效
imba_terrorblade_reflection = class({})

LinkLuaModifier("modifier_imba_reflection_illusion", "linken/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_reflection_slow", "linken/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_reflection_slow_stack", "linken/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)

function imba_terrorblade_reflection:IsHiddenWhenStolen() 		return false end
function imba_terrorblade_reflection:IsRefreshable() 			return true end
function imba_terrorblade_reflection:IsStealable() 				return false end
function imba_terrorblade_reflection:GetAOERadius()
	return self:GetSpecialValueFor("range") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_terrorblade_4")
end
function imba_terrorblade_reflection:GetCastRange()
	return self:GetSpecialValueFor("distance")
end
function imba_terrorblade_reflection:GetCooldown(level)
	--if not IsServer() then return end
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_terrorblade_1") then 
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_terrorblade_1"))
	end
	return cooldown
end
function imba_terrorblade_reflection:OnSpellStart()
	local caster = self:GetCaster()
	local power = GetDemonicPower(caster)
	local pos = self:GetCursorPosition()
	self.range = self:GetSpecialValueFor("range")
	if self:GetCaster():TG_HasTalent("special_bonus_imba_terrorblade_4") then 
		self.range = self:GetSpecialValueFor("range") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_terrorblade_4")
	end	
	self.distance = self:GetSpecialValueFor("distance")

	self.life = self:GetSpecialValueFor("lifesteal")	
	self.duration = self:GetSpecialValueFor("illusion_duration")
	local enemy = FindUnitsInRadius(
	caster:GetTeamNumber(), 
	pos, 
	nil, 
	self.range, 
	DOTA_UNIT_TARGET_TEAM_ENEMY, 
	DOTA_UNIT_TARGET_HERO, 
	DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, 
	FIND_ANY_ORDER, 
	false)	
	for i=1, #enemy do
		enemy[i]:EmitSound("Hero_Terrorblade.Reflection")
		local enemy_buff = TG_AddNewModifier_RS(enemy[i], caster, self, "modifier_imba_reflection_slow", {duration = self.duration})
		local illusion = TG_AddNewModifier_RS(enemy[i], caster, self, "modifier_imba_reflection_illusion", {duration = self.duration})
	end	
end

modifier_imba_reflection_illusion = class({})

function modifier_imba_reflection_illusion:IsDebuff()			return true end
function modifier_imba_reflection_illusion:IsHidden() 			return true end
function modifier_imba_reflection_illusion:IsPurgable() 		return true end
function modifier_imba_reflection_illusion:IsPurgeException() 	return true end
function modifier_imba_reflection_illusion:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_imba_reflection_illusion:OnCreated(keys)
	self.range = self:GetAbility():GetSpecialValueFor("range")
	self.distance = self:GetAbility():GetSpecialValueFor("distance")

	self.life = self:GetAbility():GetSpecialValueFor("lifesteal")
	self.duration = self:GetAbility():GetSpecialValueFor("illusion_duration")			
	if IsServer() then
		self.life = self.life * GetDemonicPower(self:GetCaster())
		--判断攻击间隔用什么来计算
		local int = 1
		if self:GetCaster():FindAbilityByName("imba_terrorblade_reflection"):GetAutoCastState() then
			int = 1/self:GetParent():GetAttacksPerSecond()
			self:SetDuration(self:GetAbility():GetSpecialValueFor("illusion_duration") / self:GetParent():GetAttacksPerSecond(), true)
		end	
		self:StartIntervalThink(int)
	end
end
function modifier_imba_reflection_illusion:OnIntervalThink()
	--攻击自身 触发任何东西
	if not self:GetAbility() then
		self:Destroy()
	end	
	self:GetParent():PerformAttack(self:GetParent(), false, true, true, true, false, false, true)
	--混沌特效
	local pfx = ParticleManager:CreateParticle("particles/heros/chaos_knight/chaos_knight_phantasm_attack.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)	
end
function modifier_imba_reflection_illusion:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	--触发吸血
	if keys.attacker == self:GetParent() and keys.attacker == keys.unit and (keys.unit:IsHero() or keys.unit:IsCreep() or keys.unit:IsBoss()) and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
		local lifesteal = keys.damage * self.life * 0.01
		self:GetCaster():Heal(lifesteal, self:GetAbility())
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)		
		ParticleManager:ReleaseParticleIndex(pfx)
	end		
end
modifier_imba_reflection_slow = class({})
function modifier_imba_reflection_slow:IsDebuff()			return true end
function modifier_imba_reflection_slow:IsHidden() 			return false end
function modifier_imba_reflection_slow:IsPurgable() 		return true end
function modifier_imba_reflection_slow:IsPurgeException() 	return true end
function modifier_imba_reflection_slow:GetEffectName() return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf" end
function modifier_imba_reflection_slow:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_imba_reflection_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_PROVIDES_FOW_POSITION} end
function modifier_imba_reflection_slow:GetModifierMoveSpeedBonus_Percentage() return (0 - self:GetAbility():GetSpecialValueFor("move_slow")) end
function modifier_imba_reflection_slow:GetModifierProvidesFOWVision() 	
	return 1	 
end
function modifier_imba_reflection_slow:OnCreated(keys)
		self.slow = self:GetAbility():GetSpecialValueFor("move_slow")
		self.duration = self:GetAbility():GetSpecialValueFor("illusion_duration")	
	if IsServer() then	
		--根据相应攻击间隔 减少持续时间
		if self:GetCaster():FindAbilityByName("imba_terrorblade_reflection"):GetAutoCastState() then
			self:SetDuration(self.duration / self:GetParent():GetAttacksPerSecond(), true)
		end			
		local pfx = ParticleManager:CreateParticle("particles/status_fx/status_effect_terrorblade_reflection.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
end
------------------------------------------------------------------------------------------------------------

--魔化 -1档 攻击附加50 200范围纯粹伤害 2档 附加100 200范围纯粹伤害 3档 攻击敌人时，被伤害减免的部分视作纯粹伤害，并且无视伤害减免。 4档 魔化光环对友放所有幻想有效
imba_terrorblade_metamorphosis = class({})

LinkLuaModifier("modifier_imba_cmetamorphosis_aura", "linken/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_metamorphosis", "linken/hero_terrorblade", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_metamorphosis_armor", "linken/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)

function imba_terrorblade_metamorphosis:IsHiddenWhenStolen() 		return false end
function imba_terrorblade_metamorphosis:IsRefreshable() 			return true end
function imba_terrorblade_metamorphosis:IsStealable() 				return false end
function imba_terrorblade_metamorphosis:GetCooldown(level)
	--if not IsServer() then return end
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	if caster:TG_HasTalent("special_bonus_imba_terrorblade_5") then 
		return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_terrorblade_5"))
	end
	return cooldown
end
function imba_terrorblade_metamorphosis:GetCastRange()
	return self:GetSpecialValueFor("metamorph_aura_radius") 
end
function imba_terrorblade_metamorphosis:OnUpgrade()
	--白嫖幻象
	if self:GetLevel() <= 1 then
		local caster = self:GetCaster()
		local name = "terrorblade_conjure_image"
		local ability = caster:FindAbilityByName(name)		
		ability:SetHidden(false)
		ability:SetLevel(1)
	end	
end

function imba_terrorblade_metamorphosis:OnSpellStart()
	local caster = self:GetCaster()
	self.duration = self:GetSpecialValueFor("duration")	
	local modifier = caster:FindModifierByName("modifier_imba_cmetamorphosis_aura")
	if modifier then
		modifier:SetDuration(modifier:GetRemainingTime()+self.duration, true)
	end
	caster:AddNewModifier(caster, self, "modifier_imba_cmetamorphosis_aura", {duration = self.duration})	
end

modifier_imba_cmetamorphosis_aura = class({})

function modifier_imba_cmetamorphosis_aura:IsDebuff()			return false end
function modifier_imba_cmetamorphosis_aura:IsHidden() 			return false end
function modifier_imba_cmetamorphosis_aura:IsPurgable() 		return false end
function modifier_imba_cmetamorphosis_aura:IsPurgeException() 	return false end

function modifier_imba_cmetamorphosis_aura:IsAura() return true end
function modifier_imba_cmetamorphosis_aura:GetAuraDuration() return 0.1 end
function modifier_imba_cmetamorphosis_aura:GetModifierAura() return "modifier_imba_metamorphosis" end
function modifier_imba_cmetamorphosis_aura:GetAuraRadius()
	return self.radius
end
function modifier_imba_cmetamorphosis_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_imba_cmetamorphosis_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_cmetamorphosis_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_imba_cmetamorphosis_aura:GetAuraEntityReject(unit)
	--判断是否对友放幻象有效
	if unit == self:GetParent() or (unit:IsIllusion() and unit:GetPlayerOwnerID() == self:GetParent():GetPlayerOwnerID()) then
		return false
	else
		return true
	end
end
function modifier_imba_cmetamorphosis_aura:OnCreated()
		self.t1_power = self:GetAbility():GetSpecialValueFor("t1_power")
		self.t2_power = self:GetAbility():GetSpecialValueFor("t2_power")
		self.radius= self:GetAbility():GetSpecialValueFor("metamorph_aura_radius")
		self.transformation_time =	self:GetAbility():GetSpecialValueFor("transformation_time")
		self.t1_damage = self:GetAbility():GetSpecialValueFor("t1_damage")
		self.t1_radius = self:GetAbility():GetSpecialValueFor("t1_radius")	
	if IsServer() then		
	end
end
function modifier_imba_cmetamorphosis_aura:OnDestroy(unit)
	if IsServer() then
	end	
end
modifier_imba_metamorphosis = class({})
function modifier_imba_metamorphosis:IsDebuff()			return false end
function modifier_imba_metamorphosis:IsHidden() 		return false end
function modifier_imba_metamorphosis:IsPurgable() 		return false end
function modifier_imba_metamorphosis:IsPurgeException() return false end
function modifier_imba_metamorphosis:DeclareFunctions() return {
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, 
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
	--MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, 
	} 
end
function modifier_imba_metamorphosis:GetModifierAttackRangeBonus()
	return self:GetCaster():TG_GetTalentValue("special_bonus_imba_terrorblade_2")
end	
function modifier_imba_metamorphosis:OnCreated()
self.radius= self:GetAbility():GetSpecialValueFor("metamorph_aura_radius")
self.transformation_time =	self:GetAbility():GetSpecialValueFor("transformation_time")
self.t1_damage = self:GetAbility():GetSpecialValueFor("t1_damage")
self.t1_radius = self:GetAbility():GetSpecialValueFor("t1_radius")	
self.duration = self:GetAbility():GetSpecialValueFor("duration")
	if IsServer() then
		self.t1_damage = self.t1_damage * GetDemonicPower(self:GetCaster())
		self.attackCap = self:GetParent():GetAttackCapability()
		self.attackPro = self:GetParent():GetRangedProjectileName()
		local caster = self:GetCaster()
		if self:GetParent() ~= self:GetCaster() then			
			self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		end
--*****重点********************************************这里用了原版魔化，固技能数值全部都是原版数值，更改kv无效，不过可以更改kv叠加到原版数值上去 ,可以是负值***************************************************
		self:GetParent():AddNewModifier(caster, self:GetAbility(), "modifier_terrorblade_metamorphosis_transform", {duration = self.transformation_time})
		self:GetParent():AddNewModifier(caster, self:GetAbility(), "modifier_terrorblade_metamorphosis", {duration = self.duration})				
	end
end

function modifier_imba_metamorphosis:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_terrorblade_metamorphosis")
		self:GetParent():RemoveModifierByName("modifier_imba_metamorphosis")		
		self:GetParent():SetAttackCapability(self.attackCap)
		if self:GetParent() ~= self:GetCaster() then
			self:GetParent():SetRangedProjectileName(self.attackPro)
		end	
		self.attackCap = nil
		self.attackPro = nil
	end
end		
function modifier_imba_metamorphosis:OnAttackLanded(keys)
	if not IsServer() then
		return
	end 	
	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() or keys.target:IsOther() or not keys.target:IsAlive() or keys.attacker:IsIllusion() then
		return
	end
	--攻击附加伤害
	if keys.attacker == self:GetParent() then				
		self.t1_damage = self:GetAbility():GetSpecialValueFor("t1_damage") * GetDemonicPower(self:GetCaster())
		ApplyDamage({
		victim = keys.target, 
		attacker = self:GetParent(),
	 	ability = self:GetAbility(), 
		damage_type = DAMAGE_TYPE_PURE, 
		damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_HPLOSS,
		damage = self.t1_damage
		})
	end	
	--无视目标护甲
	keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_imba_metamorphosis_armor", {})			
end
function modifier_imba_metamorphosis:OnAttackRecordDestroy(keys)
	if keys.target:HasModifier("modifier_imba_metamorphosis_armor") then
		keys.target:RemoveModifierByName("modifier_imba_metamorphosis_armor")
	end	

end	
modifier_imba_metamorphosis_armor = class({})

function modifier_imba_metamorphosis_armor:IsDebuff()				return true end
function modifier_imba_metamorphosis_armor:IsHidden() 			return false end
function modifier_imba_metamorphosis_armor:IsPurgable() 			return false end
function modifier_imba_metamorphosis_armor:IsPurgeException() 	return false end
function modifier_imba_metamorphosis_armor:DeclareFunctions() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_imba_metamorphosis_armor:OnCreated(keys)
self.armor = self:GetAbility():GetSpecialValueFor("armor")
	if IsServer() then
		self.armor_int = math.abs(self:GetParent():GetPhysicalArmorValue(false)*GetDemonicPower(self:GetCaster())*self.armor/100)
		self:SetStackCount(self.armor_int)
	end 
end
function modifier_imba_metamorphosis_armor:GetModifierPhysicalArmorBonus(keys)
	return 0 - self:GetStackCount()
end

--魂断 1档移除施法前摇 2档 可对魔免生效 3档 你获得目标2生命恢复 4档 目标获得你受到的2伤害
imba_terrorblade_sunder = class({})

LinkLuaModifier("modifier_imba_sunder_heal", "linken/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sunder_damage", "linken/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)

function imba_terrorblade_sunder:IsHiddenWhenStolen() 		return false end
function imba_terrorblade_sunder:IsRefreshable() 			return true end
function imba_terrorblade_sunder:IsStealable() 				return false end
function imba_terrorblade_sunder:CastFilterResultTarget(target)
	if target == self:GetCaster() or not target:IsHero() then
		return UF_FAIL_CUSTOM
	end
	if self:GetCaster():HasModifier("modifier_imba_sunder_heal") or target:HasModifier("modifier_imba_sunder_heal") or target:HasModifier("modifier_imba_sunder_damage") or self:GetCaster():HasModifier("modifier_imba_sunder_damage") then
		return UF_FAIL_CUSTOM
	end	
	if target:IsInvulnerable() then
		return UF_FAIL_INVULNERABLE
	end
end

function imba_terrorblade_sunder:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	elseif not target:IsHero() then
		return "#dota_hud_error_cant_cast_on_creep"
	elseif self:GetCaster():HasModifier("modifier_imba_sunder_heal") or target:HasModifier("modifier_imba_sunder_heal") or target:HasModifier("modifier_imba_sunder_damage") or self:GetCaster():HasModifier("modifier_imba_sunder_damage") then
		return "目标或你已经在连接中了"
	end
end

function imba_terrorblade_sunder:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Terrorblade.Sunder.Cast")
	return true
end
function imba_terrorblade_sunder:GetCastRange()
	local caster = self:GetCaster()
	return self:GetSpecialValueFor("cast_range") + caster:TG_GetTalentValue("special_bonus_imba_terrorblade_6")
end
function imba_terrorblade_sunder:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	self.duration = self:GetSpecialValueFor("t2_duration")
	self.metamorphosis_duration = self:GetSpecialValueFor("metamorphosis_duration")
	
	target:EmitSound("Hero_Terrorblade.Sunder.Target")
	local min_hp = self:GetSpecialValueFor("hit_point_minimum")
	local caster_hp_pct = caster:GetHealthPercent()
	local target_hp_pct = target:GetHealthPercent()
	local caster_hp = math.max(min_hp, caster:GetMaxHealth() * (target_hp_pct / 100))
	local target_hp = math.max(min_hp, target:GetMaxHealth() * (caster_hp_pct / 100))

	caster:SetHealth(caster_hp)
	ParticleManagercome(caster, target)
	Timers:CreateTimer(FrameTime()*3, function()
		target:SetHealth(target_hp)
		ParticleManagergo(caster, target)
		return nil
	end)			
	local ability = caster:FindAbilityByName("imba_terrorblade_metamorphosis")
	if not Is_Chinese_TG(caster, target) then
		target:AddNewModifier(caster, self, "modifier_imba_sunder_heal", {duration = self.duration})
		Timers:CreateTimer(FrameTime()*3, function()
			target:AddNewModifier(caster, self, "modifier_imba_sunder_damage", {duration = self.duration}) 
			return nil
		end)		
	elseif Is_Chinese_TG(caster, target) and ability and caster:Has_Aghanims_Shard()then
		target:AddNewModifier(caster, ability, "modifier_imba_cmetamorphosis_aura", {duration = self.metamorphosis_duration})
		self:EndCooldown()
		self:StartCooldown(self:GetSpecialValueFor("cd"))
	end	
end
--随机魂断颜色
function ParticleManagercome(caster, target)
	local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(pfx2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx2, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx2, 15, Vector(math.random(1,255), math.random(1,255), math.random(1,255)))
	ParticleManager:SetParticleControl(pfx2, 16, Vector(math.random(1,255), math.random(1,255), math.random(1,255)))
	ParticleManager:SetParticleControl(pfx2, 60, Vector(math.random(1,255), math.random(1,255), math.random(1,255)))
	ParticleManager:SetParticleControl(pfx2, 61, Vector(1,0,0))
	ParticleManager:ReleaseParticleIndex(pfx2)
end
function ParticleManagergo(caster, target)
	local pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(pfx1, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx1, 15, Vector(math.random(1,255), math.random(1,255), math.random(1,255)))
	ParticleManager:SetParticleControl(pfx1, 16, Vector(math.random(1,255), math.random(1,255), math.random(1,255)))
	ParticleManager:SetParticleControl(pfx1, 60, Vector(math.random(1,255), math.random(1,255), math.random(1,255)))
	ParticleManager:SetParticleControl(pfx1, 61, Vector(1,0,0))
	ParticleManager:ReleaseParticleIndex(pfx1)
end

modifier_imba_sunder_heal = class({})

function modifier_imba_sunder_heal:IsDebuff()			return true end
function modifier_imba_sunder_heal:IsHidden() 			return false end
function modifier_imba_sunder_heal:IsPurgable() 		return false end
function modifier_imba_sunder_heal:IsPurgeException() 	return false end
function modifier_imba_sunder_heal:DeclareFunctions() return {MODIFIER_EVENT_ON_HEAL_RECEIVED} end
function modifier_imba_sunder_heal:OnCreated(keys)
self.t2_int = self:GetAbility():GetSpecialValueFor("t2_int")
	if IsServer() then
		self.t2_int = self.t2_int * GetDemonicPower(self:GetCaster())
		self:StartIntervalThink(1)
	end
end
function modifier_imba_sunder_heal:OnIntervalThink()
	self:GetParent():EmitSound("Hero_Terrorblade.Sunder.Cast")
	if not self:GetCaster():IsAlive() or not self:GetParent():IsAlive() then
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end
	ParticleManagercome(self:GetCaster(), self:GetParent())		
end

function modifier_imba_sunder_heal:OnDestroy()
	if IsServer() then
	end
end
function modifier_imba_sunder_heal:OnHealReceived(keys)
	if keys.unit ~= self:GetParent() or not self:GetCaster():IsAlive() then
		return
	end		
	self:GetCaster():Heal(keys.gain * self.t2_int * 0.01, self:GetAbility())
end

modifier_imba_sunder_damage = class({})

function modifier_imba_sunder_damage:IsDebuff()				return true end
function modifier_imba_sunder_damage:IsHidden() 			return false end
function modifier_imba_sunder_damage:IsPurgable() 			return false end
function modifier_imba_sunder_damage:IsPurgeException() 	return false end
function modifier_imba_sunder_damage:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_imba_sunder_damage:OnCreated(keys)
self.t2_int = self:GetAbility():GetSpecialValueFor("t2_int")
	if IsServer() then
		self.t2_int = self.t2_int * GetDemonicPower(self:GetCaster())
		self:StartIntervalThink(1)
	end
end
function modifier_imba_sunder_damage:OnIntervalThink()
	if not self:GetCaster():IsAlive() or not self:GetParent():IsAlive() then
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end
	ParticleManagergo(self:GetCaster(), self:GetParent())		
end
function modifier_imba_sunder_damage:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetCaster() or not self:GetCaster():IsAlive() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
	end	
	local caster = self:GetCaster()
	local attacker = self:GetParent()
	local ability = self:GetAbility()
	local damage = keys.original_damage * self.t2_int * 0.01
	ApplyDamage({
	victim = attacker, 
	attacker = caster, 
	damage = damage, 
	ability = ability, 
	damage_type = DAMAGE_TYPE_PURE, 
	damage_flags 	= DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
	})		
end