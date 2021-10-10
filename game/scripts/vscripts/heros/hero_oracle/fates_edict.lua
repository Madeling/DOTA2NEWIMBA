fates_edict=class({})
LinkLuaModifier("modifier_fates_edict_debuff", "heros/hero_oracle/fates_edict.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fates_edict_buff", "heros/hero_oracle/fates_edict.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fates_edict_buff_self", "heros/hero_oracle/fates_edict.lua", LUA_MODIFIER_MOTION_NONE)
function fates_edict:IsHiddenWhenStolen() 
    return false 
end

function fates_edict:IsStealable() 
    return true 
end

function fates_edict:IsRefreshable() 			
    return true 
end

function fates_edict:GetManaCost(iLevel)	
    if self:GetCaster():TG_HasTalent("special_bonus_oracle_2") then
        return 0
    else 
        return self.BaseClass.GetManaCost(self,iLevel)
    end
end

function fates_edict:OnSpellStart(tg) 
    local caster = self:GetCaster()
    local cur_tar = self:GetCursorTarget()
    local dur = self:GetSpecialValueFor("dur")
    if cur_tar==nil then  
        if tg==nil then   
            cur_tar=caster
        else  
            cur_tar=tg
        end 
    end 
    caster.fates_edict_target=cur_tar
    caster:EmitSound("Hero_Oracle.FatesEdict.Cast")
    caster:EmitSound("Hero_Oracle.FortunesEnd.Channel")
    if Is_Chinese_TG(cur_tar,caster) then 
            cur_tar:AddNewModifier(caster, self, "modifier_fates_edict_buff_self", {duration=dur})
    elseif not Is_Chinese_TG(cur_tar,caster)  then 
        if caster:TG_HasTalent("special_bonus_oracle_1") then
            cur_tar:AddNewModifier(caster, self, "modifier_disarmed", {duration=3})
        end
            cur_tar:AddNewModifier(caster, self, "modifier_fates_edict_debuff", {duration=dur})
    end
end

modifier_fates_edict_buff_self= class({})


function modifier_fates_edict_buff_self:IsHidden() 			
    return false 
end

function modifier_fates_edict_buff_self:IsPurgable() 		
    return true
end


function modifier_fates_edict_buff_self:IsPurgeException() 
    return true 
end

function modifier_fates_edict_buff_self:OnCreated() 
    if not IsServer() then
        return 
    end
    self:StartIntervalThink(1)
end

function modifier_fates_edict_buff_self:GetEffectName() 
    return "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf" 
end

function modifier_fates_edict_buff_self:GetEffectAttachType() 
    return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_fates_edict_buff_self:OnIntervalThink() 
    self:GetParent():Purge(false, true, false, true, true)
end



modifier_fates_edict_debuff = class({})

function modifier_fates_edict_debuff:IsDebuff()			
    return true 
end

function modifier_fates_edict_debuff:IsHidden() 			
    return false 
end

function modifier_fates_edict_debuff:IsPurgable() 		
    return true
end

function modifier_fates_edict_debuff:IsPurgeException() 
    return true 
end

function modifier_fates_edict_debuff:GetEffectName() 
    return "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf" 
end

function modifier_fates_edict_debuff:GetEffectAttachType() 
    return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_fates_edict_debuff:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_fates_edict_debuff:OnCreated() 
    if not IsServer() then
        return 
    end
    self:StartIntervalThink(1)
end

function modifier_fates_edict_debuff:OnIntervalThink() 
    self:GetParent():Purge(true, false, false, false, false)
end




modifier_fates_edict_buff= class({})


function modifier_fates_edict_buff:IsHidden() 			
    return false 
end

function modifier_fates_edict_buff:IsPurgable() 		
    return true
end

function modifier_fates_edict_buff:IsPurgeException() 
    return true 
end

function modifier_fates_edict_buff:GetEffectName() 
    return "particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf" 
end

function modifier_fates_edict_buff:GetEffectAttachType() 
    return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_fates_edict_buff:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_fates_edict_buff:OnTakeDamage(tg)
    if not IsServer() then
        return 
    end
    if tg.attacker == self:GetParent() then
        tg.unit:Purge(true, false, false, false, false)
    end
end
