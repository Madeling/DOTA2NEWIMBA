primal_spring=class({})
LinkLuaModifier("modifier_primal_spring_motion", "heros/hero_monkey_king/primal_spring.lua", LUA_MODIFIER_MOTION_BOTH)
function primal_spring:IsHiddenWhenStolen() 
    return false 
end

function primal_spring:IsStealable() 
    return true 
end

function primal_spring:IsRefreshable() 			
    return true 
end

function primal_spring:GetAOERadius() 			
    return self:GetSpecialValueFor("impact_radius") 
end


function primal_spring:OnSpellStart()
    local caster=self:GetCaster()
    MK(caster)
    local target_pos=self:GetCursorPosition()
    local caster_pos=caster:GetAbsOrigin()
    local RD=self:GetSpecialValueFor("impact_radius")
    local dis_=self:GetSpecialValueFor("dis")+caster:GetCastRangeBonus()
    local dis=TG_Distance(caster_pos,target_pos)
    if dis> dis_ then 
        target_pos=target_pos-caster:GetForwardVector()*(dis-dis_)
        dis=dis_
    end 
    local dir=TG_Direction2(target_pos,caster_pos)
    if caster:HasModifier("modifier_tree_dance_motion") then
        caster:RemoveModifierByName("modifier_tree_dance_motion")
    end
    if caster:HasModifier("modifier_tree_dance_height") then
        caster:RemoveModifierByName("modifier_tree_dance_height")
    end
    local particle = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_cast_arcana_fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, target_pos)
    ParticleManager:SetParticleControl(particle, 1, Vector(RD,RD,RD))
    ParticleManager:SetParticleControl(particle, 3, target_pos)
    ParticleManager:SetParticleControl(particle, 4, target_pos)
    ParticleManager:SetParticleControl(particle, 5, target_pos)
    ParticleManager:ReleaseParticleIndex(particle)
    local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_spring_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt( particle2, 0, caster, PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )	
    ParticleManager:SetParticleControlEnt( particle2, 1, caster, PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
    ParticleManager:ReleaseParticleIndex(particle2)
    caster:AddNewModifier(caster, self, "modifier_primal_spring_motion", {dir=dir,dis=dis,pos=target_pos})
end

modifier_primal_spring_motion=class({})
function modifier_primal_spring_motion:IsDebuff() 	
	return false 
end

function modifier_primal_spring_motion:IsHidden() 			
	return true 
end

function modifier_primal_spring_motion:IsPurgable() 		
	return false 
end

function modifier_primal_spring_motion:IsPurgeException() 	
	return false 
end

function modifier_primal_spring_motion:OnCreated(tg)
    if not IsServer() then
        return
    end
    self:GetParent():StartGesture(ACT_DOTA_MK_SPRING_SOAR)  
    EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_MonkeyKing.Spring.Channel", self:GetParent())
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_jump_start_dust.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(particle)
    local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(particle2)
    self.TARGET=ToVector(tg.pos)
    self.DIR=ToVector(tg.dir)
    self.DIS=tg.dis/2
    self.POS=self:GetParent():GetAbsOrigin()
    self.H=0
    if self:GetParent():HasModifier("modifier_tree_dance_height") then
        self:GetParent():EmitSound("Hero_MonkeyKing.TreeJump.Tree")
        local particle3 = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_jump_treelaunch_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:ReleaseParticleIndex(particle3)
    end
	if not self:ApplyHorizontalMotionController() or not self:ApplyVerticalMotionController()then 
		self:Destroy()
    end

end

function modifier_primal_spring_motion:UpdateVerticalMotion(t, g)
    if not IsServer() then
        return
    end  
    local pos=self:GetParent():GetAbsOrigin()
    self.H=TG_Distance(pos,self.POS)>= self.DIS and self.H-2 or self.H+1
    self.H=self.H>100 and 1 or self.H
    self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self:GetParent():GetUpVector()*self.H)       
end

function modifier_primal_spring_motion:UpdateHorizontalMotion(t, g)
    if not IsServer() then
        return
    end  
    local pos=self:GetParent():GetAbsOrigin()
    local dis=TG_Distance(pos,self.TARGET)
    if dis <= 150 or dis>4000 or pos.z<0 or pos.z>4000 then
        self:Destroy()
        return
    end
    self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.DIR* (1600 / (1.0 / g)))
end

function modifier_primal_spring_motion:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end  
    self:Destroy()
end

function modifier_primal_spring_motion:OnVerticalMotionInterrupted()
    if not IsServer() then
        return
    end  
    self:Destroy()
end

function modifier_primal_spring_motion:OnDestroy()
    if  IsServer() then
        local RD=self:GetAbility():GetSpecialValueFor("impact_radius")
        local DAM=self:GetAbility():GetSpecialValueFor("impact_damage")
        local POS= self:GetParent():GetAbsOrigin()
        self:GetParent():RemoveVerticalMotionController(self)
        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():EmitSound("Hero_MonkeyKing.Spring.Impact")
        self:GetParent():EmitSound("Hero_MonkeyKing.Spring.Target") 
        local particle = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire.vpcf", PATTACH_CUSTOMORIGIN,self:GetParent())
        ParticleManager:SetParticleControl(particle, 0,  Vector(POS.x,POS.y,200))
        ParticleManager:SetParticleControl(particle, 1, Vector(RD,0,0))
        ParticleManager:SetParticleControl(particle, 2, Vector(1,1,1))
        ParticleManager:SetParticleControl(particle, 3,POS)
        ParticleManager:ReleaseParticleIndex(particle)
        self:GetParent():RemoveGesture(ACT_DOTA_MK_SPRING_SOAR)  
        self:GetParent():StartGesture(ACT_DOTA_MK_SPRING_END)  
        local enemies = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(), 
            self.TARGET, 
            nil, 
            RD, 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER, false)
        if #enemies> 0 then 
            for _,target in pairs(enemies) do
                local damage= {
                                    victim = target,
                                    attacker = self:GetParent(),
                                    damage = DAM,
                                    damage_type = DAMAGE_TYPE_MAGICAL,
                                    ability = self:GetAbility(),
                                    }
                ApplyDamage(damage)
            end 
            if self:GetParent():HasAbility("boundless_strike") then
                local AB=self:GetParent():FindAbilityByName("boundless_strike")
                if AB and AB:GetLevel()>0 then 
                    AB:EndCooldown()
                end
            end
        end
    end
end

function modifier_primal_spring_motion:CheckState() 
    return
    {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVULNERABLE ] = true,
        [DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES ] = true,
    } 
end

