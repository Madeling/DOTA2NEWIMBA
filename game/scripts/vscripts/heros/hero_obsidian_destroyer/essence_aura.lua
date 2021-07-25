essence_aura=class({})

LinkLuaModifier("modifier_essence_aura_buff", "heros/hero_obsidian_destroyer/essence_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_essence_aura_buff2", "heros/hero_obsidian_destroyer/essence_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_essence_aura_buff3", "heros/hero_obsidian_destroyer/essence_aura.lua", LUA_MODIFIER_MOTION_NONE)
function essence_aura:GetIntrinsicModifierName() 
    return "modifier_essence_aura_buff" 
end

modifier_essence_aura_buff=class({})

function modifier_essence_aura_buff:IsPurgable() 			
    return false 
end

function modifier_essence_aura_buff:IsPurgeException() 	
    return false 
end

function modifier_essence_aura_buff:IsHidden()				
    return true 
end

function modifier_essence_aura_buff:IsAura() 
    return true 
end

function modifier_essence_aura_buff:GetModifierAura() 
    return "modifier_essence_aura_buff2" 
end

function modifier_essence_aura_buff:GetAuraRadius() 
    return 1200
end

function modifier_essence_aura_buff:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_essence_aura_buff:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_essence_aura_buff:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO 
end




modifier_essence_aura_buff2=class({})

function modifier_essence_aura_buff2:IsPurgable() 			
    return false 
end

function modifier_essence_aura_buff2:IsPurgeException() 	
    return false 
end

function modifier_essence_aura_buff2:IsHidden()				
    return false 
end

function modifier_essence_aura_buff2:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_essence_aura_buff2:OnCreated()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.restore_amount=(self.ability:GetSpecialValueFor("restore_amount")+self.caster:TG_GetTalentValue("special_bonus_obsidian_destroyer_6"))*0.01
    self.restore_chance=self.ability:GetSpecialValueFor("restore_chance")+self.caster:TG_GetTalentValue("special_bonus_obsidian_destroyer_5")
    self.int=self.ability:GetSpecialValueFor("int")
    self.dur=self.ability:GetSpecialValueFor("dur")
end

function modifier_essence_aura_buff2:OnRefresh()
   self:OnCreated()
end

function modifier_essence_aura_buff2:OnAbilityExecuted(tg)
    if IsServer() then 
        if tg.unit==self.parent and  not self.parent:IsIllusion() and tg.ability~=nil and not tg.ability:IsToggle() and not tg.ability:IsItem() and tg.ability:GetCooldown(tg.ability:GetLevel())>1 then 
            if RollPseudoRandomPercentage(self.restore_chance,0,self.parent) then
                EmitSoundOn("Hero_ObsidianDestroyer.EssenceAura", self.parent)
                if  tg.ability:GetCooldown(tg.ability:GetLevel())>3 then 
                self.caster:AddNewModifier(self.caster, self.ability, "modifier_essence_aura_buff3", {duration=self.dur,num=self.int})
                end 
                self.parent:GiveMana(self.parent:GetMaxMana()*self.restore_amount)
                local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,self.parent)
                ParticleManager:ReleaseParticleIndex(pf)
            end
        end
    end
end

function modifier_essence_aura_buff2:OnAttack(tg)
    if IsServer() then 
        if tg.attacker==self.parent and not self.parent:IsIllusion() and not tg.target:IsBuilding() then 
            local ab=self.parent:FindAbilityByName("arcane_orb")
            if ab~=nil and ab:GetLevel()>0 and ab:GetAutoCastState() and ab:IsOwnersManaEnough() then 
                if RollPseudoRandomPercentage(self.restore_chance,0,self.parent) then
                    EmitSoundOn("Hero_ObsidianDestroyer.EssenceAura", self.parent)
                    self.caster:AddNewModifier(self.caster, self.ability, "modifier_essence_aura_buff3", {duration=self.dur,num=self.int})
                    self.parent:GiveMana(self.parent:GetMaxMana()*self.restore_amount)
                    local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW,self.parent)
                    ParticleManager:ReleaseParticleIndex(pf)
                end
            end
        end
    end
end


modifier_essence_aura_buff3=class({})

function modifier_essence_aura_buff3:IsPurgable() 			
    return false 
end

function modifier_essence_aura_buff3:IsPurgeException() 	
    return false 
end

function modifier_essence_aura_buff3:IsHidden()				
    return false 
end

function modifier_essence_aura_buff3:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_essence_aura_buff3:OnCreated(tg)
    self.caster=self:GetCaster()
    if IsServer() then 
        self:SetStackCount(self:GetStackCount()+tg.num)
        self:GetParent():CalculateStatBonus(true)
    end
end

function modifier_essence_aura_buff3:OnRefresh(tg)
   self:OnCreated(tg)
end

function modifier_essence_aura_buff3:GetModifierBonusStats_Intellect()
    return  self:GetStackCount()
 end

 function modifier_essence_aura_buff3:GetModifierMoveSpeedBonus_Constant()
    if self.caster:HasScepter() then 
        return  self:GetStackCount()
    end  
        return 0
 end
 
 function modifier_essence_aura_buff3:GetModifierAttackRangeBonus()
    if self.caster:HasScepter() then 
        return  self:GetStackCount()
    end  
        return 0
 end

 function modifier_essence_aura_buff3:GetModifierAttackSpeedBonus_Constant()
    if self.caster:HasScepter() then 
        return  self:GetStackCount()
    end  
        return 0
 end
