CreateTalents("npc_dota_hero_vengefulspirit","heros/hero_vengefulspirit/magic_missile.lua")

magic_missile=class({})
LinkLuaModifier("modifier_magic_missile_buff", "heros/hero_vengefulspirit/magic_missile.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magic_missile_cd", "heros/hero_vengefulspirit/magic_missile.lua", LUA_MODIFIER_MOTION_NONE)
function magic_missile:IsHiddenWhenStolen() 
    return false 
end

function magic_missile:IsStealable() 
    return true 
end


function magic_missile:IsRefreshable() 			
    return true 
end

function magic_missile:GetIntrinsicModifierName()
	return "modifier_magic_missile_buff"
end

function magic_missile:GetCastRange()
        return  550+self:GetCaster():TG_GetTalentValue("special_bonus_vengefulspirit_2")
end

function magic_missile:CastFilterResultTarget(Target)
    local caster=self:GetCaster()
	if (caster:GetTeamNumber() == Target:GetTeamNumber()) or (Target:IsMagicImmune() and not caster:TG_HasTalent("special_bonus_vengefulspirit_1")) or  Target:IsBuilding() then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function magic_missile:GetCustomCastErrorTarget(Target)
	return "不行的笨蛋"
end


function magic_missile:OnSpellStart()
	local caster=self:GetCaster()
	local caster_pos=caster:GetAbsOrigin()
	local target=self:GetCursorTarget()
	local caster_team=caster:GetTeamNumber()
    local sp=self:GetSpecialValueFor( "magic_missile_speed" )
    local num=math.floor(caster:GetMaxMana()/self:GetSpecialValueFor( "mana" ))
	EmitSoundOn("Hero_VengefulSpirit.MagicMissile",caster)
    for a=1,num+1 do
        local P = {
                Ability = self,
                EffectName = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf",
                iMoveSpeed = sp,
                Source =caster,
                Target = target,
                bDrawsOnMinimap = false,
                bDodgeable = true,
                bIsAttack = false,
                bProvidesVision = false,
                bReplaceExisting = false,
                vSourceLoc = caster:GetAbsOrigin(),
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2, 
            }
        ProjectileManager:CreateTrackingProjectile(P)
        sp=sp-100
    end
end


function magic_missile:OnProjectileHit( target, location)
	local caster=self:GetCaster()
	if target == nil  then
		return 
	end
    if  target:TG_TriggerSpellAbsorb(self) or (target:IsMagicImmune() and not caster:TG_HasTalent("special_bonus_vengefulspirit_1"))then
        return
    end 
    if not caster:HasModifier("modifier_magic_missile_cd") then
        caster:AddNewModifier(caster, self, "modifier_magic_missile_cd", {duration=2})
        EmitSoundOn("Hero_VengefulSpirit.MagicMissileImpact", target)
    end 
    local magic_missile_stun = self:GetSpecialValueFor( "magic_missile_stun" )
    local magic_missile_damage = self:GetSpecialValueFor( "magic_missile_damage" )+caster:TG_GetTalentValue("special_bonus_vengefulspirit_5")
        local damage = {
            victim = target,
            attacker = caster,
            damage = magic_missile_damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self,
        }
        ApplyDamage( damage )
		target:AddNewModifier(caster, self, "modifier_stunned", {duration=magic_missile_stun})
	return true
end

modifier_magic_missile_buff=class({})

function modifier_magic_missile_buff:IsHidden() 			
	return true 
end

function modifier_magic_missile_buff:IsPurgable() 		
	return false 
end

function modifier_magic_missile_buff:IsPurgeException() 	
	return false 
end


function modifier_magic_missile_buff:OnCreated()
    self.caster=self:GetCaster()
    self.ability=self:GetAbility()
    self.team=self.caster:GetTeamNumber()
end

function modifier_magic_missile_buff:DeclareFunctions()
	return     
    {
		MODIFIER_EVENT_ON_DEATH
	}
end


function modifier_magic_missile_buff:OnDeath(tg)
	if IsServer() then
        if tg.attacker==self.caster and tg.unit:IsHero() and  self.caster:HasScepter() then
            self.ability:EndCooldown()
        end 
		if  tg.unit==self.caster then
            self.pos=self.caster:GetAbsOrigin()
            self.num=math.floor(self.caster:GetMaxMana()/self.ability:GetSpecialValueFor( "mana" ))
            local heros = FindUnitsInRadius(
                self.team,
                self.pos,
                nil,
                self.ability:GetSpecialValueFor("rd"),
                DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO,
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
                FIND_ANY_ORDER,
                false)
            if #heros>0 then 
                for _,target in pairs(heros) do
                    for a=1,self.num+1 do
                        local P = {
                            Ability = self.ability,
                            EffectName = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf",
                            iMoveSpeed = 2000,
                            Source =self.caster,
                            Target = target,
                            bDrawsOnMinimap = false,
                            bDodgeable = true,
                            bIsAttack = false,
                            bProvidesVision = false,
                            bReplaceExisting = false,
                            vSourceLoc = self.pos,
                        }
                        ProjectileManager:CreateTrackingProjectile(P)
                    end
                end
            end
        end
	end
end

modifier_magic_missile_cd=class({})

function modifier_magic_missile_cd:IsHidden() 			
	return true 
end

function modifier_magic_missile_cd:IsPurgable() 		
	return false 
end

function modifier_magic_missile_cd:IsPurgeException() 	
	return false 
end