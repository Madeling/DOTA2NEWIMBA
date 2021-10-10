guardian_angel_new=class({})
LinkLuaModifier("modifier_guardian_angel_new_buff", "heros/hero_omniknight/guardian_angel_new.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_guardian_angel_new_buff2", "heros/hero_omniknight/guardian_angel_new.lua", LUA_MODIFIER_MOTION_NONE)
function guardian_angel_new:IsHiddenWhenStolen()
    return false
end

function guardian_angel_new:IsStealable()
    return true
end


function guardian_angel_new:IsRefreshable()
    return true
end

function guardian_angel_new:GetCooldown(iLevel)
    return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_omniknight_8")
end

function guardian_angel_new:OnSpellStart()
    local caster=self:GetCaster()
    local duration=self:GetSpecialValueFor("duration")+caster:TG_GetTalentValue("special_bonus_omniknight_6")
    local radius= caster:HasScepter() and 25000 or self:GetSpecialValueFor("radius")
    local pos=caster:GetAbsOrigin()
    EmitSoundOn("Hero_Omniknight.GuardianAngel.Cast", caster)
    local unit=CreateUnitByName("npc_angel", pos, true, caster, caster,  caster:GetTeamNumber())
    unit:SetAbsAngles(0, -90, 0)
    unit:AddNewModifier(caster, self, "modifier_kill",  {duration=duration})
    unit:AddNewModifier(caster, self, "modifier_guardian_angel_new_buff",  {duration=duration})
    local heroes = FindUnitsInRadius(caster:GetTeam(),pos, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
    if #heroes>0 then
        local ab=caster:FindAbilityByName("repel")
        local ab1=caster:FindAbilityByName("purification_new")
        for _, hero in pairs(heroes) do
            if ab and ab:GetLevel()>0 then
                ab:OnSpellStart(hero)
            end
            if caster:HasScepter() and ab1 and ab1:GetLevel()>0 then
                ab1:OnSpellStart(hero)
            end
        end
    end
end


modifier_guardian_angel_new_buff=class({})

function modifier_guardian_angel_new_buff:IsPurgable()
    return false
end

function modifier_guardian_angel_new_buff:IsPurgeException()
    return false
end

function modifier_guardian_angel_new_buff:IsHidden()
    return true
end

function modifier_guardian_angel_new_buff:AllowIllusionDuplicate()
    return false
end

function modifier_guardian_angel_new_buff:IsAura()
    return true
end

function modifier_guardian_angel_new_buff:GetAuraDuration()
    return 0
end

function modifier_guardian_angel_new_buff:GetModifierAura()
    return "modifier_guardian_angel_new_buff2"
end

function modifier_guardian_angel_new_buff:GetAuraRadius()
    if self:GetCaster():HasScepter() then
        return 25000
    else
        return 1400
    end
end

function modifier_guardian_angel_new_buff:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_guardian_angel_new_buff:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end


function modifier_guardian_angel_new_buff:OnCreated()
    if IsServer() then
        self.rot=0
        local particle2 = ParticleManager:CreateParticle("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
        ParticleManager:SetParticleControl(particle2, 1, Vector(self:GetCaster():HasScepter() and 25000 or 1400, 0, 0))
        ParticleManager:SetParticleControl(particle2, 2, Vector(100, 0, 0))
        ParticleManager:SetParticleControl(particle2, 3, Vector(100, 0, 0))
        ParticleManager:SetParticleControl(particle2, 15, Vector(220, 20, 60))
        self:AddParticle(particle2, false, false, 15, false, false)
        self:StartIntervalThink(FrameTime())
    end
end

function modifier_guardian_angel_new_buff:OnIntervalThink()
    self:GetParent():SetAbsAngles(0, -90+self.rot, 0)
    self.rot=self.rot+4
 end

 function modifier_guardian_angel_new_buff:GetStatusEffectName()
    return "particles/econ/items/effigies/status_fx_effigies/status_effect_vr_desat_stone.vpcf"
   end

function modifier_guardian_angel_new_buff:StatusEffectPriority()
    return 15
end

function modifier_guardian_angel_new_buff:GetEffectName()
   return "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf"
end

function modifier_guardian_angel_new_buff:GetEffectAttachType()
   return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_guardian_angel_new_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MODEL_SCALE,
    }
end

function modifier_guardian_angel_new_buff:GetModifierModelScale()
    return  300
end


function modifier_guardian_angel_new_buff:CheckState()
    return
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_UNTARGETABLE] = true,
    }
end


modifier_guardian_angel_new_buff2=class({})

function modifier_guardian_angel_new_buff2:IsPurgable()
    return false
end

function modifier_guardian_angel_new_buff2:IsPurgeException()
    return false
end

function modifier_guardian_angel_new_buff2:IsHidden()
    return false
end

function modifier_guardian_angel_new_buff2:GetStatusEffectName()
    return "particles/status_fx/status_effect_guardian_angel.vpcf"
   end

function modifier_guardian_angel_new_buff2:StatusEffectPriority()
    return 15
end

function modifier_guardian_angel_new_buff2:GetEffectName()
   return "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings_buff.vpcf"
end

function modifier_guardian_angel_new_buff2:GetEffectAttachType()
   return PATTACH_OVERHEAD_FOLLOW
end

function modifier_guardian_angel_new_buff2:ShouldUseOverheadOffset()
   return true
end

function modifier_guardian_angel_new_buff2:OnCreated()
   if not IsServer() then
       return
   end
   local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
   ParticleManager:SetParticleControlEnt(pfx, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
   self:AddParticle(pfx, false, false, 15, false, false)
end

function modifier_guardian_angel_new_buff2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_guardian_angel_new_buff2:GetModifierConstantHealthRegen()
    if self:GetAbility() then
        return  self:GetAbility():GetSpecialValueFor("hp")
    end
    return 0
end


function modifier_guardian_angel_new_buff2:GetModifierConstantManaRegen()
    if self:GetAbility() then
        return  self:GetAbility():GetSpecialValueFor("mana")
    end
    return 0
end

function modifier_guardian_angel_new_buff2:GetModifierPhysicalArmorBonus()
    if self:GetAbility() then
        return  self:GetAbility():GetSpecialValueFor("ar")
    end
    return 0
end


function modifier_guardian_angel_new_buff2:GetModifierIncomingDamage_Percentage()
    if self:GetCaster():TG_HasTalent("special_bonus_omniknight_7") then
        return -20
    end
    return 0
end