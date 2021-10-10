


function OnStartTouch( trigger )
	--trigger.caller
	local hero=trigger.activator
    if not hero:HasModifier("modifier_charge_of_darkness") and  not hero:HasModifier("modifier_imba_ball_lightning_travel") then
        local Knockback ={
            should_stun = 0,
            knockback_duration = 1,
            duration = 1,
            knockback_distance = 2000,
            knockback_height = 300,
            center_x =  hero:GetAbsOrigin().x-hero:GetForwardVector(),
            center_y =  hero:GetAbsOrigin().y-hero:GetRightVector(),
            center_z =  hero:GetAbsOrigin().z
        }
        EmitSoundOn( "TG.jump", hero )
        hero:AddNewModifier(hero,nil, "modifier_knockback", Knockback)
    end
end


