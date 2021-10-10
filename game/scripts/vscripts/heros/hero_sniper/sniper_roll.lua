sniper_roll=class({})
LinkLuaModifier("modifier_sniper_roll", "heros/hero_sniper/sniper_roll.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function sniper_roll:IsHiddenWhenStolen()
    return false
end

function sniper_roll:IsStealable()
    return false
end

function sniper_roll:IsRefreshable()
    return true
end


function sniper_roll:OnSpellStart()
    local caster = self:GetCaster()
    local cur_pos=self:GetCursorPosition()
    local caster_pos=caster:GetAbsOrigin()
    local dis=TG_Distance(caster_pos,cur_pos)
    local dir=TG_Direction(cur_pos,caster_pos)
    if dis>600 then
        dis=600
    end
    local time=dis/1000
    caster:SetForwardVector(TG_Direction(cur_pos,caster_pos))
    caster:AddNewModifier(caster, self, "modifier_sniper_roll", {duration=time,dir=dir})
    local ab=caster:FindAbilityByName("slug")
    if ab and ab:GetLevel()>0 then
        ab:EndCooldown()
    end
end


modifier_sniper_roll=class({})

function modifier_sniper_roll:IsHidden()
    return true
end

function modifier_sniper_roll:IsPurgable()
    return false
end

function modifier_sniper_roll:IsPurgeException()
    return false
end

function modifier_sniper_roll:RemoveOnDeath()
    return false
end

function modifier_sniper_roll:OnCreated(tg)
    if not IsServer() then
        return
    end

    local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_mechjaw/mechjaw_idle_rare.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle( particle, false, false, 20, false, false )
    self.DIR=ToVector(tg.dir)
    self.POS=self:GetParent():GetAbsOrigin()
		if not self:ApplyHorizontalMotionController()then
			self:Destroy()
		end

end

function modifier_sniper_roll:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end
    self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.DIR* (1000 / (1.0 / FrameTime())))
end

function modifier_sniper_roll:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end

function modifier_sniper_roll:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():RemoveHorizontalMotionController(self)
    if self:GetParent():TG_HasTalent("special_bonus_sniper_20l") then
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invisible", {duration=3})
    end
end

function modifier_sniper_roll:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	}
end

function modifier_sniper_roll:GetOverrideAnimation()
   return ACT_DOTA_TAUNT
end

function modifier_sniper_roll:GetActivityTranslationModifiers()
    return "taunt_quickdraw_gesture"
end


function modifier_sniper_roll:GetModifierTurnRate_Percentage()
    return  100
end