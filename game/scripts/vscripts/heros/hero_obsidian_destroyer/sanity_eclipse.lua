sanity_eclipse=class({})

LinkLuaModifier("modifier_sanity_eclipse", "heros/hero_obsidian_destroyer/sanity_eclipse.lua", LUA_MODIFIER_MOTION_NONE)
function sanity_eclipse:IsHiddenWhenStolen()
    return false
end

function sanity_eclipse:IsStealable()
    return true
end

function sanity_eclipse:IsRefreshable()
    return true
end

function sanity_eclipse:OnSpellStart()
    local caster=self:GetCaster()
    local pos=self:GetCursorPosition()
    local base_damage=self:GetSpecialValueFor("base_damage")
    local radius=self:GetSpecialValueFor("radius")
    local dur=self:GetSpecialValueFor("dur")+caster:TG_GetTalentValue("special_bonus_obsidian_destroyer_8")
    local damage_multiplier=self:GetSpecialValueFor("damage_multiplier")+caster:TG_GetTalentValue("special_bonus_obsidian_destroyer_7")
    EmitSoundOn("Hero_ObsidianDestroyer.SanityEclipse", caster)
    if caster:Has_Aghanims_Shard() then
        radius=radius+200
    end
    local table={
        attacker = caster,
        damage_type = caster:Has_Aghanims_Shard() and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL,
        ability = self,
    }
	local pf=ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pf, 0, pos)
	ParticleManager:SetParticleControl(pf, 1, Vector(radius, radius,radius))
	ParticleManager:SetParticleControl(pf, 2, Vector(radius, radius, radius))
    ParticleManager:ReleaseParticleIndex(pf)
    local heros = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
    if #heros>0 then
        for _, hero in pairs(heros) do
            local dmg=true
            if (hero:IsOutOfGame() or hero:IsInvulnerable()) and not hero:HasModifier("modifier_astral_imprisonment") then
                dmg=false
            end
            if hero:IsIllusion() then
                hero:Kill(self, caster)
            else
                hero:ReduceMana(hero:GetMana())
                hero:AddNewModifier_RS(caster, self, "modifier_sanity_eclipse", {duration=dur})
                local mana=caster:GetMaxMana()-hero:GetMaxMana()
                table.damage = dmg==true and base_damage+(mana>0 and mana*damage_multiplier or 0) or 0
                table.victim = hero
                ApplyDamage(table)
            end
        end
    end
end


modifier_sanity_eclipse=class({})
function modifier_sanity_eclipse:IsDebuff()
    return true
end


function modifier_sanity_eclipse:IsPurgable()
    return false
end

function modifier_sanity_eclipse:IsPurgeException()
    return false
end

function modifier_sanity_eclipse:IsHidden()
    return false
end

function modifier_sanity_eclipse:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MP_RESTORE_AMPLIFY_PERCENTAGE
	}
end


function modifier_sanity_eclipse:GetModifierMPRegenAmplify_Percentage()
    return -100
end


function modifier_sanity_eclipse:GetModifierMPRestoreAmplify_Percentage()
    return -100
end