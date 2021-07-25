
modifier_dlnec_haura_infector = class({})

function modifier_dlnec_haura_infector:IsHidden() return false end
function modifier_dlnec_haura_infector:IsBuff() return false end
function modifier_dlnec_haura_infector:IsDebuff() return true end
function modifier_dlnec_haura_infector:IsStunDebuff() return false end
function modifier_dlnec_haura_infector:IsPurgable() return true end
function modifier_dlnec_haura_infector:IsPurgeException() return true end

function modifier_dlnec_haura_infector:GetEffectName() return "particles/econ/events/diretide_2020/high_five/high_five_lvl1_overhead.vpcf" end
function modifier_dlnec_haura_infector:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_dlnec_haura_infector:OnCreated()
    if not IsServer() then return end

    --self:GetParent():EmitSound("necrolyte_necr_attack_04")
    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    local infector = self:GetParent()
    local radius = ability:GetSpecialValueFor("haura_infect_radius")
    infector:EmitSound("necrolyte_necr_laugh_03")

    local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			infector:GetAbsOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
			FIND_ANY_ORDER,	-- int, order filter
			false	-- bool, can grow cache
        )

    if #enemies<1 then return end

    for _,enemy in pairs(enemies) do
        enemy:AddNewModifier(caster, ability, "modifier_dlnec_haura_infected", {duration = ability:GetSpecialValueFor("haura_infect_duration")})
    end

end



--[[function modifier_dlnec_haura_infector:RemoveOnDeath() return self:GetParent():IsIllusion() end
function modifier_dlnec_haura_infector:IsAura() return not self:GetParent():IsIllusion() end
--function modifier_dlnec_haura_infector:GetAuraOwner() return self:GetAbility():GetCaster() end    --本来以为这行可以做到敌人身上的光环给敌人上debuff，结果不行
function modifier_dlnec_haura_infector:GetAuraDuration() return self:GetAbility():GetSpecialValueFor("haura_interval") end
function modifier_dlnec_haura_infector:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("haura_infect_radius") end
function modifier_dlnec_haura_infector:GetModifierAura() return "modifier_dlnec_haura_infected" end
function modifier_dlnec_haura_infector:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_dlnec_haura_infector:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end    --这里改成搜寻友军，就是敌人身上的光环给敌人上debuff，包括光环宿主
function modifier_dlnec_haura_infector:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end]]
