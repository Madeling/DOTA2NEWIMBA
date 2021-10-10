item_satan = class({})

LinkLuaModifier("modifier_item_satan_pa", "items/item_satan.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_satan_buff", "items/item_satan.lua", LUA_MODIFIER_MOTION_NONE)

function item_satan:OnSpellStart()
	local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    local duration=self:GetSpecialValueFor("dur") 
    caster:EmitSound( "DOTA_Item.MaskOfMadness.Activate" )
    caster:AddNewModifier( caster, self, "modifier_item_satan_buff", {duration=duration})
end

function item_satan:GetIntrinsicModifierName() 
    return "modifier_item_satan_pa" 
end


modifier_item_satan_pa = class({})

function modifier_item_satan_pa:IsHidden() 			
    return true 
end

function modifier_item_satan_pa:IsPurgable() 			
    return false 
end

function modifier_item_satan_pa:IsPurgeException() 	
    return false 
end

function modifier_item_satan_pa:AllowIllusionDuplicate() 	
    return false 
end

function modifier_item_satan_pa:OnCreated() 
    self.blood=self:GetAbility():GetSpecialValueFor("blood")
end

function modifier_item_satan_pa:OnRemoved() 
    self.blood=nil
    if not IsServer() then
        return
    end
    TG_Remove_Modifier(self:GetParent(),"modifier_item_satan_buff",0)
end


function modifier_item_satan_pa:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    } 
end

function modifier_item_satan_pa:OnAttackLanded(tg)
    if not IsServer() then
        return
    end  
    if tg.attacker == self:GetParent() and not tg.target:IsBuilding() then 
        local hp=tg.damage*self.blood*0.01
        self:GetParent():Heal(hp, self:GetParent())
        SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(),hp, self:GetParent())
    end
end   


function modifier_item_satan_pa:GetModifierAttackSpeedBonus_Constant() 
    return self:GetAbility():GetSpecialValueFor("attsp") 
end

function modifier_item_satan_pa:GetModifierPreAttack_BonusDamage() 
    return self:GetAbility():GetSpecialValueFor("att") 
end




modifier_item_satan_buff = class({})


function modifier_item_satan_buff:IsHidden() 			
    return false 
end

function modifier_item_satan_buff:IsPurgable() 			
    return false 
end

function modifier_item_satan_buff:IsPurgeException() 	
    return false 
end

function modifier_item_satan_buff:GetTexture()			
    return "item_satan"
end

function modifier_item_satan_buff:GetEffectName() 
    return "particles/items2_fx/mask_of_madness.vpcf" 
end

function modifier_item_satan_buff:GetEffectAttachType() 
    return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_item_satan_buff:OnCreated() 
    local pfx = ParticleManager:CreateParticle("particles/items/satan/hero_levelup_ti10_godray_change.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle(pfx, false, false, 100, false, false)
    
    local ab=self:GetAbility()
    self.attsp2=ab:GetSpecialValueFor("attsp2")
    self.sp=ab:GetSpecialValueFor("sp")
    self.rs=ab:GetSpecialValueFor("rs")
    self.mr=ab:GetSpecialValueFor("mr")
    self.pa=ab:GetSpecialValueFor("pa")
    self.atti=ab:GetSpecialValueFor("atti")
end

function modifier_item_satan_buff:OnRefresh() 
   self:OnCreated() 
end

function modifier_item_satan_buff:OnDestroy() 
    self.attsp2=nil
    self.sp=nil
    self.rs=nil
    self.mr=nil
    self.pa=nil
    self.atti=nil
end


function modifier_item_satan_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MODEL_SCALE
    } 
end

function modifier_item_satan_buff:GetModifierAttackSpeedBonus_Constant() 
    return self.attsp2 
end

function modifier_item_satan_buff:GetModifierMoveSpeedBonus_Constant() 
    return self.sp
end

function modifier_item_satan_buff:GetModifierStatusResistanceStacking() 
    return self.rs
end

function modifier_item_satan_buff:GetModifierBaseAttackTimeConstant() 
    if self:GetParent():IsRangedAttacker() then 
        return 1.4
    else 
        return self.atti
    end
end

function modifier_item_satan_buff:GetModifierMagicalResistanceBonus() 
    return (0-self.mr) 
end

function modifier_item_satan_buff:GetModifierPhysicalArmorBonus() 
    return (0-self.pa) 
end

function modifier_item_satan_buff:GetModifierModelChange() 
    return "models/items/warlock/golem/hellsworn_golem/hellsworn_golem.vmdl"
end

function modifier_item_satan_buff:GetModifierModelScale() 
    return 40
end
