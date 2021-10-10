stampede =class({})
LinkLuaModifier("modifier_stampede_buff", "heros/hero_centaur/stampede.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stampede_debuff", "heros/hero_centaur/stampede.lua", LUA_MODIFIER_MOTION_NONE)
function stampede:IsHiddenWhenStolen() 
    return false 
end

function stampede:IsStealable() 
    return true 
end

function stampede:IsRefreshable() 			
    return true 
end


function stampede:OnSpellStart()
    local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()
    local sp=self:GetSpecialValueFor( "sp" )
    local dur=self:GetSpecialValueFor( "duration" )+caster:TG_GetTalentValue("special_bonus_centaur_6")
    local sp1=caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), true)
    sp=sp1>sp and sp1 or sp 
    caster:EmitSound("Hero_Centaur.Stampede.Cast")
    caster:StartGesture(ACT_DOTA_CENTAUR_STAMPEDE)
    caster:AddNewModifier(caster, self, "modifier_stampede_buff", {duration=dur,sp=sp})
    if caster:HasScepter() then 
        for i=1, 24 do
            if CDOTA_PlayerResource.TG_HERO[i] then
                local hero = CDOTA_PlayerResource.TG_HERO[i]
                if hero~= nil then
                    if Is_Chinese_TG(hero,caster) and hero~=caster and hero:IsAlive() then
                        local sp1=hero:GetMoveSpeedModifier(hero:GetBaseMoveSpeed(), true)
                        sp=sp1>sp and sp1 or sp 
                        hero:AddNewModifier(caster, self, "modifier_stampede_buff", {duration=dur,sp=sp})
                    end
                end
            end
        end
    end
end

modifier_stampede_buff= class({})

function modifier_stampede_buff:IsHidden() 			
	return false 
end

function modifier_stampede_buff:IsPurgable() 		
	return false 
end

function modifier_stampede_buff:IsPurgeException() 	
	return false 
end

function modifier_stampede_buff:GetEffectName() 
    return "particles/units/heroes/hero_centaur/centaur_stampede_overhead.vpcf" 
end

function modifier_stampede_buff:GetEffectAttachType()
     return PATTACH_OVERHEAD_FOLLOW 
end

function modifier_stampede_buff:ShouldUseOverheadOffset() 
    return true 
end

function modifier_stampede_buff:OnCreated(tg) 	
    self.damageoutgoing=self:GetAbility():GetSpecialValueFor( "damageoutgoing" )
    self.rs=self:GetAbility():GetSpecialValueFor( "rs" )
    self.radius=self:GetAbility():GetSpecialValueFor( "radius2" )+self:GetParent():TG_GetTalentValue("special_bonus_centaur_7")
    self.dur=self:GetAbility():GetSpecialValueFor( "dur2" )+self:GetParent():TG_GetTalentValue("special_bonus_centaur_5")
    if not IsServer() then
        return 
    end
    self:SetStackCount(tg.sp)
    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_stampede.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle(pfx, false, false, 15, false, false)
    self:GetParent():Purge(false, true, false, true, true)
    self:OnIntervalThink()
    self:StartIntervalThink(0.15)
end

function modifier_stampede_buff:OnRefresh(tg) 	
    self.damageoutgoing=self:GetAbility():GetSpecialValueFor( "damageoutgoing" )
    self.rs=self:GetAbility():GetSpecialValueFor( "rs" )
    self.radius=self:GetAbility():GetSpecialValueFor( "radius2" )+self:GetParent():TG_GetTalentValue("special_bonus_centaur_7")
    self.dur=self:GetAbility():GetSpecialValueFor( "dur2" )+self:GetParent():TG_GetTalentValue("special_bonus_centaur_5")
    if not IsServer() then
        return 
    end
    self:SetStackCount(tg.sp)
    self:GetParent():Purge(false, true, false, true, true)
end

function modifier_stampede_buff:OnIntervalThink()
    GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 300, false) 	
    local heros = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),
        self:GetParent():GetAbsOrigin(),
        nil,
        self.radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_CLOSEST,
        false)
        if #heros>0 then 
        for _, hero in pairs(heros) do
            if not hero:IsMagicImmune() and not hero:HasModifier("modifier_stampede_debuff") then 
                    hero:AddNewModifier(self:GetParent(),self:GetAbility(), "modifier_stampede_debuff", {duration=self.dur})
            end
        end
    end
end



function modifier_stampede_buff:DeclareFunctions() 
    return 
    {
       
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    } 
end


function modifier_stampede_buff:GetModifierStatusResistanceStacking() 
    return self.rs
end

function modifier_stampede_buff:GetModifierMoveSpeed_Absolute() 
    return  self:GetStackCount()
end

function modifier_stampede_buff:GetModifierIncomingDamage_Percentage() 
    return  self.damageoutgoing
end

function modifier_stampede_buff:CheckState()
	return
	{
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end

modifier_stampede_debuff= class({})

function modifier_stampede_debuff:IsDebuff() 			
	return true 
end

function modifier_stampede_debuff:IsHidden() 			
	return false 
end

function modifier_stampede_debuff:IsPurgable() 		
	return true 
end

function modifier_stampede_debuff:IsPurgeException() 	
	return true 
end

function modifier_stampede_debuff:DeclareFunctions() 
    return 
    {
       
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    } 
end


function modifier_stampede_debuff:GetModifierMoveSpeedBonus_Percentage() 
    return self:GetAbility():GetSpecialValueFor( "slow_movement_speed" )
end