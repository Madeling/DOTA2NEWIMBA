item_imba_pipe = class({})

LinkLuaModifier("modifier_imba_pipe_passive", "ting/items/item_pipe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_pipe_aura", "ting/items/item_pipe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_pipe_block", "ting/items/item_pipe", LUA_MODIFIER_MOTION_NONE)

function item_imba_pipe:GetIntrinsicModifierName() return "modifier_imba_pipe_passive" end

function item_imba_pipe:OnSpellStart()
	local caster = self:GetCaster()
	local pos= caster:GetAbsOrigin()
	local radius = self:GetSpecialValueFor("aura_radius")
	local barrier_duration = self:GetSpecialValueFor("barrier_duration")
	caster:EmitSound("DOTA_Item.Pipe.Activate")
	local pfx = ParticleManager:CreateParticle("particles/items2_fx/pipe_of_insight_launch.vpcf", PATTACH_ABSORIGIN, caster)
	--ParticleManager:SetParticleControlEnt(pfx,0, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	--ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(pfx, 0, pos)
	ParticleManager:SetParticleControl(pfx, 1, pos)
	ParticleManager:SetParticleControl(pfx, 2, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(pfx)
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, ally in pairs(allies) do
		ally:AddNewModifier(caster, self, "modifier_item_imba_pipe_block", {duration = barrier_duration})
	end
end

modifier_imba_pipe_passive = class({})

function modifier_imba_pipe_passive:IsDebuff()			return false end
function modifier_imba_pipe_passive:IsHidden() 			return true end
function modifier_imba_pipe_passive:IsPurgable() 		return false end
function modifier_imba_pipe_passive:IsPurgeException() 	return false end
function modifier_imba_pipe_passive:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("aura_radius")
	self.hp_r = self:GetAbility():GetSpecialValueFor("health_regen")
	self.mr = self:GetAbility():GetSpecialValueFor("magic_resistance")
end
function modifier_imba_pipe_passive:OnDestroy()
	self.radius = nil
	self.hp_r = nil
	self.mr = nil
end
function modifier_imba_pipe_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_pipe_passive:IsAura() return true end
function modifier_imba_pipe_passive:GetAuraDuration() return 0.1 end
function modifier_imba_pipe_passive:RemoveOnDeath()		return self:GetParent():IsIllusion() end
function modifier_imba_pipe_passive:GetModifierAura() return "modifier_item_imba_pipe_aura" end
function modifier_imba_pipe_passive:GetAuraRadius()
if self.radius ~= nil then return self.radius end
end
function modifier_imba_pipe_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_pipe_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_pipe_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_pipe_passive:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_imba_pipe_passive:GetModifierConstantHealthRegen() 
if self.hp_r~=nil then return self.hp_r end
end
function modifier_imba_pipe_passive:GetModifierMagicalResistanceBonus() 
if self.mr~=nil then return self.mr end
end

modifier_item_imba_pipe_aura = class({})

function modifier_item_imba_pipe_aura:IsDebuff()			return false end
function modifier_item_imba_pipe_aura:IsHidden() 			return false end
function modifier_item_imba_pipe_aura:IsPurgable() 			return false end
function modifier_item_imba_pipe_aura:IsPurgeException() 	return false end
function modifier_item_imba_pipe_aura:GetTexture() return "item_imba_pipe" end
function modifier_item_imba_pipe_aura:DeclareFunctions() return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_item_imba_pipe_aura:OnCreated() 
	if not self:GetAbility()then   
		return  
	end 
	self.aura_health_regen=self:GetAbility():GetSpecialValueFor("aura_health_regen") 
	self.aura_magic_resist=self:GetAbility():GetSpecialValueFor("aura_magic_resist") 
end

function modifier_item_imba_pipe_aura:GetModifierConstantHealthRegen() 
	if self.aura_health_regen~=nil then
		return self.aura_health_regen
	end
end

function modifier_item_imba_pipe_aura:GetModifierMagicalResistanceBonus() 
	if self.aura_magic_resist~=nil then
		return self.aura_magic_resist
end
end

modifier_item_imba_pipe_block = class({})

function modifier_item_imba_pipe_block:IsDebuff()			return false end
function modifier_item_imba_pipe_block:IsHidden() 			return false end
function modifier_item_imba_pipe_block:IsPurgable() 		return true end
function modifier_item_imba_pipe_block:IsPurgeException() 	return true end


function modifier_item_imba_pipe_block:OnCreated()
	if not self:GetAbility()then   
		return  
	end 
	self.barrier_resist = self:GetAbility():GetSpecialValueFor("barrier_resist") 
	self.parent = self:GetParent()
	if IsServer() then
		if not self.particle then
		self.particle = ParticleManager:CreateParticle("particles/items2_fx/pipe_of_insight.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle, 2, Vector(self.parent:GetModelRadius() * 1.1,0,0))
		end
	end
end

function modifier_item_imba_pipe_block:OnDestroy()
	if self.particle and IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
	self.particle = nil
	self.barrier_resist = nil 
	self.parent = nil
end
function modifier_item_imba_pipe_block:GetTexture() return "item_imba_pipe" end
function modifier_item_imba_pipe_block:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_item_imba_pipe_block:GetModifierMagicalResistanceBonus() 
	return self.barrier_resist
end