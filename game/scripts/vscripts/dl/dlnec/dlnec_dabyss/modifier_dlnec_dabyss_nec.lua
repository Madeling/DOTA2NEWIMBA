
modifier_dlnec_dabyss_nec = class({})

function modifier_dlnec_dabyss_nec:IsHidden() return false end
function modifier_dlnec_dabyss_nec:IsPurgable() return false end
function modifier_dlnec_dabyss_nec:IsPurgeException() return false end
function modifier_dlnec_dabyss_nec:RemoveOnDeath() return false end

function modifier_dlnec_dabyss_nec:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_dlnec_dabyss_nec:OnDeath(params)
    if not IsServer() then return end

    if not params.unit then return end	--可能能防报错吧我也不知道随手一加
    --if not params.attacker then return end	--可能能防报错吧我也不知道随手一加。此技能用不到击杀者
    if params.unit~=self:GetParent() then return end    --死的不是本人那没事了
	--if self:GetParent():PassivesDisabled() then return end  --被破坏那没事了
    if params.unit:IsIllusion() then return end --分身能继承吗？这个肯定不行

    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local pos = self:GetParent():GetAbsOrigin()
    local dur = ability:GetSpecialValueFor("dabyss_dur")

    --[[local permanent = caster:FindModifierByName("modifier_dlnec_reaper_permanent")
    if permanent then permanent:IncrementStackCount() end   --NEC自己加]]

    CreateModifierThinker(	--创建死亡深渊thinker
		caster, -- player source
		ability, -- ability source
		"modifier_dlnec_dabyss_thinker", -- modifier name
		{
            duration = dur,
		}, -- kv
		pos,
		caster:GetTeamNumber(),
		false
    )

end
