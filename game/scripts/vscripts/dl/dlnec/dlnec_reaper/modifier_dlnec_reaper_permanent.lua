
modifier_dlnec_reaper_permanent = class({})

function modifier_dlnec_reaper_permanent:IsHidden() return self:GetStackCount() == 0 end
function modifier_dlnec_reaper_permanent:IsDebuff() return true end
function modifier_dlnec_reaper_permanent:IsStunDebuff() return false end
function modifier_dlnec_reaper_permanent:IsPurgable() return false end
function modifier_dlnec_reaper_permanent:IsPurgeException() return false end
function modifier_dlnec_reaper_permanent:RemoveOnDeath() return self:GetParent():IsIllusion() end
function modifier_dlnec_reaper_permanent:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_dlnec_reaper_permanent:OnCreated()
    if not IsServer() then return end
    self:SetStackCount(0)

    if self:GetParent():FindModifierByName("modifier_dlnec_dpulse_nec") then self:Destroy() end     --NEC自己不会受到健康忠告影响。鸡肋加强的同时避免和其他技能交互出BUG
end

function modifier_dlnec_reaper_permanent:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_RESPAWNTIME,
	}
	return funcs
end
--[[
function modifier_dlnec_reaper_permanent:GetModifierConstantRespawnTime()

    if not self:GetAbility() then return end

    local stack = self:GetStackCount()
    local time = self:GetAbility():GetSpecialValueFor("reaper_time_perstack") + self:GetAbility():GetCaster():TG_GetTalentValue("special_bonus_dlnec_25r")
    --print(time.."  modiperma")

    --经测试，老英霸里可正常运作，新英霸不行。后发现是新英霸game_mode里每次死亡都重置了复活时间

    return stack*time
end]]
