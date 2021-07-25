modifier_gold =class({})

function modifier_gold:IsHidden()
    return true
end

function modifier_gold:IsPurgable()
    return false
end

function modifier_gold:IsPurgeException()
    return false
end

function modifier_gold:RemoveOnDeath()
    return false
end

function modifier_gold:IsPermanent()
    return true
end

function modifier_gold:AllowIllusionDuplicate()
    return false
end

function modifier_gold:OnCreated()
    self.parent=self:GetParent()
   if not IsServer() then
        return
   end
   self.id=self.parent:GetPlayerOwnerID()
   if self.parent:IS_TrueHero_TG() and not PlayerResource:IsFakeClient(self.id) then
   Timers:CreateTimer(90, function()
    self:StartIntervalThink(1)
        return nil
    end)
end
end

function modifier_gold:OnIntervalThink()
        PlayerResource:ModifyGold(self:GetParent():GetPlayerOwnerID(),1,false,DOTA_ModifyGold_Unspecified)
end
