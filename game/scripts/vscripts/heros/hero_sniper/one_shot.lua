one_shot=class({})
LinkLuaModifier("modifier_one_shot_rifle", "heros/hero_sniper/one_shot.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_one_shot", "heros/hero_sniper/one_shot.lua", LUA_MODIFIER_MOTION_NONE)
function one_shot:IsHiddenWhenStolen() 
    return false 
end

function one_shot:IsStealable() 
    return true 
end

function one_shot:IsRefreshable() 			
    return true 
end

function one_shot:GetIntrinsicModifierName() 
    return "modifier_one_shot_rifle" 
end

function one_shot:GetCooldown(iLevel)
    return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_sniper_15l")
end

function one_shot:GetBehavior()
	if not self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else
		return DOTA_ABILITY_BEHAVIOR_AUTOCAST+DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
end

function one_shot:OnSpellStart(shot)
    local caster = self:GetCaster()
    local num = self:GetSpecialValueFor("num")+caster:TG_GetTalentValue("special_bonus_sniper_20r")
    EmitSoundOn("Ability.AssassinateLoad", caster)

    if caster:HasModifier("modifier_one_shot_rifle") then
        local modifier=caster:FindModifierByName("modifier_one_shot_rifle")
        modifier:SetStackCount(num)
        Notifications:Bottom(PlayerResource:GetPlayer(caster:GetPlayerOwnerID()), {text="Reloading...", duration=1.2, style={color="white", ["font-size"]="30px"}})
    end
	if caster:HasScepter() then
        caster:AddNewModifier(caster, self, "modifier_one_shot", {duration=3})
	end
   
end

function one_shot:OnProjectileHit_ExtraData(target, location,kv)
    local caster=self:GetCaster()
	if not target or target:IsBuilding() then
		return
    end
    local flag=DOTA_DAMAGE_FLAG_NONE
    if RollPseudoRandomPercentage(self:GetSpecialValueFor("ch"),0,caster) then  
        flag=DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR
        --target:AddNewModifier(caster, self, "modifier_imba_stunned", {duration=0.1})
    end 
            local damage= {
                victim = target,
                attacker = caster,
                damage =  caster:GetLevel()*(self:GetSpecialValueFor( "dam" )+caster:TG_GetTalentValue("special_bonus_sniper_15r")),
                damage_type = DAMAGE_TYPE_PHYSICAL,
                damage_flag=flag,
                ability = self,
                }
            ApplyDamage(damage)
    return true
end

modifier_one_shot_rifle=class({})

function modifier_one_shot_rifle:IsHidden() 			
	return false 
end

function modifier_one_shot_rifle:IsPurgable() 		
	return false 
end

function modifier_one_shot_rifle:IsPurgeException() 	
	return false 
end



function modifier_one_shot_rifle:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    } 
end

function modifier_one_shot_rifle:OnCreated()				
    self.attrg= self:GetAbility():GetSpecialValueFor("attrg")
    self.v=self:GetAbility():GetSpecialValueFor("v")
    self.num=self:GetAbility():GetSpecialValueFor("num")+self:GetCaster():TG_GetTalentValue("special_bonus_sniper_20r")
    if IsServer() then 
        self:SetStackCount(self.num)
    end 
end

function modifier_one_shot_rifle:OnRefresh()				
    self.attrg= self:GetAbility():GetSpecialValueFor("attrg")
    self.v=self:GetAbility():GetSpecialValueFor("v")
end

function modifier_one_shot_rifle:GetModifierAttackRangeBonus() 
    if self:GetParent():PassivesDisabled() then
        return 0
    else 
        return  self.attrg
    end
end

function modifier_one_shot_rifle:GetBonusVisionPercentage() 
    if self:GetParent():PassivesDisabled() then
        return 0
    else 
        return  self.v
    end
end

function modifier_one_shot_rifle:OnAttackLanded(tg)
    if not IsServer() then
		return 
    end
    if tg.attacker==self:GetParent() then 
        if self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion()  or tg.target:IsBuilding() then
            return
        end
        if self:GetParent():HasScepter() and self:GetAbility():GetAutoCastState() and self:GetStackCount()<=0 and self:GetAbility():IsCooldownReady() then 
            self:GetAbility():OnSpellStart()
            self:GetAbility():UseResources(false, false, true)
        end 
        if self:GetStackCount()>0 then
            self:SetStackCount(self:GetStackCount()-1)
            EmitSoundOn( "TG.shot", self:GetParent() )
            local P = 
            {
                Target = tg.target,
                Source = self:GetParent(),
                Ability = self:GetAbility(),	
                EffectName = "particles/heros/sniper/grenade1.vpcf",
                iMoveSpeed = 3000,
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
                bDrawsOnMinimap = false,
                bDodgeable = false,
                bIsAttack = false,
                bVisibleToEnemies = true,
                bReplaceExisting = false,
                bProvidesVision = false,	
            }
            TG_CreateProjectile({id=1,team=self:GetParent():GetTeamNumber(),owner=self:GetParent(),target=tg.target,p=P}) 
        end
    end 
end



modifier_one_shot=class({})

function modifier_one_shot:IsHidden() 			
	return false 
end

function modifier_one_shot:IsPurgable() 		
	return false 
end

function modifier_one_shot:IsPurgeException() 	
	return false 
end

function modifier_one_shot:DeclareFunctions() 
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    } 
end

function modifier_one_shot:GetModifierAttackSpeedBonus_Constant()				
    return self:GetParent():GetLevel()*6
end