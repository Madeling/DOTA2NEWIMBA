--阿托斯v1 
item_imba_atos = class({})
LinkLuaModifier("modifier_item_imba_atos_passive", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_atos_root", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_atos_root_v1", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_atos_roo_shackle", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_atos_shackle_cd", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
function item_imba_atos:GetIntrinsicModifierName() return "modifier_item_imba_atos_passive" end
function item_imba_atos:OnSpellStart()
	self.caster	= self:GetCaster()
	self.duration =	self:GetSpecialValueFor("duration")
	self.projectile_speed = self:GetSpecialValueFor("projectile_speed")
	local caster_location	= self.caster:GetAbsOrigin()
	local target			= self:GetCursorTarget()
	local projectile =
		{
			Target 				= target,
			Source 				= self.caster,
			Ability 			= self,
			EffectName 			= "particles/items2_fx/rod_of_atos_attack.vpcf",
			iMoveSpeed			= 1200,
			vSourceLoc 			= caster_location,
			bDrawsOnMinimap 	= false,
			bDodgeable 			= true,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			bProvidesVision 	= false,
		}
		TG_CreateProjectile({id=1,team=self.caster:GetTeamNumber(),owner=self.caster,p=projectile})
end

function item_imba_atos:OnProjectileHit(target, location)
	self.caster:TG_IS_ProjectilesValue(function()
		target=nil
  	end)
	if target and not target:IsMagicImmune() then
		if target:TriggerSpellAbsorb(self) then return nil end


		target:EmitSound("DOTA_Item.RodOfAtos.Target")

		target:AddNewModifier_RS(self.caster,self,"modifier_item_imba_atos_root",{duration =self:GetSpecialValueFor("duration")})
		target:AddNewModifier_RS(self.caster,self,"modifier_item_imba_atos_root_v1",{duration =self:GetSpecialValueFor("duration")})
	local maxc = self:GetSpecialValueFor("stack")
	local a = 0
	if not self.caster:HasModifier("modifier_item_imba_atos_shackle_cd") then 
	 enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for k = #enemies,1,-1 do		
				if enemies[k]~= nil and a<maxc and enemies[k] ~= target 
							and not enemies[k]:IsMagicImmune() 
							and not enemies[k]:IsInvisible() and not enemies[k]:IsInvulnerable() then a=a+1
		enemies[k]:AddNewModifier_RS(target,self,"modifier_item_imba_atos_roo_shackle",{duration =self:GetSpecialValueFor("duration")})
		--target:AddNewModifier(self.caster,self,"modifier_item_imba_atos_root_caster",{duration =self:GetSpecialValueFor("duration")})
		self.caster:AddNewModifier(self.caster,self,"modifier_item_imba_atos_shackle_cd",{duration = self:GetCooldownTimeRemaining()})
		end
	end
	end
	if a<maxc and target:HasModifier("modifier_item_imba_atos_root_v1") then
		local modifier = target:FindModifierByName("modifier_item_imba_atos_root_v1")
		modifier:SetStackCount(modifier:GetStackCount()+(maxc-a))
	end
end
end



---阿托斯v1
item_imba_atos_v1 = class({})
LinkLuaModifier("modifier_item_imba_atos_passive_v1", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_atos_root", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_atos_root_v1", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_atos_roo_shackle", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_atos_shackle_cd", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
function item_imba_atos_v1:GetIntrinsicModifierName() return "modifier_item_imba_atos_passive_v1" end
function item_imba_atos_v1:OnSpellStart()
	self.caster	= self:GetCaster()
	self.duration =	self:GetSpecialValueFor("duration")
	self.projectile_speed = self:GetSpecialValueFor("projectile_speed")
	local caster_location	= self.caster:GetAbsOrigin()
	local target			= self:GetCursorTarget()
		local projectile =
		{
			Target 				= target,
			Source 				= self.caster,
			Ability 			= self,
			EffectName 			= "particles/items2_fx/rod_of_atos_attack.vpcf",
			iMoveSpeed			= 1200,
			vSourceLoc 			= caster_location,
			bDrawsOnMinimap 	= false,
			bDodgeable 			= true,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			bProvidesVision 	= false,
		}
		TG_CreateProjectile({id=1,team=self.caster:GetTeamNumber(),owner=self.caster,p=projectile})

	
end
-- -createhero jugg enemy
function item_imba_atos_v1:OnProjectileHit(target, location)
	self.caster:TG_IS_ProjectilesValue(function()
		target=nil
  	end)
	if target and not target:IsMagicImmune() then
		if target:TriggerSpellAbsorb(self) then return nil end

		target:EmitSound("DOTA_Item.RodOfAtos.Target")
	

		target:AddNewModifier_RS(self.caster,self,"modifier_item_imba_atos_root",{duration =self:GetSpecialValueFor("duration")})
		target:AddNewModifier_RS(self.caster,self,"modifier_item_imba_atos_root_v1",{duration =self:GetSpecialValueFor("duration")})
		
	local maxc = self:GetSpecialValueFor("stack")
	local a = 0
	if not self.caster:HasModifier("modifier_item_imba_atos_shackle_cd") then 
	 enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for  k = #enemies,1,-1 do		
				if enemies[k]~= nil and a<maxc and enemies[k] ~= target 
							and not enemies[k]:IsMagicImmune() 
							and not enemies[k]:IsInvisible() and not enemies[k]:IsInvulnerable() then a=a+1
		enemies[k]:AddNewModifier_RS(target,self,"modifier_item_imba_atos_roo_shackle",{duration =self:GetSpecialValueFor("duration")})
		--target:AddNewModifier(self.caster,self,"modifier_item_imba_atos_root_caster",{duration =self:GetSpecialValueFor("duration")})
		self.caster:AddNewModifier(self.caster,self,"modifier_item_imba_atos_shackle_cd",{duration = self:GetCooldownTimeRemaining()})
		end
	end
	end
		if a<maxc and target:HasModifier("modifier_item_imba_atos_root_v1") then
		local modifier = target:FindModifierByName("modifier_item_imba_atos_root_v1")
		modifier:SetStackCount(modifier:GetStackCount()+(maxc-a))
	end	
end

end


-----阿托斯v2
item_imba_atos_v2 = class({})
LinkLuaModifier("modifier_item_imba_atos_passive_v2", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_atos_root", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_atos_root_v1", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_atos_roo_shackle", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_atos_shackle_cd", "ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
function item_imba_atos_v2:GetIntrinsicModifierName() return "modifier_item_imba_atos_passive_v2" end
function item_imba_atos_v2:OnSpellStart()
	self.caster	= self:GetCaster()
	self.duration =	self:GetSpecialValueFor("duration")
	self.projectile_speed = self:GetSpecialValueFor("projectile_speed")
	local caster_location	= self.caster:GetAbsOrigin()
	local target			= self:GetCursorTarget()
	local projectile =
		{
			Target 				= target,
			Source 				= self.caster,
			Ability 			= self,
			EffectName 			= "particles/items2_fx/rod_of_atos_attack.vpcf",
			iMoveSpeed			= 1200,
			vSourceLoc 			= caster_location,
			bDrawsOnMinimap 	= false,
			bDodgeable 			= true,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			bProvidesVision 	= false,
		}
		TG_CreateProjectile({id=1,team=self.caster:GetTeamNumber(),owner=self.caster,p=projectile})
end

function item_imba_atos_v2:OnProjectileHit(target, location)
	self.caster:TG_IS_ProjectilesValue(function()
		target=nil
  	end)
	if target and not target:IsMagicImmune() then
		if target:TriggerSpellAbsorb(self) then return nil end

		target:EmitSound("DOTA_Item.RodOfAtos.Target")

		target:AddNewModifier_RS(self.caster,self,"modifier_item_imba_atos_root",{duration =self:GetSpecialValueFor("duration")})
		target:AddNewModifier_RS(self.caster,self,"modifier_item_imba_atos_root_v1",{duration =self:GetSpecialValueFor("duration")})
		--target:AddNewModifier(self.caster,self,"modifier_item_imba_atos_roo_shackle",{duration =self:GetSpecialValueFor("duration")})
	local maxc = self:GetSpecialValueFor("stack")
	local a = 0
	if not self.caster:HasModifier("modifier_item_imba_atos_shackle_cd") then 
	 enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for  k = #enemies,1,-1 do		
				if enemies[k]~= nil and a<maxc and enemies[k] ~= target 
							and not enemies[k]:IsMagicImmune() 
							and not enemies[k]:IsInvisible() and not enemies[k]:IsInvulnerable() then a=a+1
		enemies[k]:AddNewModifier_RS(target,self,"modifier_item_imba_atos_roo_shackle",{duration =self:GetSpecialValueFor("duration")})
		--target:AddNewModifier(self.caster,self,"modifier_item_imba_atos_root_caster",{duration =self:GetSpecialValueFor("duration")})
		self.caster:AddNewModifier(self.caster,self,"modifier_item_imba_atos_shackle_cd",{duration = self:GetCooldownTimeRemaining()})
		end
	end
	end
	if a<maxc and target:HasModifier("modifier_item_imba_atos_root_v1") then
		local modifier = target:FindModifierByName("modifier_item_imba_atos_root_v1")
		modifier:SetStackCount(modifier:GetStackCount()+(maxc-a))
	end	
	
end
end





-----缠绕v0
modifier_item_imba_atos_root = class({})
function modifier_item_imba_atos_root:IsDebuff()			return true end
function modifier_item_imba_atos_root:IsHidden() 			return false end
function modifier_item_imba_atos_root:IsPurgable() 			return true end
function modifier_item_imba_atos_root:CheckState() 			return {[MODIFIER_STATE_ROOTED] = true} end
function modifier_item_imba_atos_root:DeclareFunctions() return {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION} end
function modifier_item_imba_atos_root:GetEffectName()		return "particles/items2_fx/rod_of_atos.vpcf" end
function modifier_item_imba_atos_root:GetModifierProvidesFOWVision() return 1 end
function modifier_item_imba_atos_root:OnDestroy()
if not IsServer() then return end
	if self:GetParent() and self:GetParent():IsAlive() then  
		if self:GetParent():HasModifier("modifier_item_imba_atos_root_v1") then
			local modifier = self:GetParent():FindModifierByName("modifier_item_imba_atos_root_v1") 
			modifier:IncrementStackCount() 
		end
	end 
end


-------易伤减速
modifier_item_imba_atos_root_v1 = class({})

function modifier_item_imba_atos_root_v1:IsDebuff()			return true end
function modifier_item_imba_atos_root_v1:IsHidden() 			return false end
function modifier_item_imba_atos_root_v1:IsPurgable() 			return false end
function modifier_item_imba_atos_root_v1:IsPurgeException() 	return true end
function modifier_item_imba_atos_root_v1:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE} end
function modifier_item_imba_atos_root_v1:GetModifierMoveSpeedBonus_Percentage() return  self.slow*self:GetStackCount() end
function modifier_item_imba_atos_root_v1:GetModifierIncomingDamage_Percentage() return self.dam*self:GetStackCount() end
function modifier_item_imba_atos_root_v1:GetEffectName()		return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf" end
function modifier_item_imba_atos_root_v1:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_item_imba_atos_root_v1:OnCreated()
	self.slow = self:GetAbility():GetSpecialValueFor("slow")
	self.dam = self:GetAbility():GetSpecialValueFor("dam")
end

function modifier_item_imba_atos_root_v1:OnDestroy()
	self.slow = nil
	self.dam = nil
end





----缠绕v2
modifier_item_imba_atos_roo_shackle = class({})
LinkLuaModifier("modifier_item_imba_atos_root_v1","ting/items/item_rod_of_atos", LUA_MODIFIER_MOTION_NONE)
function modifier_item_imba_atos_roo_shackle:IsDebuff()			return true end
function modifier_item_imba_atos_roo_shackle:IsHidden() 			return false end
function modifier_item_imba_atos_roo_shackle:IsPurgable() 			return true end
function modifier_item_imba_atos_roo_shackle:CheckState() 			return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true, [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true} end
function modifier_item_imba_atos_roo_shackle:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_atos_roo_shackle:OnCreated()
	self.caster = self:GetCaster()
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
	self.parent = self:GetParent()
		local particle = ParticleManager:CreateParticle("particles/econ/items/shadow_shaman/ss_fall20_tongue/shadowshaman_shackle_net_fall20.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW  , "attach_hitloc", self:GetCaster():GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(particle, 1,self:GetParent(), PATTACH_CENTER_FOLLOW , "attach_hitloc",self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(particle, false, false, 15, false, false)
	if not IsServer() then return end
	self:StartIntervalThink(FrameTime())
end
 
function modifier_item_imba_atos_roo_shackle:OnIntervalThink()
	if (self.parent:GetOrigin() - self.caster:GetOrigin()):Length2D() >1000  then self:StartIntervalThink(-1) self:Destroy() return end
	if (self.parent:GetOrigin() - self.caster:GetOrigin()):Length2D() <= 128 then  return end
	local target_position = self.parent:GetAbsOrigin()
	local center_vector = self:GetCaster():GetAbsOrigin() - target_position
	local pull_distance = center_vector:Normalized() * self.speed*FrameTime()
	if not self.caster:HasModifier("modifier_item_imba_atos_root_v1") then self:StartIntervalThink(-1) self:Destroy() return end
	FindClearSpaceForUnit(self.parent, target_position + pull_distance, false)

end

function modifier_item_imba_atos_roo_shackle:OnDestroy()
	if not IsServer() then return end
	GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), 400, false)
	FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), false)
	if self.caster and self.caster:IsAlive() then  
		if self.caster:HasModifier("modifier_item_imba_atos_root_v1") then
			local modifier = self.caster:FindModifierByName("modifier_item_imba_atos_root_v1") 
			modifier:IncrementStackCount() 
		end
	end 
end

--被动v0
modifier_item_imba_atos_passive = class({})
function modifier_item_imba_atos_passive:IsDebuff()			return false end
function modifier_item_imba_atos_passive:IsHidden() 			return true end
function modifier_item_imba_atos_passive:IsPurgable() 		return false end
function modifier_item_imba_atos_passive:IsPurgeException() 	return false end
function modifier_item_imba_atos_passive:DeclareFunctions() return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_HEALTH_BONUS} end
function modifier_item_imba_atos_passive:GetModifierBonusStats_Intellect() return self.int end
function modifier_item_imba_atos_passive:GetModifierHealthBonus() return self.hp end
function modifier_item_imba_atos_passive:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.int = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.hp = self:GetAbility():GetSpecialValueFor("bonus_health")
end

--被动v1
modifier_item_imba_atos_passive_v1 = class({})
function modifier_item_imba_atos_passive_v1:IsDebuff()			return false end
function modifier_item_imba_atos_passive_v1:IsHidden() 			return true end
function modifier_item_imba_atos_passive_v1:IsPurgable() 		return false end
function modifier_item_imba_atos_passive_v1:IsPurgeException() 	return false end
function modifier_item_imba_atos_passive_v1:DeclareFunctions() return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_HEALTH_BONUS,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_item_imba_atos_passive_v1:GetModifierBonusStats_Intellect() return self.int end
function modifier_item_imba_atos_passive_v1:GetModifierHealthBonus() return self.hp end
function modifier_item_imba_atos_passive_v1:GetModifierAttackSpeedBonus_Constant() return self.asp end
function modifier_item_imba_atos_passive_v1:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.int = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.hp = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.asp = self:GetAbility():GetSpecialValueFor("bonus_asp")
	
end



--被动v2
modifier_item_imba_atos_passive_v2 = class({})
function modifier_item_imba_atos_passive_v2:IsDebuff()			return false end
function modifier_item_imba_atos_passive_v2:IsHidden() 			return true end
function modifier_item_imba_atos_passive_v2:IsPurgable() 		return false end
function modifier_item_imba_atos_passive_v2:IsPurgeException() 	return false end
function modifier_item_imba_atos_passive_v2:DeclareFunctions() return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_HEALTH_BONUS,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_MANA_BONUS}end
function modifier_item_imba_atos_passive_v2:GetModifierBonusStats_Intellect() return self.int end
function modifier_item_imba_atos_passive_v2:GetModifierHealthBonus() return self.hp end
function modifier_item_imba_atos_passive_v2:GetModifierAttackSpeedBonus_Constant() return self.asp end
function modifier_item_imba_atos_passive_v2:GetModifierManaBonus() return self.mana end
function modifier_item_imba_atos_passive_v2:OnCreated()
	if self:GetAbility()==nil then
		return
	end
	self.int = self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.hp = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.asp = self:GetAbility():GetSpecialValueFor("bonus_asp")
	self.mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
end


modifier_item_imba_atos_shackle_cd = class({})
function modifier_item_imba_atos_shackle_cd:IsDebuff()			return true end
function modifier_item_imba_atos_shackle_cd:IsHidden() 			return false end
function modifier_item_imba_atos_shackle_cd:IsPurgable() 		return false end
function modifier_item_imba_atos_shackle_cd:IsPurgeException() 	return false end
function modifier_item_imba_atos_shackle_cd:RemoveOnDeath() 	return false end
