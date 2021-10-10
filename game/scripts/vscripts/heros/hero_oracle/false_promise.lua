false_promise=class({})
LinkLuaModifier("modifier_false_promise_buff", "heros/hero_oracle/false_promise.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_false_promise_buff2", "heros/hero_oracle/false_promise.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_false_promise_buff3", "heros/hero_oracle/false_promise.lua", LUA_MODIFIER_MOTION_NONE)

function false_promise:IsHiddenWhenStolen() 
    return false 
end

function false_promise:IsStealable() 
    return true 
end

function false_promise:IsRefreshable() 			
    return true 
end


function false_promise:OnSpellStart() 
    local caster = self:GetCaster()
    local cur_tar = self:GetCursorTarget()
    local dur =self:GetSpecialValueFor("dur")
    local ab=caster:FindAbilityByName("fates_edict")
    caster:EmitSound("Hero_Oracle.FalsePromise.Cast")
    cur_tar:EmitSound("Hero_Oracle.FalsePromise.Target")
    cur_tar:EmitSound("Hero_Oracle.FalsePromise.FP")
    if caster:TG_HasTalent("special_bonus_oracle_7") and cur_tar~=caster then   
        caster:Purge(false, true, false, true, true)
        caster:AddNewModifier(caster, self, "modifier_false_promise_buff2", {duration=dur})
        caster:AddNewModifier(caster, self, "modifier_false_promise_buff", {duration=dur})
        if caster:Has_Aghanims_Shard() then 
            caster:AddNewModifier(caster, self, "modifier_false_promise_buff3", {duration=dur})
        end 
    end 
    cur_tar:Purge(false, true, false, true, true)
    cur_tar:AddNewModifier(caster, self, "modifier_false_promise_buff2", {duration=dur})
    cur_tar:AddNewModifier(caster, self, "modifier_false_promise_buff", {duration=dur})
    if caster:Has_Aghanims_Shard() then 
        cur_tar:AddNewModifier(caster, self, "modifier_false_promise_buff3", {duration=dur})
    end 
    if ab and ab:GetLevel()>0 then   
        ab:OnSpellStart(cur_tar)
    end 
end

modifier_false_promise_buff2= class({})


function modifier_false_promise_buff2:IsHidden() 			
    return true 
end

function modifier_false_promise_buff2:IsPurgable() 		
    return false
end

function modifier_false_promise_buff2:IsPurgeException() 
    return false 
end

function modifier_false_promise_buff2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_DISABLE_HEALING,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, 
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, 
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE, 
	}
end

function modifier_false_promise_buff2:GetDisableHealing() 
    return 1 
end

function modifier_false_promise_buff2:GetAbsoluteNoDamageMagical() 
    return 1
end

function modifier_false_promise_buff2:GetAbsoluteNoDamagePhysical() 
    return 1 
end

function modifier_false_promise_buff2:GetAbsoluteNoDamagePure() 
    return 1 
end


modifier_false_promise_buff= class({})


function modifier_false_promise_buff:IsHidden() 			
    return false 
end

function modifier_false_promise_buff:IsPurgable() 		
    return false
end

function modifier_false_promise_buff:IsPurgeException() 
    return false 
end

function modifier_false_promise_buff:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_HEAL_RECEIVED 
	}
end


function modifier_false_promise_buff:OnCreated()
    self.HEAL=0
    self.DAM=0
    self.ATT=self:GetParent()
    if not IsServer() then
        return 
    end
    local pos=self:GetParent():GetAbsOrigin()
    local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
    ParticleManager:SetParticleControl( fx, 0, pos )
    ParticleManager:SetParticleControl( fx, 2, pos )
    ParticleManager:SetParticleControl( fx, 4,pos )
    ParticleManager:SetParticleControl(fx, 60, Vector(math.random(0,255),math.random(0,255),math.random(0,255)))
    ParticleManager:SetParticleControl(fx, 61, Vector(1,1,1))
    ParticleManager:ReleaseParticleIndex(fx)
    local fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
    ParticleManager:SetParticleControl( fx2, 0, pos )
    ParticleManager:SetParticleControl( fx2, 1, pos )
    ParticleManager:SetParticleControl( fx2, 2, Vector(100,100,100) )
    ParticleManager:SetParticleControl(fx2, 4, pos)
    ParticleManager:SetParticleControl( fx2, 5, pos )
    ParticleManager:SetParticleControl(fx2, 60, Vector(math.random(0,255),math.random(0,255),math.random(0,255)))
    ParticleManager:SetParticleControl(fx2, 61, Vector(1,1,1))
    self:AddParticle(fx2, false, false, 20, false, false)   
end

function modifier_false_promise_buff:OnRefresh()
    if not IsServer() then
        return 
    end
    local pos=self:GetParent():GetAbsOrigin()
    local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
    ParticleManager:SetParticleControl( fx, 0, pos )
    ParticleManager:SetParticleControl( fx, 2, pos )
    ParticleManager:SetParticleControl( fx, 4,pos )
    ParticleManager:SetParticleControl(fx, 60, Vector(math.random(0,255),math.random(0,255),math.random(0,255)))
    ParticleManager:SetParticleControl(fx, 61, Vector(1,1,1))
    ParticleManager:ReleaseParticleIndex(fx)
    local fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
    ParticleManager:SetParticleControl( fx2, 0, pos )
    ParticleManager:SetParticleControl( fx2, 1, pos )
    ParticleManager:SetParticleControl( fx2, 2, Vector(100,100,100) )
    ParticleManager:SetParticleControl(fx2, 4, pos)
    ParticleManager:SetParticleControl( fx2, 5, pos )
    ParticleManager:SetParticleControl(fx2, 60, Vector(math.random(0,255),math.random(0,255),math.random(0,255)))
    ParticleManager:SetParticleControl(fx2, 61, Vector(1,1,1))
    self:AddParticle(fx2, false, false, 20, false, false)   
end

function modifier_false_promise_buff:OnDestroy() 
    if  IsServer() then
        self:GetParent():RemoveModifierByName("modifier_false_promise_buff2")
        local currhp=self:GetParent():GetHealth()+ self.HEAL
        local remhp=currhp-self.DAM
        if remhp <=0 then
            self:GetParent():EmitSound("Hero_Oracle.FalsePromise.Damaged")
            local die = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
            ParticleManager:ReleaseParticleIndex(die)
            if self:GetParent()~= self:GetCaster() then
                if not self:GetCaster():TG_HasTalent("special_bonus_oracle_5") then
                    local dam2=self.DAM*0.2
                    local damageTable1 = {
                        victim = self:GetCaster(),
                        attacker = self.ATT,
                        damage = dam2,
                        damage_type =DAMAGE_TYPE_PURE, 
                        ability = self:GetAbility(),
                        }
                    ApplyDamage(damageTable1)
                end 
                ---------------------------------- 
                local dam3=self.DAM*0.8
                local damageTable2 = {
                    victim = self:GetParent(),
                    attacker = self.ATT,
                    damage = dam3,
                    damage_type =DAMAGE_TYPE_PURE,
                    ability = self:GetAbility(),
                    }
                ApplyDamage(damageTable2)
            else
                self:GetParent():Kill( self:GetAbility(), self.ATT )
            end
        else  
            self:GetParent():EmitSound("Hero_Oracle.FalsePromise.Healed")
            local heal = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
            ParticleManager:ReleaseParticleIndex(heal) 
            if remhp>self:GetParent():GetMaxHealth() then 
                self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
            else
                self:GetParent():SetHealth(remhp)
            end 
        end
    end
    self.DAM=nil
    self.ATT=nil
    self.HEAL=nil
end

function modifier_false_promise_buff:OnTakeDamage(tg)
    if not IsServer() then
        return 
    end
    if tg.unit == self:GetParent() then
        self.DAM=self.DAM+tg.original_damage
        if (self:GetParent():GetHealth()-tg.original_damage)<=0 then
            self.ATT=tg.attacker
        end
    end
end

function modifier_false_promise_buff:OnHealReceived(tg)
    if not IsServer() then
        return 
    end
    if tg.unit == self:GetParent() and tg.gain>10 then
        self.HEAL=self.HEAL+tg.gain*2
    end
end


modifier_false_promise_buff3= class({})


function modifier_false_promise_buff3:IsHidden() 			
    return true 
end

function modifier_false_promise_buff3:IsPurgable() 		
    return false
end

function modifier_false_promise_buff3:IsPurgeException() 
    return false 
end

function modifier_false_promise_buff3:GetEffectName() 
    return "particles/generic_hero_status/status_invisibility_start.vpcf" 
end

function modifier_false_promise_buff3:GetEffectAttachType() 
    return PATTACH_ABSORIGIN 
end

function modifier_false_promise_buff3:CheckState()
    return 
    {
        [MODIFIER_STATE_INVISIBLE] = true, 
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end

function modifier_false_promise_buff3:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK, 
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, 
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
        MODIFIER_PROPERTY_DISABLE_AUTOATTACK, 
        MODIFIER_EVENT_ON_ATTACK_LANDED, 
        MODIFIER_EVENT_ON_ABILITY_EXECUTED, 
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL
    }
end

function modifier_false_promise_buff3:GetDisableAutoAttack() 
    return true 
end

function modifier_false_promise_buff3:OnAttack(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and self:GetParent():IsRangedAttacker() then
		self:Destroy()
	end
end

function modifier_false_promise_buff3:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker == self:GetParent() and not self:GetParent():IsRangedAttacker() then
		self:Destroy()
	end
end

function modifier_false_promise_buff3:OnAbilityExecuted(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end
	self:Destroy()
end

function modifier_false_promise_buff3:GetModifierInvisibilityLevel() 
    return 1 
end