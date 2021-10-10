droiyan=class({})
LinkLuaModifier("modifier_droiyan", "rd/droiyan.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_droiyan_buff", "rd/droiyan.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_droiyan_cbuff", "rd/droiyan.lua", LUA_MODIFIER_MOTION_NONE)
function droiyan:IsStealable() 
    return false 
end

function droiyan:IsRefreshable() 			
    return false 
end


function droiyan:OnSpellStart()
    if PVP==false then 
        PVP=true
        local caster=self:GetCaster() 
        EmitGlobalSound("TG.bgm1")
        Notifications:BottomToAll({text = "10秒后将开启决战，击败[ "..PlayerResource:GetPlayerName(caster:GetPlayerOwnerID()).." ]赢得这场IMBA胜利", duration = 10.0, style = {["font-size"] = "50px", color = "#ffffff"}})
        Notifications:BottomToAll({text = "被"..PlayerResource:GetPlayerName(caster:GetPlayerOwnerID()).."击杀40个人头将会输掉这场比赛", duration = 10.0, style = {["font-size"] = "50px", color = "#ffffff"}})
        CreateModifierThinker(caster, self, "modifier_droiyan", {}, C_POS, caster:GetTeamNumber(), false)
        AddFOWViewer(caster:GetTeamNumber(), C_POS, 3000,9999, false)
        self:SetActivated(false)
    end
end

modifier_droiyan=class({})

function modifier_droiyan:IsPurgable() 			
    return false 
end

function modifier_droiyan:IsPurgeException() 	
    return false 
end

function modifier_droiyan:IsHidden()				
    return true 
end

function modifier_droiyan:DeclareFunctions()
	return 
    {
	    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
end

function modifier_droiyan:OnCreated(tg)
    if IsServer() then   
		local pfx = ParticleManager:CreateParticle("particles/econ/items/disruptor/disruptor_resistive_pinfold/disruptor_ecage_kineticfield.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(3000, 0, 0))
		ParticleManager:SetParticleControl(pfx, 2, Vector(9999, 0, 0))
		self:AddParticle(pfx, false, false, 15, false, false)
        GameRules:SetCreepSpawningEnabled(false) 
        local num=GameRules:GetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS)+GameRules:GetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS)
        for i=1, num or 30 do
            if CDOTA_PlayerResource.TG_HERO[i] then
                local hero = CDOTA_PlayerResource.TG_HERO[i]
                if hero  then
                    if not hero:IsAlive() then    
                        hero:RespawnHero(false, false)
                    end 
                    hero:AddNewModifier(hero, self:GetAbility(), "modifier_imba_stunned", {duration=10})
                    if hero==self:GetCaster() then 
                        local caster=self:GetCaster() 
                        if caster:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
                            local team= DOTA_TEAM_BADGUYS
                            for a=5,20 do 
                                local item=caster:GetItemInSlot(a)
                                if item and item:IsNeutralDrop() then
                                    caster:DropItemAtPositionImmediate(caster:FindItemInInventory(item:GetName()),caster:GetTeamNumber()==DOTA_TEAM_GOODGUYS and  GOOD_POS  or  BAD_POS)
                                end 
                            end 
                            GameRules:SetCustomGameTeamMaxPlayers(team,GameRules:GetCustomGameTeamMaxPlayers(team)+1)
                            caster:ChangeTeam(team) 
                            PlayerResource:SetCustomTeamAssignment(caster:GetPlayerOwnerID(),team)
                            if caster:HasModifier("modifier_player") then
                                caster:RemoveModifierByName("modifier_player")
                                caster:AddNewModifier(caster, nil, "modifier_player",{}) 	
                            end
                        end
                        caster:AddNewModifier(caster, self, "modifier_droiyan_cbuff", {})
                    elseif  hero:GetTeamNumber()==DOTA_TEAM_BADGUYS then  
                        local caster=hero 
                        local team=caster:GetTeamNumber()==DOTA_TEAM_GOODGUYS and  DOTA_TEAM_BADGUYS  or  DOTA_TEAM_GOODGUYS
                        for a=5,20 do 
                            local item=caster:GetItemInSlot(a)
                            if item and item:IsNeutralDrop() then
                                caster:DropItemAtPositionImmediate(caster:FindItemInInventory(item:GetName()),caster:GetTeamNumber()==DOTA_TEAM_GOODGUYS and  GOOD_POS  or  BAD_POS)
                            end 
                        end 
                        GameRules:SetCustomGameTeamMaxPlayers(team,GameRules:GetCustomGameTeamMaxPlayers(team)+1)
                        caster:ChangeTeam(team) 
                        PlayerResource:SetCustomTeamAssignment(caster:GetPlayerOwnerID(),team)
                        if caster:HasModifier("modifier_player") then
                            caster:RemoveModifierByName("modifier_player")
                            caster:AddNewModifier(caster, nil, "modifier_player",{}) 	
                        end
                    end 
                    hero:Interrupt()
                    hero:Stop()
                    PlayerResource:ModifyGold(hero:GetPlayerOwnerID(),99999,true,DOTA_ModifyGold_Unspecified)
                    hero:AddExperience(99999, DOTA_ModifyXP_Unspecified, false, false)
                    hero:AddNewModifier(hero, self:GetAbility(), "modifier_droiyan_buff", {})
                    FindClearSpaceForUnit(hero, C_POS, true)
                end
            end
        end
    end 
end


modifier_droiyan_buff=class({})

function modifier_droiyan_buff:IsPurgable() 			
    return false 
end

function modifier_droiyan_buff:IsPurgeException() 	
    return false 
end

function modifier_droiyan_buff:IsHidden()				
    return true 
end

function modifier_droiyan_buff:RemoveOnDeath()				
    return false 
end

function modifier_droiyan_buff:IsPermanent()				
    return true 
end

function modifier_droiyan_buff:OnCreated()
	if IsServer() then
        self:StartIntervalThink(FrameTime())
	end
end

function modifier_droiyan_buff:OnIntervalThink()
	if TG_Distance(self:GetParent():GetAbsOrigin(),C_POS)>3010  then
        FindClearSpaceForUnit(self:GetParent(), C_POS, true)
	end
end


modifier_droiyan_cbuff=class({})

function modifier_droiyan_cbuff:IsPurgable() 			
    return false 
end

function modifier_droiyan_cbuff:IsPurgeException() 	
    return false 
end

function modifier_droiyan_cbuff:IsHidden()				
    return true 
end

function modifier_droiyan_cbuff:RemoveOnDeath()				
    return false 
end

function modifier_droiyan_cbuff:IsPermanent()				
    return true 
end

function modifier_droiyan_cbuff:CheckState() 
	return 
	{
        [MODIFIER_STATE_STUNNED] = false, 
        [MODIFIER_STATE_SILENCED] = false, 
        [MODIFIER_STATE_DISARMED] = false,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	} 
end

function modifier_droiyan_cbuff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_MODEL_CHANGE, 
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_EVENT_ON_DEATH
    } 
end

function modifier_droiyan_cbuff:OnDeath(tg) 
    if IsServer() then
        if tg.unit==self:GetParent() then   
            local team=self:GetParent():GetTeamNumber()==DOTA_TEAM_GOODGUYS and  DOTA_TEAM_BADGUYS  or  DOTA_TEAM_GOODGUYS 
            GameRules:MakeTeamLose(self:GetParent():GetTeamNumber())
            GameRules:SetGameWinner(team)
        elseif  tg.unit~=self:GetParent() and  tg.unit:IsRealHero() then 
            PVP_NUM=PVP_NUM+1
            if PVP_NUM>=40 then    
                local team=self:GetParent():GetTeamNumber()==DOTA_TEAM_GOODGUYS and  DOTA_TEAM_BADGUYS  or  DOTA_TEAM_GOODGUYS 
                GameRules:MakeTeamLose(team)
                GameRules:SetGameWinner(self:GetParent():GetTeamNumber())
            end 
        end
    end
end

function modifier_droiyan_cbuff:GetModifierModelChange() 
    return "models/items/warlock/golem/ahmhedoq/ahmhedoq.vmdl"
end

function modifier_droiyan_cbuff:GetModifierModelScale() 
    return 200
end

function modifier_droiyan_cbuff:GetModifierPhysicalArmorBonus() 	
    return 500
end

function modifier_droiyan_cbuff:GetModifierHealthBonus() 	
    return 50000
end


function modifier_droiyan_cbuff:GetModifierMagicalResistanceBonus() 	
    return 100
end