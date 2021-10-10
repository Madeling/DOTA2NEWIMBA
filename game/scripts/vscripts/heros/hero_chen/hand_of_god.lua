hand_of_god=class({})
LinkLuaModifier("modifier_hand_of_god_buff", "heros/hero_chen/hand_of_god.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hand_of_god_buff2", "heros/hero_chen/hand_of_god.lua", LUA_MODIFIER_MOTION_NONE)
function hand_of_god:IsHiddenWhenStolen()
    return false
end

function hand_of_god:IsStealable()
    return true
end

function hand_of_god:IsRefreshable()
    return true
end


function hand_of_god:GetCooldown(iLevel)
    return self.BaseClass.GetCooldown(self,iLevel)
end

function hand_of_god:OnSpellStart()
    local caster=self:GetCaster()
    local hp=caster:TG_HasTalent("special_bonus_chen_7") and 99999 or self:GetSpecialValueFor( "heal_amount" )
    local dur=self:GetSpecialValueFor( "num" )*self:GetSpecialValueFor( "i" )
    if caster:TG_HasTalent("special_bonus_chen_7") then
        EmitGlobalSound("chen_chen_ability_handgod_01")
    end
    EmitGlobalSound("Hero_Chen.HandOfGodHealHero")
    EmitGlobalSound("Hero_Chen.HandOfGodHealCreep")
    for i=1, #CDOTA_PlayerResource.TG_HERO do
        if CDOTA_PlayerResource.TG_HERO[i] then
            local hero = CDOTA_PlayerResource.TG_HERO[i]
            if hero~= nil and  hero:IsAlive() then
                if  Is_Chinese_TG(hero,self) then
                    hero:Heal(hp, self)
                    SendOverheadEventMessage(hero, OVERHEAD_ALERT_HEAL, hero,hp, nil)
                    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_hand_of_god.vpcf", PATTACH_POINT_FOLLOW, hero)
                    ParticleManager:SetParticleControlEnt(particle, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
                    ParticleManager:ReleaseParticleIndex(particle)
                    hero:AddNewModifier(caster, self, "modifier_hand_of_god_buff", {duration=dur})
                    if caster:TG_HasTalent("special_bonus_chen_7") then
                        hero:AddNewModifier(caster, self, "modifier_invulnerable", {duration=1.5})
                    end
                    if caster:Has_Aghanims_Shard() then
                        hero:GiveMana(9999)
                        SendOverheadEventMessage(hero, OVERHEAD_ALERT_MANA_ADD, hero,hp, nil)
                        hero:AddNewModifier(caster, self, "modifier_hand_of_god_buff2", {duration=7})
                    end
                end
		    end
		end
    end
end


modifier_hand_of_god_buff=class({})


function modifier_hand_of_god_buff:IsHidden()
	return false
end

function modifier_hand_of_god_buff:IsPurgable()
	return false
end

function modifier_hand_of_god_buff:IsPurgeException()
	return false
end

function modifier_hand_of_god_buff:OnCreated()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.heal_amount=self.ability:GetSpecialValueFor("heal_amount")
	if  not IsServer() then
	    return
    end
    self:StartIntervalThink(2)
end

function modifier_hand_of_god_buff:OnIntervalThink()
    self.parent:Purge(false, true, false, true, true)
    self.parent:Heal(self.heal_amount, caster)
    SendOverheadEventMessage(self.parent, OVERHEAD_ALERT_HEAL, self.parent,self.heal_amount, self.parent:GetPlayerOwner())
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_hand_of_god.vpcf", PATTACH_POINT_FOLLOW, self.parent)
    ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)
end


modifier_hand_of_god_buff2=class({})


function modifier_hand_of_god_buff2:IsHidden()
	return false
end

function modifier_hand_of_god_buff2:IsPurgable()
	return false
end

function modifier_hand_of_god_buff2:IsPurgeException()
	return false
end

function modifier_hand_of_god_buff2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_hand_of_god_buff2:GetModifierPhysicalArmorBonus()
    return 10
end

function modifier_hand_of_god_buff2:GetModifierMagicalResistanceBonus()
    return 25
end
