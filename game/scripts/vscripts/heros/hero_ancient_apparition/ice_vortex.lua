ice_vortex=ice_vortex or class({})

LinkLuaModifier("modifier_ice_vortex_1", "heros/hero_ancient_apparition/ice_vortex.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ice_vortex_debuff", "heros/hero_ancient_apparition/ice_vortex.lua", LUA_MODIFIER_MOTION_NONE)

function ice_vortex:IsHiddenWhenStolen()
    return false
end

function ice_vortex:IsStealable()
    return true
end


function ice_vortex:IsRefreshable()
    return true
end


function ice_vortex:GetAOERadius()
    return self:GetSpecialValueFor("rd")
end

function ice_vortex:OnSpellStart()
	local curpos=self:GetCursorPosition()
    local caster=self:GetCaster()
    local pos=TG_Direction(curpos,caster:GetAbsOrigin())
    local dam=self:GetSpecialValueFor("dam")
    local rd=self:GetSpecialValueFor("rd")
    local v=self:GetSpecialValueFor("v")
    local dur=self:GetSpecialValueFor("dur")
    local stun=self:GetSpecialValueFor("stun")+caster:TG_GetTalentValue("special_bonus_ancient_apparition_2")
    EmitSoundOn("Hero_Ancient_Apparition.IceVortexCast", caster)
    local particle = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/ancient_apparation_ti8/ancient_ice_vortex_ti8.vpcf", PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl( particle, 0, curpos+caster:GetUpVector()*100)
    ParticleManager:SetParticleControl( particle, 5, Vector(rd,0,0))
    AddFOWViewer( caster:GetTeamNumber(), curpos, rd, dur, false )
    CreateModifierThinker(caster, self, "modifier_ice_vortex_1", {duration =dur}, curpos, caster:GetTeamNumber(), false)
    local damageTable = {
        attacker = caster,
        damage = dam,
        damage_type = self:GetAbilityDamageType(),
        ability = self
    }
    Timers:CreateTimer(dur, function()
    ParticleManager:DestroyParticle( particle, false )
    ParticleManager:ReleaseParticleIndex( particle )
    return nil
end
)

local particle3 = ParticleManager:CreateParticle("particles/heros/aa/ancient_apparition_ice_blast_main.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( particle3, 0,curpos)

local dis=100
local dis_min=500
local pos2=curpos.z+1000
Timers:CreateTimer(1, function()
    pos2=pos2-dis
    ParticleManager:SetParticleControl( particle3, 3,Vector(curpos.x,curpos.y,pos2))
    if pos2<=dis_min then
        local particle2 = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl( particle2, 0,curpos)
        ParticleManager:SetParticleControl( particle2, 3,curpos)
        ParticleManager:ReleaseParticleIndex( particle2 )
        ParticleManager:DestroyParticle( particle3, false )
        EmitSoundOnLocationWithCaster(curpos, "Hero_Ancient_Apparition.IceBlast.Target", caster)
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), curpos, nil, rd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        if  #enemies>0 then
            for _,target in pairs(enemies) do
                            if not target:IsMagicImmune() then
                                damageTable.victim = target
                                target:AddNewModifier_RS(caster, self, "modifier_imba_stunned", {duration =stun})
                                ApplyDamage(damageTable)
                            end
                    end
            end
        return nil
    else
        return FrameTime()
    end
end
)
end

modifier_ice_vortex_1=modifier_ice_vortex_1 or class({})
function modifier_ice_vortex_1:IsDebuff()
    return true
end

function modifier_ice_vortex_1:IsPurgable()
    return false
end

function modifier_ice_vortex_1:IsPurgeException()
    return false
end

function modifier_ice_vortex_1:IsHidden()
    return true
end

function modifier_ice_vortex_1:IsAura()
    return true
end


function modifier_ice_vortex_1:GetAuraDuration()
    return 0.1
end

function modifier_ice_vortex_1:GetModifierAura()
    return "modifier_ice_vortex_debuff"
end

function modifier_ice_vortex_1:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("rd")
end

function modifier_ice_vortex_1:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_ice_vortex_1:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ice_vortex_1:GetAuraSearchType()
    return  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end


modifier_ice_vortex_debuff=modifier_ice_vortex_debuff or class({})

function modifier_ice_vortex_debuff:IsDebuff()
    return true
end

function modifier_ice_vortex_debuff:IsPurgable()
    return false
end

function modifier_ice_vortex_debuff:IsPurgeException()
    return true
end

function modifier_ice_vortex_debuff:IsHidden()
    return false
end

function modifier_ice_vortex_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_ice_vortex_debuff:StatusEffectPriority()
    return 20
end

function modifier_ice_vortex_debuff:OnCreated()
    self.sp=self:GetAbility():GetSpecialValueFor("sp")
    self.dam_in=self:GetAbility():GetSpecialValueFor("dam_in")
end
function modifier_ice_vortex_debuff:OnDestroy()
    self.sp=nil
    self.dam_in=nil
end

function modifier_ice_vortex_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_ice_vortex_debuff:GetModifierMoveSpeedBonus_Percentage()
    return (0- self.sp)
end

function modifier_ice_vortex_debuff:GetModifierIncomingDamage_Percentage()
    return  self.dam_in
end