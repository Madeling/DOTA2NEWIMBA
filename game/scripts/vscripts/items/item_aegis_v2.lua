item_aegis_v2=class({})
LinkLuaModifier("modifier_item_aegis_v2_pa", "items/item_aegis_v2.lua", LUA_MODIFIER_MOTION_NONE)

function item_aegis_v2:OnSpellStart()
    self.caster=self.caster or self:GetCaster()
    self.caster:AddNewModifier(self.caster, self, "modifier_item_aegis_v2_pa", {duration=300})
    self:SpendCharge()
end

modifier_item_aegis_v2_pa=class({})

function modifier_item_aegis_v2_pa:IsHidden()return false
end
function modifier_item_aegis_v2_pa:IsPurgable()return false
end
function modifier_item_aegis_v2_pa:IsPurgeException()return false
end
function modifier_item_aegis_v2_pa:RemoveOnDeath()return true
end
function modifier_item_aegis_v2_pa:AllowIllusionDuplicate()return false
end
function modifier_item_aegis_v2_pa:GetTexture()return "item_aegis"
end

function modifier_item_aegis_v2_pa:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_REINCARNATION
    }
end

function modifier_item_aegis_v2_pa:OnCreated()
    self.die=false
    self.ability,self.parent=self:GetAbility(),self:GetParent()
    if not IsServer() then
        return
    end
    Notifications:TopToAll({text="不朽之守护被-".. PlayerResource:GetPlayerName(self.parent:GetPlayerOwnerID()).."-使用", duration=3.0})
end

function modifier_item_aegis_v2_pa:OnRefresh()
    self:OnCreated()
end

function modifier_item_aegis_v2_pa:OnDestroy()
    if not IsServer() then
        return
    end
    if  self.die==false then
        self.parent:EmitSound("Aegis.Expire")
        Notifications:TopToAll({text="-"..PlayerResource:GetPlayerName(self.parent:GetPlayerOwnerID()).."-的不朽之守护已过期", duration=3.0})
        self.parent:Heal(5000,self.parent)
        self.parent:GiveMana(5000)
        SendOverheadEventMessage(self.parent, OVERHEAD_ALERT_HEAL, self.parent,5000, nil)
        SendOverheadEventMessage(self.parent, OVERHEAD_ALERT_MANA_ADD, self.parent,5000, nil)
    end
end

function modifier_item_aegis_v2_pa:OnDeath(tg)
    if not IsServer() then
        return
    end
    if tg.unit == self.parent and not self.parent:IsIllusion() then
        local caster_pos =self.parent:GetAbsOrigin()
        self.parent:EmitSound("Aegis.Expire")
        local fx = ParticleManager:CreateParticle("particles/items_fx/aegis_timer.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(fx, 0, self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControl(fx, 1, Vector(3, 3, 3))
        ParticleManager:ReleaseParticleIndex(fx)
        self.die=true
        Timers:CreateTimer(3, function()
            local fx2 = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
            ParticleManager:SetParticleControlEnt(fx2, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc",caster_pos, true)
            ParticleManager:SetParticleControlEnt(fx2, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster_pos, true)
            ParticleManager:ReleaseParticleIndex(fx2)
            FindClearSpaceForUnit( self.parent, caster_pos, true)
            TG_Refresh_AB( self.parent)
        end)
    end
end

function modifier_item_aegis_v2_pa:ReincarnateTime()return 3.0
end