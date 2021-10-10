
modifier_dlnec_reaper_nec = class({})

function modifier_dlnec_reaper_nec:IsHidden() return true end
function modifier_dlnec_reaper_nec:IsPurgable() return false end
function modifier_dlnec_reaper_nec:IsPurgeException() return false end

function modifier_dlnec_reaper_nec:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_dlnec_reaper_nec:OnDeath(params)
    if not IsServer() then return end
    if not params.unit then return end	--可能能防报错吧我也不知道随手一加
    if not params.attacker then return end	--可能能防报错吧我也不知道随手一加
    if params.attacker ~= self:GetParent() then return end    --不是本人那没事了
    if params.unit == self:GetParent() then return end    --死的是本人那没事了
    --if params.ability ~= self:GetAbility() then return end    --这个里面没有ability！

    --local caster = self:GetParent()
    local target = params.unit
    --local ability = self:GetAbility()

    --[[local reaper = target:FindModifierByName("modifier_dlnec_reaper_target")    --看看死亡时敌人身上的modi
    if reaper then print("reaper") else print("noreaper") end
    local judge = target:FindModifierByName("modifier_dlnec_reaper_judge")
    if judge then print("judge") else print("nojudge") end
    local permanent = target:FindModifierByName("modifier_dlnec_reaper_permanent")
    if permanent then print("permanent") else print("noperma") end]]

    local judge = target:FindModifierByName("modifier_dlnec_reaper_judge")
    local permanent = target:FindModifierByName("modifier_dlnec_reaper_permanent")

    --if judge and permanent then permanent:IncrementStackCount() end
    if judge and permanent then permanent:IncrementStackCount() end     --加一层

end
