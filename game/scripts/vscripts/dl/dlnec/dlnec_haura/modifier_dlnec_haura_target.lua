
modifier_dlnec_haura_target = class({})

function modifier_dlnec_haura_target:IsHidden() return false end
function modifier_dlnec_haura_target:IsBuff() return false end
function modifier_dlnec_haura_target:IsDebuff() return true end
function modifier_dlnec_haura_target:IsStunDebuff() return false end
function modifier_dlnec_haura_target:IsPurgable() return false end
function modifier_dlnec_haura_target:IsPurgeException() return false end

function modifier_dlnec_haura_target:OnCreated()
    if not IsServer() then return end
    self.ability = self:GetAbility()
    self.caster = self.ability:GetCaster()
    self.target = self:GetParent()
    self.interval = self:GetAbility():GetSpecialValueFor("haura_interval")

    self:SetStackCount(1)
    self:StartIntervalThink(self.interval)

end

function modifier_dlnec_haura_target:OnIntervalThink()
    if not IsServer()  then return end

    if not self or not self:GetAbility() then return end        --防止幻象报错


    local hploss_base_percent = self.ability:GetSpecialValueFor("haura_hploss_base_percent")
    local hploss_stack_percent = self.ability:GetSpecialValueFor("haura_hploss_stack_percent")
    local hploss_talent_percent = self.caster:TG_GetTalentValue("special_bonus_dlnec_20l")
    local infect = self.ability:GetSpecialValueFor("haura_infect")
    local stack = self:GetStackCount()

    if stack >= infect then
        local debuff = self.target:FindModifierByName("modifier_dlnec_haura_infector")
        local duration = self.ability:GetSpecialValueFor("haura_infect_duration")
        if not debuff then
            self.target:AddNewModifier(self.caster, self.ability, "modifier_dlnec_haura_infector", {duration = duration})
        end
    end

    local hploss_base = self.target:GetMaxHealth()*hploss_base_percent/100
    local hploss_stack = self.target:GetMaxHealth()*hploss_stack_percent*stack/100
    local hploss_talent = self.target:GetMaxHealth()*hploss_talent_percent/100
    local hploss = hploss_base + hploss_stack + hploss_talent

    if self.target:IsBoss() then hploss = 0 end  --不烫肉山

    local damagetable = {
        victim = self.target,
        attacker = self.caster,
        damage = hploss,
        ability = self.ability,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
    }
    ApplyDamage(damagetable)

    self:IncrementStackCount()

end

function modifier_dlnec_haura_target:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_dlnec_haura_target:GetModifierMoveSpeedBonus_Constant()
    --这里加isserver判定，会导致客户端数值显示出错，速度实际减了显示不变
    if not self or not self:GetAbility() then return end        --防止幻象报错

    local stack = self:GetStackCount()
    if not stack or stack < 1 then stack = 1 end
    local speedloss_stack = self:GetAbility():GetSpecialValueFor("haura_speedloss_stack")
    local speedloss = -1*speedloss_stack*stack

    return speedloss
end

--[[function modifier_dlnec_haura_target:GetModifierMoveSpeedBonus_Percentage()
    if not IsServer() then return end

    local stack = self:GetStackCount()
    if not stack or stack < 1 then stack = 1 end
    local speedloss_stack = self:GetAbility():GetSpecialValueFor("haura_speedloss_stack")
    local speedloss = -1*speedloss_stack*stack
    print(speedloss)

    return speedloss
end]]
