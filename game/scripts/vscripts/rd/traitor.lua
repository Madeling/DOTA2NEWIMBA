traitor=class({})

function traitor:IsStealable() 
    return false 
end

function traitor:IsRefreshable() 			
    return false 
end

function traitor:OnSpellStart()
    local caster=self:GetCaster() 
    local gold=caster:GetLevel()*400
    local team
    if caster.original_team then  
        team=caster.original_team==DOTA_TEAM_GOODGUYS and  DOTA_TEAM_BADGUYS  or  DOTA_TEAM_GOODGUYS
    else  
        team=caster:GetTeamNumber()==DOTA_TEAM_GOODGUYS and  DOTA_TEAM_BADGUYS  or  DOTA_TEAM_GOODGUYS
    end 
    for a=5,20 do 
        local item=caster:GetItemInSlot(a)
        if item and item:IsNeutralDrop() then
            caster:DropItemAtPositionImmediate(caster:FindItemInInventory(item:GetName()),caster.original_team==DOTA_TEAM_GOODGUYS and  GOOD_POS  or  BAD_POS)
        end 
    end   
    GameRules:SetCustomGameTeamMaxPlayers(team,GameRules:GetCustomGameTeamMaxPlayers(team)+1)
    caster:ChangeTeam(team) 
    PlayerResource:SetCustomTeamAssignment(caster:GetPlayerOwnerID(),team)
    EmitAnnouncerSoundForTeam('announcer_ann_custom_adventure_alerts_18',caster:GetTeamNumber()==DOTA_TEAM_GOODGUYS and  DOTA_TEAM_BADGUYS  or  DOTA_TEAM_GOODGUYS)
    EmitAnnouncerSoundForPlayer('announcer_ann_custom_adventure_alerts_41',caster:GetPlayerOwnerID())
    if caster:HasModifier("modifier_player") then
        caster:RemoveModifierByName("modifier_player")
        caster:AddNewModifier(caster, nil, "modifier_player",{}) 	
    end
    for i=1, 24 do
        if CDOTA_PlayerResource.TG_HERO[i] then
            local hero = CDOTA_PlayerResource.TG_HERO[i]
            if hero:GetTeamNumber() ~= team then
                hero:ModifyGold(gold, true, DOTA_ModifyGold_Unspecified)
                SendOverheadEventMessage(hero, OVERHEAD_ALERT_GOLD,hero, gold, nil)
            end
        end
    end
    self:SetActivated(false)
end