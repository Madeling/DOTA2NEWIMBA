borrowed_time=class({})
LinkLuaModifier("modifier_borrowed_time", "heros/hero_abaddon/borrowed_time.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_borrowed_time_pa", "heros/hero_abaddon/borrowed_time.lua", LUA_MODIFIER_MOTION_NONE)
function borrowed_time:IsHiddenWhenStolen() 		
    return false 
end

function borrowed_time:IsRefreshable() 			
    return true 
end

function borrowed_time:IsStealable() 				
    return true 
end

function borrowed_time:GetIntrinsicModifierName() 
    return "modifier_borrowed_time_pa" 
end

function borrowed_time:GetBehavior()
    if self:GetCaster():HasScepter() then
        return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET+DOTA_ABILITY_BEHAVIOR_IMMEDIATE+DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
    else 
        return DOTA_ABILITY_BEHAVIOR_NO_TARGET+DOTA_ABILITY_BEHAVIOR_IMMEDIATE+DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
    end
end

function borrowed_time:OnSpellStart()
    local caster=self:GetCaster()
	local target=self:GetCursorTarget()
    local dur=caster:HasScepter() and self:GetSpecialValueFor("duration_scepter") or self:GetSpecialValueFor("duration")
    target=target==nil and caster or target
    EmitSoundOn("Hero_Abaddon.BorrowedTime",caster)
	target:Purge(false, true, false, true, true)
    target:AddNewModifier(caster, self, "modifier_borrowed_time",{duration=dur})
    if caster:HasScepter() and target~=caster then
        caster:Purge(false, true, false, true, true)
        caster:AddNewModifier(caster, self, "modifier_borrowed_time",{duration=dur})
    end
end

modifier_borrowed_time=class({})

function modifier_borrowed_time:IsPurgable() 			
    return false 
end

function modifier_borrowed_time:IsPurgeException() 	
    return false 
end

function modifier_borrowed_time:IsHidden()				
    return false 
end

function modifier_borrowed_time:GetEffectAttachType()				
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_borrowed_time:GetEffectName()				
    return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf" 
end

function modifier_borrowed_time:GetStatusEffectName()				
    return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" 
end

function modifier_borrowed_time:StatusEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA 
end

function modifier_borrowed_time:OnCreated()
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
end

function modifier_borrowed_time:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end

function modifier_borrowed_time:OnTakeDamage(tg)
    if not IsServer() then
        return
	end  
	
    if tg.attacker == self.parent and not self.parent:IsIllusion() then
        self.parent:Heal(tg.damage, self.ability)
	end 
end  

function modifier_borrowed_time:GetModifierAvoidDamage(tg)
    if self.ability and tg.target==self.parent and not self.parent:IsIllusion() then
        self.parent:Heal(tg.damage, self.ability)
        return 1
    else  
        return 0
    end
end

modifier_borrowed_time_pa=class({})

function modifier_borrowed_time_pa:IsPurgable() 			
    return false 
end

function modifier_borrowed_time_pa:IsPurgeException() 	
    return false 
end

function modifier_borrowed_time_pa:IsHidden()				
    return true 
end

function modifier_borrowed_time_pa:AllowIllusionDuplicate()				
    return false 
end

function modifier_borrowed_time_pa:OnCreated()
    self.caster=self:GetCaster()
    self.parent=self:GetParent()
    self.ability=self:GetAbility()
    self.hp=self.ability:GetSpecialValueFor("hp_threshold")
end

function modifier_borrowed_time_pa:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_borrowed_time_pa:OnTakeDamage(tg)
    if not IsServer() then
        return
	end  
	
    if tg.unit == self.parent and not self.parent:IsIllusion() and self.parent:GetHealth()<=self.hp and self.ability and self.ability:IsCooldownReady() and self.parent:IsAlive() then
        self.ability:OnSpellStart()
        self.ability:UseResources(false, false, true)
	end 
end  