activate_fire_remnant=class({})

LinkLuaModifier("modifier_activate_fire_remnant", "heros/hero_ember_spirit/activate_fire_remnant.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function activate_fire_remnant:IsHiddenWhenStolen()
    return false
end

function activate_fire_remnant:IsRefreshable()
    return true
end

function activate_fire_remnant:IsStealable()
    return true
end

function activate_fire_remnant:GetAssociatedPrimaryAbilities()
    return "fire_remnant"
end

function activate_fire_remnant:CastFilterResultLocation(tg)
    if IsServer() then
        local mod = self:GetCaster():FindModifierByName("modifier_fire_remnant_num")
        if  mod==nil or mod:GetStackCount()<1 then
            return UF_FAIL_CUSTOM
        end
    end
end

function activate_fire_remnant:GetCustomCastErrorLocation(tg)
    return "问就是场上没魂"
end


function activate_fire_remnant:OnSpellStart()
    local caster = self:GetCaster()
    local pos = caster:GetAbsOrigin()
	local cur_pos = self:GetCursorPosition()
	local dis = TG_Distance(pos,cur_pos)
    local dir = TG_Direction(cur_pos,pos)
    if caster:HasModifier("modifier_sleight_of_fist_buff") then
        caster:RemoveModifierByName("modifier_sleight_of_fist_buff")
    end

    if caster.fire_remnantTB and #caster.fire_remnantTB>0 then
        for a=#caster.fire_remnantTB,1,-1 do
            if caster.fire_remnantTB[a] and IsValidEntity(caster.fire_remnantTB[a]) and caster.fire_remnantTB[a]:IsAlive() then
                EmitSoundOn("Hero_EmberSpirit.FireRemnant.Activate", caster)
                caster:Purge(false, true, false, true, true)
                caster:AddNewModifier(caster, self, "modifier_activate_fire_remnant", {dir=dir,target=caster.fire_remnantTB[a]:entindex()})
                return
            end
        end
    end
end


modifier_activate_fire_remnant=class({})

function modifier_activate_fire_remnant:IsHidden()
    return true
end

function modifier_activate_fire_remnant:IsPurgable()
    return false
end

function modifier_activate_fire_remnant:IsPurgeException()
    return false
end

function modifier_activate_fire_remnant:RemoveOnDeath()
    return false
end

function modifier_activate_fire_remnant:OnCreated(tg)
    self.ability=self:GetAbility()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.pos=self.parent:GetAbsOrigin()
    if not IsServer() then
        return
    end
    self.pf = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf", PATTACH_CUSTOMORIGIN,self.parent)
    ParticleManager:SetParticleControlEnt(self.pf, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.pos, true)
    ParticleManager:SetParticleControlEnt(self.pf, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.pos, true)
    ParticleManager:SetParticleControl(self.pf, 61, Vector(1,0,0))
    self:AddParticle( self.pf, false, false, -1, false, false )
    self.DIR=ToVector(tg.dir)
    self.target=EntIndexToHScript(tg.target)
	if not self:ApplyHorizontalMotionController()then
		self:Destroy()
    end
end



function modifier_activate_fire_remnant:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end
    if self.target==nil or not IsValidEntity(self.target) or  not self.target:IsAlive() then
        self:Destroy()
        return
    end

    local tpos=self.target:GetAbsOrigin()
    local cpos=self.parent:GetAbsOrigin()
    local dir=TG_Direction(tpos,cpos)
    local dis=TG_Distance(tpos,cpos)
    if dis<=100 then
        self.target:Kill(self.ability, self.target)
        self.mod = self.caster:FindModifierByName("modifier_fire_remnant_num")
        if self.mod  then
            self.mod:DecrementStackCount()
        end
        if self.caster.fire_remnantTB  then
            if self.pf then
                ParticleManager:SetParticleControl(self.pf, 60, Vector(RandomInt(0, 255),RandomInt(0, 255),RandomInt(0, 255)))
            end
            StopSoundOn("Hero_EmberSpirit.FireRemnant.Activate", self.parent)
            EmitSoundOn("Hero_EmberSpirit.FireRemnant.Stop", self.parent)
           -- for a=#self.caster.fire_remnantTB,1,-1 do
           --     if self.caster.fire_remnantTB[a] and IsValidEntity(self.caster.fire_remnantTB[a]) and self.caster.fire_remnantTB[a]:IsAlive() then
           --         self.target=self.caster.fire_remnantTB[a]
          --          return
          --      end
          --  end
            if self.target==nil or not IsValidEntity(self.target) or  not self.target:IsAlive() then
                self:Destroy()
                return
            end
        else
            self:Destroy()
            return
        end
    end
        self.parent:SetAbsOrigin(self.parent:GetAbsOrigin()+dir* (3000 / (1.0 / g)))
end

function modifier_activate_fire_remnant:OnHorizontalMotionInterrupted()
    if  IsServer() then
        self:Destroy()
    end
end


function modifier_activate_fire_remnant:OnDestroy()
    if  IsServer() then
        self.parent:RemoveHorizontalMotionController(self)
    end
end

function modifier_activate_fire_remnant:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
	}
end


function modifier_activate_fire_remnant:GetModifierTurnRate_Percentage()
	return 100
end

function modifier_activate_fire_remnant:GetModifierModelChange()
    return ""
end

function modifier_activate_fire_remnant:GetModifierIgnoreCastAngle()
    return 1
end


function modifier_activate_fire_remnant:CheckState()
    return
     {
           [MODIFIER_STATE_INVULNERABLE] = true,
           [MODIFIER_STATE_UNSLOWABLE] = true,
           [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
end
