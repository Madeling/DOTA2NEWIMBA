CreateTalents("npc_dota_hero_elder_titan","heros/hero_elder_titan/ancestral_spirit.lua")
ancestral_spirit=class({})
LinkLuaModifier("modifier_ancestral_spirit", "heros/hero_elder_titan/ancestral_spirit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ancestral_spirit_buff", "heros/hero_elder_titan/ancestral_spirit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ancestral_spirit_echo_stomp", "heros/hero_elder_titan/ancestral_spirit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ancestral_spirit_auto", "heros/hero_elder_titan/ancestral_spirit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ancestral_spirit_return", "heros/hero_elder_titan/ancestral_spirit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ancestral_spirit_return_buff", "heros/hero_elder_titan/ancestral_spirit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ancestral_spirit_fit", "heros/hero_elder_titan/ancestral_spirit.lua", LUA_MODIFIER_MOTION_NONE)


function ancestral_spirit:IsHiddenWhenStolen()
    return false
end

function ancestral_spirit:IsStealable()
    return true
end

function ancestral_spirit:IsRefreshable()
    return true
end

function ancestral_spirit:GetAssociatedSecondaryAbilities()
    return "return_spirit"
end

function ancestral_spirit:OnUpgrade()
    local caster = self:GetCaster()
    local ab = caster:FindAbilityByName("return_spirit")
    if ab~=nil then
        ab:SetLevel(1)
        else
        caster:AddAbility("return_spirit"):SetLevel(1)
     end
end

function ancestral_spirit:OnSpellStart()
    local caster = self:GetCaster()
    local pos = self:GetCursorPosition()
    local dur=self:GetSpecialValueFor("dur")
    local ab=caster:FindAbilityByName("echo_stomp")
    local ab2=caster:FindAbilityByName("natural_order")
    local lv = 1
    local lv2 = 1
    if ab~=nil and ab:GetLevel()>0  then lv=ab:GetLevel()end
    if ab2~=nil and ab2:GetLevel()>0 then lv2=ab2:GetLevel()end
    EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Cast", caster)
    caster.tar=0
    caster:SwapAbilities("ancestral_spirit", "return_spirit", false, true)
    local ancestral = CreateUnitByName(
        "npc_dota_elder_titan_ancestral_spirit",
        pos,
        true,
        caster,
        caster,
        caster:GetTeamNumber())
        ancestral:SetControllableByPlayer(caster:GetPlayerID(), true)
        caster:AddNewModifier(caster, self, "modifier_ancestral_spirit_auto", {duration=dur})
        ancestral:AddNewModifier(caster, self, "modifier_ancestral_spirit_auto", {duration=dur})
        ancestral:AddNewModifier(caster, self, "modifier_ancestral_spirit", {anc=caster:entindex()})
        ancestral:FindAbilityByName("echo_stomp_spirit"):SetLevel(lv)
        ancestral:FindAbilityByName("natural_order_spirit"):SetLevel(lv2)
        local return_spirit= ancestral:FindAbilityByName("return_spirit")
        return_spirit:SetHidden(false)
        return_spirit:SetLevel(1)
        caster:AddNewModifier(caster, self, "modifier_ancestral_spirit_echo_stomp", {})
        caster.A=true
        caster.B=true
        caster.ancestral1=ancestral
        ancestral.caster1=caster
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_cast.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(particle, 0, pos)
    ParticleManager:SetParticleControl(particle, 2, pos)
    ParticleManager:ReleaseParticleIndex(particle)
    EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Spawn",ancestral)
end


modifier_ancestral_spirit=class({})

function modifier_ancestral_spirit:IsHidden()
	return true
end

function modifier_ancestral_spirit:IsPurgable()
	return false
end

function modifier_ancestral_spirit:IsPurgeException()
	return false
end

function modifier_ancestral_spirit:RemoveOnDeath()
	return true
end

function modifier_ancestral_spirit:OnCreated(tg)
    self.HEROS={}
    self.rd= self:GetAbility():GetSpecialValueFor( "rd" )
    self.dam= self:GetAbility():GetSpecialValueFor( "dam" )+self:GetCaster():TG_GetTalentValue("special_bonus_elder_titan_4")
    if not IsServer() then
        return
    end
    self.anc=EntIndexToHScript(tg.anc)
    self:OnIntervalThink()
    self:StartIntervalThink(FrameTime())
end

function modifier_ancestral_spirit:OnIntervalThink()
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        self.rd,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false)
        if #heros<1 then
            return
        end
            for _, hero in pairs(heros) do
                if TableFindKey(self.HEROS,hero) then
                    return
                end
                if  hero:IsMagicImmune() then
                    return
                end
                local damageTable = {
                     victim = hero,
                     attacker = self:GetCaster(),
                     damage =  self.dam,
                     damage_type =DAMAGE_TYPE_MAGICAL,
                     ability =  self:GetAbility(),
                    }
                    EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Damage",hero)
                    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_touch.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
                    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
                    ParticleManager:SetParticleControl(particle, 1, hero:GetAbsOrigin())
                    ParticleManager:SetParticleControl(particle, 2, hero:GetAbsOrigin())
                    ParticleManager:ReleaseParticleIndex(particle)
                    ApplyDamage(damageTable)
                    table.insert (self.HEROS, hero)
                    self.anc.tar=self.anc.tar+1
            end
end


function modifier_ancestral_spirit:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
    }
end


function modifier_ancestral_spirit:GetModifierMoveSpeed_Absolute()
    return 1000+self:GetCaster():TG_GetTalentValue("special_bonus_elder_titan_3")
end

function modifier_ancestral_spirit:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_ancestral_spirit:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_ancestral_spirit:GetAbsoluteNoDamagePure()
    return 1
end

function modifier_ancestral_spirit:CheckState()
    return
    {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
    }
end


modifier_ancestral_spirit_buff=class({})


function modifier_ancestral_spirit_buff:IsHidden()
	return false
end

function modifier_ancestral_spirit_buff:IsPurgable()
	return false
end

function modifier_ancestral_spirit_buff:IsPurgeException()
	return false
end

function modifier_ancestral_spirit_buff:GetTexture()
	return "ancestral_spirit"
end


function modifier_ancestral_spirit_buff:OnCreated(tg)
    if not IsServer() then
        return
    end
    local cas=EntIndexToHScript(tg.cas)
    self:SetStackCount(cas.tar)
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ancestral_spirit_fit", {duration=self:GetAbility():GetSpecialValueFor("ghost_dur")})
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(cas.tar,0,cas.tar))
    ParticleManager:SetParticleControl(particle, 2,  Vector(1,1,1))
    self:AddParticle(particle, false, false, 100, false, false)
end

function modifier_ancestral_spirit_buff:OnRefresh(tg)
    if not IsServer() then
        return
    end
    local cas=EntIndexToHScript(tg.cas)
    self:SetStackCount(cas.tar)
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ancestral_spirit_fit", {duration=self:GetAbility():GetSpecialValueFor("ghost_dur")})
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(cas.tar,0,cas.tar))
    ParticleManager:SetParticleControl(particle, 2,  Vector(1,1,1))
    self:AddParticle(particle, false, false, 100, false, false)
end

function modifier_ancestral_spirit_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_ancestral_spirit_buff:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("att_tar")*self:GetStackCount()
end

function modifier_ancestral_spirit_buff:GetModifierMoveSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("sp_tar")*self:GetStackCount()
end

function modifier_ancestral_spirit_buff:GetModifierAttackSpeedBonus_Constant()
    return  self:GetAbility():GetSpecialValueFor("attsp_tar")*self:GetStackCount()
end

function modifier_ancestral_spirit_buff:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("ar_tar")*self:GetStackCount()
end



modifier_ancestral_spirit_fit=class({})


function modifier_ancestral_spirit_fit:IsHidden()
	return false
end

function modifier_ancestral_spirit_fit:IsPurgable()
	return false
end

function modifier_ancestral_spirit_fit:IsPurgeException()
	return false
end

function modifier_ancestral_spirit_fit:RemoveOnDeath()
	return true
end

function modifier_ancestral_spirit_fit:GetTexture()
	return "spirit_att"
end

function modifier_ancestral_spirit_fit:GetStatusEffectName()
    return "particles/heros/elder_titan/status_effect_ghosts.vpcf"
end

function modifier_ancestral_spirit_fit:StatusEffectPriority()
    return 4
end


function modifier_ancestral_spirit_fit:CheckState()
    return
    {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
        [MODIFIER_STATE_UNSLOWABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end



modifier_ancestral_spirit_auto=class({})

function modifier_ancestral_spirit_auto:IsBuff()
    return true
end

function modifier_ancestral_spirit_auto:IsHidden()
	return false
end

function modifier_ancestral_spirit_auto:IsPurgable()
	return false
end

function modifier_ancestral_spirit_auto:IsPurgeException()
	return false
end

function modifier_ancestral_spirit_auto:OnDestroy()
    if not IsServer() then
        return
    end
    if self:GetParent()==self:GetCaster().ancestral1 then
     self:GetParent():CastAbilityNoTarget( self:GetParent():FindAbilityByName("return_spirit"), self:GetParent():GetOwner():GetPlayerOwnerID())
    end
end


modifier_ancestral_spirit_echo_stomp=class({})


function modifier_ancestral_spirit_echo_stomp:IsHidden()
	return true
end

function modifier_ancestral_spirit_echo_stomp:IsPurgable()
	return false
end

function modifier_ancestral_spirit_echo_stomp:IsPurgeException()
	return false
end


return_spirit=class({})

function return_spirit:IsHiddenWhenStolen()
    return false
end

function return_spirit:IsStealable()
    return true
end

function return_spirit:IsNetherWardStealable()
    return true
end

function return_spirit:IsRefreshable()
    return true
end

function return_spirit:GetAssociatedPrimaryAbilities()
    return "ancestral_spirit"
end


function return_spirit:OnSpellStart()
    local caster = self:GetCaster()
    if caster.ancestral1~=nil then
        EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Return", caster.ancestral1)
        caster.ancestral1:StartGesture( ACT_DOTA_FLAIL )
        caster.ancestral1:AddNewModifier(caster, self, "modifier_ancestral_spirit_return", {c=caster.ancestral1:entindex(),c2=caster:entindex()})
    end
    if  caster:GetOwner().ancestral1~=nil then
       EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Return", caster:GetOwner().ancestral1)
        caster:GetOwner().ancestral1:StartGesture( ACT_DOTA_FLAIL )
       caster:GetOwner().ancestral1:AddNewModifier(caster:GetOwner().ancestral1, self, "modifier_ancestral_spirit_return", {c=caster:GetOwner().ancestral1:entindex(),c2=caster:GetOwner():entindex()})
      end
end


modifier_ancestral_spirit_return=class({})


function modifier_ancestral_spirit_return:IsHidden()
	return true
end

function modifier_ancestral_spirit_return:IsPurgable()
	return false
end

function modifier_ancestral_spirit_return:IsPurgeException()
	return false
end

function modifier_ancestral_spirit_return:RemoveOnDeath()
	return true
end

function modifier_ancestral_spirit_return:OnCreated(tg)
    if not IsServer() then
        return
    end
    self.CASTER=EntIndexToHScript(tg.c)
    self.CASTER2=EntIndexToHScript(tg.c2)
    self:StartIntervalThink(FrameTime())
end

function modifier_ancestral_spirit_return:OnIntervalThink()

    if  self.CASTER.caster1:HasModifier("modifier_echo_stomp") or self.CASTER:HasModifier("modifier_echo_stomp_spirit") then
        self.CASTER:RemoveGesture(ACT_DOTA_FLAIL)
        TG_Remove_Modifier(self.CASTER,"modifier_ancestral_spirit_return_buff",0)
    else
        self.CASTER:AddNewModifier(self.CASTER, self:GetAbility(), "modifier_ancestral_spirit_return_buff", {})
        self.CASTER:MoveToNPC(self.CASTER:GetOwner())
        local direction=TG_Direction(self.CASTER:GetOwner():GetAbsOrigin(),self.CASTER:GetAbsOrigin())
        self.CASTER:SetForwardVector( direction )
        self.CASTER:SetAbsOrigin(self.CASTER:GetAbsOrigin() + direction * (1000 / (1/ FrameTime())))
        self.CASTER:StartGesture(ACT_DOTA_FLAIL)
    end
    if TG_Distance(self.CASTER:GetAbsOrigin(),self.CASTER:GetOwner():GetAbsOrigin()) <=150 then
        EmitSoundOn("Hero_ElderTitan.AncestralSpirit.Buff",self.CASTER)
        local ab=self.CASTER2:FindAbilityByName("ancestral_spirit")
        self.CASTER2:AddNewModifier(self.CASTER2, ab, "modifier_ancestral_spirit_buff", {duration=ab:GetSpecialValueFor("dur"),cas=self.CASTER2:entindex()})
        TG_Remove_Modifier(self.CASTER.caster1,"modifier_ancestral_spirit_echo_stomp",0)
        TG_Remove_Modifier(self.CASTER.caster1,"modifier_ancestral_spirit_auto",0)
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_ambient_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.CASTER2)
        ParticleManager:ReleaseParticleIndex(particle)
        self:StartIntervalThink(-1)
        self.CASTER.caster1:SwapAbilities("ancestral_spirit", "return_spirit", true, false)
        self.CASTER:Destroy()
        self.CASTER.caster1=nil
        self.CASTER2.ancestral1=nil
        self.CASTER=nil
        self.CASTER2=nil
    end
end

modifier_ancestral_spirit_return_buff=class({})


function modifier_ancestral_spirit_return_buff:IsHidden()
	return true
end

function modifier_ancestral_spirit_return_buff:IsPurgable()
	return false
end

function modifier_ancestral_spirit_return_buff:IsPurgeException()
	return false
end

function modifier_ancestral_spirit_return_buff:RemoveOnDeath()
	return true
end

function modifier_ancestral_spirit_return_buff:CheckState()
    return
    {
        [MODIFIER_STATE_ROOTED] = true,
    }
end