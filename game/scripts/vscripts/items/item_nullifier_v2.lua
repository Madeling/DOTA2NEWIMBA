item_nullifier_v2=class({})
LinkLuaModifier("modifier_item_nullifier_v2_pa", "items/item_nullifier_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_nullifier_v2_debuff", "items/item_nullifier_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_nullifier_v2_buff", "items/item_nullifier_v2.lua", LUA_MODIFIER_MOTION_NONE)

function item_nullifier_v2:GetIntrinsicModifierName() 
    return "modifier_item_nullifier_v2_pa" 
end


function item_nullifier_v2:OnSpellStart()
    local target=self:GetCursorTarget()
    local caster=self:GetCaster() 
    caster:EmitSound("DOTA_Item.Nullifier.Cast")
    local P = 
    {
        Target = target,
        Source = caster,
        Ability = self,	
        EffectName = "particles/items4_fx/nullifier_proj.vpcf",
        iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
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

function item_nullifier_v2:OnProjectileHit(target, location)
    local caster = self:GetCaster()
	if  target==nil then
		return
    end
    if caster:GetTeamNumber()==target:GetTeamNumber() then
        target:EmitSound("DOTA_Item.Nullifier.Target")
        if target:HasModifier("modifier_item_nullifier_v2_debuff") then   
            target:RemoveModifierByName("modifier_item_nullifier_v2_debuff")
        end 
        target:AddNewModifier(caster,self,"modifier_item_nullifier_v2_buff",{duration=self:GetSpecialValueFor("mute_duration")})
    else 
        if  target:TG_TriggerSpellAbsorb(self) or target:IsMagicImmune() then
            return
        end 
        target:EmitSound("DOTA_Item.Nullifier.Target")
        target:Purge(true, false, false, false, false)
        target:AddNewModifier_RS(caster,self,"modifier_item_nullifier_v2_debuff",{duration=self:GetSpecialValueFor("mute_duration")})
    end
    return true
end

modifier_item_nullifier_v2_pa=class({})


function modifier_item_nullifier_v2_pa:IsDebuff() 			
    return false 
end

function modifier_item_nullifier_v2_pa:IsHidden() 			
    return true 
end

function modifier_item_nullifier_v2_pa:IsPurgable() 			
    return false 
end

function modifier_item_nullifier_v2_pa:IsPurgeException() 	
    return false 
end

function modifier_item_nullifier_v2_pa:OnCreated() 
    if self:GetAbility() == nil then
		return
	end
    self.bonus_damage=self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_armor=self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.bonus_regen=self:GetAbility():GetSpecialValueFor("bonus_regen")
    self.hp=self:GetAbility():GetSpecialValueFor("hp")
    self.hp_r=self:GetAbility():GetSpecialValueFor("hp_r")
end

function modifier_item_nullifier_v2_pa:OnRefresh() 
    self:OnCreated() 
end

function modifier_item_nullifier_v2_pa:DeclareFunctions() 
    return
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
   } 
end

function modifier_item_nullifier_v2_pa:GetModifierPreAttack_BonusDamage()
    return  self.bonus_damage
 end

 function modifier_item_nullifier_v2_pa:GetModifierPhysicalArmorBonus()
    return   self.bonus_armor
 end

 function modifier_item_nullifier_v2_pa:GetModifierConstantManaRegen()
    return   self.bonus_regen
 end

 function modifier_item_nullifier_v2_pa:GetModifierHealthBonus()
    return  self.hp
 end

 function modifier_item_nullifier_v2_pa:GetModifierConstantHealthRegen()
    return   self.hp_r
 end

 modifier_item_nullifier_v2_buff=class({})
 
 function modifier_item_nullifier_v2_buff:IsHidden() 			
     return false 
 end
 
 function modifier_item_nullifier_v2_buff:IsPurgable() 			
     return false 
 end
 
 function modifier_item_nullifier_v2_buff:IsPurgeException() 	
     return false 
 end

 function modifier_item_nullifier_v2_buff:OnCreated() 
    self.heal=self:GetAbility():GetSpecialValueFor("heal")
    if not IsServer() then
        return
    end
    self:GetParent():EmitSound("DOTA_Item.Nullifier.Slow") 
    self:StartIntervalThink(1)
end


function modifier_item_nullifier_v2_buff:OnIntervalThink() 
    if not IsServer() then
        return
    end
    self:GetParent():Heal(self.heal, self:GetAbility())
    SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(),self.heal, nil)
end


modifier_item_nullifier_v2_debuff=class({})

function modifier_item_nullifier_v2_debuff:GetTexture()
    return "item_nullifier_v2" 
end

function modifier_item_nullifier_v2_debuff:IsDebuff() 			
    return true 
end

function modifier_item_nullifier_v2_debuff:IsHidden() 			
    return false 
end

function modifier_item_nullifier_v2_debuff:IsPurgable() 			
    return false 
end

function modifier_item_nullifier_v2_debuff:IsPurgeException() 	
    return false 
end

function modifier_item_nullifier_v2_debuff:GetEffectAttachType() 	
    return PATTACH_OVERHEAD_FOLLOW 
end

function modifier_item_nullifier_v2_debuff:GetEffectName() 	
    return "particles/items4_fx/nullifier_mute.vpcf" 
end

function modifier_item_nullifier_v2_debuff:GetStatusEffectName() 	
    return "particles/status_fx/status_effect_nullifier.vpcf" 
end


function modifier_item_nullifier_v2_debuff:GetPriority()	
    return 20
end

function modifier_item_nullifier_v2_debuff:CheckState()
    return 
    {
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
        [MODIFIER_STATE_EVADE_DISABLED] = true,
    }
end

function modifier_item_nullifier_v2_debuff:DeclareFunctions() 
    return
    {
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_DISABLE_HEALING,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
   } 
end


function modifier_item_nullifier_v2_debuff:OnCreated() 
    self.slow_interval_duration=self:GetAbility():GetSpecialValueFor("slow_interval_duration")
    self.dam=self:GetAbility():GetSpecialValueFor("dam")
    self.slow_pct=self:GetAbility():GetSpecialValueFor("slow_pct")
    self.attsp=self:GetAbility():GetSpecialValueFor("attsp")
    self.dmg=self:GetAbility():GetSpecialValueFor("dmg")*0.01
    if not IsServer() then
        return
    end
    self.damageTable = {
        attacker = self:GetCaster(),
        victim = self:GetParent(),
        damage_type =DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility(),
        }
    self:GetParent():EmitSound("DOTA_Item.Nullifier.Slow") 
    local FX=ParticleManager:CreateParticle("particles/items4_fx/nullifier_mute_debuff.vpcf", PATTACH_ROOTBONE_FOLLOW, self:GetParent())
    self:AddParticle(FX, false, false, -1, false, false)
    self:StartIntervalThink(1)
end


function modifier_item_nullifier_v2_debuff:OnIntervalThink() 
    if not IsServer() then
        return
    end
    self.damageTable.damage = self:GetParent():GetMaxHealth()*self.dmg
    ApplyDamage(self.damageTable)
end

function modifier_item_nullifier_v2_debuff:GetDisableHealing()
    return   1
 end

function modifier_item_nullifier_v2_debuff:GetModifierHealAmplify_PercentageTarget()
    return  -100
end

function modifier_item_nullifier_v2_debuff:GetModifierHPRegenAmplify_Percentage()
    return -100
end

function modifier_item_nullifier_v2_debuff:GetModifierMoveSpeedBonus_Percentage()
    return   self.slow_pct
end

function modifier_item_nullifier_v2_debuff:GetModifierAttackSpeedBonus_Constant()
    return   self.attsp
end


