change=class({})
LinkLuaModifier("modifier_change_rifle", "heros/hero_sniper/change.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_change_shotgun", "heros/hero_sniper/change.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_change_v", "heros/hero_sniper/change.lua", LUA_MODIFIER_MOTION_NONE)

function change:IsHiddenWhenStolen() 
    return false 
end

function change:IsStealable() 
    return true 
end

function change:IsRefreshable() 			
    return true 
end


function change:OnOwnerSpawned() 			
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_change_shotgun", {})
end

function change:OnUpgrade()		
    if self:GetLevel()==1 then
        local caster= self:GetCaster()
        caster:AddNewModifier(caster, self, "modifier_change_shotgun", {})
    end 
end

function change:OnToggle()
    local caster= self:GetCaster()
    EmitSoundOn("Ability.AssassinateLoad", caster)
    if self:GetToggleState() then
        if caster:HasModifier("modifier_change_shotgun") then
            caster:RemoveModifierByName("modifier_change_shotgun")
        end
            caster:AddNewModifier(caster, self, "modifier_change_rifle", {})         
    else
        if caster:HasModifier("modifier_change_rifle")  then
            caster:RemoveModifierByName("modifier_change_rifle")
        end  
            caster:AddNewModifier(caster, self, "modifier_change_shotgun", {})
    end
end





modifier_change_rifle=class({})

function modifier_change_rifle:IsHidden() 			
	return false 
end

function modifier_change_rifle:IsPurgable() 		
	return false 
end

function modifier_change_rifle:IsPurgeException() 	
	return false 
end

function modifier_change_rifle:RemoveOnDeath() 	
	return false 
end

function modifier_change_rifle:IsPermanent() 	
	return true 
end

function modifier_change_rifle:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    } 
end

function modifier_change_rifle:GetModifierAttackRangeBonus() 
    return  self.ATTRG
end

function modifier_change_rifle:GetBonusVisionPercentage() 
    return  self.V
end


function modifier_change_rifle:OnCreated()	
    self.ATTRG=self:GetAbility():GetSpecialValueFor( "attrg" )
    self.V=self:GetAbility():GetSpecialValueFor( "v" )
   if not IsServer() then
		return 
    end
    Notifications:Bottom(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), {text="切换为:狙击枪", duration=2, style={color="white", ["font-size"]="30px"}})
    self.rifle = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/widowmaker/widowmaker.vmdl"})
    self.rifle:SetParent(self:GetParent(), nil)
    self.rifle:FollowEntity(self:GetParent(), true)
end

function modifier_change_rifle:OnRefresh()	
    self:OnCreated()
end

function modifier_change_rifle:OnDestroy()
    self.ATTRG=nil
    self.V=nil
    if not IsServer() then
		return 
    end
    self.rifle:Destroy()
end

function modifier_change_rifle:GetTexture()
    return "rifle" 
end



function modifier_change_rifle:OnAttackLanded(tg)
    if not IsServer() then
		return 
    end
    if tg.attacker==self:GetParent() and tg.attacker:TG_HasTalent("special_bonus_sniper_15l") then 
        tg.target:AddNewModifier(  tg.attacker, self:GetAbility(), "modifier_change_v", {duration=self:GetAbility():GetSpecialValueFor( "vdur" )} )
    end 
end


modifier_change_shotgun=class({})


function modifier_change_shotgun:IsHidden() 			
	return false 
end

function modifier_change_shotgun:IsPurgable() 		
	return false 
end

function modifier_change_shotgun:IsPurgeException() 	
	return false 
end

function modifier_change_shotgun:RemoveOnDeath() 	
	return false 
end

function modifier_change_shotgun:IsPermanent() 	
	return true 
end

function modifier_change_shotgun:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    } 
end

function modifier_change_shotgun:GetModifierMoveSpeedBonus_Percentage() 
    return self.SP
end

function modifier_change_shotgun:GetModifierTurnRate_Percentage() 
    return  self.RATE
end




function modifier_change_shotgun:OnCreated()	
    self.minrd =self:GetAbility():GetSpecialValueFor( "minrd" )
    self.SP =self:GetAbility():GetSpecialValueFor( "sp" )
    self.RATE =self:GetAbility():GetSpecialValueFor( "rate" )
    if not IsServer() then
		return 
    end
    self.mindis =self:GetAbility():GetSpecialValueFor( "mindis" )+self:GetParent():TG_GetTalentValue("special_bonus_sniper_15r")
    Notifications:Bottom(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), {text="切换为:霰弹枪", duration=2, style={color="white", ["font-size"]="30px"}})
      self.shotgun = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/sniper/witch_hunter_set_weapon/witch_hunter_set_weapon.vmdl"})
      self.shotgun:SetParent(self:GetParent(), nil)
      self.shotgun:FollowEntity(self:GetParent(), true)
  end

  function modifier_change_shotgun:OnRefresh()	
    self:OnCreated()
  end
  
  function modifier_change_shotgun:OnDestroy()
    self.mindis =nil
    self.RATE=nil
    self.SP=nil
    if not IsServer() then
		return 
    end
      self.shotgun:Destroy()
  end

  function modifier_change_shotgun:GetTexture()
    return "shotgun" 
end

function modifier_change_shotgun:OnAttackLanded(tg)
    if not IsServer() then
		return 
    end
    if tg.attacker==self:GetParent() then 
        if TG_Distance(tg.attacker:GetAbsOrigin(),tg.target:GetAbsOrigin())<= self.mindis  then
        local enemies = FindUnitsInRadius(
            tg.attacker:GetTeamNumber(),
            tg.target:GetAbsOrigin(),
            nil,
            self.minrd,
            DOTA_UNIT_TARGET_TEAM_ENEMY, 
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE, 
            FIND_ANY_ORDER,
            false)

            for _, enemy in pairs(enemies) do
                if not enemy:IsAttackImmune() and enemy~=tg.attacker  then 
                    if tg.target==enemy then
                        tg.attacker:PerformAttack(enemy, false, false, true, false, true, false, true)
                    else
                        tg.attacker:PerformAttack(enemy, false, false, true, false, true, false, true)
                    end
                end
            end
        end
    end 
end



modifier_change_v=class({})

function modifier_change_v:IsDebuff()			
    return true 
end

function modifier_change_v:IsHidden() 			
	return false 
end

function modifier_change_v:IsPurgable() 		
	return true 
end

function modifier_change_v:IsPurgeException() 	
	return true 
end

function modifier_change_v:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    } 
end


function modifier_change_v:GetModifierPhysicalArmorBonus() 
    return -10
end