icarus_dive = class({})
LinkLuaModifier("modifier_icarus_dive_move", "heros/hero_phoenix/icarus_dive.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_icarus_dive_move2", "heros/hero_phoenix/icarus_dive.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_icarus_dive_move3", "heros/hero_phoenix/icarus_dive.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function icarus_dive:IsHiddenWhenStolen()
    return false
end

function icarus_dive:IsStealable()
    return true
end

function icarus_dive:IsRefreshable()
    return true
end

function icarus_dive:OnUpgrade()
    local caster=self:GetCaster()
    local ab=caster:FindAbilityByName("phoenix_icarus_dive")
    if ab then
        ab:SetLevel(self:GetLevel())
    end
end


function icarus_dive:OnSpellStart()
    local caster=self:GetCaster()
    local caster_pos=caster:GetAbsOrigin()
    local cur_pos=self:GetCursorPosition()
    local dis=TG_Distance(caster_pos,cur_pos)
    local dir=TG_Direction(cur_pos,caster_pos)
    local dur=self:GetSpecialValueFor("a_dur")
    local dur2=self:GetSpecialValueFor("s_dur")
    caster:EmitSound("Hero_Phoenix.IcarusDive.Cast")
    caster:SetForwardVector(dir)
    if self:GetAutoCastState() then
        caster:AddNewModifier(caster, self, "modifier_icarus_dive_move2", {duration=dur2,dis=dis,dir=dir})
    else
        caster:AddNewModifier(caster, self, "modifier_icarus_dive_move", {duration=dur,dis=dis})
    end

end

modifier_icarus_dive_move=class({})

function modifier_icarus_dive_move:IsHidden()
    return false
end

function modifier_icarus_dive_move:IsPurgable()
    return false
end

function modifier_icarus_dive_move:IsPurgeException()
    return false
end

function modifier_icarus_dive_move:OnCreated(tg)
    if not IsServer() then
        return
    end
    local fx=ParticleManager:CreateParticle("particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_icarus_dive.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl( fx, 0,self:GetParent():GetAbsOrigin())
    self:AddParticle(fx, false, false, 100, false, false)
    self.DUR=self:GetAbility():GetSpecialValueFor("a_dur")
    self.KVDIS=self:GetAbility():GetSpecialValueFor("dis")
    self.DIS=tg.dis
    self.POS=self:GetParent():GetAbsOrigin()
	self.DIR= self:GetParent():GetForwardVector()
	self.RDIR = -self:GetParent():GetRightVector()
    self.CENTER= self.POS + self.DIR*self.KVDIS
    self:GetCaster().modifier_icarus_dive_move=self.CENTER
    self.ST = GameRules:GetGameTime()
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
        end
end

function modifier_icarus_dive_move:OnRefresh(tg)
    self:OnCreated()
end

function modifier_icarus_dive_move:UpdateHorizontalMotion(t, g)
    if not IsServer() then
        return
    end
    if self:GetParent():IsStunned() or self:GetParent():IsFrozen() or self:GetParent():IsHexed() or self:GetParent():IsNightmared() then
        self:Destroy()
        return
    end
    if self:GetParent():HasModifier("modifier_supernova_buff") then
        return
    end
    local p=(GameRules:GetGameTime()-self.ST)/self.DUR
    local a  =  p * -20
    local x = math.sin( a ) * self.KVDIS
    local y = -math.cos( a ) * self.KVDIS
    local pos =self.CENTER+ self.RDIR* x + self.DIR * y
    self:GetParent():SetAbsOrigin(pos)
end

function modifier_icarus_dive_move:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end

function modifier_icarus_dive_move:OnDestroy()

    if IsServer() then
        self:GetParent():EmitSound("Hero_Phoenix.IcarusDive.Stop")
        self:GetParent():RemoveHorizontalMotionController(self)
        FindClearSpaceForUnit( self:GetParent(),  self:GetParent():GetAbsOrigin(), true)
    end
end

function modifier_icarus_dive_move:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ORDER,
	}
end

function modifier_icarus_dive_move:OnOrder(tg)
    if not IsServer() then
        return
    end
    if tg.unit==self:GetParent()  then
        if   tg.order_type == DOTA_UNIT_ORDER_HOLD_POSITION or   tg.order_type == DOTA_UNIT_ORDER_STOP then
            self:Destroy()
        end
    end
end

    modifier_icarus_dive_move2=class({})


    function modifier_icarus_dive_move2:IsHidden()
        return false
    end

    function modifier_icarus_dive_move2:IsPurgable()
        return false
    end

    function modifier_icarus_dive_move2:IsPurgeException()
        return false
    end

    function modifier_icarus_dive_move2:OnCreated(tg)
        if not IsServer() then
            return
        end
        local fx=ParticleManager:CreateParticle("particles/econ/items/phoenix/phoenix_ti10_immortal/phoenix_ti10_icarus_dive.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl( fx, 0,self:GetParent():GetAbsOrigin())
        self:AddParticle(fx, false, false, 100, false, false)
        self.SP=self:GetAbility():GetSpecialValueFor("s_sp")
        self.DUR=self:GetAbility():GetSpecialValueFor("s_dur")
        self.RD=self:GetAbility():GetSpecialValueFor("rd")
        self.DIR= self:GetParent():GetForwardVector()
        self.RDIR = -self:GetParent():GetRightVector()
        self.ST =GameRules:GetGameTime()
            if not self:ApplyHorizontalMotionController() then
                self:Destroy()
            end
    end

    function modifier_icarus_dive_move2:OnRefresh(tg)
       self:OnCreated()
    end

    function modifier_icarus_dive_move2:UpdateHorizontalMotion(t, g)
        if not IsServer() then
            return
        end
        if self:GetParent():IsStunned() or self:GetParent():IsFrozen() or self:GetParent():IsHexed() or self:GetParent():IsNightmared() then
            self:Destroy()
            return
        end
        if self:GetParent():HasModifier("modifier_supernova_buff") then
            return
        end
        local p=(GameRules:GetGameTime()-self.ST)/self.DUR
        local a  =  p * -25
        local x = math.sin(a) * 60
        local pos =self.DIR* (self.SP / (1.0 / g))+(self.RDIR*x)+self:GetParent():GetAbsOrigin()
        self:GetParent():SetAbsOrigin(pos)
    end

    function modifier_icarus_dive_move2:OnDestroy()
        if  IsServer() then
            self:GetParent():EmitSound("Hero_Phoenix.IcarusDive.Stop")
            self:GetParent():RemoveHorizontalMotionController(self)
            FindClearSpaceForUnit( self:GetParent(),  self:GetParent():GetAbsOrigin(), true)
        end
    end

    function modifier_icarus_dive_move2:OnHorizontalMotionInterrupted()
        if not IsServer() then
            return
        end
        self:Destroy()
    end

    function modifier_icarus_dive_move2:DeclareFunctions()
        return
        {
            MODIFIER_EVENT_ON_ORDER,
        }
    end

    function modifier_icarus_dive_move2:OnOrder(tg)
        if not IsServer() then
            return
        end
        if tg.unit==self:GetParent()  then
            if   tg.order_type == DOTA_UNIT_ORDER_HOLD_POSITION or   tg.order_type == DOTA_UNIT_ORDER_STOP then
                self:Destroy()
                elseif  tg.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
                    if tg.target:IsRealHero() and TG_Distance(tg.target:GetAbsOrigin(),tg.unit:GetAbsOrigin())<=self.RD then
                    tg.target:AddNewModifier(tg.unit, self:GetAbility(), "modifier_icarus_dive_move3", {duration=self:GetRemainingTime(),target = tg.unit:entindex()})
                end
            end
        end
    end

    modifier_icarus_dive_move3=class({})

    function modifier_icarus_dive_move3:IsHidden()
        return false
    end

    function modifier_icarus_dive_move3:IsPurgable()
        return false
    end

    function modifier_icarus_dive_move3:IsPurgeException()
        return false
    end

    function modifier_icarus_dive_move3:OnCreated(tg)
        if not IsServer() then
            return
        end
        self.C= EntIndexToHScript(tg.target)
        self:StartIntervalThink(0.01)
    end

    function modifier_icarus_dive_move3:OnIntervalThink()
        if self.C~=nil and self.C:IsAlive() and self.C:HasModifier("modifier_icarus_dive_move2") then
            self:GetParent():SetAbsOrigin( self.C:GetAbsOrigin())
            else
                self:StartIntervalThink(-1)
                self:Destroy()
        end
    end

    function modifier_icarus_dive_move3:OnDestroy()
        if not IsServer() then
            return
        end
        FindClearSpaceForUnit( self:GetParent(),  self:GetParent():GetAbsOrigin(), true)
    end

    function modifier_icarus_dive_move3:DeclareFunctions()
        return
        {
            MODIFIER_EVENT_ON_ORDER,
        }
    end

    function modifier_icarus_dive_move3:OnOrder(tg)
        if not IsServer() then
            return
        end
        if tg.unit==self:GetParent()  then
            if  tg.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
                self:Destroy()
            end
        end
    end