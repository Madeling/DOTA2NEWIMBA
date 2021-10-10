modifier_invoker_up=class({})

function modifier_invoker_up:IsHidden() 			
    return false 
end

function modifier_invoker_up:IsPurgable() 			
    return false 
end

function modifier_invoker_up:IsPurgeException() 	
    return false 
end

function modifier_invoker_up:IsPermanent() 	
    return true 
end

function modifier_invoker_up:AllowIllusionDuplicate() 	
    return false 
end

function modifier_invoker_up:GetTexture() 	
	return "invoker_hphover" 
end

function modifier_invoker_up:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED
    } 
end

function modifier_invoker_up:GetModifierSpellAmplify_Percentage() 	
    return 10 
end

function modifier_invoker_up:GetModifierPercentageCooldown() 	
    return 20 
end

function modifier_invoker_up:GetModifierMoveSpeedBonus_Constant() 	
    return 70 
end

function modifier_invoker_up:OnCreated()
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.team=self.parent:GetTeamNumber()	
    self.cold_rd=350
    self.cold_stun=0.15
end


function modifier_invoker_up:OnAttackLanded(tg) 	
    if IsServer() then   
        if tg.attacker==self.parent then    
            if tg.target:HasModifier("modifier_invoker_cold_snap") then
                local heros = FindUnitsInRadius(
                    self.team,
                    tg.target:GetAbsOrigin(),
                    nil,
                    self.cold_rd, 
                    DOTA_UNIT_TARGET_TEAM_ENEMY, 
                    DOTA_UNIT_TARGET_HERO,
                    DOTA_UNIT_TARGET_FLAG_NONE, 
                    FIND_ANY_ORDER,false)
                    if #heros>0 then
                        for _, hero in pairs(heros) do
                            if hero~=tg.target and not hero:IsMagicImmune() then   
                                hero:AddNewModifier(self.parent, self.ability, "modifier_imba_stunned", {duration=self.cold_stun})
                            end
                        end 
                    end
            end
        end 
    end 
end

function modifier_invoker_up:OnAbilityExecuted(tg) 	
    if IsServer() then   
        if tg.unit == self.parent then
            local name=tg.ability:GetName()
            if name=="invoker_ghost_walk" then 
                self.parent:Purge(false, true, false, true, true)
            end
            if name=="invoker_ice_wall" then 
                local pos=tg.ability:GetCursorPosition()    
                CreateModifierThinker(self.parent, tg.ability, "modifier_invoker_ice_wall_up", {duration=13.5,x=pos.x,y=pos.y,z=pos.z}, pos, self.team, false)
            end
        end
    end 
end



