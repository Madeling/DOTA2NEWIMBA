caustic_finale=class({})

LinkLuaModifier("modifier_caustic_finale", "heros/hero_sand_king/caustic_finale.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_caustic_finale_debuff", "heros/hero_sand_king/caustic_finale.lua", LUA_MODIFIER_MOTION_NONE)

function caustic_finale:GetIntrinsicModifierName() 
    return "modifier_caustic_finale" 
end

modifier_caustic_finale=class({})

function modifier_caustic_finale:IsPassive()
	return true
end

function modifier_caustic_finale:IsPurgable() 			
    return false 
end

function modifier_caustic_finale:IsPurgeException() 	
    return false 
end

function modifier_caustic_finale:IsHidden()				
    return true 
end

function modifier_caustic_finale:AllowIllusionDuplicate()				
    return false 
end

function modifier_caustic_finale:DeclareFunctions()
	return 
        {
            MODIFIER_EVENT_ON_ATTACK_LANDED,
	    }
end

function modifier_caustic_finale:OnCreated()
    self.parent=self:GetParent()
    if not self:GetAbility() then   
        return  
    end 
    self.ability=self:GetAbility()
    self.caustic_finale_damage_base=self.ability:GetSpecialValueFor("caustic_finale_damage_base")
    self.caustic_finale_duration=self.ability:GetSpecialValueFor("caustic_finale_duration")
end

function modifier_caustic_finale:OnRefresh()
   self:OnCreated()
end


function modifier_caustic_finale:OnAttackLanded(tg)
    if not IsServer() then
        return
	end  
	
    if tg.attacker == self.parent then
        if self.parent:PassivesDisabled() or self.parent:IsIllusion() or tg.target:IsBuilding() then
            return
        end
        local damage= {
            victim = tg.target,
            attacker = self.parent,
            damage = tg.target:HasModifier("modifier_sand_storm_debuff") and  self.caustic_finale_damage_base*2 or self.caustic_finale_damage_base,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self.ability,
            }
        ApplyDamage(damage)
        if tg.target:IsAlive() then 
            tg.target:AddNewModifier(self.parent, self.ability, "modifier_caustic_finale_debuff", {duration=self.caustic_finale_duration})
        end 
    end
end  


modifier_caustic_finale_debuff=class({})

function modifier_caustic_finale_debuff:IsDebuff()
	return true
end

function modifier_caustic_finale_debuff:IsPurgable() 			
    return true 
end

function modifier_caustic_finale_debuff:IsPurgeException() 	
    return true 
end

function modifier_caustic_finale_debuff:IsHidden()				
    return false 
end

function modifier_caustic_finale_debuff:GetEffectName() 
    return "particles/units/heroes/hero_sandking/sandking_caustic_finale_debuff.vpcf" 
end

function modifier_caustic_finale_debuff:GetEffectAttachType() 
    return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_caustic_finale_debuff:DeclareFunctions()
	return 
        {
            MODIFIER_EVENT_ON_DEATH,
            MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	    }
end

function modifier_caustic_finale_debuff:OnCreated()
    self.parent=self:GetParent()
        if self:GetAbility() then
        self.ability=self:GetAbility()
        self.caustic_finale_radius=self.ability:GetSpecialValueFor("caustic_finale_radius")
        self.caustic_finale_slow=self.ability:GetSpecialValueFor("caustic_finale_slow")-self:GetCaster():TG_GetTalentValue("special_bonus_sand_king_3")
        self.pct=self.ability:GetSpecialValueFor("pct")
        self.caustic_finale_damage_pct=self.ability:GetSpecialValueFor("caustic_finale_damage_pct")
    end
end

function modifier_caustic_finale_debuff:OnRefresh()
   self:OnCreated()
end

function modifier_caustic_finale_debuff:GetModifierMoveSpeedBonus_Percentage()
   return self.caustic_finale_slow
 end

function modifier_caustic_finale_debuff:OnDeath(tg)
    if not IsServer() then
        return
	end  
	
    if tg.unit == self.parent then
        EmitSoundOn("Ability.SandKing_CausticFinale", self.parent)
        local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN, self.parent)
		ParticleManager:ReleaseParticleIndex(fx)
        local targets = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),
            self.parent:GetAbsOrigin(),
            nil,
            self.caustic_finale_radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_CLOSEST,
            false)
            if #targets>0 then    
                for _, target in pairs(targets) do
                    local damage= {
                        victim = target,
                        attacker = self:GetCaster(),
                        damage = (self.caustic_finale_damage_pct+(self.parent:HasModifier("modifier_sand_storm_debuff")and self.pct or 0 ))*0.01*self.parent:GetMaxHealth(),
                        damage_type = DAMAGE_TYPE_MAGICAL,
                        ability = self.ability,
                        }
                    ApplyDamage(damage)
                end
            end
	end 
end  

