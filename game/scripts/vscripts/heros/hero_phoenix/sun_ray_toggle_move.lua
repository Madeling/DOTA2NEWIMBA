sun_ray_toggle_move=class({})
LinkLuaModifier("modifier_sun_ray_toggle_move", "heros/hero_phoenix/sun_ray_toggle_move.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function sun_ray_toggle_move:IsHiddenWhenStolen() 
    return false 
end

function sun_ray_toggle_move:IsStealable() 
    return false 
end

function sun_ray_toggle_move:IsRefreshable() 			
    return true 
end

function sun_ray_toggle_move:OnSpellStart()
    local caster=self:GetCaster()
    local caster_pos=caster:GetAbsOrigin()
    local cur_pos=self:GetCursorPosition()
    local dir=TG_Direction(caster_pos,cur_pos)
    local dis=TG_Distance(caster_pos,cur_pos)
    local time=dis/400
	caster:AddNewModifier(caster, self, "modifier_sun_ray_toggle_move", {duration=time,dir=dir})
end

modifier_sun_ray_toggle_move=class({})

function modifier_sun_ray_toggle_move:IsHidden() 			
    return false 
end

function modifier_sun_ray_toggle_move:IsPurgable() 			
    return false 
end

function modifier_sun_ray_toggle_move:IsPurgeException() 	
    return false 
end

function modifier_sun_ray_toggle_move:OnCreated(tg)
    if not IsServer() then
        return
    end
    self.DIR=ToVector(tg.dir)
		if not self:ApplyHorizontalMotionController()then 
			self:Destroy()
		end

end

function modifier_sun_ray_toggle_move:OnRefresh(tg)
    if not IsServer() then
        return
    end
    self.DIR=ToVector(tg.dir)
		if not self:ApplyHorizontalMotionController()then 
			self:Destroy()
		end

end

function modifier_sun_ray_toggle_move:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end  

    if self:GetParent():HasModifier("modifier_supernova_buff") then 
        return
    end
    
    self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.DIR* -(400 / (1.0 / FrameTime())))
end

function modifier_sun_ray_toggle_move:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end

function modifier_sun_ray_toggle_move:OnDestroy()
    self.DIR=nil
    if not IsServer() then
        return
    end
    self:GetParent():RemoveHorizontalMotionController(self)
end
