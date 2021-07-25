CreateTalents("npc_dota_hero_dark_seer", "heros/hero_dark_seer/seer_vacuum.lua")
seer_vacuum=class({})
LinkLuaModifier("modifier_seer_vacuum_m", "heros/hero_dark_seer/seer_vacuum.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_seer_vacuum_wall", "heros/hero_dark_seer/seer_vacuum.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_seer_vacuum_sp", "heros/hero_dark_seer/seer_vacuum.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function seer_vacuum:IsHiddenWhenStolen() 
    return false 
end

function seer_vacuum:IsStealable() 
    return true 
end


function seer_vacuum:IsRefreshable() 			
    return true 
end

function seer_vacuum:GetAOERadius() 			
    return 600 
end


function seer_vacuum:OnSpellStart()
    local caster=self:GetCaster()
    local curpos=self:GetCursorPosition()
    local radius=self:GetSpecialValueFor("radius")
    local damage=self:GetSpecialValueFor("damage")
    local stun=self:GetSpecialValueFor("stun")
    local heronum=0
    GridNav:DestroyTreesAroundPoint(curpos,self:GetSpecialValueFor("radius_tree") , true)
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl( particle,0, curpos)
    ParticleManager:SetParticleControl( particle, 1,Vector(radius,0,0))	
    ParticleManager:SetParticleControl( particle, 2, curpos)
    ParticleManager:ReleaseParticleIndex(particle)
    caster:EmitSound("Hero_Dark_Seer.Vacuum")
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(),curpos, nil,  radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if #enemies>0 then
        for _,unit in pairs(enemies) do
            if unit:IsRealHero() then   
                heronum=heronum+1
            end 
            if unit:IsAlive() and not unit:IsMagicImmune() and not unit:HasModifier("modifier_fountain_aura_buff") then      
                local damageTable = {
                    attacker = caster,
                    victim = unit,
                    damage = damage,
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = self
                }
                ApplyDamage(damageTable) 
                if unit:HasModifier("modifier_ion_shell_buff") then 
                    local damageTable = {
                        attacker = caster,
                        victim = unit,
                        damage = damage/2,
                        damage_type = DAMAGE_TYPE_PURE,
                        ability = self
                    }
                    ApplyDamage(damageTable) 
                    unit:AddNewModifier(caster, self, "modifier_imba_stunned", {duration=stun})
                end
                
                if unit:HasModifier("modifier_seer_vacuum_m") then 
                    unit:RemoveModifierByName("modifier_seer_vacuum_m")
                end
                unit:AddNewModifier(caster,self,"modifier_seer_vacuum_m",{duration=self:GetSpecialValueFor("duration"),dir=TG_Direction( curpos,unit:GetAbsOrigin())})
            end
        end
    end
    if heronum>5 and caster:TG_HasTalent("special_bonus_dark_seer_1")  then
        self:EndCooldown()
    end
    CreateModifierThinker(caster, self, "modifier_seer_vacuum_wall", {duration=self:GetSpecialValueFor("wall"),x=curpos.x,y=curpos.y,z=curpos.z}, curpos, caster:GetTeamNumber(), false)

end

modifier_seer_vacuum_wall=class({})

function modifier_seer_vacuum_wall:IsHidden() 			
	return true 
end

function modifier_seer_vacuum_wall:IsPurgable() 		
	return false 
end

function modifier_seer_vacuum_wall:IsPurgeException() 	
	return false 
end

function modifier_seer_vacuum_wall:OnCreated(tg) 	
     self.caster=self:GetCaster()
     self.team=self.caster:GetTeamNumber()
     self.wall=self:GetAbility():GetSpecialValueFor("wall")
     self.spdur=self:GetAbility():GetSpecialValueFor("spdur")
	if IsServer() then
        self.DIS=500    
        if self.caster:TG_HasTalent("special_bonus_dark_seer_7") then
            self.DIS=25000
        end 
        self.POS=Vector(tg.x,tg.y,tg.z)
        self.SPOS=self.POS+self.caster:GetRightVector()*self.DIS
        self.EPOS=self.POS+self.caster:GetRightVector()*-self.DIS
        local P = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_wall_of_replica.vpcf", PATTACH_WORLDORIGIN,nil)
        ParticleManager:SetParticleControl(P,0,self.SPOS)
        ParticleManager:SetParticleControl(P,1,self.EPOS)
        ParticleManager:SetParticleControl(P,2,Vector(1,1,0))
        ParticleManager:SetParticleControl(P,60,Vector(RandomInt(0, 255),RandomInt(0, 255),RandomInt(0, 255)))
        ParticleManager:SetParticleControl(P,61,Vector(1,0,0))
        self:AddParticle( P, false, false, -1, false, false )  
        self.surge_buff=self.caster:FindAbilityByName("surge")
        self:OnIntervalThink()
        self:StartIntervalThink(1)
    end 
end

function modifier_seer_vacuum_wall:OnIntervalThink() 	
    local units = FindUnitsInLine(
        self.team,
        self.SPOS,
        self.EPOS, 
        self.caster, 
        100, 
        DOTA_UNIT_TARGET_TEAM_BOTH, 
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
        if #units>0 then
            for _,unit in pairs(units) do   
                if  self.caster:TG_HasTalent("special_bonus_dark_seer_7") and self.surge_buff and Is_Chinese_TG(self.caster,unit) then    
                    unit:AddNewModifier(self.caster, self.surge_buff, "modifier_surge_buff", {duration=2})
                end 
                unit:AddNewModifier(self.caster, self:GetAbility(), "modifier_seer_vacuum_sp", {duration=self.spdur})
            end
        end
end



modifier_seer_vacuum_sp=class({})
function modifier_seer_vacuum_sp:IsHidden() 			
	return false 
end

function modifier_seer_vacuum_sp:IsPurgable() 		
	return true 
end

function modifier_seer_vacuum_sp:IsPurgeException() 	
	return true 
end

function modifier_seer_vacuum_sp:IsDebuff() 	
    if not Is_Chinese_TG(self:GetParent(),self:GetCaster()) then
        return true 
    else 
    	return false 
    end
end

function modifier_seer_vacuum_sp:RemoveOnDeath() 
    return true 
end

function modifier_seer_vacuum_sp:DeclareFunctions()
	return 
		{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
		}
end

function modifier_seer_vacuum_sp:GetModifierMoveSpeedBonus_Percentage() 
    if not Is_Chinese_TG(self:GetParent(),self:GetCaster()) then
        return 0-self:GetAbility():GetSpecialValueFor("sp") 
    else 
        return self:GetAbility():GetSpecialValueFor("sp")
    end
end


modifier_seer_vacuum_m=class({})

function modifier_seer_vacuum_m:IsHidden() 			
	return true 
end

function modifier_seer_vacuum_m:IsPurgable() 		
	return false 
end

function modifier_seer_vacuum_m:IsPurgeException() 	
	return false 
end


function modifier_seer_vacuum_m:RemoveOnDeath() 
    return true 
end


function modifier_seer_vacuum_m:GetMotionPriority() 	
	return DOTA_MOTION_CONTROLLER_PRIORITY_LOW  
end

function modifier_seer_vacuum_m:OnCreated(tg)
    if not IsServer() then
        return
    end 
    self.DIR=ToVector(tg.dir)
		if not self:ApplyHorizontalMotionController()then 
			self:Destroy()
		end

end

function modifier_seer_vacuum_m:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end  
    if  not self:GetParent():IsAlive() then
        self:Destroy()
        return
    else
        self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.DIR* (600 / (1.0 / FrameTime())))
    end

end

function modifier_seer_vacuum_m:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end  
    self:Destroy()
end



function modifier_seer_vacuum_m:OnDestroy()
    if  IsServer() then
        self:GetParent():RemoveHorizontalMotionController(self) 
        if  self:GetParent():IsAlive() then
            self:GetParent():SetAngles(0, 0, 0)
            FindClearSpaceForUnit( self:GetParent(),  self:GetParent():GetAbsOrigin(), true)
        end
    end
end

function modifier_seer_vacuum_m:CheckState()
    return 
    {
        [MODIFIER_STATE_STUNNED] = true,
    }
end

function modifier_seer_vacuum_m:DeclareFunctions()
	return 
		{
            MODIFIER_PROPERTY_OVERRIDE_ANIMATION
		}
end

function modifier_seer_vacuum_m:GetOverrideAnimation() 
    return ACT_DOTA_FLAIL
end