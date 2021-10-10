item_imba_relic_chip = class({})
LinkLuaModifier("modifier_imba_relic_chip_passive", "ting/items/item_relic_chip", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_relic", "ting/items/item_relic_chip", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_relic_rad", "ting/items/item_relic_chip", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_relic_dir", "ting/items/item_relic_chip", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_relic_effect", "ting/items/item_relic_chip", LUA_MODIFIER_MOTION_HORIZONTAL)
function item_imba_relic_chip:GetIntrinsicModifierName() return "modifier_imba_relic_chip_passive" end
function item_imba_relic_chip:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local target = self:GetCursorTarget()
	local duration_1 = self:GetSpecialValueFor("duration_1")
	local duration_2 = self:GetSpecialValueFor("duration_2")
	local base_att = self:GetSpecialValueFor("base_att")
	local base_hp = self:GetSpecialValueFor("base_hp")
	local att_minute = self:GetSpecialValueFor("att_minute")
	local hp_minute = self:GetSpecialValueFor("hp_minute")
	local time_minute = math.ceil(GameRules:GetGameTime()/60)

	self.particle	= ParticleManager:CreateParticleForTeam("particles/items4_fx/meteor_hammer_aoe.vpcf", PATTACH_WORLDORIGIN, caster, caster:GetTeam())
	ParticleManager:SetParticleControl(self.particle, 0, pos)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(400, 1, 1))



	--ParticleManager:FireParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", PATTACH_POINT, caster:GetOwner(), {[0] = point})
  -- 	ParticleManager:FireParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_magical.vpcf", PATTACH_POINT, caster, {[0] = point})
		EmitSoundOn("DOTA_Item.MeteorHammer.Channel", caster)
		self.particle3	= ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(self.particle3, 0, pos + Vector(0, 0, 1000)) -- 1000 feels kinda arbitrary but it also feels correct
		ParticleManager:SetParticleControl(self.particle3, 1, pos)
		ParticleManager:SetParticleControl(self.particle3, 2, Vector(0.6, 0, 0))
		ParticleManager:ReleaseParticleIndex(self.particle3)

	Timers:CreateTimer(0.6, function()
			ParticleManager:DestroyParticle(self.particle, true)
			if not self:IsNull() then
				local duration = 0
				EmitSoundOnLocationWithCaster(pos, "DOTA_Item.MeteorHammer.Impact", caster)
				if target  and IsValidEntity(target) and target:GetUnitName() ~= "npc_dota_r_d" and not target:IsBoss() and not target:IsHero() then
					duration = duration_1
					local new_lane_creep = CreateUnitByName(target:GetUnitName(), target:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
					new_lane_creep:SetBaseMaxHealth(math.max(target:GetMaxHealth(),1000))
					new_lane_creep:SetHealth(math.max(target:GetHealth(),1000))
					new_lane_creep:SetBaseDamageMin(target:GetBaseDamageMin())
					new_lane_creep:SetBaseDamageMax(target:GetBaseDamageMax())
					new_lane_creep:SetMinimumGoldBounty(target:GetGoldBounty())
					new_lane_creep:SetMaximumGoldBounty(target:GetGoldBounty())
					new_lane_creep:SetPhysicalArmorBaseValue(15)
					new_lane_creep:SetBaseMagicalResistanceValue(40)
					target:AddNoDraw()
					target:ForceKill(false)
					target = new_lane_creep
					else
						duration = duration_2
						target = CreateUnitByName("npc_dota_r_d", pos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
						target:SetHasInventory(false)
						target:SetCanSellItems(false)
						target:SetBaseMaxHealth(base_hp+hp_minute*time_minute)
						target:SetMaxHealth(base_hp+hp_minute*time_minute)

						target:SetBaseDamageMin(base_att+att_minute*time_minute)
						target:SetBaseDamageMax(base_att+att_minute*time_minute)
					if caster:GetTeamNumber() ~= 2 then
					--target:AddNewModifier(caster, self, "modifier_relic_rad", {duration = self:GetSpecialValueFor("duration")+7})
					--else
						target:AddNewModifier(caster, self, "modifier_relic_dir", {duration = duration+7})
				end
				end

				target:SetOwner(self:GetCaster())
				target:SetTeam(self:GetCaster():GetTeam())
				target:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
				target:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
				target:AddNewModifier(caster, self, "modifier_relic", {duration = duration})
				target:SetBaseMoveSpeed(500)
				target:SetHealth(20000)

	
				target:AddNewModifier(caster, self, "modifier_relic_effect", {duration = duration})

			end

			end)
	--self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_titan_yidong", {ent_index = self:GetCursorTarget():GetEntityIndex()})


	--[[
	local particle= ParticleManager:CreateParticle("particles/items4_fx/meteor_relic_spell_ground_impact.vpcf", PATTACH_ABSORIGIN,caster)
    ParticleManager:SetParticleControl(particle, 0,point)
    ParticleManager:SetParticleControl(particle, 1,Vector(255,255,255))
    ParticleManager:SetParticleControl(particle, 2,Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
    ParticleManager:SetParticleControl(particle, 3,point)
    ParticleManager:ReleaseParticleIndex( particle )
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		for _, hero in pairs(heroes) do
		local distance = (point - hero:GetAbsOrigin()):Length2D()
		if hero:IsInvulnerable() then return end
		if not hero:IsMagicImmune() then
		end
			local modifier = hero:AddNewModifier(caster,self,"modifier_imba_relic_chip_arrmorb",{duration = self:GetSpecialValueFor("duration")})
			modifier:SetStackCount(math.min(100,100 - math.ceil(caster:GetStrength()/self:GetSpecialValueFor("strbb"))))

				local damageTable = {
                                    victim = hero,
                                    attacker = caster,
                                    damage = caster:GetStrength()*self:GetSpecialValueFor("strd"),
                                    damage_type =DAMAGE_TYPE_PHYSICAL,
                                    damage_flags = DOTA_UNIT_TARGET_FLAG_NONE,
                                    ability = self,
                                    }
                            ApplyDamage(damageTable)

		end
		]]--
end

--models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_mega_crystal.vmdl
--models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_mega_crystal.vmdl
modifier_relic = class({})
LinkLuaModifier("modifier_relic_buff", "ting/items/item_relic_chip", LUA_MODIFIER_MOTION_NONE)
function modifier_relic:IsDebuff()			return false end
function modifier_relic:IsHidden() 			return true end
function modifier_relic:IsPurgable() 		return false end
function modifier_relic:IsPurgeException() 	return false end
function modifier_relic:IsAura() return true end
function modifier_relic:GetModifierAura() return "modifier_relic_buff" end
function modifier_relic:GetAuraRadius() return 900 end
function modifier_relic:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_relic:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_relic:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC end

function modifier_relic:CheckState()
	return {[MODIFIER_STATE_DOMINATED] = true}
end

modifier_relic_effect = class({})
function modifier_relic_effect:IsDebuff()			return false end
function modifier_relic_effect:IsHidden() 			return true end
function modifier_relic_effect:IsPurgable() 		return false end
function modifier_relic_effect:IsPurgeException() 	return false end
function modifier_relic_effect:RemoveOnDeath() 	return false end
function modifier_relic_effect:OnCreated()
	local particle= ParticleManager:CreateParticle(self:GetParent():GetTeamNumber() == 2  and "particles/items/titan_hammer/hammer_buff.vpcf" or "particles/items5_fx/helm_of_the_dominator_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
    ParticleManager:SetParticleControl(particle, 0,self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1,self:GetParent():GetAbsOrigin())
    self:AddParticle(particle, false, false, 4, false, false)
end

modifier_relic_rad = class({})
function modifier_relic_rad:IsDebuff()			return false end
function modifier_relic_rad:IsHidden() 			return true end
function modifier_relic_rad:IsPurgable() 		return false end
function modifier_relic_rad:IsPurgeException() 	return false end
function modifier_relic_rad:RemoveOnDeath() 	return false end
function modifier_relic_rad:DeclareFunctions() return {MODIFIER_PROPERTY_MODEL_CHANGE} end
function modifier_relic_rad:GetModifierModelChange()	return "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_mega_crystal.vmdl" end
--function modifier_relic_rad:GetEffectName()	return "particles/items/relic_chip/relic_buff.vpcf" end

modifier_relic_dir = class({})
function modifier_relic_dir:IsDebuff()			return false end
function modifier_relic_dir:IsHidden() 			return true end
function modifier_relic_dir:IsPurgable() 		return false end
function modifier_relic_dir:IsPurgeException() 	return false end
function modifier_relic_dir:RemoveOnDeath() 	return false end
function modifier_relic_dir:DeclareFunctions() return {MODIFIER_PROPERTY_MODEL_CHANGE} end
function modifier_relic_dir:GetModifierModelChange()	return "models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_mega_crystal.vmdl" end
--function modifier_relic_dir:GetEffectName()	return "particles/items5_fx/helm_of_the_dominator_buff.vpcf" end

--buff
modifier_relic_buff = class({})
function modifier_relic_buff:IsDebuff()			return false end
function modifier_relic_buff:IsHidden() 			return false end
function modifier_relic_buff:IsPurgable() 		return false end
function modifier_relic_buff:IsPurgeException() 	return false end
function modifier_relic_buff:DeclareFunctions() return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,MODIFIER_PROPERTY_MODEL_SCALE,MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end
function modifier_relic_buff:GetTexture()			return "item_relic_chip" end
function modifier_relic_buff:CheckState()
	return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
end

function modifier_relic_buff:OnCreated()
	if self:GetAbility() == nil then
		return
	end

	self.ab = self:GetAbility()
	self.parent = self:GetParent()
	self.health = self.parent:GetMaxHealth()
	self.hp_min = self.ab:GetSpecialValueFor("hp_min")
	self.hp_max = math.max(self.ab:GetSpecialValueFor("hp_max"),self.health)
	self.hp = math.min(math.max(self.parent:GetMaxHealth()*self.ab:GetSpecialValueFor("hp")*0.01,self.hp_min),self.hp_max)

	self.armor = self.ab:GetSpecialValueFor("armor")
	self.damage_b = self.ab:GetSpecialValueFor("damage_b")
	self.damage_ex = self.ab:GetSpecialValueFor("damage_ex")
	self.att_sp = self.ab:GetSpecialValueFor("att_sp")
end

function modifier_relic_buff:GetModifierExtraHealthBonus()
	return self.hp
end
function modifier_relic_buff:GetModifierBaseAttack_BonusDamage()
	return self.damage_b
end
function modifier_relic_buff:GetModifierPhysicalArmorBonus()
	return self.armor
end
function modifier_relic_buff:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_ex
end
function modifier_relic_buff:GetModifierAttackSpeedBonus_Constant()
	return self.att_sp
end --GetModifierBaseDamageOutgoing_Percentage

function modifier_relic_buff:GetModifierModelScale()
	return 50
end


modifier_imba_relic_chip_passive = class({})

function modifier_imba_relic_chip_passive:IsDebuff()			return false end
function modifier_imba_relic_chip_passive:IsHidden() 			return true end
function modifier_imba_relic_chip_passive:IsPurgable() 		return false end
function modifier_imba_relic_chip_passive:IsPurgeException() 	return false end
function modifier_imba_relic_chip_passive:DeclareFunctions() return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,MODIFIER_EVENT_ON_ATTACK_LANDED,MODIFIER_PROPERTY_MANA_REGEN_CONSTANT} end
function modifier_imba_relic_chip_passive:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.duration = self.ab:GetSpecialValueFor("duration")
	self.str = self.ab:GetSpecialValueFor("str")
	self.att = self.ab:GetSpecialValueFor("damage")
	self.hpre = self.ab:GetSpecialValueFor("hpre")
	self.mare = self.ab:GetSpecialValueFor("manare")
end
function modifier_imba_relic_chip_passive:GetModifierConstantHealthRegen()
	return self.hpre
end
function modifier_imba_relic_chip_passive:GetModifierConstantManaRegen()
	return self.mare
end
function modifier_imba_relic_chip_passive:GetModifierBonusStats_Strength()
	return self.str
end
function modifier_imba_relic_chip_passive:GetModifierPreAttack_BonusDamage()
	return self.att
end
