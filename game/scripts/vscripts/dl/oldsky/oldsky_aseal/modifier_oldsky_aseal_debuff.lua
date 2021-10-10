
modifier_oldsky_aseal_debuff = class({})

function modifier_oldsky_aseal_debuff:IsDebuff()			return true end
function modifier_oldsky_aseal_debuff:IsHidden() 			return false end
function modifier_oldsky_aseal_debuff:IsPurgable() 		return true end
function modifier_oldsky_aseal_debuff:IsPurgeException() 	return true end

function modifier_oldsky_aseal_debuff:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_oldsky_aseal_debuff:DeclareFunctions() return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, MODIFIER_EVENT_ON_TAKEDAMAGE} end          --天赋加减魔抗 ↓
function modifier_oldsky_aseal_debuff:GetModifierMagicalResistanceBonus() return (0 - self:GetAbility():GetSpecialValueFor("aseal_magicred") - self:GetCaster():TG_GetTalentValue("special_bonus_oldsky_15l") ) end

function modifier_oldsky_aseal_debuff:OnCreated()
    if not IsServer() then return end

    local particle1 = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_debuff.vpcf"

    local steamid = tonumber(tostring(PlayerResource:GetSteamID(self:GetCaster():GetPlayerOwnerID())))
    local idtable = {
                        76561198361355161,  --小太
                        76561198100269546,  --老太
                        76561198080385796,  --暗号
                        76561198319625131,  --老姐
                    }
    local green = Is_DATA_TG(idtable,steamid)    --绿色封印
    if green then particle1 = "particles/dlparticles/oldsky_aseal/green_p_skywrath_mage_ancient_seal_debuff.vpcf" end

    local pfx = ParticleManager:CreateParticle(particle1, PATTACH_CUSTOMORIGIN, self:GetParent())

	ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

    self:AddParticle(pfx, false, false, 15, false, false)

end

function modifier_oldsky_aseal_debuff:OnTakeDamage(keys)
    if not IsServer() then return end
    --if not self:GetCaster():Has_Aghanims_Shard() then return end        --延长debuff时间 ↓

    if keys.unit == self:GetParent() and keys.inflictor and (keys.inflictor:GetName() == "oldsky_abolt" or keys.inflictor:GetName() == "oldsky_cshot" or keys.inflictor:GetName() == "oldsky_mflare") then
		if keys.inflictor:GetName() == "oldsky_abolt" or keys.inflictor:GetName() == "oldsky_cshot" then
            self:SetDuration(self:GetRemainingTime() + self:GetAbility():GetSpecialValueFor("aseal_abolt"), true)
		else
			self:SetDuration(self:GetRemainingTime() + self:GetAbility():GetSpecialValueFor("aseal_mflare"), true)
		end
	end
end
