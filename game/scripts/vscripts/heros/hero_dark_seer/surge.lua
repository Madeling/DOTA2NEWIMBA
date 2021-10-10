surge=class({})

LinkLuaModifier("modifier_surge_buff", "heros/hero_dark_seer/surge.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

LinkLuaModifier("modifier_surge", "heros/hero_dark_seer/surge.lua", LUA_MODIFIER_MOTION_NONE)


function surge:GetIntrinsicModifierName() 
    return "modifier_surge" 
end

function surge:IsHiddenWhenStolen() 
    return false 
end

function surge:IsStealable() 
    return true 
end


function surge:IsRefreshable() 			
    return true 
end

function surge:GetCastPoint()			
    if self:GetCaster():TG_HasTalent("special_bonus_dark_seer_4") then
        return 0
    else
        return 0.3
    end
end

function surge:OnSpellStart()
    local caster=self:GetCaster()
    local cur_tar=self:GetAutoCastState() and caster or self:GetCursorTarget()
    local duration=self:GetSpecialValueFor("duration")
    cur_tar:EmitSound("Hero_Dark_Seer.Surge")
    if caster:HasScepter() then 
        local heros = FindUnitsInRadius( 
			cur_tar:GetTeamNumber(), 
			cur_tar:GetAbsOrigin(), 
			cur_tar, 
			350, 
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER, 
			false )
		if #heros > 0 then
			for _,hero in pairs(heros) do
				hero:AddNewModifier(caster, self, "modifier_surge_buff", {duration=duration})
			end
		end
    else 
        cur_tar:AddNewModifier(caster, self, "modifier_surge_buff", {duration=duration})
    end
end



modifier_surge_buff=class({})

function modifier_surge_buff:IsHidden() 			
	return false 
end

function modifier_surge_buff:IsPurgable() 		
	return true 
end

function modifier_surge_buff:IsPurgeException() 	
	return true 
end

function modifier_surge_buff:OnCreated()
    if IsServer() then 
        self.SP=self:GetAbility():GetSpecialValueFor("speed_boost")+self:GetCaster():TG_GetTalentValue("special_bonus_dark_seer_3")
        self:SetStackCount(self.SP)
        if self:GetParent()==self:GetCaster() then
            if self:GetParent():HasAbility("seriously_punch") then 
                local ab=self:GetParent():FindAbilityByName("seriously_punch")
                if ab:GetLevel()>=1 then 
                    ab:EndCooldown()
                end
            end
        end
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
       self:AddParticle(particle, false, false, -1, false, false)
   end
end

function modifier_surge_buff:OnRefresh()
    self:OnCreated()
end

function modifier_surge_buff:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
    } 
end

function modifier_surge_buff:CheckState()
    return 
    {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

function modifier_surge_buff:GetModifierMoveSpeed_Limit()
    return 99999
end

function modifier_surge_buff:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_surge_buff:GetModifierMoveSpeedBonus_Constant() 
    return   self:GetStackCount()
end

function modifier_surge_buff:GetModifierHealthRegenPercentage() 
    if self:GetCaster():TG_HasTalent("special_bonus_dark_seer_8") and self:GetCaster():IsMoving() then
        return 3
    end 
    return  0
end

function modifier_surge_buff:GetModifierTotalPercentageManaRegen() 
    if self:GetCaster():TG_HasTalent("special_bonus_dark_seer_8")and self:GetCaster():IsMoving()  then
        return 3
    end 
    return  0
end

modifier_surge=class({})


function modifier_surge:IsHidden() 			
	return true 
end

function modifier_surge:IsPurgable() 		
	return false 
end

function modifier_surge:IsPurgeException() 	
	return false 
end

function modifier_surge:OnCreated()
    self.ab=self:GetAbility()
    if IsServer() then 
        self:StartIntervalThink(1)
   end
end

function modifier_surge:OnIntervalThink()
    if self:GetCaster():IsAlive() and  self.ab and self.ab:GetAutoCastState() and self.ab:GetLevel()>0 and self.ab:IsOwnersManaEnough() and self.ab:IsCooldownReady() and not self:GetCaster():IsSilenced() and not self:GetCaster():IsStunned() then
        self.ab:OnSpellStart()
        self.ab:UseResources(true, false, true)
    end
end
