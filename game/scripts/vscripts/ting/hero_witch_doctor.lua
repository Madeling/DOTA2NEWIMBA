CreateTalents("npc_dota_hero_witch_doctor", "ting/hero_witch_doctor")
--麻痹药剂
imba_witch_doctor_paralyzing_cask = class({})
LinkLuaModifier("modifier_imba_witch_doctor_voodoo_restoration", "ting/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_witch_doctor_paralyzing_cask", "ting/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_paralyzed", "ting/hero_lich", LUA_MODIFIER_MOTION_NONE)
function imba_witch_doctor_paralyzing_cask:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	local Talent = caster:TG_GetTalentValue("special_bonus_imba_witch_doctor_2")
	local  Getcd = cooldown - Talent
	if caster:TG_HasTalent("special_bonus_imba_witch_doctor_2") then 
		return (Getcd)
	end
	return cooldown
end
function imba_witch_doctor_paralyzing_cask:OnSpellStart() 
	local pfx_name = "particles/econ/items/witch_doctor/wd_monkey/witchdoctor_cask_monkey.vpcf"
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local speed = self:GetSpecialValueFor("speed")
	local direction = GetDirection2D(pos, caster:GetAbsOrigin())   -- 方向 (a,b) b到a的方向
	local distance = self:GetSpecialValueFor("dis")
	local ab = caster:FindAbilityByName("imba_witch_doctor_voodoo_restoration")
	--local next_pos = GetGroundPosition(caster:GetAbsOrigin() + direction * distance, caster)
	--for i = 1,3,1 do 
	local next_pos = GetGroundPosition(caster:GetAbsOrigin() + direction * distance, caster) --不开自动就往目标方向300码距离扔
	if self:GetAutoCastState() then --开自动就往目标点扔 
		next_pos = Vector(pos.x,pos.y,pos.z+200)
	end
	
	local target = CreateModifierThinker(caster, self, "modifier_dummy_thinker", {duration = 4}, next_pos, caster:GetTeamNumber(), false)	

	local P1= {
				Target = target,
				Source = caster,
				Ability = self,	
				EffectName = pfx_name,
				iMoveSpeed = speed,
				vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
				bDrawsOnMinimap = false,                          -- Optional
				bDodgeable = false,                                -- Optional
				bIsAttack = false,                                -- Optional
				bVisibleToEnemies = true,                         -- Optional
				bReplaceExisting = false,                         -- Optional
				bProvidesVision = false,                           -- Optional
				ExtraData = {count = 0,direction_x = direction.x ,direction_y = direction.y ,direction_z = direction.z },
				}

	ProjectileManager:CreateTrackingProjectile(P1)
--	end
	EmitSoundOn("Hero_WitchDoctor.Paralyzing_Cask_Cast.Bonkers", self:GetCaster())

	
end

function imba_witch_doctor_paralyzing_cask:OnProjectileThink_ExtraData(pos, keys)
	AddFOWViewer(self:GetCaster():GetTeamNumber(), pos, 300, FrameTime(), false)
end

function imba_witch_doctor_paralyzing_cask:OnProjectileHit_ExtraData(target, location, keys) 
	if target then
	local caster = self:GetCaster()
	target:EmitSound("Hero_WitchDoctor.Paralyzing_Cask_Bounce.ti8")
	
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("stun_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier_RS(caster,self,"modifier_imba_stunned",{duration = self:GetSpecialValueFor("stun_duration")})
		enemy:AddNewModifier_RS(caster,self,"modifier_paralyzed",{duration = self:GetSpecialValueFor("paralyzed_duration")})
		local damageTable = {
							victim = enemy,
							attacker = caster,
							damage = self:GetSpecialValueFor("damage") + caster:TG_GetTalentValue("special_bonus_imba_witch_doctor_1"),
							damage_type = self:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self, --Optional.
							}
		ApplyDamage(damageTable)
	end

	--扔球就不弹
	if self:GetAutoCastState() then
			local ab = caster:FindAbilityByName("imba_witch_doctor_voodoo_restoration")
			if ab and ab:GetLevel() > 0 then
				CreateModifierThinker(caster, ab, "modifier_imba_witch_doctor_voodoo_restoration", {duration = self:GetSpecialValueFor("heal_duration"),isCaster = 0 ,radius = self:GetSpecialValueFor("heal_radius")}, location, caster:GetTeamNumber(), false)
			end
		return
	end
	local distnce = self:GetSpecialValueFor("dis")
	local direction = Vector(keys.direction_x,keys.direction_y,keys.direction_z)
	local count = keys.count + 1
	CreateModifierThinker(caster, self, "modifier_imba_witch_doctor_paralyzing_cask", {duration = 0.3}, location, caster:GetTeamNumber(), false)	
	if  count > self:GetSpecialValueFor("bounces_enemy") - 1 then  		--超过次数方向就变为向巫医的方向
		direction = GetDirection2D(self:GetCaster():GetAbsOrigin(), location)
	end
	if  count > self:GetSpecialValueFor("bounces") - 1 then 
		return 
	end
	local tar = target
	local speed = self:GetSpecialValueFor("speed")
	local next_pos =  GetGroundPosition(target:GetAbsOrigin() + direction * distnce, target)
	local pfx_name = "particles/econ/items/witch_doctor/wd_monkey/witchdoctor_cask_monkey.vpcf"
	local ab = caster:FindAbilityByName("imba_witch_doctor_voodoo_restoration")

	local target = CreateModifierThinker(caster, ab, "modifier_dummy_thinker", {duration = 8}, next_pos, caster:GetTeamNumber(), false)		
	local P1= {
				Target = target,
				Source = tar,
				Ability = self,	
				EffectName = pfx_name,
				iMoveSpeed = 1800,
				vSourceLoc= tar,                -- Optional (HOW)
				bDrawsOnMinimap = false,                          -- Optional
				bDodgeable = false,                                -- Optional
				bIsAttack = false,                                -- Optional
				bVisibleToEnemies = true,                         -- Optional
				bReplaceExisting = false,                         -- Optional
				bProvidesVision = false,                           -- Optional
				ExtraData = {count = count ,direction_x = direction.x ,direction_y = direction.y ,direction_z = direction.z}
				}
		Timers:CreateTimer(0.3, function() --弹跳延迟
			 ProjectileManager:CreateTrackingProjectile(P1)
		end)			
	end
	
	
end
modifier_imba_witch_doctor_paralyzing_cask = class({})
LinkLuaModifier("modifier_imba_witch_doctor_voodoo_debuff", "ting/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_witch_doctor_paralyzing_cask:IsDebuff()			return false end
function modifier_imba_witch_doctor_paralyzing_cask:IsHidden() 			return true end
function modifier_imba_witch_doctor_paralyzing_cask:IsPurgable() 		return false end
function modifier_imba_witch_doctor_paralyzing_cask:IsPurgeException() 	return false end
function modifier_imba_witch_doctor_paralyzing_cask:OnCreated()
	if not IsServer() then return end
	local pfx_name = "particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf"
	self.radius = self:GetAbility():GetSpecialValueFor("stun_radius") 
	self.mainParticle = ParticleManager:CreateParticle(pfx_name, PATTACH_POINT_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControlEnt(self.mainParticle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.mainParticle, 1, Vector( self.radius, self.radius, self.radius ) )
			ParticleManager:SetParticleControlEnt(self.mainParticle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.mainParticle, false, false, 0, false, false)	
end
--巫毒疗法
imba_witch_doctor_voodoo_restoration = class({})
LinkLuaModifier("modifier_imba_witch_doctor_voodoo_restoration", "ting/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_witch_doctor_voodoo_debuff", "ting/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)

function imba_witch_doctor_voodoo_restoration:GetBehavior()
	if self:GetCaster():TG_HasTalent("special_bonus_imba_witch_doctor_4")  then
		return DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET 
	end 
end
function imba_witch_doctor_voodoo_restoration:OnSpellStart() 
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_imba_witch_doctor_voodoo_restoration",{duration = self:GetSpecialValueFor("duration"),isCaster = 1 , radius = self:GetSpecialValueFor("radius")}) --参数用来判断持续消蓝
end
function imba_witch_doctor_voodoo_restoration:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	if  self:GetCaster():TG_HasTalent("special_bonus_imba_witch_doctor_4") then 
		cooldown = 0
	end
	return cooldown
end
function imba_witch_doctor_voodoo_restoration:OnToggle()
	if not IsServer() then return end
	local caster = self:GetCaster()
	if self:GetToggleState() then
		caster:AddNewModifier(caster, self, "modifier_imba_witch_doctor_voodoo_restoration", {isCaster = 1,radius = self:GetSpecialValueFor("radius")}) 
	else
        caster:RemoveModifierByName("modifier_imba_witch_doctor_voodoo_restoration")
    end
end


modifier_imba_witch_doctor_voodoo_restoration = class({})
LinkLuaModifier("modifier_imba_witch_doctor_voodoo_debuff", "ting/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_witch_doctor_voodoo_restoration:IsDebuff()			return false end
function modifier_imba_witch_doctor_voodoo_restoration:IsHidden() 			return false end
function modifier_imba_witch_doctor_voodoo_restoration:IsPurgable() 		return false end
function modifier_imba_witch_doctor_voodoo_restoration:IsPurgeException() 	return false end
function modifier_imba_witch_doctor_voodoo_restoration:OnCreated(params)
	if not IsServer() then return end
	EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration", self:GetParent())
	EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetParent())
	local pfx_name = "particles/econ/items/witch_doctor/wd_ti10_immortal_weapon/wd_ti10_immortal_voodoo.vpcf"
	self.isCaster = params.isCaster
	self.per = params.per
	self.radius = params.radius + self:GetCaster():TG_GetTalentValue("special_bonus_imba_witch_doctor_3")
	self.mainParticle = ParticleManager:CreateParticle(pfx_name, PATTACH_POINT_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControlEnt(self.mainParticle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.mainParticle, 1, Vector( self.radius, self.radius, self.radius ) )
			ParticleManager:SetParticleControlEnt(self.mainParticle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.mainParticle, false, false, 0, false, false)	
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("heal_interval"))
end
function modifier_imba_witch_doctor_voodoo_restoration:OnDestroy()
	if IsServer() then
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Off", self:GetParent())
		StopSoundEvent("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetParent())
		self:StartIntervalThink(-1)
	end

end

function modifier_imba_witch_doctor_voodoo_restoration:OnIntervalThink()
	if not IsServer() then return end
	local interval	= self:GetAbility():GetSpecialValueFor("heal_interval")
	local mana_cost = self:GetAbility():GetSpecialValueFor("mana_per_second")*interval
	if self.isCaster == 1 then --thinker参数 不消耗巫医的蓝
	if self:GetCaster():GetMana() >= mana_cost then
		self:GetCaster():SpendMana(mana_cost, self:GetAbility())		
	else
		if self:GetCaster():TG_HasTalent("special_bonus_imba_witch_doctor_4") then
			self:GetAbility():ToggleAbility()
		end
	end
	end
	local heal = (self:GetAbility():GetSpecialValueFor("heal") + self:GetCaster():GetBaseIntellect())*interval
	if self.per ~= nil then 
		heal = heal*self.per
	end
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local sp = 1+math.abs(caster:GetSpellAmplification(false))
	local all = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,ally in pairs(all) do
		if Is_Chinese_TG(ally,caster) then
			ally:Heal(heal*sp, caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, heal*sp, nil)
		else
			ally:AddNewModifier(caster,self:GetAbility(),"modifier_imba_witch_doctor_voodoo_debuff",{duration = interval})
			local damageTable = {
							victim = ally,
							attacker = caster,
							damage = heal,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self:GetAbility(), --Optional.
							}
			ApplyDamage(damageTable)
			
		end
	end
end

modifier_imba_witch_doctor_voodoo_debuff = class({})

function modifier_imba_witch_doctor_voodoo_debuff:IsDebuff()			return true end
function modifier_imba_witch_doctor_voodoo_debuff:IsHidden() 			return false end
function modifier_imba_witch_doctor_voodoo_debuff:IsPurgable() 		return false end
function modifier_imba_witch_doctor_voodoo_debuff:IsPurgeException() 	return false end
function modifier_imba_witch_doctor_voodoo_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE} end
function modifier_imba_witch_doctor_voodoo_debuff:GetModifierHPRegenAmplify_Percentage()
return self.heal_debuff
end
function modifier_imba_witch_doctor_voodoo_debuff:OnCreated()
	self.heal_debuff = self:GetAbility():GetSpecialValueFor("heal_debuff")*-1
end
--死亡咒术
imba_witch_doctor_maledict = class({})
LinkLuaModifier("modifier_maledict_imba_thinker", "ting/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
function imba_witch_doctor_maledict:OnInventoryContentsChanged()
	if not IsServer() then return end
    if self:GetCaster():HasScepter() then 
       self:SetHidden(false)
	   self:SetStolen(true)
       self:SetLevel(1)
    else
			self:SetHidden(true)
			self:SetLevel(0)
			self:SetStolen(true)
    end
end
function imba_witch_doctor_maledict:OnSpellStart() 
	local vPosition = self:GetCursorPosition()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), vPosition, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)
	local pfx_name = "particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_aoe.vpcf"
	local aoe = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl( aoe, 0, vPosition )
		ParticleManager:SetParticleControl( aoe, 1, Vector(radius, radius, radius) )
	if #enemies > 0 then
		EmitSoundOn("Hero_WitchDoctor.Maledict_Cast", caster)
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(caster, self, "modifier_maledict_imba_thinker", {duration = self:GetSpecialValueFor("duration")+0.1})
		end
	else
		EmitSoundOn("Hero_WitchDoctor.Maledict_CastFail", caster)
	end
end

function imba_witch_doctor_maledict:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

modifier_maledict_imba_thinker = class({})
function modifier_maledict_imba_thinker:OnCreated()
	self.time = 0.1
	self.inv = self:GetAbility():GetSpecialValueFor("inv")
	self.slow = self:GetAbility():GetSpecialValueFor("slow")*-1
	local pfx_name = "particles/units/heroes/hero_witchdoctor/witchdoctor_maledict.vpcf"		
	local maledictFX = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_maledict.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl( maledictFX, 1, Vector(2,0,0) )		
	self:AddParticle(maledictFX, false, false, 0, false, false)
	if IsServer() then
		self:StartIntervalThink( self.inv )
	end
	EmitSoundOn("Hero_WitchDoctor.Maledict_Loop", self:GetParent())
end

function modifier_maledict_imba_thinker:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
		if self:GetParent() then
		ApplyDamage(
		{
		victim = self:GetParent(), 
		attacker = self:GetCaster(), 
		damage = (self:GetParent():GetMaxHealth() - self:GetParent():GetHealth())*self:GetAbility():GetSpecialValueFor("damage")*0.01 , 
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION} --不吃法强
		)
			
		StopSoundEvent("Hero_WitchDoctor.Maledict_Loop", self:GetParent())
		end
	end
		
end

function modifier_maledict_imba_thinker:OnIntervalThink()
	self.time = self.time + self.inv
end

function modifier_maledict_imba_thinker:GetStatusEffectName()
	return "particles/status_fx/status_effect_maledict.vpcf"
end

function modifier_maledict_imba_thinker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_maledict_imba_thinker:GetDisableHealing()
	return self.time > self.inv*2 and 1 or 0
end
function modifier_maledict_imba_thinker:GetModifierMoveSpeedBonus_Percentage()
	return self.time > self.inv and self.slow or 0
end
function modifier_maledict_imba_thinker:IsPurgable()
	return false
end
function modifier_maledict_imba_thinker:IsPurgeException()
  return (not self:GetCaster():TG_HasTalent("special_bonus_imba_witch_doctor_8"))
end
function modifier_maledict_imba_thinker:IsHidden()
	return false
end
function modifier_maledict_imba_thinker:IsDebuff()
	return true
end


--法老守卫
imba_witch_doctor_voodoo_switcheroo = class({})
LinkLuaModifier("modifier_death_voodoo_handling", "ting/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_death_voodoo_handling_slow", "ting/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
function imba_witch_doctor_voodoo_switcheroo:GetChannelTime() 
	return 5 + self:GetCaster():TG_GetTalentValue("special_bonus_imba_witch_doctor_5")
end
function imba_witch_doctor_voodoo_switcheroo:OnSpellStart() 
	local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
	local pos = self:GetCursorPosition()
	EmitSoundOn("Hero_WitchDoctor.Death_WardBuild", caster)
	local duration = self:GetSpecialValueFor("duration") + self:GetCaster():TG_GetTalentValue("special_bonus_imba_witch_doctor_5") + 0.1 
	if self:GetCursorTarget() then --对自己用不创造守卫 
		if self:GetCursorTarget() == self:GetCaster() then 
			caster:AddNewModifier(caster,self,"modifier_death_voodoo_handling",{duration = duration })
			caster:Stop()
			return 
		end
	end
	local num = caster:Has_Aghanims_Shard() and self:GetSpecialValueFor("num_shard") or  self:GetSpecialValueFor("num")
	self.ward = {}	--守卫集合 
	for i = 1,num,1 do 
		self.ward[i] = CreateUnitByName("npc_dota_witch_doctor_death_ward", pos, true, caster, caster, caster:GetTeamNumber())
		self.ward[i]:SetOwner(caster)
		self.ward[i]:SetBaseDamageMax( self:GetSpecialValueFor("damage") )
		self.ward[i]:SetBaseDamageMin( self:GetSpecialValueFor("damage") )
		self.ward[i]:AddNewModifier(caster,self,"modifier_death_voodoo_handling",{duration = duration})
		self.ward[i]:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
	end
	if caster:Has_Aghanims_Shard() then --有魔晶就不持续施法
		caster:Stop()
	end
end

function imba_witch_doctor_voodoo_switcheroo:OnChannelFinish()
	if IsServer() then	
		if self.ward then
		if not self:GetCaster():Has_Aghanims_Shard() then --有魔晶就不打断持续施法
			StopSoundEvent("Hero_WitchDoctor.Death_WardBuild", self:GetCaster())
			for _,ward in pairs(self.ward) do
			UTIL_Remove(ward)
			end
		end
		end
	end
end


function imba_witch_doctor_voodoo_switcheroo:OnProjectileHit_ExtraData(target, vLocation, extraData)
	if not IsServer() then return end
	if self.ward then
	for _,ward in pairs(self.ward) do
		if not ward:IsNull() then
			ward:PerformAttack(target, false, true, true, true, false, false, false) --特效击中时 守卫攻击
	--[[		if extraData.bounces_left > 0 and self:GetCaster():Has_Aghanims_Shard() then
				extraData.bounces_left = extraData.bounces_left - 1
				extraData[tostring(target:GetEntityIndex())] = 1
				self:CreateBounceAttack(target, extraData)
			end]]
			self:kno(target,ward)
		end
	end
	
	end
	if extraData.ca == 1 then	 --参数判断 触发特效的是不是施法者  是就往套娃 弹射
			ApplyDamage(
		{
		victim = target, 
		attacker = self:GetCaster(), 
		damage = extraData.damg, 
		damage_type = 1,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,}
		)
		self:kno(target,self:GetCaster())
		if extraData.bounces_left > 0  then
				extraData.bounces_left = extraData.bounces_left - 1	--弹射减1
				extraData[tostring(target:GetEntityIndex())] = 1 --记录当前目标 (设置为1)，不再弹射这个单位 ？ 这个多余ma

				self:CreateBounceAttack(target, extraData)	--弹射
		end		
	end
	
	
end
function imba_witch_doctor_voodoo_switcheroo:kno(target,caster)
	if not IsServer() then return end
	if target then
		local Knockback ={
          should_stun = 0.00, --打断
          knockback_duration = 0.2, --击退时间 减去不能动的时间就是太空步的时间
          duration = 0, --不能动的时间
          knockback_distance = 50,
          knockback_height = 0,	--击退高度
          center_x =  caster:GetAbsOrigin().x,	--施法者为中心
          center_y =  caster:GetAbsOrigin().y,
          center_z =  caster:GetAbsOrigin().z,
		}
	  		target:AddNewModifier(self:GetCaster(), self, "modifier_knockback", Knockback)  --白牛的击退	
			target:AddNewModifier(self:GetCaster(), self, "modifier_death_voodoo_handling_slow", {duration = 0.3})	
	end	
	
end
function imba_witch_doctor_voodoo_switcheroo:CreateBounceAttack(originalTarget, extraData)
    local caster = self:GetCaster()
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), originalTarget:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"),
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
    local target = originalTarget
    for _,enemy in pairs(enemies) do
        if extraData[tostring(enemy:GetEntityIndex())] ~= 1 and  not enemy:IsAttackImmune() and extraData.bounces_left > 0 then	--有弹射次数且目标没被记录就弹
			extraData[tostring(enemy:GetEntityIndex())] = 1
		    local projectile = {
				Target = enemy,
				Source = originalTarget,
				Ability = self,
				EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack.vpcf",
				bDodgable = true,
				bProvidesVision = false,
				iMoveSpeed = 1500,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
				ExtraData = extraData
			}
			ProjectileManager:CreateTrackingProjectile(projectile)
			break
        end
    end
	EmitSoundOn("Hero_Jakiro.Attack" ,originalTarget)
end


modifier_death_voodoo_handling = class({})
LinkLuaModifier("modifier_death_voodoo_handling_slow", "ting/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
function modifier_death_voodoo_handling:OnCreated()
	if not IsServer() then return end
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	
	if self:GetParent()~= self:GetCaster() then
	self.wardParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_ward_skull.vpcf", PATTACH_POINT_FOLLOW, self:GetParent()) 
		ParticleManager:SetParticleControlEnt(self.wardParticle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.wardParticle, 2, self:GetParent():GetAbsOrigin())
		self:AddParticle(self.wardParticle, false, false, 15, false, false)
		self:StartIntervalThink( self:GetAbility():GetSpecialValueFor("intv") )
		self.damage = 0
	end
end

function modifier_death_voodoo_handling:OnIntervalThink()
	if IsServer() then
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 1, false)
		local bounces = 0
		--if self:GetCaster():Has_Aghanims_Shard() then bounces = 3 end
		for _, unit in pairs(units) do
			local projectile = {
				Target = unit,
				Source = self:GetParent(),
				Ability = self:GetAbility(),
				EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack.vpcf",
				bDodgable = true,
				bProvidesVision = false,
				iMoveSpeed = self:GetParent():GetProjectileSpeed(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
				ExtraData = {bounces_left = bounces, [tostring(unit:GetEntityIndex())] = 1}  --用计时器抹模拟守卫的攻击 记录弹射次数和当前单位
			}
			EmitSoundOn("Hero_WitchDoctor_Ward.Attack", self:GetParent())
			ProjectileManager:CreateTrackingProjectile(projectile)
			break
		end
	end
end
function modifier_death_voodoo_handling:DeclareFunctions() return {MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE} end
function modifier_death_voodoo_handling:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if self:GetCaster() ~= self:GetParent() or self:GetCaster():IsChanneling() then return  end
	if keys.attacker ~= self:GetParent() or keys.target:IsOther()  or not keys.target:IsAlive() then
		return
	end
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), keys.target:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 1, false)
		local bounces = 3
		for _, unit in pairs(units) do
			if unit ~= keys.target then 
			local projectile = {
				Target = unit,
				Source = keys.target,
				Ability = self:GetAbility(),
				EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_ward_attack.vpcf",
				bDodgable = true,
				bProvidesVision = false,
				iMoveSpeed = self:GetParent():GetProjectileSpeed(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
				ExtraData = {damg = keys.original_damage,ca = 1,bounces_left = bounces, [tostring(keys.target:GetEntityIndex())] = 1,[tostring(unit:GetEntityIndex())] = 1} --人的攻击 不弹被攻击的这个人
			}
			EmitSoundOn("Hero_WitchDoctor_Ward.Attack", self:GetParent())
			ProjectileManager:CreateTrackingProjectile(projectile)
			break
			end
		end
		if keys.target then
		local Knockback ={
          should_stun = 0.00, --打断
          knockback_duration = 0.2, --击退时间 减去不能动的时间就是太空步的时间
          duration = 0, --不能动的时间
          knockback_distance = 50,
          knockback_height = 0,	--击退高度
          center_x =  self:GetCaster():GetAbsOrigin().x,	--施法者为中心
          center_y =  self:GetCaster():GetAbsOrigin().y,
          center_z =  self:GetCaster():GetAbsOrigin().z,
		}
	  		keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", Knockback)  --白牛的击退	
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_death_voodoo_handling_slow", {duration = 0.3}) 	
		end			
end
function modifier_death_voodoo_handling:OnDestroy()
	if IsServer() then
		if self:GetParent()~= self:GetCaster() then
		UTIL_Remove(self:GetParent())
		end
		self.ward = nil
	end
end
function modifier_death_voodoo_handling:CheckState()
	local state = {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	if self:GetParent() == self:GetCaster() then
		state = {}
	end
	return state
end
function modifier_death_voodoo_handling:GetEffectName()
	return "particles/econ/events/diretide_2020/emblem/fall20_emblem_v3_effect.vpcf"
end
function modifier_death_voodoo_handling:IsHidden()
	return false
end
function modifier_death_voodoo_handling:IsPurgable()
	return false
end
function modifier_death_voodoo_handling:IsPurgeException()
	return false
end

function modifier_death_voodoo_handling:GetModifierPreAttack_BonusDamage()
	return self.damage
end
modifier_death_voodoo_handling_slow = class({})
function modifier_death_voodoo_handling_slow:OnCreated()
	self.slow = self:GetAbility():GetSpecialValueFor("slow")*-1
end
function modifier_death_voodoo_handling_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end
function modifier_death_voodoo_handling_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow 
end

function modifier_death_voodoo_handling_slow:IsHidden()
	return true
end
--巫蛊之舞
imba_witch_doctor_death_ward = class({})
LinkLuaModifier("modifier_death_ward_handling", "ting/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_witch_doctor_voodoo_restoration", "ting/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_death_ward_bkb", "ting/hero_witch_doctor", LUA_MODIFIER_MOTION_NONE)
function imba_witch_doctor_death_ward:OnSpellStart() 
	local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    local pos = self:GetCursorPosition()
    local duration = self:GetChannelTime() + 1
	local hp = self:GetSpecialValueFor("hp")+caster:TG_GetTalentValue("special_bonus_imba_witch_doctor_6")
	EmitSoundOn("Hero_WitchDoctor.Death_WardBuild", caster)
	if caster:TG_HasTalent("special_bonus_imba_witch_doctor_7") then
		caster:AddNewModifier(caster,self,"modifier_death_ward_bkb",{duration = duration}) --天赋魔免
	end
    self.death_ward=CreateUnitByName("npc_dota_witch_doctor_death_ward", pos, true, caster, caster, caster:GetTeamNumber())
		self.death_ward:SetOwner(caster)
		self.death_ward:SetBaseMaxHealth(hp)
		self.death_ward:SetMaxHealth(hp)
		self.death_ward:SetHealth(hp)
    --self.death_ward:AddNewModifier(caster, self, "modifier_plague_ward", {duration=duration})
    --self.death_ward:AddNewModifier(caster, self, "modifier_kill", {duration=duration})
	
	local ab = caster:FindAbilityByName("imba_witch_doctor_voodoo_restoration")
	if ab and ab:GetLevel() > 0 then
		self.death_ward:AddNewModifier(caster,ab,"modifier_imba_witch_doctor_voodoo_restoration",{duration = duration ,isCaster = 0 , per = self:GetSpecialValueFor("per") , radius = self:GetSpecialValueFor("heal_radius")})
	end
	
	self.death_ward:AddNewModifier(caster,self,"modifier_death_ward_handling",{duration = duration})
    self.death_ward:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
	
end

function imba_witch_doctor_death_ward:OnChannelFinish()
	if IsServer() then		
		StopSoundEvent("Hero_WitchDoctor.Death_WardBuild", self:GetCaster())
		self:GetCaster():RemoveModifierByName("modifier_death_ward_bkb")
		UTIL_Remove(self.death_ward)	
	end
end

function imba_witch_doctor_death_ward:OnProjectileHit_ExtraData(target, vLocation, extraData)
	if not IsServer() then return end
	if not self.death_ward:IsNull() then	
		if not target:IsMagicImmune() then
			target:AddNewModifier(self:GetCaster(),self,"modifier_imba_stunned",{duration = self:GetSpecialValueFor("stun")})
		end
		if self:GetCaster():HasModifier("modifier_item_monkey_king_bar_v2_pa") then
			local mod = self:GetCaster():FindModifierByName("modifier_item_monkey_king_bar_v2_pa") 
			if mod then 
				mod.miss = true 
				self:GetCaster():PerformAttack(target, true, true, true, false, false, false, true)
				mod.miss = false
			end
		else
			self:GetCaster():PerformAttack(target, true, true, true, false, false, false, true)		
		end
	end
end


modifier_death_ward_handling = class({})

function modifier_death_ward_handling:OnCreated()
	self.wardParticle = ParticleManager:CreateParticle("particles/econ/items/witch_doctor/witch_doctor_ribbitar/witchdoctor_ribbitar_ward_skull.vpcf", PATTACH_POINT_FOLLOW, self:GetParent()) 
		ParticleManager:SetParticleControlEnt(self.wardParticle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.wardParticle, 2, self:GetParent():GetAbsOrigin())
	if IsServer() then
		self:StartIntervalThink( self:GetAbility():GetSpecialValueFor("inv") )
	end
end

function modifier_death_ward_handling:OnIntervalThink()
	if IsServer() then
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 1, false)
		for _, unit in pairs(units) do
			local projectile = {
				Target = unit,
				Source = self:GetParent(),
				Ability = self:GetAbility(),
				EffectName = "particles/econ/items/witch_doctor/wd_ti8_immortal_bonkers/wd_ti8_immortal_bonkers_cask.vpcf",
				bDodgable = true,
				bProvidesVision = false,
				iMoveSpeed = self:GetParent():GetProjectileSpeed(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
			}
			EmitSoundOn("Hero_WitchDoctor_Ward.Attack", self:GetParent())
			ProjectileManager:CreateTrackingProjectile(projectile)
		end
	end
end
function modifier_death_ward_handling:CheckState()
    return 
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end

function modifier_death_ward_handling:OnAttackLanded(keys)
    if not IsServer() then
        return
	end  
    if  keys.target == self:GetParent() then
        if self:GetParent():GetHealth()>0 then
        self:GetParent():SetHealth(self:GetParent():GetHealth() - 1) 
        elseif self:GetParent():GetHealth()<=0 then
        self:GetParent():Kill(self:GetAbility(), keys.attacker)
		self:GetCaster():Stop()
        end
    end
end
function modifier_death_ward_handling:OnDestroy()
	if IsServer() then
		StopSoundEvent("Hero_WitchDoctor.Death_WardBuild", self:GetCaster())
		UTIL_Remove(self:GetParent())
		self:GetCaster():Stop()
	end
end

function modifier_death_ward_handling:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,        
		MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, 
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, 
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE, 
        MODIFIER_PROPERTY_DISABLE_HEALING, 
    } 
end

function modifier_death_ward_handling:GetModifierModelChange() 
    return "models/items/witchdoctor/wd_ward/ribbitar_ward/ribbitar_ward.vmdl"
end

function modifier_death_ward_handling:GetDisableHealing() 
    return 1 
end

function modifier_death_ward_handling:GetAbsoluteNoDamageMagical() 
    return 1 
end

function modifier_death_ward_handling:GetAbsoluteNoDamagePhysical() 
    return 1 
end

function modifier_death_ward_handling:GetAbsoluteNoDamagePure() 
    return 1 
end
function modifier_death_ward_handling:IsHidden()
    return true
end

--天赋魔免
modifier_death_ward_bkb = class({})
function modifier_death_ward_bkb:IsHidden() return true end
function modifier_death_ward_bkb:IsPurgable() return false end
function modifier_death_ward_bkb:IsPurgeException() return false end
function modifier_death_ward_bkb:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true } end
