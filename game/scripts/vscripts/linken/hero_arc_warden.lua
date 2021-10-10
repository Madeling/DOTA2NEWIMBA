------2020.6.6--by--你收拾收拾准备出林肯吧

local HeroItems_steamid_64 = {
["76561198095504121"] = true,
["76561198078081944"]= true,
}

imba_arc_warden_mold_rune = class({})

LinkLuaModifier("modifier_imba_arc_warden_scepter_controller", "linken/hero_arc_warden.lua", LUA_MODIFIER_MOTION_NONE)

function imba_arc_warden_mold_rune:IsHiddenWhenStolen() 	return false end
function imba_arc_warden_mold_rune:IsRefreshable() 			return true end
function imba_arc_warden_mold_rune:IsStealable() 			return true end
function imba_arc_warden_mold_rune:GetIntrinsicModifierName() return "modifier_imba_arc_warden_scepter_controller" end
function imba_arc_warden_mold_rune:IsTalentAbility() return true end

function imba_arc_warden_mold_rune:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local random_buff = {"modifier_rune_regen", "modifier_rune_haste", "modifier_rune_invis", "modifier_rune_doubledamage", "modifier_rune_arcane"}
	target:AddNewModifier(caster, self, RandomFromTable(random_buff), {duration = 1.0})
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	caster:EmitSound("Hero_ArcWarden.Flux.Cast")
	target:EmitSound("Hero_ArcWarden.Flux.Target")
	self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("cooldown"))
end

modifier_imba_arc_warden_scepter_controller = class({})

function modifier_imba_arc_warden_scepter_controller:IsDebuff()			return false end
function modifier_imba_arc_warden_scepter_controller:IsHidden() 		return true end
function modifier_imba_arc_warden_scepter_controller:IsPurgable() 		return false end
function modifier_imba_arc_warden_scepter_controller:IsPurgeException() return false end
function modifier_imba_arc_warden_scepter_controller:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_arc_warden_scepter_controller:OnIntervalThink()
	self:GetAbility():SetHidden(not self:GetParent():HasScepter())
end
--1乱流结束后产生一个闪光幽魂 范围内每有一个身中乱流者 增加x攻击距离和x攻击速度。

imba_arc_warden_flux = class({})

LinkLuaModifier("modifier_imba_arc_warden_flux", "linken/hero_arc_warden.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_arc_warden_flux_mod", "linken/hero_arc_warden.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spark_wraith_miss", "linken/hero_arc_warden.lua", LUA_MODIFIER_MOTION_NONE)

function imba_arc_warden_flux:IsHiddenWhenStolen() 	return false end
function imba_arc_warden_flux:IsRefreshable() 			return true end
function imba_arc_warden_flux:IsStealable() 			return true end
function imba_arc_warden_flux:GetIntrinsicModifierName() return "modifier_imba_arc_warden_flux_mod" end

function imba_arc_warden_flux:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local ID = self:GetCaster():GetPlayerOwnerID()
	local steamid = tostring(PlayerResource:GetSteamID(ID))	
	local duration = self:GetSpecialValueFor("duration") + caster:TG_GetTalentValue("special_bonus_imba_arc_warden_5")
	TG_AddNewModifier_RS(target,caster, self, "modifier_imba_arc_warden_flux", {duration = duration})
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_CUSTOMORIGIN, caster)
	if HeroItems_steamid_64[steamid] then
		pfx = ParticleManager:CreateParticle("particles/heros/arc_warden/arc_warden_flux_cast/arc_warden_flux_cast.vpcf", PATTACH_CUSTOMORIGIN, caster)
	end	
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	caster:EmitSound("Hero_ArcWarden.Flux.Cast")
	target:EmitSound("Hero_ArcWarden.Flux.Target")
end
modifier_imba_arc_warden_flux_mod = class({})

function modifier_imba_arc_warden_flux_mod:IsDebuff()			return false end
function modifier_imba_arc_warden_flux_mod:IsHidden() 		return false end
function modifier_imba_arc_warden_flux_mod:IsPurgable() 		return false end
function modifier_imba_arc_warden_flux_mod:IsPurgeException() return false end

function modifier_imba_arc_warden_flux_mod:DeclareFunctions()	
	return 
	{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	} 
end
function modifier_imba_arc_warden_flux_mod:GetModifierAttackSpeedBonus_Constant()
	return (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus_sp_ran"))
end
function modifier_imba_arc_warden_flux_mod:GetModifierAttackRangeBonus()
	return (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus_sp_ran"))
end
function modifier_imba_arc_warden_flux_mod:OnCreated()
	if IsServer() then
		self.add_search = self:GetAbility():GetSpecialValueFor("add_search")
		self:StartIntervalThink(0.2)
	end
end
function modifier_imba_arc_warden_flux_mod:OnIntervalThink()
	local target = self:GetParent()
	local enemies = FindUnitsInRadius(target:GetTeamNumber(),
	target:GetAbsOrigin(),
	nil,
	self.add_search,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	FIND_ANY_ORDER,
	false)
	local stack = 0
	for _, enemy in pairs(enemies) do
		if enemy:HasModifier("modifier_imba_arc_warden_flux") then
			stack = stack + enemy:FindModifierByName("modifier_imba_arc_warden_flux"):GetStackCount()
		end	
	end
	self:SetStackCount(stack)
end	


modifier_imba_arc_warden_flux = class({})

function modifier_imba_arc_warden_flux:IsDebuff()			return true end
function modifier_imba_arc_warden_flux:IsHidden() 		return false end
function modifier_imba_arc_warden_flux:IsPurgable() 		return true end
function modifier_imba_arc_warden_flux:IsPurgeException() return true end
function modifier_imba_arc_warden_flux:GetModifierMoveSpeedBonus_Percentage() 
	if self.ms_slow then
		return (0 - self:GetAbility():GetSpecialValueFor("ms_slow"))
	end
	return 0 
end
function modifier_imba_arc_warden_flux:DeclareFunctions()	
	return 
	{
	MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	} 
end
function modifier_imba_arc_warden_flux:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local ID = self:GetCaster():GetPlayerOwnerID()
		local steamid = tostring(PlayerResource:GetSteamID(ID))
		self.ms_slow = false
		self.texiao = 0
		self.int = 0.2
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
		self.int_damage = self:GetAbility():GetSpecialValueFor("int_damage")
		self.add_search = self:GetAbility():GetSpecialValueFor("add_search")		
		self:StartIntervalThink(self.int)
		self:IncrementStackCount()
		if HeroItems_steamid_64[steamid] then
			self.pfx = ParticleManager:CreateParticle("particles/heros/arc_warden/arc_warden_flux_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		else
			self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)	
		end			
		ParticleManager:SetParticleControlEnt(self.pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		self:AddParticle(self.pfx, false, false, 16, false, false)	
		local damageTable = {
						victim = target,
						attacker = caster,
						damage = self.damage * self.int + (self:GetStackCount()-1) * self.int_damage,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE,
						ability = self:GetAbility()
						}
		ApplyDamage(damageTable)							
	end
end
function modifier_imba_arc_warden_flux:OnRefresh()
	if IsServer() then
		self:OnCreated()				
	end
end

function modifier_imba_arc_warden_flux:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx, false)
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		self.add_search,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)
		local caster = self:GetCaster()
		local point = self:GetParent():GetAbsOrigin()
		local ability = self:GetCaster():FindAbilityByName("imba_arc_warden_spark_wraith")
		local ability2 = self:GetCaster():FindAbilityByName("imba_arc_warden_magnetic_field")
		if ability and ability:IsTrained() and self.ms_slow then								
			CreateModifierThinker(
				caster,
				ability,
				"modifier_imba_arc_warden_spark_wraith_thinker",
				{
					duration = ability:GetSpecialValueFor("duration") / 10,
					radius = ability:GetSpecialValueFor("search_radius"),
					delay = ability:GetSpecialValueFor("activation_delay"),
					valve = 0,
				},
				point,
				caster:GetTeamNumber(),
				false
			)										
			if ability2 and ability2:IsTrained() and self.ms_slow and self:GetStackCount() > 3 then
				self:GetCaster():SetCursorPosition(point)
				ability2:OnSpellStart()
			end				
		end		
	end
end

function modifier_imba_arc_warden_flux:OnIntervalThink()
	local caster = self:GetCaster()
	local target = self:GetParent()
	local search = self:GetAbility():GetSpecialValueFor("search")
	local damageTable = {
							victim = target,
							attacker = caster,
							damage = (self:GetStackCount()) * self:GetAbility():GetSpecialValueFor("damage") * self.int,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE,
							ability = self:GetAbility()
							}	
	if not caster:TG_HasTalent("special_bonus_imba_arc_warden_1") then
		local enemies = FindUnitsInRadius(target:GetTeamNumber(),
			target:GetAbsOrigin(),
			nil,
			search,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
		if #enemies <= 1 then
			self.ms_slow = true
			self.texiao = self:GetStackCount() + 3
			ApplyDamage(damageTable)
		else
			self.ms_slow = false
			self.texiao = 0
		end
	else
		self.ms_slow = true
		self.texiao = self:GetStackCount() + 3
		ApplyDamage(damageTable)
	end	
		
	ParticleManager:SetParticleControl(self.pfx, 4, Vector(self.texiao,0,0))		
end

--磁场

imba_arc_warden_magnetic_field = class({})

LinkLuaModifier("modifier_imba_arc_warden_magnetic_field_thinker", "linken/hero_arc_warden.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_arc_warden_magnetic_field_buff", "linken/hero_arc_warden.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_arc_warden_magnetic_field_selfbuff", "linken/hero_arc_warden.lua", LUA_MODIFIER_MOTION_NONE)

function imba_arc_warden_magnetic_field:IsHiddenWhenStolen() 	return false end
function imba_arc_warden_magnetic_field:IsRefreshable() 			return true end
function imba_arc_warden_magnetic_field:IsStealable() 			return true end
function imba_arc_warden_magnetic_field:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
		if IsServer() and caster:TG_HasTalent("special_bonus_imba_arc_warden_3") then 
			return (cooldown + caster:TG_GetTalentValue("special_bonus_imba_arc_warden_3"))
		end
	return cooldown
end

function imba_arc_warden_magnetic_field:GetAOERadius() 
	return 
	self:GetSpecialValueFor("base_radius") + self:GetCaster():GetAgility()
end

function imba_arc_warden_magnetic_field:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local radius = self:GetAOERadius()
	local duration = self:GetSpecialValueFor("duration")
	local thinker = CreateModifierThinker(caster, self, "modifier_imba_arc_warden_magnetic_field_thinker", {duration = duration, radius = radius}, pos, caster:GetTeamNumber(), false)
	caster:AddNewModifier(caster, self, "modifier_imba_arc_warden_magnetic_field_selfbuff", {duration = duration})

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_magnetic_cast.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)
	caster:EmitSound("Hero_ArcWarden.magneticfield.Cast")
	caster:EmitSound("Hero_ArcWarden.magneticfield")
end
modifier_imba_arc_warden_magnetic_field_selfbuff = class({})
function modifier_imba_arc_warden_magnetic_field_selfbuff:OnCreated()
	if IsServer() then
		self.arm = self:GetAbility():GetSpecialValueFor("armor")
		if self:GetCaster():TG_HasTalent("special_bonus_imba_arc_warden_8") then
			self.arm = self:GetAbility():GetSpecialValueFor("armor") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_arc_warden_8")
		end	
	end	
end	
function modifier_imba_arc_warden_magnetic_field_selfbuff:IsHidden() 			return true end
function modifier_imba_arc_warden_magnetic_field_selfbuff:IsPurgable() 			return false end
function modifier_imba_arc_warden_magnetic_field_selfbuff:IsPurgeException() 	return false end
function modifier_imba_arc_warden_magnetic_field_selfbuff:IsDebuff() 			return false end
function modifier_imba_arc_warden_magnetic_field_selfbuff:DeclareFunctions()
	return 
	{
	MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end
function modifier_imba_arc_warden_magnetic_field_selfbuff:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if not (keys.attacker == self:GetCaster() or keys.attacker:IsTempestDouble()) then
		return
	end
	if keys.target:IsBuilding() or keys.target:IsOther() or not keys.target:IsAlive() then
		return
	end
	if not keys.target:HasModifier("modifier_imba_arc_warden_magnetic_field_buff") then
		return
	end	
	local damage = math.abs(keys.target:GetPhysicalArmorValue(false))*self.arm
	local damageTable = {
						victim = keys.target,
						attacker = self:GetCaster(),
						damage = damage,
						damage_type = DAMAGE_TYPE_PURE,
						damage_flags = DOTA_DAMAGE_FLAG_NONE, 
						ability = self:GetAbility(), 
						}					
	dmg = ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, keys.target, math.abs(keys.target:GetPhysicalArmorValue(false))*self.arm, nil)
	if self:GetCaster():TG_HasTalent("special_bonus_imba_arc_warden_3") then
		self:GetCaster():Heal(damage*1.5, self:GetCaster())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetCaster(), damage*1.5, nil)
	end				
end


modifier_imba_arc_warden_magnetic_field_thinker = class({})
function modifier_imba_arc_warden_magnetic_field_thinker:OnCreated(keys)
	if IsServer() then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), keys.radius, self:GetDuration(), false)
		self.radius = keys.radius
		local ID = self:GetCaster():GetPlayerOwnerID()
		local steamid = tostring(PlayerResource:GetSteamID(ID))
		if HeroItems_steamid_64[steamid] then
			self.pfx = ParticleManager:CreateParticle("particles/heros/arc_warden/arc_warden_red_magnetic/arc_warden_red_magnetic.vpcf", PATTACH_POINT, self:GetParent())
		else
			self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_magnetic.vpcf", PATTACH_POINT, self:GetParent())	
		end			
		
		ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(self.pfx, false, false, 16, false, false)
	end
end
function modifier_imba_arc_warden_magnetic_field_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx, true)
	end
end	
function modifier_imba_arc_warden_magnetic_field_thinker:IsAura() return true end
function modifier_imba_arc_warden_magnetic_field_thinker:GetAuraDuration() return 0.1 end
function modifier_imba_arc_warden_magnetic_field_thinker:GetModifierAura() return "modifier_imba_arc_warden_magnetic_field_buff" end
function modifier_imba_arc_warden_magnetic_field_thinker:GetAuraRadius() return self.radius end
function modifier_imba_arc_warden_magnetic_field_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_imba_arc_warden_magnetic_field_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_imba_arc_warden_magnetic_field_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC end

modifier_imba_arc_warden_magnetic_field_buff = class({})
function modifier_imba_arc_warden_magnetic_field_buff:OnCreated()
	if IsServer() then
		if not Is_Chinese_TG(self:GetCaster(), self:GetParent()) then	
			local ability = self:GetCaster():FindAbilityByName("imba_arc_warden_flux") 
			if ability and ability:IsTrained() then
				if self:GetParent():IsHero() and self:GetCaster():TG_HasTalent("special_bonus_imba_arc_warden_2") and not self:GetParent():IsMagicImmune() then
					self:GetCaster():SetCursorCastTarget(self:GetParent())
					ability:OnSpellStart()
				end	
			end
		end
		self.miss = true
	end	
end	

function modifier_imba_arc_warden_magnetic_field_buff:IsHidden() 			return true end
function modifier_imba_arc_warden_magnetic_field_buff:IsPurgable() 			return false end
function modifier_imba_arc_warden_magnetic_field_buff:IsPurgeException() 	return false end
function modifier_imba_arc_warden_magnetic_field_buff:IsDebuff() 			return false end
function modifier_imba_arc_warden_magnetic_field_buff:CheckState() return {[MODIFIER_STATE_CANNOT_MISS] = not not Is_Chinese_TG(self:GetCaster(), self:GetParent()) } end
function modifier_imba_arc_warden_magnetic_field_buff:GetPriority() return MODIFIER_PRIORITY_HIGH end

function modifier_imba_arc_warden_magnetic_field_buff:DeclareFunctions()
	return 
	{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
	MODIFIER_PROPERTY_EVASION_CONSTANT, 
	MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_EVENT_ON_ATTACKED,
	MODIFIER_EVENT_ON_ATTACK_START
	}
end


function modifier_imba_arc_warden_magnetic_field_buff:GetModifierAttackSpeedBonus_Constant()
	if IsServer() and not Is_Chinese_TG(self:GetCaster(), self:GetParent()) then
		return 0
	end	
	return self:GetAbility():GetSpecialValueFor("bonus_as")	
end
function modifier_imba_arc_warden_magnetic_field_buff:GetModifierEvasion_Constant()
	if IsServer() and not Is_Chinese_TG(self:GetCaster(), self:GetParent()) or not self.miss then
		return 0
	end	
	return self:GetAbility():GetSpecialValueFor("miss_as")
end  
function modifier_imba_arc_warden_magnetic_field_buff:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker~=nil and not Is_Chinese_TG(self:GetCaster(), keys.attacker) and keys.attacker:HasModifier("modifier_imba_arc_warden_magnetic_field_buff") then
		self.miss = false
	end		
end
function modifier_imba_arc_warden_magnetic_field_buff:OnAttacked(keys)
	if not IsServer() then
		return
	end
	if keys.attacker~=nil and not Is_Chinese_TG(self:GetCaster(), keys.attacker) and keys.attacker:HasModifier("modifier_imba_arc_warden_magnetic_field_buff") then
		self.miss = true
	end		
end		

---------------闪光幽魂---被激活时，增加大招等级-1的额外目标数--每过一段时间在原地生成一个闪光幽魂-但是持续时间下降  --闪光幽魂施加乱流 --600*大招等级-1内才会施加
--乱流失效范围为0--乱流无法驱散（伤害和减速无法穿透魔免）（废弃）--乱流持续时间翻倍--减少原地生产闪光幽魂间隔 -- 扭曲磁场造成的伤害将治疗自己 --磁场施加乱流 --1250血量

imba_arc_warden_spark_wraith = class({})

LinkLuaModifier("modifier_imba_arc_warden_spark_wraith_thinker", "linken/hero_arc_warden.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_arc_warden_spark_wraith_mod", "linken/hero_arc_warden.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_imba_spark_wraith_miss", "linken/hero_arc_warden.lua", LUA_MODIFIER_MOTION_NONE)

function imba_arc_warden_spark_wraith:IsHiddenWhenStolen() 	return false end
function imba_arc_warden_spark_wraith:IsRefreshable() 		return true end
function imba_arc_warden_spark_wraith:IsStealable() 			return true end
function imba_arc_warden_spark_wraith:GetIntrinsicModifierName() return "modifier_imba_arc_warden_spark_wraith_mod" end
function imba_arc_warden_spark_wraith:GetAOERadius()
	return self:GetSpecialValueFor("search_radius")
end
function imba_arc_warden_spark_wraith:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local tk=CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_imba_arc_warden_spark_wraith_thinker",
		{
			duration = self:GetSpecialValueFor("duration"),
			radius = self:GetSpecialValueFor("search_radius"),
			delay = self:GetSpecialValueFor("activation_delay"),
			valve = 1,
		},
		pos,
		self:GetCaster():GetTeamNumber(),
		false
	)
	local ID = self:GetCaster():GetPlayerOwnerID()
	local steamid = tostring(PlayerResource:GetSteamID(ID))
	local particle_cast = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_cast.vpcf"
	if HeroItems_steamid_64[steamid] then
		particle_cast = "particles/heros/arc_warden/arc_warden_ti9_wraith_cast/arc_warden_ti9_wraith_cast.vpcf"
	end		
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(effect_cast, 0, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(effect_cast, 1, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(effect_cast)
	caster:EmitSound("Hero_ArcWarden.SparkWraith.Cast")	

	AddFOWViewer(caster:GetTeamNumber(), pos, self:GetSpecialValueFor("search_radius"), self:GetSpecialValueFor("activation_delay"), false)		
end

modifier_imba_arc_warden_spark_wraith_thinker = class({})

function modifier_imba_arc_warden_spark_wraith_thinker:OnCreated(params)
	if IsServer() then
		self.radius = params.radius
		self.delay = params.delay
		self.valve = params.valve
		local ability = self:GetAbility()
		self.delay = self:GetAbility():GetSpecialValueFor("activation_delay")
		if self:GetCaster():TG_HasTalent("special_bonus_imba_arc_warden_7") then
			self.delay = self:GetAbility():GetSpecialValueFor("activation_delay") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_arc_warden_7")
		end		
		self.attack_count = ability:GetSpecialValueFor("attack_count")
		if self:GetCaster():TG_HasTalent("special_bonus_imba_arc_warden_6") then
			self.attack_count = ability:GetSpecialValueFor("attack_count") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_arc_warden_6")
		end	
		local ID = self:GetCaster():GetPlayerOwnerID()
		local steamid = tostring(PlayerResource:GetSteamID(ID))
		local particle_cast = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf"
		if HeroItems_steamid_64[steamid] then
			particle_cast = "particles/heros/arc_warden/arc_warden_ti9_wraith/arc_warden_ti9_wraith.vpcf"
		end			
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() + Vector(0,0,65) )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius, self.radius, self.radius) )
		ParticleManager:ReleaseParticleIndex(effect_cast)
		self:StartIntervalThink(self.delay)
		self:GetParent():EmitSound("Hero_ArcWarden.SparkWraith.Appear")	
	end
end

function modifier_imba_arc_warden_spark_wraith_thinker:OnIntervalThink(params)
	if not IsServer() then return end
	if not self.delay then
		self:StartIntervalThink(0.2)
	end
	--提供视野
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	AddFOWViewer(caster:GetTeamNumber(), self:GetParent():GetOrigin(), ability:GetSpecialValueFor("search_radius"), 1, false)

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	
		self:GetParent():GetOrigin(),
		nil,	
		self.radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	
		DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,	
		FIND_CLOSEST,	
		false	
	)

	local target = nil
	for _,enemy in pairs(enemies) do
		target = enemy
		break
	end
	if not target then return end
	local ID = self:GetCaster():GetPlayerOwnerID()
	local steamid = tostring(PlayerResource:GetSteamID(ID))
	local pfxName = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_prj.vpcf"
	if HeroItems_steamid_64[steamid] then
		pfxName = "particles/heros/arc_warden/arc_warden_ti9_wraith_prj/arc_warden_ti9_wraith_prj.vpcf"
	end		
	local i = 1
		for _,enemy in pairs(enemies) do

			local info = 
			{
				Target = enemy,
				Source = self:GetParent(),
				bDeleteOnHit = true,
				Ability = ability,	
				EffectName = pfxName,
				iMoveSpeed = ability:GetSpecialValueFor("speed"),
				bDrawsOnMinimap = false,
				bDodgeable = false,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				flExpireTime = GameRules:GetGameTime() + 10,
				bProvidesVision = false,
			}
			TG_CreateProjectile({id=1,team=self:GetCaster():GetTeamNumber(),owner=self:GetCaster(),p=info})
			if i == self.attack_count or self.valve == 0 then 
				break
			end
			i = i + 1	
		end	
	self:GetParent():EmitSound("Hero_ArcWarden.SparkWraith.Activate")	
	self:Destroy()
end
function imba_arc_warden_spark_wraith:OnProjectileThink(location) AddFOWViewer(self:GetCaster():GetTeamNumber(), location, self:GetSpecialValueFor("search_radius"), FrameTime()*10, false) end

function imba_arc_warden_spark_wraith:OnProjectileHit_ExtraData(target, location, keys)
	if not target or target:IsMagicImmune() then
		return
	end
	local caster = self:GetCaster()
	local dmg = self:GetSpecialValueFor("damage")
	local damageTable = {
						victim = target,
						attacker = self:GetCaster(),
						damage = dmg,
						damage_type = self:GetAbilityDamageType(),
						damage_flags = DOTA_DAMAGE_FLAG_NONE, 
						ability = self,
						}
	ApplyDamage(damageTable)
	local ability = self:GetCaster():FindAbilityByName("imba_arc_warden_flux")
	if ability and ability:IsTrained() and not target:IsBoss() and (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() < self:GetCaster():Script_GetAttackRange() then
		self:GetCaster():SetCursorCastTarget(target)
		ability:OnSpellStart()
	end	
	target:EmitSound("Hero_ArcWarden.SparkWraith.Damage")
	TG_AddNewModifier_RS(target,self:GetCaster(), self, "modifier_imba_spark_wraith_miss", {duration = self:GetSpecialValueFor("paralyzed_duration")})
	TG_AddNewModifier_RS(target,self:GetCaster(), self, "modifier_paralyzed", {duration = self:GetSpecialValueFor("paralyzed_duration")})
end

function modifier_imba_arc_warden_spark_wraith_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
end

modifier_imba_arc_warden_spark_wraith_mod = class({})

function modifier_imba_arc_warden_spark_wraith_mod:IsDebuff()			return false end
function modifier_imba_arc_warden_spark_wraith_mod:IsHidden() 		return true end
function modifier_imba_arc_warden_spark_wraith_mod:IsPurgable() 		return false end
function modifier_imba_arc_warden_spark_wraith_mod:IsPurgeException() return false end
function modifier_imba_arc_warden_spark_wraith_mod:OnCreated()
	if IsServer() then
		self.delay = self:GetAbility():GetSpecialValueFor("activation_delay")
		self.search_radius = self:GetAbility():GetSpecialValueFor("search_radius")
		self.duration = self:GetAbility():GetSpecialValueFor("duration")
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
	end
end
function modifier_imba_arc_warden_spark_wraith_mod:OnIntervalThink()
	local caster = self:GetParent()
	local pos = caster:GetAbsOrigin()
	local interval = self:GetAbility():GetSpecialValueFor("interval") + caster:TG_GetTalentValue("special_bonus_imba_arc_warden_4")
	local control = true
	if caster:TG_HasTalent("special_bonus_imba_arc_warden_4") and control then
		self:StartIntervalThink(interval)
		control = false
	end
	if caster:PassivesDisabled() or caster:IsSilenced() or not caster:IsAlive() then return end
		CreateModifierThinker(
			caster,
			self:GetAbility(),
			"modifier_imba_arc_warden_spark_wraith_thinker",
			{
				duration = self.duration / 10,
				radius = self.search_radius,
				delay = self.delay,
				valve = 0,
			},
			pos,
			caster:GetTeamNumber(),
			false
		)	
end
modifier_imba_spark_wraith_miss = class({})

function modifier_imba_spark_wraith_miss:IsDebuff()			return true end
function modifier_imba_spark_wraith_miss:IsHidden() 			return false end
function modifier_imba_spark_wraith_miss:IsPurgable() 		return true end
function modifier_imba_spark_wraith_miss:IsPurgeException() 	return true end
function modifier_imba_spark_wraith_miss:DeclareFunctions() return {MODIFIER_PROPERTY_MISS_PERCENTAGE} end
function modifier_imba_spark_wraith_miss:GetModifierMiss_Percentage() return self:GetAbility():GetSpecialValueFor("blind_amount") end