modifier_dlzuus_charges = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dlzuus_charges:IsHidden()
	return false
end

function modifier_dlzuus_charges:IsPurgable()
	return false
end

function modifier_dlzuus_charges:DestroyOnExpire()
	return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_dlzuus_charges:OnCreated( kv )
	-- references
	if not self:GetAbility() then   
		return  
	end 
	self.max_charges = self:GetAbility():GetSpecialValueFor( "max_charges" ) -- special value
	self.charge_time = self:GetAbility():GetSpecialValueFor( "charge_restore_time" ) -- special value

	if IsServer() then
		self:SetStackCount( self.max_charges )
		self:CalculateCharge()
	end
end

function modifier_dlzuus_charges:OnRefresh( kv )
	-- references
	self.max_charges = self:GetAbility():GetSpecialValueFor( "max_charges" ) -- special value
	self.charge_time = self:GetAbility():GetSpecialValueFor( "charge_restore_time" ) -- special value

	if IsServer() then
		self:CalculateCharge()
	end
end

function modifier_dlzuus_charges:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_dlzuus_charges:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_dlzuus_charges:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit~=self:GetParent() then return end	--1判断本人，2判断刷新，3判断本技能。第一步本人本技能双判断则无法触发刷新
		if string.find(params.ability:GetAbilityName(), "refresh") then
				self:SetStackCount(self.max_charges)
				self:CalculateCharge()
		end
		if params.ability~=self:GetAbility() then return end

		self:DecrementStackCount()
		self:CalculateCharge()
	end
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_dlzuus_charges:OnIntervalThink()
	self:IncrementStackCount()
	self:StartIntervalThink(-1)
	self:CalculateCharge()
end

function modifier_dlzuus_charges:CalculateCharge()
	self:GetAbility():EndCooldown()
	local cdr = self:GetParent():GetCooldownReduction()

	if self:GetStackCount()>=self.max_charges then
		-- stop charging
		self:SetDuration( -1, false )
		self:StartIntervalThink( -1 )
	else
		-- if not charging
		if self:GetRemainingTime() <= 0.05 then
			-- start charging
			local charge_time = self:GetAbility():GetCooldown( -1 )*cdr
			if self.charge_time then
				charge_time = self.charge_time*cdr	--受cdr影响，如KV里设置了充能时间则用KV，没有设置则用冷却
			end
			self:StartIntervalThink( charge_time )
			self:SetDuration( charge_time, true )
		end

		-- set on cooldown if no charges
		if self:GetStackCount()==0 then
			self:GetAbility():StartCooldown( self:GetRemainingTime() )
		end
	end
end
