aphotic_shield=class({})
LinkLuaModifier("modifier_aphotic_shield", "heros/hero_abaddon/aphotic_shield.lua", LUA_MODIFIER_MOTION_NONE)
function aphotic_shield:IsHiddenWhenStolen() 		
    return false 
end

function aphotic_shield:IsRefreshable() 			
    return true
end

function aphotic_shield:IsStealable() 				
    return true 
end


function aphotic_shield:OnUpgrade() 			
    if self:GetLevel()==1 then    
        AbilityChargeController:AbilityChargeInitialize(self, self:GetCooldown(self:GetLevel()), 1, 1, true, true)
    end
end


function aphotic_shield:OnSpellStart()
    local caster=self:GetCaster()
	local target=self:GetCursorTarget()
    EmitSoundOn("Hero_Abaddon.AphoticShield.Cast",caster)
    target=target==nil and caster or target
    if target:HasModifier("modifier_aphotic_shield") then    
        target:RemoveModifierByName("modifier_aphotic_shield")
    end 
    target:Purge(false, true, false, true, true)
	target:AddNewModifier(caster, self, "modifier_aphotic_shield", {duration = self:GetSpecialValueFor("duration")})
    if caster:TG_HasTalent("special_bonus_abaddon_4") and target~=caster then 
        caster:Purge(false, true, false, true, true)
        caster:AddNewModifier(caster, self, "modifier_aphotic_shield", {duration = self:GetSpecialValueFor("duration")})
    end 
end


modifier_aphotic_shield=class({})

function modifier_aphotic_shield:IsPurgable() 			
    return true 
end

function modifier_aphotic_shield:IsPurgeException() 	
    return true 
end

function modifier_aphotic_shield:IsHidden()				
    return false 
end

function modifier_aphotic_shield:OnCreated()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    EmitSoundOn("Hero_Abaddon.AphoticShield.Loop", self.parent)
	if IsServer() then
        local fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(fx2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(fx2, 1,Vector(100,0,0))
		self:AddParticle(fx2, false, false, 1, false, false)
	end
end

function modifier_aphotic_shield:OnDestroy()
    EmitSoundOn("Hero_Abaddon.AphoticShield.Destroy",self.parent)
	StopSoundOn("Hero_Abaddon.AphoticShield.Loop",self.parent)
	if IsServer() then
        local damage=self.ability:GetSpecialValueFor("damage_absorb")+self.caster:TG_GetTalentValue("special_bonus_abaddon_5")
        local hp=self.ability:GetSpecialValueFor("hp")*0.01
        local heros = FindUnitsInRadius(
            self.parent:GetTeamNumber(),
            self.parent:GetAbsOrigin(),
            nil,
            self.ability:GetSpecialValueFor("radius"), 
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER,false)
            if #heros>0 then
                for _, hero in pairs(heros) do
                            local damageTable = {
                                victim = hero,
                                attacker = self.caster,
                                damage = damage+self.caster:GetMaxHealth()*hp,
                                damage_type =DAMAGE_TYPE_MAGICAL,
                                ability = self.ability,
                                }
                            ApplyDamage(damageTable)
                            if self.caster:Has_Aghanims_Shard() then 
                                self.caster:PerformAttack(hero, true, true, true, false, true, true, true)
                            end 
                end
            end
	end
end

function modifier_aphotic_shield:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_AVOID_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
	}

end

function modifier_aphotic_shield:GetModifierAvoidDamage(tg)
    if self.ability and tg.target==self.parent then
        self:SetStackCount(self:GetStackCount()+tg.damage)
        if self:GetStackCount()>self.ability:GetSpecialValueFor("damage_absorb")+self.caster:TG_GetTalentValue("special_bonus_abaddon_5") then    
            self:Destroy()
        end 
        return 1
    else  
        return 0
    end
end

function modifier_aphotic_shield:OnAttackLanded(tg)
    if not IsServer() then
        return
	end  
	
    if tg.target == self.parent and not tg.attacker:IsBuilding() and not tg.attacker:IsMagicImmune() then
        local ab=self.caster:FindAbilityByName("frostmourne") 
        if ab and ab:GetLevel()>0 and not tg.attacker:HasModifier("modifier_frostmourne_debuff") then
            tg.attacker:AddNewModifier(self.caster, ab, "modifier_frostmourne_stack", {duration=ab:GetSpecialValueFor("slow_duration")})
        end
	end 
end  