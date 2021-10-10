modifier_dlzuus_al_protect = class({})

function modifier_dlzuus_al_protect:IsHidden() return false end
function modifier_dlzuus_al_protect:IsDebuff() return false end
function modifier_dlzuus_al_protect:IsBuff() return true end
function modifier_dlzuus_al_protect:IsStunDebuff() return false end
function modifier_dlzuus_al_protect:IsPurgable() return false end
function modifier_dlzuus_al_protect:IsPurgeException() return false end
function modifier_dlzuus_al_protect:RemoveOnDeath() return true end
