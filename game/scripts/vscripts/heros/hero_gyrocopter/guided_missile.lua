guided_missile=class({})
LinkLuaModifier("modifier_guided_missile", "heros/hero_gyrocopter/guided_missile.lua", LUA_MODIFIER_MOTION_NONE)


function guided_missile:IsHiddenWhenStolen()
    return false
end

function guided_missile:IsStealable()
    return true
end

function guided_missile:IsRefreshable()
    return true
end

function guided_missile:CastFilterResultTarget(target)
	if  target:IsBoss() or (IsServer() and Is_Chinese_TG(self:GetCaster(),target)) or target:IsBuilding() then
		return UF_FAIL_CUSTOM
	end
end

function guided_missile:GetCustomCastErrorTarget(target)
    return "无法对目标发射飞弹"
end

function guided_missile:OnSpellStart()
    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local pos = caster:GetOrigin()+caster:GetForwardVector()*100
    local angles=caster:GetAnglesAsVector()
    local num=self:GetSpecialValueFor( "num" )
    local dam=self:GetSpecialValueFor( "dam" )*self:GetSpecialValueFor( "per" )*0.01
    local m=0
    if  target:TG_TriggerSpellAbsorb(self)   then
		return
    end
     if caster:TG_HasTalent("special_bonus_gyrocopter_3") then
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
            if #enemies>0 then
                for _,tar in pairs(enemies) do
                    local missile = CreateUnitByName(
                        "npc_dota_gyrocopter_homing_missile",
                        pos,
                        true,
                        nil,
                        nil,
                        caster:GetTeamNumber())
                        missile:SetBaseMoveSpeed(self:GetSpecialValueFor( "sp" ))
                        missile:SetAbsAngles(angles.x,angles.y,angles.z)
                        EmitSoundOn("Hero_Gyrocopter.HomingMissile", missile)
                        missile:AddNewModifier(caster, self, "modifier_guided_missile", {target=tar:entindex()})
                end
            end
    else
                local missile = CreateUnitByName(
                "npc_dota_gyrocopter_homing_missile",
                pos,
                true,
                nil,
                nil,
                caster:GetTeamNumber())
                missile:SetBaseMoveSpeed(self:GetSpecialValueFor( "sp" ))
                missile:SetAbsAngles(angles.x,angles.y,angles.z)
                EmitSoundOn("Hero_Gyrocopter.HomingMissile", missile)
                missile:AddNewModifier(caster, self, "modifier_guided_missile", {target=target:entindex()})
    end
    caster:EmitSound("Hero_Gyrocopter.CallDown.Fire")
    Timers:CreateTimer(0, function()
        local pos1=target:GetAbsOrigin()+RandomVector(315)
        local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_first.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(pfx, 1, pos1)
        ParticleManager:SetParticleControl(pfx, 5, Vector(1,0,0))
        Timers:CreateTimer(2, function()
            local heros = FindUnitsInRadius(
                caster:GetTeamNumber(),
                pos1,
                nil,
                300,
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_NONE,
                FIND_CLOSEST,
                false)
            if #heros>0 then
                for _, hero in pairs(heros) do
                    if not hero:IsMagicImmune() then
                        local damageTable = {
                            victim = hero,
                            attacker = caster,
                            damage = dam,
                            damage_type =DAMAGE_TYPE_MAGICAL,
                            ability = self,
                            }
                        ApplyDamage(damageTable)
                     end
                end
            end
            caster:EmitSound("Hero_Gyrocopter.CallDown.Damage")
            return  nil
        end)
        m=m+1
        if m>=num then
            return  nil
        else
            return  0.1
        end
    end)

end

modifier_guided_missile=class({})

function modifier_guided_missile:IsBuff()
    return true
end

function modifier_guided_missile:IsHidden()
	return false
end

function modifier_guided_missile:IsPurgable()
	return false
end

function modifier_guided_missile:IsPurgeException()
	return false
end

function modifier_guided_missile:CheckState()
    return
    {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end

function modifier_guided_missile:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_EVENT_ON_ATTACKED
    }
end

function modifier_guided_missile:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_guided_missile:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_guided_missile:GetAbsoluteNoDamagePure()
    return 1
end



function modifier_guided_missile:OnCreated(tg)
    if not IsServer() then
        return
    end
    self.target=EntIndexToHScript(tg.target)
    self.dam=self:GetAbility():GetSpecialValueFor( "dam" )
    self.bnum=self:GetAbility():GetSpecialValueFor( "bnum" )
    self.missile=self:GetParent()
    self.die=true
    self.currhp=0
    self.num=0
    local att_num = self:GetAbility():GetSpecialValueFor( "att_num" )
    self:GetParent():SetBaseMaxHealth(att_num)
    self:GetParent():SetMaxHealth(att_num)
    self:GetParent():SetHealth(att_num)
    Timers:CreateTimer(0.2, function()
        local particle= ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_homing_missile_fuse.vpcf", PATTACH_ABSORIGIN_FOLLOW,self.missile)
        ParticleManager:SetParticleControl(particle, 0, Vector(0,0,100))
        ParticleManager:ReleaseParticleIndex( particle )
        return nil
    end)
    local particle2= ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_guided_missile_target.vpcf", PATTACH_OVERHEAD_FOLLOW,self.target)
    self:AddParticle(particle2, false, false, 10, false, false)
    self:StartIntervalThink(3)
end

function modifier_guided_missile:OnIntervalThink()
        local particle3= ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_guided_missile.vpcf", PATTACH_CUSTOMORIGIN,self.missile)
        ParticleManager:SetParticleControlEnt( particle3, 0,self.missile, PATTACH_POINT_FOLLOW, "attach_fuse", self.missile:GetAbsOrigin(), false)
        ParticleManager:SetParticleControlEnt( particle3, 1, self.missile, PATTACH_POINT_FOLLOW, "attach_fuse", self.missile:GetAbsOrigin(), false)
        self:AddParticle(particle3, false, false, 10, false, false)
        self:StartIntervalThink(-1)
        Timers:CreateTimer(0, function()
            if  self.die then
                local dir=TG_Direction2(self.target:GetAbsOrigin(),self.missile:GetAbsOrigin())
                self.missile:SetForwardVector(dir)
                self.missile:SetAbsOrigin(self.missile:GetAbsOrigin()+dir*800/(1/FrameTime()))
             if TG_Distance( self.missile:GetAbsOrigin(),self.target:GetAbsOrigin())<=100 and  self.die then
                if  self.target:TG_TriggerSpellAbsorb(self:GetAbility())   then
                    if self.missile~=nil then
                        self.missile:RemoveModifierByName("modifier_guided_missile")
                    end
                    return nil
                end
                   EmitSoundOn("Hero_Gyrocopter.HomingMissile.Target", self.target)
                local particle4= ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_guided_missile_explosion.vpcf", PATTACH_CUSTOMORIGIN,self.target)
                ParticleManager:SetParticleControlEnt(particle4, 0, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), false)
                ParticleManager:SetParticleControlEnt(particle4, 11, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), false)
                ParticleManager:SetParticleControlEnt(particle4, 12, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), false)
                ParticleManager:ReleaseParticleIndex( particle4 )
                if not self.target:IsMagicImmune() and self.target:IsAlive() then
                    local damageTable = {
                        victim = self.target,
                        attacker =  self:GetCaster(),
                        damage = self.dam,
                        damage_type =DAMAGE_TYPE_MAGICAL,
                        ability = self:GetAbility(),
                        }
                    ApplyDamage(damageTable)
                    self.target:AddNewModifier( self.missile, self:GetAbility(), "modifier_stunned", {duration=self:GetAbility():GetSpecialValueFor( "stun" )})
                end
                self.die=false
            end
         else
                if self.missile~=nil then
                    self.missile:RemoveModifierByName("modifier_guided_missile")
                end
            return nil
        end
        return FrameTime()
    end
    )
end

function modifier_guided_missile:OnDestroy()
    if  IsServer() then
        StopSoundOn("Hero_Gyrocopter.HomingMissile",  self.missile)
        self.die = false
        self.missile:Destroy()
    end
end


function modifier_guided_missile:OnAttacked(tg)
    if not IsServer() then
        return
    end
    if tg.attacker~=self:GetParent() and tg.target==self:GetParent() then
        local curr_hp =self:GetParent():GetHealth()-1
        self:GetParent():SetHealth(curr_hp)
        self.dam=self.dam+self:GetAbility():GetSpecialValueFor( "att_dam" )
        if curr_hp<=0 then
            self.die = false
        end

    end
end