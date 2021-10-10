item_manta_v2=class({})
LinkLuaModifier("modifier_item_manta_v2", "items/item_manta_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_illusions_item_manta_v2", "items/item_manta_v2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_manta_v2_invuln", "items/item_manta_v2.lua", LUA_MODIFIER_MOTION_NONE)

function item_manta_v2:IsRefreshable() 			
    return true 
end

function item_manta_v2:OnSpellStart()
    local caster=self:GetCaster()
    local images_do_damage_percent=self:GetSpecialValueFor("images_do_damage_percent")
    local images_take_damage_percent=self:GetSpecialValueFor("images_take_damage_percent")
    local images_count=self:GetSpecialValueFor("images_count")
    local invuln_duration=self:GetSpecialValueFor("invuln_duration")
    local tooltip_illusion_duration=self:GetSpecialValueFor("tooltip_illusion_duration")
    caster:AddNewModifier(caster, self, "modifier_item_manta_v2_invuln", {duration=invuln_duration})
    caster:Purge(false, true, false, true, true)
    local modifier=
    {
        outgoing_damage=images_do_damage_percent,
        incoming_damage=images_take_damage_percent,
        bounty_base=0,
        bounty_growth=0,
        outgoing_damage_structure=images_do_damage_percent,
        outgoing_damage_roshan=images_do_damage_percent,
    }
    caster.item_manta_v2illusions=CreateIllusions(caster, caster, modifier, images_count, 77, true, true)
    for _, target in pairs(caster.item_manta_v2illusions) do
        target:AddNewModifier(caster, self, "modifier_kill", {duration=tooltip_illusion_duration})
        target:AddNewModifier(caster, self, "modifier_illusions_item_manta_v2", {duration=tooltip_illusion_duration})
        local mod =caster:FindModifierByName("modifier_item_attsp_book")
        if mod then   
            target:AddNewModifier(caster, nil, "modifier_item_attsp_book", {num=mod:GetStackCount()})
        end 
    end
end

function item_manta_v2:GetIntrinsicModifierName() 
    return "modifier_item_manta_v2" 
end


modifier_item_manta_v2=class({})

function modifier_item_manta_v2:IsPassive()			
    return true 
end

function modifier_item_manta_v2:IsHidden() 		
    return true 
end

function modifier_item_manta_v2:IsPurgable() 		
    return false 
end

function modifier_item_manta_v2:IsPurgeException() 
    return false 
end

function modifier_item_manta_v2:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
    } 
end

function modifier_item_manta_v2:OnCreated() 
    self.parent=self:GetParent()
    if self:GetAbility() == nil then
		return
    end
    self.ability=self:GetAbility()
    self.bonus_strength=self.ability:GetSpecialValueFor("bonus_strength")
    self.bonus_agility=self.ability:GetSpecialValueFor("bonus_agility")
    self.bonus_intellect=self.ability:GetSpecialValueFor("bonus_intellect")
    self.bonus_attack_speed=self.ability:GetSpecialValueFor("bonus_attack_speed")
    self.bonus_movement_speed=self.ability:GetSpecialValueFor("bonus_movement_speed")
end

function modifier_item_manta_v2:GetModifierBonusStats_Strength() 
    return self.bonus_strength
end

function modifier_item_manta_v2:GetModifierBonusStats_Agility() 
    return self.bonus_agility 
end

function modifier_item_manta_v2:GetModifierBonusStats_Intellect() 
    return self.bonus_intellect
 end

 function modifier_item_manta_v2:GetModifierAttackSpeedBonus_Constant() 
    return self.bonus_attack_speed
 end

 function modifier_item_manta_v2:GetModifierMoveSpeedBonus_Percentage_Unique() 
    return  self.bonus_movement_speed
 end

modifier_illusions_item_manta_v2=class({})

function modifier_illusions_item_manta_v2:IsHidden() 		
    return true 
end

function modifier_illusions_item_manta_v2:IsPurgable() 		
    return false 
end

function modifier_illusions_item_manta_v2:IsPurgeException() 
    return false 
end

function modifier_illusions_item_manta_v2:IsIllusion() 
    return true 
end

function modifier_illusions_item_manta_v2:DeclareFunctions() 
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_IS_ILLUSION 
    } 
end

function modifier_illusions_item_manta_v2:GetIsIllusion() 
    return 1
end

function modifier_illusions_item_manta_v2:OnCreated() 
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
end


function modifier_illusions_item_manta_v2:OnAttackLanded(tg) 
    if not IsServer() then
		return
    end
    if tg.attacker ~= self.parent or not tg.target:IsAlive() then
		return
    end
    local ppos=self.parent:GetAbsOrigin()
    local tpos=tg.target:GetAbsOrigin()
    if self.parent:IsRangedAttacker() then 
        if PseudoRandom:RollPseudoRandom( self.ability, 100 ) and TG_Distance(ppos,tpos) <= 200 then 
            FindClearSpaceForUnit(self.parent, ppos+self.parent:GetForwardVector()*-300, true)
        end 
    else 
        if PseudoRandom:RollPseudoRandom( self.ability, 100 ) then 
            FindClearSpaceForUnit(self.parent, tpos, true)
        end 
    end 
end

modifier_item_manta_v2_invuln=class({})

function modifier_item_manta_v2_invuln:IsHidden() 		
    return true 
end

function modifier_item_manta_v2_invuln:IsPurgable() 		
    return false 
end

function modifier_item_manta_v2_invuln:IsPurgeException() 
    return false 
end

function modifier_item_manta_v2_invuln:GetEffectAttachType() 	
    return PATTACH_ABSORIGIN_FOLLOW 
end


function modifier_item_manta_v2_invuln:CheckState()
	return
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end

function modifier_item_manta_v2_invuln:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_DODGE_PROJECTILE 
    } 
end

function modifier_item_manta_v2_invuln:GetModifierDodgeProjectile()
    return 1
end
