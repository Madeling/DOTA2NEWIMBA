modifier_chen_dmggod=class({})

function modifier_chen_dmggod:IsHidden() 			
    return false 
end

function modifier_chen_dmggod:IsPurgable() 		
    return false
end

function modifier_chen_dmggod:IsPurgeException() 
    return false 
end

function modifier_chen_dmggod:AllowIllusionDuplicate() 	
    return false 
end

function modifier_chen_dmggod:RemoveOnDeath() 	
    return false 
end

function modifier_chen_dmggod:IsPermanent() 	
    return true 
end

function modifier_chen_dmggod:GetTexture() 	
    return "god" 
end

function modifier_chen_dmggod:DeclareFunctions() 
    return 
    {   
        MODIFIER_EVENT_ON_TAKEDAMAGE
    } 
end

function modifier_chen_dmggod:OnCreated() 
    if not IsServer() then 
        return 
   end 
   self.ID=self:GetParent():GetPlayerOwnerID()
   self.NUM=80
   self.CD=true
   self:SetStackCount(self.NUM)
end

function modifier_chen_dmggod:OnIntervalThink() 
    self.NUM=self.NUM-1
    self:SetStackCount(self.NUM)
    if self.NUM<=0 then 
        self.CD=true
        self.NUM=80
        self:StartIntervalThink(-1)
    end
end

function modifier_chen_dmggod:OnTakeDamage(tg) 
    if not IsServer() then 
         return 
    end 
     if tg.unit==self:GetParent() and  tg.damage>=self:GetParent():GetHealth()-400 and self.CD==true  then 
        self.CD=false 
        self:StartIntervalThink(1)
        EmitSoundOn("chen_chen_laugh_11", self:GetParent())
        FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetTeamNumber()==DOTA_TEAM_GOODGUYS and  GOOD_POS  or  BAD_POS, false)
        local tp = self:GetParent():GetItemInSlot(DOTA_ITEM_TP_SCROLL)
        if tp then
            tp:EndCooldown()
        end	
        PlayerResource:SetCameraTarget(self.ID,self:GetParent())
        Timers:CreateTimer({
			useGameTime = false,
			endTime = 0.1,
			callback = function()
                PlayerResource:SetCameraTarget(self.ID,nil)
        end})
     end 
 end