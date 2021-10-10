midnight_pulse=class({})
LinkLuaModifier("modifier_midnight_pulse_debuff", "heros/hero_enigma/midnight_pulse.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_midnight_pulse_debuff1", "heros/hero_enigma/midnight_pulse.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_midnight_pulse_buff", "heros/hero_enigma/midnight_pulse.lua", LUA_MODIFIER_MOTION_NONE)
function midnight_pulse:IsHiddenWhenStolen() 
    return false 
end

function midnight_pulse:IsStealable() 
    return true 
end

function midnight_pulse:IsRefreshable() 			
    return true 
end


function midnight_pulse:OnSpellStart() 
    local caster = self:GetCaster()
    local cur_pos = self:GetCursorPosition()
    local duration =self:GetSpecialValueFor("duration")
    local radius =self:GetSpecialValueFor("radius")
    local damage_percent =self:GetSpecialValueFor("damage_percent")
    caster:EmitSound("Hero_Enigma.Midnight_Pulse")
    GridNav:DestroyTreesAroundPoint(cur_pos, radius, false)
    CreateModifierThinker(caster, self, "modifier_midnight_pulse_debuff", {duration=duration,radius=radius,damage_percent=damage_percent}, cur_pos, caster:GetTeamNumber(), false)
end

modifier_midnight_pulse_debuff= class({})

function modifier_midnight_pulse_debuff:IsDebuff() 			
    return true 
end

function modifier_midnight_pulse_debuff:IsHidden() 			
    return true 
end

function modifier_midnight_pulse_debuff:IsPurgable() 		
    return false
end

function modifier_midnight_pulse_debuff:IsPurgeException() 
    return false 
end

function modifier_midnight_pulse_debuff:OnCreated(tg) 
    self.damageTable = {
        attacker = self:GetCaster(),
        damage_type =DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, 
        ability = self:GetAbility(),
        }
    if not IsServer() then
        return 
    end
    self.radius=tg.radius
    self.damage_percent=tg.damage_percent
    self.pos=self:GetParent():GetAbsOrigin()
    local fx= ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf", PATTACH_CUSTOMORIGIN,nil)
    ParticleManager:SetParticleControl(fx, 0,  self.pos)
    ParticleManager:SetParticleControl(fx, 1, Vector(self.radius,self.radius,self.radius))
    self:AddParticle(fx, false, false, 20, false, false)
    self:StartIntervalThink(1)
end

function modifier_midnight_pulse_debuff:OnIntervalThink() 
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self.pos,
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_BOTH, 
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
        FIND_CLOSEST,
        false)
    if #heros>0 then
        for _, hero in pairs(heros) do
            if not Is_Chinese_TG( self:GetParent(),hero) and  not hero:IsBoss() then
                    self.damageTable.damage = hero:GetMaxHealth()*self.damage_percent*0.01
                    self.damageTable.victim = hero
                    ApplyDamage(self.damageTable)
                    if self:GetCaster():TG_HasTalent("special_bonus_enigma_3") then   
                        hero:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_midnight_pulse_debuff1", {duration=1.1} )
                    end 
            else
                if Is_Chinese_TG( self:GetParent(),hero) then
                    hero:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_midnight_pulse_buff", {duration=1.1} )
                end
            end
        end
    end
end


modifier_midnight_pulse_buff= class({})

function modifier_midnight_pulse_buff:IsHidden() 			
    return false 
end

function modifier_midnight_pulse_buff:IsPurgable() 		
    return false
end

function modifier_midnight_pulse_buff:IsPurgeException() 
    return false 
end

function modifier_midnight_pulse_buff:OnCreated() 
    if IsServer() then    
        self:SetStackCount(self:GetAbility():GetSpecialValueFor("attsp")+self:GetCaster():TG_GetTalentValue("special_bonus_enigma_2"))
    end
end

function modifier_midnight_pulse_buff:OnRefresh() 
    self:OnCreated() 
end


function modifier_midnight_pulse_buff:DeclareFunctions()
	return 
		{
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
		}
end

function modifier_midnight_pulse_buff:GetModifierAttackSpeedBonus_Constant() 
    return self:GetStackCount()
end

modifier_midnight_pulse_debuff1= class({})

function modifier_midnight_pulse_debuff1:IsHidden() 			
    return false 
end

function modifier_midnight_pulse_debuff1:IsPurgable() 		
    return false
end

function modifier_midnight_pulse_debuff1:IsPurgeException() 
    return false 
end

function modifier_midnight_pulse_debuff1:OnCreated() 
    if IsServer() then    
        self:SetStackCount(self:GetAbility():GetSpecialValueFor("attsp")+self:GetCaster():TG_GetTalentValue("special_bonus_enigma_2"))
    end
end

function modifier_midnight_pulse_debuff1:OnRefresh() 
    self:OnCreated() 
end


function modifier_midnight_pulse_debuff1:DeclareFunctions()
	return 
		{
            MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
		}
end

function modifier_midnight_pulse_debuff1:GetModifierAttackSpeedBonus_Constant() 
    return 0-self:GetStackCount()
end