device=class({})
LinkLuaModifier("modifier_device", "heros/hero_sniper/device.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_device2", "heros/hero_sniper/device.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_device_debuff", "heros/hero_sniper/device.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_device_buff", "heros/hero_sniper/device.lua", LUA_MODIFIER_MOTION_NONE)

function device:IsHiddenWhenStolen() 
    return false 
end

function device:IsStealable() 
    return true 
end

function device:IsRefreshable() 			
    return true 
end


function device:OnSpellStart()
    local caster = self:GetCaster()
	local casterpos = caster:GetAbsOrigin()
    local cur = self:GetCursorPosition()
    local dur =self:GetSpecialValueFor("dur")
    local name=caster:GetName()
    caster.devicename=name
    EmitSoundOn("DOTA_Item.HavocHammer.Cast", caster)
    local bot = CreateUnitByName(
      "npc_sniper_machine", 
      cur, 
      false,
      nil, 
      nil, 
      caster:GetTeamNumber())
      FindClearSpaceForUnit( bot,bot:GetAbsOrigin(), false )
      self.BOTB=bot
      bot:AddNewModifier(caster, self, "modifier_invulnerable", {duration=dur})
      bot:AddNewModifier(caster, self, "modifier_kill", {duration=dur})
      bot:AddNewModifier(caster, self, "modifier_device", {duration=dur})
      bot:AddNewModifier(caster, self, "modifier_device2", {duration=dur})
        if caster:TG_HasTalent("special_bonus_sniper_20r") then
            AddFOWViewer(caster:GetTeamNumber(), cur, 1500, dur, false)
        end 
end

modifier_device=class({})
function modifier_device:IsHidden() 			
	return false 
end

function modifier_device:IsPurgable() 		
	return false 
end

function modifier_device:IsPurgeException() 	
	return false 
end

function modifier_device:IsAura() 
    return true 
end


function modifier_device:GetModifierAura() 
    return "modifier_device_debuff" 
end

function modifier_device:GetAuraRadius() 
        return self:GetAbility():GetSpecialValueFor( "rd" )
end

function modifier_device:GetAuraSearchFlags() 
    return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_device:GetAuraSearchTeam() 
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_device:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
end

function modifier_device:GetEffectAttachType() 	
	return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_device:GetEffectName() 	
	return "particles/econ/items/mars/mars_ti10_taunt/mars_ti10_taunt.vpcf" 
end

function modifier_device:OnCreated(tg) 
    if  IsServer() then 
        local particle= ParticleManager:CreateParticle("particles/basic_ambient/generic_range_display.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
        ParticleManager:SetParticleControl(particle, 1, Vector(self:GetAbility():GetSpecialValueFor("rd"), 0, 0))
        ParticleManager:SetParticleControl(particle, 2, Vector(10, 0, 0))
        ParticleManager:SetParticleControl(particle, 3, Vector(100, 0, 0))
        ParticleManager:SetParticleControl(particle, 15, Vector(70, 130, 180))
        self:AddParticle( particle, true, false, 10, false, false )
        local particle2= ParticleManager:CreateParticle("particles/econ/events/ti10/soccer_ball/soccer_ball_dust.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
        ParticleManager:ReleaseParticleIndex( particle2 )
        local particle3= ParticleManager:CreateParticle("particles/customgames/capturepoints/cp_neutral_3.vpcf", PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
        self:AddParticle( particle3, true, false, 10, false, false )
    end
end



modifier_device2=class({})


function modifier_device2:IsHidden() 			
	return false 
end

function modifier_device2:IsPurgable() 		
	return false 
end

function modifier_device2:IsPurgeException() 	
	return false 
end

function modifier_device2:OnCreated() 	
    self.rd=self:GetAbility():GetSpecialValueFor("rd")
    if not IsServer() then
        return 
    end
    self:OnIntervalThink()
    self:StartIntervalThink(0.1)
end

function modifier_device2:OnIntervalThink() 	

    local heros = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            self:GetParent():GetAbsOrigin(),
            nil,
            self.rd,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
            DOTA_UNIT_TARGET_HERO,
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER,
            false)

            for _, hero in pairs(heros) do
                if hero:GetName()==self:GetCaster().devicename then
                    hero:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_device_buff", {duration=1})
                    hero:AddNewModifier(hero, nil, "modifier_item_lotus_orb_active", {duration=1})
                    if hero:TG_HasTalent("special_bonus_sniper_20l") then 
                        hero:Heal(10, hero)
                    end 
                 end
            end
end

function modifier_device2:OnDestroy() 	
    self.rd=nil
end

modifier_device_debuff=class({})

function modifier_device_debuff:IsDebuff()			
    return true 
end

function modifier_device_debuff:IsHidden() 			
	return false 
end

function modifier_device_debuff:IsPurgable() 		
	return false 
end

function modifier_device_debuff:IsPurgeException() 	
	return false 
end

modifier_device_buff=class({})

function modifier_device_buff:IsBuff()			
    return true 
end

function modifier_device_buff:IsHidden() 			
	return false 
end

function modifier_device_buff:IsPurgable() 		
	return false 
end

function modifier_device_buff:IsPurgeException() 	
	return false 
end

function modifier_device_buff:GetEffectAttachType() 	
	return PATTACH_ABSORIGIN_FOLLOW 
end

function modifier_device_buff:GetEffectName() 	
    return "particles/items2_fx/manta_phase.vpcf" 
end


function modifier_device_buff:CheckState()
        return
        {
            [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
       --     [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        }
     
end





