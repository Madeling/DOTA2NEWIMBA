item_guard_bot=class({})

LinkLuaModifier("modifier_item_guard_bot", "items/item_guard_bot.lua", LUA_MODIFIER_MOTION_NONE)

function item_guard_bot:OnSpellStart()
    local pos=self:GetCursorPosition()
    local caster=self:GetCaster() 
    local dur=self:GetSpecialValueFor("duration")			
    local bot = CreateUnitByName(
        "npc_guard_bot",
         pos,
         true,
         caster,
         caster,
         caster:GetTeamNumber())
         Timers:CreateTimer(0.1, function()
            bot:SetForwardVector(caster:GetForwardVector()*1)
            bot:AddNewModifier(caster, self, "modifier_kill", {duration=dur})
            bot:AddNewModifier(caster, self, "modifier_item_guard_bot", {duration=dur})
            bot:MoveToPosition(bot:GetAbsOrigin()+bot:GetForwardVector()*8000)
            return nil
        end)
        self:SpendCharge()
end



modifier_item_guard_bot=class({})

function modifier_item_guard_bot:IsHidden() 			
	return true 
end

function modifier_item_guard_bot:IsPurgable() 		
	return false 
end

function modifier_item_guard_bot:IsPurgeException() 	
	return false 
end

function modifier_item_guard_bot:OnCreated() 	
    if IsServer() then 
        self.id=self:GetCaster():GetPlayerOwnerID()
        self:StartIntervalThink(1)
    end 
end


function modifier_item_guard_bot:OnIntervalThink() 	

    local targets = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(), 
		self:GetParent():GetAbsOrigin(), 
		nil, 
		1000, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_OTHER, 
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
		FIND_ANY_ORDER, 
        false)  
        
        for _, target in pairs(targets) do
            local name=target:GetName()
            if name~=nil and (name=="npc_dota_ward_base_truesight" or name=="npc_dota_ward_base") then 
                CDOTA_PlayerResource.TG_HERO[self.id + 1].des_ward=CDOTA_PlayerResource.TG_HERO[self.id + 1].des_ward+1
                target:Kill( nil, self:GetParent() )
            end 
        end 
end

function modifier_item_guard_bot:CheckState()
    return 
    {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
    }
end