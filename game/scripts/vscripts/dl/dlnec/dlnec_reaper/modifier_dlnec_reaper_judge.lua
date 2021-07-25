
modifier_dlnec_reaper_judge = class({})

function modifier_dlnec_reaper_judge:IsHidden() return true end
function modifier_dlnec_reaper_judge:IsDebuff() return true end
function modifier_dlnec_reaper_judge:IsStunDebuff() return false end
function modifier_dlnec_reaper_judge:IsPurgable() return false end
function modifier_dlnec_reaper_judge:IsPurgeException() return false end
function modifier_dlnec_reaper_judge:RemoveOnDeath() return self:GetParent():IsIllusion() end

--虽然onremove只用一个modi就确保了击杀者为nec，但无法在ondeath中判断镰刀状态下死亡。还是得有个比伤害modi长几帧的判断modi
