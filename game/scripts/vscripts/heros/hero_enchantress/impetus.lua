impetus= class({})
LinkLuaModifier("modifier_impetus", "heros/hero_enchantress/impetus.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_impetus_buff", "heros/hero_enchantress/impetus.lua", LUA_MODIFIER_MOTION_NONE)

function impetus:GetIntrinsicModifierName() 
    return "modifier_impetus" 
end

function impetus:OnHeroLevelUp() 
    local caster=self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_impetus_buff", {}) 
end

modifier_impetus = class({})

function modifier_impetus:IsPassive()
	return true
end

function modifier_impetus:IsPurgable() 			
    return false 
end

function modifier_impetus:IsPurgeException() 	
    return false 
end

function modifier_impetus:IsHidden()				
    return true 
end

function modifier_impetus:IsPermanent()				
    return true 
end

function modifier_impetus:OnAttackStart(tg)
	if not IsServer() then
		return 
    end
    
    if tg.attacker == self:GetParent() then
        self:GetParent():EmitSound(" Hero_Enchantress.Impetus")
    end
end
function modifier_impetus:OnAttackLanded(tg)
	if not IsServer() then
		return 
	end

    if tg.attacker == self:GetParent()  then
        if  tg.target:IsOther() or tg.target:IsBuilding() or self:GetParent():IsIllusion() then
            return
        end
        local dis=TG_Distance(tg.target:GetAbsOrigin(),tg.attacker:GetAbsOrigin())
        if dis>=10000 then
            dis=10000
        end
        local dam2=dis*self:GetAbility():GetSpecialValueFor("dam")*0.01
        local damtype=tg.attacker:HasScepter() and DAMAGE_TYPE_PURE or DAMAGE_TYPE_MAGICAL
        local damage= {
            victim = tg.target,
            attacker = tg.attacker,
            damage = dam2,
            damage_type = damtype,
            damage_flags =  self:GetAbility():GetAbilityTargetFlags(), 
            ability = self:GetAbility(),
            }           
             ApplyDamage(damage)
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, tg.target, dam2, nil)   
    end 
end 


function modifier_impetus:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end


function modifier_impetus:GetModifierProjectileName()
    return  "particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf" 
end 


modifier_impetus_buff= class({})

function modifier_impetus_buff:IsHidden()				
    return true 
end

function modifier_impetus_buff:IsPurgable() 			
    return false 
end

function modifier_impetus_buff:IsPurgeException() 	
    return false 
end

function modifier_impetus_buff:RemoveOnDeath()				
    return false 
end

function modifier_impetus_buff:IsPermanent()				
    return true 
end

function modifier_impetus_buff:GetAttributes()				
    return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_impetus_buff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS 
    }
end

function modifier_impetus_buff:OnCreated()
    self.PSP=self:GetAbility():GetSpecialValueFor("psp")
end


function modifier_impetus_buff:GetModifierProjectileSpeedBonus()
    return  self.PSP
end 