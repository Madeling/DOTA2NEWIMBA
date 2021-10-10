modifier_roshan_up=class({})

LinkLuaModifier("modifier_roshan", "modifier/roshan/modifier_roshan_up.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_attsp", "modifier/roshan/modifier_roshan_up.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_roshan_attribute", "modifier/roshan/modifier_roshan_up.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_roshan_up:IsHidden() 
    return false
end

function modifier_roshan_up:GetTexture() 
    return "roshan_up" 
end

function modifier_roshan_up:IsPurgable() 
    return false 
end

function modifier_roshan_up:IsPurgeException() 
    return false 
end

function modifier_roshan_up:IsPermanent() 
    return true 
end

function modifier_roshan_up:GetAttributes() 
    return MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_roshan_up:RemoveOnDeath() 
    return false 
end

function modifier_roshan_up:CheckState()
    return 
    {
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, 
        [MODIFIER_STATE_UNSLOWABLE] = true, 
    }
end

function modifier_roshan_up:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end

function modifier_roshan_up:OnCreated()
    self.b=true
    if not IsServer() then
        return
    end
    self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_roshan",{})
    self:GetParent():SetUnitCanRespawn(true)
end

function modifier_roshan_up:OnIntervalThink()
    self.b=true
    self:StartIntervalThink(-1)
end

function modifier_roshan_up:OnTakeDamage(tg)
    if not IsServer() then
        return
    end

    if tg.unit == self:GetParent() then
        if CDOTA_PlayerResource.ROSHAN~=nil and CDOTA_PlayerResource.ROSHAN:IsAlive() and tg.unit:GetHealthPercent()<=25 and self.b then
            self.b=false
            self:StartIntervalThink(10)
            tg.unit:AddNewModifier( tg.unit, nil, "modifier_roshan_attsp", {duration=6} )
            local Knockback ={
                should_stun =  0.25,
                knockback_duration = 0.25,
                duration =  0.25,
                knockback_distance = 600,
                knockback_height = 400,
                center_x =  tg.unit:GetAbsOrigin().x,
                center_y =  tg.unit:GetAbsOrigin().y,
                center_z =  tg.unit:GetAbsOrigin().z
            }
             tg.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_knockback", Knockback)           
        end 
    end 
end

function modifier_roshan_up:OnDeath(tg)
    if not IsServer() then
        return
    end
    if tg.unit == self:GetParent() then
        local pos=self:GetParent():GetAbsOrigin()
        CDOTA_PlayerResource.ROSHAN_DIE=CDOTA_PlayerResource.ROSHAN_DIE+1
        if  CDOTA_PlayerResource.ROSHAN_DIE>0 then 
            local aegis = CreateItem("item_aegis_v2", nil, nil)
			if aegis then
				CreateItemOnPositionSync(pos, aegis)
			end
        end
        if  CDOTA_PlayerResource.ROSHAN_DIE>=3 then 
            local refresher = CreateItem("item_refresher_shard", nil, nil)
			if refresher then
				CreateItemOnPositionSync(pos, refresher)
			end
        end
        if  CDOTA_PlayerResource.ROSHAN_DIE==10 then 
            local rapier_cursed = CreateItem("item_imba_rapier_cursed", nil, nil)
			if rapier_cursed then
				CreateItemOnPositionSync(pos, rapier_cursed)
			end
        end
        CDOTA_PlayerResource.ROSHAN=self:GetParent()
        Timers:CreateTimer(120, function()
            Notifications:TopToAll({text="-肉山已复活-", duration=3.0,style={color="#FFEFDB", ["font-size"]="40px", border="5px solid #FFEFDB"},continue = true})
            CDOTA_PlayerResource.ROSHAN:RespawnUnit()
            Timers:CreateTimer(0.01, function()
                CDOTA_PlayerResource.ROSHAN:AddNewModifier( CDOTA_PlayerResource.ROSHAN, nil, "modifier_roshan_attribute",{})
                FindClearSpaceForUnit(  CDOTA_PlayerResource.ROSHAN, ROSHAN_POS, true)
                return nil
            end)
            return nil
        end)
    end
end


modifier_roshan_attsp=class({})

function modifier_roshan_attsp:GetTexture() 
    return "roshan_up" 
end

function modifier_roshan_attsp:IsPurgable() 
    return false 
end

function modifier_roshan_attsp:IsPurgeException() 
    return false 
end

function modifier_roshan_attsp:RemoveOnDeath()
    return true 
end

function modifier_roshan_attsp:OnCreated()
    if not IsServer() then
        return
    end
    self:GetParent():Purge(false, true, false, false, false)
end

function modifier_roshan_attsp:CheckState()
    return 
    {
        [MODIFIER_STATE_STUNNED] = false, 
        [MODIFIER_STATE_CANNOT_MISS] = true, 
        [MODIFIER_STATE_DISARMED] = false, 
        [MODIFIER_STATE_SILENCED] = false, 
        [MODIFIER_STATE_ROOTED] = false, 
        [MODIFIER_STATE_UNSLOWABLE] = true, 
        [MODIFIER_STATE_PASSIVES_DISABLED] = false
    }
end

function modifier_roshan_attsp:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_roshan_attsp:GetModifierAttackSpeedBonus_Constant() 
    return 400
end


modifier_roshan_attribute=class({})

function modifier_roshan_attribute:IsHidden() 
    return true
end

function modifier_roshan_attribute:IsPurgable() 
    return false 
end

function modifier_roshan_attribute:IsPurgeException() 
    return false 
end

function modifier_roshan_attribute:IsPermanent()
    return true 
end

function modifier_roshan_attribute:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_roshan_attribute:RemoveOnDeath() 
    return false 
end

function modifier_roshan_attribute:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end


function modifier_roshan_attribute:GetModifierPreAttack_BonusDamage() 
    return 100
end

function modifier_roshan_attribute:GetModifierExtraHealthBonus() 
    return 1000
end

function modifier_roshan_attribute:GetModifierPhysicalArmorBonus() 
    return 7
end

modifier_roshan=class({})

function modifier_roshan:IsHidden() 
    return true
end

function modifier_roshan:IsPurgable() 
    return false 
end

function modifier_roshan:IsPurgeException() 
    return false 
end

function modifier_roshan:IsPermanent()
    return true 
end

function modifier_roshan:RemoveOnDeath() 
    return false 
end

function modifier_roshan:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_roshan:OnIntervalThink()
    if TG_Distance(self:GetParent():GetAbsOrigin(),ROSHAN_POS) >= 500 then 
        self:GetParent():MoveToPosition(ROSHAN_POS)
        local hp= self:GetParent():GetMaxHealth()*0.2
        self:GetParent():Heal( hp,  self:GetParent())
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(),hp, nil)
    end
end