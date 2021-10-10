repel=class({})

LinkLuaModifier("modifier_repel_buff", "heros/hero_omniknight/repel.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_repel_buff2", "heros/hero_omniknight/repel.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_repel_pa", "heros/hero_omniknight/repel.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_repel_buff3", "heros/hero_omniknight/repel.lua", LUA_MODIFIER_MOTION_NONE)
function repel:IsHiddenWhenStolen() 
    return false 
end

function repel:IsStealable() 
    return true 
end


function repel:IsRefreshable() 			
    return true 
end

function repel:OnSpellStart(tg)
    local caster=self:GetCaster() 
    local target=self:GetCursorTarget() 
    local dur=self:GetSpecialValueFor("duration")+caster:TG_GetTalentValue("special_bonus_omniknight_3")
    target=target==nil and tg or target
    target:Purge(false, true, false, true, true)
    target:AddNewModifier(caster, self, "modifier_repel_buff", {duration=dur})
    if target~=caster and Is_Chinese_TG(target,caster) then 
        caster:Purge(false, true, false, true, true)
        caster:AddNewModifier(caster, self, "modifier_repel_buff", {duration=dur})
    end 
    if caster:HasAbility("degen_aura") then 
        local AB=caster:FindAbilityByName("degen_aura")
        if AB:GetLevel()>0 and target~=caster then 
            target:AddNewModifier(caster, AB, "modifier_repel_pa", {duration=dur})
        end
    end
end

modifier_repel_buff=class({})

function modifier_repel_buff:IsPurgable() 			
    return false 
end

function modifier_repel_buff:IsPurgeException() 	
    return false 
end

function modifier_repel_buff:IsHidden()				
    return false 
end

function modifier_repel_buff:IsDebuff()				
    return false 
end

function modifier_repel_buff:CheckState()
    return 
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
end

function modifier_repel_buff:DeclareFunctions() 
    return
     {
         MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
       --  MODIFIER_EVENT_ON_ATTACK_LANDED 
        }
 end

function modifier_repel_buff:GetModifierMagicalResistanceBonus() 
    return 100 
end

function modifier_repel_buff:GetEffectName()
     return "particles/units/heroes/hero_omniknight/omniknight_repel_buff.vpcf"
    end

function modifier_repel_buff:GetEffectAttachType() 
    return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_repel_buff:OnCreated(tg)	
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    --self.stack=self:GetAbility():GetSpecialValueFor("stack")-self.caster:TG_GetTalentValue("special_bonus_omniknight_4")
    --self.attnum=0
end
--[[
function modifier_repel_buff:OnAttackLanded(tg)				
    if not IsServer() then 
        return
    end 
    if tg.target == self.parent then 
        self.attnum=self.attnum+1
        if self.attnum>=self.stack then 
            self.attnum=0
            if self.caster:HasAbility("purification_new") then 
                local AB=self.caster:FindAbilityByName("purification_new")
                if AB:GetLevel()>0 then 
                    AB:OnSpellStart()
                end
            end
        end 
    end 
end
]]
function modifier_repel_buff:OnDestroy()	
    if not IsServer() then 
        return
    end 	
    self.parent:AddNewModifier(self.caster,self.ability, "modifier_repel_buff2", {duration=self.ability:GetSpecialValueFor("duration")+self.caster:TG_GetTalentValue("special_bonus_omniknight_4")})
end

modifier_repel_buff2=class({})

function modifier_repel_buff2:IsPurgable() 			
    return false 
end

function modifier_repel_buff2:IsPurgeException() 	
    return false 
end

function modifier_repel_buff2:IsHidden()				
    return false 
end

function modifier_repel_buff2:IsDebuff()				
    return false 
end

function modifier_repel_buff2:DeclareFunctions() 
    return {MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING}
 end

function modifier_repel_buff2:GetModifierStatusResistanceStacking() 
    return self:GetAbility():GetSpecialValueFor("status_resistance") 
end



modifier_repel_pa = class({})

function modifier_repel_pa:IsDebuff()			
    return false 
end

function modifier_repel_pa:IsHidden() 			
    return true 
end

function modifier_repel_pa:IsPurgable() 			
    return false 
end

function modifier_repel_pa:IsPurgeException() 	
    return false 
end

function modifier_repel_pa:IsAura()
	if self:GetParent():PassivesDisabled() then
		return false
	else
		return true
	end
end

function modifier_repel_pa:GetAuraDuration() 
    return 0 
end

function modifier_repel_pa:GetModifierAura() 
    return "modifier_repel_buff3" 
end

function modifier_repel_pa:GetAuraRadius() 
    return self:GetAbility():GetSpecialValueFor("radius") 
end

function modifier_repel_pa:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
 end

function modifier_repel_pa:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_repel_pa:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC 
end

modifier_repel_buff3 = class({})

function modifier_repel_buff3:IsDebuff()			
    return true 
end

function modifier_repel_buff3:IsHidden() 			
    return false 
end

function modifier_repel_buff3:IsPurgable() 			
    return false 
end

function modifier_repel_buff3:IsPurgeException() 	
    return false 
end

function modifier_repel_buff3:GetEffectName() 
    return "particles/units/heroes/hero_omniknight/omniknight_degen_aura_debuff.vpcf"  
end

function modifier_repel_buff3:GetEffectAttachType() 
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_repel_buff3:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    } 
end


function modifier_repel_buff3:GetModifierMoveSpeedBonus_Percentage() 
    return (0 - self:GetAbility():GetSpecialValueFor("speed_bonus"))
 end