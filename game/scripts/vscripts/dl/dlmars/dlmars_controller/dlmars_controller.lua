
dlmars_controller = class({})

function dlmars_controller:OnHeroLevelUp()

    local caster = self:GetCaster()

    if caster:GetLevel() == 7 then

        local ability = caster:FindAbilityByName("aghsfort_special_mars_spear_multiskewer")
        ability:SetLevel(1)

    end

    if caster:GetLevel() == 11 then

        local ability = caster:FindAbilityByName("aghsfort_special_mars_spear_impale_explosion")
        ability:SetLevel(1)

    end

end

function dlmars_controller:OnInventoryContentsChanged()
    local caster=self:GetCaster()

    if caster:Has_Aghanims_Shard() then

        local ability = caster:FindAbilityByName("aghsfort_special_mars_spear_burning_trail")
        ability:SetLevel(1)

    end

end
