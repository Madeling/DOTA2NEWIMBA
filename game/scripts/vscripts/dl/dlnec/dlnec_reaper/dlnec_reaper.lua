
dlnec_reaper = class({})

LinkLuaModifier("modifier_dlnec_reaper_nec", "dl/dlnec/dlnec_reaper/modifier_dlnec_reaper_nec", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dlnec_reaper_target", "dl/dlnec/dlnec_reaper/modifier_dlnec_reaper_target", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dlnec_reaper_permanent", "dl/dlnec/dlnec_reaper/modifier_dlnec_reaper_permanent", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dlnec_reaper_judge", "dl/dlnec/dlnec_reaper/modifier_dlnec_reaper_judge", LUA_MODIFIER_MOTION_NONE)

function dlnec_reaper:IsHiddenWhenStolen() 	return false end
function dlnec_reaper:IsRefreshable() 		return true end
function dlnec_reaper:IsStealable() 		return true end
function dlnec_reaper:GetCooldown() return self:GetSpecialValueFor("reaper_cd") - self:GetCaster():TG_GetTalentValue("special_bonus_dlnec_25l") end

function dlnec_reaper:GetIntrinsicModifierName()
	return "modifier_dlnec_reaper_nec"
end

function dlnec_reaper:OnSpellStart()

    local caster = self:GetCaster()
    local target = self:GetCursorTarget()

    if target:TG_TriggerSpellAbsorb(self) then
        return
    end

    target:AddNewModifier(caster, self, "modifier_dlnec_reaper_judge", {duration = self:GetSpecialValueFor("reaper_stun")+0.1})
    target:AddNewModifier(caster, self, "modifier_dlnec_reaper_target", {duration = self:GetSpecialValueFor("reaper_stun")})

end

