CreateTalents("npc_dota_hero_oracle", "heros/hero_oracle/fortunes_end.lua")
fortunes_end=class({})
LinkLuaModifier("modifier_fortunes_end_debuff", "heros/hero_oracle/fortunes_end.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fortunes_end_debuff2", "heros/hero_oracle/fortunes_end.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fortunes_end_buff", "heros/hero_oracle/fortunes_end.lua", LUA_MODIFIER_MOTION_NONE)

function fortunes_end:IsHiddenWhenStolen() 
    return false 
end

function fortunes_end:IsStealable() 
    return true 
end

function fortunes_end:IsRefreshable() 			
    return true 
end

function fortunes_end:GetAOERadius() 
    return 400
end

function fortunes_end:OnSpellStart() 
    local caster = self:GetCaster()
    local cur_tar = self:GetCursorTarget()
    local tar_pos=cur_tar:GetAbsOrigin()
    caster:EmitSound("Hero_Oracle.FortunesEnd.Attack")  
    local P = 
    {
        Target = cur_tar,
        Source = caster,
        Ability = self,	
        EffectName = "particles/econ/items/oracle/oracle_fortune_ti7/oracle_fortune_ti7_prj.vpcf",
        iMoveSpeed = 1500,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
        bDrawsOnMinimap = false,
        bDodgeable = true,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        bProvidesVision = false,	
    }
    TG_CreateProjectile({id=1,team=caster:GetTeamNumber(),owner=caster,p=P})
end

function fortunes_end:OnProjectileHit_ExtraData(target, location,kv)
    local caster = self:GetCaster()
	if not target then
		return
    end
    if  target:TG_TriggerSpellAbsorb(self)   then
        return
    end 
    local dur =self:GetSpecialValueFor("dur")
    local dam =self:GetSpecialValueFor("dam")
    local rd =self:GetSpecialValueFor("rd")
    if Is_Chinese_TG(caster,target) then 
        target:Purge(false, true, false, false, false)
        target:AddNewModifier(caster, self, "modifier_fortunes_end_buff", {duration=dur})
    else
        --[[local modifier_count = caster:GetModifierCount()
        if modifier_count>0 then
            for i = 0, modifier_count do
                local modifier_name = caster:GetModifierNameByIndex(i)
                local modifier= caster:FindModifierByName(modifier_name)
                if modifier then
                    if modifier:IsDebuff() and modifier:GetStackCount()<=0 and not modifier:IsAura() then
                        target:AddNewModifier(caster, modifier:GetAbility(), modifier_name, {duration=modifier:GetDuration()})
                    end
                end
            end
        end]]
        target:Purge(true, false, false, false, false)
        target:EmitSound("Hero_Oracle.FortunesEnd.Target")
            local heros = FindUnitsInRadius(
                caster:GetTeamNumber(),
                target:GetAbsOrigin(),
                nil,
                rd,
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_NONE, 
                FIND_CLOSEST,
                false)
                if #heros> 0 then
                    for _, hero in pairs(heros) do
                        if not Is_Chinese_TG(hero,caster) and not hero:IsMagicImmune() then
                            hero:Purge(true, false, false, false, false)
                            local damageTable = {
                                victim = hero,
                                attacker = caster,
                                damage = dam,
                                damage_type =DAMAGE_TYPE_MAGICAL,
                                ability = self,
                                }
                            ApplyDamage(damageTable)
                            TG_Remove_Modifier(hero,"modifier_purifying_flames_buff",0)
                            if caster:HasScepter() then 
                                hero:AddNewModifier(caster, self, "modifier_fortunes_end_debuff2", {duration=dur})
                            end 
                                hero:AddNewModifier(caster, self, "modifier_fortunes_end_debuff", {duration=dur})
                        end
                end
        end
    end 
    return true
end

modifier_fortunes_end_debuff=class({})

function modifier_fortunes_end_debuff:IsDebuff()			
    return true 
end

function modifier_fortunes_end_debuff:IsHidden() 			
    return false 
end

function modifier_fortunes_end_debuff:IsPurgable() 		
    return true
end

function modifier_fortunes_end_debuff:IsPurgeException() 
    return true 
end

function modifier_fortunes_end_debuff:OnCreated() 
    if not IsServer() then
        return 
    end
    self:GetParent():Purge(true, false, false, false, false)
    local p= ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_aoe.vpcf", PATTACH_ABSORIGIN,self:GetParent())
    ParticleManager:SetParticleControl(p,0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(p,2, Vector(300,0,0))
    ParticleManager:SetParticleControl(p,3, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p)
    local p2= ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
    ParticleManager:SetParticleControl(p2,0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(p2,3, self:GetParent():GetAbsOrigin())
    self:AddParticle( p2, false, false, 20, false, false )
    local p3= ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_dmg.vpcf", PATTACH_ABSORIGIN,self:GetParent())
    ParticleManager:SetParticleControl(p3,0, self:GetCaster():GetAbsOrigin()+self:GetCaster():GetUpVector()*150)
    ParticleManager:SetParticleControl(p3,1, self:GetCaster():GetAbsOrigin()+self:GetCaster():GetUpVector()*150)
    ParticleManager:SetParticleControl(p3,3, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p3)
end

function modifier_fortunes_end_debuff:OnRefresh() 
    self:OnCreated() 
end


function modifier_fortunes_end_debuff:CheckState()
    return
    {
        [MODIFIER_STATE_TETHERED] = true,
        [MODIFIER_STATE_ROOTED] = true,
    }
 
end


function modifier_fortunes_end_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_fortunes_end_debuff:GetModifierStatusResistanceStacking() 
    return -50
end

modifier_fortunes_end_debuff2=class({})

function modifier_fortunes_end_debuff2:IsDebuff()			
    return true 
end

function modifier_fortunes_end_debuff2:IsHidden() 			
    return false 
end

function modifier_fortunes_end_debuff2:IsPurgable() 		
    return true
end

function modifier_fortunes_end_debuff2:IsPurgeException() 
    return true 
end

function modifier_fortunes_end_debuff2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_DISABLE_TURNING,
	}
end

function modifier_fortunes_end_debuff2:GetModifierDisableTurning() 
    return 1
end


modifier_fortunes_end_buff=class({})

function modifier_fortunes_end_buff:IsHidden() 			
    return false 
end

function modifier_fortunes_end_buff:IsPurgable() 		
    return true
end

function modifier_fortunes_end_buff:IsPurgeException() 
    return true 
end


function modifier_fortunes_end_buff:OnCreated() 
    if not IsServer() then
        return 
    end
    
    local p= ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_aoe.vpcf", PATTACH_ABSORIGIN,self:GetParent())
    ParticleManager:SetParticleControl(p,0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(p,2, Vector(300,0,0))
    ParticleManager:SetParticleControl(p,3, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p)
    local p2= ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
    ParticleManager:SetParticleControl(p2,0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(p2,3, self:GetParent():GetAbsOrigin())
    self:AddParticle( p2, false, false, 20, false, false )
    local p3= ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_dmg.vpcf", PATTACH_ABSORIGIN,self:GetParent())
    ParticleManager:SetParticleControl(p3,0, self:GetCaster():GetAbsOrigin()+self:GetCaster():GetUpVector()*150)
    ParticleManager:SetParticleControl(p3,1, self:GetCaster():GetAbsOrigin()+self:GetCaster():GetUpVector()*150)
    ParticleManager:SetParticleControl(p3,3, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p3)
end

function modifier_fortunes_end_buff:OnRefresh() 
   self:OnCreated() 
end

