modifier_bane_vision=class({})

function modifier_bane_vision:IsDebuff()
    return true
end

function modifier_bane_vision:IsPurgable()
    return false
end

function modifier_bane_vision:IsPurgeException()
    return false
end

function modifier_bane_vision:IsHidden()
    return false
end

function modifier_bane_vision:IsPermanent()
    return true
end

function modifier_bane_vision:RemoveOnDeath()
    return false
end

function modifier_bane_vision:OnCreated(tg)
            if IsServer() then
                  self:SetStackCount(self:GetStackCount()+tg.num)
            end
end

function modifier_bane_vision:OnRefresh(tg)
            self:OnCreated(tg)
end

function modifier_bane_vision:DeclareFunctions()
    return
    {
            MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE
    }
end


function modifier_bane_vision:GetBonusVisionPercentage()
    return 0-self:GetStackCount()
end