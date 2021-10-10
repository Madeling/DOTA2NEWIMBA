trap_teleport=class({})
LinkLuaModifier("modifier_trap_teleport", "heros/hero_templar_assassin/trap_teleport.lua", LUA_MODIFIER_MOTION_NONE)
function trap_teleport:IsHiddenWhenStolen() 
    return false 
end

function trap_teleport:IsStealable() 
    return true 
end

function trap_teleport:IsRefreshable() 			
    return true 
end

function trap_teleport:GetAssociatedSecondaryAbilities() 
    return "assassin_trap" 
end

function trap_teleport:OnSpellStart() 			
    local caster = self:GetCaster()
    local cur_pos = self:GetCursorPosition()
    if caster.trap_teleportfx~=nil then 
        ParticleManager:DestroyParticle(caster.trap_teleportfx, false)
        ParticleManager:ReleaseParticleIndex(caster.trap_teleportfx)
        caster.trap_teleportfx =nil
    end
    caster.trap_teleportpos=cur_pos
    caster:AddNewModifier(caster, self, "modifier_trap_teleport", {duration=self:GetSpecialValueFor( "dur" ),pos=cur_pos})
end

modifier_trap_teleport=class({})

function modifier_trap_teleport:IsHidden() 			
    return false 
end

function modifier_trap_teleport:IsPurgable() 		
    return false
end

function modifier_trap_teleport:IsPurgeException() 
    return false 
end

function modifier_trap_teleport:OnCreated(tg) 
    if not IsServer() then
		return
    end 
    local POS=ToVector(tg.pos)
    AddFOWViewer(self:GetParent():GetTeamNumber(), POS, 500, self:GetAbility():GetSpecialValueFor( "dur" ), true)
    self:GetParent().trap_teleportfx = ParticleManager:CreateParticle("particles/heros/templar_assassin/trap_teleport.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(self:GetParent().trap_teleportfx, 0,POS)
    local pos={}
    pos[1]=Vector(POS.x+500,POS.y,POS.z+50)
    pos[2]=Vector(POS.x-500,POS.y,POS.z+50)
    pos[3]=Vector(POS.x,POS.y+500,POS.z+50)
    pos[4]=Vector(POS.x,POS.y-500,POS.z+50)
    for num=1,#pos do
        EmitSoundOnLocationWithCaster(POS, "Hero_TemplarAssassin.Trap.Explode", self:GetParent())
        local fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf", PATTACH_CUSTOMORIGIN,self:GetParent())
        ParticleManager:SetParticleControl(fx2, 0, pos[num])
        ParticleManager:ReleaseParticleIndex(fx2)
        local fx3 = ParticleManager:CreateParticle("particles/heros/templar_assassin/templar_assassin_trap_portrait.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
        ParticleManager:SetParticleControl(fx3, 0, pos[num])
        ParticleManager:SetParticleControl(fx3, 62, Vector(100,100,100))
        self:AddParticle(fx3, false, false, 100, false, false)
    end 
end

function modifier_trap_teleport:OnRefresh(tg) 
    if not IsServer() then
		return
    end 
    local POS=ToVector(tg.pos)
    AddFOWViewer(self:GetParent():GetTeamNumber(), POS, 500, self:GetAbility():GetSpecialValueFor( "dur" ), true)
    self:GetParent().trap_teleportfx = ParticleManager:CreateParticle("particles/heros/templar_assassin/trap_teleport.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(self:GetParent().trap_teleportfx, 0,POS)
    local pos={}
    pos[1]=Vector(POS.x+500,POS.y,POS.z+50)
    pos[2]=Vector(POS.x-500,POS.y,POS.z+50)
    pos[3]=Vector(POS.x,POS.y+500,POS.z+50)
    pos[4]=Vector(POS.x,POS.y-500,POS.z+50)
    for num=1,#pos do
        EmitSoundOnLocationWithCaster(POS, "Hero_TemplarAssassin.Trap.Explode", self:GetParent())
        local fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf", PATTACH_CUSTOMORIGIN,self:GetParent())
        ParticleManager:SetParticleControl(fx2, 0, pos[num])
        ParticleManager:ReleaseParticleIndex(fx2)
        local fx3 = ParticleManager:CreateParticle("particles/heros/templar_assassin/templar_assassin_trap_portrait.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
        ParticleManager:SetParticleControl(fx3, 0, pos[num])
        ParticleManager:SetParticleControl(fx3, 62, Vector(100,100,100))
        self:AddParticle(fx3, false, false, 100, false, false)
    end 
end


function modifier_trap_teleport:OnDestroy()
    if  IsServer() then
        ParticleManager:DestroyParticle(self:GetParent().trap_teleportfx, false)
        ParticleManager:ReleaseParticleIndex(self:GetParent().trap_teleportfx)
    end 
    self:GetParent().trap_teleportfx =nil
    self:GetParent().trap_teleportpos=nil
end