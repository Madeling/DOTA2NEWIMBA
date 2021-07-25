CreateTalents("npc_dota_hero_medusa", "heros/hero_medusa/split_shot.lua")
split_shot=class({})
LinkLuaModifier("modifier_split_shot_dam", "heros/hero_medusa/split_shot.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_split_shot", "heros/hero_medusa/split_shot.lua", LUA_MODIFIER_MOTION_NONE)
function split_shot:IsHiddenWhenStolen() 
    return false 
end

function split_shot:IsStealable() 
    return true 
end

function split_shot:IsRefreshable() 			
    return true 
end

function split_shot:GetIntrinsicModifierName() 
    return "modifier_split_shot" 
end

function split_shot:OnToggle() 
    local caster=self:GetCaster()
end


function split_shot:OnProjectileHit( target, location )
    if not target then 
        return 
    end
    local caster=self:GetCaster()
    local dam=0
    if caster.split_shot_dam~=nil and caster.split_shot_dam==false then   
        dam= caster:GetAverageTrueAttackDamage(caster)*self:GetSpecialValueFor( "dam2" )*0.01
    else 
        dam= (caster:GetAverageTrueAttackDamage(caster)*(self:GetSpecialValueFor("damage_modifier")+caster:TG_GetTalentValue("special_bonus_medusa_7"))*0.01)
    end 
                local damageTable = {
                    victim = target,
                    attacker = caster,
                    damage = dam,
                    damage_type =DAMAGE_TYPE_PHYSICAL,
                    damage_flags =DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION ,
                    ability = self,
                    }
                ApplyDamage(damageTable)
end


modifier_split_shot=class({})

function modifier_split_shot:IsPassive()
	return true
end

function modifier_split_shot:IsPurgable() 			
    return false 
end

function modifier_split_shot:IsPurgeException() 	
    return false 
end

function modifier_split_shot:IsHidden()				
    return true 
end

function modifier_split_shot:AllowIllusionDuplicate() 	
    return false 
end

function modifier_split_shot:OnCreated()				
    self.parent=self:GetParent()
    self.caster=self:GetCaster()
        if self:GetAbility() then
        self.ability=self:GetAbility()
        self.arrow_count=self.ability:GetSpecialValueFor("arrow_count")
    end
end

function modifier_split_shot:OnRefresh()				
    self:OnCreated()
end


function modifier_split_shot:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE
	}
end


function modifier_split_shot:OnAttackLanded(tg)
    if not IsServer() then
        return
    end  
    if tg.attacker == self.parent then
        if self.parent:PassivesDisabled() or self.parent:IsIllusion() then
            return
        end
        if not self.ability:GetToggleState() then 
            if  self.ability:IsCooldownReady() and tg.target then 
                self.ability:UseResources(false, false, true) 
                self:GetCaster().split_shot_dam=false
                local sp=0
                for a=1,self.arrow_count+self:GetCaster():TG_GetTalentValue("special_bonus_medusa_6") do 
                        local P = 
                        {
                            Target = tg.target,
                            Source = self.parent,
                            Ability = self.ability,	
                            EffectName = self.parent:GetRangedProjectileName(),
                            iMoveSpeed = self.parent:GetProjectileSpeed()-sp,
                            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
                            bDrawsOnMinimap = false,
                            bDodgeable = true,
                            bIsAttack = false,
                            bVisibleToEnemies = true,
                            bReplaceExisting = false,
                            bProvidesVision = false,	
                        }
                        ProjectileManager:CreateTrackingProjectile( P )
                        sp=sp+100
                 end
            end 
        end
    end
end

function modifier_split_shot:OnAttack(tg)
    if not IsServer() then
        return
	end  
	PrintTable(tg.record)
    if tg.attacker == self.parent then
        if self.parent:PassivesDisabled() or self.parent:IsIllusion() then
            return
        end
        if  self.ability:GetToggleState() then 
            local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.parent:Script_GetAttackRange()+200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
            if #enemies>0 then 
                self:GetCaster().split_shot_dam=true
                local num=0
                for _,enemy in pairs(enemies) do
                    if  enemy  and enemy~=tg.target  then
                        local P = 
                        {
                            Target = enemy,
                            Source = self.parent,
                            Ability = self.ability,	
                            EffectName = self.parent:GetRangedProjectileName(),
                            iMoveSpeed = self.parent:GetProjectileSpeed(),
                            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
                            bDrawsOnMinimap = false,
                            bDodgeable = true,
                            bIsAttack = false,
                            bVisibleToEnemies = true,
                            bReplaceExisting = false,
                            bProvidesVision = false,	
                        }
                        ProjectileManager:CreateTrackingProjectile( P )
                        num = num + 1
                        if num>=self.arrow_count+self:GetCaster():TG_GetTalentValue("special_bonus_medusa_6") then 
                            return 
                        end
                    end
                end
            end
        end 
	end 
end  



