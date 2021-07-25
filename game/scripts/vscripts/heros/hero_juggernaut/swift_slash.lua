swift_slash=class({})
LinkLuaModifier("modifier_swift_slash_move", "heros/hero_juggernaut/swift_slash.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_swift_slash_move2", "heros/hero_juggernaut/swift_slash.lua", LUA_MODIFIER_MOTION_BOTH)
function swift_slash:IsHiddenWhenStolen() 
    return false 
end

function swift_slash:IsStealable() 
    return true 
end


function swift_slash:IsRefreshable() 			
    return true 
end

function swift_slash:GetCooldown(iLevel)
    return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_juggernaut_6")
end

function swift_slash:GetCastPoint()			
    if self:GetCaster():TG_HasTalent("special_bonus_juggernaut_8") then
        return 0
    else
        return 0.3
    end
end

function swift_slash:OnSpellStart()
    local caster=self:GetCaster()
    local target_pos=self:GetCursorPosition()
    local caster_pos=caster:GetAbsOrigin()
    local dis=TG_Distance(caster_pos,target_pos)
    local dir=TG_Direction(target_pos,caster_pos)
    if dis>700 then
        dis=700
    end
    local time=dis/1500
    caster:EmitSound("TG.juggjump")
    caster:EmitSound("TG.jugginv")
 --[[   caster.JUMP=true
    local pfx_tgt = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(pfx_tgt, 0, caster_pos)
    ParticleManager:SetParticleControl(pfx_tgt, 1, target_pos)
    ParticleManager:ReleaseParticleIndex(pfx_tgt)
   if not target:IsMagicImmune() then      废弃
    local Knockback ={
        should_stun = true,
        knockback_duration = 0.2,
        duration = 0.2,
        knockback_distance = 0,
        knockback_height = 400,
        center_x =  caster:GetAbsOrigin().x,
        center_y =  caster:GetAbsOrigin().y,
        center_z =  caster:GetAbsOrigin().z
    }
    target:AddNewModifier(caster,self, "modifier_knockback", Knockback)
end  ]]
    local Projectile = 
    {
        Ability = self,
        EffectName = "particles/heros/jugg/jugg_shockwave.vpcf",
        vSpawnOrigin = caster_pos,
        fDistance = 3000,
        fStartRadius = 150,
        fEndRadius =150,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10,
        bDeleteOnHit = true,
        vVelocity = caster:GetForwardVector() * 2000,
        bProvidesVision = false,
    }
    TG_CreateProjectile({id=0,team=caster:GetTeamNumber(),owner=caster,p=Projectile})
    caster:AddNewModifier(caster, self, "modifier_swift_slash_move", {duration=time,dir=dir})
end

function swift_slash:OnProjectileHit_ExtraData(target, location, kv)
    local caster=self:GetCaster()
    TG_IS_ProjectilesValue1(caster,function()
        target=nil
    end)
    if target==nil then
        return
    end
    if target:IsAlive() then
        caster:PerformAttack(target, false, true, true, false, true, false, true)  
    end 
end

modifier_swift_slash_move=class({})

function modifier_swift_slash_move:IsHidden() 			
    return false 
end

function modifier_swift_slash_move:IsPurgable() 			
    return false 
end

function modifier_swift_slash_move:IsPurgeException() 	
    return false 
end

function modifier_swift_slash_move:OnCreated(tg)
    if not IsServer() then
        return
    end
    local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle( particle, false, false, 20, false, false )
    local particle2 = ParticleManager:CreateParticle("particles/heros/jugg/jugg_jump.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle( particle2, false, false, 20, false, false )    
    self.DIR=ToVector(tg.dir)
   -- self.Target = EntIndexToHScript(tg.tar)
    self.POS=self:GetParent():GetAbsOrigin()
    --self.JUMP=true
		if not self:ApplyHorizontalMotionController()then 
			self:Destroy()
		end

end

function modifier_swift_slash_move:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end  

        self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.DIR* (1500 /(1/g)))
end

function modifier_swift_slash_move:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end  
    self:Destroy()
end



function modifier_swift_slash_move:OnDestroy()

    if  IsServer() then
        self:GetParent():RemoveHorizontalMotionController(self)
    --[[    if self:GetParent().JUMP==true then         废弃
            local target_pos=self.Target:GetAbsOrigin()
            local caster_pos=self:GetParent():GetAbsOrigin()
            local dis=TG_Distance(caster_pos,target_pos)
            local dir=TG_Direction(caster_pos,target_pos)
            local time=dis/2000
            self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_swift_slash_move2", {duration=time,dir=dir,dis=dis})
        end]]
    end 
end

function modifier_swift_slash_move:GetMotionPriority() 
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH 
end


function modifier_swift_slash_move:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
end

function modifier_swift_slash_move:GetOverrideAnimation()
    if self:GetParent():GetName()=="npc_dota_hero_juggernaut"  then 
        return ACT_DOTA_VICTORY
    end
        return 0
end

function modifier_swift_slash_move:GetModifierTurnRate_Percentage() 	
	return 100
end

function modifier_swift_slash_move:CheckState()
    return
     {
           [MODIFIER_STATE_INVULNERABLE] = true,
       } 
end

--[[
modifier_swift_slash_move2=class({})


function modifier_swift_slash_move2:IsHidden() 			
    return false 
end

function modifier_swift_slash_move2:IsPurgable() 			
    return false 
end

function modifier_swift_slash_move2:IsPurgeException() 	
    return false 
end

function modifier_swift_slash_move2:OnCreated(tg)
    if not IsServer() then
        return
    end
    local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle( particle, false, false, 20, false, false )
    local particle2 = ParticleManager:CreateParticle("particles/heros/jugg/jugg_jump.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle( particle2, false, false, 20, false, false )    
    self.DIR=ToVector(tg.dir)
    self.DIS=tg.dis/2
    self.H=0
    self.POS=self:GetParent():GetAbsOrigin()
		if not self:ApplyHorizontalMotionController() then 
			self:Destroy()
        end
        self:GetParent():EmitSound("TG.jugginv")
        local Projectile = 
        {
            Ability = self:GetAbility(),
            EffectName = "particles/heros/jugg/jugg_shockwave.vpcf",
            vSpawnOrigin = self.POS,
            fDistance = 3000,
            fStartRadius = 300,
            fEndRadius =300,
            Source = self:GetParent(),
            bHasFrontalCone = false,
            bReplaceExisting = false,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            fExpireTime = GameRules:GetGameTime() + 10,
            bDeleteOnHit = true,
            vVelocity = self:GetParent():GetForwardVector() * 2000,
            bProvidesVision = false,
        }
        TG_CreateProjectile({id=0,team=self:GetParent():GetTeamNumber(),owner=self:GetParent(),p=Projectile})
end

function modifier_swift_slash_move2:UpdateHorizontalMotion(t, g)
    if not IsServer() then
        return
    end  
        self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.DIR* -(2000 / (1.0 / FrameTime())))
end


function modifier_swift_slash_move2:OnDestroy()
    if  IsServer() then
        self:GetParent():RemoveHorizontalMotionController(self)
    end
end

function modifier_swift_slash_move2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end

function modifier_swift_slash_move2:GetOverrideAnimation()
    return ACT_DOTA_ATTACK_EVENT
end

function modifier_swift_slash_move2:GetActivityTranslationModifiers()
    return "favor"
end

function modifier_swift_slash_move2:GetModifierTurnRate_Percentage() 	
	return 100
end

function modifier_swift_slash_move2:CheckState()
    return
     {
           [MODIFIER_STATE_INVULNERABLE] = true,
       } 
end

]]