CreateTalents("npc_dota_hero_templar_assassin", "heros/hero_templar_assassin/refraction.lua")
refraction=class({})
LinkLuaModifier("modifier_refraction_attsp", "heros/hero_templar_assassin/refraction.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_refraction_buff1", "heros/hero_templar_assassin/refraction.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_refraction_buff2", "heros/hero_templar_assassin/refraction.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_refraction_buff3", "heros/hero_templar_assassin/refraction.lua", LUA_MODIFIER_MOTION_NONE)

function refraction:IsHiddenWhenStolen()
    return false
end

function refraction:IsStealable()
    return true
end

function refraction:IsRefreshable()
    return true
end

function refraction:GetIntrinsicModifierName()
    return "modifier_refraction_attsp"
end

function refraction:GetCooldown(iLevel)
        return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_templar_assassin_1")
end


function refraction:OnSpellStart()
    local caster = self:GetCaster()
    local dur=self:GetSpecialValueFor( "dur" )
    caster:EmitSound("Hero_TemplarAssassin.Refraction")
    caster:AddNewModifier(caster, self, "modifier_refraction_buff1", {duration=dur})
    caster:AddNewModifier(caster, self, "modifier_refraction_buff2", {duration=dur})
    if caster:Has_Aghanims_Shard()  then
    caster:Purge(false,true,false,false,false)
    end
end

modifier_refraction_attsp=class({})

function modifier_refraction_attsp:IsHidden()
    return true
end

function modifier_refraction_attsp:IsPurgable()
    return false
end

function modifier_refraction_attsp:IsPurgeException()
    return false
end

function modifier_refraction_attsp:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_refraction_attsp:GetModifierAttackSpeedBonus_Constant()
    if self:GetAbility() then
        return self:GetAbility():GetSpecialValueFor( "attsp" )
    end
        return 0
end

modifier_refraction_buff1=class({})


function modifier_refraction_buff1:IsHidden()
    return false
end

function modifier_refraction_buff1:IsPurgable()
    return false
end

function modifier_refraction_buff1:IsPurgeException()
    return false
end

function modifier_refraction_buff1:OnCreated()
    if not self:GetAbility() then
        return
    end
   self.NUM= self:GetAbility():GetSpecialValueFor( "num" )
    if not IsServer() then
        return
    end
    TG_Remove_AllModifier(self:GetParent(),"modifier_refraction_buff3")
    self:SetStackCount(self.NUM)
    local pos=self:GetParent():GetAbsOrigin()
   local fx= ParticleManager:CreateParticle("particles/econ/items/lanaya/ta_ti9_immortal_shoulders/ta_ti9_refraction.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW ,self:GetParent())
    ParticleManager:SetParticleControl(fx, 0,pos)
    ParticleManager:SetParticleControlEnt(fx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(fx, 5,pos)
    self:AddParticle( fx, false, false, 20, false, false )
end

function modifier_refraction_buff1:OnRefresh()
    self:OnCreated()
 end


 function modifier_refraction_buff1:OnDestroy()
    self.NUM=nil
    if not IsServer() then
        return
    end
    local fx= ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_loadout.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
    ParticleManager:SetParticleControl(fx, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(fx, 1, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(fx, 2, Vector(10,10,10))
    ParticleManager:ReleaseParticleIndex(fx)
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        self:GetAbility():GetSpecialValueFor("rd"),
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false )
    for _, hero in pairs(heros) do
        if not hero:IsInvisible() then
            self:GetParent():PerformAttack(hero, false, true, true, false, true, false, false)
        end
    end
 end

function modifier_refraction_buff1:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_refraction_buff1:OnTakeDamage(tg)
    if not IsServer() then
        return
    end

    if tg.unit == self:GetParent() and tg.original_damage>5 then
        self:GetParent():EmitSound("Hero_TemplarAssassin.Refraction.Absorb")
        local fx= ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit.vpcf", PATTACH_CUSTOMORIGIN,self:GetParent())
        ParticleManager:SetParticleControlEnt(fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(fx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(fx, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(fx)
        self.NUM=self.NUM-1
        self:SetStackCount(self.NUM)
        if self.NUM<=0 then
            if  self:GetCaster():TG_HasTalent("special_bonus_templar_assassin_5") then
                    local mod=self:GetCaster():FindModifierByName("modifier_refraction_buff2")
                    if mod then
                        mod:SetDuration(0, true)
                    end
            end
                if self:GetParent():Has_Aghanims_Shard()  then
                self:GetParent():Purge(false,true,false,false,false)
                end
            self:Destroy()
        end
    end
end

function modifier_refraction_buff1:GetAbsoluteNoDamageMagical()
    return 1
end
function modifier_refraction_buff1:GetAbsoluteNoDamagePhysical()
    return 1
end
function modifier_refraction_buff1:GetAbsoluteNoDamagePure()
    return 1
end

modifier_refraction_buff2=class({})


function modifier_refraction_buff2:IsHidden()
    return false
end

function modifier_refraction_buff2:IsPurgable()
    return false
end

function modifier_refraction_buff2:IsPurgeException()
    return false
end

function modifier_refraction_buff2:GetTexture()
    return "refraction"
end

function modifier_refraction_buff2:OnCreated()
    self.NUM= self:GetAbility():GetSpecialValueFor( "num" )
     if not IsServer() then
         return
     end
     self:SetStackCount(self.NUM)
 end

 function modifier_refraction_buff2:OnRefresh()
     self.NUM= self:GetAbility():GetSpecialValueFor( "num" )
      if not IsServer() then
          return
      end
      self:SetStackCount(self.NUM)
  end

  function modifier_refraction_buff2:OnDestroy()
    if not IsServer() then
        return
    end
    TG_Remove_AllModifier(self:GetParent(),"modifier_refraction_buff3")
 end

function modifier_refraction_buff2:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,

	}
end

function modifier_refraction_buff2:OnAttackLanded(tg)
    if not IsServer() then
        return
    end
    if tg.attacker == self:GetParent() and not tg.attacker:IsIllusion() then
                if self.NUM>0   then
                     if tg.attacker:HasModifier("modifier_refraction_buff2") then
                        self:GetParent():EmitSound("Hero_TemplarAssassin.Refraction.Damage")
                        self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_refraction_buff3", {})
                        self.NUM=self.NUM-1
                        self:SetStackCount(self.NUM)
                        if  self.NUM<=0 then
                                if not self:GetCaster():TG_HasTalent("special_bonus_templar_assassin_5") then
                                            self:Destroy()
                                end
                        end
                    end
        end
    end
end

modifier_refraction_buff3=class({})

function modifier_refraction_buff3:IsHidden()
    return true
end

function modifier_refraction_buff3:IsPurgable()
    return false
end

function modifier_refraction_buff3:IsPurgeException()
    return false
end

function modifier_refraction_buff3:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_refraction_buff3:OnCreated()
    self.ATT=self:GetAbility():GetSpecialValueFor( "att" )
 end

 function modifier_refraction_buff3:OnRefresh()
     self.ATT=self:GetAbility():GetSpecialValueFor( "att" )
  end

  function modifier_refraction_buff3:OnDestroy()
    self.ATT=nil
 end

function modifier_refraction_buff3:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end

function modifier_refraction_buff3:GetModifierPreAttack_BonusDamage()
    return  self.ATT
end