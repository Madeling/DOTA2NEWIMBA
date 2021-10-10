psionic_trap=class({})
LinkLuaModifier("modifier_psionic_trap_buff", "heros/hero_templar_assassin/psionic_trap.lua", LUA_MODIFIER_MOTION_NONE)

function psionic_trap:IsHiddenWhenStolen()
    return false
end

function psionic_trap:IsStealable()
    return true
end

function psionic_trap:IsRefreshable()
    return true
end

function psionic_trap:CastFilterResultLocation(tg)
    local max=self:GetSpecialValueFor( "max" )
    if self:GetCaster().psionic_trapnum~=nil and self:GetCaster().psionic_trapnum>=max then
        return UF_FAIL_CUSTOM
	end
end

function psionic_trap:GetCustomCastErrorLocation(tg)
    return "放置的陷阱数量已达到上限"
end

function psionic_trap:OnSpellStart()
    local caster = self:GetCaster()
    local cur_pos = self:GetCursorPosition()
    local dur=self:GetSpecialValueFor( "dur" )
    local max=self:GetSpecialValueFor( "max" )
    if caster.psionic_trapnum==nil then
        caster.psionic_trapnum=0
    end
    if caster.psionic_trapnum<=max then
        caster:EmitSound("Hero_TemplarAssassin.Trap.Cast")
        caster:EmitSound("Hero_TemplarAssassin.Trap")
        local null = CreateUnitByName(
            "npc_dota_psionic_trap",
            cur_pos,
            true,
            caster,
            caster,
            caster:GetTeamNumber())
        null:AddNewModifier(caster, self, "modifier_psionic_trap_buff", {duration=dur})
        null:AddNewModifier(caster, self, "modifier_kill", {duration=dur})
        caster.psionic_trapnum=caster.psionic_trapnum+1
    end
end

function psionic_trap:OnInventoryContentsChanged()
    local caster=self:GetCaster()
    if caster:HasScepter() then
        TG_Set_Scepter(caster,false,1,"assassin_trap")
        TG_Set_Scepter(caster,false,1,"trap_teleport")
    else
        TG_Set_Scepter(caster,true,1,"assassin_trap")
        TG_Set_Scepter(caster,true,1,"trap_teleport")
    end
end

modifier_psionic_trap_buff=class({})

function modifier_psionic_trap_buff:IsHidden()
    return true
end

function modifier_psionic_trap_buff:IsPurgable()
    return false
end

function modifier_psionic_trap_buff:IsPurgeException()
    return false
end

function modifier_psionic_trap_buff:OnCreated()
    self.DAM=self:GetAbility():GetSpecialValueFor( "dam" )
    self.RD=self:GetAbility():GetSpecialValueFor( "rd" )
    if not IsServer() then
        return
    end
    local fx = ParticleManager:CreateParticle("particles/heros/templar_assassin/templar_assassin_trap_portrait.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(fx, 0, self:GetParent():GetAbsOrigin()+self:GetParent():GetUpVector()*1000)
    ParticleManager:SetParticleControl(fx, 62, Vector(100,100,100))
    self:AddParticle(fx, false, false, 100, false, false)
    local fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle(fx2, false, false, 100, false, false)
    self:StartIntervalThink(0.1)
end

function modifier_psionic_trap_buff:OnIntervalThink()
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        self.RD,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false )
   if #heros>0 then
    self:StartIntervalThink(-1)
    self:Destroy()
    end
end

function modifier_psionic_trap_buff:OnDestroy()
    if  IsServer() then
        local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:ReleaseParticleIndex(fx)
        EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_TemplarAssassin.Trap.Trigger", self:GetParent())
        EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_TemplarAssassin.Trap.Explode", self:GetParent())
        local heros = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            self:GetParent():GetAbsOrigin(),
            nil,
            self.RD,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false )
        for _, hero in pairs(heros) do
            if not hero:IsMagicImmune() then
                if self:GetCaster():TG_HasTalent("special_bonus_templar_assassin_4") then
                    hero:AddNewModifier(self:GetParent() , self:GetAbility(), "modifier_imba_stunned", {duration=0.5})
                end
                hero:AddNewModifier(self:GetParent() , self:GetAbility(), "modifier_confuse", {duration=self:GetAbility():GetSpecialValueFor( "confuse" )})
                local damageTable = {
                    attacker = self:GetCaster(),
                    victim = hero,
                    damage = self.DAM,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility()
                }
                ApplyDamage(damageTable)
            end
        end
        if  self:GetParent():GetOwner().psionic_trapnum~=nil then
            self:GetParent():GetOwner().psionic_trapnum= self:GetParent():GetOwner().psionic_trapnum-1
        end
         self:GetParent():Kill( self:GetAbility(), self:GetParent() )
    end
end

function modifier_psionic_trap_buff:CheckState()
    return
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
    }
end