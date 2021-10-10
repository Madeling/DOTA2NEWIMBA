modifier_player=class({})

function modifier_player:IsHidden()
    return false
end

function modifier_player:IsPurgable()
    return false
end

function modifier_player:IsPurgeException()
    return false
end

function modifier_player:RemoveOnDeath()
    return false
end

function modifier_player:IsPermanent()
    return true
end

function modifier_player:AllowIllusionDuplicate()
    return false
end

function modifier_player:GetTexture()
    return "jugg_dog"
end

function modifier_player:OnCreated()
    self.parent=self:GetParent()
    self.name=self.parent:GetName()
    self.N={}
    self.NS={}
    if IsServer() then
        self.parent.original_team=self.parent:GetTeamNumber()
        self.pos=self.parent.original_team == DOTA_TEAM_GOODGUYS and GOOD_POS or BAD_POS
        self.id=self.parent:GetPlayerOwnerID()
        self.PL=PlayerResource:GetPlayer(self.id)
        --[[if self.parent:IS_TrueHero_TG() and not PlayerResource:IsFakeClient(self.id) then
            self:StartIntervalThink(3)
        end]]
    end
end

function modifier_player:OnIntervalThink()
    for a=5,15 do
        local item=self.parent:GetItemInSlot(a)
        if item~=nil and item:IsNeutralDrop() then
            if a>=9 then
                table.insert (self.NS,item)
            else
                table.insert (self.N,item)
            end
        end
    end
    if self.N~=nil and (#self.N + #self.NS)>1 then
        for b=1,#self.N do
            self.parent:DropItemAtPositionImmediate(self.parent:FindItemInInventory(self.N[b]:GetName()),self.pos)
        end
    end
    if self.NS~=nil and #self.NS>1 then
        Notifications:Bottom(PlayerResource:GetPlayer(self.id), {text="请将多余的中立物品送回否则你将被封禁", duration=3, style={color="yellow", ["font-size"]="40px"}})
    end
    self.N={}
    self.NS={}
end

--[[
function modifier_player:CheckState()
    if self.parent:HasModifier("modifier_fountain_aura_buff") and self.id and (IsServer() and  PlayerResource:GetConnectionState(self.id) == DOTA_CONNECTION_STATE_ABANDONED) then
        return
        {
            [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        }
    else
        return {}
    end
end
]]

function modifier_player:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_HERO_KILLED,
    }
end

function modifier_player:OnAttackLanded(tg)
   if IsServer() then
        if tg.attacker==self.parent  then
            local name=tg.target:GetUnitName()
            if name=="npc_dota_observer_wards" or name=="npc_dota_sentry_wards" then
                if CDOTA_PlayerResource.TG_HERO[self.id + 1].des_ward~=nil then
                    CDOTA_PlayerResource.TG_HERO[self.id + 1].des_ward=CDOTA_PlayerResource.TG_HERO[self.id + 1].des_ward+1
                end
                if tg.target and  tg.target:GetTeamNumber()~=self.parent:GetTeamNumber() then
                    PlayerResource:ModifyGold(self.id,40,false,DOTA_ModifyGold_WardKill)
                    SendOverheadEventMessage(self.parent, OVERHEAD_ALERT_GOLD, self.parent, 40, nil)
                end
                tg.target:Destroy()
            end
        end
   end
end

function modifier_player:OnAbilityExecuted(tg)
    if IsServer() then
            if tg.unit==self.parent  and not self.parent:IsIllusion() then
                local name=tg.ability:GetName()
                    if  tg.ability:IsItem() and (name=="item_ward_observer" or name=="item_ward_dispenser" or name=="item_ward_sentry")  then
                            if CDOTA_PlayerResource.TG_HERO[self.id + 1].use_ward~=nil then
                                CDOTA_PlayerResource.TG_HERO[self.id + 1].use_ward=CDOTA_PlayerResource.TG_HERO[self.id + 1].use_ward+1
                            end
                    end
            end
    end
 end

 function modifier_player:OnHeroKilled(tg)
    if IsServer() then
         if tg.attacker==self.parent and tg.unit:IsRealHero() and not self.parent:IsIllusion() then
            local level1=self.parent:GetLevel()
            local level2=tg.unit:GetLevel()
            if level and level2 and level2>level1 then
                local lv=level2-level
                self.parent:AddExperience(lv*700, DOTA_ModifyXP_Unspecified, false, false)
                PlayerResource:ModifyGold(self.id,lv*300 ,false,DOTA_ModifyGold_Unspecified)
            end
         end
         if tg.unit==self.parent and not self.parent:IsIllusion() and tg.attacker:IsRealHero() then
            		if tg.unit:GetLevel()<tg.attacker:GetLevel() then
                            PlayerResource:ModifyGold(self.parent,RandomInt(400,1000), false, DOTA_ModifyGold_Unspecified)
                            tg.unit:AddExperience(RandomInt(400,900), DOTA_ModifyXP_Unspecified, false, false)
					end
                    if PlayerResource:GetConnectionState(self.id) == DOTA_CONNECTION_STATE_ABANDONED then
                        self.parent:SetMinimumGoldBounty(0)
                        self.parent:SetMaximumGoldBounty(0)
                        self.parent:SetCustomDeathXP(0)
                    end
        end
    end
 end
