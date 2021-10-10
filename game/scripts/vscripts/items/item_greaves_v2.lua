item_greaves_v2=class({})
LinkLuaModifier("modifier_item_greaves_v2_pa", "items/item_greaves_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_greaves_v2_buff", "items/item_greaves_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_greaves_v2_buffcd", "items/item_greaves_v2.lua", LUA_MODIFIER_MOTION_NONE)

function item_greaves_v2:OnSpellStart()
    local caster = self:GetCaster()
    local hp=self:GetSpecialValueFor("hp")
    local mana=self:GetSpecialValueFor("mana")
    local hpper=self:GetSpecialValueFor("hpper")
    local manaper=self:GetSpecialValueFor("manaper")
    caster:EmitSound("Item.GuardianGreaves.Activate")
	local fx = ParticleManager:CreateParticle("particles/items3_fx/warmage.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:ReleaseParticleIndex(fx)
	local heros = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _, hero in pairs(heros) do
        if not hero:HasModifier("modifier_item_greaves_v2_buffcd") then 
            local hp2=hp+hero:GetMaxHealth()*hpper*0.01
            local mana2=mana+hero:GetMaxHealth()*manaper*0.01
            hero:Heal(hp, caster)
            hero:GiveMana(mana2)
            SendOverheadEventMessage(hero, OVERHEAD_ALERT_HEAL, hero,hp2, nil)
            SendOverheadEventMessage(hero, OVERHEAD_ALERT_MANA_ADD, hero,mana2, nil)
            local fx2 = ParticleManager:CreateParticle("particles/items3_fx/warmage_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
            ParticleManager:ReleaseParticleIndex(fx2)
            hero:AddNewModifier(hero, self, "modifier_item_greaves_v2_buffcd", {duration=20})
            hero:Purge(false, true, false, true, true)
        end
	end
end

function item_greaves_v2:GetIntrinsicModifierName() 
    return "modifier_item_greaves_v2_pa" 
end


modifier_item_greaves_v2_pa=class({})


function modifier_item_greaves_v2_pa:IsHidden() 			
    return true 
end

function modifier_item_greaves_v2_pa:IsPurgable() 			
    return false 
end

function modifier_item_greaves_v2_pa:IsPurgeException() 	
    return false 
end

function modifier_item_greaves_v2_pa:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_item_greaves_v2_pa:IsAura() 
    return true 
end

function modifier_item_greaves_v2_pa:GetAuraDuration() 
    return 0
end

function modifier_item_greaves_v2_pa:GetModifierAura() 
    return "modifier_item_greaves_v2_buff" 
end

function modifier_item_greaves_v2_pa:GetAuraRadius() 
    return self:GetAbility():GetSpecialValueFor("ard") 
end

function modifier_item_greaves_v2_pa:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY 
end

function modifier_item_greaves_v2_pa:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_item_greaves_v2_pa:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO 
end

function modifier_item_greaves_v2_pa:DeclareFunctions() 
    return 
        {
            MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
            MODIFIER_PROPERTY_MANA_BONUS,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE, 
            MODIFIER_EVENT_ON_TAKEDAMAGE
        }
end

function modifier_item_greaves_v2_pa:OnCreated() 
    self.parent=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
        self.MINHP=self.ability:GetSpecialValueFor("minhp") 
        self.PAR=self.ability:GetSpecialValueFor("par") 
        self.PMANA=self.ability:GetSpecialValueFor("pmana") 
        self.PSP=self.ability:GetSpecialValueFor("psp") 
end



function modifier_item_greaves_v2_pa:OnTakeDamage(tg)
	if not IsServer() then
		return
	end
    if tg.unit == self.parent then
        local hp=self.parent:GetMaxHealth()*self.MINHP*0.01
        if self.parent:GetHealth() <= hp and self.ability:IsCooldownReady() and self.ability:IsOwnersManaEnough() and not self.parent:IsIllusion() and not self.parent:IsSilenced() and not self.parent:IsMuted() then 
            self.ability:UseResources(true, true, true)
            self.ability:OnSpellStart()
            self.parent:Purge(false,true,false,false,false)
        end
	end
end


function modifier_item_greaves_v2_pa:GetModifierPhysicalArmorBonus() 
     return self.PAR
end

function modifier_item_greaves_v2_pa:GetModifierManaBonus()
     return self.PMANA
end

function modifier_item_greaves_v2_pa:GetModifierMoveSpeedBonus_Special_Boots() 
    return self.PSP
end




modifier_item_greaves_v2_buff=class({})

function modifier_item_greaves_v2_buff:IsHidden() 			
    return false 
end

function modifier_item_greaves_v2_buff:IsPurgable() 			
    return false 
end

function modifier_item_greaves_v2_buff:IsPurgeException() 	
    return false 
end


function modifier_item_greaves_v2_buff:OnCreated() 
    if self:GetAbility() then
    self.AHP=self:GetAbility():GetSpecialValueFor("ahp") 
    self.AAR=self:GetAbility():GetSpecialValueFor("aar") 
end
end



function modifier_item_greaves_v2_buff:DeclareFunctions()
     return 
     {
         MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, 
         MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    } 
end

function modifier_item_greaves_v2_buff:GetModifierConstantHealthRegen()
    return self.AHP 
end

function modifier_item_greaves_v2_buff:GetModifierPhysicalArmorBonus()
    return self.AAR
end

modifier_item_greaves_v2_buffcd=class({})

function modifier_item_greaves_v2_buffcd:IsHidden() 			
    return false 
end

function modifier_item_greaves_v2_buffcd:IsPurgable() 			
    return false 
end

function modifier_item_greaves_v2_buffcd:IsPurgeException() 	
    return false 
end

function modifier_item_greaves_v2_buffcd:RemoveOnDeath() 	
    return false 
end

function modifier_item_greaves_v2_buffcd:GetTexture() 	
    return "item_greaves_v2" 
end
