network=class({})

function network:Create_Login(id)
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
                    if status=="Forbidden" then
                        CDOTA_PlayerResource.TG_HERO[id + 1].ban="Forbidden"
                        network:GetPlayerBan(status,id)
                    else
                    local data=resbody["data"]
                    if data==nil then
                        return
                    end
                    local session_ticket=data["SessionTicket"]
                    local PlayFabId=data["PlayFabId"]
                    local pl=PlayerResource:GetPlayer(id)
                    CDOTA_PlayerResource.TG_HERO[id + 1].session_ticket=session_ticket
                    CDOTA_PlayerResource.TG_HERO[id + 1].pbid=PlayFabId
                    pl.session_ticket=session_ticket
                    pl.pbid=PlayFabId
                    network:First_Login(session_ticket,id)
                end
        end)
end


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------



function network:First_Login(session_ticket,id)
    local pl=PlayerResource:GetPlayer(id)
    local name=PlayerResource:GetPlayerName(id)
    local num=id+1
    local tb={}
        network:Send_Request({
                    FBR="GetUserData",
                    TYPE="X-Authentication",
                    ST=session_ticket,
                    PORT="Client",
                    POST='{"Keys": ["PL"]}',
                    Method=(function(resbody)
                        local data=resbody["data"]
                        if data==nil then
                            return
                        end
                        local data2=data["Data"]
                        local PL=data2["PL"]
                        local SID=PlayerResource:GetSteamID(id)
                        if PL==nil then
                            network:Send_Request({
                                FBR="UpdateUserTitleDisplayName",
                                TYPE="X-Authentication",
                                ST=session_ticket,
                                PORT="Client",
                                POST='{"DisplayName":"'..name.."+"..tostring(SID)..'","TitleId": "95150"}',
                                Method=(function(data)end)
                            })
                            network:Send_Request({
                                FBR="UpdateUserData",
                                TYPE="X-Authentication",
                                ST=session_ticket,
                                PORT="Client",
                                POST='{"Data":{"PL": '..json.encode('{"kill":0,"death":0,"max_count":0,"win":0,"steamid":"'..tostring(SID)..'","roshan":0,"tower":0,"des_ward":0,"use_ward":0,"steamname":"'..name..'"}')..'},"Permission": "Public"}',
                                Method=(function(data)end)
                            })
                            CDOTA_PlayerResource.TG_HERO[num].des_ward=0
                            CDOTA_PlayerResource.TG_HERO[num].use_ward=0
                            tb={0,0,0,0,0,0,0,0}
                            Timers:CreateTimer({
                                useGameTime = false,
                                endTime =6,
                                callback = function()
                                        table.insert (CDOTA_PlayerResource.NET_DATA,id+1, tb)
                                        CustomNetTables:SetTableValue("player_data", "PLD", CDOTA_PlayerResource.NET_DATA)
                                        CustomGameEventManager:Send_ServerToPlayer(pl,"User_Data",{tb})
                            end
                            })
                        else
                            local VALUE=json.decode(PL["Value"])
                            if VALUE==nil then
                                return
                            end
                            local kill=VALUE["kill"] or 0
                            local death=VALUE["death"]or 0
                            local max_count=VALUE["max_count"] or 0
                            local win=VALUE["win"] or 0
                            local roshan=VALUE["roshan"] or 0
                            local tower=VALUE["tower"] or 0
                            local des_ward=VALUE["des_ward"] or 0
                            local use_ward=VALUE["use_ward"] or 0
                            CDOTA_PlayerResource.TG_HERO[num].kill=kill
                            CDOTA_PlayerResource.TG_HERO[num].death=death
                            CDOTA_PlayerResource.TG_HERO[num].win=win
                            CDOTA_PlayerResource.TG_HERO[num].max_count=max_count
                            CDOTA_PlayerResource.TG_HERO[num].roshan=roshan
                            CDOTA_PlayerResource.TG_HERO[num].tower=tower
                            CDOTA_PlayerResource.TG_HERO[num].des_ward=des_ward
                            CDOTA_PlayerResource.TG_HERO[num].use_ward=use_ward
                            table.insert (tb, kill)
                            table.insert (tb, death)
                            table.insert (tb, max_count)
                            table.insert (tb, win)
                            table.insert (tb, roshan)
                            table.insert (tb, tower)
                            table.insert (tb, use_ward)
                            table.insert (tb, des_ward)
                                table.insert (CDOTA_PlayerResource.NET_DATA,num, tb)
                                CustomNetTables:SetTableValue("player_data", "PLD", CDOTA_PlayerResource.NET_DATA)
                                CustomGameEventManager:Send_ServerToPlayer(pl,"User_Data",{tb})
                            if win/max_count*100 >= 90 then
                                PlayerResource:SetCustomPlayerColor(id,	255,255,0)
                            else
                                PlayerResource:SetCustomPlayerColor(id,	255,255,255)
                            end
                         end
                    end)
                })
end


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------



function network:Game_End(id,tb)
    local pl=PlayerResource:GetPlayer(id)
    local name=PlayerResource:GetPlayerName(id)
    local sid=PlayerResource:GetSteamID(id)
    local session_ticket=CDOTA_PlayerResource.TG_HERO[id + 1].session_ticket
    network:Send_Request({
        FBR="UpdateUserTitleDisplayName",
        TYPE="X-Authentication",
        ST=session_ticket,
        PORT="Client",
        POST='{"DisplayName":"'..name.."+"..tostring(sid)..'","TitleId": "95150"}',
        Method=(function(data)end)
    })
    network:Send_Request({
        FBR="GetUserData",
        TYPE="X-Authentication",
        ST=session_ticket,
        PORT="Client",
        POST='{"Keys": ["PL"]}',
        Method=(function(resbody)
            local data=resbody["data"]
            local data2=data["Data"]
            local PL=data2["PL"]
                local VALUE=json.decode(PL["Value"])
                local kill=VALUE["kill"]
                local death=VALUE["death"]
                local max_count=VALUE["max_count"]
                local win=VALUE["win"]
                local roshan=VALUE["roshan"]
                local tower=VALUE["tower"]
                local use_ward=(CDOTA_PlayerResource.TG_HERO[id+1].use_ward or 0)
                local des_ward=(CDOTA_PlayerResource.TG_HERO[id+1].des_ward or 0)
                kill=kill+tb.K
                death=death+tb.D
                win=win+tb.WR
                max_count=max_count+tb.TN
                roshan=roshan+tb.RS
                tower=tower+tb.TW
                network:Send_Request({
                    FBR="UpdateUserData",
                    TYPE="X-Authentication",
                    ST=session_ticket,
                    PORT="Client",
                    POST='{"Data":{"PL":'..json.encode('{"kill":'..tostring(kill)..',"death":'..tostring(death)..',"max_count":'..tostring(max_count)..',"win":'..tostring(win)..',"steamid":"'..tostring(sid)..'","roshan":'..tostring(roshan)..',"tower":'..tostring(tower)..',"steamname":"'..name..'","use_ward":'..tostring(use_ward)..',"des_ward":'..tostring(des_ward)..'}')..'},"Permission": "Public"}',
                    Method=(function(data)  end)
                })
        end)
    })

end


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


function network:Hero_WinR(id,hero,win,lose)
    local pl=PlayerResource:GetPlayer(id)
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


function network:GetPlayerBan(BAN,id,Reason)
    if BAN~=nil then
        local pl=PlayerResource:GetPlayer(id)
        local name=PlayerResource:GetPlayerName(id)
        local hero=pl:GetAssignedHero()
        if BAN=="Forbidden" then
            if not hero:HasModifier("modifier_gnm") then
                    hero:AddNewModifier(hero, nil, "modifier_gnm", {})
                    CustomUI:DynamicHud_Create(id,"BAN_ID","file://{resources}/layout/custom_game/net.xml",nil)
                    Timers:CreateTimer(7, function()
                        Notifications:TopToAll({text = name.." 是被封禁人员无法进行游玩", duration = 4.0, style = {["font-size"] = "50px", color = "#ffffff"}})
                        --SendToServerConsole( "disconnect" )
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
