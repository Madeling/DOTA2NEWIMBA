item_monkey_king_bar_v2 =class({})

LinkLuaModifier("modifier_item_monkey_king_bar_v2_pa", "items/item_monkey_king_bar_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_monkey_king_bar_v2_buff", "items/item_monkey_king_bar_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_monkey_king_bar_v2_debuff", "items/item_monkey_king_bar_v2.lua", LUA_MODIFIER_MOTION_NONE)

function item_monkey_king_bar_v2:GetIntrinsicModifierName() 
    return "modifier_item_monkey_king_bar_v2_pa" 
end

modifier_item_monkey_king_bar_v2_pa =class({})

function modifier_item_monkey_king_bar_v2_pa:IsHidden() 			
    return true 
end

function modifier_item_monkey_king_bar_v2_pa:IsPurgable() 			
    return false 
end

function modifier_item_monkey_king_bar_v2_pa:IsPurgeException() 	
    return false 
end

function modifier_item_monkey_king_bar_v2_pa:AllowIllusionDuplicate() 	
    return false 
end

function modifier_item_monkey_king_bar_v2_pa:DeclareFunctions() 
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_FAIL,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    } 
end




function modifier_item_monkey_king_bar_v2_pa:OnCreated() 
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    self.miss=false
    self.num=0
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.attsp=self.ability:GetSpecialValueFor("attsp") 
    self.att=self.ability:GetSpecialValueFor("att") 
    self.ch=self.ability:GetSpecialValueFor("ch") 
    self.dam=self.ability:GetSpecialValueFor("dam") 
    self.sp=self.ability:GetSpecialValueFor("sp") 
    self.dur=self.ability:GetSpecialValueFor("dur") 
    self.rg=self.ability:GetSpecialValueFor("rg") 
    self.wh=self.ability:GetSpecialValueFor("wh")
    self.stack=self.ability:GetSpecialValueFor("stack")+1
end

function modifier_item_monkey_king_bar_v2_pa:OnAttackStart(tg)
    if not IsServer() then
        return
    end  
    if tg.attacker == self.parent then 
        if RollPseudoRandomPercentage(self.ch,0,self.parent) and not tg.target:HasModifier("modifier_item_butterfly_v2_buff")  then 
            self.miss=true
            self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_monkey_king_bar_v2_buff", {})   
        end
    end
end   


function modifier_item_monkey_king_bar_v2_pa:OnAttackFail(tg)
    if not IsServer() then
        return
    end  
    if tg.attacker == self.parent then 
        if self.parent:HasModifier("modifier_item_monkey_king_bar_v2_buff") then 
            self.parent:RemoveModifierByName("modifier_item_monkey_king_bar_v2_buff")
        end 
    end
end   


function modifier_item_monkey_king_bar_v2_pa:OnAttackLanded(tg)
    if not IsServer()  then
        return
    end  


    if tg.attacker == self.parent then
        if self.parent:HasModifier("modifier_item_monkey_king_bar_v2_buff") then 
            self.parent:RemoveModifierByName("modifier_item_monkey_king_bar_v2_buff")
        end 
        if tg.target:HasModifier("modifier_item_butterfly_v2_buff") then
            return
        end
    end  
    if tg.attacker == self.parent and not self.parent:IsIllusion() and not tg.target:IsBuilding() then    
            self.num=self.num+1
            if self.num>=self.stack  then
                self.num=0
                if not self.parent:IsRangedAttacker() then 
                local tpos=tg.target:GetAbsOrigin()
                local cpos=self.parent:GetAbsOrigin()
                local dir=self.parent:GetForwardVector()
                local end_pos=tpos+dir*self.rg
                local trail = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
                ParticleManager:SetParticleControl(trail, 0,cpos)
                ParticleManager:SetParticleControl(trail, 1,end_pos)
                ParticleManager:ReleaseParticleIndex(trail) 
                local heros = FindUnitsInLine(
                    self.parent:GetTeam(),
                    tpos,
                    end_pos, 
                    self.parent, 
                    self.wh, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 
                    DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
                    if #heros>0 then
                        for _,target in pairs(heros) do
                            self.parent:PerformAttack(target,false, false, true, false, true, false, false)
                        end
                    end
                end 
                    if tg.target:HasModifier("modifier_item_monkey_king_bar_v2_debuff") then 
                        tg.target:RemoveModifierByName("modifier_item_monkey_king_bar_v2_debuff")
                    end 

            else 
                if not tg.target:IsMagicImmune() then 
                TG_Modifier_Num_ADD2({
                    target=tg.target,
                    caster=self.parent,
                    ability=self.ability,
                    modifier="modifier_item_monkey_king_bar_v2_debuff",
                    init=self.sp,
                    stack=self.sp,
                    duration=TG_StatusResistance_GET( tg.target,self.dur)
                })       
                end
            end
    

            if  self.miss then
                self.miss=false 
                tg.target:EmitSound("DOTA_Item.MKB.Minibash")
                local damageTable = {
                    victim = tg.target,
                    attacker = self.parent,
                    damage = self.dam,
                    damage_type =DAMAGE_TYPE_PURE,
                    ability = self.ability,
                    }
                ApplyDamage(damageTable)
                SendOverheadEventMessage(tg.target, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, tg.target, self.dam, tg.target)
            end
    end
end   


function modifier_item_monkey_king_bar_v2_pa:GetModifierAttackSpeedBonus_Constant() 
    return self.attsp 
end

function modifier_item_monkey_king_bar_v2_pa:GetModifierPreAttack_BonusDamage() 
    return self.att 
end

modifier_item_monkey_king_bar_v2_buff =class({})

function modifier_item_monkey_king_bar_v2_buff:IsHidden() 			
    return true 
end

function modifier_item_monkey_king_bar_v2_buff:IsPurgable() 			
    return false 
end

function modifier_item_monkey_king_bar_v2_buff:IsPurgeException() 	
    return false 
end

function modifier_item_monkey_king_bar_v2_buff:RemoveOnDeath() 	
    return true 
end

function modifier_item_monkey_king_bar_v2_buff:CheckState()
    return {[MODIFIER_STATE_CANNOT_MISS] = true} 
end


modifier_item_monkey_king_bar_v2_debuff =class({})

function modifier_item_monkey_king_bar_v2_debuff:IsDebuff() 			
    return true 
end

function modifier_item_monkey_king_bar_v2_debuff:IsHidden() 			
    return false 
end

function modifier_item_monkey_king_bar_v2_debuff:IsPurgable() 			
    return false 
end

function modifier_item_monkey_king_bar_v2_debuff:IsPurgeException() 	
    return false 
end

function modifier_item_monkey_king_bar_v2_debuff:OnCreated(tg) 
    if IsServer() then 
        self:SetStackCount(tg.num)
    end 
end

function modifier_item_monkey_king_bar_v2_debuff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    } 
end


function modifier_item_monkey_king_bar_v2_debuff:GetModifierMoveSpeedBonus_Percentage() 	
    return 0-self:GetStackCount()
end
