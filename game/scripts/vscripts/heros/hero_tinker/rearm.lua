rearm=class({})

function rearm:IsHiddenWhenStolen() 
    return false 
end

function rearm:IsStealable() 
    return true 
end

function rearm:IsRefreshable() 			
    return true 
end

function rearm:GetCastAnimation()
	return ACT_DOTA_TINKER_REARM2
end

function rearm:OnInventoryContentsChanged()
    local caster=self:GetCaster()
   if not caster.rearm_abname and caster:Has_Aghanims_Shard() then 
       caster.rearm_abname=TK_RD[RandomInt(1,#TK_RD)]
       local ab=caster:AddAbility(caster.rearm_abname)
       ab:SetLevel(ab:GetMaxLevel())
       caster:SwapAbilities("tinker_march_of_the_machines",caster.rearm_abname, false, true)
    end
end

function rearm:OnChannelFinish(bInterrupted)
    local caster=self:GetCaster()
    if not bInterrupted then 
        TG_Refresh_AB(caster)
        local tp = caster:GetTP()
        if tp then
            tp:EndCooldown()
        end
        if caster:HasInventory() then
            for i=0,9 do
              local item= caster:GetItemInSlot(i)
                if item~=nil then 
                    if not Is_DATA_TG(NOT_RS_ITEM_TK,item:GetName()) then
                        item:EndCooldown()
                    end	
                end	
            end
        end
	end
end