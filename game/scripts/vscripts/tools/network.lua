network=class({})


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


function network:IsBan(id)
        local req = CreateHTTPRequestScriptVM("POST", "https://95150.playfabapi.com/Client/LoginWithCustomID")
        req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
        local pf = '{"CustomId": "'..tostring(PlayerResource:GetSteamID(id))..'","CreateAccount": true,"TitleId": "95150"}'
        req:SetHTTPRequestRawPostBody("application/json",pf)
        req:Send(function(res)
                    local resbody = json.decode(res.Body)
                    if resbody==nil then
                        return
                    end
                    local status=resbody["status"]
                    local banmsg
                    if resbody.errorDetails then
                        for key, value in pairs(resbody.errorDetails) do
                                banmsg=tostring(key)
                        end
                    end
                    if status=="Forbidden" then
                        CDOTA_PlayerResource.TG_HERO[id + 1].ban="Forbidden"
                        network:GetPlayerBan(status,id,banmsg)
                    end
        end)
end

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


function network:GetPlayerBan(BAN,id,msg)
    if BAN~=nil then
        local pl=PlayerResource:GetPlayer(id)
        local name=PlayerResource:GetPlayerName(id)
        local hero=pl:GetAssignedHero()
        if BAN=="Forbidden" then
            if not hero:HasModifier("modifier_gnm") then
                    hero:AddNewModifier(hero, nil, "modifier_gnm", {})
                    CustomUI:DynamicHud_Create(id,"BAN_ID","file://{resources}/layout/custom_game/net.xml",nil)
                    Timers:CreateTimer(7, function()
                        Notifications:TopToAll({text = name.."-"..msg.."-被封禁", duration = 5.0, style = {["font-size"] = "40px", color = "#ffffff"}})
                        return nil
                    end)
            end
        else
            if hero:HasModifier("modifier_gnm") then
                hero:RemoveModifierByName("modifier_gnm")
                CustomUI:DynamicHud_Destroy( id, "BAN_ID")
            end
        end
    end
end


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


function network:Send_Request(tg)
    if tg==nil then
        return
    end
    local req = CreateHTTPRequestScriptVM("POST", "https://95150.playfabapi.com/"..tg.PORT.."/"..tg.FBR)
    req:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    req:SetHTTPRequestHeaderValue(tg.TYPE, tg.ST)
    req:SetHTTPRequestRawPostBody("application/json",tg.POST)
    req:Send(function(res)
        local resbody = json.decode(res.Body)
        tg.Method(resbody)
    end)
end



----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------



function network:CreateData(id)
    local data={}
    local steamid=PlayerResource:GetSteamID(id)
    local name=PlayerResource:GetPlayerName(id)
    data.name=name
    data.id=tostring(steamid)
    data.kill=0
    data.death=0
    data.max_count=0
    data.win=0
    data.roshan=0
    data.tower=0
    data.use_ward=0
    data.des_ward=0
    data.hk=0
    local encoded = json.encode(data)
    local request = CreateHTTPRequestScriptVM("PUT",CDOTA_PlayerResource.address.. data.id..'.json')
    request:SetHTTPRequestRawPostBody("application/json", encoded)
    request:Send(function( result )
            if  (result.StatusCode ~= 200) then
                 print("failed >CreateData")
            return false
        end
    end)
end


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


function network:LoadData(id)
   local steamid=PlayerResource:GetSteamID(id)
   local pl=PlayerResource:GetPlayer(id)
   local num=id+1
   local pid=id
   local tb={}
   local request = CreateHTTPRequestScriptVM( "GET", CDOTA_PlayerResource.address..tostring(steamid)..'.json')
    request:Send( function( result )
        if  (result.StatusCode ~= 200) then
               print("failed >LoadData")
               network:LoadData(pid)
            return false
        end
         local obj= json.decode(result.Body)
        if not obj then
            network:CreateData(pid)
            CDOTA_PlayerResource.TG_HERO[num].des_ward=0
            CDOTA_PlayerResource.TG_HERO[num].use_ward=0
            CDOTA_PlayerResource.TG_HERO[num].kill=0
            CDOTA_PlayerResource.TG_HERO[num].death=0
            CDOTA_PlayerResource.TG_HERO[num].win=0
            CDOTA_PlayerResource.TG_HERO[num].max_count=0
            CDOTA_PlayerResource.TG_HERO[num].roshan=0
            CDOTA_PlayerResource.TG_HERO[num].tower=0
            CDOTA_PlayerResource.TG_HERO[num].hk=0
            tb={0,0,0,0,0,0,0,0,0}
            CustomNetTables:SetTableValue("player_data", tostring(steamid), tb)
            return false
        else
                            CDOTA_PlayerResource.TG_HERO[num].kill=obj.kill
                            CDOTA_PlayerResource.TG_HERO[num].death=obj.death
                            CDOTA_PlayerResource.TG_HERO[num].win=obj.win
                            CDOTA_PlayerResource.TG_HERO[num].max_count=obj.max_count
                            CDOTA_PlayerResource.TG_HERO[num].roshan=obj.roshan
                            CDOTA_PlayerResource.TG_HERO[num].tower=obj.tower
                            CDOTA_PlayerResource.TG_HERO[num].des_ward=obj.des_ward
                            CDOTA_PlayerResource.TG_HERO[num].use_ward=obj.use_ward
                            CDOTA_PlayerResource.TG_HERO[num].hk=obj.hk
                            tb={
                                obj.kill,
                                obj.death,
                                obj.max_count,
                                obj.win,
                                obj.roshan,
                                obj.tower,
                                obj.use_ward,
                                obj.des_ward,
                                obj.hk
                            }
                            CustomNetTables:SetTableValue("player_data", tostring(steamid),tb)
        end
    end )
end


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


function network:LoadHeroWR()
   local request = CreateHTTPRequestScriptVM( "GET", CDOTA_PlayerResource.wr_address..'.json')
    request:Send( function( result )
        if  (result.StatusCode ~= 200) then
               print("failed > LoadHeroWR")
               network:LoadHeroWR()
            return false
        end
         local obj= json.decode(result.Body)
        if not obj then
            return false
        end
            CDOTA_PlayerResource.HeroWR=obj
    end )
end


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


function network:UpdateData(data)
        local requestP = CreateHTTPRequestScriptVM("PUT",CDOTA_PlayerResource.address..data.id..'.json')
        requestP:SetHTTPRequestRawPostBody("application/json", json.encode(data))
        requestP:Send(function( result )
            if (result.StatusCode ~= 200) then
                print("failed > UpdateData")
                network:UpdateData(data)
                return false
            end
        end)
end


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------



function network:UpdateHeroWR(winTeam)
    if CDOTA_PlayerResource.wr_key=="test" then
           return
    end
    local request = CreateHTTPRequestScriptVM( "GET", CDOTA_PlayerResource.wr_address..'.json')
    request:Send( function( result )
        if (result.StatusCode ~= 200) then
               print("failed >UpdateHeroWR")
               network:UpdateHeroWR(winTeam)
            return false
        end
        local obj= json.decode(result.Body)
        if not obj then
            for a=1,#CDOTA_PlayerResource.TG_HERO do
                    if CDOTA_PlayerResource.TG_HERO~=nil and #CDOTA_PlayerResource.TG_HERO>0  then
                            local hero=CDOTA_PlayerResource.TG_HERO[a]
					        local name=hero:GetName()
                            local team=hero:GetTeam()
                            local table={}
                            table.count=1
                            table.win=0
                            if team==winTeam then
                                    table.win=1
                            end
                            local requestP = CreateHTTPRequestScriptVM("PUT",CDOTA_PlayerResource.wr_address..name..'.json')
                            requestP:SetHTTPRequestRawPostBody("application/json", json.encode(table))
                            requestP:Send(function( result )
                            end)
                    end
			end
            return false
        end
                for a=1,#CDOTA_PlayerResource.TG_HERO do
				if CDOTA_PlayerResource.TG_HERO~=nil and #CDOTA_PlayerResource.TG_HERO>0  then
                        local hero=CDOTA_PlayerResource.TG_HERO[a]
					    local name=hero:GetName()
                        local team=hero:GetTeam()
                        local table={}
                        if obj[name]==nil then
                                table.win=0
                                if team==winTeam then
                                    table.win=1
                                end
                                table.count=1
                        else
                                table.win=obj[name]["win"]
                                if team==winTeam then
                                        table.win=table.win+1
                                end
                                        table.count=obj[name]["count"]+1
                        end
                        local requestP = CreateHTTPRequestScriptVM("PUT",CDOTA_PlayerResource.wr_address..name..'.json')
                        requestP:SetHTTPRequestRawPostBody("application/json", json.encode(table))
                        requestP:Send(function( result )
                        end)
				end
		    end
        end )
end
