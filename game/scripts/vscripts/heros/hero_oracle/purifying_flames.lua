purifying_flames=class({})
LinkLuaModifier("modifier_purifying_flames_buff", "heros/hero_oracle/purifying_flames.lua", LUA_MODIFIER_MOTION_NONE)

function purifying_flames:IsHiddenWhenStolen() 
    return false 
end

function purifying_flames:IsStealable() 
    return true 
end

function purifying_flames:IsRefreshable() 			
    return true 
end

function purifying_flames:GetCastPoint()			
    if self:GetCaster():TG_HasTalent("special_bonus_oracle_4") then
        return 0
    else
        return 0.3
    end
end

function purifying_flames:GetCooldown(iLevel)  
    return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_oracle_3")
end

function purifying_flames:OnSpellStart() 
    local caster = self:GetCaster()
    local cur_tar = self:GetCursorTarget()
    local dur =self:GetSpecialValueFor("dur")
    cur_tar:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
    if  cur_tar:TG_TriggerSpellAbsorb(self)   then
        return
    end
    if caster:TG_HasTalent("special_bonus_oracle_8") then
        local heros = FindUnitsInRadius(
            caster:GetTeamNumber(),
            cur_tar:GetAbsOrigin(),
            nil,
            300,
            DOTA_UNIT_TARGET_TEAM_BOTH, 
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_CLOSEST,
            false)
            if #heros> 0 then
                for _, hero in pairs(heros) do
                    hero:AddNewModifier(caster, self, "modifier_purifying_flames_buff", {duration=dur})
                end
            end
    else 
            cur_tar:AddNewModifier(caster, self, "modifier_purifying_flames_buff", {duration=dur})
    end

end


modifier_purifying_flames_buff= class({})


function modifier_purifying_flames_buff:IsHidden() 			
    return false 
end

function modifier_purifying_flames_buff:IsPurgable() 		
    return true
end

function modifier_purifying_flames_buff:IsPurgeException() 
    return true 
end

function modifier_purifying_flames_buff:GetEffectName() 
    return "particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames.vpcf" 
end

function modifier_purifying_flames_buff:GetEffectAttachType() 
    return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_purifying_flames_buff:GetAttributes()
     return MODIFIER_ATTRIBUTE_MULTIPLE
     end

function modifier_purifying_flames_buff:OnCreated()
    if not self:GetAbility() then
        return 
    end 
    self.HEAL=self:GetAbility():GetSpecialValueFor("heal")
    self.MANA=self:GetAbility():GetSpecialValueFor("mana")
    local dam=self:GetAbility():GetSpecialValueFor("dam")

    if not IsServer() then
        return 
    end
    local fx = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
    ParticleManager:ReleaseParticleIndex(fx)
    if not Is_Chinese_TG(self:GetParent(),self:GetCaster()) then 
            dam=(dam+(self:GetCaster():GetIntellect()*self:GetAbility():GetSpecialValueFor("int")*0.01))
        if self:GetParent():HasModifier("modifier_fates_edict_debuff") then
            dam=dam+dam*0.5
        end
        local damageTable = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = dam,
            damage_type =DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
            }
        ApplyDamage(damageTable)
    else 
        self:StartIntervalThink(1)
    end
end

function modifier_purifying_flames_buff:OnRefresh() 
    self:OnCreated()
end


function modifier_purifying_flames_buff:OnIntervalThink() 
    if Is_Chinese_TG(self:GetParent(),self:GetCaster()) then
        self:GetParent():GiveMana(self.MANA)
		SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_MANA_ADD, self:GetParent(),  self.MANA, nil)
    end 
    self:GetParent():Heal( self.HEAL, self:GetParent())
    SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(), self.HEAL, nil)
end

function modifier_purifying_flames_buff:OnDestroy() 
    self.HEAL=nil
    self.MANA=nil
end


