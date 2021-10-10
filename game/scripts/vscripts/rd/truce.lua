truce=class({})

function truce:IsStealable() 
    return false 
end

function truce:IsRefreshable() 			
    return false 
end

function truce:OnSpellStart()
    local caster=self:GetCaster() 
    Notifications:TopToAll({text="停战！！暂停40秒，大家可以去上个厕所", duration=40, class="NotificationMessage",continue=true,style={color="#EEE5DE",["font-size"]="50px"}})
    EmitAnnouncerSound('announcer_ann_custom_generic_alert_13')
    PauseGame(true)
    Timers:CreateTimer({
        useGameTime = false,
        endTime = 40,
        callback = function()
            PauseGame(false)
            EmitAnnouncerSound("announcer_ann_custom_begin")
            caster:AddNewModifier(caster, self, "modifier_truesight_f", {num=400})
        end
      })
    self:SetActivated(false)
end