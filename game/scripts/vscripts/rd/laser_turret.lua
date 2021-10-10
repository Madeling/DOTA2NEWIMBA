laser_turret=class({})

LinkLuaModifier("modifier_laser_turret", "rd/laser_turret.lua", LUA_MODIFIER_MOTION_NONE)

function laser_turret:IsHiddenWhenStolen() 
    return false 
end

function laser_turret:IsStealable() 
    return true 
end

function laser_turret:IsRefreshable() 			
    return true 
end

function laser_turret:OnSpellStart() 
    local caster = self:GetCaster()
    local cur_pos = self:GetCursorPosition()
    local duration=self:GetSpecialValueFor("duration")
    local laser=CreateUnitByName("npc_dota_laser", cur_pos, true, caster, caster, caster:GetTeamNumber())
    laser:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
    laser:AddNewModifier(caster, self, "modifier_kill", {duration=duration})
    laser:AddNewModifier(caster, self, "modifier_laser_turret", {duration=duration})
end



function laser_turret:OnProjectileHit_ExtraData( target, location,kv)
	if target == nil  then
		return 
    end
    local caster=self:GetCaster()
    local caster_pos=caster:GetAbsOrigin()
    local dir=GetDirection2D(target:GetAbsOrigin(),caster_pos)
    local base_dam=self:GetSpecialValueFor("base_dam")	
    local int_per=self:GetSpecialValueFor("per")	
    local dis=self:GetSpecialValueFor("dis")	
    local target_pos=target:GetAbsOrigin()
    local damageTable = {
        victim = target,
        attacker = caster,
        damage = base_dam+caster:GetPrimaryAttribute()*int_per*0.01,
        damage_type = self:GetAbilityDamageType(),
        ability = self, 
        }
    ApplyDamage(damageTable)
    local Knockback =
    {
        should_stun = false,
        knockback_duration = 0.3,
        duration = 0.3,
        knockback_distance = dis,
        knockback_height = 10,
        center_x = target_pos.x-dir.x,
        center_y = target_pos.y-dir.y,
        center_z = target_pos.z
    }
    target:AddNewModifier(caster,self, "modifier_knockback", Knockback)
	return true
end

modifier_laser_turret=class({})

function modifier_laser_turret:IsPurgable() 			
    return false
end

function modifier_laser_turret:IsPurgeException() 		
    return false 
end

function modifier_laser_turret:IsHidden()				
    return true 
end


function modifier_laser_turret:OnCreated(tg)
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.interval=self.ability:GetSpecialValueFor("interval")		
    self.range=self.ability:GetSpecialValueFor("range")	
    self.num=self.ability:GetSpecialValueFor("num")
    self.fx="particles/units/heroes/hero_tinker/tinker_laser.vpcf"   
    self.max_num=false	
    if not IsServer() then 
            return 
    end
    local p = ParticleManager:CreateParticle( "particles/econ/items/gyrocopter/gyro_ti10_immortal_missile/gyro_ti10_immortal_missile_target.vpcf", PATTACH_ABSORIGIN_FOLLOW , self.caster )
    ParticleManager:SetParticleControl( p, 0, self.caster:GetAbsOrigin() )
    self:AddParticle(p, false, false, -1, false, false)
    self.team=self.parent:GetTeamNumber()
    self:StartIntervalThink(self.interval)
end

function modifier_laser_turret:OnIntervalThink()
    local enemies = FindUnitsInRadius(self.team, self.parent:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    if #enemies>0 then 
        if #enemies>self.num then 
            self.max_num=true
        --    self.fx="particles/econ/items/tinker/tinker_ti10_immortal_laser/tinker_ti10_immortal_laser.vpcf"
        end 
        EmitSoundOn("Hero_Tinker.Laser", self.parent) 
        for a=1,math.min(#enemies,6) do
            if not enemies[a]:IsMagicImmune() then 
                if self.max_num then 
                    local P2 = {
                        Ability = self.ability,
                        EffectName = "particles/tgp/laser_turret/ltmissile.vpcf",
                        iMoveSpeed = 1000,
                        Source =self.parent,
                        Target = enemies[a],
                        bDrawsOnMinimap = false,
                        bDodgeable = true,
                        bIsAttack = false,
                        bProvidesVision = false,
                        bReplaceExisting = false,
                    }
                    ProjectileManager:CreateTrackingProjectile(P2)
                end 
                local P = {
                    Ability = self.ability,
                    EffectName = self.fx,
                    iMoveSpeed = 1000,
                    Source =self.parent,
                    Target = enemies[a],
                    bDrawsOnMinimap = false,
                    bDodgeable = true,
                    bIsAttack = false,
                    bProvidesVision = false,
                    bReplaceExisting = false,
                }
                ProjectileManager:CreateTrackingProjectile(P)
            end  
        end
    end
end

function modifier_laser_turret:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MODEL_SCALE,
	}
end

function modifier_laser_turret:GetModifierModelScale()	
    if 	self.max_num then 
        return 100
    else 
        return 0
    end 		
end

