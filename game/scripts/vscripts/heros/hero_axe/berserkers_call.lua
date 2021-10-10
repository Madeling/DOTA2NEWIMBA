CreateTalents("npc_dota_hero_axe", "heros/hero_axe/berserkers_call.lua")
berserkers_call = class({})
LinkLuaModifier("modifier_berserkers_call_axe_buff", "heros/hero_axe/berserkers_call.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_berserkers_call_axe_debuff", "heros/hero_axe/berserkers_call.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_berserkers_call_axe_buff3", "heros/hero_axe/berserkers_call.lua", LUA_MODIFIER_MOTION_NONE)

function berserkers_call:IsHiddenWhenStolen()return false
end
function berserkers_call:IsStealable()return true
end
function berserkers_call:IsRefreshable()return true
end
function berserkers_call:GetManaCost(iLevel)
    if self:GetCaster():TG_HasTalent("special_bonus_axe_2") then
        return 0
    else
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end
function berserkers_call:OnSpellStart()
    self.caster=self.caster or self:GetCaster()
    local num=self:GetSpecialValueFor("num")
    EmitSoundOn("Hero_Axe.Berserkers_Call",  self.caster)
    self.caster:AddNewModifier( self.caster, self, "modifier_berserkers_call_axe_buff", {duration = self:GetSpecialValueFor("buff_defense_time")})
    local units=FindUnitsInRadius(self.caster:GetTeamNumber(),self.caster:GetAbsOrigin(),nil,self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
     if #units>0 then
            local stun_time=self:GetSpecialValueFor("stun_time")
            local ab=self.caster:FindAbilityByName("battle_hunger")
            for _,target in pairs(units) do
                target:AddNewModifier_RS(self.caster, self, "modifier_axe_berserkers_call", {duration = stun_time})
                    if #units>num or self.caster:TG_HasTalent("special_bonus_axe_1")  then
                        target:AddNewModifier_RS(self.caster, self, "modifier_berserkers_call_axe_debuff", {duration = stun_time})
                    end
                    if ab and self.caster:HasScepter() then
                        ab:OnSpellStart(target)
                    end
            end
    end
        local mod=self.caster:FindModifierByName("modifier_counter_helix_ch")
        if mod then
                mod:TurnAround(self.caster)
        end
        if #units>num or self.caster:TG_HasTalent("special_bonus_axe_1")  then
            local particle = ParticleManager:CreateParticle( "particles/heros/axe/axe_bc_m.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
            ParticleManager:ReleaseParticleIndex(particle)
        else
            local particle = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_call.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
            ParticleManager:ReleaseParticleIndex(particle)
        end
end

  --防御buff
    modifier_berserkers_call_axe_buff =  class({})
    function modifier_berserkers_call_axe_buff:IsHidden()return false
    end
    function modifier_berserkers_call_axe_buff:IsPurgable()return false
    end
    function modifier_berserkers_call_axe_buff:DeclareFunctions()
        return
        {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
            MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        }
    end
    function modifier_berserkers_call_axe_buff:OnCreated()
        self.armor=self:GetAbility():GetSpecialValueFor( "armor")
        self.magica=self:GetAbility():GetSpecialValueFor( "magica")
    end
    function modifier_berserkers_call_axe_buff:OnRefresh()
        self:OnCreated()
    end
    function modifier_berserkers_call_axe_buff:GetModifierPhysicalArmorBonus(  )return self.armor
    end
    function modifier_berserkers_call_axe_buff:GetModifierMagicalResistanceBonus(  )return self.magica
    end


    --敌人debuff
    modifier_berserkers_call_axe_debuff= class({})

    function modifier_berserkers_call_axe_debuff:IsHidden()return true
    end
    function modifier_berserkers_call_axe_debuff:IsDebuff()return true
    end
    function modifier_berserkers_call_axe_debuff:IsPurgable()return false
    end
    function modifier_berserkers_call_axe_debuff:OnDeath(tg)
        if IsServer() then
            if tg.unit == self:GetCaster() then
                self:Destroy()
            end
        end
    end
    function modifier_berserkers_call_axe_debuff:OnCreated()
        self.attsp=self:GetAbility():GetSpecialValueFor( "attsp")
    end
    function modifier_berserkers_call_axe_debuff:OnRefresh()
        self:OnCreated()
    end
    function modifier_berserkers_call_axe_debuff:CheckState()
        return
        {
            [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
            [MODIFIER_STATE_SILENCED]=true,
            [MODIFIER_STATE_CANNOT_MISS]=true,
            [MODIFIER_STATE_MUTED]=true,
        }
    end
    function modifier_berserkers_call_axe_debuff:DeclareFunctions()
        return
        {
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
            MODIFIER_EVENT_ON_DEATH,
        }
    end

    function modifier_berserkers_call_axe_debuff:GetModifierAttackSpeedBonus_Constant()
        return self.attsp
    end


    --A帐效果
    modifier_berserkers_call_axe_buff3= class({})

    function modifier_berserkers_call_axe_buff3:IsHidden()
        return true
    end
    function modifier_berserkers_call_axe_buff3:IsPurgable()
        return false
    end

    function modifier_berserkers_call_axe_buff3:DeclareFunctions()
        return
         {
            MODIFIER_EVENT_ON_ATTACKED,
        }
    end

    function modifier_berserkers_call_axe_buff3:OnAttacked(tg)
        if not IsServer() then
            return
        end
        if not tg.attacker:HasModifier("modifier_berserkers_call_axe_debuff") and tg.attacker:IsRealHero() and tg.attacker~=self:GetParent() and tg.target==self:GetParent()   then
            tg.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_axe_berserkers_call", {duration = self:GetAbility():GetSpecialValueFor("stun_time")})
            tg.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_berserkers_call_axe_debuff", {duration = self:GetAbility():GetSpecialValueFor("stun_time")})
        end
     end