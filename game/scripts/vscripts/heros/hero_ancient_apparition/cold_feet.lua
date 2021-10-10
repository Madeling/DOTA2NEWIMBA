


cold_feet=cold_feet or class({})

LinkLuaModifier("modifier_cold_feet_debuff", "heros/hero_ancient_apparition/cold_feet.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cold_feet_debuff2", "heros/hero_ancient_apparition/cold_feet.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cold_feet_buff", "heros/hero_ancient_apparition/cold_feet.lua", LUA_MODIFIER_MOTION_NONE)

function cold_feet:IsHiddenWhenStolen() 
    return false 
end

function cold_feet:IsStealable() 
    return true 
end


function cold_feet:IsRefreshable() 			
    return true 
end



function cold_feet:OnSpellStart()
        local cur_tar=self:GetCursorTarget()
        local caster=self:GetCaster() 
        EmitSoundOn("Hero_Ancient_Apparition.ChillingTouch.Cast", caster)
        if  cur_tar:TG_TriggerSpellAbsorb(self)   then
            return
        end    
        local P = 
        {
            Target = cur_tar,
            Source = caster,
            Ability = self,	
            EffectName = "particles/econ/events/snowball/snowball_projectile.vpcf",
            iMoveSpeed = 1200,
            vSourceLoc = caster:GetAbsOrigin(),
            bDrawsOnMinimap = false,
            bDodgeable = false,
            bIsAttack = false,
            bVisibleToEnemies = true,
            bReplaceExisting = false,
            bProvidesVision = false,
        }
        TG_CreateProjectile({id=1,team=caster:GetTeamNumber(),owner=caster,p=P})

end

function cold_feet:OnProjectileHit(target, location)
    local caster=self:GetCaster() 
    TG_IS_ProjectilesValue1(caster,function()
        target=nil
    end)
    if target==nil then
        return
    end
    EmitSoundOn("Hero_Ancient_Apparition.ChillingTouch.Target", target)

    if target~=caster then
    local P = 
    {
        Target = caster,
        Source = target,
        Ability = self,	
        EffectName = "particles/econ/events/snowball/snowball_projectile.vpcf",
        iMoveSpeed = 1200,
        vSourceLoc = target:GetAbsOrigin(),
        bDrawsOnMinimap = false,
        bDodgeable = false,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = GameRules:GetGameTime() + 10,
        bProvidesVision = false,
    }
    TG_CreateProjectile({id=1,team=caster:GetTeamNumber(),owner=caster,p=P})
    end
    if target:IsAlive() and not target:IsMagicImmune() and target~=caster then
        local damage= {
            victim = target,
            attacker = caster,
            damage = self:GetSpecialValueFor("dam"),
            damage_type = self:GetAbilityDamageType(),
            ability = self,
            }
        ApplyDamage(damage)
         target:AddNewModifier(caster, self, "modifier_cold_feet_debuff", {duration=self:GetSpecialValueFor("spdur")})
    elseif target==caster then
        caster:AddNewModifier(caster, self, "modifier_cold_feet_buff", {duration=self:GetSpecialValueFor("csdur")+caster:TG_GetTalentValue("special_bonus_ancient_apparition_1")})    
    end

end



modifier_cold_feet_debuff=modifier_cold_feet_debuff or class({})

function modifier_cold_feet_debuff:IsDebuff()
    return true 
end

function modifier_cold_feet_debuff:IsPurgable() 			
    return true
end

function modifier_cold_feet_debuff:IsPurgeException() 		
    return true 
end

function modifier_cold_feet_debuff:IsHidden()				
    return false 
end

function modifier_cold_feet_debuff:RemoveOnDeath()				
    return true 
end


function modifier_cold_feet_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost_armor.vpcf" 
   end

function modifier_cold_feet_debuff:StatusEffectPriority() 
   return 20
end

function modifier_cold_feet_debuff:OnCreated()	
   self.stun=self:GetAbility():GetSpecialValueFor("stun")
   self.sp=self:GetAbility():GetSpecialValueFor("sp")
end

function modifier_cold_feet_debuff:OnDestroy()	
    if  IsServer() then
        if not self:GetParent():IsMagicImmune() then
            self:GetParent():AddNewModifier(self:GetCaster() , self:GetAbility(), "modifier_cold_feet_debuff2", {duration=self.stun})
            EmitSoundOn("Hero_Ancient_Apparition.ColdFeetCast", self:GetParent())
        end
    end
    self.stun=nil
    self.sp=nil
end


function modifier_cold_feet_debuff:DeclareFunctions() 
    return
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
   } 
end

function modifier_cold_feet_debuff:GetModifierMoveSpeedBonus_Percentage() 
    return self.sp
end

modifier_cold_feet_debuff2=modifier_cold_feet_debuff2 or class({})


function modifier_cold_feet_debuff2:IsDebuff()
    return true 
end
function modifier_cold_feet_debuff2:IsPurgable() 			
    return false
end
function modifier_cold_feet_debuff2:IsPurgeException() 		
    return false 
end
function modifier_cold_feet_debuff2:IsHidden()				
    return false 
end

function modifier_cold_feet_debuff2:RemoveOnDeath()				
    return true 
end

function modifier_cold_feet_debuff2:GetEffectName()	
     return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_frozen.vpcf"
end

function modifier_cold_feet_debuff2:GetEffectAttachType()	
    return PATTACH_ABSORIGIN
end


function modifier_cold_feet_debuff2:OnDestroy()	
    if not IsServer() then
        return
    end
    local particle2 = ParticleManager:CreateParticle("particles/econ/events/snowman/snowman_death.vpcf", PATTACH_ABSORIGIN, self:GetParent())
    ParticleManager:ReleaseParticleIndex(particle2)   
end


function modifier_cold_feet_debuff2:CheckState()
    return
     {
            [MODIFIER_STATE_FROZEN] = true,
            [MODIFIER_STATE_STUNNED] = true,
            [MODIFIER_STATE_MUTED] = true,
            [MODIFIER_STATE_SILENCED] = true,
    }
end

function modifier_cold_feet_debuff2:DeclareFunctions() 
    return
    {
        MODIFIER_PROPERTY_MODEL_CHANGE, 
        MODIFIER_PROPERTY_MODEL_SCALE,
   } 
end

function modifier_cold_feet_debuff2:GetModifierModelChange()				
    return "models/items/crystal_maiden/snowman/crystal_maiden_snowmaiden.vmdl" 
end

function modifier_cold_feet_debuff2:GetModifierModelScale()				
    return 50
end

modifier_cold_feet_buff=modifier_cold_feet_buff or class({})

function modifier_cold_feet_buff:IsPurgable() 			
    return false
end
function modifier_cold_feet_buff:IsPurgeException() 		
    return false 
end
function modifier_cold_feet_buff:IsHidden()				
    return false 
end

function modifier_cold_feet_buff:RemoveOnDeath()				
    return true 
end

function modifier_cold_feet_buff:OnCreated()				
    self.dam=self:GetAbility():GetSpecialValueFor("cs")
end


function modifier_cold_feet_buff:GetModifierPreAttack_CriticalStrike()			
    return   self.dam
end

function modifier_cold_feet_buff:DeclareFunctions() 
    return
    {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE, 
   } 
end
