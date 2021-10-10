item_attsp_book=class({})
LinkLuaModifier("modifier_item_attsp_book", "items/item_attsp_book.lua", LUA_MODIFIER_MOTION_NONE)

function item_attsp_book:CastFilterResult()
    self.caster=self.caster or self:GetCaster()
    if not IsServer() then return end
    local modifier=self.caster:HasModifier("modifier_item_attsp_book") and self.caster:FindModifierByName("modifier_item_attsp_book") or nil
    if GameRules:GetDOTATime(false, false)<2100 then
        if self.caster:HasModifier("modifier_item_spell_book") or (modifier~=nil and modifier:GetStackCount()>=1000)then
            return UF_FAIL_CUSTOM
        end
    else
        if  modifier~=nil and modifier:GetStackCount()>=1000 then
            return UF_FAIL_CUSTOM
        end
    end
end


function item_attsp_book:GetCustomCastError()
    return "已使用法强书或叠加达到上限，该物品无法在使用"
end

function item_attsp_book:OnSpellStart()
    TG_Modifier_Num_ADD(self.caster,"modifier_item_attsp_book",20,20)
    self:SpendCharge()
end

modifier_item_attsp_book=class({})

function modifier_item_attsp_book:GetTexture()return "item_attsp_book"
end
function modifier_item_attsp_book:IsHidden()return false
end
function modifier_item_attsp_book:IsPurgable()return false
end
function modifier_item_attsp_book:IsPurgeException()return false
end
function modifier_item_attsp_book:IsPermanent()return true
end
function modifier_item_attsp_book:AllowIllusionDuplicate()return false
end

function modifier_item_attsp_book:OnCreated(tg)
    if not IsServer() then
        return
    end
    self:SetStackCount(tg.num)
end

function modifier_item_attsp_book:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_item_attsp_book:GetModifierAttackSpeedBonus_Constant()return self:GetStackCount()
end