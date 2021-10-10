item_imba_seer_of_disk = class({})
LinkLuaModifier("modifier_seer_of_disk_passive", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_relic_cd", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_seer_vision", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_seer_vision_think", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_HORIZONTAL)
function item_imba_seer_of_disk:GetIntrinsicModifierName() return "modifier_seer_of_disk_passive" end
function item_imba_seer_of_disk:GetAOERadius() return 600 end
function item_imba_seer_of_disk:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local duration_1 = self:GetSpecialValueFor("duration_1")
	local duration_2 = self:GetSpecialValueFor("duration_2")
	local radius = self:GetSpecialValueFor("radius")
	caster:EmitSound("Item.CrimsonGuard.Cast")
	local target = CreateModifierThinker(caster, self, "modifier_seer_vision_think", {duration = duration_1+0.5}, pos, caster:GetTeamNumber(), false)
	AddFOWViewer(caster:GetTeamNumber(), pos, radius,duration_1 , false)
	
	local enemy = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,e in pairs(enemy)  do
			if e:IsInvisible() then
				local mod = e:AddNewModifier(caster, self, "modifier_seer_vision", {duration = duration_2})
				mod:SetStackCount(1)
			end
			e:AddNewModifier(caster, self, "modifier_seer_vision", {duration = duration_1})
		end
		
		
		--ParticleManager:ReleaseParticleIndex(self.particle4
	--ParticleManager:FireParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", PATTACH_POINT, caster:GetOwner(), {[0] = point})
  -- 	ParticleManager:FireParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_magical.vpcf", PATTACH_POINT, caster, {[0] = point})


	
	
	--self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_titan_yidong", {ent_index = self:GetCursorTarget():GetEntityIndex()})
	
	
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
			local modifier = hero:AddNewModifier(caster,self,"modifier_seer_of_disk_arrmorb",{duration = self:GetSpecialValueFor("duration")})
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
modifier_seer_vision_think = class({})

function modifier_seer_vision_think:IsDebuff()			return true end
function modifier_seer_vision_think:IsHidden() 			return false end
function modifier_seer_vision_think:IsPurgable() 		return true end
function modifier_seer_vision_think:IsPurgeException() 	return true end
function modifier_seer_vision_think:OnCreated()
	if self:GetAbility() == nil then return end
	self.parent = self:GetParent()
	self.ab = self:GetAbility()
	self.radius = self.ab:GetSpecialValueFor("radius")
	if IsServer() then
		self.particle4	= ParticleManager:CreateParticle("particles/items/disk/disk_pfx0.vpcf", PATTACH_WORLDORIGIN, self.parent)		
		ParticleManager:SetParticleControl(self.particle4, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle4, 1, Vector(self.radius, self.radius, 0))
	end
end

function modifier_seer_vision_think:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle4, true)
	end
end
modifier_seer_vision = class({})

function modifier_seer_vision:IsDebuff()			return true end
function modifier_seer_vision:IsHidden() 			return false end
function modifier_seer_vision:IsPurgable() 		return false end
function modifier_seer_vision:IsPurgeException() 	return false end
function modifier_seer_vision:GetTexture()			return "item_seer_of_disk" end
function modifier_seer_vision:DeclareFunctions()	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_seer_vision:GetModifierMoveSpeedBonus_Percentage() return	self.movespeed*self:GetStackCount()	end
function modifier_seer_vision:CheckState() return {[MODIFIER_STATE_PROVIDES_VISION] = true,[MODIFIER_STATE_INVISIBLE] = false} end
function modifier_seer_vision:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA 
end

function modifier_seer_vision:OnCreated()
	if IsServer() and self:GetAbility()~= nil then
		self.movespeed = self:GetAbility():GetSpecialValueFor("movespeed")
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare_sparks.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end

--models/creeps/lane_creeps/creep_radiant_melee/radiant_melee_mega_crystal.vmdl
--models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_mega_crystal.vmdl


modifier_relic_cd = class({})
function modifier_relic_cd:IsDebuff()			return true end
function modifier_relic_cd:IsHidden() 			return false end
function modifier_relic_cd:IsPurgable() 		return false end
function modifier_relic_cd:IsPurgeException() 	return false end
function modifier_relic_cd:RemoveOnDeath() 	return false end
function modifier_relic_cd:GetTexture()			return "item_seer_of_disk" end

--function modifier_relic_cd:GetEffectName()	return "particles/items5_fx/helm_of_the_dominator_buff.vpcf" end



modifier_seer_of_disk_passive = class({})
LinkLuaModifier("modifier_relic_cd", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_NONE)
function modifier_seer_of_disk_passive:IsDebuff()			return false end
function modifier_seer_of_disk_passive:IsHidden() 			return true end
function modifier_seer_of_disk_passive:IsPurgable() 		return false end
function modifier_seer_of_disk_passive:IsPurgeException() 	return false end
function modifier_seer_of_disk_passive:DeclareFunctions() return {MODIFIER_PROPERTY_STATUS_RESISTANCE,MODIFIER_PROPERTY_MANA_BONUS,MODIFIER_PROPERTY_HEALTH_BONUS,MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,} end
function modifier_seer_of_disk_passive:OnCreated()
	if self:GetAbility() == nil then return end
	self.ab = self:GetAbility()
	self.parent = self:GetParent()
	self.hp_l= self.ab:GetSpecialValueFor("hp_l")
	self.duration = self.ab:GetSpecialValueFor("duration")
	self.cd_duration = self.ab:GetSpecialValueFor("cd_duration")
	self.hp = self.ab:GetSpecialValueFor("hp")
	self.mp = self.ab:GetSpecialValueFor("mp")
	self.stat = self.ab:GetSpecialValueFor("stat")
end
function modifier_seer_of_disk_passive:GetModifierHealthBonus() 			return self.hp end
function modifier_seer_of_disk_passive:GetModifierManaBonus() 			return self.mp end
function modifier_seer_of_disk_passive:GetModifierStatusResistance() 			return self.stat end


function modifier_seer_of_disk_passive:GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() or keys.target ~= self.parent then return end

	if keys.attacker:IsHero() and  not self.parent:HasModifier("modifier_relic_cd") and not self.parent:HasModifier("modifier_item_aeon_disk_buff") and not self.parent:IsIllusion() then
		--local buff_duration = ability:GetSpecialValueFor("buff_duration")

		--local buff_cooldown = ability:GetSpecialValueFor("aeon_disk_cooldown")
		--print("item_imba_hurricane_lance_unique",keys.damage) 800 + 1000  小于伤害+阈值 小于阈值
		if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and self.parent:GetHealth() - keys.damage  < self.hp_l then
			if self.parent:GetHealth() >= self.hp_l then 
				self.parent:SetHealth(self.hp_l)
			end 
				self.parent:EmitSound("DOTA_Item.ComboBreaker")
				self.parent:Purge( false, true, false, true, true )
				self.parent:AddNewModifier(self.parent, self.ab, "modifier_item_aeon_disk_buff", {duration = self.duration})	
				self.parent:AddNewModifier(self.parent, self.ab, "modifier_relic_cd", {duration = self.cd_duration*self.parent:GetCooldownReduction()})	
			return -100
		end
	end
end

item_imba_crown = class({})
LinkLuaModifier("modifier_item_king_light", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_king_miss", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_king_passive", "ting/items/item_seer_of_disk", LUA_MODIFIER_MOTION_NONE)

function item_imba_crown:GetIntrinsicModifierName() return "modifier_item_king_passive" end
function item_imba_crown:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	self:GetCaster():EmitSound("Item.CrimsonGuard.Cast")
	    local pfx = ParticleManager:CreateParticle("particles/items/disk/disk_pfx_7.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(pfx, 0, pos)		
		ParticleManager:ReleaseParticleIndex(pfx)
		
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_item_dustofappearance",{duration = self:GetSpecialValueFor("duration")})		
	end
	
end

modifier_item_king_passive = class({})
function modifier_item_king_passive:IsDebuff()			return false end
function modifier_item_king_passive:IsHidden() 			return true end
function modifier_item_king_passive:IsPurgable() 		return false end
function modifier_item_king_passive:IsPurgeException() 	return false end
function modifier_item_king_passive:OnCreated()
	if self:GetAbility()==nil then 
		return
	end 
	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.hp = self:GetAbility():GetSpecialValueFor("bonus_hp")
end
function modifier_item_king_passive:OnDestroy()
	self.bonus_all_stats = nil 
	self.hp = nil
end
function modifier_item_king_passive:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_BONUS,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end
function modifier_item_king_passive:GetModifierBonusStats_Intellect() return self.bonus_all_stats end
function modifier_item_king_passive:GetModifierBonusStats_Agility() return self.bonus_all_stats end
function modifier_item_king_passive:GetModifierBonusStats_Strength() return self.bonus_all_stats end
function modifier_item_king_passive:GetModifierHealthBonus() return self.hp end




