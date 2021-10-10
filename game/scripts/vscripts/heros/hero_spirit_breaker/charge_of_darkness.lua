CreateTalents("npc_dota_hero_spirit_breaker","heros/hero_spirit_breaker/charge_of_darkness.lua")
charge_of_darkness=class({})
LinkLuaModifier("modifier_charge_of_darkness", "heros/hero_spirit_breaker/charge_of_darkness.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_charge_of_darkness_target", "heros/hero_spirit_breaker/charge_of_darkness.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_charge_of_darkness_forward", "heros/hero_spirit_breaker/charge_of_darkness.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function charge_of_darkness:IsHiddenWhenStolen()
    return false
end

function charge_of_darkness:IsStealable()
    return false
end

function charge_of_darkness:IsRefreshable()
    return true
end


function charge_of_darkness:OnSpellStart()
    local caster = self:GetCaster()
    local target=self:GetCursorTarget()
    if  target:TG_TriggerSpellAbsorb(self) then
		return
	end
    local caster_pos=caster:GetAbsOrigin()
    local target_pos=target:GetAbsOrigin()
    local dir=TG_Direction(target_pos,caster_pos)
    EmitSoundOn("Hero_Spirit_Breaker.ChargeOfDarkness", caster)
    target:AddNewModifier(caster, self, "modifier_charge_of_darkness_target", {})
    caster:AddNewModifier(caster, self, "modifier_charge_of_darkness", {target=target:entindex()})
end

modifier_charge_of_darkness=class({})

function modifier_charge_of_darkness:IsHidden()
    return true
end

function modifier_charge_of_darkness:IsPurgable()
    return false
end

function modifier_charge_of_darkness:IsPurgeException()
    return false
end

function modifier_charge_of_darkness:RemoveOnDeath()
    return false
end

function modifier_charge_of_darkness:GetStatusEffectName()
    return "particles/status_fx/status_effect_charge_of_darkness.vpcf"
end

function modifier_charge_of_darkness:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_charge_of_darkness:GetMotionPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_LOW
end

function modifier_charge_of_darkness:OnCreated(tg)
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.team=self.parent:GetTeamNumber()
    if not self:GetAbility() then
        return
    end
    self.dur=self.ability:GetSpecialValueFor( "dur" )
    self.rd=self.ability:GetSpecialValueFor( "rd" )
    self.bash_radius=self.ability:GetSpecialValueFor( "bash_radius" )
    self.movement_speed=self.ability:GetSpecialValueFor( "movement_speed" )
    self.stun_duration=self.ability:GetSpecialValueFor( "stun_duration" )
    self.dmg=self.ability:GetSpecialValueFor( "dmg" )
    self.limit=self.ability:GetSpecialValueFor( "limit" )
    if not IsServer() then
        return
    end
    self.TARTB={}
    self.Knockback={
        should_stun = true,
        knockback_duration = self.stun_duration,
        duration = self.stun_duration,
        knockback_distance = 100,
        knockback_height = 100,
    }
    self.damageTable = {
		attacker = self.caster,
		damage_type =DAMAGE_TYPE_MAGICAL,
		ability = self.ability,
		}
    self.parent:AddActivityModifier("charge")
    local particle = ParticleManager:CreateParticle("particles/heros/spirit_breaker/spirit_breaker_charge_mist_change0.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
    ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 60, Vector(RandomInt(0, 255),RandomInt(0, 255),RandomInt(0, 255)))
    ParticleManager:SetParticleControl(particle, 61, Vector(1,0,0))
    self:AddParticle( particle, false, false, 20, false, false )
    EmitSoundOn("Hero_Spirit_Breaker.Charge.Impact",self.parent)
    self.target=EntIndexToHScript(tg.target)
		if not self:ApplyHorizontalMotionController()then
			self:Destroy()
		end

end

function modifier_charge_of_darkness:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end
    local cpos=self.parent:GetAbsOrigin()
    local tpos=self.target:GetAbsOrigin()
    local dis=TG_Distance(cpos,tpos)
    local dir=TG_Direction(tpos,cpos)
    self.parent:MoveToPosition(tpos)
    if  not self.parent:IsAlive() or self.parent:IsStunned() or self.parent:IsOutOfGame() or self.parent:IsRooted() or self.parent:IsHexed() or  dis<=100 then
        self:Destroy()
        return
    end
    if  (not self.target or not self.target:IsAlive()) then
        local heros = FindUnitsInRadius(
            self.team,
            tpos,
            nil,
            self.rd,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_CLOSEST,
            false)
        if #heros>0 then
            self.target=heros[1]
            self.target:AddNewModifier(self.parent, self.ability, "modifier_charge_of_darkness_target", {})
        else
            self:Destroy()
            return
        end
    end

    if  self.parent and self.parent:IsAlive() then
        local heros = FindUnitsInRadius(
            self.team,
            cpos,
            nil,
            self.parent:HasModifier("modifier_bulldoze_buff") and self.bash_radius*2 or self.bash_radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false)
        if #heros>0 then
            for _, hero in pairs(heros) do
            if not Is_DATA_TG( self.TARTB,hero) then
                    table.insert(self.TARTB,hero)
                    EmitSoundOn("Hero_Spirit_Breaker.GreaterBash",hero)
                    local pos=hero:GetAbsOrigin()
                    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf" , PATTACH_CENTER_FOLLOW,hero)
                    ParticleManager:SetParticleControl(particle, 0, pos)
                    ParticleManager:SetParticleControl(particle, 1, pos)
                    ParticleManager:SetParticleControl(particle, 2, pos)
                    ParticleManager:ReleaseParticleIndex(particle)
                    local sp=self.parent:GetMoveSpeedModifier(self.parent:GetBaseMoveSpeed(), true)
                    sp=sp>self.limit and self.limit or sp
                    self.damageTable.victim = hero
                    self.damageTable.damage = sp*self.dmg*0.01
                    ApplyDamage(self.damageTable)
                    self.Knockback.center_x = tpos.x
                    self.Knockback.center_y = tpos.y
                    self.Knockback.center_z = tpos.z
                    hero:AddNewModifier_RS(self.parent,self.ability, "modifier_knockback", self.Knockback)
                end
            end
        end
    end
    self.parent:StartGesture(ACT_DOTA_RUN)
    self.parent:SetAbsOrigin(cpos+dir*(self.parent:GetMoveSpeedModifier(self.parent:GetBaseMoveSpeed(), true) / (1.0 / g)))
end

function modifier_charge_of_darkness:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end

function modifier_charge_of_darkness:OnDestroy()
    if not IsServer() then
        return
    end
    self.parent:ClearActivityModifiers()
    self.parent:RemoveGesture(ACT_DOTA_RUN)
    self.parent:StartGesture(ACT_DOTA_SPIRIT_BREAKER_CHARGE_END)
    self.parent:RemoveHorizontalMotionController(self)
    if  self.target and  self.target:IsAlive() then
        if self.target:HasModifier("modifier_charge_of_darkness_target") then
            self.target:RemoveModifierByName("modifier_charge_of_darkness_target")
        end
        if self.ability:GetAutoCastState()==true then
            if self.target:HasModifier("modifier_knockback") then
                self.target:RemoveModifierByName("modifier_knockback")
            end
            local cpos=self.parent:GetAbsOrigin()
            local tpos=self.target:GetAbsOrigin()
            local dis=TG_Distance(cpos,tpos)
            if dis<=100 then
                self.target:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration=self.dur})
                self.parent:AddNewModifier(self.parent, self.ability, "modifier_charge_of_darkness_forward", {duration=self.dur,target=self.target:entindex()})
            end
        else
            FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
        end
    end
end

function modifier_charge_of_darkness:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ORDER,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
end

function modifier_charge_of_darkness:CheckState()
    return
    {
          [MODIFIER_STATE_DISARMED] = true,
          [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
          [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
      }
end

function modifier_charge_of_darkness:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_charge_of_darkness:GetModifierMoveSpeedBonus_Constant()
    return self.movement_speed+self.caster:TG_GetTalentValue("special_bonus_spirit_breaker_1")
end

function modifier_charge_of_darkness:OnOrder(tg)
    if not IsServer() then
        return
    end
    if tg.unit == self.parent then
		if tg.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or tg.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET or
            tg.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE or tg.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET or
            tg.order_type == DOTA_UNIT_ORDER_HOLD_POSITION or tg.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
            self.parent:ClearActivityModifiers()
            self:Destroy()
        end
	end
end

modifier_charge_of_darkness_forward=class({})

function modifier_charge_of_darkness_forward:IsHidden()
    return true
end

function modifier_charge_of_darkness_forward:IsPurgable()
    return false
end

function modifier_charge_of_darkness_forward:IsPurgeException()
    return false
end

function modifier_charge_of_darkness_forward:RemoveOnDeath()
    return false
end

function modifier_charge_of_darkness_forward:GetMotionPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_LOW
end

function modifier_charge_of_darkness_forward:OnCreated(tg)
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.team=self.parent:GetTeamNumber()
    if not IsServer() then
        return
    end
    self.target=EntIndexToHScript(tg.target)
		if not self:ApplyHorizontalMotionController()then
			self:Destroy()
		end

end

function modifier_charge_of_darkness_forward:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end
    if not self.target or  not self.target:IsAlive() or  not self.parent or not self.parent:IsAlive() then
        self:Destroy()
        return
    end
    local cpos=self.parent:GetAbsOrigin()
    local dir=self.parent:GetForwardVector()
    self.parent:StartGesture(ACT_DOTA_RUN)
    self.parent:SetAbsOrigin(cpos+dir*1600 / (1.0 / g))
    self.target:SetAbsOrigin(cpos+dir*200)
    GridNav:DestroyTreesAroundPoint(cpos,300,true)
end

function modifier_charge_of_darkness_forward:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end


function modifier_charge_of_darkness_forward:OnDestroy()
    if not IsServer() then
        return
    end
    self.parent:ClearActivityModifiers()
    self.parent:RemoveGesture(ACT_DOTA_RUN)
    self.parent:StartGesture(ACT_DOTA_SPIRIT_BREAKER_CHARGE_END)
    FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
    self.parent:RemoveHorizontalMotionController(self)
end

function modifier_charge_of_darkness_forward:CheckState()
    return
    {
          [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
      }
end


modifier_charge_of_darkness_target=class({})

function modifier_charge_of_darkness_target:IsHidden()
    return true
end

function modifier_charge_of_darkness_target:IsPurgable()
    return false
end

function modifier_charge_of_darkness_target:IsPurgeException()
    return false
end

function modifier_charge_of_darkness_target:RemoveOnDeath()
    return true
end

function modifier_charge_of_darkness_target:OnCreated()
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    if IsServer() then
        local particle = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_target.vpcf" , PATTACH_OVERHEAD_FOLLOW, self.parent,self.caster:GetPlayerOwner())
        ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
        self:AddParticle( particle, false, false, 20, false, false )
    end
end

function modifier_charge_of_darkness_target:CheckState()
    return
    {
          [MODIFIER_STATE_PROVIDES_VISION] = true,
      }
end

function modifier_charge_of_darkness_target:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
end

function modifier_charge_of_darkness_target:GetModifierProvidesFOWVision()
    return 1
end