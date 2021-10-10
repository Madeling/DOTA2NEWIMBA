item_gift=class({})

function item_gift:OnSpellStart()
    local caster=self:GetCaster()
    local name=Gift_ITEM[RandomInt(1, #Gift_ITEM)]
    caster:AddItemByName(name)
    self:SpendCharge()
    self:Destroy()
end