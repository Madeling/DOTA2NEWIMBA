CreateTalents("npc_dota_hero_enigma", "heros/hero_enigma/malefice.lua")
malefice=class({})
LinkLuaModifier("modifier_malefice_debuff", "heros/hero_enigma/malefice.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_malefice_debuff1", "heros/hero_enigma/malefice.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
function malefice:IsHiddenWhenStolen()
    return false
end

function malefice:IsStealable()
    return true
end

function malefice:IsRefreshable()
    return true
end

function malefice:OnSpellStart()
    local caster = self:GetCaster()
    local cur_tar = self:GetCursorTarget()
    local duration =self:GetSpecialValueFor("duration")
    caster:EmitSound("Hero_Enigma.Malefice")
    if  cur_tar:TG_TriggerSpellAbsorb(self)   then
        return
    end
    cur_tar:AddNewModifier_RS(caster, self, "modifier_malefice_debuff", {duration=duration-1})
end

modifier_malefice_debuff= class({})

function modifier_malefice_debuff:IsDebuff()
    return true
end

function modifier_malefice_debuff:IsHidden()
    return true
end

function modifier_malefice_debuff:IsPurgable()
    return true
end

function modifier_malefice_debuff:IsPurgeException()
    return true
end

function modifier_malefice_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_enigma_malefice.vpcf"
end


function modifier_malefice_debuff:StatusEffectPriority()
	return 100
end


function modifier_malefice_debuff:GetHeroEffectName()
	return "particles/units/heroes/hero_enigma/enigma_malefice.vpcf"
end


function modifier_malefice_debuff:HeroEffectPriority()
	return 100
end

function modifier_malefice_debuff:OnCreated()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.team=self.caster:GetTeamNumber()
    local tick_rate =self.ability:GetSpecialValueFor("tick_rate")
    local damage =self.ability:GetSpecialValueFor("damage")+self.caster:TG_GetTalentValue("special_bonus_enigma_1")
    self.stun_duration =self.ability:GetSpecialValueFor("stun_duration")
    self.rd =self.ability:GetSpecialValueFor("rd")
    self.damageTable = {
        victim = self.parent,
        attacker = self.caster,
        damage =  damage,
        damage_type =DAMAGE_TYPE_MAGICAL,
        ability = self.ability,
        }
    if not IsServer() then
        return
    end
    local fx= ParticleManager:CreateParticle(
        "particles/units/heroes/hero_enigma/enigma_blackhole.vpcf",
        PATTACH_CUSTOMORIGIN_FOLLOW,
        self.parent)
        ParticleManager:SetParticleControl(fx, 0,  self.parent:GetAbsOrigin()+self.parent:GetUpVector()*100)
        ParticleManager:SetParticleControl(fx, 60, Vector(75,0,130))
        ParticleManager:SetParticleControl(fx, 61, Vector(1,0,0))
    self:AddParticle(fx, false, false, -1, false, false)
    self:OnIntervalThink()
    self:StartIntervalThink(tick_rate)
end

function modifier_malefice_debuff:OnIntervalThink()
    if not self.parent:IsMagicImmune() then
        self.pos=self.parent:GetAbsOrigin()
        self.parent:EmitSound("Hero_Enigma.MaleficeTick")
        self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_stunned", {duration=self.stun_duration})
        ApplyDamage(self.damageTable)
        local heros = FindUnitsInRadius(
            self.team,
            self.pos,
            nil,
            self.rd,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false)
        if #heros>0 then
            for _, hero in pairs(heros) do
                if hero~=self.parent and not hero:IsMagicImmune() then
                    if hero:HasModifier("modifier_malefice_debuff1") then
                        hero:RemoveModifierByName("modifier_malefice_debuff1")
                    end
                    if not hero:HasModifier("modifier_black_hole_debuff2") and not hero:HasModifier("modifier_malefice_debuff1") and hero:IsAlive() then
                        hero:AddNewModifier(self:GetCaster(), self.ability, "modifier_malefice_debuff1", {duration=0.4,pos=self.pos})
                    end
                end
            end
        end
    end
end

modifier_malefice_debuff1= class({})

function modifier_malefice_debuff1:IsDebuff()
    return true
end

function modifier_malefice_debuff1:IsHidden()
    return false
end

function modifier_malefice_debuff1:IsPurgable()
    return false
end

function modifier_malefice_debuff1:IsPurgeException()
    return false
end

function modifier_malefice_debuff1:RemoveOnDeath()
	return false
end

function modifier_malefice_debuff1:GetMotionPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end

function modifier_malefice_debuff1:OnCreated(tg)
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.dam =self.ability:GetSpecialValueFor("dam")
    if not IsServer() then
        return
    end
    self.POS=self.parent:GetAbsOrigin()
    self.CENTER= ToVector(tg.pos)
    self.DIR= TG_Direction2(self.CENTER,self.POS)
    local damageTable = {
        victim = self.parent,
        attacker = self.caster,
        damage =  self.dam,
        damage_type =DAMAGE_TYPE_MAGICAL,
        ability = self.ability,
        }
        ApplyDamage(damageTable)
        local fx= ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_ambient_body.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,self.parent)
        ParticleManager:SetParticleControl(fx, 0,  self.POS)
        ParticleManager:SetParticleControl(fx, 1,  self.POS)
        self:AddParticle(fx, false, false, -1, false, false)
        if not self:ApplyHorizontalMotionController() then
            self:Destroy()
        end
end


function modifier_malefice_debuff1:UpdateHorizontalMotion(t, g)
    if not IsServer() then
        return
    end
    if not self.parent:IsAlive() then
        self:Destroy()
        return
    end
    self.parent:SetAbsOrigin(self.parent:GetAbsOrigin()+self.DIR*( 500/(1/FrameTime())))
end


function modifier_malefice_debuff1:OnDestroy()
    if  IsServer() then
        self.parent:RemoveHorizontalMotionController(self)
    end
end

function modifier_malefice_debuff1:OnHorizontalMotionInterrupted()
    if not IsServer() then
        return
    end
    self:Destroy()
end

function modifier_malefice_debuff1:CheckState()
    return
    {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end
