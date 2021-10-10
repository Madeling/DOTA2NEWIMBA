sun_ray=class({})

LinkLuaModifier("modifier_sun_ray_buff", "heros/hero_phoenix/sun_ray.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function sun_ray:IsHiddenWhenStolen() 
    return false 
end

function sun_ray:IsStealable() 
    return true 
end

function sun_ray:IsRefreshable() 			
    return true 
end

function sun_ray:GetAssociatedSecondaryAbilities() 
    return "sun_ray_stop" 
end

function sun_ray:OnSpellStart()
    local caster=self:GetCaster()
    local caster_pos=caster:GetAbsOrigin()
    local cur_pos=self:GetCursorPosition()
    local dis=TG_Distance(caster_pos,cur_pos)
    local dir=TG_Direction(cur_pos,caster_pos)
    local dur=self:GetSpecialValueFor( "dur" )
    caster:EmitSound("Hero_Phoenix.SunRay.Beam")
    caster:EmitSound("Hero_Phoenix.SunRay.Cast")
    local ab1= caster:FindAbilityByName("sun_ray_stop")
    caster.ab2= caster:FindAbilityByName("sun_ray_toggle_move")
    if ab1~=nil then ab1:SetLevel(1) end 
    if caster.ab2~=nil then caster.ab2:SetLevel(1) end 
    caster:SwapAbilities( "sun_ray", "sun_ray_stop", false, true )
    caster.sun_rayfx = ParticleManager:CreateParticle( "particles/econ/items/phoenix/phoenix_solar_forge/phoenix_sunray_solar_forge.vpcf", PATTACH_WORLDORIGIN, nil )
    caster:AddNewModifier(caster, self, "modifier_sun_ray_buff", {duration=dur})
end

modifier_sun_ray_buff=class({})

function modifier_sun_ray_buff:IsHidden() 			
    return false 
end

function modifier_sun_ray_buff:IsPurgable() 			
    return false 
end

function modifier_sun_ray_buff:IsPurgeException() 	
    return false 
end
function modifier_sun_ray_buff:GetEffectName()
	return "particles/units/heroes/hero_phoenix/phoenix_sunray_mane.vpcf"
end

function modifier_sun_ray_buff:OnCreated() 
    local ab=self:GetAbility()	
    local tick=ab:GetSpecialValueFor( "tick" )
    local rd=ab:GetSpecialValueFor( "rd" )
    local hp=ab:GetSpecialValueFor( "hp" )
    local base_dam=ab:GetSpecialValueFor( "base_dam" )+self:GetCaster():TG_GetTalentValue("special_bonus_phoenix_4")
    local dam_per=ab:GetSpecialValueFor( "dam_per" )+self:GetCaster():TG_GetTalentValue("special_bonus_phoenix_3")
    local base_heal=ab:GetSpecialValueFor( "base_heal" )+self:GetCaster():TG_GetTalentValue("special_bonus_phoenix_4")
    local heal_per=ab:GetSpecialValueFor( "heal_per" )+self:GetCaster():TG_GetTalentValue("special_bonus_phoenix_3")
    local currhp=ab:GetSpecialValueFor( "currhp" )+self:GetCaster():TG_GetTalentValue("special_bonus_phoenix_7")
    local damt=DAMAGE_TYPE_MAGICAL
    local dam=0
    self.ST=true
    if not IsServer() then
        return
    end 
    local caster=self:GetParent()
    local team=caster:GetTeam()
    caster:EmitSound("Hero_Phoenix.SunRay.Loop")
    self.HEAD=self:GetParent():ScriptLookupAttachment( "attach_head" )
    self:OnIntervalThink()
    self:StartIntervalThink(FrameTime())
    Timers:CreateTimer(0, function()
        if self.ST~=nil and self.ST then
            if caster:GetHealth()>=10 then 
            caster:SetHealth(caster:GetHealth() * ( 100 - hp) / 100 )
        end
        if self.end_Pos~=nil then
            local heros = FindUnitsInLine(team,caster:GetAbsOrigin(),self.end_Pos, caster, rd, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE)
                if heros~=nil then
                    for _,target in pairs(heros) do
                        if Is_Chinese_TG(caster,target) and target~=caster then
                            local heal=base_heal+target:GetMaxHealth()*heal_per*0.01
                            target:Heal(heal, scaster)
                            SendOverheadEventMessage(target, OVERHEAD_ALERT_HEAL, target,heal,nil)
                        else
                            if caster:GetHealth()<=caster:GetMaxHealth()*0.7 then
                                damt=DAMAGE_TYPE_PURE
                                dam=base_dam+(target:GetMaxHealth()*dam_per*0.01)+(caster:GetHealth()*currhp*0.01)
                            else
                                damt=DAMAGE_TYPE_MAGICAL
                                dam=base_dam+(target:GetMaxHealth()*dam_per*0.01)
                            end
                            if target~=caster then
                                local damageTable = {
                                    attacker = caster,
                                    victim = target,
                                    damage = dam,
                                    damage_type = damt,
                                    ability = ab
                                }
                                ApplyDamage(damageTable)
                            end
                        end
                    end
                end
            end
            return tick
        else
            return nil
        end
    end)
end

function modifier_sun_ray_buff:OnIntervalThink()
   
    if self:GetCaster():HasModifier("modifier_icarus_dive_move") then 
        if self:GetCaster().modifier_icarus_dive_move~=nil then
            ParticleManager:SetParticleControl(self:GetCaster().sun_rayfx, 0,self:GetCaster().modifier_icarus_dive_move+ self:GetParent():GetUpVector()*2000)
            self.end_Pos=Vector(self:GetCaster().modifier_icarus_dive_move.x,self:GetCaster().modifier_icarus_dive_move.y,self:GetCaster().modifier_icarus_dive_move.z+100)
            ParticleManager:SetParticleControl( self:GetCaster().sun_rayfx, 1,self.end_Pos)
        end
    else
        ParticleManager:SetParticleControl(self:GetCaster().sun_rayfx, 0,self:GetParent():GetAttachmentOrigin(self.HEAD))
        self.end_Pos= self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 2000
        self.end_Pos = GetGroundPosition( self.end_Pos, nil )
        self.end_Pos.z = self.end_Pos.z + 100
        ParticleManager:SetParticleControl( self:GetCaster().sun_rayfx, 1, self.end_Pos )
        for i=1, math.ceil( 2000 / 400 ) do
            AddFOWViewer(self:GetParent():GetTeamNumber(), ( self:GetParent():GetAbsOrigin() +  self:GetParent():GetForwardVector() * ( 400 * (i-1)*1.5 ) ), 200, 0.1, false)
        end
    end
end

function modifier_sun_ray_buff:OnDestroy()
    self.end_Pos=nil 
    self.ST=nil	
    self.HEAD=nil
    if not IsServer() then
        return
    end 
    local caster= self:GetCaster()
    local ab=caster:FindAbilityByName("sun_ray")
    caster:StopSound( "Hero_Phoenix.SunRay.Loop")
    caster:EmitSound( "Hero_Phoenix.SunRay.Stop")
    TG_Remove_Modifier(caster,"modifier_sun_ray_toggle_move",0)
    if ab~=nil and ab:IsHidden() then
        caster:SwapAbilities( "sun_ray", "sun_ray_stop", true, false )
    end
    if caster.ab2~=nil then
        caster.ab2:SetLevel(0)
    end
    if caster.sun_rayfx~=nil then	
        ParticleManager:DestroyParticle(caster.sun_rayfx, true )
        ParticleManager:ReleaseParticleIndex(caster.sun_rayfx )
    end
end

function modifier_sun_ray_buff:CheckState()
    return
    { 
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }
end

function modifier_sun_ray_buff:DeclareFunctions() 
    return 
    { 
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
    } 
end


function modifier_sun_ray_buff:GetOverrideAnimation() 
        return ACT_DOTA_OVERRIDE_ABILITY_3 
end

function modifier_sun_ray_buff:GetModifierMoveSpeed_Limit()
		return 1
end

function modifier_sun_ray_buff:GetModifierMoveSpeed_Max()
		return 1
end

function modifier_sun_ray_buff:GetModifierIgnoreCastAngle()
    return 360
end


