
dlnec_haura = class({})

LinkLuaModifier( "modifier_dlnec_haura_nec", "dl/dlnec/dlnec_haura/modifier_dlnec_haura_nec", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dlnec_haura_target", "dl/dlnec/dlnec_haura/modifier_dlnec_haura_target", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dlnec_haura_infector", "dl/dlnec/dlnec_haura/modifier_dlnec_haura_infector", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dlnec_haura_infected", "dl/dlnec/dlnec_haura/modifier_dlnec_haura_infected", LUA_MODIFIER_MOTION_NONE )

function dlnec_haura:GetIntrinsicModifierName()
	return not self:GetCaster():IsIllusion() and "modifier_dlnec_haura_nec"		--这里成功让幻象不继承了
end

function dlnec_haura:GetAOERadius() return self:GetSpecialValueFor("haura_radius") end
